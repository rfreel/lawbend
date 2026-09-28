import Base
import ../../lib/order.bend as Ord
import ./main.bend as E

law reject_is_identity:
  for current: Nat
  for -epoch: Nat
  {E.apply(current, epoch, E.Reject{}) == current : Nat}

law never_decreases:
  for current: Nat
  for -epoch: Nat
  for d: E.Decision<current, epoch>
  Ord.LE(current, E.apply(current, epoch, d))

law epoch_can_be_relabelled:
  for -current: Nat
  for -from_epoch: Nat
  for -to_epoch: Nat
  for c: E.Candidate<current, from_epoch>
  E.Candidate<current, to_epoch>
