# Bounded solver / observer / repair protocol. No custom foreign effects.
import Base

type Subject is Data:
  Subject{task: String, contract: String, artifact: String, revision: String}

type ObservationKind is Data:
  Readback{}
  Judgment{}

type Evidence<-E: Data> is Data:
  Evidence{subject: Subject, observer: String, report: String,
           kind: ObservationKind, payload: E}

type Verdict<-E: Data, -D: Data> is Data:
  Pass{evidence: Evidence<E>}
  Fail{evidence: Evidence<E>, defects: List<&2, D>}
  Unavailable{reason: String}

type Attempt<-O: Data, -E: Data, -D: Data> is Data:
  Attempt{output: O, verdict: Verdict<E, D>}

type Outcome<-O: Data, -E: Data, -D: Data> is Data:
  Accepted{output: O, evidence: Evidence<E>, audit: List<&2, Attempt<O, E, D>>}
  Exhausted{output: O, evidence: Evidence<E>, defects: List<&2, D>,
            audit: List<&2, Attempt<O, E, D>>}
  Blocked{output: O, reason: String, audit: List<&2, Attempt<O, E, D>>}

def nonempty_result(empty: Bool) -> Bool:
  match empty:
    case True{}: False{}
    case False{}: True{}

def nonempty(s: String) -> Bool:
  nonempty_result(String.is_empty(s))

def same_subject(a: Subject, b: Subject) -> Bool:
  match a b:
    case Subject{t, c, artifact, r} Subject{t2, c2, artifact2, r2}:
      String.eq(t, t2) && String.eq(c, c2) &&
      String.eq(artifact, artifact2) && String.eq(r, r2)

def valid_subject(s: Subject) -> Bool:
  match s:
    case Subject{t, c, a, r}:
      nonempty(t) && nonempty(c) && nonempty(a) && nonempty(r)

# Matching metadata neither authenticates the observer nor makes a report true.
def valid_evidence(~E: Data, +expected: Subject, evidence: Evidence<E>) -> Bool:
  match evidence:
    case Evidence{actual, observer, report, kind, payload}:
      valid_subject(expected) && same_subject(expected, actual) &&
      nonempty(observer) && nonempty(report)

def guard_status(~E: Data, ~D: Data, valid: Bool,
                 verdict: Verdict<E, D>) -> Verdict<E, D>:
  match valid:
    case True{}: verdict
    case False{}: Unavailable{"evidence identity mismatch or missing witness metadata"}

def guard(~E: Data, ~D: Data, expected: Subject,
          verdict: Verdict<E, D>) -> Verdict<E, D>:
  match verdict:
    case Pass{+evidence}:
      guard_status(~E, ~D, valid_evidence(~E, expected, evidence), Pass{evidence})
    case Fail{+evidence, defects}:
      guard_status(~E, ~D, valid_evidence(~E, expected, evidence), Fail{evidence, defects})
    case Unavailable{reason}:
      Unavailable{reason}

def finish(~O: Data, ~E: Data, ~D: Data,
           candidate: O, verdict: Verdict<E, D>,
           audit: List<&2, Attempt<O, E, D>>) -> IO(Outcome<O, E, D>):
  match verdict:
    case Pass{evidence}:
      IO.pure(Outcome<O, E, D>, Accepted{candidate, evidence, audit})
    case Fail{evidence, defects}:
      IO.pure(Outcome<O, E, D>, Exhausted{candidate, evidence, defects, audit})
    case Unavailable{reason}:
      IO.pure(Outcome<O, E, D>, Blocked{candidate, reason, audit})

def resume(~O: Data, ~E: Data, ~D: Data,
           unchanged: Bool, candidate: O, audit: List<&2, Attempt<O, E, D>>,
           continue: O -> List<&2, Attempt<O, E, D>> -> IO(Outcome<O, E, D>))
           -> IO(Outcome<O, E, D>):
  match unchanged:
    case True{}:
      IO.pure(Outcome<O, E, D>, Blocked{candidate, "repair produced no new artifact revision", audit})
    case False{}:
      continue(candidate, audit)

