module

public import Firedancer.Math.Curve
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

/-! Extended coordinates: the addition, doubling and negation formulas' outputs as `IsExt`, and
`dblN` one doubling at a time. -/

namespace MLIR.Firedancer.Ref.Ed25519

public section

variable {x y : ZMod p}

/-- The addition formula's output is the sum in extended coordinates, for `(A, B, D, C)` its
`(Y₁ - X₁)(Y₂ - X₂)`, `(Y₁ + X₁)(Y₂ + X₂)`, `2 Z₁ Z₂`, `2d T₁ T₂`. -/
theorem isExt_add {x₁ y₁ X₁ Y₁ T₁ Z₁ x₂ y₂ X₂ Y₂ T₂ Z₂ A B C D : ZMod p}
    (hA : IsExt x₁ y₁ X₁ Y₁ T₁ Z₁) (hB : IsExt x₂ y₂ X₂ Y₂ T₂ Z₂)
    (h1 : OnCurve x₁ y₁) (h2 : OnCurve x₂ y₂) (eA : A = (Y₁ - X₁) * (Y₂ - X₂))
    (eB : B = (Y₁ + X₁) * (Y₂ + X₂)) (eC : C = T₁ * T₂ * (2 * d)) (eD : D = (Z₁ + Z₁) * Z₂) :
    let Q := Ref.Ed25519.add x₁ y₁ x₂ y₂
    IsExt Q.1 Q.2 ((B - A) * (D - C)) ((C + D) * (A + B)) ((B - A) * (A + B))
      ((C + D) * (D - C)) := by
  obtain ⟨d₁, d₂, eX, eY⟩ := add_compl hA hB h1 h2
  subst eA eB eC eD
  refine ⟨mul_ne_zero (by rwa [add_comm]) d₂, ?_, ?_, by ring⟩
  · linear_combination ((Z₁ + Z₁) * Z₂ - T₁ * T₂ * (2 * d)) * eX
  · linear_combination (T₁ * T₂ * (2 * d) + (Z₁ + Z₁) * Z₂) * eY

/-- The doubling formula's output is the double in extended coordinates, for `(X, Y, Z)`
projective coordinates of `(x, y)`. -/
theorem isExt_dbl {X Y Z : ZMod p} (hz : Z ≠ 0) (hx : X = x * Z) (hy : Y = y * Z)
    (hc : OnCurve x y) :
    let A := X ^ 2
    let B := Y ^ 2
    let E := A + B - (Y + X) ^ 2
    let G := A - B
    let F := G + (Z ^ 2 + Z ^ 2)
    let H := A + B
    IsExt (Ref.Ed25519.dbl x y).1 (Ref.Ed25519.dbl x y).2 (E * F) (G * H) (E * H) (G * F) := by
  intro A B E G F H
  have d₁ := dbl_den₁ hc
  have d₂ := dbl_den₂ hc
  have eG : G = -(Z ^ 2 * (y ^ 2 - x ^ 2)) := by simp only [G, A, B, hx, hy]; ring
  have eF : F = Z ^ 2 * (2 - y ^ 2 + x ^ 2) := by simp only [F, G, A, B, hx, hy]; ring
  have eE : E = -(2 * x * y * Z ^ 2) := by simp only [E, A, B, hx, hy]; ring
  have eH : H = (y ^ 2 + x ^ 2) * Z ^ 2 := by simp only [H, A, B, hx, hy]; ring
  have hz2 : Z ^ 2 ≠ 0 := pow_ne_zero 2 hz
  refine ⟨?_, ?_, ?_, by ring⟩
  · rw [eG, eF]
    exact mul_ne_zero (neg_ne_zero.2 (mul_ne_zero hz2 d₁)) (mul_ne_zero hz2 d₂)
  · simp only [Ref.Ed25519.dbl, eE, eF, eG]
    field_simp
  · simp only [Ref.Ed25519.dbl, eH, eF, eG]
    field_simp

/-- `IsExt` of `-(x, y) = (-x, y)`. -/
theorem isExt_neg {X Y T Z : ZMod p} (h : IsExt x y X Y T Z) : IsExt (-x) y (-X) Y (-T) Z := by
  obtain ⟨hZ, rfl, rfl, hT⟩ := h
  exact ⟨hZ, by ring, rfl, by linear_combination -hT⟩

/-- `dblN (n + 1)` doubles `dblN n`. -/
theorem dblN_succ' (n : ℕ) (P : ZMod p × ZMod p) :
    Ref.Ed25519.dblN (n + 1) P =
      Ref.Ed25519.dbl (Ref.Ed25519.dblN n P).1 (Ref.Ed25519.dblN n P).2 := by
  induction n generalizing P with
  | zero => rfl
  | succ n ih => rw [Ref.Ed25519.dblN, ih, Ref.Ed25519.dblN]

/-- Doubling `n` times stays on the curve. -/
theorem dblN_onCurve (n : ℕ) {P : ZMod p × ZMod p} (h : OnCurve P.1 P.2) :
    OnCurve (Ref.Ed25519.dblN n P).1 (Ref.Ed25519.dblN n P).2 := by
  induction n with
  | zero => exact h
  | succ n ih => rw [dblN_succ']; exact Ref.Ed25519.dbl_onCurve ih

end

end MLIR.Firedancer.Ref.Ed25519
