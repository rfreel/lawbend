# Example requirement from the official Bend 2.0.27 guide.
# Not a user-approved production specification. After adoption, do not weaken.
import Base
import ./main.bend as App

law add_zero:
  for x: Nat
  {App.add_zero(x) == x : Nat}
