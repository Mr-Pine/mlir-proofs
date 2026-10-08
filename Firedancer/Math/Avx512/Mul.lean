module

public import Firedancer.Math.Avx512.R43x6
public import Firedancer.Avx512.fd_r43x6_mul_fast
public import Firedancer.Avx512.fd_r43x6_sqr_fast
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

/-! `fd_r43x6_mul_fast` and `fd_r43x6_sqr_fast`, and their folds `fd_r43x6_mul` and
`fd_r43x6_sqr`, in `ZMod p`: lane by lane, the products' 52-bit halves summed by columns, then
`za + 152 zb`. -/

namespace LeanMLIR.RIR.Firedancer.Avx512

open LeanMLIR.RIR.Firedancer.Ref (p)

namespace R43x6

-- the lane `simp` sets are shared by all lanes, each using part of them
set_option linter.unusedSimpArgs false

/-! ## `madd52` -/

/-- `madd52lo` of 52-bit operands: their product mod `2^52`. -/
public theorem madd52lo_toNat {a b : BitVec 64} (ha : a.toNat < 2 ^ 52) (hb : b.toNat < 2 ^ 52) :
    (madd52lo a b).toNat = a.toNat * b.toNat % 2 ^ 52 := by
  simp only [madd52lo, BitVec.toNat_and, BitVec.toNat_mul, BitVec.reduceToNat, m52, and_m52]
  rw [Nat.mod_eq_of_lt ha, Nat.mod_eq_of_lt hb, Nat.mod_mod_of_dvd _ (by decide)]

/-- `madd52hi` of 52-bit operands: their product over `2^52`. -/
public theorem madd52hi_toNat {a b : BitVec 64} (ha : a.toNat < 2 ^ 52) (hb : b.toNat < 2 ^ 52) :
    (madd52hi a b).toNat = a.toNat * b.toNat / 2 ^ 52 := by
  simp only [madd52hi, BitVec.toNat_setWidth, BitVec.toNat_ushiftRight, BitVec.toNat_mul,
    BitVec.toNat_and, BitVec.reduceToNat, m52, and_m52, Nat.shiftRight_eq_div_pow]
  rw [Nat.mod_eq_of_lt ha, Nat.mod_eq_of_lt hb, Nat.mod_eq_of_lt (a := a.toNat) (by omega),
    Nat.mod_eq_of_lt (a := b.toNat) (by omega)]
  have : a.toNat * b.toNat < 2 ^ 104 := by
    calc a.toNat * b.toNat < 2 ^ 52 * 2 ^ 52 := Nat.mul_lt_mul'' ha hb
      _ = 2 ^ 104 := by norm_num
  rw [Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega)]

public theorem madd52lo_lt (a b : BitVec 64) : (madd52lo a b).toNat < 2 ^ 52 := by
  simp only [madd52lo, BitVec.toNat_and, BitVec.reduceToNat, m52, and_m52]
  exact Nat.mod_lt _ (by decide)

/-- A product of 52-bit operands is its low half plus `2^52` times its high half. -/
public theorem madd52_split {a b : BitVec 64} (ha : a.toNat < 2 ^ 52) (hb : b.toNat < 2 ^ 52) :
    a.toNat * b.toNat = (madd52lo a b).toNat + 2 ^ 52 * (madd52hi a b).toNat := by
  rw [madd52lo_toNat ha hb, madd52hi_toNat ha hb, Nat.mod_add_div]

/-- `madd52hi` of `m`- and `n`-bit operands has `m + n - 52` bits. -/
public theorem madd52hi_lt {a b : BitVec 64} (ha : a.toNat < 2 ^ m) (hb : b.toNat < 2 ^ n)
    (hm : m ≤ 52) (hn : n ≤ 52) : (madd52hi a b).toNat < 2 ^ (m + n - 52) := by
  have pm := Nat.pow_le_pow_right (n := 2) (by decide) hm
  have pn := Nat.pow_le_pow_right (n := 2) (by decide) hn
  rw [madd52hi_toNat (by omega) (by omega), Nat.div_lt_iff_lt_mul (by norm_num), ← pow_add]
  calc a.toNat * b.toNat < 2 ^ m * 2 ^ n := Nat.mul_lt_mul'' ha hb
    _ = 2 ^ (m + n) := (pow_add _ _ _).symm
    _ ≤ 2 ^ (m + n - 52 + 52) := Nat.pow_le_pow_right (by decide) (by omega)

public theorem madd52hi_lt47 {a b : BitVec 64} (ha : a.toNat < 2 ^ 47) (hb : b.toNat < 2 ^ 47) :
    (madd52hi a b).toNat < 2 ^ 42 :=
  madd52hi_lt (m := 47) (n := 47) ha hb (by norm_num) (by norm_num)

public theorem madd52hi_lt48 {a b : BitVec 64} (ha : a.toNat < 2 ^ 48) (hb : b.toNat < 2 ^ 47) :
    (madd52hi a b).toNat < 2 ^ 43 :=
  madd52hi_lt (m := 48) (n := 47) ha hb (by norm_num) (by norm_num)

public theorem madd52lo_zero (a : BitVec 64) : madd52lo a 0 = 0 := by
  simp [madd52lo]

public theorem madd52hi_zero (a : BitVec 64) : madd52hi a 0 = 0 := by
  simp [madd52hi]

public theorem madd52lo_zero' (a : BitVec 64) : madd52lo a 0#64 = 0#64 :=
  madd52lo_zero a

public theorem madd52hi_zero' (a : BitVec 64) : madd52hi a 0#64 = 0#64 :=
  madd52hi_zero a

/-! ## Product columns -/

@[expose] public section

/-- Six radix-`2^43` limbs `f 0 … f 5`, packed. -/
def limbs6 (f : ℕ → ℕ) : ℕ :=
  f 0 + f 1 * 2 ^ 43 + f 2 * 2 ^ 86 + f 3 * 2 ^ 129 + f 4 * 2 ^ 172 + f 5 * 2 ^ 215

