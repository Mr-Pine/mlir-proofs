module

public import Ed25519.Field
public import Firedancer.Bn254.Glv
public import Firedancer.Bn254.Math.Limbs
public import Mathlib.Algebra.Field.ZMod
import Mathlib.NumberTheory.LegendreSymbol.Basic
import Mathlib.NumberTheory.LucasPrimality
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.NormNum.Prime
import Mathlib.Tactic.ReduceModChar

/-! The base field `ZMod p` and the group order `r` of bn254: both prime, the Montgomery value map
of `fp_t`, the constants, and the curve facts `y² = x³ + 3` needs. -/

namespace Firedancer.Bn254

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

@[expose] public section

/-- The base field prime `p` of bn254. -/
def p_bn254 : ℕ :=
  21888242871839275222246405745257275088696311157297823662689037894645226208583

/-- The group order `r` of bn254 (the scalar field prime). -/
def r_bn254 : ℕ :=
  21888242871839275222246405745257275088548364400416034343698204186575808495617

end

/-! ## `p` and `r` are prime -/

section Prime

theorem prime_405928799 : Nat.Prime 405928799 := by
  pratt 22 [(2, 1), (11, 1), (3691, 1), (4999, 1)] []

theorem prime_11465965001 : Nat.Prime 11465965001 := by
  pratt 3 [(2, 3), (5, 4), (7, 1), (327599, 1)] []

theorem prime_1853641 : Nat.Prime 1853641 := by
  pratt 17 [(2, 3), (3, 2), (5, 1), (19, 1), (271, 1)] []

theorem prime_4562087 : Nat.Prime 4562087 := by
  pratt 5 [(2, 1), (17, 1), (109, 1), (1231, 1)] []

theorem prime_173171039 : Nat.Prime 173171039 := by
  pratt 13 [(2, 1), (73, 1), (89, 1), (13327, 1)] []

theorem prime_1263766531 : Nat.Prime 1263766531 := by
  pratt 10 [(2, 1), (3, 1), (5, 1), (13, 1), (911, 1), (3557, 1)] []

theorem prime_35385462869 : Nat.Prime 35385462869 := by
  pratt 2 [(2, 2), (7, 1), (1263766531, 1)] [prime_1263766531]

theorem prime_2480874801745591 : Nat.Prime 2480874801745591 := by
  pratt 6 [(2, 1), (3, 2), (5, 1), (19, 1), (41, 1), (35385462869, 1)] [prime_35385462869]

theorem prime_13427688667394608761327070753331941386769 :
    Nat.Prime 13427688667394608761327070753331941386769 := by
  pratt 17 [(2, 4), (3, 1), (7, 1), (11, 1), (1853641, 1), (4562087, 1), (173171039, 1), (2480874801745591, 1)] [prime_1853641, prime_4562087, prime_173171039, prime_2480874801745591]

public theorem prime_p_bn254 : p_bn254.Prime := by
  unfold p_bn254
  pratt 3 [(2, 1), (3, 2), (13, 1), (29, 1), (67, 1), (229, 1), (311, 1), (983, 1), (11003, 1), (405928799, 1), (11465965001, 1), (13427688667394608761327070753331941386769, 1)] [prime_405928799, prime_11465965001, prime_13427688667394608761327070753331941386769]

theorem prime_12048837557 : Nat.Prime 12048837557 := by
  pratt 2 [(2, 2), (7, 2), (661, 1), (93001, 1)] []

theorem prime_5156902474397 : Nat.Prime 5156902474397 := by
  pratt 2 [(2, 2), (107, 1), (12048837557, 1)] [prime_12048837557]

theorem prime_1670836401704629 : Nat.Prime 1670836401704629 := by
  pratt 2 [(2, 2), (3, 4), (5156902474397, 1)] [prime_5156902474397]

theorem prime_1593227 : Nat.Prime 1593227 := by
  pratt 2 [(2, 1), (19, 1), (41927, 1)] []

theorem prime_639533339 : Nat.Prime 639533339 := by
  pratt 2 [(2, 1), (229, 1), (853, 1), (1637, 1)] []

theorem prime_65865678001877903 : Nat.Prime 65865678001877903 := by
  pratt 5 [(2, 1), (83, 1), (379, 1), (1637, 1), (639533339, 1)] [prime_639533339]

theorem prime_13818364434197438864469338081 : Nat.Prime 13818364434197438864469338081 := by
  pratt 3 [(2, 5), (5, 1), (823, 1), (1593227, 1), (65865678001877903, 1)] [prime_1593227, prime_65865678001877903]

