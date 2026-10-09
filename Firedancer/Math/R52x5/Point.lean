module

public import Firedancer.Math.Curve
public import Firedancer.Math.R52x5.Fe
public import Firedancer.R52x5.fd_curve25519_into_precomputed
public import Firedancer.R52x5.fd_ed25519_point_neg
import Firedancer.Math.Ext
import Firedancer.Math.Avx512.Mul
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

/-! Points as `FD_R52X5_QUAD`s: the four field elements' values and limb ranges, the coordinate
forms the point operations take and give, and the QUAD macros as operations on them. -/

namespace MLIR.Firedancer.R52x5

open MLIR.Firedancer.Ref (p)
open Firedancer.Avx512 (madd52lo madd52hi)
open Firedancer.Avx512.R43x6 (madd52lo_lt madd52hi_lt madd52lo_toNat madd52_split)

/-! ## Definitions -/

@[expose] public section

namespace Quad5

/-- The field element of coordinate `j` (`X, Y, Z, T`). -/
abbrev val (Q : Quad5) (j : Fin 4) : ZMod p :=
  Ref.Limbs.val (Q.elem j)

/-- Every limb below `2^n`; `Below 52` is what `FD_R52X5_QUAD_REDUCE` gives. -/
abbrev Below (n : ℕ) (Q : Quad5) : Prop :=
  ∀ j i, (Q.elem j i).toNat < 2 ^ n

/-- Coordinate `j` has value `v j` and limbs at most `b j`. -/
def Is (Q : Quad5) (v : Fin 4 → ZMod p) (b : Fin 4 → ℕ) : Prop :=
  ∀ j, Q.val j = v j ∧ ∀ i, (Q.elem j i).toNat ≤ b j

/-- `Q` is `(x, y)` in projective coordinates, `T` ignored. -/
abbrev Proj (Q : Quad5) (x y : ZMod p) : Prop :=
  Q.toPoint.Proj x y

/-- `Q` is `(x, y)` in extended coordinates `(X, Y, Z, T)`. -/
abbrev Ext (Q : Quad5) (x y : ZMod p) : Prop :=
  Q.toPoint.Ext x y

/-- `Q` is `(x, y)` precomputed, as `FD_R52X5_TO_TABLE` and the base table give it:
`(Y - X, Y + X, 2 Z, 2d T)` of extended coordinates (`121666` absorbed into them). -/
def Pre (Q : Quad5) (x y : ZMod p) : Prop :=
  ∃ X Y T Z,
    Ref.Ed25519.IsExt x y X Y T Z ∧
      Q.val 0 = Y - X ∧ Q.val 1 = Y + X ∧ Q.val 2 = 2 * Z ∧ Q.val 3 = 2 * Ref.Ed25519.d * T

/-- `Q` is `(x, y)` as `add_with_opts`' second operand: extended for `pre = 0`, else
precomputed. -/
def Operand (Q : Quad5) (pre : BitVec 32) (x y : ZMod p) : Prop :=
  if pre = 0 then Q.Ext x y else Q.Pre x y

/-- `Q` is the affine point `(x, y)`: elements `(x, y, 1, x y)`. -/
def Affine (Q : Quad5) (x y : ZMod p) : Prop :=
  Q.val 0 = x ∧ Q.val 1 = y ∧ Q.val 2 = 1 ∧ Q.val 3 = x * y

/-- Imm `k` of a `PERMUTE`, mod 4 as `wl_permute` reads it. -/
def sel (i0 i1 i2 i3 : ℕ) (k : Fin 4) : Fin 4 :=
  ⟨![i0, i1, i2, i3] k % 4, Nat.mod_lt _ (by decide)⟩

end Quad5

end

/-! ## Coordinates -/

namespace Quad5

public theorem ext_iff_isExt {Q : Quad5} {x y : ZMod p} :
    Q.Ext x y ↔ Ref.Ed25519.IsExt x y (Q.val 0) (Q.val 1) (Q.val 3) (Q.val 2) :=
  Iff.rfl

public theorem proj_iff {Q : Quad5} {x y : ZMod p} :
    Q.Proj x y ↔ Q.val 2 ≠ 0 ∧ Q.val 0 = x * Q.val 2 ∧ Q.val 1 = y * Q.val 2 :=
  Iff.rfl

