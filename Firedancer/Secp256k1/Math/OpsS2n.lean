module

public import Firedancer.Secp256k1.BackendS2n
public import Firedancer.Secp256k1.Math.Ops
import Mathlib.Tactic.Ring

/-! The s2n-bignum backend meets `Backend.Spec`, with and without `__ADX__`: every library
precondition holds at its call. -/

namespace Firedancer.Secp256k1.S2n

variable {a b : fd_secp256k1_fp_t}

/-! ## Field -/

public theorem fd_secp256k1_fp_add.spec_val (ha : fpCanon a) (hb : fpCanon b) :
    fpCanon (fd_secp256k1_fp_add.spec a b) ∧
      toF (fd_secp256k1_fp_add.spec a b) = toF a + toF b := by
  rw [fd_secp256k1_fp_add.spec, bignum_add_p256k1.spec, ite_eq_left ⟨ha, hb⟩]
  refine ⟨(fp_out _).1, ?_⟩
  rw [(fp_out _).2, toF, toF, montVal, montVal]; push_cast; ring

public theorem fd_secp256k1_fp_sub.spec_val (ha : fpCanon a) (hb : fpCanon b) :
    fpCanon (fd_secp256k1_fp_sub.spec a b) ∧
      toF (fd_secp256k1_fp_sub.spec a b) = toF a - toF b := by
  rw [fd_secp256k1_fp_sub.spec, bignum_sub_p256k1.spec, ite_eq_left ⟨ha, hb⟩]
  refine ⟨(fp_out_int _).1, ?_⟩
  rw [(fp_out_int _).2, toF, toF, montVal, montVal]; push_cast; ring

public theorem fd_secp256k1_fp_dbl.spec_val (ha : fpCanon a) :
    fpCanon (fd_secp256k1_fp_dbl.spec a) ∧ toF (fd_secp256k1_fp_dbl.spec a) = 2 * toF a := by
  rw [fd_secp256k1_fp_dbl.spec, bignum_double_p256k1.spec, ite_eq_left ha]
  refine ⟨(fp_out _).1, ?_⟩
  rw [(fp_out _).2, toF, montVal]; push_cast; ring

/-- No precondition. -/
public theorem fd_secp256k1_fp_triple.spec_val (adx : Bool) (a : fd_secp256k1_fp_t) :
    fpCanon (fd_secp256k1_fp_triple.spec adx a) ∧
      toF (fd_secp256k1_fp_triple.spec adx a) = 3 * toF a := by
  have h : fd_secp256k1_fp_triple.spec adx a = limbsOfNat 4 ((3 * limbsEval a) % p_256k1) := by
    cases adx <;> rfl
  rw [h]
  refine ⟨(fp_out _).1, ?_⟩
  rw [(fp_out _).2, toF, montVal]; push_cast; ring

public theorem fd_secp256k1_fp_mul.spec_val (adx : Bool) (ha : fpCanon a) (hb : fpCanon b) :
    fpCanon (fd_secp256k1_fp_mul.spec adx a b) ∧
      toF (fd_secp256k1_fp_mul.spec adx a b) = toF a * toF b := by
  have hpre := mul_le_R_mul p_256k1_lt.le ha hb
  have h :
    fd_secp256k1_fp_mul.spec adx a b =
      limbsOfNat 4 ((limbsEval a * limbsEval b * invMod (2 ^ 256) p_256k1) % p_256k1) := by
    cases adx
    · exact ite_eq_left hpre
    · exact ite_eq_left hpre
  rw [h]
  refine ⟨(fp_out _).1, ?_⟩
  rw [(fp_out _).2, toF, toF, montVal, montVal]; simp only [Nat.cast_mul, natCast_invMod_R_p]; ring

