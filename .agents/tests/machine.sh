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
# Assertions about final evidence/defects execute in Bend, not in shell.
"$BEND" EVIDENCE_TESTS.bend | tee "$RUNNER_TEMP/evidence-machine.log"
"$BEND" RENDER_TESTS.bend | tee "$RUNNER_TEMP/render-machine.log"
grep -Fx 'render-code:npm test' "$RUNNER_TEMP/render-machine.log"
grep -Fx 'render-text:example prose' "$RUNNER_TEMP/render-machine.log"
# Mutate implementations in isolation; never change requirements to get a pass.
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/render" "$TMP/evidence"
cp -- ./*.bend "$TMP/render/"
sed 's/case Code{code}: CodeBlock{code}/case Code{code}: Paragraph{code}/' RENDER.bend > "$TMP/render/RENDER.bend"
if (cd "$TMP/render" && "$BEND" PROOF.bend) > "$TMP/render/rejected.log" 2>&1; then
  echo 'FAIL: checker accepted code rendered as a paragraph' >&2
  exit 1
fi
cat "$TMP/render/rejected.log"
grep -F 'code_is_always_a_block' "$TMP/render/rejected.log" >/dev/null
# Discard final defects in an isolated implementation; require named rejection.
cp -- ./*.bend "$TMP/evidence/"
sed 's/Exhausted{candidate, evidence, defects, audit}/Exhausted{candidate, evidence, Nil{}, audit}/' MACHINE.bend > "$TMP/evidence/MACHINE.bend"
if cmp -s MACHINE.bend "$TMP/evidence/MACHINE.bend"; then
  echo 'FAIL: defect-dropping mutation did not change the source' >&2
  exit 1
fi
if (cd "$TMP/evidence" && "$BEND" EVIDENCE_TESTS.bend) > "$TMP/evidence/rejected.log" 2>&1; then
  echo 'FAIL: runtime accepted discarded final defects' >&2
  exit 1
fi
cat "$TMP/evidence/rejected.log"
grep -F 'FAIL: zero-fuel-exhausted' "$TMP/evidence/rejected.log" >/dev/null
"$BEND" EVIDENCE_TESTS.bend
echo 'BEND TASK MACHINE CHECKS PASS'
