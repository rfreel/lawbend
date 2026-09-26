# Agent operating instructions

Start with SYSTEM.md and .agents/MANIFEST.json. Select the smallest relevant route; do not read the whole repository. Use .agents/TASK_TEMPLATE.md for nontrivial work, without requiring a permanent file for a small change.

## Authority

User instructions control intent. LAW.bend is the content-addressed human meta-law anchored by LAW.IMMUTABLE; do not edit it. LAWS.bend is the Keccak requirement. agent-machine/LAWS.bend states separate task-machine obligations. Do not weaken either to fix a proof. benchmarks/research_contract.json is the current Keccak experiment boundary; changing it creates a different experiment. Surface conflicts rather than silently choosing the easier requirement.

## Toolchain and route

Keccak remains on Bend 2.0.16; the task machine and initializer use 2.0.27. Run `bend version`, read the installed `bend guide`, and inspect the relevant existing code. A proof file does not instantiate every generic runtime path: check the concrete invocation too.

Use the pinned .agents/skills/bend-build/SKILL.md for implementation/performance work and its references/research-loops.md for experiments. Verify its snapshot with `sha256sum --check .agents/skills/bend-build/SHA256SUMS`. The .agents/skills/bend2-official-workflow/SKILL.md records tool usage; agent-machine/DIAGNOSTICS.md records observed failures.

When local Bend is missing, use an authorized GitHub Actions executor with the pinned official release. No Python, C, JavaScript, Java or alternate prover substitutes for Bend checking. Shell/jq files in this repository only perform installation, filesystem/Git bookkeeping and process orchestration. Existing Keccak external references do not implement a new Bend theorem.

## Action and recovery

Identify the outcome, write/protected sets, active claim classes, and one consequential uncertainty. Compare shallow proof-first, observation-first, implementation-first and tooling-first routes. Execute the cheapest authorized discriminator; do not perform every route. Stop a failed hypothesis when its evidence is decisive. On interruption, read the actual branch head, relevant diff and finished run results before repeating work.

Unknown, blocked, rejected, exhausted and accepted are different states. A tool failure is not a theorem refutation. A timeout is not a negative proof. An unavailable observer does not justify inventing defects. Keep raw evidence and the exact artifact revision.

## Receipt reuse

Read evidence/README.md. Use:

```sh
.agents/bin/gate-receipt.sh explain CLAIM
.agents/bin/gate-receipt.sh status CLAIM RECEIPT EXPECTED_TOOL EXPECTED_CONTEXT
```

Require usable=true, a trusted run origin, and scope that still answers the request. Freshness alone is insufficient: a failed run can be fresh. Schema-1 receipts need a new run. `emit` records assertions; `run` executes the command and retains its result. Caller-supplied context labels are not independent verification.

## Completion

A successful Bend proof covers its declared laws, not external observations, host correctness, performance or observer independence. The task-machine Accepted constructor means the protocol received a revision-matched Pass; it is not human acceptance or empirical truth. Generated tutorial laws are not approved production requirements.

Require the task's actual gates, checked against the submitted revision. Record reusable lessons once at their proper layer. Report missing external adapters and holdout observations explicitly. Do not call self-authored fixtures a blind-agent evaluation or claim a reduction in resource use without comparative measurement.
