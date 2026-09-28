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
  match s ok:
    case Draft{} False{}:
      Draft{}
    case Draft{} True{}:
      Shadow{}
    case Shadow{} False{}:
      Shadow{}
    case Shadow{} True{}:
      Canary{}
    case Canary{} False{}:
      Canary{}
    case Canary{} True{}:
      Limited{}
    case Limited{} False{}:
      Limited{}
    case Limited{} True{}:
      Full{}
    case Full{} False{}:
      Full{}
    case Full{} True{}:
      Full{}
