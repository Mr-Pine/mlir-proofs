module

public import Firedancer.Math.Avx512.Point
public import Firedancer.Math.Avx512.Mul
public import Firedancer.Math.Avx512.Reduce
public import Firedancer.Lane.fd_r43x6_ge_encode
public import Ed25519.Encode
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring
import Std.Tactic.BVDecide

/-! `fd_r43x6_ge_encode` packs `Ed25519.encode` of the affine point. -/

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512 Firedancer.Avx512.R43x6
open _root_.Ed25519 (p)

-- the lane `simp` sets are shared by all lanes, each using part of them
set_option linter.unusedSimpArgs false

/-! ## `fd_r43x6_mul_fast`'s lanes -/

/-- `madd52lo`'s product of limb `k` of `x` and limb `j` of `y`. -/
private def mulLo (x y : Wwl) (k j : ℕ) : ℕ :=
  (madd52lo x[k]! y[j]!).toNat

/-- `madd52hi`'s product of limb `k` of `x` and limb `j` of `y`. -/
private def mulHi (x y : Wwl) (k j : ℕ) : ℕ :=
  (madd52hi x[k]! y[j]!).toNat

/-- `za + 152 zb` of a product of `u47` limbs is below `3 · 2^61`. -/
private theorem mcol_lt' {L H : ℕ → ℕ → ℕ} (hL : ∀ k j, k < 6 → j < 6 → L k j < 2 ^ 52)
    (hH : ∀ k j, k < 6 → j < 6 → H k j < 2 ^ 42) (n : ℕ) (hn : n < 6) :
    mcol L H n + 152 * mcol L H (n + 6) < 3 * 2 ^ 61 := by
  have := hL 0 0 (by norm_num) (by norm_num)
  have := hH 0 0 (by norm_num) (by norm_num)
  have := hL 0 1 (by norm_num) (by norm_num)
  have := hH 0 1 (by norm_num) (by norm_num)
  have := hL 0 2 (by norm_num) (by norm_num)
  have := hH 0 2 (by norm_num) (by norm_num)
  have := hL 0 3 (by norm_num) (by norm_num)
  have := hH 0 3 (by norm_num) (by norm_num)
  have := hL 0 4 (by norm_num) (by norm_num)
  have := hH 0 4 (by norm_num) (by norm_num)
  have := hL 0 5 (by norm_num) (by norm_num)
  have := hH 0 5 (by norm_num) (by norm_num)
  have := hL 1 0 (by norm_num) (by norm_num)
  have := hH 1 0 (by norm_num) (by norm_num)
  have := hL 1 1 (by norm_num) (by norm_num)
  have := hH 1 1 (by norm_num) (by norm_num)
  have := hL 1 2 (by norm_num) (by norm_num)
  have := hH 1 2 (by norm_num) (by norm_num)
  have := hL 1 3 (by norm_num) (by norm_num)
  have := hH 1 3 (by norm_num) (by norm_num)
  have := hL 1 4 (by norm_num) (by norm_num)
  have := hH 1 4 (by norm_num) (by norm_num)
  have := hL 1 5 (by norm_num) (by norm_num)
  have := hH 1 5 (by norm_num) (by norm_num)
  have := hL 2 0 (by norm_num) (by norm_num)
  have := hH 2 0 (by norm_num) (by norm_num)
  have := hL 2 1 (by norm_num) (by norm_num)
  have := hH 2 1 (by norm_num) (by norm_num)
  have := hL 2 2 (by norm_num) (by norm_num)
  have := hH 2 2 (by norm_num) (by norm_num)
  have := hL 2 3 (by norm_num) (by norm_num)
  have := hH 2 3 (by norm_num) (by norm_num)
  have := hL 2 4 (by norm_num) (by norm_num)
  have := hH 2 4 (by norm_num) (by norm_num)
  have := hL 2 5 (by norm_num) (by norm_num)
  have := hH 2 5 (by norm_num) (by norm_num)
  have := hL 3 0 (by norm_num) (by norm_num)
  have := hH 3 0 (by norm_num) (by norm_num)
  have := hL 3 1 (by norm_num) (by norm_num)
  have := hH 3 1 (by norm_num) (by norm_num)
  have := hL 3 2 (by norm_num) (by norm_num)
  have := hH 3 2 (by norm_num) (by norm_num)
  have := hL 3 3 (by norm_num) (by norm_num)
  have := hH 3 3 (by norm_num) (by norm_num)
  have := hL 3 4 (by norm_num) (by norm_num)
  have := hH 3 4 (by norm_num) (by norm_num)
  have := hL 3 5 (by norm_num) (by norm_num)
  have := hH 3 5 (by norm_num) (by norm_num)
  have := hL 4 0 (by norm_num) (by norm_num)
  have := hH 4 0 (by norm_num) (by norm_num)
  have := hL 4 1 (by norm_num) (by norm_num)
  have := hH 4 1 (by norm_num) (by norm_num)
  have := hL 4 2 (by norm_num) (by norm_num)
  have := hH 4 2 (by norm_num) (by norm_num)
  have := hL 4 3 (by norm_num) (by norm_num)
  have := hH 4 3 (by norm_num) (by norm_num)
  have := hL 4 4 (by norm_num) (by norm_num)
  have := hH 4 4 (by norm_num) (by norm_num)
  have := hL 4 5 (by norm_num) (by norm_num)
  have := hH 4 5 (by norm_num) (by norm_num)
  have := hL 5 0 (by norm_num) (by norm_num)
  have := hH 5 0 (by norm_num) (by norm_num)
  have := hL 5 1 (by norm_num) (by norm_num)
  have := hH 5 1 (by norm_num) (by norm_num)
  have := hL 5 2 (by norm_num) (by norm_num)
  have := hH 5 2 (by norm_num) (by norm_num)
  have := hL 5 3 (by norm_num) (by norm_num)
  have := hH 5 3 (by norm_num) (by norm_num)
  have := hL 5 4 (by norm_num) (by norm_num)
  have := hH 5 4 (by norm_num) (by norm_num)
  have := hL 5 5 (by norm_num) (by norm_num)
  have := hH 5 5 (by norm_num) (by norm_num)
  match n, hn with
  | 0, _ | 1, _ | 2, _ | 3, _ | 4, _ | 5, _ => simp only [mcol, Nat.reduceAdd]; omega

