module

public import Firedancer.Bn254.Math.Field
public import Firedancer.Bn254.Math.Mont
import Mathlib.Data.Nat.Bitwise
import Mathlib.FieldTheory.Finite.Basic
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.LinearCombination
import Mathlib.NumberTheory.LegendreSymbol.Basic
import Mathlib.Tactic.ReduceModChar
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! The `Fp` operations of `Field.lean` on canonical Montgomery inputs compute their `ZMod p`
values, discharging every fiat and s2n-bignum precondition. -/

namespace Firedancer.Bn254

/-! ## `fd_uint256.h` predicates -/

/-- `fd_uint256_bit` tests bit `i` of the value. -/
public theorem fd_uint256_bit.spec_ne_zero (b : fd_uint256_t) (i : ℕ) (h : i < 256) :
    fd_uint256_bit.spec b i h ≠ 0 ↔ (limbsEval b).testBit i := by
  have hk : i % 64 < 64 := Nat.mod_lt _ (by norm_num)
  have hq : i / 64 < 4 := by omega
  unfold fd_uint256_bit.spec
  rw [ne_eq, ← BitVec.toNat_inj, BitVec.toNat_and, BitVec.toNat_shiftLeft, bv_toNat_zero,
    BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by norm_num : 1 < 2 ^ 64), Nat.shiftLeft_eq, Nat.one_mul,
    Nat.mod_eq_of_lt (Nat.pow_lt_pow_right (by norm_num) hk), Nat.and_two_pow, ←
    limbsEval_div_mod b hq, Nat.testBit_mod_two_pow, Nat.testBit_div_two_pow]
  simp only [mul_eq_zero, Bool.toNat_eq_zero, Nat.pow_eq_zero, OfNat.ofNat_ne_zero, ne_eq,
    false_and, or_false, Bool.not_eq_false, hk, decide_true, Bool.true_and]
  rw [show i % 64 + 64 * (i / 64) = i by omega]

theorem or4_eq_zero (a b c d : BitVec 64) :
    (a ||| b ||| c ||| d) = 0 ↔ a = 0 ∧ b = 0 ∧ c = 0 ∧ d = 0 := by bv_decide

/-- `fd_uint256_is_zero` holds exactly on the value `0`. -/
public theorem fd_uint256_is_zero.spec_ne_zero (b : fd_uint256_t) :
    fd_uint256_is_zero.spec b ≠ 0 ↔ limbsEval b = 0 := by
  unfold fd_uint256_is_zero.spec
  rw [limbsEval_four]
  have := b[0].isLt; have := b[1].isLt; have := b[2].isLt; have := b[3].isLt
  by_cases h : (b[0] ||| b[1] ||| b[2] ||| b[3]) = 0
  · rw [ite_eq_left h]
    rw [or4_eq_zero] at h
    simp only [← BitVec.toNat_inj, bv_toNat_zero] at h
    simp only [ne_eq, show (1 : BitVec 32) ≠ 0 by decide, not_false_eq_true, true_iff]
    omega
  · rw [ite_eq_right h]
    rw [or4_eq_zero] at h
    simp only [← BitVec.toNat_inj, bv_toNat_zero] at h
    simp only [ne_eq, not_true_eq_false, false_iff]
    omega

/-! ## Multiplication -/

theorem two_pow_mul_inv : (2 : ZMod p_bn254) ^ 256 * ((2 : ZMod p_bn254) ^ 256)⁻¹ = 1 :=
  mul_inv_cancel₀ two_pow_ne_zero_p

