module

public import Firedancer.Math.Curve
public import Firedancer.Math.Avx512.QuadBound
public import Firedancer.Math.Avx512.Reduce
public import Firedancer.Avx512.Common.Point
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring
import Std.Tactic.BVDecide

/-! Points as `FD_R43X6_QUAD`s: the field elements `X, Y, Z, T` an `fd_ed25519_point_t` holds, the
coordinate forms the point operations take and give (projective, extended, precomputed), and the
QUAD lane operations (`PERMUTE`, `LANE_ADD_FAST`, `LANE_SUB_FAST`, the folds, `MUL_FAST`,
`SQR_FAST`) as operations on the four elements' values and limb ranges. -/

namespace LeanMLIR.RIR.Firedancer.Avx512

open LeanMLIR.RIR.Firedancer.Ref (p)
open R43x6 (quadElem)

/-! ## Definitions -/

@[expose] public section

namespace Quad

/-- Element `j` of `Q`, `X, Y, Z, T` for `j = 0 … 3`, as `FD_R43X6_QUAD_UNPACK` gives it. -/
abbrev elem (Q : Quad) (j : ℕ) : Wwl :=
  quadElem Q.P03 Q.P14 Q.P25 j

/-- The field element of element `j`. -/
abbrev val (Q : Quad) (j : ℕ) : ZMod p :=
  R43x6.val (Q.elem j)

/-- `Q` is `(x, y)` in projective coordinates, `T` ignored: `x = X/Z`, `y = Y/Z`. -/
def Proj (Q : Quad) (x y : ZMod p) : Prop :=
  Q.val 2 ≠ 0 ∧ Q.val 0 = x * Q.val 2 ∧ Q.val 1 = y * Q.val 2

/-- `Q` is `(x, y)` in extended coordinates `(X, Y, Z, T)`. -/
def Ext (Q : Quad) (x y : ZMod p) : Prop :=
  Ref.Ed25519.IsExt x y (Q.val 0) (Q.val 1) (Q.val 3) (Q.val 2)

/-- `Q` is `(x, y)` precomputed, as `into_precomputed` and the base table give it and
`FD_R43X6_GE_ADD_TABLE_ALT` takes it: `(Y - X, Y + X, Z, 2d T)` of extended coordinates. -/
def Pre (Q : Quad) (x y : ZMod p) : Prop :=
  ∃ X Y T Z, Ref.Ed25519.IsExt x y X Y T Z ∧ Q.val 0 = Y - X ∧ Q.val 1 = Y + X ∧ Q.val 2 = Z ∧
    Q.val 3 = 2 * Ref.Ed25519.d * T

/-- `Q` is `(x, y)` as `add_with_opts`' second operand: precomputed for a nonzero `pre`, else
extended. -/
def Operand (Q : Quad) (pre : BitVec 32) (x y : ZMod p) : Prop :=
  if pre = 0 then Q.Ext x y else Q.Pre x y

/-- `Q` is the affine point `(x, y)`: elements `(x, y, 1, x y)`, as decoding gives it. -/
def Affine (Q : Quad) (x y : ZMod p) : Prop :=
  Q.val 0 = x ∧ Q.val 1 = y ∧ Q.val 2 = 1 ∧ Q.val 3 = x * y

/-- Every element folded: the range the point operations give. -/
abbrev Folded (Q : Quad) : Prop :=
  ∀ j < 4, R43x6.Folded (Q.elem j)

/-- Every element's limbs in `[0, 2^n)`. -/
abbrev Unsigned (n : ℕ) (Q : Quad) : Prop :=
  ∀ j < 4, R43x6.Unsigned n (Q.elem j)

end Quad

/-- Limbs as longs in `[lo, hi]`. -/
abbrev R43x6.In (lo hi : ℤ) (x : Wwl) : Prop :=
  ∀ i : Fin 6, lo ≤ x[(i : ℕ)].toInt ∧ x[(i : ℕ)].toInt ≤ hi

/-- Element `j` of `Q` has value `v j` and limbs in `[lo j, hi j]`. -/
def Quad.Is (Q : Quad) (v : Fin 4 → ZMod p) (lo hi : Fin 4 → ℤ) : Prop :=
  ∀ j : Fin 4, R43x6.val (Q.elem j) = v j ∧ R43x6.In (lo j) (hi j) (Q.elem j)

end

/-! ## The QUAD operations on elements -/

public section

namespace Quad

/-- An element's lanes: limbs 0-2 in lane `j`, limbs 3-5 in lane `j + 4`, then zeros. -/
theorem elem_eq (Q : Quad) (j : Fin 4) :
    Q.elem j = #v[Q.P03[(j : ℕ)], Q.P14[(j : ℕ)], Q.P25[(j : ℕ)], Q.P03[(j : ℕ) + 4],
      Q.P14[(j : ℕ) + 4], Q.P25[(j : ℕ) + 4], 0, 0] := by
  simp only [elem, quadElem, getElem!_pos, show (j : ℕ) + 4 < 8 by omega,
    show (j : ℕ) < 8 by omega]

/-- `elem_eq` at a natural index. -/
theorem elem_eq_nat (Q : Quad) (j : ℕ) (hj : j < 4) :
    Q.elem j = #v[Q.P03[j], Q.P14[j], Q.P25[j], Q.P03[j + 4], Q.P14[j + 4], Q.P25[j + 4], 0, 0] :=
  elem_eq Q ⟨j, hj⟩

