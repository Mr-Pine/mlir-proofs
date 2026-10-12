module

public import Agave.Math.CurveModels
public import Agave.Math.Encoding
public import Agave.Math.ScalarReduce
public import Agave.Math.Verify
public import Agave.Serial.VerificationKey_verify_dalek_prehashed
import Mathlib.FieldTheory.Finite.Basic
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! `verify_dalek_prehashed`'s inlined helpers in `ZMod p`: `invert` raises to `p - 2`, `compress`
of extended coordinates is `Ed25519.encode`, and `from_canonical_bytes`'s `Choice` is
`CanonicalS`. -/

namespace MLIR.Agave.Serial

open _root_.Ed25519

/-! ## `invert` -/

/-- `z.invert()` raises limbs below `2^54` to `p - 2`, into limbs below `2^52`. -/
public theorem FieldElement51_invert.spec_val {z : Fin 5 → BitVec 64} (hz : Limbs.Lt z (2 ^ 54)) :
    Limbs.val (FieldElement51_invert.spec z) = Limbs.val z ^ (p - 2) ∧
      Limbs.Lt (FieldElement51_invert.spec z) (2 ^ 52) := by
  obtain ⟨⟨v19, l19⟩, v3, l3⟩ := FieldElement51_pow22501.spec_val hz
  obtain ⟨v20, l20⟩ := FieldElement51_pow2k.spec_val (k := 5) (by decide) (l19.mono (by decide))
  obtain ⟨v21, l21⟩ := FieldElement51_Mul_mul.spec_val (l20.mono (by decide)) (l3.mono (by decide))
  refine ⟨?_, l21⟩
  rw [FieldElement51_invert.spec, v21, v20, v19, v3, ← pow_mul, ← pow_add]
  rfl

/-- `z.invert()` of a non-zero `z` below `2^54`: its inverse. -/
public theorem FieldElement51_invert.mul_spec_val {z : Fin 5 → BitVec 64} (hz : Limbs.Lt z (2 ^ 54))
    (h0 : Limbs.val z ≠ 0) : Limbs.val z * Limbs.val (FieldElement51_invert.spec z) = 1 := by
  rw [(FieldElement51_invert.spec_val hz).1, ← pow_succ', show p - 2 + 1 = p - 1 by decide,
    ZMod.pow_card_sub_one_eq_one h0]

/-! ## `compress` -/

/-- `s[31] ^= b << 7` on bytes below `2^255` and a bit `b`: `b` on top. -/
theorem set_sign {s : BitVec 256} {b : BitVec 8} (hs : s.toNat < 2 ^ 255) (hb : b.toNat < 2) :
    (s.extractLsb' 248 8 ^^^ b <<< 7) ++ s.extractLsb' 0 248 =
      BitVec.ofNat 256 (s.toNat + 2 ^ 255 * b.toNat) := by
  have hs' : s < BitVec.ofNat 256 (2 ^ 255) := by
    rw [BitVec.lt_def, BitVec.toNat_ofNat]
    omega
  obtain rfl | rfl : b = 0#8 ∨ b = 1#8 := by
    have : b < 2#8 := by
      rw [BitVec.lt_def]
      exact hb
    bv_decide
  · have h : BitVec.ofNat 256 (s.toNat + 2 ^ 255 * (0#8).toNat) = s := by simp
    rw [h]
    bv_decide
  · have h :
      BitVec.ofNat 256 (s.toNat + 2 ^ 255 * (1#8).toNat) = s + BitVec.ofNat 256 (2 ^ 255) := by
      rw [show (1#8).toNat = 1 from rfl, Nat.mul_one, BitVec.ofNat_add, BitVec.ofNat_toNat,
        BitVec.setWidth_eq]
    rw [h]
    bv_decide

/-- `P.compress()` of extended coordinates of `Q` with limbs below `2^54`: `Q`'s encoding. -/
public theorem EdwardsPoint_compress.spec_eq {P : EdwardsPoint} {Q : Point} (hb : P.Lt (2 ^ 54))
    (h : P.Ext Q.x Q.y) : EdwardsPoint_compress.spec P = encode Q := by
  obtain ⟨hX, hY, hZ, -⟩ := hb
  obtain ⟨hz, hx, hy, -⟩ := h
  have hr := FieldElement51_invert.mul_spec_val hZ hz
  have lr := (FieldElement51_invert.spec_val hZ).2.mono (by decide : 2 ^ 52 ≤ 2 ^ 54)
  obtain ⟨vx, -⟩ := FieldElement51_Mul_mul.spec_val hX lr
  obtain ⟨vy, -⟩ := FieldElement51_Mul_mul.spec_val hY lr
  have ex : Limbs.val (FieldElement51_Mul_mul.spec P.X (FieldElement51_invert.spec P.Z)) = Q.x := by
    rw [vx, hx, mul_assoc, hr, mul_one]
  have ey : Limbs.val (FieldElement51_Mul_mul.spec P.Y (FieldElement51_invert.spec P.Z)) = Q.y := by
    rw [vy, hy, mul_assoc, hr, mul_one]
  have hs :=
    FieldElement51_to_bytes.spec_val
      (FieldElement51_Mul_mul.spec P.Y (FieldElement51_invert.spec P.Z))
  have hn :=
    FieldElement51_is_negative.spec_val
      (FieldElement51_Mul_mul.spec P.X (FieldElement51_invert.spec P.Z))
  rw [ey] at hs
  rw [ex] at hn
  simp only [EdwardsPoint_compress.spec]
  rw [set_sign
      (by
        rw [hs]; exact (ZMod.val_lt Q.y).trans (by decide))
      (by
        rw [hn]; exact Nat.mod_lt _ (by decide)),
    hs, hn]
  rfl

/-! ## `from_canonical_bytes` -/

/-- `bytes[31] >> 7 == 0`: `bytes` is below `2^255`. -/
theorem high_bit_unset_iff (s : BitVec 256) :
    s.extractLsb' 248 8 >>> 7 = 0#8 ↔ s.toNat < 2 ^ 255 := by
  have h : s.extractLsb' 248 8 >>> 7 = 0#8 ↔ s < BitVec.ofNat 256 (2 ^ 255) := by bv_decide
  rw [h, BitVec.lt_def, BitVec.toNat_ofNat]
  omega

/-- `Scalar::from_canonical_bytes(s)`'s `Choice`: `1` exactly when `s` is canonical. -/
public theorem Scalar_from_canonical_bytes.spec_eq (s : BitVec 256) :
    Scalar_from_canonical_bytes.spec s = if CanonicalS s then 1#8 else 0#8 := by
  have hc : s = Scalar_reduce.spec s ↔ s.toNat % ell = s.toNat := by
    rw [← BitVec.toNat_inj, Scalar_reduce.toNat_spec]
    exact eq_comm
  simp only [Scalar_from_canonical_bytes.spec, slice_u8_ConstantTimeEq_ct_eq.spec_eq, CanonicalS,
    Nat.div_eq_zero_iff_lt (by decide : 0 < 2 ^ 255), ← high_bit_unset_iff, hc]
  by_cases h1 : s.extractLsb' 248 8 >>> 7 = 0#8 <;> by_cases h2 : s.toNat % ell = s.toNat <;>
    simp [h1, h2]

end MLIR.Agave.Serial
