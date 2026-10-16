module

public import Mathlib.AlgebraicGeometry.EllipticCurve.Affine.Point
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.LinearCombination

/-! The G1 formulas of `G1.lean` over a field: on Jacobian representatives of `y² = x³ + 3`
(`(X, Y, Z)` for `(X/Z², Y/Z³)`, `Z = 0` for zero), `dbl`, `madd`, the affine sum and
`to_affine` compute the group law under the case splits the C makes. -/

namespace Firedancer.Bn254.Jac

open WeierstrassCurve WeierstrassCurve.Affine
variable {F : Type*} [Field F]

/-! ## Definitions -/

@[expose] public section

variable (F) in
/-- The curve `y² = x³ + 3`. -/
def curve : WeierstrassCurve F :=
  ⟨0, 0, 0, 0, 3⟩

/-- Jacobian coordinates `(X, Y, Z)`, as `fd_bn254_g1_t`. -/
@[ext]
structure Pt (F : Type*) where
  x : F
  y : F
  z : F

/-- `P` represents `p`: `Z = 0` for zero (any `X`, `Y`, as `fd_bn254_g1_is_zero`), else
`(x Z², y Z³, Z)`. -/
def Rep (P : Pt F) : (curve F).toAffine.Point → Prop
  | .zero => P.z = 0
  | .some x y _ => P.z ≠ 0 ∧ P.x = x * P.z ^ 2 ∧ P.y = y * P.z ^ 3

/-- `fd_bn254_g1_dbl.spec` past its zero test (dbl-2009-l). -/
def dbl (p : Pt F) : Pt F :=
  let a := p.x ^ 2
  let b := p.y ^ 2
  let c := b ^ 2
  let d := p.x * b
  let d := d + d
  let d := d + d
  let e := a + a
  let e := a + e
  let f := e ^ 2
  let rX := d + d
  let rX := f - rX
  let rZ := p.y * p.z
  let rZ := rZ + rZ
  let rY := d - rX
  let rY := e * rY
  let c := c + c
  let c := c + c
  let c := c + c
  let rY := rY - c
  ⟨rX, rY, rZ⟩

/-- `fd_bn254_g1_add_mixed.spec`'s `U2` and `S2` for `q = (qx, qy)`. -/
def maddU (p : Pt F) (qx : F) : F :=
  qx * p.z ^ 2

/-- `S2 = qy · Z · Z²`. -/
def maddS (p : Pt F) (qy : F) : F :=
  qy * p.z * p.z ^ 2

/-- `fd_bn254_g1_add_mixed.spec` past its zero and doubling tests (madd-2007-bl). -/
def madd (p : Pt F) (qx qy : F) : Pt F :=
  let zz := p.z ^ 2
  let u2 := qx * zz
  let s2 := qy * p.z
  let s2 := s2 * zz
  let h := u2 - p.x
  let hh := h ^ 2
  let i := hh + hh
  let i := i + i
  let j := h * i
  let rr := s2 - p.y
  let rr := rr + rr
  let v := p.x * i
  let rX := rr ^ 2
  let rX := rX - j
  let rX := rX - v
  let rX := rX - v
  let i := p.y * j
  let i := i + i
  let rY := v - rX
  let rY := rY * rr
  let rY := rY - i
  let rZ := p.z + h
  let rZ := rZ ^ 2
  let rZ := rZ - zz
  let rZ := rZ - hh
  ⟨rX, rY, rZ⟩

/-- `fd_bn254_g1_affine_add.spec`'s doubling slope `(2y)⁻¹ · 3x²`. -/
def dblSlope (x y : F) : F :=
  let a := x ^ 2
  let b := a + a
  let a := a + b
  let b := y + y
  (b)⁻¹ * a

/-- `fd_bn254_g1_affine_add.spec`'s chord slope `(x₁ - x₂)⁻¹ (y₁ - y₂)`. -/
def addSlope (x₁ y₁ x₂ y₂ : F) : F :=
  (x₁ - x₂)⁻¹ * (y₁ - y₂)

