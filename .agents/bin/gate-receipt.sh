#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
CLAIMS="$ROOT/.agents/CLAIMS.json"

die() {
  printf '%s\n' "$*" >&2
  exit 64
}

claim_json() {
  local id="$1"
  jq -e --arg id "$id" '.claims[$id]' "$CLAIMS" 2>/dev/null ||
    die "unknown claim: $id"
}

claim_files() {
  local id="$1"
  local dep
  claim_json "$id" >/dev/null
  while IFS= read -r dep; do
    if [[ -f "$ROOT/$dep" ]]; then
      printf '%s\n' "$dep"
    elif [[ -d "$ROOT/$dep" ]]; then
      git -C "$ROOT" ls-files -- "$dep" "$dep/**"
    else
      die "missing dependency for $id: $dep"
    fi
  done < <(jq -r --arg id "$id" '.claims[$id].dependencies[]' "$CLAIMS") |
    LC_ALL=C sort -u
}

dependency_records() {
  local id="$1"
  local path blob
  while IFS= read -r path; do
    blob="$(git -C "$ROOT" hash-object "$ROOT/$path")"
    jq -nc --arg path "$path" --arg blob "$blob" '{path:$path,blob:$blob}'
  done < <(claim_files "$id")
}

dependency_hash() {
  local id="$1"
  local path blob
  {
    while IFS= read -r path; do
      blob="$(git -C "$ROOT" hash-object "$ROOT/$path")"
      printf '%s  %s\n' "$blob" "$path"
    done < <(claim_files "$id")
  } | LC_ALL=C sort | sha256sum | awk '{print $1}'
}

emit_receipt() {
  [[ "$#" -eq 7 ]] || die "emit: CLAIM RESULT COMMAND TOOL_VERSION EVIDENCE_URI OUT"
  local id="$1" result="$2" command="$3" tool="$4" evidence="$5" out="$6"
  local dep_hash dep_json gates scope source_tree generated_at

  # The seventh position is reserved for schema evolution and must currently be '-'.
  [[ "$7" == "-" ]] || die "emit: final argument must be '-'"

  dep_hash="$(dependency_hash "$id")"
  dep_json="$(dependency_records "$id" | jq -s '.')"
  gates="$(jq -c --arg id "$id" '.claims[$id].gates' "$CLAIMS")"
  scope="$(jq -r --arg id "$id" '.claims[$id].scope' "$CLAIMS")"
  source_tree="$(git -C "$ROOT" rev-parse 'HEAD^{tree}')"
  generated_at="$(date -u +'%Y-%m-%dT%H:%M:%SZ')"

  mkdir -p "$(dirname "$out")"
  jq -n     --argjson schema_version 1     --arg claim_id "$id"     --argjson gates "$gates"     --arg source_tree "$source_tree"     --arg dependency_set_hash "$dep_hash"     --argjson dependencies "$dep_json"     --arg tool_version "$tool"     --arg command "$command"     --arg result "$result"     --arg evidence_uri "$evidence"     --arg scope "$scope"     --arg generated_at "$generated_at"     '{
      schema_version:$schema_version,
      claim_id:$claim_id,
      gates:$gates,
      source_tree:$source_tree,
      dependency_set_hash:$dependency_set_hash,
      dependencies:$dependencies,
      tool_version:$tool_version,
      command:$command,
      result:$result,
      evidence_uri:$evidence_uri,
      scope:$scope,
      generated_at:$generated_at
    }' > "$out"
}

receipt_status() {
  [[ "$#" -eq 2 ]] || die "status: CLAIM RECEIPT"
  local id="$1" receipt="$2"
  local stored current status
  [[ -f "$receipt" ]] || die "receipt not found: $receipt"
  jq -e --arg id "$id" '.schema_version == 1 and .claim_id == $id' "$receipt" >/dev/null ||
    die "receipt does not match claim: $id"
  stored="$(jq -r '.dependency_set_hash' "$receipt")"
  current="$(dependency_hash "$id")"
  if [[ "$stored" == "$current" ]]; then
    status="fresh"
  else
    status="stale"
  fi
  jq -nc     --arg claim_id "$id"     --arg status "$status"     --arg receipt_hash "$stored"     --arg current_hash "$current"     '{claim_id:$claim_id,status:$status,receipt_hash:$receipt_hash,current_hash:$current_hash}'
  [[ "$status" == "fresh" ]]
}

case "${1:-}" in
  explain)
    [[ "$#" -eq 2 ]] || die "explain: CLAIM"
    claim_json "$2"
    ;;
  files)
    [[ "$#" -eq 2 ]] || die "files: CLAIM"
    claim_files "$2"
    ;;
  hash)
    [[ "$#" -eq 2 ]] || die "hash: CLAIM"
    dependency_hash "$2"
    ;;
  emit)
    shift
    emit_receipt "$@"
    ;;
  status)
    shift
    receipt_status "$@"
    ;;
  *)
    die "usage: $0 {explain|files|hash|emit|status} ..."
    ;;
esac
