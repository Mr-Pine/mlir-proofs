module

public import Firedancer.Bn254.G1
public import Firedancer.Bn254.Math.Curve
public import Firedancer.Bn254.Math.Ops

/-! The G1 point functions of `G1.lean` on stored representatives: `dbl`, `add_mixed`,
`affine_add` and `to_affine` act as the group law of `y² = x³ + 3` over `ZMod p`, under the case
splits the C makes. -/

namespace Firedancer.Bn254

open Jac WeierstrassCurve WeierstrassCurve.Affine

@[expose] public section

/-- The points of `y² = x³ + 3` over `ZMod p`. -/
abbrev ECPoint :=
  (curve (ZMod p_bn254)).toAffine.Point

/-- The field values of a stored point's coordinates. -/
def toP (a : fd_bn254_g1_t) : Pt (ZMod p_bn254) :=
  ⟨toF a.X, toF a.Y, toF a.Z⟩

/-- A stored Jacobian point represents `P`: canonical `Z` (and `X`, `Y` unless `P = 0`). -/
def PRep (a : fd_bn254_g1_t) (P : ECPoint) : Prop :=
  fpCanon a.Z ∧ (P ≠ 0 → fpCanon a.X ∧ fpCanon a.Y) ∧ Rep (toP a) P

/-- A stored point represents `P` in affine form: `Z` is Montgomery one unless `P = 0`. -/
def ARep (a : fd_bn254_g1_t) (P : ECPoint) : Prop :=
  PRep a P ∧ (P ≠ 0 → a.Z = fd_bn254_const_one_mont)

end

/-- The curve over `ZMod p` has no `2`-torsion. -/
public theorem h3 : ∀ x : ZMod p_bn254, x ^ 3 + 3 ≠ 0 :=
  cube_add_three_ne_zero

variable {B : Backend}

/-! ## Basic facts -/

public theorem PRep.is_zero_iff {a : fd_bn254_g1_t} {P : ECPoint} (ha : PRep a P) :
    fd_bn254_g1_is_zero.spec a ≠ 0 ↔ P = 0 := by
  rw [fd_bn254_g1_is_zero.spec, fd_bn254_fp_is_zero.spec_iff ⟨ha.1, rfl⟩]
  exact ha.2.2.z_eq_zero_iff

public theorem fd_bn254_g1_set.spec_eq (a : fd_bn254_g1_t) : fd_bn254_g1_set.spec a = a := by
  simp only [fd_bn254_g1_set.spec, fd_bn254_fp_set.spec_eq]

public theorem PRep.zero_of_z {a : fd_bn254_g1_t} (h : limbsEval a.Z = 0) : PRep a 0 :=
  ⟨by
    show limbsEval _ < _; rw [h]; exact p_bn254_pos, fun h => absurd rfl h,
    show toF a.Z = 0 by
      rw [toF_eq_zero_iff
          (by
            show limbsEval _ < _; rw [h]; exact p_bn254_pos)];
      exact h⟩

public theorem PRep.set_zero (r : fd_bn254_g1_t) : PRep (fd_bn254_g1_set_zero.spec r) 0 :=
  PRep.zero_of_z limbsEval_set_zero

public theorem ARep.set_zero (r : fd_bn254_g1_t) : ARep (fd_bn254_g1_set_zero.spec r) 0 :=
  ⟨PRep.set_zero r, fun h => absurd rfl h⟩

/-- Field values of a nonzero represented point. -/
public theorem PRep.tr {a : fd_bn254_g1_t} {P : ECPoint} (ha : PRep a P) (hP : P ≠ 0) :
    Tr a.X (toF a.X) ∧ Tr a.Y (toF a.Y) ∧ Tr a.Z (toF a.Z) :=
  ⟨⟨(ha.2.1 hP).1, rfl⟩, ⟨(ha.2.1 hP).2, rfl⟩, ⟨ha.1, rfl⟩⟩

