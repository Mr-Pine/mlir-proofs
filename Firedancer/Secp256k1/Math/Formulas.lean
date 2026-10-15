module

public import Mathlib.AlgebraicGeometry.EllipticCurve.Affine.Point
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.LinearCombination

/-! The complete formulas of `Point.lean` over a field: `add`, `dbl` and `neg` compute the group law
of `y² = x³ + 7` on projective representatives, whenever the curve has no `2`-torsion. -/

namespace Firedancer.Secp256k1.Formulas

open WeierstrassCurve WeierstrassCurve.Affine
variable {F : Type*} [Field F]

/-! ## Definitions -/

@[expose] public section

variable (F) in
/-- The curve `y² = x³ + 7`. -/
def curve : WeierstrassCurve F :=
  ⟨0, 0, 0, 0, 7⟩

/-- Projective coordinates `(X : Y : Z)`, as `fd_secp256k1_point_t`. -/
@[ext]
structure Proj (F : Type*) where
  x : F
  y : F
  z : F

/-- `fd_secp256k1_point_add.spec` over `F`. -/
def add (a b : Proj F) : Proj F :=
  let t0 := a.x * b.x
  let t1 := a.y * b.y
  let t2 := a.z * b.z
  let t3 := a.x + a.y
  let t4 := b.x + b.y
  let t3 := t3 * t4
  let t4 := t0 + t1
  let t3 := t3 - t4
  let t4 := a.y + a.z
  let X3 := b.y + b.z
  let t4 := t4 * X3
  let X3 := t1 + t2
  let t4 := t4 - X3
  let X3 := a.x + a.z
  let Y3 := b.x + b.z
  let X3 := X3 * Y3
  let Y3 := t0 + t2
  let Y3 := X3 - Y3
  let t0 := 3 * t0
  let t2_4 := 2 * t2
  let t2_4 := 2 * t2_4
  let t5 := 2 * t2_4
  let t5 := 2 * t5
  let t5 := t5 + t2_4
  let t2 := t5 + t2
  let Z3 := t1 + t2
  let t1 := t1 - t2
  let Y3_4 := 2 * Y3
  let Y3_4 := 2 * Y3_4
  let t5 := 2 * Y3_4
  let t5 := 2 * t5
  let t5 := t5 + Y3_4
  let Y3 := t5 + Y3
  let X3 := t4 * Y3
  let t2 := t3 * t1
  let r_x := t2 - X3
  let Y3 := Y3 * t0
  let t1 := t1 * Z3
  let r_y := t1 + Y3
  let t0 := t0 * t3
  let Z3 := Z3 * t4
  let r_z := Z3 + t0
  ⟨r_x, r_y, r_z⟩

/-- `fd_secp256k1_point_dbl.spec` over `F`. -/
def dbl (a : Proj F) : Proj F :=
  let t0 := a.y ^ 2
  let Z3 := 2 * t0
  let Z3 := 2 * Z3
  let Z3 := 2 * Z3
  let t1 := a.y * a.z
  let t2 := a.z ^ 2
  let t2_4 := 2 * t2
  let t2_4 := 2 * t2_4
  let t5 := 2 * t2_4
  let t5 := 2 * t5
  let t5 := t5 + t2_4
  let t2 := t5 + t2
  let X3 := t2 * Z3
  let Y3 := t0 + t2
  let r_z := t1 * Z3
  let t1 := 2 * t2
  let t2 := t1 + t2
  let t0 := t0 - t2
  let Y3 := t0 * Y3
  let t1 := a.x * a.y
  let r_y := X3 + Y3
  let X3 := t0 * t1
  let r_x := 2 * X3
  ⟨r_x, r_y, r_z⟩

/-- `fd_secp256k1_point_neg.spec` over `F`. -/
def neg (a : Proj F) : Proj F :=
  let r_x := a.x
  let r_z := a.z
  let r_y := -a.y
  ⟨r_x, r_y, r_z⟩

