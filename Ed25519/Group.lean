module

public import Ed25519.Curve
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

/-! The group law: the curve's points form an abelian group under `Ed25519.add`, with `(0, 1)`
neutral and `-(x, y) = (-x, y)`, and `dblN n` multiplies by `2ⁿ`. Closure and associativity are
polynomial identities modulo the curve equations, their certificates found by Singular's `lift`. -/

namespace Ed25519

/-! ## Definitions -/

@[expose] public section

/-- A point on the curve. -/
@[ext]
structure Point where
  x : ZMod p
  y : ZMod p
  on : OnCurve x y

end

/-! ## Closure and associativity -/

section Assoc

variable {x₁ y₁ x₂ y₂ x₃ y₃ : ZMod p}

/-- The sum's `x` times its denominator. -/
public theorem add_fst_mul (h1 : OnCurve x₁ y₁) (h2 : OnCurve x₂ y₂) :
    (add x₁ y₁ x₂ y₂).1 * (1 + d * x₁ * x₂ * y₁ * y₂) = x₁ * y₂ + y₁ * x₂ :=
  div_mul_cancel₀ _ (add_den₁ h1 h2)

/-- The sum's `y` times its denominator. -/
public theorem add_snd_mul (h1 : OnCurve x₁ y₁) (h2 : OnCurve x₂ y₂) :
    (add x₁ y₁ x₂ y₂).2 * (1 - d * x₁ * x₂ * y₁ * y₂) = y₁ * y₂ + x₁ * x₂ :=
  div_mul_cancel₀ _ (add_den₂ h1 h2)

/-- The sum stays on the curve. -/
public theorem add_onCurve (h1 : OnCurve x₁ y₁) (h2 : OnCurve x₂ y₂) :
    OnCurve (add x₁ y₁ x₂ y₂).1 (add x₁ y₁ x₂ y₂).2 := by
  have d₁ := add_den₁ h1 h2
  have d₂ := add_den₂ h1 h2
  have ha := add_fst_mul h1 h2
  have hb := add_snd_mul h1 h2
  generalize (add x₁ y₁ x₂ y₂).1 = a at ha ⊢
  generalize (add x₁ y₁ x₂ y₂).2 = b at hb ⊢
  unfold OnCurve at h1 h2 ⊢
  have key : -(x₁ * y₂ + y₁ * x₂) ^ 2 * (1 - d * x₁ * x₂ * y₁ * y₂) ^ 2 +
      (y₁ * y₂ + x₁ * x₂) ^ 2 * (1 + d * x₁ * x₂ * y₁ * y₂) ^ 2 =
      (1 + d * x₁ * x₂ * y₁ * y₂) ^ 2 * (1 - d * x₁ * x₂ * y₁ * y₂) ^ 2 +
        d * (x₁ * y₂ + y₁ * x₂) ^ 2 * (y₁ * y₂ + x₁ * x₂) ^ 2 := by
    linear_combination (x₁ ^ 2 * y₁ ^ 2 * x₂ ^ 4 * d + x₁ ^ 2 * y₁ ^ 2 * y₂ ^ 4 * d +
      2 * x₁ ^ 2 * y₁ ^ 2 * x₂ ^ 2 * d - 2 * x₁ ^ 2 * y₁ ^ 2 * y₂ ^ 2 * d +
      2 * x₁ ^ 2 * y₁ ^ 2 * x₂ ^ 2 - 2 * x₁ ^ 2 * y₁ ^ 2 * y₂ ^ 2 + x₁ ^ 2 * y₁ ^ 2 * d +
      2 * x₁ ^ 2 * y₁ ^ 2 - x₁ ^ 2 * x₂ ^ 2 + y₁ ^ 2 * x₂ ^ 2 + x₁ ^ 2 * y₂ ^ 2 - y₁ ^ 2 * y₂ ^ 2 -
      x₁ ^ 2 + y₁ ^ 2 + 1) * h1 + (x₁ ^ 4 * y₁ ^ 4 * x₂ ^ 2 * y₂ ^ 2 * d ^ 3 -
      x₁ ^ 4 * y₁ ^ 4 * x₂ ^ 2 * d ^ 2 + x₁ ^ 4 * y₁ ^ 4 * y₂ ^ 2 * d ^ 2 -
      x₁ ^ 4 * y₁ ^ 4 * d ^ 2 - 2 * x₁ ^ 4 * y₁ ^ 4 * d - x₁ ^ 4 * y₁ ^ 2 * x₂ ^ 2 * d +
      x₁ ^ 2 * y₁ ^ 4 * x₂ ^ 2 * d + x₁ ^ 4 * y₁ ^ 2 * y₂ ^ 2 * d - x₁ ^ 2 * y₁ ^ 4 * y₂ ^ 2 * d -
      2 * x₁ ^ 4 * y₁ ^ 2 + 2 * x₁ ^ 2 * y₁ ^ 4 - 2 * x₁ ^ 2 * y₁ ^ 2 * d + x₁ ^ 4 -
      4 * x₁ ^ 2 * y₁ ^ 2 + y₁ ^ 4) * h2
  generalize 1 + d * x₁ * x₂ * y₁ * y₂ = mx at d₁ ha key
  generalize 1 - d * x₁ * x₂ * y₁ * y₂ = my at d₂ hb key
  generalize x₁ * y₂ + y₁ * x₂ = nx at ha key
  generalize y₁ * y₂ + x₁ * x₂ = ny at hb key
  apply mul_left_cancel₀ (pow_ne_zero 2 (mul_ne_zero d₁ d₂))
  linear_combination key -
    (my ^ 2 * (a * mx + nx) + d * (a * mx * b * my + nx * ny) * b * my) * ha +
    (mx ^ 2 * (b * my + ny) - d * (a * mx * b * my + nx * ny) * nx) * hb

