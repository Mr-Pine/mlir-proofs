module

public import Firedancer.Secp256k1.BackendRef
public import Firedancer.Secp256k1.Math.Ops
import Mathlib.FieldTheory.Finite.Basic
import Std.Tactic.BVDecide
public meta import Std.Tactic.BVDecide.Reflect

/-! The fiat-crypto backend meets `Backend.Spec`: every fiat precondition (inputs `< m`) holds at
its call. Unlike s2n, its inverses are Fermat powers and also hold at `0`. -/

namespace Firedancer.Secp256k1

variable {a b : fd_secp256k1_fp_t}

/-! ## fiat field functions -/

public theorem fiat_secp256k1_montgomery_mul.spec_val (ha : fpCanon a) (hb : fpCanon b) :
    fpCanon (fiat_secp256k1_montgomery_mul.spec a b) ∧
      toF (fiat_secp256k1_montgomery_mul.spec a b) = toF a * toF b := by
  simp only [fiat_secp256k1_montgomery_mul.spec, fiat_secp256k1_montgomery_m_eq]
  rw [ite_eq_left ⟨ha, hb⟩]
  refine ⟨(fp_out _).1, ?_⟩
  rw [(fp_out _).2]
  simp only [toF, montVal, Nat.cast_mul, natCast_fiat_Rinv_p]; ring

public theorem fiat_secp256k1_montgomery_square.spec_val (ha : fpCanon a) :
    fpCanon (fiat_secp256k1_montgomery_square.spec a) ∧
      toF (fiat_secp256k1_montgomery_square.spec a) = toF a ^ 2 := by
  simp only [fiat_secp256k1_montgomery_square.spec, fiat_secp256k1_montgomery_m_eq]
  rw [ite_eq_left ha]
  refine ⟨(fp_out _).1, ?_⟩
  rw [(fp_out _).2]
  simp only [toF, montVal, Nat.cast_mul, natCast_fiat_Rinv_p]; ring

public theorem fiat_secp256k1_montgomery_add.spec_val (ha : fpCanon a) (hb : fpCanon b) :
    fpCanon (fiat_secp256k1_montgomery_add.spec a b) ∧
      toF (fiat_secp256k1_montgomery_add.spec a b) = toF a + toF b := by
  simp only [fiat_secp256k1_montgomery_add.spec, fiat_secp256k1_montgomery_m_eq]
  rw [ite_eq_left ⟨ha, hb⟩]
  refine ⟨(fp_out _).1, ?_⟩
  rw [(fp_out _).2]
  simp only [toF, montVal, Nat.cast_add]; ring

public theorem fiat_secp256k1_montgomery_sub.spec_val (ha : fpCanon a) (hb : fpCanon b) :
    fpCanon (fiat_secp256k1_montgomery_sub.spec a b) ∧
      toF (fiat_secp256k1_montgomery_sub.spec a b) = toF a - toF b := by
  simp only [fiat_secp256k1_montgomery_sub.spec, fiat_secp256k1_montgomery_m_eq]
  rw [ite_eq_left ⟨ha, hb⟩]
  refine ⟨(fp_out_int _).1, ?_⟩
  rw [(fp_out_int _).2]
  simp only [toF, montVal, Int.cast_sub, Int.cast_natCast]; ring

public theorem fiat_secp256k1_montgomery_opp.spec_val (ha : fpCanon a) :
    fpCanon (fiat_secp256k1_montgomery_opp.spec a) ∧
      toF (fiat_secp256k1_montgomery_opp.spec a) = -toF a := by
  simp only [fiat_secp256k1_montgomery_opp.spec, fiat_secp256k1_montgomery_m_eq]
  rw [ite_eq_left ha]
  refine ⟨(fp_out_int _).1, ?_⟩
  rw [(fp_out_int _).2]
  simp only [toF, montVal, Int.cast_neg, Int.cast_natCast]; ring

public theorem fiat_secp256k1_montgomery_to_montgomery.spec_val (ha : fpCanon a) :
    fpCanon (fiat_secp256k1_montgomery_to_montgomery.spec a) ∧
      toF (fiat_secp256k1_montgomery_to_montgomery.spec a) = (limbsEval a : ZMod p_256k1) := by
  simp only [fiat_secp256k1_montgomery_to_montgomery.spec, fiat_secp256k1_montgomery_m_eq]
  rw [ite_eq_left ha]
  refine ⟨(fp_out _).1, ?_⟩
  rw [(fp_out _).2, Nat.cast_mul, Nat.cast_pow, Nat.cast_ofNat,
    mul_inv_cancel_right₀ (pow_ne_zero _ two_ne_zero_p)]

