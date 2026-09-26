#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
INIT="$ROOT/.agents/bin/bend-proof-init.sh"
test -x "$INIT" || { echo 'FAIL: Bend project initializer is missing' >&2; exit 1; }
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
"$INIT" "$TMP/new proof"
cd "$TMP/new proof"
for f in INTENT.md MODEL.bend main.bend LAWS.bend PROOF.bend TRUST.md AGENTS.md .agents/MANIFEST.json .agents/CLAIMS.json .agents/bin/gate-receipt.sh .github/workflows/proof.yml task-machine/MACHINE.bend; do test -s "$f" || { echo "FAIL: missing $f" >&2; exit 1; }; done
before="$(sha256sum LAWS.bend | cut -d' ' -f1)"
if "$INIT" "$TMP/new proof"; then echo 'FAIL: existing destination overwritten' >&2; exit 1; fi
test "$before" = "$(sha256sum LAWS.bend | cut -d' ' -f1)"
echo 'PASS: standalone files, spaces and no overwrite'
"${BEND:?BEND must identify the official checker}" version
if "$BEND" PROOF.bend > "$TMP/open.log" 2>&1; then echo 'FAIL: open proof accepted' >&2; exit 1; fi
cat "$TMP/open.log"
grep -E 'TODO|unfilled|open law' "$TMP/open.log" >/dev/null
cp examples/PROOF.complete.bend PROOF.bend
"$BEND" PROOF.bend | tee "$TMP/checked.log"
grep -F 'All terms check.' "$TMP/checked.log" >/dev/null
test "$before" = "$(sha256sum LAWS.bend | cut -d' ' -f1)"
echo 'PASS: completed example checked with unchanged law'
"$BEND" main.bend
"$BEND" task-machine/PROOF.bend

git init -q
git config user.email fixture@example.invalid
git config user.name fixture
git add .
git commit -qm generated-fixture
GATE_CONTEXT_ID=fixture-context .agents/bin/check-proof.sh
.agents/bin/gate-receipt.sh status project.proof build/gate-receipts/project.proof.json 'bend 2.0.27' fixture-context | jq -e '.usable == true' >/dev/null
if .agents/bin/gate-receipt.sh hash project.external; then echo 'FAIL: missing independent evidence accepted' >&2; exit 1; fi
if BEND=/missing/bend .agents/bin/check-proof.sh; then echo 'FAIL: missing compiler accepted' >&2; exit 1; fi
cp LAWS.bend "$TMP/law"
printf '\n# changed law\n' >> LAWS.bend
if .agents/bin/check-proof.sh; then echo 'FAIL: law drift accepted' >&2; exit 1; fi
mv "$TMP/law" LAWS.bend
echo 'PASS: executed receipt, missing evidence, missing compiler and law drift'

printf 'import Base\nimport ./LAWS.bend as Laws\ndef Laws.add_zero(x):\n  {==}\n' > PROOF.bend
if "$BEND" PROOF.bend > "$TMP/invalid.log" 2>&1; then echo 'FAIL: invalid proof accepted' >&2; exit 1; fi
cat "$TMP/invalid.log"
grep -E 'Error|error|mismatch|Mismatch' "$TMP/invalid.log" >/dev/null
echo 'PASS: official checker rejected invalid proof'
echo 'INITIALIZER REGRESSIONS PASS'