/-- `P` represents `p`: `(0 : Y : 0)` with `Y ≠ 0` for zero, `(xZ : yZ : Z)` with `Z ≠ 0` for
`(x, y)`. -/
def Rep (P : Proj F) : (curve F).toAffine.Point → Prop
  | .zero => P.x = 0 ∧ P.y ≠ 0 ∧ P.z = 0
  | .some x y _ => P.z ≠ 0 ∧ P.x = x * P.z ∧ P.y = y * P.z

/-! ## Closed forms -/

/-- `P` scaled by `c`. -/
def scale (c : F) (P : Proj F) : Proj F :=
  ⟨c * P.x, c * P.y, c * P.z⟩

/-- `add` as polynomials (eprint 2015/1060, Algorithm 7 with `b₃ = 21`). -/
theorem add_eq (a b : Proj F) :
    add a b =
      ⟨(a.x * b.y + b.x * a.y) * (a.y * b.y - 21 * a.z * b.z) -
          21 * (a.y * b.z + b.y * a.z) * (a.x * b.z + b.x * a.z),
        (a.y * b.y + 21 * a.z * b.z) * (a.y * b.y - 21 * a.z * b.z) +
          63 * a.x * b.x * (a.x * b.z + b.x * a.z),
        (a.y * b.z + b.y * a.z) * (a.y * b.y + 21 * a.z * b.z) +
          3 * a.x * b.x * (a.x * b.y + b.x * a.y)⟩ := by
  ext <;> simp only [add] <;> ring

/-- `add` is homogeneous of degree `(2, 2)`. -/
theorem add_scale (c d : F) (a b : Proj F) :
    add (scale c a) (scale d b) = scale (c ^ 2 * d ^ 2) (add a b) := by
  simp only [add_eq, scale]; ext <;> ring

/-- On the projective curve, `dbl` agrees with `add` of a point to itself. -/
theorem dbl_eq_add {a : Proj F} (h : a.y ^ 2 * a.z = a.x ^ 3 + 7 * a.z ^ 3) : dbl a = add a a := by
  rw [add_eq]
  ext <;> simp only [dbl]
  · ring
  · linear_combination 126 * a.z * h
  · linear_combination 6 * a.y * h

/-! ## Representatives -/

/-- An affine point's coordinates satisfy `y² = x³ + 7`. -/
theorem eqn {x y : F} (h : (curve F).toAffine.Nonsingular x y) : y ^ 2 = x ^ 3 + 7 := by
  have := (equation_iff x y).mp h.1
  simpa [curve] using this

/-- Without `2`-torsion, a curve point has `y ≠ 0`. -/
theorem y_ne_zero (h7 : ∀ x : F, x ^ 3 + 7 ≠ 0) {x y : F} (h : y ^ 2 = x ^ 3 + 7) : y ≠ 0 := by
  rintro rfl
  exact
    h7 x
      (by
        rw [← h]; ring)

/-- Without `2`-torsion, `2 ≠ 0` (else `1³ + 7 = 0`). -/
theorem two_ne_zero_of (h7 : ∀ x : F, x ^ 3 + 7 ≠ 0) : (2 : F) ≠ 0 := by
  intro h2
  exact h7 1 (by linear_combination 4 * h2)

/-- A representative of an affine point is a multiple of `(x : y : 1)`. -/
theorem Rep.eq_scale {P : Proj F} {x y : F} {h : (curve F).toAffine.Nonsingular x y}
    (hP : Rep P (.some x y h)) : P = scale P.z ⟨x, y, 1⟩ := by
  obtain ⟨-, hx, hy⟩ := hP
  ext <;> simp [scale, hx, hy, mul_comm]

/-- Nonzero multiples of a representative represent the same point. -/
theorem Rep.scale {c : F} (hc : c ≠ 0) {P : Proj F} {p : (curve F).toAffine.Point} (hP : Rep P p) :
    Rep (scale c P) p := by
  cases p with
  | zero =>
    obtain ⟨hx, hy, hz⟩ := hP
    exact
      ⟨by simp [Formulas.scale, hx], by simp [Formulas.scale, hc, hy], by simp [Formulas.scale, hz]⟩
  | some x y _ =>
    obtain ⟨hz, hx, hy⟩ := hP
    refine ⟨mul_ne_zero hc hz, ?_, ?_⟩ <;> simp only [Formulas.scale, hx, hy] <;> ring

