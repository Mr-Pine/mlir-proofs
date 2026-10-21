module

public import Agave.Math.CurveModels
public import Agave.Serial.CompressedEdwardsY_decompress
import Firedancer.Math.Curve
import Firedancer.Math.Decode
import Firedancer.Math.Sqrt
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! `CompressedEdwardsY::decompress` in `ZMod p`: `from_bytes`, `pow_p58`, `sqrt_ratio_i`, and the
decoded point, `None` exactly when `Ed25519.decode` fails, else the decoded point in extended
coordinates with limbs below `2^52`. -/

namespace MLIR.Agave

open _root_.Ed25519

/-! ## Definitions -/

@[expose] public section

/-- `P?` is `decode buf`: `none` when it fails, else the decoded point in extended coordinates with
limbs below `2^52`. -/
def DecodesExt (buf : BitVec 256) : Option EdwardsPoint → Prop
  | none => decode buf = none
  | some P => ∃ Q, decode buf = some Q ∧ P.Ext Q.x Q.y ∧ P.Lt (2 ^ 52)

end

namespace Serial

/-! ## Constants -/

theorem ONE_val : Limbs.val FieldElement51.ONE = 1 ∧ Limbs.Lt FieldElement51.ONE (2 ^ 52) :=
  ⟨by simp [Limbs.val_eq, FieldElement51.ONE], by
    rw [Limbs.lt_iff]; decide⟩

theorem EDWARDS_D_val :
    Limbs.val FieldElement51.EDWARDS_D = d ∧ Limbs.Lt FieldElement51.EDWARDS_D (2 ^ 52) :=
  ⟨Firedancer.Ref.fd_f25519_d.val.1, by
    rw [Limbs.lt_iff]; decide⟩

theorem SQRT_M1_val :
    Limbs.val FieldElement51.SQRT_M1 = sqrtM1 ∧ Limbs.Lt FieldElement51.SQRT_M1 (2 ^ 52) :=
  ⟨Firedancer.Ref.fd_f25519_sqrtm1.val.1, by
    rw [Limbs.lt_iff]; decide⟩

/-! ## `from_bytes` -/

theorem FieldElement51_from_bytes.bytes_eq (buf : BitVec 256) :
    FieldElement51_to_bytes.bytes (FieldElement51_from_bytes.spec buf 0)
        (FieldElement51_from_bytes.spec buf 1) (FieldElement51_from_bytes.spec buf 2)
        (FieldElement51_from_bytes.spec buf 3) (FieldElement51_from_bytes.spec buf 4) =
      buf &&& BitVec.allOnes 256 >>> 1 := by
  simp only [FieldElement51_to_bytes.bytes, FieldElement51_from_bytes.spec, mask51]
  bv_decide

/-- Five limbs below `2^51`, shifted to `51 k` and summed in 256 bits: their number. -/
theorem toNat_sum51 {l0 l1 l2 l3 l4 : BitVec 64} (h0 : l0.toNat < 2 ^ 51) (h1 : l1.toNat < 2 ^ 51)
    (h2 : l2.toNat < 2 ^ 51) (h3 : l3.toNat < 2 ^ 51) (h4 : l4.toNat < 2 ^ 51) :
    (l0.setWidth 256 + l1.setWidth 256 <<< 51 + l2.setWidth 256 <<< 102 + l3.setWidth 256 <<< 153 +
          l4.setWidth 256 <<< 204).toNat =
      l0.toNat + l1.toNat * 2 ^ 51 + l2.toNat * 2 ^ 102 + l3.toNat * 2 ^ 153 +
        l4.toNat * 2 ^ 204 := by
  simp only [BitVec.toNat_add, BitVec.toNat_shiftLeft, BitVec.toNat_setWidth, Nat.shiftLeft_eq]
  omega

theorem FieldElement51_from_bytes.sum_eq (buf : BitVec 256) :
    (FieldElement51_from_bytes.spec buf 0).setWidth 256 +
        (FieldElement51_from_bytes.spec buf 1).setWidth 256 <<< 51 +
        (FieldElement51_from_bytes.spec buf 2).setWidth 256 <<< 102 +
        (FieldElement51_from_bytes.spec buf 3).setWidth 256 <<< 153 +
        (FieldElement51_from_bytes.spec buf 4).setWidth 256 <<< 204 =
      buf &&& BitVec.allOnes 256 >>> 1 := by
  simp only [FieldElement51_from_bytes.spec, mask51]
  bv_decide

