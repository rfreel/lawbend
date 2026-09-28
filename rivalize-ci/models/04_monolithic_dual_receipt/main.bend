import Base
import ../../lib/order.bend as Ord

type ProofReceipt<-epoch: Nat> is Data:
  ProofReceipt{}

type ObservationReceipt<-epoch: Nat> is Data:
  ObservationReceipt{}

type Candidate<-current: Nat, -epoch: Nat> is Type:
  Candidate{next: Nat, evidence: Ord.LE(current, next)}

type Decision<-current: Nat, -epoch: Nat> is Type:
  Reject{}
  Accept{
    candidate: Candidate<current, epoch>,
    proof: ProofReceipt<epoch>,
    observation: ObservationReceipt<epoch>
  }

def apply(current: Nat, -epoch: Nat, d: Decision<current, epoch>) -> Nat:
  match d:
    case Reject{}:
      current
    case Accept{candidate, proof, observation}:
      match candidate:
        case Candidate{next, evidence}:
          next
