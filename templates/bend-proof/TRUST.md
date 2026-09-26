# Trust boundary

A successful Bend check proves only the laws actually checked, under the selected parser, termination/quantity checker, equality kernel and Base semantics. It does not prove the model captures external scientific truth, compiler correctness, hardware correctness, security, performance or independent observer reliability.

The root example law/proof follow the official Bend 2.0.27 guide's add_zero example. The layout follows gouveags/bend-init; its custom C/JavaScript directory effects are not included. Shell utilities copy/install files, invoke Git and execute Bend. They do not implement or decide the theorem. Pure example execution is normalized by Bend. The task machine uses Base IO; no custom foreign effects are shipped.

The initializer targets GNU/Linux. It does not install packages, publish, create a remote repository, merge branches or overwrite an existing destination. Its filesystem operations are not formally proved.

Law hashes and receipts are project-controlled records, not signatures or human approval. recorded receipts preserve an asserted result; executed receipts wrap a command. Both need a trusted origin. usable additionally requires matching dependencies, successful execution, and explicit matching tool/context identifiers. A caller must assess whether the captured context is sufficient for the exact claim. Use isolated workspaces; before/after hashes do not eliminate malicious concurrent modification.

The external claim requires evidence/observations.json, which is intentionally absent. No external evidence or receipt is invented by initialization. A clean-run fixture is not a blind-agent usability or holdout-generalization evaluation.

Sources: https://github.com/bendlang/bend/blob/v2.0.27/guide/GUIDE.md ; https://github.com/gouveags/bend-init/blob/main/README.md
