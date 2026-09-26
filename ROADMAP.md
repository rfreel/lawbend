# Agent-system roadmap

The system should evolve by reducing future decision cost, not by accumulating
more process. Each milestone must remove ambiguity or repeated work for a real
consumer.

## M0 — Existing correctness/research substrate

Status: established.

- human/meta law anchor;
- object-level Bend laws and proof;
- independent finite validation;
- pinned optimization contract;
- clean-run evidence and research history.

## M1 — Coherent control tower

Status: implemented.

- one control root;
- explicit intent and mathematical/control model;
- task gate algebra;
- orthogonal shallow starting paths;
- machine-readable routing manifest;
- compact durable decision memory;
- impact-aware CI;
- corrected Bend execution guidance.

## M2 — Dependency-aware gate receipts

Status: implemented.

Deliver:

- `.agents/CLAIMS.json` claim/dependency registry;
- `.agents/bin/gate-receipt.sh` for explain/hash/emit/status;
- aggregate dependency hashes plus per-file Git blob identities;
- control-plane mutation test proving fresh → stale → fresh behavior;
- CI receipt artifacts for control topology, immutable meta-law, and Keccak
  research gate.

Acceptance:

- a changed dependency makes the corresponding receipt stale;
- restoration makes it fresh again;
- unrelated claims retain independent dependency hashes;
- receipts carry explicit scope and do not self-certify external truth.

## M3 — Law-backed project initializer

Next.

Create a minimal initializer for new proof projects:

```
INTENT.md
MODEL.bend or MODEL.md
LAWS.bend
PROOF.bend
TRUST.md
AGENTS.md
.agents/MANIFEST.json
.agents/CLAIMS.json
.agents/bin/gate-receipt.sh
.github/workflows/proof.yml
```

The initializer should encode:

```
intent → mathematical model → formal statement → proof
                     \
                      → external evidence
```

Acceptance:

- generated project has one Bend command that checks all formal laws;
- laws are human-owned by construction;
- agent receives a minimal routing map;
- formal and external claims have separate dependency receipts;
- a fresh agent can complete a small proof task using only generated guidance.

## M4 — Failure-indexed proof ergonomics

After M3 adversarial use exposes stable failure classes.

Accrete only observed classes:

- parser/syntax mismatch;
- quantity/affinity mismatch;
- termination failure;
- definitional equality mismatch;
- missing representation bridge;
- wrong law/spec;
- tooling/version mismatch.

Each entry maps a diagnostic to the cheapest next discriminator.

## M5 — Representation bridge library

Only when multiple projects consume the same bridge shapes.

Candidates:

- encode/decode round trip;
- operation homomorphism;
- bounds/capacity preservation;
- public API refinement;
- state-machine simulation.

## M6 — Agent accretion loop

Continuously:

1. task closes;
2. classify lesson as transient or durable;
3. durable decision → `DECISIONS.md`;
4. detailed failure/provenance → `AFTER_ACTION_REPORT.md`;
5. repeated route improvement → manifest/system docs;
6. delete superseded duplicate instructions.

Metric: lower future orientation and validation cost at equal or better claim
precision.