/-- `from_bytes` takes `buf`'s low 255 bits, in limbs below `2^51`. -/
public theorem FieldElement51_from_bytes.spec_val (buf : BitVec 256) :
    Limbs.val (FieldElement51_from_bytes.spec buf) = ((buf.toNat % 2 ^ 255 : ℕ) : ZMod p) ∧
      Limbs.Lt (FieldElement51_from_bytes.spec buf) (2 ^ 51) := by
  have hl : Limbs.Lt (FieldElement51_from_bytes.spec buf) (2 ^ 51) := by
    intro i
    fin_cases i <;> simp only [FieldElement51_from_bytes.spec, mask51, toNat_and_mask] <;> omega
  refine ⟨?_, hl⟩
  have h := toNat_sum51 (hl 0) (hl 1) (hl 2) (hl 3) (hl 4)
  rw [FieldElement51_from_bytes.sum_eq] at h
  rw [Limbs.val_nat, Limbs.nat, ← h]
  congr 1
  rw [BitVec.toNat_and, BitVec.toNat_ushiftRight, BitVec.toNat_allOnes, Nat.shiftRight_eq_div_pow]
  rw [show (2 ^ 256 - 1) / 2 ^ 1 = 2 ^ 255 - 1 by norm_num, Nat.and_two_pow_sub_one_eq_mod]

/-! ## `pow_p58` -/