/-- `fp_mul` on a canonical `a` (Pre (M)): canonical, with value `toF a · toF b`. -/
public theorem fd_bn254_fp_mul.tr_of {a : fd_bn254_fp_t} (ha : fpCanon a) (b : fd_bn254_fp_t) :
    Tr (fd_bn254_fp_mul.spec a b) (toF a * toF b) := by
  have h :=
    fd_uint256_mul_mod_p.spec_val a b fd_bn254_const_p fd_bn254_const_p_inv const_p_inv_spec
      (by
        rw [limbsEval_const_p]; exact p_bn254_lt)
      (by rwa [limbsEval_const_p])
  rw [limbsEval_const_p] at h
  refine ⟨h.1, ?_⟩
  unfold toF fd_bn254_fp_mul.spec
  linear_combination
    ((2 : ZMod p_bn254) ^ 256)⁻¹ ^ 2 * h.2 -
      (limbsEval (fd_uint256_mul_mod_p.spec a b fd_bn254_const_p fd_bn254_const_p_inv) :
          ZMod p_bn254) *
        ((2 : ZMod p_bn254) ^ 256)⁻¹ *
        two_pow_mul_inv

section Track

variable {a b : fd_bn254_fp_t} {u v : ZMod p_bn254}

public theorem fd_bn254_fp_mul.tr (ha : Tr a u) (hb : Tr b v) :
    Tr (fd_bn254_fp_mul.spec a b) (u * v) := by
  rw [← ha.2, ← hb.2]; exact fd_bn254_fp_mul.tr_of ha.1 b

public theorem fd_bn254_fp_sqr.tr (ha : Tr a u) : Tr (fd_bn254_fp_sqr.spec a) (u ^ 2) := by
  rw [sq]; exact fd_bn254_fp_mul.tr ha ha

theorem toF_const_rr : toF fd_bn254_const_rr = (2 : ZMod p_bn254) ^ 256 := by
  have := toF_eq_natCast (v := 2 ^ 256) (by rw [limbsEval_const_rr])
  rw [this]; push_cast; rfl

theorem toF_const_one : toF fd_bn254_const_one = ((2 : ZMod p_bn254) ^ 256)⁻¹ := by
  unfold toF; rw [limbsEval_const_one, Nat.cast_one, one_mul]

/-- `fp_to_mont` of a value `x < p` stands for `x`. -/
public theorem fd_bn254_fp_to_mont.tr {x : fd_bn254_fp_t} (hx : limbsEval x < p_bn254) :
    Tr (fd_bn254_fp_to_mont.spec x) (limbsEval x : ZMod p_bn254) := by
  have h := fd_bn254_fp_mul.tr_of hx fd_bn254_const_rr
  refine ⟨h.1, ?_⟩
  rw [fd_bn254_fp_to_mont.spec, h.2, toF_const_rr]
  unfold toF; rw [mul_assoc, inv_mul_cancel₀ two_pow_ne_zero_p, mul_one]

/-- `fp_from_mont` of a canonical `a` holds the residue `toF a` plainly. -/
public theorem fd_bn254_fp_from_mont.val (ha : Tr a u) :
    fpCanon (fd_bn254_fp_from_mont.spec a) ∧
      (limbsEval (fd_bn254_fp_from_mont.spec a) : ZMod p_bn254) = u := by
  have h := fd_bn254_fp_mul.tr_of ha.1 fd_bn254_const_one
  refine ⟨h.1, ?_⟩
  have h2 := h.2
  rw [toF_const_one, ha.2] at h2
  unfold toF at h2
  rw [fd_bn254_fp_from_mont.spec]
  have := mul_right_cancel₀ (inv_ne_zero two_pow_ne_zero_p) h2
  exact this

/-! ## fiat add, sub, opp -/

theorem natCast_emod_toNat (z : ℤ) :
    (((z % (p_bn254 : ℤ)).toNat : ℕ) : ZMod p_bn254) = (z : ZMod p_bn254) := by
  have h :=
    Int.emod_nonneg z
      (by
        have := p_bn254_pos; omega : (p_bn254 : ℤ) ≠ 0)
  rw [← Int.cast_natCast, Int.toNat_of_nonneg h, ZMod.intCast_mod]

theorem emod_toNat_lt (z : ℤ) : (z % (p_bn254 : ℤ)).toNat < p_bn254 := by
  have := p_bn254_pos
  have :=
    Int.emod_lt_of_pos z
      (by
        have := p_bn254_pos; omega : (0 : ℤ) < p_bn254)
  omega

