# Agent operating instructions

Start with [SYSTEM.md](SYSTEM.md) and [.agents/MANIFEST.json](.agents/MANIFEST.json).
Do **not** read the whole repository by default.

## 1. Orient

For a nontrivial task:

1. identify the requested outcome and explicit non-goals;
2. select the path in the manifest;
3. use [.agents/TASK_TEMPLATE.md](.agents/TASK_TEMPLATE.md) as the task capsule;
4. activate only the claim classes and gates the task needs;
5. prewalk two to four shallow routes before making a consequential edit.

Expand the read set only when an explicit dependency, contradiction, or failed
gate requires it.

## 2. Respect authority

- User/human instructions control intent.
- `LAW.bend` is the content-addressed human meta-law. Do not edit it.
- `LAWS.bend` is the object-level Keccak requirement. Do not weaken or rewrite
  it to make a proof pass. A requested law change is a requirements change.
- `benchmarks/research_contract.json` freezes the current optimization
  experiment. Changing it creates a different experiment and must be surfaced.
- `PROOF.bend`, implementation, evidence, and control documents are downstream
  artifacts; they must conform to the authorities above.

If two authorities appear inconsistent, do not silently reconcile them. Surface
the mismatch and identify which contract would have to change.

## 3. Bend environment

Before Bend design, implementation, proof, compilation, or benchmark work:

1. run `bend version`;
2. read the complete `bend guide`;
3. read the relevant existing Bend files;
4. use the installed guide as the syntax/behavior authority for that compiler.

If Bend is unavailable locally, use the repository's approved pinned
GitHub-Actions execution path when possible. A missing local executable is a
tooling blocker, not permission to substitute Python, C, JavaScript, Lean, or
another verifier for a Bend proof claim.

For implementation/performance work, also read the pinned
[bend-build skill](.agents/skills/bend-build/SKILL.md). For optimization
research, read its
[research-loop reference](.agents/skills/bend-build/references/research-loops.md).
For Bend workflow details, read
[the Bend 2 workflow skill](.agents/skills/bend2-official-workflow/SKILL.md).

Verify the vendored bend-build snapshot when its contents are relevant:

```sh
sha256sum --check .agents/skills/bend-build/SHA256SUMS
```

## 4. Execute cheap discriminators first

Prefer:

```
targeted read
< static check
< focused proof/test
< finite independent validation
< build/runtime
< full validation
< benchmark
< external clean-machine confirmation
```

Stop once a failure already decides the live hypothesis. Re-run only gates whose
dependencies changed.

## 5. Claim discipline

Keep these distinct:

- formal derivation;
- external observation;
- actual runtime behavior;
- performance measurement;
- provenance/reproducibility;
- authorized acceptance.

A passing `bend PROOF.bend` establishes only its stated laws under the stated
Bend/Base assumptions. Finite vectors remain finite. Benchmarks remain scoped to
their workloads and hosts.

## 6. Finish and accrete

Before reporting completion:

- required gate vector passes;
- exact claim boundary is stated;
- affected evidence corresponds to the shipped source;
- blockers and unsupported extensions are explicit;
- any reusable architectural lesson is promoted once to `DECISIONS.md`.

Use `AFTER_ACTION_REPORT.md` only for chronology, provenance, and failure
forensics. It is not required reading for ordinary tasks.
