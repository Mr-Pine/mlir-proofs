module

public import Firedancer.Bn254.Math.Ops
import Mathlib.Tactic.IntervalCases
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! Byte encodings of field elements: the big- and little-endian values the syscalls read, the bytes
they write, and the `frombytes_nm`/`tobytes_nm`/`is_neg_nm`/`neg_nm` helpers in those terms. -/

namespace Firedancer.Bn254

/-! ## Encodings -/

@[expose] public section

/-- The value of 32 bytes, big-endian if `be`, else little-endian. -/
def bytesToNat (be : Bool) (b : Vector (BitVec 8) 32) : ℕ :=
  if be then beNat b else beNat b.reverse

/-- The 32 big-endian bytes of `v mod 2^256`. -/
def natToBytesBE (v : ℕ) : Vector (BitVec 8) 32 :=
  Vector.ofFn fun j => BitVec.ofNat 8 (v / 256 ^ (31 - j.val))

/-- The 32 bytes of `v mod 2^256`, big-endian if `be`, else little-endian. -/
def natToBytes (be : Bool) (v : ℕ) : Vector (BitVec 8) 32 :=
  if be then natToBytesBE v else (natToBytesBE v).reverse

/-- The byte holding a field encoding's top bits (the flags). -/
def flagByte (be : Bool) (b : Vector (BitVec 8) 32) : BitVec 8 :=
  if be then b[0] else b[31]

end

/-! ## Limbs and bytes -/

theorem byte_split (x : BitVec 64) :
    x.extractLsb' 56 8 ++ x.extractLsb' 48 8 ++ x.extractLsb' 40 8 ++ x.extractLsb' 32 8 ++
        x.extractLsb' 24 8 ++
        x.extractLsb' 16 8 ++
        x.extractLsb' 8 8 ++
        x.extractLsb' 0 8 =
      x := by
  bv_decide

public theorem buf_ofBuf (b : Vector (BitVec 8) 32) : (fd_uint256_t.ofBuf b).buf = b := by
  refine Vector.ext fun j hj => ?_
  have e (x7 x6 x5 x4 x3 x2 x1 x0 : BitVec 8) :
    (x7 ++ x6 ++ x5 ++ x4 ++ x3 ++ x2 ++ x1 ++ x0 : BitVec 64).extractLsb' 0 8 = x0 ∧
      (x7 ++ x6 ++ x5 ++ x4 ++ x3 ++ x2 ++ x1 ++ x0 : BitVec 64).extractLsb' 8 8 = x1 ∧
      (x7 ++ x6 ++ x5 ++ x4 ++ x3 ++ x2 ++ x1 ++ x0 : BitVec 64).extractLsb' 16 8 = x2 ∧
      (x7 ++ x6 ++ x5 ++ x4 ++ x3 ++ x2 ++ x1 ++ x0 : BitVec 64).extractLsb' 24 8 = x3 ∧
      (x7 ++ x6 ++ x5 ++ x4 ++ x3 ++ x2 ++ x1 ++ x0 : BitVec 64).extractLsb' 32 8 = x4 ∧
      (x7 ++ x6 ++ x5 ++ x4 ++ x3 ++ x2 ++ x1 ++ x0 : BitVec 64).extractLsb' 40 8 = x5 ∧
      (x7 ++ x6 ++ x5 ++ x4 ++ x3 ++ x2 ++ x1 ++ x0 : BitVec 64).extractLsb' 48 8 = x6 ∧
      (x7 ++ x6 ++ x5 ++ x4 ++ x3 ++ x2 ++ x1 ++ x0 : BitVec 64).extractLsb' 56 8 = x7 := by
    refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> bv_decide
  interval_cases j <;> simp [fd_uint256_t.buf, fd_uint256_t.ofBuf, e]

public theorem ofBuf_injective : Function.Injective fd_uint256_t.ofBuf := fun a b h => by
  rw [← buf_ofBuf a, ← buf_ofBuf b, h]

