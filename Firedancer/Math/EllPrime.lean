module

public import Ed25519.Scalar
public import Mathlib.Data.ZMod.Basic
import Ed25519.Field
import Mathlib.NumberTheory.LucasPrimality
import Mathlib.Tactic.NormNum.Prime
import Mathlib.Tactic.ReduceModChar

/-! `ℓ` is prime, by a Pratt certificate (Lucas's test on each factor of `q - 1`). -/

namespace Ed25519

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

theorem prime_132667 : Nat.Prime 132667 := by
  pratt 5 [(2, 1), (3, 1), (22111, 1)] []

theorem prime_137849 : Nat.Prime 137849 := by
  pratt 3 [(2, 3), (17231, 1)] []

theorem prime_409477 : Nat.Prime 409477 := by
  pratt 2 [(2, 2), (3, 1), (34123, 1)] []

theorem prime_531581 : Nat.Prime 531581 := by
  pratt 2 [(2, 2), (5, 1), (7, 1), (3797, 1)] []

theorem prime_1224481 : Nat.Prime 1224481 := by
  pratt 13 [(2, 5), (3, 1), (5, 1), (2551, 1)] []

theorem prime_14741173 : Nat.Prime 14741173 := by
  pratt 2 [(2, 2), (3, 2), (409477, 1)] [prime_409477]

theorem prime_58964693 : Nat.Prime 58964693 := by
  pratt 2 [(2, 2), (14741173, 1)] [prime_14741173]

theorem prime_292386187 : Nat.Prime 292386187 := by
  pratt 2 [(2, 1), (3, 4), (307, 1), (5879, 1)] []

theorem prime_213441916511 : Nat.Prime 213441916511 := by
  pratt 13 [(2, 1), (5, 1), (73, 1), (292386187, 1)] [prime_292386187]

theorem prime_1257559732178653 : Nat.Prime 1257559732178653 := by
  pratt 2 [(2, 2), (3, 1), (7, 1), (23, 1), (531581, 1), (1224481, 1)] [prime_531581, prime_1224481]

theorem prime_4434155615661930479 : Nat.Prime 4434155615661930479 := by
  pratt 17 [(2, 1), (41, 1), (43, 1), (1257559732178653, 1)] [prime_1257559732178653]

theorem prime_3044861653679985063343 : Nat.Prime 3044861653679985063343 := by
  pratt 5 [(2, 1), (3, 1), (11, 1), (30703, 1), (82163, 1), (132667, 1), (137849, 1)] [prime_132667, prime_137849]

theorem prime_172054593956031949258510691 : Nat.Prime 172054593956031949258510691 := by
  pratt 2 [(2, 1), (5, 1), (1361, 1), (2851, 1), (4434155615661930479, 1)] [prime_4434155615661930479]

theorem prime_198211423230930754013084525763697 : Nat.Prime 198211423230930754013084525763697 := by
  pratt 5 [(2, 4), (3, 1), (23, 1), (58964693, 1), (3044861653679985063343, 1)] [prime_58964693, prime_3044861653679985063343]

theorem prime_19757330305831588566944191468367130476339 : Nat.Prime 19757330305831588566944191468367130476339 := by
  pratt 2 [(2, 1), (269, 1), (213441916511, 1), (172054593956031949258510691, 1)] [prime_213441916511, prime_172054593956031949258510691]

theorem prime_276602624281642239937218680557139826668747 : Nat.Prime 276602624281642239937218680557139826668747 := by
  pratt 2 [(2, 1), (7, 1), (19757330305831588566944191468367130476339, 1)] [prime_19757330305831588566944191468367130476339]

/-- `ℓ` is prime. -/
public theorem prime_ell : Nat.Prime ell := by
  unfold ell
  pratt 2 [(2, 2), (3, 1), (11, 1), (198211423230930754013084525763697, 1), (276602624281642239937218680557139826668747, 1)] [prime_198211423230930754013084525763697, prime_276602624281642239937218680557139826668747]

/-- `ZMod ℓ` is a field. -/
public instance fact_prime_ell : Fact ell.Prime :=
  ⟨prime_ell⟩

end Ed25519
