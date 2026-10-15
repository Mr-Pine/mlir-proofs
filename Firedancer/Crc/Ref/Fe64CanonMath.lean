module

public import Firedancer.Crc.Ref.Fe64Canon
public import Ed25519.Field
import Std.Tactic.BVDecide

/-!
# 4×64 field kernels: `canon`

`Fe64.canon X` is `X mod p` for every 256-bit `X`: each pass subtracts `p` once when it can, and
`2^256 < 3p`.
-/

namespace MLIR.Firedancer.Crc.Ref.Fe64

open _root_.Ed25519

/-- A pass subtracts `p` when `X ≥ p`. -/
theorem canonPass_eq (X : BitVec 256) : canonPass X = if X < pBits then X else X - pBits := by
  simp only [canonPass]
  bv_decide

theorem pBits_toNat : pBits.toNat = p := by decide

theorem canonPass_toNat (X : BitVec 256) :
    (canonPass X).toNat = if X.toNat < p then X.toNat else X.toNat - p := by
  rw [canonPass_eq]
  by_cases h : X.toNat < p
  · rw [ite_eq_left
        (by
          rw [BitVec.lt_def, pBits_toNat]; exact h),
      ite_eq_left h]
  · rw [ite_eq_right
        (by
          rw [BitVec.lt_def, pBits_toNat]; exact h),
      ite_eq_right h,
      BitVec.toNat_sub_of_le
        (by
          rw [BitVec.le_def, pBits_toNat]; omega),
      pBits_toNat]

/-- `canon X` is `X mod p`. -/
public theorem canon_toNat (X : BitVec 256) : (canon X).toNat = X.toNat % p := by
  have := X.isLt
  have h1 := canonPass_toNat X
  have h2 := canonPass_toNat (canonPass X)
  simp only [canon]
  unfold p at *
  split at h1 <;> split at h2 <;> omega

public theorem canon_lt (X : BitVec 256) : (canon X).toNat < p := by
  rw [canon_toNat]
  exact Nat.mod_lt _ (by decide)

/-- `canon X` is `X` in the field. -/
public theorem canon_val (X : BitVec 256) : ((canon X).toNat : ZMod p) = X.toNat := by
  rw [canon_toNat, ZMod.natCast_mod]

end MLIR.Firedancer.Crc.Ref.Fe64