/-- The affine sum `fd_bn254_g1_affine_add.spec` forms from the slope `l`. -/
def affSum (x₁ y₁ x₂ l : F) : Pt F :=
  let x := l ^ 2
  let x := x - x₁
  let x := x - x₂
  let y := x₁ - x
  let y := y * l
  let y := y - y₁
  ⟨x, y, 1⟩

/-- `fd_bn254_g1_to_affine.spec` past its zero/one tests. -/
def toAffine (p : Pt F) : Pt F :=
  let iz := p.z⁻¹
  let iz2 := iz ^ 2
  let rX := p.x * iz2
  let rY := p.y * iz2
  let rY := rY * iz
  ⟨rX, rY, 1⟩

end

/-! ## Curve facts -/

/-- An affine point's coordinates satisfy `y² = x³ + 3`. -/
public theorem eqn {x y : F} (h : (curve F).toAffine.Nonsingular x y) : y ^ 2 = x ^ 3 + 3 := by
  have := (equation_iff x y).mp h.1
  simpa [curve] using this

/-- Without `2`-torsion, a curve point has `y ≠ 0`. -/
public theorem y_ne_zero (h3 : ∀ x : F, x ^ 3 + 3 ≠ 0) {x y : F} (h : y ^ 2 = x ^ 3 + 3) :
    y ≠ 0 := by
  rintro rfl
  exact
    h3 x
      (by
        rw [← h]; ring)

/-- Without `2`-torsion, `2 ≠ 0` (else `1³ + 3 = 0`). -/
public theorem two_ne_zero_of (h3 : ∀ x : F, x ^ 3 + 3 ≠ 0) : (2 : F) ≠ 0 := by
  intro h2
  exact h3 1 (by linear_combination 2 * h2)

/-- A pair on `y² = x³ + 3` is nonsingular when `x³ + 3` never vanishes. -/
public theorem nonsingular_of_eqn (h3 : ∀ x : F, x ^ 3 + 3 ≠ 0) {x y : F} (h : y ^ 2 = x ^ 3 + 3) :
    (curve F).toAffine.Nonsingular x y := by
  refine ⟨(equation_iff _ _).mpr (by simpa [curve] using h), ?_⟩
  right
  rw [evalEval_polynomialY]
  have := mul_ne_zero (two_ne_zero_of h3) (y_ne_zero h3 h)
  simpa [curve] using this

public theorem negY_eq (x y : F) : (curve F).toAffine.negY x y = -y := by simp [negY, curve]

/-- Points with equal `x` have equal or opposite `y`. -/
public theorem y_eq_or_neg {x y₁ y₂ : F} (h₁ : y₁ ^ 2 = x ^ 3 + 3) (h₂ : y₂ ^ 2 = x ^ 3 + 3) :
    y₁ = y₂ ∨ y₁ = -y₂ := by
  have : (y₁ - y₂) * (y₁ + y₂) = 0 := by linear_combination h₁ - h₂
  rcases mul_eq_zero.mp this with h | h
  · exact .inl (sub_eq_zero.mp h)
  · exact .inr (eq_neg_of_add_eq_zero_left h)

/-! ## Representatives -/

public theorem Rep.z_eq_zero_iff {P : Pt F} {p : (curve F).toAffine.Point} (hP : Rep P p) :
    P.z = 0 ↔ p = 0 := by
  cases p with
  | zero => exact ⟨fun _ => rfl, fun _ => hP⟩
  | some => exact ⟨fun h => absurd h hP.1, fun h => absurd h (Point.some_ne_zero _)⟩

public theorem Rep.unique {P : Pt F} {p q : (curve F).toAffine.Point} (hp : Rep P p)
    (hq : Rep P q) : p = q := by
  cases p with
  | zero =>
    cases q with
    | zero => rfl
    | some => exact absurd hp hq.1
  | some x y _ =>
    cases q with
    | zero => exact absurd hq hp.1
    | some x' y' _ =>
      have hz2 := pow_ne_zero 2 hp.1
      have hz3 := pow_ne_zero 3 hp.1
      have hx : x = x' := mul_right_cancel₀ hz2 (hp.2.1.symm.trans hq.2.1)
      have hy : y = y' := mul_right_cancel₀ hz3 (hp.2.2.symm.trans hq.2.2)
      subst hx hy
      rfl

