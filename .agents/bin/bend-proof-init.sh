#!/usr/bin/env bash
# Copies files only. Formal proof decisions belong to the official Bend checker.
set -euo pipefail
[[ "$#" -eq 1 && -n "$1" ]] || { echo 'usage: bend-proof-init.sh NEW_DIRECTORY' >&2; exit 64; }
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TEMPLATE="$ROOT/templates/bend-proof"
[[ -d "$TEMPLATE" && -f "$ROOT/.agents/bin/gate-receipt.sh" ]] || { echo 'initializer assets are missing' >&2; exit 66; }
dest="$1"
[[ "$dest" != *[[:cntrl:]]* ]] || { echo 'control characters in destination are unsupported' >&2; exit 64; }
[[ ! -e "$dest" && ! -L "$dest" ]] || { echo 'destination already exists; nothing changed' >&2; exit 73; }
parent="$(cd "$(dirname -- "$dest")" && pwd -P)"
dest="$parent/$(basename -- "$dest")"
stage="$(mktemp -d "$parent/.bend-proof-init.XXXXXX")"
trap 'rm -rf -- "$stage"' EXIT
cp -R -- "$TEMPLATE/." "$stage/"
cp -- "$ROOT/.agents/bin/gate-receipt.sh" "$stage/.agents/bin/gate-receipt.sh"
cp -- "$ROOT/LICENSE" "$stage/LICENSE"
mkdir -p "$stage/task-machine"
cp -- "$ROOT/agent-machine/"*.bend "$ROOT/agent-machine/README.md" "$stage/task-machine/"
chmod +x "$stage/.agents/bin/"*.sh
(cd "$stage" && sha256sum LAWS.bend > .agents/LAWS.sha256)
# GNU mv: refuse overwrite and never nest in a concurrently created directory.
mv -T -n -- "$stage" "$dest"
[[ ! -d "$stage" ]] || { echo 'destination appeared during generation; nothing overwritten' >&2; exit 73; }
printf 'Created %s\nState: example law, human approval absent, root proof open.\nNext: read AGENTS.md in the generated project.\n' "$dest"