public theorem fd_secp256k1_fp_sqr.spec_val (adx : Bool) (ha : fpCanon a) :
    fpCanon (fd_secp256k1_fp_sqr.spec adx a) ∧
      toF (fd_secp256k1_fp_sqr.spec adx a) = toF a ^ 2 := by
  have hpre : limbsEval a ^ 2 ≤ 2 ^ 256 * p_256k1 := by
    rw [sq]; exact mul_le_R_mul p_256k1_lt.le ha ha
  have h :
    fd_secp256k1_fp_sqr.spec adx a =
      limbsOfNat 4 ((limbsEval a ^ 2 * invMod (2 ^ 256) p_256k1) % p_256k1) := by
    cases adx
    · exact ite_eq_left hpre
    · exact ite_eq_left hpre
  rw [h]
  refine ⟨(fp_out _).1, ?_⟩
  rw [(fp_out _).2, toF, montVal]; simp only [Nat.cast_mul, Nat.cast_pow, natCast_invMod_R_p]; ring

public theorem fd_secp256k1_fp_negate.spec_val (ha : fpCanon a) :
    fpCanon (fd_secp256k1_fp_negate.spec a) ∧ toF (fd_secp256k1_fp_negate.spec a) = -toF a := by
  rw [fd_secp256k1_fp_negate.spec, bignum_neg_p256k1.spec, ite_eq_left ha]
  refine ⟨(fp_out_int _).1, ?_⟩
  rw [(fp_out_int _).2, toF, montVal]; push_cast; ring

/-- No precondition: `tomont` of any 256-bit value. -/
public theorem fd_secp256k1_fp_tomont.spec_val (adx : Bool) (a : fd_secp256k1_fp_t) :
    fpCanon (fd_secp256k1_fp_tomont.spec adx a) ∧
      toF (fd_secp256k1_fp_tomont.spec adx a) = (limbsEval a : ZMod p_256k1) := by
  have h :
    fd_secp256k1_fp_tomont.spec adx a = limbsOfNat 4 ((2 ^ 256 * limbsEval a) % p_256k1) := by
    cases adx <;> rfl
  rw [h]
  refine ⟨(fp_out _).1, ?_⟩
  rw [(fp_out _).2, Nat.cast_mul, Nat.cast_pow, Nat.cast_ofNat, mul_comm, ← mul_assoc,
    inv_mul_cancel₀ (pow_ne_zero _ two_ne_zero_p), one_mul]

/-- `bignum_demont_p256k1` of a canonical value. -/
theorem demont_eq (ha : fpCanon a) :
    bignum_demont_p256k1.spec a =
      limbsOfNat 4 ((limbsEval a * invMod (2 ^ 256) p_256k1) % p_256k1) :=
  ite_eq_left ha

public theorem fd_secp256k1_fp_is_odd.spec_val (ha : fpCanon a) :
    fd_secp256k1_fp_is_odd.spec a = if (toF a).val % 2 = 1 then 1#32 else 0#32 := by
  rw [fd_secp256k1_fp_is_odd.spec, demont_eq ha, is_odd_limbsOfNat, toF_val natCast_invMod_R_p]

public theorem fd_secp256k1_fp_tobytes.spec_val (ha : fpCanon a) :
    beNat (fd_secp256k1_fp_tobytes.spec a) = (toF a).val := by
  rw [fd_secp256k1_fp_tobytes.spec, demont_eq ha, beNat_bswap_buf, limbsEval_mod_p,
    toF_val natCast_invMod_R_p]