theorem tr_limbsOfNat {n : ℕ} (hn : n < p_bn254) {w : ZMod p_bn254}
    (hw : (n : ZMod p_bn254) * ((2 : ZMod p_bn254) ^ 256)⁻¹ = w) : Tr (limbsOfNat 4 n) w := by
  have hlt : n < 2 ^ 256 := lt_trans hn (lt_trans p_bn254_lt (by norm_num))
  refine
    ⟨show limbsEval _ < _ by
        rw [limbsEval_limbsOfNat_of_lt hlt]; exact hn,
      ?_⟩
  unfold toF; rw [limbsEval_limbsOfNat_of_lt hlt, hw]

public theorem fd_bn254_fp_add.tr (ha : Tr a u) (hb : Tr b v) :
    Tr (fd_bn254_fp_add.spec a b) (u + v) := by
  unfold fd_bn254_fp_add.spec fiat_bn254_add.spec
  rw [fiat_bn254_m_eq, ite_eq_left ⟨ha.1, hb.1⟩]
  refine tr_limbsOfNat (Nat.mod_lt _ p_bn254_pos) ?_
  rw [← ha.2, ← hb.2, ZMod.natCast_mod]; unfold toF; push_cast; ring

public theorem fd_bn254_fp_sub.tr (ha : Tr a u) (hb : Tr b v) :
    Tr (fd_bn254_fp_sub.spec a b) (u - v) := by
  unfold fd_bn254_fp_sub.spec fiat_bn254_sub.spec
  rw [fiat_bn254_m_eq, ite_eq_left ⟨ha.1, hb.1⟩]
  refine tr_limbsOfNat (emod_toNat_lt _) ?_
  rw [← ha.2, ← hb.2, natCast_emod_toNat]; unfold toF; push_cast; ring

public theorem fd_bn254_fp_neg.tr (ha : Tr a u) : Tr (fd_bn254_fp_neg.spec a) (-u) := by
  unfold fd_bn254_fp_neg.spec fiat_bn254_opp.spec
  rw [fiat_bn254_m_eq, ite_eq_left ha.1]
  refine tr_limbsOfNat (emod_toNat_lt _) ?_
  rw [← ha.2, natCast_emod_toNat]; unfold toF; push_cast; ring

/-! ## Copies, constants, comparisons -/

public theorem fd_bn254_fp_set.spec_eq (a : fd_bn254_fp_t) : fd_bn254_fp_set.spec a = a :=
  (vec4_eta a).symm

public theorem fd_bn254_fp_set_one.spec_eq : fd_bn254_fp_set_one.spec = fd_bn254_const_one_mont :=
  rfl

public theorem fd_bn254_fp_set_one.tr : Tr fd_bn254_fp_set_one.spec 1 :=
  fd_bn254_fp_set_one.spec_eq ▸ fd_bn254_const_one_mont.tr

public theorem limbsEval_set_zero : limbsEval fd_bn254_fp_set_zero.spec = 0 := by
  simp [fd_bn254_fp_set_zero.spec, limbsEval_four]

public theorem fd_bn254_fp_set_zero.tr : Tr fd_bn254_fp_set_zero.spec 0 :=
  ⟨show limbsEval _ < _ by
      rw [limbsEval_set_zero]; exact p_bn254_pos,
    by
    unfold toF; rw [limbsEval_set_zero, Nat.cast_zero, zero_mul]⟩

/-- `fp_is_zero` tests for the value `0`. -/
public theorem fd_bn254_fp_is_zero.spec_ne_zero_iff (a : fd_bn254_fp_t) :
    fd_bn254_fp_is_zero.spec a ≠ 0 ↔ limbsEval a = 0 := by
  unfold fd_bn254_fp_is_zero.spec
  rw [limbsEval_four]
  have := a[0].isLt; have := a[1].isLt; have := a[2].isLt; have := a[3].isLt
  by_cases h : a[0] = 0 ∧ a[1] = 0 ∧ a[2] = 0 ∧ a[3] = 0
  · rw [ite_eq_left h]
    simp only [← BitVec.toNat_inj, bv_toNat_zero] at h
    simp only [ne_eq, show (1 : BitVec 32) ≠ 0 by decide, not_false_eq_true, true_iff]
    omega
  · rw [ite_eq_right h]
    simp only [← BitVec.toNat_inj, bv_toNat_zero] at h
    simp only [ne_eq, not_true_eq_false, false_iff]
    omega

