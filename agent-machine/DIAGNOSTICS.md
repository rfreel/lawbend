# Observed diagnostics

## Callback quantity mismatch

Observed with Bend 2.0.27 in GitHub run 36275716686: the seven laws checked, but TESTS.bend failed when instantiating run. The template expected `Nat -> Nat -> IO(...)`; the supplied callback had `@+input:Nat -> @+candidate:Nat -> IO(...)`.

These are different function types. Keep the callback's public parameters affine and forward each once to an internal helper that declares reusable Data parameters. Do not change the generic contract merely to fit one callback.

A successful proof file does not guarantee every dormant template specialization or runtime entry point compiles. Check the actual invocation as well as the proof entry.

## Missing dependency hidden by shell producer failure

Observed in the receipt regression run 36274870340: git reported a deleted source file, but the original receipt script still emitted a receipt because failures inside process substitutions did not reach the caller. Complete an inventory with explicit error checks before hashing or emitting. This is metadata plumbing, not a Bend proof result.

## Expected versus unexpected checker failure

An open law and an invalid proof both exit unsuccessfully, but missing executables, timeouts and parse failures are not proof refutations. Tests must first confirm a valid baseline, preserve the law, mutate the implementation or proof deliberately, and inspect the named failing obligation.