/-- The bounds `omega` needs on `x y`'s lanes and their `madd52` halves. -/
local macro "mul_bounds" x:ident y:ident hx:ident hy:ident : tactic =>
  `(tactic| (
    have bx0 : ($x[0]'(by decide)).toNat < 2 ^ 47 := $hx 0
    have by0 : ($y[0]'(by decide)).toNat < 2 ^ 47 := $hy 0
    have bx1 : ($x[1]'(by decide)).toNat < 2 ^ 47 := $hx 1
    have by1 : ($y[1]'(by decide)).toNat < 2 ^ 47 := $hy 1
    have bx2 : ($x[2]'(by decide)).toNat < 2 ^ 47 := $hx 2
    have by2 : ($y[2]'(by decide)).toNat < 2 ^ 47 := $hy 2
    have bx3 : ($x[3]'(by decide)).toNat < 2 ^ 47 := $hx 3
    have by3 : ($y[3]'(by decide)).toNat < 2 ^ 47 := $hy 3
    have bx4 : ($x[4]'(by decide)).toNat < 2 ^ 47 := $hx 4
    have by4 : ($y[4]'(by decide)).toNat < 2 ^ 47 := $hy 4
    have bx5 : ($x[5]'(by decide)).toNat < 2 ^ 47 := $hx 5
    have by5 : ($y[5]'(by decide)).toNat < 2 ^ 47 := $hy 5
    have := madd52lo_lt ($x[0]'(by decide)) ($y[0]'(by decide))
    have := madd52hi_lt47 bx0 by0
    have := madd52lo_lt ($x[0]'(by decide)) ($y[1]'(by decide))
    have := madd52hi_lt47 bx0 by1
    have := madd52lo_lt ($x[0]'(by decide)) ($y[2]'(by decide))
    have := madd52hi_lt47 bx0 by2
    have := madd52lo_lt ($x[0]'(by decide)) ($y[3]'(by decide))
    have := madd52hi_lt47 bx0 by3
    have := madd52lo_lt ($x[0]'(by decide)) ($y[4]'(by decide))
    have := madd52hi_lt47 bx0 by4
    have := madd52lo_lt ($x[0]'(by decide)) ($y[5]'(by decide))
    have := madd52hi_lt47 bx0 by5
    have := madd52lo_lt ($x[1]'(by decide)) ($y[0]'(by decide))
    have := madd52hi_lt47 bx1 by0
    have := madd52lo_lt ($x[1]'(by decide)) ($y[1]'(by decide))
    have := madd52hi_lt47 bx1 by1
    have := madd52lo_lt ($x[1]'(by decide)) ($y[2]'(by decide))
    have := madd52hi_lt47 bx1 by2
    have := madd52lo_lt ($x[1]'(by decide)) ($y[3]'(by decide))
    have := madd52hi_lt47 bx1 by3
    have := madd52lo_lt ($x[1]'(by decide)) ($y[4]'(by decide))
    have := madd52hi_lt47 bx1 by4
    have := madd52lo_lt ($x[1]'(by decide)) ($y[5]'(by decide))
    have := madd52hi_lt47 bx1 by5
    have := madd52lo_lt ($x[2]'(by decide)) ($y[0]'(by decide))
    have := madd52hi_lt47 bx2 by0
    have := madd52lo_lt ($x[2]'(by decide)) ($y[1]'(by decide))
    have := madd52hi_lt47 bx2 by1
    have := madd52lo_lt ($x[2]'(by decide)) ($y[2]'(by decide))
    have := madd52hi_lt47 bx2 by2
    have := madd52lo_lt ($x[2]'(by decide)) ($y[3]'(by decide))
    have := madd52hi_lt47 bx2 by3
    have := madd52lo_lt ($x[2]'(by decide)) ($y[4]'(by decide))
    have := madd52hi_lt47 bx2 by4
    have := madd52lo_lt ($x[2]'(by decide)) ($y[5]'(by decide))
    have := madd52hi_lt47 bx2 by5
    have := madd52lo_lt ($x[3]'(by decide)) ($y[0]'(by decide))
    have := madd52hi_lt47 bx3 by0
    have := madd52lo_lt ($x[3]'(by decide)) ($y[1]'(by decide))
    have := madd52hi_lt47 bx3 by1
    have := madd52lo_lt ($x[3]'(by decide)) ($y[2]'(by decide))
    have := madd52hi_lt47 bx3 by2
    have := madd52lo_lt ($x[3]'(by decide)) ($y[3]'(by decide))
    have := madd52hi_lt47 bx3 by3
    have := madd52lo_lt ($x[3]'(by decide)) ($y[4]'(by decide))
    have := madd52hi_lt47 bx3 by4
    have := madd52lo_lt ($x[3]'(by decide)) ($y[5]'(by decide))
    have := madd52hi_lt47 bx3 by5
    have := madd52lo_lt ($x[4]'(by decide)) ($y[0]'(by decide))
    have := madd52hi_lt47 bx4 by0
    have := madd52lo_lt ($x[4]'(by decide)) ($y[1]'(by decide))
    have := madd52hi_lt47 bx4 by1
    have := madd52lo_lt ($x[4]'(by decide)) ($y[2]'(by decide))
    have := madd52hi_lt47 bx4 by2
    have := madd52lo_lt ($x[4]'(by decide)) ($y[3]'(by decide))
    have := madd52hi_lt47 bx4 by3
    have := madd52lo_lt ($x[4]'(by decide)) ($y[4]'(by decide))
    have := madd52hi_lt47 bx4 by4
    have := madd52lo_lt ($x[4]'(by decide)) ($y[5]'(by decide))
    have := madd52hi_lt47 bx4 by5
    have := madd52lo_lt ($x[5]'(by decide)) ($y[0]'(by decide))
    have := madd52hi_lt47 bx5 by0
    have := madd52lo_lt ($x[5]'(by decide)) ($y[1]'(by decide))
    have := madd52hi_lt47 bx5 by1
    have := madd52lo_lt ($x[5]'(by decide)) ($y[2]'(by decide))
    have := madd52hi_lt47 bx5 by2
    have := madd52lo_lt ($x[5]'(by decide)) ($y[3]'(by decide))
    have := madd52hi_lt47 bx5 by3
    have := madd52lo_lt ($x[5]'(by decide)) ($y[4]'(by decide))
    have := madd52hi_lt47 bx5 by4
    have := madd52lo_lt ($x[5]'(by decide)) ($y[5]'(by decide))
    have := madd52hi_lt47 bx5 by5
    skip))

/-- A lane of `fd_r43x6_mul_fast` as its columns: the lane operations, `toNat` with no overflow,
then `ring`. -/
local macro "mul_lane" hy6:ident hy7:ident : tactic =>
  `(tactic| (
    unfold fd_r43x6_mul_fast.spec fd_r43x6_mul_fast.tail fold152
    iterate 2
      try simp only [wwl_add_get, wwl_and_get, wwl_shl_get, wwl_madd52lo_get,
        wwl_madd52hi_get, wwl_slide_get, wwl_get0, wwl_get1, wwl_get2, wwl_get3,
        wwl_get4, wwl_get5, wwl_get6, wwl_get7, wwl_zero_get, getD_get, Vector.getElem_replicate,
        BitVec.reduceToNat, Nat.reduceMod, Nat.reduceLT, Nat.reduceAdd, Nat.reduceSub, ite_true,
        ite_false, Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero,
        List.getElem_cons_succ]
    simp only [$hy6:ident, $hy7:ident, mcol, mulLo, mulHi, getElem!_pos, Nat.reduceLT,
      Nat.reduceAdd, madd52lo_zero, madd52hi_zero, BitVec.zero_add, BitVec.add_zero,
      BitVec.zero_shiftLeft, BitVec.toNat_add, BitVec.toNat_shiftLeft, BitVec.toNat_and,
      Nat.shiftLeft_eq, BitVec.reduceToNat, BitVec.toNat_zero, Nat.reducePow, Nat.reduceMod,
      Nat.zero_add, Nat.add_zero, toNat_neg_one, and_m64, Nat.and_zero, Nat.zero_mod,
      Nat.zero_mul]
    simp (disch := omega) only [Nat.mod_eq_of_lt, Nat.mod_mod]
    ring))