public theorem fiat_secp256k1_montgomery_from_montgomery.spec_eq (ha : fpCanon a) :
    fiat_secp256k1_montgomery_from_montgomery.spec a =
      limbsOfNat 4 ((limbsEval a * fiat_Rinv p_256k1) % p_256k1) := by
  simp only [fiat_secp256k1_montgomery_from_montgomery.spec, fiat_secp256k1_montgomery_m_eq]
  exact ite_eq_left ha

/-! ## Field -/

namespace Ref

public theorem fd_secp256k1_fp_triple.spec_val (ha : fpCanon a) :
    fpCanon (fd_secp256k1_fp_triple.spec a) ∧ toF (fd_secp256k1_fp_triple.spec a) = 3 * toF a := by
  obtain ⟨c1, v1⟩ := fiat_secp256k1_montgomery_add.spec_val ha ha
  obtain ⟨c2, v2⟩ := fiat_secp256k1_montgomery_add.spec_val c1 ha
  exact
    ⟨c2, by
      rw [fd_secp256k1_fp_triple.spec, v2, v1]; ring⟩

public theorem fd_secp256k1_fp_is_odd.spec_val (ha : fpCanon a) :
    fd_secp256k1_fp_is_odd.spec a = if (toF a).val % 2 = 1 then 1#32 else 0#32 := by
  rw [fd_secp256k1_fp_is_odd.spec, fiat_secp256k1_montgomery_from_montgomery.spec_eq ha,
    is_odd_limbsOfNat, toF_val natCast_fiat_Rinv_p]

public theorem fd_secp256k1_fp_tobytes.spec_val (ha : fpCanon a) :
    beNat (fd_secp256k1_fp_tobytes.spec a) = (toF a).val := by
  rw [fd_secp256k1_fp_tobytes.spec, fiat_secp256k1_montgomery_from_montgomery.spec_eq ha,
    beNat_bswap_buf, limbsEval_mod_p, toF_val natCast_fiat_Rinv_p]

/-- Fermat: also `0` at `0`. -/
public theorem fd_secp256k1_fp_invert.spec_val (ha : fpCanon a) :
    fpCanon (fd_secp256k1_fp_invert.spec a) ∧ toF (fd_secp256k1_fp_invert.spec a) = (toF a)⁻¹ := by
  obtain ⟨c, v⟩ :=
    fd_pcurve_ref_pow.spec_val fpCanon toF
      (fun _ _ hx hy => fiat_secp256k1_montgomery_mul.spec_val hx hy)
      (fun _ hx => fiat_secp256k1_montgomery_square.spec_val hx)
      fiat_secp256k1_montgomery_set_one.fp ha fd_secp256k1_const_p_m2
  exact
    ⟨c, by
      rw [fd_secp256k1_fp_invert.spec, fd_secp256k1_fp_pow_limbs.spec, v, limbsEval_const_p_m2,
        pow_sub_two_eq_inv (by norm_num [p_256k1])]⟩

end Ref

/-! ## Outputs modulo `n` -/

theorem sc_out (x : ℕ) :
    scCanon (limbsOfNat 4 (x % n_256k1)) ∧ toS (limbsOfNat 4 (x % n_256k1)) = (x : ZMod n_256k1) :=
  ⟨sc_canon_mod x, by rw [toS, limbsEval_mod_n, ZMod.natCast_mod]⟩

theorem sc_out_int (z : ℤ) :
    scCanon (limbsOfNat 4 (z % (n_256k1 : ℤ)).toNat) ∧
      toS (limbsOfNat 4 (z % (n_256k1 : ℤ)).toNat) = (z : ZMod n_256k1) := by
  have h := limbsEval_limbsOfNat_emod n_256k1_lt.le n_256k1_pos z
  exact
    ⟨by
      rw [scCanon, h]; exact emod_toNat_lt n_256k1_pos z, by
      rw [toS, h, natCast_emod_toNat n_256k1_pos]⟩

theorem toSM_eq (a : fd_secp256k1_scalar_t) : toSM a = toS a * ((2 : ZMod n_256k1) ^ 256)⁻¹ :=
  rfl

/-! ## fiat scalar functions -/

variable {s t : fd_secp256k1_scalar_t}

public theorem fiat_secp256k1_montgomery_scalar_mul.spec_val (hs : scCanon s) (ht : scCanon t) :
    scCanon (fiat_secp256k1_montgomery_scalar_mul.spec s t) ∧
      toSM (fiat_secp256k1_montgomery_scalar_mul.spec s t) = toSM s * toSM t := by
  simp only [fiat_secp256k1_montgomery_scalar_mul.spec, fiat_secp256k1_montgomery_scalar_m_eq]
  rw [ite_eq_left ⟨hs, ht⟩]
  refine ⟨(sc_out _).1, ?_⟩
  rw [toSM_eq, (sc_out _).2, toSM_eq, toSM_eq]
  simp only [toS, Nat.cast_mul, natCast_fiat_Rinv_n]; ring

