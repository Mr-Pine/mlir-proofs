module

public import Firedancer.Math.R52x5.Fe
public import Firedancer.R52x5.fd_f25519_sqr
import Firedancer.Math.Avx512.Mul
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

/-! `fd_f25519_mul` and `fd_f25519_sqr` in `ZMod p`: lane by lane, the products' 52-bit halves
summed by radix-`2^51` columns, `za + 19 zb`, then `fold`. -/

namespace MLIR.Firedancer.R52x5

open MLIR.Firedancer.Ref (p)
open Firedancer.Avx512 (Wwl madd52lo madd52hi)
open Firedancer.Avx512.R43x6 (wwl_add_get wwl_and_get wwl_andnot_get wwl_shl_get wwl_shl_vector_get
  wwl_madd52lo_get wwl_madd52hi_get wwl_permute_get wwl_slide_get wwl_bcast_get wwl_get0 wwl_get1
  wwl_get2 wwl_get3 wwl_get4 wwl_get5 wwl_get6 wwl_get7 wwl_zero_get getD_get madd52lo_lt
  madd52_split madd52lo_zero madd52hi_zero madd52lo_zero' madd52hi_zero' madd52lo_zero_left
  madd52hi_zero_left not_neg_one_and not_zero_and neg_one_and zero_and toNat_neg_one and_m64 p_int)
-- the lane `simp` sets are shared by all lanes, each using part of them
set_option linter.unusedSimpArgs false

/-! ## Columns -/

@[expose] public section

/-- Five radix-`2^51` limbs `f 0 … f 4`, packed as `Ref.Limbs.nat`. -/
def limbs5 (f : ℕ → ℕ) : ℕ :=
  f 0 + f 1 * 2 ^ 51 + f 2 * 2 ^ 102 + f 3 * 2 ^ 153 + f 4 * 2 ^ 204

/-- Column `d` of a 5 × 5 product split by `madd52`: the low halves `L k j` with `k + j = d`, and
twice the high halves `H k j` with `k + j = d - 1`. -/
def mcol (L H : ℕ → ℕ → ℕ) : ℕ → ℕ
  | 0 => L 0 0
  | 1 => L 0 1 + L 1 0 + 2 * H 0 0
  | 2 => L 0 2 + L 1 1 + L 2 0 + 2 * (H 0 1 + H 1 0)
  | 3 => L 0 3 + L 1 2 + L 2 1 + L 3 0 + 2 * (H 0 2 + H 1 1 + H 2 0)
  | 4 => L 0 4 + L 1 3 + L 2 2 + L 3 1 + L 4 0 + 2 * (H 0 3 + H 1 2 + H 2 1 + H 3 0)
  | 5 => L 1 4 + L 2 3 + L 3 2 + L 4 1 + 2 * (H 0 4 + H 1 3 + H 2 2 + H 3 1 + H 4 0)
  | 6 => L 2 4 + L 3 3 + L 4 2 + 2 * (H 1 4 + H 2 3 + H 3 2 + H 4 1)
  | 7 => L 3 4 + L 4 3 + 2 * (H 2 4 + H 3 3 + H 4 2)
  | 8 => L 4 4 + 2 * (H 3 4 + H 4 3)
  | 9 => 2 * H 4 4
  | _ => 0

/-- Column `d` of a square split by `madd52`: the low halves `L i j` with `i ≤ j`, `i + j = d`,
and twice the high halves `H i j` with `i ≤ j`, `i + j = d - 1`, off-diagonal ones doubled. -/
def scol (L H : ℕ → ℕ → ℕ) : ℕ → ℕ
  | 0 => L 0 0
  | 1 => 2 * L 0 1 + 2 * H 0 0
  | 2 => 2 * L 0 2 + L 1 1 + 2 * 2 * H 0 1
  | 3 => 2 * L 0 3 + 2 * L 1 2 + 2 * (2 * H 0 2 + H 1 1)
  | 4 => 2 * L 0 4 + 2 * L 1 3 + L 2 2 + 2 * (2 * H 0 3 + 2 * H 1 2)
  | 5 => 2 * L 1 4 + 2 * L 2 3 + 2 * (2 * H 0 4 + 2 * H 1 3 + H 2 2)
  | 6 => 2 * L 2 4 + L 3 3 + 2 * (2 * H 1 4 + 2 * H 2 3)
  | 7 => 2 * L 3 4 + 2 * (2 * H 2 4 + H 3 3)
  | 8 => L 4 4 + 2 * 2 * H 3 4
  | 9 => 2 * H 4 4
  | _ => 0

end

