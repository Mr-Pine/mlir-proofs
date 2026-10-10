module

public import Agave.Math.Point
public import Ed25519.Decode
public import Agave.Math.FieldElement51
public import Agave.Serial.CompletedPoint_as_extended
public import Agave.Serial.CompletedPoint_as_projective
public import Agave.Serial.EdwardsPoint_as_projective_niels
public import Agave.Serial.EdwardsPoint_Add_ProjectiveNielsPoint_add
public import Agave.Serial.ProjectivePoint_double
public import Agave.Serial.EdwardsPoint_is_small_order
import Mathlib.Tactic.ReduceModChar
import Mathlib.Tactic.Ring

/-! The serial point specs in `ZMod p`: each computes its `Point` formula on the coordinates' values
(`IsExt`, `IsProj`, `IsCompleted`, `IsNiels`), under dalek's limb bounds. -/

namespace MLIR.Agave

open _root_.Ed25519

/-! ## Definitions -/

@[expose] public section

/-- Every coordinate's limbs below `c`. -/
abbrev EdwardsPoint.Lt (P : EdwardsPoint) (c : ℕ) : Prop :=
  Limbs.Lt P.X c ∧ Limbs.Lt P.Y c ∧ Limbs.Lt P.Z c ∧ Limbs.Lt P.T c

/-- Every coordinate's limbs below `c`. -/
abbrev ProjectivePoint.Lt (P : ProjectivePoint) (c : ℕ) : Prop :=
  Limbs.Lt P.X c ∧ Limbs.Lt P.Y c ∧ Limbs.Lt P.Z c

/-- Every coordinate's limbs below `c`. -/
abbrev CompletedPoint.Lt (P : CompletedPoint) (c : ℕ) : Prop :=
  Limbs.Lt P.X c ∧ Limbs.Lt P.Y c ∧ Limbs.Lt P.Z c ∧ Limbs.Lt P.T c

/-- Every coordinate's limbs below `c`. -/
abbrev ProjectiveNielsPoint.Lt (P : ProjectiveNielsPoint) (c : ℕ) : Prop :=
  Limbs.Lt P.Y_plus_X c ∧ Limbs.Lt P.Y_minus_X c ∧ Limbs.Lt P.Z c ∧ Limbs.Lt P.T2d c

/-- `P`'s values are extended coordinates of `(x, y)`. -/
abbrev EdwardsPoint.Ext (P : EdwardsPoint) (x y : ZMod p) : Prop :=
  IsExt x y (Limbs.val P.X) (Limbs.val P.Y) (Limbs.val P.T) (Limbs.val P.Z)

/-- `P`'s values are projective coordinates of `(x, y)`. -/
abbrev ProjectivePoint.Proj (P : ProjectivePoint) (x y : ZMod p) : Prop :=
  IsProj x y (Limbs.val P.X) (Limbs.val P.Y) (Limbs.val P.Z)

/-- `P`'s values are completed coordinates of `(x, y)`. -/
abbrev CompletedPoint.Compl (P : CompletedPoint) (x y : ZMod p) : Prop :=
  IsCompleted x y (Limbs.val P.X) (Limbs.val P.Y) (Limbs.val P.Z) (Limbs.val P.T)

/-- `P`'s values are Niels coordinates of `(x, y)`. -/
abbrev ProjectiveNielsPoint.Niels (P : ProjectiveNielsPoint) (x y : ZMod p) : Prop :=
  IsNiels x y (Limbs.val P.Y_plus_X) (Limbs.val P.Y_minus_X) (Limbs.val P.Z) (Limbs.val P.T2d)

end

namespace Serial

/-! ## Constants -/

/-- `EDWARDS_D2` is `2d`, in 51-bit limbs. -/
public theorem EDWARDS_D2.val : Limbs.val EDWARDS_D2 = 2 * d ∧ Limbs.Lt EDWARDS_D2 (2 ^ 51) := by
  refine
    ⟨?_, by
      rw [Limbs.lt_iff]; decide⟩
  rw [Limbs.val_eq]
  unfold d
  simp [EDWARDS_D2]
  reduce_mod_char