/-- A representative has `Y ≠ 0`. -/
theorem Rep.y_ne_zero (h7 : ∀ x : F, x ^ 3 + 7 ≠ 0) {P : Proj F} {p : (curve F).toAffine.Point}
    (hP : Rep P p) : P.y ≠ 0 := by
  cases p with
  | zero => exact hP.2.1
  | some x y h =>
    rw [hP.2.2]
    exact mul_ne_zero (Formulas.y_ne_zero h7 (eqn h)) hP.1

/-- A representative lies on the projective curve `Y²Z = X³ + 7Z³`. -/
theorem Rep.onCurve {P : Proj F} {p : (curve F).toAffine.Point} (hP : Rep P p) :
    P.y ^ 2 * P.z = P.x ^ 3 + 7 * P.z ^ 3 := by
  cases p with
  | zero => simp [hP.1, hP.2.2]
  | some x y h =>
    rw [hP.2.1, hP.2.2]
    linear_combination P.z ^ 3 * eqn h

/-- A triple represents at most one point. -/
theorem Rep.unique {P : Proj F} {p q : (curve F).toAffine.Point} (hp : Rep P p) (hq : Rep P q) :
    p = q := by
  cases p with
  | zero =>
    cases q with
    | zero => rfl
    | some => exact absurd hp.2.2 hq.1
  | some x y _ =>
    cases q with
    | zero => exact absurd hq.2.2 hp.1
    | some x' y' _ =>
      have hx : x = x' := mul_right_cancel₀ hp.1 (hp.2.1.symm.trans hq.2.1)
      have hy : y = y' := mul_right_cancel₀ hp.1 (hp.2.2.symm.trans hq.2.2)
      subst hx hy
      rfl

/-- A representative has `Z = 0` exactly for the zero point. -/
theorem Rep.z_eq_zero_iff {P : Proj F} {p : (curve F).toAffine.Point} (hP : Rep P p) :
    P.z = 0 ↔ p = 0 := by
  cases p with
  | zero => exact ⟨fun _ => rfl, fun _ => hP.2.2⟩
  | some => exact ⟨fun h => absurd h hP.1, fun h => absurd h (Point.some_ne_zero _)⟩

/-- The valid representatives: `(0 : Y : 0)` with `Y ≠ 0`, and `Z ≠ 0` on `Y²Z = X³ + 7Z³`. -/
theorem exists_rep_iff (h7 : ∀ x : F, x ^ 3 + 7 ≠ 0) (P : Proj F) :
    (∃ p, Rep P p) ↔
      (P.x = 0 ∧ P.y ≠ 0 ∧ P.z = 0) ∨ (P.z ≠ 0 ∧ P.y ^ 2 * P.z = P.x ^ 3 + 7 * P.z ^ 3) := by
  constructor
  · rintro ⟨p, hP⟩
    cases p with
    | zero => exact .inl hP
    | some => exact .inr ⟨hP.1, hP.onCurve⟩
  · rintro (h | ⟨hz, h⟩)
    · exact ⟨0, h⟩
    have e : (P.y / P.z) ^ 2 = (P.x / P.z) ^ 3 + 7 := by
      field_simp
      linear_combination h
    have hns : (curve F).toAffine.Nonsingular (P.x / P.z) (P.y / P.z) := by
      refine ⟨(equation_iff _ _).mpr (by simpa [curve] using e), ?_⟩
      right
      rw [evalEval_polynomialY]
      have := mul_ne_zero (two_ne_zero_of h7) (Formulas.y_ne_zero h7 e)
      simpa [curve] using this
    exact ⟨.some _ _ hns, hz, by field_simp, by field_simp⟩

/-- `neg` on a representative of `p` gives a representative of `-p`. -/
theorem rep_neg {P : Proj F} {p : (curve F).toAffine.Point} (hP : Rep P p) : Rep (neg P) (-p) := by
  cases p with
  | zero => exact ⟨hP.1, neg_ne_zero.mpr hP.2.1, hP.2.2⟩
  | some x y h =>
    rw [Point.neg_some]
    refine ⟨hP.1, hP.2.1, ?_⟩
    simp only [neg, negY, curve, hP.2.2]
    ring