public theorem bswap_ofBuf (b : Vector (BitVec 8) 32) :
    fd_uint256_bswap.spec (fd_uint256_t.ofBuf b) = fd_uint256_t.ofBuf b.reverse := by
  refine Vector.ext fun i hi => ?_
  interval_cases i <;> simp [fd_uint256_bswap.spec, fd_uint256_t.ofBuf, bswap_bytes]

public theorem limbsEval_ofBuf (b : Vector (BitVec 8) 32) :
    limbsEval (fd_uint256_t.ofBuf b) = beNat b.reverse := by
  rw [← limbsEval_bswap_ofBuf, bswap_ofBuf, Vector.reverse_reverse]

theorem horner_step (x i : ℕ) : x / 256 % 256 ^ i * 256 + x % 256 = x % 256 ^ (i + 1) := by
  rw [pow_succ', Nat.mod_mul]; omega

theorem horner_natToBytesBE (v : ℕ) :
    ∀ (n : ℕ) (hn : n ≤ 32),
      Nat.fold n (fun i (h : i < n) acc => acc * 256 + ((natToBytesBE v)[i]'(by omega)).toNat) 0 =
        v / 256 ^ (32 - n) % 256 ^ n
  | 0, _ => by simp only [Nat.fold_zero, pow_zero, Nat.mod_one]
  | n + 1, hn => by
    rw [Nat.fold_succ, horner_natToBytesBE v n (by omega)]
    simp only [natToBytesBE, Vector.getElem_ofFn, BitVec.toNat_ofNat]
    rw [show 32 - n = (31 - n) + 1 by omega, pow_succ, ← Nat.div_div_eq_div_mul,
      show (2 : ℕ) ^ 8 = 256 by norm_num, horner_step, show 32 - (n + 1) = 31 - n by omega]

public theorem beNat_natToBytesBE (v : ℕ) : beNat (natToBytesBE v) = v % 2 ^ 256 := by
  have := horner_natToBytesBE v 32 le_rfl
  rw [Nat.sub_self, pow_zero, Nat.div_one] at this
  rw [show (2 : ℕ) ^ 256 = 256 ^ 32 by norm_num, ← this]
  rfl

public theorem buf_eq_natToBytes (a : fd_uint256_t) :
    a.buf = (natToBytesBE (limbsEval a)).reverse := by
  apply ofBuf_injective
  rw [ofBuf_buf]
  apply limbsEval_injective
  rw [limbsEval_ofBuf, Vector.reverse_reverse, beNat_natToBytesBE,
    Nat.mod_eq_of_lt (limbsEval_lt a)]

public theorem bswap_buf (a : fd_uint256_t) :
    (fd_uint256_bswap.spec a).buf = natToBytesBE (limbsEval a) := by
  apply ofBuf_injective
  rw [ofBuf_buf, ← Vector.reverse_reverse (natToBytesBE _), ← bswap_ofBuf, ← buf_eq_natToBytes,
    ofBuf_buf]

/-! ## Masking the flag bits -/

theorem ofBuf_mask (r : fd_uint256_t) :
    fd_uint256_t.ofBuf (r.buf.set 31 (r.buf[31] &&& FLAG_MASK)) =
      r.set 3 (r[3] &&& 0x3FFFFFFFFFFFFFFF) := by
  have m0 (x : BitVec 64) :
    (x.extractLsb' 56 8 &&& FLAG_MASK) ++ x.extractLsb' 48 8 ++ x.extractLsb' 40 8 ++
        x.extractLsb' 32 8 ++
        x.extractLsb' 24 8 ++
        x.extractLsb' 16 8 ++
        x.extractLsb' 8 8 ++
        x.extractLsb' 0 8 =
      x &&& 0x3FFFFFFFFFFFFFFF := by
    unfold FLAG_MASK; bv_decide
  refine Vector.ext fun i hi => ?_
  interval_cases i <;>
    simp [fd_uint256_t.ofBuf, fd_uint256_t.buf, Vector.getElem_set, byte_split, m0]

public theorem limbsEval_mask (r : fd_uint256_t) :
    limbsEval (fd_uint256_t.ofBuf (r.buf.set 31 (r.buf[31] &&& FLAG_MASK))) =
      limbsEval r % 2 ^ 254 := by
  rw [ofBuf_mask, limbsEval_four, limbsEval_four]
  simp only [Vector.getElem_set, Nat.reduceEqDiff, ↓reduceIte, BitVec.toNat_and]
  rw [show (0x3FFFFFFFFFFFFFFF : BitVec 64).toNat = 2 ^ 62 - 1 by rfl,
    Nat.and_two_pow_sub_one_eq_mod]
  have := r[0].isLt; have := r[1].isLt; have := r[2].isLt
  omega

/-! ## `frombytes_nm`, `tobytes_nm` -/

public theorem limbsEval_read (buf : Vector (BitVec 8) 32) (be : BitVec 32) :
    limbsEval
        (if be ≠ 0 then fd_uint256_bswap.spec (fd_uint256_t.ofBuf buf)
        else fd_uint256_t.ofBuf buf) =
      bytesToNat (be ≠ 0) buf := by
  unfold bytesToNat
  by_cases h : be ≠ 0
  · simp only [h, decide_true, ↓reduceIte, ne_eq, not_false_eq_true, limbsEval_bswap_ofBuf]
  · simp only [h, decide_false, Bool.false_eq_true, ↓reduceIte, limbsEval_ofBuf]

/-- `frombytes_nm`: the flags of the flag byte, `NULL` exactly on both flags (when read) or a value
`≥ p` (after masking the flags, when read), else the value. -/
public theorem fd_bn254_fp_frombytes_nm.val (r : fd_bn254_fp_t) (buf : Vector (BitVec 8) 32)
    (be : BitVec 32) (flags : Option (BitVec 32 × BitVec 32)) :
    let res := fd_bn254_fp_frombytes_nm.spec r buf be flags
    let fb := flagByte (be ≠ 0) buf
    let V := if flags.isSome then bytesToNat (be ≠ 0) buf % 2 ^ 254 else bytesToNat (be ≠ 0) buf
    res.flags =
        flags.map
          (fun _ =>
            ((if fb &&& FLAG_INF ≠ 0 then 1 else 0), (if fb &&& FLAG_NEG ≠ 0 then 1 else 0))) ∧
      (res.ret = none ↔ (flags.isSome ∧ fb &&& FLAG_INF ≠ 0 ∧ fb &&& FLAG_NEG ≠ 0) ∨ p_bn254 ≤ V) ∧
      ∀ q, res.ret = some q → res.r = q ∧ limbsEval q = V := by
  intro res fb V
  have hfb : (if be ≠ 0 then buf[0] else buf[31]) = fb := by
    simp only [fb, flagByte]; split_ifs with h <;> simp_all
  have hread := limbsEval_read buf be
  simp only [res, fd_bn254_fp_frombytes_nm.spec, hfb]
  generalize
    (if be ≠ 0 then fd_uint256_bswap.spec (fd_uint256_t.ofBuf buf) else fd_uint256_t.ofBuf buf) =
    R at hread ⊢
  have hmask := limbsEval_mask R
  generalize fd_uint256_t.ofBuf (R.buf.set 31 (R.buf[31] &&& FLAG_MASK)) = M at hmask ⊢
  have one32 : (1 : BitVec 32) ≠ 0 := by decide
  generalize hX : bytesToNat (be ≠ 0) buf = X at hread ⊢
  rw [fd_uint256_cmp.spec_sle, limbsEval_const_p]
  cases flags with
  | none =>
    have hV : V = X := by
      rw [← hX]; simp [V]
    rw [hV]
    simp only [Option.map_none, Option.isSome_none, Bool.false_eq_true, false_and, ↓reduceIte,
      false_or]
    rw [hread]
    by_cases hc : p_bn254 ≤ X
    · rw [ite_eq_left (decide_eq_true hc)]
      exact ⟨rfl, iff_of_true rfl hc, fun q hq => by cases hq⟩
    · rw [ite_eq_right (by simpa using hc)]
      refine ⟨rfl, iff_of_false (by simp) hc, fun q hq => ?_⟩
      simp only [Option.some.injEq] at hq; subst hq; exact ⟨rfl, hread⟩
  | some
    f =>
    have hV : V = X % 2 ^ 254 := by
      rw [← hX]; simp [V]
    rw [hV]
    simp only [Option.map_some, Option.isSome_some, true_and, ↓reduceIte]
    rw [hmask, hread]
    by_cases hf : fb &&& FLAG_INF ≠ 0 ∧ fb &&& FLAG_NEG ≠ 0
    · rw [ite_eq_left
          (by
            rw [ite_eq_left hf.1, ite_eq_left hf.2]; exact ⟨one32, one32⟩)]
      exact ⟨rfl, iff_of_true rfl (.inl hf), fun q hq => by cases hq⟩
    · have hf2 :
        ¬((if fb &&& FLAG_INF ≠ 0 then (1 : BitVec 32) else 0) ≠ 0 ∧
            (if fb &&& FLAG_NEG ≠ 0 then (1 : BitVec 32) else 0) ≠ 0) := by
        intro ⟨h1, h2⟩; apply hf
        exact
          ⟨fun h0 => h1 (by rw [ite_eq_right (not_not.mpr h0)]), fun h0 =>
            h2 (by rw [ite_eq_right (not_not.mpr h0)])⟩
      rw [ite_eq_right hf2]
      by_cases hc : p_bn254 ≤ X % 2 ^ 254
      · rw [ite_eq_left (decide_eq_true hc)]
        exact ⟨rfl, iff_of_true rfl (.inr hc), fun q hq => by cases hq⟩
      · rw [ite_eq_right (by simpa using hc)]
        refine ⟨rfl, iff_of_false (by simp) (by rintro (h | h) <;> contradiction), fun q hq => ?_⟩
        simp only [Option.some.injEq] at hq; subst hq; exact ⟨rfl, by rw [hmask, hread]⟩

/-- `tobytes_nm` writes the value's bytes in the requested order. -/
public theorem fd_bn254_fp_tobytes_nm.buf_eq (a : fd_bn254_fp_t) (be : BitVec 32) :
    (fd_bn254_fp_tobytes_nm.spec a be).buf = natToBytes (be ≠ 0) (limbsEval a) := by
  unfold fd_bn254_fp_tobytes_nm.spec natToBytes
  by_cases h : be ≠ 0
  · rw [ite_eq_left h, ite_eq_left (decide_eq_true h)]; exact bswap_buf a
  · rw [ite_eq_right h, ite_eq_right (by simpa using h)]; exact buf_eq_natToBytes a

/-! ## Signs and negation of plain values -/

theorem cmp_slt (a b : fd_uint256_t) :
    (0#32).slt (fd_uint256_cmp.spec a b) = decide (limbsEval b < limbsEval a) := by
  have := a[0].isLt; have := a[1].isLt; have := a[2].isLt; have := a[3].isLt
  have := b[0].isLt; have := b[1].isLt; have := b[2].isLt; have := b[3].isLt
  rw [limbsEval_four, limbsEval_four]
  unfold fd_uint256_cmp.spec
  simp only [ne_eq, ← BitVec.toNat_inj, BitVec.lt_def]
  split_ifs <;>
    simp only [show (0#32).slt 0 = false from rfl, show (0#32).slt 1 = true from rfl,
      show (0#32).slt (-1) = false from rfl, eq_comm (a := true), eq_comm (a := false),
      decide_eq_true_eq, decide_eq_false_iff_not] <;>
    omega

theorem limbsEval_half : limbsEval fd_bn254_const_p_minus_one_half = p_bn254 / 2 := by
  simp [limbsEval_four, fd_bn254_const_p_minus_one_half, p_bn254]

/-- `is_neg_nm` tests `x > (p-1)/2`. -/
public theorem fd_bn254_fp_is_neg_nm.spec_ne_zero (x : fd_bn254_fp_t) :
    fd_bn254_fp_is_neg_nm.spec x ≠ 0 ↔ p_bn254 / 2 < limbsEval x := by
  unfold fd_bn254_fp_is_neg_nm.spec
  rw [cmp_slt, limbsEval_half]
  by_cases h : p_bn254 / 2 < limbsEval x
  · simp only [h, decide_true, ↓reduceIte]; decide
  · simp only [h, decide_false, Bool.false_eq_true, ↓reduceIte, ne_eq, not_true_eq_false]

theorem neg_limb_nm (p b cy : BitVec 64) (hc : cy = 0 ∨ cy = 1) :
    let b' := b + cy
    let cy' : BitVec 64 := (if b' < cy then 1 else 0) + (if p < b' then 1 else 0)
    (p - b').toNat + b.toNat + cy.toNat = p.toNat + cy'.toNat * 2 ^ 64 ∧ (cy' = 0 ∨ cy' = 1) := by
  intro b' cy'
  have hbv :
    ((p - b').setWidth 66 + b.setWidth 66 + cy.setWidth 66 =
        p.setWidth 66 + cy'.setWidth 66 <<< 64) ∧
      (cy' = 0 ∨ cy' = 1) := by
    simp only [b', cy']; rcases hc with rfl | rfl <;> bv_decide
  refine ⟨?_, hbv.2⟩
  have h := congrArg BitVec.toNat hbv.1
  have := p.isLt; have := b.isLt; have := (p - b').isLt
  have hc2 : cy'.toNat ≤ 1 := by rcases hbv.2 with h | h <;> rw [h] <;> decide
  have hc1 : cy.toNat ≤ 1 := by rcases hc with rfl | rfl <;> decide
  simp only [BitVec.toNat_add, BitVec.toNat_setWidth, BitVec.toNat_shiftLeft] at h
  rw [Nat.shiftLeft_eq] at h
  omega

/-- `neg_nm` of a plain `0 < a < p` is `p - a`; of `0` it is `0`. -/
public theorem fd_bn254_fp_neg_nm.val (a : fd_bn254_fp_t) (ha : limbsEval a < p_bn254) :
    limbsEval (fd_bn254_fp_neg_nm.spec a) =
      if limbsEval a = 0 then 0 else p_bn254 - limbsEval a := by
  unfold fd_bn254_fp_neg_nm.spec
  by_cases h0 : limbsEval a = 0
  · rw [ite_eq_left h0, ite_eq_left ((fd_bn254_fp_is_zero.spec_ne_zero_iff a).mpr h0)]
    exact limbsEval_set_zero
  rw [ite_eq_right h0, ite_eq_right (mt (fd_bn254_fp_is_zero.spec_ne_zero_iff a).mp h0)]
  dsimp only
  obtain ⟨e0, b0⟩ := neg_limb_nm fd_bn254_const_p[0] a[0] 0 (.inl rfl)
  obtain ⟨e1, b1⟩ := neg_limb_nm fd_bn254_const_p[1] a[1] _ b0
  obtain ⟨e2, b2⟩ := neg_limb_nm fd_bn254_const_p[2] a[2] _ b1
  obtain ⟨e3, -⟩ := neg_limb_nm fd_bn254_const_p[3] a[3] _ b2
  have hp := limbsEval_const_p
  rw [limbsEval_four] at hp
  rw [limbsEval_four] at ha h0 ⊢
  simp only [Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero,
    List.getElem_cons_succ]
  simp only [bv_toNat_zero, add_zero] at e0
  generalize fd_bn254_const_p[0] = p0 at *
  generalize fd_bn254_const_p[1] = p1 at *
  generalize fd_bn254_const_p[2] = p2 at *
  generalize fd_bn254_const_p[3] = p3 at *
  rw [limbsEval_four]
  omega

end Firedancer.Bn254