public theorem fd_bn254_fp_is_zero.spec_iff (ha : Tr a u) :
    fd_bn254_fp_is_zero.spec a ≠ 0 ↔ u = 0 := by
  rw [fd_bn254_fp_is_zero.spec_ne_zero_iff, ← ha.2, toF_eq_zero_iff ha.1]

/-- `fp_eq` on canonical inputs compares values. -/
public theorem fd_bn254_fp_eq.spec_iff (ha : Tr a u) (hb : Tr b v) :
    fd_bn254_fp_eq.spec a b ≠ 0 ↔ u = v := by
  unfold fd_bn254_fp_eq.spec
  rw [fd_uint256_eq.spec_eq, ← ha.2, ← hb.2, toF_inj ha.1 hb.1]
  by_cases h : a = b
  · simp only [h, ↓reduceIte, ne_eq, show (1 : BitVec 32) ≠ 0 by decide, not_false_eq_true]
  · simp only [h, ↓reduceIte, ne_eq, not_true_eq_false]

public theorem fd_bn254_fp_is_one.spec_iff (ha : Tr a u) :
    fd_bn254_fp_is_one.spec a ≠ 0 ↔ u = 1 := by
  have h : fd_bn254_fp_is_one.spec a = fd_bn254_fp_eq.spec a fd_bn254_const_one_mont := rfl
  rw [h, fd_bn254_fp_eq.spec_iff ha fd_bn254_const_one_mont.tr]

/-! ## `fp_pow` -/

public theorem bit_val (B i : ℕ) : B % 2 ^ (i + 1) = B % 2 ^ i + 2 ^ i * (B / 2 ^ i % 2) :=
  Nat.mod_pow_succ

public theorem testBit_iff (B i : ℕ) : B.testBit i ↔ B / 2 ^ i % 2 = 1 := by
  rw [Nat.testBit_eq_decide_div_mod_eq, decide_eq_true_iff]

public theorem fd_bn254_fp_pow.step_tr (ha : Tr a u) (b r : fd_bn254_fp_t) (i : ℕ) (h : i < 256)
    (hr : Tr r v) :
    Tr (fd_bn254_fp_pow.step a b r i h) (v ^ 2 * u ^ (limbsEval b / 2 ^ i % 2)) := by
  unfold fd_bn254_fp_pow.step
  dsimp only
  have hs := fd_bn254_fp_sqr.tr hr
  split_ifs with hb
  · rw [fd_uint256_bit.spec_ne_zero, testBit_iff] at hb
    rw [hb, pow_one]; exact fd_bn254_fp_mul.tr hs ha
  · rw [fd_uint256_bit.spec_ne_zero, testBit_iff] at hb
    rw [show limbsEval b / 2 ^ i % 2 = 0 by omega, pow_zero, mul_one]; exact hs

public theorem fd_bn254_fp_pow.loop_tr (ha : Tr a u) (b : fd_bn254_fp_t) :
    ∀ (i : ℕ) (h : i < 256) (r : fd_bn254_fp_t) (v : ZMod p_bn254),
      Tr r v →
        Tr (fd_bn254_fp_pow.loop a b r i h) (v ^ 2 ^ (i + 1) * u ^ (limbsEval b % 2 ^ (i + 1)))
  | 0, h, r, v, hr => by
    unfold fd_bn254_fp_pow.loop
    have := fd_bn254_fp_pow.step_tr ha b r 0 h hr
    simpa only [pow_zero, Nat.div_one, zero_add, pow_one] using this
  | i + 1, h, r, v, hr => by
    unfold fd_bn254_fp_pow.loop
    have :=
      fd_bn254_fp_pow.loop_tr ha b i (by omega) _ _ (fd_bn254_fp_pow.step_tr ha b r (i + 1) h hr)
    convert this using 1
    rw [bit_val (limbsEval b) (i + 1)]
    ring

