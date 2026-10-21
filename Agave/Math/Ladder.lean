module

public import Agave.Math.BaseTable
public import Agave.Math.CurveModels
public import Agave.Math.NafLookupTable5
public import Agave.Serial.mul.Spec
import Mathlib.Tactic.Module

/-! `vartime_double_base::mul` in `ZMod p`: `mul.spec a A b` is `a A + b B` for `a, b < 2^255`. The
B adds' and the projective conversions' `spec_val`s; `table_B`'s entries read from the global's
bits; the ladder's invariant, `2^(i+1) R` plus the digits up to `i`. -/

namespace MLIR.Agave

open _root_.Ed25519

/-! ## Definitions -/

@[expose] public section

/-- Every coordinate's limbs below `c`. -/
abbrev AffineNielsPoint.Lt (P : AffineNielsPoint) (c : ℕ) : Prop :=
  Limbs.Lt P.y_plus_x c ∧ Limbs.Lt P.y_minus_x c ∧ Limbs.Lt P.xy2d c

/-- `P`'s values are affine Niels coordinates of `(x, y)`. -/
abbrev AffineNielsPoint.Niels (P : AffineNielsPoint) (x y : ZMod p) : Prop :=
  IsAffineNiels x y (Limbs.val P.y_plus_x) (Limbs.val P.y_minus_x) (Limbs.val P.xy2d)

end

namespace Serial

/-! ## Point ops -/

/-- `identity()` is projective coordinates of `0`, below `2^52`. -/
public theorem ProjectivePoint_identity.spec_val :
    ProjectivePoint_identity.spec.Proj (0 : Point).x (0 : Point).y ∧
      ProjectivePoint_identity.spec.Lt (2 ^ 52) := by
  have l0 : Limbs.Lt FieldElement51.ZERO (2 ^ 52) := by
    rw [Limbs.lt_iff]; decide
  have l1 : Limbs.Lt FieldElement51.ONE (2 ^ 52) := by
    rw [Limbs.lt_iff]; decide
  refine ⟨?_, l0, l1, l1⟩
  simp only [ProjectivePoint.Proj, ProjectivePoint_identity.spec, FieldElement51.ZERO_val,
    FieldElement51.ONE_val, Point.zero_x, Point.zero_y]
  exact ⟨one_ne_zero, by ring, by ring⟩

/-- `as_extended` of projective coordinates below `2^54`: extended ones below `2^52`. -/
public theorem ProjectivePoint_as_extended.spec_val {P : ProjectivePoint} {x y : ZMod p}
    (hb : P.Lt (2 ^ 54)) (h : P.Proj x y) :
    (ProjectivePoint_as_extended.spec P).Ext x y ∧
      (ProjectivePoint_as_extended.spec P).Lt (2 ^ 52) := by
  obtain ⟨hX, hY, hZ⟩ := hb
  obtain ⟨v1, l1⟩ := FieldElement51_Mul_mul.spec_val hX hZ
  obtain ⟨v2, l2⟩ := FieldElement51_Mul_mul.spec_val hY hZ
  obtain ⟨v3, l3⟩ := FieldElement51_square.spec_val hZ
  obtain ⟨v4, l4⟩ := FieldElement51_Mul_mul.spec_val hX hY
  refine ⟨?_, l1, l2, l3, l4⟩
  simp only [EdwardsPoint.Ext, ProjectivePoint_as_extended.spec, v1, v2, v3, v4]
  exact h.isExt

