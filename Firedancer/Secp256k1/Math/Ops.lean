module

public import Firedancer.Secp256k1.Math.Field
public import Firedancer.Secp256k1.Math.Scalar
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.Ring

/-! What the shared code needs of a backend's `fp_*` and `scalar_*` functions, as one
proposition `Backend.Spec`, and the lemmas both backends' proofs share. -/

namespace Firedancer.Secp256k1

/-! ## The specification -/

/-- The `fp_*` and `scalar_*` functions on canonical inputs give canonical outputs whose values
are the field and scalar operations (`fd_secp256k1_private.h:86-90`). -/
public structure Backend.Spec (B : Backend) : Prop where
  scalar_frombytes_r (b : Vector (BitVec 8) 32) : limbsEval (B.scalar_frombytes b).r = beNat b
  scalar_frombytes_ret (b : Vector (BitVec 8) 32) :
    (B.scalar_frombytes b).ret =
      if 0 < beNat b ∧ beNat b < n_256k1 then some (B.scalar_frombytes b).r else none
  scalar_reduce (a : fd_secp256k1_scalar_t) : limbsEval (B.scalar_reduce a) = limbsEval a % n_256k1
  scalar_invert {a : fd_secp256k1_scalar_t} :
    scCanon a → toS a ≠ 0 → scCanon (B.scalar_invert a) ∧ toS (B.scalar_invert a) = (toS a)⁻¹
  scalar_mul {a b : fd_secp256k1_scalar_t} :
    scCanon a → scCanon b → scCanon (B.scalar_mul a b) ∧ toSM (B.scalar_mul a b) = toSM a * toSM b
  scalar_negate {a : fd_secp256k1_scalar_t} :
    scCanon a → scCanon (B.scalar_negate a) ∧ toS (B.scalar_negate a) = -toS a
  scalar_tomont {a : fd_secp256k1_scalar_t} :
    scCanon a → scCanon (B.scalar_tomont a) ∧ toSM (B.scalar_tomont a) = toS a
  scalar_demont {a : fd_secp256k1_scalar_t} :
    scCanon a → scCanon (B.scalar_demont a) ∧ toS (B.scalar_demont a) = toSM a
  fp_set (a : fd_secp256k1_fp_t) : B.fp_set a = a
  fp_eq {a b : fd_secp256k1_fp_t} :
    fpCanon a → fpCanon b → B.fp_eq a b = if toF a = toF b then 1#32 else 0#32
  fp_add {a b : fd_secp256k1_fp_t} :
    fpCanon a → fpCanon b → fpCanon (B.fp_add a b) ∧ toF (B.fp_add a b) = toF a + toF b
  fp_sub {a b : fd_secp256k1_fp_t} :
    fpCanon a → fpCanon b → fpCanon (B.fp_sub a b) ∧ toF (B.fp_sub a b) = toF a - toF b
  fp_dbl {a : fd_secp256k1_fp_t} : fpCanon a → fpCanon (B.fp_dbl a) ∧ toF (B.fp_dbl a) = 2 * toF a
  fp_triple {a : fd_secp256k1_fp_t} :
    fpCanon a → fpCanon (B.fp_triple a) ∧ toF (B.fp_triple a) = 3 * toF a
  fp_mul {a b : fd_secp256k1_fp_t} :
    fpCanon a → fpCanon b → fpCanon (B.fp_mul a b) ∧ toF (B.fp_mul a b) = toF a * toF b
  fp_sqr {a : fd_secp256k1_fp_t} : fpCanon a → fpCanon (B.fp_sqr a) ∧ toF (B.fp_sqr a) = toF a ^ 2
  fp_negate {a : fd_secp256k1_fp_t} :
    fpCanon a → fpCanon (B.fp_negate a) ∧ toF (B.fp_negate a) = -toF a
  fp_is_odd {a : fd_secp256k1_fp_t} :
    fpCanon a → B.fp_is_odd a = if (toF a).val % 2 = 1 then 1#32 else 0#32
  fp_invert {a : fd_secp256k1_fp_t} :
    fpCanon a → toF a ≠ 0 → fpCanon (B.fp_invert a) ∧ toF (B.fp_invert a) = (toF a)⁻¹
  fp_tomont {a : fd_secp256k1_fp_t} :
    fpCanon a → fpCanon (B.fp_tomont a) ∧ toF (B.fp_tomont a) = (limbsEval a : ZMod p_256k1)
  fp_tobytes {a : fd_secp256k1_fp_t} : fpCanon a → beNat (B.fp_tobytes a) = (toF a).val

