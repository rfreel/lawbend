#!/usr/bin/env bash
# Git/filesystem bookkeeping only. Bend remains the formal checker.
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
CLAIMS="$ROOT/.agents/CLAIMS.json"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

die() { printf '%s\n' "$*" >&2; exit 64; }
need_path() {
  local p="$1" part
  [[ -n "$p" && "$p" != /* && "$p" != *[[:cntrl:]]* ]] || die "invalid dependency path: $p"
  case "/$p/" in */../*|*/./*|*//*|*/.git/*) die "unsafe dependency path: $p";; esac
  part="$p"
  while [[ "$part" != . ]]; do
    [[ ! -L "$ROOT/$part" ]] || die "symlink dependency: $part"
    part="$(dirname -- "$part")"
  done
}
claim_json() {
  jq -ce --arg id "$1" '
    select(.schema_version == 1) | .claims[$id] |
    select(type == "object") |
    select((.dependencies | type) == "array" and (.dependencies | length) > 0) |
    select(all(.dependencies[]; type == "string" and length > 0)) |
    select((.gates | type) == "array" and (.gates | length) > 0) |
    select((.scope | type) == "string" and (.scope | length) > 0)
  ' "$CLAIMS" || die "unknown or invalid claim: $1"
}
snapshot() {
  local id="$1" dep p blob mode full count=0
  claim_json "$id" > "$WORK/contract.json" || die "cannot read claim: $id"
  jq -j '.dependencies[] | . + "\u0000"' "$WORK/contract.json" > "$WORK/roots" || die 'cannot read dependencies'
  : > "$WORK/paths"
  while IFS= read -r -d '' dep; do
    need_path "$dep"
    if [[ -f "$ROOT/$dep" ]]; then
      printf '%s\0' "$dep" >> "$WORK/paths"
    elif [[ -d "$ROOT/$dep" ]]; then
      git -C "$ROOT" ls-files -z --cached -- "$dep" >> "$WORK/paths" || die "cannot inventory $dep"
      find "$ROOT/$dep" -mindepth 1 \( -type f -o -type l \) -print0 > "$WORK/found" || die "cannot traverse $dep"
      while IFS= read -r -d '' full; do
        printf '%s\0' "${full#"$ROOT"/}" >> "$WORK/paths"
      done < "$WORK/found"
    else
      die "missing dependency for $id: $dep"
    fi
  done < "$WORK/roots"
  LC_ALL=C sort -zu "$WORK/paths" > "$WORK/unique" || die 'cannot sort inventory'
  : > "$WORK/records"
  while IFS= read -r -d '' p; do
    need_path "$p"
    [[ -f "$ROOT/$p" ]] || die "missing or non-file dependency: $p"
    blob="$(git -C "$ROOT" hash-object --no-filters -- "$ROOT/$p")" || die "cannot hash $p"
    mode=100644
    [[ ! -x "$ROOT/$p" ]] || mode=100755
    jq -nc --arg path "$p" --arg blob "$blob" --arg mode "$mode" '{path:$path,blob:$blob,mode:$mode}' >> "$WORK/records" || die 'cannot encode inventory'
    count=$((count + 1))
  done < "$WORK/unique"
  [[ "$count" -gt 0 ]] || die "empty dependency inventory: $id"
  blob="$(git hash-object --no-filters -- "$0")" || die 'cannot hash receipt tool'
  jq -s --slurpfile contract "$WORK/contract.json" --arg recorder_blob "$blob" \
    '{contract:$contract[0],dependencies:.,recorder_blob:$recorder_blob}' "$WORK/records" > "$WORK/current.json" || die 'cannot build snapshot'
}
basis_hash() { jq -cS . "$1" | sha256sum | cut -d' ' -f1; }
write_receipt() {
  local id="$1" result="$2" command="$3" tool="$4" uri="$5" out="$6" recording="$7" tmp
  case "$result" in running|success|failure|blocked|cancelled|timeout|unstable) ;; *) die "invalid result: $result";; esac
  [[ -n "$tool" && -n "$command" && -n "$uri" ]] || die 'tool, command and evidence location must be explicit'
  mkdir -p -- "$(dirname -- "$out")"
  tmp="$(mktemp "${out}.tmp.XXXXXX")"
  jq -n --slurpfile basis "$WORK/current.json" \
    --arg claim_id "$id" --arg result "$result" --arg command "$command" \
    --arg tool_version "$tool" --arg evidence_uri "$uri" --arg recording "$recording" \
    --arg context_id "${GATE_CONTEXT_ID:-}" \
    --arg source_commit "$(git -C "$ROOT" rev-parse HEAD)" \
    --arg source_tree "$(git -C "$ROOT" rev-parse 'HEAD^{tree}')" \
    --arg dependency_set_hash "$(basis_hash "$WORK/current.json")" \
    --arg generated_at "$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
    '{schema_version:2,claim_id:$claim_id,result:$result,command:$command,
      tool_version:$tool_version,evidence_uri:$evidence_uri,recording:$recording,
      context_id:$context_id,source_commit:$source_commit,source_tree:$source_tree,
      source_kind:"working-tree snapshot; source_tree identifies HEAD, not uncommitted bytes",
      dependency_set_hash:$dependency_set_hash,basis:$basis[0],
      dependencies:$basis[0].dependencies,gates:$basis[0].contract.gates,
      scope:$basis[0].contract.scope,generated_at:$generated_at}' > "$tmp" || { rm -f -- "$tmp"; die 'receipt serialization failed'; }
  mv -- "$tmp" "$out"
}
emit_receipt() {
  [[ "$#" -eq 6 || ( "$#" -eq 7 && "$7" == - ) ]] || die 'emit: CLAIM RESULT COMMAND TOOL_VERSION EVIDENCE_URI OUT [ - ]'
  snapshot "$1"
  write_receipt "$1" "$2" "$3" "$4" "$5" "$6" recorded
}
receipt_status() {
  [[ "$#" -eq 2 || "$#" -eq 4 ]] || die 'status: CLAIM RECEIPT [EXPECTED_TOOL_VERSION EXPECTED_CONTEXT_ID]'
  local id="$1" receipt="$2" stored current status=fresh result recording tool_ok=false context_ok=false usable=false code=0
  [[ -f "$receipt" ]] || die "receipt not found: $receipt"
  jq -e --arg id "$id" '.schema_version == 2 and .claim_id == $id and
    (.basis.dependencies | length) > 0 and .dependencies == .basis.dependencies and
    .gates == .basis.contract.gates and .scope == .basis.contract.scope and
    (.dependency_set_hash | type) == "string" and
    (.result | IN("running","success","failure","blocked","cancelled","timeout","unstable")) and
    (.recording | IN("recorded","executed"))' "$receipt" >/dev/null || die 'invalid or legacy receipt; rerun the gate'
  jq '.basis' "$receipt" > "$WORK/stored.json" || die 'cannot read stored inventory'
  stored="$(jq -r '.dependency_set_hash' "$receipt")"
  [[ "$stored" == "$(basis_hash "$WORK/stored.json")" ]] || die 'receipt inventory/hash mismatch'
  snapshot "$id"
  current="$(basis_hash "$WORK/current.json")"
  [[ "$stored" == "$current" ]] || { status=stale; code=1; }
  result="$(jq -r '.result' "$receipt")"
  recording="$(jq -r '.recording' "$receipt")"
  [[ "$result" == success ]] || code=1
  if [[ "$#" -eq 4 ]]; then
    [[ -n "$3" && -n "$4" ]] || die 'expected execution context must not be empty'
    [[ "$3" != "$(jq -r '.tool_version' "$receipt")" ]] || tool_ok=true
    [[ "$4" != "$(jq -r '.context_id' "$receipt")" ]] || context_ok=true
    if [[ "$status" == fresh && "$result" == success && "$recording" == executed && "$tool_ok" == true && "$context_ok" == true ]]; then
      usable=true
    else
      code=1
    fi
  fi
  jq -nc --arg claim_id "$id" --arg status "$status" --arg result "$result" \
    --arg recording "$recording" --arg receipt_hash "$stored" --arg current_hash "$current" \
    --argjson tool_matches "$tool_ok" --argjson context_matches "$context_ok" --argjson usable "$usable" \
    '{claim_id:$claim_id,status:$status,result:$result,recording:$recording,
      receipt_hash:$receipt_hash,current_hash:$current_hash,tool_matches:$tool_matches,
      context_matches:$context_matches,usable:$usable,
      note:"Freshness is not authenticity, truth, human acceptance or environment equivalence."}'
  return "$code"
}
run_gate() {
  [[ "$#" -ge 6 && "$5" == -- ]] || die 'run: CLAIM OUT TOOL_VERSION EVIDENCE_URI -- COMMAND [ARG ...]'
  local id="$1" out="$2" tool="$3" uri="$4" command result=success code=0 before after
  shift 5
  snapshot "$id"
  before="$(basis_hash "$WORK/current.json")"
  mkdir -p -- "$(dirname -- "$out")"
  printf -v command '%q ' "$@"
  # Invalidate an earlier success before execution; interruption cannot expose it as current.
  write_receipt "$id" running "$command" "$tool" "$uri" "$out" executed
  "$@" > "${out}.log" 2>&1 || code=$?
  cat -- "${out}.log"
  snapshot "$id"
  after="$(basis_hash "$WORK/current.json")"
  if [[ "$before" != "$after" ]]; then result=unstable; code=65
  elif [[ "$code" == 124 ]]; then result=timeout
  elif [[ "$code" -ne 0 ]]; then result=failure
  fi
  write_receipt "$id" "$result" "$command" "$tool" "$uri" "$out" executed
  return "$code"
}
case "${1:-}" in
  explain) [[ "$#" -eq 2 ]] || die 'explain: CLAIM'; claim_json "$2";;
  files) [[ "$#" -eq 2 ]] || die 'files: CLAIM'; snapshot "$2"; jq -r '.dependencies[].path' "$WORK/current.json";;
  hash) [[ "$#" -eq 2 ]] || die 'hash: CLAIM'; snapshot "$2"; basis_hash "$WORK/current.json";;
  emit) shift; emit_receipt "$@";;
  status) shift; receipt_status "$@";;
  run) shift; run_gate "$@";;
  *) die 'usage: gate-receipt.sh {explain|files|hash|emit|status|run} ...';;
esac