/-- `bignum_modinv` needs `gcd(a, p) = 1`, so `toF a ≠ 0`; at `0` it is unspecified (unlike
ref). -/
public theorem fd_secp256k1_fp_invert.spec_val (adx : Bool) (ha : fpCanon a) (h0 : toF a ≠ 0) :
    fpCanon (fd_secp256k1_fp_invert.spec adx a) ∧
      toF (fd_secp256k1_fp_invert.spec adx a) = (toF a)⁻¹ := by
  set d := (limbsEval a * invMod (2 ^ 256) p_256k1) % p_256k1 with hd
  have hdF : (d : ZMod p_256k1) = toF a := by
    rw [hd, ZMod.natCast_mod, toF, montVal, Nat.cast_mul, natCast_invMod_R_p]
  have hcop : Nat.Coprime d p_256k1 :=
    Nat.coprime_comm.1
      ((Nat.Prime.coprime_iff_not_dvd prime_p_256k1).2 fun hdv =>
        h0 (hdF ▸ (ZMod.natCast_eq_zero_iff d p_256k1).2 hdv))
  have hinv :
    bignum_modinv.spec 4 (bignum_demont_p256k1.spec a) fd_secp256k1_const_p 12 false =
      limbsOfNat 4 (invMod d p_256k1) := by
    rw [bignum_modinv.spec, ite_eq_left]
    · rw [demont_eq ha, ← hd, limbsEval_mod_p, ← hd, limbsEval_const_p]; rfl
    · rw [demont_eq ha, ← hd, limbsEval_mod_p, ← hd, limbsEval_const_p]
      exact ⟨by norm_num [p_256k1], by norm_num [p_256k1], hcop, by decide, by decide, rfl⟩
  have hr : limbsEval (limbsOfNat 4 (invMod d p_256k1)) = invMod d p_256k1 :=
    limbsEval_limbsOfNat_of_lt ((invMod_lt p_256k1_pos).trans p_256k1_lt)
  obtain ⟨c, v⟩ := fd_secp256k1_fp_tomont.spec_val adx (limbsOfNat 4 (invMod d p_256k1))
  have e :
    fd_secp256k1_fp_invert.spec adx a =
      fd_secp256k1_fp_tomont.spec adx (limbsOfNat 4 (invMod d p_256k1)) := by
    rw [fd_secp256k1_fp_invert.spec, hinv]; rfl
  rw [e]
  refine ⟨c, ?_⟩
  rw [v, hr,
    natCast_invMod_eq_inv
      (by
        rw [hdF]; exact h0),
    hdF]

public theorem fd_secp256k1_fp_eq.spec_val (ha : fpCanon a) (hb : fpCanon b) :
    fd_secp256k1_fp_eq.spec a b = if toF a = toF b then 1#32 else 0#32 :=
  fp_eq_val ha hb

/-! ## Scalars -/

variable {s t : fd_secp256k1_scalar_t}

public theorem fd_secp256k1_scalar_frombytes.spec_r (input : Vector (BitVec 8) 32) :
    (fd_secp256k1_scalar_frombytes.spec input).r =
      fd_uint256_bswap.spec (fd_uint256_t.ofBuf input) := by
  unfold fd_secp256k1_scalar_frombytes.spec
  dsimp only
  split_ifs <;> rfl

public theorem fd_secp256k1_scalar_frombytes.spec_ret (input : Vector (BitVec 8) 32) :
    (fd_secp256k1_scalar_frombytes.spec input).ret =
      if 0 < beNat input ∧ beNat input < n_256k1 then
        some (fd_secp256k1_scalar_frombytes.spec input).r
      else none := by
  rw [fd_secp256k1_scalar_frombytes.spec_r]
  exact frombytes_ret_eq input

/-- A full reduction mod `n` of any 256-bit value. -/
public theorem fd_secp256k1_scalar_reduce.spec_val (s : fd_secp256k1_scalar_t) :
    limbsEval (fd_secp256k1_scalar_reduce.spec s) = limbsEval s % n_256k1 := by
  rw [fd_secp256k1_scalar_reduce.spec, bignum_mod_n256k1_4.spec, limbsEval_mod_n]

