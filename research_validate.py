#!/usr/bin/env python3
"""Freeze the Keccak claim boundary and run its existing proof/reference checks.

This gate does not claim that a Bend proof verifies the native compiler.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys


ROOT = Path(__file__).resolve().parent
CONTRACT = "benchmarks/research_contract.json"


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def imports(source: str) -> list[str]:
    return re.findall(r"^\s*import\s+(.+?)\s*$", source, flags=re.M)


def audit(root: Path = ROOT) -> dict:
    contract = json.loads((root / CONTRACT).read_text())
    for filename, expected in contract["frozen_files"].items():
        path = root / filename
        if not path.is_file() or digest(path) != expected:
            raise RuntimeError(f"Frozen contract changed or disappeared: {filename}")
    actual_bend_files = {
        p.relative_to(root).as_posix()
        for directory in ("src", "spec", "proofs")
        for p in (root / directory).rglob("*.bend")
    }
    if actual_bend_files != set(contract["bend_files"]):
        raise RuntimeError("Bend import surface changed: added or removed source, specification, or proof files")
    for filename, expected in contract["imports"].items():
        source = (root / filename).read_text()
        if imports(source) != expected:
            raise RuntimeError(f"Import graph changed: {filename}")
        code = "\n".join(line.split("#", 1)[0] for line in source.splitlines())
        if re.search(r"@\s*unsafe\b|\?\w*|\b(?:IO|File|Socket|Listener|Chan)\.", code):
            raise RuntimeError(f"Unsafe declaration, hole, or unexpected effect: {filename}")
        if filename.startswith("src/") and re.search(r"\b(?:List|Nil|Cons)\b|/(?:proofs|spec)/", code):
            raise RuntimeError(f"Production path gained proof/spec storage or a list: {filename}")
    bend = Path(os.environ.get("BEND", str(Path.home() / ".bend/bin/bend")))
    version = subprocess.run([str(bend), "--version"], capture_output=True, text=True, check=True).stdout.strip()
    if version != contract["bend_version"]:
        raise RuntimeError(f"Bend version changed: expected {contract['bend_version']}, got {version}")
    return contract


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--audit-only", action="store_true")
    parser.add_argument("--mutations", action="store_true", help="Run the repository's ten negative proof probes")
    args = parser.parse_args()
    if sys.flags.optimize:
        raise RuntimeError("Python optimizations disable assertions in the existing validation script")
    contract = audit()
    print(f"Contract: {len(contract['frozen_files'])} frozen files, {len(contract['imports'])} checked imports, {contract['bend_version']}", flush=True)
    if args.audit_only:
        return
    command = [sys.executable, "tools/validate.py"]
    if args.mutations:
        command.append("--mutations")
    subprocess.run(command, cwd=ROOT, env={**os.environ, "BEND_NO_TELEMETRY": "1", "PYTHONOPTIMIZE": "0"}, check=True, timeout=1500)
    print("Proof and independent digest checks passed for the stated Keccak API", flush=True)


if __name__ == "__main__":
    main()
