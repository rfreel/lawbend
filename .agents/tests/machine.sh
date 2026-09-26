#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT/agent-machine" 2>/dev/null || { echo 'FAIL: reusable Bend task machine is missing' >&2; exit 1; }
: "${BEND:?official Bend executable required}"
"$BEND" PROOF.bend
"$BEND" DOCS_MODEL.bend
"$BEND" TESTS.bend | tee "$RUNNER_TEMP/task-machine.log"
grep -Fx 'accepted:0:1' "$RUNNER_TEMP/task-machine.log"
grep -Fx 'accepted:2:3' "$RUNNER_TEMP/task-machine.log"
grep -Fx 'exhausted:3:4' "$RUNNER_TEMP/task-machine.log"
grep -Fx 'exhausted:0:1' "$RUNNER_TEMP/task-machine.log"
test "$(grep -c '^blocked:' "$RUNNER_TEMP/task-machine.log")" -eq 3
test "$(grep -c '^verify$' "$RUNNER_TEMP/task-machine.log")" -eq 12
test "$(grep -c '^repair$' "$RUNNER_TEMP/task-machine.log")" -eq 6
"$BEND" RENDER_TESTS.bend | tee "$RUNNER_TEMP/render-machine.log"
grep -Fx 'render-code:npm test' "$RUNNER_TEMP/render-machine.log"
grep -Fx 'render-text:example prose' "$RUNNER_TEMP/render-machine.log"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
cp -- ./*.bend "$TMP/"
sed 's/case Code{code}: CodeBlock{code}/case Code{code}: Paragraph{code}/' RENDER.bend > "$TMP/RENDER.bend"
if (cd "$TMP" && "$BEND" PROOF.bend) > "$TMP/rejected.log" 2>&1; then
  echo 'FAIL: checker accepted code rendered as a paragraph' >&2
  exit 1
fi
cat "$TMP/rejected.log"
grep -F 'code_is_always_a_block' "$TMP/rejected.log" >/dev/null
echo 'BEND TASK MACHINE CHECKS PASS'