-- `ring` multiplies out `2^51` powers up to `2^408`
set_option exponentiation.threshold 512 in
/-- The columns of `X * Y`, `za + 19 zb`, differ from `X * Y` by `p zb`. -/
theorem mul_core {X Y : ℕ → ℕ} {L H : ℕ → ℕ → ℕ}
    (h : ∀ k j, k < 5 → j < 5 → X k * Y j = L k j + 2 ^ 52 * H k j) :
    (limbs5 (fun n => mcol L H n + 19 * mcol L H (n + 5)) : ℤ) +
        p * limbs5 (fun n => mcol L H (n + 5)) =
      limbs5 X * limbs5 Y := by
  have h00 : (X 0 : ℤ) * Y 0 = L 0 0 + 2 ^ 52 * H 0 0 := by
    exact_mod_cast h 0 0 (by norm_num) (by norm_num)
  have h01 : (X 0 : ℤ) * Y 1 = L 0 1 + 2 ^ 52 * H 0 1 := by
    exact_mod_cast h 0 1 (by norm_num) (by norm_num)
  have h02 : (X 0 : ℤ) * Y 2 = L 0 2 + 2 ^ 52 * H 0 2 := by
    exact_mod_cast h 0 2 (by norm_num) (by norm_num)
  have h03 : (X 0 : ℤ) * Y 3 = L 0 3 + 2 ^ 52 * H 0 3 := by
    exact_mod_cast h 0 3 (by norm_num) (by norm_num)
  have h04 : (X 0 : ℤ) * Y 4 = L 0 4 + 2 ^ 52 * H 0 4 := by
    exact_mod_cast h 0 4 (by norm_num) (by norm_num)
  have h10 : (X 1 : ℤ) * Y 0 = L 1 0 + 2 ^ 52 * H 1 0 := by
    exact_mod_cast h 1 0 (by norm_num) (by norm_num)
  have h11 : (X 1 : ℤ) * Y 1 = L 1 1 + 2 ^ 52 * H 1 1 := by
    exact_mod_cast h 1 1 (by norm_num) (by norm_num)
  have h12 : (X 1 : ℤ) * Y 2 = L 1 2 + 2 ^ 52 * H 1 2 := by
    exact_mod_cast h 1 2 (by norm_num) (by norm_num)
  have h13 : (X 1 : ℤ) * Y 3 = L 1 3 + 2 ^ 52 * H 1 3 := by
    exact_mod_cast h 1 3 (by norm_num) (by norm_num)
  have h14 : (X 1 : ℤ) * Y 4 = L 1 4 + 2 ^ 52 * H 1 4 := by
    exact_mod_cast h 1 4 (by norm_num) (by norm_num)
  have h20 : (X 2 : ℤ) * Y 0 = L 2 0 + 2 ^ 52 * H 2 0 := by
    exact_mod_cast h 2 0 (by norm_num) (by norm_num)
  have h21 : (X 2 : ℤ) * Y 1 = L 2 1 + 2 ^ 52 * H 2 1 := by
    exact_mod_cast h 2 1 (by norm_num) (by norm_num)
  have h22 : (X 2 : ℤ) * Y 2 = L 2 2 + 2 ^ 52 * H 2 2 := by
    exact_mod_cast h 2 2 (by norm_num) (by norm_num)
  have h23 : (X 2 : ℤ) * Y 3 = L 2 3 + 2 ^ 52 * H 2 3 := by
    exact_mod_cast h 2 3 (by norm_num) (by norm_num)
  have h24 : (X 2 : ℤ) * Y 4 = L 2 4 + 2 ^ 52 * H 2 4 := by
    exact_mod_cast h 2 4 (by norm_num) (by norm_num)
  have h30 : (X 3 : ℤ) * Y 0 = L 3 0 + 2 ^ 52 * H 3 0 := by
    exact_mod_cast h 3 0 (by norm_num) (by norm_num)
  have h31 : (X 3 : ℤ) * Y 1 = L 3 1 + 2 ^ 52 * H 3 1 := by
    exact_mod_cast h 3 1 (by norm_num) (by norm_num)
  have h32 : (X 3 : ℤ) * Y 2 = L 3 2 + 2 ^ 52 * H 3 2 := by
    exact_mod_cast h 3 2 (by norm_num) (by norm_num)
  have h33 : (X 3 : ℤ) * Y 3 = L 3 3 + 2 ^ 52 * H 3 3 := by
    exact_mod_cast h 3 3 (by norm_num) (by norm_num)
  have h34 : (X 3 : ℤ) * Y 4 = L 3 4 + 2 ^ 52 * H 3 4 := by
    exact_mod_cast h 3 4 (by norm_num) (by norm_num)
  have h40 : (X 4 : ℤ) * Y 0 = L 4 0 + 2 ^ 52 * H 4 0 := by
    exact_mod_cast h 4 0 (by norm_num) (by norm_num)
  have h41 : (X 4 : ℤ) * Y 1 = L 4 1 + 2 ^ 52 * H 4 1 := by
    exact_mod_cast h 4 1 (by norm_num) (by norm_num)
  have h42 : (X 4 : ℤ) * Y 2 = L 4 2 + 2 ^ 52 * H 4 2 := by
    exact_mod_cast h 4 2 (by norm_num) (by norm_num)
  have h43 : (X 4 : ℤ) * Y 3 = L 4 3 + 2 ^ 52 * H 4 3 := by
    exact_mod_cast h 4 3 (by norm_num) (by norm_num)
  have h44 : (X 4 : ℤ) * Y 4 = L 4 4 + 2 ^ 52 * H 4 4 := by
    exact_mod_cast h 4 4 (by norm_num) (by norm_num)
  simp only [limbs5, mcol, Nat.reduceAdd]
  rw [p_int]
  push_cast
  linear_combination
    -(h00 + 2 ^ 51 * (h01 + h10) + 2 ^ 102 * (h02 + h11 + h20) + 2 ^ 153 * (h03 + h12 + h21 + h30) +
        2 ^ 204 * (h04 + h13 + h22 + h31 + h40) +
        2 ^ 255 * (h14 + h23 + h32 + h41) +
        2 ^ 306 * (h24 + h33 + h42) +
        2 ^ 357 * (h34 + h43) +
        2 ^ 408 * h44)