/-- If `7` is not a square, a representative with `X = 0` is the zero point. -/
theorem Rep.eq_zero_of_x_eq_zero (h7 : ∀ y : F, y ^ 2 ≠ 7) {P : Proj F}
    {p : (curve F).toAffine.Point} (hP : Rep P p) (hx : P.x = 0) : p = 0 := by
  cases p with
  | zero => rfl
  | some x y h =>
    have : x = 0 := by simpa [hP.1] using hx.symm.trans hP.2.1
    exact absurd (by simpa [this] using eqn h) (h7 y)

/-- `fd_secp256k1_point_is_identity`'s criterion holds exactly for the zero point, if `7` is not a
square. -/
theorem Rep.isIdentity_iff (h7 : ∀ y : F, y ^ 2 ≠ 7) {P : Proj F} {p : (curve F).toAffine.Point}
    (hP : Rep P p) : (P.z = 0 ∨ P.x = 0 ∧ (P.y = 0 ∨ P.y = 1)) ↔ p = 0 := by
  refine ⟨?_, fun h => .inl (hP.z_eq_zero_iff.mpr h)⟩
  rintro (h | ⟨h, -⟩)
  · exact hP.z_eq_zero_iff.mp h
  · exact hP.eq_zero_of_x_eq_zero h7 h

/-! ## The group law -/

variable [DecidableEq F]

