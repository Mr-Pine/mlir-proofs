module

public import Mathlib.Algebra.BigOperators.Fin
public import Mathlib.Data.ZMod.Basic
public import Firedancer.Ref.fd_f25519_add
public import Firedancer.Ref.fd_f25519_add_nr
public import Firedancer.Ref.fd_f25519_mul
public import Firedancer.Ref.fd_f25519_neg
public import Firedancer.Ref.fd_f25519_pow22523
public import Firedancer.Ref.fd_f25519_sqr
public import Firedancer.Ref.fd_f25519_sub
public import Firedancer.Ref.fd_f25519_sub_nr
public import Firedancer.Ref.fd_f25519_tobytes
public import Firedancer.Ref.fd_f25519_eq
public import Firedancer.Ref.fd_f25519_sgn
public import Firedancer.Ref.fd_f25519_frombytes
import Mathlib.NumberTheory.LucasPrimality
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.NormNum.Prime
import Mathlib.Tactic.ReduceModChar
import Std.Tactic.BVDecide

/-! The Ref field arithmetic in `ZMod p`, `p = 2^255 - 19`: each spec computes its field operation
on the limbs' values, under fiat-crypto's tight and loose limb bounds. -/

namespace MLIR.Firedancer.Ref

/-! ## Definitions -/

@[expose] public section

/-- The field's prime. -/
abbrev p : ℕ :=
  2 ^ 255 - 19

/-- A field element's value: limb `i` weighs `2^(51 i)`. -/
def Limbs.val (l : Fin 5 → BitVec 64) : ZMod p :=
  ∑ i : Fin 5, ((l i).toNat : ZMod p) * 2 ^ (51 * (i : ℕ))

/-- fiat-crypto's tight bounds: every limb at most `2^51`. -/
abbrev Limbs.Tight (l : Fin 5 → BitVec 64) : Prop :=
  ∀ i, (l i).toNat ≤ 0x8000000000000

/-- fiat-crypto's loose bounds: every limb at most `3 · 2^51`. -/
abbrev Limbs.Loose (l : Fin 5 → BitVec 64) : Prop :=
  ∀ i, (l i).toNat ≤ 0x18000000000000

/-- The limbs' natural number, before reduction mod `p`. -/
def Limbs.nat (l : Fin 5 → BitVec 64) : ℕ :=
  (l 0).toNat + (l 1).toNat * 2 ^ 51 + (l 2).toNat * 2 ^ 102 + (l 3).toNat * 2 ^ 153 +
    (l 4).toNat * 2 ^ 204

/-- Limbs at most `2p`'s, `2^52 - 38` and `2^52 - 2`: what `fiat_25519_sub` may subtract. -/
abbrev Limbs.Under2p (l : Fin 5 → BitVec 64) : Prop :=
  ∀ i, (l i).toNat ≤ if i = 0 then 4503599627370458 else 4503599627370494

end

/-! ## Proof macros -/

/-- `Nat.Prime n` by `prime_of_pratt a fs`; `norm_num` proves the factors prime except `hs`'s. -/
local macro "pratt " a:term:max fs:term:max " [" hs:term,* "]" : tactic =>
  `(tactic| (
    refine $(Lean.mkIdent `prime_of_pratt) $a $fs ?_ ?_ ?_ ?_
    · norm_num
    · simp only [List.forall_mem_cons, List.not_mem_nil, IsEmpty.forall_iff, implies_true,
        and_true, true_and, $[$hs:term],*]
      norm_num
    · reduce_mod_char
    · simp only [List.forall_mem_cons, List.not_mem_nil, IsEmpty.forall_iff, implies_true,
        and_true]
      repeat' apply And.intro
      all_goals reduce_mod_char; decide))

/-! ## Basic facts -/

section Basic

public theorem Limbs.val_eq (l : Fin 5 → BitVec 64) :
    Limbs.val l =
      (l 0).toNat + (l 1).toNat * 2 ^ 51 + (l 2).toNat * 2 ^ 102 + (l 3).toNat * 2 ^ 153 +
        (l 4).toNat * 2 ^ 204 := by
  simp [Limbs.val, Fin.sum_univ_five]

public theorem Limbs.tight_iff (l : Fin 5 → BitVec 64) :
    Limbs.Tight l ↔
      (l 0).toNat ≤ 0x8000000000000 ∧
        (l 1).toNat ≤ 0x8000000000000 ∧
        (l 2).toNat ≤ 0x8000000000000 ∧
        (l 3).toNat ≤ 0x8000000000000 ∧ (l 4).toNat ≤ 0x8000000000000 := by
  refine ⟨fun h => ⟨h 0, h 1, h 2, h 3, h 4⟩, fun h i => ?_⟩
  fin_cases i <;> simp [h]

public theorem Limbs.loose_iff (l : Fin 5 → BitVec 64) :
    Limbs.Loose l ↔
      (l 0).toNat ≤ 0x18000000000000 ∧
        (l 1).toNat ≤ 0x18000000000000 ∧
        (l 2).toNat ≤ 0x18000000000000 ∧
        (l 3).toNat ≤ 0x18000000000000 ∧ (l 4).toNat ≤ 0x18000000000000 := by
  refine ⟨fun h => ⟨h 0, h 1, h 2, h 3, h 4⟩, fun h i => ?_⟩
  fin_cases i <;> simp [h]

public theorem Limbs.Tight.loose {l : Fin 5 → BitVec 64} (h : Limbs.Tight l) : Limbs.Loose l :=
  fun i => (h i).trans (by decide)

public theorem Limbs.Tight.under2p {l : Fin 5 → BitVec 64} (h : Limbs.Tight l) : Limbs.Under2p l :=
  fun i => (h i).trans (by split <;> decide)

public theorem Limbs.val_nat (l : Fin 5 → BitVec 64) : Limbs.val l = (Limbs.nat l : ZMod p) := by
  rw [Limbs.val_eq, Limbs.nat]
  push_cast
  rfl

public theorem Limbs.Tight.nat_lt {l : Fin 5 → BitVec 64} (h : Limbs.Tight l) :
    Limbs.nat l < 2 * p := by
  rw [Limbs.tight_iff] at h
  unfold Limbs.nat
  change _ < 2 * (2 ^ 255 - 19)
  omega

/-- The bounds `Under2p` gives each limb. -/
theorem Limbs.Under2p.bounds {l : Fin 5 → BitVec 64} (h : Limbs.Under2p l) :
    (l 0).toNat ≤ 4503599627370458 ∧ (l 1).toNat ≤ 4503599627370494 ∧
      (l 2).toNat ≤ 4503599627370494 ∧ (l 3).toNat ≤ 4503599627370494 ∧
        (l 4).toNat ≤ 4503599627370494 :=
  ⟨by simpa using h 0, by simpa using h 1, by simpa using h 2, by simpa using h 3,
    by simpa using h 4⟩

public theorem two_pow_255 : (2 : ZMod p) ^ 255 = 19 := by
  have h : 2 ^ 255 = p + 19 := by norm_num
  rw [show (2 : ZMod p) ^ 255 = ((2 ^ 255 : ℕ) : ZMod p) by
      push_cast; rfl,
    h, Nat.cast_add, ZMod.natCast_self, zero_add]
  rfl

end Basic

/-! ## `p` is prime -/

section Prime

/-- Lucas's test, `p - 1 = ∏ q ^ k` over the pairs `(q, k)` of `fs`, `a` the witness. -/
theorem prime_of_pratt {p : ℕ} (a : ℕ) (fs : List (ℕ × ℕ))
    (hfs : (fs.map fun f => f.1 ^ f.2).prod = p - 1) (hprime : ∀ f ∈ fs, f.1.Prime)
    (ha : (a : ZMod p) ^ (p - 1) = 1) (hd : ∀ f ∈ fs, (a : ZMod p) ^ ((p - 1) / f.1) ≠ 1) :
    p.Prime := by
  refine lucas_primality p a ha fun q hq hdvd => ?_
  rw [← hfs] at hdvd
  obtain ⟨_, hm, hqf⟩ := (Prime.dvd_prod_iff hq.prime).1 hdvd
  obtain ⟨f, hf, rfl⟩ := List.mem_map.1 hm
  rw [(Nat.prime_dvd_prime_iff_eq hq (hprime f hf)).1 (hq.dvd_of_dvd_pow hqf)]
  exact hd f hf

theorem prime_1923133 : Nat.Prime 1923133 := by
  pratt 2 [(2, 2), (3, 1), (43, 1), (3727, 1)] []

theorem prime_31757755568855353 : Nat.Prime 31757755568855353 := by
  pratt 10 [(2, 3), (3, 1), (31, 1), (107, 1), (223, 1), (4153, 1), (430751, 1)] []

theorem prime_2773320623 : Nat.Prime 2773320623 := by
  pratt 5 [(2, 1), (2437, 1), (569003, 1)] []

theorem prime_72106336199 : Nat.Prime 72106336199 := by
  pratt 7 [(2, 1), (13, 1), (2773320623, 1)] [prime_2773320623]

theorem prime_8574133 : Nat.Prime 8574133 := by
  pratt 2 [(2, 2), (3, 1), (7, 1), (103, 1), (991, 1)] []

theorem prime_1919519569386763 : Nat.Prime 1919519569386763 := by
  pratt 2 [(2, 1), (3, 1), (7, 1), (19, 1), (47, 2), (127, 1), (8574133, 1)] [prime_8574133]

theorem prime_75445702479781427272750846543864801 :
    Nat.Prime 75445702479781427272750846543864801 := by
  pratt 7
    [(2, 5), (3, 2), (5, 2), (75707, 1), (72106336199, 1), (1919519569386763, 1)]
    [prime_72106336199, prime_1919519569386763]

