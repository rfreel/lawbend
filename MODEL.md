# System model

This document is the mathematical/control model behind the repository.

## Task object

Treat every consequential task as:

```
Task = <Intent, Claims, RequiredGates, ReadSet, WriteSet, Budget, Evidence, Status>
```

RequiredGates is a set derived from the requested outcome, not from which checks
are convenient to pass. A task does not need irrelevant stages.

## Claim classes

```
ClaimClass =
  Formal
| Empirical
| Operational
| Performance
| Provenance
| Acceptance
```

A task may contain several claim classes. Each has a different admissible witness:

| Claim | Admissible witness |
| --- | --- |
| Formal | term accepted by the specified Bend checker/kernel |
| Empirical | observation independent enough to falsify the claim |
| Operational | execution of the actual public/deployment path |
| Performance | raw comparable measurements under the frozen workload/boundary |
| Provenance | source/tool/version identity and reproducible transition |
| Acceptance | authorized project/human decision |

No witness automatically upgrades another class.

## Gate algebra

```
G = {H, M, F, X, O, P, V, A}
```

H=intent/authority, M=model, F=formal, X=external observation,
O=operational, P=performance, V=provenance, A=authorized acceptance.

For task t:

```
complete(t) :=
  required(t) is a subset of currently_valid_passes(t)
  and no blocker intersects the scope of any claimed result
```

A pass carries its actual evidence, subject revision and scope. A historical pass
whose dependencies changed is not a currently valid pass. Adding an irrelevant
passed check does not make a claim stronger. A requirements change must identify
which completion criterion changed and who authorized it.

## Status

Task progress, verifier outcome, and human acceptance are different coordinates.
A task may be bound, active, blocked, rejected, complete or awaiting acceptance.

The task-machine outcomes in `agent-machine/MACHINE.bend` mean:

- Accepted: the protocol received a revision-matched Pass and retained its output
  and evidence. This constructor is not independent scientific truth or human
  acceptance.
- Exhausted: the repair allowance was consumed; the final verification failed.
  The final output, evidence and defects remain available.
- Blocked: observation was unavailable, metadata did not bind to the subject,
  or repair produced no new revision. This is not a theorem refutation.

All machine outcomes retain attempt history. An exhausted run can later resume
under a newly authorized budget; the old evidence is not rewritten into a pass.
Promoting a reusable lesson to durable documentation is a separate action, not an
increase in certainty about the underlying result.

## Law hierarchy

### Meta-law

`LAW.bend` states the claim-certificate policy. It is human-controlled and
content-addressed through `LAW.IMMUTABLE`. Its nine open laws are not proved by
the identity/type-shape workflow. Do not describe that workflow as enforcement of
every claim made by an agent.

### Object laws

The root `LAWS.bend` states Keccak-specific mathematical obligations over the
actual public implementation and specification. Root `PROOF.bend` supplies them.

`agent-machine/LAWS.bend` and its paired proof are a separate object-level
contract for rendering and terminal evidence preservation. Read their exact
quantifiers; a concrete IO specialization requires its own execution check.

The meta-policy, Keccak laws and task-machine laws are related but not substitutes
for one another. Do not weaken a law to repair a proof.

### Experiment contract

`benchmarks/research_contract.json` freezes the permitted Keccak experiment:
source surface, references, toolchain, workloads and evidence boundary. Changing
it creates a different experiment; it is not a routine source-only optimization.

## Refinement and evidence graph

```
human intent -> mathematical model -> object laws -> Bend proof -> formal claim
                     |
                     +-> public implementation -> runtime checks -> operational claim
                     |                         -> independent oracle -> empirical claim
                     |                         -> fixed benchmark -> performance claim
                     +-> source/tool identities -> provenance claim

required scoped claims + explicit authority -> acceptance decision
```

The arrows are dependencies, not equivalences. Runtime tests do not produce a
formal proof. A proof of a simplified model needs a representation bridge to the
public implementation before it supports a claim about that implementation.

## Scope rule

```
Scope = <time, population/input domain, environment, architecture, magnitude/workload>
```

Evidence supports only the dimensions it actually observes. A scope change needs
a new observation or a valid transfer theorem. Similar names do not establish
that transfer. A positive result on agent-authored fixtures is not a blind-agent
or held-out-task evaluation.

## Dependency invalidation

For artifact a, let deps(a) be its consuming claims. Changing a invalidates those
claims and their transitive consumers, not unrelated observations.

- A proof change without a law/implementation change does not erase historical
  empirical vectors, though an aggregate registered gate may need to rerun.
- Implementation changes invalidate dependent proof/runtime/benchmark receipts.
- Workload changes invalidate affected timing comparisons, not unchanged theorems.
- Oracle changes invalidate oracle-backed observations, not internal refinement.
- Navigation changes do not change program semantics, but can invalidate control
  claims and how an agent interprets an acceptance condition.

The declared dependency closure must cover actual inputs. Unknown closure is a
reason to invalidate conservatively, not to reuse an unsupported receipt.

## Control objective

Choose the cheapest authorized action whose possible outcomes can change the
next decision or establish a requested criterion. Consider information gained,
dependency reach, reversibility, cost and delay without inventing numerical
scores for them.

```
What cheapest observation could falsify the current model?
```

Prewalk independent routes only as far as needed to answer that question. Link
routes when one requires another's result. Do not execute all routes by default,
and do not repeat a failed action under unchanged conditions.

## Representation rule

A representation must preserve the distinctions its consumer needs. For a
lossless representation:

```
decode(encode(x)) = x
```

A deliberately lossy view instead needs an explicit relation showing preservation
of the relevant property. A round trip alone does not establish operational
behavior, performance or correspondence to an external artifact.

## Resource classes

This is the same default order as `SYSTEM.md` and `.agents/MANIFEST.json`:

```
targeted_read
< static_check
< focused_proof_or_test
< finite_independent_validation
< build_runtime
< full_validation
< benchmark
< external_confirmation
```

It is a default cost preference, not a universal dependency order. Build first
when a concrete test requires an executable. Record the dependency that overrides
the preference. Do not run broad validation before an available cheaper action
that already decides the live uncertainty.

## Gate receipts and reuse

The canonical claim/dependency registry is `.agents/CLAIMS.json`; the recorder is
`.agents/bin/gate-receipt.sh`. [The receipt contract](evidence/README.md) defines
schema-2 recording, inventories, failure classes and CLI behavior.

The inventory includes declared files and directory contents, including new or
ignored files under selected directories, plus their content identities and
executable modes. Missing tracked inputs, symlinks and corrupt receipts fail
closed. A Git commit ID alone does not identify uncommitted bytes.

A receipt retains claim definition, source tree, dependency identities, recorder
identity, tool version, execution context, command, result, log, evidence URI and
scope. `run` executes the command and compares input identities before and after;
`emit` only records assertions.

Freshness means identity agreement for the declared dependency/claim/recorder
state. Reuse additionally requires successful executed status and explicit
matching tool and context. A fresh failure is not usable. A missing receipt is
not success. `usable=true` is not authentication: its origin, scope and raw
observation still require review. See the linked receipt contract rather than
copying a second schema here.

```
changed dependency/claim/recorder -> affected receipt stale -> rerun affected gate
same source but wrong tool/context or failed run -> not reusable
```

Neither receipt bookkeeping nor a typed Evidence value establishes that an
observer is independent. That condition must be supplied and checked at the
external observer boundary.
