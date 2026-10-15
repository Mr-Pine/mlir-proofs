module

public import Firedancer.Secp256k1.Math.Formulas
public import Firedancer.Secp256k1.Math.Ops
public import Firedancer.Secp256k1.Point

/-! The point functions of `Point.lean` on any backend meeting `Backend.Spec`: on canonical
coordinates they compute `Formulas.add`/`dbl`/`neg` of the field values, so they act on
representatives as the group law of `y² = x³ + 7` over `ZMod p_256k1`. -/

namespace Firedancer.Secp256k1

open Formulas WeierstrassCurve WeierstrassCurve.Affine

@[expose] public section

/-- The points of `y² = x³ + 7` over `ZMod p_256k1`. -/
abbrev ECPoint :=
  (curve (ZMod p_256k1)).toAffine.Point

/-- Every coordinate of a stored point is canonical. -/
def PCanon (a : fd_secp256k1_point_t) : Prop :=
  fpCanon a.x ∧ fpCanon a.y ∧ fpCanon a.z

/-- The field values of a stored point's coordinates. -/
def toP (a : fd_secp256k1_point_t) : Proj (ZMod p_256k1) :=
  ⟨toF a.x, toF a.y, toF a.z⟩

/-- A stored point has canonical coordinates representing `P`. -/
def PRep (a : fd_secp256k1_point_t) (P : ECPoint) : Prop :=
  PCanon a ∧ Rep (toP a) P

end

/-- A pair `(x, y)` on the curve is nonsingular when `x³ + 7` never vanishes. -/
public theorem nonsingular_of_eqn {F : Type*} [Field F] (h7 : ∀ x : F, x ^ 3 + 7 ≠ 0) {x y : F}
    (h : y ^ 2 = x ^ 3 + 7) : (curve F).toAffine.Nonsingular x y := by
  refine ⟨(equation_iff _ _).mpr (by simpa [curve] using h), ?_⟩
  right
  rw [evalEval_polynomialY]
  have := mul_ne_zero (two_ne_zero_of h7) (Formulas.y_ne_zero h7 h)
  simpa [curve] using this

@[expose] public section

/-- The base point `G` (SEC 2). -/
def basePoint : ECPoint :=
  .some Gx Gy (nonsingular_of_eqn cube_add_seven_ne_zero Gy_sq)

end

/-! ## Tracked coordinates -/

/-- A stored element is canonical with value `v`. -/
public abbrev Tr (a : fd_secp256k1_fp_t) (v : ZMod p_256k1) : Prop :=
  fpCanon a ∧ toF a = v

variable {B : Backend}

section Track

variable (hB : B.Spec) {a b : fd_secp256k1_fp_t} {u v : ZMod p_256k1}

include hB

public theorem tr_mul (ha : Tr a u) (hb : Tr b v) : Tr (B.fp_mul a b) (u * v) :=
  ⟨(hB.fp_mul ha.1 hb.1).1, by rw [(hB.fp_mul ha.1 hb.1).2, ha.2, hb.2]⟩

public theorem tr_add (ha : Tr a u) (hb : Tr b v) : Tr (B.fp_add a b) (u + v) :=
  ⟨(hB.fp_add ha.1 hb.1).1, by rw [(hB.fp_add ha.1 hb.1).2, ha.2, hb.2]⟩

public theorem tr_sub (ha : Tr a u) (hb : Tr b v) : Tr (B.fp_sub a b) (u - v) :=
  ⟨(hB.fp_sub ha.1 hb.1).1, by rw [(hB.fp_sub ha.1 hb.1).2, ha.2, hb.2]⟩

public theorem tr_dbl (ha : Tr a u) : Tr (B.fp_dbl a) (2 * u) :=
  ⟨(hB.fp_dbl ha.1).1, by rw [(hB.fp_dbl ha.1).2, ha.2]⟩

public theorem tr_triple (ha : Tr a u) : Tr (B.fp_triple a) (3 * u) :=
  ⟨(hB.fp_triple ha.1).1, by rw [(hB.fp_triple ha.1).2, ha.2]⟩

public theorem tr_sqr (ha : Tr a u) : Tr (B.fp_sqr a) (u ^ 2) :=
  ⟨(hB.fp_sqr ha.1).1, by rw [(hB.fp_sqr ha.1).2, ha.2]⟩

