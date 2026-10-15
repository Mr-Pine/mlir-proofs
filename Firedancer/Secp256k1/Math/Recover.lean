module

public import Firedancer.Secp256k1.Math.DoubleBaseMul
public import Firedancer.Secp256k1.Math.Sqrt
public import Firedancer.Secp256k1.Math.OpsS2n
public import Firedancer.Secp256k1.Math.OpsRef
public import Firedancer.Secp256k1.Recover
public import Mathlib.Algebra.Module.ZMod
import Mathlib.Tactic.Module

/-! `fd_secp256k1_recover` computes SEC 1 v2 §4.1.6 public key recovery: `recoverSpec`, stated
over `ZMod p_256k1`, `ZMod n_256k1` and Mathlib's Weierstrass points, for both backends. -/

namespace Firedancer.Secp256k1

open Formulas WeierstrassCurve WeierstrassCurve.Affine

/-! ## Bytes -/

@[expose] public section

/-- The 32 big-endian bytes of `v mod 2^256`. -/
def be32 (v : ℕ) : Vector (BitVec 8) 32 :=
  Vector.ofFn fun i => BitVec.ofNat 8 (v / 256 ^ (31 - i.val))

end

theorem fold_horner_digit (g : ℕ → ℕ) (hg : ∀ i, g i < 256) :
    ∀ (k i : ℕ),
      i < k → Nat.fold k (fun j _ acc => acc * 256 + g j) 0 / 256 ^ (k - 1 - i) % 256 = g i := by
  intro k
  induction k with
  | zero =>
    intro i h; omega
  | succ k ih =>
    intro i hi
    rw [Nat.fold_succ]
    have hk := hg k
    rcases Nat.lt_succ_iff_lt_or_eq.1 hi with h | rfl
    · rw [show k + 1 - 1 - i = (k - 1 - i) + 1 by omega, pow_succ', ← Nat.div_div_eq_div_mul,
        show
          (Nat.fold k (fun j _ acc => acc * 256 + g j) 0 * 256 + g k) / 256 =
            Nat.fold k (fun j _ acc => acc * 256 + g j) 0
          by omega]
      exact ih i h
    · rw [show i + 1 - 1 - i = 0 by omega, pow_zero, Nat.div_one]
      omega

/-- 32 bytes are the big-endian bytes of their value. -/
public theorem be32_beNat (b : Vector (BitVec 8) 32) : be32 (beNat b) = b := by
  have e :
    beNat b =
      Nat.fold 32 (fun j _ acc => acc * 256 + (if h : j < 32 then b[j].toNat else 0)) 0 := by
    unfold beNat
    congr
    funext j hj acc
    rw [dite_eq_left hj]
  refine Vector.ext fun i hi => ?_
  apply BitVec.eq_of_toNat_eq
  rw [be32, Vector.getElem_ofFn, BitVec.toNat_ofNat, e,
    fold_horner_digit _ (fun j => by split <;> [exact (b[j]).isLt; omega]) 32 i hi, dite_eq_left hi]

/-- The two `memcpy`s of the output. -/
public theorem storeBytes_storeBytes (pk : Vector (BitVec 8) 64) (a b : Vector (BitVec 8) 32) :
    storeBytes (storeBytes pk 0 a) 32 b = a ++ b := by
  refine Vector.ext fun j hj => ?_
  simp only [storeBytes, Vector.getElem_ofFn]
  by_cases h : j < 32
  · simp [h, show ¬32 ≤ j by omega, Vector.getElem_append_left (xs := a) (ys := b) h]
  · simp [show 32 ≤ j by omega, show j - 32 < 32 by omega,
      Vector.getElem_append_right (xs := a) (ys := b) hj (by omega : 32 ≤ j)]

/-! ## Lifting `x` -/

/-- Either root of `x³ + 7 = c²` squares to `x³ + 7`. -/
public theorem sq_adjust {x c : ZMod p_256k1} (hc : x ^ 3 + 7 = c * c) (par : ℕ) :
    (if c.val % 2 = par then c else -c) ^ 2 = x ^ 3 + 7 := by split_ifs <;> rw [hc] <;> ring

