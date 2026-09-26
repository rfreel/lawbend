# System model

This document is the compact mathematical/control model behind the repository.

## Task object

Treat every consequential task as:

```
Task = <Intent, Claims, RequiredGates, ReadSet, WriteSet, Budget, Evidence, Status>
```

The important property is that `RequiredGates` is a set. Work is not forced
through irrelevant stages.

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

A task may contain several claim classes. Each class has a different admissible
witness:

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

Let the gate universe be:

```
G = {H, M, F, X, O, P, V, A}
```

where H=intent, M=model, F=formal, X=external observation,
O=operational, P=performance, V=provenance, A=acceptance.

For task `t`:

```
complete(t) :=
  required(t) ⊆ passed(t)
  and no blocker intersects the scope of any claimed result
```

This is a partial order over evidence states rather than a single workflow.
Adding an irrelevant passed gate does not make a claim stronger.

## Status

```
Status =
  Unoriented
| Bound
| Active
| Candidate
| Blocked
| Rejected
| Accepted
| Accreted
```

- `Blocked` means a required transition cannot currently execute; it is not a
  failed theorem.
- `Rejected` means a discriminating gate produced counterevidence.
- `Accepted` means all required gates for the scoped claim passed.
- `Accreted` means reusable knowledge was promoted to the durable system.

## Law hierarchy

There are two distinct law planes in this repository.

### Meta-law

`LAW.bend` defines the claim-certificate policy: consequential rendered claims
must not outrun evidence, scope, provenance, or completion status. It is
human-controlled and content-addressed.

### Object law

`LAWS.bend` states Keccak-specific mathematical obligations over the actual
public implementation and specification. `PROOF.bend` supplies their proofs.

These are not duplicate law files. The meta-law governs how claims may be made;
the object law states what the Keccak implementation must satisfy.

### Experiment contract

`benchmarks/research_contract.json` is neither law plane. It freezes the
permitted optimization experiment: source surface, references, toolchain,
workloads, and evidence boundary. Changing it creates a different experiment.

## Refinement graph

```
human intent
    |
    v
mathematical/control model
    |
    +------> object laws --------> proof
    |                                |
    v                                v
public implementation ----------> formal claim
    |                                |
    +------> runtime tests ----------+
    |
    +------> independent oracle ----> empirical claim
    |
    +------> benchmark contract ----> performance claim
    |
    +------> source/version hash ---> provenance claim
                                     |
                                     v
                                  acceptance
```

The arrows are dependencies, not equivalences.

## Scope rule

Evidence supports only the dimensions it actually observes. Preserve at least:

```
Scope = <time, population/input domain, environment, architecture, magnitude/workload>
```

A change of scope requires a new observation or a valid theorem transferring
the property. Do not infer the transfer because names look similar.

## Dependency invalidation

For an artifact `a`, let `deps(a)` be the claims that consume it. When
`a` changes, invalidate only `deps(a)` and their transitive consumers.

Practical rules:

- changing a proof without changing laws does not invalidate empirical vectors;
- changing implementation invalidates dependent proof/runtime/benchmark results;
- changing benchmark workload invalidates performance conclusions, not the
  mathematical theorem;
- changing the external oracle invalidates oracle-backed observations, not the
  internal refinement proof;
- changing navigation/docs does not invalidate semantic claims unless it changes
  authority, contract, or interpretation.

## Control objective

Choose the next action `a` to maximize useful uncertainty removed per unit of
resource while preserving reversibility:

```
choose(a) ~ high(discrimination × dependency reach × reversibility)
            / cost
```

This is a qualitative ordering, not a fabricated numerical score.

The first useful question is therefore not "what can I run?" but:

```
What cheapest observation could prove my current model wrong?
```

## Representation rule

An alternate representation is useful only if its consumer-visible distinctions
can be recovered or proven irrelevant. Prefer explicit round-trip/refinement
relations over parallel synchronized descriptions.

For any representation bridge:

```
decode(encode(x)) = x
```

is the minimum useful shape; operational/performance properties still require
their own gates.

## Resource classes

```
Read < Check < FocusedProof/Test < FullValidation < Build < Benchmark < ExternalConfirm
```

Use the cheapest class capable of deciding the live uncertainty. Cache stable
facts such as the exact compiler command/version and re-run only when a
dependency changed.


## Gate receipts and freshness

A gate result is reusable only when the dependencies that define its claim have
not changed.

For registered claim `c`:

```
D(c) = ordered set of tracked dependency files
H(c) = sha256(sort(blob(file), path) for file in D(c))
```

A receipt records:

```
Receipt = <
  ClaimId,
  Gates,
  SourceTree,
  DependencySetHash,
  DependencyBlobs,
  ToolVersion,
  Command,
  Result,
  EvidenceURI,
  Scope
>
```

A receipt is **fresh** exactly when its recorded dependency-set hash equals the
current `H(c)`. Otherwise it is **stale**.

Freshness means only that the same gate observed the same declared dependency
state. It does not upgrade the epistemic class of the evidence.

The canonical dependency registry is `.agents/CLAIMS.json`. The executable
projection is `.agents/bin/gate-receipt.sh`.

This makes invalidation mechanical:

```
changed dependency
       ↓
H(c) changes
       ↓
receipt(c) = stale
       ↓
rerun only the gate(s) for c
```

Claims not consuming the changed dependency remain fresh.