# Make reuse of an IO-produced Data value explicit at a parameter boundary.
def after_repair(~I: Data, ~O: Data, ~E: Data, ~D: Data,
                 ~identify: I -> O -> Subject,
                 +input: I, previous: O, +next: O,
                 audit: List<&2, Attempt<O, E, D>>,
                 continue: O -> List<&2, Attempt<O, E, D>> -> IO(Outcome<O, E, D>))
                 -> IO(Outcome<O, E, D>):
  resume(~O, ~E, ~D,
    same_subject(identify(input, previous), identify(input, next)),
    next, audit, continue)

def advance(~I: Data, ~O: Data, ~E: Data, ~D: Data,
            ~identify: I -> O -> Subject,
            ~repair: I -> O -> List<&2, D> -> IO(O),
            +input: I, +candidate: O, verdict: Verdict<E, D>,
            audit: List<&2, Attempt<O, E, D>>,
            continue: O -> List<&2, Attempt<O, E, D>> -> IO(Outcome<O, E, D>))
            -> IO(Outcome<O, E, D>):
  match verdict:
    case Pass{evidence}:
      IO.pure(Outcome<O, E, D>, Accepted{candidate, evidence, audit})
    case Fail{evidence, defects}:
      do IO<Outcome<O, E, D>>:
        next : O <- repair(input, candidate, defects)
        after_repair(~I, ~O, ~E, ~D, ~identify, input, candidate, next, audit, continue)
    case Unavailable{reason}:
      IO.pure(Outcome<O, E, D>, Blocked{candidate, reason, audit})

def checked_zero(~O: Data, ~E: Data, ~D: Data,
                 expected: Subject, +candidate: O, +verdict: Verdict<E, D>,
                 audit: List<&2, Attempt<O, E, D>>) -> IO(Outcome<O, E, D>):
  finish(~O, ~E, ~D, candidate, guard(~E, ~D, expected, verdict),
         Con{Attempt{candidate, verdict}, audit})

def checked_more(~I: Data, ~O: Data, ~E: Data, ~D: Data,
                 ~identify: I -> O -> Subject,
                 ~repair: I -> O -> List<&2, D> -> IO(O),
                 +input: I, +candidate: O, +verdict: Verdict<E, D>,
                 audit: List<&2, Attempt<O, E, D>>,
                 continue: O -> List<&2, Attempt<O, E, D>> -> IO(Outcome<O, E, D>))
                 -> IO(Outcome<O, E, D>):
  advance(~I, ~O, ~E, ~D, ~identify, ~repair, input, candidate,
    guard(~E, ~D, identify(input, candidate), verdict),
    Con{Attempt{candidate, verdict}, audit}, continue)

# fuel bounds controller repairs, not callback duration or hidden adapter work.
def loop(~I: Data, ~O: Data, ~E: Data, ~D: Data,
         ~identify: I -> O -> Subject,
         ~verify: I -> O -> IO(Verdict<E, D>),
         ~repair: I -> O -> List<&2, D> -> IO(O),
         fuel: Nat, +input: I, +candidate: O,
         audit: List<&2, Attempt<O, E, D>>) -> IO(Outcome<O, E, D>):
  match fuel:
    case 0n:
      do IO<Outcome<O, E, D>>:
        verdict : Verdict<E, D> <- verify(input, candidate)
        checked_zero(~O, ~E, ~D, identify(input, candidate), candidate, verdict, audit)
    case 1n+rest:
      do IO<Outcome<O, E, D>>:
        verdict : Verdict<E, D> <- verify(input, candidate)
        checked_more(~I, ~O, ~E, ~D, ~identify, ~repair,
          input, candidate, verdict, audit,
          next => history => loop(~I, ~O, ~E, ~D, ~identify, ~verify, ~repair,
                                  rest, input, next, history))

def run(~I: Data, ~O: Data, ~E: Data, ~D: Data,
        ~identify: I -> O -> Subject,
        ~solve: I -> IO(O),
        ~verify: I -> O -> IO(Verdict<E, D>),
        ~repair: I -> O -> List<&2, D> -> IO(O),
        fuel: Nat, +input: I) -> IO(Outcome<O, E, D>):
  do IO<Outcome<O, E, D>>:
    candidate : O <- solve(input)
    loop(~I, ~O, ~E, ~D, ~identify, ~verify, ~repair, fuel, input, candidate, Nil{})
