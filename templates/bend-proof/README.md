# Standalone Bend proof project

Start at AGENTS.md. The root tutorial proof is intentionally open.

```sh
bend version
bend guide
bend PROOF.bend  # initially reports an open law
cp examples/PROOF.complete.bend PROOF.bend
bend PROOF.bend  # checks the completed induction proof
bend main.bend   # evaluates 2n
```

For a recorded check, initialize and commit this directory as a Git repository, then run `.agents/bin/check-proof.sh`. It writes build/gate-receipts/project.proof.json and its actual checker log.

The task-machine subdirectory is a reusable Bend-only library and separate proof package. Its README explains evidence types, revision matching, bounded repair and missing external adapters.

No existing law is silently accepted by generating these files. Review INTENT.md and LAWS.bend for any real project. See TRUST.md.