/-- Extended coordinates are projective ones. -/
public theorem Ext.proj {Q : Quad5} {x y : ZMod p} (h : Q.Ext x y) : Q.Proj x y :=
  ⟨h.1, h.2.1, h.2.2.1⟩

public theorem elem_0 (Q : Quad5) (j : Fin 4) : Q.elem j 0 = Q.P0[j] :=
  rfl

public theorem elem_1 (Q : Quad5) (j : Fin 4) : Q.elem j 1 = Q.P1[j] :=
  rfl

public theorem elem_2 (Q : Quad5) (j : Fin 4) : Q.elem j 2 = Q.P2[j] :=
  rfl

public theorem elem_3 (Q : Quad5) (j : Fin 4) : Q.elem j 3 = Q.P3[j] :=
  rfl

public theorem elem_4 (Q : Quad5) (j : Fin 4) : Q.elem j 4 = Q.P4[j] :=
  rfl

public theorem Is.val {Q : Quad5} (h : Q.Is v b) (j : Fin 4) : Q.val j = v j :=
  (h j).1

public theorem Is.le {Q : Quad5} (h : Q.Is v b) (j : Fin 4) (i : Fin 5) :
    (Q.elem j i).toNat ≤ b j :=
  (h j).2 i

public theorem Is.below {Q : Quad5} (h : Q.Is v b) (hb : ∀ j, b j < 2 ^ n) : Q.Below n := fun j i =>
  (h.le j i).trans_lt (hb j)

public theorem Is.mono {Q : Quad5} (h : Q.Is v b) (hb : ∀ j, b j ≤ c j) : Q.Is v c := fun j =>
  ⟨h.val j, fun i => (h.le j i).trans (hb j)⟩

/-- A `Below n` quad is its own values, limbs at most `2^n - 1`. -/
public theorem Below.is {Q : Quad5} (h : Q.Below n) : Q.Is Q.val (fun _ => 2 ^ n - 1) := fun j =>
  ⟨rfl, fun i => Nat.le_sub_one_of_lt (h j i)⟩

public theorem Is.congr {Q : Quad5} (h : Q.Is v b) (hv : ∀ j, v j = v' j) (hb : ∀ j, b j ≤ b' j) :
    Q.Is v' b' := fun j => ⟨(h.val j).trans (hv j), fun i => (h.le j i).trans (hb j)⟩

/-! ## `FD_R52X5_QUAD_NEGATE_LAZY` -/

/-- `32 p`'s limbs, `FD_R52X5_QUAD_NEGATE_LAZY`'s bias. -/
def bias32p : Fin 5 → BitVec 64 := fun i => if i = 0 then 0xFFFFFFFFFFFDA0 else 0xFFFFFFFFFFFFE0

theorem val_bias32p : Ref.Limbs.val bias32p = 0 := by
  rw [Ref.Limbs.val_nat,
    show Ref.Limbs.nat bias32p = 32 * p by
      unfold Ref.Limbs.nat; rfl]
  rw [Nat.cast_mul, ZMod.natCast_self, mul_zero]

theorem negateLazy_elem (S : Quad5) (j : Fin 4) (i : Fin 5) :
    S.negateLazy.elem j i = bias32p i - S.elem j i := by
  fin_cases i <;>
    simp [negateLazy, bias32p, elem_0, elem_1, elem_2, elem_3, elem_4, wl_sub_getElem,
      wl_bcast_getElem]