/-- `&P - &Q`, `P` extended below `2^53`, `Q` Niels below `2^54`, both on the curve: completed
coordinates of their difference, below `2^54`. -/
public theorem EdwardsPoint_Sub_ProjectiveNielsPoint_sub.spec_val {P : EdwardsPoint}
    {Q : ProjectiveNielsPoint} {x₁ y₁ x₂ y₂ : ZMod p} (hP : P.Lt (2 ^ 53)) (hQ : Q.Lt (2 ^ 54))
    (h₁ : P.Ext x₁ y₁) (h₂ : Q.Niels x₂ y₂) (hc₁ : OnCurve x₁ y₁) (hc₂ : OnCurve x₂ y₂) :
    (EdwardsPoint_Sub_ProjectiveNielsPoint_sub.spec P Q).Compl (add x₁ y₁ (-x₂) y₂).1
        (add x₁ y₁ (-x₂) y₂).2 ∧
      (EdwardsPoint_Sub_ProjectiveNielsPoint_sub.spec P Q).Lt (2 ^ 54) := by
  obtain ⟨hX, hY, hZ, hT⟩ := hP
  obtain ⟨hYpX, hYmX, hZ₂, hT2d⟩ := hQ
  obtain ⟨vYpX, lYpX⟩ := FieldElement51_Add_add.spec_val hY hX (by norm_num)
  obtain ⟨vYmX, lYmX⟩ :=
    FieldElement51_Sub_sub.spec_val (hY.mono (by norm_num)) (hX.mono (by norm_num))
  obtain ⟨vPM, lPM⟩ := FieldElement51_Mul_mul.spec_val (lYpX.mono (by norm_num)) hYmX
  obtain ⟨vMP, lMP⟩ := FieldElement51_Mul_mul.spec_val (lYmX.mono (by norm_num)) hYpX
  obtain ⟨vTT, lTT⟩ := FieldElement51_Mul_mul.spec_val (hT.mono (by norm_num)) hT2d
  obtain ⟨vZZ, lZZ⟩ := FieldElement51_Mul_mul.spec_val (hZ.mono (by norm_num)) hZ₂
  obtain ⟨vZZ2, lZZ2⟩ := FieldElement51_Add_add.spec_val lZZ lZZ (by norm_num)
  obtain ⟨v1, l1⟩ :=
    FieldElement51_Sub_sub.spec_val (lPM.mono (by norm_num)) (lMP.mono (by norm_num))
  obtain ⟨v2, l2⟩ := FieldElement51_Add_add.spec_val lPM lMP (by norm_num)
  obtain ⟨v3, l3⟩ :=
    FieldElement51_Sub_sub.spec_val (lZZ2.mono (by norm_num)) (lTT.mono (by norm_num))
  obtain ⟨v4, l4⟩ := FieldElement51_Add_add.spec_val lZZ2 lTT (by norm_num)
  refine
    ⟨?_, l1.mono (by norm_num), l2.mono (by norm_num), l3.mono (by norm_num), l4.mono (by norm_num)⟩
  simp only [CompletedPoint.Compl, EdwardsPoint_Sub_ProjectiveNielsPoint_sub.spec, v1, v2, v3, v4,
    vPM, vMP, vTT, vZZ2, vZZ, vYpX, vYmX]
  exact isCompleted_sub_niels h₁ h₂ hc₁ hc₂

/-- `&P + &Q`, `P` extended below `2^52`, `Q` affine Niels below `2^54`, both on the curve:
completed coordinates of their sum, below `2^54`. -/
public theorem EdwardsPoint_Add_AffineNielsPoint_add.spec_val {P : EdwardsPoint}
    {Q : AffineNielsPoint} {x₁ y₁ x₂ y₂ : ZMod p} (hP : P.Lt (2 ^ 52)) (hQ : Q.Lt (2 ^ 54))
    (h₁ : P.Ext x₁ y₁) (h₂ : Q.Niels x₂ y₂) (hc₁ : OnCurve x₁ y₁) (hc₂ : OnCurve x₂ y₂) :
    (EdwardsPoint_Add_AffineNielsPoint_add.spec P Q).Compl (add x₁ y₁ x₂ y₂).1 (add x₁ y₁ x₂ y₂).2 ∧
      (EdwardsPoint_Add_AffineNielsPoint_add.spec P Q).Lt (2 ^ 54) := by
  obtain ⟨hX, hY, hZ, hT⟩ := hP
  obtain ⟨hYpX, hYmX, hXY⟩ := hQ
  obtain ⟨vYpX, lYpX⟩ := FieldElement51_Add_add.spec_val hY hX (by norm_num)
  obtain ⟨vYmX, lYmX⟩ :=
    FieldElement51_Sub_sub.spec_val (hY.mono (by norm_num)) (hX.mono (by norm_num))
  obtain ⟨vPP, lPP⟩ := FieldElement51_Mul_mul.spec_val (lYpX.mono (by norm_num)) hYpX
  obtain ⟨vMM, lMM⟩ := FieldElement51_Mul_mul.spec_val (lYmX.mono (by norm_num)) hYmX
  obtain ⟨vTT, lTT⟩ := FieldElement51_Mul_mul.spec_val (hT.mono (by norm_num)) hXY
  obtain ⟨vZ2, lZ2⟩ := FieldElement51_Add_add.spec_val hZ hZ (by norm_num)
  obtain ⟨v1, l1⟩ :=
    FieldElement51_Sub_sub.spec_val (lPP.mono (by norm_num)) (lMM.mono (by norm_num))
  obtain ⟨v2, l2⟩ := FieldElement51_Add_add.spec_val lPP lMM (by norm_num)
  obtain ⟨v3, l3⟩ := FieldElement51_Add_add.spec_val lZ2 lTT (by norm_num)
  obtain ⟨v4, l4⟩ :=
    FieldElement51_Sub_sub.spec_val (lZ2.mono (by norm_num)) (lTT.mono (by norm_num))
  refine
    ⟨?_, l1.mono (by norm_num), l2.mono (by norm_num), l3.mono (by norm_num), l4.mono (by norm_num)⟩
  simp only [CompletedPoint.Compl, EdwardsPoint_Add_AffineNielsPoint_add.spec, v1, v2, v3, v4, vPP,
    vMM, vTT, vZ2, vYpX, vYmX]
  exact isCompleted_add_affineNiels h₁ h₂ hc₁ hc₂

