module

public import Firedancer.Lane.Common.Verify
public import Ed25519.Limbs
import Firedancer.Math.Avx512.Mul
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring
import Std.Tactic.BVDecide

/-! The lane field operations in `ZMod p`: lane `j`'s value and limb bounds through each operation
of `fd_ed25519_lane.h`. -/

namespace MLIR.Firedancer.Lane

open _root_.Ed25519 (p)
open Firedancer.Avx512

/-! ## Definitions -/

@[expose] public section

/-- Lane `j`'s element. -/
abbrev Fe.val (a : Fe) (j : Fin 8) : ZMod p :=
  Ed25519.Limbs.val (a.lane j)

/-- Limb `i` of every lane at most `b i`. -/
def Fe.Le (a : Fe) (b : Fin 5 → ℕ) : Prop :=
  ∀ j i, (a.lane j i).toNat ≤ b i

/-- The bound of `fd_ed25519_lane_carry`'s output: limb 0 below `2^51 + 19 · 2^13`, the others
below `2^51 + 2^13`. -/
def carriedB : Fin 5 → ℕ :=
  fun i => if i = 0 then 2 ^ 51 - 1 + 19 * (2 ^ 13 - 1) else 2 ^ 51 - 1 + (2 ^ 13 - 1)

/-- "carried": `fd_ed25519_lane_carry`'s output. -/
abbrev Fe.Carried (a : Fe) : Prop :=
  a.Le carriedB

/-- "f52": every limb below `2^52`, the IFMA input requirement. -/
abbrev Fe.F52 (a : Fe) : Prop :=
  a.Le fun _ => 2 ^ 52 - 1

/-- "loose": an uncarried product, every limb below `267 · 2^52`. -/
abbrev Fe.Loose (a : Fe) : Prop :=
  a.Le fun _ => 267 * 2 ^ 52

end

/-! ## Lane access -/

/-! Each `wwl` operation at lane `j < 8`. -/

@[simp] public theorem getElem_wwl_add (x y : Wwl) (j : ℕ) (hj : j < 8) :
    (wwl_add x y)[j] = x[j] + y[j] := by
  simp [wwl_add]

@[simp] public theorem getElem_wwl_sub (x y : Wwl) (j : ℕ) (hj : j < 8) :
    (wwl_sub x y)[j] = x[j] - y[j] := by
  simp [wwl_sub]

@[simp] public theorem getElem_wwl_mul (x y : Wwl) (j : ℕ) (hj : j < 8) :
    (wwl_mul x y)[j] = x[j] * y[j] := by
  simp [wwl_mul]

@[simp] public theorem getElem_wwl_and (x y : Wwl) (j : ℕ) (hj : j < 8) :
    (wwl_and x y)[j] = x[j] &&& y[j] := by
  simp [wwl_and]

@[simp] public theorem getElem_wwl_shru (x : Wwl) (n : ℕ) (j : ℕ) (hj : j < 8) :
    (wwl_shru x n)[j] = x[j] >>> n := by
  simp [wwl_shru]

@[simp] public theorem getElem_wwl_madd52lo (a x y : Wwl) (j : ℕ) (hj : j < 8) :
    (wwl_madd52lo a x y)[j] = a[j] + madd52lo x[j] y[j] := by
  simp [wwl_madd52lo]

@[simp] public theorem getElem_wwl_madd52hi (a x y : Wwl) (j : ℕ) (hj : j < 8) :
    (wwl_madd52hi a x y)[j] = a[j] + madd52hi x[j] y[j] := by
  simp [wwl_madd52hi]

@[simp] public theorem getElem_wwl_bcast (x : BitVec 64) (j : ℕ) (hj : j < 8) :
    (wwl_bcast x)[j] = x := by
  simp [wwl_bcast]

@[simp] public theorem getElem_wwl_zero (j : ℕ) (hj : j < 8) : (wwl_zero)[j] = 0 := by
  simp

@[simp] public theorem getElem_wwl_if (c : BitVec 32) (x y : Wwl) (j : ℕ) (hj : j < 8) :
    (wwl_if c x y)[j] = if c.getLsbD j then x[j] else y[j] := by
  simp [wwl_if]

@[simp] public theorem Fe.lane_zero (a : Fe) (j : Fin 8) : a.lane j 0 = a.l0[(j : ℕ)] := rfl
@[simp] public theorem Fe.lane_one (a : Fe) (j : Fin 8) : a.lane j 1 = a.l1[(j : ℕ)] := rfl
@[simp] public theorem Fe.lane_two (a : Fe) (j : Fin 8) : a.lane j 2 = a.l2[(j : ℕ)] := rfl
@[simp] public theorem Fe.lane_three (a : Fe) (j : Fin 8) : a.lane j 3 = a.l3[(j : ℕ)] := rfl
@[simp] public theorem Fe.lane_four (a : Fe) (j : Fin 8) : a.lane j 4 = a.l4[(j : ℕ)] := rfl

public theorem Fe.limb_zipWith (f : Wwl → Wwl → Wwl) (a b : Fe) (i : Fin 5) :
    (Fe.zipWith f a b).limb i = f (a.limb i) (b.limb i) := by
  fin_cases i <;> rfl

public theorem Fe.lane_bcast2 (l0 l : BitVec 64) (j : Fin 8) (i : Fin 5) :
    (Fe.bcast2 l0 l).lane j i = if i = 0 then l0 else l := by
  fin_cases i <;> simp [Fe.bcast2]

