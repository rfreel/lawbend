#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
INIT="$ROOT/.agents/bin/bend-proof-init.sh"
test -x "$INIT" || { echo 'FAIL: Bend project initializer is missing' >&2; exit 1; }
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
"$INIT" "$TMP/new proof"
cd "$TMP/new proof"
for f in INTENT.md MODEL.bend main.bend LAWS.bend PROOF.bend TRUST.md AGENTS.md .agents/MANIFEST.json .agents/CLAIMS.json .agents/bin/gate-receipt.sh .github/workflows/proof.yml; do test -s "$f" || { echo "FAIL: missing $f" >&2; exit 1; }; done
before="$(sha256sum LAWS.bend | cut -d' ' -f1)"
if "$INIT" "$TMP/new proof"; then echo 'FAIL: existing destination overwritten' >&2; exit 1; fi
test "$before" = "$(sha256sum LAWS.bend | cut -d' ' -f1)"
echo 'PASS: standalone files, spaces and no overwrite'
"${BEND:?BEND must identify the official checker}" version
if "$BEND" PROOF.bend --check-only > "$TMP/open.log" 2>&1; then echo 'FAIL: open proof accepted' >&2; exit 1; fi
cat "$TMP/open.log"
grep -E 'TODO|unfilled|open law' "$TMP/open.log" >/dev/null
cp examples/PROOF.complete.bend PROOF.bend
"$BEND" PROOF.bend --check-only | tee "$TMP/checked.log"
grep -F 'All terms check.' "$TMP/checked.log" >/dev/null
test "$before" = "$(sha256sum LAWS.bend | cut -d' ' -f1)"
echo 'PASS: completed example checked with unchanged law'
printf 'import Base\nimport ./LAWS.bend as Laws\ndef Laws.add_zero(x):\n  {==}\n' > PROOF.bend
if "$BEND" PROOF.bend --check-only > "$TMP/invalid.log" 2>&1; then echo 'FAIL: invalid proof accepted' >&2; exit 1; fi
cat "$TMP/invalid.log"
echo 'PASS: official checker rejected invalid proof'
echo 'INITIALIZER REGRESSIONS PASS'
