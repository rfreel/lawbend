import Base
import ../../lib/order.bend as Ord
import ./main.bend as PC

law never_decreases:
  for -current: Nat
  for c: PC.Candidate<current>
  Ord.LE(current, PC.commit(current, c))