/-- Column `d` of a 6 × 6 product split by `madd52`: the low halves `L k j` with `k + j = d`, and
`2^9` times the high halves `H k j` with `k + j = d - 1`. -/
def mcol (L H : ℕ → ℕ → ℕ) : ℕ → ℕ
  | 0 => L 0 0
  | 1 => L 0 1 + L 1 0 + 2 ^ 9 * (H 0 0)
  | 2 => L 0 2 + L 1 1 + L 2 0 + 2 ^ 9 * (H 0 1 + H 1 0)
  | 3 => L 0 3 + L 1 2 + L 2 1 + L 3 0 + 2 ^ 9 * (H 0 2 + H 1 1 + H 2 0)
  | 4 => L 0 4 + L 1 3 + L 2 2 + L 3 1 + L 4 0 + 2 ^ 9 * (H 0 3 + H 1 2 + H 2 1 + H 3 0)
  | 5 => L 0 5 + L 1 4 + L 2 3 + L 3 2 + L 4 1 + L 5 0 + 2 ^ 9 * (H 0 4 + H 1 3 + H 2 2 + H 3 1 +
      H 4 0)
  | 6 => L 1 5 + L 2 4 + L 3 3 + L 4 2 + L 5 1 + 2 ^ 9 * (H 0 5 + H 1 4 + H 2 3 + H 3 2 + H 4 1 +
      H 5 0)
  | 7 => L 2 5 + L 3 4 + L 4 3 + L 5 2 + 2 ^ 9 * (H 1 5 + H 2 4 + H 3 3 + H 4 2 + H 5 1)
  | 8 => L 3 5 + L 4 4 + L 5 3 + 2 ^ 9 * (H 2 5 + H 3 4 + H 4 3 + H 5 2)
  | 9 => L 4 5 + L 5 4 + 2 ^ 9 * (H 3 5 + H 4 4 + H 5 3)
  | 10 => L 5 5 + 2 ^ 9 * (H 4 5 + H 5 4)
  | 11 => 2 ^ 9 * (H 5 5)
  | _ => 0

/-- Column `d` of a square split by `madd52`: the low halves `L i j` with `i ≤ j`, `i + j = d`,
and `2^9` times the high halves `H i j` with `i ≤ j`, `i + j = d - 1`. -/
def scol (L H : ℕ → ℕ → ℕ) : ℕ → ℕ
  | 0 => L 0 0
  | 1 => L 0 1 + 2 ^ 9 * (H 0 0)
  | 2 => L 0 2 + L 1 1 + 2 ^ 9 * (H 0 1)
  | 3 => L 0 3 + L 1 2 + 2 ^ 9 * (H 0 2 + H 1 1)
  | 4 => L 0 4 + L 1 3 + L 2 2 + 2 ^ 9 * (H 0 3 + H 1 2)
  | 5 => L 0 5 + L 1 4 + L 2 3 + 2 ^ 9 * (H 0 4 + H 1 3 + H 2 2)
  | 6 => L 1 5 + L 2 4 + L 3 3 + 2 ^ 9 * (H 0 5 + H 1 4 + H 2 3)
  | 7 => L 2 5 + L 3 4 + 2 ^ 9 * (H 1 5 + H 2 4 + H 3 3)
  | 8 => L 3 5 + L 4 4 + 2 ^ 9 * (H 2 5 + H 3 4)
  | 9 => L 4 5 + 2 ^ 9 * (H 3 5 + H 4 4)
  | 10 => L 5 5 + 2 ^ 9 * (H 4 5)
  | 11 => 2 ^ 9 * (H 5 5)
  | _ => 0

end

-- `ring` multiplies out `2^43` powers up to `2^430`
set_option exponentiation.threshold 512 in
/-- The columns of `X * Y`, `za + 152 zb`, differ from `X * Y` by `(2^258 - 152) zb`. -/
public theorem mul_core {X Y : ℕ → ℕ} {L H : ℕ → ℕ → ℕ}
    (h : ∀ k j, k < 6 → j < 6 → X k * Y j = L k j + 2 ^ 52 * H k j) :
    (limbs6 (fun n => mcol L H n + 152 * mcol L H (n + 6)) : ℤ) +
        8 * p * limbs6 (fun n => mcol L H (n + 6)) =
      limbs6 X * limbs6 Y := by
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
  have h05 : (X 0 : ℤ) * Y 5 = L 0 5 + 2 ^ 52 * H 0 5 := by
    exact_mod_cast h 0 5 (by norm_num) (by norm_num)
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
  have h15 : (X 1 : ℤ) * Y 5 = L 1 5 + 2 ^ 52 * H 1 5 := by
    exact_mod_cast h 1 5 (by norm_num) (by norm_num)
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
  have h25 : (X 2 : ℤ) * Y 5 = L 2 5 + 2 ^ 52 * H 2 5 := by
    exact_mod_cast h 2 5 (by norm_num) (by norm_num)
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
  have h35 : (X 3 : ℤ) * Y 5 = L 3 5 + 2 ^ 52 * H 3 5 := by
    exact_mod_cast h 3 5 (by norm_num) (by norm_num)
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
  have h45 : (X 4 : ℤ) * Y 5 = L 4 5 + 2 ^ 52 * H 4 5 := by
    exact_mod_cast h 4 5 (by norm_num) (by norm_num)
  have h50 : (X 5 : ℤ) * Y 0 = L 5 0 + 2 ^ 52 * H 5 0 := by
    exact_mod_cast h 5 0 (by norm_num) (by norm_num)
  have h51 : (X 5 : ℤ) * Y 1 = L 5 1 + 2 ^ 52 * H 5 1 := by
    exact_mod_cast h 5 1 (by norm_num) (by norm_num)
  have h52 : (X 5 : ℤ) * Y 2 = L 5 2 + 2 ^ 52 * H 5 2 := by
    exact_mod_cast h 5 2 (by norm_num) (by norm_num)
  have h53 : (X 5 : ℤ) * Y 3 = L 5 3 + 2 ^ 52 * H 5 3 := by
    exact_mod_cast h 5 3 (by norm_num) (by norm_num)
  have h54 : (X 5 : ℤ) * Y 4 = L 5 4 + 2 ^ 52 * H 5 4 := by
    exact_mod_cast h 5 4 (by norm_num) (by norm_num)
  have h55 : (X 5 : ℤ) * Y 5 = L 5 5 + 2 ^ 52 * H 5 5 := by
    exact_mod_cast h 5 5 (by norm_num) (by norm_num)
  simp only [limbs6, mcol, Nat.reduceAdd]
  rw [p_int]
  push_cast
  linear_combination -(2 ^ 0 * h00 + 2 ^ 43 * h01 + 2 ^ 86 * h02 + 2 ^ 129 * h03 + 2 ^ 172 * h04 +
      2 ^ 215 * h05 + 2 ^ 43 * h10 + 2 ^ 86 * h11 + 2 ^ 129 * h12 + 2 ^ 172 * h13 + 2 ^ 215 * h14 +
      2 ^ 258 * h15 + 2 ^ 86 * h20 + 2 ^ 129 * h21 + 2 ^ 172 * h22 + 2 ^ 215 * h23 + 2 ^ 258 * h24 +
      2 ^ 301 * h25 + 2 ^ 129 * h30 + 2 ^ 172 * h31 + 2 ^ 215 * h32 + 2 ^ 258 * h33 +
      2 ^ 301 * h34 + 2 ^ 344 * h35 + 2 ^ 172 * h40 + 2 ^ 215 * h41 + 2 ^ 258 * h42 +
      2 ^ 301 * h43 + 2 ^ 344 * h44 + 2 ^ 387 * h45 + 2 ^ 215 * h50 + 2 ^ 258 * h51 +
      2 ^ 301 * h52 + 2 ^ 344 * h53 + 2 ^ 387 * h54 + 2 ^ 430 * h55)