/-- Coordinates of an affine representative of `some x y`. -/
public theorem ARep.coords {a : fd_bn254_g1_t} {x y : ZMod p_bn254}
    {h : (curve (ZMod p_bn254)).toAffine.Nonsingular x y} (ha : ARep a (.some x y h)) :
    Tr a.X x ∧ Tr a.Y y ∧ a.Z = fd_bn254_const_one_mont := by
  have hz := ha.2 (Point.some_ne_zero h)
  obtain ⟨hX, hY, -⟩ := ha.1.tr (Point.some_ne_zero h)
  obtain ⟨-, ex, ey⟩ := ha.1.2.2
  have h1 : toF a.Z = 1 := by
    rw [hz]; exact fd_bn254_const_one_mont.tr.2
  refine ⟨⟨hX.1, ?_⟩, ⟨hY.1, ?_⟩, hz⟩
  · have := ex; simp only [toP, h1, one_pow, mul_one] at this; exact this
  · have := ey; simp only [toP, h1, one_pow, mul_one] at this; exact this

/-- An affine stored triple with coordinates `(x, y, 1)` represents `some x y`. -/
public theorem ARep.of_coords {a : fd_bn254_g1_t} {x y : ZMod p_bn254}
    (h : (curve (ZMod p_bn254)).toAffine.Nonsingular x y) (hx : Tr a.X x) (hy : Tr a.Y y)
    (hz : a.Z = fd_bn254_const_one_mont) : ARep a (.some x y h) := by
  have h1 : Tr a.Z 1 := hz ▸ fd_bn254_const_one_mont.tr
  refine ⟨⟨h1.1, fun _ => ⟨hx.1, hy.1⟩, ?_⟩, fun _ => hz⟩
  refine
      ⟨by
        rw [show (toP a).z = 1 from h1.2]; exact one_ne_zero, ?_, ?_⟩ <;>
    simp only [toP, h1.2, hx.2, hy.2, one_pow, mul_one]

/-- `ARep.of_coords` for a literal triple. -/
public theorem ARep.of_xyz {X Y Z : fd_bn254_fp_t} {x y : ZMod p_bn254}
    (h : (curve (ZMod p_bn254)).toAffine.Nonsingular x y) (hx : Tr X x) (hy : Tr Y y)
    (hz : Z = fd_bn254_const_one_mont) : ARep ⟨X, Y, Z⟩ (.some x y h) :=
  ARep.of_coords h hx hy hz

public theorem ARep.prep {a : fd_bn254_g1_t} {P : ECPoint} (ha : ARep a P) : PRep a P :=
  ha.1

/-- Three tracked coordinates give the triple of their values. -/
public theorem toP_of_tr {X Y Z : fd_bn254_fp_t} {x y z : ZMod p_bn254} (hx : Tr X x) (hy : Tr Y y)
    (hz : Tr Z z) : toP ⟨X, Y, Z⟩ = ⟨x, y, z⟩ := by simp only [toP, hx.2, hy.2, hz.2]

/-! ## `fd_bn254_g1_dbl` -/

