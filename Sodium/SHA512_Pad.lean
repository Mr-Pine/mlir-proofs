module

public import MLIR.Run.Tactic
public import Sodium.Common.Sha512
public import Sodium.SHA512_Transform
public import Sodium.be64enc_vect
public import Firedancer.Common.Counter
public import Sodium.Mlir.SHA512_Pad
import Std.Tactic.BVDecide

namespace MLIR.Sodium

open Memory

/-! ## Specification -/

@[expose] public section

namespace SHA512_Pad

/-- `r = (count[1] >> 3) & 0x7f`, the bytes buffered. -/
def r (v : HashState) : Nat :=
  v.count1.toNat / 8 % 128

/-- `PAD`: `0x80`, then zeros. -/
def pad : BitVec 1024 :=
  0x80#1024

/-- `PAD` copied to byte 112 of the buffer, or, past it, to the block's end, the block
compressed and its first 112 bytes zeroed. -/
def head (v : HashState) : HashState :=
  if r v < 112 then
    v.fill (BitVec.ofNat 64 (r v)) (pad.setWidth (8 * (BitVec.ofNat 64 (112 - r v)).toNat))
  else
    let u := v.fill (BitVec.ofNat 64 (r v)) (pad.setWidth (8 * (BitVec.ofNat 64 (128 - r v)).toNat))
    { u with state := SHA512_Transform.spec u.state u.buf }.fill 0#64 0#896

/-- How many blocks `SHA512_Pad` allocates: `PAD`'s, one per compressed block. -/
def blocks (v : HashState) : Nat :=
  if r v < 112 then 2 else 3

/-- `be64enc_vect(&state->buf[112], state->count, 16)`. -/
def count (w : HashState) : HashState :=
  (w.fill 112#64 (store64_be.spec w.count0)).fill 120#64 (store64_be.spec w.count1)

/-- The last block compressed: `SHA512_Transform(state->state, state->buf, …)`. -/
def tail (w : HashState) : HashState :=
  { count w with state := SHA512_Transform.spec (count w).state (count w).buf }

/-- `tmp64` after the last block. -/
def tailTmp (w : HashState) : BitVec 5632 :=
  SHA512_Transform.tmp (count w).state (count w).buf

end SHA512_Pad

/-- The padded message's last block or two compressed into `state`. -/
def SHA512_Pad.spec (v : HashState) : HashState :=
  SHA512_Pad.tail (SHA512_Pad.head v)

end

/-! ## Proof -/

section Proof

namespace SHA512_Pad

theorem and127 (n : Nat) : n &&& 127 = n % 128 := by
  rw [show (127 : Nat) = 2 ^ 7 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod]

/-! The buffered byte count `r`, as the steps compute it. -/

theorem r64_eq (x : BitVec 64) :
    BitVec.setWidth 64 (BitVec.setWidth 32 x) >>> 3 &&& 127#64 =
      BitVec.ofNat 64 (x.toNat / 8 % 128) := by
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_and, BitVec.toNat_ushiftRight, BitVec.toNat_setWidth, BitVec.toNat_ofNat,
    Nat.shiftRight_eq_div_pow]
  rw [show (127 : Nat) % 2 ^ 64 = 127 from rfl, and127]
  omega

theorem rNat_eq (x : BitVec 64) :
    (x.toNat % 4294967296 % 18446744073709551616) >>> 3 &&& 127 = x.toNat / 8 % 128 := by
  rw [Nat.shiftRight_eq_div_pow, and127]
  omega

theorem r32_eq (x : BitVec 64) :
    BitVec.setWidth 32 x >>> 3 &&& 127#32 = BitVec.ofNat 32 (x.toNat / 8 % 128) := by
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_and, BitVec.toNat_ushiftRight, BitVec.toNat_setWidth, BitVec.toNat_ofNat,
    Nat.shiftRight_eq_div_pow]
  rw [show (127 : Nat) % 2 ^ 32 = 127 from rfl, and127]
  omega

/-! `c - r` for `r ≤ c < 2 ^ 31`, as a 32-bit subtraction. -/