private theorem lane0 {x y : Wwl} (hx : Unsigned 47 x) (hy : Unreduced y) :
    (fd_r43x6_mul_fast.spec x y)[0].toNat =
      mcol (mulLo x y) (mulHi x y) 0 + 152 * mcol (mulLo x y) (mulHi x y) 6 := by
  obtain ⟨hy, hy6, hy7⟩ := hy
  mul_bounds x y hx hy
  mul_lane hy6 hy7

private theorem lane1 {x y : Wwl} (hx : Unsigned 47 x) (hy : Unreduced y) :
    (fd_r43x6_mul_fast.spec x y)[1].toNat =
      mcol (mulLo x y) (mulHi x y) 1 + 152 * mcol (mulLo x y) (mulHi x y) 7 := by
  obtain ⟨hy, hy6, hy7⟩ := hy
  mul_bounds x y hx hy
  mul_lane hy6 hy7

private theorem lane2 {x y : Wwl} (hx : Unsigned 47 x) (hy : Unreduced y) :
    (fd_r43x6_mul_fast.spec x y)[2].toNat =
      mcol (mulLo x y) (mulHi x y) 2 + 152 * mcol (mulLo x y) (mulHi x y) 8 := by
  obtain ⟨hy, hy6, hy7⟩ := hy
  mul_bounds x y hx hy
  mul_lane hy6 hy7

