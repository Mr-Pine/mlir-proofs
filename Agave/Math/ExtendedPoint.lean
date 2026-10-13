module

public import Agave.Math.Point
public import Agave.Math.FieldElement2625x4
public import Agave.Common.ExtendedPoint
public import Agave.Avx2.ExtendedPoint_double_impl_double
public import Agave.Avx2.ExtendedPoint_Sub_CachedPoint_sub_impl_sub
public import Agave.Avx2.CachedPoint_From_ExtendedPoint_from_impl_from
public import Agave.Avx2.EXTENDEDPOINT_IDENTITY
public import Agave.Math.BaseTable
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

/-! The AVX2 point formulas in `ZMod p`, element by element: the lane operations move, add and
negate whole elements, `reduce` keeps each element's value. -/

namespace MLIR.Agave

open _root_.Ed25519

/-! ## Definitions -/

@[expose] public section

namespace Fe2625x4

/-- Element `e` of `v` has value `z`, even limbs below `ev` and odd ones below `od`. -/
def Repr (v : Fe2625x4) (e : Fin 4) (z : ZMod p) (ev od : ℕ) : Prop :=
  val v e = z ∧ ∀ i, (v i)[evenLane e].toNat < ev ∧ (v i)[oddLane e].toNat < od

/-- The bound of an `ExtendedPoint` after a multiplication or `reduce`. -/
abbrev Reduced (v : Fe2625x4) : Prop :=
  Bounded v (2 ^ 26 + 2 ^ 12) (2 ^ 25 + 2 ^ 19)

/-- `v` holds extended coordinates of `P` in its elements `(X, Y, Z, T)`. -/
def IsExtOf (v : Fe2625x4) (P : Point) : Prop :=
  IsExt P.x P.y (val v 0) (val v 1) (val v 3) (val v 2)

/-- `v` holds cached coordinates of `P` (`Agave.IsCached`). -/
def IsCachedOf (v : Fe2625x4) (P : Point) : Prop :=
  IsCached P.x P.y (val v 0) (val v 1) (val v 2) (val v 3)

end Fe2625x4

end

namespace Fe2625x4

/-! ## Lanes -/

theorem shuffle_apply (x : Fe2625x4) (c : Fin 8 → Fin 8) (i : Fin 5) :
    shuffle x c i = permute (x i) c := by fin_cases i <;> rfl

theorem blend_apply (x y : Fe2625x4) (m : Fin 8 → Bool) (i : Fin 5) :
    blend x y m i = blendLanes (x i) (y i) m := by fin_cases i <;> rfl

theorem add_apply (x y : Fe2625x4) (i : Fin 5) : add x y i = addLanes (x i) (y i) := by
  fin_cases i <;> rfl

theorem dbl_apply (x : Fe2625x4) (i : Fin 5) : dbl x i = dblLanes (x i) := by fin_cases i <;> rfl

theorem negateLazy_apply (x : Fe2625x4) (i : Fin 5) : negateLazy x i = subLanes (p2 i) (x i) := by
  fin_cases i <;> rfl

theorem permute_getElem (v : Vector (BitVec 32) 8) (c : Fin 8 → Fin 8) (j : Fin 8) :
    (permute v c)[j] = v[c j] := by fin_cases j <;> rfl

theorem blendLanes_getElem (x y : Vector (BitVec 32) 8) (m : Fin 8 → Bool) (j : Fin 8) :
    (blendLanes x y m)[j] = if m j then y[j] else x[j] := by fin_cases j <;> rfl

theorem addLanes_getElem (x y : Vector (BitVec 32) 8) (j : Fin 8) :
    (addLanes x y)[j] = x[j] + y[j] := by fin_cases j <;> rfl

theorem subLanes_getElem (x y : Vector (BitVec 32) 8) (j : Fin 8) :
    (subLanes x y)[j] = x[j] - y[j] := by fin_cases j <;> rfl

theorem dblLanes_getElem (x : Vector (BitVec 32) 8) (j : Fin 8) : (dblLanes x)[j] = x[j] <<< 1 := by
  fin_cases j <;> rfl

theorem zero_getElem (i : Fin 5) (j : Fin 8) : (zero i)[j] = 0 := by
  fin_cases i <;> fin_cases j <;> rfl

/-! ## Values from lanes -/

