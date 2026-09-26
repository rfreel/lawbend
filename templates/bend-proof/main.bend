import Base
import ./MODEL.bend as Model

def add_zero(x: Nat) -> Nat:
  Model.add_zero(x)

def main() -> Nat:
  add_zero(2n)
