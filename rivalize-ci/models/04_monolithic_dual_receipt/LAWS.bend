import Base
import ../../lib/order.bend as Ord
import ./main.bend as M

law never_decreases:
  for current: Nat
  for -epoch: Nat
  for d: M.Decision<current, epoch>
  Ord.LE(current, M.apply(current, epoch, d))

law receipts_are_forgeable:
  for -epoch: Nat
  M.ProofReceipt<epoch> & M.ObservationReceipt<epoch>