public theorem prime_r_bn254 : r_bn254.Prime := by
  unfold r_bn254
  pratt 5 [(2, 28), (3, 2), (13, 1), (29, 1), (983, 1), (11003, 1), (237073, 1), (405928799, 1), (1670836401704629, 1), (13818364434197438864469338081, 1)] [prime_405928799, prime_1670836401704629, prime_13818364434197438864469338081]

public instance fact_prime_p_bn254 : Fact p_bn254.Prime :=
  ⟨prime_p_bn254⟩

public instance fact_prime_r_bn254 : Fact r_bn254.Prime :=
  ⟨prime_r_bn254⟩

end Prime

/-! ## Stored elements -/

@[expose] public section

/-- A stored field element is canonical: its value is below `p`. -/
abbrev fpCanon (a : fd_bn254_fp_t) : Prop :=
  limbsEval a < p_bn254

/-- The field element a Montgomery-form `fp_t` stores, `a · 2⁻²⁵⁶`. -/
def toF (a : fd_bn254_fp_t) : ZMod p_bn254 :=
  (limbsEval a : ZMod p_bn254) * ((2 : ZMod p_bn254) ^ 256)⁻¹

/-- A stored element is canonical with value `v`. -/
abbrev Tr (a : fd_bn254_fp_t) (v : ZMod p_bn254) : Prop :=
  fpCanon a ∧ toF a = v

/-- The cube root of unity `β` of `fd_bn254_const_beta_mont`. -/
def beta : ZMod p_bn254 :=
  21888242871839275220042445260109153167277707414472061641714758635765020556616

end

public theorem p_bn254_lt : p_bn254 < 2 ^ 254 := by norm_num [p_bn254]

public theorem p_bn254_pos : 0 < p_bn254 := by norm_num [p_bn254]

public theorem r_bn254_lt_p : r_bn254 < p_bn254 := by norm_num [r_bn254, p_bn254]

public theorem two_ne_zero_p : (2 : ZMod p_bn254) ≠ 0 := by
  unfold p_bn254; reduce_mod_char; decide

public theorem two_pow_ne_zero_p : (2 : ZMod p_bn254) ^ 256 ≠ 0 :=
  pow_ne_zero _ two_ne_zero_p

public theorem fiat_bn254_m_eq : fiat_bn254_m = p_bn254 := by norm_num [fiat_bn254_m, p_bn254]

