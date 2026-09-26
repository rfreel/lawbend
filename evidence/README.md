# Gate receipts

Gate receipts are compact evidence pointers. They answer two questions:

1. what exact dependency state did a gate observe?
2. is that observation still fresh for the current tree?

They do **not** make a claim true by themselves.

Canonical claim/dependency definitions live in `.agents/CLAIMS.json`.
`.agents/bin/gate-receipt.sh` computes the current dependency-set hash, emits
receipts, and compares a prior receipt with the current dependency state.

Examples:

```sh
.agents/bin/gate-receipt.sh explain control.topology
.agents/bin/gate-receipt.sh hash control.topology
.agents/bin/gate-receipt.sh status control.topology receipt.json
```

Receipt status:

- `fresh`: every dependency selected by the claim registry has the same
  aggregate content identity as the recorded gate run;
- `stale`: at least one selected dependency changed, was added, or was removed.

Freshness means "this gate observed this dependency state." It does not transfer
formal evidence into empirical evidence, finite tests into universal coverage,
or internal provenance into independent external validation.