/-- Lane `j`'s element, limb by limb. -/
public theorem Fe.val_eq (a : Fe) (j : Fin 8) :
    a.val j = (a.l0[(j : ℕ)].toNat : ZMod p) + a.l1[(j : ℕ)].toNat * 2 ^ 51 +
      a.l2[(j : ℕ)].toNat * 2 ^ 102 + a.l3[(j : ℕ)].toNat * 2 ^ 153 +
      a.l4[(j : ℕ)].toNat * 2 ^ 204 :=
  Ed25519.Limbs.val_eq _

/-! ## Lanes -/

public theorem Fe.ofLanes_lane (f : Fin 8 → Fin 5 → BitVec 64) (j : Fin 8) :
    (Fe.ofLanes f).lane j = f j := by
  funext i
  fin_cases i <;> simp [Fe.lane, Fe.limb, Fe.ofLanes]

public theorem Fe.ite_lane (c : BitVec 32) (a b : Fe) (j : Fin 8) :
    (Fe.ite c a b).lane j = if c.getLsbD j then a.lane j else b.lane j := by
  funext i
  simp only [Fe.lane, Fe.ite, Fe.limb_zipWith, Fin.getElem_fin, getElem_wwl_if]
  split <;> rfl

public theorem Fe.one_val (j : Fin 8) : Fe.one.val j = 1 := by
  simp [Fe.val_eq, Fe.one, Fe.small]

public theorem Fe.zero_val (j : Fin 8) : Fe.zero.val j = 0 := by
  simp [Fe.val_eq, Fe.zero, Fe.small]

public theorem Fe.one_carried : Fe.one.Carried := by
  intro j i
  fin_cases i <;> simp [Fe.one, Fe.small, carriedB]

public theorem Fe.zero_carried : Fe.zero.Carried := by
  intro j i
  fin_cases i <;> simp [Fe.zero, Fe.small, carriedB]

public theorem Fe.Le.mono {a : Fe} {b c : Fin 5 → ℕ} (h : a.Le b) (hbc : ∀ i, b i ≤ c i) :
    a.Le c := fun j i => (h j i).trans (hbc i)

public theorem Fe.Carried.f52 {a : Fe} (h : a.Carried) : a.F52 := by
  refine h.mono fun i => ?_
  unfold carriedB
  split <;> norm_num

public theorem Fe.F52.loose {a : Fe} (h : a.F52) : a.Loose := by
  exact h.mono fun _ => by norm_num

/-! ## Carries and sums -/

theorem toNat_and_mask51 (x : BitVec 64) : (x &&& mask51).toNat = x.toNat % 2 ^ 51 :=
  Ed25519.toNat_and_mask x

/-- A carry into limb `i > 0` in `ℕ`. -/
theorem carry_limb_toNat (x y : BitVec 64) :
    ((x &&& mask51) + (y >>> 51)).toNat = x.toNat % 2 ^ 51 + y.toNat / 2 ^ 51 := by
  have := y.isLt
  rw [BitVec.toNat_add, toNat_and_mask51, Ed25519.toNat_shift, Nat.mod_eq_of_lt (by omega)]

/-- The top carry folded into limb 0 in `ℕ`. -/
theorem carry_limb0_toNat (x y : BitVec 64) :
    ((x &&& mask51) + madd52lo (y >>> 51) 19).toNat = x.toNat % 2 ^ 51 + y.toNat / 2 ^ 51 * 19 := by
  have := y.isLt
  have hy : (y >>> 51).toNat < 2 ^ 52 := by rw [Ed25519.toNat_shift]; omega
  rw [BitVec.toNat_add, toNat_and_mask51, R43x6.madd52lo_toNat hy (by decide), Ed25519.toNat_shift,
    show (19 : BitVec 64).toNat = 19 from rfl,
    Nat.mod_eq_of_lt (a := y.toNat / 2 ^ 51 * 19) (by omega), Nat.mod_eq_of_lt (by omega)]

/-- A sum without overflow in `ℕ`. -/
theorem toNat_add_of_lt {x y : BitVec 64} (h : x.toNat + y.toNat < 2 ^ 64) :
    (x + y).toNat = x.toNat + y.toNat := by
  rw [BitVec.toNat_add, Nat.mod_eq_of_lt h]

public theorem addRaw_lane (a b : Fe) (j : Fin 8) (i : Fin 5) :
    (addRaw a b).lane j i = a.lane j i + b.lane j i := by
  simp only [Fe.lane, addRaw, Fe.limb_zipWith, Fin.getElem_fin, getElem_wwl_add]

public theorem subOff_lane (c a b : Fe) (j : Fin 8) (i : Fin 5) :
    (subOff c a b).lane j i = a.lane j i + c.lane j i - b.lane j i := by
  simp only [Fe.lane, subOff, Fe.limb_zipWith, Fin.getElem_fin, getElem_wwl_add, getElem_wwl_sub]

/-- The weighted sum of the limbs `c0, c, c, c, c`. -/
theorem sum_bcast2 (c0 c : BitVec 64) :
    ∑ i : Fin 5, (((if i = 0 then c0 else c).toNat : ℕ) : ZMod p) * 2 ^ (51 * (i : ℕ)) =
      ((c0.toNat + c.toNat * (2 ^ 51 + 2 ^ 102 + 2 ^ 153 + 2 ^ 204) : ℕ) : ZMod p) := by
  simp only [Fin.sum_univ_five]
  push_cast
  simp
  ring

