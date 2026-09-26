# Durable decisions

This is the compact, accretive memory of the system. It records stable decisions,
not chronology. Historical detail and failed attempts belong in
`AFTER_ACTION_REPORT.md`.

## D-0001 — One control-plane root

**Decision:** `SYSTEM.md` is the navigation/control root.

**Reason:** agents previously had to reconcile README, AGENTS, skills,
correctness notes, contracts, and history without a declared topology.

**Consequence:** specialized documents remain authoritative for their own
content, but navigation and task routing are centralized.

## D-0002 — Gate vectors, not a universal pipeline

**Decision:** tasks activate only the formal, empirical, operational,
performance, provenance, and acceptance gates their claims require.

**Reason:** forcing every task through every validation path wastes resources
and conflates kinds of evidence.

**Consequence:** documentation-only work does not trigger the full Keccak
research gate; proof work does not need a benchmark unless it makes a
performance claim.

## D-0003 — Two law planes

**Decision:** `LAW.bend` is the immutable meta-policy for claim certificates;
`LAWS.bend` is the object-level Keccak theorem set.

**Reason:** both are called "law" but have different subjects and owners.

**Consequence:** agents must never infer that proving object laws fills the
meta-law, or that editing object laws is a proof repair.

## D-0004 — Prewalk orthogonal routes

**Decision:** before a consequential edit, prewalk multiple shallow routes and
choose the cheapest discriminating one.

**Reason:** the first available tool is often not the best first experiment.

**Consequence:** formal-first, observation-first, implementation-first, and
tooling-first are considered independently and linked only when necessary.

## D-0005 — Approved remote Bend executor

**Decision:** if the local environment lacks Bend, an approved GitHub Actions
runner may install the pinned official Bend release and execute the Bend gate.

**Reason:** a missing local executable is a tooling state, not a reason to
replace Bend proof checking with another language.

**Consequence:** retain the exact compiler version, checksum, command, commit,
and runner result. No Python/C/JS verifier substitutes for `bend PROOF.bend`.

## D-0006 — Bend version command

**Decision:** use `bend version`, then read `bend guide`.

**Reason:** Bend 2.0.27 rejects `bend --version`; the installed CLI advertises
`bend version`.

**Consequence:** project agent instructions use the command accepted by current
Bend 2 tooling and still defer to the installed guide when versions differ.

## D-0007 — Accrete only reusable knowledge

**Decision:** promote architectural decisions, expensive failure modes,
invalidation rules, and trusted execution paths; do not promote transient logs
or duplicated checklists.

**Reason:** uncontrolled memory increases future context cost.

**Consequence:** `DECISIONS.md` stays small; `AFTER_ACTION_REPORT.md`
remains the detailed evidence archive.

## D-0008 — Impact-aware CI

**Decision:** heavy workflows trigger only when their dependency surface changes.

**Reason:** running proof/build/reference/benchmark infrastructure for unrelated
documentation changes wastes resources without increasing confidence.

**Consequence:** workflow path filters mirror the claim-dependency graph.


## D-0009 — CI routing is itself observable

**Decision:** validate the control plane with a documentation-only commit after
installing impact-aware workflow filters.

**Reason:** path-filter intent is not enough; the Actions run set is the direct
observation of whether routing behaves as designed.

**Consequence:** a control-doc-only change should run the lightweight control
gate and skip the Keccak research and immutable-law gates.


## D-0010 — Expected failures need typed diagnostics

**Decision:** a gate that expects failure must match the expected failure class,
not ban a generic word such as `Error:`.

**Reason:** the immutable meta-law intentionally has nine open laws. A newer
Bend checker reports that expected condition as `Error: 9 TODOs found.`, which
made the old broad `! grep "Error:"` predicate reject a correct observation.

**Consequence:** negative gates identify the expected diagnostic and reject only
additional/unexpected errors. Tool-output wording changes are treated as tooling
evidence, not as theorem failures.
