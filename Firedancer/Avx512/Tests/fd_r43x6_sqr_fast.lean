module

public import Firedancer.Avx512.fd_r43x6_sqr_fast

meta import Firedancer.Avx512.fd_r43x6_sqr_fast

namespace MLIR.Firedancer.Avx512

private def p : Nat :=
  2 ^ 255 - 19

/-- The field element of lanes `0 … 5`, radix `2^43`, mod `p`. -/
private def value (v : Wwl) : Nat :=
  (List.range 6).foldl (fun acc i => acc + v[i]!.toNat * 2 ^ (43 * i)) 0 % p

/-- The result if it is `spec x`, else `none`. -/
private def out (x : Wwl) : Option Wwl :=
  match fd_r43x6_sqr_fast.eval 1 (fd_r43x6_sqr_fast.args (Ty.wrap x)) ⟨⟨1⟩, ⟨∅⟩⟩ with
  | .value (some (.cons r .nil), _) =>
    if r == Ty.wrap (fd_r43x6_sqr_fast.spec x) then some (fd_r43x6_sqr_fast.spec x) else none
  | _ => none

/-- `spec x` is the square mod `p`, with lanes 6 and 7 zero. -/
private def check (x : Wwl) : Bool :=
  match out x with
  | some z => value z == value x * value x % p && z[6] == 0 && z[7] == 0
  | none => false

#guard check #v[1, 2, 3, 4, 5, 6, 0, 0]

#guard check #v[2 ^ 47 - 1, 2 ^ 47 - 1, 2 ^ 47 - 1, 2 ^ 47 - 1, 2 ^ 47 - 1, 2 ^ 47 - 1, 0, 0]

#guard
  check #v[0x123456789ABC, 0x7FEDCBA98765, 0x1F2E3D4C5B6A, 0x0A1B2C3D4E5F, 0x665544332211,
    0x777777777777, 0, 0]

-- any lanes: the program is the spec
#guard (out #v[-1, -2, -3, -4, -5, -6, -7, -8]).isSome

end MLIR.Firedancer.Avx512
