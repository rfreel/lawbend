import Base
import ../../lib/order.bend as Ord
import ./main.bend as R
import ./LAWS.bend as Laws

def Laws.reject_is_identity(s):
  match s:
    case R.Draft{}:
      {==}
    case R.Shadow{}:
      {==}
    case R.Canary{}:
      {==}
    case R.Limited{}:
      {==}
    case R.Full{}:
      {==}

def Laws.never_decreases(s, ok):
  match s ok:
    case R.Draft{} False{}:
      Unit{}
    case R.Draft{} True{}:
      Unit{}
    case R.Shadow{} False{}:
      Unit{}
    case R.Shadow{} True{}:
      Unit{}
    case R.Canary{} False{}:
      Unit{}
    case R.Canary{} True{}:
      Unit{}
    case R.Limited{} False{}:
      Unit{}
    case R.Limited{} True{}:
      Unit{}
    case R.Full{} False{}:
      Unit{}
    case R.Full{} True{}:
      Unit{}

def Laws.never_skips_more_than_one(s, ok):
  match s ok:
    case R.Draft{} False{}:
      Unit{}
    case R.Draft{} True{}:
      Unit{}
    case R.Shadow{} False{}:
      Unit{}
    case R.Shadow{} True{}:
      Unit{}
    case R.Canary{} False{}:
      Unit{}
    case R.Canary{} True{}:
      Unit{}
    case R.Limited{} False{}:
      Unit{}
    case R.Limited{} True{}:
      Unit{}
    case R.Full{} False{}:
      Unit{}
    case R.Full{} True{}:
      Unit{}

def Laws.full_is_absorbing(ok):
  match ok:
    case False{}:
      {==}
    case True{}:
      {==}