/-- The curve point with abscissa `x` and ordinate of parity `par` (`0` or `1`), if `x³ + 7` is a
square. The test is classical, so the kernel never evaluates it. -/
@[expose]
public noncomputable def liftX (x : ZMod p_256k1) (par : ℕ) : Option ECPoint :=
  @dite _ (IsSquare (x ^ 3 + 7)) (Classical.propDecidable _)
    (fun h =>
      some
        (.some x (if h.choose.val % 2 = par then h.choose else -h.choose)
          (nonsingular_of_eqn cube_add_seven_ne_zero (sq_adjust h.choose_spec par))))
    (fun _ => none)

/-- Negation flips the parity of a nonzero element. -/
public theorem val_neg_mod_two {y : ZMod p_256k1} (hy : y ≠ 0) : (-y).val % 2 = 1 - y.val % 2 := by
  have hp : p_256k1 % 2 = 1 := by norm_num [p_256k1]
  have hlt := ZMod.val_lt y
  have h0 : y.val ≠ 0 := fun h => hy ((ZMod.val_eq_zero y).1 h)
  rw [ZMod.neg_val, ite_eq_right hy]
  omega

public theorem liftX_eq_none {x : ZMod p_256k1} {par : ℕ} (h : ¬IsSquare (x ^ 3 + 7)) :
    liftX x par = none := by rw [liftX, dite_eq_right h]

/-- `liftX` returns the point with the given root of parity `par`. -/
public theorem liftX_eq_some {x y : ZMod p_256k1} {par : ℕ} (hy : y ^ 2 = x ^ 3 + 7)
    (hp : y.val % 2 = par) :
    liftX x par = some (.some x y (nonsingular_of_eqn cube_add_seven_ne_zero hy)) := by
  have hs : IsSquare (x ^ 3 + 7) := ⟨y, by rw [← hy, sq]⟩
  rw [liftX, dite_eq_left hs]
  simp only [Option.some.injEq, Point.some.injEq, true_and]
  have hc := hs.choose_spec
  have hy0 : y ≠ 0 := fun h0 =>
    cube_add_seven_ne_zero x
      (by
        rw [← hy, h0]; ring)
  have hc0 : hs.choose ≠ 0 := fun h0 =>
    cube_add_seven_ne_zero x
      (by
        rw [hc, h0]; ring)
  rcases sq_eq_sq_iff_eq_or_eq_neg.1 (show hs.choose ^ 2 = y ^ 2 by rw [hy, sq, ← hc]) with e | e
  · rw [ite_eq_left (by rw [e, hp])]; exact e
  · have := val_neg_mod_two hy0
    rw [ite_eq_right
        (by
          rw [e, this]; omega),
      e, neg_neg]

/-! ## `fd_secp256k1_recovery_y` -/

variable {B : Backend}

