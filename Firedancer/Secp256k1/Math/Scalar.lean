module

public import Ed25519.Field
import Firedancer.Secp256k1.Math.Field
public import Firedancer.Secp256k1.Math.Mont
public import Firedancer.Secp256k1.Private
public import Firedancer.Secp256k1.S2n
import Mathlib.NumberTheory.LucasPrimality
import Mathlib.Tactic.NormNum.Prime
import Mathlib.Tactic.ReduceModChar

/-! Scalars `ZMod n_256k1`: `n` is prime, plain and Montgomery value maps, the constants.

In `fd_secp256k1_recover` the scalars `rs`, `s` (from `frombytes`), `msg` (after `reduce`) and
`rn` (after `invert`) are plain; `msg`, `s`, `rn` after `tomont` and `u1`, `u2` up to their
`demont` are Montgomery; `u1`, `u2` after `demont` (the `double_base_mul` scalars) are plain. -/

namespace Firedancer.Secp256k1

open Ed25519 (prime_of_pratt)

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

/-! ## `n` is prime -/

section Prime

theorem prime_4681609 : Nat.Prime 4681609 := by
  pratt 23 [(2, 3), (3, 1), (97, 1), (2011, 1)] []

theorem prime_107361793816595537 : Nat.Prime 107361793816595537 := by
  pratt 3 [(2, 4), (16699, 1), (85831, 1), (4681609, 1)] [prime_4681609]

theorem prime_44706919 : Nat.Prime 44706919 := by
  pratt 6 [(2, 1), (3, 1), (797, 1), (9349, 1)] []

theorem prime_174723607534414371449 : Nat.Prime 174723607534414371449 := by
  pratt 3 [(2, 3), (17, 1), (59, 1), (4051, 1), (120233, 1), (44706919, 1)] [prime_44706919]

theorem prime_545358713 : Nat.Prime 545358713 := by
  pratt 5 [(2, 3), (41, 1), (59, 1), (28181, 1)] []

theorem prime_1627771 : Nat.Prime 1627771 := by
  pratt 3 [(2, 1), (3, 1), (5, 1), (29, 1), (1871, 1)] []

theorem prime_297159362677 : Nat.Prime 297159362677 := by
  pratt 2 [(2, 2), (3, 2), (11, 1), (461, 1), (1627771, 1)] [prime_1627771]

theorem prime_29047611873442575647497758179 : Nat.Prime 29047611873442575647497758179 := by
  pratt 2 [(2, 1), (293, 1), (305873, 1), (545358713, 1), (297159362677, 1)]
    [prime_545358713, prime_297159362677]

theorem prime_341948486974166000522343609283189 : Nat.Prime 341948486974166000522343609283189 := by
  pratt 2 [(2, 2), (3, 3), (109, 1), (29047611873442575647497758179, 1)]
    [prime_29047611873442575647497758179]

public theorem n_256k1_eq :
    n_256k1 = 115792089237316195423570985008687907852837564279074904382605163141518161494337 :=
  rfl

public theorem prime_n_256k1 : n_256k1.Prime := by
  rw [n_256k1_eq]
  pratt 7
    [(2, 6), (3, 1), (149, 1), (631, 1), (107361793816595537, 1), (174723607534414371449, 1),
      (341948486974166000522343609283189, 1)]
    [prime_107361793816595537, prime_174723607534414371449, prime_341948486974166000522343609283189]

public instance fact_prime_n_256k1 : Fact n_256k1.Prime :=
  ⟨prime_n_256k1⟩

end Prime

/-! ## Stored scalars -/

@[expose] public section

/-- A stored scalar is canonical: its value is below `n`. -/
abbrev scCanon (a : fd_secp256k1_scalar_t) : Prop :=
  limbsEval a < n_256k1

/-- The scalar a plain `scalar_t` stores. -/
abbrev toS (a : fd_secp256k1_scalar_t) : ZMod n_256k1 :=
  (limbsEval a : ZMod n_256k1)

/-- The scalar a Montgomery-form `scalar_t` stores, `a · 2⁻²⁵⁶`. -/
abbrev toSM (a : fd_secp256k1_scalar_t) : ZMod n_256k1 :=
  montVal n_256k1 a

end

public theorem n_256k1_lt : n_256k1 < 2 ^ 256 := by norm_num [n_256k1]

public theorem n_256k1_pos : 0 < n_256k1 := by norm_num [n_256k1]

public theorem n_256k1_lt_p_256k1 : n_256k1 < p_256k1 := by norm_num [n_256k1, p_256k1]

/-- One conditional subtraction reduces any 256-bit value mod `n`. -/
public theorem two_pow_256_sub_one_lt_two_mul_n : 2 ^ 256 - 1 < 2 * n_256k1 := by norm_num [n_256k1]

public theorem two_ne_zero_n : (2 : ZMod n_256k1) ≠ 0 := by
  unfold n_256k1
  reduce_mod_char
  decide

public theorem fiat_secp256k1_montgomery_scalar_m_eq :
    fiat_secp256k1_montgomery_scalar_m = n_256k1 := by
  norm_num [fiat_secp256k1_montgomery_scalar_m, n_256k1]

/-- Evaluates `limbsEval` of the constant `c` and closes the arithmetic. -/
local macro "limbs_eval " c:ident ns:ident* : tactic =>
  `(tactic| simp [limbsEval_four, $c:ident, n_256k1, $[$ns:ident],*])

public theorem limbsEval_const_n : limbsEval fd_secp256k1_const_n = n_256k1 := by
  limbs_eval fd_secp256k1_const_n

public theorem limbsEval_const_p_minus_n :
    limbsEval fd_secp256k1_const_p_minus_n = p_256k1 - n_256k1 := by
  limbs_eval fd_secp256k1_const_p_minus_n p_256k1

/-- `rr_mont` is `R² mod n`. -/
public theorem limbsEval_const_scalar_rr_mont :
    limbsEval fd_secp256k1_const_scalar_rr_mont = 2 ^ 256 * 2 ^ 256 % n_256k1 := by
  limbs_eval fd_secp256k1_const_scalar_rr_mont

public theorem limbsEval_const_n_m2 : limbsEval Ref.fd_secp256k1_const_n_m2 = n_256k1 - 2 := by
  limbs_eval Ref.fd_secp256k1_const_n_m2

public theorem fiat_secp256k1_montgomery_scalar_set_one.sc :
    scCanon fiat_secp256k1_montgomery_scalar_set_one.spec ∧
      toSM fiat_secp256k1_montgomery_scalar_set_one.spec = 1 := by
  have h : limbsEval fiat_secp256k1_montgomery_scalar_set_one.spec = 2 ^ 256 % n_256k1 := by
    rw [fiat_secp256k1_montgomery_scalar_set_one.spec, limbsEval_limbsOfNat,
      fiat_secp256k1_montgomery_scalar_m_eq]
    exact Nat.mod_eq_of_lt (lt_trans (Nat.mod_lt _ n_256k1_pos) n_256k1_lt)
  refine
    ⟨show limbsEval _ < _ by
        rw [h]; exact Nat.mod_lt _ n_256k1_pos,
      ?_⟩
  unfold toSM montVal
  rw [h, ZMod.natCast_mod, Nat.cast_pow, Nat.cast_ofNat,
    mul_inv_cancel₀ (pow_ne_zero _ two_ne_zero_n)]

end Firedancer.Secp256k1
