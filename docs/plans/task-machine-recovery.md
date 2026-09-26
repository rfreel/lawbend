# Task-machine recovery and final-evidence regression

## User contract

The supplied Verdict carries evidence on Pass and on Fail. Outcome retains the final candidate and the evidence from its final verification. Exhausted also retains the final defects. Zero fuel still verifies; each repair consumes one allowance. The independent origin of E is an adapter obligation, not a property implied by a type name.

## Recovered state

Recovery read the actual PR #2 head, 3a17e556324dbd9279d1b26bb5000bee3da2f213, rather than replaying earlier failed tool calls. That head already contains receipts, the standalone initializer, and the evidence-bearing Bend machine. Its five PR workflows finished successfully. The machine's documented additions are revision binding, Blocked outcomes, no-change detection, and retained attempt history. These remain distinct from the two-terminal-outcome sample supplied by the user.

## Remaining discriminator

The existing protocol fixture uses a constant evidence payload and its output summary ignores that payload. It observes control counts but cannot distinguish a previous report from the final report by payload. Add a second concrete Bend specialization with changing Nat payloads, changing report IDs, and changing defects. Do not change the user's laws, implementation, or acceptance criteria.

## Checks

1. Zero-fuel acceptance retains the first/final report and makes no repair.
2. Zero-fuel exhaustion retains final defects and evidence.
3. Acceptance on the last repair allowance still follows a final verification.
4. Acceptance after multiple repairs retains the final report and full attempt history.
5. Exhaustion after multiple repairs retains the last defects, not earlier defects.
6. Early acceptance does not use an available repair allowance.
7. A temporary implementation that discards final defects must reach a named Bend runtime assertion failure. Restore/unmodified source must pass again. A parser error or timeout does not count as rejection.

All new behavioral assertions run in Bend. Shell only launches Bend and identifies the diagnostic. Registered receipt dependencies include the new test so old protocol receipts become stale.

## Completion boundary

Observe current commit-specific GitHub jobs and retained receipts before integration. Do not substitute generated test cases for an independent scientific observer or a blind-agent holdout evaluation. A production external adapter, independently supplied holdout tasks, and comparative resource measurements remain separate requirements before claims about external accuracy or reduced operating cost.
