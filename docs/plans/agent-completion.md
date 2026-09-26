# Agent-system completion plan

Goal: execute the authorized receipt, initializer, adversarial-use and integration steps without changing existing human laws or substituting another proof checker for Bend.

Basis: ROADMAP.md M2-M4; user authorization in this conversation. Base: d22f1d2384b092272b8bf301bb69606628bef720. M2 already exists; extend and test it rather than rebuilding from conversation memory.

## Design and scope

A receipt is a recorded observation, not a certificate of truth. Its dependency state, result, source identity and execution context are separate fields. Freshness alone must not authorize reuse of a failed run. Missing files, unknown claims and incomplete inventories must fail closed. Source-only freshness cannot establish environment equivalence.

The initializer copies a small standalone Bend project, uses the official pinned checker, keeps laws separate from proofs, and starts with an intentionally open proof. It must never overwrite an existing destination or silently authorize its own example law. A separate example supplies a proof for the exact copied law. The real checker must accept it and reject an incorrect replacement. No Python, C, Java or alternate formal verifier is introduced. Shell is limited to filesystem, Git, installation and checker orchestration; jq handles receipt data.

Formal and external evidence remain different claims. An empty evidence directory does not count as empirical verification. Acceptance of a generated law belongs to the user. No external data is uploaded or published by generated code.

## Alternatives prewalked

- Reuse existing receipts unchanged: cheapest, but fail-open process substitution and fresh failed runs are consequential risks; run negative cases first.
- Build a larger orchestrator/database: rejected; no necessary consumer.
- Add a small initializer plus direct checker tests: selected; tests clean directories, paths with spaces, missing toolchain, unchanged laws and rejection behavior.
- Claim fresh-agent usability from a clean runner: rejected; a runner is not a fresh agent. Keep that criterion unresolved unless independently exercised.

## Tasks

- [ ] 1. Add receipt regression cases. Observe existing failures. Repair inventories and explicit reuse status; preserve current CLI compatibility where safe.
- [ ] 2. Add initializer test. Observe missing initializer. Implement templates and non-overwriting copy command. Run official Bend 2.0.27 on a clean generated project, open proof, completed example and invalid proof.
- [ ] 3. Run boundary cases: missing/deleted/untracked/symlink dependencies, failed receipts, corrupt receipts, changed context, unrelated changes, existing destinations, missing compiler and law drift.
- [ ] 4. Update routing, trust boundaries, evidence records and roadmap using actual run results. Validate changed workflows and unchanged protected blobs.
- [ ] 5. Review exact PR head and merge only the stable tested scope under the user's authorization. Keep a separate blind-agent usability observation open; do not invent one.

## Completion evidence

Actual GitHub runner results at the committed head; official Bend release digest/version and checker logs; generated project files and unchanged law digest; receipt regression outputs; no claim of universal external financial truth or measured agent productivity.

## Review focus

1. Shell producer failure hidden by process substitution.
2. A failed but unchanged receipt appearing reusable.
3. Untracked/deleted/symlink files omitted from inventories.
4. A green starter concealing unapproved or open obligations.
5. Copy/install failures, incomplete output, and accidental overwrites.

Fresh-agent effectiveness remains a separate empirical acceptance criterion. No number of self-run fixtures establishes it.
