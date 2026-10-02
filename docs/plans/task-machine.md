# Bend task-machine extension

Authority: user's supplied Bend2 solver / verifier / repair architecture and explicit authorization to implement the remaining system steps.

## Meaning preserved

Input, output, evidence and defect remain distinct types. The three effectful operations are solve, verify and repair. Nat fuel counts repairs, not initial verification: zero fuel still verifies once. A successful result retains evidence from the final verification. No external observer is implemented or simulated as an independent witness.

## Necessary refinements

- Move matches on IO-bound/computed values into helpers that match function parameters, as required by the installed Bend 2.0.27 guide.
- Add Unavailable / Blocked for missing, invalid or unavailable evidence. This is not an empirical refutation and does not spend repair fuel.
- Add a pure subject projection: task ID, contract revision, artifact identity and artifact revision. Check a witness against all four before using Pass or defects. Preserve readback versus independent judgment as different evidence kinds.
- Preserve attempt history, including rejected and mismatched reports. This is a reverse-chronological audit, not a new source of truth.
- Do not introduce C/JavaScript effect implementations. Google Docs and Gemini are documented adapter contracts only; no external writes are authorized by this example.

## Proof boundary

Prove the user's code-tag -> code-block law for every String and the inverse rendering relation. Prove terminal output/evidence preservation under the declared Bend types. Compile the generic IO controller and run bounded repair cases, zero-fuel cases, immediate pass, unavailable witness, revision mismatch and a repair callback that must not be invoked. Runtime fixture cases are protocol tests, not independent-world verification and not a theorem of generalization. Fuel bounds controller repair calls; it does not bound duration or behavior inside an external adapter.

## Tasks

- [ ] Add a missing-package acceptance check; observe failure.
- [ ] Implement the shared Bend protocol and pure rendering model.
- [ ] Supply proofs without changing the requirements to ease checking.
- [ ] Exercise the real compiled IO protocol under pinned Bend.
- [ ] Connect the standalone initializer and explicit claim/evidence status.
- [ ] Update status with current compiler results; leave independent holdout evaluation pending.