/-- Negation, `(-x, y)`, stays on the curve. -/
public theorem onCurve_neg {x y : ZMod p} (h : OnCurve x y) : OnCurve (-x) y :=
  OnCurve.neg h

/-- The sum is symmetric. -/
public theorem add_symm (x₁ y₁ x₂ y₂ : ZMod p) : add x₁ y₁ x₂ y₂ = add x₂ y₂ x₁ y₁ := by
  simp only [add]
  congr 1 <;> ring

/-- `(a, b) + (x, y)` for `a = nx / mx` and `b = ny / my`, its denominators cleared. -/
public theorem add_mul_den {a b x y nx mx ny my : ZMod p} (ha : a * mx = nx) (hb : b * my = ny)
    (hab : OnCurve a b) (hxy : OnCurve x y) (hmx : mx ≠ 0) (hmy : my ≠ 0) :
    (add a b x y).1 * (mx * my + d * nx * ny * x * y) = nx * my * y + ny * mx * x ∧
      mx * my + d * nx * ny * x * y ≠ 0 ∧
      (add a b x y).2 * (mx * my - d * nx * ny * x * y) = ny * mx * y + nx * my * x ∧
      mx * my - d * nx * ny * x * y ≠ 0 := by
  subst ha hb
  have e₁ : mx * my + d * (a * mx) * (b * my) * x * y = (1 + d * a * x * b * y) * (mx * my) := by
    ring
  have e₂ : mx * my - d * (a * mx) * (b * my) * x * y = (1 - d * a * x * b * y) * (mx * my) := by
    ring
  have d₁ := add_den₁ hab hxy
  have d₂ := add_den₂ hab hxy
  simp only [add, e₁, e₂]
  refine ⟨?_, mul_ne_zero d₁ (mul_ne_zero hmx hmy), ?_, mul_ne_zero d₂ (mul_ne_zero hmx hmy)⟩
  · rw [← mul_assoc, div_mul_cancel₀ _ d₁]
    ring
  · rw [← mul_assoc, div_mul_cancel₀ _ d₂]
    ring

