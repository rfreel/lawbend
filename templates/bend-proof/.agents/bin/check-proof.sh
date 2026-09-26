#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"
BEND="${BEND:-bend}"
command -v "$BEND" >/dev/null || { echo 'Bend is missing; use the pinned official release or generated GitHub Actions workflow' >&2; exit 69; }
sha256sum --check .agents/LAWS.sha256
expected="$(jq -r '.bend_version' .agents/TOOLCHAIN.json)"
actual="$("$BEND" version)"
[[ "$actual" == "$expected" ]] || { printf 'Bend version mismatch: expected %s, got %s\n' "$expected" "$actual" >&2; exit 65; }
[[ "$(git rev-parse --show-toplevel)" == "$ROOT" ]] || { echo 'Initialize and commit this project as its own Git repository before recording a receipt' >&2; exit 65; }
# Context is an observed fingerprint, not a guarantee of every host property.
binary_hash="$(sha256sum "$(command -v "$BEND")" | cut -d' ' -f1)"
base_hash="$("$BEND" base | sha256sum | cut -d' ' -f1)"
export GATE_CONTEXT_ID="${GATE_CONTEXT_ID:-$(uname -s):$(uname -m):$binary_hash:$base_hash}"
uri="${GATE_EVIDENCE_URI:-file://$ROOT/build/gate-receipts/project.proof.json.log}"
.agents/bin/gate-receipt.sh run project.proof build/gate-receipts/project.proof.json "$actual" "$uri" -- "$BEND" PROOF.bend