theorem ssubOverflow_ofNat32 {c R : Nat} (h : R ≤ c) (hc : c < 2 ^ 31) :
    (BitVec.ofNat 32 c).ssubOverflow (BitVec.ofNat 32 R) = false := by
  have h1 : (BitVec.ofNat 32 c).toInt = c := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have h2 : (BitVec.ofNat 32 R).toInt = R := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp [BitVec.ssubOverflow, h1, h2]
  omega

theorem usubOverflow_ofNat32 {c R : Nat} (h : R ≤ c) (hc : c < 2 ^ 31) :
    (BitVec.ofNat 32 c).usubOverflow (BitVec.ofNat 32 R) = false := by
  simp [BitVec.usubOverflow]
  omega

theorem sub_ofNat32 {c R : Nat} (h : R ≤ c) (hc : c < 2 ^ 31) :
    BitVec.ofNat 32 c - BitVec.ofNat 32 R = BitVec.ofNat 32 (c - R) := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_sub_of_le
      (by
        rw [BitVec.le_def]; simp; omega)]
  simp
  omega

/-- A buffer known to byte 112, then the counts: all known. -/
theorem bufDef_count {w : HashState} (h : w.Prefix 112) :
    (count w).bufDef = BitVec.allOnes 1024 := by
  unfold HashState.Prefix at h
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have hb := congrArg (·.getLsbD i) h
  simp only [BitVec.getLsbD_extractLsb', BitVec.getLsbD_allOnes, Nat.zero_add] at hb
  simp only [count, HashState.fill, Firedancer.Ref.fd_sha512_append.copy, getLsbD_spliceBits,
    BitVec.getLsbD_allOnes, hi, decide_true, BitVec.toNat_ofNat]
  split
  · simp only [decide_eq_true_eq]
    omega
  split
  · simp only [decide_eq_true_eq]
    omega
  · rename_i h1 h2
    have h896 : i < 896 := by
      simp at h1 h2; omega
    simpa [h896] using hb

/-- `be64enc_vect(&state->buf[112], state->count, 16)` on the stored struct. -/
theorem storeWords_count {M : MemoryState} {st : Pointer} {w : HashState}
    (hMf : M.HashStateFit st) :
    (M.storeHashState st w).storeWords (st.add 192#64)
        (be64enc_vect.spec (M.storeHashState st w) (st.add 64#64)) 2 =
      M.storeHashState st (count w) := by
  have hsto := hMf.1
  have hin := hMf.2.1.inBounds
  simp only [MemoryState.storeWords, be64enc_vect.spec, Pointer.add_add, Nat.mul_zero, Nat.mul_one,
    BitVec.add_zero, BitVec.reduceAdd, MemoryState.readAt_storeHashState_count0 hin hsto,
    MemoryState.readAt_storeHashState_count1 hin hsto]
  rw [MemoryState.storeHashState_storeAt_buf hsto (by decide) (by decide),
    MemoryState.storeHashState_storeAt_buf hsto (by decide) (by decide)]
  rfl

/-- `^bb3`: the counts into the last 16 bytes, the last block compressed. -/
theorem tail_block (st tmp : Pointer) (M : MemoryState) (w : HashState) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (args (.value st) (.value tmp)).get) (hR : E ⊨ [%280 := 16#64]) (hwf : S.WF)
    (hM : S.mem = M.storeHashState st w) (hMf : M.HashStateFit st) (htmp : Room M tmp 5632)
    (htmpo : ¬tmp.offset.uaddOverflow 704#64) (hsep : tmp.id ≠ st.id) (hpre : w.Prefix 112)
    (g : Vals [] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hK :
      (PoisonOr.value
            (.nil,
              { alloc := ⟨S.alloc.nextFreeBlock + 1⟩,
                mem := (M.storeAt tmp (tailTmp w)).storeHashState st (tail w) }) >>=
          g) =
        K) :
    (SHA512_Pad.runFrom E 3 S >>= g) = K := by
  subst hK
  have hsto := hMf.1
  have hSf : S.mem.HashStateFit st := hM ▸ hMf.storeHashState
  have ho := Pointer.offset_lt_of_hashState hsto
  have h192 := Pointer.offset_add_of_hashState hsto (k := 192) (by decide)
  have h64 := Pointer.offset_add_of_hashState hsto (k := 64) (by decide)
  have h16 : (16#64 >>> 3).toNat = 2 := by decide
  have hdst : Room S.mem (st.add 192#64) (64 * (16#64 >>> 3).toNat) :=
    Room.add_of_le (Pointer.not_uaddOverflow_of_hashState hsto (by decide)) (by decide) hSf.2.1
  have hdsto : (st.add 192#64).offset.toNat + 8 * (16#64 >>> 3).toNat < 2 ^ 64 := by
    rw [h16, h192]; omega
  have hsrc : Fits S.mem (st.add 64#64) (64 * (16#64 >>> 3).toNat) :=
    Fits.add_of_le (Pointer.not_uaddOverflow_of_hashState hsto (by decide)) (by decide) hSf.2.2
  have hsrco : (st.add 64#64).offset.toNat + 8 * (16#64 >>> 3).toNat < 2 ^ 64 := by
    rw [h16, h64]; omega
  have hdisj :
    (Range.of (st.add 192#64) (64 * (16#64 >>> 3).toNat)).Disjoint
      (Range.of (st.add 64#64) (64 * (16#64 >>> 3).toNat)) := by
    simp only [Range.Disjoint, Range.of, Pointer.add_id, Pointer.offsetInBits, h64, h192, h16]
    omega
  block_init
  iterate 3 step_pure
  -- be64enc_vect(&state->buf[112], state->count, 16);
  step_call using be64enc_vect.call_eq consuming hdst hdsto hsrc hsrco hdisj
  rw [hM, storeWords_count hMf] at hS
  clear hread_st ho h192 h64 h16
  have hst512 : Fits S.mem st 512 := hSf.2.2.mono (by decide)
  have hsto64 : ¬st.offset.uaddOverflow 64#64 :=
    Pointer.not_uaddOverflow_of_hashState hsto (by decide)
  have hbuf : Fits S.mem (st.add 80#64) 1024 := by
    rw [hS]
    refine Fits.storeHashState_buf hMf.2.1 hsto (by decide) ?_
    rw [bufDef_count hpre]
    exact BitVec.extractLsb'_allOnes (by decide)
  have hbufo : ¬(st.add 80#64).offset.uaddOverflow 128#64 :=
    Pointer.not_uaddOverflow_add hsto (by decide)
  have htmp' : Room S.mem tmp 5632 := by
    rw [hS]; exact htmp.storeHashState
  have hsep' : tmp.id ≠ (st.add 80#64).id := by simpa using hsep
  step_pure
  -- SHA512_Transform(state->state, state->buf, &tmp64[0], &tmp64[80]);
  step_call using SHA512_Transform.call_eq consuming hst512 hsto64 hbuf hbufo htmp' hsep'
  finish_block
  have hin := hMf.2.1.inBounds
  rw [hS, MemoryState.readWords8_storeHashState hin hsto,
    MemoryState.readAt_storeHashState_buf hin hsto, MemoryState.storeHashState_storeAt_comm hsep,
    MemoryState.storeHashState_storeWords8 hsto]
  rfl

end SHA512_Pad

public theorem PAD.value_eq (s : GlobalState) : PAD.value s = .value (Ty.wrap PAD.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

theorem BitVec.packLanes_replicate_zero {we : Nat} :
    ∀ {n : Nat}, BitVec.packLanes (Vector.replicate n (0 : BitVec we)) = 0
  | 0 => by
    unfold BitVec.packLanes; rfl
  | n + 1 => by
    have ht : (Vector.replicate (n + 1) (0 : BitVec we)).tail = Vector.replicate n 0 := by
      ext i hi
      simp [Vector.tail]
    unfold BitVec.packLanes
    rw [ht]
    erw [BitVec.packLanes_replicate_zero (n := n)]
    exact BitVec.zero_append_zero

theorem PAD.flattenRaw_lit : Ty.flattenRaw _ PAD.lit = SHA512_Pad.pad := by
  rw [Ty.flattenRaw_struct, PAD.lit]
  simp only [Ty.fieldsAlign]
  rw [Ty.flattenRawFields_cons, Ty.flattenRawFields_singleton, Ty.flattenRaw_array,
    Ty.flattenRaw_bv]
  simp only [Ty.padding, Ty.width, Ty.align, Vector.map_replicate, Ty.flattenRaw_bv]
  erw [BitVec.packLanes_replicate_zero]
  show 0#0 ++ (0 : BitVec 1016) ++ (0#0 ++ 128#8) = 128#1024
  bv_decide

theorem PAD.flatBits_lit {hw : _} : Ty.flatBits (hw := hw) PAD.lit = SHA512_Pad.pad := by
  rw [Ty.flatBits_eq]
  simp only [PAD.flattenRaw_lit]
  rfl

/-- `SHA512_Pad(state, tmp64)` pads the buffered bytes and compresses the last block or two into
`state` (`spec`), leaving the last block's words at `tmp64`. The buffer's first `r` bytes must be
known. The block counter advances by `blocks`. -/
public theorem SHA512_Pad.call_eq (st tmp : Pointer) (s : GlobalState) (hwf : s.WF)
    (hst : s.mem.HashStateFit st)
    (hpre : (s.mem.readHashState st).Prefix (SHA512_Pad.r (s.mem.readHashState st)))
    (htmp : Room s.mem tmp 5632) (htmpo : ¬tmp.offset.uaddOverflow 704#64) (hsep : tmp.id ≠ st.id) :
    SHA512_Pad.call (SHA512_Pad.args (.value st) (.value tmp)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + SHA512_Pad.blocks (s.mem.readHashState st)⟩,
            mem :=
              (s.mem.storeAt tmp
                    (SHA512_Pad.tailTmp (SHA512_Pad.head (s.mem.readHashState st)))).storeHashState
                st (SHA512_Pad.spec (s.mem.readHashState st)) }) := by
  generalize hv : s.mem.readHashState st = v at hpre ⊢
  have hc1 : s.mem.readAt (st.add 72#64) 64 = v.count1 := by
    rw [← hv, MemoryState.readHashState_count1 hst.2.1.inBounds hst.1]
  have hsto := hst.1
  generalize hres : SHA512_Pad.spec v = res
  generalize hX : SHA512_Pad.tailTmp (SHA512_Pad.head v) = X
  generalize hk : SHA512_Pad.blocks v = k
  func_init
  have hv₀ : S₀.mem.readHashState st = v := hS ▸ hv
  clear hv
  block_init
  iterate 4 step_pure
  step_addressof PAD.value_eq with pad
  erw [PAD.flatBits_lit] at hS hread_pad
  have hpad_id : pad.id = ⟨S₀.alloc.nextFreeBlock⟩ := by
    rw [hpad]; rfl
  -- the struct, past the new block
  have hv₁ : S.mem.readHashState st = v := by
    rw [hS]
    exact (MemoryState.readHashState_addBlock_of_id_ne (hpad_id ▸ hst_ne_pad)).trans hv₀
  iterate 3 step_pure
  obtain ⟨R, hRe⟩ : ∃ R, v.count1.toNat / 8 % 128 = R := ⟨_, rfl⟩
  have hR : R < 128 := hRe ▸ Nat.mod_lt _ (by decide)
  have hrv : SHA512_Pad.r v = R := hRe
  step_pure
  -- r = (unsigned int) ((state->count[1] >> 3) & 0x7f);
  step_load
  step_pure
  step_pure
  step_pure [SHA512_Pad.r32_eq, hRe]
  step_pure
  have hm₁ : (S₀.mem.addBlock ⟨S₀.alloc.nextFreeBlock⟩ 128 SHA512_Pad.pad).HashStateFit st :=
    MemoryState.HashStateFit.addBlock hwf₀ ⟨hsto, hst₀, hst₀_1⟩
  have hv₂ : (S₀.mem.addBlock ⟨S₀.alloc.nextFreeBlock⟩ 128 SHA512_Pad.pad).readHashState st = v :=
    (MemoryState.readHashState_addBlock_of_id_ne (hpad_id ▸ hst_ne_pad)).trans hv₀
  have hp₁ :
    (S₀.mem.addBlock ⟨S₀.alloc.nextFreeBlock⟩ 128 SHA512_Pad.pad).readAt pad 1024 =
      SHA512_Pad.pad := by
    rw [hpad, ← GlobalState.allocaPtr_eq_slot]
    exact MemoryState.readAt_addBlock_allocaPtr (by decide)
  finish_block
  · -- if (r < 112): PAD to byte 112
    have hR' : R < 112 := by
      simpa [BitVec.ult, Nat.mod_eq_of_lt (show R < 4294967296 by omega)] using hbr
    block_init
    step_pure [SHA512_Pad.r32_eq, hRe]
    step_pure [Firedancer.msb_ofNat32 (show R < 2 ^ 31 by omega),
      Firedancer.setWidth_ofNat32 (show R < 2 ^ 32 by omega)]
    step_pure [Nat.mod_eq_of_lt (show R < 4294967296 by omega),
      Nat.mod_eq_of_lt (show R < 18446744073709551616 by omega),
      show R < 18446744073709551616 by omega]
    have hg : ¬(st.add (BitVec.ofNat 64 R)).offset.uaddOverflow 80#64 :=
      Pointer.not_uaddOverflow_add hsto
        (by
          simp; omega)
    step_pure [gep_value hg, Pointer.add_add, ← BitVec.ofNat_add]
    step_pure [show (112#32) = BitVec.ofNat 32 112 from rfl,
      SHA512_Pad.ssubOverflow_ofNat32 (show R ≤ 112 by omega) (by decide),
      SHA512_Pad.usubOverflow_ofNat32 (show R ≤ 112 by omega) (by decide),
      SHA512_Pad.sub_ofNat32 (show R ≤ 112 by omega) (by decide)]
    step_pure [Firedancer.msb_ofNat32 (show 112 - R < 2 ^ 31 by omega),
      Firedancer.setWidth_ofNat32 (show 112 - R < 2 ^ 32 by omega)]
    have hsrc : Fits S.mem pad (8 * (BitVec.ofNat 64 (112 - R)).toNat) :=
      hpad_fits.mono
        (by
          simp; omega)
    have hdst :
      Room S.mem (st.add (BitVec.ofNat 64 (R + 80))) (8 * (BitVec.ofNat 64 (112 - R)).toNat) :=
      Room.add_of_le
        (Pointer.not_uaddOverflow_of_hashState hsto
          (by
            simp; omega))
        (by
          simp; omega)
        hst.2.1
    step_memcpy consuming hsrc hdst
    finish_block
    have hhead :
      SHA512_Pad.head v =
        v.fill (BitVec.ofNat 64 R)
          (SHA512_Pad.pad.setWidth (8 * (BitVec.ofNat 64 (112 - R)).toNat)) := by
      rw [SHA512_Pad.head, hrv]
      simp only [hR', ↓reduceIte]
    refine
      SHA512_Pad.tail_block st tmp (S₀.mem.addBlock ⟨S₀.alloc.nextFreeBlock⟩ 128 SHA512_Pad.pad)
        (SHA512_Pad.head v) S E hArgs (by env_reads) hwf ?_ hm₁ (htmp₀.addBlock hwf₀) htmpo hsep ?_
        _ _ ?_
    · rw [hS, hhead]
      dsimp only
      rw [MemoryState.readAt_of_readAt_le
          (by
            simp; omega)
          hp₁]
      conv_lhs => rw [← MemoryState.storeHashState_readHashState_self hm₁, hv₂]
      rw [MemoryState.storeHashState_storeAt_buf hsto
          (by
            simp; omega)
          (by
            simp; omega)]
      congr 2
      apply BitVec.eq_of_toNat_eq
      simp
      omega
    · rw [hhead]
      have :=
        hpre.fill (off := BitVec.ofNat 64 R)
          (by
            rw [hrv]; simp; omega)
          (SHA512_Pad.pad.setWidth (8 * (BitVec.ofNat 64 (112 - R)).toNat)) (j :=
          (BitVec.ofNat 64 (112 - R)).toNat) rfl
          (by
            rw [hrv]; simp; omega)
      rwa [hrv,
        show R + (BitVec.ofNat 64 (112 - R)).toNat = 112 by
          simp; omega] at
        this
    · subst hres hX hk
      have hSa : S.alloc.nextFreeBlock = S₀.alloc.nextFreeBlock + 1 := by rw [hS]
      have hb : SHA512_Pad.blocks v = 2 := by simp [SHA512_Pad.blocks, hrv, hR']
      rw [hSa, hb, SHA512_Pad.spec]
      simp only [PoisonOr.value_bind, MemoryState.eraseFrom_storeHashState,
        MemoryState.eraseFrom_storeAt, MemoryState.eraseFrom_addBlock_of_le (Nat.le_refl _),
        GlobalState.WF.eraseFrom hwf₀]
  · -- else: PAD to the block's end, compress, zero the first 112 bytes
    have hR' : 112 ≤ R := by
      simpa [BitVec.ult, Nat.mod_eq_of_lt (show R < 4294967296 by omega)] using hbr
    block_init
    step_pure [show (128#32) = BitVec.ofNat 32 128 from rfl,
      SHA512_Pad.ssubOverflow_ofNat32 (show R ≤ 128 by omega) (by decide),
      SHA512_Pad.usubOverflow_ofNat32 (show R ≤ 128 by omega) (by decide),
      SHA512_Pad.sub_ofNat32 (show R ≤ 128 by omega) (by decide)]
    step_pure [SHA512_Pad.r32_eq, hRe]
    step_pure [Firedancer.msb_ofNat32 (show R < 2 ^ 31 by omega),
      Firedancer.setWidth_ofNat32 (show R < 2 ^ 32 by omega)]
    step_pure [Nat.mod_eq_of_lt (show R < 4294967296 by omega),
      Nat.mod_eq_of_lt (show R < 18446744073709551616 by omega),
      show R < 18446744073709551616 by omega]
    have hg : ¬(st.add (BitVec.ofNat 64 R)).offset.uaddOverflow 80#64 :=
      Pointer.not_uaddOverflow_add hsto
        (by
          simp; omega)
    step_pure [gep_value hg, Pointer.add_add, ← BitVec.ofNat_add]
    step_pure [Firedancer.msb_ofNat32 (show 128 - R < 2 ^ 31 by omega),
      Firedancer.setWidth_ofNat32 (show 128 - R < 2 ^ 32 by omega)]
    have hsrc : Fits S.mem pad (8 * (BitVec.ofNat 64 (128 - R)).toNat) :=
      hpad_fits.mono
        (by
          simp; omega)
    have hdst :
      Room S.mem (st.add (BitVec.ofNat 64 (R + 80))) (8 * (BitVec.ofNat 64 (128 - R)).toNat) :=
      Room.add_of_le
        (Pointer.not_uaddOverflow_of_hashState hsto
          (by
            simp; omega))
        (by
          simp; omega)
        hst.2.1
    -- for (i = 0; i < 128 - r; i++) { state->buf[r + i] = PAD[i]; }
    step_memcpy consuming hsrc hdst
    -- the bytes as the struct's
    have hu :
      (S₀.mem.addBlock ⟨S₀.alloc.nextFreeBlock⟩ 128 SHA512_Pad.pad).storeAt
          (st.add (BitVec.ofNat 64 (R + 80)))
          ((S₀.mem.addBlock ⟨S₀.alloc.nextFreeBlock⟩ 128 SHA512_Pad.pad).readAt pad
            (8 * (BitVec.ofNat 64 (128 - R)).toNat)) =
        (S₀.mem.addBlock ⟨S₀.alloc.nextFreeBlock⟩ 128 SHA512_Pad.pad).storeHashState st
          (v.fill (BitVec.ofNat 64 R)
            (SHA512_Pad.pad.setWidth (8 * (BitVec.ofNat 64 (128 - R)).toNat))) := by
      rw [MemoryState.readAt_of_readAt_le
          (by
            simp; omega)
          hp₁]
      conv_lhs => rw [← MemoryState.storeHashState_readHashState_self hm₁, hv₂]
      rw [MemoryState.storeHashState_storeAt_buf hsto
          (by
            simp; omega)
          (by
            simp; omega)]
      congr 2
      apply BitVec.eq_of_toNat_eq
      simp
      omega
    rw [hu] at hS
    clear hu hread_st_0 hfits_st_0
    have hfull :=
      hpre.fill (off := BitVec.ofNat 64 R)
        (by
          rw [hrv]; simp; omega)
        (SHA512_Pad.pad.setWidth (8 * (BitVec.ofNat 64 (128 - R)).toNat)) (j :=
        (BitVec.ofNat 64 (128 - R)).toNat) rfl
        (by
          rw [hrv]; simp; omega)
    rw [hrv,
      show R + (BitVec.ofNat 64 (128 - R)).toNat = 128 by
        simp; omega] at hfull
    have hst512 : Fits S.mem st 512 := hst.2.2.mono (by decide)
    have hsto64 : ¬st.offset.uaddOverflow 64#64 :=
      Pointer.not_uaddOverflow_of_hashState hsto (by decide)
    have hbuf : Fits S.mem (st.add 80#64) 1024 := by
      rw [hS]
      exact Fits.storeHashState_buf hm₁.2.1 hsto (by decide) hfull
    have hbufo : ¬(st.add 80#64).offset.uaddOverflow 128#64 :=
      Pointer.not_uaddOverflow_add hsto (by decide)
    have hsep' : tmp.id ≠ (st.add 80#64).id := by simpa using hsep
    step_pure
    step_pure
    -- SHA512_Transform(state->state, state->buf, &tmp64[0], &tmp64[80]);
    step_call using SHA512_Transform.call_eq consuming hst512 hsto64 hbuf hbufo hsep'
    have hin := hm₁.2.1.inBounds
    rw [MemoryState.readWords8_storeHashState hin hsto,
      MemoryState.readAt_storeHashState_buf hin hsto, MemoryState.storeHashState_storeAt_comm hsep,
      MemoryState.storeHashState_storeWords8 hsto] at hS
    -- memset(&state->buf[0], 0, 112);
    step_memset
    rw [MemoryState.storeHashState_storeAt_buf hsto (by decide) (by decide)] at hS
    finish_block
    have hhead :
      SHA512_Pad.head v =
        {
              v.fill (BitVec.ofNat 64 R)
                (SHA512_Pad.pad.setWidth (8 * (BitVec.ofNat 64 (128 - R)).toNat)) with
              state :=
                SHA512_Transform.spec
                  (v.fill (BitVec.ofNat 64 R)
                      (SHA512_Pad.pad.setWidth (8 * (BitVec.ofNat 64 (128 - R)).toNat))).state
                  (v.fill (BitVec.ofNat 64 R)
                      (SHA512_Pad.pad.setWidth (8 * (BitVec.ofNat 64 (128 - R)).toNat))).buf }.fill
          0#64 0#896 := by
      rw [SHA512_Pad.head, hrv]
      simp only [show ¬R < 112 by omega, ↓reduceIte]
    refine
      SHA512_Pad.tail_block st tmp
        ((S₀.mem.addBlock ⟨S₀.alloc.nextFreeBlock⟩ 128 SHA512_Pad.pad).storeAt tmp
          (SHA512_Transform.tmp
            (v.fill (BitVec.ofNat 64 R)
                (SHA512_Pad.pad.setWidth (8 * (BitVec.ofNat 64 (128 - R)).toNat))).state
            (v.fill (BitVec.ofNat 64 R)
                (SHA512_Pad.pad.setWidth (8 * (BitVec.ofNat 64 (128 - R)).toNat))).buf))
        (SHA512_Pad.head v) S E hArgs (by env_reads) hwf ?_ hm₁.storeAt
        (htmp₀.addBlock hwf₀).storeAt htmpo hsep ?_ _ _ ?_
    · simp only [BitVec.sub_self] at hS
      rw [hS, hhead]
    · rw [hhead]
      exact
        (HashState.prefix_zero _).fill (off := 0#64) (k := 0) rfl 0#896 (j := 112) rfl (by decide)
    · subst hres hX hk
      have hSa : S.alloc.nextFreeBlock = S₀.alloc.nextFreeBlock + 1 + 1 := by rw [hS]
      have hb : SHA512_Pad.blocks v = 3 := by simp [SHA512_Pad.blocks, hrv, show ¬R < 112 by omega]
      rw [hSa, hb, SHA512_Pad.spec, MemoryState.storeAt_storeAt_self]
      simp only [PoisonOr.value_bind, MemoryState.eraseFrom_storeHashState,
        MemoryState.eraseFrom_storeAt, MemoryState.eraseFrom_addBlock_of_le (Nat.le_refl _),
        GlobalState.WF.eraseFrom hwf₀]

end Proof

end MLIR.Sodium