public theorem tr_neg (ha : Tr a u) : Tr (B.fp_negate a) (-u) :=
  ⟨(hB.fp_negate ha.1).1, by rw [(hB.fp_negate ha.1).2, ha.2]⟩

end Track

public theorem of_tr {r : fd_secp256k1_point_t} {X Y Z : ZMod p_256k1} (hx : Tr r.x X)
    (hy : Tr r.y Y) (hz : Tr r.z Z) : PCanon r ∧ toP r = ⟨X, Y, Z⟩ :=
  ⟨⟨hx.1, hy.1, hz.1⟩, by simp only [toP, hx.2, hy.2, hz.2]⟩

/-! ## Value lemmas -/

/-- `point_add` computes `Formulas.add` on canonical inputs. -/
public theorem fd_secp256k1_point_add.spec_val (hB : B.Spec) {a b : fd_secp256k1_point_t}
    (ha : PCanon a) (hb : PCanon b) :
    PCanon (fd_secp256k1_point_add.spec B a b) ∧
      toP (fd_secp256k1_point_add.spec B a b) = add (toP a) (toP b) := by
  have ax : Tr a.x (toF a.x) := ⟨ha.1, rfl⟩
  have ay : Tr a.y (toF a.y) := ⟨ha.2.1, rfl⟩
  have az : Tr a.z (toF a.z) := ⟨ha.2.2, rfl⟩
  have bx : Tr b.x (toF b.x) := ⟨hb.1, rfl⟩
  have by' : Tr b.y (toF b.y) := ⟨hb.2.1, rfl⟩
  have bz : Tr b.z (toF b.z) := ⟨hb.2.2, rfl⟩
  have g1 := tr_mul hB ax bx
  have g2 := tr_mul hB ay by'
  have g3 := tr_mul hB az bz
  have g4 := tr_add hB ax ay
  have g5 := tr_add hB bx by'
  have g6 := tr_mul hB g4 g5
  have g7 := tr_add hB g1 g2
  have g8 := tr_sub hB g6 g7
  have g9 := tr_add hB ay az
  have g10 := tr_add hB by' bz
  have g11 := tr_mul hB g9 g10
  have g12 := tr_add hB g2 g3
  have g13 := tr_sub hB g11 g12
  have g14 := tr_add hB ax az
  have g15 := tr_add hB bx bz
  have g16 := tr_mul hB g14 g15
  have g17 := tr_add hB g1 g3
  have g18 := tr_sub hB g16 g17
  have g19 := tr_triple hB g1
  have g20 := tr_dbl hB g3
  have g21 := tr_dbl hB g20
  have g22 := tr_dbl hB g21
  have g23 := tr_dbl hB g22
  have g24 := tr_add hB g23 g21
  have g25 := tr_add hB g24 g3
  have g26 := tr_add hB g2 g25
  have g27 := tr_sub hB g2 g25
  have g28 := tr_dbl hB g18
  have g29 := tr_dbl hB g28
  have g30 := tr_dbl hB g29
  have g31 := tr_dbl hB g30
  have g32 := tr_add hB g31 g29
  have g33 := tr_add hB g32 g18
  have g34 := tr_mul hB g13 g33
  have g35 := tr_mul hB g8 g27
  have gx := tr_sub hB g35 g34
  have g36 := tr_mul hB g33 g19
  have g37 := tr_mul hB g27 g26
  have gy := tr_add hB g37 g36
  have g38 := tr_mul hB g19 g8
  have g39 := tr_mul hB g26 g13
  have gz := tr_add hB g39 g38
  exact of_tr gx gy gz