public theorem FieldElement51.ZERO_val : Limbs.val FieldElement51.ZERO = 0 := by
  simp [Limbs.val_eq, FieldElement51.ZERO]

public theorem FieldElement51.ONE_val : Limbs.val FieldElement51.ONE = 1 := by
  simp [Limbs.val_eq, FieldElement51.ONE]

/-! ## `square2` -/

/-- `a.square2()` takes limbs below `2^54` to `2 a²` in limbs below `2^53`. -/
public theorem FieldElement51_square2.spec_val {a : Fin 5 → BitVec 64} (ha : Limbs.Lt a (2 ^ 54)) :
    Limbs.val (FieldElement51_square2.spec a) = 2 * Limbs.val a ^ 2 ∧
      Limbs.Lt (FieldElement51_square2.spec a) (2 ^ 53) := by
  obtain ⟨hv, hl⟩ := FieldElement51_pow2k.spec_val (k := 1) (by decide) ha
  have e (i : Fin 5) :
    (FieldElement51_square2.spec a i).toNat = 2 * (FieldElement51_pow2k.spec a 1 i).toNat := by
    have := hl i
    simp only [FieldElement51_square2.spec, BitVec.toNat_shiftLeft, Nat.shiftLeft_eq]
    rw [Nat.mod_eq_of_lt (by omega)]
    ring
  refine
    ⟨?_, fun i => by
      rw [e]; have := hl i; omega⟩
  rw [show Limbs.val a ^ 2 = Limbs.val a ^ 2 ^ 1 by norm_num, ← hv]
  simp only [Limbs.val, e, Finset.mul_sum]
  refine Finset.sum_congr rfl fun i _ => ?_
  push_cast
  ring

/-! ## Conversions -/

/-- `as_extended` of completed coordinates below `2^54`: extended ones below `2^52`. -/
public theorem CompletedPoint_as_extended.spec_val {P : CompletedPoint} {x y : ZMod p}
    (hb : P.Lt (2 ^ 54)) (h : P.Compl x y) :
    (CompletedPoint_as_extended.spec P).Ext x y ∧
      (CompletedPoint_as_extended.spec P).Lt (2 ^ 52) := by
  obtain ⟨hX, hY, hZ, hT⟩ := hb
  obtain ⟨v1, l1⟩ := FieldElement51_Mul_mul.spec_val hX hT
  obtain ⟨v2, l2⟩ := FieldElement51_Mul_mul.spec_val hY hZ
  obtain ⟨v3, l3⟩ := FieldElement51_Mul_mul.spec_val hZ hT
  obtain ⟨v4, l4⟩ := FieldElement51_Mul_mul.spec_val hX hY
  refine ⟨?_, l1, l2, l3, l4⟩
  simp only [EdwardsPoint.Ext, CompletedPoint_as_extended.spec, v1, v2, v3, v4]
  exact h.isExt

/-- `as_projective` of completed coordinates below `2^54`: projective ones below `2^52`. -/
public theorem CompletedPoint_as_projective.spec_val {P : CompletedPoint} {x y : ZMod p}
    (hb : P.Lt (2 ^ 54)) (h : P.Compl x y) :
    (CompletedPoint_as_projective.spec P).Proj x y ∧
      (CompletedPoint_as_projective.spec P).Lt (2 ^ 52) := by
  obtain ⟨hX, hY, hZ, hT⟩ := hb
  obtain ⟨v1, l1⟩ := FieldElement51_Mul_mul.spec_val hX hT
  obtain ⟨v2, l2⟩ := FieldElement51_Mul_mul.spec_val hY hZ
  obtain ⟨v3, l3⟩ := FieldElement51_Mul_mul.spec_val hZ hT
  refine ⟨?_, l1, l2, l3⟩
  simp only [ProjectivePoint.Proj, CompletedPoint_as_projective.spec, v1, v2, v3]
  exact h.isProj

