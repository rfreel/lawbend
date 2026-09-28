import Base

law LE:
  for a: Nat
  for b: Nat
  Type

def LE(a, b):
  match a b:
    case 0n y:
      Unit
    case 1n+x 0n:
      Empty
    case 1n+x 1n+y:
      LE(x, y)

law refl:
  for a: Nat
  LE(a, a)

def refl(a):
  match a:
    case 0n:
      Unit{}
    case 1n+x:
      refl(x)

law step:
  for a: Nat
  for b: Nat
  for e: LE(a, b)
  LE(a, 1n+b)

def step(a, b, e):
  match a:
    case 0n:
      Unit{}
    case 1n+x:
      match b:
        case 0n:
          Empty.absurd(LE(x, 0n), e)
        case 1n+y:
          step(x, y, e)

law trans:
  for a: Nat
  for b: Nat
  for c: Nat
  for ab: LE(a, b)
  for bc: LE(b, c)
  LE(a, c)

def trans(a, b, c, ab, bc):
  match a:
    case 0n:
      Unit{}
    case 1n+x:
      match b:
        case 0n:
          Empty.absurd(LE(1n+x, c), ab)
        case 1n+y:
          match c:
            case 0n:
              Empty.absurd(LE(1n+x, 0n), bc)
            case 1n+z:
              trans(x, y, z, ab, bc)
