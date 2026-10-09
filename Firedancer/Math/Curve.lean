module

public import Firedancer.Math.Field
public import Firedancer.Math.Sqrt
public import Mathlib.Algebra.Field.ZMod
public import Firedancer.Ref.fd_ed25519_partial_dbl
public import Firedancer.Ref.fd_ed25519_point_add_final_mul
public import Firedancer.Ref.fd_ed25519_point_add_final_mul_projective
public import Firedancer.Ref.fd_ed25519_point_dbln
public import Firedancer.Ref.fd_ed25519_point_add_with_opts
public import Firedancer.Ref.fd_ed25519_point_sub_with_opts
public import Firedancer.Ref.fd_ed25519_point_neg
public import Firedancer.Ref.fd_ed25519_point_set_zero
public import Firedancer.Ref.fd_curve25519_into_precomputed
public import Firedancer.Ref.fd_ed25519_affine_is_small_order
public import Firedancer.Ref.fd_ed25519_point_eq_z1
public import Firedancer.Ref.fd_ed25519_point_frombytes
import Mathlib.FieldTheory.Finite.Basic
import Mathlib.NumberTheory.LegendreSymbol.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.ReduceModChar

/-! The Ref point operations on the twisted Edwards curve `-x² + y² = 1 + d x² y²` over `ZMod p`:
each spec computes its curve operation on the points its limbs represent. -/

namespace MLIR.Firedancer.Ref

/-! ## Definitions -/

@[expose] public section

namespace Ed25519

/-- The curve's `d = -121665 / 121666`. -/
def d : ZMod p :=
  37095705934669439343138083508754565189542113879843219016388785533085940283555

/-- `(x, y)` is on the curve. -/
def OnCurve (x y : ZMod p) : Prop :=
  -x ^ 2 + y ^ 2 = 1 + d * x ^ 2 * y ^ 2

/-- Doubling, `a = -1`. -/
def dbl (x y : ZMod p) : ZMod p × ZMod p :=
  (2 * x * y / (y ^ 2 - x ^ 2), (y ^ 2 + x ^ 2) / (2 - y ^ 2 + x ^ 2))

/-- Addition, the unified (complete) formula for `a = -1`. -/
def add (x₁ y₁ x₂ y₂ : ZMod p) : ZMod p × ZMod p :=
  ((x₁ * y₂ + y₁ * x₂) / (1 + d * x₁ * x₂ * y₁ * y₂),
    (y₁ * y₂ + x₁ * x₂) / (1 - d * x₁ * x₂ * y₁ * y₂))

/-- `(x, y)` doubled `n` times. -/
def dblN : ℕ → ZMod p × ZMod p → ZMod p × ZMod p
  | 0, P => P
  | n + 1, P => dblN n (dbl P.1 P.2)

/-- An order-8 point's `y`; the other order-8 points have `-y8`. -/
def y8 : ZMod p :=
  2707385501144840649318225287225658788936804267575313519463743609750303402022

/-- `8 (x, y)` is the neutral point. -/
def SmallOrder (x y : ZMod p) : Prop :=
  dblN 3 (x, y) = (0, 1)

instance (x y : ZMod p) : Decidable (SmallOrder x y) :=
  inferInstanceAs (Decidable (_ = _))

/-- `(X : Y : T : Z)` are extended coordinates of `(x, y)`. -/
def IsExt (x y X Y T Z : ZMod p) : Prop :=
  Z ≠ 0 ∧ X = x * Z ∧ Y = y * Z ∧ T * Z = X * Y

end Ed25519

/-- `P` is `(x, y)` in projective coordinates, `T` ignored: `x = X/Z`, `y = Y/Z`. -/
def _root_.MLIR.PointLimbs.Proj (P : PointLimbs) (x y : ZMod p) : Prop :=
  Limbs.val P.Z ≠ 0 ∧ Limbs.val P.X = x * Limbs.val P.Z ∧ Limbs.val P.Y = y * Limbs.val P.Z

/-- `P` is `(x, y)` in extended coordinates. -/
def _root_.MLIR.PointLimbs.Ext (P : PointLimbs) (x y : ZMod p) : Prop :=
  Ed25519.IsExt x y (Limbs.val P.X) (Limbs.val P.Y) (Limbs.val P.T) (Limbs.val P.Z)

