module

public import Ed25519.Field
public import Mathlib.Algebra.Field.ZMod
import Mathlib.FieldTheory.Finite.Basic
import Mathlib.NumberTheory.LegendreSymbol.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.ReduceModChar

/-! The twisted Edwards curve `-x² + y² = 1 + d x² y²` over `ZMod p`: its affine formulas, where
they are defined, and the points of small order. -/

namespace Ed25519

/-! ## Definitions -/

@[expose] public section

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

end

/-! ## The curve constant -/

section Constant

public theorem d_pow : d ^ (p / 2) = -1 := by
  unfold d
  reduce_mod_char

/-- `d` is not a square, so the curve's formulas never divide by zero. -/
public theorem d_not_square : ¬IsSquare d := by
  have hd : d ≠ 0 := by
    intro h
    have := d_pow
    rw [h, zero_pow (by decide)] at this
    exact
      absurd this.symm
        (by
          reduce_mod_char; decide)
  rw [ZMod.euler_criterion p hd, d_pow]
  reduce_mod_char
  decide

end Constant

/-! ## Denominators on the curve -/

section Denominators

variable {x y : ZMod p}

/-- On the curve `x y ≠ 0` once `d x² y²` is `± 1`. -/
public theorem mul_ne_zero_of_d (h : d * x ^ 2 * y ^ 2 = c) (hc : c ≠ 0) : x * y ≠ 0 := by
  intro hxy
  apply hc
  rw [← h]
  linear_combination (d * x * y) * hxy

/-- `1 + d x² y² ≠ 0`: else `d = (√-1 / (x y))²`. -/
public theorem one_add_ne (x y : ZMod p) : 1 + d * x ^ 2 * y ^ 2 ≠ 0 := by
  intro h0
  have h1 : d * x ^ 2 * y ^ 2 = -1 := by linear_combination h0
  have hxy := mul_ne_zero_of_d h1 (by simp)
  apply d_not_square
  refine ⟨sqrtM1 / (x * y), ?_⟩
  rw [div_mul_div_comm, eq_div_iff (mul_ne_zero hxy hxy)]
  linear_combination h1 - sqrtM1_sq

/-- `1 - d x² y² ≠ 0`: else `d = (1 / (x y))²`. -/
public theorem one_sub_ne (x y : ZMod p) : 1 - d * x ^ 2 * y ^ 2 ≠ 0 := by
  intro h0
  have h1 : d * x ^ 2 * y ^ 2 = 1 := by linear_combination -h0
  have hxy := mul_ne_zero_of_d h1 one_ne_zero
  apply d_not_square
  refine ⟨1 / (x * y), ?_⟩
  rw [div_mul_div_comm, eq_div_iff (mul_ne_zero hxy hxy)]
  linear_combination h1

/-- Doubling's `y² - x²`, nonzero on the curve. -/
public theorem dbl_den₁ (hc : OnCurve x y) : y ^ 2 - x ^ 2 ≠ 0 := by
  have := one_add_ne x y
  unfold OnCurve at hc
  intro h
  exact this (by linear_combination -hc + h)

/-- Doubling's `2 - y² + x²`, nonzero on the curve. -/
public theorem dbl_den₂ (hc : OnCurve x y) : 2 - y ^ 2 + x ^ 2 ≠ 0 := by
  have := one_sub_ne x y
  unfold OnCurve at hc
  intro h
  exact this (by linear_combination hc + h)

/-- Doubling stays on the curve. -/
public theorem dbl_onCurve (hc : OnCurve x y) : OnCurve (dbl x y).1 (dbl x y).2 := by
  have d₁ := dbl_den₁ hc
  have d₂ := dbl_den₂ hc
  unfold OnCurve at hc ⊢
  simp only [dbl]
  field_simp
  linear_combination (4 * (x ^ 2 + y ^ 2) ^ 2) * hc