/-- `point_dbl` computes `Formulas.dbl` on canonical inputs. -/
public theorem fd_secp256k1_point_dbl.spec_val (hB : B.Spec) {a : fd_secp256k1_point_t}
    (ha : PCanon a) :
    PCanon (fd_secp256k1_point_dbl.spec B a) ∧
      toP (fd_secp256k1_point_dbl.spec B a) = dbl (toP a) := by
  have ax : Tr a.x (toF a.x) := ⟨ha.1, rfl⟩
  have ay : Tr a.y (toF a.y) := ⟨ha.2.1, rfl⟩
  have az : Tr a.z (toF a.z) := ⟨ha.2.2, rfl⟩
  have g1 := tr_sqr hB ay
  have g2 := tr_dbl hB g1
  have g3 := tr_dbl hB g2
  have g4 := tr_dbl hB g3
  have g5 := tr_mul hB ay az
  have g6 := tr_sqr hB az
  have g7 := tr_dbl hB g6
  have g8 := tr_dbl hB g7
  have g9 := tr_dbl hB g8
  have g10 := tr_dbl hB g9
  have g11 := tr_add hB g10 g8
  have g12 := tr_add hB g11 g6
  have g13 := tr_mul hB g12 g4
  have g14 := tr_add hB g1 g12
  have gz := tr_mul hB g5 g4
  have g15 := tr_dbl hB g12
  have g16 := tr_add hB g15 g12
  have g17 := tr_sub hB g1 g16
  have g18 := tr_mul hB g17 g14
  have g19 := tr_mul hB ax ay
  have gy := tr_add hB g13 g18
  have g20 := tr_mul hB g17 g19
  have gx := tr_dbl hB g20
  exact of_tr gx gy gz

/-- `point_neg` computes `Formulas.neg` on canonical inputs. -/
public theorem fd_secp256k1_point_neg.spec_val (hB : B.Spec) {a : fd_secp256k1_point_t}
    (ha : PCanon a) :
    PCanon (fd_secp256k1_point_neg.spec B a) ∧
      toP (fd_secp256k1_point_neg.spec B a) = neg (toP a) := by
  have gy := tr_neg hB (⟨ha.2.1, rfl⟩ : Tr a.y (toF a.y))
  refine of_tr ?_ gy ?_ <;> simp only [fd_secp256k1_point_neg.spec, hB.fp_set]
  exacts [⟨ha.1, rfl⟩, ⟨ha.2.2, rfl⟩]

/-- `point_set` copies. -/
public theorem fd_secp256k1_point_set.spec_eq (hB : B.Spec) (a : fd_secp256k1_point_t) :
    fd_secp256k1_point_set.spec B a = a := by simp only [fd_secp256k1_point_set.spec, hB.fp_set]

/-! ## Representatives -/

section Rep

variable (hB : B.Spec)

include hB

/-- `point_add` represents `P + Q`. -/
public theorem PRep.add {a b : fd_secp256k1_point_t} {P Q : ECPoint} (ha : PRep a P)
    (hb : PRep b Q) : PRep (fd_secp256k1_point_add.spec B a b) (P + Q) := by
  obtain ⟨c, v⟩ := fd_secp256k1_point_add.spec_val hB ha.1 hb.1
  exact ⟨c, v ▸ rep_add cube_add_seven_ne_zero ha.2 hb.2⟩

/-- `point_dbl` represents `2 • P`. -/
public theorem PRep.dbl {a : fd_secp256k1_point_t} {P : ECPoint} (ha : PRep a P) :
    PRep (fd_secp256k1_point_dbl.spec B a) (2 • P) := by
  obtain ⟨c, v⟩ := fd_secp256k1_point_dbl.spec_val hB ha.1
  exact ⟨c, v ▸ rep_dbl cube_add_seven_ne_zero ha.2⟩

/-- `point_neg` represents `-P`. -/
public theorem PRep.neg {a : fd_secp256k1_point_t} {P : ECPoint} (ha : PRep a P) :
    PRep (fd_secp256k1_point_neg.spec B a) (-P) := by
  obtain ⟨c, v⟩ := fd_secp256k1_point_neg.spec_val hB ha.1
  exact ⟨c, v ▸ rep_neg ha.2⟩

/-- `point_sub` represents `P - Q`. -/
public theorem PRep.sub {a b : fd_secp256k1_point_t} {P Q : ECPoint} (ha : PRep a P)
    (hb : PRep b Q) : PRep (fd_secp256k1_point_sub.spec B a b) (P - Q) := by
  rw [sub_eq_add_neg]
  exact PRep.add hB ha (PRep.neg hB hb)

