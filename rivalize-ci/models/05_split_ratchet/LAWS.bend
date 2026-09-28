import Base
import ../../lib/order.bend as Ord
import ./main.bend as R

law reject_is_identity:
  for s: R.Stage
  {R.advance(s, False{}) == s : R.Stage}

law never_decreases:
  for s: R.Stage
  for ok: Bool
  Ord.LE(R.rank(s), R.rank(R.advance(s, ok)))

law never_skips_more_than_one:
  for s: R.Stage
  for ok: Bool
  Ord.LE(R.rank(R.advance(s, ok)), 1n+R.rank(s))

law full_is_absorbing:
  for ok: Bool
  {R.advance(R.Full{}, ok) == R.Full{} : R.Stage}