/-- A stored value whose limbs are `v · 2^256` mod `p` stands for `v`. -/
public theorem toF_eq_natCast {a : fd_bn254_fp_t} {v : ℕ}
    (h : limbsEval a % p_bn254 = v * 2 ^ 256 % p_bn254) : toF a = v := by
  unfold toF
  rw [(ZMod.natCast_eq_natCast_iff' _ _ _).2 h, Nat.cast_mul, Nat.cast_pow, Nat.cast_ofNat,
    mul_assoc, mul_inv_cancel₀ two_pow_ne_zero_p, mul_one]

/-- Distinct canonical values have distinct residues. -/
public theorem toF_inj {a b : fd_bn254_fp_t} (ha : fpCanon a) (hb : fpCanon b) :
    toF a = toF b ↔ a = b := by
  refine ⟨fun h => limbsEval_injective ?_, fun h => h ▸ rfl⟩
  have h' := mul_right_cancel₀ (inv_ne_zero two_pow_ne_zero_p) h
  have := congrArg ZMod.val h'
  rwa [ZMod.val_cast_of_lt ha, ZMod.val_cast_of_lt hb] at this

/-- A canonical element is `0` exactly when its limbs are. -/
public theorem toF_eq_zero_iff {a : fd_bn254_fp_t} (ha : fpCanon a) :
    toF a = 0 ↔ limbsEval a = 0 := by
  unfold toF
  rw [mul_eq_zero, or_iff_left (inv_ne_zero two_pow_ne_zero_p), ZMod.natCast_eq_zero_iff]
  constructor
  · intro h; exact Nat.eq_zero_of_dvd_of_lt h ha
  · intro h; rw [h]; exact dvd_zero _

/-! ## Constants -/

/-- Evaluates `limbsEval` of the constant `c` and closes the arithmetic. -/
local macro "limbs_eval " c:ident ns:ident* : tactic =>
  `(tactic| simp [limbsEval_four, $c:ident, p_bn254, $[$ns:ident],*])

public theorem limbsEval_const_p : limbsEval fd_bn254_const_p = p_bn254 := by
  limbs_eval fd_bn254_const_p

public theorem const_p_inv_spec :
    (fd_bn254_const_p[0].toNat * fd_bn254_const_p_inv.toNat) % 2 ^ 64 = 2 ^ 64 - 1 := by
  simp [fd_bn254_const_p, fd_bn254_const_p_inv]

public theorem limbsEval_const_one : limbsEval fd_bn254_const_one = 1 := by
  limbs_eval fd_bn254_const_one

public theorem limbsEval_const_rr :
    limbsEval fd_bn254_const_rr % p_bn254 = 2 ^ 256 * 2 ^ 256 % p_bn254 := by
  limbs_eval fd_bn254_const_rr

public theorem fpCanon_const_rr : fpCanon fd_bn254_const_rr := by limbs_eval fd_bn254_const_rr

public theorem fd_bn254_const_one_mont.tr : Tr fd_bn254_const_one_mont 1 :=
  ⟨by limbs_eval fd_bn254_const_one_mont, by
    rw [← Nat.cast_one]; exact toF_eq_natCast (by limbs_eval fd_bn254_const_one_mont)⟩

public theorem fd_bn254_const_b_mont.tr : Tr fd_bn254_const_b_mont 3 :=
  ⟨by limbs_eval fd_bn254_const_b_mont, by
    rw [← Nat.cast_ofNat]; exact toF_eq_natCast (by limbs_eval fd_bn254_const_b_mont)⟩

public theorem fd_bn254_const_p_minus_one_mont.tr : Tr fd_bn254_const_p_minus_one_mont (-1) := by
  refine ⟨by limbs_eval fd_bn254_const_p_minus_one_mont, ?_⟩
  have : (-1 : ZMod p_bn254) = ((p_bn254 - 1 : ℕ) : ZMod p_bn254) := by
    rw [Nat.cast_sub p_bn254_pos, ZMod.natCast_self, Nat.cast_one, zero_sub]
  rw [this]
  exact toF_eq_natCast (by limbs_eval fd_bn254_const_p_minus_one_mont)

public theorem fd_bn254_const_beta_mont.tr : Tr fd_bn254_const_beta_mont beta := by
  refine ⟨by limbs_eval fd_bn254_const_beta_mont, ?_⟩
  unfold beta; rw [← Nat.cast_ofNat]
  exact toF_eq_natCast (by limbs_eval fd_bn254_const_beta_mont)

/-! ## The curve `y² = x³ + 3` -/

/-- `-3` is not a cube: `(-3)^((p-1)/3) ≠ 1`. -/
public theorem neg_three_pow_ne_one : (-3 : ZMod p_bn254) ^ ((p_bn254 - 1) / 3) ≠ 1 := by
  unfold p_bn254
  reduce_mod_char
  decide

/-- `x³ + 3` has no root, so the curve has no point with `y = 0`. -/
public theorem cube_add_three_ne_zero (x : ZMod p_bn254) : x ^ 3 + 3 ≠ 0 := by
  intro h
  have hx : x ≠ 0 := by
    rintro rfl
    have : (3 : ZMod p_bn254) ≠ 0 := by
      unfold p_bn254; reduce_mod_char; decide
    exact this (by simpa using h)
  have h3 : x ^ 3 = -3 := by linear_combination h
  apply neg_three_pow_ne_one
  rw [← h3, ← pow_mul, Nat.mul_div_cancel' (by norm_num [p_bn254]), ZMod.pow_card_sub_one_eq_one hx]

/-- `3` is not a square, so the curve has no point with `x = 0`. -/
public theorem not_isSquare_three : ¬IsSquare (3 : ZMod p_bn254) := by
  rw [ZMod.euler_criterion _
      (by
        unfold p_bn254; reduce_mod_char; decide)]
  unfold p_bn254
  reduce_mod_char
  decide

public theorem sq_ne_three (y : ZMod p_bn254) : y ^ 2 ≠ 3 := fun h =>
  not_isSquare_three ⟨y, by rw [← h, sq]⟩

public theorem beta_sq_add : beta ^ 2 + beta + 1 = 0 := by
  unfold beta p_bn254
  reduce_mod_char

public theorem beta_cube : beta ^ 3 = 1 := by linear_combination (beta - 1) * beta_sq_add

public theorem beta_ne_one : beta ≠ 1 := by
  unfold beta p_bn254
  reduce_mod_char
  decide

public theorem beta_ne_zero : beta ≠ 0 := by
  unfold beta p_bn254
  reduce_mod_char
  decide

end Firedancer.Bn254
