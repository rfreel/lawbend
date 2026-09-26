# Agent-system completion plan

Goal: execute the authorized receipt, initializer, adversarial-use and integration steps without weakening human laws or substituting an alternate prover.

Base: d22f1d2384b092272b8bf301bb69606628bef720. The user subsequently supplied the typed solver/verifier/repair design; docs/plans/task-machine.md records that extension. Shell remains limited to filesystem, Git, installation, receipts and checker orchestration; every new theorem and solver protocol is Bend.

## Decisions

A fresh receipt is not necessarily reusable. Missing inventories fail closed. Command result and environment equivalence are independent fields. A clean runner is not a fresh agent. The official guide's add_zero example provides the initializer's small proof task; the user's code-block law is the separate task-machine rendering obligation.

The generic machine keeps solve, verify and repair as IO templates, plus a pure identity projection. Evidence must name the exact task/contract/artifact/revision. Blocked covers missing or mismatched observations and no-progress repair. Attempts remain in the outcome. Witness authenticity and independent judgment stay outside the proof boundary.

## Checklist

- [x] Add failing receipt and missing-initializer checks; observe them on GitHub.
- [x] Repair fail-open inventory handling, failed-result reuse and corrupt inventory handling.
- [x] Add standalone non-overwriting initializer, open root proof, completed official example and executed receipts.
- [x] Add the task-machine package, Code -> CodeBlock laws and explicit proof boundary.
- [ ] Finish concrete IO specialization checks and implementation mutation rejection.
- [ ] Check current-head workflows and unchanged protected blobs.
- [ ] Update PR evidence and integrate only the tested scope under authorization.
- [ ] Obtain independent fresh-agent/holdout observations; fixtures cannot establish this criterion.

## Review focus

Missing/deleted/untracked/symlink dependencies; failed fresh receipts; altered context; existing destinations; unapproved or open laws; callback quantity mismatch; stale evidence revisions; unavailable observers; zero fuel; unchanged repair output; compiled fixture counts versus universal claims.

Status is determined by the exact commit's checker and runner output, not this checklist alone. Remaining independent observations are listed in ROADMAP.md.