/-- `g1_dbl` on a representative of `P` represents `2 • P`. -/
public theorem fd_bn254_g1_dbl.rep {a : fd_bn254_g1_t} {P : ECPoint} (r : fd_bn254_g1_t)
    (ha : PRep a P) : PRep (fd_bn254_g1_dbl.spec r a) (2 • P) := by
  rw [fd_bn254_g1_dbl.spec]
  split_ifs with hz
  · rw [ha.is_zero_iff] at hz; subst hz; rw [nsmul_zero]; exact PRep.set_zero r
  · rw [ha.is_zero_iff] at hz
    obtain ⟨ax, ay, az⟩ := ha.tr hz
    dsimp only
    have g1 := fd_bn254_fp_sqr.tr ax
    have g2 := fd_bn254_fp_sqr.tr ay
    have g3 := fd_bn254_fp_sqr.tr g2
    have g4 := fd_bn254_fp_mul.tr ax g2
    have g5 := fd_bn254_fp_add.tr g4 g4
    have g6 := fd_bn254_fp_add.tr g5 g5
    have g7 := fd_bn254_fp_add.tr g1 g1
    have g8 := fd_bn254_fp_add.tr g1 g7
    have g9 := fd_bn254_fp_sqr.tr g8
    have g10 := fd_bn254_fp_add.tr g6 g6
    have gX := fd_bn254_fp_sub.tr g9 g10
    have g11 := fd_bn254_fp_mul.tr ay az
    have gZ := fd_bn254_fp_add.tr g11 g11
    have g12 := fd_bn254_fp_sub.tr g6 gX
    have g13 := fd_bn254_fp_mul.tr g8 g12
    have c1 := fd_bn254_fp_add.tr g3 g3
    have c2 := fd_bn254_fp_add.tr c1 c1
    have c3 := fd_bn254_fp_add.tr c2 c2
    have gY := fd_bn254_fp_sub.tr g13 c3
    refine ⟨gZ.1, fun _ => ⟨gX.1, gY.1⟩, ?_⟩
    rw [toP_of_tr gX gY gZ]
    cases P with
    | zero => exact absurd rfl hz
    | some x y h => exact rep_dbl h3 (P := toP a) ha.2.2

/-! ## `fd_bn254_g1_add_mixed` -/

/-- `g1_add_mixed` on a representative of `P` and an affine nonzero `Q` represents `P + Q`. -/
public theorem fd_bn254_g1_add_mixed.rep {a q : fd_bn254_g1_t} {P Q : ECPoint} (r : fd_bn254_g1_t)
    (ha : PRep a P) (hq : ARep q Q) (hQ : Q ≠ 0) :
    PRep (fd_bn254_g1_add_mixed.spec r a q) (P + Q) := by
  rw [fd_bn254_g1_add_mixed.spec]
  cases P with
  | zero =>
    rw [ite_eq_left ((ha.is_zero_iff).mpr rfl), fd_bn254_g1_set.spec_eq, ← Point.zero_def, zero_add]
    exact hq.prep
  | some x₁ y₁ h₁ =>
    rw [ite_eq_right (mt (ha.is_zero_iff).mp (Point.some_ne_zero h₁))]
    cases Q with
    | zero => exact absurd rfl hQ
    | some x₂ y₂ h₂ =>
      have hz : Point.some x₁ y₁ h₁ ≠ 0 := Point.some_ne_zero h₁
      obtain ⟨ax, ay, az⟩ := ha.tr hz
      obtain ⟨qx, qy, -⟩ := hq.coords
      dsimp only
      have zz := fd_bn254_fp_sqr.tr az
      have u2 := fd_bn254_fp_mul.tr qx zz
      have s2a := fd_bn254_fp_mul.tr qy az
      have s2 := fd_bn254_fp_mul.tr s2a zz
      split_ifs with ht
      · rw [fd_bn254_fp_eq.spec_iff u2 ax, fd_bn254_fp_eq.spec_iff s2 ay] at ht
        obtain ⟨rfl, rfl⟩ := (madd_test_iff ha.2.2).mp ht
        rw [← two_nsmul]; exact fd_bn254_g1_dbl.rep r ha
      rw [fd_bn254_fp_eq.spec_iff u2 ax, fd_bn254_fp_eq.spec_iff s2 ay] at ht
      have hne : ¬(x₁ = x₂ ∧ y₁ = y₂) := fun h => ht ((madd_test_iff ha.2.2).mpr h)
      have hh := fd_bn254_fp_sub.tr u2 ax
      have hh2 := fd_bn254_fp_sqr.tr hh
      have i1 := fd_bn254_fp_add.tr hh2 hh2
      have i2 := fd_bn254_fp_add.tr i1 i1
      have j := fd_bn254_fp_mul.tr hh i2
      have rr1 := fd_bn254_fp_sub.tr s2 ay
      have rr := fd_bn254_fp_add.tr rr1 rr1
      have v := fd_bn254_fp_mul.tr ax i2
      have x1 := fd_bn254_fp_sqr.tr rr
      have x2 := fd_bn254_fp_sub.tr x1 j
      have x3 := fd_bn254_fp_sub.tr x2 v
      have gX := fd_bn254_fp_sub.tr x3 v
      have k1 := fd_bn254_fp_mul.tr ay j
      have k2 := fd_bn254_fp_add.tr k1 k1
      have y1 := fd_bn254_fp_sub.tr v gX
      have y2 := fd_bn254_fp_mul.tr y1 rr
      have gY := fd_bn254_fp_sub.tr y2 k2
      have z1 := fd_bn254_fp_add.tr az hh
      have z2 := fd_bn254_fp_sqr.tr z1
      have z3 := fd_bn254_fp_sub.tr z2 zz
      have gZ := fd_bn254_fp_sub.tr z3 hh2
      refine ⟨gZ.1, fun _ => ⟨gX.1, gY.1⟩, ?_⟩
      rw [toP_of_tr gX gY gZ]
      exact rep_madd h3 (P := toP a) (h₂ := h₂) ha.2.2 hne