/-- `fd_ed25519_lane_carry` keeps the value, for any limbs. -/
public theorem carry_val (r : Fe) (j : Fin 8) : (carry r).val j = r.val j := by
  simp only [Fe.val_eq, carry, getElem_wwl_madd52lo, getElem_wwl_and, getElem_wwl_shru,
    getElem_wwl_bcast, getElem_wwl_add, carry_limb_toNat, carry_limb0_toNat]
  push_cast
  linear_combination Ed25519.mod_add_div51 (r.l0[(j : ℕ)].toNat) +
    2 ^ 51 * Ed25519.mod_add_div51 (r.l1[(j : ℕ)].toNat) +
    2 ^ 102 * Ed25519.mod_add_div51 (r.l2[(j : ℕ)].toNat) +
    2 ^ 153 * Ed25519.mod_add_div51 (r.l3[(j : ℕ)].toNat) +
    2 ^ 204 * Ed25519.mod_add_div51 (r.l4[(j : ℕ)].toNat) -
    ((r.l4[(j : ℕ)].toNat / 2 ^ 51 : ℕ) : ZMod p) * Ed25519.two_pow_255

/-- `fd_ed25519_lane_carry`'s limbs in `ℕ`. -/
public theorem carry_lane (r : Fe) (j : Fin 8) :
    ((carry r).lane j 0).toNat = (r.lane j 0).toNat % 2 ^ 51 + (r.lane j 4).toNat / 2 ^ 51 * 19 ∧
      ((carry r).lane j 1).toNat = (r.lane j 1).toNat % 2 ^ 51 + (r.lane j 0).toNat / 2 ^ 51 ∧
      ((carry r).lane j 2).toNat = (r.lane j 2).toNat % 2 ^ 51 + (r.lane j 1).toNat / 2 ^ 51 ∧
      ((carry r).lane j 3).toNat = (r.lane j 3).toNat % 2 ^ 51 + (r.lane j 2).toNat / 2 ^ 51 ∧
      ((carry r).lane j 4).toNat = (r.lane j 4).toNat % 2 ^ 51 + (r.lane j 3).toNat / 2 ^ 51 := by
  simp only [Fe.lane_zero, Fe.lane_one, Fe.lane_two, Fe.lane_three, Fe.lane_four, carry,
    getElem_wwl_madd52lo, getElem_wwl_and, getElem_wwl_shru, getElem_wwl_bcast, getElem_wwl_add,
    carry_limb_toNat, carry_limb0_toNat, and_self]

public theorem carry_carried (r : Fe) : (carry r).Carried := by
  intro j i
  obtain ⟨h0, h1, h2, h3, h4⟩ := carry_lane r j
  have := (r.lane j 0).isLt; have := (r.lane j 1).isLt; have := (r.lane j 2).isLt
  have := (r.lane j 3).isLt; have := (r.lane j 4).isLt
  fin_cases i <;> simp only [Fin.zero_eta, Fin.mk_one, Fin.reduceFinMk, h0, h1, h2, h3, h4,
    carriedB] <;> simp <;> omega

public theorem addRaw_val {a b : Fe} {A B : Fin 5 → ℕ} (ha : a.Le A) (hb : b.Le B)
    (h : ∀ i, A i + B i < 2 ^ 64) (j : Fin 8) :
    (addRaw a b).val j = a.val j + b.val j := by
  have e (i : Fin 5) : (((addRaw a b).lane j i).toNat : ZMod p) =
      ((a.lane j i).toNat : ZMod p) + (b.lane j i).toNat := by
    rw [addRaw_lane, toNat_add_of_lt (by have := ha j i; have := hb j i; have := h i; omega)]
    push_cast; rfl
  simp only [Fe.val, Ed25519.Limbs.val, e, add_mul, Finset.sum_add_distrib]

public theorem addRaw_le {a b : Fe} {A B : Fin 5 → ℕ} (ha : a.Le A) (hb : b.Le B)
    (h : ∀ i, A i + B i < 2 ^ 64) : (addRaw a b).Le fun i => A i + B i := by
  intro j i
  rw [addRaw_lane, toNat_add_of_lt (by have := ha j i; have := hb j i; have := h i; omega)]
  exact Nat.add_le_add (ha j i) (hb j i)

/-- `a + c - b` with a constant `c ≡ 0` of limbs `c0, c, c, c, c` covering `b`. -/
public theorem subOff_val {a b : Fe} {A B : Fin 5 → ℕ} {c0 c : BitVec 64} (ha : a.Le A)
    (hb : b.Le B) (hc : ∀ i, B i ≤ (if i = 0 then c0 else c).toNat)
    (h : ∀ i, A i + (if i = 0 then c0 else c).toNat < 2 ^ 64)
    (hp : ((c0.toNat + c.toNat * (2 ^ 51 + 2 ^ 102 + 2 ^ 153 + 2 ^ 204) : ℕ) : ZMod p) = 0)
    (j : Fin 8) :
    (subOff (Fe.bcast2 c0 c) a b).val j = a.val j - b.val j := by
  have e (i : Fin 5) : (((subOff (Fe.bcast2 c0 c) a b).lane j i).toNat : ZMod p) =
      ((a.lane j i).toNat : ZMod p) + ((if i = 0 then c0 else c).toNat : ℕ) -
        (b.lane j i).toNat := by
    have := ha j i; have := hb j i; have := hc i; have := h i
    rw [subOff_lane, Fe.lane_bcast2, BitVec.toNat_sub_of_le, toNat_add_of_lt (by omega),
      Nat.cast_sub (by omega), Nat.cast_add]
    rw [BitVec.le_def, toNat_add_of_lt (by omega)]
    omega
  simp only [Fe.val, Ed25519.Limbs.val, e, add_mul, sub_mul, Finset.sum_add_distrib,
    Finset.sum_sub_distrib, sum_bcast2, hp, add_zero]

