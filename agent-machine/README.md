# Evidence-bearing Bend task machine

## Run

Use the pinned official Bend 2.0.27 release. From this directory:

```sh
bend version
bend guide
bend PROOF.bend
bend TESTS.bend
```

MACHINE.bend contains the reusable IO protocol. RENDER.bend models the user's prose/code distinction. LAWS.bend states seven explicit obligations and PROOF.bend supplies them. TESTS.bend is a local protocol fixture, not an independent observer.

## Interface

`run(~I, ~O, ~E, ~D, ~identify, ~solve, ~verify, ~repair, fuel, input)`.

The three effectful operations have the user's roles: solve produces a candidate; verify produces evidence and defects; repair uses only the task, candidate and reported defects. The added pure `identify` function returns task ID, contract revision, artifact identity and artifact revision. Every reported Pass or Fail is checked against that subject. Empty witness IDs and report IDs are blocked. `Readback` and `Judgment` remain distinct evidence kinds; a formal Bend proof is neither.

The exact artifact revision is accepted, not an assertion that a mutable remote URL will keep that revision forever. The adapter must read the real artifact, cover all runtime criteria, authenticate the observer, prevent self-review when independence is required, and handle concurrent writes. Metadata equality is not authentication or scientific truth.

## Outcomes and resources

- Accepted retains the final output and evidence.
- Exhausted retains the last output, evidence and defects.
- Blocked retains the output and reason when observation is unavailable, metadata mismatches, or repair leaves the artifact revision unchanged.
- Every outcome retains reverse-chronological attempt history, including failures and rejected reports.

Zero fuel still verifies once. Each recursive continuation consumes one repair allowance; at most fuel repairs and fuel+1 controller verification calls are possible if callbacks return. The checker enforces structural recursion. The checked laws cover rendering, terminal data preservation, and invalid-binding rejection; they are not a separate universal theorem over the host IO runtime's effect counts. TESTS.bend observes representative callback counts. Fuel does not bound callback duration, internal retries, API cost, or hidden side effects. Adapters require their own deadlines and idempotency controls. Audit size grows with attempts and candidate size: production outputs should normally be immutable references, not large duplicated documents.

## Google Docs mapping — not implemented

I: task ID, frozen criteria revision, title, requirements, criterion IDs.
O: document URL/ID and exact revision.
E: readback or independent judgment payload; an Evidence envelope includes observer and report ID.
D: criterion ID, location, observed value, expected value.

A Docs adapter must store the candidate, read the actual stored structure, obtain any required independent semantic judgment, and return Pass only when every fixed criterion is covered for the same revision. A network failure returns Unavailable, not Fail with fabricated defects. No Google/Gemini adapter, credentials, external write, custom C effect or JavaScript effect is included.

The Code -> CodeBlock theorem concerns internal Bend values only. It says nothing by itself about what Google stored or rendered. Holdout task performance and fresh-agent usability remain external tests, not consequences of compilation.
