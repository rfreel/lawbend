# Intent

## System mission

Build and maintain Bend systems whose consequential claims are:

- explicit enough to audit;
- mechanically proved when they are mathematical;
- independently observed when they concern the external world;
- reproducible when they concern execution;
- measured under a fixed contract when they concern performance;
- never strengthened merely because a convenient gate passed.

The system should make the next correct action obvious to an agent while
minimizing unnecessary context, reruns, duplicated reasoning, and irreversible
changes.

## Current project outcome

For the current Keccak instance, the desired outcome is:

1. a usable public Ethereum Keccak-256 API in stock Bend;
2. a universal Bend refinement of that public API to a separately structured
   Bend sponge specification;
3. independent finite observations that can expose disagreement with the
   intended external algorithm;
4. reproducible source/toolchain provenance;
5. an optimization process that pursues the inherited
   `Bend time / optimized C time <= 2` target without weakening items 1–4.

## Priority order

When objectives conflict:

1. preserve the intended public semantics;
2. preserve the human-owned formal obligation;
3. preserve honest claim/evidence boundaries;
4. preserve reproducibility and reversibility;
5. improve performance;
6. improve convenience.

A speedup that weakens a law is not an optimization of this project. A formal
proof that only proves an easier substitute is not completion.

## Non-goals

The current system does not claim:

- compiler or hardware correctness;
- cryptographic collision/preimage security;
- constant-time behavior;
- that finite vectors prove unrestricted external conformance;
- that a measured candidate is globally optimal;
- that the current <=2x target has been reached.

## Authority and change

- The user/human owner controls intent.
- `LAW.bend` is the immutable meta-policy for claim certification, anchored by
  `LAW.IMMUTABLE`.
- `LAWS.bend` is the current object-level Keccak proof obligation.
- `benchmarks/research_contract.json` is the current experiment boundary.
- Agent-authored proof, implementation, evidence, and control documents must
  conform to those inputs; they do not silently rewrite them.

If intent and a current law/contract diverge, surface the mismatch as a contract
change. Do not silently choose whichever artifact is easier to satisfy.