/-- `scalar_negate` also negates Montgomery values (it is linear). -/
public theorem Backend.Spec.scalar_negate_mont {B : Backend} (hB : B.Spec)
    {a : fd_secp256k1_scalar_t} (ha : scCanon a) :
    scCanon (B.scalar_negate a) ∧ toSM (B.scalar_negate a) = -toSM a := by
  obtain ⟨c, v⟩ := hB.scalar_negate ha
  refine ⟨c, ?_⟩
  simp only [toSM, montVal]
  rw [show ((limbsEval (B.scalar_negate a) : ℕ) : ZMod n_256k1) = toS (B.scalar_negate a) from rfl,
    v, toS, neg_mul]

/-! ## Outputs modulo `p` -/

public theorem limbsEval_mod_p (x : ℕ) : limbsEval (limbsOfNat 4 (x % p_256k1)) = x % p_256k1 :=
  limbsEval_limbsOfNat_mod p_256k1_lt.le p_256k1_pos x

/-- The canonical output `x mod p` stands for `x · 2⁻²⁵⁶`. -/
public theorem fp_out (x : ℕ) :
    fpCanon (limbsOfNat 4 (x % p_256k1)) ∧
      toF (limbsOfNat 4 (x % p_256k1)) = (x : ZMod p_256k1) * ((2 : ZMod p_256k1) ^ 256)⁻¹ := by
  refine
    ⟨by
      rw [fpCanon, limbsEval_mod_p]; exact Nat.mod_lt _ p_256k1_pos, ?_⟩
  rw [toF, montVal, limbsEval_mod_p, ZMod.natCast_mod]

/-- The canonical output `z mod p` stands for `z · 2⁻²⁵⁶`. -/
public theorem fp_out_int (z : ℤ) :
    fpCanon (limbsOfNat 4 (z % (p_256k1 : ℤ)).toNat) ∧
      toF (limbsOfNat 4 (z % (p_256k1 : ℤ)).toNat) =
        (z : ZMod p_256k1) * ((2 : ZMod p_256k1) ^ 256)⁻¹ := by
  have h := limbsEval_limbsOfNat_emod p_256k1_lt.le p_256k1_pos z
  refine
    ⟨by
      rw [fpCanon, h]; exact emod_toNat_lt p_256k1_pos z, ?_⟩
  rw [toF, montVal, h, natCast_emod_toNat p_256k1_pos]

public theorem natCast_invMod_R_p :
    ((invMod (2 ^ 256) p_256k1 : ℕ) : ZMod p_256k1) = ((2 : ZMod p_256k1) ^ 256)⁻¹ :=
  natCast_invMod_two_pow two_ne_zero_p

public theorem natCast_fiat_Rinv_p :
    ((fiat_Rinv p_256k1 : ℕ) : ZMod p_256k1) = ((2 : ZMod p_256k1) ^ 256)⁻¹ :=
  natCast_fiat_Rinv two_ne_zero_p

/-- A product of canonical values is within the Montgomery bound. -/
public theorem mul_le_R_mul {m x y : ℕ} (hm : m ≤ 2 ^ 256) (hx : x < m) (hy : y < m) :
    x * y ≤ 2 ^ 256 * m :=
  (Nat.mul_le_mul hx.le hy.le).trans (Nat.mul_le_mul_right m hm)

/-- The value of a canonical element is its `x · k mod p` for `k` an inverse of `R`. -/
public theorem toF_val {a : fd_secp256k1_fp_t} {k : ℕ}
    (hk : (k : ZMod p_256k1) = ((2 : ZMod p_256k1) ^ 256)⁻¹) :
    (toF a).val = limbsEval a * k % p_256k1 := by
  rw [toF, montVal, ← hk, ← Nat.cast_mul, ZMod.val_natCast]