/-- The key square: on the curve, `d x₁ x₂ y₁ y₂ = ε` with `ε² = 1` makes `(y₁ + ε j x₁)²` equal
`d (x₁ y₁ (y₂ + j x₂))²` for a square root `j` of `-1`. -/
public theorem add_square {x₁ y₁ x₂ y₂ ε j : ZMod p} (h1 : OnCurve x₁ y₁) (h2 : OnCurve x₂ y₂)
    (h : d * x₁ * x₂ * y₁ * y₂ = ε) (hε : ε ^ 2 = 1) (hj : j ^ 2 = -1) :
    (y₁ + ε * j * x₁) ^ 2 = d * (x₁ * y₁ * (y₂ + j * x₂)) ^ 2 := by
  unfold OnCurve at h1 h2
  have e1 : (y₁ + ε * j * x₁) ^ 2 = y₁ ^ 2 - x₁ ^ 2 + 2 * ε * j * x₁ * y₁ := by
    linear_combination (x₁ ^ 2 * ε ^ 2) * hj - x₁ ^ 2 * hε
  have e2 :
    d * (x₁ * y₁ * (y₂ + j * x₂)) ^ 2 =
      d * x₁ ^ 2 * y₁ ^ 2 * (y₂ ^ 2 - x₂ ^ 2) + 2 * j * x₁ * y₁ * (d * x₁ * x₂ * y₁ * y₂) := by
    linear_combination (d * x₁ ^ 2 * y₁ ^ 2 * x₂ ^ 2) * hj
  have e3 : d * x₁ ^ 2 * y₁ ^ 2 * (y₂ ^ 2 - x₂ ^ 2) = y₁ ^ 2 - x₁ ^ 2 := by
    linear_combination (d * x₁ ^ 2 * y₁ ^ 2) * h2 + (d * x₁ * x₂ * y₁ * y₂ + ε) * h + hε - h1
  rw [e1, e2, e3, h]
  ring

/-- The addition's denominators never vanish on the curve: `d x₁ x₂ y₁ y₂ ≠ ±1`. -/
public theorem add_ne {x₁ y₁ x₂ y₂ ε : ZMod p} (h1 : OnCurve x₁ y₁) (h2 : OnCurve x₂ y₂)
    (hε : ε ^ 2 = 1) : d * x₁ * x₂ * y₁ * y₂ ≠ ε := by
  intro h
  have hε0 : ε ≠ 0 := by
    rintro rfl; simp at hε
  have hall : x₁ * y₁ * (x₂ * y₂) ≠ 0 := by
    intro h0
    apply hε0
    rw [← h]
    linear_combination d * h0
  have hx₁y₁ : x₁ * y₁ ≠ 0 := left_ne_zero_of_mul hall
  have hy₂ : y₂ ≠ 0 := right_ne_zero_of_mul (right_ne_zero_of_mul hall)
  -- with `j` and `-j`, `y₂ ± j x₂ = 0`, so `y₂ = 0`
  have hzero (j : ZMod p) (hj : j ^ 2 = -1) : y₂ + j * x₂ = 0 := by
    by_contra hne
    apply d_not_square
    refine ⟨(y₁ + ε * j * x₁) / (x₁ * y₁ * (y₂ + j * x₂)), ?_⟩
    have hden : x₁ * y₁ * (y₂ + j * x₂) ≠ 0 := mul_ne_zero hx₁y₁ hne
    rw [div_mul_div_comm, eq_div_iff (mul_ne_zero hden hden)]
    linear_combination -(add_square h1 h2 h hε hj)
  have hi := hzero _ sqrtM1_sq
  have hi' :=
    hzero (-sqrtM1)
      (by
        rw [neg_sq]; exact sqrtM1_sq)
  apply hy₂
  have h2y : 2 * y₂ = 0 := by linear_combination hi + hi'
  have h2 : (2 : ZMod p) ≠ 0 := by decide
  simpa [h2] using h2y

/-- `1 + d x₁ x₂ y₁ y₂ ≠ 0` on the curve. -/
public theorem add_den₁ {x₁ y₁ x₂ y₂ : ZMod p} (h1 : OnCurve x₁ y₁) (h2 : OnCurve x₂ y₂) :
    1 + d * x₁ * x₂ * y₁ * y₂ ≠ 0 := by
  have := add_ne h1 h2 (ε := -1) (by ring)
  intro h
  exact this (by linear_combination h)

/-- `1 - d x₁ x₂ y₁ y₂ ≠ 0` on the curve. -/
public theorem add_den₂ {x₁ y₁ x₂ y₂ : ZMod p} (h1 : OnCurve x₁ y₁) (h2 : OnCurve x₂ y₂) :
    1 - d * x₁ * x₂ * y₁ * y₂ ≠ 0 := by
  have := add_ne h1 h2 (ε := 1) (by ring)
  intro h
  exact this (by linear_combination -h)