/-- `add` on `(x₁ : y₁ : 1)` and `(x₂ : y₂ : 1)` represents their sum. -/
theorem rep_add_affine (h7 : ∀ x : F, x ^ 3 + 7 ≠ 0) {x₁ y₁ x₂ y₂ : F}
    (h₁ : (curve F).toAffine.Nonsingular x₁ y₁) (h₂ : (curve F).toAffine.Nonsingular x₂ y₂) :
    Rep (add ⟨x₁, y₁, 1⟩ ⟨x₂, y₂, 1⟩) (.some x₁ y₁ h₁ + .some x₂ y₂ h₂) := by
  have e₁ := eqn h₁
  have e₂ := eqn h₂
  have h2 := two_ne_zero_of h7
  rw [add_eq]
  by_cases hx : x₁ = x₂
  · subst x₂
    by_cases hy : y₁ = (curve F).toAffine.negY x₁ y₂
    · rw [Point.add_of_Y_eq rfl hy]
      have hy' : y₂ = -y₁ := by
        simp only [negY, curve] at hy
        linear_combination hy
      subst y₂
      refine ⟨by ring, ?_, by ring⟩
      intro hY
      have hy0 := Formulas.y_ne_zero h7 e₁
      have hT : x₁ ^ 3 * (x₁ ^ 3 - 56) ^ 3 + 448 * y₁ ^ 6 = 0 := by
        linear_combination
          (x₁ ^ 6 + 140 * x₁ ^ 3 - 392) * hY +
            (-x₁ ^ 9 - x₁ ^ 6 * y₁ ^ 2 + 301 * x₁ ^ 6 + 308 * x₁ ^ 3 * y₁ ^ 2 + 448 * y₁ ^ 4 +
                5684 * x₁ ^ 3 +
                3528 * y₁ ^ 2 +
                24696) *
              e₁
      apply h7 (x₁ * (x₁ ^ 3 - 56) / (2 * y₁) ^ 2)
      field_simp
      linear_combination hT
    · have hy₂ : y₁ = y₂ := Y_eq_of_Y_ne h₁.1 h₂.1 rfl hy
      subst y₂
      rw [Point.add_of_Y_ne hy]
      have hy1 := Formulas.y_ne_zero h7 e₁
      have hy0 : 2 * y₁ ≠ 0 := mul_ne_zero h2 hy1
      have hℓ : (curve F).toAffine.slope x₁ x₁ y₁ y₁ = 3 * x₁ ^ 2 / (2 * y₁) := by
        rw [slope_of_Y_ne rfl hy]
        simp only [negY, curve]
        ring
      refine ⟨?_, ?_, ?_⟩
      · intro hz
        apply pow_ne_zero 3 hy0
        linear_combination hz + 6 * y₁ * e₁
      · have :
          (curve F).toAffine.addX x₁ x₁ (3 * x₁ ^ 2 / (2 * y₁)) =
            (9 * x₁ ^ 4 - 8 * x₁ * y₁ ^ 2) / (2 * y₁) ^ 2 := by
          simp only [addX, curve]
          field_simp
          ring
        rw [hℓ, this, div_mul_eq_mul_div, eq_div_iff (pow_ne_zero 2 hy0)]
        linear_combination (54 * x₁ ^ 4 * y₁ + 24 * x₁ * y₁ ^ 3) * e₁
      · have :
          (curve F).toAffine.addY x₁ x₁ y₁ (3 * x₁ ^ 2 / (2 * y₁)) =
            -(3 * x₁ ^ 2 * (9 * x₁ ^ 4 - 12 * x₁ * y₁ ^ 2) + 8 * y₁ ^ 4) / (2 * y₁) ^ 3 := by
          simp only [addY, negAddY, addX, negY, curve]
          field_simp
          ring
        rw [hℓ, this, div_mul_eq_mul_div, eq_div_iff (pow_ne_zero 3 hy0)]
        linear_combination (-162 * x₁ ^ 6 * y₁ + 24 * y₁ ^ 5 + 504 * y₁ ^ 3) * e₁
  · have hd : x₁ - x₂ ≠ 0 := sub_ne_zero.mpr hx
    rw [Point.add_of_X_ne hx]
    refine ⟨?_, ?_, ?_⟩
    · intro hz
      have hYp :
        -((y₁ + y₂) * ((y₁ + y₂) ^ 2 - (x₁ + x₂) * (x₁ - x₂) ^ 2 - x₁ * (x₁ - x₂) ^ 2) +
              y₁ * (x₁ - x₂) ^ 3) =
          0 := by
        linear_combination (-y₁ - 2 * y₂) * e₁ + (-2 * y₁ - y₂) * e₂ - hz
      have hxp : ((y₁ + y₂) ^ 2 - (x₁ + x₂) * (x₁ - x₂) ^ 2) ^ 3 + 7 * (x₁ - x₂) ^ 6 = 0 := by
        linear_combination
          -((y₁ + y₂) * ((y₁ + y₂) ^ 2 - (x₁ + x₂) * (x₁ - x₂) ^ 2 - x₁ * (x₁ - x₂) ^ 2) +
                  y₁ * (x₁ - x₂) ^ 3) *
              hYp -
            (-x₁ ^ 6 + 3 * x₁ ^ 5 * x₂ + x₁ ^ 3 * y₁ ^ 2 - 3 * x₁ ^ 2 * y₁ ^ 2 * x₂ +
                                    3 * x₁ * y₁ ^ 2 * x₂ ^ 2 +
                                    2 * x₁ ^ 3 * y₁ * y₂ -
                                  6 * x₁ ^ 2 * y₁ * x₂ * y₂ +
                                6 * x₁ * y₁ * x₂ ^ 2 * y₂ -
                              9 * x₁ ^ 3 * y₂ ^ 2 +
                            12 * x₁ ^ 2 * x₂ * y₂ ^ 2 -
                          6 * x₁ * x₂ ^ 2 * y₂ ^ 2 -
                          y₁ ^ 2 * y₂ ^ 2 -
                          2 * y₁ * y₂ ^ 3 +
                        y₂ ^ 4 +
                        70 * x₁ ^ 3 -
                      105 * x₁ ^ 2 * x₂ +
                    63 * x₁ * x₂ ^ 2 +
                    7 * y₁ ^ 2 +
                    14 * y₁ * y₂ -
                  21 * y₂ ^ 2 +
                98) *
              e₁ -
            (-8 * x₁ ^ 6 + 6 * x₁ ^ 5 * x₂ + 6 * x₁ ^ 4 * x₂ ^ 2 - 8 * x₁ ^ 3 * x₂ ^ 3 +
                                                  3 * x₁ * x₂ ^ 5 -
                                                x₂ ^ 6 +
                                              8 * x₁ ^ 3 * y₁ ^ 2 -
                                            12 * x₁ ^ 2 * y₁ ^ 2 * x₂ +
                                          6 * x₁ * y₁ ^ 2 * x₂ ^ 2 -
                                        y₁ ^ 2 * x₂ ^ 3 -
                                        4 * x₁ ^ 3 * y₁ * y₂ +
                                      6 * x₁ ^ 2 * y₁ * x₂ * y₂ -
                                    6 * x₁ * y₁ * x₂ ^ 2 * y₂ +
                                  2 * y₁ * x₂ ^ 3 * y₂ +
                                  3 * x₁ ^ 2 * x₂ * y₂ ^ 2 -
                                3 * x₁ * x₂ ^ 2 * y₂ ^ 2 +
                              x₂ ^ 3 * y₂ ^ 2 +
                              y₁ ^ 4 +
                              2 * y₁ ^ 3 * y₂ -
                            y₁ ^ 2 * y₂ ^ 2 -
                            84 * x₁ ^ 3 +
                          105 * x₁ ^ 2 * x₂ -
                        63 * x₁ * x₂ ^ 2 +
                      14 * x₂ ^ 3 +
                      7 * y₁ ^ 2 -
                    14 * y₁ * y₂ +
                  7 * y₂ ^ 2 -
                98) *
              e₂
      apply h7 (((y₁ + y₂) ^ 2 - (x₁ + x₂) * (x₁ - x₂) ^ 2) / (x₁ - x₂) ^ 2)
      field_simp
      linear_combination hxp
    · have :
        (curve F).toAffine.addX x₁ x₂ ((curve F).toAffine.slope x₁ x₂ y₁ y₂) =
          ((y₁ - y₂) ^ 2 - (x₁ + x₂) * (x₁ - x₂) ^ 2) / (x₁ - x₂) ^ 2 := by
        rw [slope_of_X_ne hx]
        simp only [addX, curve]
        field_simp
        ring
      rw [this, div_mul_eq_mul_div, eq_div_iff (pow_ne_zero 2 hd)]
      linear_combination
        (-3 * x₁ * y₁ * x₂ ^ 2 - 3 * x₁ ^ 2 * x₂ * y₂ + 3 * x₁ * x₂ ^ 2 * y₂ - y₁ ^ 2 * y₂ +
                y₁ * y₂ ^ 2 +
                3 * y₂ ^ 3 -
              21 * y₁) *
            e₁ +
          (3 * x₁ ^ 3 * y₁ + 3 * x₁ ^ 2 * y₁ * x₂ - 3 * x₁ * y₁ * x₂ ^ 2 + 3 * x₁ ^ 3 * y₂ -
                3 * x₁ ^ 2 * x₂ * y₂ -
                2 * y₁ ^ 2 * y₂ -
                y₁ * y₂ ^ 2 +
              21 * y₁) *
            e₂
    · have :
        (curve F).toAffine.addY x₁ x₂ y₁ ((curve F).toAffine.slope x₁ x₂ y₁ y₂) =
          -((y₁ - y₂) * ((y₁ - y₂) ^ 2 - (x₁ + x₂) * (x₁ - x₂) ^ 2 - x₁ * (x₁ - x₂) ^ 2) +
                y₁ * (x₁ - x₂) ^ 3) /
            (x₁ - x₂) ^ 3 := by
        rw [slope_of_X_ne hx]
        simp only [addY, negAddY, addX, negY, curve]
        field_simp
        ring
      rw [this, div_mul_eq_mul_div, eq_div_iff (pow_ne_zero 3 hd)]
      linear_combination
        (3 * x₁ * y₁ ^ 2 * x₂ ^ 2 + 3 * x₁ ^ 2 * y₁ * x₂ * y₂ - 6 * x₁ * y₁ * x₂ ^ 2 * y₂ -
                        6 * x₁ ^ 2 * x₂ * y₂ ^ 2 +
                      9 * x₁ * x₂ ^ 2 * y₂ ^ 2 +
                      y₁ ^ 3 * y₂ -
                    2 * y₁ ^ 2 * y₂ ^ 2 -
                    2 * y₁ * y₂ ^ 3 -
                    63 * x₁ ^ 2 * x₂ +
                  126 * x₁ * x₂ ^ 2 +
                  21 * y₁ ^ 2 -
                21 * y₁ * y₂ -
                42 * y₂ ^ 2 +
              441) *
            e₁ +
          (-9 * x₁ ^ 2 * y₁ ^ 2 * x₂ + 6 * x₁ * y₁ ^ 2 * x₂ ^ 2 + 6 * x₁ ^ 2 * y₁ * x₂ * y₂ -
                      3 * x₁ * y₁ * x₂ ^ 2 * y₂ -
                      3 * x₁ ^ 2 * x₂ * y₂ ^ 2 +
                    2 * y₁ ^ 3 * y₂ +
                    2 * y₁ ^ 2 * y₂ ^ 2 -
                  y₁ * y₂ ^ 3 -
                  126 * x₁ ^ 2 * x₂ +
                63 * x₁ * x₂ ^ 2 +
                42 * y₁ ^ 2 +
                21 * y₁ * y₂ -
              21 * y₂ ^ 2 -
              441) *
            e₂

