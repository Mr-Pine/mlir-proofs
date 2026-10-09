module

public import Firedancer.Ref.fd_ed25519_verify_equation

meta import Firedancer.Ref.fd_ed25519_verify_equation

/-! The lift reads the base-point table through `fd_ed25519_double_scalar_mul_base` and cannot be
evaluated. These test `spec` on zero scalars: a non-zero digit's ladder takes minutes unmemoized,
and `fd_ed25519_double_scalar_mul_base`'s tests cover it. -/

namespace MLIR.Firedancer.Ref

private def p : Nat := 2 ^ 255 - 19

/-- The base point `B`. -/
private def B : Nat × Nat :=
  (15112221349535400772501151409588531511454012693041857206046113283949847762202,
    46316835694926478169428394003475163141307993866256225615783033603165251855960)

/-- An affine point's limbs, `Z = 1`. -/
private def toPoint (P : Nat × Nat) : PointLimbs :=
  let limbs (v : Nat) : Fin 5 → BitVec 64 := fun i => BitVec.ofNat 64 (v >>> (51 * i.val) % 2 ^ 51)
  ⟨limbs P.1, limbs P.2, limbs (P.1 * P.2 % p), limbs 1⟩

/-- No table: zero scalars never read it. -/
private def noTbl : Nat → PointLimbs := fun _ => ⟨0, 0, 0, 0⟩

-- `[0]B = O + [0]A`
#guard fd_ed25519_verify_equation.spec noTbl 0#256 (toPoint B) 0#256 (toPoint (0, 1)) == 1#32

#guard fd_ed25519_verify_equation.spec noTbl 0#256 (toPoint B) 0#256 (toPoint B) == 0#32

end MLIR.Firedancer.Ref
