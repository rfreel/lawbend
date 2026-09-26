# Agent-system roadmap

Authority: the user's four-stage intent/model/statement/proof workflow, authorization to finish the system steps, and the supplied solver/verifier/repair architecture.

## Implemented substrate

Keccak's public laws, proof, implementation and frozen experiment contract remain unchanged. Root proof claims still use Bend 2.0.16. The agent system has a routing manifest, explicit claim classes and independent evidence boundaries.

## Receipt correctness

The first implementation existed at d22f1d2384b092272b8bf301bb69606628bef720. Regression run 36274870340 exposed that deleting a tracked dependency still permitted emission. The new recorder completes and validates an inventory before hashing, tracks newly added files and executable modes, rejects symlinks/corrupt inventories, and distinguishes fresh from usable.

Schema-2 reuse requires a successful executed result, matching dependency/claim/recorder identities, explicit matching tool/context and a trusted origin. This is bookkeeping, not authentication or proof of external truth. Legacy recorded receipts are never automatically promoted.

## Standalone initializer

`.agents/bin/bend-proof-init.sh NEW_DIRECTORY` copies a GNU/Linux standalone project without overwrite. It preserves the upstream Bend-guide add-zero tutorial as an independent small proof example. The root proof starts open; an included completion example proves the unchanged law. It also includes the separately checked task-machine library.

Human law adoption remains explicit. Generated metadata does not authorize a requirement. Missing external observations remain missing. The initializer has tests for fresh paths, spaces, existing destinations, missing compilers, law drift, invalid proofs and actual recorded checker execution.

## Reusable Bend task machine

`agent-machine/` implements the user's typed solve / verify / repair protocol. The added pure subject projection binds evidence to task, contract, artifact and revision. The machine retains evidence and failed attempts; missing/mismatched evidence is Blocked rather than empirical failure. Repeating the same artifact revision after repair stops rather than wasting more verification calls.

Formal laws cover internal code-block rendering and terminal evidence/defect preservation. Concrete IO specializations are checked separately. The caller must deploy authentic independent observers and complete criterion checks. No Google Docs or Gemini foreign adapter is included. Nat fuel bounds controller repair steps, not arbitrary adapter duration.

## Acceptance still requiring independent observation

- A genuinely separate agent uses only the generated guidance on a held-out specification.
- A task/evaluator owner supplies holdout tasks not used to design or repair this machine.
- A real external adapter reads exact artifact revisions and provides verifiable reports under fixed criteria.
- Comparative measurements establish any claimed reduction in orientation cost, token use or execution cost.

The automated fixture suite is not a substitute for these observations. Do not assign an invented number of turns to them. Integration may ship a precisely scoped tested library without claiming these external criteria are complete.

## Next layers, only with a consumer

Bind a real readback/judgment adapter; authenticate reports and implement deadlines, cancellation and concurrent-revision handling. Add diagnostics only after an observed failure. Factor reusable representation bridges only when a second real task needs them. Keep stable decisions separate from raw history.
