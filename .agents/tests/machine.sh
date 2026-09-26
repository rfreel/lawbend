#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT/agent-machine" 2>/dev/null || { echo 'FAIL: reusable Bend task machine is missing' >&2; exit 1; }
: "${BEND:?official Bend executable required}"
"$BEND" PROOF.bend
"$BEND" TESTS.bend | tee "$RUNNER_TEMP/task-machine.log"
grep -Fx 'accepted:0:1' "$RUNNER_TEMP/task-machine.log"
grep -Fx 'accepted:2:3' "$RUNNER_TEMP/task-machine.log"
grep -Fx 'exhausted:3:4' "$RUNNER_TEMP/task-machine.log"
grep -Fx 'exhausted:0:1' "$RUNNER_TEMP/task-machine.log"
test "$(grep -c '^blocked:' "$RUNNER_TEMP/task-machine.log")" -eq 2
echo 'BEND TASK MACHINE CHECKS PASS'
