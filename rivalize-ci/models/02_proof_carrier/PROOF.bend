import Base
import ../../lib/order.bend as Ord
import ./main.bend as PC
import ./LAWS.bend as Laws

def Laws.never_decreases(current, c):
  match c:
    case PC.Candidate{next, evidence}:
      evidence