/-- `point_set_identity` represents `0`. -/
public theorem fd_secp256k1_point_set_identity.spec_rep :
    PRep (fd_secp256k1_point_set_identity.spec B) 0 := by
  simp only [fd_secp256k1_point_set_identity.spec, hB.fp_set]
  refine
    ⟨⟨fd_secp256k1_const_zero.fp.1, fd_secp256k1_const_one_mont.fp.1, fd_secp256k1_const_zero.fp.1⟩,
      ?_⟩
  simp only [toP, fd_secp256k1_const_zero.fp.2, fd_secp256k1_const_one_mont.fp.2]
  exact ⟨rfl, one_ne_zero, rfl⟩

/-- `point_set_base` represents `G`. -/
public theorem fd_secp256k1_point_set_base.spec_rep :
    PRep (fd_secp256k1_point_set_base.spec B) basePoint := by
  simp only [fd_secp256k1_point_set_base.spec, hB.fp_set]
  refine
    ⟨⟨fd_secp256k1_const_base_x_mont.fp.1, fd_secp256k1_const_base_y_mont.fp.1,
        fd_secp256k1_const_one_mont.fp.1⟩,
      ?_⟩
  simp only [toP, basePoint, Rep, fd_secp256k1_const_base_x_mont.fp.2,
    fd_secp256k1_const_base_y_mont.fp.2, fd_secp256k1_const_one_mont.fp.2]
  exact ⟨one_ne_zero, (mul_one _).symm, (mul_one _).symm⟩

/-- `point_to_affine r a` of a representative of `(x, y)` stores canonical `x` and `y` at `r`, and
keeps `r.z`. -/
public theorem fd_secp256k1_point_to_affine.spec_val {r a : fd_secp256k1_point_t} {x y}
    {h : (curve (ZMod p_256k1)).toAffine.Nonsingular x y} (ha : PRep a (.some x y h)) :
    Tr (fd_secp256k1_point_to_affine.spec B r a).x x ∧
      Tr (fd_secp256k1_point_to_affine.spec B r a).y y ∧
      (fd_secp256k1_point_to_affine.spec B r a).z = r.z := by
  obtain ⟨⟨cx, cy, cz⟩, hz, hx, hy⟩ := ha
  obtain ⟨ci, vi⟩ := hB.fp_invert cz hz
  have tz : Tr (B.fp_invert a.z) (toF a.z)⁻¹ := ⟨ci, vi⟩
  have gx := tr_mul hB (⟨cx, rfl⟩ : Tr a.x _) tz
  have gy := tr_mul hB (⟨cy, rfl⟩ : Tr a.y _) tz
  simp only [toP] at hz hx hy
  refine ⟨⟨gx.1, ?_⟩, ⟨gy.1, ?_⟩, rfl⟩
  · show toF (B.fp_mul a.x (B.fp_invert a.z)) = x
    rw [gx.2, hx, mul_assoc, mul_inv_cancel₀ hz, mul_one]
  · show toF (B.fp_mul a.y (B.fp_invert a.z)) = y
    rw [gy.2, hy, mul_assoc, mul_inv_cancel₀ hz, mul_one]

/-- `point_is_identity` is nonzero exactly on representatives of `0`. -/
public theorem fd_secp256k1_point_is_identity.spec_rep {a : fd_secp256k1_point_t} {P : ECPoint}
    (ha : PRep a P) : fd_secp256k1_point_is_identity.spec B a ≠ 0#32 ↔ P = 0 := by
  have h7 : ∀ y : ZMod p_256k1, y ^ 2 ≠ 7 := fun y hy => not_isSquare_seven ⟨y, by rw [← hy, sq]⟩
  rw [← (Rep.isIdentity_iff h7 ha.2)]
  obtain ⟨⟨cx, cy, cz⟩, -⟩ := ha
  have z0 := fd_secp256k1_const_zero.fp
  have o1 := fd_secp256k1_const_one_mont.fp
  simp only [fd_secp256k1_point_is_identity.spec, hB.fp_eq cx z0.1, hB.fp_eq cy z0.1,
    hB.fp_eq cy o1.1, hB.fp_eq cz z0.1, z0.2, o1.2, toP]
  split_ifs <;> simp_all

end Rep

end Firedancer.Secp256k1