/-- `FD_R43X6_QUAD_UNPACK`'s `X, Y, Z, T` are elements `0 … 3`. -/
theorem X_eq (Q : Quad) : Q.X = Q.elem 0 :=
  (elem_eq Q 0).symm

theorem Y_eq (Q : Quad) : Q.Y = Q.elem 1 :=
  (elem_eq Q 1).symm

theorem Z_eq (Q : Quad) : Q.Z = Q.elem 2 :=
  (elem_eq Q 2).symm

theorem T_eq (Q : Quad) : Q.T = Q.elem 3 :=
  (elem_eq Q 3).symm

/-- `FD_R43X6_QUAD_PERMUTE`: element `j` is element `ij` of `S`. -/
theorem elem_permute (S : Quad) (i0 i1 i2 i3 j : Fin 4) :
    (S.permute i0 i1 i2 i3).elem j = S.elem (![i0, i1, i2, i3] j) := by
  have e (x : Wwl) (i : Fin 4) : x[(i : ℕ) % 8]?.getD 0#64 = x[(i : ℕ)] ∧
      x[(4 + (i : ℕ)) % 8]?.getD 0#64 = x[(i : ℕ) + 4] := by
    constructor
    · rw [Nat.mod_eq_of_lt (by omega), R43x6.getD_get _ _ (by omega)]
    · rw [Nat.mod_eq_of_lt (by omega), Nat.add_comm, R43x6.getD_get _ _ (by omega)]
  rw [elem_eq, elem_eq]
  fin_cases j <;>
    simp [permute, R43x6.wwl_permute_get, R43x6.wwl_get0, R43x6.wwl_get1, R43x6.wwl_get2,
      R43x6.wwl_get3, R43x6.wwl_get4, R43x6.wwl_get5, R43x6.wwl_get6, R43x6.wwl_get7, e]

/-- `FD_R43X6_QUAD_LANE_ADD_FAST`: `P + Q` in the elements the mask selects, `S` in the others. -/
theorem elem_laneAddFast (S P Q : Quad) (i0 i1 i2 i3 : ℕ) (j : Fin 4)
    (hm : (quadMask i0 i1 i2 i3).getLsbD ((j : ℕ) + 4) = (quadMask i0 i1 i2 i3).getLsbD j) :
    (S.laneAddFast i0 i1 i2 i3 P Q).elem j =
      if (quadMask i0 i1 i2 i3).getLsbD j then fd_r43x6_add_fast (P.elem j) (Q.elem j)
      else S.elem j := by
  rw [elem_eq, elem_eq, elem_eq, elem_eq]
  split <;> rename_i hc <;> ext k hk : 1 <;>
    match k, hk with
    | 0, _ | 1, _ | 2, _ | 3, _ | 4, _ | 5, _ | 6, _ | 7, _ =>
      simp [laneAddFast, R43x6.wwv_add_if_get, R43x6.add_fast_get, hm, hc]

/-- `p`'s limbs in each element, as `fd_r43x6_p()`. -/
theorem quadP_elem (j : Fin 4) : quadP.elem j = fd_r43x6_p := by
  rw [elem_eq]
  fin_cases j <;> rfl

/-- `FD_R43X6_QUAD_LANE_SUB_FAST`: `P + (p - Q)` in the elements the mask selects, `S` in the
others. -/
theorem elem_laneSubFast (S P Q : Quad) (i0 i1 i2 i3 : ℕ) (j : Fin 4)
    (hm : (quadMask i0 i1 i2 i3).getLsbD ((j : ℕ) + 4) = (quadMask i0 i1 i2 i3).getLsbD j) :
    (S.laneSubFast i0 i1 i2 i3 P Q).elem j =
      if (quadMask i0 i1 i2 i3).getLsbD j then fd_r43x6_sub_fast (P.elem j) (Q.elem j)
      else S.elem j := by
  have e : (⟨wwl_sub quadP.P03 Q.P03, wwl_sub quadP.P14 Q.P14, wwl_sub quadP.P25 Q.P25⟩ :
      Quad).elem j = wwl_sub fd_r43x6_p (Q.elem j) := by
    rw [← quadP_elem j, elem_eq, elem_eq, elem_eq]
    ext k hk : 1
    match k, hk with
    | 0, _ | 1, _ | 2, _ | 3, _ | 4, _ | 5, _ | 6, _ | 7, _ => simp [R43x6.wwl_sub_get]
  rw [laneSubFast, elem_laneAddFast _ _ _ _ _ _ _ _ hm, e]
  rfl

/-! Lanes of the folds. -/

theorem wwl_shru_get (x : Wwl) (n i : ℕ) (h : i < 8) : (wwl_shru x n)[i] = x[i] >>> n := by
  simp [wwl_shru]

theorem wwl_shr_get (x : Wwl) (n i : ℕ) (h : i < 8) : (wwl_shr x n)[i] = x[i].sshiftRight n := by
  simp [wwl_shr]