/-- An affine triple `(x, y, 1)` represents `some x y`. -/
public theorem rep_affine {x y : F} (h : (curve F).toAffine.Nonsingular x y) :
    Rep ⟨x, y, 1⟩ (.some x y h) :=
  ⟨one_ne_zero, by simp, by simp⟩

public theorem rep_affine_iff {x y x' y' : F} {h : (curve F).toAffine.Nonsingular x' y'} :
    Rep ⟨x, y, 1⟩ (.some x' y' h) ↔ x = x' ∧ y = y' := by simp [Rep]

/-! ## `dbl` -/

variable [DecidableEq F]

/-- `dbl` on a representative of a nonzero `p` represents `2 • p`. -/
public theorem rep_dbl (h3 : ∀ x : F, x ^ 3 + 3 ≠ 0) {P : Pt F} {x y : F}
    {h : (curve F).toAffine.Nonsingular x y} (hP : Rep P (.some x y h)) :
    Rep (dbl P) (2 • .some x y h) := by
  obtain ⟨hz, hx, hy⟩ := hP
  have e := eqn h
  have hy0 := y_ne_zero h3 e
  have h2 := two_ne_zero_of h3
  have hne : y ≠ (curve F).toAffine.negY x y := by
    rw [negY_eq]; intro hc
    exact hy0 ((mul_eq_zero.mp (by linear_combination hc : (2 : F) * y = 0)).resolve_left h2)
  rw [two_nsmul, Point.add_of_Y_ne hne]
  have hl : (curve F).toAffine.slope x x y y = 3 * x ^ 2 / (2 * y) := by
    rw [slope_of_Y_ne rfl hne, negY_eq]; simp only [curve]; ring
  refine ⟨?_, ?_, ?_⟩
  · simp only [dbl, hy]
    have := mul_ne_zero (mul_ne_zero (mul_ne_zero h2 hy0) (pow_ne_zero 3 hz)) hz
    intro hc; apply this; linear_combination hc
  · simp only [addX, hl]
    simp only [dbl, curve, hx, hy]
    field_simp
    ring
  · simp only [addY, negAddY, addX, hl, negY_eq]
    simp only [dbl, curve, hx, hy]
    field_simp
    ring

/-! ## `madd` -/

omit [DecidableEq F] in
/-- `add_mixed`'s doubling test holds exactly when `q = p`. -/
public theorem madd_test_iff {P : Pt F} {x₁ y₁ x₂ y₂ : F}
    {h₁ : (curve F).toAffine.Nonsingular x₁ y₁} (hP : Rep P (.some x₁ y₁ h₁)) :
    (maddU P x₂ = P.x ∧ maddS P y₂ = P.y) ↔ (x₁ = x₂ ∧ y₁ = y₂) := by
  obtain ⟨hz, hx, hy⟩ := hP
  simp only [maddU, maddS, hx, hy]
  have hz2 := pow_ne_zero 2 hz
  have hz3 := pow_ne_zero 3 hz
  constructor
  · rintro ⟨a, b⟩
    exact ⟨(mul_right_cancel₀ hz2 a).symm, (mul_right_cancel₀ hz3 (by linear_combination b)).symm⟩
  · rintro ⟨rfl, rfl⟩; exact ⟨rfl, by ring⟩

