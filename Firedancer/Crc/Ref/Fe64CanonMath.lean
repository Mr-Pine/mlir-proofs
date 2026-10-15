module

public import Firedancer.Crc.Ref.Fe64Canon
public import Firedancer.Crc.Ref.Fe64Bytes
public import Ed25519.Field
import Std.Tactic.BVDecide

/-!
# 4×64 field kernels: `canon` and what is built on it

`Fe64.canon X` is `X mod p` for every 256-bit `X`: each pass subtracts `p` once when it can, and
`2^256 < 3p`. So `tobytes` stores `X mod p`, `eq` compares mod `p`, `is_zero` tests `X ≡ 0`, `sgn`
is the parity of `X mod p`, and `frombytes` reads the low 255 bits.
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

/-- `canon` agrees exactly on values congruent mod `p` (`crc_fe64_eq`'s result). -/
public theorem canon_eq_iff (X Y : BitVec 256) : canon X = canon Y ↔ X.toNat % p = Y.toNat % p := by
  rw [← canon_toNat, ← canon_toNat]
  exact ⟨congrArg BitVec.toNat, BitVec.eq_of_toNat_eq⟩

/-- `canon` is zero exactly on multiples of `p` (`crc_fe64_is_zero`'s result). -/
public theorem canon_eq_zero_iff (X : BitVec 256) : canon X = 0#256 ↔ X.toNat % p = 0 := by
  rw [← canon_toNat]
  exact ⟨fun h => (congrArg BitVec.toNat h).trans rfl, fun h => BitVec.eq_of_toNat_eq h⟩

/-- `crc_fe64_sgn`'s result is the parity of `X mod p`. -/
public theorem sgn_toNat (X : BitVec 256) :
    ((canon X).setWidth 32 &&& 1#32).toNat = X.toNat % p % 2 := by
  rw [← canon_toNat]
  have : ∀ C : BitVec 256, ((C.setWidth 32 &&& 1#32).toNat = C.toNat % 2) := by
    intro C
    rw [BitVec.toNat_and, BitVec.toNat_setWidth, show (1#32).toNat = 2 ^ 1 - 1 from rfl,
      Nat.and_two_pow_sub_one_eq_mod]
    omega
  exact this _

/-- `frombytes B` is `B mod 2^255`. -/
public theorem frombytes_toNat (B : BitVec 256) : (frombytes B).toNat = B.toNat % 2 ^ 255 := by
  simp only [frombytes, BitVec.toNat_setWidth]
  omega

end MLIR.Firedancer.Crc.Ref.Fe64
