# Controlled Bend research loops

Read this when optimizing a Bend public API, testing a new representation, or claiming a verified and fast implementation. [The Keccak after-action report](https://github.com/rfreel/lawbend/blob/main/AFTER_ACTION_REPORT.md) indexes the originating thread, concrete observations, the clean-checkout failure, and repairs. Its historical prompts are not proof of results that the report marks unavailable.

## Bind the claim

Write one contract identifying: intended result; exported type and shape; input length and capacity behavior; endian and padding rules; independent specification and theorem; baseline revision; candidate source surface; reference implementation revision; source and toolchain versions; compiler flags; workloads; measurement boundary; per-workload target; and exact evidence required for acceptance. An instruction, proxy score, internal validator, or output label does not make an external claim true. Record scope and quantifiers for each claimed theorem or performance result. Do not invent unobserved probabilities, risk tolerances, or completeness.

If the user wants a frontier, express it as **established / tested but finite / unresolved** for the fixed API and workload, with evidence on each boundary. An optimization search over a finite candidate set does not calculate the global performance frontier. A representation refinement theorem only transfers a property for which the relevant distinction and interface have been preserved; it does not certify compiler behavior, external-standard conformance, timing, or cryptographic security.

## Model the trial as permitted transitions

| State | Enter only when | Next permitted actions |
| --- | --- | --- |
| `bound` | API, law/specification, source, versions, and acceptance target fixed | Validate baseline or report an exact blocker. |
| `baseline_validated` | Kernel check and independent reference outputs agree at their stated scopes | Build and measure unmodified public path. |
| `baseline_measured` | Raw reference and Bend samples, hashes, and host recorded | Create an isolated candidate source tree. |
| `candidate_validated` | Candidate preserves protected interface/imports; its public proof and independent outputs pass | Build and measure the candidate against the same reference and workloads. |
| `candidate_measured` | Full raw samples and provenance recorded | Compare per-row results and request independent confirmation before adopting a speed claim. |
| `rejected` | A genuine proof, reference, build, or measurement failure identified | Keep counterevidence and next hypothesis; do not rewrite the gate to obtain a pass. |
| `blocked` | A needed action is unavailable, e.g., missing compiler or external oracle | Name the required test, exact blocker, and resumption condition; continue unaffected work. |

Represent distinct results directly; do not use synchronized booleans such as `proof_ok` and `candidate_ready` or treat a timeout as proof rejection. A result should include stage, exit/diagnostic, source hash, run context, and available evidence. Treat resource use, waiting, concurrency, observations, and effects after an apparent pass as part of the sequence. Check combined constraints and progress separately; local checks do not imply shared correctness.

## Execute and evaluate

1. Confirm the exact Bend release, runtime, code generation, compiler, and public API. Stock Bend 2.0.16 emits native C that requires Clang for its `musttail` syntax; a GCC failure is a toolchain incompatibility, not evidence against the algorithm. In portable C harnesses using `clock_gettime`, expose POSIX declarations before system headers on Linux.
2. Fetch the independent reference *before* checking its pinned commit and clean tree. The first [lawbend Actions run](https://github.com/rfreel/lawbend/actions/runs/35933779264) found the inverse ordering only on a clean checkout; the [repaired run](https://github.com/rfreel/lawbend/actions/runs/35934078029) passed. Do not rely on an existing local vendor checkout to validate setup.
3. Run the exported Bend law against a separately written specification. Preserve the proof/specification import graph and test harness when trying source-only edits. Proof-only linked structures can model behavior, but cannot silently replace the public packed-array path. Run targeted negative mutations to learn whether the declared checks distinguish relevant mistakes.
4. Check full outputs against an independent implementation on empty, partial, rate-boundary, repeated-block, dirty-storage, and invalid-capacity cases. Ethereum Keccak-256 is not SHA3-256. Finite vectors, including 278 cases per backend in lawbend, are finite observations and not unrestricted external conformance.
5. Build baseline and candidate from source in isolated workspaces under the same compiler and flags. Benchmark the real public operation, disclose input cloning and output allocation, alternate run order, retain results, record raw samples and binary/source hashes, and check full digests outside a first-word benchmark checksum. Never slow the reference or relabel workloads to satisfy a ratio.
6. Compare **each** agreed workload. A smoke run on 0, 136, and 1024 bytes cannot establish a ten-workload target, even if all three rows pass. Small changes across three samples can be noise; repeat on a clean consumer machine before a speed claim. If a different machine or scale is used, re-establish the required correspondence.
7. Do not auto-promote candidates, silently change frozen contracts, delete counterevidence, or declare that a project-controlled hash gate enforces rules against its own author. Validate against the uploaded tree and a fresh runner. State exactly who controls acceptance and how protected state actually changes.

## Six practical writing and design checks

Produce materially different architectures for genuinely novel choices; trace failures to the originating condition; encode the actual entities and states instead of adding branches or synchronized flags; remove hidden ownership and reader work; automate only repeated mechanical steps while leaving consequential judgment explicit; replace generic assertions with named sources, observations, derivations, and limitations.

## Eleven claim checks from the originating thread

1. **Outcome and authority:** Bind the required effect to the actual instruction, permission, and scope; do not infer facts from an idealized user.
2. **Intent and substitutes:** Separate the actual outcome, its specification, score/proxy, and evaluator; retain incompatible interpretations.
3. **Full consequences:** Include action, inaction, delay, resources, reversibility, interaction, and downstream effects.
4. **Claims and uncertainty:** Distinguish derivation under assumptions, worldly observation, and authorized acceptance; do not infer safety or failure from missing data.
5. **Evidence and revision:** Retain source, scope, counterevidence, dependencies, and a way a relevant error could be exposed; recheck only affected conclusions.
6. **Representations and scale:** Preserve distinctions, decisions, consequences, scope, and quantifiers across each change of representation or granularity.
7. **Interfaces and shared effects:** Check that producer guarantees meet consumer assumptions, including timing, shared state, and progress; verify combined constraints.
8. **Enforcement and changes:** Keep protected acceptance and evidence outside unilateral control when required; do not self-certify an internal gate.
9. **Action and progress:** Take an available authorized step that advances the outcome; avoid unchanged repetition and review in place of action.
10. **Completion and stopping:** Check required effects and acceptance criteria; name the precise blocker or unresolved claim; stop on completion.
11. **Extension and self-review:** Do not transfer finite passing cases into unrestricted coverage; apply the same evidence standards to this checklist without recursive paralysis.

Keep the full sequence and data in the repository's after-action report. The skill's rules guide the next project; its earlier report is a case study, not a claim that every future Bend build behaves like Keccak on Bend 2.0.16.
