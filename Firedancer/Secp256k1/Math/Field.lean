module

public import Ed25519.Field
public import Firedancer.Secp256k1.Math.Mont
public import Firedancer.Secp256k1.Private
public import Firedancer.Secp256k1.S2n
import Mathlib.NumberTheory.LegendreSymbol.Basic
import Mathlib.NumberTheory.LucasPrimality
import Mathlib.Tactic.NormNum.Prime
import Mathlib.Tactic.ReduceModChar

/-! The field `ZMod p_256k1`: `p` is prime, the Montgomery value map of `fp_t`, the constants, and
the curve facts `y² = x³ + 7` needs. -/

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

/-! ## `p` is prime -/

section Prime

theorem prime_13331831 : Nat.Prime 13331831 := by
  pratt 13 [(2, 1), (5, 1), (971, 1), (1373, 1)] []

theorem prime_173378833005251801 : Nat.Prime 173378833005251801 := by
  pratt 6 [(2, 3), (5, 2), (2621, 1), (24809, 1), (13331831, 1)] [prime_13331831]

theorem prime_22149492674086928081353 : Nat.Prime 22149492674086928081353 := by
  pratt 5 [(2, 3), (3, 1), (5323, 1), (173378833005251801, 1)] [prime_173378833005251801]

theorem prime_132896956044521568488119 : Nat.Prime 132896956044521568488119 := by
  pratt 6 [(2, 1), (3, 1), (22149492674086928081353, 1)] [prime_22149492674086928081353]

theorem prime_1206781 : Nat.Prime 1206781 := by
  pratt 10 [(2, 2), (3, 1), (5, 1), (20113, 1)] []

theorem prime_7240687 : Nat.Prime 7240687 := by
  pratt 3 [(2, 1), (3, 1), (1206781, 1)] [prime_1206781]

theorem prime_107590001 : Nat.Prime 107590001 := by
  pratt 3 [(2, 4), (5, 4), (7, 1), (29, 1), (53, 1)] []

theorem prime_255515944373312847190720520512484175977 :
    Nat.Prime 255515944373312847190720520512484175977 := by
  pratt 3
    [(2, 3), (7, 2), (11, 1), (1627, 1), (2657, 1), (4423, 1), (41201, 1), (96557, 1),
      (7240687, 1), (107590001, 1)]
    [prime_7240687, prime_107590001]

theorem prime_205115282021455665897114700593932402728804164701536103180137503955397371 :
    Nat.Prime 205115282021455665897114700593932402728804164701536103180137503955397371 := by
  pratt 10
    [(2, 1), (3, 1), (5, 1), (29, 2), (31, 1), (7723, 1), (132896956044521568488119, 1),
      (255515944373312847190720520512484175977, 1)]
    [prime_132896956044521568488119, prime_255515944373312847190720520512484175977]

public theorem p_256k1_eq :
    p_256k1 = 115792089237316195423570985008687907853269984665640564039457584007908834671663 := by
  norm_num [p_256k1]

public theorem prime_p_256k1 : p_256k1.Prime := by
  rw [p_256k1_eq]
  pratt 3
    [(2, 1), (3, 1), (7, 1), (13441, 1),
      (205115282021455665897114700593932402728804164701536103180137503955397371, 1)]
    [prime_205115282021455665897114700593932402728804164701536103180137503955397371]

public instance fact_prime_p_256k1 : Fact p_256k1.Prime :=
  ⟨prime_p_256k1⟩

end Prime

/-! ## Stored elements -/

@[expose] public section

/-- A stored field element is canonical: its value is below `p`. -/
abbrev fpCanon (a : fd_secp256k1_fp_t) : Prop :=
  limbsEval a < p_256k1

/-- The field element a Montgomery-form `fp_t` stores, `a · 2⁻²⁵⁶`. -/
abbrev toF (a : fd_secp256k1_fp_t) : ZMod p_256k1 :=
  montVal p_256k1 a

/-- The base point's affine `x` (SEC 2). -/
def Gx : ZMod p_256k1 :=
  0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798

/-- The base point's affine `y` (SEC 2). -/
def Gy : ZMod p_256k1 :=
  0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8

end

public theorem p_256k1_lt : p_256k1 < 2 ^ 256 := by norm_num [p_256k1]

public theorem p_256k1_pos : 0 < p_256k1 := by norm_num [p_256k1]

public theorem two_ne_zero_p : (2 : ZMod p_256k1) ≠ 0 := by
  unfold p_256k1
  reduce_mod_char
  decide

public theorem fiat_secp256k1_montgomery_m_eq : fiat_secp256k1_montgomery_m = p_256k1 := by
  norm_num [fiat_secp256k1_montgomery_m, p_256k1]

