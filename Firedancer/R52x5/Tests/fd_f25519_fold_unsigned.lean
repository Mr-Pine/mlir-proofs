module

public import Firedancer.R52x5.fd_f25519_fold_unsigned

meta import Firedancer.R52x5.fd_f25519_fold_unsigned

namespace MLIR.Firedancer.R52x5

open Firedancer.Avx512 (Wwl)

/-- The element `Σ lane_i * 2^(51 i)` over lanes `0 … 4`, mod `p`. -/
private def value (x : Wwl) : Nat :=
  (List.range 5).foldl (fun acc i => acc + x[i]!.toNat * 2 ^ (51 * i)) 0 % (2 ^ 255 - 19)

/-- The result if it is `fold x`, else `none`. -/
private def out (x : Wwl) : Option Wwl :=
  match fd_f25519_fold_unsigned.eval 1 (fd_f25519_fold_unsigned.args (Ty.wrap x)) ⟨⟨1⟩, ⟨∅⟩⟩ with
  | .value (some (.cons r .nil), _) => if r == Ty.wrap (fold x) then some (fold x) else none
  | _ => none

/-- `fold x` keeps `x`'s value (lanes below `2^63`), lanes 0-4 below `2^52`, 5-7 zero. -/
private def check (x : Wwl) : Bool :=
  match out x with
  | some z =>
    value z == value x && (List.range 5).all (fun i => z[i]!.toNat < 2 ^ 52) && z[5] == 0 &&
      z[6] == 0 &&
      z[7] == 0
  | none => false

-- small limbs stay; carries move up, limb 4's times 19 into limb 0
#guard out #v[1, 2, 3, 4, 5, 0, 0, 0] == some #v[1, 2, 3, 4, 5, 0, 0, 0]

#guard out #v[2 ^ 51, 0, 0, 0, 2 ^ 51, 0, 0, 0] == some #v[19, 1, 0, 0, 0, 0, 0, 0]

#guard check #v[2 ^ 63 - 1, 2 ^ 63 - 1, 2 ^ 63 - 1, 2 ^ 63 - 1, 2 ^ 63 - 1, 0, 0, 0]

#guard
  check
    #v[0x123456789ABCDEF, 0x7FEDCBA987654321, 0x1F2E3D4C5B6A7988, 0x0A1B2C3D4E5F6071,
      0x6655443322110099, 0, 0, 0]

-- lanes 5-7 are dropped
#guard out #v[0, 0, 0, 0, 0, 7, 8, 9] == some #v[0, 0, 0, 0, 0, 0, 0, 0]

end MLIR.Firedancer.R52x5