/-- `za + 152 zb` of a product of `u47` limbs is below `2^63`. -/
public theorem mcol_lt {L H : ℕ → ℕ → ℕ} (hL : ∀ k j, k < 6 → j < 6 → L k j < 2 ^ 52)
    (hH : ∀ k j, k < 6 → j < 6 → H k j < 2 ^ 42) (n : ℕ) (hn : n < 6) :
    mcol L H n + 152 * mcol L H (n + 6) < 2 ^ 63 := by
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

/-- `x[k]!` of an unsigned limb. -/
public theorem Unsigned.get! {x : Wwl} (h : Unsigned n x) {k : ℕ} (hk : k < 6) :
    x[k]!.toNat < 2 ^ n := by
  have := h ⟨k, hk⟩
  rwa [getElem!_pos x k (by omega)]

public theorem nat_eq_limbs6 (x : Wwl) : nat x = limbs6 fun k => x[k]!.toNat := by
  simp [nat, limbs6, getElem!_pos]

/-- An `fd_r43x6_t` whose lanes are the columns `za + 152 zb` of `X * Y`, below `2^63`, has
value `X * Y`. -/
public theorem val_of_mcol {z : Wwl} {L H : ℕ → ℕ → ℕ} {X Y : ℕ → ℕ}
    (hz : nat z = limbs6 fun n => mcol L H n + 152 * mcol L H (n + 6)) (hz63 : Unsigned 63 z)
    (h : ∀ k j, k < 6 → j < 6 → X k * Y j = L k j + 2 ^ 52 * H k j) :
    val z = (limbs6 X : ZMod p) * limbs6 Y := by
  have e := congrArg (Int.cast : ℤ → ZMod p) (mul_core h)
  simp only [Int.cast_add, Int.cast_mul, Int.cast_natCast, Int.cast_ofNat, ZMod.natCast_self,
    mul_zero, zero_mul, add_zero] at e
  rw [val_eq_nat hz63, hz, e]

/-! ## `fd_r43x6_mul_fast` -/

public theorem toNat_neg_one : (-1 : BitVec 64).toNat = 18446744073709551615 := by
  decide

/-- `&&& (2^64 - 1)` on naturals. -/
public theorem and_m64 (n : ℕ) : n &&& 18446744073709551615 = n % 2 ^ 64 :=
  Nat.and_two_pow_sub_one_eq_mod n 64

/-- `madd52lo`'s product of limb `k` of `x` and limb `j` of `y`. -/
def lmul (x y : Wwl) (k j : ℕ) : ℕ :=
  (madd52lo x[k]! y[j]!).toNat

/-- `madd52hi`'s product of limb `k` of `x` and limb `j` of `y`. -/
def hmul (x y : Wwl) (k j : ℕ) : ℕ :=
  (madd52hi x[k]! y[j]!).toNat

