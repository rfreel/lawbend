# Agent-system completion plan

Goal: execute the authorized receipt, initializer, adversarial-use and integration steps without weakening human laws or substituting an alternate prover.

Base: d22f1d2384b092272b8bf301bb69606628bef720. The user subsequently supplied the typed solver/verifier/repair design; docs/plans/task-machine.md records that extension. Shell is limited to filesystem, Git, installation, receipts and checker orchestration. All new theorems and the task protocol are Bend.

## Decisions

Fresh is not the same as reusable. Missing inventories fail closed. Command result and environment equivalence are separate fields. A new execution first writes a non-reusable running receipt so interruption cannot expose an earlier success as its result. For retained history, callers should use a unique output path for each run.

A clean runner is not a fresh agent. The official guide's add_zero example is the initializer's small proof task; the user's code-block law is the separate rendering obligation. The generic machine keeps solve, verify and repair as IO templates plus a pure identity projection. Evidence identifies task, contract, artifact and revision. Missing/mismatched observation and no-progress repair return Blocked. Observer authenticity stays outside the proof.

## Engineering checks

At 3a17e556324dbd9279d1b26bb5000bee3da2f213 the task-machine proof/runtime/mutation job and initializer/receipt jobs passed. The current commit adds an in-flight receipt regression and typed Docs adapter data; current CI must pass before integration.

- [x] Observe failing receipt inventory, missing initializer and missing machine probes.
- [x] Repair inventory failure propagation and distinguish recorded, executed, fresh and usable states.
- [x] Add standalone non-overwriting initializer, open root law, completed example and actual checker receipts.
- [x] Add the Bend machine and seven laws without weakening the user's code-block property.
- [x] Exercise two distinct type specializations, zero fuel, bounded repair, stale witness, unavailable observer, unchanged repair, and code-block mutation rejection.
- [ ] Verify the final running-state regression on old and new implementations.
- [ ] Check final-head workflows and protected-source identity, then integrate the tested scope.

## External acceptance still open

- An independent fresh agent drives the generated project without this conversation.
- An independent task owner supplies held-out specifications and evaluation.
- Real Docs/readback/judgment adapters are implemented against an authorized artifact and observer.
- Comparative measurements establish any claimed resource-efficiency improvement.

These are not consequences of type checking or self-authored fixtures. No turn-count estimate or generalization claim is established.