/-- `bignum_modinv` needs `gcd(s, n) = 1`, so `toS s ≠ 0`; at `0` it is unspecified. -/
public theorem fd_secp256k1_scalar_invert.spec_val (h0 : toS s ≠ 0) :
    scCanon (fd_secp256k1_scalar_invert.spec s) ∧
      toS (fd_secp256k1_scalar_invert.spec s) = (toS s)⁻¹ := by
  have hcop : Nat.Coprime (limbsEval s) n_256k1 :=
    Nat.coprime_comm.1
      ((Nat.Prime.coprime_iff_not_dvd prime_n_256k1).2 fun hdv =>
        h0 ((ZMod.natCast_eq_zero_iff _ n_256k1).2 hdv))
  have h : fd_secp256k1_scalar_invert.spec s = limbsOfNat 4 (invMod (limbsEval s) n_256k1) := by
    rw [fd_secp256k1_scalar_invert.spec, bignum_modinv.spec, ite_eq_left]
    · rw [limbsEval_const_n]; rfl
    · rw [limbsEval_const_n]
      exact ⟨by norm_num [n_256k1], by norm_num [n_256k1], hcop, by decide, by decide, rfl⟩
  have hr :=
    limbsEval_limbsOfNat_of_lt ((invMod_lt (a := limbsEval s) n_256k1_pos).trans n_256k1_lt)
  rw [h]
  exact
    ⟨by
      rw [scCanon, hr]; exact invMod_lt n_256k1_pos, by rw [toS, hr, natCast_invMod_eq_inv h0]⟩

public theorem fd_secp256k1_scalar_mul.spec_val (hs : scCanon s) (ht : scCanon t) :
    scCanon (fd_secp256k1_scalar_mul.spec s t) ∧
      toSM (fd_secp256k1_scalar_mul.spec s t) = toSM s * toSM t := by
  have h :
    fd_secp256k1_scalar_mul.spec s t =
      limbsOfNat 4 ((limbsEval s * limbsEval t * invMod (2 ^ 256) n_256k1) % n_256k1) := by
    rw [fd_secp256k1_scalar_mul.spec, bignum_montmul.spec, ite_eq_left]
    · rw [limbsEval_const_n]; rfl
    · rw [limbsEval_const_n]
      exact ⟨mul_le_R_mul n_256k1_lt.le hs ht, by norm_num [n_256k1], rfl⟩
  rw [h]
  refine ⟨sc_canon_mod _, ?_⟩
  simp only [toSM, montVal, limbsEval_mod_n, ZMod.natCast_mod, Nat.cast_mul, natCast_invMod_R_n]
  ring

public theorem fd_secp256k1_scalar_negate.spec_val (hs : scCanon s) :
    scCanon (fd_secp256k1_scalar_negate.spec s) ∧
      toS (fd_secp256k1_scalar_negate.spec s) = -toS s := by
  have hsub :
    limbsEval (bignum_sub.spec 4 4 fd_secp256k1_const_n 4 s).z = n_256k1 - limbsEval s := by
    have hl := limbsEval_lt s
    simp only [bignum_sub.spec]
    show limbsEval (limbsOfNat 4 _) = _
    rw [limbsEval_limbsOfNat, limbsEval_const_n]
    have h4 : (4 : BitVec 64).toNat = 4 := rfl
    simp only [h4, Nat.min_self, Nat.reduceMul]
    have hn := n_256k1_lt
    rw [Nat.mod_eq_of_lt hn, Nat.mod_eq_of_lt hl]
    have : ((n_256k1 : ℤ) - limbsEval s) % (2 ^ 256 : ℕ) = ((n_256k1 - limbsEval s : ℕ) : ℤ) := by
      rw [Int.emod_eq_of_lt] <;> omega
    rw [show ((2 : ℤ) ^ 256) = ((2 ^ 256 : ℕ) : ℤ) by norm_num, this, Int.toNat_natCast]
    exact Nat.mod_eq_of_lt (by omega)
  rw [fd_secp256k1_scalar_negate.spec, bignum_mod_n256k1_4.spec, hsub]
  refine ⟨sc_canon_mod _, ?_⟩
  rw [toS, toS, limbsEval_mod_n, ZMod.natCast_mod, Nat.cast_sub hs.le, ZMod.natCast_self, zero_sub]

