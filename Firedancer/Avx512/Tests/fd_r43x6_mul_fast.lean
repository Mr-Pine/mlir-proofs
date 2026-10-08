module

public import Firedancer.Avx512.fd_r43x6_mul_fast

meta import Firedancer.Avx512.fd_r43x6_mul_fast

namespace LeanMLIR.RIR.Firedancer.Avx512

private def p : Nat :=
  2 ^ 255 - 19

/-- The field element of lanes `0 … 5`, radix `2^43`, mod `p`. -/
private def value (v : Wwl) : Nat :=
  (List.range 6).foldl (fun acc i => acc + v[i]!.toNat * 2 ^ (43 * i)) 0 % p

/-- The result if it is `spec x y`, else `none`. -/
private def out (x y : Wwl) : Option Wwl :=
  match fd_r43x6_mul_fast.eval 1 (fd_r43x6_mul_fast.args (Ty.wrap x) (Ty.wrap y)) ⟨⟨1⟩, ⟨∅⟩⟩ with
  | .value (some (.cons r .nil), _) =>
    if r == Ty.wrap (fd_r43x6_mul_fast.spec x y) then some (fd_r43x6_mul_fast.spec x y) else none
  | _ => none

/-- `spec x y` is the product mod `p`, with lanes 6 and 7 zero. -/
private def check (x y : Wwl) : Bool :=
  match out x y with
  | some z => value z == value x * value y % p && z[6] == 0 && z[7] == 0
  | none => false

#guard check #v[1, 2, 3, 4, 5, 6, 0, 0] #v[7, 8, 9, 10, 11, 12, 0, 0]

-- `u47` limbs, the largest the header allows
#guard
  check #v[2 ^ 47 - 1, 2 ^ 47 - 1, 2 ^ 47 - 1, 2 ^ 47 - 1, 2 ^ 47 - 1, 2 ^ 47 - 1, 0, 0]
    #v[2 ^ 47 - 1, 2 ^ 47 - 1, 2 ^ 47 - 1, 2 ^ 47 - 1, 2 ^ 47 - 1, 2 ^ 47 - 1, 0, 0]

#guard
  check #v[0x123456789ABC, 0x7FEDCBA98765, 0x1F2E3D4C5B6A, 0x0A1B2C3D4E5F, 0x665544332211,
      0x777777777777, 0, 0]
    #v[0x3333333333, 0x5555555555, 0x7, 0x0, 0x1, 0x7FFFFFFFFFF, 0, 0]

-- lanes 6 and 7 of `x` are ignored
#guard out #v[1, 2, 3, 4, 5, 6, 99, 99] #v[1, 0, 0, 0, 0, 0, 0, 0] ==
  out #v[1, 2, 3, 4, 5, 6, 0, 0] #v[1, 0, 0, 0, 0, 0, 0, 0]

end LeanMLIR.RIR.Firedancer.Avx512