/-! ## `fd_bn254_g1_affine_add` -/

/-- Converts a `Rep` of an affine triple into an `ARep` of the stored result. -/
theorem ARep.of_rep {a : fd_bn254_g1_t} {S : ECPoint} {x y : ZMod p_bn254} (hx : Tr a.X x)
    (hy : Tr a.Y y) (hz : a.Z = fd_bn254_const_one_mont) (hS : Rep ⟨x, y, 1⟩ S) : ARep a S := by
  cases S with
  | zero => exact absurd hS one_ne_zero
  | some x' y' h' =>
    obtain ⟨rfl, rfl⟩ := rep_affine_iff.mp hS
    exact ARep.of_coords h' hx hy hz

/-- `g1_affine_add` on affine representatives of `P`, `Q` gives an affine representative of
`P + Q`, for any backend whose `fp_inv` inverts nonzero elements. -/
public theorem fd_bn254_g1_affine_add.rep (hB : B.Spec) {p q : fd_bn254_g1_t} {P Q : ECPoint}
    (r : fd_bn254_g1_t) (hp : ARep p P) (hq : ARep q Q) :
    ARep (fd_bn254_g1_affine_add.spec B r p q) (P + Q) := by
  rw [fd_bn254_g1_affine_add.spec]
  cases P with
  | zero =>
    rw [ite_eq_left ((hp.prep.is_zero_iff).mpr rfl), fd_bn254_g1_set.spec_eq, ← Point.zero_def,
      zero_add]
    exact hq
  | some x₁ y₁
    h₁ =>
    rw [ite_eq_right (mt (hp.prep.is_zero_iff).mp (Point.some_ne_zero h₁))]
    cases Q with
    | zero =>
      rw [ite_eq_left ((hq.prep.is_zero_iff).mpr rfl), fd_bn254_g1_set.spec_eq, ← Point.zero_def,
        add_zero]
      exact hp
    | some x₂ y₂
      h₂ =>
      rw [ite_eq_right (mt (hq.prep.is_zero_iff).mp (Point.some_ne_zero h₂))]
      obtain ⟨px, py, -⟩ := hp.coords
      obtain ⟨qx, qy, -⟩ := hq.coords
      have hy0 := y_ne_zero h3 (eqn h₁)
      have h2 := two_ne_zero_of h3
      dsimp only
      split_ifs with hx hy
      · rw [fd_bn254_fp_eq.spec_iff px qx] at hx
        rw [fd_bn254_fp_eq.spec_iff py qy] at hy
        subst hx hy
        dsimp only
        have l1 := fd_bn254_fp_sqr.tr px
        have l2 := fd_bn254_fp_add.tr l1 l1
        have l3 := fd_bn254_fp_add.tr l1 l2
        have l4 := fd_bn254_fp_add.tr py py
        have l4ne : y₁ + y₁ ≠ 0 := by
          intro hc
          exact
            hy0
              ((mul_eq_zero.mp
                    (by linear_combination hc : (2 : ZMod p_bn254) * y₁ = 0)).resolve_left
                h2)
        have l5 := hB _ _ l4 l4ne
        have l := fd_bn254_fp_mul.tr l5 l3
        have a1 := fd_bn254_fp_sqr.tr l
        have a2 := fd_bn254_fp_sub.tr a1 px
        have gX := fd_bn254_fp_sub.tr a2 qx
        have b1 := fd_bn254_fp_sub.tr px gX
        have b2 := fd_bn254_fp_mul.tr b1 l
        have gY := fd_bn254_fp_sub.tr b2 py
        simp only [fd_bn254_fp_set.spec_eq]
        exact ARep.of_rep gX gY fd_bn254_fp_set_one.spec_eq (rep_affSum_dbl h3 h₁)
      · rw [fd_bn254_fp_eq.spec_iff px qx] at hx
        rw [fd_bn254_fp_eq.spec_iff py qy] at hy
        subst hx
        dsimp only
        rw [add_eq_zero_of_y_ne h₁ h₂ hy]
        exact ARep.set_zero r
      · rw [fd_bn254_fp_eq.spec_iff px qx] at hx
        dsimp only
        have l1 := fd_bn254_fp_sub.tr px qx
        have l2 := fd_bn254_fp_sub.tr py qy
        have l5 := hB _ _ l1 (sub_ne_zero.mpr hx)
        have l := fd_bn254_fp_mul.tr l5 l2
        have a1 := fd_bn254_fp_sqr.tr l
        have a2 := fd_bn254_fp_sub.tr a1 px
        have gX := fd_bn254_fp_sub.tr a2 qx
        have b1 := fd_bn254_fp_sub.tr px gX
        have b2 := fd_bn254_fp_mul.tr b1 l
        have gY := fd_bn254_fp_sub.tr b2 py
        simp only [fd_bn254_fp_set.spec_eq]
        exact ARep.of_rep gX gY fd_bn254_fp_set_one.spec_eq (rep_affSum_add h₁ h₂ hx)

