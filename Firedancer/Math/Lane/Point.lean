module

public import Firedancer.Math.Lane.Mul
public import Ed25519.Group
import Ed25519.Ext
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Ring

/-! The lane group operations on curve points: doubling, the complete addition and the table form
keep lane `j`'s extended coordinates, and their outputs stay carried. -/

namespace MLIR.Firedancer.Lane

open _root_.Ed25519 (p d IsExt)
open Firedancer.Avx512

/-! ## Definitions -/

@[expose] public section

/-- Lane `j` of `P` is projective coordinates of `Q` (`T` unconstrained). -/
def Point.Proj (P : Point) (j : Fin 8) (Q : Ed25519.Point) : Prop :=
  P.z.val j ≠ 0 ∧ P.x.val j = Q.x * P.z.val j ∧ P.y.val j = Q.y * P.z.val j

/-- Lane `j` of `P` is extended coordinates of `Q`. -/
def Point.Ext (P : Point) (j : Fin 8) (Q : Ed25519.Point) : Prop :=
  IsExt Q.x Q.y (P.x.val j) (P.y.val j) (P.t.val j) (P.z.val j)

/-- `X, Y, Z` carried, the doubling's input requirement. -/
def Point.CarriedXYZ (P : Point) : Prop :=
  P.x.Carried ∧ P.y.Carried ∧ P.z.Carried

/-- All four coordinates carried. -/
def Point.Carried (P : Point) : Prop :=
  P.CarriedXYZ ∧ P.t.Carried

/-- An addition operand of lane `j`: `y + x`, `y - x`, `2dt`, `z` of extended coordinates of `Q`. -/
def Operand (qp qm qk qz : Fe) (j : Fin 8) (Q : Ed25519.Point) : Prop :=
  ∃ X Y T Z, IsExt Q.x Q.y X Y T Z ∧ qp.val j = Y + X ∧ qm.val j = Y - X ∧
    qk.val j = 2 * d * T ∧ qz.val j = Z

/-- The table form of `Q` in lane `j`: an operand, and `nk = -k`. -/
def Niels.Is (q : Niels) (j : Fin 8) (Q : Ed25519.Point) : Prop :=
  Operand q.p q.m q.k q.z j Q ∧ q.nk.val j = -q.k.val j

/-- The table form's bounds: `p, m, k, z` carried, `nk` f52. -/
def Niels.Bounded (q : Niels) : Prop :=
  q.p.Carried ∧ q.m.Carried ∧ q.k.Carried ∧ q.nk.F52 ∧ q.z.Carried

end

/-! ## Field steps with constant bounds -/