public theorem subOff_le {a b : Fe} {A B : Fin 5 → ℕ} {c0 c : BitVec 64} (ha : a.Le A)
    (hb : b.Le B) (hc : ∀ i, B i ≤ (if i = 0 then c0 else c).toNat)
    (h : ∀ i, A i + (if i = 0 then c0 else c).toNat < 2 ^ 64) :
    (subOff (Fe.bcast2 c0 c) a b).Le fun i => A i + (if i = 0 then c0 else c).toNat := by
  intro j i
  dsimp only
  have := ha j i; have := hb j i; have := hc i; have := h i
  rw [subOff_lane, Fe.lane_bcast2, BitVec.toNat_sub_of_le, toNat_add_of_lt (by omega)]
  · omega
  · rw [BitVec.le_def, toNat_add_of_lt (by omega)]
    omega

/-- `2p`'s limbs cover a carried element's. -/
theorem twoP_cover (i : Fin 5) :
    carriedB i ≤ (if i = 0 then (2 ^ 52 - 38 : BitVec 64) else 2 ^ 52 - 2).toNat := by
  unfold carriedB; split_ifs <;> decide

theorem twoP_lt (i : Fin 5) :
    (if i = 0 then (2 ^ 52 - 38 : BitVec 64) else 2 ^ 52 - 2).toNat ≤ 2 ^ 52 - 2 := by
  split_ifs <;> decide

theorem natCast_mul_p (k : ℕ) : ((k * p : ℕ) : ZMod p) = 0 := by
  rw [Nat.cast_mul, ZMod.natCast_self, mul_zero]

theorem twoP_zero :
    ((((2 ^ 52 - 38 : BitVec 64)).toNat + (2 ^ 52 - 2 : BitVec 64).toNat *
        (2 ^ 51 + 2 ^ 102 + 2 ^ 153 + 2 ^ 204) : ℕ) : ZMod p) = 0 := by
  rw [show ((2 ^ 52 - 38 : BitVec 64)).toNat + (2 ^ 52 - 2 : BitVec 64).toNat *
      (2 ^ 51 + 2 ^ 102 + 2 ^ 153 + 2 ^ 204) = 2 * p by decide, natCast_mul_p]

/-- `fd_ed25519_lane_sub_raw`, `b` within `2p`. -/
public theorem subRaw_val {a b : Fe} {A : Fin 5 → ℕ} (ha : a.Le A) (hb : b.Carried)
    (h : ∀ i, A i < 2 ^ 63) (j : Fin 8) : (subRaw a b).val j = a.val j - b.val j := by
  exact subOff_val ha hb twoP_cover (fun i => by have := h i; have := twoP_lt i; omega) twoP_zero j

public theorem subRaw_le {a b : Fe} {A : Fin 5 → ℕ} (ha : a.Le A) (hb : b.Carried)
    (h : ∀ i, A i < 2 ^ 63) : (subRaw a b).Le fun i => A i + 2 ^ 52 := by
  exact (subOff_le ha hb twoP_cover fun i => by have := h i; have := twoP_lt i; omega).mono
    fun i => by have := twoP_lt i; omega

public theorem neg_lane (a : Fe) (j : Fin 8) (i : Fin 5) :
    (neg a).lane j i = (if i = 0 then (2 ^ 52 - 38 : BitVec 64) else 2 ^ 52 - 2) - a.lane j i := by
  rw [← Fe.lane_bcast2 _ _ j]
  simp only [Fe.lane, neg, twoP, Fe.limb_zipWith, Fin.getElem_fin, getElem_wwl_sub]

/-- `fd_ed25519_lane_neg` of a carried element: f52. -/
public theorem neg_val {a : Fe} (ha : a.Carried) (j : Fin 8) : (neg a).val j = -a.val j := by
  have e (i : Fin 5) : (((neg a).lane j i).toNat : ZMod p) =
      (((if i = 0 then (2 ^ 52 - 38 : BitVec 64) else 2 ^ 52 - 2).toNat : ℕ) : ZMod p) -
        (a.lane j i).toNat := by
    have := ha j i; have := twoP_cover i
    rw [neg_lane, BitVec.toNat_sub_of_le (by rw [BitVec.le_def]; omega), Nat.cast_sub (by omega)]
  simp only [Fe.val, Ed25519.Limbs.val, e, sub_mul, Finset.sum_sub_distrib, sum_bcast2, twoP_zero,
    zero_sub]

public theorem neg_f52 {a : Fe} (ha : a.Carried) : (neg a).F52 := by
  intro j i
  dsimp only
  have := ha j i; have := twoP_cover i; have := twoP_lt i
  rw [neg_lane, BitVec.toNat_sub_of_le (by rw [BitVec.le_def]; omega)]
  omega

public theorem add_val {a b : Fe} (ha : a.F52) (hb : b.F52) (j : Fin 8) :
    (add a b).val j = a.val j + b.val j := by
  rw [add, carry_val, addRaw_val ha hb fun _ => by norm_num]

/-- `fd_ed25519_lane_sub` for any f52 `b`. -/
public theorem sub_val {a b : Fe} (ha : a.F52) (hb : b.F52) (j : Fin 8) :
    (sub a b).val j = a.val j - b.val j := by
  rw [sub, carry_val]
  refine subOff_val ha hb (fun i => by split_ifs <;> decide) (fun i => by split_ifs <;> decide) ?_ j
  rw [show (2 * (2 ^ 52 - 38) : BitVec 64).toNat + (2 * (2 ^ 52 - 2) : BitVec 64).toNat *
      (2 ^ 51 + 2 ^ 102 + 2 ^ 153 + 2 ^ 204) = 4 * p by decide, natCast_mul_p]

theorem shl_toNat {n k : ℕ} (hn : n ≤ 2 ^ 51) (hk : k ≤ 12) :
    (((n <<< k : ℕ)) : BitVec 64).toNat = n * 2 ^ k := by
  have : 2 ^ k ≤ 2 ^ 12 := Nat.pow_le_pow_right (by norm_num) hk
  have : n * 2 ^ k ≤ 2 ^ 51 * 2 ^ 12 := Nat.mul_le_mul hn this
  rw [BitVec.natCast_eq_ofNat, BitVec.toNat_ofNat, Nat.shiftLeft_eq, Nat.mod_eq_of_lt (by omega)]