/-- `&P - &Q`, `P` extended below `2^52`, `Q` affine Niels below `2^54`, both on the curve:
completed coordinates of their difference, below `2^54`. -/
public theorem EdwardsPoint_Sub_AffineNielsPoint_sub.spec_val {P : EdwardsPoint}
    {Q : AffineNielsPoint} {x₁ y₁ x₂ y₂ : ZMod p} (hP : P.Lt (2 ^ 52)) (hQ : Q.Lt (2 ^ 54))
    (h₁ : P.Ext x₁ y₁) (h₂ : Q.Niels x₂ y₂) (hc₁ : OnCurve x₁ y₁) (hc₂ : OnCurve x₂ y₂) :
    (EdwardsPoint_Sub_AffineNielsPoint_sub.spec P Q).Compl (add x₁ y₁ (-x₂) y₂).1
        (add x₁ y₁ (-x₂) y₂).2 ∧
      (EdwardsPoint_Sub_AffineNielsPoint_sub.spec P Q).Lt (2 ^ 54) := by
  obtain ⟨hX, hY, hZ, hT⟩ := hP
  obtain ⟨hYpX, hYmX, hXY⟩ := hQ
  obtain ⟨vYpX, lYpX⟩ := FieldElement51_Add_add.spec_val hY hX (by norm_num)
  obtain ⟨vYmX, lYmX⟩ :=
    FieldElement51_Sub_sub.spec_val (hY.mono (by norm_num)) (hX.mono (by norm_num))
  obtain ⟨vPM, lPM⟩ := FieldElement51_Mul_mul.spec_val (lYpX.mono (by norm_num)) hYmX
  obtain ⟨vMP, lMP⟩ := FieldElement51_Mul_mul.spec_val (lYmX.mono (by norm_num)) hYpX
  obtain ⟨vTT, lTT⟩ := FieldElement51_Mul_mul.spec_val (hT.mono (by norm_num)) hXY
  obtain ⟨vZ2, lZ2⟩ := FieldElement51_Add_add.spec_val hZ hZ (by norm_num)
  obtain ⟨v1, l1⟩ :=
    FieldElement51_Sub_sub.spec_val (lPM.mono (by norm_num)) (lMP.mono (by norm_num))
  obtain ⟨v2, l2⟩ := FieldElement51_Add_add.spec_val lPM lMP (by norm_num)
  obtain ⟨v3, l3⟩ :=
    FieldElement51_Sub_sub.spec_val (lZ2.mono (by norm_num)) (lTT.mono (by norm_num))
  obtain ⟨v4, l4⟩ := FieldElement51_Add_add.spec_val lZ2 lTT (by norm_num)
  refine
    ⟨?_, l1.mono (by norm_num), l2.mono (by norm_num), l3.mono (by norm_num), l4.mono (by norm_num)⟩
  simp only [CompletedPoint.Compl, EdwardsPoint_Sub_AffineNielsPoint_sub.spec, v1, v2, v3, v4, vPM,
    vMP, vTT, vZ2, vYpX, vYmX]
  exact isCompleted_sub_affineNiels h₁ h₂ hc₁ hc₂

namespace mul

/-! ## `table_B` -/

/-- `table_B`'s global's bits. -/
abbrev bitsB : BitVec 61440 :=
  Ty.flatBits anon_042b818bc72209407b52bd0e4d6c8368_73.lit (w := 61440) (hw := rfl)