public theorem fd_bn254_fp_pow.scan_some (b : fd_uint256_t) :
    ∀ (i : ℕ) (h : i < 256) (j : Fin 256),
      fd_bn254_fp_pow.scan b i h = some j →
        limbsEval b % 2 ^ (i + 1) = limbsEval b % 2 ^ (j.val + 1)
  | 0, h, j, hj => by
    unfold fd_bn254_fp_pow.scan at hj
    split_ifs at hj; cases hj; rfl
  | i + 1, h, j, hj => by
    unfold fd_bn254_fp_pow.scan at hj
    split_ifs at hj with hb
    · cases hj; rfl
    · rw [fd_uint256_bit.spec_ne_zero, testBit_iff] at hb
      rw [bit_val, show limbsEval b / 2 ^ (i + 1) % 2 = 0 by omega, mul_zero, add_zero]
      exact fd_bn254_fp_pow.scan_some b i (by omega) j hj

public theorem fd_bn254_fp_pow.scan_none (b : fd_uint256_t) :
    ∀ (i : ℕ) (h : i < 256), fd_bn254_fp_pow.scan b i h = none → limbsEval b % 2 ^ (i + 1) = 0
  | 0, h, hj => by
    unfold fd_bn254_fp_pow.scan at hj
    split_ifs at hj with hb
    rw [fd_uint256_bit.spec_ne_zero, testBit_iff] at hb
    rw [bit_val]; simp only [pow_zero, Nat.mod_one, Nat.div_one, one_mul, zero_add]; omega
  | i + 1, h, hj => by
    unfold fd_bn254_fp_pow.scan at hj
    split_ifs at hj with hb
    rw [fd_uint256_bit.spec_ne_zero, testBit_iff] at hb
    rw [bit_val, show limbsEval b / 2 ^ (i + 1) % 2 = 0 by omega, mul_zero, add_zero]
    exact fd_bn254_fp_pow.scan_none b i (by omega) hj

/-- `fp_pow( r, a, b )` computes `u ^ b`. -/
public theorem fd_bn254_fp_pow.tr (ha : Tr a u) (b : fd_uint256_t) :
    Tr (fd_bn254_fp_pow.spec a b) (u ^ limbsEval b) := by
  have hB := limbsEval_lt b
  unfold fd_bn254_fp_pow.spec
  dsimp only
  split_ifs with hz
  · rw [fd_uint256_is_zero.spec_ne_zero] at hz
    rw [hz, pow_zero]; exact fd_bn254_fp_set_one.tr
  · rw [fd_uint256_is_zero.spec_ne_zero] at hz
    split
    · rename_i hs
      have := fd_bn254_fp_pow.scan_none b 255 (by omega) hs
      rw [Nat.mod_eq_of_lt hB] at this
      exact absurd this hz
    · rename_i j hs
      have e := fd_bn254_fp_pow.scan_some b 255 (by omega) j hs
      rw [Nat.mod_eq_of_lt hB] at e
      have := fd_bn254_fp_pow.loop_tr ha b j.val j.isLt _ _ fd_bn254_fp_set_one.tr
      rwa [one_pow, one_mul, ← e] at this

/-! ## `fp_inv` -/

/-- Fermat's inverse, `0` at `0`. -/
theorem pow_sub_two_eq_inv (x : ZMod p_bn254) : x ^ (p_bn254 - 2) = x⁻¹ := by
  rcases eq_or_ne x 0 with rfl | hx
  · rw [inv_zero, zero_pow (by norm_num [p_bn254])]
  · apply eq_inv_of_mul_eq_one_left
    rw [← pow_succ, show p_bn254 - 2 + 1 = p_bn254 - 1 by norm_num [p_bn254],
      ZMod.pow_card_sub_one_eq_one hx]

theorem limbsEval_p_minus_2 :
    limbsEval
        ((fd_bn254_fp_set.spec fd_bn254_const_p).set 0
          ((fd_bn254_fp_set.spec fd_bn254_const_p)[0] - 2)) =
      p_bn254 - 2 := by
  simp [limbsEval_four, fd_bn254_fp_set.spec, fd_bn254_const_p, p_bn254]