/-- `z.pow_p58()` raises limbs below `2^54` to `(p - 5) / 8`, into limbs below `2^52`. -/
public theorem FieldElement51_pow_p58.spec_val {z : Fin 5 → BitVec 64} (hz : Limbs.Lt z (2 ^ 54)) :
    Limbs.val (FieldElement51_pow_p58.spec z) = Limbs.val z ^ ((p - 5) / 8) ∧
      Limbs.Lt (FieldElement51_pow_p58.spec z) (2 ^ 52) := by
  obtain ⟨⟨v19, b19⟩, -⟩ := FieldElement51_pow22501.spec_val hz
  obtain ⟨v20, b20⟩ := FieldElement51_pow2k.spec_val (k := 2) (by decide) (b19.mono (by decide))
  obtain ⟨v21, b21⟩ := FieldElement51_Mul_mul.spec_val hz (b20.mono (by decide))
  refine ⟨?_, b21⟩
  rw [FieldElement51_pow_p58.spec, v21, v20, v19, ← pow_mul, ← pow_succ']
  norm_num

/-! ## Flags -/

theorem ite_or_ite8 {a b : Prop} [Decidable a] [Decidable b] :
    ((if a then 1#8 else 0#8) ||| if b then 1#8 else 0#8) = if a ∨ b then 1#8 else 0#8 := by
  by_cases a <;> by_cases b <;> simp [*]

/-- `ct_eq` on values. -/
theorem ct_eq_val (a b : Fin 5 → BitVec 64) :
    FieldElement51_ConstantTimeEq_ct_eq.spec a b = if Limbs.val a = Limbs.val b then 1#8 else 0#8 :=
  FieldElement51_ConstantTimeEq_ct_eq.spec_val a b

/-- `conditional_assign` on a `0`/`1` flag. -/
theorem cond_assign_ite {c : Prop} [Decidable c] (self other : Fin 5 → BitVec 64) :
    FieldElement51_ConditionallySelectable_conditional_assign.spec self other
        (if c then 1#8 else 0#8) =
      if c then other else self := by
  rw [FieldElement51_ConditionallySelectable_conditional_assign.spec_eq _ _
      (by by_cases c <;> simp [*])]
  by_cases c <;> simp [*]

/-- `is_negative` as a `0`/`1` flag. -/
theorem is_negative_ite (a : Fin 5 → BitVec 64) :
    FieldElement51_is_negative.spec a = if (Limbs.val a).val % 2 = 1 then 1#8 else 0#8 := by
  apply BitVec.eq_of_toNat_eq
  rw [FieldElement51_is_negative.spec_val]
  split <;> simp_all

/-- The sign bit `repr[31] >> 7` as a `0`/`1` flag. -/
theorem sign_ite (buf : BitVec 256) :
    buf.extractLsb' 248 8 >>> 7 = if buf.toNat / 2 ^ 255 = 1 then 1#8 else 0#8 := by
  have hb : buf.toNat / 2 ^ 255 < 2 := by
    have := buf.isLt; omega
  have h : (buf.extractLsb' 248 8 >>> 7).toNat = buf.toNat / 2 ^ 255 := by
    simp only [BitVec.toNat_ushiftRight, BitVec.extractLsb'_toNat, Nat.shiftRight_eq_div_pow]
    have := buf.isLt
    omega
  apply BitVec.eq_of_toNat_eq
  rw [h]
  split
  · next h1 =>
      rw [h1]; rfl
  · next h1 =>
      simp only [BitVec.toNat_ofNat]; omega

/-- A nonnegative choice of `±r`: even, the same square. -/
theorem neg_if_odd_even (r : ZMod p) :
    ((if r.val % 2 = 1 then -r else r).val % 2 = 0) ∧
      (if r.val % 2 = 1 then -r else r) ^ 2 = r ^ 2 := by
  split
  · next
      h =>
      have h0 : r ≠ 0 := by
        rintro rfl; simp at h
      refine ⟨?_, by ring⟩
      rw [ZMod.neg_val, ite_eq_right h0]
      have := ZMod.val_lt r
      have hp : p % 2 = 1 := by norm_num
      omega
  · next h => exact ⟨by omega, rfl⟩

/-! ## `sqrt_ratio_i` -/

open Classical in
/-- `sqrt_ratio_i(u, v)` on limbs below `2^54`, `v ≠ 0`: the flag is `1` exactly when `u / v` is a
square, then `v r² = u`; `r` is even and in limbs below `2^52` either way. -/
public theorem FieldElement51_sqrt_ratio_i.spec_val {u v : Fin 5 → BitVec 64}
    (hu : Limbs.Lt u (2 ^ 54)) (hv : Limbs.Lt v (2 ^ 54)) (hv0 : Limbs.val v ≠ 0) :
    let R := FieldElement51_sqrt_ratio_i.spec u v
    R.1 = (if IsSquare (Limbs.val u / Limbs.val v) then 1#8 else 0#8) ∧
      (IsSquare (Limbs.val u / Limbs.val v) → Limbs.val v * Limbs.val R.2 ^ 2 = Limbs.val u) ∧
      (Limbs.val R.2).val % 2 = 0 ∧ Limbs.Lt R.2 (2 ^ 52) := by
  dsimp only
  obtain ⟨vsq, bsq⟩ := FieldElement51_square.spec_val hv
  obtain ⟨v3, b3⟩ := FieldElement51_Mul_mul.spec_val (bsq.mono (by decide)) hv
  obtain ⟨v3sq, b3sq⟩ := FieldElement51_square.spec_val (b3.mono (by decide))
  obtain ⟨v7, b7⟩ := FieldElement51_Mul_mul.spec_val (b3sq.mono (by decide)) hv
  obtain ⟨vuv3, buv3⟩ := FieldElement51_Mul_mul.spec_val hu (b3.mono (by decide))
  obtain ⟨vuv7, buv7⟩ := FieldElement51_Mul_mul.spec_val hu (b7.mono (by decide))
  obtain ⟨vp58, bp58⟩ := FieldElement51_pow_p58.spec_val (buv7.mono (by decide))
  obtain ⟨vr, br⟩ := FieldElement51_Mul_mul.spec_val (buv3.mono (by decide)) (bp58.mono (by decide))
  simp only [FieldElement51_sqrt_ratio_i.spec]
  generalize hr0 :
    FieldElement51_Mul_mul.spec
      (FieldElement51_Mul_mul.spec u (FieldElement51_Mul_mul.spec (FieldElement51_square.spec v) v))
      (FieldElement51_pow_p58.spec
        (FieldElement51_Mul_mul.spec u
          (FieldElement51_Mul_mul.spec
            (FieldElement51_square.spec
              (FieldElement51_Mul_mul.spec (FieldElement51_square.spec v) v))
            v))) =
    r0 at vr br
  -- `β = u v³ (u v⁷)^((p-5)/8)`
  have hβ :
    Limbs.val r0 =
      Limbs.val u * Limbs.val v ^ 3 * (Limbs.val u * Limbs.val v ^ 7) ^ ((p - 5) / 8) := by
    rw [vr, vuv3, vp58, vuv7, v7, v3sq, v3, vsq]
    ring
  obtain ⟨vrsq, brsq⟩ := FieldElement51_square.spec_val (br.mono (by decide))
  obtain ⟨vcheck, -⟩ := FieldElement51_Mul_mul.spec_val hv (brsq.mono (by decide))
  obtain ⟨vnu, bnu⟩ := FieldElement51_Neg_neg.spec_val hu
  obtain ⟨vnui, -⟩ :=
    FieldElement51_Mul_mul.spec_val (bnu.mono (by decide)) (SQRT_M1_val.2.mono (by decide))
  obtain ⟨vrp, brp⟩ :=
    FieldElement51_Mul_mul.spec_val (SQRT_M1_val.2.mono (by decide)) (br.mono (by decide))
  rw [vrsq] at vcheck
  rw [vnu, SQRT_M1_val.1] at vnui
  rw [SQRT_M1_val.1] at vrp
  simp only [ct_eq_val, vcheck, vnu, vnui, ite_or_ite8, cond_assign_ite]
  -- `r` after the `√-1` fix
  generalize hr1 :
    (if
        Limbs.val v * Limbs.val r0 ^ 2 = -Limbs.val u * sqrtM1 ∨
          Limbs.val v * Limbs.val r0 ^ 2 = -Limbs.val u then
      FieldElement51_Mul_mul.spec FieldElement51.SQRT_M1 r0
    else r0) =
    r1
  have vr1 :
    Limbs.val r1 =
      if
          Limbs.val v * Limbs.val r0 ^ 2 = -Limbs.val u * sqrtM1 ∨
            Limbs.val v * Limbs.val r0 ^ 2 = -Limbs.val u then
        sqrtM1 * Limbs.val r0
      else Limbs.val r0 := by
    rw [← hr1]
    split <;> simp [vrp]
  have br1 : Limbs.Lt r1 (2 ^ 52) := by
    rw [← hr1]
    split
    · exact brp
    · exact br
  obtain ⟨vnr1, bnr1⟩ := FieldElement51_Neg_neg.spec_val (br1.mono (by decide))
  rw [is_negative_ite, cond_assign_ite]
  have vr2 :
    Limbs.val (if (Limbs.val r1).val % 2 = 1 then FieldElement51_Neg_neg.spec r1 else r1) =
      if (Limbs.val r1).val % 2 = 1 then -Limbs.val r1 else Limbs.val r1 := by
    split <;> simp [vnr1]
  rw [vr2]
  obtain ⟨heven, hsq2⟩ := neg_if_odd_even (Limbs.val r1)
  have hiff := (Firedancer.Ref.sqrt_ratio_iff hv0 hβ).symm
  refine ⟨?_, fun hsq => ?_, heven, ?_⟩
  · by_cases hsq : IsSquare (Limbs.val u / Limbs.val v)
    · rw [ite_eq_left (Or.comm.1 (hiff.2 hsq)), ite_eq_left hsq]
    · rw [ite_eq_right (fun h => hsq (hiff.1 (Or.comm.1 h))), ite_eq_right hsq]
  · rw [hsq2, vr1]
    have hne : (1 : ZMod p) + sqrtM1 ≠ 0 := by
      intro h
      have := sqrtM1_sq
      rw [show sqrtM1 = -1 by linear_combination h] at this
      exact absurd this (by decide)
    rcases hiff.2 hsq with hfc | hff
    · split
      · next hf =>
          -- `v β² = u` and `= -u` or `-u √-1`: `u = 0`, so `β = 0`
          have hu0 : Limbs.val u = 0 := by
            rcases hf with hf | hf
            · have : Limbs.val u * (1 + sqrtM1) = 0 := by linear_combination hfc.symm.trans hf
              exact (mul_eq_zero.1 this).resolve_right hne
            · have : 2 * Limbs.val u = 0 := by linear_combination hfc.symm.trans hf
              exact (mul_eq_zero.1 this).resolve_left (by decide)
          rw [hβ, hu0]
          ring
      · exact hfc
    · rw [ite_eq_left (Or.inr hff)]
      linear_combination sqrtM1 ^ 2 * hff - Limbs.val u * sqrtM1_sq
  · split
    · exact bnr1
    · exact br1

/-! ## `decompress` -/

/-- `repr.decompress()` is `decode repr`: `None` exactly when decoding fails, else the decoded point
in extended coordinates, `Z = 1`, limbs below `2^52`. -/
public theorem CompressedEdwardsY_decompress.spec_val (buf : BitVec 256) :
    DecodesExt buf (CompressedEdwardsY_decompress.spec buf) := by
  obtain ⟨vY, bY⟩ := FieldElement51_from_bytes.spec_val buf
  generalize hY : FieldElement51_from_bytes.spec buf = Y at vY bY
  generalize hy : ((buf.toNat % 2 ^ 255 : ℕ) : ZMod p) = y at vY
  obtain ⟨vYY, bYY⟩ := FieldElement51_square.spec_val (bY.mono (by decide))
  obtain ⟨vu, bu⟩ :=
    FieldElement51_Sub_sub.spec_val (bYY.mono (by decide)) (ONE_val.2.mono (by decide))
  obtain ⟨vYYd, bYYd⟩ :=
    FieldElement51_Mul_mul.spec_val (bYY.mono (by decide)) (EDWARDS_D_val.2.mono (by decide))
  obtain ⟨vv, bv⟩ := FieldElement51_Add_add.spec_val bYYd ONE_val.2 (by decide)
  rw [vYY, ONE_val.1, vY] at vu
  rw [vYYd, vYY, EDWARDS_D_val.1, vY] at vv
  rw [ONE_val.1] at vv
  have hv0 :
    Limbs.val
        (FieldElement51_Add_add.spec
          (FieldElement51_Mul_mul.spec (FieldElement51_square.spec Y) FieldElement51.EDWARDS_D)
          FieldElement51.ONE) ≠
      0 := by
    rw [vv]
    exact fun h => v_ne y (by linear_combination h)
  obtain ⟨hflag, hroot, heven, br⟩ :=
    FieldElement51_sqrt_ratio_i.spec_val (bu.mono (by decide)) (bv.mono (by decide)) hv0
  rw [vu, vv] at hflag hroot
  have hsq_iff : IsSquare ((y ^ 2 - 1) / (y ^ 2 * d + 1)) ↔ ∃ P, Decodes buf P := by
    rw [exists_decodes_iff, hy, exists_onCurve_iff, mul_comm (y ^ 2) d]
  simp only [CompressedEdwardsY_decompress.spec, CompressedEdwardsY_decompress.step_1, hY]
  generalize hR : FieldElement51_sqrt_ratio_i.spec _ _ = R at hflag hroot heven br
  rw [hflag]
  by_cases hsq : IsSquare ((y ^ 2 - 1) / (y ^ 2 * d + 1))
  · rw [ite_eq_left hsq, ite_eq_right (by decide)]
    have hr := hroot hsq
    generalize hr2 : R.2 = r at hr heven br
    obtain ⟨vnr, bnr⟩ := FieldElement51_Neg_neg.spec_val (br.mono (by decide))
    have hb : buf.toNat / 2 ^ 255 < 2 := by
      have := buf.isLt; omega
    simp only [CompressedEdwardsY_decompress.step_2, sign_ite, cond_assign_ite]
    -- `x`: `r`, negated for the sign bit
    generalize hX : (if buf.toNat / 2 ^ 255 = 1 then FieldElement51_Neg_neg.spec r else r) = X
    have vX : Limbs.val X = if buf.toNat / 2 ^ 255 = 1 then -Limbs.val r else Limbs.val r := by
      rw [← hX]
      split <;> simp [vnr]
    have bX : Limbs.Lt X (2 ^ 52) := by
      rw [← hX]
      split
      · exact bnr
      · exact br
    have hon : OnCurve (Limbs.val X) y := by
      rw [onCurve_iff]
      rw [vX]
      split <;> linear_combination hr
    obtain ⟨vT, bT⟩ := FieldElement51_Mul_mul.spec_val (bX.mono (by decide)) (bY.mono (by decide))
    have hdec : Decodes buf ⟨Limbs.val X, y, hon⟩ := by
      refine ⟨hy.symm, ?_⟩
      show Limbs.val X = 0 ∨ (Limbs.val X).val % 2 = buf.toNat / 2 ^ 255
      rw [vX]
      split
      · next h1 =>
          by_cases h0 : Limbs.val r = 0
          · left; simp [h0]
          · right
            rw [ZMod.neg_val, ite_eq_right h0, h1]
            have := ZMod.val_lt (Limbs.val r)
            have hp : p % 2 = 1 := by norm_num
            have := (ZMod.val_pos).2 h0
            omega
      · next h1 =>
          right
          rw [heven]
          omega
    refine
      ⟨_, decode_eq_some hdec,
        ⟨by
          rw [ONE_val.1]; exact one_ne_zero, ?_, ?_, ?_⟩,
        bX, bY.mono (by decide), ONE_val.2, bT⟩
    · simp [ONE_val.1]
    · simp [ONE_val.1, vY]
    · rw [vT, ONE_val.1, mul_one]
  · rw [ite_eq_right hsq, ite_eq_left (c := (0#8 : BitVec 8) = (0 : BitVec 8)) rfl]
    exact decode_eq_none.2 fun P hP => hsq (hsq_iff.2 ⟨P, hP⟩)

end Serial

end MLIR.Agave