/-- `madd` past the doubling test represents `p + q` for nonzero `p` and affine `q`. -/
public theorem rep_madd (h3 : ∀ x : F, x ^ 3 + 3 ≠ 0) {P : Pt F} {x₁ y₁ x₂ y₂ : F}
    {h₁ : (curve F).toAffine.Nonsingular x₁ y₁} {h₂ : (curve F).toAffine.Nonsingular x₂ y₂}
    (hP : Rep P (.some x₁ y₁ h₁)) (hne : ¬(x₁ = x₂ ∧ y₁ = y₂)) :
    Rep (madd P x₂ y₂) (.some x₁ y₁ h₁ + .some x₂ y₂ h₂) := by
  obtain ⟨hz, hx, hy⟩ := hP
  have h2 := two_ne_zero_of h3
  by_cases hxe : x₁ = x₂
  · subst hxe
    have hy' : y₁ = -y₂ := by
      rcases y_eq_or_neg (eqn h₁) (eqn h₂) with h | h
      · exact absurd ⟨rfl, h⟩ hne
      · exact h
    rw [Point.add_of_Y_eq rfl
        (by
          rw [negY_eq]; exact hy')]
    show (madd P x₁ y₂).z = 0
    simp only [madd, hx]; ring
  · rw [Point.add_of_X_ne hxe]
    have hd : x₁ - x₂ ≠ 0 := sub_ne_zero.mpr hxe
    have hl : (curve F).toAffine.slope x₁ x₂ y₁ y₂ = (y₁ - y₂) / (x₁ - x₂) := slope_of_X_ne hxe
    refine ⟨?_, ?_, ?_⟩
    · simp only [madd, hx]
      have := mul_ne_zero (mul_ne_zero (mul_ne_zero h2 hz) (pow_ne_zero 2 hz)) hd
      intro hc; apply this; linear_combination -hc
    · simp only [addX, hl]
      simp only [madd, curve, hx, hy]
      field_simp
      ring
    · simp only [addY, negAddY, addX, hl, negY_eq]
      simp only [madd, curve, hx, hy]
      field_simp
      ring

/-! ## Affine sum -/

/-- The doubling branch of `affine_add` gives `p + p`. -/
public theorem rep_affSum_dbl (h3 : ∀ x : F, x ^ 3 + 3 ≠ 0) {x y : F}
    (h : (curve F).toAffine.Nonsingular x y) :
    Rep (affSum x y x (dblSlope x y)) (.some x y h + .some x y h) := by
  have e := eqn h
  have hy0 := y_ne_zero h3 e
  have h2 := two_ne_zero_of h3
  have hne : y ≠ (curve F).toAffine.negY x y := by
    rw [negY_eq]; intro hc
    exact hy0 ((mul_eq_zero.mp (by linear_combination hc : (2 : F) * y = 0)).resolve_left h2)
  rw [Point.add_of_Y_ne hne]
  have hl : (curve F).toAffine.slope x x y y = dblSlope x y := by
    rw [slope_of_Y_ne rfl hne, negY_eq]; simp only [curve, dblSlope]
    have : y + y ≠ 0 := by
      intro hc
      exact hy0 ((mul_eq_zero.mp (by linear_combination hc : (2 : F) * y = 0)).resolve_left h2)
    field_simp; ring
  refine ⟨one_ne_zero, ?_, ?_⟩
  · simp only [addX, hl]; simp only [affSum, curve]; ring
  · simp only [addY, negAddY, addX, hl, negY_eq]; simp only [affSum, curve]; ring

/-- The chord branch of `affine_add` gives `p + q` for `x₁ ≠ x₂`. -/
public theorem rep_affSum_add {x₁ y₁ x₂ y₂ : F} (h₁ : (curve F).toAffine.Nonsingular x₁ y₁)
    (h₂ : (curve F).toAffine.Nonsingular x₂ y₂) (hx : x₁ ≠ x₂) :
    Rep (affSum x₁ y₁ x₂ (addSlope x₁ y₁ x₂ y₂)) (.some x₁ y₁ h₁ + .some x₂ y₂ h₂) := by
  rw [Point.add_of_X_ne hx]
  have hl : (curve F).toAffine.slope x₁ x₂ y₁ y₂ = addSlope x₁ y₁ x₂ y₂ := by
    rw [slope_of_X_ne hx, addSlope, div_eq_inv_mul]
  refine ⟨one_ne_zero, ?_, ?_⟩
  · simp only [addX, hl]; simp only [affSum, curve]; ring
  · simp only [addY, negAddY, addX, hl, negY_eq]; simp only [affSum, curve]; ring

/-- Equal `x` and unequal `y` sum to zero. -/
public theorem add_eq_zero_of_y_ne {x y₁ y₂ : F} (h₁ : (curve F).toAffine.Nonsingular x y₁)
    (h₂ : (curve F).toAffine.Nonsingular x y₂) (hy : y₁ ≠ y₂) :
    Point.some x y₁ h₁ + .some x y₂ h₂ = 0 := by
  have hy' : y₁ = -y₂ := (y_eq_or_neg (eqn h₁) (eqn h₂)).resolve_left hy
  exact
    Point.add_of_Y_eq rfl
      (by
        rw [negY_eq]; exact hy')

/-! ## `to_affine` -/

/-! ## A double-and-add ladder (for evaluating `k • q`) -/

@[expose] public section

/-- Adds the affine `(qx, qy)` to `P` with the zero and doubling tests of `add_mixed`. -/
def addAff (P : Pt F) (qx qy : F) : Pt F :=
  if P.z = 0 then ⟨qx, qy, 1⟩
  else if maddU P qx = P.x ∧ maddS P qy = P.y then dbl P else madd P qx qy

/-- `(k mod 2^n) • (qx, qy)` by left-to-right double-and-add over the low `n` bits of `k`. -/
def mulAff (qx qy : F) : ℕ → ℕ → Pt F
  | _, 0 => ⟨0, 1, 0⟩
  | k, n + 1 =>
    if k % 2 = 1 then addAff (dbl (mulAff qx qy (k / 2) n)) qx qy else dbl (mulAff qx qy (k / 2) n)

end

/-- `dbl` on any representative of `p` represents `2 • p`. -/
public theorem rep_dbl' (h3 : ∀ x : F, x ^ 3 + 3 ≠ 0) {P : Pt F} {p : (curve F).toAffine.Point}
    (hP : Rep P p) : Rep (dbl P) (2 • p) := by
  cases p with
  | zero =>
    rw [← Point.zero_def, nsmul_zero]
    show (dbl P).z = 0
    have : P.z = 0 := hP
    simp only [dbl, this, mul_zero, add_zero]
  | some x y h => exact rep_dbl h3 hP

public theorem rep_addAff (h3 : ∀ x : F, x ^ 3 + 3 ≠ 0) {P : Pt F} {p : (curve F).toAffine.Point}
    {qx qy : F} (hq : (curve F).toAffine.Nonsingular qx qy) (hP : Rep P p) :
    Rep (addAff P qx qy) (p + .some qx qy hq) := by
  unfold addAff
  cases p with
  | zero =>
    have : P.z = 0 := hP
    rw [ite_eq_left this, ← Point.zero_def, zero_add]; exact rep_affine hq
  | some x y h =>
    rw [ite_eq_right hP.1]
    split_ifs with ht
    · obtain ⟨rfl, rfl⟩ := (madd_test_iff hP).mp ht
      rw [← two_nsmul]; exact rep_dbl h3 hP
    · exact rep_madd h3 hP (fun h => ht ((madd_test_iff hP).mpr h))

public theorem rep_mulAff (h3 : ∀ x : F, x ^ 3 + 3 ≠ 0) {qx qy : F}
    (hq : (curve F).toAffine.Nonsingular qx qy) :
    ∀ n k, Rep (mulAff qx qy k n) ((k % 2 ^ n) • .some qx qy hq)
  | 0, k => by
    rw [pow_zero, Nat.mod_one, zero_nsmul]; show (0 : F) = 0; rfl
  | n + 1, k => by
    have ih := rep_dbl' h3 (rep_mulAff h3 hq n (k / 2))
    have hk : k % 2 ^ (n + 1) = 2 * (k / 2 % 2 ^ n) + k % 2 := by
      rw [pow_succ', Nat.mod_mul]; ring
    unfold mulAff
    split_ifs with hb
    · rw [hk, hb, add_nsmul, one_nsmul, mul_nsmul']; exact rep_addAff h3 hq ih
    · rw [hk, show k % 2 = 0 by omega, add_zero, mul_nsmul']; exact ih

omit [DecidableEq F] in
/-- `toAffine` of a representative of a nonzero point is its affine triple. -/
public theorem rep_toAffine {P : Pt F} {x y : F} {h : (curve F).toAffine.Nonsingular x y}
    (hP : Rep P (.some x y h)) : toAffine P = ⟨x, y, 1⟩ := by
  obtain ⟨hz, hx, hy⟩ := hP
  ext <;> simp only [toAffine, hx, hy] <;> field_simp

end Firedancer.Bn254.Jac