/-- `P` is `(x, y)` as `add_with_opts`'s second operand: extended coordinates `(X : Y : T : Z)`,
with `Z = 1` for a nonzero `zOne` (`P.Z` unused) and stored as `(Y - X, Y + X, 2d T)` for a nonzero
`pre`. -/
def _root_.MLIR.PointLimbs.Operand (P : PointLimbs) (zOne pre : BitVec 32) (x y : ZMod p) :
    Prop :=
  ∃ X Y T Z, Ed25519.IsExt x y X Y T Z ∧ (if zOne = 0#32 then Limbs.val P.Z = Z else Z = 1) ∧
    if pre = 0#32 then Limbs.val P.X = X ∧ Limbs.val P.Y = Y ∧ Limbs.val P.T = T
    else Limbs.val P.X = Y - X ∧ Limbs.val P.Y = Y + X ∧ Limbs.val P.T = 2 * Ed25519.d * T

/-- `P` is `(x, y)` as a completed point, before the last multiplications of an addition:
`x = X/Z`, `y = T/Y`. -/
def _root_.MLIR.PointLimbs.Compl (P : PointLimbs) (x y : ZMod p) : Prop :=
  Limbs.val P.Z ≠ 0 ∧ Limbs.val P.Y ≠ 0 ∧ Limbs.val P.X = x * Limbs.val P.Z ∧
    Limbs.val P.T = y * Limbs.val P.Y

/-- All four coordinates within fiat's tight bounds. -/
abbrev _root_.MLIR.PointLimbs.Tight (P : PointLimbs) : Prop :=
  Limbs.Tight P.X ∧ Limbs.Tight P.Y ∧ Limbs.Tight P.T ∧ Limbs.Tight P.Z

/-- All four coordinates within fiat's loose bounds. -/
abbrev _root_.MLIR.PointLimbs.Loose (P : PointLimbs) : Prop :=
  Limbs.Loose P.X ∧ Limbs.Loose P.Y ∧ Limbs.Loose P.T ∧ Limbs.Loose P.Z

end

/-! ## The curve constant -/

section Constant

theorem Ed25519.d_pow : Ed25519.d ^ (p / 2) = -1 := by
  unfold Ed25519.d
  reduce_mod_char

/-- `d` is not a square, so the curve's formulas never divide by zero. -/
theorem Ed25519.d_not_square : ¬IsSquare Ed25519.d := by
  have hd : Ed25519.d ≠ 0 := by
    intro h
    have := Ed25519.d_pow
    rw [h, zero_pow (by decide)] at this
    exact absurd this.symm (by reduce_mod_char; decide)
  rw [ZMod.euler_criterion p hd, Ed25519.d_pow]
  reduce_mod_char
  decide

end Constant

/-! ## Denominators on the curve -/

section Denominators

variable {x y : ZMod p}

/-- On the curve `x y ≠ 0` once `d x² y²` is `± 1`. -/
theorem Ed25519.mul_ne_zero_of_d (h : Ed25519.d * x ^ 2 * y ^ 2 = c) (hc : c ≠ 0) : x * y ≠ 0 := by
  intro hxy
  apply hc
  rw [← h]
  linear_combination (Ed25519.d * x * y) * hxy

/-- `1 + d x² y² ≠ 0`: else `d = (√-1 / (x y))²`. -/
public theorem Ed25519.one_add_ne (x y : ZMod p) : 1 + Ed25519.d * x ^ 2 * y ^ 2 ≠ 0 := by
  intro h0
  have h1 : Ed25519.d * x ^ 2 * y ^ 2 = -1 := by linear_combination h0
  have hxy := Ed25519.mul_ne_zero_of_d h1 (by simp)
  apply Ed25519.d_not_square
  refine ⟨sqrtM1 / (x * y), ?_⟩
  rw [div_mul_div_comm, eq_div_iff (mul_ne_zero hxy hxy)]
  linear_combination h1 - sqrtM1_sq

/-- `1 - d x² y² ≠ 0`: else `d = (1 / (x y))²`. -/
theorem Ed25519.one_sub_ne (x y : ZMod p) : 1 - Ed25519.d * x ^ 2 * y ^ 2 ≠ 0 := by
  intro h0
  have h1 : Ed25519.d * x ^ 2 * y ^ 2 = 1 := by linear_combination -h0
  have hxy := Ed25519.mul_ne_zero_of_d h1 one_ne_zero
  apply Ed25519.d_not_square
  refine ⟨1 / (x * y), ?_⟩
  rw [div_mul_div_comm, eq_div_iff (mul_ne_zero hxy hxy)]
  linear_combination h1

/-- Doubling's `y² - x²`, nonzero on the curve. -/
public theorem Ed25519.dbl_den₁ (hc : Ed25519.OnCurve x y) : y ^ 2 - x ^ 2 ≠ 0 := by
  have := Ed25519.one_add_ne x y
  unfold Ed25519.OnCurve at hc
  intro h
  exact this (by linear_combination -hc + h)

/-- Doubling's `2 - y² + x²`, nonzero on the curve. -/
public theorem Ed25519.dbl_den₂ (hc : Ed25519.OnCurve x y) : 2 - y ^ 2 + x ^ 2 ≠ 0 := by
  have := Ed25519.one_sub_ne x y
  unfold Ed25519.OnCurve at hc
  intro h
  exact this (by linear_combination hc + h)

/-- Doubling stays on the curve. -/
public theorem Ed25519.dbl_onCurve (hc : Ed25519.OnCurve x y) :
    Ed25519.OnCurve (Ed25519.dbl x y).1 (Ed25519.dbl x y).2 := by
  have d₁ := Ed25519.dbl_den₁ hc
  have d₂ := Ed25519.dbl_den₂ hc
  unfold Ed25519.OnCurve at hc ⊢
  simp only [Ed25519.dbl]
  field_simp
  linear_combination (4 * (x ^ 2 + y ^ 2) ^ 2) * hc

/-- The key square: on the curve, `d x₁ x₂ y₁ y₂ = ε` with `ε² = 1` makes `(y₁ + ε j x₁)²` equal
`d (x₁ y₁ (y₂ + j x₂))²` for a square root `j` of `-1`. -/
theorem Ed25519.add_square {x₁ y₁ x₂ y₂ ε j : ZMod p} (h1 : Ed25519.OnCurve x₁ y₁)
    (h2 : Ed25519.OnCurve x₂ y₂) (h : Ed25519.d * x₁ * x₂ * y₁ * y₂ = ε) (hε : ε ^ 2 = 1)
    (hj : j ^ 2 = -1) :
    (y₁ + ε * j * x₁) ^ 2 = Ed25519.d * (x₁ * y₁ * (y₂ + j * x₂)) ^ 2 := by
  unfold Ed25519.OnCurve at h1 h2
  have e1 : (y₁ + ε * j * x₁) ^ 2 = y₁ ^ 2 - x₁ ^ 2 + 2 * ε * j * x₁ * y₁ := by
    linear_combination (x₁ ^ 2 * ε ^ 2) * hj - x₁ ^ 2 * hε
  have e2 : Ed25519.d * (x₁ * y₁ * (y₂ + j * x₂)) ^ 2 =
      Ed25519.d * x₁ ^ 2 * y₁ ^ 2 * (y₂ ^ 2 - x₂ ^ 2) +
        2 * j * x₁ * y₁ * (Ed25519.d * x₁ * x₂ * y₁ * y₂) := by
    linear_combination (Ed25519.d * x₁ ^ 2 * y₁ ^ 2 * x₂ ^ 2) * hj
  have e3 : Ed25519.d * x₁ ^ 2 * y₁ ^ 2 * (y₂ ^ 2 - x₂ ^ 2) = y₁ ^ 2 - x₁ ^ 2 := by
    linear_combination (Ed25519.d * x₁ ^ 2 * y₁ ^ 2) * h2 +
      (Ed25519.d * x₁ * x₂ * y₁ * y₂ + ε) * h + hε - h1
  rw [e1, e2, e3, h]
  ring

/-- The addition's denominators never vanish on the curve: `d x₁ x₂ y₁ y₂ ≠ ±1`. -/
theorem Ed25519.add_ne {x₁ y₁ x₂ y₂ ε : ZMod p} (h1 : Ed25519.OnCurve x₁ y₁)
    (h2 : Ed25519.OnCurve x₂ y₂) (hε : ε ^ 2 = 1) : Ed25519.d * x₁ * x₂ * y₁ * y₂ ≠ ε := by
  intro h
  have hε0 : ε ≠ 0 := by rintro rfl; simp at hε
  have hall : x₁ * y₁ * (x₂ * y₂) ≠ 0 := by
    intro h0
    apply hε0
    rw [← h]
    linear_combination Ed25519.d * h0
  have hx₁y₁ : x₁ * y₁ ≠ 0 := left_ne_zero_of_mul hall
  have hy₂ : y₂ ≠ 0 := right_ne_zero_of_mul (right_ne_zero_of_mul hall)
  -- with `j` and `-j`, `y₂ ± j x₂ = 0`, so `y₂ = 0`
  have hzero (j : ZMod p) (hj : j ^ 2 = -1) : y₂ + j * x₂ = 0 := by
    by_contra hne
    apply Ed25519.d_not_square
    refine ⟨(y₁ + ε * j * x₁) / (x₁ * y₁ * (y₂ + j * x₂)), ?_⟩
    have hden : x₁ * y₁ * (y₂ + j * x₂) ≠ 0 := mul_ne_zero hx₁y₁ hne
    rw [div_mul_div_comm, eq_div_iff (mul_ne_zero hden hden)]
    linear_combination -(Ed25519.add_square h1 h2 h hε hj)
  have hi := hzero _ sqrtM1_sq
  have hi' := hzero (-sqrtM1) (by rw [neg_sq]; exact sqrtM1_sq)
  apply hy₂
  have h2y : 2 * y₂ = 0 := by linear_combination hi + hi'
  have h2 : (2 : ZMod p) ≠ 0 := by decide
  simpa [h2] using h2y

/-- `1 + d x₁ x₂ y₁ y₂ ≠ 0` on the curve. -/
public theorem Ed25519.add_den₁ {x₁ y₁ x₂ y₂ : ZMod p} (h1 : Ed25519.OnCurve x₁ y₁)
    (h2 : Ed25519.OnCurve x₂ y₂) : 1 + Ed25519.d * x₁ * x₂ * y₁ * y₂ ≠ 0 := by
  have := Ed25519.add_ne h1 h2 (ε := -1) (by ring)
  intro h
  exact this (by linear_combination h)

/-- `1 - d x₁ x₂ y₁ y₂ ≠ 0` on the curve. -/
public theorem Ed25519.add_den₂ {x₁ y₁ x₂ y₂ : ZMod p} (h1 : Ed25519.OnCurve x₁ y₁)
    (h2 : Ed25519.OnCurve x₂ y₂) : 1 - Ed25519.d * x₁ * x₂ * y₁ * y₂ ≠ 0 := by
  have := Ed25519.add_ne h1 h2 (ε := 1) (by ring)
  intro h
  exact this (by linear_combination -h)

/-- Addition from extended coordinates, as `add_with_opts` computes it before its last
multiplications: `(r₆ - r₅, r₈ - r₇, r₈ + r₇, r₆ + r₅)` is the sum as a completed point. -/
public theorem Ed25519.add_compl {x₁ y₁ X₁ Y₁ T₁ Z₁ x₂ y₂ X₂ Y₂ T₂ Z₂ : ZMod p}
    (hA : Ed25519.IsExt x₁ y₁ X₁ Y₁ T₁ Z₁) (hB : Ed25519.IsExt x₂ y₂ X₂ Y₂ T₂ Z₂)
    (h1 : Ed25519.OnCurve x₁ y₁) (h2 : Ed25519.OnCurve x₂ y₂) :
    let r₅ := (Y₁ - X₁) * (Y₂ - X₂)
    let r₆ := (Y₁ + X₁) * (Y₂ + X₂)
    let r₇ := T₁ * T₂ * (2 * Ed25519.d)
    let r₈ := (Z₁ + Z₁) * Z₂
    let Q := Ed25519.add x₁ y₁ x₂ y₂
    r₈ + r₇ ≠ 0 ∧ r₈ - r₇ ≠ 0 ∧ r₆ - r₅ = Q.1 * (r₈ + r₇) ∧ r₆ + r₅ = Q.2 * (r₈ - r₇) := by
  obtain ⟨hZ₁, rfl, rfl, hT₁⟩ := hA
  obtain ⟨hZ₂, rfl, rfl, hT₂⟩ := hB
  obtain rfl : T₁ = x₁ * y₁ * Z₁ := mul_right_cancel₀ hZ₁ (by rw [hT₁]; ring)
  obtain rfl : T₂ = x₂ * y₂ * Z₂ := mul_right_cancel₀ hZ₂ (by rw [hT₂]; ring)
  have d₁ := Ed25519.add_den₁ h1 h2
  have d₂ := Ed25519.add_den₂ h1 h2
  have h2 : (2 : ZMod p) ≠ 0 := by decide
  have e₁ : (Z₁ + Z₁) * Z₂ + x₁ * y₁ * Z₁ * (x₂ * y₂ * Z₂) * (2 * Ed25519.d) =
      2 * Z₁ * Z₂ * (1 + Ed25519.d * x₁ * x₂ * y₁ * y₂) := by ring
  have e₂ : (Z₁ + Z₁) * Z₂ - x₁ * y₁ * Z₁ * (x₂ * y₂ * Z₂) * (2 * Ed25519.d) =
      2 * Z₁ * Z₂ * (1 - Ed25519.d * x₁ * x₂ * y₁ * y₂) := by ring
  simp only [Ed25519.add, e₁, e₂]
  refine ⟨by simp [*], by simp [*], ?_, ?_⟩
  · rw [mul_comm (2 * Z₁ * Z₂), ← mul_assoc, div_mul_cancel₀ _ d₁]
    ring
  · rw [mul_comm (2 * Z₁ * Z₂), ← mul_assoc, div_mul_cancel₀ _ d₂]
    ring

/-- Negation, `(-x, y)`, stays on the curve. -/
public theorem Ed25519.OnCurve.neg (h : Ed25519.OnCurve x y) : Ed25519.OnCurve (-x) y := by
  unfold Ed25519.OnCurve at *
  linear_combination h

/-- Negation in extended coordinates. -/
theorem Ed25519.IsExt.neg {X Y T Z : ZMod p} (h : Ed25519.IsExt x y X Y T Z) :
    Ed25519.IsExt (-x) y (-X) Y (-T) Z := by
  obtain ⟨hZ, rfl, rfl, hT⟩ := h
  exact ⟨hZ, by ring, rfl, by linear_combination -hT⟩

end Denominators

/-! ## Small order -/

section SmallOrder

variable {x y : ZMod p}

/-- The other root of `d s² + 2 s - 1`, besides `y8²`; not a square. -/
def Ed25519.s₁ : ZMod p :=
  3685532557031388680362915159118232971324886473920755116993713661282644049091

theorem Ed25519.s₁_not_square : ¬IsSquare Ed25519.s₁ := by
  have h0 : Ed25519.s₁ ≠ 0 := by unfold Ed25519.s₁; decide
  rw [ZMod.euler_criterion p h0]
  unfold Ed25519.s₁
  reduce_mod_char
  decide

/-- `d s² + 2 s - 1 = d (s - y8²) (s - s₁)`. -/
theorem Ed25519.y8_poly (s : ZMod p) :
    Ed25519.d * s ^ 2 + 2 * s - 1 = Ed25519.d * (s - Ed25519.y8 ^ 2) * (s - Ed25519.s₁) := by
  have e1 : Ed25519.d * (Ed25519.y8 ^ 2 + Ed25519.s₁) = -2 := by
    unfold Ed25519.d Ed25519.y8 Ed25519.s₁
    reduce_mod_char
  have e2 : Ed25519.d * Ed25519.y8 ^ 2 * Ed25519.s₁ = -1 := by
    unfold Ed25519.d Ed25519.y8 Ed25519.s₁
    reduce_mod_char
  linear_combination s * e1 - e2

theorem Ed25519.d_ne_zero : Ed25519.d ≠ 0 := by
  unfold Ed25519.d
  decide

/-- On the curve, `y² + x² = 0` exactly at the order-8 points. -/
theorem Ed25519.sq_add_sq_eq_zero (hc : Ed25519.OnCurve x y) :
    y ^ 2 + x ^ 2 = 0 ↔ y = Ed25519.y8 ∨ y = -Ed25519.y8 := by
  unfold Ed25519.OnCurve at hc
  have hp := Ed25519.y8_poly (y ^ 2)
  constructor
  · intro h
    have h0 : Ed25519.d * (y ^ 2 - Ed25519.y8 ^ 2) * (y ^ 2 - Ed25519.s₁) = 0 := by
      rw [← hp]
      linear_combination (1 + Ed25519.d * y ^ 2) * h + hc
    rcases mul_eq_zero.1 h0 with h1 | h1
    · rcases mul_eq_zero.1 h1 with h2 | h2
      · exact absurd h2 Ed25519.d_ne_zero
      · have : (y - Ed25519.y8) * (y + Ed25519.y8) = 0 := by linear_combination h2
        rcases mul_eq_zero.1 this with h3 | h3
        · exact .inl (by linear_combination h3)
        · exact .inr (by linear_combination h3)
    · exact absurd ⟨y, by linear_combination -h1⟩ Ed25519.s₁_not_square
  · intro h
    have hy : y ^ 2 = Ed25519.y8 ^ 2 := by rcases h with rfl | rfl <;> ring
    have hne := Ed25519.one_add_ne 1 y
    have q : Ed25519.d * (y ^ 2) ^ 2 + 2 * y ^ 2 - 1 = 0 := by rw [hp, hy]; ring
    have : (1 + Ed25519.d * 1 ^ 2 * y ^ 2) * (y ^ 2 + x ^ 2) = 0 := by
      linear_combination q - hc
    exact (mul_eq_zero.1 this).resolve_left hne

/-- Doubling's `x` vanishes exactly when `x y` does. -/
theorem Ed25519.dbl_fst_eq_zero (hc : Ed25519.OnCurve x y) :
    (Ed25519.dbl x y).1 = 0 ↔ x * y = 0 := by
  have := Ed25519.dbl_den₁ hc
  have h2 : (2 : ZMod p) ≠ 0 := by decide
  simp only [Ed25519.dbl, div_eq_zero_iff, this, or_false, mul_assoc, mul_eq_zero, h2, false_or]

/-- Doubling's `y` vanishes exactly when `y² + x²` does. -/
theorem Ed25519.dbl_snd_eq_zero (hc : Ed25519.OnCurve x y) :
    (Ed25519.dbl x y).2 = 0 ↔ y ^ 2 + x ^ 2 = 0 := by
  have := Ed25519.dbl_den₂ hc
  simp only [Ed25519.dbl, div_eq_zero_iff, this, or_false]

/-- Doubling a point with `x = 0`, `(0, ±1)`, gives the neutral point. -/
theorem Ed25519.dbl_of_fst (hc : Ed25519.OnCurve x y) (hx : x = 0) : Ed25519.dbl x y = (0, 1) := by
  subst hx
  unfold Ed25519.OnCurve at hc
  have hy : y ^ 2 = 1 := by linear_combination hc
  simp [Ed25519.dbl, hy]
  norm_num

/-- Doubling a point with `y = 0`, of order 4, gives `(0, -1)`. -/
theorem Ed25519.dbl_of_snd (hc : Ed25519.OnCurve x y) (hy : y = 0) :
    Ed25519.dbl x y = (0, -1) := by
  subst hy
  unfold Ed25519.OnCurve at hc
  have hx : x ^ 2 = -1 := by linear_combination -hc
  simp [Ed25519.dbl, hx]
  norm_num

/-- A point is of small order exactly when `x = 0`, `y = 0`, or `y = ± y8`. -/
public theorem Ed25519.smallOrder_iff (hc : Ed25519.OnCurve x y) :
    Ed25519.SmallOrder x y ↔ x = 0 ∨ y = 0 ∨ y = Ed25519.y8 ∨ y = -Ed25519.y8 := by
  have c1 := Ed25519.dbl_onCurve hc
  have c2 := Ed25519.dbl_onCurve c1
  have hm1 : (-1 : ZMod p) ≠ 1 := by decide
  simp only [Ed25519.SmallOrder, Ed25519.dblN]
  constructor
  · intro h
    have h3 := (Ed25519.dbl_fst_eq_zero c2).1 (congrArg Prod.fst h)
    rcases mul_eq_zero.1 h3 with h4 | h4
    · rcases mul_eq_zero.1 ((Ed25519.dbl_fst_eq_zero c1).1 h4) with h5 | h5
      · rcases mul_eq_zero.1 ((Ed25519.dbl_fst_eq_zero hc).1 h5) with h6 | h6
        · exact .inl h6
        · exact .inr (.inl h6)
      · exact .inr (.inr ((Ed25519.sq_add_sq_eq_zero hc).1 ((Ed25519.dbl_snd_eq_zero hc).1 h5)))
    · rw [Ed25519.dbl_of_snd c2 h4] at h
      exact absurd (congrArg Prod.snd h) hm1
  · intro h
    rcases h with h | h | h
    · rw [Ed25519.dbl_of_fst c1 ((Ed25519.dbl_fst_eq_zero hc).2 (by simp [h]))]
      exact Ed25519.dbl_of_fst (by unfold Ed25519.OnCurve; ring) rfl
    · rw [Ed25519.dbl_of_fst c1 ((Ed25519.dbl_fst_eq_zero hc).2 (by simp [h]))]
      exact Ed25519.dbl_of_fst (by unfold Ed25519.OnCurve; ring) rfl
    · have h1 := (Ed25519.dbl_snd_eq_zero hc).2 ((Ed25519.sq_add_sq_eq_zero hc).2 h)
      rw [Ed25519.dbl_of_snd c1 h1]
      exact Ed25519.dbl_of_fst (by unfold Ed25519.OnCurve; ring) rfl

end SmallOrder

/-! ## The point operations -/

section Proof

variable {P : PointLimbs} {x y : ZMod p}

/-- `partial_dbl` takes a projective `(x, y)` on the curve to `2 (x, y)` as a completed point; its
`X` and `Y` loose, `T` and `Z` tight. -/
public theorem fd_ed25519_partial_dbl.spec_compl (hP : P.Proj x y) (hc : Ed25519.OnCurve x y)
    (hX : Limbs.Under2p P.X) (hY : Limbs.Tight P.Y) (hZ : Limbs.Loose P.Z) :
    let D := fd_ed25519_partial_dbl.spec P
    D.Compl (Ed25519.dbl x y).1 (Ed25519.dbl x y).2 ∧ Limbs.Loose D.X ∧ Limbs.Loose D.Y ∧
      Limbs.Tight D.T ∧ Limbs.Tight D.Z := by
  obtain ⟨hz, hx, hy⟩ := hP
  obtain ⟨v1, b1⟩ := fd_f25519_add_nr.spec_wide' hX hY
  obtain ⟨v2, b2⟩ := fd_f25519_sqr.spec_val hX.loose
  obtain ⟨v3, b3⟩ := fd_f25519_sqr.spec_val hY.loose
  obtain ⟨v4, b4⟩ := fd_f25519_sqr.spec_val hZ
  obtain ⟨v5, b5⟩ := fd_f25519_sqr.spec_val b1
  obtain ⟨v4', b4'⟩ := fd_f25519_add.spec_val b4 b4
  obtain ⟨vT, bT⟩ := fd_f25519_add.spec_val b2 b3
  obtain ⟨vZ, bZ⟩ := fd_f25519_sub.spec_val b2 b3.under2p
  obtain ⟨vY, bY⟩ := fd_f25519_add_nr.spec_val b4' bZ
  obtain ⟨vX, bX⟩ := fd_f25519_sub_nr.spec_val bT b5
  refine ⟨?_, bX, bY, bT, bZ⟩
  simp only [fd_ed25519_partial_dbl.spec, PointLimbs.Compl, Ed25519.dbl]
  have d₁ := Ed25519.dbl_den₁ hc
  have d₂ := Ed25519.dbl_den₂ hc
  rw [vX, vY, vT, vZ, v4', v5, v2, v3, v4, v1, hx, hy]
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro h
    apply d₁
    have : Limbs.val P.Z ^ 2 * (y ^ 2 - x ^ 2) = 0 := by linear_combination -h
    simpa [hz] using this
  · intro h
    apply d₂
    have : Limbs.val P.Z ^ 2 * (2 - y ^ 2 + x ^ 2) = 0 := by linear_combination h
    simpa [hz] using this
  · field_simp
    ring
  · field_simp
    ring

/-- `add_final_mul` takes a completed `(x, y)` to `(x, y)` in extended coordinates, tight. -/
public theorem fd_ed25519_point_add_final_mul.spec_ext (hP : P.Compl x y) (hX : Limbs.Loose P.X)
    (hY : Limbs.Loose P.Y) (hT : Limbs.Loose P.T) (hZ : Limbs.Loose P.Z) :
    (fd_ed25519_point_add_final_mul.spec P).Ext x y ∧
      (fd_ed25519_point_add_final_mul.spec P).Tight := by
  obtain ⟨hz, hy0, hx, ht⟩ := hP
  obtain ⟨vX, bX⟩ := fd_f25519_mul.spec_val hX hY
  obtain ⟨vY, bY⟩ := fd_f25519_mul.spec_val hZ hT
  obtain ⟨vT, bT⟩ := fd_f25519_mul.spec_val hX hT
  obtain ⟨vZ, bZ⟩ := fd_f25519_mul.spec_val hY hZ
  refine ⟨⟨?_, ?_, ?_, ?_⟩, bX, bY, bT, bZ⟩ <;>
    simp only [fd_ed25519_point_add_final_mul.spec, vX, vY, vT, vZ]
  · exact mul_ne_zero hy0 hz
  · rw [hx]; ring
  · rw [ht]; ring
  · ring

/-- `add_final_mul_projective` takes a completed `(x, y)` to `(x, y)` in projective coordinates,
`X`, `Y`, `Z` tight. -/
public theorem fd_ed25519_point_add_final_mul_projective.spec_proj (hP : P.Compl x y)
    (hX : Limbs.Loose P.X) (hY : Limbs.Loose P.Y) (hT : Limbs.Loose P.T) (hZ : Limbs.Loose P.Z)
    (T₀ : Fin 5 → BitVec 64) :
    let Q := fd_ed25519_point_add_final_mul_projective.spec P T₀
    Q.Proj x y ∧ Limbs.Tight Q.X ∧ Limbs.Tight Q.Y ∧ Limbs.Tight Q.Z := by
  obtain ⟨hz, hy0, hx, ht⟩ := hP
  obtain ⟨vX, bX⟩ := fd_f25519_mul.spec_val hX hY
  obtain ⟨vY, bY⟩ := fd_f25519_mul.spec_val hZ hT
  obtain ⟨vZ, bZ⟩ := fd_f25519_mul.spec_val hY hZ
  refine ⟨⟨?_, ?_, ?_⟩, bX, bY, bZ⟩ <;>
    simp only [fd_ed25519_point_add_final_mul_projective.spec, vX, vY, vZ]
  · exact mul_ne_zero hy0 hz
  · rw [hx]; ring
  · rw [ht]; ring

/-- `dbln`'s loop keeps a completed point on the curve, doubling it at each step. -/
theorem fd_ed25519_point_dbln.iter_compl :
    ∀ (j : ℕ) {t : PointLimbs} {x y : ZMod p}, t.Compl x y → Ed25519.OnCurve x y →
      Limbs.Loose t.X → Limbs.Loose t.Y → Limbs.Loose t.T → Limbs.Loose t.Z →
      let Q := Ed25519.dblN j (x, y)
      let u := fd_ed25519_point_dbln.iter j t
      u.Compl Q.1 Q.2 ∧ Ed25519.OnCurve Q.1 Q.2 ∧ Limbs.Loose u.X ∧ Limbs.Loose u.Y ∧
        Limbs.Loose u.T ∧ Limbs.Loose u.Z
  | 0, _, _, _, ht, hc, bX, bY, bT, bZ => ⟨ht, hc, bX, bY, bT, bZ⟩
  | j + 1, t, x, y, ht, hc, bX, bY, bT, bZ => by
    obtain ⟨hp, pX, pY, pZ⟩ :=
      fd_ed25519_point_add_final_mul_projective.spec_proj ht bX bY bT bZ 0
    obtain ⟨hd, dX, dY, dT, dZ⟩ := fd_ed25519_partial_dbl.spec_compl hp hc pX.under2p pY pZ.loose
    exact fd_ed25519_point_dbln.iter_compl j hd (Ed25519.dbl_onCurve hc) dX dY dT.loose dZ.loose

/-- `dbln` takes a projective `(x, y)` on the curve to `2ⁿ (x, y)` in extended coordinates, tight,
for `n ≥ 1`. -/
public theorem fd_ed25519_point_dbln.spec_ext (hP : P.Proj x y) (hc : Ed25519.OnCurve x y)
    (hX : Limbs.Under2p P.X) (hY : Limbs.Tight P.Y) (hZ : Limbs.Loose P.Z) {n : ℕ}
    (hn : 1 ≤ n) :
    let Q := Ed25519.dblN n (x, y)
    (fd_ed25519_point_dbln.spec P n).Ext Q.1 Q.2 ∧ (fd_ed25519_point_dbln.spec P n).Tight := by
  obtain ⟨m, rfl⟩ : ∃ m, n = m + 1 := ⟨n - 1, by omega⟩
  obtain ⟨hd, dX, dY, dT, dZ⟩ := fd_ed25519_partial_dbl.spec_compl hP hc hX hY hZ
  obtain ⟨hi, -, iX, iY, iT, iZ⟩ :=
    fd_ed25519_point_dbln.iter_compl m hd (Ed25519.dbl_onCurve hc) dX dY dT.loose dZ.loose
  exact fd_ed25519_point_add_final_mul.spec_ext hi iX iY iT iZ

/-- `k = 2d`, tight. -/
theorem fd_f25519_k.val : Limbs.val fd_f25519_k.limbs = 2 * Ed25519.d ∧
    Limbs.Tight fd_f25519_k.limbs := by
  refine ⟨?_, by rw [Limbs.tight_iff]; decide⟩
  rw [Limbs.val_eq]
  unfold Ed25519.d
  simp [fd_f25519_k.limbs]
  reduce_mod_char

/-- `add_with_opts`'s factors `r₂, r₄`: `B`'s `Y - X` and `Y + X`, loose. -/
theorem fd_ed25519_point_add_with_opts.r24 {B : PointLimbs} {pre : BitVec 32} {X Y T : ZMod p}
    (hB : if pre = 0#32 then Limbs.val B.X = X ∧ Limbs.val B.Y = Y ∧ Limbs.val B.T = T
      else Limbs.val B.X = Y - X ∧ Limbs.val B.Y = Y + X ∧ Limbs.val B.T = 2 * Ed25519.d * T)
    (hb : if pre = 0#32 then Limbs.Tight B.X ∧ Limbs.Tight B.Y
      else Limbs.Loose B.X ∧ Limbs.Loose B.Y) :
    let r₂ := if pre = 0#32 then fd_f25519_sub_nr.spec B.Y B.X else B.X
    let r₄ := if pre = 0#32 then fd_f25519_add_nr.spec B.Y B.X else B.Y
    (Limbs.val r₂ = Y - X ∧ Limbs.Loose r₂) ∧ (Limbs.val r₄ = Y + X ∧ Limbs.Loose r₄) := by
  split_ifs at hB hb ⊢ with hp
  · obtain ⟨vX, vY, -⟩ := hB
    obtain ⟨v2, b2⟩ := fd_f25519_sub_nr.spec_val hb.2 hb.1
    obtain ⟨v4, b4⟩ := fd_f25519_add_nr.spec_val hb.2 hb.1
    exact ⟨⟨by rw [v2, vX, vY], b2⟩, ⟨by rw [v4, vX, vY], b4⟩⟩
  · exact ⟨⟨hB.1, hb.1⟩, ⟨hB.2.1, hb.2⟩⟩

/-- `add_with_opts`'s `r₇ = 2d T₁ T₂` and `r₈ = 2 Z₁ Z₂`, tight. -/
theorem fd_ed25519_point_add_with_opts.r78 {A B : PointLimbs} {zOne pre : BitVec 32}
    {X Y T Z : ZMod p}
    (hZ : if zOne = 0#32 then Limbs.val B.Z = Z else Z = 1)
    (hB : if pre = 0#32 then Limbs.val B.X = X ∧ Limbs.val B.Y = Y ∧ Limbs.val B.T = T
      else Limbs.val B.X = Y - X ∧ Limbs.val B.Y = Y + X ∧ Limbs.val B.T = 2 * Ed25519.d * T)
    (hAT : Limbs.Loose A.T) (hAZ : Limbs.Tight A.Z) (hBT : Limbs.Loose B.T)
    (hBZ : Limbs.Loose B.Z) :
    let r₇ := fd_f25519_mul.spec A.T B.T
    let r₇ := if pre = 0#32 then fd_f25519_mul.spec r₇ fd_f25519_k.limbs else r₇
    let r₈ :=
      if zOne = 0#32 then fd_f25519_mul.spec (fd_f25519_add_nr.spec A.Z A.Z) B.Z
      else fd_f25519_add.spec A.Z A.Z
    (Limbs.val r₇ = Limbs.val A.T * T * (2 * Ed25519.d) ∧ Limbs.Tight r₇) ∧
      (Limbs.val r₈ = (Limbs.val A.Z + Limbs.val A.Z) * Z ∧ Limbs.Tight r₈) := by
  obtain ⟨v7, b7⟩ := fd_f25519_mul.spec_val hAT hBT
  refine ⟨?_, ?_⟩
  · split_ifs at hB ⊢
    · obtain ⟨vk, bk⟩ := fd_f25519_k.val
      obtain ⟨v, b⟩ := fd_f25519_mul.spec_val b7.loose bk.loose
      exact ⟨by rw [v, v7, vk, hB.2.2], b⟩
    · exact ⟨by rw [v7, hB.2.2]; ring, b7⟩
  · split_ifs at hZ ⊢
    · obtain ⟨vt, bt⟩ := fd_f25519_add_nr.spec_val hAZ hAZ
      obtain ⟨v, b⟩ := fd_f25519_mul.spec_val bt hBZ
      exact ⟨by rw [v, vt, hZ], b⟩
    · obtain ⟨v, b⟩ := fd_f25519_add.spec_val hAZ hAZ
      exact ⟨by rw [v, hZ, mul_one], b⟩

/-- `add_with_opts` without its last multiplications: `A + B` as a completed point, loose. -/
public theorem fd_ed25519_point_add_with_opts.spec_compl {A B : PointLimbs}
    {zOne pre skip : BitVec 32} {x₁ y₁ x₂ y₂ : ZMod p} (hA : A.Ext x₁ y₁)
    (hB : B.Operand zOne pre x₂ y₂) (h1 : Ed25519.OnCurve x₁ y₁) (h2 : Ed25519.OnCurve x₂ y₂)
    (hAX : Limbs.Tight A.X) (hAY : Limbs.Tight A.Y) (hAT : Limbs.Loose A.T)
    (hAZ : Limbs.Tight A.Z)
    (hBXY : if pre = 0#32 then Limbs.Tight B.X ∧ Limbs.Tight B.Y
      else Limbs.Loose B.X ∧ Limbs.Loose B.Y)
    (hBT : Limbs.Loose B.T) (hBZ : Limbs.Loose B.Z) (hs : skip ≠ 0#32) :
    let Q := Ed25519.add x₁ y₁ x₂ y₂
    let R := fd_ed25519_point_add_with_opts.spec A B zOne pre skip
    R.Compl Q.1 Q.2 ∧ R.Loose := by
  obtain ⟨X₂, Y₂, T₂, Z₂, hE, hZ, hXYT⟩ := hB
  obtain ⟨d₁, d₂, eX, eT⟩ := Ed25519.add_compl hA hE h1 h2
  obtain ⟨⟨v2, b2⟩, ⟨v4, b4⟩⟩ := fd_ed25519_point_add_with_opts.r24 hXYT hBXY
  obtain ⟨⟨v7, b7⟩, ⟨v8, b8⟩⟩ := fd_ed25519_point_add_with_opts.r78 hZ hXYT hAT hAZ hBT hBZ
  obtain ⟨v1, b1⟩ := fd_f25519_sub_nr.spec_val hAY hAX
  obtain ⟨v3, b3⟩ := fd_f25519_add_nr.spec_val hAY hAX
  obtain ⟨v5, b5⟩ := fd_f25519_mul.spec_val b1 b2
  obtain ⟨v6, b6⟩ := fd_f25519_mul.spec_val b3 b4
  rw [v1, v2] at v5
  rw [v3, v4] at v6
  simp only [fd_ed25519_point_add_with_opts.spec, fd_ed25519_point_add_with_opts.last, hs,
    ite_false]
  obtain ⟨vX, bX⟩ := fd_f25519_sub_nr.spec_val b6 b5
  obtain ⟨vY, bY⟩ := fd_f25519_sub_nr.spec_val b8 b7
  obtain ⟨vZ, bZ⟩ := fd_f25519_add_nr.spec_val b8 b7
  obtain ⟨vT, bT⟩ := fd_f25519_add_nr.spec_val b6 b5
  refine ⟨⟨?_, ?_, ?_, ?_⟩, bX, bY, bT, bZ⟩ <;> simp only [vX, vY, vZ, vT, v5, v6, v7, v8]
  · exact d₁
  · exact d₂
  · exact eX
  · exact eT

/-- `add_with_opts` with its last multiplications: `A + B` in extended coordinates, tight. -/
public theorem fd_ed25519_point_add_with_opts.spec_ext {A B : PointLimbs} {zOne pre : BitVec 32}
    {x₁ y₁ x₂ y₂ : ZMod p} (hA : A.Ext x₁ y₁) (hB : B.Operand zOne pre x₂ y₂)
    (h1 : Ed25519.OnCurve x₁ y₁) (h2 : Ed25519.OnCurve x₂ y₂) (hAX : Limbs.Tight A.X)
    (hAY : Limbs.Tight A.Y) (hAT : Limbs.Loose A.T) (hAZ : Limbs.Tight A.Z)
    (hBXY : if pre = 0#32 then Limbs.Tight B.X ∧ Limbs.Tight B.Y
      else Limbs.Loose B.X ∧ Limbs.Loose B.Y)
    (hBT : Limbs.Loose B.T) (hBZ : Limbs.Loose B.Z) :
    let Q := Ed25519.add x₁ y₁ x₂ y₂
    let R := fd_ed25519_point_add_with_opts.spec A B zOne pre 0#32
    R.Ext Q.1 Q.2 ∧ R.Tight := by
  obtain ⟨hc, bX, bY, bT, bZ⟩ :=
    fd_ed25519_point_add_with_opts.spec_compl (skip := 1#32) hA hB h1 h2 hAX hAY hAT hAZ hBXY hBT
      hBZ (by decide)
  have := fd_ed25519_point_add_final_mul.spec_ext hc bX bY bT bZ
  simpa [fd_ed25519_point_add_with_opts.spec, fd_ed25519_point_add_with_opts.last] using this

/-- `sub_with_opts` without its last multiplications: `A - B` as a completed point, loose. -/
public theorem fd_ed25519_point_sub_with_opts.spec_compl {A B : PointLimbs}
    {zOne pre skip : BitVec 32} {x₁ y₁ x₂ y₂ : ZMod p} (hA : A.Ext x₁ y₁)
    (hB : B.Operand zOne pre x₂ y₂) (h1 : Ed25519.OnCurve x₁ y₁) (h2 : Ed25519.OnCurve x₂ y₂)
    (hAX : Limbs.Tight A.X) (hAY : Limbs.Tight A.Y) (hAT : Limbs.Loose A.T)
    (hAZ : Limbs.Tight A.Z)
    (hBXY : if pre = 0#32 then Limbs.Tight B.X ∧ Limbs.Tight B.Y
      else Limbs.Loose B.X ∧ Limbs.Loose B.Y)
    (hBT : Limbs.Loose B.T) (hBZ : Limbs.Loose B.Z) (hs : skip ≠ 0#32) :
    let Q := Ed25519.add x₁ y₁ (-x₂) y₂
    let R := fd_ed25519_point_sub_with_opts.spec A B zOne pre skip
    R.Compl Q.1 Q.2 ∧ R.Loose := by
  obtain ⟨X₂, Y₂, T₂, Z₂, hE, hZ, hXYT⟩ := hB
  obtain ⟨d₁, d₂, eX, eT⟩ := Ed25519.add_compl hA hE.neg h1 h2.neg
  obtain ⟨⟨v4, b4⟩, ⟨v2, b2⟩⟩ := fd_ed25519_point_add_with_opts.r24 hXYT hBXY
  obtain ⟨⟨v7, b7⟩, ⟨v8, b8⟩⟩ := fd_ed25519_point_add_with_opts.r78 hZ hXYT hAT hAZ hBT hBZ
  obtain ⟨v1, b1⟩ := fd_f25519_sub_nr.spec_val hAY hAX
  obtain ⟨v3, b3⟩ := fd_f25519_add_nr.spec_val hAY hAX
  obtain ⟨v5, b5⟩ := fd_f25519_mul.spec_val b1 b2
  obtain ⟨v6, b6⟩ := fd_f25519_mul.spec_val b3 b4
  rw [v1, v2] at v5
  rw [v3, v4] at v6
  simp only [fd_ed25519_point_sub_with_opts.spec, fd_ed25519_point_sub_with_opts.last, hs,
    ite_false]
  obtain ⟨vX, bX⟩ := fd_f25519_sub_nr.spec_val b6 b5
  obtain ⟨vY, bY⟩ := fd_f25519_add_nr.spec_val b8 b7
  obtain ⟨vZ, bZ⟩ := fd_f25519_sub_nr.spec_val b8 b7
  obtain ⟨vT, bT⟩ := fd_f25519_add_nr.spec_val b6 b5
  refine ⟨⟨?_, ?_, ?_, ?_⟩, bX, bY, bT, bZ⟩ <;> simp only [vX, vY, vZ, vT, v5, v6, v7, v8]
  · exact fun h => d₁ (by linear_combination h)
  · exact fun h => d₂ (by linear_combination h)
  · linear_combination eX
  · linear_combination eT

/-- `sub_with_opts` with its last multiplications: `A - B` in extended coordinates, tight. -/
public theorem fd_ed25519_point_sub_with_opts.spec_ext {A B : PointLimbs} {zOne pre : BitVec 32}
    {x₁ y₁ x₂ y₂ : ZMod p} (hA : A.Ext x₁ y₁) (hB : B.Operand zOne pre x₂ y₂)
    (h1 : Ed25519.OnCurve x₁ y₁) (h2 : Ed25519.OnCurve x₂ y₂) (hAX : Limbs.Tight A.X)
    (hAY : Limbs.Tight A.Y) (hAT : Limbs.Loose A.T) (hAZ : Limbs.Tight A.Z)
    (hBXY : if pre = 0#32 then Limbs.Tight B.X ∧ Limbs.Tight B.Y
      else Limbs.Loose B.X ∧ Limbs.Loose B.Y)
    (hBT : Limbs.Loose B.T) (hBZ : Limbs.Loose B.Z) :
    let Q := Ed25519.add x₁ y₁ (-x₂) y₂
    let R := fd_ed25519_point_sub_with_opts.spec A B zOne pre 0#32
    R.Ext Q.1 Q.2 ∧ R.Tight := by
  obtain ⟨hc, bX, bY, bT, bZ⟩ :=
    fd_ed25519_point_sub_with_opts.spec_compl (skip := 1#32) hA hB h1 h2 hAX hAY hAT hAZ hBXY hBT
      hBZ (by decide)
  have := fd_ed25519_point_add_final_mul.spec_ext hc bX bY bT bZ
  simpa [fd_ed25519_point_sub_with_opts.spec, fd_ed25519_point_sub_with_opts.last] using this

/-- The neutral point is on the curve. -/
public theorem Ed25519.onCurve_zero : Ed25519.OnCurve 0 1 := by
  unfold Ed25519.OnCurve
  ring

/-- `set_zero` is the neutral point `(0, 1)`, tight. -/
public theorem fd_ed25519_point_set_zero.spec_ext :
    fd_ed25519_point_set_zero.spec.Ext 0 1 ∧ fd_ed25519_point_set_zero.spec.Tight := by
  have v0 : Limbs.val fd_f25519_zero.limbs = 0 := by
    simp [Limbs.val_eq, fd_f25519_zero.limbs]
  have v1 : Limbs.val fd_f25519_one.limbs = 1 := by
    simp [Limbs.val_eq, fd_f25519_one.limbs]
  refine ⟨?_, ?_⟩
  · simp only [PointLimbs.Ext, Ed25519.IsExt, fd_ed25519_point_set_zero.spec, v0, v1]
    norm_num
  · simp only [fd_ed25519_point_set_zero.spec]
    decide

/-- `neg` takes `(x, y)` to `-(x, y) = (-x, y)`; its `X` and `T` within `2p`'s limbs. -/
public theorem fd_ed25519_point_neg.spec_ext (hP : P.Ext x y) (hX : Limbs.Under2p P.X)
    (hT : Limbs.Under2p P.T) :
    let N := fd_ed25519_point_neg.spec P
    N.Ext (-x) y ∧ Limbs.Under2p N.X ∧ Limbs.Under2p N.T := by
  obtain ⟨vX, bX, -⟩ := fd_f25519_neg.spec_wide hX
  obtain ⟨vT, bT, -⟩ := fd_f25519_neg.spec_wide hT
  refine ⟨?_, bX, bT⟩
  have := Ed25519.IsExt.neg hP
  simpa only [PointLimbs.Ext, fd_ed25519_point_neg.spec, vX, vT] using this

/-- `into_precomputed` takes `(x, y)` to its table form, `add_with_opts`'s precomputed operand;
`X` and `Y` loose, `T` tight. -/
public theorem fd_curve25519_into_precomputed.spec_operand (hP : P.Ext x y)
    (hX : Limbs.Under2p P.X) (hY : Limbs.Tight P.Y) (hT : Limbs.Loose P.T) :
    let Q := fd_curve25519_into_precomputed.spec P
    Q.Operand 0#32 1#32 x y ∧ Limbs.Loose Q.X ∧ Limbs.Loose Q.Y ∧ Limbs.Tight Q.T ∧ Q.Z = P.Z := by
  obtain ⟨vX, bX⟩ := fd_f25519_sub_nr.spec_wide hY hX
  obtain ⟨vY, bY⟩ := fd_f25519_add_nr.spec_wide hY hX
  obtain ⟨vk, bk⟩ := fd_f25519_k.val
  obtain ⟨vT, bT⟩ := fd_f25519_mul.spec_val hT bk.loose
  refine ⟨⟨_, _, _, _, hP, ?_⟩, bX, bY, bT, rfl⟩
  simp only [fd_curve25519_into_precomputed.spec, vX, vY, vT, vk]
  simp only [ite_true, show (1#32 = 0#32) = False by decide, ite_false, true_and]
  ring

/-- An operand whose `Z` is one may be passed with `zOne` set. -/
public theorem _root_.MLIR.PointLimbs.Operand.of_z_one {B : PointLimbs} {pre : BitVec 32}
    (h : B.Operand 0#32 pre x y) (hZ : Limbs.val B.Z = 1) (zOne : BitVec 32) :
    B.Operand zOne pre x y := by
  obtain ⟨X, Y, T, Z, hE, hz, hB⟩ := h
  refine ⟨X, Y, T, Z, hE, ?_, hB⟩
  simp only [ite_true] at hz
  split_ifs <;> simp [← hz, hZ]

/-- The order-8 `y`s' limbs: `y8` and `-y8`, tight. -/
theorem fd_ed25519_order8_point_y.val :
    (Limbs.val fd_ed25519_order8_point_y0.limbs = Ed25519.y8 ∧
        Limbs.Tight fd_ed25519_order8_point_y0.limbs) ∧
      (Limbs.val fd_ed25519_order8_point_y1.limbs = -Ed25519.y8 ∧
        Limbs.Tight fd_ed25519_order8_point_y1.limbs) := by
  refine ⟨⟨?_, by rw [Limbs.tight_iff]; decide⟩, ⟨?_, by rw [Limbs.tight_iff]; decide⟩⟩ <;>
    · rw [Limbs.val_eq]
      unfold Ed25519.y8
      simp [fd_ed25519_order8_point_y0.limbs, fd_ed25519_order8_point_y1.limbs]
      reduce_mod_char

/-- `is_small_order` on an affine point `(X, Y)` on the curve, `Y` tight and `X` within `2p`'s limbs
and below `2p`: `1` exactly when `8 (X, Y)` is the neutral point. -/
public theorem fd_ed25519_affine_is_small_order.spec_val (hX : Limbs.Under2p P.X)
    (hXn : Limbs.nat P.X < 2 * p) (hY : Limbs.Tight P.Y)
    (hc : Ed25519.OnCurve (Limbs.val P.X) (Limbs.val P.Y)) :
    fd_ed25519_affine_is_small_order.spec P =
      if Ed25519.SmallOrder (Limbs.val P.X) (Limbs.val P.Y) then 1#32 else 0#32 := by
  obtain ⟨⟨v0, b0⟩, ⟨v1, b1⟩⟩ := fd_ed25519_order8_point_y.val
  rw [fd_ed25519_affine_is_small_order.spec, fd_f25519_is_zero.spec_val hY.under2p hY.nat_lt,
    fd_f25519_is_zero.spec_val hX hXn, fd_f25519_eq.spec_val hY b0.under2p,
    fd_f25519_eq.spec_val hY b1.under2p, v0, v1]
  simp only [ite_or_ite]
  exact if_congr (by rw [Ed25519.smallOrder_iff hc]; tauto) rfl rfl

/-- `eq_z1` compares a projective `(x, y)` with the affine point `B`: `1` exactly when they are
equal. -/
public theorem fd_ed25519_point_eq_z1.spec_val {A B : PointLimbs} (hA : A.Proj x y)
    (hAX : Limbs.Tight A.X) (hAY : Limbs.Tight A.Y) (hAZ : Limbs.Loose A.Z)
    (hBX : Limbs.Loose B.X) (hBY : Limbs.Loose B.Y) :
    fd_ed25519_point_eq_z1.spec A B =
      if Limbs.val B.X = x ∧ Limbs.val B.Y = y then 1#32 else 0#32 := by
  obtain ⟨hz, hx, hy⟩ := hA
  obtain ⟨vx, bx⟩ := fd_f25519_mul.spec_val hBX hAZ
  obtain ⟨vy, by'⟩ := fd_f25519_mul.spec_val hBY hAZ
  simp only [fd_ed25519_point_eq_z1.spec, fd_f25519_eq.spec_val by' hAY.under2p,
    fd_f25519_eq.spec_val bx hAX.under2p, vx, vy, hx, hy, mul_left_inj' hz]
  rw [ite_and_ite]
  exact if_congr and_comm rfl rfl

/-- `d`, tight. -/
theorem fd_f25519_d.val :
    Limbs.val fd_f25519_d.limbs = Ed25519.d ∧ Limbs.Tight fd_f25519_d.limbs := by
  refine ⟨?_, by rw [Limbs.tight_iff]; decide⟩
  rw [Limbs.val_eq]
  unfold Ed25519.d
  simp [fd_f25519_d.limbs]
  reduce_mod_char

/-- `1`, tight. -/
theorem fd_f25519_one.val : Limbs.val fd_f25519_one.limbs = 1 ∧ Limbs.Tight fd_f25519_one.limbs :=
  ⟨by simp [Limbs.val_eq, fd_f25519_one.limbs], by rw [Limbs.tight_iff]; decide⟩

/-- The sign `frombytes` expects: `buf`'s top bit. -/
theorem fd_ed25519_point_frombytes.sign (buf : BitVec 256) :
    (buf.extractLsb' 248 8 >>> 7).setWidth 32 = BitVec.ofNat 32 (buf.toNat / 2 ^ 255) := by
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_setWidth, BitVec.toNat_ushiftRight, BitVec.extractLsb'_toNat,
    Nat.shiftRight_eq_div_pow, BitVec.toNat_ofNat]
  have := buf.isLt
  omega

/-- On the curve exactly when `(d y² + 1) x² = y² - 1`. -/
public theorem Ed25519.onCurve_iff :
    Ed25519.OnCurve x y ↔ (y ^ 2 * Ed25519.d + 1) * x ^ 2 = y ^ 2 - 1 := by
  unfold Ed25519.OnCurve
  constructor <;> intro h <;> linear_combination -h

/-- `frombytes`'s `u = y² - 1` and `v = d y² + 1` for `y` the bits `buf` holds, tight. -/
theorem fd_ed25519_point_frombytes.uv (buf : BitVec 256) :
    let y := fd_f25519_frombytes.spec buf
    let u := fd_f25519_sqr.spec y
    let v := fd_f25519_mul.spec u fd_f25519_d.limbs
    let u := fd_f25519_sub.spec u fd_f25519_one.limbs
    let v := fd_f25519_add.spec v fd_f25519_one.limbs
    (Limbs.val u = Limbs.val y ^ 2 - 1 ∧ Limbs.Tight u) ∧
      (Limbs.val v = Limbs.val y ^ 2 * Ed25519.d + 1 ∧ Limbs.Tight v) := by
  obtain ⟨-, yb⟩ := fd_f25519_frombytes.spec_val buf
  obtain ⟨vd, bd⟩ := fd_f25519_d.val
  obtain ⟨v1, b1⟩ := fd_f25519_one.val
  obtain ⟨uv, ub⟩ := fd_f25519_sqr.spec_val yb.loose
  obtain ⟨vv, vb⟩ := fd_f25519_mul.spec_val ub.loose bd.loose
  obtain ⟨uv', ub'⟩ := fd_f25519_sub.spec_val ub b1.under2p
  obtain ⟨vv', vb'⟩ := fd_f25519_add.spec_val vb b1
  exact ⟨⟨by rw [uv', uv, v1], ub'⟩, ⟨by rw [vv', vv, uv, vd, v1], vb'⟩⟩

/-- `frombytes`'s `u = y² - 1` and `v = d y² + 1` have positive numbers. -/
theorem fd_ed25519_point_frombytes.uv_pos (buf : BitVec 256) :
    let y := fd_f25519_frombytes.spec buf
    let u := fd_f25519_sqr.spec y
    let v := fd_f25519_mul.spec u fd_f25519_d.limbs
    0 < Limbs.nat (fd_f25519_sub.spec u fd_f25519_one.limbs) ∧
      0 < Limbs.nat (fd_f25519_add.spec v fd_f25519_one.limbs) := by
  obtain ⟨-, yb⟩ := fd_f25519_frombytes.spec_val buf
  obtain ⟨-, bd⟩ := fd_f25519_d.val
  obtain ⟨-, b1⟩ := fd_f25519_one.val
  obtain ⟨-, ub⟩ := fd_f25519_sqr.spec_val yb.loose
  obtain ⟨-, vb⟩ := fd_f25519_mul.spec_val ub.loose bd.loose
  have h1 : Limbs.nat fd_f25519_one.limbs = 1 := by decide
  exact ⟨fd_f25519_sub.spec_pos ub b1.under2p (by rw [h1]; exact Nat.lt_add_left _ (by decide)),
    fd_f25519_add.spec_pos vb b1 (by omega)⟩

/-- `frombytes`'s `v = d y² + 1` is never zero. -/
theorem fd_ed25519_point_frombytes.v_ne (buf : BitVec 256) :
    Limbs.val (fd_f25519_add.spec (fd_f25519_mul.spec (fd_f25519_sqr.spec
      (fd_f25519_frombytes.spec buf)) fd_f25519_d.limbs) fd_f25519_one.limbs) ≠ 0 := by
  rw [(fd_ed25519_point_frombytes.uv buf).2.1]
  intro h
  exact Ed25519.one_add_ne 1 (Limbs.val (fd_f25519_frombytes.spec buf))
    (by linear_combination h)

/-- `frombytes` fails exactly when no point on the curve has the `y` that `buf`'s low 255 bits
hold. -/
public theorem fd_ed25519_point_frombytes.spec_eq_none_iff (buf : BitVec 256) :
    fd_ed25519_point_frombytes.spec buf = none ↔
      ∀ x, ¬Ed25519.OnCurve x ((buf.toNat % 2 ^ 255 : ℕ) : ZMod p) := by
  obtain ⟨yv, -⟩ := fd_f25519_frombytes.spec_val buf
  obtain ⟨⟨uv, ub⟩, ⟨vv, vb⟩⟩ := fd_ed25519_point_frombytes.uv buf
  have hv0 := fd_ed25519_point_frombytes.v_ne buf
  obtain ⟨hsq, hnsq, -⟩ := fd_f25519_sqrt_ratio.spec_val ub vb hv0
  rw [← yv]
  have key : IsSquare (Limbs.val (fd_f25519_sub.spec (fd_f25519_sqr.spec
      (fd_f25519_frombytes.spec buf)) fd_f25519_one.limbs) / Limbs.val (fd_f25519_add.spec
        (fd_f25519_mul.spec (fd_f25519_sqr.spec (fd_f25519_frombytes.spec buf)) fd_f25519_d.limbs)
        fd_f25519_one.limbs)) ↔
        ∃ x, Ed25519.OnCurve x (Limbs.val (fd_f25519_frombytes.spec buf)) := by
    rw [vv] at hv0
    rw [uv, vv]
    simp only [Ed25519.onCurve_iff, IsSquare, div_eq_iff hv0]
    constructor <;> rintro ⟨r, hr⟩ <;> exact ⟨r, by linear_combination -hr⟩
  simp only [fd_ed25519_point_frombytes.spec]
  split
  · simp only [true_iff]
    intro x hx
    rename_i hret
    exact absurd ((hsq (key.2 ⟨x, hx⟩)).1.symm.trans hret) (by decide)
  · simp only [reduceCtorEq, false_iff, not_forall, not_not]
    rename_i hret
    by_contra h
    exact hret (hnsq fun hs => h (key.1 hs))

/-- A point `frombytes` decodes: `(x, y)` on the curve for `y` the bits `buf`'s low 255 bits hold,
`x` of the parity of `buf`'s top bit unless zero, `Z = 1`. `X` is within `2p`'s limbs and below
`2p`; `Y`, `T`, `Z` are tight. -/
public theorem fd_ed25519_point_frombytes.spec_some {buf : BitVec 256} {P : PointLimbs}
    (h : fd_ed25519_point_frombytes.spec buf = some P) :
    let y : ZMod p := ((buf.toNat % 2 ^ 255 : ℕ) : ZMod p)
    ∃ x, P.Ext x y ∧ Ed25519.OnCurve x y ∧ (x = 0 ∨ x.val % 2 = buf.toNat / 2 ^ 255) ∧
      Limbs.val P.Z = 1 ∧ Limbs.Under2p P.X ∧ Limbs.nat P.X < 2 * p ∧
      Limbs.Tight P.Y ∧ Limbs.Tight P.T ∧ Limbs.Tight P.Z := by
  dsimp only
  obtain ⟨yv, yb⟩ := fd_f25519_frombytes.spec_val buf
  rw [← yv]
  obtain ⟨⟨uv, ub⟩, ⟨vv, vb⟩⟩ := fd_ed25519_point_frombytes.uv buf
  obtain ⟨hsq, hnsq, hpar, hb2, hn⟩ :=
    fd_f25519_sqrt_ratio.spec_val ub vb (fd_ed25519_point_frombytes.v_ne buf)
  -- `r`'s number is positive, so `-r`'s is below `2p`
  have hpos := fd_f25519_sqrt_ratio.spec_pos ub vb (fd_ed25519_point_frombytes.uv_pos buf).1
    (fd_ed25519_point_frombytes.uv_pos buf).2
  obtain ⟨v1, b1⟩ := fd_f25519_one.val
  simp only [fd_ed25519_point_frombytes.spec] at h
  split at h
  · contradiction
  rename_i hret
  have hs : IsSquare _ := by_contra fun hs => hret (hnsq hs)
  obtain ⟨-, hroot⟩ := hsq hs
  rw [uv, vv] at hroot
  rw [fd_f25519_sgn.spec_val hb2 hn, hpar, fd_ed25519_point_frombytes.sign] at h
  simp only [Option.some.injEq] at h
  subst h
  generalize fd_f25519_sqrt_ratio.spec _ _ = R at hroot hpar hb2 hn hpos
  have hc : Ed25519.OnCurve (Limbs.val R.r) (Limbs.val (fd_f25519_frombytes.spec buf)) := by
    rw [Ed25519.onCurve_iff]
    linear_combination hroot
  -- `x` is `r`, or `-r` for the top bit set
  have hext (X : Fin 5 → BitVec 64) (hX : Limbs.Under2p X) :
      (PointLimbs.mk X (fd_f25519_frombytes.spec buf) (fd_f25519_mul.spec X
        (fd_f25519_frombytes.spec buf)) fd_f25519_one.limbs).Ext (Limbs.val X)
          (Limbs.val (fd_f25519_frombytes.spec buf)) ∧
        Limbs.Tight (fd_f25519_mul.spec X (fd_f25519_frombytes.spec buf)) := by
    obtain ⟨vt, bt⟩ := fd_f25519_mul.spec_val hX.loose yb.loose
    refine ⟨⟨by simp [v1], by simp [v1], by simp [v1], ?_⟩, bt⟩
    simp only [v1, vt, mul_one]
  rcases (by have := buf.isLt; omega : buf.toNat / 2 ^ 255 = 0 ∨ buf.toNat / 2 ^ 255 = 1)
    with hb | hb <;> rw [hb] at ⊢
  · simp only [ite_true]
    obtain ⟨he, bt⟩ := hext R.r hb2
    exact ⟨_, he, hc, .inr hpar, v1, hb2, hn, yb, bt, b1⟩
  · simp only [show (0#32 = BitVec.ofNat 32 1) = False by decide, ite_false]
    obtain ⟨vn, bn, nn⟩ := fd_f25519_neg.spec_wide hb2
    obtain ⟨he, bt⟩ := hext _ bn
    refine ⟨_, he, by rw [vn]; exact hc.neg, ?_, v1, bn, by omega, yb, bt, b1⟩
    rw [vn]
    by_cases h0 : Limbs.val R.r = 0
    · exact .inl (by simp [h0])
    · right
      rw [ZMod.neg_val, ite_eq_right h0]
      have := ZMod.val_lt (Limbs.val R.r)
      have hp : p % 2 = 1 := by norm_num
      omega

end Proof

end MLIR.Firedancer.Ref
