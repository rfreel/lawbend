#!/usr/bin/env bash
set -euo pipefail
SOURCE="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/repo/.agents/bin" "$TMP/repo/src"
cp "$SOURCE/bin/gate-receipt.sh" "$TMP/repo/.agents/bin/"
cd "$TMP/repo"
git init -q
git config user.email fixture@example.invalid
git config user.name fixture
printf 'baseline\n' > src/input.bend
printf 'unrelated\n' > note.md
cat > .agents/CLAIMS.json <<'JSON'
{"schema_version":1,"claims":{"fixture":{"gates":["F","V"],"description":"Regression fixture only","scope":"Fixture files only","dependencies":["src"]}}}
JSON
git add .
git commit -qm baseline
R=.agents/bin/gate-receipt.sh
emit() { "$R" emit fixture "$1" 'bend PROOF.bend' 'bend 2.0.27' 'https://example.invalid/fixture' "$TMP/receipt.json" -; }
check_fresh() { "$R" status fixture "$TMP/receipt.json" > "$TMP/status.json"; jq -e '.status == "fresh"' "$TMP/status.json" >/dev/null; }
emit success
check_fresh
printf 'changed\n' >> src/input.bend
if "$R" status fixture "$TMP/receipt.json" > "$TMP/status.json"; then echo 'FAIL: changed dependency accepted' >&2; exit 1; fi
jq -e '.status == "stale"' "$TMP/status.json" >/dev/null
git restore src/input.bend
check_fresh
printf 'irrelevant change\n' >> note.md
check_fresh
echo 'PASS: change, restore, unrelated file'

mv src/input.bend "$TMP/input.bend"
if emit success > "$TMP/missing.log" 2>&1; then cat "$TMP/missing.log"; echo 'FAIL: missing tracked dependency emitted a receipt' >&2; exit 1; fi
mv "$TMP/input.bend" src/input.bend
echo 'PASS: missing dependency fails closed'

emit failure
if "$R" status fixture "$TMP/receipt.json" > "$TMP/status.json"; then echo 'FAIL: failed run is reusable' >&2; exit 1; fi
jq -e '.usable == false' "$TMP/status.json" >/dev/null
echo 'PASS: failed receipt cannot be reused'

emit success
printf 'new source\n' > src/untracked.bend
if "$R" status fixture "$TMP/receipt.json" > "$TMP/status.json"; then echo 'FAIL: untracked source ignored' >&2; exit 1; fi
rm src/untracked.bend
check_fresh
echo 'PASS: source addition invalidates'

ln -s "$TMP/receipt.json" src/escape.bend
if emit success > "$TMP/symlink.log" 2>&1; then echo 'FAIL: symlink accepted' >&2; exit 1; fi
rm src/escape.bend
echo 'PASS: symlink dependency rejected'

emit success
jq '.dependencies = []' "$TMP/receipt.json" > "$TMP/bad.json"
if "$R" status fixture "$TMP/bad.json" > "$TMP/status.json"; then echo 'FAIL: corrupt inventory accepted' >&2; exit 1; fi
echo 'PASS: corrupt receipt rejected'

if "$R" hash unknown > "$TMP/unknown.log" 2>&1; then echo 'FAIL: unknown claim accepted' >&2; exit 1; fi
echo 'PASS: unknown claim rejected'
echo 'RECEIPT REGRESSIONS PASS'
