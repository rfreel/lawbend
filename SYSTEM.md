# Agent control system

This is the control-plane root for `lawbend`. It does not override a user
instruction, an immutable human law, or an experiment contract. Its purpose is
to make the repository cheap to understand and hard to mis-control.

## Core invariant

A task should require the smallest sufficient set of reads, edits, and gates.

Four separations are never collapsed:

1. **intent** — what outcome is wanted;
2. **model** — what objects, states, relations, and invariants represent it;
3. **formal obligation** — what Bend must prove;
4. **world evidence** — what must be observed rather than proved.

Performance, provenance, and human acceptance are additional orthogonal
dimensions. A proof is not a benchmark. A benchmark is not an external-standard
theorem. A hash is not independent evidence. A passing internal gate is not
human acceptance.

## The tower

| Layer | Question | Canonical artifact | Output |
| --- | --- | --- | --- |
| L0 Intent | What effect do we want? | `INTENT.md` | outcome, non-goals, authority |
| L1 Model | What mathematical/control state represents it? | `MODEL.md` | entities, states, transitions, invariants |
| L2 Contracts | What must remain true? | `LAW.bend`, `LAWS.bend`, `benchmarks/research_contract.json` | meta-law, object laws, experiment boundary |
| L3 Construction | What realizes the contracts? | `src/`, `spec/`, `proofs/`, `PROOF.bend` | implementation, specification, proof |
| L4 Evidence | What was actually observed? | `CORRECTNESS.md`, `VALIDATION.json`, `benchmarks/` | scoped observations and measurements |
| L5 Control | What should an agent do next? | `AGENTS.md`, `.agents/MANIFEST.json`, task capsule | bounded next transition |
| L6 Accretion | What should survive this task? | `DECISIONS.md`, `AFTER_ACTION_REPORT.md`, `ROADMAP.md` | reusable decisions, history, next system work |

There are three directions through the tower:

- **downward refinement:** intent → model → laws → implementation;
- **upward evidence:** execution → observations → claims → acceptance;
- **sideways representation:** alternate forms must preserve the distinctions
  needed by the consuming layer.

Skipping a layer is allowed only when that layer is genuinely irrelevant to the
task. The task capsule records the reason.

## Minimal common prefix

Do not read the repository linearly.

For every nontrivial task:

1. read this file;
2. read `.agents/MANIFEST.json`;
3. instantiate `.agents/TASK_TEMPLATE.md` mentally or in the PR description;
4. select one starting path;
5. read only that path's declared read set;
6. expand context only when a dependency or contradiction requires it.

## Orthogonal starting paths

Each path is independently usable and converges on the same task coordinates
within one hop.

| Start | First read after the common prefix | First discriminating gate |
| --- | --- | --- |
| intent/change request | `INTENT.md`, then `MODEL.md` | outcome and non-goals are unambiguous |
| formal proof | object `LAWS.bend`, relevant spec/proof | `bend PROOF.bend` |
| implementation | public API + relevant `src/` and spec | changed entry point behaves as modeled |
| correctness/evidence | `CORRECTNESS.md`, evidence source | independent observation can falsify claim |
| performance | `benchmarks/OPTIMIZATION.md`, research contract | same public path and workload are comparable |
| research hypothesis | research-loop reference + contract | hypothesis has a falsifier and isolated change surface |
| debugging | failing observation + owning layer | smallest reproducer distinguishes cause |
| release/publish | intent + correctness + provenance | shipped tree equals accepted tree |
| tooling/blocker | `AGENTS.md`, pinned toolchain source | approved execution path exists |

A path may link to another path, but it should do so by an explicit dependency,
not by loading everything preemptively.

## Prewalk before action

Before a consequential edit, prewalk two to four plausible routes at minimal
depth. For each route identify:

- first falsifier;
- expected resource class: read/check/proof/test/build/benchmark/external;
- irreversible or contract-changing step, if any;
- condition that makes the route unnecessary.

Choose the cheapest route that can eliminate the largest live uncertainty.
Do not execute every prewalked route. The prewalk is a control decision, not a
ritual.

Typical orthogonal routes are:

- **formal-first:** can the desired property even be stated/proved under the
  current model?
- **observation-first:** does an independent example already falsify the model?
- **implementation-first:** is there a localized defect with an obvious owner?
- **tooling-first:** is the apparent blocker merely an unavailable executor?

## Gate vector

Progress is a set of satisfied gates, not one mandatory pipeline.

| Gate | Meaning | Typical verifier |
| --- | --- | --- |
| H | intent/authority bound | explicit human requirement / `INTENT.md` |
| M | model coherent | model review + interface consistency |
| F | formal property proved | Bend kernel |
| X | external/empirical claim observed | independent implementation/source/tool |
| O | actual operational path works | real entry point/runtime |
| P | performance claim measured | pinned paired benchmark |
| V | provenance/reproducibility bound | hashes, versions, clean checkout |
| A | accepted for use | authorized human/project decision |

Each task activates only the gates required by its claim classes. Completion is
`required_gates ⊆ passed_gates` with no unresolved blocker affecting the
claimed result.

## Resource order

Unless the task requires otherwise, spend resources in this order:

1. metadata and targeted reads;
2. static parse/type/check;
3. focused proof or unit-level discriminator;
4. finite independent validation;
5. build/runtime execution;
6. full proof/validation suite;
7. benchmark;
8. external clean-machine confirmation.

Stop at the first failure that already decides the hypothesis. Do not rerun a
gate whose dependency set did not change.

## Change propagation

Changes invalidate claims by dependency, not by proximity.

- intent change → review model, laws, acceptance, and downstream claims;
- model/spec change → recheck dependent laws, proofs, evidence interpretation;
- object-law change → new formal obligation; never call it a proof repair;
- implementation change → re-run only dependent formal/operational/evidence gates;
- reference/harness/workload change → invalidate affected empirical/performance claims;
- compiler/toolchain change → re-establish proof/runtime/performance claims under the new toolchain;
- documentation-only navigation change → no Keccak proof/benchmark rerun unless it changes an authority or claim.

## Accretion

A task should leave the system easier to drive than it found it.

Promote a lesson to `DECISIONS.md` when it is stable and reusable: an
architectural choice, an expensive failure mode, a trusted command, an
invalidation rule, or a repeated workflow improvement. Keep raw chronology and
counterevidence in `AFTER_ACTION_REPORT.md`.

Do not accrete:

- duplicated instructions;
- transient debugging details;
- unsupported conclusions;
- a new abstraction with no consumer;
- a checklist item that cannot change a decision.

## Done

A task is done when:

1. its active gate vector is satisfied;
2. the exact claim boundary is stated;
3. affected artifacts and evidence agree;
4. unresolved items are either irrelevant to the claim or explicitly blocked;
5. reusable knowledge has been promoted once, at the highest stable layer.