public theorem fiat_secp256k1_montgomery_scalar_square.spec_val (hs : scCanon s) :
    scCanon (fiat_secp256k1_montgomery_scalar_square.spec s) ∧
      toSM (fiat_secp256k1_montgomery_scalar_square.spec s) = toSM s ^ 2 := by
  simp only [fiat_secp256k1_montgomery_scalar_square.spec, fiat_secp256k1_montgomery_scalar_m_eq]
  rw [ite_eq_left hs]
  refine ⟨(sc_out _).1, ?_⟩
  rw [toSM_eq, (sc_out _).2, toSM_eq]
  simp only [toS, Nat.cast_mul, natCast_fiat_Rinv_n]; ring

public theorem fiat_secp256k1_montgomery_scalar_opp.spec_val (hs : scCanon s) :
    scCanon (fiat_secp256k1_montgomery_scalar_opp.spec s) ∧
      toS (fiat_secp256k1_montgomery_scalar_opp.spec s) = -toS s := by
  simp only [fiat_secp256k1_montgomery_scalar_opp.spec, fiat_secp256k1_montgomery_scalar_m_eq]
  rw [ite_eq_left hs]
  exact ⟨(sc_out_int _).1, by rw [(sc_out_int _).2, Int.cast_neg, Int.cast_natCast]⟩

public theorem fiat_secp256k1_montgomery_scalar_to_montgomery.spec_val (hs : scCanon s) :
    scCanon (fiat_secp256k1_montgomery_scalar_to_montgomery.spec s) ∧
      toSM (fiat_secp256k1_montgomery_scalar_to_montgomery.spec s) = toS s := by
  simp only [fiat_secp256k1_montgomery_scalar_to_montgomery.spec,
    fiat_secp256k1_montgomery_scalar_m_eq]
  rw [ite_eq_left hs]
  refine ⟨(sc_out _).1, ?_⟩
  rw [toSM_eq, (sc_out _).2, Nat.cast_mul, Nat.cast_pow, Nat.cast_ofNat,
    mul_inv_cancel_right₀ (pow_ne_zero _ two_ne_zero_n)]

public theorem fiat_secp256k1_montgomery_scalar_from_montgomery.spec_val (hs : scCanon s) :
    scCanon (fiat_secp256k1_montgomery_scalar_from_montgomery.spec s) ∧
      toS (fiat_secp256k1_montgomery_scalar_from_montgomery.spec s) = toSM s := by
  simp only [fiat_secp256k1_montgomery_scalar_from_montgomery.spec,
    fiat_secp256k1_montgomery_scalar_m_eq]
  rw [ite_eq_left hs]
  exact ⟨(sc_out _).1, by rw [(sc_out _).2, toSM_eq, Nat.cast_mul, natCast_fiat_Rinv_n]⟩

/-! ## `reduce_once` -/

theorem toNat_limbs256 (a0 a1 a2 a3 : BitVec 64) :
    (a3 ++ a2 ++ a1 ++ a0).toNat = limbsEval #v[a0, a1, a2, a3] := by
  rw [limbsEval_four]
  simp only [toNat_append_add, Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_succ,
    List.getElem_cons_zero]
  ring

/-- The borrow chain of `reduce_once` against `n`, on the 256-bit value. -/
theorem reduce_once_bits (a0 a1 a2 a3 : BitVec 64) :
    let r := Ref.fd_pcurve_ref_reduce_once.spec #v[a0, a1, a2, a3] fd_secp256k1_const_n
    r[3] ++ r[2] ++ r[1] ++ r[0] =
      if
          a3 ++ a2 ++ a1 ++ a0 <
            0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141#256 then
        a3 ++ a2 ++ a1 ++ a0
      else
        a3 ++ a2 ++ a1 ++ a0 -
          0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141#256 := by
  simp only [Ref.fd_pcurve_ref_reduce_once.spec, fd_ulong_if.spec, fd_secp256k1_const_n,
    Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_succ, List.getElem_cons_zero]
  bv_decide