theorem fold_get0 (u : Wwl) :
    (fold u)[0] = (u[0] &&& 8796093022207#64) + (19#64 * (u[5] >>> 40) &&& 4503599627370495#64) :=
  (R43x6.fold_get u).1
theorem fold_get1 (u : Wwl) :
    (fold u)[1] = (u[1] &&& 8796093022207#64) + (u[0] >>> 43 &&& 4503599627370495#64) :=
  (R43x6.fold_get u).2.1
theorem fold_get2 (u : Wwl) :
    (fold u)[2] = (u[2] &&& 8796093022207#64) + (u[1] >>> 43 &&& 4503599627370495#64) :=
  (R43x6.fold_get u).2.2.1
theorem fold_get3 (u : Wwl) :
    (fold u)[3] = (u[3] &&& 8796093022207#64) + (u[2] >>> 43 &&& 4503599627370495#64) :=
  (R43x6.fold_get u).2.2.2.1
theorem fold_get4 (u : Wwl) :
    (fold u)[4] = (u[4] &&& 8796093022207#64) + (u[3] >>> 43 &&& 4503599627370495#64) :=
  (R43x6.fold_get u).2.2.2.2.1
theorem fold_get5 (u : Wwl) :
    (fold u)[5] = (u[5] &&& 1099511627775#64) + (u[4] >>> 43 &&& 4503599627370495#64) :=
  (R43x6.fold_get u).2.2.2.2.2.1
theorem fold_get6 (u : Wwl) : (fold u)[6] = 0 :=
  (R43x6.fold_get u).2.2.2.2.2.2.1
theorem fold_get7 (u : Wwl) : (fold u)[7] = 0 :=
  (R43x6.fold_get u).2.2.2.2.2.2.2

theorem shr43_and (x : BitVec 64) : x >>> 43 &&& 4503599627370495#64 = x >>> 43 := by
  bv_decide

theorem shr40_mul19 (x : BitVec 64) :
    19#64 * (x >>> 40) &&& 4503599627370495#64 = x >>> 40 + (x >>> 40 <<< 1 + x >>> 40 <<< 4) := by
  bv_decide

/-- The `getElem` subterms of `e`. -/
meta partial def getElemTerms (e : Lean.Expr) (acc : Array Lean.Expr) : Array Lean.Expr :=
  let acc := if e.isAppOfArity ``GetElem.getElem 8 then acc.push e else acc
  match e with
  | .app f a => getElemTerms a (getElemTerms f acc)
  | .mdata _ b => getElemTerms b acc
  | _ => acc

open Lean Meta Elab Tactic in
/-- `generalize_lanes`: each vector lane in the goal as a fresh variable, lanes equal up to their
instances as one. -/
elab "generalize_lanes" : tactic => do
  for t in getElemTerms (← instantiateMVars (← getMainTarget)) #[] do
    let g ← getMainGoal
    let s ← saveState
    try
      let (_, g') ← g.generalize #[{ expr := t }]
      replaceMainGoal [g']
    catch _ => s.restore

set_option hygiene false in
/-- An element equation lane by lane: each lane unfolded to the input lanes. -/
local macro "elem_lanes" : tactic =>
  `(tactic| (
    obtain ⟨j, hj⟩ := j
    simp only [elem_eq_nat _ _ hj]
    ext k hk : 1
    match j, hj, k, hk with
    | 0, _, 0, _ | 0, _, 1, _ | 0, _, 2, _ | 0, _, 3, _ | 0, _, 4, _ | 0, _, 5, _ | 0, _, 6, _
    | 0, _, 7, _ | 1, _, 0, _ | 1, _, 1, _ | 1, _, 2, _ | 1, _, 3, _ | 1, _, 4, _ | 1, _, 5, _
    | 1, _, 6, _ | 1, _, 7, _ | 2, _, 0, _ | 2, _, 1, _ | 2, _, 2, _ | 2, _, 3, _ | 2, _, 4, _
    | 2, _, 5, _ | 2, _, 6, _ | 2, _, 7, _ | 3, _, 0, _ | 3, _, 1, _ | 3, _, 2, _ | 3, _, 3, _
    | 3, _, 4, _ | 3, _, 5, _ | 3, _, 6, _ | 3, _, 7, _ =>
      simp only [Vector.getElem_mk, List.getElem_toArray,
        List.getElem_cons_zero, List.getElem_cons_succ, Nat.reduceLT, Nat.reduceAdd, fold_get0,
        fold_get1, fold_get2, fold_get3, fold_get4, fold_get5, fold_get6, fold_get7,
        R43x6.wwl_add_get, R43x6.wwl_sub_get, R43x6.wwl_and_get, R43x6.wwl_shl_get,
        R43x6.wwl_shr_vector_get, R43x6.wwl_shru_vector_get, R43x6.wwl_pack_halves_get,
        R43x6.wwl_bcast_get, R43x6.wwl_get0, R43x6.wwl_get1, R43x6.wwl_get2, R43x6.wwl_get3,
        R43x6.wwl_get4, R43x6.wwl_get5, R43x6.wwl_get6, R43x6.wwl_get7, R43x6.getD_get,
        BitVec.reduceToNat, Nat.reduceMod, Nat.reduceMul, Nat.reduceSub, ite_true, ite_false,
        foldUnsigned, foldSigned, wwl_shru_get, wwl_shr_get, m43, m40, shr43_and, shr40_mul19]
      try (generalize_lanes; bv_decide)))

-- the lane `simp` set is shared by all lanes, each using part of it
set_option linter.unusedSimpArgs false in
/-- `FD_R43X6_QUAD_FOLD_UNSIGNED` is `fd_r43x6_fold_unsigned` on each element. -/
theorem elem_foldUnsigned (P : Quad) (j : Fin 4) : P.foldUnsigned.elem j = fold (P.elem j) := by
  elem_lanes

-- the lane `simp` set is shared by all lanes, each using part of it
set_option linter.unusedSimpArgs false in
/-- `FD_R43X6_QUAD_FOLD_SIGNED` is `fd_r43x6_fold_signed` on each element. -/
theorem elem_foldSigned (P : Quad) (j : Fin 4) :
    P.foldSigned.elem j = fd_r43x6_fold_signed (P.elem j) := by
  rw [R43x6.fd_r43x6_fold_signed_eq, foldSignedBias]
  elem_lanes

end Quad

/-! ## Limb ranges -/

namespace R43x6

/-- A wider range. -/
theorem In.mono {x : Wwl} (h : In lo hi x) (h1 : lo' ≤ lo) (h2 : hi ≤ hi') : In lo' hi' x :=
  fun i => ⟨h1.trans (h i).1, (h i).2.trans h2⟩

/-- Limbs in `[0, 2^n)` as longs. -/
theorem In.of_unsigned {x : Wwl} (h : Unsigned n x) (hn : n ≤ 63) : In 0 (2 ^ n - 1) x := by
  intro i
  have := h i
  have : 2 ^ n ≤ 2 ^ 63 := Nat.pow_le_pow_right (by decide) hn
  have e : ((2 ^ n : ℕ) : ℤ) = 2 ^ n := by push_cast; rfl
  rw [toInt_of_lt (by omega)]
  omega

/-- Nonnegative limbs below `2^n` are unsigned. -/
theorem In.unsigned {x : Wwl} (h : In 0 hi x) (hhi : hi < 2 ^ n) : Unsigned n x := by
  intro i
  have := toNat_of_toInt_nonneg (h i).1
  have := (h i).2
  exact_mod_cast (show (x[(i : ℕ)].toNat : ℤ) < 2 ^ n by omega)

/-- Folded limbs are in `[0, 2^44)`. -/
theorem Folded.in {x : Wwl} (h : Folded x) : In 0 (2 ^ 44 - 1) x :=
  In.of_unsigned h.unsigned (by decide)

/-- `fd_r43x6_add_fast` of limbs in `[a, b]` and `[c, d]`: limbs in `[a + c, b + d]`. -/
theorem In.add_fast {x y : Wwl} (hx : In a b x) (hy : In c d y) (h1 : -2 ^ 63 ≤ a + c)
    (h2 : b + d < 2 ^ 63) :
    val (fd_r43x6_add_fast x y) = val x + val y ∧ In (a + c) (b + d) (fd_r43x6_add_fast x y) := by
  have lane : ∀ i : Fin 6, (fd_r43x6_add_fast x y)[(i : ℕ)].toInt =
      x[(i : ℕ)].toInt + y[(i : ℕ)].toInt := fun i => by
    have := hx i
    have := hy i
    rw [add_fast_get]
    exact toInt_add' (by omega) (by omega)
  refine ⟨?_, fun i => ?_⟩
  · rw [val, val, val, int_of_lanes lane, int, int]
    simp only [Fin.isValue, Fin.coe_ofNat_eq_mod, Nat.reduceMod]
    push_cast
    ring
  · have := hx i
    have := hy i
    rw [lane i]
    omega

/-- `fd_r43x6_sub_fast` of limbs in `[a, b]` and `[c, d]`: `x + (p - y)`, limbs in
`[a - d, b - c + 2^43]`. -/
theorem In.sub_fast {x y : Wwl} (hx : In a b x) (hy : In c d y) (h1 : -2 ^ 62 ≤ c)
    (h2 : d < 2 ^ 62) (h3 : -2 ^ 62 ≤ a - d) (h4 : b - c < 2 ^ 62) :
    val (fd_r43x6_sub_fast x y) = val x - val y ∧
      In (a - d) (b - c + 2 ^ 43) (fd_r43x6_sub_fast x y) := by
  obtain ⟨lane, v⟩ := sub_fast_lanes (x := x) (y := y) fun i => by
    have := hx i
    have := hy i
    omega
  refine ⟨v, fun i => ?_⟩
  have := hx i
  have := hy i
  have := p_lane i
  rw [lane i]
  omega

/-- `fd_r43x6_fold_signed` of limbs from `-2^63 + 19 · 2^23`: the value, folded. -/
theorem In.fold_signed {x : Wwl} (hx : In a b x) (ha : -2 ^ 63 + 19 * 2 ^ 23 ≤ a) :
    val (fd_r43x6_fold_signed x) = val x ∧ Folded (fd_r43x6_fold_signed x) :=
  fd_r43x6_fold_signed_spec_of_ge (by have : a ≤ x[0].toInt := (hx 0).1; omega)
    fun i => by have := hx i; omega

/-- `fd_r43x6_fold_unsigned` of nonnegative limbs: the value, folded. -/
theorem In.fold {x : Wwl} (hx : In 0 b x) (hb : b < 2 ^ 63) :
    val (fold x) = val x ∧ Folded (fold x) :=
  fold_spec (hx.unsigned (n := 63) (by omega))

/-- `fd_r43x6_p()`'s limbs as longs. -/
theorem p_toInt (i : Fin 6) :
    fd_r43x6_p[(i : ℕ)].toInt = if (i : ℕ) = 0 then 2 ^ 43 - 19 else if (i : ℕ) = 5 then 2 ^ 40 - 1
      else 2 ^ 43 - 1 := by
  fin_cases i <;> decide

/-- `fd_r43x6_sub_fast( p, x )` of folded limbs: `-x`, limbs `2 p_i - x_i` in `[0, 2^44)`. -/
theorem neg_folded {x : Wwl} (h : Folded x) :
    val (fd_r43x6_sub_fast fd_r43x6_p x) = -val x ∧
      In 0 (2 ^ 44 - 1) (fd_r43x6_sub_fast fd_r43x6_p x) := by
  have hx (i : Fin 6) : x[(i : ℕ)].toInt = x[(i : ℕ)].toNat :=
    toInt_of_lt (by have := h.unsigned i; omega)
  obtain ⟨h0, h1, h2, h3, h4, h5, -⟩ := h
  have b (i : Fin 6) : x[(i : ℕ)].toNat ≤ (if (i : ℕ) = 0 then 2 ^ 43 + 19 * (2 ^ 24 - 1)
      else if (i : ℕ) = 5 then 2 ^ 40 + 2 ^ 21 - 1 else 2 ^ 43 + 2 ^ 21 - 1) := by
    fin_cases i <;> simp <;> omega
  obtain ⟨lane, v⟩ := sub_fast_lanes (x := fd_r43x6_p) (y := x) fun i => by
    have := b i
    have := hx i
    have := p_toInt i
    split_ifs at * <;> omega
  refine ⟨by rw [v, val_p, zero_sub], fun i => ?_⟩
  have := b i
  have := hx i
  have := p_toInt i
  rw [lane i]
  split_ifs at * <;> omega

end R43x6

/-! ## Element values and ranges through the QUAD operations -/

namespace Quad

open R43x6 (In)

/-- A limb of element `j`, as the lane holding it. -/
theorem elem_get (Q : Quad) (j : Fin 4) (k : Fin 6) :
    (Q.elem j)[(k : ℕ)] =
      if (k : ℕ) < 3 then
        (if (k : ℕ) = 0 then Q.P03[(j : ℕ)] else if (k : ℕ) = 1 then Q.P14[(j : ℕ)]
          else Q.P25[(j : ℕ)])
      else
        (if (k : ℕ) = 3 then Q.P03[(j : ℕ) + 4] else if (k : ℕ) = 4 then Q.P14[(j : ℕ) + 4]
          else Q.P25[(j : ℕ) + 4]) := by
  rw [elem_eq]
  fin_cases k <;> simp

/-- Lanes from element limb ranges in `[0, hi]`, `hi` below `b`. -/
theorem lanesLt_of_in {P : Quad} (h : ∀ j : Fin 4, In lo hi (P.elem j)) (hlo : 0 ≤ lo)
    {b : BitVec 64} (hb : hi < b.toNat) : R43x6.LanesLt P.P03 P.P14 P.P25 b := by
  have lt (j : Fin 4) (k : Fin 6) : (P.elem j)[(k : ℕ)] < b := by
    have := h j k
    have := R43x6.toNat_of_toInt_nonneg (a := (P.elem j)[(k : ℕ)]) (by omega)
    rw [BitVec.lt_def]
    omega
  intro i hi
  match i, hi with
  | 0, _ => exact ⟨lt 0 0, lt 0 1, lt 0 2⟩
  | 1, _ => exact ⟨lt 1 0, lt 1 1, lt 1 2⟩
  | 2, _ => exact ⟨lt 2 0, lt 2 1, lt 2 2⟩
  | 3, _ => exact ⟨lt 3 0, lt 3 1, lt 3 2⟩
  | 4, _ => exact ⟨lt 0 3, lt 0 4, lt 0 5⟩
  | 5, _ => exact ⟨lt 1 3, lt 1 4, lt 1 5⟩
  | 6, _ => exact ⟨lt 2 3, lt 2 4, lt 2 5⟩
  | 7, _ => exact ⟨lt 3 3, lt 3 4, lt 3 5⟩

/-- Element limb ranges from lanes below `b ≤ 2^63`. -/
theorem in_of_lanesLt {P : Quad} {b : BitVec 64} (h : R43x6.LanesLt P.P03 P.P14 P.P25 b)
    (hb : b.toNat ≤ 2 ^ 63) (j : Fin 4) : In 0 (b.toNat - 1) (P.elem j) := by
  intro k
  have hl : (P.elem j)[(k : ℕ)] < b := by
    rw [elem_get]
    have := h j (by omega)
    have := h (j + 4) (by omega)
    fin_cases k <;> simp [*]
  rw [BitVec.lt_def] at hl
  rw [R43x6.toInt_of_lt (by omega)]
  omega

namespace Is

variable {S P Q : Quad} {v vs vp vq : Fin 4 → ZMod p} {lo hi ls hs lp hp lq hq : Fin 4 → ℤ}

/-- Wider ranges. -/
theorem mono (h : Q.Is v lo hi) (lo' hi' : Fin 4 → ℤ)
    (hr : ∀ j, lo' j ≤ lo j ∧ hi j ≤ hi' j := by intro j; fin_cases j <;> norm_num) :
    Q.Is v lo' hi' :=
  fun j => ⟨(h j).1, (h j).2.mono (hr j).1 (hr j).2⟩

/-- `PERMUTE( S, i0,i1,i2,i3 )`: element `j` is `S`'s element `ij`. -/
theorem permute (h : S.Is v lo hi) (i0 i1 i2 i3 : Fin 4) (w : Fin 4 → ZMod p)
    (hw : ∀ j, w j = v (![i0, i1, i2, i3] j) := by intro j; fin_cases j <;> simp) :
    (S.permute i0 i1 i2 i3).Is w (fun j => lo (![i0, i1, i2, i3] j))
      (fun j => hi (![i0, i1, i2, i3] j)) := fun j => by
  rw [elem_permute, hw]
  exact h _

/-- `LANE_ADD_FAST( S, mask, P, Q )`: `vp + vq` where selected, `vs` elsewhere, in ranges
`[lo', hi']` covering the sums' and `S`'s. -/
theorem laneAddFast (hS : S.Is vs ls hs) (hP : P.Is vp lp hp) (hQ : Q.Is vq lq hq)
    (i0 i1 i2 i3 : ℕ) (w : Fin 4 → ZMod p) (lo' hi' : Fin 4 → ℤ)
    (hm : ∀ j : Fin 4, (quadMask i0 i1 i2 i3).getLsbD ((j : ℕ) + 4) =
      (quadMask i0 i1 i2 i3).getLsbD j := by decide)
    (hw : ∀ j : Fin 4, w j = if (quadMask i0 i1 i2 i3).getLsbD j then vp j + vq j else vs j := by
      intro j; fin_cases j <;> rfl)
    (hr : ∀ j : Fin 4, if (quadMask i0 i1 i2 i3).getLsbD j then
        lo' j ≤ lp j + lq j ∧ hp j + hq j ≤ hi' j ∧ -2 ^ 63 ≤ lp j + lq j ∧ hp j + hq j < 2 ^ 63
      else lo' j ≤ ls j ∧ hs j ≤ hi' j := by intro j; fin_cases j <;> norm_num [quadMask]) :
    (S.laneAddFast i0 i1 i2 i3 P Q).Is w lo' hi' := fun j => by
  have r := hr j
  rw [elem_laneAddFast _ _ _ _ _ _ _ _ (hm j), hw j]
  rcases Bool.eq_false_or_eq_true ((quadMask i0 i1 i2 i3).getLsbD j) with hc | hc <;>
    simp only [hc, ite_true, Bool.false_eq_true, ite_false] at r ⊢
  · obtain ⟨v, i⟩ := (hP j).2.add_fast (hQ j).2 r.2.2.1 r.2.2.2
    exact ⟨by rw [v, (hP j).1, (hQ j).1], i.mono r.1 r.2.1⟩
  · exact ⟨(hS j).1, (hS j).2.mono r.1 r.2⟩

/-- `LANE_SUB_FAST( S, mask, P, Q )`: `vp - vq` where selected, `vs` elsewhere, in ranges
`[lo', hi']` covering the differences plus `p` and `S`'s. -/
theorem laneSubFast (hS : S.Is vs ls hs) (hP : P.Is vp lp hp) (hQ : Q.Is vq lq hq)
    (i0 i1 i2 i3 : ℕ) (w : Fin 4 → ZMod p) (lo' hi' : Fin 4 → ℤ)
    (hm : ∀ j : Fin 4, (quadMask i0 i1 i2 i3).getLsbD ((j : ℕ) + 4) =
      (quadMask i0 i1 i2 i3).getLsbD j := by decide)
    (hw : ∀ j : Fin 4, w j = if (quadMask i0 i1 i2 i3).getLsbD j then vp j - vq j else vs j := by
      intro j; fin_cases j <;> rfl)
    (hr : ∀ j : Fin 4, if (quadMask i0 i1 i2 i3).getLsbD j then
        lo' j ≤ lp j - hq j ∧ hp j - lq j + 2 ^ 43 ≤ hi' j ∧ -2 ^ 62 ≤ lq j ∧ hq j < 2 ^ 62 ∧
          -2 ^ 62 ≤ lp j - hq j ∧ hp j - lq j < 2 ^ 62
      else lo' j ≤ ls j ∧ hs j ≤ hi' j := by intro j; fin_cases j <;> norm_num [quadMask]) :
    (S.laneSubFast i0 i1 i2 i3 P Q).Is w lo' hi' := fun j => by
  have r := hr j
  rw [elem_laneSubFast _ _ _ _ _ _ _ _ (hm j), hw j]
  rcases Bool.eq_false_or_eq_true ((quadMask i0 i1 i2 i3).getLsbD j) with hc | hc <;>
    simp only [hc, ite_true, Bool.false_eq_true, ite_false] at r ⊢
  · obtain ⟨v, i⟩ := (hP j).2.sub_fast (hQ j).2 r.2.2.1 r.2.2.2.1 r.2.2.2.2.1 r.2.2.2.2.2
    exact ⟨by rw [v, (hP j).1, (hQ j).1], i.mono r.1 r.2.1⟩
  · exact ⟨(hS j).1, (hS j).2.mono r.1 r.2⟩

/-- `FOLD_SIGNED`: the values, folded. -/
theorem foldSigned (h : Q.Is v lo hi)
    (hlo : ∀ j, -2 ^ 63 + 19 * 2 ^ 23 ≤ lo j := by intro j; fin_cases j <;> norm_num) :
    Q.foldSigned.Is v (fun _ => 0) (fun _ => 2 ^ 44 - 1) ∧ Q.foldSigned.Folded := by
  have e (j : Fin 4) := (h j).2.fold_signed (hlo j)
  refine ⟨fun j => ?_, fun j hj => ?_⟩
  · rw [elem_foldSigned]
    exact ⟨by rw [(e j).1, (h j).1], (e j).2.in⟩
  · have := (e ⟨j, hj⟩).2
    rwa [← elem_foldSigned] at this

/-- `FOLD_UNSIGNED`: the values of nonnegative limbs, folded. -/
theorem foldUnsigned (h : Q.Is v lo hi)
    (hr : ∀ j, 0 ≤ lo j ∧ hi j < 2 ^ 63 := by intro j; fin_cases j <;> norm_num) :
    Q.foldUnsigned.Is v (fun _ => 0) (fun _ => 2 ^ 44 - 1) ∧ Q.foldUnsigned.Folded := by
  have e (j : Fin 4) := ((h j).2.mono (hr j).1 le_rfl).fold (hr j).2
  refine ⟨fun j => ?_, fun j hj => ?_⟩
  · rw [elem_foldUnsigned]
    exact ⟨by rw [(e j).1, (h j).1], (e j).2.in⟩
  · have := (e ⟨j, hj⟩).2
    rwa [← elem_foldUnsigned] at this

/-- `MUL_FAST` of nonnegative limbs below `2^47`: the products, limbs below `2^63`. -/
theorem quadMul' (hP : P.Is vp lp hp) (hQ : Q.Is vq lq hq) (w : Fin 4 → ZMod p)
    (hw : ∀ j, w j = vp j * vq j := by intro j; fin_cases j <;> rfl)
    (hr : ∀ j, 0 ≤ lp j ∧ hp j < 2 ^ 47 ∧ 0 ≤ lq j ∧ hq j < 2 ^ 47 := by
      intro j; fin_cases j <;> norm_num) :
    (Avx512.quadMul P Q).Is w (fun _ => 0) (fun _ => 2 ^ 63 - 1) := fun j => by
  obtain ⟨v, u⟩ := R43x6.fd_r43x6_quad_mul_fast_spec (j := j) j.2
    (((hP j).2.mono (hr j).1 le_rfl).unsigned (hr j).2.1)
    (((hQ j).2.mono (hr j).2.2.1 le_rfl).unsigned (hr j).2.2.2)
  exact ⟨by rw [hw, ← (hP j).1, ← (hQ j).1, ← v]; rfl, R43x6.In.of_unsigned u le_rfl⟩

/-- `MUL_FAST` of nonnegative limbs below `2^44`: the products, limbs below `7 · 2^59`. -/
theorem quadMul (hP : P.Is vp lp hp) (hQ : Q.Is vq lq hq) (w : Fin 4 → ZMod p)
    (hw : ∀ j, w j = vp j * vq j := by intro j; fin_cases j <;> rfl)
    (hr : ∀ j, 0 ≤ lp j ∧ hp j < 2 ^ 44 ∧ 0 ≤ lq j ∧ hq j < 2 ^ 44 := by
      intro j; fin_cases j <;> norm_num) :
    (Avx512.quadMul P Q).Is w (fun _ => 0) (fun _ => 7 * 2 ^ 59 - 1) := fun j => by
  have lt := R43x6.fd_r43x6_quad_mul_fast_lt
    (lanesLt_of_in (lo := 0) (hi := 2 ^ 44 - 1) (fun j => (hP j).2.mono (hr j).1 (by
      have := (hr j).2.1; omega)) le_rfl (b := 17592186044416#64) (by decide))
    (lanesLt_of_in (lo := 0) (hi := 2 ^ 44 - 1) (fun j => (hQ j).2.mono (hr j).2.2.1 (by
      have := (hr j).2.2.2; omega)) le_rfl (b := 17592186044416#64) (by decide))
  exact ⟨(quadMul' hP hQ w hw (fun j => ⟨(hr j).1, by have := (hr j).2.1; omega, (hr j).2.2.1,
    by have := (hr j).2.2.2; omega⟩) j).1, in_of_lanesLt (P := Avx512.quadMul P Q) lt (by decide) j⟩

/-- `SQR_FAST` of nonnegative limbs below `2^45`: the squares, limbs below `2^61`. -/
theorem quadSqr (hP : P.Is v lo hi) (w : Fin 4 → ZMod p)
    (hw : ∀ j, w j = v j ^ 2 := by intro j; fin_cases j <;> rfl)
    (hr : ∀ j, 0 ≤ lo j ∧ hi j < 2 ^ 45 := by intro j; fin_cases j <;> norm_num) :
    (Avx512.quadSqr P).Is w (fun _ => 0) (fun _ => 2 ^ 61 - 1) := fun j => by
  obtain ⟨v, -⟩ := R43x6.fd_r43x6_quad_sqr_fast_spec (j := j) j.2
    (((hP j).2.mono (hr j).1 le_rfl).unsigned (n := 47) (by have := (hr j).2; omega))
  have lt := R43x6.fd_r43x6_quad_sqr_fast_lt
    (lanesLt_of_in (lo := 0) (hi := 2 ^ 45 - 1) (fun j => (hP j).2.mono (hr j).1 (by
      have := (hr j).2; omega)) le_rfl (b := 35184372088832#64) (by decide))
  exact ⟨by rw [hw, ← (hP j).1, ← v]; rfl, in_of_lanesLt (P := Avx512.quadSqr P) lt (by decide) j⟩

end Is

end Quad

/-! ## Forms and ranges -/

namespace Quad

open R43x6 (In)

variable {Q : Quad}

/-- Folded elements are `u44`. -/
theorem Folded.unsigned (h : Q.Folded) : Q.Unsigned 44 :=
  fun j hj => (h j hj).unsigned

/-- A wider range. -/
theorem Unsigned.mono (h : Q.Unsigned m) (hmn : m ≤ n) : Q.Unsigned n :=
  fun j hj => (h j hj).mono hmn

/-- The elements' own values, in `[0, 2^n - 1]`. -/
theorem Is.of_unsigned (h : Q.Unsigned n) (hn : n ≤ 63) :
    Q.Is ![Q.val 0, Q.val 1, Q.val 2, Q.val 3] (fun _ => 0) (fun _ => 2 ^ n - 1) := fun j => by
  refine ⟨?_, In.of_unsigned (h j j.2) hn⟩
  fin_cases j <;> rfl

/-- Element `j`'s value. -/
theorem Is.val (h : Q.Is v lo hi) (j : Fin 4) : Q.val j = v j :=
  (h j).1

/-- Nonnegative limbs below `2^n` are unsigned. -/
theorem Is.unsigned (h : Q.Is v lo hi) (hr : ∀ j, 0 ≤ lo j ∧ hi j < 2 ^ n) : Q.Unsigned n :=
  fun j hj => ((h ⟨j, hj⟩).2.mono (hr _).1 le_rfl).unsigned (hr _).2

/-- `LANE_SUB_FAST( S, mask, p, S )` of a folded `S`: `-S` where selected, limbs in `[0, 2^44)`. -/
theorem Is.laneSubFast_p (h : Q.Is v lo hi) (hF : Q.Folded) (i0 i1 i2 i3 : ℕ) (w : Fin 4 → ZMod p)
    (hm : ∀ j : Fin 4, (quadMask i0 i1 i2 i3).getLsbD ((j : ℕ) + 4) =
      (quadMask i0 i1 i2 i3).getLsbD j := by decide)
    (hw : ∀ j : Fin 4, w j = if (quadMask i0 i1 i2 i3).getLsbD j then -v j else v j := by
      intro j; fin_cases j <;> rfl) :
    (Q.laneSubFast i0 i1 i2 i3 quadP Q).Is w (fun _ => 0) (fun _ => 2 ^ 44 - 1) := fun j => by
  rw [elem_laneSubFast _ _ _ _ _ _ _ _ (hm j), hw j, quadP_elem, ← (h j).1]
  split
  · exact R43x6.neg_folded (hF j j.2)
  · exact ⟨rfl, (hF j j.2).in⟩

/-- Affine coordinates are extended ones, `Z = 1`. -/
theorem Affine.ext (h : Q.Affine x y) : Q.Ext x y := by
  obtain ⟨h0, h1, h2, h3⟩ := h
  rw [Ext, h0, h1, h2, h3]
  exact ⟨one_ne_zero, (mul_one x).symm, (mul_one y).symm, by ring⟩

/-- Extended coordinates are projective ones. -/
theorem Ext.proj (h : Q.Ext x y) : Q.Proj x y :=
  ⟨h.1, h.2.1, h.2.2.1⟩

/-- Element values `X, Y, Z, T` that are extended coordinates make `Q` extended. -/
theorem Is.ext {X Y Z T : ZMod p} (h : Q.Is ![X, Y, Z, T] lo hi)
    (he : Ref.Ed25519.IsExt x y X Y T Z) :
    Q.Ext x y := by
  have e0 : Q.val 0 = X := h.val 0
  have e1 : Q.val 1 = Y := h.val 1
  have e2 : Q.val 2 = Z := h.val 2
  have e3 : Q.val 3 = T := h.val 3
  rw [Ext, e0, e1, e2, e3]
  exact he

/-- Elements `(y - x, y + x, 1, 2d x y)`, as the base table holds them: `(x, y)` precomputed, with
`Z = 1`. -/
theorem Pre.of_affine (h0 : Q.val 0 = y - x) (h1 : Q.val 1 = y + x) (h2 : Q.val 2 = 1)
    (h3 : Q.val 3 = 2 * Ref.Ed25519.d * (x * y)) : Q.Pre x y :=
  ⟨x, y, x * y, 1, ⟨one_ne_zero, (mul_one x).symm, (mul_one y).symm, mul_one _⟩, h0, h1, h2, h3⟩

end Quad

end

end LeanMLIR.RIR.Firedancer.Avx512