/-- A lane as its columns: the lane operations, then `toNat` with no overflow. -/
local macro "lane_nat" : tactic =>
  `(tactic| (
    iterate 2
      try simp only [wwl_add_get, wwl_sub_get, wwl_and_get, wwl_andnot_get, wwl_shl_get,
        wwl_shl_vector_get, wwl_shr_vector_get, wwl_shru_vector_get, wwl_madd52lo_get,
        wwl_madd52hi_get, wwl_permute_get, wwl_select_get, wwl_slide_get, wwl_pack_halves_get,
        wwl_pack_h0_h1_get, wwv_add_if_get, wwl_bcast_get, wwl_get0, wwl_get1, wwl_get2, wwl_get3,
        wwl_get4, wwl_get5, wwl_get6, wwl_get7, wwl_zero_get, getD_get, Vector.getElem_replicate,
        BitVec.reduceToNat, Nat.reduceMod, Nat.reduceLT, Nat.reduceAdd, Nat.reduceSub, ite_true,
        ite_false]
    simp only [mcol, lmul, hmul, getElem!_pos, Nat.reduceLT, Nat.reduceAdd, madd52lo_zero,
      madd52hi_zero, BitVec.zero_add, BitVec.add_zero, BitVec.zero_shiftLeft, BitVec.toNat_add,
      BitVec.toNat_shiftLeft, BitVec.toNat_and, Nat.shiftLeft_eq, BitVec.reduceToNat,
      BitVec.toNat_zero, Nat.reducePow, Nat.reduceMod] at *
    simp (disch := omega) only [Nat.mod_eq_of_lt, Nat.and_two_pow_sub_one_eq_mod]
    omega))

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
    simp only [$hy6:ident, $hy7:ident, mcol, lmul, hmul, getElem!_pos, Nat.reduceLT, Nat.reduceAdd,
      madd52lo_zero, madd52hi_zero, BitVec.zero_add, BitVec.add_zero, BitVec.zero_shiftLeft,
      BitVec.toNat_add, BitVec.toNat_shiftLeft, BitVec.toNat_and, Nat.shiftLeft_eq,
      BitVec.reduceToNat, BitVec.toNat_zero, Nat.reducePow, Nat.reduceMod, Nat.zero_add,
      Nat.add_zero, toNat_neg_one, and_m64, Nat.and_zero, Nat.zero_mod, Nat.zero_mul]
    simp (disch := omega) only [Nat.mod_eq_of_lt, Nat.mod_mod]
    ring))

theorem mul_fast_lane0 {x y : Wwl} (hx : Unsigned 47 x) (hy : Unreduced y) :
    (fd_r43x6_mul_fast.spec x y)[0].toNat =
      mcol (lmul x y) (hmul x y) 0 + 152 * mcol (lmul x y) (hmul x y) 6 := by
  obtain ⟨hy, hy6, hy7⟩ := hy
  mul_bounds x y hx hy
  mul_lane hy6 hy7

theorem mul_fast_lane1 {x y : Wwl} (hx : Unsigned 47 x) (hy : Unreduced y) :
    (fd_r43x6_mul_fast.spec x y)[1].toNat =
      mcol (lmul x y) (hmul x y) 1 + 152 * mcol (lmul x y) (hmul x y) 7 := by
  obtain ⟨hy, hy6, hy7⟩ := hy
  mul_bounds x y hx hy
  mul_lane hy6 hy7

theorem mul_fast_lane2 {x y : Wwl} (hx : Unsigned 47 x) (hy : Unreduced y) :
    (fd_r43x6_mul_fast.spec x y)[2].toNat =
      mcol (lmul x y) (hmul x y) 2 + 152 * mcol (lmul x y) (hmul x y) 8 := by
  obtain ⟨hy, hy6, hy7⟩ := hy
  mul_bounds x y hx hy
  mul_lane hy6 hy7

theorem mul_fast_lane3 {x y : Wwl} (hx : Unsigned 47 x) (hy : Unreduced y) :
    (fd_r43x6_mul_fast.spec x y)[3].toNat =
      mcol (lmul x y) (hmul x y) 3 + 152 * mcol (lmul x y) (hmul x y) 9 := by
  obtain ⟨hy, hy6, hy7⟩ := hy
  mul_bounds x y hx hy
  mul_lane hy6 hy7

theorem mul_fast_lane4 {x y : Wwl} (hx : Unsigned 47 x) (hy : Unreduced y) :
    (fd_r43x6_mul_fast.spec x y)[4].toNat =
      mcol (lmul x y) (hmul x y) 4 + 152 * mcol (lmul x y) (hmul x y) 10 := by
  obtain ⟨hy, hy6, hy7⟩ := hy
  mul_bounds x y hx hy
  mul_lane hy6 hy7

theorem mul_fast_lane5 {x y : Wwl} (hx : Unsigned 47 x) (hy : Unreduced y) :
    (fd_r43x6_mul_fast.spec x y)[5].toNat =
      mcol (lmul x y) (hmul x y) 5 + 152 * mcol (lmul x y) (hmul x y) 11 := by
  obtain ⟨hy, hy6, hy7⟩ := hy
  mul_bounds x y hx hy
  mul_lane hy6 hy7

theorem mul_fast_lane67 {x y : Wwl} (hy : Unreduced y) :
    (fd_r43x6_mul_fast.spec x y)[6] = 0 ∧ (fd_r43x6_mul_fast.spec x y)[7] = 0 := by
  obtain ⟨-, hy6, hy7⟩ := hy
  unfold fd_r43x6_mul_fast.spec fd_r43x6_mul_fast.tail fold152
  constructor <;>
  · iterate 2
      try simp only [wwl_add_get, wwl_and_get, wwl_shl_get, wwl_madd52lo_get,
        wwl_madd52hi_get, wwl_slide_get, wwl_get0, wwl_get1, wwl_get2, wwl_get3,
        wwl_get4, wwl_get5, wwl_get6, wwl_get7, wwl_zero_get, getD_get, Vector.getElem_replicate,
        BitVec.reduceToNat, Nat.reduceMod, Nat.reduceLT, Nat.reduceAdd, Nat.reduceSub, ite_true,
        ite_false, Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero,
        List.getElem_cons_succ]
    simp [hy6, hy7, madd52lo_zero, madd52hi_zero, madd52lo_zero', madd52hi_zero']

/-- `fd_r43x6_mul_fast` multiplies `u47` limbs (`y`'s lanes 6 and 7 zero) into `u63` limbs with
lanes 6 and 7 zero. -/
public theorem fd_r43x6_mul_fast_spec {x y : Wwl} (hx : Unsigned 47 x) (hy : Unreduced y) :
    val (fd_r43x6_mul_fast.spec x y) = val x * val y ∧
      Unsigned 63 (fd_r43x6_mul_fast.spec x y) ∧ HighZero (fd_r43x6_mul_fast.spec x y) := by
  have hL : ∀ k j, k < 6 → j < 6 → lmul x y k j < 2 ^ 52 := fun k j _ _ => madd52lo_lt _ _
  have hH : ∀ k j, k < 6 → j < 6 → hmul x y k j < 2 ^ 42 := fun k j hk hj =>
    madd52hi_lt47 (hx.get! hk) (hy.1.get! hj)
  have hc := mcol_lt hL hH
  have e0 := mul_fast_lane0 hx hy
  have e1 := mul_fast_lane1 hx hy
  have e2 := mul_fast_lane2 hx hy
  have e3 := mul_fast_lane3 hx hy
  have e4 := mul_fast_lane4 hx hy
  have e5 := mul_fast_lane5 hx hy
  have z63 : Unsigned 63 (fd_r43x6_mul_fast.spec x y) := by
    have := hc 0 (by norm_num); have := hc 1 (by norm_num); have := hc 2 (by norm_num)
    have := hc 3 (by norm_num); have := hc 4 (by norm_num); have := hc 5 (by norm_num)
    intro i; fin_cases i <;> simp only [Fin.isValue, Fin.val_zero, Fin.val_one, Fin.val_two,
      Fin.coe_ofNat_eq_mod, Nat.reduceMod, e0, e1, e2, e3, e4, e5] <;> omega
  refine ⟨?_, z63, mul_fast_lane67 hy⟩
  rw [val_of_mcol (L := lmul x y) (H := hmul x y) (X := fun k => x[k]!.toNat)
      (Y := fun j => y[j]!.toNat) (by simp only [nat, limbs6, e0, e1, e2, e3, e4, e5]) z63
      fun k j hk hj => madd52_split ((hx.get! hk).trans (by norm_num))
        ((hy.1.get! hj).trans (by norm_num)),
    val_eq_nat (hx.mono (by norm_num)), val_eq_nat (hy.1.mono (by norm_num)), nat_eq_limbs6,
    nat_eq_limbs6]

/-- `fd_r43x6_mul` multiplies `u47` limbs (`y`'s lanes 6 and 7 zero) into folded ones. -/
public theorem fd_r43x6_mul_spec {x y : Wwl} (hx : Unsigned 47 x) (hy : Unreduced y) :
    val (fd_r43x6_mul x y) = val x * val y ∧ Folded (fd_r43x6_mul x y) := by
  obtain ⟨v, h63, -⟩ := fd_r43x6_mul_fast_spec hx hy
  obtain ⟨v', f⟩ := fold_spec h63
  exact ⟨by rw [fd_r43x6_mul, v', v], f⟩

-- `ring` multiplies out `2^43` powers up to `2^430`
set_option exponentiation.threshold 512 in
/-- `X ^ 2`'s columns, `za + 152 zb`, differ from `X ^ 2` by `(2^258 - 152) zb`. -/
public theorem sqr_core {X : ℕ → ℕ} {L H : ℕ → ℕ → ℕ}
    (hd : ∀ i, i < 6 → X i * X i = L i i + 2 ^ 52 * H i i)
    (ho : ∀ i j, i < j → j < 6 → 2 * X i * X j = L i j + 2 ^ 52 * H i j) :
    (limbs6 (fun n => scol L H n + 152 * scol L H (n + 6)) : ℤ) +
        8 * p * limbs6 (fun n => scol L H (n + 6)) =
      limbs6 X * limbs6 X := by
  have h00 : (X 0 : ℤ) * X 0 = L 0 0 + 2 ^ 52 * H 0 0 := by
    exact_mod_cast hd 0 (by norm_num)
  have h01 : 2 * (X 0 : ℤ) * X 1 = L 0 1 + 2 ^ 52 * H 0 1 := by
    exact_mod_cast ho 0 1 (by norm_num) (by norm_num)
  have h02 : 2 * (X 0 : ℤ) * X 2 = L 0 2 + 2 ^ 52 * H 0 2 := by
    exact_mod_cast ho 0 2 (by norm_num) (by norm_num)
  have h03 : 2 * (X 0 : ℤ) * X 3 = L 0 3 + 2 ^ 52 * H 0 3 := by
    exact_mod_cast ho 0 3 (by norm_num) (by norm_num)
  have h04 : 2 * (X 0 : ℤ) * X 4 = L 0 4 + 2 ^ 52 * H 0 4 := by
    exact_mod_cast ho 0 4 (by norm_num) (by norm_num)
  have h05 : 2 * (X 0 : ℤ) * X 5 = L 0 5 + 2 ^ 52 * H 0 5 := by
    exact_mod_cast ho 0 5 (by norm_num) (by norm_num)
  have h11 : (X 1 : ℤ) * X 1 = L 1 1 + 2 ^ 52 * H 1 1 := by
    exact_mod_cast hd 1 (by norm_num)
  have h12 : 2 * (X 1 : ℤ) * X 2 = L 1 2 + 2 ^ 52 * H 1 2 := by
    exact_mod_cast ho 1 2 (by norm_num) (by norm_num)
  have h13 : 2 * (X 1 : ℤ) * X 3 = L 1 3 + 2 ^ 52 * H 1 3 := by
    exact_mod_cast ho 1 3 (by norm_num) (by norm_num)
  have h14 : 2 * (X 1 : ℤ) * X 4 = L 1 4 + 2 ^ 52 * H 1 4 := by
    exact_mod_cast ho 1 4 (by norm_num) (by norm_num)
  have h15 : 2 * (X 1 : ℤ) * X 5 = L 1 5 + 2 ^ 52 * H 1 5 := by
    exact_mod_cast ho 1 5 (by norm_num) (by norm_num)
  have h22 : (X 2 : ℤ) * X 2 = L 2 2 + 2 ^ 52 * H 2 2 := by
    exact_mod_cast hd 2 (by norm_num)
  have h23 : 2 * (X 2 : ℤ) * X 3 = L 2 3 + 2 ^ 52 * H 2 3 := by
    exact_mod_cast ho 2 3 (by norm_num) (by norm_num)
  have h24 : 2 * (X 2 : ℤ) * X 4 = L 2 4 + 2 ^ 52 * H 2 4 := by
    exact_mod_cast ho 2 4 (by norm_num) (by norm_num)
  have h25 : 2 * (X 2 : ℤ) * X 5 = L 2 5 + 2 ^ 52 * H 2 5 := by
    exact_mod_cast ho 2 5 (by norm_num) (by norm_num)
  have h33 : (X 3 : ℤ) * X 3 = L 3 3 + 2 ^ 52 * H 3 3 := by
    exact_mod_cast hd 3 (by norm_num)
  have h34 : 2 * (X 3 : ℤ) * X 4 = L 3 4 + 2 ^ 52 * H 3 4 := by
    exact_mod_cast ho 3 4 (by norm_num) (by norm_num)
  have h35 : 2 * (X 3 : ℤ) * X 5 = L 3 5 + 2 ^ 52 * H 3 5 := by
    exact_mod_cast ho 3 5 (by norm_num) (by norm_num)
  have h44 : (X 4 : ℤ) * X 4 = L 4 4 + 2 ^ 52 * H 4 4 := by
    exact_mod_cast hd 4 (by norm_num)
  have h45 : 2 * (X 4 : ℤ) * X 5 = L 4 5 + 2 ^ 52 * H 4 5 := by
    exact_mod_cast ho 4 5 (by norm_num) (by norm_num)
  have h55 : (X 5 : ℤ) * X 5 = L 5 5 + 2 ^ 52 * H 5 5 := by
    exact_mod_cast hd 5 (by norm_num)
  simp only [limbs6, scol, Nat.reduceAdd]
  rw [p_int]
  push_cast
  linear_combination -(2 ^ 0 * h00 + 2 ^ 43 * h01 + 2 ^ 86 * h02 + 2 ^ 129 * h03 + 2 ^ 172 * h04 +
      2 ^ 215 * h05 + 2 ^ 86 * h11 + 2 ^ 129 * h12 + 2 ^ 172 * h13 + 2 ^ 215 * h14 + 2 ^ 258 * h15 +
      2 ^ 172 * h22 + 2 ^ 215 * h23 + 2 ^ 258 * h24 + 2 ^ 301 * h25 + 2 ^ 258 * h33 +
      2 ^ 301 * h34 + 2 ^ 344 * h35 + 2 ^ 344 * h44 + 2 ^ 387 * h45 + 2 ^ 430 * h55)

/-- `za + 152 zb` of a square of `u47` limbs is below `2^63`. -/
public theorem scol_lt {L H : ℕ → ℕ → ℕ} (hL : ∀ i j, i ≤ j → j < 6 → L i j < 2 ^ 52)
    (hH : ∀ i j, i ≤ j → j < 6 → H i j < 2 ^ 43) (n : ℕ) (hn : n < 6) :
    scol L H n + 152 * scol L H (n + 6) < 2 ^ 63 := by
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
  have := hL 2 2 (by norm_num) (by norm_num)
  have := hH 2 2 (by norm_num) (by norm_num)
  have := hL 2 3 (by norm_num) (by norm_num)
  have := hH 2 3 (by norm_num) (by norm_num)
  have := hL 2 4 (by norm_num) (by norm_num)
  have := hH 2 4 (by norm_num) (by norm_num)
  have := hL 2 5 (by norm_num) (by norm_num)
  have := hH 2 5 (by norm_num) (by norm_num)
  have := hL 3 3 (by norm_num) (by norm_num)
  have := hH 3 3 (by norm_num) (by norm_num)
  have := hL 3 4 (by norm_num) (by norm_num)
  have := hH 3 4 (by norm_num) (by norm_num)
  have := hL 3 5 (by norm_num) (by norm_num)
  have := hH 3 5 (by norm_num) (by norm_num)
  have := hL 4 4 (by norm_num) (by norm_num)
  have := hH 4 4 (by norm_num) (by norm_num)
  have := hL 4 5 (by norm_num) (by norm_num)
  have := hH 4 5 (by norm_num) (by norm_num)
  have := hL 5 5 (by norm_num) (by norm_num)
  have := hH 5 5 (by norm_num) (by norm_num)
  match n, hn with
  | 0, _ | 1, _ | 2, _ | 3, _ | 4, _ | 5, _ => simp only [scol, Nat.reduceAdd]; omega

/-- An `fd_r43x6_t` whose lanes are the columns `za + 152 zb` of `X ^ 2`, below `2^63`, has
value `X ^ 2`. -/
public theorem val_of_scol {z : Wwl} {L H : ℕ → ℕ → ℕ} {X : ℕ → ℕ}
    (hz : nat z = limbs6 fun n => scol L H n + 152 * scol L H (n + 6)) (hz63 : Unsigned 63 z)
    (hd : ∀ i, i < 6 → X i * X i = L i i + 2 ^ 52 * H i i)
    (ho : ∀ i j, i < j → j < 6 → 2 * X i * X j = L i j + 2 ^ 52 * H i j) :
    val z = (limbs6 X : ZMod p) ^ 2 := by
  have e := congrArg (Int.cast : ℤ → ZMod p) (sqr_core hd ho)
  simp only [Int.cast_add, Int.cast_mul, Int.cast_natCast, Int.cast_ofNat, ZMod.natCast_self,
    mul_zero, zero_mul, add_zero] at e
  rw [val_eq_nat hz63, hz, e, sq]

/-! ## `fd_r43x6_sqr_fast` -/

/-- Doubling a long below `2^63`. -/
public theorem shl1_toNat {a : BitVec 64} (h : a.toNat < 2 ^ 63) :
    (a <<< 1).toNat = 2 * a.toNat := by
  rw [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq, Nat.mod_eq_of_lt (by omega)]
  ring

public theorem shl1_lt {a : BitVec 64} (h : a.toNat < 2 ^ 47) : (a <<< 1).toNat < 2 ^ 48 := by
  rw [shl1_toNat (by omega)]
  omega

public theorem madd52lo_zero_left (a : BitVec 64) : madd52lo 0#64 a = 0#64 := by
  simp [madd52lo]

public theorem madd52hi_zero_left (a : BitVec 64) : madd52hi 0#64 a = 0#64 := by
  simp [madd52hi]

public theorem not_neg_one_and (a : BitVec 64) : ~~~(-1 : BitVec 64) &&& a = 0#64 := by
  bv_decide

public theorem not_zero_and (a : BitVec 64) : ~~~(0 : BitVec 64) &&& a = a := by
  bv_decide

public theorem neg_one_and (a : BitVec 64) : (-1 : BitVec 64) &&& a = a := by
  bv_decide

public theorem zero_and (a : BitVec 64) : (0 : BitVec 64) &&& a = 0#64 := by
  bv_decide

/-- `madd52lo`'s product of limbs `i ≤ j` of `x`, limb `i` doubled unless `i = j`. -/
def lsqr (x : Wwl) (i j : ℕ) : ℕ :=
  if i = j then (madd52lo x[i]! x[j]!).toNat else (madd52lo (x[i]! <<< 1) x[j]!).toNat

/-- `madd52hi`'s product of limbs `i ≤ j` of `x`, limb `i` doubled unless `i = j`. -/
def hsqr (x : Wwl) (i j : ℕ) : ℕ :=
  if i = j then (madd52hi x[i]! x[j]!).toNat else (madd52hi (x[i]! <<< 1) x[j]!).toNat

/-- The bounds `omega` needs on `x`'s lanes and their `madd52` halves. -/
local macro "sqr_bounds" x:ident hx:ident : tactic =>
  `(tactic| (
    have bx0 : ($x[0]'(by decide)).toNat < 2 ^ 47 := $hx 0
    have dx0 := shl1_lt bx0
    have bx1 : ($x[1]'(by decide)).toNat < 2 ^ 47 := $hx 1
    have dx1 := shl1_lt bx1
    have bx2 : ($x[2]'(by decide)).toNat < 2 ^ 47 := $hx 2
    have dx2 := shl1_lt bx2
    have bx3 : ($x[3]'(by decide)).toNat < 2 ^ 47 := $hx 3
    have dx3 := shl1_lt bx3
    have bx4 : ($x[4]'(by decide)).toNat < 2 ^ 47 := $hx 4
    have dx4 := shl1_lt bx4
    have bx5 : ($x[5]'(by decide)).toNat < 2 ^ 47 := $hx 5
    have dx5 := shl1_lt bx5
    have := madd52lo_lt ($x[0]'(by decide)) ($x[0]'(by decide))
    have := madd52hi_lt47 bx0 bx0
    have := madd52lo_lt (($x[0]'(by decide)) <<< 1) ($x[1]'(by decide))
    have := madd52hi_lt48 dx0 bx1
    have := madd52lo_lt (($x[0]'(by decide)) <<< 1) ($x[2]'(by decide))
    have := madd52hi_lt48 dx0 bx2
    have := madd52lo_lt (($x[0]'(by decide)) <<< 1) ($x[3]'(by decide))
    have := madd52hi_lt48 dx0 bx3
    have := madd52lo_lt (($x[0]'(by decide)) <<< 1) ($x[4]'(by decide))
    have := madd52hi_lt48 dx0 bx4
    have := madd52lo_lt (($x[0]'(by decide)) <<< 1) ($x[5]'(by decide))
    have := madd52hi_lt48 dx0 bx5
    have := madd52lo_lt ($x[1]'(by decide)) ($x[1]'(by decide))
    have := madd52hi_lt47 bx1 bx1
    have := madd52lo_lt (($x[1]'(by decide)) <<< 1) ($x[2]'(by decide))
    have := madd52hi_lt48 dx1 bx2
    have := madd52lo_lt (($x[1]'(by decide)) <<< 1) ($x[3]'(by decide))
    have := madd52hi_lt48 dx1 bx3
    have := madd52lo_lt (($x[1]'(by decide)) <<< 1) ($x[4]'(by decide))
    have := madd52hi_lt48 dx1 bx4
    have := madd52lo_lt (($x[1]'(by decide)) <<< 1) ($x[5]'(by decide))
    have := madd52hi_lt48 dx1 bx5
    have := madd52lo_lt ($x[2]'(by decide)) ($x[2]'(by decide))
    have := madd52hi_lt47 bx2 bx2
    have := madd52lo_lt (($x[2]'(by decide)) <<< 1) ($x[3]'(by decide))
    have := madd52hi_lt48 dx2 bx3
    have := madd52lo_lt (($x[2]'(by decide)) <<< 1) ($x[4]'(by decide))
    have := madd52hi_lt48 dx2 bx4
    have := madd52lo_lt (($x[2]'(by decide)) <<< 1) ($x[5]'(by decide))
    have := madd52hi_lt48 dx2 bx5
    have := madd52lo_lt ($x[3]'(by decide)) ($x[3]'(by decide))
    have := madd52hi_lt47 bx3 bx3
    have := madd52lo_lt (($x[3]'(by decide)) <<< 1) ($x[4]'(by decide))
    have := madd52hi_lt48 dx3 bx4
    have := madd52lo_lt (($x[3]'(by decide)) <<< 1) ($x[5]'(by decide))
    have := madd52hi_lt48 dx3 bx5
    have := madd52lo_lt ($x[4]'(by decide)) ($x[4]'(by decide))
    have := madd52hi_lt47 bx4 bx4
    have := madd52lo_lt (($x[4]'(by decide)) <<< 1) ($x[5]'(by decide))
    have := madd52hi_lt48 dx4 bx5
    have := madd52lo_lt ($x[5]'(by decide)) ($x[5]'(by decide))
    have := madd52hi_lt47 bx5 bx5
    skip))

/-- A lane of `fd_r43x6_sqr_fast` as its columns: the lane operations, `toNat` with no
overflow, then `ring`. -/
local macro "sqr_lane" hx7:ident : tactic =>
  `(tactic| (
    unfold fd_r43x6_sqr_fast.spec fd_r43x6_sqr_fast.reduce fd_r43x6_sqr_fast.sums fold152
    iterate 3
      try simp only [wwl_add_get, wwl_and_get, wwl_andnot_get, wwl_shl_get, wwl_madd52lo_get,
        wwl_madd52hi_get, wwl_slide_get, wwl_permute_get, wwl_shl_vector_get, wwl_get0, wwl_get1,
        wwl_get2, wwl_get3, wwl_get4, wwl_get5, wwl_get6, wwl_get7, wwl_zero_get, getD_get,
        Vector.getElem_replicate, BitVec.reduceToNat, Nat.reduceMod, Nat.reduceLT, Nat.reduceAdd,
        Nat.reduceSub, ite_true, ite_false, Vector.getElem_mk, List.getElem_toArray,
        List.getElem_cons_zero, List.getElem_cons_succ, sqrMask1, sqrMask2]
    simp only [$hx7:ident, BitVec.shiftLeft_zero, BitVec.zero_shiftLeft, not_neg_one_and,
      not_zero_and, neg_one_and, zero_and, madd52lo_zero, madd52hi_zero, madd52lo_zero',
      madd52hi_zero', madd52lo_zero_left, madd52hi_zero_left]
    simp only [scol, lsqr, hsqr, getElem!_pos, Nat.reduceLT, Nat.reduceAdd, Nat.reduceEqDiff,
      ite_true, ite_false, BitVec.zero_add, BitVec.add_zero, BitVec.toNat_add,
      BitVec.toNat_shiftLeft, BitVec.toNat_and, Nat.shiftLeft_eq, BitVec.reduceToNat,
      BitVec.toNat_zero, Nat.reducePow, Nat.reduceMod, Nat.zero_add, Nat.add_zero, toNat_neg_one,
      and_m64, Nat.and_zero, Nat.zero_mod, Nat.zero_mul]
    simp (disch := omega) only [Nat.mod_eq_of_lt, Nat.mod_mod]
    ring))

theorem sqr_fast_lane0 {x : Wwl} (hx : Unreduced x) :
    (fd_r43x6_sqr_fast.spec x)[0].toNat =
      scol (lsqr x) (hsqr x) 0 + 152 * scol (lsqr x) (hsqr x) 6 := by
  obtain ⟨hx, hx6, hx7⟩ := hx
  sqr_bounds x hx
  sqr_lane hx7

theorem sqr_fast_lane1 {x : Wwl} (hx : Unreduced x) :
    (fd_r43x6_sqr_fast.spec x)[1].toNat =
      scol (lsqr x) (hsqr x) 1 + 152 * scol (lsqr x) (hsqr x) 7 := by
  obtain ⟨hx, hx6, hx7⟩ := hx
  sqr_bounds x hx
  sqr_lane hx7

theorem sqr_fast_lane2 {x : Wwl} (hx : Unreduced x) :
    (fd_r43x6_sqr_fast.spec x)[2].toNat =
      scol (lsqr x) (hsqr x) 2 + 152 * scol (lsqr x) (hsqr x) 8 := by
  obtain ⟨hx, hx6, hx7⟩ := hx
  sqr_bounds x hx
  sqr_lane hx7

theorem sqr_fast_lane3 {x : Wwl} (hx : Unreduced x) :
    (fd_r43x6_sqr_fast.spec x)[3].toNat =
      scol (lsqr x) (hsqr x) 3 + 152 * scol (lsqr x) (hsqr x) 9 := by
  obtain ⟨hx, hx6, hx7⟩ := hx
  sqr_bounds x hx
  sqr_lane hx7

theorem sqr_fast_lane4 {x : Wwl} (hx : Unreduced x) :
    (fd_r43x6_sqr_fast.spec x)[4].toNat =
      scol (lsqr x) (hsqr x) 4 + 152 * scol (lsqr x) (hsqr x) 10 := by
  obtain ⟨hx, hx6, hx7⟩ := hx
  sqr_bounds x hx
  sqr_lane hx7

theorem sqr_fast_lane5 {x : Wwl} (hx : Unreduced x) :
    (fd_r43x6_sqr_fast.spec x)[5].toNat =
      scol (lsqr x) (hsqr x) 5 + 152 * scol (lsqr x) (hsqr x) 11 := by
  obtain ⟨hx, hx6, hx7⟩ := hx
  sqr_bounds x hx
  sqr_lane hx7

theorem sqr_fast_lane67 {x : Wwl} (hx : Unreduced x) :
    (fd_r43x6_sqr_fast.spec x)[6] = 0 ∧ (fd_r43x6_sqr_fast.spec x)[7] = 0 := by
  obtain ⟨-, hx6, hx7⟩ := hx
  unfold fd_r43x6_sqr_fast.spec fd_r43x6_sqr_fast.reduce fd_r43x6_sqr_fast.sums fold152
  constructor <;>
  · iterate 3
      try simp only [wwl_add_get, wwl_and_get, wwl_andnot_get, wwl_shl_get, wwl_madd52lo_get,
        wwl_madd52hi_get, wwl_slide_get, wwl_permute_get, wwl_shl_vector_get, wwl_get0, wwl_get1,
        wwl_get2, wwl_get3, wwl_get4, wwl_get5, wwl_get6, wwl_get7, wwl_zero_get, getD_get,
        Vector.getElem_replicate, BitVec.reduceToNat, Nat.reduceMod, Nat.reduceLT, Nat.reduceAdd,
        Nat.reduceSub, ite_true, ite_false, Vector.getElem_mk, List.getElem_toArray,
        List.getElem_cons_zero, List.getElem_cons_succ, sqrMask1, sqrMask2]
    simp [hx7, not_neg_one_and, not_zero_and, neg_one_and, zero_and, madd52lo_zero,
      madd52hi_zero, madd52lo_zero', madd52hi_zero', madd52lo_zero_left, madd52hi_zero_left]

/-- `fd_r43x6_sqr_fast` squares unreduced limbs into `u63` limbs with lanes 6 and 7 zero. -/
public theorem fd_r43x6_sqr_fast_spec {x : Wwl} (hx : Unreduced x) :
    val (fd_r43x6_sqr_fast.spec x) = val x ^ 2 ∧ Unsigned 63 (fd_r43x6_sqr_fast.spec x) ∧
      HighZero (fd_r43x6_sqr_fast.spec x) := by
  have hL : ∀ i j, i ≤ j → j < 6 → lsqr x i j < 2 ^ 52 := fun i j _ _ => by
    unfold lsqr; split <;> exact madd52lo_lt _ _
  have hH : ∀ i j, i ≤ j → j < 6 → hsqr x i j < 2 ^ 43 := fun i j _ hj => by
    unfold hsqr
    split
    · exact (madd52hi_lt47 (hx.1.get! (by omega)) (hx.1.get! hj)).trans (by norm_num)
    · exact madd52hi_lt48 (shl1_lt (hx.1.get! (by omega))) (hx.1.get! hj)
  have hc := scol_lt hL hH
  have e0 := sqr_fast_lane0 hx
  have e1 := sqr_fast_lane1 hx
  have e2 := sqr_fast_lane2 hx
  have e3 := sqr_fast_lane3 hx
  have e4 := sqr_fast_lane4 hx
  have e5 := sqr_fast_lane5 hx
  have z63 : Unsigned 63 (fd_r43x6_sqr_fast.spec x) := by
    have := hc 0 (by norm_num); have := hc 1 (by norm_num); have := hc 2 (by norm_num)
    have := hc 3 (by norm_num); have := hc 4 (by norm_num); have := hc 5 (by norm_num)
    intro i; fin_cases i <;> simp only [Fin.isValue, Fin.val_zero, Fin.val_one, Fin.val_two,
      Fin.coe_ofNat_eq_mod, Nat.reduceMod, e0, e1, e2, e3, e4, e5] <;> omega
  refine ⟨?_, z63, sqr_fast_lane67 hx⟩
  rw [val_of_scol (L := lsqr x) (H := hsqr x) (X := fun k => x[k]!.toNat)
      (by simp only [nat, limbs6, e0, e1, e2, e3, e4, e5]) z63
      (fun i hi => by
        simp only [lsqr, hsqr, ↓reduceIte]
        exact madd52_split ((hx.1.get! hi).trans (by norm_num))
          ((hx.1.get! hi).trans (by norm_num)))
      (fun i j hij hj => by
        have bi := hx.1.get! (show i < 6 by omega)
        simp only [lsqr, hsqr, show i ≠ j by omega, ↓reduceIte]
        rw [← madd52_split ((shl1_lt bi).trans (by norm_num))
          ((hx.1.get! hj).trans (by norm_num)), shl1_toNat (by omega)]),
    val_eq_nat (hx.1.mono (by norm_num)), nat_eq_limbs6]

/-- `fd_r43x6_sqr` squares unreduced limbs into folded ones. -/
public theorem fd_r43x6_sqr_spec {x : Wwl} (hx : Unreduced x) :
    val (fd_r43x6_sqr x) = val x ^ 2 ∧ Folded (fd_r43x6_sqr x) := by
  obtain ⟨v, h63, -⟩ := fd_r43x6_sqr_fast_spec hx
  obtain ⟨v', f⟩ := fold_spec h63
  exact ⟨by rw [fd_r43x6_sqr, v', v], f⟩

end R43x6


end LeanMLIR.RIR.Firedancer.Avx512
