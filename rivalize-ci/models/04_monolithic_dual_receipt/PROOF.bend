import Base
import ../../lib/order.bend as Ord
import ./main.bend as M
import ./LAWS.bend as Laws

def Laws.never_decreases(current, epoch, d):
  match d:
    case M.Reject{}:
      Ord.refl(current)
    case M.Accept{candidate, proof, observation}:
      match candidate:
        case M.Candidate{next, evidence}:
          evidence

def Laws.receipts_are_forgeable(epoch):
  (M.ProofReceipt{}, M.ObservationReceipt{})
