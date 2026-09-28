import Base
import ../../lib/order.bend as Ord
import ./main.bend as E
import ./LAWS.bend as Laws

def Laws.reject_is_identity(current, epoch):
  {==}

def Laws.never_decreases(current, epoch, d):
  match d:
    case E.Reject{}:
      Ord.refl(current)
    case E.Accept{candidate}:
      match candidate:
        case E.Candidate{next, evidence}:
          evidence

def Laws.epoch_can_be_relabelled(current, from_epoch, to_epoch, c):
  match c:
    case E.Candidate{next, evidence}:
      E.Candidate{next, evidence}