/-! ## `fd_bn254_g1_to_affine` -/

/-- `g1_to_affine` of a representative of `some x y` stores `x` and `y`. -/
public theorem fd_bn254_g1_to_affine.tr (hB : B.Spec) {p : fd_bn254_g1_t} {x y : ZMod p_bn254}
    {h : (curve (ZMod p_bn254)).toAffine.Nonsingular x y} (hp : PRep p (.some x y h)) :
    Tr (fd_bn254_g1_to_affine.spec B p).X x ∧ Tr (fd_bn254_g1_to_affine.spec B p).Y y := by
  have hP := Point.some_ne_zero h
  obtain ⟨ax, ay, az⟩ := hp.tr hP
  obtain ⟨hz, ex, ey⟩ := hp.2.2
  rw [fd_bn254_g1_to_affine.spec]
  split_ifs with hzo
  · rw [fd_bn254_g1_set.spec_eq]
    rcases hzo with h0 | h1
    · exact absurd ((hp.is_zero_iff).mp h0) hP
    · rw [fd_bn254_fp_is_one.spec_iff az] at h1
      simp only [toP, h1, one_pow, mul_one] at ex ey
      exact ⟨⟨ax.1, ex⟩, ⟨ay.1, ey⟩⟩
  · dsimp only
    have i1 := hB _ _ az hz
    have i2 := fd_bn254_fp_sqr.tr i1
    have gX := fd_bn254_fp_mul.tr ax i2
    have y1 := fd_bn254_fp_mul.tr ay i2
    have gY := fd_bn254_fp_mul.tr y1 i1
    have e := rep_toAffine hp.2.2
    refine ⟨⟨gX.1, ?_⟩, ⟨gY.1, ?_⟩⟩
    · rw [gX.2]; exact congrArg Pt.x e
    · rw [gY.2]; exact congrArg Pt.y e

end Firedancer.Bn254