/-- `add` is complete: on representatives of `p` and `q` it gives a representative of `p + q`. -/
theorem rep_add (h7 : ∀ x : F, x ^ 3 + 7 ≠ 0) {P Q : Proj F} {p q : (curve F).toAffine.Point}
    (hP : Rep P p) (hQ : Rep Q q) : Rep (add P Q) (p + q) := by
  cases p with
  | zero =>
    obtain ⟨hx, hy, hz⟩ := hP
    have : add P Q = scale (P.y ^ 2 * Q.y) Q := by
      rw [add_eq]; ext <;> simp only [scale, hx, hz] <;> ring
    rw [this, ← Point.zero_def, zero_add]
    exact hQ.scale (mul_ne_zero (pow_ne_zero 2 hy) (hQ.y_ne_zero h7))
  | some x₁ y₁ h₁ =>
    cases q with
    | zero =>
      obtain ⟨hx, hy, hz⟩ := hQ
      have : add P Q = scale (P.y * Q.y ^ 2) P := by
        rw [add_eq]; ext <;> simp only [scale, hx, hz] <;> ring
      rw [this, ← Point.zero_def, add_zero]
      exact hP.scale (mul_ne_zero (hP.y_ne_zero h7) (pow_ne_zero 2 hy))
    | some x₂ y₂ h₂ =>
      rw [hP.eq_scale, hQ.eq_scale, add_scale]
      exact (rep_add_affine h7 h₁ h₂).scale (mul_ne_zero (pow_ne_zero 2 hP.1) (pow_ne_zero 2 hQ.1))