/-- `IsExt` of equal coordinates. -/
theorem isExt_congr {x y X Y T Z X' Y' T' Z' : ZMod p} (h : IsExt x y X Y T Z) (hX : X' = X)
    (hY : Y' = Y) (hT : T' = T) (hZ : Z' = Z) : IsExt x y X' Y' T' Z' := by
  subst hX hY hT hZ
  exact h

/-- `0`'s limbs are `0`. -/
theorem Fe.zero_le : Fe.zero.Le fun _ => 0 := by
  intro j i
  fin_cases i <;> simp [Fe.zero, Fe.small]

/-! `addRaw`, `subBig` with the same bound on every limb. -/

theorem addRaw_val' {a b : Fe} {M N : ℕ} (ha : a.Le fun _ => M) (hb : b.Le fun _ => N)
    (h : M + N < 2 ^ 64) (j : Fin 8) : (addRaw a b).val j = a.val j + b.val j :=
  addRaw_val ha hb (fun _ => h) j

theorem addRaw_le' {a b : Fe} {M N : ℕ} (ha : a.Le fun _ => M) (hb : b.Le fun _ => N)
    (h : M + N < 2 ^ 64) : (addRaw a b).Le fun _ => M + N :=
  addRaw_le ha hb fun _ => h

/-- `2^k p`'s limbs cover `N`. -/
theorem bigP_covers {N k : ℕ} (hN : N ≤ (2 ^ 51 - 19) * 2 ^ k) (i : Fin 5) :
    N ≤ (if i = 0 then 2 ^ 51 - 19 else 2 ^ 51 - 1) * 2 ^ k := by
  split
  · exact hN
  · exact hN.trans (Nat.mul_le_mul_right _ (by omega))

theorem subBig_val' {a b : Fe} {M N k : ℕ} (hk : k ≤ 12) (ha : a.Le fun _ => M)
    (hb : b.Le fun _ => N) (hN : N ≤ (2 ^ 51 - 19) * 2 ^ k)
    (hM : M + (2 ^ 51 - 1) * 2 ^ k < 2 ^ 64) (j : Fin 8) :
    (subBig a b k).val j = a.val j - b.val j :=
  subBig_val hk ha hb (bigP_covers hN) (fun _ => hM) j

theorem subBig_le' {a b : Fe} {M N k : ℕ} (hk : k ≤ 12) (ha : a.Le fun _ => M)
    (hb : b.Le fun _ => N) (hN : N ≤ (2 ^ 51 - 19) * 2 ^ k)
    (hM : M + (2 ^ 51 - 1) * 2 ^ k < 2 ^ 64) :
    (subBig a b k).Le fun _ => M + (2 ^ 51 - 1) * 2 ^ k :=
  subBig_le hk ha hb (bigP_covers hN) fun _ => hM

/-- `2^k p - h`, the doubling's negated `H`. -/
theorem zipWith_sub_bigP (h : Fe) (k : ℕ) : Fe.zipWith wwl_sub (bigP k) h = subBig Fe.zero h k := by
  have e (x : Wwl) : wwl_add (Vector.replicate 8 0) x = x := by
    ext i hi
    simp [wwl_add]
  simp only [subBig, subOff, Fe.zipWith, Fe.zero, Fe.small, wwl_bcast, wwl_zero, e]

/-- A product of carried factors. -/
theorem mul_carry_val (a b : Fe) (c : Bool) (j : Fin 8) :
    (mul (carry a) (carry b) c).val j = a.val j * b.val j := by
  rw [mul_val (carry_carried a).f52 (carry_carried b).f52, carry_val, carry_val]

theorem mul_carry_carried (a b : Fe) : (mul (carry a) (carry b)).Carried :=
  mul_carried (carry_carried a).f52 (carry_carried b).f52

/-! ## Basics -/

/-- `y + x`, `y - x` swapped and `-2dt` for `2dt`: an operand of `-Q`. -/
public theorem Operand.neg {qp qm qk qz nk : Fe} {j : Fin 8} {Q : Ed25519.Point}
    (h : Operand qp qm qk qz j Q) (hn : nk.val j = -qk.val j) : Operand qm qp nk qz j (-Q) := by
  obtain ⟨X, Y, T, Z, hE, h1, h2, h3, h4⟩ := h
  refine ⟨-X, Y, -T, Z, ?_, by rw [h2]; ring, by rw [h1]; ring, by rw [hn, h3]; ring, h4⟩
  simpa only [Ed25519.Point.neg_x, Ed25519.Point.neg_y] using hE.neg

public theorem Point.Ext.proj {P : Point} {j : Fin 8} {Q : Ed25519.Point} (h : P.Ext j Q) :
    P.Proj j Q :=
  ⟨h.1, h.2.1, h.2.2.1⟩

public theorem Point.Carried.xyz {P : Point} (h : P.Carried) : P.CarriedXYZ :=
  h.1

public theorem Point.zero_ext (j : Fin 8) : Point.zero.Ext j 0 := by
  simp only [Point.Ext, Point.zero, Fe.zero_val, Fe.one_val, Ed25519.Point.zero_x,
    Ed25519.Point.zero_y]
  exact ⟨one_ne_zero, by ring, by ring, by ring⟩

public theorem Point.zero_carried : Point.zero.Carried :=
  ⟨⟨Fe.zero_carried, Fe.one_carried, Fe.one_carried⟩, Fe.zero_carried⟩

/-- `2p` is `0`. -/
theorem twoP_val (j : Fin 8) : twoP.val j = 0 := by
  simp only [Fe.val_eq, twoP, Fe.bcast2, getElem_wwl_bcast]
  decide

/-- `2p`'s limbs are below `2^52`. -/
theorem twoP_f52 : twoP.F52 := by
  intro j i
  rw [twoP, Fe.lane_bcast2]
  show _ ≤ 2 ^ 52 - 1
  split <;> decide

public theorem Niels.zero_is (j : Fin 8) : Niels.zero.Is j 0 := by
  refine ⟨⟨0, 1, 0, 1, ?_, ?_, ?_, ?_, ?_⟩, ?_⟩ <;>
    simp only [Niels.zero, Fe.one_val, Fe.zero_val, twoP_val, Ed25519.Point.zero_x,
      Ed25519.Point.zero_y]
  · exact ⟨one_ne_zero, by ring, by ring, by ring⟩
  all_goals ring

public theorem Niels.zero_bounded : Niels.zero.Bounded :=
  ⟨Fe.one_carried, Fe.one_carried, Fe.zero_carried, twoP_f52, Fe.one_carried⟩

/-- The entry itself, as an operand. -/
public theorem Niels.Is.operand {q : Niels} {j : Fin 8} {Q : Ed25519.Point} (h : q.Is j Q) :
    Operand q.p q.m q.k q.z j Q :=
  h.1

/-- The entry read negated, `p, m` swapped and `nk` for `k`: an operand of `-Q`. -/
public theorem Niels.Is.operand_neg {q : Niels} {j : Fin 8} {Q : Ed25519.Point} (h : q.Is j Q) :
    Operand q.m q.p q.nk q.z j (-Q) :=
  h.1.neg h.2

/-- An operand depends only on lane `j`'s values. -/
public theorem Operand.congr {qp qm qk qz qp' qm' qk' qz' : Fe} {j : Fin 8} {Q : Ed25519.Point}
    (h : Operand qp qm qk qz j Q) (ep : qp'.val j = qp.val j) (em : qm'.val j = qm.val j)
    (ek : qk'.val j = qk.val j) (ez : qz'.val j = qz.val j) : Operand qp' qm' qk' qz' j Q := by
  obtain ⟨X, Y, T, Z, hE, h1, h2, h3, h4⟩ := h
  exact ⟨X, Y, T, Z, hE, ep.trans h1, em.trans h2, ek.trans h3, ez.trans h4⟩

/-! ## Doubling -/

public theorem Point.dbl_ext {P : Point} {j : Fin 8} {Q : Ed25519.Point} (h : P.Proj j Q)
    (hb : P.CarriedXYZ) (t0 : Fe) : (P.dbl true t0).Ext j (Q + Q) := by
  obtain ⟨hx, hy, hz⟩ := hb
  obtain ⟨hz0, ex, ey⟩ := h
  have hE := _root_.Ed25519.isExt_dbl hz0 ex ey Q.on
  dsimp only at hE
  rw [_root_.Ed25519.Point.dbl_eq] at hE
  have hs : (Lane.add P.x P.y).Carried := carry_carried _
  have la := sqr_loose hx.f52
  have lb := sqr_loose hy.f52
  have lc := sqr_loose hz.f52
  have ls := sqr_loose hs.f52
  have lh := addRaw_le' la lb (by norm_num)
  have vs := sqr_val hs.f52 false j
  rw [add_val hx.f52 hy.f52] at vs
  have vg := subBig_val' (k := 11) (by norm_num) lb la (by norm_num) (by norm_num) j
  have vh := addRaw_val' la lb (by norm_num) j
  have ve := subBig_val' (k := 12) (by norm_num) ls lh (by norm_num) (by norm_num) j
  have vn := subBig_val' (k := 12) (by norm_num) Fe.zero_le lh (by norm_num) (by norm_num) j
  have vc := addRaw_val' lc lc (by norm_num) j
  have vf := subBig_val' (k := 11) (by norm_num) (carry_carried
    (subBig (sqr P.y false) (sqr P.x false) 11)).f52 (addRaw_le' lc lc (by norm_num))
    (by norm_num) (by norm_num) j
  simp only [Point.Ext, Point.dbl, ↓reduceIte, zipWith_sub_bigP, mul_carry_val, carry_val, vg, vh,
    ve, vn, vc, vf, vs, sqr_val hx.f52, sqr_val hy.f52, sqr_val hz.f52, Fe.zero_val]
  refine isExt_congr hE ?_ ?_ ?_ ?_ <;> ring

/-- `X, Y, Z` do not depend on `withT`. -/
theorem Point.dbl_xyz (P : Point) (withT : Bool) (t0 : Fe) :
    (P.dbl withT t0).x = (P.dbl true t0).x ∧ (P.dbl withT t0).y = (P.dbl true t0).y ∧
      (P.dbl withT t0).z = (P.dbl true t0).z :=
  ⟨rfl, rfl, rfl⟩

/-- `Proj` of equal `X, Y, Z`. -/
theorem Point.Proj.congr {P P' : Point} {j : Fin 8} {Q : Ed25519.Point} (h : P.Proj j Q)
    (e : P'.x = P.x ∧ P'.y = P.y ∧ P'.z = P.z) : P'.Proj j Q := by
  obtain ⟨ex, ey, ez⟩ := e
  rw [Point.Proj, ex, ey, ez]
  exact h

public theorem Point.dbl_proj {P : Point} {j : Fin 8} {Q : Ed25519.Point} (h : P.Proj j Q)
    (hb : P.CarriedXYZ) (withT : Bool) (t0 : Fe) : (P.dbl withT t0).Proj j (Q + Q) :=
  (Point.dbl_ext h hb t0).proj.congr (Point.dbl_xyz P withT t0)

public theorem Point.dbl_carriedXYZ {P : Point} (_hb : P.CarriedXYZ) (withT : Bool) (t0 : Fe) :
    (P.dbl withT t0).CarriedXYZ :=
  ⟨mul_carry_carried _ _, mul_carry_carried _ _, mul_carry_carried _ _⟩

public theorem Point.dbl_carried {P : Point} (hb : P.CarriedXYZ) (t0 : Fe) :
    (P.dbl true t0).Carried :=
  ⟨Point.dbl_carriedXYZ hb true t0, mul_carry_carried _ _⟩

/-- Without `T`, the destination's `t` stays. -/
public theorem Point.dbl_t (P : Point) (t0 : Fe) : (P.dbl false t0).t = t0 :=
  rfl

/-! ## Addition -/

/-- `fd_ed25519_lane_point_add_fin` of loose `a, b, c, d`: `(B - A, 2D - C, 2D + C, B + A)`'s
products. -/
theorem Point.addFin_vals {a b c d : Fe} (ha : a.Loose) (hb : b.Loose) (hc : c.Loose)
    (hd : d.Loose) (t0 : Fe) (j : Fin 8) :
    let P := Point.addFin a b c d true t0
    let A := a.val j; let B := b.val j; let C := c.val j; let D := d.val j + d.val j
    P.x.val j = (B - A) * (D - C) ∧ P.y.val j = (D + C) * (B + A) ∧
      P.z.val j = (D - C) * (D + C) ∧ P.t.val j = (B - A) * (B + A) := by
  have ld := addRaw_le' hd hd (by norm_num)
  have ve := subBig_val' (k := 11) (by norm_num) hb ha (by norm_num) (by norm_num) j
  have vh := addRaw_val' hb ha (by norm_num) j
  have vd := addRaw_val' hd hd (by norm_num) j
  have vf := subBig_val' (k := 11) (by norm_num) ld hc (by norm_num) (by norm_num) j
  have vg := addRaw_val' ld hc (by norm_num) j
  simp only [Point.addFin, ↓reduceIte, mul_carry_val, ve, vh, vd, vf, vg]
  trivial

public theorem Point.addQ_ext {P : Point} {j : Fin 8} {Q₁ Q₂ : Ed25519.Point} {qp qm qk qz : Fe}
    {affine : Bool} (h : P.Ext j Q₁) (hb : P.Carried)
    (hq : Operand qp qm qk (if affine then Fe.one else qz) j Q₂) (hqb : qp.F52 ∧ qm.F52 ∧ qk.F52)
    (hz : affine = false → qz.F52) (t0 : Fe) :
    (P.addQ qp qm qk qz affine true t0).Ext j (Q₁ + Q₂) := by
  obtain ⟨⟨hx, hy, hz1⟩, ht⟩ := hb
  obtain ⟨hp, hm, hk⟩ := hqb
  obtain ⟨X, Y, T, Z, hE, ep, em, ek, ez⟩ := hq
  have hs : (sub P.y P.x).Carried := carry_carried _
  have ha : (Lane.add P.y P.x).Carried := carry_carried _
  -- `d`, the operand's `Z` folded in
  have hd : (if affine then P.z else mul P.z qz false).Loose ∧
      (if affine then P.z else mul P.z qz false).val j = P.z.val j * Z := by
    rw [← ez]
    cases affine <;> simp only [Bool.false_eq_true, ↓reduceIte, Fe.one_val, mul_one]
    · exact ⟨mul_loose hz1.f52 (hz rfl), mul_val hz1.f52 (hz rfl) false j⟩
    · exact ⟨hz1.f52.loose, trivial⟩
  obtain ⟨vx, vy, vz, vt⟩ := Point.addFin_vals (mul_loose hs.f52 hm) (mul_loose ha.f52 hp)
    (mul_loose ht.f52 hk) hd.1 t0 j
  simp only [mul_val hs.f52 hm, mul_val ha.f52 hp, mul_val ht.f52 hk, hd.2,
    sub_val hy.f52 hx.f52, add_val hy.f52 hx.f52, em, ep, ek] at vx vy vz vt
  have hS := _root_.Ed25519.isExt_add h hE Q₁.on Q₂.on rfl rfl rfl rfl
  dsimp only at hS
  rw [Point.Ext, Point.addQ, vx, vy, vz, vt]
  refine isExt_congr hS ?_ ?_ ?_ ?_ <;> ring

/-- `X, Y, Z` do not depend on `withT`. -/
theorem Point.addQ_xyz (P : Point) (qp qm qk qz : Fe) (affine withT : Bool) (t0 : Fe) :
    let R := P.addQ qp qm qk qz affine withT t0
    let R' := P.addQ qp qm qk qz affine true t0
    R.x = R'.x ∧ R.y = R'.y ∧ R.z = R'.z :=
  ⟨rfl, rfl, rfl⟩

/-- The complete addition of `P` in extended coordinates and an operand (`z = 1` when `affine`). -/
public theorem Point.addQ_proj {P : Point} {j : Fin 8} {Q₁ Q₂ : Ed25519.Point} {qp qm qk qz : Fe}
    {affine : Bool} (h : P.Ext j Q₁) (hb : P.Carried)
    (hq : Operand qp qm qk (if affine then Fe.one else qz) j Q₂) (hqb : qp.F52 ∧ qm.F52 ∧ qk.F52)
    (hz : affine = false → qz.F52) (withT : Bool) (t0 : Fe) :
    (P.addQ qp qm qk qz affine withT t0).Proj j (Q₁ + Q₂) :=
  (Point.addQ_ext h hb hq hqb hz t0).proj.congr (Point.addQ_xyz P qp qm qk qz affine withT t0)

public theorem Point.addQ_carriedXYZ {P : Point} {qp qm qk qz : Fe} {affine : Bool}
    (_hb : P.Carried) (_hqb : qp.F52 ∧ qm.F52 ∧ qk.F52) (_hz : affine = false → qz.F52)
    (withT : Bool) (t0 : Fe) : (P.addQ qp qm qk qz affine withT t0).CarriedXYZ :=
  ⟨mul_carry_carried _ _, mul_carry_carried _ _, mul_carry_carried _ _⟩

public theorem Point.addQ_carried {P : Point} {qp qm qk qz : Fe} {affine : Bool}
    (hb : P.Carried) (hqb : qp.F52 ∧ qm.F52 ∧ qk.F52) (hz : affine = false → qz.F52) (t0 : Fe) :
    (P.addQ qp qm qk qz affine true t0).Carried :=
  ⟨Point.addQ_carriedXYZ hb hqb hz true t0, mul_carry_carried _ _⟩

public theorem Point.addQ_t (P : Point) (qp qm qk qz : Fe) (affine : Bool) (t0 : Fe) :
    (P.addQ qp qm qk qz affine false t0).t = t0 :=
  rfl

/-! ## The table form -/

public theorem Point.toNiels_is {P : Point} {j : Fin 8} {Q : Ed25519.Point} {k2d : Fe}
    (h : P.Ext j Q) (hb : P.Carried) (hk : k2d.val j = 2 * d) (hkb : k2d.F52) :
    (P.toNiels k2d).Is j Q := by
  obtain ⟨⟨hx, hy, -⟩, ht⟩ := hb
  refine ⟨⟨_, _, _, _, h, add_val hy.f52 hx.f52 j, sub_val hy.f52 hx.f52 j, ?_, rfl⟩,
    neg_val (mul_carried ht.f52 hkb) j⟩
  simp only [Point.toNiels]
  rw [mul_val ht.f52 hkb, hk]
  ring

public theorem Point.toNiels_bounded {P : Point} {k2d : Fe} (hb : P.Carried) (hkb : k2d.F52) :
    (P.toNiels k2d).Bounded :=
  ⟨carry_carried _, carry_carried _, mul_carried hb.2.f52 hkb, neg_f52 (mul_carried hb.2.f52 hkb),
    hb.1.2.2⟩

end MLIR.Firedancer.Lane