/-- `as_projective_niels` of extended coordinates below `2^53`: Niels ones below `2^54`. -/
public theorem EdwardsPoint_as_projective_niels.spec_val {P : EdwardsPoint} {x y : ZMod p}
    (hb : P.Lt (2 ^ 53)) (h : P.Ext x y) :
    (EdwardsPoint_as_projective_niels.spec P).Niels x y ∧
      (EdwardsPoint_as_projective_niels.spec P).Lt (2 ^ 54) := by
  obtain ⟨hX, hY, hZ, hT⟩ := hb
  obtain ⟨vd, ld⟩ := EDWARDS_D2.val
  obtain ⟨v1, l1⟩ := FieldElement51_Add_add.spec_val hY hX (by norm_num)
  obtain ⟨v2, l2⟩ := FieldElement51_Sub_sub.spec_val (hY.mono (by norm_num)) (hX.mono (by norm_num))
  obtain ⟨v4, l4⟩ := FieldElement51_Mul_mul.spec_val (hT.mono (by norm_num)) (ld.mono (by norm_num))
  refine
    ⟨?_, l1.mono (by norm_num), l2.mono (by norm_num), hZ.mono (by norm_num), l4.mono (by norm_num)⟩
  simp only [ProjectiveNielsPoint.Niels, EdwardsPoint_as_projective_niels.spec, v1, v2, v4, vd]
  exact IsExt.isNiels h

/-! ## Doubling and addition -/

/-- `double` of projective coordinates below `2^53` of a point on the curve: completed ones of its
double, below `2^54`. -/
public theorem ProjectivePoint_double.spec_val {P : ProjectivePoint} {x y : ZMod p}
    (hb : P.Lt (2 ^ 53)) (h : P.Proj x y) (hc : OnCurve x y) :
    (ProjectivePoint_double.spec P).Compl (dbl x y).1 (dbl x y).2 ∧
      (ProjectivePoint_double.spec P).Lt (2 ^ 54) := by
  obtain ⟨hX, hY, hZ⟩ := hb
  obtain ⟨vXX, lXX⟩ := FieldElement51_square.spec_val (hX.mono (by norm_num))
  obtain ⟨vYY, lYY⟩ := FieldElement51_square.spec_val (hY.mono (by norm_num))
  obtain ⟨vZZ2, lZZ2⟩ := FieldElement51_square2.spec_val (hZ.mono (by norm_num))
  obtain ⟨vXpY, lXpY⟩ := FieldElement51_Add_add.spec_val hX hY (by norm_num)
  obtain ⟨vXpY2, lXpY2⟩ := FieldElement51_square.spec_val (lXpY.mono (by norm_num))
  obtain ⟨vYpX, lYpX⟩ := FieldElement51_Add_add.spec_val lYY lXX (by norm_num)
  obtain ⟨vYmX, lYmX⟩ :=
    FieldElement51_Sub_sub.spec_val (lYY.mono (by norm_num)) (lXX.mono (by norm_num))
  obtain ⟨v1, l1⟩ :=
    FieldElement51_Sub_sub.spec_val (lXpY2.mono (by norm_num)) (lYpX.mono (by norm_num))
  obtain ⟨v4, l4⟩ :=
    FieldElement51_Sub_sub.spec_val (lZZ2.mono (by norm_num)) (lYmX.mono (by norm_num))
  refine
    ⟨?_, l1.mono (by norm_num), lYpX.mono (by norm_num), lYmX.mono (by norm_num),
      l4.mono (by norm_num)⟩
  simp only [CompletedPoint.Compl, ProjectivePoint_double.spec, v1, v4, vYpX, vYmX, vXpY2, vXpY,
    vXX, vYY, vZZ2]
  exact isCompleted_dbl h hc