private theorem lane3 {x y : Wwl} (hx : Unsigned 47 x) (hy : Unreduced y) :
    (fd_r43x6_mul_fast.spec x y)[3].toNat =
      mcol (mulLo x y) (mulHi x y) 3 + 152 * mcol (mulLo x y) (mulHi x y) 9 := by
  obtain ⟨hy, hy6, hy7⟩ := hy
  mul_bounds x y hx hy
  mul_lane hy6 hy7

private theorem lane4 {x y : Wwl} (hx : Unsigned 47 x) (hy : Unreduced y) :
    (fd_r43x6_mul_fast.spec x y)[4].toNat =
      mcol (mulLo x y) (mulHi x y) 4 + 152 * mcol (mulLo x y) (mulHi x y) 10 := by
  obtain ⟨hy, hy6, hy7⟩ := hy
  mul_bounds x y hx hy
  mul_lane hy6 hy7

private theorem lane5 {x y : Wwl} (hx : Unsigned 47 x) (hy : Unreduced y) :
    (fd_r43x6_mul_fast.spec x y)[5].toNat =
      mcol (mulLo x y) (mulHi x y) 5 + 152 * mcol (mulLo x y) (mulHi x y) 11 := by
  obtain ⟨hy, hy6, hy7⟩ := hy
  mul_bounds x y hx hy
  mul_lane hy6 hy7

