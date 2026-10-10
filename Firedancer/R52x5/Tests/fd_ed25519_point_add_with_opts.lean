module

public import Firedancer.R52x5.fd_ed25519_point_add_with_opts

meta import Firedancer.R52x5.fd_ed25519_point_add_with_opts

namespace MLIR.Firedancer.R52x5

private def p : Nat :=
  2 ^ 255 - 19

/-- Limb `i` (51 bits) of `n`. -/
private def limb (n i : Nat) : BitVec 64 :=
  BitVec.ofNat 64 (n / 2 ^ (51 * i) % 2 ^ 51)

/-- The point `(x, y, z, t)` in the QUAD layout. -/
private def quad (x y z t : Nat) : Quad5 :=
  ⟨wl (limb x 0) (limb y 0) (limb z 0) (limb t 0), wl (limb x 1) (limb y 1) (limb z 1) (limb t 1),
    wl (limb x 2) (limb y 2) (limb z 2) (limb t 2), wl (limb x 3) (limb y 3) (limb z 3) (limb t 3),
    wl (limb x 4) (limb y 4) (limb z 4) (limb t 4)⟩

/-- Coordinate `j` of `Q` mod `p`. -/
private def val (Q : Quad5) (j : Nat) : Nat :=
  (Q.P0[j]!.toNat + 2 ^ 51 * Q.P1[j]!.toNat + 2 ^ 102 * Q.P2[j]!.toNat + 2 ^ 153 * Q.P3[j]!.toNat +
      2 ^ 204 * Q.P4[j]!.toNat) %
    p

/-- The base point's affine coordinates. -/
private def bx : Nat :=
  15112221349535400772501151409588531511454012693041857206046113283949847762202

private def «by» : Nat :=
  46316835694926478169428394003475163141307993866256225615783033603165251855960

/-- The base point, `Z = 1`. -/
private def P : Quad5 :=
  quad bx «by» 1 (bx * «by» % p)

/-- Not on the curve: only the bits are compared. -/
private def A : Quad5 :=
  quad 0x1234567890ABCDEF1234567890ABCDEF (2 ^ 255 - 20) 1 (2 ^ 200 + 12345)

/-- Blocks 0-3, a point each: `X` at 0, `Y` at 1, `Y`'s precomputed form at 2, 3 for the result. -/
private def state (X Y : Quad5) : GlobalState :=
  let m : MemoryState :=
    ⟨Std.ExtHashMap.ofList
        [(⟨0⟩, .ofBytes 192 0), (⟨1⟩, .ofBytes 192 0), (⟨2⟩, .ofBytes 192 0),
          (⟨3⟩, .ofBytes 192 0)]⟩
  ⟨⟨4⟩,
    ((m.storeQuad5 ⟨⟨0⟩, 0⟩ X).storeQuad5 ⟨⟨1⟩, 0⟩ Y).storeQuad5 ⟨⟨2⟩, 0⟩
      (fd_curve25519_into_precomputed.spec Y)⟩

/-- The point the code stores at `r`, if it returns `r`. -/
private def run (X Y : Quad5) (r a b : Nat) (pre : BitVec 32) : Option Quad5 :=
  let ptr (k : Nat) : Pointer := ⟨⟨k⟩, 0⟩
  match
    fd_ed25519_point_add_with_opts.eval 3
      (fd_ed25519_point_add_with_opts.args (.value (ptr r)) (.value (ptr a)) (.value (ptr b))
        (.value pre))
      (state X Y) with
  | .value (some (.cons (.value r') .nil), s') =>
    if r' == ptr r then some (s'.mem.readQuad5 r') else none
  | _ => none

private def eq (Q R : Quad5) : Bool :=
  Q.P0 == R.P0 && Q.P1 == R.P1 && Q.P2 == R.P2 && Q.P3 == R.P3 && Q.P4 == R.P4

/-- `X + Y` both ways (`Y`, or its precomputed form with `b_is_precomputed`), into another point
and in place, is `spec`. -/
private def check (X Y : Quad5) : Bool :=
  let S := fd_ed25519_point_add_with_opts.spec X Y 0
  match run X Y 3 0 1 0, run X Y 3 0 2 1, run X Y 0 0 1 0 with
  | some R, some R', some R'' => eq R S && eq R' S && eq R'' S
  | _, _, _ => false

#guard check A A && check A P

/-- `R`'s `X / Z`, `Y / Z` satisfy the curve equation: `(Y² - X²) Z² = Z⁴ + d X² Y²`. -/
private def onCurve (R : Quad5) : Bool :=
  let x := val R 0
  let y := val R 1
  let z := val R 2
  let d := 37095705934669439343138083508754565189542113879843219016388785533085940283555
  (y * y + p * p - x * x) % p * (z * z % p) % p ==
    (z * z % p * (z * z % p) + d * (x * x % p) % p * (y * y % p)) % p

-- the neutral point plus the base point has the base point's `X / Z`, `Y / Z` and `T / Z`
#guard
  match run quadZero P 3 0 1 0 with
  | some R =>
    val R 0 == bx * val R 2 % p && val R 1 == «by» * val R 2 % p &&
      val R 3 == bx * «by» % p * val R 2 % p
  | none => false

-- the base point plus itself, through the precomputed branch, is on the curve
#guard
  match run P P 3 0 2 1 with
  | some R => onCurve R && val R 2 != 0
  | none => false

end MLIR.Firedancer.R52x5