/-- The sum is associative on the curve. -/
public theorem add_add (h1 : OnCurve x₁ y₁) (h2 : OnCurve x₂ y₂) (h3 : OnCurve x₃ y₃) :
    add (add x₁ y₁ x₂ y₂).1 (add x₁ y₁ x₂ y₂).2 x₃ y₃ =
      add x₁ y₁ (add x₂ y₂ x₃ y₃).1 (add x₂ y₂ x₃ y₃).2 := by
  obtain ⟨l₁, l₂, l₃, l₄⟩ := add_mul_den (add_fst_mul h1 h2) (add_snd_mul h1 h2)
    (add_onCurve h1 h2) h3 (add_den₁ h1 h2) (add_den₂ h1 h2)
  obtain ⟨r₁, r₂, r₃, r₄⟩ := add_mul_den (add_fst_mul h2 h3) (add_snd_mul h2 h3)
    (add_onCurve h2 h3) h1 (add_den₁ h2 h3) (add_den₂ h2 h3)
  rw [add_symm x₁ y₁ (add x₂ y₂ x₃ y₃).1]
  unfold OnCurve at h1 h2 h3
  refine Prod.ext ?_ ?_
  · rw [eq_div_of_mul_eq l₂ l₁, eq_div_of_mul_eq r₂ r₁, div_eq_div_iff l₂ r₂]
    linear_combination (x₁ * x₂ ^ 2 * y₂ * x₃ ^ 2 * y₃ * d - y₁ * x₂ * y₂ ^ 2 * x₃ ^ 2 * y₃ * d -
      y₁ * x₂ ^ 2 * y₂ * x₃ * y₃ ^ 2 * d + x₁ * x₂ * y₂ ^ 2 * x₃ * y₃ ^ 2 * d +
      x₁ * x₂ ^ 3 * x₃ ^ 3 + y₁ * x₂ ^ 2 * y₂ * x₃ ^ 3 - x₁ * x₂ * y₂ ^ 2 * x₃ ^ 3 -
      y₁ * y₂ ^ 3 * x₃ ^ 3 + y₁ * x₂ ^ 3 * x₃ ^ 2 * y₃ + x₁ * x₂ ^ 2 * y₂ * x₃ ^ 2 * y₃ -
      y₁ * x₂ * y₂ ^ 2 * x₃ ^ 2 * y₃ - x₁ * y₂ ^ 3 * x₃ ^ 2 * y₃ - x₁ * x₂ ^ 3 * x₃ * y₃ ^ 2 -
      y₁ * x₂ ^ 2 * y₂ * x₃ * y₃ ^ 2 + x₁ * x₂ * y₂ ^ 2 * x₃ * y₃ ^ 2 + y₁ * y₂ ^ 3 * x₃ * y₃ ^ 2 -
      y₁ * x₂ ^ 3 * y₃ ^ 3 - x₁ * x₂ ^ 2 * y₂ * y₃ ^ 3 + y₁ * x₂ * y₂ ^ 2 * y₃ ^ 3 +
      x₁ * y₂ ^ 3 * y₃ ^ 3 + x₁ * x₂ ^ 3 * x₃ + y₁ * x₂ ^ 2 * y₂ * x₃ - x₁ * x₂ * y₂ ^ 2 * x₃ -
      y₁ * y₂ ^ 3 * x₃ + x₁ * x₂ * x₃ ^ 3 + y₁ * y₂ * x₃ ^ 3 + y₁ * x₂ ^ 3 * y₃ +
      x₁ * x₂ ^ 2 * y₂ * y₃ - y₁ * x₂ * y₂ ^ 2 * y₃ - x₁ * y₂ ^ 3 * y₃ + y₁ * x₂ * x₃ ^ 2 * y₃ +
      x₁ * y₂ * x₃ ^ 2 * y₃ - x₁ * x₂ * x₃ * y₃ ^ 2 - y₁ * y₂ * x₃ * y₃ ^ 2 - y₁ * x₂ * y₃ ^ 3 -
      x₁ * y₂ * y₃ ^ 3 + x₁ * x₂ * x₃ + y₁ * y₂ * x₃ + y₁ * x₂ * y₃ + x₁ * y₂ * y₃) * h1 +
      (-x₁ ^ 3 * y₁ ^ 2 * x₂ ^ 2 * y₂ * x₃ ^ 2 * y₃ * d ^ 2 +
      x₁ ^ 2 * y₁ ^ 3 * x₂ * y₂ ^ 2 * x₃ ^ 2 * y₃ * d ^ 2 +
      x₁ ^ 2 * y₁ ^ 3 * x₂ ^ 2 * y₂ * x₃ * y₃ ^ 2 * d ^ 2 -
      x₁ ^ 3 * y₁ ^ 2 * x₂ * y₂ ^ 2 * x₃ * y₃ ^ 2 * d ^ 2 - x₁ ^ 3 * y₁ ^ 2 * x₂ * x₃ ^ 3 * d -
      x₁ ^ 2 * y₁ ^ 3 * y₂ * x₃ ^ 3 * d - x₁ ^ 2 * y₁ * x₂ ^ 2 * y₂ * x₃ ^ 3 * d -
      x₁ * y₁ ^ 2 * x₂ * y₂ ^ 2 * x₃ ^ 3 * d - x₁ ^ 2 * y₁ ^ 3 * x₂ * x₃ ^ 2 * y₃ * d -
      x₁ ^ 3 * y₁ ^ 2 * y₂ * x₃ ^ 2 * y₃ * d + x₁ * y₁ ^ 2 * x₂ ^ 2 * y₂ * x₃ ^ 2 * y₃ * d +
      x₁ ^ 2 * y₁ * x₂ * y₂ ^ 2 * x₃ ^ 2 * y₃ * d + x₁ ^ 3 * y₁ ^ 2 * x₂ * x₃ * y₃ ^ 2 * d +
      x₁ ^ 2 * y₁ ^ 3 * y₂ * x₃ * y₃ ^ 2 * d + x₁ ^ 2 * y₁ * x₂ ^ 2 * y₂ * x₃ * y₃ ^ 2 * d +
      x₁ * y₁ ^ 2 * x₂ * y₂ ^ 2 * x₃ * y₃ ^ 2 * d + x₁ ^ 2 * y₁ ^ 3 * x₂ * y₃ ^ 3 * d +
      x₁ ^ 3 * y₁ ^ 2 * y₂ * y₃ ^ 3 * d - x₁ * y₁ ^ 2 * x₂ ^ 2 * y₂ * y₃ ^ 3 * d -
      x₁ ^ 2 * y₁ * x₂ * y₂ ^ 2 * y₃ ^ 3 * d - x₁ ^ 3 * y₁ ^ 2 * x₂ * x₃ * d -
      x₁ ^ 2 * y₁ ^ 3 * y₂ * x₃ * d - x₁ ^ 2 * y₁ * x₂ ^ 2 * y₂ * x₃ * d -
      x₁ * y₁ ^ 2 * x₂ * y₂ ^ 2 * x₃ * d - x₁ ^ 2 * y₁ ^ 3 * x₂ * y₃ * d -
      x₁ ^ 3 * y₁ ^ 2 * y₂ * y₃ * d + x₁ * y₁ ^ 2 * x₂ ^ 2 * y₂ * y₃ * d +
      x₁ ^ 2 * y₁ * x₂ * y₂ ^ 2 * y₃ * d - x₁ ^ 3 * x₂ * x₃ ^ 3 + x₁ * y₁ ^ 2 * x₂ * x₃ ^ 3 -
      x₁ ^ 2 * y₁ * y₂ * x₃ ^ 3 + y₁ ^ 3 * y₂ * x₃ ^ 3 - x₁ ^ 2 * y₁ * x₂ * x₃ ^ 2 * y₃ +
      y₁ ^ 3 * x₂ * x₃ ^ 2 * y₃ - x₁ ^ 3 * y₂ * x₃ ^ 2 * y₃ + x₁ * y₁ ^ 2 * y₂ * x₃ ^ 2 * y₃ +
      x₁ ^ 3 * x₂ * x₃ * y₃ ^ 2 - x₁ * y₁ ^ 2 * x₂ * x₃ * y₃ ^ 2 + x₁ ^ 2 * y₁ * y₂ * x₃ * y₃ ^ 2 -
      y₁ ^ 3 * y₂ * x₃ * y₃ ^ 2 + x₁ ^ 2 * y₁ * x₂ * y₃ ^ 3 - y₁ ^ 3 * x₂ * y₃ ^ 3 +
      x₁ ^ 3 * y₂ * y₃ ^ 3 - x₁ * y₁ ^ 2 * y₂ * y₃ ^ 3 - x₁ ^ 3 * x₂ * x₃ + x₁ * y₁ ^ 2 * x₂ * x₃ -
      x₁ ^ 2 * y₁ * y₂ * x₃ + y₁ ^ 3 * y₂ * x₃ - x₁ * x₂ * x₃ ^ 3 - y₁ * y₂ * x₃ ^ 3 -
      x₁ ^ 2 * y₁ * x₂ * y₃ + y₁ ^ 3 * x₂ * y₃ - x₁ ^ 3 * y₂ * y₃ + x₁ * y₁ ^ 2 * y₂ * y₃ -
      y₁ * x₂ * x₃ ^ 2 * y₃ - x₁ * y₂ * x₃ ^ 2 * y₃ + x₁ * x₂ * x₃ * y₃ ^ 2 +
      y₁ * y₂ * x₃ * y₃ ^ 2 + y₁ * x₂ * y₃ ^ 3 + x₁ * y₂ * y₃ ^ 3 - x₁ * x₂ * x₃ - y₁ * y₂ * x₃ -
      y₁ * x₂ * y₃ - x₁ * y₂ * y₃) * h2 + (x₁ ^ 2 * y₁ * x₂ ^ 4 * y₂ ^ 3 * x₃ * d ^ 2 +
      x₁ * y₁ ^ 2 * x₂ ^ 3 * y₂ ^ 4 * x₃ * d ^ 2 - x₁ * y₁ ^ 2 * x₂ ^ 4 * y₂ ^ 3 * y₃ * d ^ 2 -
      x₁ ^ 2 * y₁ * x₂ ^ 3 * y₂ ^ 4 * y₃ * d ^ 2 + x₁ ^ 2 * y₁ * x₂ ^ 4 * y₂ * x₃ * d +
      x₁ ^ 3 * x₂ ^ 3 * y₂ ^ 2 * x₃ * d - y₁ ^ 3 * x₂ ^ 2 * y₂ ^ 3 * x₃ * d -
      x₁ * y₁ ^ 2 * x₂ * y₂ ^ 4 * x₃ * d - x₁ * y₁ ^ 2 * x₂ ^ 4 * y₂ * y₃ * d -
      y₁ ^ 3 * x₂ ^ 3 * y₂ ^ 2 * y₃ * d + x₁ ^ 3 * x₂ ^ 2 * y₂ ^ 3 * y₃ * d +
      x₁ ^ 2 * y₁ * x₂ * y₂ ^ 4 * y₃ * d + x₁ * x₂ ^ 3 * y₂ ^ 2 * x₃ * d +
      y₁ * x₂ ^ 2 * y₂ ^ 3 * x₃ * d + y₁ * x₂ ^ 3 * y₂ ^ 2 * y₃ * d +
      x₁ * x₂ ^ 2 * y₂ ^ 3 * y₃ * d) * h3
  · rw [eq_div_of_mul_eq l₄ l₃, eq_div_of_mul_eq r₄ r₃, div_eq_div_iff l₄ r₄]
    linear_combination (y₁ * x₂ ^ 2 * y₂ * x₃ ^ 2 * y₃ * d - x₁ * x₂ * y₂ ^ 2 * x₃ ^ 2 * y₃ * d -
      x₁ * x₂ ^ 2 * y₂ * x₃ * y₃ ^ 2 * d + y₁ * x₂ * y₂ ^ 2 * x₃ * y₃ ^ 2 * d +
      y₁ * x₂ ^ 3 * x₃ ^ 3 + x₁ * x₂ ^ 2 * y₂ * x₃ ^ 3 - y₁ * x₂ * y₂ ^ 2 * x₃ ^ 3 -
      x₁ * y₂ ^ 3 * x₃ ^ 3 + x₁ * x₂ ^ 3 * x₃ ^ 2 * y₃ + y₁ * x₂ ^ 2 * y₂ * x₃ ^ 2 * y₃ -
      x₁ * x₂ * y₂ ^ 2 * x₃ ^ 2 * y₃ - y₁ * y₂ ^ 3 * x₃ ^ 2 * y₃ - y₁ * x₂ ^ 3 * x₃ * y₃ ^ 2 -
      x₁ * x₂ ^ 2 * y₂ * x₃ * y₃ ^ 2 + y₁ * x₂ * y₂ ^ 2 * x₃ * y₃ ^ 2 + x₁ * y₂ ^ 3 * x₃ * y₃ ^ 2 -
      x₁ * x₂ ^ 3 * y₃ ^ 3 - y₁ * x₂ ^ 2 * y₂ * y₃ ^ 3 + x₁ * x₂ * y₂ ^ 2 * y₃ ^ 3 +
      y₁ * y₂ ^ 3 * y₃ ^ 3 + y₁ * x₂ ^ 3 * x₃ + x₁ * x₂ ^ 2 * y₂ * x₃ - y₁ * x₂ * y₂ ^ 2 * x₃ -
      x₁ * y₂ ^ 3 * x₃ + y₁ * x₂ * x₃ ^ 3 + x₁ * y₂ * x₃ ^ 3 + x₁ * x₂ ^ 3 * y₃ +
      y₁ * x₂ ^ 2 * y₂ * y₃ - x₁ * x₂ * y₂ ^ 2 * y₃ - y₁ * y₂ ^ 3 * y₃ + x₁ * x₂ * x₃ ^ 2 * y₃ +
      y₁ * y₂ * x₃ ^ 2 * y₃ - y₁ * x₂ * x₃ * y₃ ^ 2 - x₁ * y₂ * x₃ * y₃ ^ 2 - x₁ * x₂ * y₃ ^ 3 -
      y₁ * y₂ * y₃ ^ 3 + y₁ * x₂ * x₃ + x₁ * y₂ * x₃ + x₁ * x₂ * y₃ + y₁ * y₂ * y₃) * h1 +
      (-x₁ ^ 2 * y₁ ^ 3 * x₂ ^ 2 * y₂ * x₃ ^ 2 * y₃ * d ^ 2 +
      x₁ ^ 3 * y₁ ^ 2 * x₂ * y₂ ^ 2 * x₃ ^ 2 * y₃ * d ^ 2 +
      x₁ ^ 3 * y₁ ^ 2 * x₂ ^ 2 * y₂ * x₃ * y₃ ^ 2 * d ^ 2 -
      x₁ ^ 2 * y₁ ^ 3 * x₂ * y₂ ^ 2 * x₃ * y₃ ^ 2 * d ^ 2 - x₁ ^ 2 * y₁ ^ 3 * x₂ * x₃ ^ 3 * d -
      x₁ ^ 3 * y₁ ^ 2 * y₂ * x₃ ^ 3 * d + x₁ * y₁ ^ 2 * x₂ ^ 2 * y₂ * x₃ ^ 3 * d +
      x₁ ^ 2 * y₁ * x₂ * y₂ ^ 2 * x₃ ^ 3 * d - x₁ ^ 3 * y₁ ^ 2 * x₂ * x₃ ^ 2 * y₃ * d -
      x₁ ^ 2 * y₁ ^ 3 * y₂ * x₃ ^ 2 * y₃ * d - x₁ ^ 2 * y₁ * x₂ ^ 2 * y₂ * x₃ ^ 2 * y₃ * d -
      x₁ * y₁ ^ 2 * x₂ * y₂ ^ 2 * x₃ ^ 2 * y₃ * d + x₁ ^ 2 * y₁ ^ 3 * x₂ * x₃ * y₃ ^ 2 * d +
      x₁ ^ 3 * y₁ ^ 2 * y₂ * x₃ * y₃ ^ 2 * d - x₁ * y₁ ^ 2 * x₂ ^ 2 * y₂ * x₃ * y₃ ^ 2 * d -
      x₁ ^ 2 * y₁ * x₂ * y₂ ^ 2 * x₃ * y₃ ^ 2 * d + x₁ ^ 3 * y₁ ^ 2 * x₂ * y₃ ^ 3 * d +
      x₁ ^ 2 * y₁ ^ 3 * y₂ * y₃ ^ 3 * d + x₁ ^ 2 * y₁ * x₂ ^ 2 * y₂ * y₃ ^ 3 * d +
      x₁ * y₁ ^ 2 * x₂ * y₂ ^ 2 * y₃ ^ 3 * d - x₁ ^ 2 * y₁ ^ 3 * x₂ * x₃ * d -
      x₁ ^ 3 * y₁ ^ 2 * y₂ * x₃ * d + x₁ * y₁ ^ 2 * x₂ ^ 2 * y₂ * x₃ * d +
      x₁ ^ 2 * y₁ * x₂ * y₂ ^ 2 * x₃ * d - x₁ ^ 3 * y₁ ^ 2 * x₂ * y₃ * d -
      x₁ ^ 2 * y₁ ^ 3 * y₂ * y₃ * d - x₁ ^ 2 * y₁ * x₂ ^ 2 * y₂ * y₃ * d -
      x₁ * y₁ ^ 2 * x₂ * y₂ ^ 2 * y₃ * d - x₁ ^ 2 * y₁ * x₂ * x₃ ^ 3 + y₁ ^ 3 * x₂ * x₃ ^ 3 -
      x₁ ^ 3 * y₂ * x₃ ^ 3 + x₁ * y₁ ^ 2 * y₂ * x₃ ^ 3 - x₁ ^ 3 * x₂ * x₃ ^ 2 * y₃ +
      x₁ * y₁ ^ 2 * x₂ * x₃ ^ 2 * y₃ - x₁ ^ 2 * y₁ * y₂ * x₃ ^ 2 * y₃ + y₁ ^ 3 * y₂ * x₃ ^ 2 * y₃ +
      x₁ ^ 2 * y₁ * x₂ * x₃ * y₃ ^ 2 - y₁ ^ 3 * x₂ * x₃ * y₃ ^ 2 + x₁ ^ 3 * y₂ * x₃ * y₃ ^ 2 -
      x₁ * y₁ ^ 2 * y₂ * x₃ * y₃ ^ 2 + x₁ ^ 3 * x₂ * y₃ ^ 3 - x₁ * y₁ ^ 2 * x₂ * y₃ ^ 3 +
      x₁ ^ 2 * y₁ * y₂ * y₃ ^ 3 - y₁ ^ 3 * y₂ * y₃ ^ 3 - x₁ ^ 2 * y₁ * x₂ * x₃ + y₁ ^ 3 * x₂ * x₃ -
      x₁ ^ 3 * y₂ * x₃ + x₁ * y₁ ^ 2 * y₂ * x₃ - y₁ * x₂ * x₃ ^ 3 - x₁ * y₂ * x₃ ^ 3 -
      x₁ ^ 3 * x₂ * y₃ + x₁ * y₁ ^ 2 * x₂ * y₃ - x₁ ^ 2 * y₁ * y₂ * y₃ + y₁ ^ 3 * y₂ * y₃ -
      x₁ * x₂ * x₃ ^ 2 * y₃ - y₁ * y₂ * x₃ ^ 2 * y₃ + y₁ * x₂ * x₃ * y₃ ^ 2 +
      x₁ * y₂ * x₃ * y₃ ^ 2 + x₁ * x₂ * y₃ ^ 3 + y₁ * y₂ * y₃ ^ 3 - y₁ * x₂ * x₃ - x₁ * y₂ * x₃ -
      x₁ * x₂ * y₃ - y₁ * y₂ * y₃) * h2 + (-x₁ * y₁ ^ 2 * x₂ ^ 4 * y₂ ^ 3 * x₃ * d ^ 2 -
      x₁ ^ 2 * y₁ * x₂ ^ 3 * y₂ ^ 4 * x₃ * d ^ 2 + x₁ ^ 2 * y₁ * x₂ ^ 4 * y₂ ^ 3 * y₃ * d ^ 2 +
      x₁ * y₁ ^ 2 * x₂ ^ 3 * y₂ ^ 4 * y₃ * d ^ 2 - x₁ * y₁ ^ 2 * x₂ ^ 4 * y₂ * x₃ * d -
      y₁ ^ 3 * x₂ ^ 3 * y₂ ^ 2 * x₃ * d + x₁ ^ 3 * x₂ ^ 2 * y₂ ^ 3 * x₃ * d +
      x₁ ^ 2 * y₁ * x₂ * y₂ ^ 4 * x₃ * d + x₁ ^ 2 * y₁ * x₂ ^ 4 * y₂ * y₃ * d +
      x₁ ^ 3 * x₂ ^ 3 * y₂ ^ 2 * y₃ * d - y₁ ^ 3 * x₂ ^ 2 * y₂ ^ 3 * y₃ * d -
      x₁ * y₁ ^ 2 * x₂ * y₂ ^ 4 * y₃ * d + y₁ * x₂ ^ 3 * y₂ ^ 2 * x₃ * d +
      x₁ * x₂ ^ 2 * y₂ ^ 3 * x₃ * d + x₁ * x₂ ^ 3 * y₂ ^ 2 * y₃ * d +
      y₁ * x₂ ^ 2 * y₂ ^ 3 * y₃ * d) * h3