/-- The portable `fp_inv` (`fp_pow( a, p-2 )`) inverts, `0` at `0`. -/
public theorem fd_bn254_fp_inv.spec_tr (ha : Tr a u) : Tr (fd_bn254_fp_inv.spec a) u⁻¹ := by
  unfold fd_bn254_fp_inv.spec
  dsimp only
  have :=
    fd_bn254_fp_pow.tr ha
      ((fd_bn254_fp_set.spec fd_bn254_const_p).set 0
        ((fd_bn254_fp_set.spec fd_bn254_const_p)[0] - 2))
  rwa [limbsEval_p_minus_2, pow_sub_two_eq_inv] at this

/-- The s2n `fp_inv` inverts a nonzero element; `bignum_modinv`'s `gcd = 1` holds since `0 < a < p`. -/
public theorem fd_bn254_fp_inv.s2n_tr (ha : Tr a u) (hu : u ≠ 0) :
    Tr (fd_bn254_fp_inv.s2n a) u⁻¹ := by
  have hA0 : limbsEval a ≠ 0 := fun h =>
    hu
      (by
        rw [← ha.2, toF_eq_zero_iff ha.1]; exact h)
  have hcop : Nat.Coprime (limbsEval a) p_bn254 :=
    Nat.coprime_comm.1
      ((Nat.Prime.coprime_iff_not_dvd prime_p_bn254).2 fun hd =>
        hA0 (Nat.eq_zero_of_dvd_of_lt hd ha.1))
  have hpre :
    Nat.gcd (limbsEval a) (limbsEval fd_bn254_const_p) = 1 ∧
      limbsEval fd_bn254_const_p % 2 = 1 ∧
      limbsEval fd_bn254_const_p ≠ 1 ∧
      3 * (4 : BitVec 64).toNat ≤ 12 ∧ (4 : BitVec 64).toNat < 2 ^ 57 ∧ false = false := by
    rw [limbsEval_const_p]
    exact ⟨hcop, by norm_num [p_bn254], by norm_num [p_bn254], by decide, by decide, rfl⟩
  unfold fd_bn254_fp_inv.s2n bignum_modinv.spec
  rw [ite_eq_left hpre, limbsEval_const_p]
  dsimp only
  have hz : invMod (limbsEval a) p_bn254 < p_bn254 := invMod_lt p_bn254_pos
  have hz' : invMod (limbsEval a) p_bn254 < 2 ^ 256 :=
    lt_trans hz (lt_trans p_bn254_lt (by norm_num))
  have h1 :=
    fd_bn254_fp_to_mont.tr (x := limbsOfNat 4 (invMod (limbsEval a) p_bn254))
      (by
        rw [limbsEval_limbsOfNat_of_lt hz']; exact hz)
  have h2 := fd_bn254_fp_mul.tr_of h1.1 fd_bn254_const_rr
  refine ⟨h2.1, ?_⟩
  show
    toF
        (fd_bn254_fp_mul.spec
          (fd_bn254_fp_to_mont.spec (limbsOfNat 4 (invMod (limbsEval a) p_bn254)))
          fd_bn254_const_rr) =
      u⁻¹
  rw [h2.2, h1.2, toF_const_rr, limbsEval_limbsOfNat_of_lt hz', ← ha.2]
  have hinv := natCast_mul_invMod p_bn254_pos hcop
  unfold toF
  rw [mul_inv, inv_inv]
  have hA : (limbsEval a : ZMod p_bn254) ≠ 0 := by
    rw [Ne, ZMod.natCast_eq_zero_iff]; exact fun hd => hA0 (Nat.eq_zero_of_dvd_of_lt hd ha.1)
  field_simp
  linear_combination (2 : ZMod p_bn254) ^ 256 * hinv

/-- A backend whose `fp_inv` inverts nonzero canonical elements. -/
@[expose]
public def Backend.Spec (B : Backend) : Prop :=
  ∀ (a : fd_bn254_fp_t) (u : ZMod p_bn254), Tr a u → u ≠ 0 → Tr (B.fp_inv a) u⁻¹

theorem Backend.s2n_fp_inv : Backend.s2n.fp_inv = fd_bn254_fp_inv.s2n := by simp only [Backend.s2n]

theorem Backend.ref_fp_inv : Backend.ref.fp_inv = fd_bn254_fp_inv.spec := by simp only [Backend.ref]

public theorem Backend.s2n_spec : Backend.s2n.Spec := by
  intro a u ha hu; rw [Backend.s2n_fp_inv]; exact fd_bn254_fp_inv.s2n_tr ha hu

public theorem Backend.ref_spec : Backend.ref.Spec := by
  intro a u ha _; rw [Backend.ref_fp_inv]; exact fd_bn254_fp_inv.spec_tr ha

/-! ## `fp_sqrt` -/

theorem limbsEval_sqrt_exp : limbsEval fd_bn254_const_sqrt_exp * 2 + 1 = p_bn254 / 2 := by
  simp [limbsEval_four, fd_bn254_const_sqrt_exp, p_bn254]

theorem neg_one_ne_one_p : (-1 : ZMod p_bn254) ≠ 1 := by
  unfold p_bn254; reduce_mod_char; decide

theorem neg_one_ne_zero_p : (-1 : ZMod p_bn254) ≠ 0 := by
  unfold p_bn254; reduce_mod_char; decide

/-- `fp_sqrt` fails exactly on non-squares; on success it stores a square root at `r`. -/
public theorem fd_bn254_fp_sqrt.tr (ha : Tr a u) (r : fd_bn254_fp_t) :
    ((fd_bn254_fp_sqrt.spec r a).ret = none ↔ ¬IsSquare u) ∧
      ∀ y,
        (fd_bn254_fp_sqrt.spec r a).ret = some y →
          (fd_bn254_fp_sqrt.spec r a).r = y ∧ ∃ w, Tr y w ∧ w ^ 2 = u := by
  have h1 := fd_bn254_fp_pow.tr ha fd_bn254_const_sqrt_exp
  have h0 := fd_bn254_fp_mul.tr (fd_bn254_fp_sqr.tr h1) ha
  have hE := limbsEval_sqrt_exp
  have hpow : (u ^ limbsEval fd_bn254_const_sqrt_exp) ^ 2 * u = u ^ (p_bn254 / 2) := by
    rw [← pow_mul, ← pow_succ, ← hE]
  rw [fd_bn254_fp_sqrt.spec]
  dsimp only
  split_ifs with he <;> dsimp only
  · rw [fd_bn254_fp_eq.spec_iff h0 fd_bn254_const_p_minus_one_mont.tr, hpow] at he
    refine ⟨iff_of_true rfl ?_, fun y hy => by simp at hy⟩
    have hu : u ≠ 0 := by
      rintro rfl
      rw [zero_pow (by norm_num [p_bn254])] at he
      exact neg_one_ne_zero_p he.symm
    rw [ZMod.euler_criterion _ hu, he]
    exact neg_one_ne_one_p
  · rw [fd_bn254_fp_eq.spec_iff h0 fd_bn254_const_p_minus_one_mont.tr, hpow] at he
    have hw := fd_bn254_fp_mul.tr h1 ha
    have hsq : (u ^ limbsEval fd_bn254_const_sqrt_exp * u) ^ 2 = u := by
      rcases eq_or_ne u 0 with rfl | hu
      · simp
      · have := (ZMod.pow_div_two_eq_neg_one_or_one _ hu).resolve_right he
        calc
          (u ^ limbsEval fd_bn254_const_sqrt_exp * u) ^ 2 =
              (u ^ limbsEval fd_bn254_const_sqrt_exp) ^ 2 * u * u :=
            by ring
          _ = u := by rw [hpow, this, one_mul]
    refine ⟨iff_of_false not_false (fun h => h ⟨_, by rw [← hsq, sq]⟩), fun y hy => ?_⟩
    rw [Option.some.injEq] at hy
    subst hy
    exact ⟨rfl, _, hw, hsq⟩

end Track

end Firedancer.Bn254