/-- A stored value whose limbs are `v · 2^256` mod `p` stands for `v`. -/
public theorem toF_eq_natCast {a : fd_secp256k1_fp_t} {v : ℕ}
    (h : limbsEval a % p_256k1 = v * 2 ^ 256 % p_256k1) : toF a = v := by
  unfold toF montVal
  rw [(ZMod.natCast_eq_natCast_iff' _ _ _).2 h, Nat.cast_mul, Nat.cast_pow, Nat.cast_ofNat,
    mul_assoc, mul_inv_cancel₀ (pow_ne_zero _ two_ne_zero_p), mul_one]

/-! ## Constants -/

/-- Evaluates `limbsEval` of the constant `c` and closes the arithmetic. -/
local macro "limbs_eval " c:ident ns:ident* : tactic =>
  `(tactic| simp [limbsEval_four, $c:ident, p_256k1, $[$ns:ident],*])

public theorem limbsEval_const_p : limbsEval fd_secp256k1_const_p = p_256k1 := by
  limbs_eval fd_secp256k1_const_p

public theorem limbsEval_const_p_m2 : limbsEval Ref.fd_secp256k1_const_p_m2 = p_256k1 - 2 := by
  limbs_eval Ref.fd_secp256k1_const_p_m2

public theorem fd_secp256k1_const_zero.fp :
    fpCanon fd_secp256k1_const_zero ∧ toF fd_secp256k1_const_zero = 0 :=
  ⟨by limbs_eval fd_secp256k1_const_zero, by
    rw [← Nat.cast_zero]; exact toF_eq_natCast (by limbs_eval fd_secp256k1_const_zero)⟩

public theorem fd_secp256k1_const_one_mont.fp :
    fpCanon fd_secp256k1_const_one_mont ∧ toF fd_secp256k1_const_one_mont = 1 :=
  ⟨by limbs_eval fd_secp256k1_const_one_mont, by
    rw [← Nat.cast_one]; exact toF_eq_natCast (by limbs_eval fd_secp256k1_const_one_mont)⟩

public theorem fd_secp256k1_const_b_mont.fp :
    fpCanon fd_secp256k1_const_b_mont ∧ toF fd_secp256k1_const_b_mont = 7 :=
  ⟨by limbs_eval fd_secp256k1_const_b_mont, by
    rw [← Nat.cast_ofNat]; exact toF_eq_natCast (by limbs_eval fd_secp256k1_const_b_mont)⟩

public theorem fd_secp256k1_const_n_mont.fp :
    fpCanon fd_secp256k1_const_n_mont ∧ toF fd_secp256k1_const_n_mont = (n_256k1 : ZMod p_256k1) :=
  ⟨by limbs_eval fd_secp256k1_const_n_mont,
    toF_eq_natCast (by limbs_eval fd_secp256k1_const_n_mont n_256k1)⟩

public theorem fd_secp256k1_const_base_x_mont.fp :
    fpCanon fd_secp256k1_const_base_x_mont ∧ toF fd_secp256k1_const_base_x_mont = Gx :=
  ⟨by limbs_eval fd_secp256k1_const_base_x_mont, by
    unfold Gx; rw [← Nat.cast_ofNat]
    exact toF_eq_natCast (by limbs_eval fd_secp256k1_const_base_x_mont)⟩

public theorem fd_secp256k1_const_base_y_mont.fp :
    fpCanon fd_secp256k1_const_base_y_mont ∧ toF fd_secp256k1_const_base_y_mont = Gy :=
  ⟨by limbs_eval fd_secp256k1_const_base_y_mont, by
    unfold Gy; rw [← Nat.cast_ofNat]
    exact toF_eq_natCast (by limbs_eval fd_secp256k1_const_base_y_mont)⟩

public theorem fiat_secp256k1_montgomery_set_one.fp :
    fpCanon fiat_secp256k1_montgomery_set_one.spec ∧
      toF fiat_secp256k1_montgomery_set_one.spec = 1 := by
  have h : limbsEval fiat_secp256k1_montgomery_set_one.spec = 2 ^ 256 % p_256k1 := by
    rw [fiat_secp256k1_montgomery_set_one.spec, limbsEval_limbsOfNat,
      fiat_secp256k1_montgomery_m_eq]
    exact Nat.mod_eq_of_lt (lt_trans (Nat.mod_lt _ p_256k1_pos) p_256k1_lt)
  exact
    ⟨show limbsEval _ < _ by
        rw [h]; exact Nat.mod_lt _ p_256k1_pos,
      by
      rw [← Nat.cast_one];
      exact
        toF_eq_natCast
          (by
            rw [h]; simp)⟩

/-! ## The curve `y² = x³ + 7` -/

/-- The base point is on the curve. -/
public theorem Gy_sq : Gy ^ 2 = Gx ^ 3 + 7 := by
  unfold Gx Gy p_256k1
  reduce_mod_char

/-- The stored base point is on the curve. -/
public theorem base_mont_on_curve :
    toF fd_secp256k1_const_base_y_mont ^ 2 = toF fd_secp256k1_const_base_x_mont ^ 3 + 7 := by
  rw [fd_secp256k1_const_base_x_mont.fp.2, fd_secp256k1_const_base_y_mont.fp.2, Gy_sq]

/-- `-7` is not a cube: `(-7)^((p-1)/3) ≠ 1`. -/
public theorem neg_seven_pow_ne_one : (-7 : ZMod p_256k1) ^ ((p_256k1 - 1) / 3) ≠ 1 := by
  unfold p_256k1
  reduce_mod_char
  decide

/-- `x³ + 7` has no root, so the curve has no point with `y = 0`. -/
public theorem cube_add_seven_ne_zero (x : ZMod p_256k1) : x ^ 3 + 7 ≠ 0 := by
  intro h
  have hx : x ≠ 0 := by
    rintro rfl
    have : (7 : ZMod p_256k1) ≠ 0 := by
      unfold p_256k1; reduce_mod_char; decide
    exact this (by simpa using h)
  have h3 : x ^ 3 = -7 := by linear_combination h
  apply neg_seven_pow_ne_one
  rw [← h3, ← pow_mul, Nat.mul_div_cancel' (by norm_num [p_256k1]), ZMod.pow_card_sub_one_eq_one hx]

/-- `7` is not a square, so the curve has no point with `x = 0`. -/
public theorem not_isSquare_seven : ¬IsSquare (7 : ZMod p_256k1) := by
  rw [ZMod.euler_criterion _
      (by
        unfold p_256k1; reduce_mod_char; decide)]
  unfold p_256k1
  reduce_mod_char
  decide

end Firedancer.Secp256k1
