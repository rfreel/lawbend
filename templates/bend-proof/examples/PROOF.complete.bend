# Copy to the root as PROOF.bend to run the tutorial.
# The induction proof follows the official Bend 2.0.27 guide.
import Base
import ./LAWS.bend as Laws

def Laws.add_zero(x):
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Laws.add_zero(p) : {1n+Nat.add(p, 0n) == 1n+_ : Nat}
      {==}
