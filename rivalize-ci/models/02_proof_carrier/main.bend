import Base
import ../../lib/order.bend as Ord

type Candidate<-current: Nat> is Type:
  Candidate{next: Nat, evidence: Ord.LE(current, next)}

def commit(-current: Nat, c: Candidate<current>) -> Nat:
  match c:
    case Candidate{next, evidence}:
      next