/-- `2^k p`'s limbs in `ℕ`. -/
theorem bigP_toNat (i : Fin 5) {k : ℕ} (hk : k ≤ 12) :
    (if i = 0 then (((2 ^ 51 - 19) <<< k : ℕ) : BitVec 64) else (((2 ^ 51 - 1) <<< k : ℕ))).toNat =
      (if i = 0 then 2 ^ 51 - 19 else 2 ^ 51 - 1) * 2 ^ k := by
  split_ifs <;> exact shl_toNat (by norm_num) hk

/-- `fd_ed25519_lane_sub_big`: `a + 2^k p - b`, `b` within `2^k p`. -/
public theorem subBig_val {a b : Fe} {A B : Fin 5 → ℕ} {k : ℕ} (hk : k ≤ 12) (ha : a.Le A)
    (hb : b.Le B) (hB : ∀ i, B i ≤ (if i = 0 then 2 ^ 51 - 19 else 2 ^ 51 - 1) * 2 ^ k)
    (h : ∀ i, A i + (2 ^ 51 - 1) * 2 ^ k < 2 ^ 64) (j : Fin 8) :
    (subBig a b k).val j = a.val j - b.val j := by
  refine subOff_val (c0 := (((2 ^ 51 - 19) <<< k : ℕ) : BitVec 64))
    (c := (((2 ^ 51 - 1) <<< k : ℕ) : BitVec 64)) ha hb (fun i => (bigP_toNat i hk).symm ▸ hB i)
    (fun i => by rw [bigP_toNat i hk]; have := h i; split_ifs <;> omega) ?_ j
  rw [shl_toNat (by norm_num) hk, shl_toNat (by norm_num) hk,
    show (2 ^ 51 - 19) * 2 ^ k + (2 ^ 51 - 1) * 2 ^ k * (2 ^ 51 + 2 ^ 102 + 2 ^ 153 + 2 ^ 204) =
        2 ^ k * p by
      rw [show p = (2 ^ 51 - 19) + (2 ^ 51 - 1) * (2 ^ 51 + 2 ^ 102 + 2 ^ 153 + 2 ^ 204) by decide]
      ring,
    natCast_mul_p]

public theorem subBig_le {a b : Fe} {A B : Fin 5 → ℕ} {k : ℕ} (hk : k ≤ 12) (ha : a.Le A)
    (hb : b.Le B) (hB : ∀ i, B i ≤ (if i = 0 then 2 ^ 51 - 19 else 2 ^ 51 - 1) * 2 ^ k)
    (h : ∀ i, A i + (2 ^ 51 - 1) * 2 ^ k < 2 ^ 64) :
    (subBig a b k).Le fun i => A i + (2 ^ 51 - 1) * 2 ^ k := by
  refine (subOff_le (c0 := (((2 ^ 51 - 19) <<< k : ℕ) : BitVec 64))
    (c := (((2 ^ 51 - 1) <<< k : ℕ) : BitVec 64)) ha hb (fun i => (bigP_toNat i hk).symm ▸ hB i)
    (fun i => by rw [bigP_toNat i hk]; have := h i; split_ifs <;> omega)).mono fun i => ?_
  rw [bigP_toNat i hk]
  split_ifs <;> omega

/-! ## Zero tests -/

/-- One carry pass of `fd_ed25519_lane_normalize`. -/
def normPass (a : Fe) : Fe :=
  let mask := wwl_bcast mask51
  let l1 := wwl_add a.l1 (wwl_shru a.l0 51)
  let l0 := wwl_and a.l0 mask
  let l2 := wwl_add a.l2 (wwl_shru l1 51)
  let l1 := wwl_and l1 mask
  let l3 := wwl_add a.l3 (wwl_shru l2 51)
  let l2 := wwl_and l2 mask
  let l4 := wwl_add a.l4 (wwl_shru l3 51)
  let l3 := wwl_and l3 mask
  let l0 := wwl_add l0 (wwl_mul (wwl_shru l4 51) (wwl_bcast 19))
  let l4 := wwl_and l4 mask
  ⟨l0, l1, l2, l3, l4⟩

theorem normalize_eq (a : Fe) : normalize a = normPass (normPass a) := rfl

/-- A carry `y >>> 51` into `x` in `ℕ`. -/
theorem add_shr_toNat {x y : BitVec 64} {n m : ℕ} (hx : x.toNat = n) (hy : y.toNat = m)
    (h : n + m / 2 ^ 51 < 2 ^ 64) : (x + (y >>> 51)).toNat = n + m / 2 ^ 51 := by
  rw [toNat_add_of_lt] <;> rw [Ed25519.toNat_shift, hx, hy]
  exact h

