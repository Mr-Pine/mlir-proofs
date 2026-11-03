module

public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_quad_mul
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_quad_sqr
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_quad_add
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_quad_sub
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_quad_neg
public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_quad_reduce
public import Firedancer.Math.R52x5.QuadMul
import Firedancer.Math.Avx512.Mul
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Ring

/-! crc's QUAD field kernels in `ZMod p`: each is its pre-carry limbs, then one carry pass. -/

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

open MLIR.Firedancer.R52x5
open _root_.Ed25519 (p)
open Firedancer.Avx512 (madd52lo madd52hi)
open Firedancer.Avx512.R43x6 (madd52lo_lt madd52lo_toNat madd52hi_toNat madd52_split)

/-! ## The carry pass -/

@[expose] public section

/-- The carry pass ending every kernel: bit 51 up into the next limb, limb 4's carry times 19 into
limb 0. -/
def carry (l : Fin 5 → BitVec 64) : Fin 5 → BitVec 64
  | ⟨0, _⟩ => (l 0 &&& 2251799813685247#64) + madd52lo 19#64 (l 4 >>> 51)
  | ⟨1, _⟩ => (l 1 &&& 2251799813685247#64) + l 0 >>> 51
  | ⟨2, _⟩ => (l 2 &&& 2251799813685247#64) + l 1 >>> 51
  | ⟨3, _⟩ => (l 3 &&& 2251799813685247#64) + l 2 >>> 51
  | ⟨4, _⟩ => (l 4 &&& 2251799813685247#64) + l 3 >>> 51

/-- `16 p`'s limbs, the bias of `quad_sub` and `quad_neg`. -/
def bias16 : Fin 5 → BitVec 64 := fun i =>
  if i = 0 then 36028797018963664#64 else 36028797018963952#64

/-- The carry pass on a QUAD, lane by lane. -/
def quadCarry (S : Quad5) : Quad5 :=
  let _mask := wl_bcast 2251799813685247
  ⟨wl_madd52lo (wl_and S.P0 _mask) (wl_bcast 19) (wl_shru S.P4 51),
    wl_add (wl_and S.P1 _mask) (wl_shru S.P0 51), wl_add (wl_and S.P2 _mask) (wl_shru S.P1 51),
    wl_add (wl_and S.P3 _mask) (wl_shru S.P2 51), wl_add (wl_and S.P4 _mask) (wl_shru S.P3 51)⟩

/-- `fd_r52x5_quad_sub` before its carry pass: `X - Y + 16 p`. -/
def subPre (X Y : Quad5) : Quad5 :=
  ⟨wl_add (wl_sub X.P0 Y.P0) (wl_bcast 36028797018963664),
    wl_add (wl_sub X.P1 Y.P1) (wl_bcast 36028797018963952),
    wl_add (wl_sub X.P2 Y.P2) (wl_bcast 36028797018963952),
    wl_add (wl_sub X.P3 Y.P3) (wl_bcast 36028797018963952),
    wl_add (wl_sub X.P4 Y.P4) (wl_bcast 36028797018963952)⟩

/-- `fd_r52x5_quad_neg` before its carry pass: `16 p - X`. -/
def negPre (X : Quad5) : Quad5 :=
  ⟨wl_sub (wl_bcast 36028797018963664) X.P0, wl_sub (wl_bcast 36028797018963952) X.P1,
    wl_sub (wl_bcast 36028797018963952) X.P2, wl_sub (wl_bcast 36028797018963952) X.P3,
    wl_sub (wl_bcast 36028797018963952) X.P4⟩

/-- `fd_r52x5_quad_mul` before its carry pass: columns `0 … 4` plus 19 times columns `5 … 9`. -/
def mulPre (X Y : Quad5) : Quad5 :=
  ⟨wl_madd52lo (wl_mul (wl_add (wl_shl (wl_madd52hi (wl_madd52hi (wl_madd52hi (wl_madd52hi (wl_madd52hi wl_zero X.P1 Y.P3) X.P0 Y.P4) X.P2 Y.P2) X.P3 Y.P1) X.P4 Y.P0) 1) (wl_madd52lo (wl_madd52lo (wl_madd52lo (wl_madd52lo wl_zero X.P2 Y.P3) X.P1 Y.P4) X.P3 Y.P2) X.P4 Y.P1)) (wl_bcast 19)) X.P0 Y.P0,
    wl_add (wl_add (wl_shl (wl_madd52hi wl_zero X.P0 Y.P0) 1) (wl_madd52lo (wl_madd52lo wl_zero X.P1 Y.P0) X.P0 Y.P1)) (wl_mul (wl_add (wl_shl (wl_madd52hi (wl_madd52hi (wl_madd52hi (wl_madd52hi wl_zero X.P2 Y.P3) X.P1 Y.P4) X.P3 Y.P2) X.P4 Y.P1) 1) (wl_madd52lo (wl_madd52lo (wl_madd52lo wl_zero X.P3 Y.P3) X.P2 Y.P4) X.P4 Y.P2)) (wl_bcast 19)),
    wl_add (wl_add (wl_shl (wl_madd52hi (wl_madd52hi wl_zero X.P1 Y.P0) X.P0 Y.P1) 1) (wl_madd52lo (wl_madd52lo (wl_madd52lo wl_zero X.P1 Y.P1) X.P0 Y.P2) X.P2 Y.P0)) (wl_mul (wl_add (wl_shl (wl_madd52hi (wl_madd52hi (wl_madd52hi wl_zero X.P3 Y.P3) X.P2 Y.P4) X.P4 Y.P2) 1) (wl_madd52lo (wl_madd52lo wl_zero X.P4 Y.P3) X.P3 Y.P4)) (wl_bcast 19)),
    wl_add (wl_add (wl_shl (wl_madd52hi (wl_madd52hi (wl_madd52hi wl_zero X.P1 Y.P1) X.P0 Y.P2) X.P2 Y.P0) 1) (wl_madd52lo (wl_madd52lo (wl_madd52lo (wl_madd52lo wl_zero X.P1 Y.P2) X.P0 Y.P3) X.P2 Y.P1) X.P3 Y.P0)) (wl_mul (wl_madd52lo (wl_shl (wl_madd52hi (wl_madd52hi wl_zero X.P4 Y.P3) X.P3 Y.P4) 1) X.P4 Y.P4) (wl_bcast 19)),
    wl_add (wl_add (wl_shl (wl_madd52hi (wl_madd52hi (wl_madd52hi (wl_madd52hi wl_zero X.P1 Y.P2) X.P0 Y.P3) X.P2 Y.P1) X.P3 Y.P0) 1) (wl_madd52lo (wl_madd52lo (wl_madd52lo (wl_madd52lo (wl_madd52lo wl_zero X.P1 Y.P3) X.P0 Y.P4) X.P2 Y.P2) X.P3 Y.P1) X.P4 Y.P0)) (wl_mul (wl_madd52hi wl_zero X.P4 Y.P4) (wl_bcast 38))⟩

/-- `fd_r52x5_quad_sqr` before its carry pass. -/
def sqrPre (X : Quad5) : Quad5 :=
  ⟨wl_madd52lo (wl_mul (wl_add (wl_madd52hi (wl_shl (wl_madd52hi (wl_madd52hi wl_zero X.P1 X.P3) X.P0 X.P4) 1) X.P2 X.P2) (wl_madd52lo (wl_madd52lo wl_zero X.P2 X.P3) X.P1 X.P4)) (wl_bcast 38)) X.P0 X.P0,
    wl_add (wl_mul (wl_madd52lo (wl_shl (wl_madd52lo (wl_shl (wl_madd52hi (wl_madd52hi wl_zero X.P2 X.P3) X.P1 X.P4) 1) X.P2 X.P4) 1) X.P3 X.P3) (wl_bcast 19)) (wl_shl (wl_madd52hi (wl_madd52lo wl_zero X.P0 X.P1) X.P0 X.P0) 1),
    wl_add (wl_mul (wl_madd52lo (wl_madd52hi (wl_shl (wl_madd52hi wl_zero X.P2 X.P4) 1) X.P3 X.P3) X.P3 X.P4) (wl_bcast 38)) (wl_madd52lo (wl_shl (wl_madd52lo (wl_shl (wl_madd52hi wl_zero X.P0 X.P1) 1) X.P0 X.P2) 1) X.P1 X.P1),
    wl_add (wl_mul (wl_madd52lo (wl_shl (wl_madd52hi wl_zero X.P3 X.P4) 2) X.P4 X.P4) (wl_bcast 19)) (wl_shl (wl_add (wl_madd52hi (wl_shl (wl_madd52hi wl_zero X.P0 X.P2) 1) X.P1 X.P1) (wl_madd52lo (wl_madd52lo wl_zero X.P1 X.P2) X.P0 X.P3)) 1),
    wl_add (wl_mul (wl_madd52hi wl_zero X.P4 X.P4) (wl_bcast 38)) (wl_madd52lo (wl_add (wl_shl (wl_madd52hi (wl_madd52hi wl_zero X.P1 X.P2) X.P0 X.P3) 2) (wl_shl (wl_madd52lo (wl_madd52lo wl_zero X.P1 X.P3) X.P0 X.P4) 1)) X.P2 X.P2)⟩

end

/-- `madd52lo`'s product, lane `j`, of limb `k` of `X` and limb `i` of `Y`. -/
def lq (X Y : Quad5) (j : Fin 4) (k i : ℕ) : ℕ :=
  (madd52lo (X.laneN j k) (Y.laneN j i)).toNat

/-- `madd52hi`'s product, lane `j`, of limb `k` of `X` and limb `i` of `Y`. -/
def hq (X Y : Quad5) (j : Fin 4) (k i : ℕ) : ℕ :=
  (madd52hi (X.laneN j k) (Y.laneN j i)).toNat

/-- A pre-carry limb in lane `j`: the lane operations, `toNat` with no overflow. -/
local macro "pre_col" : tactic =>
  `(tactic|
    ( simp only [mulPre, sqrPre, mcol, scol, lq, hq, Quad5.laneN, Quad5.elem_0,
        Quad5.elem_1, Quad5.elem_2, Quad5.elem_3, Quad5.elem_4, Fin.getElem_fin,
        wl_madd52lo_getElem, wl_madd52hi_getElem, wl_add_getElem, wl_mul_getElem, wl_shl_getElem,
        wl_bcast_getElem, Vector.getElem_replicate]
      madd_bounds
      simp only [BitVec.toNat_add, BitVec.toNat_mul, BitVec.toNat_shiftLeft, Nat.shiftLeft_eq,
        show BitVec.toNat (0 : BitVec 64) = 0 from rfl, show BitVec.toNat (19 : BitVec 64) = 19 from rfl,
        show BitVec.toNat (38 : BitVec 64) = 38 from rfl, Nat.zero_add]
      omega))

theorem quadCarry_elem (S : Quad5) (j : Fin 4) : (quadCarry S).elem j = carry (S.elem j) := by
  funext i
  fin_cases i <;>
    simp only [quadCarry, carry, Quad5.elem_0, Quad5.elem_1, Quad5.elem_2, Quad5.elem_3,
      Quad5.elem_4, Fin.getElem_fin, wl_madd52lo_getElem, wl_add_getElem, wl_and_getElem,
      wl_shru_getElem, wl_bcast_getElem, Fin.zero_eta, Fin.mk_one, Fin.reduceFinMk] <;> rfl

theorem subPre_elem (X Y : Quad5) (j : Fin 4) (i : Fin 5) :
    (subPre X Y).elem j i = X.elem j i - Y.elem j i + bias16 i := by
  fin_cases i <;>
    simp only [subPre, bias16, Quad5.elem_0, Quad5.elem_1, Quad5.elem_2, Quad5.elem_3,
      Quad5.elem_4, Fin.getElem_fin, wl_add_getElem, wl_sub_getElem, wl_bcast_getElem,
      Fin.zero_eta, Fin.mk_one, Fin.reduceFinMk, Fin.isValue, ite_true, ite_false, one_ne_zero,
      Fin.reduceEq] <;> rfl

theorem negPre_elem (X : Quad5) (j : Fin 4) (i : Fin 5) :
    (negPre X).elem j i = bias16 i - X.elem j i := by
  fin_cases i <;>
    simp only [negPre, bias16, Quad5.elem_0, Quad5.elem_1, Quad5.elem_2, Quad5.elem_3,
      Quad5.elem_4, Fin.getElem_fin, wl_sub_getElem, wl_bcast_getElem, Fin.zero_eta, Fin.mk_one,
      Fin.reduceFinMk, Fin.isValue, ite_true, ite_false, one_ne_zero, Fin.reduceEq] <;> rfl

theorem carry_lane0 (x y : BitVec 64) :
    ((x &&& 2251799813685247#64) + madd52lo 19#64 (y >>> 51)).toNat =
      x.toNat % 2 ^ 51 + 19 * (y.toNat / 2 ^ 51) := by
  have := y.isLt
  have hc : (y >>> 51).toNat = y.toNat / 2 ^ 51 := Ed25519.toNat_shift y
  rw [BitVec.toNat_add, Ed25519.toNat_and_mask, madd52lo_toNat (by decide) (by omega), hc,
    show BitVec.toNat (19#64) = 19 from rfl, Nat.mod_eq_of_lt (a := 19 * _) (by omega),
    Nat.mod_eq_of_lt (by omega)]

theorem carry_lane (x y : BitVec 64) :
    ((x &&& 2251799813685247#64) + y >>> 51).toNat = x.toNat % 2 ^ 51 + y.toNat / 2 ^ 51 := by
  have := y.isLt
  rw [BitVec.toNat_add, Ed25519.toNat_and_mask, Ed25519.toNat_shift, Nat.mod_eq_of_lt (by omega)]

theorem carry_toNat (l : Fin 5 → BitVec 64) :
    (carry l 0).toNat = (l 0).toNat % 2 ^ 51 + 19 * ((l 4).toNat / 2 ^ 51) ∧
      (carry l 1).toNat = (l 1).toNat % 2 ^ 51 + (l 0).toNat / 2 ^ 51 ∧
      (carry l 2).toNat = (l 2).toNat % 2 ^ 51 + (l 1).toNat / 2 ^ 51 ∧
      (carry l 3).toNat = (l 3).toNat % 2 ^ 51 + (l 2).toNat / 2 ^ 51 ∧
      (carry l 4).toNat = (l 4).toNat % 2 ^ 51 + (l 3).toNat / 2 ^ 51 :=
  ⟨carry_lane0 _ _, carry_lane _ _, carry_lane _ _, carry_lane _ _, carry_lane _ _⟩

/-- The carry pass keeps the value; its limbs are at most `2^51 + 2^18`. -/
public theorem carry_spec (l : Fin 5 → BitVec 64) :
    Ed25519.Limbs.val (carry l) = Ed25519.Limbs.val l ∧
      ∀ i, (carry l i).toNat ≤ 2 ^ 51 + 2 ^ 18 := by
  obtain ⟨h0, h1, h2, h3, h4⟩ := carry_toNat l
  refine ⟨val_of_carry h0 h1 h2 h3 h4, fun i => ?_⟩
  have := (l 0).isLt; have := (l 1).isLt; have := (l 2).isLt; have := (l 3).isLt
  have := (l 4).isLt
  fin_cases i <;> simp only [Fin.zero_eta, Fin.mk_one, Fin.reduceFinMk, h0, h1, h2, h3, h4] <;>
    omega

/-- `quadCarry` of a QUAD of values `v`: `Is v (2^51 + 2^18)`. -/
theorem quadCarry_is {S : Quad5} {v : Fin 4 → ZMod p} (hv : ∀ j, S.val j = v j) :
    (quadCarry S).Is v (fun _ => 2 ^ 51 + 2 ^ 18) := by
  intro j
  obtain ⟨h1, h2⟩ := carry_spec (S.elem j)
  exact ⟨by rw [Quad5.val, quadCarry_elem, h1]; exact hv j, fun i => by rw [quadCarry_elem]; exact h2 i⟩

theorem val_add_of_toNat {r x y : Fin 5 → BitVec 64}
    (h : ∀ i, (r i).toNat + (y i).toNat = (x i).toNat) :
    Ed25519.Limbs.val r = Ed25519.Limbs.val x - Ed25519.Limbs.val y := by
  have e (i : Fin 5) : ((r i).toNat : ZMod p) + (y i).toNat = (x i).toNat := by
    have := congrArg (Nat.cast (R := ZMod p)) (h i); push_cast at this; exact this
  rw [Ed25519.Limbs.val_eq, Ed25519.Limbs.val_eq, Ed25519.Limbs.val_eq]
  linear_combination
    e 0 + 2 ^ 51 * e 1 + 2 ^ 102 * e 2 + 2 ^ 153 * e 3 + 2 ^ 204 * e 4

theorem val_bias16 : Ed25519.Limbs.val bias16 = 0 := by
  rw [Ed25519.Limbs.val_nat,
    show Ed25519.Limbs.nat bias16 = 16 * p by
      unfold Ed25519.Limbs.nat; rfl]
  rw [Nat.cast_mul, ZMod.natCast_self, mul_zero]

theorem bias16_toNat (i : Fin 5) :
    2 ^ 55 - 304 ≤ (bias16 i).toNat ∧ (bias16 i).toNat ≤ 2 ^ 55 - 16 := by
  fin_cases i <;> decide

/-! ## `quad_reduce`, `quad_add`, `quad_sub`, `quad_neg` -/

theorem quad_reduce_eq (X : Quad5) : fd_r52x5_quad_reduce.spec X = quadCarry X := rfl

theorem quad_add_eq (X Y : Quad5) : fd_r52x5_quad_add.spec X Y = quadCarry (Quad5.addFast Y X) :=
  rfl

theorem quad_sub_eq (X Y : Quad5) : fd_r52x5_quad_sub.spec X Y = quadCarry (subPre X Y) := rfl

theorem quad_neg_eq (X : Quad5) : fd_r52x5_quad_neg.spec X = quadCarry (negPre X) := rfl

theorem quad_mul_eq (X Y : Quad5) : fd_r52x5_quad_mul.spec X Y = quadCarry (mulPre X Y) := by
  simp only [fd_r52x5_quad_mul.spec, quadCarry, mulPre, wl_add_comm (wl_shru _ _)]

theorem quad_sqr_eq (X : Quad5) : fd_r52x5_quad_sqr.spec X = quadCarry (sqrPre X) := by
  simp only [fd_r52x5_quad_sqr.spec, quadCarry, sqrPre, wl_add_comm (wl_shru _ _)]

/-- `fd_r52x5_quad_reduce` keeps the values, limbs at most `2^51 + 2^18`, for any input. -/
public theorem fd_r52x5_quad_reduce.spec_is {X : Quad5} (hX : X.Is v b) :
    (fd_r52x5_quad_reduce.spec X).Is v (fun _ => 2 ^ 51 + 2 ^ 18) := by
  rw [quad_reduce_eq]; exact quadCarry_is hX.val

/-- `fd_r52x5_quad_add`: the sums, limbs at most `2^51 + 2^18`, for limbs summing below `2^64`. -/
public theorem fd_r52x5_quad_add.spec_is {X Y : Quad5} (hX : X.Is v b) (hY : Y.Is w c)
    (h : ∀ j, b j + c j < 2 ^ 64) :
    (fd_r52x5_quad_add.spec X Y).Is (fun j => v j + w j) (fun _ => 2 ^ 51 + 2 ^ 18) := by
  rw [quad_add_eq]
  refine quadCarry_is fun j => ?_
  rw [(Quad5.addFast_is hY hX fun j => by have := h j; omega).val j, add_comm]

/-- `fd_r52x5_quad_sub`: the differences, limbs at most `2^51 + 2^18`, for `X` below `2^63` and
`Y` at most `2^55 - 304` (under the `16 p` bias). -/
public theorem fd_r52x5_quad_sub.spec_is {X Y : Quad5} (hX : X.Is v b) (hY : Y.Is w c)
    (hb : ∀ j, b j < 2 ^ 63) (hc : ∀ j, c j ≤ 2 ^ 55 - 304) :
    (fd_r52x5_quad_sub.spec X Y).Is (fun j => v j - w j) (fun _ => 2 ^ 51 + 2 ^ 18) := by
  rw [quad_sub_eq]
  refine quadCarry_is fun j => ?_
  rw [← hX.val j, ← hY.val j]
  have e := val_add_of_toNat (r := (subPre X Y).elem j) (y := Y.elem j)
    (x := fun i => X.elem j i + bias16 i) fun i => by
      have := hX.le j i; have := hY.le j i; have := hb j; have := hc j; have := bias16_toNat i
      have := (X.elem j i).isLt
      simp only [subPre_elem, BitVec.toNat_add, BitVec.toNat_sub]
      omega
  rw [Quad5.val, e, val_of_toNat (x := X.elem j) (y := bias16) fun i => by
    have := hX.le j i; have := hb j; have := bias16_toNat i
    simp only [BitVec.toNat_add]; omega, val_bias16, add_zero]

/-- `fd_r52x5_quad_neg`: the negations, limbs at most `2^51 + 2^18`, for `X` at most
`2^55 - 304`. -/
public theorem fd_r52x5_quad_neg.spec_is {X : Quad5} (hX : X.Is v b) (hb : ∀ j, b j ≤ 2 ^ 55 - 304) :
    (fd_r52x5_quad_neg.spec X).Is (fun j => -v j) (fun _ => 2 ^ 51 + 2 ^ 18) := by
  rw [quad_neg_eq]
  refine quadCarry_is fun j => ?_
  rw [← hX.val j]
  have e := val_add_of_toNat (r := (negPre X).elem j) (y := X.elem j) (x := bias16) fun i => by
    have := hX.le j i; have := hb j; have := bias16_toNat i
    simp only [negPre_elem, BitVec.toNat_sub]
    omega
  rw [Quad5.val, e, val_bias16, zero_sub]

/-! ## `quad_mul`, `quad_sqr` -/


theorem mulPre_toNat_0 {X Y : Quad5} (hX : X.Below 52) (hY : Y.Below 52) (j : Fin 4) :
    ((mulPre X Y).elem j 0).toNat =
      mcol (lq X Y j) (hq X Y j) 0 + 19 * mcol (lq X Y j) (hq X Y j) 5 := by
  have := hX j 0; have := hX j 1; have := hX j 2; have := hX j 3; have := hX j 4
  have := hY j 0; have := hY j 1; have := hY j 2; have := hY j 3; have := hY j 4
  simp only [Quad5.elem_0, Quad5.elem_1, Quad5.elem_2, Quad5.elem_3, Quad5.elem_4,
    Fin.getElem_fin] at *
  pre_col

theorem mulPre_toNat_1 {X Y : Quad5} (hX : X.Below 52) (hY : Y.Below 52) (j : Fin 4) :
    ((mulPre X Y).elem j 1).toNat =
      mcol (lq X Y j) (hq X Y j) 1 + 19 * mcol (lq X Y j) (hq X Y j) 6 := by
  have := hX j 0; have := hX j 1; have := hX j 2; have := hX j 3; have := hX j 4
  have := hY j 0; have := hY j 1; have := hY j 2; have := hY j 3; have := hY j 4
  simp only [Quad5.elem_0, Quad5.elem_1, Quad5.elem_2, Quad5.elem_3, Quad5.elem_4,
    Fin.getElem_fin] at *
  pre_col

theorem mulPre_toNat_2 {X Y : Quad5} (hX : X.Below 52) (hY : Y.Below 52) (j : Fin 4) :
    ((mulPre X Y).elem j 2).toNat =
      mcol (lq X Y j) (hq X Y j) 2 + 19 * mcol (lq X Y j) (hq X Y j) 7 := by
  have := hX j 0; have := hX j 1; have := hX j 2; have := hX j 3; have := hX j 4
  have := hY j 0; have := hY j 1; have := hY j 2; have := hY j 3; have := hY j 4
  simp only [Quad5.elem_0, Quad5.elem_1, Quad5.elem_2, Quad5.elem_3, Quad5.elem_4,
    Fin.getElem_fin] at *
  pre_col

theorem mulPre_toNat_3 {X Y : Quad5} (hX : X.Below 52) (hY : Y.Below 52) (j : Fin 4) :
    ((mulPre X Y).elem j 3).toNat =
      mcol (lq X Y j) (hq X Y j) 3 + 19 * mcol (lq X Y j) (hq X Y j) 8 := by
  have := hX j 0; have := hX j 1; have := hX j 2; have := hX j 3; have := hX j 4
  have := hY j 0; have := hY j 1; have := hY j 2; have := hY j 3; have := hY j 4
  simp only [Quad5.elem_0, Quad5.elem_1, Quad5.elem_2, Quad5.elem_3, Quad5.elem_4,
    Fin.getElem_fin] at *
  pre_col

theorem mulPre_toNat_4 {X Y : Quad5} (hX : X.Below 52) (hY : Y.Below 52) (j : Fin 4) :
    ((mulPre X Y).elem j 4).toNat =
      mcol (lq X Y j) (hq X Y j) 4 + 19 * mcol (lq X Y j) (hq X Y j) 9 := by
  have := hX j 0; have := hX j 1; have := hX j 2; have := hX j 3; have := hX j 4
  have := hY j 0; have := hY j 1; have := hY j 2; have := hY j 3; have := hY j 4
  simp only [Quad5.elem_0, Quad5.elem_1, Quad5.elem_2, Quad5.elem_3, Quad5.elem_4,
    Fin.getElem_fin] at *
  pre_col
theorem mulPre_toNat {X Y : Quad5} (hX : X.Below 52) (hY : Y.Below 52) (j : Fin 4) :
    let L := lq X Y j
    let H := hq X Y j
    ((mulPre X Y).elem j 0).toNat = mcol L H 0 + 19 * mcol L H 5 ∧
      ((mulPre X Y).elem j 1).toNat = mcol L H 1 + 19 * mcol L H 6 ∧
      ((mulPre X Y).elem j 2).toNat = mcol L H 2 + 19 * mcol L H 7 ∧
      ((mulPre X Y).elem j 3).toNat = mcol L H 3 + 19 * mcol L H 8 ∧
      ((mulPre X Y).elem j 4).toNat = mcol L H 4 + 19 * mcol L H 9 :=
  ⟨mulPre_toNat_0 hX hY j, mulPre_toNat_1 hX hY j, mulPre_toNat_2 hX hY j, mulPre_toNat_3 hX hY j,
    mulPre_toNat_4 hX hY j⟩

theorem sqrPre_toNat_0 {X : Quad5} (hX : X.Below 52) (j : Fin 4) :
    ((sqrPre X).elem j 0).toNat =
      scol (lq X X j) (hq X X j) 0 + 19 * scol (lq X X j) (hq X X j) 5 := by
  have := hX j 0; have := hX j 1; have := hX j 2; have := hX j 3; have := hX j 4
  simp only [Quad5.elem_0, Quad5.elem_1, Quad5.elem_2, Quad5.elem_3, Quad5.elem_4,
    Fin.getElem_fin] at *
  pre_col

theorem sqrPre_toNat_1 {X : Quad5} (hX : X.Below 52) (j : Fin 4) :
    ((sqrPre X).elem j 1).toNat =
      scol (lq X X j) (hq X X j) 1 + 19 * scol (lq X X j) (hq X X j) 6 := by
  have := hX j 0; have := hX j 1; have := hX j 2; have := hX j 3; have := hX j 4
  simp only [Quad5.elem_0, Quad5.elem_1, Quad5.elem_2, Quad5.elem_3, Quad5.elem_4,
    Fin.getElem_fin] at *
  pre_col

theorem sqrPre_toNat_2 {X : Quad5} (hX : X.Below 52) (j : Fin 4) :
    ((sqrPre X).elem j 2).toNat =
      scol (lq X X j) (hq X X j) 2 + 19 * scol (lq X X j) (hq X X j) 7 := by
  have := hX j 0; have := hX j 1; have := hX j 2; have := hX j 3; have := hX j 4
  simp only [Quad5.elem_0, Quad5.elem_1, Quad5.elem_2, Quad5.elem_3, Quad5.elem_4,
    Fin.getElem_fin] at *
  pre_col

theorem sqrPre_toNat_3 {X : Quad5} (hX : X.Below 52) (j : Fin 4) :
    ((sqrPre X).elem j 3).toNat =
      scol (lq X X j) (hq X X j) 3 + 19 * scol (lq X X j) (hq X X j) 8 := by
  have := hX j 0; have := hX j 1; have := hX j 2; have := hX j 3; have := hX j 4
  simp only [Quad5.elem_0, Quad5.elem_1, Quad5.elem_2, Quad5.elem_3, Quad5.elem_4,
    Fin.getElem_fin] at *
  pre_col

theorem sqrPre_toNat_4 {X : Quad5} (hX : X.Below 52) (j : Fin 4) :
    ((sqrPre X).elem j 4).toNat =
      scol (lq X X j) (hq X X j) 4 + 19 * scol (lq X X j) (hq X X j) 9 := by
  have := hX j 0; have := hX j 1; have := hX j 2; have := hX j 3; have := hX j 4
  simp only [Quad5.elem_0, Quad5.elem_1, Quad5.elem_2, Quad5.elem_3, Quad5.elem_4,
    Fin.getElem_fin] at *
  pre_col
theorem sqrPre_toNat {X : Quad5} (hX : X.Below 52) (j : Fin 4) :
    let L := lq X X j
    let H := hq X X j
    ((sqrPre X).elem j 0).toNat = scol L H 0 + 19 * scol L H 5 ∧
      ((sqrPre X).elem j 1).toNat = scol L H 1 + 19 * scol L H 6 ∧
      ((sqrPre X).elem j 2).toNat = scol L H 2 + 19 * scol L H 7 ∧
      ((sqrPre X).elem j 3).toNat = scol L H 3 + 19 * scol L H 8 ∧
      ((sqrPre X).elem j 4).toNat = scol L H 4 + 19 * scol L H 9 :=
  ⟨sqrPre_toNat_0 hX j, sqrPre_toNat_1 hX j, sqrPre_toNat_2 hX j, sqrPre_toNat_3 hX j,
    sqrPre_toNat_4 hX j⟩

theorem mulPre_val {X Y : Quad5} (hX : X.Below 52) (hY : Y.Below 52) (j : Fin 4) :
    (mulPre X Y).val j = X.val j * Y.val j := by
  obtain ⟨e0, e1, e2, e3, e4⟩ := mulPre_toNat hX hY j
  rw [Quad5.val, Ed25519.Limbs.val_nat,
    show Ed25519.Limbs.nat ((mulPre X Y).elem j) =
      limbs5 fun n => mcol (lq X Y j) (hq X Y j) n + 19 * mcol (lq X Y j) (hq X Y j) (n + 5) by
        simp only [Ed25519.Limbs.nat, limbs5, e0, e1, e2, e3, e4, Fin.isValue]]
  rw [cast_of_core
        (mul_core (L := lq X Y j) (H := hq X Y j) fun k i hk hi =>
          madd52_split (X.laneN_lt hX j hk) (Y.laneN_lt hY j hi)),
      Quad5.val, Quad5.val, Ed25519.Limbs.val_nat, Ed25519.Limbs.val_nat, Quad5.nat_elem,
      Quad5.nat_elem, Nat.cast_mul]

theorem sqrPre_val {X : Quad5} (hX : X.Below 52) (j : Fin 4) :
    (sqrPre X).val j = X.val j ^ 2 := by
  obtain ⟨e0, e1, e2, e3, e4⟩ := sqrPre_toNat hX j
  rw [Quad5.val, Ed25519.Limbs.val_nat,
    show Ed25519.Limbs.nat ((sqrPre X).elem j) =
      limbs5 fun n => scol (lq X X j) (hq X X j) n + 19 * scol (lq X X j) (hq X X j) (n + 5) by
        simp only [Ed25519.Limbs.nat, limbs5, e0, e1, e2, e3, e4, Fin.isValue]]
  rw [cast_of_core
        (sqr_core (L := lq X X j) (H := hq X X j) fun i k _ hk =>
          madd52_split (X.laneN_lt hX j (by omega)) (X.laneN_lt hX j hk)),
      Quad5.val, Ed25519.Limbs.val_nat, Quad5.nat_elem, Nat.cast_mul, sq]

/-- `fd_r52x5_quad_mul` of QUADs with limbs below `2^52`: the four products, limbs at most
`2^51 + 2^18`. -/
public theorem fd_r52x5_quad_mul.spec_is {X Y : Quad5} (hX : X.Is v b) (hY : Y.Is w c)
    (hb : ∀ j, b j < 2 ^ 52) (hc : ∀ j, c j < 2 ^ 52) :
    (fd_r52x5_quad_mul.spec X Y).Is (fun j => v j * w j) (fun _ => 2 ^ 51 + 2 ^ 18) := by
  rw [quad_mul_eq]
  exact quadCarry_is fun j => by rw [mulPre_val (hX.below hb) (hY.below hc), hX.val, hY.val]

/-- `fd_r52x5_quad_sqr` of a QUAD with limbs below `2^52`: the four squares, limbs at most
`2^51 + 2^18`. -/
public theorem fd_r52x5_quad_sqr.spec_is {X : Quad5} (hX : X.Is v b) (hb : ∀ j, b j < 2 ^ 52) :
    (fd_r52x5_quad_sqr.spec X).Is (fun j => v j ^ 2) (fun _ => 2 ^ 51 + 2 ^ 18) := by
  rw [quad_sqr_eq]
  exact quadCarry_is fun j => by rw [sqrPre_val (hX.below hb), hX.val]

end MLIR.Firedancer.Crc.Ed25519.Avx512