end Assoc

/-! ## The group -/

namespace Point

public section

instance : Zero Point := ⟨⟨0, 1, by unfold OnCurve; ring⟩⟩

instance : Neg Point := ⟨fun P => ⟨-P.x, P.y, onCurve_neg P.on⟩⟩

instance : Add Point := ⟨fun P Q => ⟨_, _, add_onCurve P.on Q.on⟩⟩

end

/-! The coordinates of `0`, `-P`, `P + Q` and `P - Q`. -/

@[simp] public theorem zero_x : (0 : Point).x = 0 := rfl
@[simp] public theorem zero_y : (0 : Point).y = 1 := rfl
@[simp] public theorem neg_x (P : Point) : (-P).x = -P.x := rfl
@[simp] public theorem neg_y (P : Point) : (-P).y = P.y := rfl
public theorem add_x (P Q : Point) : (P + Q).x = (add P.x P.y Q.x Q.y).1 := rfl
public theorem add_y (P Q : Point) : (P + Q).y = (add P.x P.y Q.x Q.y).2 := rfl

/-- The points form an abelian group. -/
public instance : AddCommGroup Point where
  add_assoc P Q R := by
    have h := add_add P.on Q.on R.on
    exact Point.ext (congrArg Prod.fst h) (congrArg Prod.snd h)
  zero_add P := by
    ext <;> simp [add_x, add_y, add]
  add_zero P := by
    ext <;> simp [add_x, add_y, add]
  neg_add_cancel P := by
    have h := P.on
    have d₂ := add_den₂ (onCurve_neg h) h
    unfold OnCurve at h
    ext
    · simp only [add_x, add, neg_x, neg_y, zero_x, div_eq_zero_iff]
      exact .inl (by ring)
    · simp only [add_y, add, neg_x, neg_y, zero_y]
      rw [div_eq_one_iff_eq d₂]
      linear_combination h
  add_comm P Q := by
    have h := add_symm P.x P.y Q.x Q.y
    exact Point.ext (congrArg Prod.fst h) (congrArg Prod.snd h)
  nsmul := nsmulRec
  zsmul := zsmulRec