/-- `&P + &Q`, `P` extended below `2^53`, `Q` Niels below `2^54`, both on the curve: completed
coordinates of their sum, below `2^54`. -/
public theorem EdwardsPoint_Add_ProjectiveNielsPoint_add.spec_val {P : EdwardsPoint}
    {Q : ProjectiveNielsPoint} {x₁ y₁ x₂ y₂ : ZMod p} (hP : P.Lt (2 ^ 53)) (hQ : Q.Lt (2 ^ 54))
    (h₁ : P.Ext x₁ y₁) (h₂ : Q.Niels x₂ y₂) (hc₁ : OnCurve x₁ y₁) (hc₂ : OnCurve x₂ y₂) :
    let R := add x₁ y₁ x₂ y₂
    (EdwardsPoint_Add_ProjectiveNielsPoint_add.spec P Q).Compl R.1 R.2 ∧
      (EdwardsPoint_Add_ProjectiveNielsPoint_add.spec P Q).Lt (2 ^ 54) := by
  intro R
  obtain ⟨hX, hY, hZ, hT⟩ := hP
  obtain ⟨hYpX, hYmX, hZ₂, hT2d⟩ := hQ
  obtain ⟨vYpX, lYpX⟩ := FieldElement51_Add_add.spec_val hY hX (by norm_num)
  obtain ⟨vYmX, lYmX⟩ :=
    FieldElement51_Sub_sub.spec_val (hY.mono (by norm_num)) (hX.mono (by norm_num))
  obtain ⟨vPP, lPP⟩ := FieldElement51_Mul_mul.spec_val (lYpX.mono (by norm_num)) hYpX
  obtain ⟨vMM, lMM⟩ := FieldElement51_Mul_mul.spec_val (lYmX.mono (by norm_num)) hYmX
  obtain ⟨vTT, lTT⟩ := FieldElement51_Mul_mul.spec_val (hT.mono (by norm_num)) hT2d
  obtain ⟨vZZ, lZZ⟩ := FieldElement51_Mul_mul.spec_val (hZ.mono (by norm_num)) hZ₂
  obtain ⟨vZZ2, lZZ2⟩ := FieldElement51_Add_add.spec_val lZZ lZZ (by norm_num)
  obtain ⟨v1, l1⟩ :=
    FieldElement51_Sub_sub.spec_val (lPP.mono (by norm_num)) (lMM.mono (by norm_num))
  obtain ⟨v2, l2⟩ := FieldElement51_Add_add.spec_val lPP lMM (by norm_num)
  obtain ⟨v3, l3⟩ := FieldElement51_Add_add.spec_val lZZ2 lTT (by norm_num)
  obtain ⟨v4, l4⟩ :=
    FieldElement51_Sub_sub.spec_val (lZZ2.mono (by norm_num)) (lTT.mono (by norm_num))
  refine
    ⟨?_, l1.mono (by norm_num), l2.mono (by norm_num), l3.mono (by norm_num), l4.mono (by norm_num)⟩
  simp only [CompletedPoint.Compl, EdwardsPoint_Add_ProjectiveNielsPoint_add.spec, v1, v2, v3, v4,
    vPP, vMM, vTT, vZZ2, vZZ, vYpX, vYmX]
  exact isCompleted_add_niels h₁ h₂ hc₁ hc₂

/-! ## Small order -/

/-- Projective coordinates of the neutral point, as `ct_eq` with `(0 : 1 : 1)` tests them. -/
theorem isProj_eq_zero_iff {x y X Y Z : ZMod p} (h : IsProj x y X Y Z) :
    X * 1 = 0 * Z ∧ Y * 1 = 1 * Z ↔ (x, y) = (0, 1) := by
  obtain ⟨hZ, rfl, rfl⟩ := h
  simp only [mul_one, zero_mul, one_mul, Prod.mk.injEq, mul_eq_zero, hZ, or_false]
  exact
    and_congr_right fun _ =>
      ⟨fun h => mul_right_cancel₀ hZ (h.trans (one_mul Z).symm), fun h => by rw [h, one_mul]⟩