/-- Addition from extended coordinates, as `add_with_opts` computes it before its last
multiplications: `(r₆ - r₅, r₈ - r₇, r₈ + r₇, r₆ + r₅)` is the sum as a completed point. -/
public theorem add_compl {x₁ y₁ X₁ Y₁ T₁ Z₁ x₂ y₂ X₂ Y₂ T₂ Z₂ : ZMod p}
    (hA : IsExt x₁ y₁ X₁ Y₁ T₁ Z₁) (hB : IsExt x₂ y₂ X₂ Y₂ T₂ Z₂) (h1 : OnCurve x₁ y₁)
    (h2 : OnCurve x₂ y₂) :
    let r₅ := (Y₁ - X₁) * (Y₂ - X₂)
    let r₆ := (Y₁ + X₁) * (Y₂ + X₂)
    let r₇ := T₁ * T₂ * (2 * d)
    let r₈ := (Z₁ + Z₁) * Z₂
    let Q := add x₁ y₁ x₂ y₂
    r₈ + r₇ ≠ 0 ∧ r₈ - r₇ ≠ 0 ∧ r₆ - r₅ = Q.1 * (r₈ + r₇) ∧ r₆ + r₅ = Q.2 * (r₈ - r₇) := by
  obtain ⟨hZ₁, rfl, rfl, hT₁⟩ := hA
  obtain ⟨hZ₂, rfl, rfl, hT₂⟩ := hB
  obtain rfl : T₁ = x₁ * y₁ * Z₁ :=
    mul_right_cancel₀ hZ₁
      (by
        rw [hT₁]; ring)
  obtain rfl : T₂ = x₂ * y₂ * Z₂ :=
    mul_right_cancel₀ hZ₂
      (by
        rw [hT₂]; ring)
  have d₁ := add_den₁ h1 h2
  have d₂ := add_den₂ h1 h2
  have h2 : (2 : ZMod p) ≠ 0 := by decide
  have e₁ :
    (Z₁ + Z₁) * Z₂ + x₁ * y₁ * Z₁ * (x₂ * y₂ * Z₂) * (2 * d) =
      2 * Z₁ * Z₂ * (1 + d * x₁ * x₂ * y₁ * y₂) := by
    ring
  have e₂ :
    (Z₁ + Z₁) * Z₂ - x₁ * y₁ * Z₁ * (x₂ * y₂ * Z₂) * (2 * d) =
      2 * Z₁ * Z₂ * (1 - d * x₁ * x₂ * y₁ * y₂) := by
    ring
  simp only [add, e₁, e₂]
  refine ⟨by simp [*], by simp [*], ?_, ?_⟩
  · rw [mul_comm (2 * Z₁ * Z₂), ← mul_assoc, div_mul_cancel₀ _ d₁]
    ring
  · rw [mul_comm (2 * Z₁ * Z₂), ← mul_assoc, div_mul_cancel₀ _ d₂]
    ring

/-- Negation, `(-x, y)`, stays on the curve. -/
public theorem OnCurve.neg (h : OnCurve x y) : OnCurve (-x) y := by
  unfold OnCurve at *
  linear_combination h

/-- Negation in extended coordinates. -/
public theorem IsExt.neg {X Y T Z : ZMod p} (h : IsExt x y X Y T Z) :
    IsExt (-x) y (-X) Y (-T) Z := by
  obtain ⟨hZ, rfl, rfl, hT⟩ := h
  exact ⟨hZ, by ring, rfl, by linear_combination -hT⟩

end Denominators

/-! ## Small order -/

section SmallOrder

variable {x y : ZMod p}

/-- The other root of `d s² + 2 s - 1`, besides `y8²`; not a square. -/
@[expose]
public def s₁ : ZMod p :=
  3685532557031388680362915159118232971324886473920755116993713661282644049091

public theorem s₁_not_square : ¬IsSquare s₁ := by
  have h0 : s₁ ≠ 0 := by
    unfold s₁; decide
  rw [ZMod.euler_criterion p h0]
  unfold s₁
  reduce_mod_char
  decide

/-- `d s² + 2 s - 1 = d (s - y8²) (s - s₁)`. -/
public theorem y8_poly (s : ZMod p) : d * s ^ 2 + 2 * s - 1 = d * (s - y8 ^ 2) * (s - s₁) := by
  have e1 : d * (y8 ^ 2 + s₁) = -2 := by
    unfold d y8 s₁
    reduce_mod_char
  have e2 : d * y8 ^ 2 * s₁ = -1 := by
    unfold d y8 s₁
    reduce_mod_char
  linear_combination s * e1 - e2

public theorem d_ne_zero : d ≠ 0 := by
  unfold d
  decide

/-- On the curve, `y² + x² = 0` exactly at the order-8 points. -/
public theorem sq_add_sq_eq_zero (hc : OnCurve x y) : y ^ 2 + x ^ 2 = 0 ↔ y = y8 ∨ y = -y8 := by
  unfold OnCurve at hc
  have hp := y8_poly (y ^ 2)
  constructor
  · intro h
    have h0 : d * (y ^ 2 - y8 ^ 2) * (y ^ 2 - s₁) = 0 := by
      rw [← hp]
      linear_combination (1 + d * y ^ 2) * h + hc
    rcases mul_eq_zero.1 h0 with h1 | h1
    · rcases mul_eq_zero.1 h1 with h2 | h2
      · exact absurd h2 d_ne_zero
      · have : (y - y8) * (y + y8) = 0 := by linear_combination h2
        rcases mul_eq_zero.1 this with h3 | h3
        · exact .inl (by linear_combination h3)
        · exact .inr (by linear_combination h3)
    · exact absurd ⟨y, by linear_combination -h1⟩ s₁_not_square
  · intro h
    have hy : y ^ 2 = y8 ^ 2 := by rcases h with rfl | rfl <;> ring
    have hne := one_add_ne 1 y
    have q : d * (y ^ 2) ^ 2 + 2 * y ^ 2 - 1 = 0 := by
      rw [hp, hy]; ring
    have : (1 + d * 1 ^ 2 * y ^ 2) * (y ^ 2 + x ^ 2) = 0 := by linear_combination q - hc
    exact (mul_eq_zero.1 this).resolve_left hne