-- `ring` multiplies out `2^51` powers up to `2^408`
set_option exponentiation.threshold 512 in
/-- The columns of `X ^ 2`, `za + 19 zb`, differ from `X ^ 2` by `p zb`. -/
theorem sqr_core {X : ℕ → ℕ} {L H : ℕ → ℕ → ℕ}
    (h : ∀ i j, i ≤ j → j < 5 → X i * X j = L i j + 2 ^ 52 * H i j) :
    (limbs5 (fun n => scol L H n + 19 * scol L H (n + 5)) : ℤ) +
        p * limbs5 (fun n => scol L H (n + 5)) =
      limbs5 X * limbs5 X := by
  have h00 : (X 0 : ℤ) * X 0 = L 0 0 + 2 ^ 52 * H 0 0 := by
    exact_mod_cast h 0 0 (by norm_num) (by norm_num)
  have h01 : (X 0 : ℤ) * X 1 = L 0 1 + 2 ^ 52 * H 0 1 := by
    exact_mod_cast h 0 1 (by norm_num) (by norm_num)
  have h02 : (X 0 : ℤ) * X 2 = L 0 2 + 2 ^ 52 * H 0 2 := by
    exact_mod_cast h 0 2 (by norm_num) (by norm_num)
  have h03 : (X 0 : ℤ) * X 3 = L 0 3 + 2 ^ 52 * H 0 3 := by
    exact_mod_cast h 0 3 (by norm_num) (by norm_num)
  have h04 : (X 0 : ℤ) * X 4 = L 0 4 + 2 ^ 52 * H 0 4 := by
    exact_mod_cast h 0 4 (by norm_num) (by norm_num)
  have h11 : (X 1 : ℤ) * X 1 = L 1 1 + 2 ^ 52 * H 1 1 := by
    exact_mod_cast h 1 1 (by norm_num) (by norm_num)
  have h12 : (X 1 : ℤ) * X 2 = L 1 2 + 2 ^ 52 * H 1 2 := by
    exact_mod_cast h 1 2 (by norm_num) (by norm_num)
  have h13 : (X 1 : ℤ) * X 3 = L 1 3 + 2 ^ 52 * H 1 3 := by
    exact_mod_cast h 1 3 (by norm_num) (by norm_num)
  have h14 : (X 1 : ℤ) * X 4 = L 1 4 + 2 ^ 52 * H 1 4 := by
    exact_mod_cast h 1 4 (by norm_num) (by norm_num)
  have h22 : (X 2 : ℤ) * X 2 = L 2 2 + 2 ^ 52 * H 2 2 := by
    exact_mod_cast h 2 2 (by norm_num) (by norm_num)
  have h23 : (X 2 : ℤ) * X 3 = L 2 3 + 2 ^ 52 * H 2 3 := by
    exact_mod_cast h 2 3 (by norm_num) (by norm_num)
  have h24 : (X 2 : ℤ) * X 4 = L 2 4 + 2 ^ 52 * H 2 4 := by
    exact_mod_cast h 2 4 (by norm_num) (by norm_num)
  have h33 : (X 3 : ℤ) * X 3 = L 3 3 + 2 ^ 52 * H 3 3 := by
    exact_mod_cast h 3 3 (by norm_num) (by norm_num)
  have h34 : (X 3 : ℤ) * X 4 = L 3 4 + 2 ^ 52 * H 3 4 := by
    exact_mod_cast h 3 4 (by norm_num) (by norm_num)
  have h44 : (X 4 : ℤ) * X 4 = L 4 4 + 2 ^ 52 * H 4 4 := by
    exact_mod_cast h 4 4 (by norm_num) (by norm_num)
  simp only [limbs5, scol, Nat.reduceAdd]
  rw [p_int]
  push_cast
  linear_combination
    -(h00 + 2 ^ 51 * 2 * h01 + 2 ^ 102 * (2 * h02 + h11) + 2 ^ 153 * (2 * h03 + 2 * h12) +
        2 ^ 204 * (2 * h04 + 2 * h13 + h22) +
        2 ^ 255 * (2 * h14 + 2 * h23) +
        2 ^ 306 * (2 * h24 + h33) +
        2 ^ 357 * 2 * h34 +
        2 ^ 408 * h44)