/-- One conditional subtraction of `n`; `n`-reduced on every 256-bit input since
`2^256 - 1 < 2n`. -/
public theorem Ref.fd_secp256k1_scalar_reduce.spec_val (s : fd_secp256k1_scalar_t) :
    limbsEval (Ref.fd_secp256k1_scalar_reduce.spec s) = limbsEval s % n_256k1 := by
  have hs : s = #v[s[0], s[1], s[2], s[3]] := (fp_set_eq s).symm
  have h2 := two_pow_256_sub_one_lt_two_mul_n
  rw [Ref.fd_secp256k1_scalar_reduce.spec, hs]
  generalize s[0] = a0, s[1] = a1, s[2] = a2, s[3] = a3
  have hr (r : fd_secp256k1_scalar_t) : limbsEval r = (r[3] ++ r[2] ++ r[1] ++ r[0]).toNat := by
    rw [toNat_limbs256, fp_set_eq]
  have hN :
    (0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141#256).toNat = n_256k1 := rfl
  have hl := (a3 ++ a2 ++ a1 ++ a0).isLt
  rw [hr, reduce_once_bits, ← toNat_limbs256]
  split_ifs with h
  · rw [BitVec.lt_def, hN] at h
    exact (Nat.mod_eq_of_lt h).symm
  · rw [BitVec.lt_def, hN, not_lt] at h
    rw [BitVec.toNat_sub_of_le
        (by
          rw [BitVec.le_def, hN]; exact h),
      hN]
    rw [Nat.mod_eq_sub_mod h, Nat.mod_eq_of_lt (by omega)]

namespace Ref

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

/-- Fermat in the Montgomery domain: also `0` at `0`. -/
public theorem fd_secp256k1_scalar_invert.spec_val (hs : scCanon s) :
    scCanon (fd_secp256k1_scalar_invert.spec s) ∧
      toS (fd_secp256k1_scalar_invert.spec s) = (toS s)⁻¹ := by
  obtain ⟨c1, v1⟩ := fiat_secp256k1_montgomery_scalar_to_montgomery.spec_val hs
  obtain ⟨c2, v2⟩ :=
    fd_pcurve_ref_pow.spec_val scCanon toSM
      (fun _ _ hx hy => fiat_secp256k1_montgomery_scalar_mul.spec_val hx hy)
      (fun _ hx => fiat_secp256k1_montgomery_scalar_square.spec_val hx)
      fiat_secp256k1_montgomery_scalar_set_one.sc c1 fd_secp256k1_const_n_m2
  obtain ⟨c3, v3⟩ := fiat_secp256k1_montgomery_scalar_from_montgomery.spec_val c2
  exact
    ⟨c3, by
      rw [fd_secp256k1_scalar_invert.spec, fd_secp256k1_scalar_pow_limbs.spec, v3, v2, v1,
        limbsEval_const_n_m2, pow_sub_two_eq_inv (by norm_num [n_256k1])]⟩

/-- The ref backend meets the specification. -/
public theorem backend_spec : backend.Spec where
  scalar_frombytes_r b := by
    show limbsEval (fd_secp256k1_scalar_frombytes.spec b).r = _
    rw [fd_secp256k1_scalar_frombytes.spec_r, limbsEval_bswap_ofBuf]
  scalar_frombytes_ret := fd_secp256k1_scalar_frombytes.spec_ret
  scalar_reduce := fd_secp256k1_scalar_reduce.spec_val
  scalar_invert hs _ := fd_secp256k1_scalar_invert.spec_val hs
  scalar_mul := fiat_secp256k1_montgomery_scalar_mul.spec_val
  scalar_negate := fiat_secp256k1_montgomery_scalar_opp.spec_val
  scalar_tomont := fiat_secp256k1_montgomery_scalar_to_montgomery.spec_val
  scalar_demont := fiat_secp256k1_montgomery_scalar_from_montgomery.spec_val
  fp_set := fp_set_eq
  fp_eq := fp_eq_val
  fp_add := fiat_secp256k1_montgomery_add.spec_val
  fp_sub := fiat_secp256k1_montgomery_sub.spec_val
  fp_dbl ha := by
    obtain ⟨c, v⟩ := fiat_secp256k1_montgomery_add.spec_val ha ha
    exact
      ⟨c, by
        rw [show backend.fp_dbl _ = fiat_secp256k1_montgomery_add.spec _ _ from rfl, v]; ring⟩
  fp_triple := fd_secp256k1_fp_triple.spec_val
  fp_mul := fiat_secp256k1_montgomery_mul.spec_val
  fp_sqr := fiat_secp256k1_montgomery_square.spec_val
  fp_negate := fiat_secp256k1_montgomery_opp.spec_val
  fp_is_odd := fd_secp256k1_fp_is_odd.spec_val
  fp_invert ha _ := fd_secp256k1_fp_invert.spec_val ha
  fp_tomont := fiat_secp256k1_montgomery_to_montgomery.spec_val
  fp_tobytes := fd_secp256k1_fp_tobytes.spec_val

end Ref

end Firedancer.Secp256k1