public theorem fd_secp256k1_scalar_tomont.spec_val (hs : scCanon s) :
    scCanon (fd_secp256k1_scalar_tomont.spec s) ∧
      toSM (fd_secp256k1_scalar_tomont.spec s) = toS s := by
  have hrr := limbsEval_const_scalar_rr_mont
  have h :
    fd_secp256k1_scalar_tomont.spec s =
      limbsOfNat 4
        ((limbsEval s * limbsEval fd_secp256k1_const_scalar_rr_mont * invMod (2 ^ 256) n_256k1) %
          n_256k1) := by
    rw [fd_secp256k1_scalar_tomont.spec, bignum_montmul.spec, ite_eq_left]
    · rw [limbsEval_const_n]; rfl
    · rw [limbsEval_const_n]
      exact
        ⟨mul_le_R_mul n_256k1_lt.le hs
            (by
              rw [hrr]; exact Nat.mod_lt _ n_256k1_pos),
          by norm_num [n_256k1], rfl⟩
  rw [h]
  refine ⟨sc_canon_mod _, ?_⟩
  rw [toSM, toS, montVal, limbsEval_mod_n, ZMod.natCast_mod, hrr]
  simp only [Nat.cast_mul, natCast_invMod_R_n, ZMod.natCast_mod, Nat.cast_pow, Nat.cast_ofNat]
  have hR := pow_ne_zero 256 two_ne_zero_n
  rw [← mul_assoc, mul_inv_cancel_right₀ hR, mul_inv_cancel_right₀ hR]

/-- No precondition on the input. -/
public theorem fd_secp256k1_scalar_demont.spec_val (s : fd_secp256k1_scalar_t) :
    scCanon (fd_secp256k1_scalar_demont.spec s) ∧
      toS (fd_secp256k1_scalar_demont.spec s) = toSM s := by
  have h :
    fd_secp256k1_scalar_demont.spec s =
      limbsOfNat 4 ((limbsEval s * invMod (2 ^ 256) n_256k1) % n_256k1) := by
    rw [fd_secp256k1_scalar_demont.spec, bignum_demont.spec, ite_eq_left]
    · rw [limbsEval_const_n]; rfl
    · rw [limbsEval_const_n]; exact ⟨by norm_num [n_256k1], rfl⟩
  rw [h]
  refine ⟨sc_canon_mod _, ?_⟩
  rw [toS, toSM, montVal, limbsEval_mod_n, ZMod.natCast_mod, Nat.cast_mul, natCast_invMod_R_n]

/-! ## The backend -/

/-- The s2n-bignum backend meets the specification, with or without `__ADX__`. -/
public theorem backend_spec (adx : Bool) : (backend adx).Spec where
  scalar_frombytes_r b := by
    show limbsEval (fd_secp256k1_scalar_frombytes.spec b).r = _
    rw [fd_secp256k1_scalar_frombytes.spec_r, limbsEval_bswap_ofBuf]
  scalar_frombytes_ret := fd_secp256k1_scalar_frombytes.spec_ret
  scalar_reduce := fd_secp256k1_scalar_reduce.spec_val
  scalar_invert _ h0 := fd_secp256k1_scalar_invert.spec_val h0
  scalar_mul := fd_secp256k1_scalar_mul.spec_val
  scalar_negate := fd_secp256k1_scalar_negate.spec_val
  scalar_tomont := fd_secp256k1_scalar_tomont.spec_val
  scalar_demont {s} _ := fd_secp256k1_scalar_demont.spec_val s
  fp_set := fp_set_eq
  fp_eq := fd_secp256k1_fp_eq.spec_val
  fp_add := fd_secp256k1_fp_add.spec_val
  fp_sub := fd_secp256k1_fp_sub.spec_val
  fp_dbl := fd_secp256k1_fp_dbl.spec_val
  fp_triple {a} _ := fd_secp256k1_fp_triple.spec_val adx a
  fp_mul := fd_secp256k1_fp_mul.spec_val adx
  fp_sqr := fd_secp256k1_fp_sqr.spec_val adx
  fp_negate := fd_secp256k1_fp_negate.spec_val
  fp_is_odd := fd_secp256k1_fp_is_odd.spec_val
  fp_invert := fd_secp256k1_fp_invert.spec_val adx
  fp_tomont {a} _ := fd_secp256k1_fp_tomont.spec_val adx a
  fp_tobytes := fd_secp256k1_fp_tobytes.spec_val

end Firedancer.Secp256k1.S2n