/-- A `p`-multiple apart in `ℤ`, equal in `ZMod p`. -/
theorem cast_of_core {u v w : ℕ} (h : (u : ℤ) + p * v = w) : (u : ZMod p) = w := by
  have e := congrArg (Int.cast : ℤ → ZMod p) h
  simpa only [Int.cast_add, Int.cast_mul, Int.cast_natCast, ZMod.natCast_self, zero_mul,
    add_zero] using e

/-- An element's `Ref.Limbs.nat` as `limbs5` of its lanes. -/
theorem nat_eq_limbs5 (x : Wwl) : Ref.Limbs.nat (limbs x) = limbs5 fun k => x[k]!.toNat := by
  simp [Ref.Limbs.nat, limbs5, limbs, getElem!_pos]

/-- `madd52hi` of 52-bit operands is below `2^52`. -/
theorem madd52hi_lt52 {a b : BitVec 64} (ha : a.toNat < 2 ^ 52) (hb : b.toNat < 2 ^ 52) :
    (madd52hi a b).toNat < 2 ^ 52 :=
  Firedancer.Avx512.R43x6.madd52hi_lt (m := 52) (n := 52) ha hb le_rfl le_rfl

/-! ## `fd_f25519_mul` -/

/-- `madd52lo`'s product of lane `k` of `x` and lane `j` of `y`. -/
def lmul (x y : Wwl) (k j : ℕ) : ℕ :=
  (madd52lo x[k]! y[j]!).toNat

/-- `madd52hi`'s product of lane `k` of `x` and lane `j` of `y`. -/
def hmul (x y : Wwl) (k j : ℕ) : ℕ :=
  (madd52hi x[k]! y[j]!).toNat