/-- `fd_r43x6_mul_fast` of `u47` limbs (`y`'s lanes 6 and 7 zero): lanes below `3 · 2^61`. -/
theorem mul_fast_lt {x y : Wwl} (hx : Unsigned 47 x) (hy : Unreduced y) (i : Fin 6) :
    (fd_r43x6_mul_fast.spec x y)[(i : ℕ)].toNat < 3 * 2 ^ 61 := by
  have hL : ∀ k j, k < 6 → j < 6 → mulLo x y k j < 2 ^ 52 := fun k j _ _ => madd52lo_lt _ _
  have hH : ∀ k j, k < 6 → j < 6 → mulHi x y k j < 2 ^ 42 := fun k j hk hj =>
    madd52hi_lt47 (hx.get! hk) (hy.1.get! hj)
  have hc := mcol_lt' hL hH
  have e0 := lane0 hx hy
  have e1 := lane1 hx hy
  have e2 := lane2 hx hy
  have e3 := lane3 hx hy
  have e4 := lane4 hx hy
  have e5 := lane5 hx hy
  have := hc 0 (by norm_num); have := hc 1 (by norm_num); have := hc 2 (by norm_num)
  have := hc 3 (by norm_num); have := hc 4 (by norm_num); have := hc 5 (by norm_num)
  fin_cases i <;> simp only [Fin.isValue, Fin.val_zero, Fin.val_one, Fin.val_two,
    Fin.coe_ofNat_eq_mod, Nat.reduceMod, e0, e1, e2, e3, e4, e5] <;> omega

/-! ## Carries -/

/-- A nonnegative limb plus any long's carry: no overflow. -/
private theorem add_sshr43 {a : BitVec 64} (ha : 0 ≤ a.toInt ∧ a.toInt < 3 * 2 ^ 61)
    (b : BitVec 64) :
    (a + b.sshiftRight 43).toInt = a.toInt + b.toInt / 2 ^ 43 := by
  have := toInt_bounds b
  rw [toInt_add' (by rw [toInt_sshiftRight']; omega) (by rw [toInt_sshiftRight']; omega),
    toInt_sshiftRight']

/-- `fd_r43x6_biased_carry_propagate_limbs(x, y, 0)` of limbs below `3 · 2^61`: nearly reduced
limbs whose integer is `x`'s less a multiple of `p`. -/
theorem biased0_spec {x : Wwl} (hx : ∀ i : Fin 6, x[(i : ℕ)].toNat < 3 * 2 ^ 61) :
    LimbsBounded 41 (biasedCarryPropagateLimbs (extractLimbs x) 0) ∧
      limbsNat (biasedCarryPropagateLimbs (extractLimbs x) 0) < 2 * p ∧
      ∃ c : ℤ, (limbsNat (biasedCarryPropagateLimbs (extractLimbs x) 0) : ℤ) = int x - p * c := by
  have i0 := toInt_of_lt (a := x[0]) (by have := hx 0; simp at this; omega)
  have i1 := toInt_of_lt (a := x[1]) (by have := hx 1; simp at this; omega)
  have i2 := toInt_of_lt (a := x[2]) (by have := hx 2; simp at this; omega)
  have i3 := toInt_of_lt (a := x[3]) (by have := hx 3; simp at this; omega)
  have i4 := toInt_of_lt (a := x[4]) (by have := hx 4; simp at this; omega)
  have i5 := toInt_of_lt (a := x[5]) (by have := hx 5; simp at this; omega)
  have b0 : x[0].toNat < 3 * 2 ^ 61 := hx 0
  have b1 : x[1].toNat < 3 * 2 ^ 61 := hx 1
  have b2 : x[2].toNat < 3 * 2 ^ 61 := hx 2
  have b3 : x[3].toNat < 3 * 2 ^ 61 := hx 3
  have b4 : x[4].toNat < 3 * 2 ^ 61 := hx 4
  have b5 : x[5].toNat < 3 * 2 ^ 61 := hx 5
  clear hx
  have z1 : ∀ a : BitVec 64, a - 0 = a := fun a => BitVec.sub_zero a
  have z2 : ∀ a : BitVec 64, a + 0 = a := fun a => BitVec.add_zero a
  simp only [biasedCarryPropagateLimbs, carryLimbs, carrySums, extractLimbs, limbsNat, z1, z2]
  have Hc := toInt_sshiftRight' x[5] 40
  generalize x[5].sshiftRight 40 = c at Hc ⊢
  have Hz : (x[0] + 19 * c).toInt = x[0].toInt + 19 * c.toInt := by
    have h19 : (19 * c).toInt = 19 * c.toInt := toInt_mul19 (by omega) (by omega)
    rw [toInt_add' (by rw [h19]; omega) (by rw [h19]; omega), h19]
  generalize x[0] + 19 * c = z0 at Hz ⊢
  have Hs1 := add_sshr43 (a := x[1]) (by omega) z0
  generalize x[1] + z0.sshiftRight 43 = s1 at Hs1 ⊢
  have Hs2 := add_sshr43 (a := x[2]) (by omega) s1
  generalize x[2] + s1.sshiftRight 43 = s2 at Hs2 ⊢
  have Hs3 := add_sshr43 (a := x[3]) (by omega) s2
  generalize x[3] + s2.sshiftRight 43 = s3 at Hs3 ⊢
  have Hs4 := add_sshr43 (a := x[4]) (by omega) s3
  generalize x[4] + s3.sshiftRight 43 = s4 at Hs4 ⊢
  have Hc4 := toInt_sshiftRight' s4 43
  generalize s4.sshiftRight 43 = c4 at Hc4 ⊢
  have Hm := and_m40_lt x[5]
  have Hmi : (x[5] &&& m40).toInt = (x[5] &&& m40).toNat := toInt_of_lt (by omega)
  have Hy5i : ((x[5] &&& m40) + c4).toInt = (x[5] &&& m40).toNat + c4.toInt := by
    rw [toInt_add' (by rw [Hmi]; omega) (by rw [Hmi]; omega), Hmi]
  have Hy5n : (((x[5] &&& m40) + c4).toNat : ℤ) = (x[5] &&& m40).toNat + c4.toInt := by
    rw [toNat_of_toInt_nonneg (by rw [Hy5i]; omega), Hy5i]
  have q0 := and_m43_lt z0
  have q1 := and_m43_lt s1
  have q2 := and_m43_lt s2
  have q3 := and_m43_lt s3
  have q4 := and_m43_lt s4
  have pa := p_add
  refine ⟨⟨q0, q1, q2, q3, q4, by dsimp only; omega⟩, by omega, c.toInt, ?_⟩
  push_cast
  rw [toInt_and_m43, toInt_and_m43, toInt_and_m43, toInt_and_m43, toInt_and_m43, Hy5n,
    toInt_and_m40, int]
  have m0 := Int.emod_def z0.toInt (2 ^ 43)
  have m1 := Int.emod_def s1.toInt (2 ^ 43)
  have m2 := Int.emod_def s2.toInt (2 ^ 43)
  have m3 := Int.emod_def s3.toInt (2 ^ 43)
  have m4 := Int.emod_def s4.toInt (2 ^ 43)
  have mt := Int.emod_def x[5].toInt (2 ^ 40)
  linear_combination m0 + 2 ^ 43 * m1 + 2 ^ 86 * m2 + 2 ^ 129 * m3 + 2 ^ 172 * m4 +
    2 ^ 215 * mt + Hz + 2 ^ 43 * Hs1 + 2 ^ 86 * Hs2 + 2 ^ 129 * Hs3 + 2 ^ 172 * Hs4 +
    2 ^ 255 * Hc + 2 ^ 215 * Hc4

/-- The C's branchless `19 & ((c - 1) >> 63)` of a nonnegative `c`: `19` exactly when `c = 0`. -/
private theorem sel19 {c : BitVec 64} (hc : c.msb = false) :
    (19 &&& (c - 1).sshiftRight 63) = if c = 0 then 19 else 0 := by
  split <;> bv_decide

/-- `modNearlyC` of nearly reduced limbs is `fd_r43x6_mod_nearly_reduced_limbs`. -/
theorem modNearlyC_eq {l : Limbs} (hb : LimbsBounded 41 l) :
    modNearlyC l = modNearlyReducedLimbs l := by
  obtain ⟨b0, b1, b2, b3, b4, b5⟩ := hb
  obtain ⟨y0, y1, y2, y3, y4, y5⟩ := l
  dsimp only at b0 b1 b2 b3 b4 b5
  have hc : ((y5 + (carryLimbs (y0 + 19) y1 y2 y3 y4).c).sshiftRight 40).msb = false := by
    have h0 : y0 < 0x80000000000#64 := by rw [BitVec.lt_def]; simpa using b0
    have h1 : y1 < 0x80000000000#64 := by rw [BitVec.lt_def]; simpa using b1
    have h2 : y2 < 0x80000000000#64 := by rw [BitVec.lt_def]; simpa using b2
    have h3 : y3 < 0x80000000000#64 := by rw [BitVec.lt_def]; simpa using b3
    have h4 : y4 < 0x80000000000#64 := by rw [BitVec.lt_def]; simpa using b4
    have h5 : y5 < 0x20000000000#64 := by rw [BitVec.lt_def]; simpa using b5
    simp only [carryLimbs, carrySums]
    bv_decide
  simp only [modNearlyC, modNearlyReducedLimbs, sel19 hc]

/-- `x`'s limbs carried with bias `0` and reduced, for lanes below `3 · 2^61`: the reduced limbs
of `x`'s value. -/
theorem encLimbs_spec {x : Wwl} (hx : ∀ i : Fin 6, x[(i : ℕ)].toNat < 3 * 2 ^ 61) :
    LimbsBounded 40 (encLimbs x) ∧ limbsNat (encLimbs x) = (val x).val := by
  obtain ⟨hb, hL, c, hc⟩ := biased0_spec hx
  obtain ⟨rb, rv⟩ := modNearly_spec hb hL
  rw [encLimbs, modNearlyC_eq hb]
  refine ⟨rb, ?_⟩
  rw [rv]
  have e : ((val x).val : ℤ) = int x % p := by
    rw [val, ZMod.val_intCast]
  apply Nat.cast_injective (R := ℤ)
  rw [e, Int.natCast_mod, hc, show int x - p * c = int x + (-c) * p by ring,
    Int.add_mul_emod_self_right]

/-! ## Packing -/

/-- Four longs packed: lane 0 lowest. -/
private theorem packLanes_four (v : Vector (BitVec 64) 4) :
    BitVec.packLanes v = v[3] ++ (v[2] ++ (v[1] ++ v[0])) := by
  simp only [BitVec.packLanes, Vector.tail_eq_cast_extract, Vector.getElem_cast,
    Vector.getElem_extract, Nat.reduceAdd]
  generalize v[0] = a, v[1] = b, v[2] = c, v[3] = d
  bv_decide

/-- Six limbs and a top bit summed into 320 bits, limb `i` at bit `43 i`, the bit at `255`. -/
private def sum320 (l : Limbs) (b : BitVec 64) : BitVec 320 :=
  l.y0.zeroExtend 320 + (l.y1.zeroExtend 320 <<< 43) + (l.y2.zeroExtend 320 <<< 86) +
    (l.y3.zeroExtend 320 <<< 129) + (l.y4.zeroExtend 320 <<< 172) +
    (l.y5.zeroExtend 320 <<< 215) + ((b &&& 1).zeroExtend 320 <<< 255)

private theorem sum320_toNat (l : Limbs) (b : BitVec 64) :
    (sum320 l b).toNat = limbsNat l + 2 ^ 255 * (b.toNat % 2) := by
  have := l.y0.isLt
  have := l.y1.isLt
  have := l.y2.isLt
  have := l.y3.isLt
  have := l.y4.isLt
  have := l.y5.isLt
  have h1 : (1 : BitVec 64).toNat = 1 := rfl
  have hb := Nat.mod_lt b.toNat (show 2 > 0 by decide)
  simp only [sum320, limbsNat, BitVec.toNat_add, BitVec.toNat_shiftLeft, BitVec.toNat_setWidth,
    BitVec.toNat_and, h1, Nat.and_one_is_mod, Nat.shiftLeft_eq]
  simp (disch := omega) only [Nat.mod_eq_of_lt]
  omega

/-- `fd_r43x6_pack` of reduced limbs with a bit or-ed in at limb 5's bit 40, bit by bit. -/
private theorem packWv_bv {y0 y1 y2 y3 y4 y5 : BitVec 64} (b : BitVec 64)
    (h0 : y0 < 0x80000000000#64) (h1 : y1 < 0x80000000000#64) (h2 : y2 < 0x80000000000#64)
    (h3 : y3 < 0x80000000000#64) (h4 : y4 < 0x80000000000#64) (h5 : y5 < 0x10000000000#64) :
    BitVec.packLanes (packWv ⟨y0, y1, y2, y3, y4, y5 ||| (b &&& 1) <<< 40⟩) =
      (sum320 ⟨y0, y1, y2, y3, y4, y5⟩ b).setWidth 256 := by
  rw [packLanes_four]
  simp only [packWv, sum320, Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero,
    List.getElem_cons_succ]
  bv_decide

/-- `encPack`'s packing of reduced limbs `r` with bit `b`: `r`'s integer, `b`'s parity at bit
`255`. -/
theorem packLanes_packWv_or {r : Limbs} (hr : LimbsBounded 40 r) (b : BitVec 64) :
    BitVec.packLanes (packWv ⟨r.y0, r.y1, r.y2, r.y3, r.y4, r.y5 ||| (b &&& 1) <<< 40⟩) =
      BitVec.ofNat 256 (limbsNat r + 2 ^ 255 * (b.toNat % 2)) := by
  obtain ⟨b0, b1, b2, b3, b4, b5⟩ := hr
  obtain ⟨y0, y1, y2, y3, y4, y5⟩ := r
  rw [packWv_bv b (by rw [BitVec.lt_def]; simpa using b0) (by rw [BitVec.lt_def]; simpa using b1)
    (by rw [BitVec.lt_def]; simpa using b2) (by rw [BitVec.lt_def]; simpa using b3)
    (by rw [BitVec.lt_def]; simpa using b4) (by rw [BitVec.lt_def]; simpa using b5)]
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_setWidth, sum320_toNat, BitVec.toNat_ofNat]

/-! ## The encoding -/

/-- An element of a QUAD with `u47` limbs is unreduced. -/
private theorem elem_unreduced {Q : Quad} (h : Q.Unsigned 47) {j : ℕ} (hj : j < 4) :
    Unreduced (Q.elem j) :=
  ⟨h j hj, rfl, rfl⟩

/-- Reduced limbs' parity is limb 0's. -/
private theorem limbsNat_mod_two (l : Limbs) : limbsNat l % 2 = l.y0.toNat % 2 := by
  simp only [limbsNat]
  omega

/-- `fd_r43x6_ge_encode` of a projective `P` for `Q` with `u47` limbs packs to `Q`'s encoding. -/
public theorem fd_r43x6_ge_encode.spec_encode {P : Quad} {Q : Ed25519.Point}
    (hP : P.Proj Q.x Q.y) (hU : P.Unsigned 47) :
    BitVec.packLanes (fd_r43x6_ge_encode.spec P) = Ed25519.encode Q := by
  obtain ⟨hz, hx, hy⟩ := hP
  have hX : P.X = P.elem 0 := rfl
  have hY : P.Y = P.elem 1 := rfl
  have hZ : P.Z = P.elem 2 := rfl
  have uX : Unsigned 47 P.X := hX ▸ (elem_unreduced hU (j := 0) (by decide)).1
  have uY : Unsigned 47 P.Y := hY ▸ (elem_unreduced hU (j := 1) (by decide)).1
  obtain ⟨vzi, fzi⟩ := fd_r43x6_invert.spec_val (hZ ▸ elem_unreduced hU (j := 2) (by decide))
  obtain ⟨vx, -⟩ := fd_r43x6_mul_fast_spec uX fzi.unreduced
  obtain ⟨vy, -⟩ := fd_r43x6_mul_fast_spec uY fzi.unreduced
  obtain ⟨-, ex⟩ := encLimbs_spec (mul_fast_lt uX fzi.unreduced)
  obtain ⟨rby, ey⟩ := encLimbs_spec (mul_fast_lt uY fzi.unreduced)
  have hx' : val (fd_r43x6_mul_fast.spec P.X (fd_r43x6_invert.spec P.Z)) = Q.x := by
    rw [vx, vzi, hX, hZ]
    change P.val 0 * (P.val 2)⁻¹ = Q.x
    rw [hx, mul_assoc, mul_inv_cancel₀ hz, mul_one]
  have hy' : val (fd_r43x6_mul_fast.spec P.Y (fd_r43x6_invert.spec P.Z)) = Q.y := by
    rw [vy, vzi, hY, hZ]
    change P.val 1 * (P.val 2)⁻¹ = Q.y
    rw [hy, mul_assoc, mul_inv_cancel₀ hz, mul_one]
  simp only [fd_r43x6_ge_encode.spec, encPack]
  rw [packLanes_packWv_or rby, ey, hy', ← limbsNat_mod_two, ex, hx']
  rfl

/-- `fd_r43x6_ge_encode` of a projective point for `Q` with `u47` limbs returns four longs packing
to `Q`'s encoding. -/
public theorem fd_r43x6_ge_encode.call_encode (P : Quad) (s : GlobalState) (hwf : s.WF)
    {Q : Ed25519.Point} (hP : P.Proj Q.x Q.y) (hU : P.Unsigned 47) :
    ∃ w : Wv,
      _root_.Firedancer.Lane.Mlir.fd_r43x6_ge_encode.call
          (_root_.Firedancer.Lane.Mlir.fd_r43x6_ge_encode.args (Ty.wrap P.P03) (Ty.wrap P.P14)
            (Ty.wrap P.P25)) s =
        .value (.cons (Ty.wrap w) .nil, s) ∧
      BitVec.packLanes w = Ed25519.encode Q :=
  ⟨_, fd_r43x6_ge_encode.call_eq P s hwf, fd_r43x6_ge_encode.spec_encode hP hU⟩

end MLIR.Firedancer.Lane