/-- `normPass`'s limbs in `ℕ`, for limbs below `2^62`. -/
theorem normPass_lane (a : Fe) (j : Fin 8) (h : ∀ i, (a.lane j i).toNat < 2 ^ 62) :
    ((normPass a).lane j 0).toNat = (a.lane j 0).toNat % 2 ^ 51 +
        ((a.lane j 4).toNat + ((a.lane j 3).toNat + ((a.lane j 2).toNat + ((a.lane j 1).toNat +
          (a.lane j 0).toNat / 2 ^ 51) / 2 ^ 51) / 2 ^ 51) / 2 ^ 51) / 2 ^ 51 * 19 ∧
      ((normPass a).lane j 1).toNat = ((a.lane j 1).toNat + (a.lane j 0).toNat / 2 ^ 51) % 2 ^ 51 ∧
      ((normPass a).lane j 2).toNat = ((a.lane j 2).toNat + ((a.lane j 1).toNat +
        (a.lane j 0).toNat / 2 ^ 51) / 2 ^ 51) % 2 ^ 51 ∧
      ((normPass a).lane j 3).toNat = ((a.lane j 3).toNat + ((a.lane j 2).toNat +
        ((a.lane j 1).toNat + (a.lane j 0).toNat / 2 ^ 51) / 2 ^ 51) / 2 ^ 51) % 2 ^ 51 ∧
      ((normPass a).lane j 4).toNat = ((a.lane j 4).toNat + ((a.lane j 3).toNat +
        ((a.lane j 2).toNat + ((a.lane j 1).toNat + (a.lane j 0).toNat / 2 ^ 51) / 2 ^ 51) /
          2 ^ 51) / 2 ^ 51) % 2 ^ 51 := by
  have h0 := h 0; have h1 := h 1; have h2 := h 2; have h3 := h 3; have h4 := h 4
  simp only [Fe.lane_zero, Fe.lane_one, Fe.lane_two, Fe.lane_three, Fe.lane_four] at *
  simp only [normPass, getElem_wwl_add, getElem_wwl_and, getElem_wwl_shru, getElem_wwl_mul,
    getElem_wwl_bcast, toNat_and_mask51]
  generalize a.l0[(j : ℕ)] = x0 at *
  generalize a.l1[(j : ℕ)] = x1 at *
  generalize a.l2[(j : ℕ)] = x2 at *
  generalize a.l3[(j : ℕ)] = x3 at *
  generalize a.l4[(j : ℕ)] = x4 at *
  have e1 := add_shr_toNat rfl rfl (x := x1) (y := x0) (by omega)
  generalize x1 + (x0 >>> 51) = t1 at *
  have e2 := add_shr_toNat rfl e1 (x := x2) (by omega)
  generalize x2 + (t1 >>> 51) = t2 at *
  have e3 := add_shr_toNat rfl e2 (x := x3) (by omega)
  generalize x3 + (t2 >>> 51) = t3 at *
  have e4 := add_shr_toNat rfl e3 (x := x4) (by omega)
  generalize x4 + (t3 >>> 51) = t4 at *
  refine ⟨?_, by rw [e1], by rw [e2], by rw [e3], by rw [e4]⟩
  have := t4.isLt
  have e5 : ((t4 >>> 51) * 19).toNat = t4.toNat / 2 ^ 51 * 19 := by
    rw [BitVec.toNat_mul, Ed25519.toNat_shift, show (19 : BitVec 64).toNat = 19 from rfl,
      Nat.mod_eq_of_lt (by omega)]
  rw [toNat_add_of_lt (by rw [toNat_and_mask51, e5]; omega), toNat_and_mask51, e5, e4]

/-- A carry pass, the top carry folded by `19`, keeps the value. -/
theorem pass_val {x0 x1 x2 x3 x4 t1 t2 t3 t4 : ℕ} (h1 : t1 = x1 + x0 / 2 ^ 51)
    (h2 : t2 = x2 + t1 / 2 ^ 51) (h3 : t3 = x3 + t2 / 2 ^ 51) (h4 : t4 = x4 + t3 / 2 ^ 51) :
    ((x0 % 2 ^ 51 + t4 / 2 ^ 51 * 19 : ℕ) : ZMod p) + (t1 % 2 ^ 51 : ℕ) * 2 ^ 51 +
        (t2 % 2 ^ 51 : ℕ) * 2 ^ 102 + (t3 % 2 ^ 51 : ℕ) * 2 ^ 153 + (t4 % 2 ^ 51 : ℕ) * 2 ^ 204 =
      x0 + x1 * 2 ^ 51 + x2 * 2 ^ 102 + x3 * 2 ^ 153 + x4 * 2 ^ 204 := by
  have T1 := congrArg (Nat.cast (R := ZMod p)) h1
  have T2 := congrArg (Nat.cast (R := ZMod p)) h2
  have T3 := congrArg (Nat.cast (R := ZMod p)) h3
  have T4 := congrArg (Nat.cast (R := ZMod p)) h4
  push_cast at T1 T2 T3 T4 ⊢
  linear_combination Ed25519.mod_add_div51 x0 + 2 ^ 51 * Ed25519.mod_add_div51 t1 +
    2 ^ 102 * Ed25519.mod_add_div51 t2 + 2 ^ 153 * Ed25519.mod_add_div51 t3 +
    2 ^ 204 * Ed25519.mod_add_div51 t4 + 2 ^ 51 * T1 + 2 ^ 102 * T2 + 2 ^ 153 * T3 + 2 ^ 204 * T4 -
    ((t4 / 2 ^ 51 : ℕ) : ZMod p) * Ed25519.two_pow_255

