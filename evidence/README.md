# Gate receipts

A receipt records an observation and its declared dependencies. It is not a signature, a proof, an observer, or human acceptance.

## Commands

```sh
.agents/bin/gate-receipt.sh explain CLAIM
.agents/bin/gate-receipt.sh hash CLAIM
.agents/bin/gate-receipt.sh run CLAIM OUT TOOL_VERSION EVIDENCE_URI -- COMMAND ARGUMENTS
.agents/bin/gate-receipt.sh status CLAIM RECEIPT EXPECTED_TOOL_VERSION EXPECTED_CONTEXT_ID
```

Set GATE_CONTEXT_ID when executing a gate. A context ID must describe the environment dimensions relevant to that claim. Caller-supplied labels are not independently authenticated.

`run` executes the command, retains its log and records its actual exit result. It checks dependency identities before and after execution. A changed snapshot is unstable, never successful. It does not impose a timeout; invoke a bounded command or use the CI job deadline. An aborted recorder may leave only a log and no receipt; absence never means success.

`emit` remains available for historical records but produces recording=recorded. Such receipts cannot report usable=true. The old optional final dash remains accepted for compatibility. Schema-1 receipts must be regenerated rather than silently upgraded.

## Freshness and reuse

- fresh means the declared dependency inventory and claim definition match.
- stale means an inventoried dependency or definition changed.
- missing files, symlinks, corrupt receipts and unknown claims produce an error.
- failed, blocked, cancelled, timeout and unstable results are not reusable.
- usable=true additionally requires successful executed status and explicit matching tool/context IDs.

A two-argument status query checks source freshness only and always leaves usable=false. It exits unsuccessfully for stale or failed results. A four-argument query also exits unsuccessfully when reuse conditions fail. Before reusing any result, inspect its trusted origin, scope and log; even usable=true does not authenticate an arbitrary JSON file.

The recorder includes tracked paths, new files and ignored files inside selected directories; it deliberately over-invalidates rather than silently missing an import. Executable mode changes matter. Missing tracked files fail closed. Directory output should be written outside dependency roots. Do not introduce cache exclusions without reviewing the import/build dependency closure.

source_tree identifies Git HEAD. The explicit working-tree inventory identifies the bytes actually examined, including uncommitted files. Do not describe those as identical merely because a receipt has a commit ID. Use isolated workspaces; before/after snapshots are not a defense against a malicious concurrent actor.

## Evidence classes

Bend proof, mechanical readback, independent judgment and holdout evaluation are distinct. None upgrades another. task-machine fixtures exercise code paths; they are not independent observations of Google Docs or Gemini. No external receipt is manufactured by the initializer.