/-- `dbl` is complete: on a representative of `p` it gives a representative of `2 • p`. -/
theorem rep_dbl (h7 : ∀ x : F, x ^ 3 + 7 ≠ 0) {P : Proj F} {p : (curve F).toAffine.Point}
    (hP : Rep P p) : Rep (dbl P) (2 • p) := by
  rw [dbl_eq_add hP.onCurve, two_nsmul]
  exact rep_add h7 hP hP

/-- `add`'s output has `Z = 0` exactly when `p + q = 0`. -/
theorem add_z_eq_zero_iff (h7 : ∀ x : F, x ^ 3 + 7 ≠ 0) {P Q : Proj F}
    {p q : (curve F).toAffine.Point} (hP : Rep P p) (hQ : Rep Q q) : (add P Q).z = 0 ↔ p + q = 0 :=
  (rep_add h7 hP hQ).z_eq_zero_iff

/-- `dbl`'s output has `Z = 0` exactly when `2 • p = 0`. -/
theorem dbl_z_eq_zero_iff (h7 : ∀ x : F, x ^ 3 + 7 ≠ 0) {P : Proj F} {p : (curve F).toAffine.Point}
    (hP : Rep P p) : (dbl P).z = 0 ↔ 2 • p = 0 :=
  (rep_dbl h7 hP).z_eq_zero_iff

end

end Firedancer.Secp256k1.Formulas
