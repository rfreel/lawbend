import Base

type Stage is Data:
  Draft{}
  Shadow{}
  Canary{}
  Limited{}
  Full{}

def rank(s: Stage) -> Nat:
  match s:
    case Draft{}:
      0n
    case Shadow{}:
      1n
    case Canary{}:
      2n
    case Limited{}:
      3n
    case Full{}:
      4n

def advance(s: Stage, ok: Bool) -> Stage:
  match ok:
    case False{}:
      s
    case True{}:
      match s:
        case Draft{}:
          Shadow{}
        case Shadow{}:
          Canary{}
        case Canary{}:
          Limited{}
        case Limited{}:
          Full{}
        case Full{}:
          Full{}
