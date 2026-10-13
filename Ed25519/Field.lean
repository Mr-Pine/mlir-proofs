module

public import Mathlib.Data.ZMod.Basic
import Mathlib.NumberTheory.LucasPrimality
import Mathlib.Tactic.NormNum.Prime
import Mathlib.Tactic.ReduceModChar
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

/-! The field `ZMod p`, `p = 2^255 - 19`: `p` is prime, and `√-1`. -/

namespace Ed25519

/-! ## Definitions -/

@[expose] public section

/-- The field's prime. -/
abbrev p : ℕ :=
  2 ^ 255 - 19

/-- `√-1`. -/
def sqrtM1 : ZMod p :=
  19681161376707505956807079304988542015446066515923890162744021073123829784752

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

public theorem two_pow_255 : (2 : ZMod p) ^ 255 = 19 := by
  have h : 2 ^ 255 = p + 19 := by norm_num
  rw [show (2 : ZMod p) ^ 255 = ((2 ^ 255 : ℕ) : ZMod p) by
      push_cast; rfl,
    h, Nat.cast_add, ZMod.natCast_self, zero_add]
  rfl

public theorem sqrtM1_sq : sqrtM1 ^ 2 = -1 := by
  unfold sqrtM1
  reduce_mod_char

/-! ## `p` is prime -/

section Prime

/-- Lucas's test, `p - 1 = ∏ q ^ k` over the pairs `(q, k)` of `fs`, `a` the witness. -/
public theorem prime_of_pratt {p : ℕ} (a : ℕ) (fs : List (ℕ × ℕ))
    (hfs : (fs.map fun f => f.1 ^ f.2).prod = p - 1) (hprime : ∀ f ∈ fs, f.1.Prime)
    (ha : (a : ZMod p) ^ (p - 1) = 1) (hd : ∀ f ∈ fs, (a : ZMod p) ^ ((p - 1) / f.1) ≠ 1) :
    p.Prime := by
  refine lucas_primality p a ha fun q hq hdvd => ?_
  rw [← hfs] at hdvd
  obtain ⟨_, hm, hqf⟩ := (Prime.dvd_prod_iff hq.prime).1 hdvd
  obtain ⟨f, hf, rfl⟩ := List.mem_map.1 hm
  rw [(Nat.prime_dvd_prime_iff_eq hq (hprime f hf)).1 (hq.dvd_of_dvd_pow hqf)]
  exact hd f hf

public theorem prime_1923133 : Nat.Prime 1923133 := by
  pratt 2 [(2, 2), (3, 1), (43, 1), (3727, 1)] []

public theorem prime_31757755568855353 : Nat.Prime 31757755568855353 := by
  pratt 10 [(2, 3), (3, 1), (31, 1), (107, 1), (223, 1), (4153, 1), (430751, 1)] []

public theorem prime_2773320623 : Nat.Prime 2773320623 := by
  pratt 5 [(2, 1), (2437, 1), (569003, 1)] []

public theorem prime_72106336199 : Nat.Prime 72106336199 := by
  pratt 7 [(2, 1), (13, 1), (2773320623, 1)] [prime_2773320623]

public theorem prime_8574133 : Nat.Prime 8574133 := by
  pratt 2 [(2, 2), (3, 1), (7, 1), (103, 1), (991, 1)] []

public theorem prime_1919519569386763 : Nat.Prime 1919519569386763 := by
  pratt 2 [(2, 1), (3, 1), (7, 1), (19, 1), (47, 2), (127, 1), (8574133, 1)] [prime_8574133]

public theorem prime_75445702479781427272750846543864801 :
    Nat.Prime 75445702479781427272750846543864801 := by
  pratt 7
    [(2, 5), (3, 2), (5, 2), (75707, 1), (72106336199, 1), (1919519569386763, 1)]
    [prime_72106336199, prime_1919519569386763]

public theorem prime_74058212732561358302231226437062788676166966415465897661863160754340907 :
    Nat.Prime 74058212732561358302231226437062788676166966415465897661863160754340907 := by
  pratt 2
    [(2, 1), (3, 1), (353, 1), (57467, 1), (132049, 1), (1923133, 1), (31757755568855353, 1),
      (75445702479781427272750846543864801, 1)]
    [prime_1923133, prime_31757755568855353, prime_75445702479781427272750846543864801]

public theorem prime_p : p.Prime := by
  pratt 2
    [(2, 2), (3, 1), (65147, 1),
      (74058212732561358302231226437062788676166966415465897661863160754340907, 1)]
    [prime_74058212732561358302231226437062788676166966415465897661863160754340907]

public instance fact_prime_p : Fact p.Prime :=
  ⟨prime_p⟩

end Prime

/-! ## Casts and squares -/

/-- Naturals equal mod `p` are equal in `ZMod p`. -/
public theorem natCast_eq {a b : ℕ} (h : a % p = b % p) : (a : ZMod p) = b :=
  (ZMod.natCast_eq_natCast_iff' a b p).2 h

/-- Naturals distinct mod `p` are distinct in `ZMod p`. -/
public theorem natCast_ne {a b : ℕ} (h : a % p ≠ b % p) : (a : ZMod p) ≠ b := fun e =>
  h ((ZMod.natCast_eq_natCast_iff' a b p).1 e)

/-- `c² = 1` exactly at `±1`. -/
public theorem sq_eq_one_iff' {c : ZMod p} : c ^ 2 = 1 ↔ c = 1 ∨ c = -1 := by
  constructor
  · intro h
    have : (c - 1) * (c + 1) = 0 := by linear_combination h
    rcases mul_eq_zero.1 this with h | h
    · exact .inl (by linear_combination h)
    · exact .inr (by linear_combination h)
  · rintro (rfl | rfl) <;> ring

end Ed25519