/-- The bounds `omega` needs on `a b`'s lanes and their `madd52` halves. -/
local macro "mul_bounds" a:ident b:ident ha:ident hb:ident : tactic =>
  `(tactic|
    ( have ba0 : ($a[0]'(by decide)).toNat < 2 ^ 52 := $ha 0
      have bb0 : ($b[0]'(by decide)).toNat < 2 ^ 52 := $hb 0
      have ba1 : ($a[1]'(by decide)).toNat < 2 ^ 52 := $ha 1
      have bb1 : ($b[1]'(by decide)).toNat < 2 ^ 52 := $hb 1
      have ba2 : ($a[2]'(by decide)).toNat < 2 ^ 52 := $ha 2
      have bb2 : ($b[2]'(by decide)).toNat < 2 ^ 52 := $hb 2
      have ba3 : ($a[3]'(by decide)).toNat < 2 ^ 52 := $ha 3
      have bb3 : ($b[3]'(by decide)).toNat < 2 ^ 52 := $hb 3
      have ba4 : ($a[4]'(by decide)).toNat < 2 ^ 52 := $ha 4
      have bb4 : ($b[4]'(by decide)).toNat < 2 ^ 52 := $hb 4
      have := madd52lo_lt ($a[0]'(by decide)) ($b[0]'(by decide))
      have := madd52hi_lt52 ba0 bb0
      have := madd52lo_lt ($a[0]'(by decide)) ($b[1]'(by decide))
      have := madd52hi_lt52 ba0 bb1
      have := madd52lo_lt ($a[0]'(by decide)) ($b[2]'(by decide))
      have := madd52hi_lt52 ba0 bb2
      have := madd52lo_lt ($a[0]'(by decide)) ($b[3]'(by decide))
      have := madd52hi_lt52 ba0 bb3
      have := madd52lo_lt ($a[0]'(by decide)) ($b[4]'(by decide))
      have := madd52hi_lt52 ba0 bb4
      have := madd52lo_lt ($a[1]'(by decide)) ($b[0]'(by decide))
      have := madd52hi_lt52 ba1 bb0
      have := madd52lo_lt ($a[1]'(by decide)) ($b[1]'(by decide))
      have := madd52hi_lt52 ba1 bb1
      have := madd52lo_lt ($a[1]'(by decide)) ($b[2]'(by decide))
      have := madd52hi_lt52 ba1 bb2
      have := madd52lo_lt ($a[1]'(by decide)) ($b[3]'(by decide))
      have := madd52hi_lt52 ba1 bb3
      have := madd52lo_lt ($a[1]'(by decide)) ($b[4]'(by decide))
      have := madd52hi_lt52 ba1 bb4
      have := madd52lo_lt ($a[2]'(by decide)) ($b[0]'(by decide))
      have := madd52hi_lt52 ba2 bb0
      have := madd52lo_lt ($a[2]'(by decide)) ($b[1]'(by decide))
      have := madd52hi_lt52 ba2 bb1
      have := madd52lo_lt ($a[2]'(by decide)) ($b[2]'(by decide))
      have := madd52hi_lt52 ba2 bb2
      have := madd52lo_lt ($a[2]'(by decide)) ($b[3]'(by decide))
      have := madd52hi_lt52 ba2 bb3
      have := madd52lo_lt ($a[2]'(by decide)) ($b[4]'(by decide))
      have := madd52hi_lt52 ba2 bb4
      have := madd52lo_lt ($a[3]'(by decide)) ($b[0]'(by decide))
      have := madd52hi_lt52 ba3 bb0
      have := madd52lo_lt ($a[3]'(by decide)) ($b[1]'(by decide))
      have := madd52hi_lt52 ba3 bb1
      have := madd52lo_lt ($a[3]'(by decide)) ($b[2]'(by decide))
      have := madd52hi_lt52 ba3 bb2
      have := madd52lo_lt ($a[3]'(by decide)) ($b[3]'(by decide))
      have := madd52hi_lt52 ba3 bb3
      have := madd52lo_lt ($a[3]'(by decide)) ($b[4]'(by decide))
      have := madd52hi_lt52 ba3 bb4
      have := madd52lo_lt ($a[4]'(by decide)) ($b[0]'(by decide))
      have := madd52hi_lt52 ba4 bb0
      have := madd52lo_lt ($a[4]'(by decide)) ($b[1]'(by decide))
      have := madd52hi_lt52 ba4 bb1
      have := madd52lo_lt ($a[4]'(by decide)) ($b[2]'(by decide))
      have := madd52hi_lt52 ba4 bb2
      have := madd52lo_lt ($a[4]'(by decide)) ($b[3]'(by decide))
      have := madd52hi_lt52 ba4 bb3
      have := madd52lo_lt ($a[4]'(by decide)) ($b[4]'(by decide))
      have := madd52hi_lt52 ba4 bb4
      skip))

/-- A lane of `fd_f25519_mul.z` as its columns: the lane operations, `toNat` with no overflow,
then `ring`. -/
local macro "mul_lane" hb5:ident hb6:ident hb7:ident : tactic =>
  `(tactic|
    ( unfold fd_f25519_mul.z
      iterate 2
        try
          simp only [wwl_add_get, wwl_and_get, wwl_shl_get, wwl_madd52lo_get, wwl_madd52hi_get,
            wwl_slide_get, wwl_permute_get, wwl_bcast_get, wwl_get0, wwl_get1, wwl_get2, wwl_get3,
            wwl_get4, wwl_get5, wwl_get6, wwl_get7, wwl_zero_get, getD_get,
            Vector.getElem_replicate, BitVec.reduceToNat, Nat.reduceMod, Nat.reduceLT,
            Nat.reduceAdd, Nat.reduceSub, ite_true, ite_false]
      simp only [$hb5:ident, $hb6:ident, $hb7:ident, mcol, lmul, hmul, getElem!_pos, Nat.reduceLT,
        Nat.reduceAdd, madd52lo_zero, madd52hi_zero, madd52lo_zero', madd52hi_zero',
        BitVec.zero_add, BitVec.add_zero, BitVec.zero_shiftLeft, BitVec.toNat_add,
        BitVec.toNat_shiftLeft, BitVec.toNat_and, Nat.shiftLeft_eq, BitVec.reduceToNat,
        BitVec.toNat_zero, Nat.reducePow, Nat.reduceMod, Nat.zero_add, Nat.add_zero, toNat_neg_one,
        and_m64, Nat.and_zero, Nat.zero_mod, Nat.zero_mul]
      simp only [Nat.mod_mod]
      clear $hb5:ident $hb6:ident $hb7:ident
      simp (disch := omega) only [Nat.mod_eq_of_lt]
      ring))