theorem getLsbD_packLanes_bv1 (v : Vector (BitVec 1) 8) (i : ℕ) (hi : i < 8) :
    (BitVec.packLanes v).getLsbD i = v[i].getLsbD 0 := by
  have h := congrArg (·.getLsbD 0) (BitVec.extractLsb'_packLanes v i (by omega))
  simpa using h

theorem wwl_eq_getLsbD (x y : Wwl) (j : ℕ) (hj : j < 8) :
    (wwl_eq x y).getLsbD j = decide (x[j] = y[j]) := by
  rw [wwl_eq, BitVec.getLsbD_setWidth, getLsbD_packLanes_bv1 _ _ hj]
  by_cases h : x[j] = y[j] <;> simp [h, show j < 32 by omega]

/-- Limbs below `2^51` are `0`'s or `p`'s exactly when their number is `0 mod p`. -/
theorem zero_iff_limbs {y0 y1 y2 y3 y4 : ℕ} (h0 : y0 < 2 ^ 51) (h1 : y1 < 2 ^ 51)
    (h2 : y2 < 2 ^ 51) (h3 : y3 < 2 ^ 51) (h4 : y4 < 2 ^ 51) :
    ((y0 = 0 ∧ y1 = 0 ∧ y2 = 0 ∧ y3 = 0 ∧ y4 = 0) ∨
        (y0 = 2 ^ 51 - 19 ∧ y1 = 2 ^ 51 - 1 ∧ y2 = 2 ^ 51 - 1 ∧ y3 = 2 ^ 51 - 1 ∧
          y4 = 2 ^ 51 - 1)) ↔
      (y0 : ZMod p) + y1 * 2 ^ 51 + y2 * 2 ^ 102 + y3 * 2 ^ 153 + y4 * 2 ^ 204 = 0 := by
  rw [show (y0 : ZMod p) + y1 * 2 ^ 51 + y2 * 2 ^ 102 + y3 * 2 ^ 153 + y4 * 2 ^ 204 =
      ((y0 + y1 * 2 ^ 51 + y2 * 2 ^ 102 + y3 * 2 ^ 153 + y4 * 2 ^ 204 : ℕ) : ZMod p) by
        push_cast; rfl,
    ZMod.natCast_eq_zero_iff]
  constructor
  · rintro (⟨rfl, rfl, rfl, rfl, rfl⟩ | ⟨rfl, rfl, rfl, rfl, rfl⟩)
    · exact dvd_zero _
    · exact ⟨1, by norm_num⟩
  · rintro ⟨k, hk⟩
    norm_num at hk
    rcases (by omega : k = 0 ∨ k = 1) with rfl | rfl
    · left; omega
    · right; omega

theorem normPass_val (a : Fe) (j : Fin 8) (h : ∀ i, (a.lane j i).toNat < 2 ^ 62) :
    (normPass a).val j = a.val j := by
  obtain ⟨e0, e1, e2, e3, e4⟩ := normPass_lane a j h
  rw [Fe.val, Fe.val, Ed25519.Limbs.val_eq, Ed25519.Limbs.val_eq, e0, e1, e2, e3, e4]
  exact pass_val rfl rfl rfl rfl

/-- The first pass's top carry is at most `4`. -/
theorem pass1_lt {x0 x1 x2 x3 x4 : ℕ} (h0 : x0 < 2 ^ 53) (h1 : x1 < 2 ^ 53) (h2 : x2 < 2 ^ 53)
    (h3 : x3 < 2 ^ 53) (h4 : x4 < 2 ^ 53) :
    x0 % 2 ^ 51 + (x4 + (x3 + (x2 + (x1 + x0 / 2 ^ 51) / 2 ^ 51) / 2 ^ 51) / 2 ^ 51) / 2 ^ 51 * 19 <
      2 ^ 51 + 2 ^ 7 := by
  have hc1 : (x1 + x0 / 2 ^ 51) / 2 ^ 51 ≤ 4 := by omega
  generalize (x1 + x0 / 2 ^ 51) / 2 ^ 51 = c1 at *
  have hc2 : (x2 + c1) / 2 ^ 51 ≤ 4 := by omega
  generalize (x2 + c1) / 2 ^ 51 = c2 at *
  have hc3 : (x3 + c2) / 2 ^ 51 ≤ 4 := by omega
  generalize (x3 + c2) / 2 ^ 51 = c3 at *
  have hc4 : (x4 + c3) / 2 ^ 51 ≤ 4 := by omega
  generalize (x4 + c3) / 2 ^ 51 = c4 at *
  omega

/-- The second pass leaves limb 0 below `2^51`: a top carry needs a carry out of limb 0. -/
theorem pass2_lt {y0 y1 y2 y3 y4 : ℕ} (h0 : y0 < 2 ^ 51 + 2 ^ 7) (h1 : y1 < 2 ^ 51)
    (h2 : y2 < 2 ^ 51) (h3 : y3 < 2 ^ 51) (h4 : y4 < 2 ^ 51) :
    y0 % 2 ^ 51 + (y4 + (y3 + (y2 + (y1 + y0 / 2 ^ 51) / 2 ^ 51) / 2 ^ 51) / 2 ^ 51) / 2 ^ 51 * 19 <
      2 ^ 51 := by
  have hc1 : (y1 + y0 / 2 ^ 51) / 2 ^ 51 ≤ y0 / 2 ^ 51 := by omega
  generalize (y1 + y0 / 2 ^ 51) / 2 ^ 51 = c1 at *
  have hc2 : (y2 + c1) / 2 ^ 51 ≤ c1 := by omega
  generalize (y2 + c1) / 2 ^ 51 = c2 at *
  have hc3 : (y3 + c2) / 2 ^ 51 ≤ c2 := by omega
  generalize (y3 + c2) / 2 ^ 51 = c3 at *
  have hc4 : (y4 + c3) / 2 ^ 51 ≤ c3 := by omega
  generalize (y4 + c3) / 2 ^ 51 = c4 at *
  omega

theorem normalize_lt {a : Fe} {j : Fin 8} (h : ∀ i, (a.lane j i).toNat < 2 ^ 53) (i : Fin 5) :
    ((normalize a).lane j i).toNat < 2 ^ 51 := by
  obtain ⟨e0, e1, e2, e3, e4⟩ := normPass_lane a j fun i => (h i).trans (by norm_num)
  have b0 := pass1_lt (h 0) (h 1) (h 2) (h 3) (h 4)
  rw [← e0] at b0
  have b1 := e1 ▸ Nat.mod_lt _ (by norm_num : 0 < 2 ^ 51)
  have b2 := e2 ▸ Nat.mod_lt _ (by norm_num : 0 < 2 ^ 51)
  have b3 := e3 ▸ Nat.mod_lt _ (by norm_num : 0 < 2 ^ 51)
  have b4 := e4 ▸ Nat.mod_lt _ (by norm_num : 0 < 2 ^ 51)
  have h' : ∀ i, ((normPass a).lane j i).toNat < 2 ^ 62 := by
    intro i; fin_cases i <;> simp only [Fin.zero_eta, Fin.mk_one, Fin.reduceFinMk] <;> omega
  obtain ⟨f0, f1, f2, f3, f4⟩ := normPass_lane (normPass a) j h'
  rw [normalize_eq]
  fin_cases i <;> simp only [Fin.zero_eta, Fin.mk_one, Fin.reduceFinMk, f0, f1, f2, f3, f4]
  · exact pass2_lt b0 b1 b2 b3 b4
  all_goals exact Nat.mod_lt _ (by norm_num)

theorem normalize_val {a : Fe} {j : Fin 8} (h : ∀ i, (a.lane j i).toNat < 2 ^ 53) :
    (normalize a).val j = a.val j := by
  have h1 : ∀ i, (a.lane j i).toNat < 2 ^ 62 := fun i => (h i).trans (by norm_num)
  have h2 : ∀ i, ((normPass a).lane j i).toNat < 2 ^ 62 := by
    obtain ⟨e0, e1, e2, e3, e4⟩ := normPass_lane a j h1
    have b0 := pass1_lt (h 0) (h 1) (h 2) (h 3) (h 4)
    rw [← e0] at b0
    intro i
    fin_cases i <;> simp only [Fin.zero_eta, Fin.mk_one, Fin.reduceFinMk, e1, e2, e3, e4] <;> omega
  rw [normalize_eq, normPass_val _ _ h2, normPass_val _ _ h1]

/-- `fd_ed25519_lane_is_zero` for limbs below `2^53`: bit `j` is lane `j`'s value being zero. -/
public theorem isZero_getLsbD {a : Fe} (ha : a.Le fun _ => 2 ^ 53 - 1) (j : Fin 8) :
    (isZero a).getLsbD j = decide (a.val j = 0) := by
  have hx : ∀ i, (a.lane j i).toNat < 2 ^ 53 := fun i => by
    have := ha j i; dsimp only at this; omega
  have h255 : ∀ j < 8, (255 : BitVec 32).getLsbD j = true := by decide
  have hn := normalize_lt hx
  rw [← normalize_val hx, Fe.val, Ed25519.Limbs.val_eq]
  unfold isZero
  generalize normalize a = n at *
  have n0 := hn 0; have n1 := hn 1; have n2 := hn 2; have n3 := hn 3; have n4 := hn 4
  rw [Bool.eq_iff_iff, decide_eq_true_iff]
  simp only [Fe.lane_zero, Fe.lane_one, Fe.lane_two, Fe.lane_three, Fe.lane_four] at *
  simp only [BitVec.getLsbD_or, BitVec.getLsbD_and, h255 j j.isLt, wwl_eq_getLsbD _ _ _ j.isLt,
    getElem_wwl_zero, getElem_wwl_bcast, Bool.true_and, Bool.or_eq_true, Bool.and_eq_true,
    decide_eq_true_eq, BitVec.toNat_eq, show (0 : BitVec 64).toNat = 0 from rfl, and_assoc,
    show (mask51 - 18 : BitVec 64).toNat = 2 ^ 51 - 19 from rfl,
    show mask51.toNat = 2 ^ 51 - 1 from rfl]
  exact zero_iff_limbs n0 n1 n2 n3 n4

/-- `fd_ed25519_lane_is_zero` sets only bits `0 … 7`. -/
public theorem isZero_lt (a : Fe) : (isZero a).toNat < 2 ^ 8 := by
  have key : ∀ z q : BitVec 32, (255 &&& z ||| 255 &&& q) < 256 := by intro z q; bv_decide
  exact BitVec.lt_def.mp (key _ _)

/-! ## Encodings -/

/-- `limbsOfBytes`' limbs: bits `51 i …` of the encoding. -/
theorem limbsOfBytes_toNat (b : BitVec 256) (i : Fin 5) :
    (limbsOfBytes b i).toNat = b.toNat / 2 ^ (51 * (i : ℕ)) % 2 ^ 51 := by
  have := b.isLt
  fin_cases i <;>
    simp only [limbsOfBytes, Fin.getElem_fin, Vector.getElem_mk, List.getElem_toArray,
      List.getElem_cons_succ, List.getElem_cons_zero] <;>
    rw [toNat_and_mask51] <;>
    simp only [BitVec.toNat_ushiftRight, BitVec.extractLsb'_toNat, Nat.shiftRight_eq_div_pow] <;>
    norm_num <;> omega

/-- `limbsOfBytes`: the encoding's low 255 bits, in limbs below `2^51`. -/
public theorem limbsOfBytes_val (b : BitVec 256) :
    Ed25519.Limbs.val (limbsOfBytes b) = ((b.toNat % 2 ^ 255 : ℕ) : ZMod p) := by
  rw [Ed25519.Limbs.val_nat]
  congr 1
  simp only [Ed25519.Limbs.nat, limbsOfBytes_toNat, Fin.isValue, Fin.val_zero, Fin.val_one,
    Fin.val_two]
  norm_num
  omega

public theorem limbsOfBytes_lt (b : BitVec 256) (i : Fin 5) :
    (limbsOfBytes b i).toNat < 2 ^ 51 := by
  rw [limbsOfBytes_toNat]
  exact Nat.mod_lt _ (by norm_num)

end MLIR.Firedancer.Lane