/-- Elements with equal lanes have equal values. -/
theorem val_congr {v w : Fe2625x4} {e e' : Fin 4}
    (h : ∀ i, (v i)[evenLane e] = (w i)[evenLane e'] ∧ (v i)[oddLane e] = (w i)[oddLane e']) :
    val v e = val w e' := by simp only [val, nat, (h _).1, (h _).2]

/-- Lanes adding up: values adding up. -/
theorem val_add_of_lanes {u v w : Fe2625x4} {e : Fin 4}
    (h :
      ∀ i,
        (u i)[evenLane e].toNat = (v i)[evenLane e].toNat + (w i)[evenLane e].toNat ∧
          (u i)[oddLane e].toNat = (v i)[oddLane e].toNat + (w i)[oddLane e].toNat) :
    val u e = val v e + val w e := by
  simp only [val, nat, (h _).1, (h _).2]
  push_cast
  rw [← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl fun i _ => ?_
  ring

/-! ## Elements -/

variable {x y : Fe2625x4} {e e' : Fin 4} {z z' : ZMod p} {a b a' b' : ℕ}

public theorem Repr.mono (h : Repr x e z a b) (ha : a ≤ a') (hb : b ≤ b') : Repr x e z a' b' :=
  ⟨h.1, fun i => ⟨(h.2 i).1.trans_le ha, (h.2 i).2.trans_le hb⟩⟩

/-- An element of a bounded field element. -/
public theorem Repr.of_bounded (h : Bounded x a b) (e : Fin 4) : Repr x e (val x e) a b :=
  ⟨rfl, fun i => h i e⟩

/-- A field element with every element bounded. -/
public theorem bounded_of_repr {z : Fin 4 → ZMod p} (h : ∀ e, Repr x e (z e) a b) : Bounded x a b :=
  fun i e => (h e).2 i

/-- `x.shuffle(c)` where `c` moves element `e'` to `e`. -/
public theorem Repr.shuffle {c : Fin 8 → Fin 8} (h : Repr x e' z a b)
    (hc : c (evenLane e) = evenLane e' ∧ c (oddLane e) = oddLane e') :
    Repr (Fe2625x4.shuffle x c) e z a b := by
  have hl i :
    (Fe2625x4.shuffle x c i)[evenLane e] = (x i)[evenLane e'] ∧
      (Fe2625x4.shuffle x c i)[oddLane e] = (x i)[oddLane e'] := by
    rw [shuffle_apply, permute_getElem, permute_getElem]
    exact ⟨congrArg (fun j : Fin 8 => (x i)[j]) hc.1, congrArg (fun j : Fin 8 => (x i)[j]) hc.2⟩
  refine ⟨(val_congr hl).trans h.1, fun i => ?_⟩
  rw [(hl i).1, (hl i).2]
  exact h.2 i

/-- `x.blend(y, m)` where `m` takes element `e` of `y`. -/
public theorem Repr.blend_right {m : Fin 8 → Bool} (h : Repr y e z a b)
    (hm : m (evenLane e) = true ∧ m (oddLane e) = true) : Repr (blend x y m) e z a b := by
  have hl i :
    (blend x y m i)[evenLane e] = (y i)[evenLane e] ∧
      (blend x y m i)[oddLane e] = (y i)[oddLane e] := by
    rw [blend_apply, blendLanes_getElem, blendLanes_getElem, hm.1, hm.2]
    exact ⟨rfl, rfl⟩
  refine ⟨(val_congr hl).trans h.1, fun i => ?_⟩
  rw [(hl i).1, (hl i).2]
  exact h.2 i

/-- `x.blend(y, m)` where `m` keeps element `e` of `x`. -/
public theorem Repr.blend_left {m : Fin 8 → Bool} (h : Repr x e z a b)
    (hm : m (evenLane e) = false ∧ m (oddLane e) = false) : Repr (blend x y m) e z a b := by
  have hl i :
    (blend x y m i)[evenLane e] = (x i)[evenLane e] ∧
      (blend x y m i)[oddLane e] = (x i)[oddLane e] := by
    rw [blend_apply, blendLanes_getElem, blendLanes_getElem, hm.1, hm.2]
    exact ⟨rfl, rfl⟩
  refine ⟨(val_congr hl).trans h.1, fun i => ?_⟩
  rw [(hl i).1, (hl i).2]
  exact h.2 i

theorem toNat_add_lt {u w : BitVec 32} {A B : ℕ} (hu : u.toNat < A) (hw : w.toNat < B)
    (h : A + B ≤ 2 ^ 32) : (u + w).toNat = u.toNat + w.toNat := by
  rw [BitVec.toNat_add, Nat.mod_eq_of_lt (by omega)]

/-- `x + y` without carries, lanes not overflowing. -/
public theorem Repr.add (hx : Repr x e z a b) (hy : Repr y e z' a' b') (ha : a + a' ≤ 2 ^ 32)
    (hb : b + b' ≤ 2 ^ 32) : Repr (Fe2625x4.add x y) e (z + z') (a + a' - 1) (b + b' - 1) := by
  have hl i :
    (Fe2625x4.add x y i)[evenLane e].toNat = (x i)[evenLane e].toNat + (y i)[evenLane e].toNat ∧
      (Fe2625x4.add x y i)[oddLane e].toNat = (x i)[oddLane e].toNat + (y i)[oddLane e].toNat := by
    rw [add_apply, addLanes_getElem, addLanes_getElem]
    exact ⟨toNat_add_lt (hx.2 i).1 (hy.2 i).1 ha, toNat_add_lt (hx.2 i).2 (hy.2 i).2 hb⟩
  refine ⟨(val_add_of_lanes hl).trans (by rw [hx.1, hy.1]), fun i => ?_⟩
  rw [(hl i).1, (hl i).2]
  have := hx.2 i
  have := hy.2 i
  omega

/-- `x + x`, as shifts. -/
public theorem Repr.dbl (hx : Repr x e z a b) (ha : 2 * a ≤ 2 ^ 32) (hb : 2 * b ≤ 2 ^ 32) :
    Repr (Fe2625x4.dbl x) e (z + z) (a + a) (b + b) := by
  have hs (u : BitVec 32) (hu : 2 * u.toNat < 2 ^ 32) : (u <<< 1).toNat = u.toNat + u.toNat := by
    rw [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq, Nat.mod_eq_of_lt (by omega)]; ring
  have hl i :
    (Fe2625x4.dbl x i)[evenLane e].toNat = (x i)[evenLane e].toNat + (x i)[evenLane e].toNat ∧
      (Fe2625x4.dbl x i)[oddLane e].toNat = (x i)[oddLane e].toNat + (x i)[oddLane e].toNat := by
    rw [dbl_apply, dblLanes_getElem, dblLanes_getElem]
    exact
      ⟨hs _
          (by
            have := (hx.2 i).1; omega),
        hs _
          (by
            have := (hx.2 i).2; omega)⟩
  refine ⟨(val_add_of_lanes hl).trans (by rw [hx.1]), fun i => ?_⟩
  rw [(hl i).1, (hl i).2]
  exact ⟨Nat.add_lt_add (hx.2 i).1 (hx.2 i).1, Nat.add_lt_add (hx.2 i).2 (hx.2 i).2⟩

/-- `FieldElement2625x4::ZERO`. -/
public theorem Repr.zero (e : Fin 4) : Repr Fe2625x4.zero e 0 1 1 := by
  refine ⟨?_, fun i => ?_⟩
  · simp only [val, nat, zero_getElem]
    simp
  · rw [zero_getElem, zero_getElem]
    decide

/-- The lanes of `2p`. -/
theorem p2_lanes (i : Fin 5) (e : Fin 4) :
    134217690 ≤ (p2 i)[evenLane e].toNat ∧
      (p2 i)[evenLane e].toNat < 2 ^ 27 ∧ (p2 i)[oddLane e].toNat = 67108862 := by
  fin_cases i <;> fin_cases e <;> decide

theorem val_p2 (e : Fin 4) : val p2 e = 0 := by
  rw [val, nat_p2]; simp

/-- `x.negate_lazy()`: `2p - x`, lanes at most `2p`'s. -/
public theorem Repr.negateLazy (hx : Repr x e z a b) (ha : a ≤ 134217691) (hb : b ≤ 67108863) :
    Repr (Fe2625x4.negateLazy x) e (-z) (2 ^ 27) (2 ^ 26) := by
  have hs (u w : BitVec 32) (h : u.toNat ≤ w.toNat) : (w - u).toNat + u.toNat = w.toNat := by
    rw [BitVec.toNat_sub_of_le (BitVec.le_def.mpr h)]; omega
  have hl i :
    (p2 i)[evenLane e].toNat =
        (Fe2625x4.negateLazy x i)[evenLane e].toNat + (x i)[evenLane e].toNat ∧
      (p2 i)[oddLane e].toNat =
        (Fe2625x4.negateLazy x i)[oddLane e].toNat + (x i)[oddLane e].toNat := by
    rw [negateLazy_apply, subLanes_getElem, subLanes_getElem]
    have := p2_lanes i e
    have := hx.2 i
    exact ⟨(hs _ _ (by omega)).symm, (hs _ _ (by omega)).symm⟩
  have hv := val_add_of_lanes hl
  rw [val_p2, hx.1] at hv
  refine ⟨by linear_combination -hv, fun i => ?_⟩
  have := p2_lanes i e
  have := hl i
  omega

/-! ## `reduce` -/

theorem reduceReg_even (x : Vector (BitVec 32) 8) (c : Fin 4 → BitVec 32) (e : Fin 4) :
    (reduceReg x c)[evenLane e] = (x[evenLane e] &&& 67108863) + c e := by fin_cases e <;> rfl

theorem reduceReg_odd (x : Vector (BitVec 32) 8) (c : Fin 4 → BitVec 32) (e : Fin 4) :
    (reduceReg x c)[oddLane e] = (x[oddLane e] &&& 33554431) + x[evenLane e] >>> 26 := by
  fin_cases e <;> rfl

theorem carries_apply (x : Vector (BitVec 32) 8) (e : Fin 4) :
    carries x e = x[oddLane e] >>> 25 := by fin_cases e <;> rfl

theorem toNat_and26 (u : BitVec 32) : (u &&& 67108863).toNat = u.toNat % 2 ^ 26 := by
  rw [BitVec.toNat_and, ← Nat.and_two_pow_sub_one_eq_mod]; rfl

theorem toNat_and25 (u : BitVec 32) : (u &&& 33554431).toNat = u.toNat % 2 ^ 25 := by
  rw [BitVec.toNat_and, ← Nat.and_two_pow_sub_one_eq_mod]; rfl

theorem toNat_shr (u : BitVec 32) (k : ℕ) : (u >>> k).toNat = u.toNat / 2 ^ k := by
  rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]

/-- An even limb reduced, taking carry `c`. -/
theorem toNat_reduce_even (u c : BitVec 32) (hc : c.toNat < 2 ^ 12) :
    ((u &&& 67108863) + c).toNat = u.toNat % 2 ^ 26 + c.toNat := by
  rw [BitVec.toNat_add, toNat_and26]
  have := Nat.mod_lt u.toNat (show 0 < 2 ^ 26 by decide)
  rw [Nat.mod_eq_of_lt (by omega)]

/-- An odd limb reduced, taking the even limb's carry. -/
theorem toNat_reduce_odd (u w : BitVec 32) :
    ((u &&& 33554431) + w >>> 26).toNat = u.toNat % 2 ^ 25 + w.toNat / 2 ^ 26 := by
  show ((u &&& (33554431 : BitVec 32)) + w >>> 26).toNat = _
  rw [BitVec.toNat_add, toNat_and25, toNat_shr]
  have := Nat.mod_lt u.toNat (show 0 < 2 ^ 25 by decide)
  have := w.isLt
  rw [Nat.mod_eq_of_lt (by omega)]

theorem toNat_carry (u : BitVec 32) : (u >>> 25).toNat = u.toNat / 2 ^ 25 :=
  toNat_shr u 25

theorem toNat_carry19 (u : BitVec 32) : (u >>> 25 * 19).toNat = u.toNat / 2 ^ 25 * 19 := by
  rw [BitVec.toNat_mul, toNat_shr]
  have := u.isLt
  rw [show (19 : BitVec 32).toNat = 19 from rfl, Nat.mod_eq_of_lt (by omega)]

/-- `x.reduce()` keeps each element's value. -/
public theorem val_reduce (v : Fe2625x4) (e : Fin 4) : val (reduce v) e = val v e := by
  have r0 : reduce v 0 = reduceReg (v 0) fun e => carries (v 4) e * 19 := rfl
  have r1 : reduce v 1 = reduceReg (v 1) (carries (v 0)) := rfl
  have r2 : reduce v 2 = reduceReg (v 2) (carries (v 1)) := rfl
  have r3 : reduce v 3 = reduceReg (v 3) (carries (v 2)) := rfl
  have r4 : reduce v 4 = reduceReg (v 4) (carries (v 3)) := rfl
  have c9 := (toNat_carry19 (v 4)[oddLane e])
  have hc9 : ((v 4)[oddLane e] >>> 25 * 19).toNat < 2 ^ 12 := by
    have := ((v 4)[oddLane e]).isLt; omega
  have hc (i : Fin 5) : ((v i)[oddLane e] >>> 25).toNat < 2 ^ 12 := by
    have := ((v i)[oddLane e]).isLt; rw [toNat_carry]; omega
  rw [val, val, nat_eq, nat_eq, r0, r1, r2, r3, r4]
  simp only [reduceReg_even, reduceReg_odd, carries_apply]
  rw [toNat_reduce_even _ _ hc9, toNat_reduce_even _ _ (hc 0), toNat_reduce_even _ _ (hc 1),
    toNat_reduce_even _ _ (hc 2), toNat_reduce_even _ _ (hc 3), toNat_reduce_odd, toNat_reduce_odd,
    toNat_reduce_odd, toNat_reduce_odd, toNat_reduce_odd, c9, toNat_carry, toNat_carry, toNat_carry,
    toNat_carry]
  have hR :=
    reduce_val (v 0)[evenLane e].toNat (v 0)[oddLane e].toNat (v 1)[evenLane e].toNat
      (v 1)[oddLane e].toNat (v 2)[evenLane e].toNat (v 2)[oddLane e].toNat (v 3)[evenLane e].toNat
      (v 3)[oddLane e].toNat (v 4)[evenLane e].toNat (v 4)[oddLane e].toNat
  push_cast at hR ⊢
  linear_combination hR

/-- `x.reduce()`'s limbs: below `2^26 + 2^12` (even) and `2^25 + 2^6` (odd). -/
public theorem reduce_bounded (v : Fe2625x4) :
    Bounded (reduce v) (2 ^ 26 + 2 ^ 12) (2 ^ 25 + 2 ^ 6) := by
  have hc9 (e : Fin 4) : ((v 4)[oddLane e] >>> 25 * 19).toNat < 2 ^ 12 := by
    have := ((v 4)[oddLane e]).isLt; rw [toNat_carry19]; omega
  have hc (i : Fin 5) (e : Fin 4) : ((v i)[oddLane e] >>> 25).toNat < 2 ^ 12 := by
    have := ((v i)[oddLane e]).isLt; rw [toNat_carry]; omega
  have he (u c : BitVec 32) (hc : c.toNat < 2 ^ 12) :
    ((u &&& 67108863) + c).toNat < 2 ^ 26 + 2 ^ 12 := by
    rw [toNat_reduce_even _ _ hc]
    have := Nat.mod_lt u.toNat (show 0 < 2 ^ 26 by decide)
    omega
  have ho (u w : BitVec 32) : ((u &&& 33554431) + w >>> 26).toNat < 2 ^ 25 + 2 ^ 6 := by
    rw [toNat_reduce_odd]
    have := Nat.mod_lt u.toNat (show 0 < 2 ^ 25 by decide)
    have := w.isLt
    omega
  have r0 : reduce v 0 = reduceReg (v 0) fun e => carries (v 4) e * 19 := rfl
  have r1 : reduce v 1 = reduceReg (v 1) (carries (v 0)) := rfl
  have r2 : reduce v 2 = reduceReg (v 2) (carries (v 1)) := rfl
  have r3 : reduce v 3 = reduceReg (v 3) (carries (v 2)) := rfl
  have r4 : reduce v 4 = reduceReg (v 4) (carries (v 3)) := rfl
  intro i e
  fin_cases i
  · show (reduce v 0)[evenLane e].toNat < _ ∧ (reduce v 0)[oddLane e].toNat < _
    rw [r0, reduceReg_even, reduceReg_odd, carries_apply]
    exact ⟨he _ _ (hc9 e), ho _ _⟩
  · show (reduce v 1)[evenLane e].toNat < _ ∧ (reduce v 1)[oddLane e].toNat < _
    rw [r1, reduceReg_even, reduceReg_odd, carries_apply]
    exact ⟨he _ _ (hc 0 e), ho _ _⟩
  · show (reduce v 2)[evenLane e].toNat < _ ∧ (reduce v 2)[oddLane e].toNat < _
    rw [r2, reduceReg_even, reduceReg_odd, carries_apply]
    exact ⟨he _ _ (hc 1 e), ho _ _⟩
  · show (reduce v 3)[evenLane e].toNat < _ ∧ (reduce v 3)[oddLane e].toNat < _
    rw [r3, reduceReg_even, reduceReg_odd, carries_apply]
    exact ⟨he _ _ (hc 2 e), ho _ _⟩
  · show (reduce v 4)[evenLane e].toNat < _ ∧ (reduce v 4)[oddLane e].toNat < _
    rw [r4, reduceReg_even, reduceReg_odd, carries_apply]
    exact ⟨he _ _ (hc 3 e), ho _ _⟩

/-! ## `-x` -/

/-- `(16p, 16p, 16p, 16p)`. -/
def p16 : Fe2625x4 :=
  ![p16Lo, p16Hi, p16Hi, p16Hi, p16Hi]

theorem p16_lanes (i : Fin 5) (e : Fin 4) :
    1073741520 ≤ (p16 i)[evenLane e].toNat ∧ (p16 i)[oddLane e].toNat = 536870896 := by
  fin_cases i <;> fin_cases e <;> decide

theorem val_p16 (e : Fin 4) : val p16 e = 0 := by
  have h : nat p16 e = 16 * p := by
    rw [nat_eq]; fin_cases e <;> decide
  rw [val, h]; simp

/-- `-x`: `16p - x` reduced, `x`'s lanes at most `16p`'s. -/
public theorem Repr.neg (hx : Repr x e z a b) (ha : a ≤ 1073741521) (hb : b ≤ 536870897) :
    Repr (Fe2625x4.neg x) e (-z) (2 ^ 26 + 2 ^ 12) (2 ^ 25 + 2 ^ 6) := by
  set w : Fe2625x4 :=
    ![subLanes p16Lo (x 0), subLanes p16Hi (x 1), subLanes p16Hi (x 2), subLanes p16Hi (x 3),
      subLanes p16Hi (x 4)] with
    hw
  have hw' i : w i = subLanes (p16 i) (x i) := by fin_cases i <;> rfl
  have hs (u w : BitVec 32) (h : u.toNat ≤ w.toNat) : (w - u).toNat + u.toNat = w.toNat := by
    rw [BitVec.toNat_sub_of_le (BitVec.le_def.mpr h)]; omega
  have hl i :
    (p16 i)[evenLane e].toNat = (w i)[evenLane e].toNat + (x i)[evenLane e].toNat ∧
      (p16 i)[oddLane e].toNat = (w i)[oddLane e].toNat + (x i)[oddLane e].toNat := by
    rw [hw', subLanes_getElem, subLanes_getElem]
    have := p16_lanes i e
    have := hx.2 i
    exact ⟨(hs _ _ (by omega)).symm, (hs _ _ (by omega)).symm⟩
  have hv := val_add_of_lanes hl
  rw [val_p16, hx.1] at hv
  refine ⟨?_, fun i => reduce_bounded w i e⟩
  change val (reduce w) e = -z
  rw [val_reduce]
  linear_combination -hv

/-! ## `x * (s₀, s₁, s₂, s₃)` -/

theorem unpackLo_getElem (v : Vector (BitVec 32) 8) (e : Fin 4) :
    (unpackLo v)[(e : ℕ)] = 0#32 ++ v[evenLane e] := by fin_cases e <;> rfl

theorem unpackHi_getElem (v : Vector (BitVec 32) 8) (e : Fin 4) :
    (unpackHi v)[(e : ℕ)] = 0#32 ++ v[oddLane e] := by fin_cases e <;> rfl

theorem ValLe.scaled {u : BitVec 32} {k : BitVec 64} (hk : k.toNat ≤ 2 ^ 18) :
    ValLe ((0#32 ++ u) * k) (u.toNat * k.toNat) ((2 ^ 32 - 1) * 2 ^ 18) :=
  ValLe.mul
    ⟨by
      rw [BitVec.toNat_append]; simp, by
      have := u.isLt; omega⟩
    ⟨rfl, hk⟩ (by decide)

/-- `x * (s₀, s₁, s₂, s₃)`: element `e` times `s_e`, into reduced limbs. -/
public theorem val_mulScalars (x : Fe2625x4) {c : Vector (BitVec 64) 4}
    (hc : ∀ e : Fin 4, c[(e : ℕ)].toNat ≤ 2 ^ 18) (e : Fin 4) :
    Repr (Avx2.mulScalars x c) e (val x e * c[(e : ℕ)].toNat) (2 ^ 26) (2 ^ 25 + 2 ^ 19) := by
  apply Avx2.FieldElement2625x4_reduce64_impl_reduce64.spec_valLe
  iterate 10
    · simp only [Matrix.cons_val, vmul_getElem, unpackLo_getElem, unpackHi_getElem]
      exact ValLe.scaled (hc e)
  · decide
  rw [val, nat_eq]
  push_cast
  ring

/-- `x.diff_sum()`: `(B - A, A + B, D - C, C + D)`, the differences through `negate_lazy`. -/
public theorem Repr.diffSum {z : Fin 4 → ZMod p} (hx : ∀ e, Repr x e (z e) a b) (ha : a ≤ 134217691)
    (hb : b ≤ 67108863) :
    Repr (Fe2625x4.diffSum x) 0 (z 1 + -z 0) (a + 2 ^ 27 - 1) (b + 2 ^ 26 - 1) ∧
      Repr (Fe2625x4.diffSum x) 1 (z 0 + z 1) (a + a - 1) (b + b - 1) ∧
      Repr (Fe2625x4.diffSum x) 2 (z 3 + -z 2) (a + 2 ^ 27 - 1) (b + 2 ^ 26 - 1) ∧
      Repr (Fe2625x4.diffSum x) 3 (z 2 + z 3) (a + a - 1) (b + b - 1) := by
  have ha' : a + 2 ^ 27 ≤ 2 ^ 32 := by omega
  have hb' : b + 2 ^ 26 ≤ 2 ^ 32 := by omega
  have ha'' : a + a ≤ 2 ^ 32 := by omega
  have hb'' : b + b ≤ 2 ^ 32 := by omega
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact
      ((hx 1).shuffle (e := 0) (c := Shuffle.BADC) (by decide)).add
        (((hx 0).negateLazy ha hb).blend_right (by decide)) ha' hb'
  · exact
      ((hx 0).shuffle (e := 1) (c := Shuffle.BADC) (by decide)).add ((hx 1).blend_left (by decide))
        ha'' hb''
  · exact
      ((hx 3).shuffle (e := 2) (c := Shuffle.BADC) (by decide)).add
        (((hx 2).negateLazy ha hb).blend_right (by decide)) ha' hb'
  · exact
      ((hx 2).shuffle (e := 3) (c := Shuffle.BADC) (by decide)).add ((hx 3).blend_left (by decide))
        ha'' hb''

public theorem Bounded.mono {v : Fe2625x4} {a b a' b' : ℕ} (h : Bounded v a b) (ha : a ≤ a')
    (hb : b ≤ b') : Bounded v a' b' := fun i e => ⟨(h i e).1.trans_le ha, (h i e).2.trans_le hb⟩

end Fe2625x4

/-! ## `ExtendedPoint::double` -/

namespace Avx2

open _root_.MLIR.Agave.Fe2625x4

/-- `double`'s square input `(X, Y, Z, X + Y)`. -/
def dblPre (x : Fe2625x4) : Fe2625x4 :=
  blend x (add (shuffle (shuffle x Shuffle.ABAB) Shuffle.BADC) (shuffle x Shuffle.ABAB)) Lanes.D

/-- `double`'s `(S₅, S₆, S₈, S₉)` from the square `tmp1`. -/
def dblPost (tmp1 : Fe2625x4) : Fe2625x4 :=
  add
    (add (add (blend (blend zero (dbl tmp1) Lanes.C) tmp1 Lanes.D) (shuffle tmp1 Shuffle.AAAA))
      (blend zero (shuffle tmp1 Shuffle.BBBB) Lanes.AD))
    (blend zero (negateLazy (shuffle tmp1 Shuffle.BBBB)) Lanes.BC)

theorem dbl_spec_eq (x : Fe2625x4) :
    ExtendedPoint_double_impl_double.spec x =
      FieldElement2625x4_Mul_mul_impl_mul.spec
        (shuffle
          (dblPost
            (FieldElement2625x4_square_and_negate_D_impl_square_and_negate_D.spec (dblPre x)))
          Shuffle.CACA)
        (shuffle
          (dblPost
            (FieldElement2625x4_square_and_negate_D_impl_square_and_negate_D.spec (dblPre x)))
          Shuffle.DBBD) := by
  unfold ExtendedPoint_double_impl_double.spec dblPre dblPost
  rfl

/-- `self.double()` of extended coordinates of `P`, reduced: extended coordinates of `2 P`,
reduced. -/
public theorem ExtendedPoint_double_impl_double.spec_val {x : Fe2625x4} {P : Point}
    (hP : IsExtOf x P) (hx : Reduced x) :
    IsExtOf (ExtendedPoint_double_impl_double.spec x) (2 • P) ∧
      Reduced (ExtendedPoint_double_impl_double.spec x) := by
  have rx := Repr.of_bounded hx
  -- tmp0 = (X1 Y1 Z1 X1+Y1)
  have p0 : Repr (dblPre x) 0 (val x 0) (2 ^ 27 + 2 ^ 13) (2 ^ 26 + 2 ^ 20) :=
    ((rx 0).blend_left (by decide)).mono (by norm_num) (by norm_num)
  have p1 : Repr (dblPre x) 1 (val x 1) (2 ^ 27 + 2 ^ 13) (2 ^ 26 + 2 ^ 20) :=
    ((rx 1).blend_left (by decide)).mono (by norm_num) (by norm_num)
  have p2 : Repr (dblPre x) 2 (val x 2) (2 ^ 27 + 2 ^ 13) (2 ^ 26 + 2 ^ 20) :=
    ((rx 2).blend_left (by decide)).mono (by norm_num) (by norm_num)
  have p3 : Repr (dblPre x) 3 (val x 0 + val x 1) (2 ^ 27 + 2 ^ 13) (2 ^ 26 + 2 ^ 20) :=
    ((((((rx 0).shuffle (e := 2) (c := Shuffle.ABAB) (by decide)).shuffle (e := 3) (c :=
                  Shuffle.BADC) (by decide)).add
              ((rx 1).shuffle (e := 3) (c := Shuffle.ABAB) (by decide)) (by norm_num)
              (by norm_num)).blend_right
          (by decide)).mono
      (by norm_num) (by norm_num))
  have hpre : Bounded (dblPre x) (2 ^ 27 + 2 ^ 13) (2 ^ 26 + 2 ^ 20) := by
    intro i e
    fin_cases e
    exacts [p0.2 i, p1.2 i, p2.2 i, p3.2 i]
  -- tmp1 = (S1 S2 S3 -S4)
  obtain ⟨hsv, hsb⟩ := FieldElement2625x4_square_and_negate_D_impl_square_and_negate_D.spec_val hpre
  rw [dbl_spec_eq]
  generalize FieldElement2625x4_square_and_negate_D_impl_square_and_negate_D.spec (dblPre x) =
    t at hsv hsb ⊢
  have s := Repr.of_bounded hsb
  -- (S5 S6 S8 S9)
  have z0 : Repr (dblPost t) 0 (0 + val t 0 + val t 1 + 0) (2 ^ 28) (2 ^ 27) :=
    ((((((Repr.zero 0).blend_left (by decide)).blend_left (by decide)).add
                  ((s 0).shuffle (by decide)) (by norm_num) (by norm_num)).add
              (((s 1).shuffle (c := Shuffle.BBBB) (by decide)).blend_right (by decide))
              (by norm_num) (by norm_num)).add
          ((Repr.zero 0).blend_left (by decide)) (by norm_num) (by norm_num)).mono
      (by norm_num) (by norm_num)
  have z1 : Repr (dblPost t) 1 (0 + val t 0 + 0 + -val t 1) (3 * 2 ^ 26) (3 * 2 ^ 25 + 2 ^ 21) :=
    ((((((Repr.zero 1).blend_left (by decide)).blend_left (by decide)).add
                  ((s 0).shuffle (by decide)) (by norm_num) (by norm_num)).add
              ((Repr.zero 1).blend_left (by decide)) (by norm_num) (by norm_num)).add
          ((((s 1).shuffle (c := Shuffle.BBBB) (by decide)).negateLazy (by norm_num)
                (by norm_num)).blend_right
            (by decide))
          (by norm_num) (by norm_num)).mono
      (by norm_num) (by norm_num)
  have z2 :
    Repr (dblPost t) 2 (val t 2 + val t 2 + val t 0 + 0 + -val t 1) (5 * 2 ^ 26)
      (5 * 2 ^ 25 + 2 ^ 21) :=
    (((((((s 2).dbl (by norm_num) (by norm_num)).blend_right (by decide)).blend_left
                      (by decide)).add
                  ((s 0).shuffle (by decide)) (by norm_num) (by norm_num)).add
              ((Repr.zero 2).blend_left (by decide)) (by norm_num) (by norm_num)).add
          ((((s 1).shuffle (c := Shuffle.BBBB) (by decide)).negateLazy (by norm_num)
                (by norm_num)).blend_right
            (by decide))
          (by norm_num) (by norm_num)).mono
      (by norm_num) (by norm_num)
  have z3 :
    Repr (dblPost t) 3 (val t 3 + val t 0 + val t 1 + 0) (3 * 2 ^ 26) (3 * 2 ^ 25 + 2 ^ 21) :=
    (((((s 3).blend_right (by decide)).add ((s 0).shuffle (by decide)) (by norm_num)
                  (by norm_num)).add
              (((s 1).shuffle (c := Shuffle.BBBB) (by decide)).blend_right (by decide))
              (by norm_num) (by norm_num)).add
          ((Repr.zero 3).blend_left (by decide)) (by norm_num) (by norm_num)).mono
      (by norm_num) (by norm_num)
  -- (S8 S5 S8 S5) * (S9 S6 S6 S9)
  have a0 := z2.shuffle (e := 0) (c := Shuffle.CACA) (by decide)
  have a1 := z0.shuffle (e := 1) (c := Shuffle.CACA) (by decide)
  have a2 := z2.shuffle (e := 2) (c := Shuffle.CACA) (by decide)
  have a3 := z0.shuffle (e := 3) (c := Shuffle.CACA) (by decide)
  have b0 := z3.shuffle (e := 0) (c := Shuffle.DBBD) (by decide)
  have b1 := z1.shuffle (e := 1) (c := Shuffle.DBBD) (by decide)
  have b2 := z1.shuffle (e := 2) (c := Shuffle.DBBD) (by decide)
  have b3 := z3.shuffle (e := 3) (c := Shuffle.DBBD) (by decide)
  have ha : Bounded (shuffle (dblPost t) Shuffle.CACA) (5 * 2 ^ 26) (5 * 2 ^ 25 + 2 ^ 21) := by
    intro i e
    fin_cases e
    exacts [a0.2 i, (a1.mono (by norm_num) (by norm_num)).2 i, a2.2 i,
      (a3.mono (by norm_num) (by norm_num)).2 i]
  have hb : Bounded (shuffle (dblPost t) Shuffle.DBBD) (3 * 2 ^ 26) (3 * 2 ^ 25 + 2 ^ 21) := by
    intro i e
    fin_cases e
    exacts [b0.2 i, b1.2 i, b2.2 i, b3.2 i]
  obtain ⟨hmv, hmb⟩ := FieldElement2625x4_Mul_mul_impl_mul.spec_val ha hb
  refine ⟨?_, hmb.mono (by norm_num) (by norm_num)⟩
  have hs0 : val t 0 = val x 0 ^ 2 := by
    rw [hsv, p0.1]; rfl
  have hs1 : val t 1 = val x 1 ^ 2 := by
    rw [hsv, p1.1]; rfl
  have hs2 : val t 2 = val x 2 ^ 2 := by
    rw [hsv, p2.1]; rfl
  have hs3 : val t 3 = -(val x 0 + val x 1) ^ 2 := by
    rw [hsv, p3.1]; rfl
  have h := isExt_dbl_avx2 (IsExt.isProj hP) P.on
  rw [Point.dbl_eq, ← two_nsmul] at h
  dsimp only at h
  refine IsExt.congr h ?_ ?_ ?_ ?_ <;>
    simp only [hmv, a0.1, a1.1, a2.1, a3.1, b0.1, b1.1, b2.1, b3.1, hs0, hs1, hs2, hs3] <;>
    ring

/-! ## `CachedPoint::from`, `ExtendedPoint + CachedPoint`, `ExtendedPoint - CachedPoint` -/

/-- `x.blend(x.diff_sum(), Lanes::AB)` of a reduced `x`: `(Y - X, Y + X, Z, T)`. -/
public theorem blend_diffSum {x : Fe2625x4} (hx : Reduced x) :
    Repr (blend x (diffSum x) Lanes.AB) 0 (val x 1 + -val x 0) (3 * 2 ^ 26 + 2 ^ 12)
        (3 * 2 ^ 25 + 2 ^ 19) ∧
      Repr (blend x (diffSum x) Lanes.AB) 1 (val x 0 + val x 1) (2 ^ 27 + 2 ^ 13)
        (2 ^ 26 + 2 ^ 20) ∧
      Repr (blend x (diffSum x) Lanes.AB) 2 (val x 2) (2 ^ 26 + 2 ^ 12) (2 ^ 25 + 2 ^ 19) ∧
      Repr (blend x (diffSum x) Lanes.AB) 3 (val x 3) (2 ^ 26 + 2 ^ 12) (2 ^ 25 + 2 ^ 19) := by
  have rx := Repr.of_bounded hx
  obtain ⟨d0, d1, -, -⟩ := Repr.diffSum rx (by norm_num) (by norm_num)
  exact
    ⟨(d0.blend_right (by decide)).mono (by norm_num) (by norm_num),
      (d1.blend_right (by decide)).mono (by norm_num) (by norm_num), (rx 2).blend_left (by decide),
      (rx 3).blend_left (by decide)⟩

/-- `CachedPoint::from(P)` of extended coordinates of `Q`, reduced: cached coordinates of `Q`,
reduced. -/
public theorem CachedPoint_From_ExtendedPoint_from_impl_from.spec_val {x : Fe2625x4} {Q : Point}
    (hQ : IsExtOf x Q) (hx : Reduced x) :
    IsCachedOf (CachedPoint_From_ExtendedPoint_from_impl_from.spec x) Q ∧
      Reduced (CachedPoint_From_ExtendedPoint_from_impl_from.spec x) := by
  obtain ⟨t0, t1, t2, t3⟩ := blend_diffSum hx
  have hc :
    ∀ e : Fin 4,
      (#v[121666, 121666, 2 * 121666, 2 * 121665] : Vector (BitVec 64) 4)[(e : ℕ)].toNat ≤
        2 ^ 18 := by
    decide
  have m := val_mulScalars (blend x (diffSum x) Lanes.AB) hc
  rw [show
      CachedPoint_From_ExtendedPoint_from_impl_from.spec x =
        blend (mulScalars (blend x (diffSum x) Lanes.AB) #v[121666, 121666, 2 * 121666, 2 * 121665])
          (neg
            (mulScalars (blend x (diffSum x) Lanes.AB) #v[121666, 121666, 2 * 121666, 2 * 121665]))
          Lanes.D
      from rfl]
  generalize mulScalars (blend x (diffSum x) Lanes.AB) #v[121666, 121666, 2 * 121666, 2 * 121665] =
    y at m ⊢
  have r0 := (m 0).blend_left (y := neg y) (m := Lanes.D) (by decide)
  have r1 := (m 1).blend_left (y := neg y) (m := Lanes.D) (by decide)
  have r2 := (m 2).blend_left (y := neg y) (m := Lanes.D) (by decide)
  have r3 := ((m 3).neg (by norm_num) (by norm_num)).blend_right (x := y) (m := Lanes.D) (by decide)
  refine ⟨?_, ?_⟩
  · have h := IsExt.isCached hQ
    unfold IsCachedOf
    rw [r0.1, r1.1, r2.1, r3.1, t0.1, t1.1, t2.1, t3.1]
    have c0 :
      (#v[121666, 121666, 2 * 121666, 2 * 121665] : Vector (BitVec 64) 4)[((0 : Fin 4) : ℕ)].toNat =
        121666 := by
      decide
    have c1 :
      (#v[121666, 121666, 2 * 121666, 2 * 121665] : Vector (BitVec 64) 4)[((1 : Fin 4) : ℕ)].toNat =
        121666 := by
      decide
    have c2 :
      (#v[121666, 121666, 2 * 121666, 2 * 121665] : Vector (BitVec 64) 4)[((2 : Fin 4) : ℕ)].toNat =
        243332 := by
      decide
    have c3 :
      (#v[121666, 121666, 2 * 121666, 2 * 121665] : Vector (BitVec 64) 4)[((3 : Fin 4) : ℕ)].toNat =
        243330 := by
      decide
    rw [c0, c1, c2, c3]
    convert h using 1 <;> push_cast <;> ring
  · intro i e
    fin_cases e
    exacts [(r0.mono (by norm_num) (by norm_num)).2 i, (r1.mono (by norm_num) (by norm_num)).2 i,
      (r2.mono (by norm_num) (by norm_num)).2 i, (r3.mono (by norm_num) (by norm_num)).2 i]

/-- `self + other` of extended coordinates of `P`, reduced, and cached coordinates of `Q`, limbs
below `2^27` and `2^26`: extended coordinates of `P + Q`, reduced. -/
public theorem ExtendedPoint_Add_CachedPoint_add_impl_add.spec_val {x y : Fe2625x4} {P Q : Point}
    (hP : IsExtOf x P) (hx : Reduced x) (hQ : IsCachedOf y Q) (hy : Bounded y (2 ^ 27) (2 ^ 26)) :
    IsExtOf (ExtendedPoint_Add_CachedPoint_add_impl_add.spec x y) (P + Q) ∧
      Reduced (ExtendedPoint_Add_CachedPoint_add_impl_add.spec x y) := by
  obtain ⟨t0, t1, t2, t3⟩ := blend_diffSum hx
  have ht : Bounded (blend x (diffSum x) Lanes.AB) (5 * 2 ^ 26) (5 * 2 ^ 25 + 2 ^ 21) := by
    intro i e
    fin_cases e
    exacts [(t0.mono (by norm_num) (by norm_num)).2 i, (t1.mono (by norm_num) (by norm_num)).2 i,
      (t2.mono (by norm_num) (by norm_num)).2 i, (t3.mono (by norm_num) (by norm_num)).2 i]
  obtain ⟨hmv, hmb⟩ :=
    FieldElement2625x4_Mul_mul_impl_mul.spec_val ht (hy.mono (by norm_num) (by norm_num))
  rw [show
      ExtendedPoint_Add_CachedPoint_add_impl_add.spec x y =
        FieldElement2625x4_Mul_mul_impl_mul.spec
          (shuffle
            (diffSum
              (shuffle (FieldElement2625x4_Mul_mul_impl_mul.spec (blend x (diffSum x) Lanes.AB) y)
                Shuffle.ABDC))
            Shuffle.ADDA)
          (shuffle
            (diffSum
              (shuffle (FieldElement2625x4_Mul_mul_impl_mul.spec (blend x (diffSum x) Lanes.AB) y)
                Shuffle.ABDC))
            Shuffle.CBCB)
      from rfl]
  generalize FieldElement2625x4_Mul_mul_impl_mul.spec (blend x (diffSum x) Lanes.AB) y =
    m at hmv hmb ⊢
  have rm := Repr.of_bounded hmb
  have s0 := (rm 0).shuffle (e := 0) (c := Shuffle.ABDC) (by decide)
  have s1 := (rm 1).shuffle (e := 1) (c := Shuffle.ABDC) (by decide)
  have s2 := (rm 3).shuffle (e := 2) (c := Shuffle.ABDC) (by decide)
  have s3 := (rm 2).shuffle (e := 3) (c := Shuffle.ABDC) (by decide)
  obtain ⟨d0, d1, d2, d3⟩ :=
    Repr.diffSum (x := shuffle m Shuffle.ABDC) (z := ![val m 0, val m 1, val m 3, val m 2])
      (fun e => by
        fin_cases e; exacts [s0, s1, s2, s3])
      (by norm_num) (by norm_num)
  have a0 := d0.shuffle (e := 0) (c := Shuffle.ADDA) (by decide)
  have a1 := d3.shuffle (e := 1) (c := Shuffle.ADDA) (by decide)
  have a2 := d3.shuffle (e := 2) (c := Shuffle.ADDA) (by decide)
  have a3 := d0.shuffle (e := 3) (c := Shuffle.ADDA) (by decide)
  have b0 := d2.shuffle (e := 0) (c := Shuffle.CBCB) (by decide)
  have b1 := d1.shuffle (e := 1) (c := Shuffle.CBCB) (by decide)
  have b2 := d2.shuffle (e := 2) (c := Shuffle.CBCB) (by decide)
  have b3 := d1.shuffle (e := 3) (c := Shuffle.CBCB) (by decide)
  have ha :
    Bounded (shuffle (diffSum (shuffle m Shuffle.ABDC)) Shuffle.ADDA) (5 * 2 ^ 26)
      (5 * 2 ^ 25 + 2 ^ 21) := by
    intro i e
    fin_cases e
    exacts [(a0.mono (by norm_num) (by norm_num)).2 i, (a1.mono (by norm_num) (by norm_num)).2 i,
      (a2.mono (by norm_num) (by norm_num)).2 i, (a3.mono (by norm_num) (by norm_num)).2 i]
  have hb :
    Bounded (shuffle (diffSum (shuffle m Shuffle.ABDC)) Shuffle.CBCB) (3 * 2 ^ 26)
      (3 * 2 ^ 25 + 2 ^ 21) := by
    intro i e
    fin_cases e
    exacts [(b0.mono (by norm_num) (by norm_num)).2 i, (b1.mono (by norm_num) (by norm_num)).2 i,
      (b2.mono (by norm_num) (by norm_num)).2 i, (b3.mono (by norm_num) (by norm_num)).2 i]
  obtain ⟨hnv, hnb⟩ := FieldElement2625x4_Mul_mul_impl_mul.spec_val ha hb
  refine ⟨?_, hnb.mono (by norm_num) (by norm_num)⟩
  have h := isExt_add_cached hP hQ P.on Q.on
  dsimp only at h
  rw [← Point.add_x, ← Point.add_y] at h
  refine IsExt.congr h ?_ ?_ ?_ ?_ <;>
    simp only [hnv, a0.1, a1.1, a2.1, a3.1, b0.1, b1.1, b2.1, b3.1, hmv, t0.1, t1.1, t2.1, t3.1,
      Matrix.cons_val] <;>
    ring

/-- `-&other` of cached coordinates of `Q`, reduced: cached coordinates of `-Q`, limbs below
`2^27` and `2^26`. -/
public theorem cachedNeg_val {y : Fe2625x4} {Q : Point} (hQ : IsCachedOf y Q) (hy : Reduced y) :
    IsCachedOf (cachedNeg y) (-Q) ∧ Bounded (cachedNeg y) (2 ^ 27) (2 ^ 26) := by
  rw [show
      cachedNeg y = blend (shuffle y Shuffle.BACD) (negateLazy (shuffle y Shuffle.BACD)) Lanes.D
      from rfl]
  have ry := Repr.of_bounded hy
  have r0 :=
    ((ry 1).shuffle (e := 0) (c := Shuffle.BACD) (by decide)).blend_left (y :=
      negateLazy (shuffle y Shuffle.BACD)) (m := Lanes.D) (by decide)
  have r1 :=
    ((ry 0).shuffle (e := 1) (c := Shuffle.BACD) (by decide)).blend_left (y :=
      negateLazy (shuffle y Shuffle.BACD)) (m := Lanes.D) (by decide)
  have r2 :=
    ((ry 2).shuffle (e := 2) (c := Shuffle.BACD) (by decide)).blend_left (y :=
      negateLazy (shuffle y Shuffle.BACD)) (m := Lanes.D) (by decide)
  have r3 :=
    ((((ry 3).shuffle (e := 3) (c := Shuffle.BACD) (by decide)).negateLazy (by norm_num)
          (by norm_num)).blend_right
      (x := shuffle y Shuffle.BACD) (m := Lanes.D) (by decide))
  refine ⟨?_, ?_⟩
  · have h := hQ.neg
    unfold IsCachedOf
    rw [r0.1, r1.1, r2.1, r3.1, Point.neg_x, Point.neg_y]
    exact h
  · intro i e
    fin_cases e
    exacts [(r0.mono (by norm_num) (by norm_num)).2 i, (r1.mono (by norm_num) (by norm_num)).2 i,
      (r2.mono (by norm_num) (by norm_num)).2 i, r3.2 i]

/-- `self - other` of extended coordinates of `P` and cached coordinates of `Q`, both reduced:
extended coordinates of `P - Q`, reduced. -/
public theorem ExtendedPoint_Sub_CachedPoint_sub_impl_sub.spec_val {x y : Fe2625x4} {P Q : Point}
    (hP : IsExtOf x P) (hx : Reduced x) (hQ : IsCachedOf y Q) (hy : Reduced y) :
    IsExtOf (ExtendedPoint_Sub_CachedPoint_sub_impl_sub.spec x y) (P - Q) ∧
      Reduced (ExtendedPoint_Sub_CachedPoint_sub_impl_sub.spec x y) := by
  obtain ⟨hn, hb⟩ := cachedNeg_val hQ hy
  rw [sub_eq_add_neg]
  exact ExtendedPoint_Add_CachedPoint_add_impl_add.spec_val hP hx hn hb

/-! ## The globals -/

/-- `EXTENDEDPOINT_IDENTITY` holds extended coordinates `(0 : 1 : 1 : 0)` of the neutral point,
reduced. -/
public theorem EXTENDEDPOINT_IDENTITY.point_val :
    IsExtOf EXTENDEDPOINT_IDENTITY.point 0 ∧ Reduced EXTENDEDPOINT_IDENTITY.point := by
  have h (e : Fin 4) : val EXTENDEDPOINT_IDENTITY.point e = if e = 1 ∨ e = 2 then 1 else 0 := by
    rw [val, nat_eq]
    fin_cases e <;> decide
  refine
    ⟨?_, by
      unfold Reduced Bounded; decide⟩
  unfold IsExtOf
  rw [h, h, h, h, Point.zero_x, Point.zero_y]
  refine ⟨?_, ?_, ?_, ?_⟩ <;> simp

/-- Little-endian bytes of `N`, packed: `N`'s low `8 n` bits. -/
theorem packNat_bytes (n N : ℕ) :
    Ty.packNat 8 (List.ofFn fun i : Fin n => N >>> (8 * (i : ℕ)) % 2 ^ 8) = N % 2 ^ (8 * n) := by
  induction n generalizing N with
  | zero => simp [Ty.packNat, Nat.mod_one]
  | succ n ih =>
    rw [List.ofFn_succ, Ty.packNat]
    have h :
      (fun i : Fin n => N >>> (8 * ((Fin.succ i : Fin (n + 1)) : ℕ)) % 2 ^ 8) = fun i : Fin n =>
        (N >>> 8) >>> (8 * (i : ℕ)) % 2 ^ 8 := by
      funext i
      rw [← Nat.shiftRight_add, Fin.val_succ]
      ring_nf
    rw [h, ih]
    apply Nat.eq_of_testBit_eq
    intro k
    simp only [Nat.testBit_or, Nat.testBit_shiftLeft, Nat.testBit_mod_two_pow,
      Nat.testBit_shiftRight, Fin.val_zero, Nat.mul_zero, Nat.shiftRight_zero]
    by_cases hk : k < 8
    · simp [hk, show ¬8 ≤ k by omega, show k < 8 * (n + 1) by omega]
    · simp only [hk, decide_false, Bool.false_and, Bool.or_false, ge_iff_le, show 8 ≤ k by omega,
        decide_true, Bool.true_and]
      by_cases hk' : k < 8 * (n + 1)
      · simp only [show k - 8 < 8 * n by omega, hk', decide_true, Bool.true_and]
        congr 1
        omega
      · simp [hk', show ¬k - 8 < 8 * n by omega]

-- the table's width, `2 ^ 81920`, is unified with `2 ^ (8 * 10240)`
set_option exponentiation.threshold 81920 in
/-- The table literal's bits: `BaseTable.avx2Nat`. -/
theorem BASEPOINT_ODD_LOOKUP_TABLE.bits_eq :
    BASEPOINT_ODD_LOOKUP_TABLE.bits = BitVec.ofNat 81920 BaseTable.avx2Nat := by
  apply BitVec.eq_of_toNat_eq
  show
    (Ty.flatBits (t := .array 10240 (.bv 8)) BASEPOINT_ODD_LOOKUP_TABLE.lit (hw :=
          (by decide : (Ty.array 10240 (.bv 8)).width = 81920))).toNat =
      _
  rw [Ty.flatBits_eq, BitVec.toNat_cast, Ty.toNat_flattenRaw, BitVec.toNat_ofNat,
    BaseTable.avx2_lit]
  simp only [Ty.flattenNat, Vector.toList_ofFn, List.map_ofFn]
  have hp : Ty.padding (Ty.bv 8).width (Ty.bv 8).align + (Ty.bv 8).width = 8 := by decide
  rw [hp]
  generalize BaseTable.avx2Nat = N
  have hf :
    ((fun x => BitVec.toNat x) ∘ fun i : Fin 10240 => BitVec.ofNat 8 (N >>> (8 * ↑i))) =
      fun i : Fin 10240 => N >>> (8 * (i : ℕ)) % 2 ^ 8 := by
    funext i
    simp only [Function.comp_apply, BitVec.toNat_ofNat]
  rw [hf]
  exact packNat_bytes 10240 N

/-- Entry `j < 64` of `BASEPOINT_ODD_LOOKUP_TABLE` is `BaseTable.avx2Entry j`. -/
public theorem BASEPOINT_ODD_LOOKUP_TABLE.point_eq {j : ℕ} (hj : j < 64) :
    BASEPOINT_ODD_LOOKUP_TABLE.point j = BaseTable.avx2Entry j := by
  funext i
  apply Vector.ext
  intro l hl
  unfold BASEPOINT_ODD_LOOKUP_TABLE.point Fe2625x4.ofBits BaseTable.avx2Entry
  rw [BASEPOINT_ODD_LOOKUP_TABLE.bits_eq]
  generalize BaseTable.avx2Nat = N
  simp only [Vector.getElem_ofFn]
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.extractLsb'_toNat, BitVec.toNat_ofNat]
  apply Nat.eq_of_testBit_eq
  intro k
  simp only [Nat.testBit_mod_two_pow, Nat.testBit_shiftRight]
  have := i.isLt
  by_cases hk : k < 32
  · have h1 : 256 * (i : ℕ) + 32 * l + k < 1280 := by omega
    have h2 : 1280 * j + (256 * (i : ℕ) + 32 * l + k) < 81920 := by omega
    simp only [hk, h1, h2, decide_true, Bool.true_and]
    congr 1
    omega
  · simp [hk]

/-- Entry `j < 64` of `BASEPOINT_ODD_LOOKUP_TABLE` holds cached coordinates of `(2 j + 1) B`,
reduced. -/
public theorem BASEPOINT_ODD_LOOKUP_TABLE.point_val {j : ℕ} (hj : j < 64) :
    IsCachedOf (BASEPOINT_ODD_LOOKUP_TABLE.point j) ((2 * j + 1) • basePoint) ∧
      Reduced (BASEPOINT_ODD_LOOKUP_TABLE.point j) := by
  rw [BASEPOINT_ODD_LOOKUP_TABLE.point_eq hj]
  obtain ⟨h, hb⟩ := BaseTable.avx2_entry hj
  exact ⟨h, fun i e => ⟨(hb i e).1.trans (by norm_num), (hb i e).2.trans (by norm_num)⟩⟩

end Avx2

end MLIR.Agave