theorem prime_74058212732561358302231226437062788676166966415465897661863160754340907 :
    Nat.Prime 74058212732561358302231226437062788676166966415465897661863160754340907 := by
  pratt 2
    [(2, 1), (3, 1), (353, 1), (57467, 1), (132049, 1), (1923133, 1), (31757755568855353, 1),
      (75445702479781427272750846543864801, 1)]
    [prime_1923133, prime_31757755568855353, prime_75445702479781427272750846543864801]

theorem prime_p : p.Prime := by
  pratt 2
    [(2, 2), (3, 1), (65147, 1),
      (74058212732561358302231226437062788676166966415465897661863160754340907, 1)]
    [prime_74058212732561358302231226437062788676166966415465897661863160754340907]

public instance fact_prime_p : Fact p.Prime :=
  ⟨prime_p⟩

end Prime

/-! ## Limb arithmetic -/

section Arith

theorem toNat_and_mask (x : BitVec 64) : (x &&& 2251799813685247#64).toNat = x.toNat % 2 ^ 51 := by
  rw [BitVec.toNat_and, ← Nat.and_two_pow_sub_one_eq_mod]
  rfl

theorem toNat_shift (x : BitVec 64) : (x >>> 51).toNat = x.toNat / 2 ^ 51 := by
  rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]

