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
printf 'baseline\n' > src/input
printf '%s\n' '{"schema_version":1,"claims":{"fixture":{"gates":["O"],"scope":"Local receipt fixture only","dependencies":["src"]}}}' > .agents/CLAIMS.json
git add .
git commit -qm fixture
R=.agents/bin/gate-receipt.sh
OUT="$TMP/receipt.json"
export GATE_CONTEXT_ID=fixture-context-A
"$R" run fixture "$OUT" fixture-tool-A fixture://local -- printf 'observed\n'
"$R" status fixture "$OUT" fixture-tool-A fixture-context-A | jq -e '.usable == true' >/dev/null
"$R" status fixture "$OUT" | jq -e '.status == "fresh" and .usable == false' >/dev/null
if "$R" status fixture "$OUT" fixture-tool-A other-context; then echo 'FAIL: changed context reused' >&2; exit 1; fi
if "$R" status fixture "$OUT" other-tool fixture-context-A; then echo 'FAIL: changed tool reused' >&2; exit 1; fi
echo 'PASS: reuse requires explicit matching tool and context'

set +e
"$R" run fixture "$OUT" fixture-tool-A fixture://local -- bash -c 'exit 7'
code=$?
set -e
test "$code" -eq 7
jq -e '.result == "failure" and .recording == "executed"' "$OUT" >/dev/null
if "$R" status fixture "$OUT" fixture-tool-A fixture-context-A; then echo 'FAIL: failed command reused' >&2; exit 1; fi
echo 'PASS: actual command failure is retained'

set +e
"$R" run fixture "$OUT" fixture-tool-A fixture://local -- bash -c 'printf changed >> src/input'
code=$?
set -e
test "$code" -eq 65
jq -e '.result == "unstable"' "$OUT" >/dev/null
if "$R" status fixture "$OUT" fixture-tool-A fixture-context-A; then echo 'FAIL: unstable execution reused' >&2; exit 1; fi
echo 'PASS: dependency change during execution is unstable'

"$R" emit fixture success asserted-command asserted-tool fixture://asserted "$OUT"
if "$R" status fixture "$OUT" asserted-tool fixture-context-A; then echo 'FAIL: assertion promoted to executed evidence' >&2; exit 1; fi
echo 'PASS: manual emission is not executed evidence'
echo 'RECEIPT CONTEXT CHECKS PASS'
