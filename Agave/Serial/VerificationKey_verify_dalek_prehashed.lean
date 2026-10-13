module

public import Agave.Common.Copy
public import Agave.Common.Decompress
public import Agave.Common.Tactics
public import Agave.Serial.CompressedEdwardsY_decompress
public import Agave.Serial.EdwardsPoint_is_small_order
public import Agave.Serial.FieldElement51_Mul_mul
public import Agave.Serial.FieldElement51_is_negative
public import Agave.Serial.FieldElement51_pow22501
public import Agave.Serial.FieldElement51_pow2k
public import Agave.Serial.FieldElement51_to_bytes
public import Agave.Serial.Mlir.VerificationKey_verify_dalek_prehashed
public import Agave.Serial.Scalar_reduce
public import Agave.Serial.black_box_u8
public import Agave.Serial.mul
public import Agave.Serial.slice_u8_ConstantTimeEq_ct_eq
public import Firedancer.Common.Tactics
public import MLIR.Run.Tactic
import all MLIR.Semantics.Effectful.Memory.Bits
import Mathlib.Tactic.FinCases
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Serial

/-! ## Specification -/

@[expose] public section

/-- `z.invert()`, `z^(p-2)`: `(t19, t3) = z.pow22501()`, `t20 = t19.pow2k(5)`, `&t20 * &t3`. -/
def FieldElement51_invert.spec (z : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let t := FieldElement51_pow22501.spec z
  let t20 := FieldElement51_pow2k.spec t.1 5
  FieldElement51_Mul_mul.spec t20 t.2

/-- `P.compress()`, `P.to_affine().compress()`: `recip = Z.invert()`, `x = &X * &recip`,
`y = &Y * &recip`, `s = y.to_bytes()`, `s[31] ^= x.is_negative() << 7`. -/
def EdwardsPoint_compress.spec (P : EdwardsPoint) : BitVec 256 :=
  let recip := FieldElement51_invert.spec P.Z
  let x := FieldElement51_Mul_mul.spec P.X recip
  let y := FieldElement51_Mul_mul.spec P.Y recip
  let s := FieldElement51_to_bytes.spec y
  (s.extractLsb' 248 8 ^^^ FieldElement51_is_negative.spec x <<< 7) ++ s.extractLsb' 0 248

/-- `Scalar::from_canonical_bytes(bytes)`'s `Choice`, `high_bit_unset & candidate.is_canonical()`:
`bytes[31] >> 7 == 0` and `bytes.ct_eq(&bytes.reduce())`, in the code's operand order. -/
def Scalar_from_canonical_bytes.spec (bytes : BitVec 256) : BitVec 8 :=
  let high_bit_unset := (BitVec.ofBool (bytes.extractLsb' 248 8 >>> 7 = 0#8)).setWidth 8
  slice_u8_ConstantTimeEq_ct_eq.spec bytes (Scalar_reduce.spec bytes) &&& high_bit_unset

/-- `verify_dalek_prehashed(signature = r ‖ s, h)` with `self.minus_A`, as `Result<(), Error>`'s
byte: `2` (`Err(InvalidSignature)`) or `-1` (`Ok(())`), the checks in the Rust's order. -/
def VerificationKey_verify_dalek_prehashed.spec (minus_A : EdwardsPoint) (r s h : BitVec 256) :
    BitVec 8 :=
  if EdwardsPoint_is_small_order.spec minus_A = 1#1 then 2#8
  else
    match CompressedEdwardsY_decompress.spec r with
    | none => 2#8
    | some R =>
      if EdwardsPoint_is_small_order.spec R = 1#1 then 2#8
      else
        if Scalar_from_canonical_bytes.spec s = 1#8 then
          let expected_R := EdwardsPoint_compress.spec (mul.spec h minus_A s)
          if expected_R = r then -1#8 else 2#8
        else 2#8

/-- The blocks the function allocates, its callees' included: its 14 slots, then each call's. -/
def VerificationKey_verify_dalek_prehashed.blocks (minus_A : EdwardsPoint) (r s h : BitVec 256) :
    Nat :=
  14 + 101 +
    if EdwardsPoint_is_small_order.spec minus_A = 1#1 then 0
    else
      match CompressedEdwardsY_decompress.spec r with
      | none => 158
      | some R =>
        159 + 101 +
          if EdwardsPoint_is_small_order.spec R = 1#1 then 0
          else
            1 + 19 + 33 + 1 +
              if Scalar_from_canonical_bytes.spec s = 1#8 then mul.blocks h s + 20 + 2 else 0

end

/-! ## Proof -/

section Proof

set_option hygiene false in
/-- `memcpy_n n hsrc hx`: a `memcpy` of `n` bytes by `run_memcpy_read`, for a source `step_memcpy`
cannot read (an object store's); its facts given, the others by `mem_fact`. -/
local macro "memcpy_n " n:num hsrc:term:max hx:term:max : tactic =>
  `(tactic|
      step_impure =>
        (expect_values; exact run_memcpy_read (n := $n) rfl (by mem_fact) (by mem_fact) $hsrc $hx))

/-- `memcpy` of `n` known bytes read as `x`: a store of `x`. -/
theorem run_memcpy_read {dst src : Pointer} {len : BitVec w} {n : Nat} {x : BitVec (8 * n)}
    (hn : len.toNat = n) (hd : (Range.of dst (8 * n)).Disjoint (Range.of src (8 * n)))
    (hfd : Room s.mem dst (8 * n)) (hfs : Fits s.mem src (8 * n))
    (hx : s.mem.readAt src (8 * n) = x) :
    (Operation.memcpy (.value dst) (.value src) (.value len)) env s =
      .value (env, { s with mem := s.mem.storeAt dst x }) := by
  rw [run_memcpy hn hd hfd hfs, hx]

/-- `reduce` on bytes that reduce to `x`. -/
theorem reduce_call_eq {out self : Pointer} {s : GlobalState} {x : BitVec 256} (hwf : s.WF)
    (hout : Room s.mem out (8 * 32)) (hout_off : ¬out.offset.uaddOverflow 32#64)
    (hself : Fits s.mem self 256) (hself_off : ¬self.offset.uaddOverflow 32#64)
    (hx : Scalar_reduce.spec (s.mem.readAt self 256) = x) :
    Scalar_reduce.call (Scalar_reduce.args (.value out) (.value self)) s =
      .value (.nil, { alloc := ⟨s.alloc.nextFreeBlock + 19⟩, mem := s.mem.storeAt out x }) := by
  rw [Scalar_reduce.call_eq out self s hwf hout hout_off hself hself_off, hx]

/-! The field calls of `compress`, their inputs given by read facts. -/

theorem pow22501_call_eq {out z : Pointer} {s : GlobalState} {Z : Fin 5 → BitVec 64} (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (hout' : s.mem.LimbsRoom (out.add 40#64))
    (hoff : out.offset.toNat + 72 < 2 ^ 64) (hz : s.mem.LimbsFit z) (hZ : s.mem.readLimbs z = Z) :
    FieldElement51_pow22501.call (FieldElement51_pow22501.args (.value out) (.value z)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 20⟩,
            mem :=
              (s.mem.storeLimbs out (FieldElement51_pow22501.spec Z).1).storeLimbs (out.add 40#64)
                (FieldElement51_pow22501.spec Z).2 }) := by
  rw [FieldElement51_pow22501.call_eq out z s hwf hout hout' hoff hz, hZ]

theorem pow2k_call_eq {out a : Pointer} {k : BitVec 32} {s : GlobalState} {X : Fin 5 → BitVec 64}
    (hwf : s.WF) (hout : s.mem.LimbsRoom out) (ha : s.mem.LimbsFit a) (hk0 : 0 < k.toNat)
    (hk : k.toNat < 2 ^ 31) (hX : s.mem.readLimbs a = X) :
    FieldElement51_pow2k.call (FieldElement51_pow2k.args (.value out) (.value a) (.value k)) s =
      .value
        (.nil, { s with mem := s.mem.storeLimbs out (FieldElement51_pow2k.spec X k.toNat) }) := by
  rw [FieldElement51_pow2k.call_eq out a k s hwf hout ha hk0 hk, hX]

theorem mul_call_eq {out a b : Pointer} {s : GlobalState} {X Y : Fin 5 → BitVec 64} (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (ha : s.mem.LimbsFit a) (hb : s.mem.LimbsFit b)
    (hX : s.mem.readLimbs a = X) (hY : s.mem.readLimbs b = Y) :
    FieldElement51_Mul_mul.call (FieldElement51_Mul_mul.args (.value out) (.value a) (.value b)) s =
      .value (.nil, { s with mem := s.mem.storeLimbs out (FieldElement51_Mul_mul.spec X Y) }) := by
  rw [FieldElement51_Mul_mul.call_eq out a b s hwf hout ha hb, hX, hY]

theorem to_bytes_call_eq {out a : Pointer} {s : GlobalState} {X : Fin 5 → BitVec 64} (hwf : s.WF)
    (hout : Room s.mem out (8 * 32)) (hout_off : ¬out.offset.uaddOverflow 32#64)
    (ha : s.mem.LimbsFit a) (hX : s.mem.readLimbs a = X) :
    FieldElement51_to_bytes.call (FieldElement51_to_bytes.args (.value out) (.value a)) s =
      .value (.nil, { s with mem := s.mem.storeAt out (FieldElement51_to_bytes.spec X) }) := by
  rw [FieldElement51_to_bytes.call_eq out a s hwf hout hout_off ha, hX]

theorem is_negative_call_eq {a : Pointer} {s : GlobalState} {X : Fin 5 → BitVec 64} (hwf : s.WF)
    (ha : s.mem.LimbsFit a) (hX : s.mem.readLimbs a = X) :
    FieldElement51_is_negative.call (FieldElement51_is_negative.args (.value a)) s =
      .value
        (.cons (.value (FieldElement51_is_negative.spec X)) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩, mem := s.mem }) := by
  rw [FieldElement51_is_negative.call_eq a s hwf ha, hX]

/-- A read past `decompress`'s result in another block. -/
theorem readAt_storeOptEdwards_of_id_ne {m : MemoryState} {p q : Pointer} {P : Option EdwardsPoint}
    (h : p.id ≠ q.id) : (m.storeOptEdwards p P).readAt q w = m.readAt q w := by
  cases P <;> simp only [MemoryState.storeOptEdwards]
  · exact MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne h) _
  · rw [MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne h),
      MemoryState.readAt_storeEdwards_of_id_ne (by simpa only [Pointer.add_id] using h)]

/-- A point read past `decompress`'s result in another block. -/
theorem readEdwards_storeOptEdwards_of_id_ne {m : MemoryState} {p q : Pointer}
    {P : Option EdwardsPoint} (h : p.id ≠ q.id) :
    (m.storeOptEdwards p P).readEdwards q = m.readEdwards q := by
  have hl (k : BitVec 64) :
    (m.storeOptEdwards p P).readLimbs (q.add k) = m.readLimbs (q.add k) := by
    have h' : p.id ≠ (q.add k).id := by simpa only [Pointer.add_id] using h
    cases P <;> simp only [MemoryState.storeOptEdwards]
    · exact MemoryState.readLimbs_storeAt_of_id_ne h'
    · rw [MemoryState.readLimbs_storeAt_of_id_ne h',
        MemoryState.readLimbs_storeEdwards_of_id_ne (by simpa only [Pointer.add_id] using h')]
  have h0 := hl 0#64
  simp only [Pointer.add_zero'] at h0
  simp only [MemoryState.readEdwards, h0, hl]

attribute [local mlir_read] readAt_storeOptEdwards_of_id_ne readEdwards_storeOptEdwards_of_id_ne

/-- No wrap past `s`, 32 bytes into a signature whose 64 bytes do not wrap. -/
theorem s_noOverflow {p : Pointer} (h : ¬p.offset.uaddOverflow 64#64) :
    ¬(p.add 32#64).offset.uaddOverflow 32#64 := by
  simp only [Pointer.add, BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le, BitVec.toNat_add,
    BitVec.toNat_ofNat] at h ⊢
  omega

/-- `s[31]`, byte 63 of the signature. -/
theorem readAt_s31 {m : MemoryState} {p : Pointer} {sc : BitVec 256}
    (hb : InBounds m (p.add 32#64) 256) (hov : ¬(p.add 32#64).offset.uaddOverflow 32#64)
    (h : m.readAt (p.add 32#64) 256 = sc) : m.readAt (p.add 63#64) 8 = sc.extractLsb' 248 8 := by
  simpa using
    MemoryState.readAt_add_of_readAt (off := 31#64) (w := 8) hb
      (BitVec.not_uaddOverflow_of_le hov (by decide)) (by decide) h

/-- `s[1..32]`, bytes 33 to 63 of the signature. -/
theorem readAt_s_tail {m : MemoryState} {p : Pointer} {sc : BitVec 256}
    (hb : InBounds m (p.add 32#64) 256) (hov : ¬(p.add 32#64).offset.uaddOverflow 32#64)
    (h : m.readAt (p.add 32#64) 256 = sc) : m.readAt (p.add 33#64) 248 = sc.extractLsb' 8 248 := by
  simpa using
    MemoryState.readAt_add_of_readAt (off := 1#64) (w := 248) hb
      (BitVec.not_uaddOverflow_of_le hov (by decide)) (by decide) h

/-- `s[0]`, byte 32 of the signature. -/
theorem readAt_s0 {m : MemoryState} {p : Pointer} {sc : BitVec 256}
    (h : m.readAt (p.add 32#64) 256 = sc) : m.readAt (p.add 32#64) 8 = sc.setWidth 8 :=
  MemoryState.readAt_of_readAt_le (by decide) h

/-- `s` copied to `p` as `s[1..32]`, then `s[0]`: its 256 bits. -/
theorem scalar_copy {m : MemoryState} {p : Pointer} {sc : BitVec 256} (ho : p.offset = 0)
    (h0 : Fits m p 8) (h1 : Fits m (p.add 1#64) 248) (hr0 : m.readAt p 8 = sc.setWidth 8)
    (hr1 : m.readAt (p.add 1#64) 248 = sc.extractLsb' 8 248) :
    Fits m p 256 ∧ m.readAt p 256 = sc := by
  have hov : ¬p.offset.uaddOverflow 1#64 := by simp [ho, BitVec.uaddOverflow]
  have hf := Fits.append hov (by decide) rfl h0 h1
  refine ⟨hf, ?_⟩
  rw [readAt_append (v := 8) (w := 248) hf.inBounds hov (by decide) hr0 hr1]
  bv_decide

/-- The code's `high_bit_unset`, `s[31] > -1` as a signed byte. -/
theorem high_bit_eq (x : BitVec 8) :
    (BitVec.ofBool ((255#8).slt x)).setWidth 8 = (BitVec.ofBool (x >>> 7 = 0#8)).setWidth 8 := by
  bv_decide

/-- A canonical `s` has bit 255 clear. -/
theorem lt_of_canonical {sc : BitVec 256} (h : Scalar_from_canonical_bytes.spec sc = 1#8) :
    sc.toNat < 2 ^ 255 := by
  simp only [Scalar_from_canonical_bytes.spec] at h
  generalize slice_u8_ConstantTimeEq_ct_eq.spec sc (Scalar_reduce.spec sc) = c at h
  have : sc < BitVec.ofNat 256 (2 ^ 255) := by bv_decide
  simpa [BitVec.lt_def] using this

/-- A byte spliced in at bit 248: the byte on top of the low 248 bits. -/
theorem spliceBits_248 (s : BitVec 256) (b : BitVec 8) :
    Memory.spliceBits s 248 b = b ++ s.extractLsb' 0 248 := by
  simp only [Memory.spliceBits]
  bv_decide

/-- The code's result select on `bcmp(expected, r, 32) == 0`. -/
theorem bcmp_select {u : Unspecified} {x y : BitVec (8 * 32)} {a b : BitVec 8} :
    (if BitVec.ofBool (Operation.bcmpResult u 32 x y == 0#32) = 1#1 then a else b) =
      if x = y then a else b := by
  have h : (Operation.bcmpResult u 32 x y == 0#32) = decide (x = y) := by
    rw [Bool.eq_iff_iff, beq_iff_eq, decide_eq_true_iff]
    exact Operation.bcmpResult_eq_zero_iff
  rw [h]
  by_cases hxy : x = y <;> simp [hxy]

/-- The point at `p`, from the 1280 bits there. -/
public theorem readEdwards_of_readAt {m : MemoryState} {p : Pointer} {P : EdwardsPoint}
    (hf : Fits m p 1280) (ho : p.offset.toNat + 160 ≤ 2 ^ 64)
    (h : m.readAt p 1280 = edwardsBits P) : m.readEdwards p = P := by
  -- in a copy of `m` with `p`'s block writable, which reads the same
  have hr (q : Pointer) (w : Nat) : (m.makeWritable p.id).readAt q w = m.readAt q w :=
    MemoryState.readAt_makeWritable
  have hl (q : Pointer) : (m.makeWritable p.id).readLimbs q = m.readLimbs q := by
    funext i; fin_cases i <;> simp only [MemoryState.readLimbs, hr]
  have he : (m.makeWritable p.id).readEdwards p = m.readEdwards p := by
    simp only [MemoryState.readEdwards, hl]
  have hfw : Fits (m.makeWritable p.id) p 1280 := hf.makeWritable
  rw [← he, ← MemoryState.storeAt_readAt_self hfw, hr, h, storeAt_edwardsBits ho]
  exact
    MemoryState.readEdwards_storeEdwards_self
      (MemoryState.PointRoom.of_room' (Room.makeWritable_self hf.live) ho)

/-- `decompress` on bytes that decode to `P`. -/
theorem decompress_call_eq {out repr : Pointer} {s : GlobalState} {P : Option EdwardsPoint}
    (hwf : s.WF) (hg : s.mem.Globals CompressedEdwardsY_decompress.globals)
    (hout : s.mem.OptEdwardsRoom out) (hrepr : Fits s.mem repr 256)
    (hrepr_off : ¬repr.offset.uaddOverflow 32#64)
    (hP : CompressedEdwardsY_decompress.spec (s.mem.readAt repr 256) = P) :
    CompressedEdwardsY_decompress.call
        (CompressedEdwardsY_decompress.args (.value out) (.value repr)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + if P.isSome then 159 else 158⟩
            mem := s.mem.storeOptEdwards out P }) := by
  rw [CompressedEdwardsY_decompress.call_eq out repr s hwf hg hout hrepr hrepr_off, hP]

-- about 120 steps over a frame of 14 slots and 16 calls: past the default heartbeats
set_option maxHeartbeats 1000000 in
open VerificationKey_verify_dalek_prehashed in
/-- `self.verify_dalek_prehashed(signature, h)` for `self` (`minus_A` at `self + 32`), the 64-byte
`signature` (`r ‖ s`) and the scalar `h < 2^255`: returns `spec`'s byte. Everything it writes is in
its frame: the memory is unchanged, the counter moves on by `blocks`. -/
public theorem VerificationKey_verify_dalek_prehashed.call_eq (self sig h : Pointer)
    (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals VerificationKey_verify_dalek_prehashed.globals)
    (hself : s.mem.PointFit (self.add 32#64)) (hself_off : ¬self.offset.uaddOverflow 32#64)
    (hsig : Fits s.mem sig 512)
    (hsig_off : ¬sig.offset.uaddOverflow 64#64) (hh : Fits s.mem h 256)
    (hh_off : ¬h.offset.uaddOverflow 32#64) (hdh : (s.mem.readAt h 256).toNat < 2 ^ 255) :
    VerificationKey_verify_dalek_prehashed.call
        (VerificationKey_verify_dalek_prehashed.args (.value self) (.value sig) (.value h)) s =
      .value
        (.cons
            (.value
              (spec (s.mem.readEdwards (self.add 32#64)) (s.mem.readAt sig 256)
                (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt h 256)))
            .nil,
          { alloc :=
              ⟨s.alloc.nextFreeBlock +
                  blocks (s.mem.readEdwards (self.add 32#64)) (s.mem.readAt sig 256)
                    (s.mem.readAt (sig.add 32#64) 256) (s.mem.readAt h 256)⟩
            mem := s.mem }) := by
  generalize hres : spec _ _ _ _ = res
  generalize hblk : blocks _ _ _ _ = k
  generalize hA : self.add 32#64 = A at hself hres hblk
  obtain ⟨vh, hvh⟩ : ∃ v, s.mem.readAt h 256 = v := ⟨_, rfl⟩
  obtain ⟨r, hr⟩ : ∃ v, s.mem.readAt sig 256 = v := ⟨_, rfl⟩
  obtain ⟨sc, hsc⟩ : ∃ v, s.mem.readAt (sig.add 32#64) 256 = v := ⟨_, rfl⟩
  obtain ⟨mA, hmA⟩ : ∃ v, s.mem.readEdwards A = v := ⟨_, rfl⟩
  rw [hvh] at hdh
  have hsig_off32 : ¬sig.offset.uaddOverflow 32#64 :=
    BitVec.not_uaddOverflow_of_le hsig_off (by decide)
  rw [hvh, hr, hsc, hmA] at hres hblk
  func_init
  have hr₀ : S₀.mem.readAt sig 256 = r := hS ▸ hr
  have hsc₀ : S₀.mem.readAt (sig.add 32#64) 256 = sc := hS ▸ hsc
  block_init
  iterate 11 step_pure
  step_alloca with pt20
  step_alloca with ppow
  step_alloca with pt3
  step_alloca with pt19
  step_alloca with precip
  step_alloca with pcs
  step_alloca with paff
  step_alloca with pred
  step_alloca with pexp
  step_alloca with ps
  step_alloca with popt
  step_alloca with pres1
  step_alloca with pres2
  step_alloca with pR
  -- if self.minus_A.is_small_order() { return Err(Error::InvalidSignature); }
  step_pure [hA]
  step_call using EdwardsPoint_is_small_order.call_eq
  finish_block
  case isTrue =>
    block_init
    finish_block
    subst hS
    erase_frame
    rw [← hres, ← hblk]
    simp only [spec, blocks, hbr, ↓reduceIte, GlobalState.alloca_alloc, Nat.add_assoc,
      Nat.reduceAdd]
  case isFalse =>
    have hnA := hbr
    clear hbr
    -- let R = CompressedEdwardsY(*signature.r_bytes()).decompress().ok_or(..)?;
    block_init
    iterate 4 step_pure
    have hopt : S.mem.OptEdwardsRoom popt :=
      ⟨by simp [hpopt_off], hroom_popt.mono (by decide),
        Room.add_of_le (by simp [hpopt_off, BitVec.uaddOverflow]) (by decide) hroom_popt⟩
    rcases hdec : CompressedEdwardsY_decompress.spec r with _ | R
    case
      none =>
      step_call using
        (decompress_call_eq (hP :=
          (congrArg CompressedEdwardsY_decompress.spec hr).trans hdec)) consuming
        hopt
      -- the globals and the writable blocks past `storeOptEdwards`, which the step does not see
      -- through
      any_goals
        rw [hS']
        first
        | exact hg.mono MemoryState.globals_storeOptEdwards fun _ h => h
        | exact Writable.storeOptEdwards (by assumption)
      step_load
      step_pure
      finish_block
      block_init
      iterate 3 step_pure
      finish_block
      block_init
      step_pure
      finish_block
      block_init
      finish_block
      subst hS
      simp only [MemoryState.storeOptEdwards]
      erase_frame
      rw [← hres, ← hblk]
      simp only [spec, blocks, hnA, hdec, ↓reduceIte, Option.isSome_none, Bool.false_eq_true,
        GlobalState.alloca_alloc, Nat.add_assoc, Nat.reduceAdd]
    case
      some =>
      step_call using
        (decompress_call_eq (hP :=
          (congrArg CompressedEdwardsY_decompress.spec hr).trans hdec)) consuming
        hopt
      -- the globals and the writable blocks past `storeOptEdwards`, which the step does not see
      -- through
      any_goals
        rw [hS']
        first
        | exact hg.mono MemoryState.globals_storeOptEdwards fun _ h => h
        | exact Writable.storeOptEdwards (by assumption)
      step_load
      step_pure
      finish_block
      block_init
      step_pure
      step_pure
      memcpy_n 160(MemoryState.PointFit.fits hpointFit_popt_8)hread_popt_8
      step_pure
      step_pure
      step_memcpy
      step_pure
      step_memcpy
      step_pure
      clear hread_pres2_6 hread_pres1_6 hread_popt hread_popt_8_readEdwards hread_popt_8
      have hR_fit := MemoryState.PointFit.of_fits' hfits_pR (by simp [hpR_off])
      have hR_read := readEdwards_of_readAt hfits_pR (by simp [hpR_off]) hread_pR
      clear hread_pR
      -- if R.is_small_order() { return Err(Error::InvalidSignature); }
      step_call using EdwardsPoint_is_small_order.call_eq [hR_read]
      finish_block
      case isTrue =>
        block_init
        step_pure
        finish_block
        block_init
        finish_block
        subst hS
        simp only [MemoryState.storeOptEdwards]
        erase_frame
        rw [← hres, ← hblk]
        simp only [spec, blocks, hnA, hbr, hdec, ↓reduceIte, Option.isSome_some,
          GlobalState.alloca_alloc, Nat.add_assoc, Nat.reduceAdd]
      case isFalse =>
        have hnR := hbr
        clear hbr
        -- let s = Option::<Scalar>::from(Scalar::from_canonical_bytes(*signature.s_bytes()))
        block_init
        iterate 3 step_pure
        have hs_off := s_noOverflow hsig_off
        have hs31 := readAt_s31 (by mem_fact) hs_off hsc₀
        step_load [hs31]
        clear hs31
        step_pure
        step_pure
        step_call using black_box_u8.call_eq with high_bit_unset
        step_pure
        obtain ⟨reduced, hreduced⟩ : ∃ x, Scalar_reduce.spec sc = x := ⟨_, rfl⟩
        step_call using (reduce_call_eq (hx := (congrArg Scalar_reduce.spec hsc).trans hreduced))
        step_call using slice_u8_ConstantTimeEq_ct_eq.call_eq [hsc₀] with is_canonical
        step_pure
        step_pure
        step_call using black_box_u8.call_eq with choice
        step_pure
        have hchoice' : choice = Scalar_from_canonical_bytes.spec sc := by
          rw [hchoice, his_canonical, hhigh_bit_unset, high_bit_eq, ← hreduced]
          rfl
        clear hchoice his_canonical hhigh_bit_unset hread_pred
        finish_block
        case isFalse =>
          block_init
          step_pure
          finish_block
          block_init
          step_pure
          finish_block
          block_init
          finish_block
          subst hS
          simp only [MemoryState.storeOptEdwards]
          erase_frame
          rw [← hres, ← hblk]
          simp only [spec, blocks, hnA, hnR, hbr, hdec, ↓reduceIte, Option.isSome_some,
            GlobalState.alloca_alloc, Nat.add_assoc, Nat.reduceAdd]
        case isTrue =>
          have hs_lt := lt_of_canonical hbr
          block_init
          -- `s`'s bytes copied to `ps`
          step_pure
          have hs0 := readAt_s0 hsc₀
          step_load [hs0]
          clear hs0
          step_pure
          step_memcpy
          rw [readAt_s_tail (by mem_fact) hs_off hsc₀] at hread_ps_1
          step_store
          obtain ⟨hps_fit, hps_read⟩ := scalar_copy hps_off hfits_ps hfits_ps_1 hread_ps hread_ps_1
          clear hfits_ps hfits_ps_1 hread_ps hread_ps_1
          -- let expected_R = vartime_double_scalar_mul_basepoint(&h, &self.minus_A, &s).compress();
          step_pure
          have hexp := MemoryState.PointRoom.of_room hroom_pexp hpexp_off
          have hdh' : (S.mem.readAt h 256).toNat < 2 ^ 255 := hvh ▸ hdh
          have hds : (S.mem.readAt ps 256).toNat < 2 ^ 255 := hps_read ▸ hs_lt
          step_call using mul.call_eq consuming hdh' hds
          name_point P
          clear hvh hsc hmA hR_read hps_read hps_fit hfits_pR hR_fit hroom_pR hroom_ps
          -- let recip = self.Z.invert();
          iterate 4 step_pure
          have hppow_40 :=
            Agave.limbsRoom_add (k := 40#64) hroom_ppow hppow_off (by decide) (by decide)
          have hppow_limbs := MemoryState.LimbsRoom.of_room (hroom_ppow.mono (by decide)) hppow_off
          clear hroom_ppow hppow_bounds
          step_call using (pow22501_call_eq (hZ := hread_pexp_80))
          name_limbs t3
          name_limbs t19
          step_pure
          have hppow_bits :=
            (MemoryState.readAt_eq_limbsBits hppow_limbs).trans (congrArg limbsBits hread_ppow)
          have hsrc := MemoryState.LimbsFit.fits hppow_limbs
          step_memcpy consuming hsrc hppow_bits
          step_pure
          step_pure
          memcpy_n 40(MemoryState.LimbsFit.fits hppow_40)hread_ppow_40
          step_pure
          clear hread_ppow hread_ppow_40_readLimbs hread_ppow_40
          have hpt19_limbs := MemoryState.LimbsFit.of_fits' hfits_pt19 (by simp [hpt19_off])
          have hpt19_read :=
            readLimbs_of_readAt_limbsBits hfits_pt19.inBounds (by simp [hpt19_off]) hread_pt19
          have hpt3_limbs := MemoryState.LimbsFit.of_fits' hfits_pt3 (by simp [hpt3_off])
          have hpt3_read :=
            readLimbs_of_readAt_limbsBits hfits_pt3.inBounds (by simp [hpt3_off]) hread_pt3
          clear hfits_pt19 hread_pt19 hroom_pt19 hfits_pt3 hread_pt3 hroom_pt3
          step_pure
          have hpt20_limbs := MemoryState.LimbsRoom.of_room hroom_pt20 hpt20_off
          step_call using (pow2k_call_eq (hX := hpt19_read))
          name_limbs t20
          have hprecip_limbs := MemoryState.LimbsRoom.of_room hroom_precip hprecip_off
          step_call using (mul_call_eq (hX := hread_pt20_readLimbs) (hY := hpt3_read))
          name_limbs recip
          iterate 3 step_pure
          clear hpt19_read hpt3_read hread_pt20_readLimbs hread_pt20
          -- let x = &self.X * &recip;
          have hpaff_40 :=
            Agave.limbsRoom_add (k := 40#64) hroom_paff hpaff_off (by decide) (by decide)
          have hpaff_limbs := MemoryState.LimbsRoom.of_room (hroom_paff.mono (by decide)) hpaff_off
          step_call using (mul_call_eq (hX := hread_pexp_readLimbs) (hY := hread_precip_readLimbs))
          name_limbs x
          -- let y = &self.Y * &recip;
          step_pure
          step_pure
          step_call using (mul_call_eq (hX := hread_pexp_40) (hY := hread_precip_readLimbs))
          name_limbs y
          step_pure
          clear hread_precip_readLimbs hread_precip hpaff_40
          -- let mut s = self.y.to_bytes(); s[31] ^= self.x.is_negative().unwrap_u8() << 7;
          step_call using (to_bytes_call_eq (hX := hread_paff_40_readLimbs))
          step_call using (is_negative_call_eq (hX := hread_paff_readLimbs)) with x_is_negative
          step_pure
          step_pure
          step_load
          step_pure
          step_store
          step_pure
          step_pure
          -- if expected_R.as_bytes() == signature.r_bytes() { Ok(()) } else { Err(..) }
          step_call using Operation.bcmp_eq [hr₀] with cmp
          step_pure
          step_pure [hcmp, Operation.bcmpResult_eq_zero_iff]
          step_pure
          finish_block
          block_init
          step_pure
          finish_block
          block_init
          finish_block
          subst hS
          simp only [MemoryState.storeOptEdwards]
          erase_frame
          simp only [bcmp_select, spliceBits_248]
          rw [← hres, ← hblk]
          simp only [spec, blocks, hnA, hnR, hbr, hdec, ↓reduceIte, Option.isSome_some,
            GlobalState.alloca_alloc, Nat.add_assoc, Nat.reduceAdd, EdwardsPoint_compress.spec,
            FieldElement51_invert.spec, hx_is_negative, hx, hy, hrecip, ht20, ht19, ht3, hP]
          simp only [← Nat.add_assoc, Nat.reduceAdd]
          rfl

end Proof

end MLIR.Agave.Serial