/-- Bits `8 m` to `8 m + 64` of `table_B`'s global: those of `BaseTable.serialNat`. -/
theorem bitsB_extract {m : ℕ} (hm : m + 8 ≤ 7680) :
    bitsB.extractLsb' (8 * m) 64 = BitVec.ofNat 64 (BaseTable.serialNat >>> (8 * m)) := by
  refine
    (congrArg (BitVec.extractLsb' _ 64) Ty.flatBits_eq).trans <| BitVec.extractLsb'_cast.trans ?_
  apply BitVec.eq_of_getLsbD_eq
  intro k hk
  have hs : (Ty.bv 8).stride = 8 := rfl
  have hw : (Ty.bv 8).width = 8 := rfl
  have h :=
    Ty.extractLsb'_flattenRaw_array anon_042b818bc72209407b52bd0e4d6c8368_73.lit (s := 8 * m + k)
      (w := 1)
      (by
        rw [hs]; omega)
      (by
        rw [hs, hw]; omega)
  have h0 := congrArg (fun x => x.getLsbD 0) h
  simp only [BitVec.getLsbD_extractLsb', Nat.add_zero, Ty.extractLsb'_flattenRaw_bv] at h0
  simp only [hs, BaseTable.serial_getElem (by omega : (8 * m + k) / 8 < 7680)] at h0
  rw [BitVec.getLsbD_extractLsb', BitVec.getLsbD_ofNat]
  simp [hk, Nat.testBit_shiftRight] at h0 ⊢
  rw [h0, BitVec.getLsbD_ofNat, Nat.testBit_shiftRight]
  simp only [show k % 8 < 8 by omega, decide_true, Bool.true_and]
  congr 1
  omega

/-- `table_B[j]`, `j < 64`, is `BaseTable`'s serial entry `j`. -/
public theorem tableB_eq {j : ℕ} (hj : j < 64) :
    tableB j =
      ⟨BaseTable.serialLimbs j 0, BaseTable.serialLimbs j 1, BaseTable.serialLimbs j 2⟩ := by
  have e (o f : ℕ) (hf : f < 3) (ho : o = 960 * j + 320 * f) :
    (fun k : Fin 5 => bitsB.extractLsb' (o + 64 * k.val) 64) = BaseTable.serialLimbs j f :=
    funext fun k => by
      rw [show o + 64 * k.val = 8 * (120 * j + 40 * f + 8 * k.val) by omega]
      exact bitsB_extract (by omega)
  exact
    congr
      (congr (congrArg AffineNielsPoint.mk (e (960 * j) 0 (by omega) (by omega)))
        (e (960 * j + 320) 1 (by omega) (by omega)))
      (e (960 * j + 640) 2 (by omega) (by omega))

/-- `table_B[j]`, `j < 64`, is `(2 j + 1) B` as an `AffineNielsPoint`, below `2^52`. -/
public theorem tableB_val {j : ℕ} (hj : j < 64) :
    (tableB j).Niels ((2 * j + 1) • basePoint).x ((2 * j + 1) • basePoint).y ∧
      (tableB j).Lt (2 ^ 52) := by
  obtain ⟨h, hb⟩ := BaseTable.serial_entry hj
  rw [tableB_eq hj]
  exact ⟨h, hb 0 (by omega), hb 1 (by omega), hb 2 (by omega)⟩

/-! ## Digits -/

/-- A positive width-`w` digit halves to the index of its multiple, below `2^(w-1)`. -/
theorem idx_pos {w : ℕ} {d : BitVec 8} (hd : Naf.Digit w d.toInt) (hp : (0#8).slt d = true) :
    ((2 * (d >>> 1).toNat + 1 : ℕ) : ℤ) = d.toInt ∧ 2 * (d >>> 1).toNat + 1 < 2 ^ (w - 1) := by
  have h1 : 0 < d.toInt := by simpa only [BitVec.slt, decide_eq_true_eq, BitVec.toInt_zero] using hp
  have h2 : d.toInt = d.toNat := by
    have hc := BitVec.toInt_eq_toNat_cond d
    have := d.isLt
    split at hc <;> omega
  have hH : ((2 ^ (w - 1) : ℕ) : ℤ) = 2 ^ (w - 1) := by norm_num
  unfold Naf.Digit at hd
  rw [← hH] at hd
  generalize 2 ^ (w - 1) = H at hd ⊢
  rw [BitVec.toNat_ushiftRight, Nat.shiftRight_one]
  omega

/-- A negative width-`w` digit, `w ≤ 8`, negated, halves to the index of its multiple, below
`2^(w-1)`. -/
theorem idx_neg {w : ℕ} {d : BitVec 8} (hw : w ≤ 8) (hd : Naf.Digit w d.toInt)
    (hn : d.slt 0#8 = true) :
    ((2 * ((-d) >>> 1).toNat + 1 : ℕ) : ℤ) = -d.toInt ∧
      2 * ((-d) >>> 1).toNat + 1 < 2 ^ (w - 1) := by
  have h1 : d.toInt < 0 := by simpa only [BitVec.slt, decide_eq_true_eq, BitVec.toInt_zero] using hn
  have h2 : d.toInt = d.toNat - 256 ∧ 128 ≤ d.toNat := by
    have hc := BitVec.toInt_eq_toNat_cond d
    have := d.isLt
    split at hc <;> omega
  have h3 : (-d).toNat = 256 - d.toNat := by
    rw [BitVec.toNat_neg]
    have := d.isLt
    omega
  have h128 := hd.lt_128 hw
  have hH : ((2 ^ (w - 1) : ℕ) : ℤ) = 2 ^ (w - 1) := by norm_num
  unfold Naf.Digit at hd
  rw [← hH] at hd
  generalize 2 ^ (w - 1) = H at hd ⊢
  rw [BitVec.toNat_ushiftRight, Nat.shiftRight_one, h3]
  omega

/-- A digit neither positive nor negative is `0`. -/
theorem eq_zero_of_not {d : BitVec 8} (hp : ¬(0#8).slt d = true) (hn : ¬d.slt 0#8 = true) :
    d = 0#8 := by
  simp only [BitVec.slt, decide_eq_true_eq, BitVec.toInt_zero, not_lt] at hp hn
  have h0 : d.toInt = 0 := by omega
  exact BitVec.eq_of_toInt_eq (by rw [h0, BitVec.toInt_zero])

/-- Digit `i` of the width-`w` NAF's bytes, `2 ≤ w ≤ 8`, `x < 2^255`, as an `i8`: a width-`w`
digit. -/
theorem digit_spec {x : BitVec 256} {w : ℕ} (h2 : 2 ≤ w) (h8 : w ≤ 8) (hx : x.toNat < 2 ^ 255)
    {i : ℕ} (hi : i < 256) : Naf.Digit w (digit (Scalar_non_adjacent_form.spec x w) i).toInt := by
  rw [Scalar_non_adjacent_form.toInt_lane_spec h2 h8 hx i hi]
  exact Naf.digit_naf h2 hx i hi

/-! ## The adds and an iteration -/

/-- Projective coordinates of `R`, below `2^52`. -/
abbrev PR (r : ProjectivePoint) (R : Point) : Prop :=
  r.Proj R.x R.y ∧ r.Lt (2 ^ 52)

/-- Completed coordinates of `R`, below `2^54`. -/
abbrev CR (t : CompletedPoint) (R : Point) : Prop :=
  t.Compl R.x R.y ∧ t.Lt (2 ^ 54)

theorem PR.congr {r : ProjectivePoint} {R S : Point} (h : PR r R) (e : R = S) : PR r S :=
  e ▸ h

/-- `a_naf[i]`'s add takes `t`, `R`, to `R + d A`, `tA` holding `A`'s odd multiples. -/
theorem addA_compl {w : ℕ} {tA : ℕ → ProjectiveNielsPoint} {PA R : Point} {t : CompletedPoint}
    {d : BitVec 8}
    (htA :
      ∀ k,
        2 * k + 1 < 2 ^ (w - 1) →
          (tA k).Niels ((2 * k + 1) • PA).x ((2 * k + 1) • PA).y ∧ (tA k).Lt (2 ^ 54))
    (hw : w ≤ 8) (hd : Naf.Digit w d.toInt) (ht : CR t R) :
    CR (addA tA d t) (R + d.toInt • PA) := by
  obtain ⟨he, ⟨eX, eY, eZ, eT⟩⟩ := CompletedPoint_as_extended.spec_val ht.2 ht.1
  have hE : (CompletedPoint_as_extended.spec t).Lt (2 ^ 53) :=
    ⟨eX.mono (by norm_num), eY.mono (by norm_num), eZ.mono (by norm_num), eT.mono (by norm_num)⟩
  unfold addA
  split_ifs with hp hn
  · obtain ⟨e, hk⟩ := idx_pos hd hp
    obtain ⟨hN, hl⟩ := htA _ hk
    have hs : (2 * (d >>> 1).toNat + 1) • PA = d.toInt • PA := by rw [← natCast_zsmul, e]
    rw [hs] at hN
    obtain ⟨c, l⟩ :=
      EdwardsPoint_Add_ProjectiveNielsPoint_add.spec_val hE hl he hN R.on (_ : Point).on
    rw [← Point.add_x, ← Point.add_y] at c
    exact ⟨c, l⟩
  · obtain ⟨e, hk⟩ := idx_neg hw hd hn
    obtain ⟨hN, hl⟩ := htA _ hk
    obtain ⟨c, l⟩ :=
      EdwardsPoint_Sub_ProjectiveNielsPoint_sub.spec_val hE hl he hN R.on (_ : Point).on
    rw [← Point.sub_x, ← Point.sub_y] at c
    have hs : R - (2 * ((-d) >>> 1).toNat + 1) • PA = R + d.toInt • PA := by
      rw [← natCast_zsmul, e, neg_smul, sub_neg_eq_add]
    rw [hs] at c
    exact ⟨c, l⟩
  · rw [eq_zero_of_not hp hn, BitVec.toInt_zero, zero_smul, add_zero]
    exact ht

/-- `b_naf[i]`'s add takes `t`, `R`, to `R + d B`, `tB` holding `B`'s odd multiples. -/
theorem addB_compl {w : ℕ} {tB : ℕ → AffineNielsPoint} {PB R : Point} {t : CompletedPoint}
    {d : BitVec 8}
    (htB :
      ∀ k,
        2 * k + 1 < 2 ^ (w - 1) →
          (tB k).Niels ((2 * k + 1) • PB).x ((2 * k + 1) • PB).y ∧ (tB k).Lt (2 ^ 54))
    (hw : w ≤ 8) (hd : Naf.Digit w d.toInt) (ht : CR t R) :
    CR (addB tB d t) (R + d.toInt • PB) := by
  obtain ⟨he, hE⟩ := CompletedPoint_as_extended.spec_val ht.2 ht.1
  unfold addB
  split_ifs with hp hn
  · obtain ⟨e, hk⟩ := idx_pos hd hp
    obtain ⟨hN, hl⟩ := htB _ hk
    have hs : (2 * (d >>> 1).toNat + 1) • PB = d.toInt • PB := by rw [← natCast_zsmul, e]
    rw [hs] at hN
    obtain ⟨c, l⟩ := EdwardsPoint_Add_AffineNielsPoint_add.spec_val hE hl he hN R.on (_ : Point).on
    rw [← Point.add_x, ← Point.add_y] at c
    exact ⟨c, l⟩
  · obtain ⟨e, hk⟩ := idx_neg hw hd hn
    obtain ⟨hN, hl⟩ := htB _ hk
    obtain ⟨c, l⟩ := EdwardsPoint_Sub_AffineNielsPoint_sub.spec_val hE hl he hN R.on (_ : Point).on
    rw [← Point.sub_x, ← Point.sub_y] at c
    have hs : R - (2 * ((-d) >>> 1).toNat + 1) • PB = R + d.toInt • PB := by
      rw [← natCast_zsmul, e, neg_smul, sub_neg_eq_add]
    rw [hs] at c
    exact ⟨c, l⟩
  · rw [eq_zero_of_not hp hn, BitVec.toInt_zero, zero_smul, add_zero]
    exact ht

/-- An iteration takes `r`, `R`, to `2 R + da A + db B`. -/
theorem step_proj {wa wb : ℕ} {tA : ℕ → ProjectiveNielsPoint} {tB : ℕ → AffineNielsPoint}
    {PA PB R : Point} {r : ProjectivePoint} {da db : BitVec 8}
    (htA :
      ∀ k,
        2 * k + 1 < 2 ^ (wa - 1) →
          (tA k).Niels ((2 * k + 1) • PA).x ((2 * k + 1) • PA).y ∧ (tA k).Lt (2 ^ 54))
    (htB :
      ∀ k,
        2 * k + 1 < 2 ^ (wb - 1) →
          (tB k).Niels ((2 * k + 1) • PB).x ((2 * k + 1) • PB).y ∧ (tB k).Lt (2 ^ 54))
    (hwa : wa ≤ 8) (hwb : wb ≤ 8) (hda : Naf.Digit wa da.toInt) (hdb : Naf.Digit wb db.toInt)
    (hr : PR r R) : PR (step tA tB da db r) (2 • R + da.toInt • PA + db.toInt • PB) := by
  obtain ⟨hX, hY, hZ⟩ := hr.2
  obtain ⟨c, l⟩ :=
    ProjectivePoint_double.spec_val
      ⟨hX.mono (by norm_num), hY.mono (by norm_num), hZ.mono (by norm_num)⟩ hr.1 R.on
  rw [Point.dbl_eq, ← two_nsmul] at c
  have h := addB_compl htB hwb hdb (addA_compl htA hwa hda ⟨c, l⟩)
  exact CompletedPoint_as_projective.spec_val h.2 h.1

/-! ## The ladder -/

/-- The value of a NAF's low `i` digits, `Σ_{k < i} naf[k] 2^k`, signed. -/
def low (naf : BitVec (8 * 256)) (i : ℕ) : ℤ :=
  ∑ k ∈ Finset.range i, (digit naf k).toInt * 2 ^ k

theorem low_succ (naf : BitVec (8 * 256)) (i : ℕ) :
    low naf (i + 1) = low naf i + (digit naf i).toInt * 2 ^ i :=
  Finset.sum_range_succ _ _

/-- Zero digits from `j` on add nothing. -/
theorem low_add {naf : BitVec (8 * 256)} {j : ℕ} (hz : ∀ k, j ≤ k → k < 256 → digit naf k = 0#8) :
    ∀ m, j + m ≤ 256 → low naf (j + m) = low naf j
  | 0, _ => rfl
  | m + 1, h => by
    rw [← Nat.add_assoc, low_succ, hz _ (by omega) (by omega), BitVec.toInt_zero, zero_mul,
      add_zero, low_add hz m (by omega)]

/-- All 256 digits of `x`'s NAF, `x < 2^255`: `x`. -/
theorem low_256 {x : BitVec 256} {w : ℕ} (h2 : 2 ≤ w) (h8 : w ≤ 8) (hx : x.toNat < 2 ^ 255) :
    low (Scalar_non_adjacent_form.spec x w) 256 = x.toNat := by
  rw [← Naf.val_naf h2 hx, low, Naf.val, ← Fin.sum_univ_eq_sum_range]
  refine Finset.sum_congr rfl fun i _ => ?_
  rw [Scalar_non_adjacent_form.toInt_lane_spec h2 h8 hx i i.isLt]
  rfl

/-- The main loop from `i` on `r`, `R`: `2^(i+1) R` plus the digits up to `i`. -/
theorem ladder_proj {wa wb : ℕ} {tA : ℕ → ProjectiveNielsPoint} {tB : ℕ → AffineNielsPoint}
    {PA PB : Point} {a_naf b_naf : BitVec (8 * 256)}
    (htA :
      ∀ k,
        2 * k + 1 < 2 ^ (wa - 1) →
          (tA k).Niels ((2 * k + 1) • PA).x ((2 * k + 1) • PA).y ∧ (tA k).Lt (2 ^ 54))
    (htB :
      ∀ k,
        2 * k + 1 < 2 ^ (wb - 1) →
          (tB k).Niels ((2 * k + 1) • PB).x ((2 * k + 1) • PB).y ∧ (tB k).Lt (2 ^ 54))
    (hwa : wa ≤ 8) (hwb : wb ≤ 8) (hda : ∀ k < 256, Naf.Digit wa (digit a_naf k).toInt)
    (hdb : ∀ k < 256, Naf.Digit wb (digit b_naf k).toInt) :
    ∀ i,
      i < 256 →
        ∀ {r : ProjectivePoint} {R : Point},
          PR r R →
            PR (ladder tA tB a_naf b_naf i r)
              ((2 ^ (i + 1) : ℤ) • R + low a_naf (i + 1) • PA + low b_naf (i + 1) • PB)
  | 0, h, r, R, hr => by
    rw [ladder]
    refine (step_proj htA htB hwa hwb (hda 0 h) (hdb 0 h) hr).congr ?_
    simp only [low, Finset.sum_range_one, pow_zero, mul_one, zero_add, pow_one]
    module
  | i + 1, h, r, R, hr => by
    rw [ladder]
    have hl :=
      ladder_proj htA htB hwa hwb hda hdb i (by omega)
        (step_proj htA htB hwa hwb (hda _ h) (hdb _ h) hr)
    refine hl.congr ?_
    rw [low_succ a_naf (i + 1), low_succ b_naf (i + 1)]
    module

/-! ## The first non-zero digit -/

theorem start_le (a_naf b_naf : BitVec (8 * 256)) : ∀ j, start a_naf b_naf j ≤ j
  | 0 => le_rfl
  | j + 1 => by
    rw [start]
    split_ifs
    · exact (start_le a_naf b_naf j).trans (by omega)
    · exact le_rfl

/-- The digits above `start`'s index, up to `j`, are zero. -/
theorem start_zero (a_naf b_naf : BitVec (8 * 256)) :
    ∀ j k, start a_naf b_naf j < k → k ≤ j → digit a_naf k = 0#8 ∧ digit b_naf k = 0#8
  | 0, _, h, hk => by
    rw [start] at h
    omega
  | j + 1, k, h, hk => by
    rw [start] at h
    split_ifs at h with hz
    · by_cases hkj : k = j + 1
      · exact hkj ▸ hz
      · exact start_zero a_naf b_naf j k h (by omega)
    · omega

end mul

/-! ## `a A + b B` -/

open mul in
/-- `vartime_double_base::mul(a, A, b)`, `A` extended below `2^53` of `Q`, `a, b < 2^255`: extended
coordinates of `a Q + b B`, below `2^52`. -/
public theorem mul.spec_val {A : EdwardsPoint} {Q : Point} (hb : A.Lt (2 ^ 53)) (h : A.Ext Q.x Q.y)
    {a b : BitVec 256} (ha : a.toNat < 2 ^ 255) (hb' : b.toNat < 2 ^ 255) :
    (mul.spec a A b).Ext (a.toNat • Q + b.toNat • basePoint).x
        (a.toNat • Q + b.toNat • basePoint).y ∧
      (mul.spec a A b).Lt (2 ^ 52) := by
  have htA := fun k (_ : 2 * k + 1 < 2 ^ (5 - 1)) =>
    NafLookupTable5_ProjectiveNielsPoint_From_EdwardsPoint_from.Ai_val hb h k
  have htB :
    ∀ k,
      2 * k + 1 < 2 ^ (8 - 1) →
        (tableB k).Niels ((2 * k + 1) • basePoint).x ((2 * k + 1) • basePoint).y ∧
          (tableB k).Lt (2 ^ 54) := by
    intro k hk
    rw [show (2 : ℕ) ^ (8 - 1) = 128 from rfl] at hk
    obtain ⟨h1, h2, h3, h4⟩ := tableB_val (j := k) (by omega)
    exact ⟨h1, h2.mono (by norm_num), h3.mono (by norm_num), h4.mono (by norm_num)⟩
  have hda := fun k (hk : k < 256) => digit_spec (w := 5) (by decide) (by decide) ha hk
  have hdb := fun k (hk : k < 256) => digit_spec (w := 8) (by decide) (by decide) hb' hk
  unfold mul.spec
  dsimp only
  generalize hs :
    start (Scalar_non_adjacent_form.spec a 5) (Scalar_non_adjacent_form.spec b 8) 255 = s
  have hs255 : s ≤ 255 := hs ▸ start_le _ _ 255
  have hz :=
    hs ▸ start_zero (Scalar_non_adjacent_form.spec a 5) (Scalar_non_adjacent_form.spec b 8) 255
  have e1 :=
    low_add (j := s + 1) (fun k hk hk' => (hz k (by omega) (by omega)).1) (255 - s) (by omega)
  have e2 :=
    low_add (j := s + 1) (fun k hk hk' => (hz k (by omega) (by omega)).2) (255 - s) (by omega)
  rw [show s + 1 + (255 - s) = 256 by omega, low_256 (by decide) (by decide) ha] at e1
  rw [show s + 1 + (255 - s) = 256 by omega, low_256 (by decide) (by decide) hb'] at e2
  have hl :=
    ladder_proj htA htB (by decide) (by decide) hda hdb s (by omega)
      ProjectivePoint_identity.spec_val
  obtain ⟨hp, hX, hY, hZ⟩ :=
    hl.congr (S := a.toNat • Q + b.toNat • basePoint)
      (by rw [← e1, ← e2, smul_zero, zero_add, natCast_zsmul, natCast_zsmul])
  exact
    ProjectivePoint_as_extended.spec_val
      ⟨hX.mono (by norm_num), hY.mono (by norm_num), hZ.mono (by norm_num)⟩ hp

end Serial

end MLIR.Agave
