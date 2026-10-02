# Regression contract: the user's loop retains the FINAL verifier evidence and
# FINAL defects, including the zero-fuel verification. These fixtures test that
# protocol; they are not independent observations about an external artifact.
import Base
import ./MACHINE.bend as M

def identify(input: Nat, candidate: Nat) -> M.Subject:
  M.Subject{Nat.show(input), "evidence-test-v1", "candidate", Nat.show(candidate)}

def evidence(input: Nat, +candidate: Nat) -> M.Evidence<Nat>:
  M.Evidence{identify(input, candidate), "fixture-not-independent",
             "r" ++ Nat.show(candidate), M.Readback{}, Nat.add(100n, candidate)}

def choose(ok: Bool, e: M.Evidence<Nat>, defect: Nat) -> M.Verdict<Nat, Nat>:
  match ok:
    case True{}: M.Pass{e}
    case False{}: M.Fail{e, [defect]}

def solve(input: Nat) -> IO(Nat):
  IO.pure(Nat, 0n)

def verify_values(+input: Nat, +candidate: Nat) -> IO(M.Verdict<Nat, Nat>):
  IO.pure(M.Verdict<Nat, Nat>,
    choose(Nat.is_eq(input, candidate), evidence(input, candidate),
           Nat.add(200n, candidate)))

def verify(input: Nat, candidate: Nat) -> IO(M.Verdict<Nat, Nat>):
  verify_values(input, candidate)

def repair(input: Nat, candidate: Nat, defects: List<&2, Nat>) -> IO(Nat):
  IO.pure(Nat, 1n+candidate)

def forbidden_repair(input: Nat, candidate: Nat, defects: List<&2, Nat>) -> IO(Nat):
  IO.die(Nat, 93, "FAIL: a repair ran without permission or after acceptance")

def numbers(xs: List<&2, Nat>) -> String:
  match xs:
    case Nil{}: ""
    case Con{head, tail}: Nat.show(head) ++ "," ++ numbers(tail)

def stamp(e: M.Evidence<Nat>) -> String:
  match e:
    case M.Evidence{subject, observer, report, kind, payload}:
      report ++ ":" ++ Nat.show(payload)

def verdict_stamp(v: M.Verdict<Nat, Nat>) -> String:
  match v:
    case M.Pass{e}: "P" ++ stamp(e)
    case M.Fail{e, defects}: "F" ++ stamp(e) ++ ":" ++ numbers(defects)
    case M.Unavailable{reason}: "U" ++ reason

def history(xs: List<&2, M.Attempt<Nat, Nat, Nat>>) -> String:
  match xs:
    case Nil{}: ""
    case Con{M.Attempt{output, verdict}, tail}:
      Nat.show(output) ++ ">" ++ verdict_stamp(verdict) ++ ";" ++ history(tail)

def summarize(outcome: M.Outcome<Nat, Nat, Nat>) -> String:
  match outcome:
    case M.Accepted{output, e, audit}:
      "A|" ++ Nat.show(output) ++ "|" ++ stamp(e) ++ "|" ++ history(audit)
    case M.Exhausted{output, e, defects, audit}:
      "X|" ++ Nat.show(output) ++ "|" ++ stamp(e) ++ "|" ++ numbers(defects) ++ "|" ++ history(audit)
    case M.Blocked{output, reason, audit}:
      "B|" ++ Nat.show(output) ++ "|" ++ reason ++ "|" ++ history(audit)

def require(ok: Bool, label: String) -> IO(Unit):
  match ok:
    case True{}: IO.print("PASS: " ++ label)
    case False{}: IO.die(Unit, 94, "FAIL: " ++ label)

def check(outcome: M.Outcome<Nat, Nat, Nat>, expected: String, label: String) -> IO(Unit):
  require(String.eq(summarize(outcome), expected), label)

def main() -> IO(Unit):
  do IO<Unit>:
    a : M.Outcome<Nat, Nat, Nat> <- M.run(~Nat, ~Nat, ~Nat, ~Nat, ~identify, ~solve, ~verify, ~forbidden_repair, 0n, 0n)
    check(a, "A|0|r0:100|0>Pr0:100;", "zero-fuel-accepted")
    b : M.Outcome<Nat, Nat, Nat> <- M.run(~Nat, ~Nat, ~Nat, ~Nat, ~identify, ~solve, ~verify, ~forbidden_repair, 0n, 2n)
    check(b, "X|0|r0:100|200,|0>Fr0:100:200,;", "zero-fuel-exhausted")
    c : M.Outcome<Nat, Nat, Nat> <- M.run(~Nat, ~Nat, ~Nat, ~Nat, ~identify, ~solve, ~verify, ~repair, 1n, 1n)
    check(c, "A|1|r1:101|1>Pr1:101;0>Fr0:100:200,;", "last-allowance-accepted")
    d : M.Outcome<Nat, Nat, Nat> <- M.run(~Nat, ~Nat, ~Nat, ~Nat, ~identify, ~solve, ~verify, ~repair, 3n, 2n)
    check(d, "A|2|r2:102|2>Pr2:102;1>Fr1:101:201,;0>Fr0:100:200,;", "accepted-retains-final-evidence-and-history")
    e : M.Outcome<Nat, Nat, Nat> <- M.run(~Nat, ~Nat, ~Nat, ~Nat, ~identify, ~solve, ~verify, ~repair, 2n, 6n)
    check(e, "X|2|r2:102|202,|2>Fr2:102:202,;1>Fr1:101:201,;0>Fr0:100:200,;", "exhausted-retains-final-evidence-and-defects")
    f : M.Outcome<Nat, Nat, Nat> <- M.run(~Nat, ~Nat, ~Nat, ~Nat, ~identify, ~solve, ~verify, ~forbidden_repair, 3n, 0n)
    check(f, "A|0|r0:100|0>Pr0:100;", "early-pass-does-not-repair")