theorem toNat_shift_lo (x : BitVec 128) :
    (x >>> 51 &&& 18446744073709551615#128).toNat = x.toNat / 2 ^ 51 % 2 ^ 64 := by
  rw [BitVec.toNat_and, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow, ←
    Nat.and_two_pow_sub_one_eq_mod]
  rfl

theorem toNat_setWidth_mask (x : BitVec 128) :
    (x.setWidth 64 &&& 2251799813685247#64).toNat = x.toNat % 2 ^ 51 := by
  rw [toNat_and_mask, BitVec.toNat_setWidth, Nat.mod_mod_of_dvd _ (by decide)]

theorem toNat_shift_setWidth (x : BitVec 128) :
    ((x >>> 51).setWidth 64).toNat = x.toNat / 2 ^ 51 % 2 ^ 64 := by
  rw [BitVec.toNat_setWidth, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]

/-- fiat's carries after a product's 128-bit column sums: each column carried into the next at
bit 51, the top carry times 19 into limb 0, then carries out of limbs 0 and 1. -/
def carryCols (c0 c1 c2 c3 c4 : BitVec 128) : Fin 5 → BitVec 64 :=
  let mask := 2251799813685247#64 -- `2^51 - 1`
  let lo := 18446744073709551615#128 -- `2^64 - 1`
  let r1 := c1 + (c0 >>> 51 &&& lo)
  let r2 := c2 + (r1 >>> 51 &&& lo)
  let r3 := c3 + (r2 >>> 51 &&& lo)
  let r4 := c4 + (r3 >>> 51 &&& lo)
  let u0 := (r4 >>> 51).setWidth 64 * 19 + (c0.setWidth 64 &&& mask)
  let u1 := (u0 >>> 51) + (r1.setWidth 64 &&& mask)
  fun
  | ⟨0, _⟩ => u0 &&& mask
  | ⟨1, _⟩ => u1 &&& mask
  | ⟨2, _⟩ => (u1 >>> 51) + (r2.setWidth 64 &&& mask)
  | ⟨3, _⟩ => r3.setWidth 64 &&& mask
  | ⟨4, _⟩ => r4.setWidth 64 &&& mask

/-- The carries' value identity in `ℕ`, cast to `ZMod p`. -/
theorem carry_val {C0 C1 C2 C3 C4 t1 t2 t3 t4 u0 u1 : ℕ} (ht1 : t1 = C1 + C0 / 2 ^ 51)
    (ht2 : t2 = C2 + t1 / 2 ^ 51) (ht3 : t3 = C3 + t2 / 2 ^ 51) (ht4 : t4 = C4 + t3 / 2 ^ 51)
    (hu0 : u0 = t4 / 2 ^ 51 * 19 + C0 % 2 ^ 51) (hu1 : u1 = u0 / 2 ^ 51 + t1 % 2 ^ 51) :
    ((u0 % 2 ^ 51 : ℕ) : ZMod p) + (u1 % 2 ^ 51 : ℕ) * 2 ^ 51 +
        (u1 / 2 ^ 51 + t2 % 2 ^ 51 : ℕ) * 2 ^ 102 +
        (t3 % 2 ^ 51 : ℕ) * 2 ^ 153 +
        (t4 % 2 ^ 51 : ℕ) * 2 ^ 204 =
      C0 + C1 * 2 ^ 51 + C2 * 2 ^ 102 + C3 * 2 ^ 153 + C4 * 2 ^ 204 := by
  have e (x : ℕ) : ((x % 2 ^ 51 : ℕ) : ZMod p) + 2 ^ 51 * (x / 2 ^ 51 : ℕ) = x := by
    exact_mod_cast congrArg (Nat.cast (R := ZMod p)) (Nat.mod_add_div x (2 ^ 51))
  have T1 := congrArg (Nat.cast (R := ZMod p)) ht1
  have T2 := congrArg (Nat.cast (R := ZMod p)) ht2
  have T3 := congrArg (Nat.cast (R := ZMod p)) ht3
  have T4 := congrArg (Nat.cast (R := ZMod p)) ht4
  have U0 := congrArg (Nat.cast (R := ZMod p)) hu0
  have U1 := congrArg (Nat.cast (R := ZMod p)) hu1
  push_cast at T1 T2 T3 T4 U0 U1 ⊢
  linear_combination
    2 ^ 51 * e u1 + 2 ^ 51 * U1 + e u0 + U0 + e C0 + 2 ^ 51 * T1 + 2 ^ 51 * e t1 + 2 ^ 102 * T2 +
        2 ^ 102 * e t2 +
        2 ^ 153 * T3 +
        2 ^ 153 * e t3 +
        2 ^ 204 * T4 +
        2 ^ 204 * e t4 -
      (t4 / 2 ^ 51 : ℕ) * two_pow_255

/-- The carries keep a positive number positive: the top carry folds back as `19`, never `0`. -/
theorem carry_pos {C0 C1 C2 C3 C4 t1 t2 t3 t4 u0 u1 : ℕ} (ht1 : t1 = C1 + C0 / 2 ^ 51)
    (ht2 : t2 = C2 + t1 / 2 ^ 51) (ht3 : t3 = C3 + t2 / 2 ^ 51) (ht4 : t4 = C4 + t3 / 2 ^ 51)
    (hu0 : u0 = t4 / 2 ^ 51 * 19 + C0 % 2 ^ 51) (hu1 : u1 = u0 / 2 ^ 51 + t1 % 2 ^ 51)
    (hC : 0 < C0 + C1 * 2 ^ 51 + C2 * 2 ^ 102 + C3 * 2 ^ 153 + C4 * 2 ^ 204) :
    0 < u0 % 2 ^ 51 + u1 % 2 ^ 51 * 2 ^ 51 + (u1 / 2 ^ 51 + t2 % 2 ^ 51) * 2 ^ 102 +
      t3 % 2 ^ 51 * 2 ^ 153 + t4 % 2 ^ 51 * 2 ^ 204 := by
  omega

/-- `carryCols` computes the columns' value, carried to tight limbs, positive if the columns'
number is. -/
theorem carryCols_spec {c0 c1 c2 c3 c4 : BitVec 128} (h0 : c0.toNat ≤ 2 ^ 114)
    (h1 : c1.toNat ≤ 2 ^ 114) (h2 : c2.toNat ≤ 2 ^ 114) (h3 : c3.toNat ≤ 2 ^ 114)
    (h4 : c4.toNat ≤ 2 ^ 109) :
    (Limbs.val (carryCols c0 c1 c2 c3 c4) =
        c0.toNat + c1.toNat * 2 ^ 51 + c2.toNat * 2 ^ 102 + c3.toNat * 2 ^ 153 +
          c4.toNat * 2 ^ 204 ∧
      Limbs.Tight (carryCols c0 c1 c2 c3 c4)) ∧
      (0 < c0.toNat + c1.toNat * 2 ^ 51 + c2.toNat * 2 ^ 102 + c3.toNat * 2 ^ 153 +
          c4.toNat * 2 ^ 204 → 0 < Limbs.nat (carryCols c0 c1 c2 c3 c4)) := by
  rw [Limbs.val_eq, Limbs.tight_iff, Limbs.nat]
  dsimp only [carryCols]
  generalize hr1 : c1 + (c0 >>> 51 &&& 18446744073709551615#128) = r1
  generalize hr2 : c2 + (r1 >>> 51 &&& 18446744073709551615#128) = r2
  generalize hr3 : c3 + (r2 >>> 51 &&& 18446744073709551615#128) = r3
  generalize hr4 : c4 + (r3 >>> 51 &&& 18446744073709551615#128) = r4
  generalize hu0 : (r4 >>> 51).setWidth 64 * 19 + (c0.setWidth 64 &&& 2251799813685247#64) = u0
  generalize hu1 : u0 >>> 51 + (r1.setWidth 64 &&& 2251799813685247#64) = u1
  have k1 : r1.toNat = c1.toNat + c0.toNat / 2 ^ 51 := by
    rw [← hr1, BitVec.toNat_add, toNat_shift_lo]; omega
  have k2 : r2.toNat = c2.toNat + r1.toNat / 2 ^ 51 := by
    rw [← hr2, BitVec.toNat_add, toNat_shift_lo]; omega
  have k3 : r3.toNat = c3.toNat + r2.toNat / 2 ^ 51 := by
    rw [← hr3, BitVec.toNat_add, toNat_shift_lo]; omega
  have k4 : r4.toNat = c4.toNat + r3.toNat / 2 ^ 51 := by
    rw [← hr4, BitVec.toNat_add, toNat_shift_lo]; omega
  have ku0 : u0.toNat = r4.toNat / 2 ^ 51 * 19 + c0.toNat % 2 ^ 51 := by
    rw [← hu0, BitVec.toNat_add, BitVec.toNat_mul, toNat_shift_setWidth, toNat_setWidth_mask,
      show (19 : BitVec 64).toNat = 19 from rfl]
    omega
  have ku1 : u1.toNat = u0.toNat / 2 ^ 51 + r1.toNat % 2 ^ 51 := by
    rw [← hu1, BitVec.toNat_add, toNat_shift, toNat_setWidth_mask]; omega
  have ko2 :
    (u1 >>> 51 + (r2.setWidth 64 &&& 2251799813685247#64)).toNat =
      u1.toNat / 2 ^ 51 + r2.toNat % 2 ^ 51 := by
    rw [BitVec.toNat_add, toNat_shift, toNat_setWidth_mask]; omega
  -- `toNat_and_mask` also matches the narrowed limbs: rewrite them first
  simp only [toNat_setWidth_mask]
  simp only [toNat_and_mask, ko2]
  refine ⟨⟨carry_val k1 k2 k3 k4 ku0 ku1, ?_, ?_, ?_, ?_, ?_⟩, carry_pos k1 k2 k3 k4 ku0 ku1⟩ <;>
    omega

/-- `x` holds `n`, at most `M`. -/
def ValLe (x : BitVec w) (n M : ℕ) : Prop :=
  x.toNat = n ∧ n ≤ M

theorem ValLe.const (c : BitVec w) : ValLe c c.toNat c.toNat :=
  ⟨rfl, le_rfl⟩

theorem ValLe.add {x y : BitVec w} (hx : ValLe x m M) (hy : ValLe y n N) (h : M + N < 2 ^ w) :
    ValLe (x + y) (m + n) (M + N) := by
  obtain ⟨rfl, hm⟩ := hx
  obtain ⟨rfl, hn⟩ := hy
  exact ⟨by rw [BitVec.toNat_add, Nat.mod_eq_of_lt (by omega)], by omega⟩

theorem ValLe.mul {x y : BitVec w} (hx : ValLe x m M) (hy : ValLe y n N) (h : M * N < 2 ^ w) :
    ValLe (x * y) (m * n) (M * N) := by
  obtain ⟨rfl, hm⟩ := hx
  obtain ⟨rfl, hn⟩ := hy
  have := Nat.mul_le_mul hm hn
  exact ⟨by rw [BitVec.toNat_mul, Nat.mod_eq_of_lt (by omega)], this⟩

theorem ValLe.setWidth {x : BitVec w} (hx : ValLe x n M) (h : M < 2 ^ v) :
    ValLe (x.setWidth v) n M := by
  obtain ⟨rfl, hn⟩ := hx
  exact ⟨by rw [BitVec.toNat_setWidth, Nat.mod_eq_of_lt (by omega)], hn⟩

theorem ValLe.shl {x : BitVec w} (hx : ValLe x n M) (h : M * 2 ^ k < 2 ^ w) :
    ValLe (x <<< k) (n * 2 ^ k) (M * 2 ^ k) := by
  obtain ⟨rfl, hn⟩ := hx
  have := Nat.mul_le_mul_right (2 ^ k) hn
  exact ⟨by rw [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq, Nat.mod_eq_of_lt (by omega)], this⟩

/-- `carryCols_spec` over column sums known through `ValLe`; `Q` makes their number positive. -/
theorem carryCols_valLe {Q : Prop} {c0 c1 c2 c3 c4 : BitVec 128} (h0 : ValLe c0 n0 M0)
    (h1 : ValLe c1 n1 M1) (h2 : ValLe c2 n2 M2) (h3 : ValLe c3 n3 M3) (h4 : ValLe c4 n4 M4)
    (hM : M0 ≤ 2 ^ 114 ∧ M1 ≤ 2 ^ 114 ∧ M2 ≤ 2 ^ 114 ∧ M3 ≤ 2 ^ 114 ∧ M4 ≤ 2 ^ 109)
    (hv : (n0 : ZMod p) + n1 * 2 ^ 51 + n2 * 2 ^ 102 + n3 * 2 ^ 153 + n4 * 2 ^ 204 = v)
    (hQ : Q → 0 < n0 + n1 * 2 ^ 51 + n2 * 2 ^ 102 + n3 * 2 ^ 153 + n4 * 2 ^ 204) :
    (Limbs.val (carryCols c0 c1 c2 c3 c4) = v ∧ Limbs.Tight (carryCols c0 c1 c2 c3 c4)) ∧
      (Q → 0 < Limbs.nat (carryCols c0 c1 c2 c3 c4)) := by
  obtain ⟨rfl, h0⟩ := h0
  obtain ⟨rfl, h1⟩ := h1
  obtain ⟨rfl, h2⟩ := h2
  obtain ⟨rfl, h3⟩ := h3
  obtain ⟨rfl, h4⟩ := h4
  obtain ⟨⟨hv', ht⟩, hp⟩ :=
    carryCols_spec (c0 := c0) (c1 := c1) (c2 := c2) (c3 := c3) (c4 := c4) (by omega) (by omega)
      (by omega) (by omega) (by omega)
  exact ⟨⟨hv'.trans hv, ht⟩, hp ∘ hQ⟩

/-- The 128-bit product of two 64-bit values. -/
abbrev mulW (x y : BitVec 64) : BitVec 128 :=
  x.setWidth 128 * y.setWidth 128

/-- A limb of `x + 2p - y`: no wrap for tight `x`, `y`, and the result is loose. -/
theorem sub_limb {s x y : BitVec 64} (c : ℕ) (hs : s = x + BitVec.ofNat 64 c - y)
    (hx : x.toNat ≤ 0x8000000000000) (hy : y.toNat ≤ c) (hc : c ≤ 0x10000000000000) :
    s.toNat + y.toNat = x.toNat + c ∧ s.toNat ≤ 0x18000000000000 := by
  rw [hs, BitVec.toNat_sub, BitVec.toNat_add, BitVec.toNat_ofNat]
  omega

/-- A limb of `2p - x`: no wrap for `x` at most `2p`'s limb, and the result is loose. -/
theorem opp_limb {s x : BitVec 64} (c : ℕ) (hs : s = BitVec.ofNat 64 c - x)
    (hx : x.toNat ≤ c) (hc : c ≤ 0x10000000000000) :
    s.toNat + x.toNat = c ∧ s.toNat ≤ 0x18000000000000 := by
  rw [hs, BitVec.toNat_sub, BitVec.toNat_ofNat]
  omega

end Arith

/-! ## fiat-crypto -/

section Fiat

/-- `fiat_25519_carry_mul.spec` is `carryCols` of the product's column sums. -/
theorem fiat_25519_carry_mul.spec_eq (a b : Fin 5 → BitVec 64) :
    fiat_25519_carry_mul.spec a b =
      carryCols
        (mulW (a 3) (b 2 * 19) + mulW (b 1 * 19) (a 4) + mulW (a 2) (b 3 * 19) +
          mulW (a 1) (b 4 * 19) +
          mulW (a 0) (b 0))
        (mulW (a 3) (b 3 * 19) + mulW (b 2 * 19) (a 4) + mulW (a 2) (b 4 * 19) + mulW (b 0) (a 1) +
          mulW (a 0) (b 1))
        (mulW (a 3) (b 4 * 19) + mulW (b 3 * 19) (a 4) + mulW (a 1) (b 1) + mulW (b 0) (a 2) +
          mulW (a 0) (b 2))
        (mulW (a 2) (b 1) + mulW (b 4 * 19) (a 4) + mulW (a 1) (b 2) + mulW (b 0) (a 3) +
          mulW (a 0) (b 3))
        (mulW (a 2) (b 2) + mulW (a 3) (b 1) + mulW (a 1) (b 3) + mulW (b 0) (a 4) +
          mulW (a 0) (b 4)) := by
  funext i
  fin_cases i <;> rfl

/-- `fiat_25519_carry_mul` multiplies loose field elements into a tight one, of a positive number
if both numbers are. -/
theorem fiat_25519_carry_mul.spec_full {a b : Fin 5 → BitVec 64} (ha : Limbs.Loose a)
    (hb : Limbs.Loose b) :
    (Limbs.val (fiat_25519_carry_mul.spec a b) = Limbs.val a * Limbs.val b ∧
      Limbs.Tight (fiat_25519_carry_mul.spec a b)) ∧
      (0 < Limbs.nat a ∧ 0 < Limbs.nat b → 0 < Limbs.nat (fiat_25519_carry_mul.spec a b)) := by
  have hA i : ValLe (a i) (a i).toNat 0x18000000000000 := ⟨rfl, ha i⟩
  have hB i : ValLe (b i) (b i).toNat 0x18000000000000 := ⟨rfl, hb i⟩
  rw [fiat_25519_carry_mul.spec_eq]
  apply carryCols_valLe
  iterate 5
    · apply_rules [ValLe.add, ValLe.mul, ValLe.setWidth, ValLe.const]
      all_goals decide
  · decide
  · rw [Limbs.val_eq, Limbs.val_eq]
    simp only [show (19 : BitVec 64).toNat = 19 from rfl]
    push_cast
    generalize ((a 0).toNat : ZMod p) = a0
    generalize ((a 1).toNat : ZMod p) = a1
    generalize ((a 2).toNat : ZMod p) = a2
    generalize ((a 3).toNat : ZMod p) = a3
    generalize ((a 4).toNat : ZMod p) = a4
    generalize ((b 0).toNat : ZMod p) = b0
    generalize ((b 1).toNat : ZMod p) = b1
    generalize ((b 2).toNat : ZMod p) = b2
    generalize ((b 3).toNat : ZMod p) = b3
    generalize ((b 4).toNat : ZMod p) = b4
    linear_combination
      -(a1 * b4 + a2 * b3 + a3 * b2 + a4 * b1 + (a2 * b4 + a3 * b3 + a4 * b2) * 2 ^ 51 +
            (a3 * b4 + a4 * b3) * 2 ^ 102 +
            a4 * b4 * 2 ^ 153) *
        two_pow_255
  · -- every product `a i * b j` is in some column
    rintro ⟨pa, pb⟩
    simp only [Limbs.nat, show (19 : BitVec 64).toNat = 19 from rfl] at pa pb ⊢
    generalize (a 0).toNat = a0 at *
    generalize (a 1).toNat = a1 at *
    generalize (a 2).toNat = a2 at *
    generalize (a 3).toNat = a3 at *
    generalize (a 4).toNat = a4 at *
    generalize (b 0).toNat = b0 at *
    generalize (b 1).toNat = b1 at *
    generalize (b 2).toNat = b2 at *
    generalize (b 3).toNat = b3 at *
    generalize (b 4).toNat = b4 at *
    have := Nat.mul_pos (m := a0 + a1 + a2 + a3 + a4) (n := b0 + b1 + b2 + b3 + b4) (by omega)
      (by omega)
    ring_nf at this ⊢
    refine Nat.lt_of_lt_of_le this ?_
    clear pa pb this
    omega

/-- `fiat_25519_carry_mul` multiplies loose field elements into a tight one. -/
public theorem fiat_25519_carry_mul.spec_val {a b : Fin 5 → BitVec 64} (ha : Limbs.Loose a)
    (hb : Limbs.Loose b) :
    Limbs.val (fiat_25519_carry_mul.spec a b) = Limbs.val a * Limbs.val b ∧
      Limbs.Tight (fiat_25519_carry_mul.spec a b) :=
  (fiat_25519_carry_mul.spec_full ha hb).1

/-- `fiat_25519_carry_square.spec` is `carryCols` of the square's column sums. -/
theorem fiat_25519_carry_square.spec_eq (a : Fin 5 → BitVec 64) :
    fiat_25519_carry_square.spec a =
      carryCols (mulW (a 1) (a 4 * 38) + mulW (a 2) (a 3 * 38) + mulW (a 0) (a 0))
        (mulW (a 2) (a 4 * 38) + mulW (a 3 * 19) (a 3) + mulW (a 0) (a 1 <<< 1))
        (mulW (a 1) (a 1) + mulW (a 3) (a 4 * 38) + mulW (a 0) (a 2 <<< 1))
        (mulW (a 1) (a 2 <<< 1) + mulW (a 4 * 19) (a 4) + mulW (a 0) (a 3 <<< 1))
        (mulW (a 1) (a 3 <<< 1) + mulW (a 2) (a 2) + mulW (a 0) (a 4 <<< 1)) := by
  funext i
  fin_cases i <;> rfl

/-- `fiat_25519_carry_square` squares a loose field element into a tight one, of a positive
number if the input's is. -/
theorem fiat_25519_carry_square.spec_full {a : Fin 5 → BitVec 64} (ha : Limbs.Loose a) :
    (Limbs.val (fiat_25519_carry_square.spec a) = Limbs.val a ^ 2 ∧
      Limbs.Tight (fiat_25519_carry_square.spec a)) ∧
      (0 < Limbs.nat a → 0 < Limbs.nat (fiat_25519_carry_square.spec a)) := by
  have hA i : ValLe (a i) (a i).toNat 0x18000000000000 := ⟨rfl, ha i⟩
  rw [fiat_25519_carry_square.spec_eq]
  apply carryCols_valLe
  iterate 5
    · apply_rules [ValLe.add, ValLe.mul, ValLe.setWidth, ValLe.shl, ValLe.const]
      all_goals decide
  · decide
  · rw [Limbs.val_eq]
    simp only [show (19 : BitVec 64).toNat = 19 from rfl, show (38 : BitVec 64).toNat = 38 from rfl]
    push_cast
    generalize ((a 0).toNat : ZMod p) = a0
    generalize ((a 1).toNat : ZMod p) = a1
    generalize ((a 2).toNat : ZMod p) = a2
    generalize ((a 3).toNat : ZMod p) = a3
    generalize ((a 4).toNat : ZMod p) = a4
    linear_combination
      -(2 * a1 * a4 + 2 * a2 * a3 + (2 * a2 * a4 + a3 ^ 2) * 2 ^ 51 + 2 * a3 * a4 * 2 ^ 102 +
            a4 ^ 2 * 2 ^ 153) *
        two_pow_255
  · -- every product `a i * a j` is in some column
    intro pa
    simp only [Limbs.nat, show (19 : BitVec 64).toNat = 19 from rfl,
      show (38 : BitVec 64).toNat = 38 from rfl] at pa ⊢
    generalize (a 0).toNat = a0 at *
    generalize (a 1).toNat = a1 at *
    generalize (a 2).toNat = a2 at *
    generalize (a 3).toNat = a3 at *
    generalize (a 4).toNat = a4 at *
    have := Nat.mul_pos (m := a0 + a1 + a2 + a3 + a4) (n := a0 + a1 + a2 + a3 + a4) (by omega)
      (by omega)
    ring_nf at this ⊢
    refine Nat.lt_of_lt_of_le this ?_
    clear pa this
    omega

/-- `fiat_25519_carry_square` squares a loose field element into a tight one. -/
public theorem fiat_25519_carry_square.spec_val {a : Fin 5 → BitVec 64} (ha : Limbs.Loose a) :
    Limbs.val (fiat_25519_carry_square.spec a) = Limbs.val a ^ 2 ∧
      Limbs.Tight (fiat_25519_carry_square.spec a) :=
  (fiat_25519_carry_square.spec_full ha).1

/-- `fiat_25519_carry` keeps a loose field element's value, with tight limbs, and a positive
number positive. -/
theorem fiat_25519_carry.spec_full {l : Fin 5 → BitVec 64} (hl : Limbs.Loose l) :
    (Limbs.val (fiat_25519_carry.spec l) = Limbs.val l ∧ Limbs.Tight (fiat_25519_carry.spec l)) ∧
      (0 < Limbs.nat l → 0 < Limbs.nat (fiat_25519_carry.spec l)) := by
  have h0 := hl 0
  have h1 := hl 1
  have h2 := hl 2
  have h3 := hl 3
  have h4 := hl 4
  rw [Limbs.val_eq, Limbs.val_eq l, Limbs.tight_iff, Limbs.nat, Limbs.nat]
  dsimp only [fiat_25519_carry.spec]
  generalize hx2 : l 0 >>> 51 + l 1 = x2
  generalize hx3 : x2 >>> 51 + l 2 = x3
  generalize hx4 : x3 >>> 51 + l 3 = x4
  generalize hx5 : x4 >>> 51 + l 4 = x5
  generalize hx6 : x5 >>> 51 * 19 + (l 0 &&& 2251799813685247#64) = x6
  generalize hx7 : x6 >>> 51 + (x2 &&& 2251799813685247#64) = x7
  have k2 : x2.toNat = (l 1).toNat + (l 0).toNat / 2 ^ 51 := by
    rw [← hx2, BitVec.toNat_add, toNat_shift]; omega
  have k3 : x3.toNat = (l 2).toNat + x2.toNat / 2 ^ 51 := by
    rw [← hx3, BitVec.toNat_add, toNat_shift]; omega
  have k4 : x4.toNat = (l 3).toNat + x3.toNat / 2 ^ 51 := by
    rw [← hx4, BitVec.toNat_add, toNat_shift]; omega
  have k5 : x5.toNat = (l 4).toNat + x4.toNat / 2 ^ 51 := by
    rw [← hx5, BitVec.toNat_add, toNat_shift]; omega
  have k6 : x6.toNat = x5.toNat / 2 ^ 51 * 19 + (l 0).toNat % 2 ^ 51 := by
    rw [← hx6, BitVec.toNat_add, BitVec.toNat_mul, toNat_shift, toNat_and_mask,
      show (19 : BitVec 64).toNat = 19 from rfl]
    omega
  have k7 : x7.toNat = x6.toNat / 2 ^ 51 + x2.toNat % 2 ^ 51 := by
    rw [← hx7, BitVec.toNat_add, toNat_shift, toNat_and_mask]; omega
  have ko2 :
    (x7 >>> 51 + (x3 &&& 2251799813685247#64)).toNat = x7.toNat / 2 ^ 51 + x3.toNat % 2 ^ 51 := by
    rw [BitVec.toNat_add, toNat_shift, toNat_and_mask]; omega
  simp only [toNat_and_mask, ko2]
  refine ⟨⟨carry_val k2 k3 k4 k5 k6 k7, ?_, ?_, ?_, ?_, ?_⟩, carry_pos k2 k3 k4 k5 k6 k7⟩ <;>
    omega

/-- `fiat_25519_carry` keeps a loose field element's value, with tight limbs. -/
public theorem fiat_25519_carry.spec_val {l : Fin 5 → BitVec 64} (hl : Limbs.Loose l) :
    Limbs.val (fiat_25519_carry.spec l) = Limbs.val l ∧ Limbs.Tight (fiat_25519_carry.spec l) :=
  (fiat_25519_carry.spec_full hl).1

/-- `fiat_25519_add` adds limbwise into a loose field element, when no limb sum exceeds the loose
bound. -/
public theorem fiat_25519_add.spec_le {x y : Fin 5 → BitVec 64}
    (h : ∀ k, (x k).toNat + (y k).toNat ≤ 0x18000000000000) :
    Limbs.val (fiat_25519_add.spec x y) = Limbs.val x + Limbs.val y ∧
      Limbs.Loose (fiat_25519_add.spec x y) := by
  have hk k : (fiat_25519_add.spec x y k).toNat = (y k).toNat + (x k).toNat := by
    have := h k
    rw [fiat_25519_add.spec, BitVec.toNat_add]
    omega
  refine ⟨?_, fun k => ?_⟩
  · rw [Limbs.val, Limbs.val, Limbs.val, ← Finset.sum_add_distrib]
    refine Finset.sum_congr rfl fun k _ => ?_
    rw [hk]
    push_cast
    ring
  · have := h k
    have := hk k
    omega

/-- `fiat_25519_add` adds the limbs' numbers, when no limb sum exceeds the loose bound. -/
theorem fiat_25519_add.spec_nat {x y : Fin 5 → BitVec 64}
    (h : ∀ k, (x k).toNat + (y k).toNat ≤ 0x18000000000000) :
    Limbs.nat (fiat_25519_add.spec x y) = Limbs.nat x + Limbs.nat y := by
  have hk k : (fiat_25519_add.spec x y k).toNat = (y k).toNat + (x k).toNat := by
    have := h k
    rw [fiat_25519_add.spec, BitVec.toNat_add]
    omega
  simp only [Limbs.nat, hk]
  ring

/-- `fiat_25519_add` adds tight field elements into a loose one. -/
public theorem fiat_25519_add.spec_val {x y : Fin 5 → BitVec 64} (hx : Limbs.Tight x)
    (hy : Limbs.Tight y) :
    Limbs.val (fiat_25519_add.spec x y) = Limbs.val x + Limbs.val y ∧
      Limbs.Loose (fiat_25519_add.spec x y) :=
  fiat_25519_add.spec_le fun k => by have := hx k; have := hy k; omega

/-- `fiat_25519_sub` subtracts tight field elements into a loose one: the numbers' `x + 2p - y`. -/
theorem fiat_25519_sub.spec_full {x y : Fin 5 → BitVec 64} (hx : Limbs.Tight x)
    (hy : Limbs.Under2p y) :
    (Limbs.val (fiat_25519_sub.spec x y) = Limbs.val x - Limbs.val y ∧
      Limbs.Loose (fiat_25519_sub.spec x y)) ∧
      Limbs.nat (fiat_25519_sub.spec x y) + Limbs.nat y = Limbs.nat x + 2 * p := by
  obtain ⟨g0, g1, g2, g3, g4⟩ := hy.bounds
  obtain ⟨e0, b0⟩ :=
    sub_limb (s := fiat_25519_sub.spec x y 0) (x := x 0) (y := y 0)
      4503599627370458 rfl (hx 0) g0 (by decide)
  obtain ⟨e1, b1⟩ :=
    sub_limb (s := fiat_25519_sub.spec x y 1) (x := x 1) (y := y 1)
      4503599627370494 rfl (hx 1) g1 (by decide)
  obtain ⟨e2, b2⟩ :=
    sub_limb (s := fiat_25519_sub.spec x y 2) (x := x 2) (y := y 2)
      4503599627370494 rfl (hx 2) g2 (by decide)
  obtain ⟨e3, b3⟩ :=
    sub_limb (s := fiat_25519_sub.spec x y 3) (x := x 3) (y := y 3)
      4503599627370494 rfl (hx 3) g3 (by decide)
  obtain ⟨e4, b4⟩ :=
    sub_limb (s := fiat_25519_sub.spec x y 4) (x := x 4) (y := y 4)
      4503599627370494 rfl (hx 4) g4 (by decide)
  refine ⟨⟨?_, (Limbs.loose_iff _).2 ⟨b0, b1, b2, b3, b4⟩⟩, ?_⟩
  swap
  · unfold Limbs.nat
    change _ = _ + 2 * (2 ^ 255 - 19)
    omega
  rw [Limbs.val_eq, Limbs.val_eq x, Limbs.val_eq y]
  replace e0 := congrArg (Nat.cast (R := ZMod p)) e0
  replace e1 := congrArg (Nat.cast (R := ZMod p)) e1
  replace e2 := congrArg (Nat.cast (R := ZMod p)) e2
  replace e3 := congrArg (Nat.cast (R := ZMod p)) e3
  replace e4 := congrArg (Nat.cast (R := ZMod p)) e4
  push_cast at e0 e1 e2 e3 e4
  linear_combination e0 + 2 ^ 51 * e1 + 2 ^ 102 * e2 + 2 ^ 153 * e3 + 2 ^ 204 * e4 + 2 * two_pow_255

/-- `fiat_25519_sub` subtracts tight field elements into a loose one. -/
public theorem fiat_25519_sub.spec_val {x y : Fin 5 → BitVec 64} (hx : Limbs.Tight x)
    (hy : Limbs.Under2p y) :
    Limbs.val (fiat_25519_sub.spec x y) = Limbs.val x - Limbs.val y ∧
      Limbs.Loose (fiat_25519_sub.spec x y) :=
  (fiat_25519_sub.spec_full hx hy).1

/-- `fiat_25519_opp` negates limbs at most `2p`'s, into such limbs: `2p` minus the number. -/
public theorem fiat_25519_opp.spec_wide {x : Fin 5 → BitVec 64} (hx : Limbs.Under2p x) :
    Limbs.val (fiat_25519_opp.spec x) = -Limbs.val x ∧ Limbs.Under2p (fiat_25519_opp.spec x) ∧
      Limbs.nat (fiat_25519_opp.spec x) + Limbs.nat x = 2 * p := by
  obtain ⟨h0, h1, h2, h3, h4⟩ := hx.bounds
  obtain ⟨e0, -⟩ := opp_limb (s := fiat_25519_opp.spec x 0) (x := x 0) 4503599627370458 rfl h0
    (by decide)
  obtain ⟨e1, -⟩ := opp_limb (s := fiat_25519_opp.spec x 1) (x := x 1) 4503599627370494 rfl h1
    (by decide)
  obtain ⟨e2, -⟩ := opp_limb (s := fiat_25519_opp.spec x 2) (x := x 2) 4503599627370494 rfl h2
    (by decide)
  obtain ⟨e3, -⟩ := opp_limb (s := fiat_25519_opp.spec x 3) (x := x 3) 4503599627370494 rfl h3
    (by decide)
  obtain ⟨e4, -⟩ := opp_limb (s := fiat_25519_opp.spec x 4) (x := x 4) 4503599627370494 rfl h4
    (by decide)
  have hn : Limbs.nat (fiat_25519_opp.spec x) + Limbs.nat x = 2 * p := by
    unfold Limbs.nat
    change _ = 2 * (2 ^ 255 - 19)
    omega
  refine ⟨?_, fun i => ?_, hn⟩
  · rw [Limbs.val_nat, Limbs.val_nat, eq_neg_iff_add_eq_zero, ← Nat.cast_add, hn]
    simp
  · fin_cases i <;>
      simp only [Fin.zero_eta, Fin.isValue, Fin.mk_one, Fin.reduceFinMk, Fin.reduceEq, ite_true,
        ite_false] <;>
      omega

public theorem Limbs.Under2p.loose {l : Fin 5 → BitVec 64} (h : Limbs.Under2p l) : Limbs.Loose l :=
  fun i => (h i).trans (by split <;> decide)

/-- `fiat_25519_opp` negates a tight field element into a loose one. -/
public theorem fiat_25519_opp.spec_val {x : Fin 5 → BitVec 64} (hx : Limbs.Tight x) :
    Limbs.val (fiat_25519_opp.spec x) = -Limbs.val x ∧ Limbs.Loose (fiat_25519_opp.spec x) :=
  have h := fiat_25519_opp.spec_wide hx.under2p
  ⟨h.1, h.2.1.loose⟩

/-- A step of the borrow chain: `x - c - b` as a 51-bit digit `s.1` and the borrow `s.2`. -/
theorem subborrow_step {b : BitVec 8} {x c : BitVec 64} {s : BitVec 64 × BitVec 8}
    (h : fiat_25519_subborrowx_u51.spec b x c = s) (hb : b.toNat ≤ 1)
    (hx : x.toNat < c.toNat + 2 ^ 51)
    (hc : 0 < c.toNat ∧ c.toNat < 2 ^ 51) :
    s.1.toNat + c.toNat + b.toNat = x.toNat + 2 ^ 51 * s.2.toNat ∧
      s.1.toNat < 2 ^ 51 ∧ s.2.toNat ≤ 1 := by
  subst h
  simp only [fiat_25519_subborrowx_u51.spec, toNat_and_mask, BitVec.toNat_sub,
    BitVec.toNat_setWidth, toNat_shift, BitVec.toNat_add, show (0 : BitVec 8).toNat = 0 from rfl]
  omega

/-- A step of the carry chain: `b + x + y` as a 51-bit digit `s.1` and the carry `s.2`. -/
theorem addcarry_step {b : BitVec 8} {x y : BitVec 64} {s : BitVec 64 × BitVec 8}
    (h : fiat_25519_addcarryx_u51.spec b x y = s) (hb : b.toNat ≤ 1) (hx : x.toNat < 2 ^ 51)
    (hy : y.toNat < 2 ^ 51) :
    s.1.toNat + 2 ^ 51 * s.2.toNat = b.toNat + x.toNat + y.toNat ∧
      s.1.toNat < 2 ^ 51 ∧ s.2.toNat ≤ 1 := by
  subst h
  simp only [fiat_25519_addcarryx_u51.spec, toNat_and_mask, BitVec.toNat_setWidth, toNat_shift,
    BitVec.toNat_add]
  omega

/-- `cmovznz`'s mask from a borrow `b`, applied to `c`: `c` if `b = 1`, else `0`. -/
theorem cmov_and {b : BitVec 8} (hb : b.toNat ≤ 1) (c : BitVec 64) :
    (fiat_25519_cmovznz_u64.spec b 0 0xffffffffffffffff &&& c).toNat = b.toNat * c.toNat := by
  rw [fiat_25519_cmovznz_u64.spec]
  split_ifs with h
  · simp [h]
  · have : b.toNat = 1 := by
      have : b.toNat ≠ 0 := fun h' => h (BitVec.eq_of_toNat_eq h')
      omega
    rw [this, one_mul, BitVec.toNat_and, Nat.and_comm,
      show (0xffffffffffffffff : BitVec 64).toNat = 2 ^ 64 - 1 from rfl,
      Nat.and_two_pow_sub_one_eq_mod, Nat.mod_eq_of_lt c.isLt]

/-- The final subtraction of `p`, `p` added back on a borrow: `Y` is `N mod p`. -/
theorem sub_p_canon {N X Y b k : ℕ} (hb : b ≤ 1) (hX : X < 2 ^ 255) (hY : Y < 2 ^ 255)
    (hN : N < 2 * p) (h1 : X + p = N + 2 ^ 255 * b) (h2 : Y + 2 ^ 255 * k = X + b * p) :
    Y = N % p := by
  change Y = N % (2 ^ 255 - 19)
  change N < 2 * (2 ^ 255 - 19) at hN
  change X + (2 ^ 255 - 19) = N + 2 ^ 255 * b at h1
  change Y + 2 ^ 255 * k = X + b * (2 ^ 255 - 19) at h2
  obtain rfl | rfl : b = 0 ∨ b = 1 := by omega
  · rw [Nat.mod_eq_sub_mod (by omega), Nat.mod_eq_of_lt (by omega)]
    omega
  · rw [Nat.mod_eq_of_lt (by omega)]
    omega

/-- `pack` of 51-bit limbs is their 255-bit sum. -/
theorem pack_eq_sum {x12 x14 x16 x18 x20 : BitVec 64} (h12 : x12 < 0x8000000000000#64)
    (h14 : x14 < 0x8000000000000#64) (h16 : x16 < 0x8000000000000#64)
    (h18 : x18 < 0x8000000000000#64) (h20 : x20 < 0x8000000000000#64) :
    fiat_25519_to_bytes.pack x12 x14 x16 x18 x20 =
      x12.setWidth 256 + x14.setWidth 256 <<< 51 + x16.setWidth 256 <<< 102 +
        x18.setWidth 256 <<< 153 +
        x20.setWidth 256 <<< 204 := by
  simp only [fiat_25519_to_bytes.pack]
  bv_decide

theorem pack_toNat {x12 x14 x16 x18 x20 : BitVec 64} (h12 : x12.toNat < 2 ^ 51)
    (h14 : x14.toNat < 2 ^ 51) (h16 : x16.toNat < 2 ^ 51) (h18 : x18.toNat < 2 ^ 51)
    (h20 : x20.toNat < 2 ^ 51) :
    (fiat_25519_to_bytes.pack x12 x14 x16 x18 x20).toNat =
      x12.toNat + x14.toNat * 2 ^ 51 + x16.toNat * 2 ^ 102 + x18.toNat * 2 ^ 153 +
        x20.toNat * 2 ^ 204 := by
  rw [pack_eq_sum (BitVec.lt_def.2 h12) (BitVec.lt_def.2 h14) (BitVec.lt_def.2 h16)
      (BitVec.lt_def.2 h18) (BitVec.lt_def.2 h20)]
  simp only [BitVec.toNat_add, BitVec.toNat_shiftLeft, BitVec.toNat_setWidth, Nat.shiftLeft_eq]
  omega

/-- `fiat_25519_to_bytes` encodes limbs at most `2p`'s, of a number below `2p`, as their value's
representative in `[0, p)` (`ZMod.val`). -/
public theorem fiat_25519_to_bytes.spec_wide {a : Fin 5 → BitVec 64} (ha : Limbs.Under2p a)
    (hN : Limbs.nat a < 2 * p) :
    (fiat_25519_to_bytes.spec a).toNat = (Limbs.val a).val := by
  unfold Limbs.nat at hN
  change _ < 2 * (2 ^ 255 - 19) at hN
  revert hN
  obtain ⟨h0, h1, h2, h3, h4⟩ := ha.bounds
  clear ha
  have k0 : (2251799813685229 : BitVec 64).toNat = 2251799813685229 := rfl
  have k1 : (2251799813685247 : BitVec 64).toNat = 2251799813685247 := rfl
  dsimp only [fiat_25519_to_bytes.spec]
  generalize hs1 : fiat_25519_subborrowx_u51.spec 0 (a 0) 2251799813685229 = s1
  obtain ⟨e1, r1, b1⟩ := subborrow_step hs1 (by decide) (by rw [k0]; omega) (by decide)
  generalize hs2 : fiat_25519_subborrowx_u51.spec s1.2 (a 1) 2251799813685247 = s2
  obtain ⟨e2, r2, b2⟩ := subborrow_step hs2 b1 (by rw [k1]; omega) (by decide)
  generalize hs3 : fiat_25519_subborrowx_u51.spec s2.2 (a 2) 2251799813685247 = s3
  obtain ⟨e3, r3, b3⟩ := subborrow_step hs3 b2 (by rw [k1]; omega) (by decide)
  generalize hs4 : fiat_25519_subborrowx_u51.spec s3.2 (a 3) 2251799813685247 = s4
  obtain ⟨e4, r4, b4⟩ := subborrow_step hs4 b3 (by rw [k1]; omega) (by decide)
  generalize hs5 : fiat_25519_subborrowx_u51.spec s4.2 (a 4) 2251799813685247 = s5
  obtain ⟨e5, r5, b5⟩ := subborrow_step hs5 b4 (by rw [k1]; omega) (by decide)
  clear h0 h1 h2 h3 h4
  have k8 : (0 : BitVec 8).toNat = 0 := rfl
  have m0 := cmov_and b5 2251799813685229
  have m1 := cmov_and b5 2251799813685247
  rw [k0] at m0
  rw [k1] at m1
  generalize fiat_25519_cmovznz_u64.spec s5.2 0 18446744073709551615 = m at m0 m1
  generalize ht1 : fiat_25519_addcarryx_u51.spec 0 s1.1 (m &&& 2251799813685229) = t1
  obtain ⟨f1, y1, c1⟩ := addcarry_step ht1 (by decide) r1 (by omega)
  generalize ht2 : fiat_25519_addcarryx_u51.spec t1.2 s2.1 (m &&& 2251799813685247) = t2
  obtain ⟨f2, y2, c2⟩ := addcarry_step ht2 c1 r2 (by omega)
  generalize ht3 : fiat_25519_addcarryx_u51.spec t2.2 s3.1 (m &&& 2251799813685247) = t3
  obtain ⟨f3, y3, c3⟩ := addcarry_step ht3 c2 r3 (by omega)
  generalize ht4 : fiat_25519_addcarryx_u51.spec t3.2 s4.1 (m &&& 2251799813685247) = t4
  obtain ⟨f4, y4, c4⟩ := addcarry_step ht4 c3 r4 (by omega)
  generalize ht5 : fiat_25519_addcarryx_u51.spec t4.2 s5.1 (m &&& 2251799813685247) = t5
  obtain ⟨f5, y5, c5⟩ := addcarry_step ht5 c4 r5 (by omega)
  rw [pack_toNat y1 y2 y3 y4 y5,
    show
      Limbs.val a =
        (((a 0).toNat + (a 1).toNat * 2 ^ 51 + (a 2).toNat * 2 ^ 102 + (a 3).toNat * 2 ^ 153 +
              (a 4).toNat * 2 ^ 204 :
            ℕ) :
          ZMod p)
      by
      rw [Limbs.val_eq]; push_cast; rfl,
    ZMod.val_natCast]
  intro hN
  refine
    sub_p_canon b5 (X :=
      s1.1.toNat + s2.1.toNat * 2 ^ 51 + s3.1.toNat * 2 ^ 102 + s4.1.toNat * 2 ^ 153 +
        s5.1.toNat * 2 ^ 204)
      (k := t5.2.toNat) (by omega) (by omega)
      (by
        change _ < 2 * (2 ^ 255 - 19); omega)
      (by
        change _ + (2 ^ 255 - 19) = _; omega)
      (by
        change _ = _ + _ * (2 ^ 255 - 19); omega)

/-- `fiat_25519_to_bytes` encodes a tight field element as its value's representative in
`[0, p)` (`ZMod.val`). -/
public theorem fiat_25519_to_bytes.spec_val {a : Fin 5 → BitVec 64} (ha : Limbs.Tight a) :
    (fiat_25519_to_bytes.spec a).toNat = (Limbs.val a).val :=
  fiat_25519_to_bytes.spec_wide ha.under2p ha.nat_lt

end Fiat

/-! ## Firedancer's field functions -/

section Fd

/-- `fd_f25519_mul` multiplies loose field elements into a tight one. -/
public theorem fd_f25519_mul.spec_val {a b : Fin 5 → BitVec 64} (ha : Limbs.Loose a)
    (hb : Limbs.Loose b) :
    Limbs.val (fd_f25519_mul.spec a b) = Limbs.val a * Limbs.val b ∧
      Limbs.Tight (fd_f25519_mul.spec a b) :=
  fiat_25519_carry_mul.spec_val ha hb

/-- `fd_f25519_sqr` squares a loose field element into a tight one. -/
public theorem fd_f25519_sqr.spec_val {a : Fin 5 → BitVec 64} (ha : Limbs.Loose a) :
    Limbs.val (fd_f25519_sqr.spec a) = Limbs.val a ^ 2 ∧ Limbs.Tight (fd_f25519_sqr.spec a) :=
  fiat_25519_carry_square.spec_val ha

/-- `fd_f25519_mul` of loose field elements of positive numbers has a positive number. -/
public theorem fd_f25519_mul.spec_pos {a b : Fin 5 → BitVec 64} (ha : Limbs.Loose a)
    (hb : Limbs.Loose b) (pa : 0 < Limbs.nat a) (pb : 0 < Limbs.nat b) :
    0 < Limbs.nat (fd_f25519_mul.spec a b) :=
  (fiat_25519_carry_mul.spec_full ha hb).2 ⟨pa, pb⟩

/-- `fd_f25519_sqr` of a loose field element of a positive number has a positive number. -/
public theorem fd_f25519_sqr.spec_pos {a : Fin 5 → BitVec 64} (ha : Limbs.Loose a)
    (pa : 0 < Limbs.nat a) : 0 < Limbs.nat (fd_f25519_sqr.spec a) :=
  (fiat_25519_carry_square.spec_full ha).2 pa

/-- `fd_f25519_add` adds tight field elements into a tight one. -/
public theorem fd_f25519_add.spec_val {a b : Fin 5 → BitVec 64} (ha : Limbs.Tight a)
    (hb : Limbs.Tight b) :
    Limbs.val (fd_f25519_add.spec a b) = Limbs.val a + Limbs.val b ∧
      Limbs.Tight (fd_f25519_add.spec a b) := by
  obtain ⟨hv, hl⟩ := fiat_25519_add.spec_val ha hb
  obtain ⟨hv', ht⟩ := fiat_25519_carry.spec_val hl
  exact ⟨hv'.trans hv, ht⟩

/-- `fd_f25519_add` of tight field elements, one of a positive number, has a positive number. -/
public theorem fd_f25519_add.spec_pos {a b : Fin 5 → BitVec 64} (ha : Limbs.Tight a)
    (hb : Limbs.Tight b) (h : 0 < Limbs.nat a + Limbs.nat b) :
    0 < Limbs.nat (fd_f25519_add.spec a b) := by
  have hab k : (a k).toNat + (b k).toNat ≤ 0x18000000000000 := by
    have := ha k; have := hb k; omega
  refine (fiat_25519_carry.spec_full (fiat_25519_add.spec_le hab).2).2 ?_
  rwa [fiat_25519_add.spec_nat hab]

/-- `fd_f25519_sub` subtracts tight field elements into a tight one. -/
public theorem fd_f25519_sub.spec_val {a b : Fin 5 → BitVec 64} (ha : Limbs.Tight a)
    (hb : Limbs.Under2p b) :
    Limbs.val (fd_f25519_sub.spec a b) = Limbs.val a - Limbs.val b ∧
      Limbs.Tight (fd_f25519_sub.spec a b) := by
  obtain ⟨hv, hl⟩ := fiat_25519_sub.spec_val ha hb
  obtain ⟨hv', ht⟩ := fiat_25519_carry.spec_val hl
  exact ⟨hv'.trans hv, ht⟩

/-- `fd_f25519_sub a b` has a positive number when `a + 2p - b`'s is: the carries keep it so. -/
public theorem fd_f25519_sub.spec_pos {a b : Fin 5 → BitVec 64} (ha : Limbs.Tight a)
    (hb : Limbs.Under2p b) (h : Limbs.nat b < Limbs.nat a + 2 * p) :
    0 < Limbs.nat (fd_f25519_sub.spec a b) := by
  obtain ⟨⟨-, hl⟩, hn⟩ := fiat_25519_sub.spec_full ha hb
  exact (fiat_25519_carry.spec_full hl).2 (by omega)

/-- `fd_f25519_neg` negates a tight field element into a loose one. -/
public theorem fd_f25519_neg.spec_val {a : Fin 5 → BitVec 64} (ha : Limbs.Tight a) :
    Limbs.val (fd_f25519_neg.spec a) = -Limbs.val a ∧ Limbs.Loose (fd_f25519_neg.spec a) :=
  fiat_25519_opp.spec_val ha

/-- `fd_f25519_neg` on limbs at most `2p`'s: `2p` minus the number, its limbs at most `2p`'s. -/
public theorem fd_f25519_neg.spec_wide {a : Fin 5 → BitVec 64} (ha : Limbs.Under2p a) :
    Limbs.val (fd_f25519_neg.spec a) = -Limbs.val a ∧ Limbs.Under2p (fd_f25519_neg.spec a) ∧
      Limbs.nat (fd_f25519_neg.spec a) + Limbs.nat a = 2 * p :=
  fiat_25519_opp.spec_wide ha

/-- `fd_f25519_neg`'s limbs are at most `2p`'s. -/
public theorem fd_f25519_neg.spec_under2p {a : Fin 5 → BitVec 64} (ha : Limbs.Tight a) :
    Limbs.Under2p (fd_f25519_neg.spec a) :=
  (fiat_25519_opp.spec_wide ha.under2p).2.1

/-- `fd_f25519_add_nr` adds tight field elements into a loose one. -/
public theorem fd_f25519_add_nr.spec_val {a b : Fin 5 → BitVec 64} (ha : Limbs.Tight a)
    (hb : Limbs.Tight b) :
    Limbs.val (fd_f25519_add_nr.spec a b) = Limbs.val a + Limbs.val b ∧
      Limbs.Loose (fd_f25519_add_nr.spec a b) :=
  fiat_25519_add.spec_val ha hb

/-- `fd_f25519_add_nr` adds a tight field element and one within `2p`'s limbs into a loose one. -/
public theorem fd_f25519_add_nr.spec_wide {a b : Fin 5 → BitVec 64} (ha : Limbs.Tight a)
    (hb : Limbs.Under2p b) :
    Limbs.val (fd_f25519_add_nr.spec a b) = Limbs.val a + Limbs.val b ∧
      Limbs.Loose (fd_f25519_add_nr.spec a b) :=
  fiat_25519_add.spec_le fun k => by
    have := ha k
    have := hb k
    split at this <;> omega

/-- `fd_f25519_add_nr` adds one within `2p`'s limbs and a tight field element into a loose one. -/
public theorem fd_f25519_add_nr.spec_wide' {a b : Fin 5 → BitVec 64} (ha : Limbs.Under2p a)
    (hb : Limbs.Tight b) :
    Limbs.val (fd_f25519_add_nr.spec a b) = Limbs.val a + Limbs.val b ∧
      Limbs.Loose (fd_f25519_add_nr.spec a b) :=
  fiat_25519_add.spec_le fun k => by
    have := hb k
    have := ha k
    split at this <;> omega

/-- `fd_f25519_sub_nr` subtracts tight field elements into a loose one. -/
public theorem fd_f25519_sub_nr.spec_val {a b : Fin 5 → BitVec 64} (ha : Limbs.Tight a)
    (hb : Limbs.Tight b) :
    Limbs.val (fd_f25519_sub_nr.spec a b) = Limbs.val a - Limbs.val b ∧
      Limbs.Loose (fd_f25519_sub_nr.spec a b) :=
  fiat_25519_sub.spec_val ha hb.under2p

/-- `fd_f25519_sub_nr` subtracts one within `2p`'s limbs from a tight field element, into a loose
one. -/
public theorem fd_f25519_sub_nr.spec_wide {a b : Fin 5 → BitVec 64} (ha : Limbs.Tight a)
    (hb : Limbs.Under2p b) :
    Limbs.val (fd_f25519_sub_nr.spec a b) = Limbs.val a - Limbs.val b ∧
      Limbs.Loose (fd_f25519_sub_nr.spec a b) :=
  fiat_25519_sub.spec_val ha hb

/-- `fd_f25519_tobytes` encodes a tight field element as its value's representative in
`[0, p)`. -/
public theorem fd_f25519_tobytes.spec_val {a : Fin 5 → BitVec 64} (ha : Limbs.Under2p a)
    (hN : Limbs.nat a < 2 * p) :
    (fd_f25519_tobytes.spec a).toNat = (Limbs.val a).val :=
  fiat_25519_to_bytes.spec_wide ha hN

/-- `l` is loose with value `z ^ e`, of a positive number if `z`'s is. -/
def IsPow (l z : Fin 5 → BitVec 64) (e : ℕ) : Prop :=
  (Limbs.val l = Limbs.val z ^ e ∧ Limbs.Loose l) ∧ (0 < Limbs.nat z → 0 < Limbs.nat l)

theorem IsPow.self {z : Fin 5 → BitVec 64} (hz : Limbs.Loose z) : IsPow z z 1 :=
  ⟨⟨(pow_one _).symm, hz⟩, id⟩

theorem IsPow.sqr (h : IsPow l z e) : IsPow (fd_f25519_sqr.spec l) z (e * 2) := by
  obtain ⟨hv, ht⟩ := fd_f25519_sqr.spec_val h.1.2
  exact ⟨⟨by rw [hv, h.1.1, pow_mul], ht.loose⟩, fun hz => fd_f25519_sqr.spec_pos h.1.2 (h.2 hz)⟩

theorem IsPow.mul (h : IsPow l z e) (h' : IsPow m z f) :
    IsPow (fd_f25519_mul.spec l m) z (e + f) := by
  obtain ⟨hv, ht⟩ := fd_f25519_mul.spec_val h.1.2 h'.1.2
  exact ⟨⟨by rw [hv, h.1.1, h'.1.1, pow_add], ht.loose⟩,
    fun hz => fd_f25519_mul.spec_pos h.1.2 h'.1.2 (h.2 hz) (h'.2 hz)⟩

theorem IsPow.sqrN (h : IsPow l z e) : IsPow (fd_f25519_pow22523.sqrN n l) z (e * 2 ^ n) := by
  induction n generalizing l e with
  | zero => simpa [fd_f25519_pow22523.sqrN] using h
  | succ n ih =>
    rw [fd_f25519_pow22523.sqrN, pow_succ', ← mul_assoc]
    exact ih h.sqr

theorem IsPow.mul_tight (h : IsPow l z e) (h' : IsPow m z f) (hg : e + f = g) :
    (Limbs.val (fd_f25519_mul.spec l m) = Limbs.val z ^ g ∧
      Limbs.Tight (fd_f25519_mul.spec l m)) ∧
      (0 < Limbs.nat z → 0 < Limbs.nat (fd_f25519_mul.spec l m)) := by
  obtain ⟨hv, ht⟩ := fd_f25519_mul.spec_val h.1.2 h'.1.2
  exact ⟨⟨by rw [hv, h.1.1, h'.1.1, ← pow_add, hg], ht⟩,
    fun hz => fd_f25519_mul.spec_pos h.1.2 h'.1.2 (h.2 hz) (h'.2 hz)⟩

/-- `fd_f25519_pow22523` raises a loose field element to `(p - 5) / 8`, tight, of a positive
number if the input's is. -/
theorem fd_f25519_pow22523.spec_full {z : Fin 5 → BitVec 64} (hz : Limbs.Loose z) :
    (Limbs.val (fd_f25519_pow22523.spec z) = Limbs.val z ^ ((p - 5) / 8) ∧
      Limbs.Tight (fd_f25519_pow22523.spec z)) ∧
      (0 < Limbs.nat z → 0 < Limbs.nat (fd_f25519_pow22523.spec z)) := by
  have h0 := IsPow.self hz
  have h1 := h0.sqr
  have h2 := h1.sqr
  have h3 := h2.sqr
  have h4 := h0.mul h3
  have h5 := h1.mul h4
  have h6 := h5.sqr
  have h7 := h4.mul h6
  have h8 := h7.sqr
  have h9 := h8.sqrN (n := 4)
  have h10 := h9.mul h7
  have h11 := h10.sqr
  have h12 := h11.sqrN (n := 9)
  have h13 := h12.mul h10
  have h14 := h13.sqr
  have h15 := h14.sqrN (n := 19)
  have h16 := h15.mul h13
  have h17 := h16.sqr
  have h18 := h17.sqrN (n := 9)
  have h19 := h18.mul h10
  have h20 := h19.sqr
  have h21 := h20.sqrN (n := 49)
  have h22 := h21.mul h19
  have h23 := h22.sqr
  have h24 := h23.sqrN (n := 99)
  have h25 := h24.mul h22
  have h26 := h25.sqr
  have h27 := h26.sqrN (n := 49)
  have h28 := h27.mul h19
  have h29 := h28.sqr
  have h30 := h29.sqr
  exact h30.mul_tight h0 (by norm_num)

/-- `fd_f25519_pow22523` raises a loose field element to `(p - 5) / 8`, tight. -/
public theorem fd_f25519_pow22523.spec_val {z : Fin 5 → BitVec 64} (hz : Limbs.Loose z) :
    Limbs.val (fd_f25519_pow22523.spec z) = Limbs.val z ^ ((p - 5) / 8) ∧
      Limbs.Tight (fd_f25519_pow22523.spec z) :=
  (fd_f25519_pow22523.spec_full hz).1

/-- `fd_f25519_pow22523` of a loose field element of a positive number has a positive number. -/
public theorem fd_f25519_pow22523.spec_pos {z : Fin 5 → BitVec 64} (hz : Limbs.Loose z)
    (pz : 0 < Limbs.nat z) : 0 < Limbs.nat (fd_f25519_pow22523.spec z) :=
  (fd_f25519_pow22523.spec_full hz).2 pz

end Fd

/-! ## Comparisons -/

section Compare

/-- Five limbs agree when their naturals do. -/
theorem Limbs.forall_eq_iff (l c : Fin 5 → BitVec 64) :
    (∀ k, l k = c k) ↔
      (l 0).toNat = (c 0).toNat ∧ (l 1).toNat = (c 1).toNat ∧ (l 2).toNat = (c 2).toNat ∧
        (l 3).toNat = (c 3).toNat ∧ (l 4).toNat = (c 4).toNat := by
  refine ⟨fun h => by simp [h], fun ⟨h0, h1, h2, h3, h4⟩ k => ?_⟩
  fin_cases k <;> exact BitVec.eq_of_toNat_eq ‹_›

/-- The bounded multiples of `p`: `0` and `p`'s digits. -/
theorem p_dvd_iff {a0 a1 a2 a3 a4 : ℕ} (h0 : a0 ≤ 4503599627370458) (h1 : a1 ≤ 4503599627370494)
    (h2 : a2 ≤ 4503599627370494) (h3 : a3 ≤ 4503599627370494) (h4 : a4 ≤ 4503599627370494)
    (hN : a0 + a1 * 2 ^ 51 + a2 * 2 ^ 102 + a3 * 2 ^ 153 + a4 * 2 ^ 204 < 2 * p) :
    p ∣ a0 + a1 * 2 ^ 51 + a2 * 2 ^ 102 + a3 * 2 ^ 153 + a4 * 2 ^ 204 ↔
      (a0 = 0 ∧ a1 = 0 ∧ a2 = 0 ∧ a3 = 0 ∧ a4 = 0) ∨
        (a0 = 2251799813685229 ∧ a1 = 2251799813685247 ∧ a2 = 2251799813685247 ∧
          a3 = 2251799813685247 ∧ a4 = 2251799813685247) := by
  simp only [p, Nat.reducePow, Nat.reduceSub, Nat.reduceMul] at hN ⊢
  constructor
  · rintro ⟨c, hc⟩
    rcases (by omega : c = 0 ∨ c = 1) with rfl | rfl
    · left
      omega
    · right
      -- the digits one at a time, from the bottom
      generalize hr3 : a3 + a4 * 2 ^ 51 = r3 at *
      generalize hr2 : a2 + r3 * 2 ^ 51 = r2 at *
      generalize hr1 : a1 + r2 * 2 ^ 51 = r1 at *
      have : a0 + r1 * 2 ^ 51 =
          57896044618658097711785492504343953926634992332820282019728792003956564819949 := by
        subst hr1 hr2 hr3
        omega
      have : r1 = 25711008708143844408671393477458601640355247900524685364822015 := by omega
      have : r2 = 11417981541647679048466287755595961091061972991 := by omega
      have : r3 = 5070602400912917605986812821503 := by omega
      omega
  · rintro (⟨rfl, rfl, rfl, rfl, rfl⟩ | ⟨rfl, rfl, rfl, rfl, rfl⟩)
    · exact ⟨0, rfl⟩
    · exact ⟨1, rfl⟩

/-- A zero below `2p`, its limbs at most `2p`'s, is all zeros or `p`'s limbs. -/
theorem Limbs.val_eq_zero_iff {l : Fin 5 → BitVec 64} (h : Limbs.Under2p l)
    (hN : Limbs.nat l < 2 * p) :
    Limbs.val l = 0 ↔ (∀ k, l k = 0) ∨ (∀ k, l k = fd_f25519_is_zero.pLimbs k) := by
  obtain ⟨h0, h1, h2, h3, h4⟩ := h.bounds
  rw [Limbs.val_nat, ZMod.natCast_eq_zero_iff, Limbs.nat, p_dvd_iff h0 h1 h2 h3 h4 hN,
    show (∀ k, l k = 0) ↔ _ from Limbs.forall_eq_iff l 0,
    Limbs.forall_eq_iff l fd_f25519_is_zero.pLimbs]
  rfl

/-- `is_zero` on limbs at most `2p`'s, of a number below `2p`: `1` exactly at zero. -/
public theorem fd_f25519_is_zero.spec_val {a : Fin 5 → BitVec 64} (ha : Limbs.Under2p a)
    (hN : Limbs.nat a < 2 * p) :
    fd_f25519_is_zero.spec a = if Limbs.val a = 0 then 1#32 else 0#32 := by
  simp only [fd_f25519_is_zero.spec, Limbs.val_eq_zero_iff ha hN]
  rfl

/-- `eq` on tight values: `1` exactly when they are equal. -/
public theorem fd_f25519_eq.spec_val {a b : Fin 5 → BitVec 64} (ha : Limbs.Tight a)
    (hb : Limbs.Under2p b) :
    fd_f25519_eq.spec a b = if Limbs.val a = Limbs.val b then 1#32 else 0#32 := by
  obtain ⟨v, t⟩ := fd_f25519_sub.spec_val ha hb
  simp only [fd_f25519_eq.spec, fd_f25519_is_zero.spec_val t.under2p t.nat_lt, v,
    sub_eq_zero]

/-- `sgn` on a tight value: the parity of its canonical value. -/
public theorem fd_f25519_sgn.spec_val {a : Fin 5 → BitVec 64} (ha : Limbs.Under2p a)
    (hN : Limbs.nat a < 2 * p) :
    fd_f25519_sgn.spec a = BitVec.ofNat 32 ((Limbs.val a).val % 2) := by
  have h := fd_f25519_tobytes.spec_val ha hN
  apply BitVec.eq_of_toNat_eq
  simp only [fd_f25519_sgn.spec, BitVec.toNat_and, BitVec.toNat_setWidth, BitVec.toNat_ofNat, h]
  rw [Nat.and_one_is_mod]
  omega

end Compare

/-! ## Decoding -/

section Decode

/-- `from_bytes`'s limb `i`: bits `51 i` to `51 i + 50` of `buf`. -/
theorem fiat_25519_from_bytes.spec_limb (buf : BitVec 256) (i : Fin 5) :
    fiat_25519_from_bytes.spec buf i =
      (buf >>> (51 * i.val)).setWidth 64 &&& 2251799813685247#64 := by
  fin_cases i <;> simp only [fiat_25519_from_bytes.spec] <;> bv_decide

/-- `frombytes` reads `buf`'s low 255 bits, tight. -/
public theorem fd_f25519_frombytes.spec_val (buf : BitVec 256) :
    Limbs.val (fd_f25519_frombytes.spec buf) = ((buf.toNat % 2 ^ 255 : ℕ) : ZMod p) ∧
      Limbs.Tight (fd_f25519_frombytes.spec buf) := by
  have h (i : Fin 5) :
      (fd_f25519_frombytes.spec buf i).toNat = buf.toNat / 2 ^ (51 * i.val) % 2 ^ 51 := by
    rw [fd_f25519_frombytes.spec, fiat_25519_from_bytes.spec_limb, toNat_and_mask,
      BitVec.toNat_setWidth, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
    exact Nat.mod_mod_of_dvd _ (by decide)
  refine ⟨?_, fun i => by rw [h]; omega⟩
  rw [Limbs.val_nat, Limbs.nat, h 0, h 1, h 2, h 3, h 4]
  congr 1
  simp only [Fin.isValue, Fin.coe_ofNat_eq_mod, Nat.reduceMod, Nat.reduceMul, Nat.reducePow,
    mul_zero, pow_zero, Nat.div_one]
  omega

end Decode

end MLIR.Firedancer.Ref
