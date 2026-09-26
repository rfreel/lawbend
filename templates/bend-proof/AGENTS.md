# Start here

Read INTENT.md, then .agents/MANIFEST.json. Choose one route; do not scan the whole project.

Run `bend version` and read `bend guide` using the version in .agents/TOOLCHAIN.json. Implementations and proofs are Bend only. No alternate prover, unsafe declaration or foreign-function implementation replaces a law.

The example law is not a human-approved production requirement. After adoption, LAWS.bend is protected; do not change it to make a proof pass. .agents/LAWS.sha256 detects drift, not independent authorization.

Tutorial: `bend PROOF.bend` initially reports an open law. Complete the proof by induction or copy examples/PROOF.complete.bend to PROOF.bend. Then `bend PROOF.bend` and `bend main.bend` exercise the actual path. Do not claim this proves an external observation.

Recorded runs: initialize and commit this directory as its own Git repository, then run `.agents/bin/check-proof.sh`. It checks the law digest and actual Bend version, invokes Bend and records the exit result. A missing checker is a setup failure, not a rejected theorem. Generated GitHub Actions installs the official checksum-pinned executable.

For generic tasks, read task-machine/README.md and use its typed run interface. Pass real revision-bound observer adapters, not the local fixture. Code blocks in internal Bend values and blocks stored in Google Docs are different claims.

Reuse requires `gate-receipt.sh status CLAIM RECEIPT EXPECTED_TOOL EXPECTED_CONTEXT` with usable=true, trusted origin, and matching scope. A fresh failure is not reusable. A source-only query cannot establish environment equivalence.

On interruption inspect Git, current files and receipts before repeating work. Before an unfamiliar edit, compare a direct proof step, an independent counterexample and a toolchain probe. Execute the cheapest action that can change the next decision.
