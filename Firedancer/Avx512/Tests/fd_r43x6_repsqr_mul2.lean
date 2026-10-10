module

public import Firedancer.Avx512.fd_r43x6_repsqr_mul2

meta import Firedancer.Avx512.fd_r43x6_repsqr_mul2

namespace MLIR.Firedancer.Avx512

private def p : Nat :=
  2 ^ 255 - 19

/-- The field element of lanes `0 … 5`, radix `2^43`, mod `p`. -/
private def value (v : Wwl) : Nat :=
  (List.range 6).foldl (fun acc i => acc + v[i]!.toNat * 2 ^ (43 * i)) 0 % p

/-- `N` as unreduced lanes: 43-bit limbs, then one unit of each limb pushed down a lane, so the
folds have carries everywhere. -/
private def unreduced (N : Nat) : Wwl :=
  let l := (List.range 6).map fun i => if i < 5 then N / 2 ^ (43 * i) % 2 ^ 43 else N / 2 ^ 215
  let l :=
    (List.range 6).map fun i =>
      l[i]! + (if i < 5 ∧ l[i + 1]! > 0 then 2 ^ 43 else 0) - (if 0 < i ∧ l[i]! > 0 then 1 else 0)
  Vector.ofFn fun i => if i.val < 6 then BitVec.ofNat 64 l[i.val]! else 0

private def za : Pointer :=
  ⟨⟨0⟩, 0⟩

private def zb : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- Two zeroed 64-byte blocks. -/
private def state : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, .ofBytes 64 0), (⟨1⟩, .ofBytes 64 0)]⟩⟩

/-- `*_za` and `*_zb` hold `spec` of each side, `xa^(2^n) ya` and `xb^(2^n) yb` mod `p`. -/
private def check (xa ya xb yb n : Nat) : Bool :=
  let (xa, ya, xb, yb) := (unreduced xa, unreduced ya, unreduced xb, unreduced yb)
  match
    fd_r43x6_repsqr_mul2.eval (n + 3)
      (fd_r43x6_repsqr_mul2.args (.value za) (Ty.wrap xa) (Ty.wrap ya) (.value zb) (Ty.wrap xb)
        (Ty.wrap yb) (.value (BitVec.ofNat 64 n)))
      state with
  | .value (some .nil, s') =>
    let ra := s'.mem.readVec za
    let rb := s'.mem.readVec zb
    ra == fd_r43x6_repsqr_mul2.spec xa ya n && rb == fd_r43x6_repsqr_mul2.spec xb yb n &&
      value ra == value xa ^ (2 ^ n) * value ya % p &&
      value rb == value xb ^ (2 ^ n) * value yb % p
  | _ => false

-- `n = 0` skips the loop; `n = 1, 3` run it
#guard check 3 5 7 11 0

#guard check 3 5 7 11 1

#guard check (2 ^ 250 + 12345) (2 ^ 200 + 1) (p - 1) (p - 2) 3

end MLIR.Firedancer.Avx512