theorem mul_lane0 {a b : Wwl} (ha : Below 52 a) (hb : Below 52 b) :
    (fd_f25519_mul.z a b)[0].toNat =
      mcol (lmul a b) (hmul a b) 0 + 19 * mcol (lmul a b) (hmul a b) 5 := by
  obtain ⟨-, ha⟩ := ha
  obtain ⟨⟨hb5, hb6, hb7⟩, hb⟩ := hb
  mul_bounds a b ha hb
  clear ha hb
  mul_lane hb5 hb6 hb7

theorem mul_lane1 {a b : Wwl} (ha : Below 52 a) (hb : Below 52 b) :
    (fd_f25519_mul.z a b)[1].toNat =
      mcol (lmul a b) (hmul a b) 1 + 19 * mcol (lmul a b) (hmul a b) 6 := by
  obtain ⟨-, ha⟩ := ha
  obtain ⟨⟨hb5, hb6, hb7⟩, hb⟩ := hb
  mul_bounds a b ha hb
  clear ha hb
  mul_lane hb5 hb6 hb7

theorem mul_lane2 {a b : Wwl} (ha : Below 52 a) (hb : Below 52 b) :
    (fd_f25519_mul.z a b)[2].toNat =
      mcol (lmul a b) (hmul a b) 2 + 19 * mcol (lmul a b) (hmul a b) 7 := by
  obtain ⟨-, ha⟩ := ha
  obtain ⟨⟨hb5, hb6, hb7⟩, hb⟩ := hb
  mul_bounds a b ha hb
  clear ha hb
  mul_lane hb5 hb6 hb7

theorem mul_lane3 {a b : Wwl} (ha : Below 52 a) (hb : Below 52 b) :
    (fd_f25519_mul.z a b)[3].toNat =
      mcol (lmul a b) (hmul a b) 3 + 19 * mcol (lmul a b) (hmul a b) 8 := by
  obtain ⟨-, ha⟩ := ha
  obtain ⟨⟨hb5, hb6, hb7⟩, hb⟩ := hb
  mul_bounds a b ha hb
  clear ha hb
  mul_lane hb5 hb6 hb7

theorem mul_lane4 {a b : Wwl} (ha : Below 52 a) (hb : Below 52 b) :
    (fd_f25519_mul.z a b)[4].toNat =
      mcol (lmul a b) (hmul a b) 4 + 19 * mcol (lmul a b) (hmul a b) 9 := by
  obtain ⟨-, ha⟩ := ha
  obtain ⟨⟨hb5, hb6, hb7⟩, hb⟩ := hb
  mul_bounds a b ha hb
  clear ha hb
  mul_lane hb5 hb6 hb7

/-- `B(52)` lane `k < 5`, read with `!`. -/
theorem Below.get! {x : Wwl} (h : Below 52 x) {k : ℕ} (hk : k < 5) : x[k]!.toNat < 2 ^ 52 := by
  have := h.2 ⟨k, hk⟩
  rwa [getElem!_pos x k (by omega)]

/-- `fd_f25519_mul`'s `z` of `B(52)` operands has value `a * b`. -/
theorem mul_z_val {a b : Wwl} (ha : Below 52 a) (hb : Below 52 b) :
    val (fd_f25519_mul.z a b) = val a * val b := by
  have hz :
    Ref.Limbs.nat (limbs (fd_f25519_mul.z a b)) =
      limbs5 fun n => mcol (lmul a b) (hmul a b) n + 19 * mcol (lmul a b) (hmul a b) (n + 5) := by
    rw [nat_eq_limbs5]
    simp only [limbs5, getElem!_pos, Nat.reduceLT, mul_lane0 ha hb, mul_lane1 ha hb,
      mul_lane2 ha hb, mul_lane3 ha hb, mul_lane4 ha hb, Nat.reduceAdd]
  rw [val, Ref.Limbs.val_nat, hz,
    cast_of_core
      (mul_core (L := lmul a b) (H := hmul a b) (X := fun k => a[k]!.toNat) (Y := fun j =>
        b[j]!.toNat) fun k j hk hj => madd52_split (ha.get! hk) (hb.get! hj)),
    val, val, Ref.Limbs.val_nat, Ref.Limbs.val_nat, nat_eq_limbs5, nat_eq_limbs5, Nat.cast_mul]