/-! `P - Q` is `P + (-Q)`. -/

public theorem sub_x (P Q : Point) : (P - Q).x = (add P.x P.y (-Q.x) Q.y).1 := rfl
public theorem sub_y (P Q : Point) : (P - Q).y = (add P.x P.y (-Q.x) Q.y).2 := rfl

end Point

/-! ## Doubling and small order -/

/-- On the curve, doubling is the sum with itself. -/
public theorem dbl_eq_add {x y : ZMod p} (h : OnCurve x y) : dbl x y = add x y x y := by
  unfold OnCurve at h
  have e₁ : 1 + d * x * x * y * y = y ^ 2 - x ^ 2 := by linear_combination -h
  have e₂ : 1 - d * x * x * y * y = 2 - y ^ 2 + x ^ 2 := by linear_combination h
  simp only [dbl, add, e₁, e₂]
  congr 1 <;> ring

namespace Point

/-- `dbl` is `P + P`. -/
public theorem dbl_eq (P : Point) : dbl P.x P.y = ((P + P).x, (P + P).y) :=
  dbl_eq_add P.on

/-- `dblN n` is `2ⁿ P`. -/
public theorem dblN_eq (n : ℕ) (P : Point) :
    dblN n (P.x, P.y) = ((2 ^ n • P).x, (2 ^ n • P).y) := by
  induction n generalizing P with
  | zero => rw [pow_zero, one_smul, dblN]
  | succ n ih => rw [dblN, dbl_eq, ih, pow_succ, mul_smul, two_smul]

/-- Small order is `8 P = 0`. -/
public theorem smallOrder_iff_nsmul (P : Point) : SmallOrder P.x P.y ↔ 8 • P = 0 := by
  rw [SmallOrder, dblN_eq, Point.ext_iff, Prod.ext_iff]
  norm_num

end Point

end Ed25519
