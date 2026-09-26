# Intent

Status: tutorial only; not adopted as a production requirement.

Outcome: exercise intent -> model -> law -> proof on the official guide's natural-number addition example. The public add_zero function must return its input for every natural number.

Model: MODEL.bend uses Base.Nat. Formal statement: LAWS.bend quantifies over every Nat. Proof: PROOF.bend starts open. No external-world or performance conclusion follows from this example.

For real work the human owner replaces or explicitly adopts this intent and its law. Review the model and law together, record the decision, then update the law digest through an explicit requirements change. A successful checker run is not approval of intent.

The optional task-machine package adds the user's separate Code -> CodeBlock requirement and a generic solver/verifier/repair protocol. It does not supply an independent external observer.