/-- `fd_f25519_mul` multiplies `B(52)` elements into a `B(52)` one. -/
public theorem fd_f25519_mul.spec_val {a b : Wwl} (ha : Below 52 a) (hb : Below 52 b) :
    val (fd_f25519_mul.spec a b) = val a * val b ∧ Below 52 (fd_f25519_mul.spec a b) := by
  rw [fd_f25519_mul.spec]
  exact ⟨(fold.spec_val _).1.trans (mul_z_val ha hb), (fold.spec_val _).2⟩

/-! ## `fd_f25519_sqr` -/

/-- `madd52lo`'s product of lanes `i` and `j` of `x`. -/
def lsqr (x : Wwl) (i j : ℕ) : ℕ :=
  (madd52lo x[i]! x[j]!).toNat

/-- `madd52hi`'s product of lanes `i` and `j` of `x`. -/
def hsqr (x : Wwl) (i j : ℕ) : ℕ :=
  (madd52hi x[i]! x[j]!).toNat

/-- The bounds `omega` needs on `a`'s lanes and their `madd52` halves. -/
local macro "sqr_bounds" a:ident ha:ident : tactic =>
  `(tactic|
    ( have ba0 : ($a[0]'(by decide)).toNat < 2 ^ 52 := $ha 0
      have ba1 : ($a[1]'(by decide)).toNat < 2 ^ 52 := $ha 1
      have ba2 : ($a[2]'(by decide)).toNat < 2 ^ 52 := $ha 2
      have ba3 : ($a[3]'(by decide)).toNat < 2 ^ 52 := $ha 3
      have ba4 : ($a[4]'(by decide)).toNat < 2 ^ 52 := $ha 4
      have := madd52lo_lt ($a[0]'(by decide)) ($a[0]'(by decide))
      have := madd52hi_lt52 ba0 ba0
      have := madd52lo_lt ($a[0]'(by decide)) ($a[1]'(by decide))
      have := madd52hi_lt52 ba0 ba1
      have := madd52lo_lt ($a[0]'(by decide)) ($a[2]'(by decide))
      have := madd52hi_lt52 ba0 ba2
      have := madd52lo_lt ($a[0]'(by decide)) ($a[3]'(by decide))
      have := madd52hi_lt52 ba0 ba3
      have := madd52lo_lt ($a[0]'(by decide)) ($a[4]'(by decide))
      have := madd52hi_lt52 ba0 ba4
      have := madd52lo_lt ($a[1]'(by decide)) ($a[1]'(by decide))
      have := madd52hi_lt52 ba1 ba1
      have := madd52lo_lt ($a[1]'(by decide)) ($a[2]'(by decide))
      have := madd52hi_lt52 ba1 ba2
      have := madd52lo_lt ($a[1]'(by decide)) ($a[3]'(by decide))
      have := madd52hi_lt52 ba1 ba3
      have := madd52lo_lt ($a[1]'(by decide)) ($a[4]'(by decide))
      have := madd52hi_lt52 ba1 ba4
      have := madd52lo_lt ($a[2]'(by decide)) ($a[2]'(by decide))
      have := madd52hi_lt52 ba2 ba2
      have := madd52lo_lt ($a[2]'(by decide)) ($a[3]'(by decide))
      have := madd52hi_lt52 ba2 ba3
      have := madd52lo_lt ($a[2]'(by decide)) ($a[4]'(by decide))
      have := madd52hi_lt52 ba2 ba4
      have := madd52lo_lt ($a[3]'(by decide)) ($a[3]'(by decide))
      have := madd52hi_lt52 ba3 ba3
      have := madd52lo_lt ($a[3]'(by decide)) ($a[4]'(by decide))
      have := madd52hi_lt52 ba3 ba4
      have := madd52lo_lt ($a[4]'(by decide)) ($a[4]'(by decide))
      have := madd52hi_lt52 ba4 ba4
      skip))

/-- A lane of `fd_f25519_sqr.z` as its columns: the lane operations, `toNat` with no overflow,
then `ring`. -/
local macro "sqr_lane" ha5:ident : tactic =>
  `(tactic|
    ( unfold fd_f25519_sqr.z
      iterate 3
        try
          simp only [wwl_add_get, wwl_and_get, wwl_andnot_get, wwl_shl_get, wwl_shl_vector_get,
            wwl_madd52lo_get, wwl_madd52hi_get, wwl_slide_get, wwl_permute_get, wwl_get0, wwl_get1,
            wwl_get2, wwl_get3, wwl_get4, wwl_get5, wwl_get6, wwl_get7, wwl_zero_get, getD_get,
            Vector.getElem_replicate, BitVec.reduceToNat, Nat.reduceMod, Nat.reduceLT,
            Nat.reduceAdd, Nat.reduceSub, ite_true, ite_false]
      simp only [$ha5:ident, BitVec.shiftLeft_zero, BitVec.zero_shiftLeft, not_neg_one_and,
        not_zero_and, neg_one_and, zero_and, madd52lo_zero, madd52hi_zero, madd52lo_zero',
        madd52hi_zero', madd52lo_zero_left, madd52hi_zero_left]
      simp only [scol, lsqr, hsqr, getElem!_pos, Nat.reduceLT, Nat.reduceAdd, BitVec.zero_add,
        BitVec.add_zero, BitVec.toNat_add, BitVec.toNat_shiftLeft, BitVec.toNat_and,
        Nat.shiftLeft_eq, BitVec.reduceToNat, BitVec.toNat_zero, Nat.reducePow, Nat.reduceMod,
        Nat.zero_add, Nat.add_zero, toNat_neg_one, and_m64, Nat.and_zero, Nat.zero_mod,
        Nat.zero_mul]
      simp only [Nat.mod_mod]
      clear $ha5:ident
      simp (disch := omega) only [Nat.mod_eq_of_lt]
      ring))

theorem sqr_lane0 {a : Wwl} (ha : Below 52 a) :
    (fd_f25519_sqr.z a)[0].toNat = scol (lsqr a) (hsqr a) 0 + 19 * scol (lsqr a) (hsqr a) 5 := by
  obtain ⟨⟨ha5, -, -⟩, ha⟩ := ha
  sqr_bounds a ha
  clear ha
  sqr_lane ha5

theorem sqr_lane1 {a : Wwl} (ha : Below 52 a) :
    (fd_f25519_sqr.z a)[1].toNat = scol (lsqr a) (hsqr a) 1 + 19 * scol (lsqr a) (hsqr a) 6 := by
  obtain ⟨⟨ha5, -, -⟩, ha⟩ := ha
  sqr_bounds a ha
  clear ha
  sqr_lane ha5

theorem sqr_lane2 {a : Wwl} (ha : Below 52 a) :
    (fd_f25519_sqr.z a)[2].toNat = scol (lsqr a) (hsqr a) 2 + 19 * scol (lsqr a) (hsqr a) 7 := by
  obtain ⟨⟨ha5, -, -⟩, ha⟩ := ha
  sqr_bounds a ha
  clear ha
  sqr_lane ha5

theorem sqr_lane3 {a : Wwl} (ha : Below 52 a) :
    (fd_f25519_sqr.z a)[3].toNat = scol (lsqr a) (hsqr a) 3 + 19 * scol (lsqr a) (hsqr a) 8 := by
  obtain ⟨⟨ha5, -, -⟩, ha⟩ := ha
  sqr_bounds a ha
  clear ha
  sqr_lane ha5

theorem sqr_lane4 {a : Wwl} (ha : Below 52 a) :
    (fd_f25519_sqr.z a)[4].toNat = scol (lsqr a) (hsqr a) 4 + 19 * scol (lsqr a) (hsqr a) 9 := by
  obtain ⟨⟨ha5, -, -⟩, ha⟩ := ha
  sqr_bounds a ha
  clear ha
  sqr_lane ha5

/-- `fd_f25519_sqr`'s `z` of a `B(52)` operand has value `a ^ 2`. -/
theorem sqr_z_val {a : Wwl} (ha : Below 52 a) : val (fd_f25519_sqr.z a) = val a ^ 2 := by
  have hz :
    Ref.Limbs.nat (limbs (fd_f25519_sqr.z a)) =
      limbs5 fun n => scol (lsqr a) (hsqr a) n + 19 * scol (lsqr a) (hsqr a) (n + 5) := by
    rw [nat_eq_limbs5]
    simp only [limbs5, getElem!_pos, Nat.reduceLT, sqr_lane0 ha, sqr_lane1 ha, sqr_lane2 ha,
      sqr_lane3 ha, sqr_lane4 ha, Nat.reduceAdd]
  rw [val, Ref.Limbs.val_nat, hz,
    cast_of_core
      (sqr_core (L := lsqr a) (H := hsqr a) (X := fun k => a[k]!.toNat) fun i j hij hj =>
        madd52_split (ha.get! (by omega)) (ha.get! hj)),
    val, Ref.Limbs.val_nat, nat_eq_limbs5, Nat.cast_mul, sq]

/-- `fd_f25519_sqr` squares a `B(52)` element into a `B(52)` one. -/
public theorem fd_f25519_sqr.spec_val {a : Wwl} (ha : Below 52 a) :
    val (fd_f25519_sqr.spec a) = val a ^ 2 ∧ Below 52 (fd_f25519_sqr.spec a) := by
  rw [fd_f25519_sqr.spec]
  exact ⟨(fold.spec_val _).1.trans (sqr_z_val ha), (fold.spec_val _).2⟩

end MLIR.Firedancer.R52x5