/-- `recovery_y` returns `some` exactly when `x³ + 7` is a square; then it stores canonical
`(x : y : 1)` with `y² = x³ + 7` and `y` of parity `odd`. -/
public theorem fd_secp256k1_recovery_y.spec_val (hB : B.Spec) (r0 : fd_secp256k1_point_t)
    {x : fd_secp256k1_fp_t} (hx : fpCanon x) {odd : BitVec 32} (hodd : odd.toNat ≤ 1) :
    let res := fd_secp256k1_recovery_y.spec B r0 x odd
    (res.ret.isSome ↔ IsSquare (toF x ^ 3 + 7)) ∧
      (IsSquare (toF x ^ 3 + 7) →
        res.ret = some res.r ∧
          Tr res.r.x (toF x) ∧
          Tr res.r.z 1 ∧
          fpCanon res.r.y ∧
          toF res.r.y ^ 2 = toF x ^ 3 + 7 ∧ (toF res.r.y).val % 2 = odd.toNat) := by
  intro res
  have tx : Tr x (toF x) := ⟨hx, rfl⟩
  have t3 := tr_add hB (tr_mul hB (tr_sqr hB tx) tx) fd_secp256k1_const_b_mont.fp
  rw [show toF x ^ 2 * toF x + 7 = toF x ^ 3 + 7 by ring] at t3
  obtain ⟨sc, -, sret, ssq⟩ := fd_secp256k1_fp_sqrt.spec_val hB t3.1
  rw [t3.2] at sret ssq
  simp only [res, fd_secp256k1_recovery_y.spec]
  rw [sret]
  by_cases hs : IsSquare (toF x ^ 3 + 7)
  swap
  · rw [ite_eq_right hs]
    simp [hs]
  rw [ite_eq_left hs]
  have hsq := ssq hs
  generalize
    (fd_secp256k1_fp_sqrt.spec B (B.fp_add (B.fp_mul (B.fp_sqr x) x) fd_secp256k1_const_b_mont)).r =
    y at sc hsq ⊢
  simp only [hB.fp_set, Option.isSome_some, true_iff]
  refine ⟨hs, fun _ => ?_⟩
  have hy0 : toF y ≠ 0 := fun h0 =>
    cube_add_seven_ne_zero (toF x)
      (by
        rw [← hsq, h0]; ring)
  rw [hB.fp_is_odd sc]
  by_cases hp : (toF y).val % 2 = odd.toNat
  · have e : (if (toF y).val % 2 = 1 then 1#32 else 0#32) = odd := by
      apply BitVec.eq_of_toNat_eq; split_ifs <;> simp <;> omega
    simp only [e, ne_eq, not_true_eq_false, ite_false]
    exact ⟨trivial, tx, fd_secp256k1_const_one_mont.fp, sc, hsq, hp⟩
  · have e : (if (toF y).val % 2 = 1 then 1#32 else 0#32) ≠ odd := by
      intro e; apply hp; rw [← e]; split_ifs <;> simp <;> omega
    simp only [ne_eq, e, not_false_eq_true, ite_true]
    have tn := tr_neg hB (⟨sc, rfl⟩ : Tr y (toF y))
    refine ⟨trivial, tx, fd_secp256k1_const_one_mont.fp, tn.1, by rw [tn.2, neg_sq, hsq], ?_⟩
    rw [tn.2, val_neg_mod_two hy0]
    omega

/-! ## The specification -/

@[expose] public section

/-- `r`, the big-endian first half of the signature. -/
def sigR (sig : Vector (BitVec 8) 64) : ℕ :=
  beNat (Vector.ofFn fun i : Fin 32 => sig[i.val])

/-- `s`, the big-endian second half of the signature. -/
def sigS (sig : Vector (BitVec 8) 64) : ℕ :=
  beNat (Vector.ofFn fun i : Fin 32 => sig[32 + i.val])

/-- The abscissa of `R`: `r + n` if bit 1 of the recovery id is set, else `r`. -/
def recX (recovery_id : BitVec 32) (r : ℕ) : ℕ :=
  if recovery_id.toNat &&& 2 ≠ 0 then r + n_256k1 else r

/-- `Q = u₁ • G + u₂ • R` with `u₁ = -e · r⁻¹` and `u₂ = s · r⁻¹` mod `n`, as naturals. -/
noncomputable def recQ (e r s : ℕ) (R : ECPoint) : ECPoint :=
  (-(e : ZMod n_256k1) * (r : ZMod n_256k1)⁻¹).val • basePoint +
    ((s : ZMod n_256k1) * (r : ZMod n_256k1)⁻¹).val • R

/-- `x ‖ y`, 32 big-endian bytes each, of a nonzero point. -/
def encodeXY : ECPoint → Option (Vector (BitVec 8) 64)
  | .zero => none
  | .some qx qy _ => some (be32 qx.val ++ be32 qy.val)

/-- SEC 1 v2 §4.1.6 public key recovery, as `fd_secp256k1_recover` returns it: `encodeXY Q` for
`Q = u₁ • G + u₂ • R`, `e = msg_hash mod n`, or `none`. -/
noncomputable def recoverSpec (msg_hash : Vector (BitVec 8) 32) (sig : Vector (BitVec 8) 64)
    (recovery_id : BitVec 32) : Option (Vector (BitVec 8) 64) :=
  if ¬(0 ≤ recovery_id.toInt ∧ recovery_id.toInt ≤ 3) then none
  else
    if ¬(0 < sigR sig ∧ sigR sig < n_256k1) then none
    else
      if ¬(0 < sigS sig ∧ sigS sig < n_256k1) then none
      else
        if p_256k1 ≤ recX recovery_id (sigR sig) then none
        else
          match liftX (recX recovery_id (sigR sig) : ZMod p_256k1) (recovery_id.toNat % 2) with
          | none => none
          | some R => encodeXY (recQ (beNat msg_hash % n_256k1) (sigR sig) (sigS sig) R)

end

/-! ## Stages of `fd_secp256k1_recover` -/

/-- The scalar stage: `u1 = -e · r⁻¹` and `u2 = s · r⁻¹`, plain and canonical. -/
theorem recover_scalars (hB : B.Spec) (msg : Vector (BitVec 8) 32) {rs s : fd_secp256k1_scalar_t}
    (hrs : scCanon rs) (hrs0 : toS rs ≠ 0) (hs : scCanon s) :
    limbsEval
          (B.scalar_demont
            (B.scalar_negate
              (B.scalar_mul (B.scalar_tomont (B.scalar_invert rs))
                (B.scalar_tomont
                  (B.scalar_reduce (fd_uint256_bswap.spec (fd_uint256_t.ofBuf msg))))))) =
        (-((beNat msg % n_256k1 : ℕ) : ZMod n_256k1) * (toS rs)⁻¹).val ∧
      limbsEval
          (B.scalar_demont
            (B.scalar_mul (B.scalar_tomont (B.scalar_invert rs)) (B.scalar_tomont s))) =
        (toS s * (toS rs)⁻¹).val := by
  have hm :
    scCanon (B.scalar_reduce (fd_uint256_bswap.spec (fd_uint256_t.ofBuf msg))) ∧
      toS (B.scalar_reduce (fd_uint256_bswap.spec (fd_uint256_t.ofBuf msg))) =
        ((beNat msg % n_256k1 : ℕ) : ZMod n_256k1) := by
    rw [scCanon, toS, hB.scalar_reduce, limbsEval_bswap_ofBuf]
    exact ⟨Nat.mod_lt _ n_256k1_pos, rfl⟩
  obtain ⟨ci, vi⟩ := hB.scalar_invert hrs hrs0
  obtain ⟨cr, vr⟩ := hB.scalar_tomont ci
  obtain ⟨cm, vm⟩ := hB.scalar_tomont hm.1
  obtain ⟨cs, vs⟩ := hB.scalar_tomont hs
  obtain ⟨c1, v1⟩ := hB.scalar_mul cr cm
  obtain ⟨c1', v1'⟩ := hB.scalar_negate_mont c1
  obtain ⟨c1'', v1''⟩ := hB.scalar_demont c1'
  obtain ⟨c2, v2⟩ := hB.scalar_mul cr cs
  obtain ⟨c2', v2'⟩ := hB.scalar_demont c2
  constructor
  · rw [← ZMod.val_cast_of_lt c1'']
    change (toS _).val = _
    rw [v1'', v1', v1, vr, vm, vi, hm.2, mul_comm, neg_mul]
  · rw [← ZMod.val_cast_of_lt c2']
    change (toS _).val = _
    rw [v2', v2, vr, vs, vi, mul_comm]

/-- The `x` stage: `r` is `rs` or `rs + n` in the field, or `NULL` when that is `≥ p`. -/
theorem recover_x (hB : B.Spec) {rs : fd_secp256k1_scalar_t} (hrs : scCanon rs)
    (recovery_id : BitVec 32) :
    ∃ r,
      (if recovery_id &&& 2#32 ≠ 0#32 then
            if (0#32).sle (fd_uint256_cmp.spec rs fd_secp256k1_const_p_minus_n) then none
            else some (B.fp_add (B.fp_tomont rs) fd_secp256k1_const_n_mont)
          else some (B.fp_tomont rs)) =
          (if p_256k1 ≤ recX recovery_id (limbsEval rs) then none else some r) ∧
        Tr r (recX recovery_id (limbsEval rs) : ZMod p_256k1) := by
  unfold recX
  have hnp := n_256k1_lt_p_256k1
  have hrp : fpCanon rs := lt_trans hrs hnp
  obtain ⟨ct, vt⟩ := hB.fp_tomont hrp
  have hb : (recovery_id &&& 2#32 ≠ 0#32) ↔ recovery_id.toNat &&& 2 ≠ 0 := by
    rw [ne_eq, ne_eq, BitVec.toNat_eq.not, BitVec.toNat_and]; rfl
  by_cases h : recovery_id.toNat &&& 2 ≠ 0
  · rw [ite_eq_left (hb.2 h), ite_eq_left h, fd_uint256_cmp.spec_sle, limbsEval_const_p_minus_n]
    have tn := tr_add hB ⟨ct, vt⟩ fd_secp256k1_const_n_mont.fp
    refine ⟨_, ?_, tn.1, by rw [tn.2, Nat.cast_add]⟩
    by_cases hc : p_256k1 - n_256k1 ≤ limbsEval rs
    · rw [decide_eq_true hc, ite_eq_left rfl,
        ite_eq_left (show p_256k1 ≤ limbsEval rs + n_256k1 by omega)]
    · rw [decide_eq_false hc, ite_eq_right Bool.false_ne_true,
        ite_eq_right (show ¬p_256k1 ≤ limbsEval rs + n_256k1 by omega)]
  · rw [ite_eq_right (fun h' => h (hb.1 h')), ite_eq_right h]
    refine ⟨_, ?_, ct, vt⟩
    rw [ite_eq_right (show ¬p_256k1 ≤ limbsEval rs by omega)]

/-- The output stage: on a representative of `R`, `u1 • G + u2 • R` is checked for zero, made
affine and stored. -/
theorem recover_tail (hB : B.Spec) {a : fd_secp256k1_point_t} {R : ECPoint} (ha : PRep a R)
    (u1 u2 : fd_secp256k1_scalar_t) (pk : Vector (BitVec 8) 64) :
    (if
          fd_secp256k1_point_is_identity.spec B (fd_secp256k1_double_base_mul.spec B u1 a u2) ≠
            0#32 then
        (⟨pk, none⟩ : fd_secp256k1_recover.Result)
      else
        ⟨storeBytes
            (storeBytes pk 0
              (B.fp_tobytes
                (fd_secp256k1_point_to_affine.spec B (fd_secp256k1_double_base_mul.spec B u1 a u2)
                    (fd_secp256k1_double_base_mul.spec B u1 a u2)).x))
            32
            (B.fp_tobytes
              (fd_secp256k1_point_to_affine.spec B (fd_secp256k1_double_base_mul.spec B u1 a u2)
                  (fd_secp256k1_double_base_mul.spec B u1 a u2)).y),
          some
            (storeBytes
              (storeBytes pk 0
                (B.fp_tobytes
                  (fd_secp256k1_point_to_affine.spec B (fd_secp256k1_double_base_mul.spec B u1 a u2)
                      (fd_secp256k1_double_base_mul.spec B u1 a u2)).x))
              32
              (B.fp_tobytes
                (fd_secp256k1_point_to_affine.spec B (fd_secp256k1_double_base_mul.spec B u1 a u2)
                    (fd_secp256k1_double_base_mul.spec B u1 a u2)).y))⟩) =
      ⟨(encodeXY (limbsEval u1 • basePoint + limbsEval u2 • R)).getD pk,
        encodeXY (limbsEval u1 • basePoint + limbsEval u2 • R)⟩ := by
  have hd := fd_secp256k1_double_base_mul.spec_rep hB u1 u2 ha
  generalize fd_secp256k1_double_base_mul.spec B u1 a u2 = q at hd ⊢
  generalize limbsEval u1 • basePoint + limbsEval u2 • R = Q at hd ⊢
  have hid := fd_secp256k1_point_is_identity.spec_rep hB hd
  cases Q with
  | zero =>
    rw [ite_eq_left (hid.2 rfl)]; rfl
  | some qx qy h =>
    rw [ite_eq_right (fun h' => Point.some_ne_zero h (hid.1 h'))]
    obtain ⟨tx, ty, -⟩ := fd_secp256k1_point_to_affine.spec_val hB (r := q) hd
    have ex := hB.fp_tobytes tx.1
    have ey := hB.fp_tobytes ty.1
    rw [tx.2] at ex
    rw [ty.2] at ey
    rw [← be32_beNat (B.fp_tobytes _), ex, ← be32_beNat (B.fp_tobytes (_ : fd_secp256k1_point_t).y),
      ey, storeBytes_storeBytes]
    rfl

/-! ## The main theorem -/

/-- `fd_secp256k1_recover` returns `recoverSpec`, and writes its output to `public_key` exactly on
success. -/
public theorem fd_secp256k1_recover.spec_eq (hB : B.Spec) (public_key : Vector (BitVec 8) 64)
    (msg_hash : Vector (BitVec 8) 32) (sig : Vector (BitVec 8) 64) (recovery_id : BitVec 32) :
    fd_secp256k1_recover.spec B public_key msg_hash sig recovery_id =
      ⟨(recoverSpec msg_hash sig recovery_id).getD public_key,
        recoverSpec msg_hash sig recovery_id⟩ := by
  unfold fd_secp256k1_recover.spec
  have hrid :
    ((0#32).sle recovery_id && recovery_id.sle 3#32) =
      decide (0 ≤ recovery_id.toInt ∧ recovery_id.toInt ≤ 3) := by
    simp [BitVec.sle_eq_decide]
  rw [hrid]
  dsimp only
  rw [recoverSpec]
  by_cases h1 : 0 ≤ recovery_id.toInt ∧ recovery_id.toInt ≤ 3
  swap
  · rw [decide_eq_false h1, ite_eq_left h1]; rfl
  rw [decide_eq_true h1, ite_eq_right (not_not.2 h1), ite_eq_right (by decide)]
  -- `r` and `s`
  have eR : sigR sig = beNat (Vector.ofFn fun j : Fin 32 => sig[j.val]) := rfl
  have eS : sigS sig = beNat (Vector.ofFn fun j : Fin 32 => sig[32 + j.val]) := rfl
  rw [eR, eS, hB.scalar_frombytes_ret]
  by_cases h2 :
    0 < beNat (Vector.ofFn fun j : Fin 32 => sig[j.val]) ∧
      beNat (Vector.ofFn fun j : Fin 32 => sig[j.val]) < n_256k1
  swap
  · rw [ite_eq_right h2, ite_eq_left h2]; rfl
  rw [ite_eq_left h2, ite_eq_right (not_not.2 h2)]
  dsimp only
  rw [hB.scalar_frombytes_ret]
  by_cases h3 :
    0 < beNat (Vector.ofFn fun j : Fin 32 => sig[32 + j.val]) ∧
      beNat (Vector.ofFn fun j : Fin 32 => sig[32 + j.val]) < n_256k1
  swap
  · rw [ite_eq_right h3, ite_eq_left h3]; rfl
  rw [ite_eq_left h3, ite_eq_right (not_not.2 h3)]
  dsimp only
  -- `x`
  have hR := hB.scalar_frombytes_r (Vector.ofFn fun j : Fin 32 => sig[j.val])
  have hS := hB.scalar_frombytes_r (Vector.ofFn fun j : Fin 32 => sig[32 + j.val])
  have hrs : scCanon (B.scalar_frombytes (Vector.ofFn fun j : Fin 32 => sig[j.val])).r := by
    rw [scCanon, hR]; exact h2.2
  have hss : scCanon (B.scalar_frombytes (Vector.ofFn fun j : Fin 32 => sig[32 + j.val])).r := by
    rw [scCanon, hS]; exact h3.2
  obtain ⟨r, hr, tr⟩ := recover_x hB hrs recovery_id
  rw [hR] at hr tr
  rw [hr]
  by_cases h4 : p_256k1 ≤ recX recovery_id (beNat (Vector.ofFn fun j : Fin 32 => sig[j.val]))
  · rw [ite_eq_left h4, ite_eq_left h4]; rfl
  rw [ite_eq_right h4, ite_eq_right h4]
  dsimp only
  -- `R`
  have hodd : (recovery_id &&& 1#32).toNat = recovery_id.toNat % 2 := by
    rw [BitVec.toNat_and]; exact Nat.and_one_is_mod _
  obtain ⟨hy1, hy2⟩ :=
    fd_secp256k1_recovery_y.spec_val hB default tr.1 (odd := recovery_id &&& 1#32) (by omega)
  rw [tr.2] at hy1 hy2
  rw [hodd] at hy2
  by_cases hsq :
    IsSquare
      (((recX recovery_id (beNat (Vector.ofFn fun j : Fin 32 => sig[j.val])) : ℕ) : ZMod p_256k1) ^
          3 +
        7)
  swap
  · rw [Option.not_isSome_iff_eq_none.1 (mt hy1.1 hsq), liftX_eq_none hsq]; rfl
  obtain ⟨hret, tx, tz, cy, hysq, hpar⟩ := hy2 hsq
  rw [hret, liftX_eq_some hysq hpar]
  dsimp only
  -- `Q`
  have hA :
    PRep (fd_secp256k1_recovery_y.spec B default r (recovery_id &&& 1#32)).r
      (.some _ _ (nonsingular_of_eqn cube_add_seven_ne_zero hysq)) := by
    refine ⟨⟨tx.1, cy, tz.1⟩, ?_⟩
    simp only [toP, Rep, tx.2, tz.2, mul_one]
    exact ⟨one_ne_zero, trivial, trivial⟩
  have hr0 : toS (B.scalar_frombytes (Vector.ofFn fun j : Fin 32 => sig[j.val])).r ≠ 0 := by
    rw [toS, hR]
    intro h0
    have := Nat.le_of_dvd h2.1 ((ZMod.natCast_eq_zero_iff _ _).1 h0)
    omega
  obtain ⟨hu1, hu2⟩ := recover_scalars hB msg_hash hrs hr0 hss
  refine (recover_tail hB hA _ _ public_key).trans ?_
  rw [hu1, hu2, toS, toS, hR, hS]
  rfl

/-- The s2n-bignum build, with or without `__ADX__`, returns `recoverSpec`. -/
public theorem fd_secp256k1_recover.s2n_eq (adx : Bool) (public_key : Vector (BitVec 8) 64)
    (msg_hash : Vector (BitVec 8) 32) (sig : Vector (BitVec 8) 64) (recovery_id : BitVec 32) :
    fd_secp256k1_recover.s2n adx public_key msg_hash sig recovery_id =
      ⟨(recoverSpec msg_hash sig recovery_id).getD public_key,
        recoverSpec msg_hash sig recovery_id⟩ :=
  fd_secp256k1_recover.spec_eq (S2n.backend_spec adx) public_key msg_hash sig recovery_id

/-- The fiat-crypto build returns `recoverSpec`. -/
public theorem fd_secp256k1_recover.ref_eq (public_key : Vector (BitVec 8) 64)
    (msg_hash : Vector (BitVec 8) 32) (sig : Vector (BitVec 8) 64) (recovery_id : BitVec 32) :
    fd_secp256k1_recover.ref public_key msg_hash sig recovery_id =
      ⟨(recoverSpec msg_hash sig recovery_id).getD public_key,
        recoverSpec msg_hash sig recovery_id⟩ :=
  fd_secp256k1_recover.spec_eq Ref.backend_spec public_key msg_hash sig recovery_id

/-! ## The textbook form

These assume `hn`, that every point has order dividing `n` (true since `#E(F_p) = n`, which is
not proved here); it makes the points a `ZMod n_256k1`-module. -/

/-- Assuming `hn` (every point has order dividing `n`; not proved), `Q = r⁻¹ • (s • R - e • G)`
with `ZMod n_256k1` scalars. -/
public theorem recQ_eq (hn : ∀ P : ECPoint, n_256k1 • P = 0) (e r s : ℕ) (R : ECPoint) :
    letI := AddCommGroup.zmodModule hn
    recQ e r s R =
      (r : ZMod n_256k1)⁻¹ • ((s : ZMod n_256k1) • R - (e : ZMod n_256k1) • basePoint) := by
  let _ : Module (ZMod n_256k1) ECPoint := AddCommGroup.zmodModule hn
  have hv : ∀ (k : ZMod n_256k1) (P : ECPoint), k • P = k.val • P := fun _ _ => rfl
  rw [recQ, ← hv, ← hv]
  module

/-- Assuming `hn` (every point has order dividing `n`; not proved), a successful `recoverSpec` outputs `x ‖ y` of `Q = r⁻¹ • (s • R - e • G)`, where
`R` is the lifted point and `e = msg_hash mod n`. -/
public theorem recoverSpec_eq_some (hn : ∀ P : ECPoint, n_256k1 • P = 0)
    {msg_hash : Vector (BitVec 8) 32} {sig : Vector (BitVec 8) 64} {recovery_id : BitVec 32}
    {out : Vector (BitVec 8) 64} (h : recoverSpec msg_hash sig recovery_id = some out) :
    letI := AddCommGroup.zmodModule hn
    ∃ R Q,
      liftX (recX recovery_id (sigR sig) : ZMod p_256k1) (recovery_id.toNat % 2) = some R ∧
        encodeXY Q = some out ∧
        Q =
          (sigR sig : ZMod n_256k1)⁻¹ •
            ((sigS sig : ZMod n_256k1) • R - (beNat msg_hash : ZMod n_256k1) • basePoint) := by
  let _ : Module (ZMod n_256k1) ECPoint := AddCommGroup.zmodModule hn
  unfold recoverSpec at h
  split_ifs at h
  cases hL : liftX (recX recovery_id (sigR sig) : ZMod p_256k1) (recovery_id.toNat % 2) with
  | none =>
    rw [hL] at h; exact absurd h (by simp)
  | some R =>
    rw [hL] at h
    refine ⟨R, _, rfl, h, ?_⟩
    rw [recQ_eq hn, ZMod.natCast_mod]

end Firedancer.Secp256k1