/-- `FD_R52X5_QUAD_NEGATE_LAZY`: `32 p - S`, limbs at most `2^56 - 608` (`32 p`'s low limb). -/
public theorem negateLazy_is {S : Quad5} (h : S.Is v b) (hb : ∀ j, b j ≤ 2 ^ 56 - 608) :
    S.negateLazy.Is (fun j => -v j) (fun _ => 2 ^ 56 - 32) := by
  have hbias (i : Fin 5) : 2 ^ 56 - 608 ≤ (bias32p i).toNat ∧ (bias32p i).toNat ≤ 2 ^ 56 - 32 := by
    fin_cases i <;> decide
  have hs (j : Fin 4) (i : Fin 5) :
    (S.negateLazy.elem j i).toNat + (S.elem j i).toNat = (bias32p i).toNat := by
    have := h.le j i; have := hb j; have := hbias i
    rw [negateLazy_elem, BitVec.toNat_sub]
    omega
  intro j
  refine ⟨?_, fun i => ?_⟩
  · have e := val_of_toNat fun i => (hs j i).symm
    rw [val_bias32p] at e
    show _ = -v j
    rw [← h.val j]
    exact eq_neg_of_add_eq_zero_left e.symm
  · have := hs j i; have := hbias i
    show _ ≤ 2 ^ 56 - 32
    omega

/-! ## `FD_R52X5_QUAD_LANE_IF`, `PERMUTE`, `ADD_FAST` -/

public theorem laneIf_elem (i0 i1 i2 i3 : ℕ) (S T : Quad5) (j : Fin 4) :
    (laneIf i0 i1 i2 i3 S T).elem j = if ![i0, i1, i2, i3] j = 0 then T.elem j else S.elem j := by
  have e (i : Fin 5) :
    ((laneIf i0 i1 i2 i3 S T).limb i)[j] =
      cond (![i0, i1, i2, i3] j != 0) (S.limb i)[j] (T.limb i)[j] := by
    fin_cases j <;> fin_cases i <;> rfl
  funext i
  by_cases h : ![i0, i1, i2, i3] j = 0 <;> simp [elem, e, h]

/-- `FD_R52X5_QUAD_LANE_IF`: coordinate `k` from `S` where `immk ≠ 0`, else from `T`. -/
public theorem laneIf_is {S T : Quad5} (i0 i1 i2 i3 : ℕ) (hS : S.Is v b) (hT : T.Is w c) :
    (laneIf i0 i1 i2 i3 S T).Is (fun j => if ![i0, i1, i2, i3] j = 0 then w j else v j)
      (fun j => if ![i0, i1, i2, i3] j = 0 then c j else b j) := by
  intro j
  have e := laneIf_elem i0 i1 i2 i3 S T j
  by_cases h : ![i0, i1, i2, i3] j = 0
  · simp only [val, e, h, ite_true]
    exact hT j
  · simp only [val, e, h, ite_false]
    exact hS j

public theorem permute_elem (i0 i1 i2 i3 : ℕ) (S : Quad5) (j : Fin 4) :
    (permute i0 i1 i2 i3 S).elem j = S.elem (sel i0 i1 i2 i3 j) := by
  have e (x : Wl) : (wlPermute x i0 i1 i2 i3)[j] = x[sel i0 i1 i2 i3 j] := by
    fin_cases j <;> simp [wlPermute, sel]
  funext i
  fin_cases i <;> exact e _

/-- `FD_R52X5_QUAD_PERMUTE`: coordinate `k` is `S`'s `immk`. -/
public theorem permute_is {S : Quad5} (i0 i1 i2 i3 : ℕ) (hS : S.Is v b) :
    (permute i0 i1 i2 i3 S).Is (fun j => v (sel i0 i1 i2 i3 j))
      (fun j => b (sel i0 i1 i2 i3 j)) := by
  intro j
  simp only [val, permute_elem]
  exact hS (sel i0 i1 i2 i3 j)

public theorem addFast_elem (P Q : Quad5) (j : Fin 4) (i : Fin 5) :
    (addFast P Q).elem j i = P.elem j i + Q.elem j i := by
  fin_cases i <;> simp [addFast, elem_0, elem_1, elem_2, elem_3, elem_4, wl_add_getElem]

/-- `FD_R52X5_QUAD_ADD_FAST`: limbwise sums, no carries. -/
public theorem addFast_is {P Q : Quad5} (hP : P.Is v b) (hQ : Q.Is w c)
    (h : ∀ j, b j + c j < 2 ^ 64) : (addFast P Q).Is (fun j => v j + w j) (fun j => b j + c j) := by
  have hs (j : Fin 4) (i : Fin 5) :
    ((addFast P Q).elem j i).toNat = (P.elem j i).toNat + (Q.elem j i).toNat := by
    have := hP.le j i; have := hQ.le j i; have := h j
    rw [addFast_elem, BitVec.toNat_add, Nat.mod_eq_of_lt (by omega)]
  intro j
  refine ⟨?_, fun i => ?_⟩
  · show _ = v j + w j
    rw [← hP.val j, ← hQ.val j]
    exact val_of_toNat (hs j)
  · have := hP.le j i; have := hQ.le j i
    show _ ≤ b j + c j
    rw [hs]
    omega

end Quad5

/-! ## Carries -/

/-- Limbs carried at bit 51 into the next, limb 4's carry times 19 into limb 0, keep the
value. -/
public theorem val_of_carry {l r : Fin 5 → BitVec 64}
    (h0 : (r 0).toNat = (l 0).toNat % 2 ^ 51 + 19 * ((l 4).toNat / 2 ^ 51))
    (h1 : (r 1).toNat = (l 1).toNat % 2 ^ 51 + (l 0).toNat / 2 ^ 51)
    (h2 : (r 2).toNat = (l 2).toNat % 2 ^ 51 + (l 1).toNat / 2 ^ 51)
    (h3 : (r 3).toNat = (l 3).toNat % 2 ^ 51 + (l 2).toNat / 2 ^ 51)
    (h4 : (r 4).toNat = (l 4).toNat % 2 ^ 51 + (l 3).toNat / 2 ^ 51) :
    Ref.Limbs.val r = Ref.Limbs.val l := by
  have e (y : ℕ) : ((y % 2 ^ 51 : ℕ) : ZMod p) + 2 ^ 51 * (y / 2 ^ 51 : ℕ) = y := by
    exact_mod_cast congrArg (Nat.cast (R := ZMod p)) (Nat.mod_add_div y (2 ^ 51))
  rw [Ref.Limbs.val_eq, Ref.Limbs.val_eq, h0, h1, h2, h3, h4]
  push_cast
  linear_combination
    e (l 0).toNat + 2 ^ 51 * e (l 1).toNat + 2 ^ 102 * e (l 2).toNat + 2 ^ 153 * e (l 3).toNat +
        2 ^ 204 * e (l 4).toNat -
      ((l 4).toNat / 2 ^ 51 : ℕ) * Ref.two_pow_255

/-! ## `FD_R52X5_QUAD_REDUCE` -/

theorem reduce_lane0 (x y : BitVec 64) :
    ((x &&& 2251799813685247#64) + madd52lo (y >>> 51) 19).toNat =
      x.toNat % 2 ^ 51 + 19 * (y.toNat / 2 ^ 51) := by
  have := y.isLt
  have hc : (y >>> 51).toNat = y.toNat / 2 ^ 51 := Ref.toNat_shift y
  rw [BitVec.toNat_add, Ref.toNat_and_mask, madd52lo_toNat (by omega) (by decide), hc,
    show BitVec.toNat (19 : BitVec 64) = 19 from rfl, Nat.mod_eq_of_lt (a := _ * 19) (by omega),
    Nat.mod_eq_of_lt (by omega)]
  ring

theorem reduce_lane (x y : BitVec 64) :
    ((x &&& 2251799813685247#64) + y >>> 51).toNat = x.toNat % 2 ^ 51 + y.toNat / 2 ^ 51 := by
  have := y.isLt
  rw [BitVec.toNat_add, Ref.toNat_and_mask, Ref.toNat_shift, Nat.mod_eq_of_lt (by omega)]

namespace Quad5

/-- `FD_R52X5_QUAD_REDUCE`'s limbs in `ℕ`: the low 51 bits plus the carry of the limb below. -/
public theorem reduce_toNat (S : Quad5) (j : Fin 4) :
    (S.reduce.elem j 0).toNat = (S.elem j 0).toNat % 2 ^ 51 + 19 * ((S.elem j 4).toNat / 2 ^ 51) ∧
      (S.reduce.elem j 1).toNat = (S.elem j 1).toNat % 2 ^ 51 + (S.elem j 0).toNat / 2 ^ 51 ∧
      (S.reduce.elem j 2).toNat = (S.elem j 2).toNat % 2 ^ 51 + (S.elem j 1).toNat / 2 ^ 51 ∧
      (S.reduce.elem j 3).toNat = (S.elem j 3).toNat % 2 ^ 51 + (S.elem j 2).toNat / 2 ^ 51 ∧
      (S.reduce.elem j 4).toNat = (S.elem j 4).toNat % 2 ^ 51 + (S.elem j 3).toNat / 2 ^ 51 := by
  simp only [reduce, elem_0, elem_1, elem_2, elem_3, elem_4, Fin.getElem_fin, wl_madd52lo_getElem,
    wl_add_getElem, wl_and_getElem, wl_shru_getElem, wl_bcast_getElem]
  exact ⟨reduce_lane0 _ _, reduce_lane _ _, reduce_lane _ _, reduce_lane _ _, reduce_lane _ _⟩

/-- `FD_R52X5_QUAD_REDUCE` keeps the values, its limbs at most `2^51 + 2^18` for any input. -/
public theorem reduce_is (S : Quad5) : S.reduce.Is S.val (fun _ => 2 ^ 51 + 2 ^ 18) := by
  intro j
  obtain ⟨h0, h1, h2, h3, h4⟩ := reduce_toNat S j
  refine ⟨val_of_carry h0 h1 h2 h3 h4, fun i => ?_⟩
  have := (S.elem j 0).isLt; have := (S.elem j 1).isLt; have := (S.elem j 2).isLt
  have := (S.elem j 3).isLt; have := (S.elem j 4).isLt
  fin_cases i <;> simp only [Fin.zero_eta, Fin.mk_one, Fin.reduceFinMk, h0, h1, h2, h3, h4] <;>
    omega

public theorem reduce_below (S : Quad5) : S.reduce.Below 52 :=
  (reduce_is S).below fun _ => by norm_num

public theorem Is.reduce {S : Quad5} (h : S.Is v b) : S.reduce.Is v (fun _ => 2 ^ 51 + 2 ^ 18) :=
  (reduce_is S).congr h.val fun _ => le_rfl

/-! ## `FD_R52X5_QUAD_MUL_CONSTANT` -/

theorem mulConstant_elem (S : Quad5) (y : Wl) (j : Fin 4) :
    (S.mulConstant y).elem j 0 =
        madd52lo y[j] (S.elem j 0) +
          madd52lo (madd52hi y[j] (S.elem j 4) + madd52hi y[j] (S.elem j 4)) 19 ∧
      (S.mulConstant y).elem j 1 =
        madd52lo y[j] (S.elem j 1) + madd52hi y[j] (S.elem j 0) + madd52hi y[j] (S.elem j 0) ∧
      (S.mulConstant y).elem j 2 =
        madd52lo y[j] (S.elem j 2) + madd52hi y[j] (S.elem j 1) + madd52hi y[j] (S.elem j 1) ∧
      (S.mulConstant y).elem j 3 =
        madd52lo y[j] (S.elem j 3) + madd52hi y[j] (S.elem j 2) + madd52hi y[j] (S.elem j 2) ∧
      (S.mulConstant y).elem j 4 =
        madd52lo y[j] (S.elem j 4) + madd52hi y[j] (S.elem j 3) + madd52hi y[j] (S.elem j 3) := by
  simp [mulConstant, elem_0, elem_1, elem_2, elem_3, elem_4, wl_madd52lo_getElem,
    wl_madd52hi_getElem, wl_add_getElem, wl_bcast_getElem]

/-- `FD_R52X5_QUAD_MUL_CONSTANT`: coordinate `k` times `y[k]`, for limbs below `2^52` and `y[k]`
below `2^20`; limbs at most `2^53`. -/
public theorem mulConstant_is {S : Quad5} {y : Wl} (h : S.Is v b) (hb : ∀ j, b j < 2 ^ 52)
    (hy : ∀ j : Fin 4, y[j].toNat < 2 ^ 20) :
    (S.mulConstant y).Is (fun j => v j * (y[j].toNat : ZMod p)) (fun _ => 2 ^ 53) := by
  intro j
  obtain ⟨e0, e1, e2, e3, e4⟩ := mulConstant_elem S y j
  have hs (i : Fin 5) : (S.elem j i).toNat < 2 ^ 52 := (h.le j i).trans_lt (hb j)
  have hy' : y[j].toNat < 2 ^ 52 := (hy j).trans (by norm_num)
  have l i := madd52lo_lt y[j] (S.elem j i)
  have k i : (madd52hi y[j] (S.elem j i)).toNat < 2 ^ 20 :=
    madd52hi_lt (m := 20) (n := 52) (hy j) (hs i) (by norm_num) le_rfl
  have l4 :
    (madd52lo (madd52hi y[j] (S.elem j 4) + madd52hi y[j] (S.elem j 4)) 19).toNat =
      38 * (madd52hi y[j] (S.elem j 4)).toNat := by
    have := k 4
    rw [madd52lo_toNat
        (by
          rw [BitVec.toNat_add]; omega)
        (by decide),
      BitVec.toNat_add, show BitVec.toNat (19 : BitVec 64) = 19 from rfl,
      Nat.mod_eq_of_lt (a := _ + _) (by omega), Nat.mod_eq_of_lt (by omega)]
    ring
  have r0 :
    ((S.mulConstant y).elem j 0).toNat =
      (madd52lo y[j] (S.elem j 0)).toNat + 38 * (madd52hi y[j] (S.elem j 4)).toNat := by
    have := l 0; have := k 4
    rw [e0, BitVec.toNat_add, l4, Nat.mod_eq_of_lt (by omega)]
  have ri (a c : Fin 5) :
    (madd52lo y[j] (S.elem j a) + madd52hi y[j] (S.elem j c) + madd52hi y[j] (S.elem j c)).toNat =
      (madd52lo y[j] (S.elem j a)).toNat + 2 * (madd52hi y[j] (S.elem j c)).toNat := by
    have := l a; have := k c
    rw [BitVec.toNat_add, BitVec.toNat_add, Nat.mod_eq_of_lt (by omega),
      Nat.mod_eq_of_lt (by omega)]
    ring
  refine ⟨?_, fun i => ?_⟩
  · have sp i :
      (y[j].toNat : ZMod p) * (S.elem j i).toNat =
        (madd52lo y[j] (S.elem j i)).toNat + 2 ^ 52 * (madd52hi y[j] (S.elem j i)).toNat := by
      rw [← Nat.cast_mul, madd52_split hy' (hs i)]
      push_cast
      ring
    show _ = v j * _
    rw [← h.val j, val, val, Ref.Limbs.val_eq, Ref.Limbs.val_eq, r0, e1, e2, e3, e4, ri, ri, ri, ri]
    push_cast
    linear_combination
      -(sp 0 + 2 ^ 51 * sp 1 + 2 ^ 102 * sp 2 + 2 ^ 153 * sp 3 + 2 ^ 204 * sp 4) -
        2 * ((madd52hi y[j] (S.elem j 4)).toNat : ZMod p) * Ref.two_pow_255
  · show _ ≤ 2 ^ 53
    have := l 0; have := l 1; have := l 2; have := l 3; have := l 4
    have := k 0; have := k 1; have := k 2; have := k 3; have := k 4
    fin_cases i
    · show ((S.mulConstant y).elem j 0).toNat ≤ _; rw [r0]; omega
    · show ((S.mulConstant y).elem j 1).toNat ≤ _; rw [e1, ri]; omega
    · show ((S.mulConstant y).elem j 2).toNat ≤ _; rw [e2, ri]; omega
    · show ((S.mulConstant y).elem j 3).toNat ≤ _; rw [e3, ri]; omega
    · show ((S.mulConstant y).elem j 4).toNat ≤ _; rw [e4, ri]; omega

/-! ## `FD_R52X5_QUAD_DIFF_SUM` -/

/-- `FD_R52X5_QUAD_DIFF_SUM`: `[Y-X, X+Y, T-Z, Z+T]`, for limbs at most `2^56 - 608`. -/
public theorem diffSum_is {S : Quad5} (h : S.Is v b) (hb : ∀ j, b j ≤ 2 ^ 56 - 608) :
    S.diffSum.Is ![v 1 - v 0, v 0 + v 1, v 3 - v 2, v 2 + v 3] (fun _ => 2 ^ 57) := by
  have h2 := laneIf_is 1 0 1 0 (negateLazy_is h hb) h
  have h3 := addFast_is (permute_is 1 0 3 2 h) h2 fun j => by fin_cases j <;> simp [sel] <;> grind
  unfold diffSum
  refine h3.congr (fun j => ?_) (fun j => ?_)
  · fin_cases j <;> simp [sel] <;> ring
  · have := hb 0; have := hb 1; have := hb 2; have := hb 3
    fin_cases j <;> simp [sel] <;> omega

end Quad5

/-! ## Extended coordinates scaled -/

/-- `d = -121665 / 121666`. -/
public theorem d_mul_121666 : Ref.Ed25519.d * 121666 = -121665 := by
  unfold Ref.Ed25519.d
  decide

/-- Extended coordinates scaled by a nonzero `c` are extended coordinates of the same point. -/
public theorem isExt_mul {x y X Y T Z c : ZMod p} (h : Ref.Ed25519.IsExt x y X Y T Z) (hc : c ≠ 0) :
    Ref.Ed25519.IsExt x y (c * X) (c * Y) (c * T) (c * Z) := by
  obtain ⟨hZ, hX, hY, hT⟩ := h
  exact
    ⟨mul_ne_zero hc hZ, by
      rw [hX]; ring, by
      rw [hY]; ring, by linear_combination c ^ 2 * hT⟩

/-! ## `fd_curve25519_into_precomputed` -/

/-- `FD_R52X5_TO_TABLE` lane by lane: `121666 [Y-X, X+Y, 2Z, -2T]`, for limbs at most
`2^56 - 608`; limbs reduced. -/
public theorem fd_curve25519_into_precomputed.spec_is {S : Quad5} (h : S.Is v b)
    (hb : ∀ j, b j ≤ 2 ^ 56 - 608) :
    (fd_curve25519_into_precomputed.spec S).Is
      ![121666 * (v 1 - v 0), 121666 * (v 0 + v 1), 2 * 121666 * v 2, -(2 * 121665 * v 3)]
      (fun _ => 2 ^ 51 + 2 ^ 18) := by
  have h1 := (Quad5.laneIf_is 1 1 0 0 (Quad5.diffSum_is h hb) h).reduce
  have h2 :=
    Quad5.mulConstant_is (y := wl 121666 121666 (2 * 121666) (2 * 121665)) h1 (fun _ => by norm_num)
      (fun j => by fin_cases j <;> decide)
  have h3 := (Quad5.laneIf_is 0 0 0 1 (Quad5.negateLazy_is h2 fun _ => by norm_num) h2).reduce
  refine h3.congr (fun j => ?_) (fun _ => le_rfl)
  fin_cases j <;> simp [wl] <;> ring

/-- `fd_curve25519_into_precomputed` turns an extended `B(52)` point into a precomputed one, its
coordinates scaled by `121666`. -/
public theorem fd_curve25519_into_precomputed.spec_pre {S : Quad5} {x y : ZMod p} (hS : S.Ext x y)
    (hb : S.Below 52) :
    (fd_curve25519_into_precomputed.spec S).Pre x y ∧
      (fd_curve25519_into_precomputed.spec S).Below 52 := by
  have h := spec_is hb.is fun _ => by norm_num
  refine
    ⟨⟨121666 * S.val 0, 121666 * S.val 1, 121666 * S.val 3, 121666 * S.val 2,
        isExt_mul hS (by decide), ?_, ?_, ?_, ?_⟩,
      h.below fun _ => by norm_num⟩
  · rw [h.val 0]; simp; ring
  · rw [h.val 1]; simp; ring
  · rw [h.val 2]; simp; ring
  · rw [h.val 3]
    simp only [Matrix.cons_val]
    linear_combination (-2 * S.val 3) * d_mul_121666

/-! ## `fd_ed25519_point_neg` -/

/-- `fd_ed25519_point_neg` lane by lane: `X` and `T` negated and reduced, for limbs at most
`2^56 - 608`. -/
public theorem fd_ed25519_point_neg.spec_is {A : Quad5} (h : A.Is v b)
    (hb : ∀ j, b j ≤ 2 ^ 56 - 608) :
    (fd_ed25519_point_neg.spec A).Is ![-v 0, v 1, v 2, -v 3]
      (fun j => max (b j) (2 ^ 51 + 2 ^ 18)) := by
  have h1 := Quad5.laneIf_is 1 0 0 1 (Quad5.negateLazy_is h hb).reduce h
  refine h1.congr (fun j => ?_) (fun j => ?_) <;> fin_cases j <;> simp

/-- `fd_ed25519_point_neg` negates an extended `B(52)` point. -/
public theorem fd_ed25519_point_neg.spec_ext {A : Quad5} {x y : ZMod p} (hA : A.Ext x y)
    (hb : A.Below 52) :
    (fd_ed25519_point_neg.spec A).Ext (-x) y ∧ (fd_ed25519_point_neg.spec A).Below 52 := by
  have h := spec_is hb.is fun _ => by norm_num
  refine ⟨?_, h.below fun _ => by norm_num⟩
  have := Ref.Ed25519.isExt_neg (Quad5.ext_iff_isExt.1 hA)
  rw [Quad5.ext_iff_isExt, h.val 0, h.val 1, h.val 2, h.val 3]
  simpa using this

end MLIR.Firedancer.R52x5
