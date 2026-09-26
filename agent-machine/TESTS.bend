# Protocol fixtures only. These are NOT independent scientific witnesses.
import Base
import ./MACHINE.bend as M

def identify(input: Nat, candidate: Nat) -> M.Subject:
  M.Subject{Nat.show(input), "fixture-contract-v1", "fixture-artifact", Nat.show(candidate)}

def evidence(input: Nat, candidate: Nat) -> M.Evidence<U32>:
  M.Evidence{identify(input, candidate), "local-fixture-not-independent", "fixture-report", M.Readback{}, 0}

def verdict(pass: Bool, e: M.Evidence<U32>) -> M.Verdict<U32, String>:
  match pass:
    case True{}: M.Pass{e}
    case False{}: M.Fail{e, ["candidate differs from requested value"]}

def solve(input: Nat) -> IO(Nat):
  IO.pure(Nat, 0n)

def verify_reusable(+input: Nat, +candidate: Nat) -> IO(M.Verdict<U32, String>):
  do IO<M.Verdict<U32, String>>:
    IO.print("verify")
    return verdict(Nat.is_eq(input, candidate), evidence(input, candidate))

# The callback contract is affine. Reuse is explicit inside the implementation.
def verify(input: Nat, candidate: Nat) -> IO(M.Verdict<U32, String>):
  verify_reusable(input, candidate)

def repair(input: Nat, candidate: Nat, defects: List<&2, String>) -> IO(Nat):
  do IO<Nat>:
    IO.print("repair")
    return 1n+candidate

def forbidden_repair(input: Nat, candidate: Nat, defects: List<&2, String>) -> IO(Nat):
  IO.die(Nat, 91, "repair must not be called in this case")

def unchanged_repair(input: Nat, candidate: Nat, defects: List<&2, String>) -> IO(Nat):
  do IO<Nat>:
    IO.print("repair")
    return candidate

def unavailable(input: Nat, candidate: Nat) -> IO(M.Verdict<U32, String>):
  do IO<M.Verdict<U32, String>>:
    IO.print("verify")
    return M.Unavailable{"observer unavailable"}

def stale(input: Nat, candidate: Nat) -> IO(M.Verdict<U32, String>):
  do IO<M.Verdict<U32, String>>:
    IO.print("verify")
    return M.Pass{M.Evidence{M.Subject{Nat.show(input), "fixture-contract-v1", "fixture-artifact", "wrong-revision"}, "fixture", "stale-report", M.Judgment{}, 0}}

def audit_length(xs: List<&2, M.Attempt<Nat, U32, String>>) -> Nat:
  match xs:
    case Nil{}: 0n
    case Con{head, tail}: 1n+audit_length(tail)

def show(outcome: M.Outcome<Nat, U32, String>) -> String:
  match outcome:
    case M.Accepted{output, e, audit}:
      "accepted:" ++ Nat.show(output) ++ ":" ++ Nat.show(audit_length(audit))
    case M.Exhausted{output, e, defects, audit}:
      "exhausted:" ++ Nat.show(output) ++ ":" ++ Nat.show(audit_length(audit))
    case M.Blocked{output, reason, audit}:
      "blocked:" ++ reason ++ ":" ++ Nat.show(audit_length(audit))

def main() -> IO(Unit):
  do IO<Unit>:
    a : M.Outcome<Nat, U32, String> <- M.run(~Nat, ~Nat, ~U32, ~String, ~identify, ~solve, ~verify, ~forbidden_repair, 0n, 0n)
    IO.print(show(a))
    b : M.Outcome<Nat, U32, String> <- M.run(~Nat, ~Nat, ~U32, ~String, ~identify, ~solve, ~verify, ~repair, 3n, 2n)
    IO.print(show(b))
    c : M.Outcome<Nat, U32, String> <- M.run(~Nat, ~Nat, ~U32, ~String, ~identify, ~solve, ~verify, ~repair, 3n, 6n)
    IO.print(show(c))
    d : M.Outcome<Nat, U32, String> <- M.run(~Nat, ~Nat, ~U32, ~String, ~identify, ~solve, ~verify, ~forbidden_repair, 0n, 1n)
    IO.print(show(d))
    e : M.Outcome<Nat, U32, String> <- M.run(~Nat, ~Nat, ~U32, ~String, ~identify, ~solve, ~stale, ~forbidden_repair, 3n, 0n)
    IO.print(show(e))
    f : M.Outcome<Nat, U32, String> <- M.run(~Nat, ~Nat, ~U32, ~String, ~identify, ~solve, ~unavailable, ~forbidden_repair, 3n, 0n)
    IO.print(show(f))
    g : M.Outcome<Nat, U32, String> <- M.run(~Nat, ~Nat, ~U32, ~String, ~identify, ~solve, ~verify, ~unchanged_repair, 3n, 1n)
    IO.print(show(g))