/-- `mul_by_cofactor` of extended coordinates below `2^53` of a point on the curve: extended ones of
its eighth multiple, below `2^52`. -/
public theorem EdwardsPoint_mul_by_cofactor.spec_val {P : EdwardsPoint} {x y : ZMod p}
    (hb : P.Lt (2 ^ 53)) (h : P.Ext x y) (hc : OnCurve x y) :
    (EdwardsPoint_mul_by_cofactor.spec P).Ext (dblN 3 (x, y)).1 (dblN 3 (x, y)).2 ∧
      (EdwardsPoint_mul_by_cofactor.spec P).Lt (2 ^ 52) := by
  obtain ⟨hX, hY, hZ, -⟩ := hb
  have hc₁ := dbl_onCurve hc
  have hc₂ := dbl_onCurve hc₁
  obtain ⟨c1, b1⟩ :=
    ProjectivePoint_double.spec_val (P := ⟨P.X, P.Y, P.Z⟩) ⟨hX, hY, hZ⟩ (IsExt.isProj h) hc
  obtain ⟨p1, ⟨b1X, b1Y, b1Z⟩⟩ := CompletedPoint_as_projective.spec_val b1 c1
  obtain ⟨c2, b2⟩ :=
    ProjectivePoint_double.spec_val
      ⟨b1X.mono (by norm_num), b1Y.mono (by norm_num), b1Z.mono (by norm_num)⟩ p1 hc₁
  obtain ⟨p2, ⟨b2X, b2Y, b2Z⟩⟩ := CompletedPoint_as_projective.spec_val b2 c2
  obtain ⟨c3, b3⟩ :=
    ProjectivePoint_double.spec_val
      ⟨b2X.mono (by norm_num), b2Y.mono (by norm_num), b2Z.mono (by norm_num)⟩ p2 hc₂
  exact CompletedPoint_as_extended.spec_val b3 c3

/-- `is_small_order` of extended coordinates below `2^53` of a point on the curve: `1` exactly when
it is of small order. -/
public theorem EdwardsPoint_is_small_order.spec_val {P : EdwardsPoint} {x y : ZMod p}
    (hb : P.Lt (2 ^ 53)) (h : P.Ext x y) (hc : OnCurve x y) :
    EdwardsPoint_is_small_order.spec P = if SmallOrder x y then 1#1 else 0#1 := by
  obtain ⟨he, ⟨bX, bY, bZ, -⟩⟩ := EdwardsPoint_mul_by_cofactor.spec_val hb h hc
  unfold EdwardsPoint_is_small_order.spec
  generalize EdwardsPoint_mul_by_cofactor.spec P = Q at he bX bY bZ ⊢
  have hz := isProj_eq_zero_iff (IsExt.isProj he)
  have l0 : Limbs.Lt FieldElement51.ZERO (2 ^ 54) := by
    rw [Limbs.lt_iff]; decide
  have l1 : Limbs.Lt FieldElement51.ONE (2 ^ 54) := by
    rw [Limbs.lt_iff]; decide
  obtain ⟨vXZ, -⟩ := FieldElement51_Mul_mul.spec_val (bX.mono (by norm_num)) l1
  obtain ⟨vZX, -⟩ := FieldElement51_Mul_mul.spec_val l0 (bZ.mono (by norm_num))
  obtain ⟨vYZ, -⟩ := FieldElement51_Mul_mul.spec_val (bY.mono (by norm_num)) l1
  obtain ⟨vZY, -⟩ := FieldElement51_Mul_mul.spec_val l1 (bZ.mono (by norm_num))
  simp only [EdwardsPoint_ConstantTimeEq_ct_eq.spec, EdwardsPoint_identity.spec,
    FieldElement51_ConstantTimeEq_ct_eq.spec_val, vXZ, vZX, vYZ, vZY, FieldElement51.ZERO_val,
    FieldElement51.ONE_val, SmallOrder, ← hz]
  by_cases hX : Limbs.val Q.X = 0 <;> by_cases hY : Limbs.val Q.Y = Limbs.val Q.Z <;> simp [hX, hY]

/-- `is_small_order` of extended coordinates below `2^53` of a point `Q`: `1` exactly when
`8 Q = 0`. -/
public theorem EdwardsPoint_is_small_order.spec_point {P : EdwardsPoint} {Q : Point}
    (hb : P.Lt (2 ^ 53)) (h : P.Ext Q.x Q.y) :
    EdwardsPoint_is_small_order.spec P = if 8 • Q = 0 then 1#1 else 0#1 := by
  rw [EdwardsPoint_is_small_order.spec_val hb h Q.on]
  exact if_congr (Point.smallOrder_iff_nsmul Q) rfl rfl

end Serial

end MLIR.Agave
