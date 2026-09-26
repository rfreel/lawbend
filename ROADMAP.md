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

Status: this change.

Deliver:

- one control root (`SYSTEM.md`);
- explicit intent and mathematical/control model;
- task gate algebra;
- orthogonal shallow starting paths;
- machine-readable routing manifest;
- compact durable decision memory;
- impact-aware CI;
- corrected Bend execution guidance.

Acceptance:

- an agent can identify its minimal read set and required gates without reading
  the repository linearly;
- documentation-only changes do not launch the heavy Keccak research loop;
- meta-law, object law, and experiment contract are explicitly distinguished.

## M2 — Dependency-aware gate receipts

Next.

Goal: make "what must rerun?" mechanically inspectable without building a large
framework.

Candidate design:

```
receipt = {
  claim_id,
  gate,
  source_tree,
  dependency_hashes,
  tool_version,
  command,
  result,
  evidence_uri
}
```

Start with CI-produced JSON for proof/validation/benchmark runs. Do not build a
database until at least two consumers need cross-run queries.

Acceptance:

- a changed artifact can identify which receipts are stale;
- unchanged independent gates can be reused rather than rerun;
- receipts never self-certify the truth of an external specification.

## M3 — Law-backed project initializer

Next after M2 or independently if demanded.

Create a minimal initializer for new proof projects:

```
INTENT.md
MODEL.bend or MODEL.md
LAWS.bend
PROOF.bend
TRUST.md
AGENTS.md
.agents/MANIFEST.json
.github/workflows/proof.yml
```

The initializer should encode the same four-stage contract:

```
intent → mathematical model → formal statement → proof
```

with external evidence as a separate branch, not an extra theorem.

Acceptance:

- generated project has one command that checks all formal laws;
- laws are human-owned by construction;
- the agent receives a minimal task-routing map.

## M4 — Failure-indexed proof ergonomics

Only after repeated proof work exposes stable failure classes.

Accrete a small catalog:

- parser/syntax mismatch;
- quantity/affinity mismatch;
- termination failure;
- definitional equality mismatch;
- missing representation bridge;
- wrong law/spec;
- tooling/version mismatch.

Each entry must map a diagnostic to the cheapest next discriminator. Avoid
generic "tips"; keep only failures repeatedly observed in real work.

## M5 — Representation bridge library

Only where multiple projects need the same bridge shapes.

Candidate reusable laws:

- encode/decode round trip;
- operation homomorphism;
- bounds/capacity preservation;
- public API refinement;
- state-machine simulation.

Do not abstract a one-off proof merely because it looks reusable.

## M6 — Agent accretion loop

Continuously:

1. task closes;
2. classify lesson as transient or durable;
3. durable decision goes to `DECISIONS.md`;
4. detailed failure/provenance goes to `AFTER_ACTION_REPORT.md`;
5. repeated route improvement updates manifest/system docs;
6. delete superseded duplicate instructions.

The metric is not document count. It is lower future orientation cost with equal
or better claim precision.