/-- `fp_eq` on canonical elements. -/
public theorem fp_eq_val {a b : fd_secp256k1_fp_t} (ha : fpCanon a) (hb : fpCanon b) :
    fd_uint256_eq.spec a b = if toF a = toF b then 1#32 else 0#32 := by
  rw [fd_uint256_eq.spec_eq]
  exact if_congr (montVal_inj two_ne_zero_p ha hb).symm rfl rfl

/-- `fp_set` copies. -/
public theorem fp_set_eq (a : fd_secp256k1_fp_t) :
    (#v[a[0], a[1], a[2], a[3]] : fd_secp256k1_fp_t) = a :=
  Vector.ext fun i hi => by interval_cases i <;> rfl

/-- The `int` low bit of limb 0 of `v`'s limbs. -/
public theorem is_odd_limbsOfNat (v : ℕ) :
    ((limbsOfNat 4 v)[0] &&& 1#64).setWidth 32 = if v % 2 = 1 then 1#32 else 0#32 := by
  apply BitVec.eq_of_toNat_eq
  simp only [limbsOfNat, Vector.getElem_ofFn, Nat.mul_zero, Nat.shiftRight_zero,
    BitVec.toNat_setWidth, BitVec.toNat_and, BitVec.toNat_ofNat]
  rw [show (1 : ℕ) % 2 ^ 64 = 1 from rfl, Nat.and_one_is_mod,
    Nat.mod_mod_of_dvd v (by norm_num : 2 ∣ 2 ^ 64)]
  split_ifs with h <;> simp [h]; omega

/-! ## Scalars -/

public theorem limbsEval_mod_n (x : ℕ) : limbsEval (limbsOfNat 4 (x % n_256k1)) = x % n_256k1 :=
  limbsEval_limbsOfNat_mod n_256k1_lt.le n_256k1_pos x

public theorem sc_canon_mod (x : ℕ) : scCanon (limbsOfNat 4 (x % n_256k1)) := by
  rw [scCanon, limbsEval_mod_n]; exact Nat.mod_lt _ n_256k1_pos

public theorem natCast_invMod_R_n :
    ((invMod (2 ^ 256) n_256k1 : ℕ) : ZMod n_256k1) = ((2 : ZMod n_256k1) ^ 256)⁻¹ :=
  natCast_invMod_two_pow two_ne_zero_n

public theorem natCast_fiat_Rinv_n :
    ((fiat_Rinv n_256k1 : ℕ) : ZMod n_256k1) = ((2 : ZMod n_256k1) ^ 256)⁻¹ :=
  natCast_fiat_Rinv two_ne_zero_n

/-- `frombytes`'s checks: `NULL` unless `0 < value < n`. -/
public theorem frombytes_ret_eq (input : Vector (BitVec 8) 32) :
    (let r := fd_uint256_bswap.spec (fd_uint256_t.ofBuf input)
     if (0#32).sle (fd_uint256_cmp.spec r fd_secp256k1_const_n) then
          (⟨r, none⟩ : fd_secp256k1_scalar_frombytes.Result)
        else
          if fd_uint256_eq.spec r fd_secp256k1_const_zero ≠ 0#32 then ⟨r, none⟩
          else ⟨r, some r⟩).ret =
      if 0 < beNat input ∧ beNat input < n_256k1 then
        some (fd_uint256_bswap.spec (fd_uint256_t.ofBuf input))
      else none := by
  have hz : limbsEval fd_secp256k1_const_zero = 0 := by
    simp [limbsEval_four, fd_secp256k1_const_zero]
  simp only [fd_uint256_cmp.spec_sle, limbsEval_const_n, limbsEval_bswap_ofBuf,
    fd_uint256_eq.spec_eq]
  by_cases h1 : n_256k1 ≤ beNat input
  · simp [h1, show ¬beNat input < n_256k1 by omega]
  · by_cases h2 : fd_uint256_bswap.spec (fd_uint256_t.ofBuf input) = fd_secp256k1_const_zero
    · have h0 := congrArg limbsEval h2
      rw [limbsEval_bswap_ofBuf, hz] at h0
      simp [h2, h0]
    · have h0 : beNat input ≠ 0 := fun h0 =>
        h2 (limbsEval_injective (by rw [limbsEval_bswap_ofBuf, hz, h0]))
      simp [h1, h2]
      omega

end Firedancer.Secp256k1