/-- Doubling's `x` vanishes exactly when `x y` does. -/
public theorem dbl_fst_eq_zero (hc : OnCurve x y) : (dbl x y).1 = 0 ↔ x * y = 0 := by
  have := dbl_den₁ hc
  have h2 : (2 : ZMod p) ≠ 0 := by decide
  simp only [dbl, div_eq_zero_iff, this, or_false, mul_assoc, mul_eq_zero, h2, false_or]

/-- Doubling's `y` vanishes exactly when `y² + x²` does. -/
public theorem dbl_snd_eq_zero (hc : OnCurve x y) : (dbl x y).2 = 0 ↔ y ^ 2 + x ^ 2 = 0 := by
  have := dbl_den₂ hc
  simp only [dbl, div_eq_zero_iff, this, or_false]

/-- Doubling a point with `x = 0`, `(0, ±1)`, gives the neutral point. -/
public theorem dbl_of_fst (hc : OnCurve x y) (hx : x = 0) : dbl x y = (0, 1) := by
  subst hx
  unfold OnCurve at hc
  have hy : y ^ 2 = 1 := by linear_combination hc
  simp [dbl, hy]
  norm_num

/-- Doubling a point with `y = 0`, of order 4, gives `(0, -1)`. -/
public theorem dbl_of_snd (hc : OnCurve x y) (hy : y = 0) : dbl x y = (0, -1) := by
  subst hy
  unfold OnCurve at hc
  have hx : x ^ 2 = -1 := by linear_combination -hc
  simp [dbl, hx]
  norm_num

/-- A point is of small order exactly when `x = 0`, `y = 0`, or `y = ± y8`. -/
public theorem smallOrder_iff (hc : OnCurve x y) :
    SmallOrder x y ↔ x = 0 ∨ y = 0 ∨ y = y8 ∨ y = -y8 := by
  have c1 := dbl_onCurve hc
  have c2 := dbl_onCurve c1
  have hm1 : (-1 : ZMod p) ≠ 1 := by decide
  simp only [SmallOrder, dblN]
  constructor
  · intro h
    have h3 := (dbl_fst_eq_zero c2).1 (congrArg Prod.fst h)
    rcases mul_eq_zero.1 h3 with h4 | h4
    · rcases mul_eq_zero.1 ((dbl_fst_eq_zero c1).1 h4) with h5 | h5
      · rcases mul_eq_zero.1 ((dbl_fst_eq_zero hc).1 h5) with h6 | h6
        · exact .inl h6
        · exact .inr (.inl h6)
      · exact .inr (.inr ((sq_add_sq_eq_zero hc).1 ((dbl_snd_eq_zero hc).1 h5)))
    · rw [dbl_of_snd c2 h4] at h
      exact absurd (congrArg Prod.snd h) hm1
  · intro h
    rcases h with h | h | h
    · rw [dbl_of_fst c1 ((dbl_fst_eq_zero hc).2 (by simp [h]))]
      exact
        dbl_of_fst
          (by
            unfold OnCurve; ring)
          rfl
    · rw [dbl_of_fst c1 ((dbl_fst_eq_zero hc).2 (by simp [h]))]
      exact
        dbl_of_fst
          (by
            unfold OnCurve; ring)
          rfl
    · have h1 := (dbl_snd_eq_zero hc).2 ((sq_add_sq_eq_zero hc).2 h)
      rw [dbl_of_snd c1 h1]
      exact
        dbl_of_fst
          (by
            unfold OnCurve; ring)
          rfl

end SmallOrder

/-- The neutral point is on the curve. -/
public theorem onCurve_zero : OnCurve 0 1 := by
  unfold OnCurve
  ring

/-- On the curve exactly when `(d y² + 1) x² = y² - 1`. -/
public theorem onCurve_iff {x y : ZMod p} : OnCurve x y ↔ (y ^ 2 * d + 1) * x ^ 2 = y ^ 2 - 1 := by
  unfold OnCurve
  constructor <;> intro h <;> linear_combination -h

end Ed25519
