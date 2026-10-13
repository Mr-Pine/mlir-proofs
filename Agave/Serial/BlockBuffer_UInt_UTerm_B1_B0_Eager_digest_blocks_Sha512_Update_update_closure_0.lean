module

public import MLIR.Run.Tactic
public import Agave.Common.Sha512
public import Agave.Serial.compress512
public import Agave.Serial.Mlir.BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Serial

open _root_.Ed25519

/-! ## Specification -/

@[expose] public section

namespace BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0

/-- The blocks' count at `self + 192` raised by `k`, then `compress512` of `bytes` into the state
words at `self + 128`. -/
def compressMem (m : MemoryState) (self : Pointer) (k : BitVec 128) (bytes : List (BitVec 8)) :
    MemoryState :=
  let m' := m.storeAt (self.add 192#64) (m.readAt (self.add 192#64) 128 + k)
  m'.storeSha512 (self.add 128#64) (compress512.spec (m'.readSha512 (self.add 128#64)) bytes)

/-- The `compress512` calls of `tailMem`: one, unless no whole block. -/
def tailCalls (n : BitVec 64) : Nat :=
  if n >>> 7 = 0#64 then 0 else 1

/-- `n` bytes at `inp` into an empty buffer: the whole blocks compressed, the rest buffered and
its length in the buffer's last byte. -/
def tailMem (m : MemoryState) (self inp : Pointer) (n : BitVec 64) : MemoryState :=
  let m1 :=
    if n >>> 7 = 0#64 then m
    else
      compressMem m self ((n >>> 7).setWidth 128) (bytesLE (m.readAt inp (1024 * (n >>> 7).toNat)))
  (m1.storeAt (self.add 127#64) ((n &&& 127#64).setWidth 8)).storeAt self
    (m1.readAt (inp.add (n &&& 9223372036854775680#64)) (8 * (n &&& 127#64).toNat))

/-- `update`'s memory on `len` bytes at `data`, sha2's `Sha512` at `self`, the buffer's length `P`
in its last byte: below `128 - P` bytes appended to the buffer; else the buffer filled and
compressed, if not empty, and the rest as `tailMem`. -/
def updateMem (m : MemoryState) (self data : Pointer) (len : BitVec 64) : MemoryState :=
  let P := m.readAt (self.add 127#64) 8
  let rem := 128#64 - P.setWidth 64
  if len.ult rem then
    (m.storeAt (self.add (P.setWidth 64)) (m.readAt data (8 * len.toNat))).storeAt (self.add 127#64)
      (P + len.setWidth 8)
  else
    if P = 0#8 then tailMem m self data len
    else
      let m1 := m.storeAt (self.add (P.setWidth 64)) (m.readAt data (8 * rem.toNat))
      tailMem (compressMem m1 self 1#128 (bytesLE (m1.readAt self 1024))) self (data.add rem)
        (len - rem)

/-- `update`'s `compress512` calls. -/
def updateCalls (m : MemoryState) (self : Pointer) (len : BitVec 64) : Nat :=
  let P := m.readAt (self.add 127#64) 8
  let rem := 128#64 - P.setWidth 64
  if len.ult rem then 0 else if P = 0#8 then tailCalls len else 1 + tailCalls (len - rem)

end BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0

end

/-! ## Proof -/

namespace BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0

section Proof

/-- `128 - P`, the buffer's room. -/
theorem rem_toNat {P : BitVec 8} (h : P.toNat < 128) :
    (128#64 - P.setWidth 64).toNat = 128 - P.toNat := by
  rw [BitVec.toNat_sub_of_le
      (by
        simp [BitVec.le_def]; omega)]
  simp only [BitVec.toNat_setWidth, BitVec.toNat_ofNat]
  omega

/-- `x - y` does not wrap below `x`. -/
theorem sub_nuw {x y : BitVec 64} (h : y.toNat ≤ x.toNat) : x.usubOverflow y = false := by
  simp [BitVec.usubOverflow]; omega

/-- `x - y` keeps its sign. -/
theorem sub_nsw {x y : BitVec 64} (hx : x.toNat < 2 ^ 63) (hy : y.toNat ≤ 128) :
    x.ssubOverflow y = false := by
  have : x < 9223372036854775808#64 := by
    simp [BitVec.lt_def]; omega
  have : y ≤ 128#64 := by
    simp [BitVec.le_def]; omega
  bv_decide

/-- `128 - P` does not wrap below `128`. -/
theorem rem_nuw {pos : BitVec 8} (h : pos.toNat < 128) :
    (128#64).usubOverflow (pos.setWidth 64) = false := by
  have : pos < 128#8 := by
    simp [BitVec.lt_def]; omega
  bv_decide

/-- `128 - P` keeps its sign. -/
theorem rem_nsw (pos : BitVec 8) : (128#64).ssubOverflow (pos.setWidth 64) = false := by bv_decide

/-- The buffer's length is non-negative. -/
theorem pos_msb {pos : BitVec 8} (h : pos.toNat < 128) : pos.msb = false := by
  have : pos < 128#8 := by
    simp [BitVec.lt_def]; omega
  bv_decide

/-- A count of whole blocks is non-negative. -/
theorem pos_msb' {x : BitVec 64} (h : x.toNat < 2 ^ 56) : x.msb = false := by
  have : x < 72057594037927936#64 := by
    simp [BitVec.lt_def]; omega
  bv_decide

/-- `assume(pos > -1)` holds. -/
theorem pos_slt {pos : BitVec 8} (h : pos.toNat < 128) : (255#8).slt pos = true := by
  have : pos < 128#8 := by
    simp [BitVec.lt_def]; omega
  bv_decide

/-- `trunc` to `u8` drops no bits. -/
theorem trunc8_nuw {x : BitVec 64} (h : x.toNat < 128) : (x.setWidth 8).setWidth 64 = x := by
  have : x < 128#64 := by
    simp [BitVec.lt_def]; omega
  bv_decide

/-- `trunc` to `u8` keeps the sign. -/
theorem trunc8_nsw {x : BitVec 64} (h : x.toNat < 128) : (x.setWidth 8).signExtend 64 = x := by
  have : x < 128#64 := by
    simp [BitVec.lt_def]; omega
  bv_decide

/-- The new buffer length does not wrap. -/
theorem pos_add_nuw {P : BitVec 8} {x : BitVec 64} (h : P.toNat + x.toNat < 128) :
    P.uaddOverflow (x.setWidth 8) = false := by
  simp only [BitVec.uaddOverflow, BitVec.toNat_setWidth, decide_eq_false_iff_not, Nat.not_le]
  omega

/-- The whole blocks' bytes fit. -/
theorem mask_lt (n : BitVec 64) : n.toNat &&& 9223372036854775680 < 18446744073709551616 :=
  Nat.lt_of_le_of_lt Nat.and_le_left n.isLt

/-- The whole blocks' bytes, at most the input's. -/
theorem and_mask_le (n : BitVec 64) : (n &&& 9223372036854775680#64).toNat ≤ n.toNat := by
  simp only [BitVec.toNat_and]
  exact Nat.and_le_left

/-- An offset below a bound that does not wrap does not wrap. -/
theorem noOverflow_of_le {p : Pointer} {x : BitVec 64} {k : Nat} (h : x.toNat ≤ k)
    (hk : p.offset.toNat + k < 2 ^ 64) : ¬p.offset.uaddOverflow x := by
  simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le]
  omega

/-- `n >> 7`, the whole blocks. -/
theorem nb_toNat (n : BitVec 64) : (n >>> 7).toNat = n.toNat / 128 := by
  simp [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]

/-- `n & 127`, the rest. -/
theorem tail_toNat (n : BitVec 64) : (n &&& 127#64).toNat = n.toNat % 128 := by
  simp only [BitVec.toNat_and, show (127#64).toNat = 2 ^ 7 - 1 by rfl,
    Nat.and_two_pow_sub_one_eq_mod]

/-- `n & !127`, the whole blocks' bytes, for `n < 2 ^ 63`. -/
theorem full_toNat {n : BitVec 64} (h : n.toNat < 2 ^ 63) :
    (n &&& 9223372036854775680#64).toNat = n.toNat / 128 * 128 := by
  have hb : n < 9223372036854775808#64 := by
    simp [BitVec.lt_def]; omega
  have e : n &&& 9223372036854775680#64 = n - (n &&& 127#64) := by bv_decide
  rw [e,
    BitVec.toNat_sub_of_le
      (by
        simp [BitVec.le_def]; exact Nat.and_le_left),
    tail_toNat]
  omega

/-- `compressMem` keeps a state well-formed. -/
theorem wf_compressMem {a : AllocState} {m : MemoryState} (h : (⟨a, m⟩ : GlobalState).WF) :
    (⟨a, compressMem m self k b⟩ : GlobalState).WF :=
  GlobalState.WF.storeSha512_mk (GlobalState.WF.storeAt_mk h)

/-- `tailMem` keeps a state well-formed. -/
theorem wf_tailMem {a : AllocState} {m : MemoryState} (h : (⟨a, m⟩ : GlobalState).WF) :
    (⟨a, tailMem m self inp n⟩ : GlobalState).WF := by
  unfold tailMem
  split
  · exact GlobalState.WF.storeAt_mk (GlobalState.WF.storeAt_mk h)
  · exact GlobalState.WF.storeAt_mk (GlobalState.WF.storeAt_mk (wf_compressMem h))

/-- `^bb3` on `n` bytes at `inp`, the buffer empty: `tailMem`. -/
theorem tail_eq (self data inp : Pointer) (len n : BitVec 64) (S : GlobalState) (E : ⟪Γ⟫)
    (hwf : S.WF)
    (hg :
      S.mem.Globals
        BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0.globals)
    (hArgs :
      E.args = (args (.value self) (.value data) (.value len) (.value (self.add 128#64))).get)
    (hR :
      E ⊨ [%378 := 127#64, %384 := 7#64, %385 := 9223372036854775680#64, %386 := 0#64, %387 :=
        self.add 127#64, %397 := n, %398 := inp])
    (hself : Room S.mem self 1664) (hso : self.offset.toNat + 208 < 2 ^ 64)
    (hst : S.mem.Sha512Fit (self.add 128#64)) (hbl : Fits S.mem (self.add 192#64) 128)
    (hinp : Fits S.mem inp (8 * n.toNat)) (hio : inp.offset.toNat + n.toNat < 2 ^ 64)
    (hn : n.toNat < 2 ^ 63) (hsi : self.id ≠ inp.id) :
    BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0.runFrom E 3 S =
      .value
        (.nil,
          { S with mem := tailMem S.mem self inp n }) := by
  have hfov := noOverflow_of_le (and_mask_le n) hio
  have hso8 : ¬self.offset.uaddOverflow 208#64 := by
    simp [BitVec.uaddOverflow]; omega
  have htm : n.toNat &&& 127 = n.toNat % 128 := Nat.and_two_pow_sub_one_eq_mod n.toNat 7
  block_init
  step_pure with nb
  step_pure with transparent full
  step_pure with tail
  have htl : tail.toNat < 128 := by
    rw [htail, tail_toNat]; omega
  step_pure [mask_lt n, hfov]
  step_pure
  finish_block
  case isTrue =>
    block_init
    have htt : tail.toNat = n.toNat % 128 := by rw [htail, tail_toNat]
    have hroomt : Room S.mem self (8 * tail.toNat) := hself.mono (by omega)
    have hfitst : Fits S.mem (inp.add (n &&& 9223372036854775680#64)) (8 * tail.toNat) :=
      Fits.add_of_le hfov
        (by
          rw [full_toNat hn, htt]; omega)
        hinp
    clear hst hbl
    step_pure [trunc8_nuw htl, trunc8_nsw htl]
    step_store
    step_memcpy
    finish_block
    block_init
    finish_block
    subst_vars
    simp only [tailMem, hbr, ↓reduceIte]
  case isFalse =>
    have hnbn : nb.toNat = n.toNat / 128 := by rw [hnb, nb_toNat]
    have hnb56 : nb.toNat < 2 ^ 56 := by omega
    have hnbB : Fits S.mem inp (1024 * nb.toNat) := hinp.mono (by omega)
    have hnbo : inp.offset.toNat + 128 * nb.toNat < 2 ^ 64 := by omega
    block_init
    step_pure [pos_msb' hnb56]
    step_pure [Pointer.add_add]
    step_load
    step_pure
    step_store
    step_call using (compress512.call_eq (hn := hbr) (hn56 := hnb56) (hB := hnbB) (hdo := hnbo))
    finish_block
    block_init
    have htt : tail.toNat = n.toNat % 128 := by rw [htail, tail_toNat]
    have hroomt : Room S.mem self (8 * tail.toNat) := hself.mono (by omega)
    have hfitst : Fits S.mem (inp.add (n &&& 9223372036854775680#64)) (8 * tail.toNat) :=
      Fits.add_of_le hfov
        (by
          rw [full_toNat hn, htt]; omega)
        hinp
    clear hst hbl hnbB
    step_pure [trunc8_nuw htl, trunc8_nsw htl]
    step_store
    step_memcpy
    finish_block
    block_init
    finish_block
    subst_vars
    simp only [tailMem, compressMem, hbr, ↓reduceIte]

/-- `update`'s memory keeps a state well-formed. -/
public theorem wf_updateMem {a : AllocState} {m : MemoryState} (h : (⟨a, m⟩ : GlobalState).WF) :
    (⟨a, updateMem m self data len⟩ : GlobalState).WF := by
  dsimp only [updateMem]
  split
  · exact GlobalState.WF.storeAt_mk (GlobalState.WF.storeAt_mk h)
  split
  · exact wf_tailMem h
  · exact wf_tailMem (wf_compressMem (GlobalState.WF.storeAt_mk h))

/-- `<BlockBuffer<U128, Eager>>::digest_blocks(data, |blocks| compress512(core, blocks))`, as
`<Sha512 as Update>::update` calls it: `len` bytes at `data` absorbed by sha2's `Sha512` at
`self`, the core's state and block count at `self + 128` (`updateMem`). The buffer's length (its
last byte) is below `128` and as many first bytes known; `self` is apart from `data`. -/
public theorem call_eq (self data : Pointer) (len : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (hg :
      s.mem.Globals
        BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0.globals)
    (hself : Room s.mem self 1664) (hso : self.offset.toNat + 208 < 2 ^ 64)
    (hpos : Fits s.mem (self.add 127#64) 8) (hP128 : (s.mem.readAt (self.add 127#64) 8).toNat < 128)
    (hbuf : Fits s.mem self (8 * (s.mem.readAt (self.add 127#64) 8).toNat))
    (hst : s.mem.Sha512Fit (self.add 128#64)) (hbl : Fits s.mem (self.add 192#64) 128)
    (hdata : Fits s.mem data (8 * len.toNat)) (hdo : data.offset.toNat + len.toNat < 2 ^ 64)
    (hlen : len.toNat < 2 ^ 63) (hsd : self.id ≠ data.id) :
    BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0.call
        (args (.value self) (.value data) (.value len) (.value (self.add 128#64))) s =
      .value
        (.nil,
          { s with mem := updateMem s.mem self data len }) := by
  generalize hP : s.mem.readAt (self.add 127#64) 8 = P at hP128 hbuf
  -- the end state's `WF`, for `func_init`'s frame-free form
  have hwfU : ({ s with mem := updateMem s.mem self data len } : GlobalState).WF :=
    wf_updateMem (a := s.alloc) hwf
  func_init
  clear hwfU
  have hP₀ : S₀.mem.readAt (self.add 127#64) 8 = P := hS ▸ hP
  simp only [updateMem, hP₀]
  block_init
  iterate 10 step_pure
  step_load
  step_pure [pos_msb hP128]
  step_pure
  step_pure [pos_slt hP128]
  step_pure [rem_nuw hP128, rem_nsw] with rem
  have hremv : rem.toNat = 128 - P.toNat := by
    rw [hrem]; exact rem_toNat hP128
  step_pure
  finish_block
  case
    isTrue =>
    have hL : len.toNat < 128 - P.toNat := by
      simp only [BitVec.ult, decide_eq_true_eq] at hbr
      omega
    have hroom : Room S.mem (self.add (P.setWidth 64)) (8 * len.toNat) :=
      Room.add_of_le
        (by
          simp [BitVec.uaddOverflow]; omega)
        (by
          simp; omega)
        hself
    block_init
    step_pure [Nat.mod_lt _ (show 0 < 2 ^ 64 by decide)]
    step_memcpy
    step_pure [trunc8_nuw (by omega : len.toNat < 128), trunc8_nsw (by omega : len.toNat < 128)]
    step_pure [pos_add_nuw (by omega : P.toNat + len.toNat < 128)]
    step_store
    finish_block
    block_init
    finish_block
    subst hS
    simp only [hbr, ↓reduceIte]
  case
    isFalse =>
    have hL : 128 - P.toNat ≤ len.toNat := by
      simp only [BitVec.ult, decide_eq_true_eq] at hbr
      omega
    have hbr0 : len.ult rem = false := by simpa using hbr
    block_init
    step_pure
    finish_block
    case isTrue =>
      subst hbr
      rw [tail_eq self data data len len S E hwf hg hArgs (by env_reads) hself hso hst hbl hdata hdo
          hlen hsd]
      subst hS
      simp only [hbr0, ↓reduceIte, Bool.false_eq_true]
    case
      isFalse =>
      have hrov : ¬data.offset.uaddOverflow rem := noOverflow_of_le (k := len.toNat) (by omega) hdo
      have hroomr : Room S.mem (self.add (P.setWidth 64)) (8 * rem.toNat) :=
        Room.add_of_le
          (by
            simp [BitVec.uaddOverflow]; omega)
          (by
            simp; omega)
          hself
      have hfitsr : Fits S.mem data (8 * rem.toNat) := hdata.mono (by omega)
      block_init
      step_pure [show rem.toNat < 18446744073709551616 from rem.isLt]
      step_pure [sub_nuw (show rem.toNat ≤ len.toNat by omega),
        sub_nsw hlen (show rem.toNat ≤ 128 by omega)]
      step_pure [Nat.mod_lt _ (show 0 < 2 ^ 64 by decide)]
      step_memcpy
      have hblk : Fits S.mem self (1024 * (1#64).toNat) :=
        Fits.append (off := P.setWidth 64)
          (by
            simp [BitVec.uaddOverflow]; omega)
          (by
            simp; omega)
          (by
            simp; omega)
          hbuf hfits_self_0
      step_pure [Pointer.add_add]
      step_load
      step_pure
      step_store
      step_call using
        (compress512.call_eq (hn := by decide) (hn56 := by decide) (hB := hblk) (hdo := by
          simp; omega))
      finish_block
      have hlr : (len - rem).toNat = len.toNat - rem.toNat :=
        BitVec.toNat_sub_of_le
          (by
            simp [BitVec.le_def]; omega)
      have hinp : Fits S.mem (data.add rem) (8 * (len - rem).toNat) :=
        Fits.add_of_le hrov (by omega) hdata
      have hio : (data.add rem).offset.toNat + (len - rem).toNat < 2 ^ 64 := by
        simp only [Pointer.add, BitVec.toNat_add]
        rw [Nat.mod_eq_of_lt (by omega)]
        omega
      rw [tail_eq self data (data.add rem) len (len - rem) S E hwf hg hArgs (by env_reads) hself hso
          hst hbl hinp hio (by omega) (by simpa [Pointer.add_id] using hsd)]
      subst hS
      simp only [hbr0, hbr, ↓reduceIte, Bool.false_eq_true]
      rw [hP₀, ← hrem]
      simp only [compressMem]

/-! ## The absorbed bytes -/

/-- Two ranges of one object, apart. -/
theorem rng_disj {p : Pointer} {a b : BitVec 64} {v w : Nat} (hp : p.offset.toNat + 208 < 2 ^ 64)
    (ha : a.toNat ≤ 208) (hb : b.toNat ≤ 208)
    (h : a.toNat * 8 + v ≤ b.toNat * 8 ∨ b.toNat * 8 + w ≤ a.toNat * 8) :
    (Range.of (p.add a) v).Disjoint (Range.of (p.add b) w) := by
  simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add]
  rw [Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega)]
  omega

/-- A range from an object's start and one apart from it. -/
theorem rng_disj0 {p : Pointer} {b : BitVec 64} {v w : Nat} (hp : p.offset.toNat + 208 < 2 ^ 64)
    (hb : b.toNat ≤ 208) (h : v ≤ b.toNat * 8 ∨ b.toNat * 8 + w ≤ 0) :
    (Range.of p v).Disjoint (Range.of (p.add b) w) := by
  simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add]
  rw [Nat.mod_eq_of_lt (by omega)]
  omega

/-- The buffer's length, widened. -/
theorem setWidth_toNat {P : BitVec 8} : (P.setWidth 64).toNat = P.toNat := by
  have := P.isLt
  rw [BitVec.toNat_setWidth, Nat.mod_eq_of_lt (by omega)]

/-- Below `128 - P` bytes, `P` the buffer's length: appended to the buffer. -/
theorem absorbed_short {m : MemoryState} {self data : Pointer} {len : BitVec 64}
    {M : List (BitVec 8)} (h : m.Sha2Absorbed self M) (hL : M.length % 128 + len.toNat < 128) :
    ((m.storeAt (self.add ((m.readAt (self.add 127#64) 8).setWidth 64))
              (m.readAt data (8 * len.toNat))).storeAt
          (self.add 127#64) (m.readAt (self.add 127#64) 8 + len.setWidth 8)).Sha2Absorbed
      self (M ++ bytesLE (m.readAt data (8 * len.toNat))) := by
  obtain ⟨hso, hroom, hpf, hp, hbf, hb, hsf, hst, hcf, hc⟩ := h
  generalize hP : m.readAt (self.add 127#64) 8 = P at hp ⊢
  generalize hD : m.readAt data (8 * len.toNat) = D
  have hDl : (bytesLE D).length = len.toNat := by simp
  have hml : (M ++ bytesLE D).length % 128 = M.length % 128 + len.toNat := by
    simp only [List.length_append, hDl]; omega
  have hmd : (M ++ bytesLE D).length / 128 = M.length / 128 := by
    simp only [List.length_append, hDl]; omega
  have hPw := setWidth_toNat (P := P)
  have hP' : P.toNat + len.toNat < 128 := by omega
  have d1 :
    (Range.of (self.add (P.setWidth 64)) (8 * len.toNat)).Disjoint (Range.of (self.add 127#64) 8) :=
    rng_disj hso (by omega) (by decide)
      (by
        simp; omega)
  have hroomP : Room m (self.add (P.setWidth 64)) (8 * len.toNat) :=
    Room.add_of_le
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by omega) hroom
  have hroom127 : Room m (self.add 127#64) 8 := hpf.room (hroom.writable.of_id_eq rfl)
  have hsf' :=
    (hsf.storeAt (q := self.add (P.setWidth 64)) (x := D)).storeAt (q := self.add 127#64) (x :=
      P + len.setWidth 8)
  -- reads of the rest: past both stores
  have past {k : BitVec 64} {w : Nat} (hk : k.toNat ≤ 208)
    (h1 : P.toNat * 8 + 8 * len.toNat ≤ k.toNat * 8 ∨ k.toNat * 8 + w ≤ P.toNat * 8)
    (h2 : 127 * 8 + 8 ≤ k.toNat * 8 ∨ k.toNat * 8 + w ≤ 127 * 8) :
    ((m.storeAt (self.add (P.setWidth 64)) D).storeAt (self.add 127#64) (P + len.setWidth 8)).readAt
        (self.add k) w =
      m.readAt (self.add k) w := by
    rw [MemoryState.readAt_storeAt_disjoint (rng_disj hso (by decide) hk (by simpa using h2)),
      MemoryState.readAt_storeAt_disjoint
        (rng_disj hso (by omega) hk
          (by
            rw [hPw]; omega))]
  refine
    ⟨hso, hroom.storeAt.storeAt, Fits.storeAt_self hroom127.storeAt, ?_, ?_, ?_, hsf', ?_,
      hcf.storeAt.storeAt, ?_⟩
  · rw [MemoryState.readAt_storeAt_self hroom127.storeAt, hml]
    simp only [BitVec.toNat_add, BitVec.toNat_setWidth]
    omega
  · rw [hml]
    exact
      Fits.append (off := P.setWidth 64) (v := 8 * (M.length % 128)) (w := 8 * len.toNat)
        (by
          simp [BitVec.uaddOverflow]; omega)
        (by omega) (by omega) hbf.storeAt.storeAt (Fits.storeAt_self hroomP).storeAt
  · rw [hml, hmd, Nat.mul_add,
      MemoryState.bytesLE_readAt_append (off := P.setWidth 64)
        (by
          simp [BitVec.uaddOverflow]; omega)
        (by omega) (by omega),
      MemoryState.readAt_storeAt_disjoint
        (rng_disj0 hso (b := 127#64) (by decide)
            (by
              simp; omega)).symm,
      MemoryState.readAt_storeAt_disjoint
        (rng_disj0 hso (b := P.setWidth 64) (by omega) (by omega)).symm,
      hb, MemoryState.readAt_storeAt_disjoint d1.symm,
      MemoryState.readAt_storeAt_self hroomP, List.drop_append_of_le_length (by omega)]
  · have hs128 : (self.add 128#64).offset.toNat + 56 < 2 ^ 64 := by
      simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]; omega
    rw [Sha512.compressBlocks_append_short
        (by
          simp only [hDl]; omega),
      ← hst,
      MemoryState.readSha512_storeAt_of_disjoint hs128
        (rng_disj hso (by decide) (by decide) (by simp)),
      MemoryState.readSha512_storeAt_of_disjoint hs128
        (rng_disj hso (by omega) (by decide)
          (by
            simp; omega))]
  · rw [past (by decide)
        (by
          simp; omega)
        (by simp),
      hc, hmd]

/-- `tailMem` keeps the object's state, block count and room, past its stores to the buffer. -/
theorem tail_bytes {m : MemoryState} {inp : Pointer} {n : BitVec 64} {D : BitVec (8 * n.toNat)}
    (hinp : Fits m inp (8 * n.toNat)) (hio : inp.offset.toNat + n.toNat < 2 ^ 64)
    (hn : n.toNat < 2 ^ 63) (hD : m.readAt inp (8 * n.toNat) = D) :
    bytesLE (m.readAt (inp.add (n &&& 9223372036854775680#64)) (8 * (n &&& 127#64).toNat)) =
      (bytesLE D).drop (n.toNat / 128 * 128) := by
  have hf := full_toNat hn
  have ht := tail_toNat n
  rw [MemoryState.readAt_add_of_readAt hinp.inBounds (noOverflow_of_le (and_mask_le n) hio)
      (by
        rw [hf, ht]; omega)
      hD,
    bytesLE_extractLsb' D
      (by
        rw [hf]; omega)
      (by omega)
      (by
        rw [hf, ht]; omega),
    hf, ht, show n.toNat / 128 * 128 * 8 / 8 = n.toNat / 128 * 128 by omega,
    show 8 * (n.toNat % 128) / 8 = n.toNat % 128 by omega]
  apply List.take_of_length_le
  simp only [List.length_drop, length_bytesLE]
  omega

/-- Whole blocks compressed into an object between blocks: still between blocks, after them. -/
theorem blocks_compress {m : MemoryState} {self : Pointer} {M bytes : List (BitVec 8)}
    {c : BitVec 128} (h : m.Sha2Blocks self M) (hb : bytes.length % 128 = 0)
    (hc : c = BitVec.ofNat 128 (bytes.length / 128)) :
    (compressMem m self c bytes).Sha2Blocks self (M ++ bytes) := by
  obtain ⟨hso, hroom, hsf, hst, hcf, hcnt, hw⟩ := h
  have hs128 : (self.add 128#64).offset.toNat + 56 < 2 ^ 64 := by
    simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]; omega
  have d192 : (Range.of (self.add 192#64) 128).Disjoint (Range.of (self.add 128#64) 512) :=
    rng_disj hso (by decide) (by decide) (by simp)
  have hb128 :
    Room (m.storeAt (self.add 192#64) (m.readAt (self.add 192#64) 128 + c)) (self.add 128#64)
      512 :=
    (Room.add_of_le
        (by
          simp [BitVec.uaddOverflow]; omega)
        (by decide) hroom).storeAt
  refine ⟨hso, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · exact (hroom.storeAt).storeSha512
  · exact (hsf.storeAt).storeSha512
  · simp only [compressMem]
    rw [MemoryState.readSha512_storeSha512_self hs128 hb128,
      MemoryState.readSha512_storeAt_of_disjoint hs128 d192, hst, compress512.spec, ←
      Sha512.compressBlocks_append _ hw]
  · exact (hcf.storeAt).storeSha512
  · simp only [compressMem]
    rw [MemoryState.readAt_storeSha512_of_disjoint hs128 d192.symm,
      MemoryState.readAt_storeAt_self (hcf.room (hroom.writable.of_id_eq rfl)), hcnt, hc,
      ← BitVec.ofNat_add]
    congr 1
    simp only [List.length_append]
    omega
  · simp only [List.length_append]; omega

/-- The rest, below a block, buffered in an object between blocks, its length `t` in the last
byte. -/
theorem absorbed_rest {m : MemoryState} {self : Pointer} {M : List (BitVec 8)} {t : Nat}
    {pv : BitVec 8} {X : BitVec (8 * t)} (h : m.Sha2Blocks self M) (ht : t < 128)
    (hpv : pv.toNat = t) :
    ((m.storeAt (self.add 127#64) pv).storeAt self X).Sha2Absorbed self (M ++ bytesLE X) := by
  obtain ⟨hso, hroom, hsf, hst, hcf, hcnt, hw⟩ := h
  have hXl : (bytesLE X).length = t := by simp
  have hml : (M ++ bytesLE X).length % 128 = t := by
    simp only [List.length_append, hXl]; omega
  have hmd : (M ++ bytesLE X).length / 128 = M.length / 128 := by
    simp only [List.length_append, hXl]; omega
  have hs128 : (self.add 128#64).offset.toNat + 56 < 2 ^ 64 := by
    simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]; omega
  have hroom127 : Room m (self.add 127#64) 8 :=
    Room.add_of_le
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by decide) hroom
  have hroomt : Room (m.storeAt (self.add 127#64) pv) self (8 * t) :=
    (hroom.mono (by omega)).storeAt
  refine
    ⟨hso, hroom.storeAt.storeAt, (Fits.storeAt_self hroom127).storeAt, ?_, ?_, ?_,
      hsf.storeAt.storeAt, ?_, hcf.storeAt.storeAt, ?_⟩
  · rw [MemoryState.readAt_storeAt_disjoint
        (rng_disj0 hso (by decide)
          (by
            simp; omega)),
      MemoryState.readAt_storeAt_self hroom127, hpv, hml]
  · rw [hml]; exact Fits.storeAt_self hroomt
  · rw [hml, hmd, MemoryState.readAt_storeAt_self hroomt,
      List.drop_append_of_le_length (by omega), show M.length / 128 * 128 = M.length by omega,
      List.drop_length, List.nil_append]
  · rw [MemoryState.readSha512_storeAt_of_disjoint hs128
        (rng_disj0 hso (by decide)
          (by
            simp; omega)),
      MemoryState.readSha512_storeAt_of_disjoint hs128
        (rng_disj hso (by decide) (by decide) (by simp)),
      hst,
      Sha512.compressBlocks_append_short
        (by
          simp only [hXl]; omega)]
  · rw [MemoryState.readAt_storeAt_disjoint
        (rng_disj0 hso (by decide)
          (by
            simp; omega)),
      MemoryState.readAt_storeAt_disjoint (rng_disj hso (by decide) (by decide) (by simp)), hcnt,
      hmd]

/-- A read of another block past `compressMem`. -/
theorem readAt_compressMem {m : MemoryState} {self q : Pointer}
    (hso : self.offset.toNat + 208 < 2 ^ 64) (hne : self.id ≠ q.id) :
    (compressMem m self c b).readAt q w = m.readAt q w := by
  simp only [compressMem]
  rw [MemoryState.readAt_storeSha512_of_disjoint
      (by
        simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]; omega)
      (Range.disjoint_of_id_ne (by simpa using hne)),
    MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne (by simpa using hne))]

/-- `n` bytes at `inp` absorbed by an object between blocks. -/
theorem absorbed_tail {m : MemoryState} {self inp : Pointer} {n : BitVec 64} {M : List (BitVec 8)}
    (h : m.Sha2Blocks self M) (hinp : Fits m inp (8 * n.toNat))
    (hio : inp.offset.toNat + n.toNat < 2 ^ 64) (hn : n.toNat < 2 ^ 63) (hsi : self.id ≠ inp.id) :
    (tailMem m self inp n).Sha2Absorbed self (M ++ bytesLE (m.readAt inp (8 * n.toNat))) := by
  generalize hD : m.readAt inp (8 * n.toNat) = D
  have hDl : (bytesLE D).length = n.toNat := by simp
  have ht := tail_toNat n
  have hpv : ((n &&& 127#64).setWidth 8).toNat = (n &&& 127#64).toNat := by
    rw [BitVec.toNat_setWidth, Nat.mod_eq_of_lt (by omega)]
  have hbytes := tail_bytes hinp hio hn hD
  have hnb := nb_toNat n
  unfold tailMem
  by_cases h0 : n >>> 7 = 0#64
  · simp only [h0, ↓reduceIte]
    have hL : n.toNat < 128 := by
      rw [h0] at hnb; simp at hnb; omega
    have :=
      absorbed_rest (X :=
        m.readAt (inp.add (n &&& 9223372036854775680#64)) (8 * (n &&& 127#64).toNat)) h (by omega)
        hpv
    rwa [hbytes, show n.toNat / 128 * 128 = 0 by omega, List.drop_zero] at this
  · simp only [h0, ↓reduceIte]
    have hblocks :
      bytesLE (m.readAt inp (1024 * (n >>> 7).toNat)) =
        (bytesLE D).take (128 * (n.toNat / 128)) := by
      rw [MemoryState.readAt_of_readAt_le (by omega) hD, bytesLE_setWidth _ (by omega) (by omega)]
      congr 1
      omega
    have hc :=
      blocks_compress (c := (n >>> 7).setWidth 128) h (bytes :=
        bytesLE (m.readAt inp (1024 * (n >>> 7).toNat)))
        (by
          rw [hblocks, List.length_take, hDl]; omega)
        (by
          rw [hblocks, List.length_take, hDl]
          apply BitVec.eq_of_toNat_eq
          simp only [BitVec.toNat_setWidth, BitVec.toNat_ofNat, hnb]
          congr 1
          omega)
    have :=
      absorbed_rest (X :=
        (compressMem m self ((n >>> 7).setWidth 128)
              (bytesLE (m.readAt inp (1024 * (n >>> 7).toNat)))).readAt
          (inp.add (n &&& 9223372036854775680#64)) (8 * (n &&& 127#64).toNat))
        hc (by omega) hpv
    refine (congrArg _ ?_).mp this
    rw [readAt_compressMem h.off (by simpa using hsi), hbytes, hblocks, List.append_assoc,
      show 128 * (n.toNat / 128) = n.toNat / 128 * 128 by omega, List.take_append_drop]

/-- An object that has absorbed whole blocks only is between blocks. -/
theorem blocks_of_absorbed {m : MemoryState} {self : Pointer} {M : List (BitVec 8)}
    (h : m.Sha2Absorbed self M) (hM : M.length % 128 = 0) : m.Sha2Blocks self M :=
  ⟨h.off, h.room, h.stateFit, h.state, h.countFits, h.count, hM⟩

/-- A non-empty buffer filled to a block from `data` and compressed. -/
theorem blocks_fill {m : MemoryState} {self data : Pointer} {len : BitVec 64} {M : List (BitVec 8)}
    (h : m.Sha2Absorbed self M) (hL : 128 - M.length % 128 ≤ len.toNat) :
    (compressMem
          (m.storeAt (self.add ((m.readAt (self.add 127#64) 8).setWidth 64))
            (m.readAt data (8 * (128#64 - (m.readAt (self.add 127#64) 8).setWidth 64).toNat)))
          self 1#128
          (bytesLE
            ((m.storeAt (self.add ((m.readAt (self.add 127#64) 8).setWidth 64))
                  (m.readAt data
                    (8 * (128#64 - (m.readAt (self.add 127#64) 8).setWidth 64).toNat))).readAt
              self 1024))).Sha2Blocks
      self
      (M ++
        (bytesLE (m.readAt data (8 * len.toNat))).take
          (128#64 - (m.readAt (self.add 127#64) 8).setWidth 64).toNat) := by
  obtain ⟨hso, hroom, hpf, hp, hbf, hb, hsf, hst, hcf, hc⟩ := h
  generalize hP : m.readAt (self.add 127#64) 8 = P at hp ⊢
  have hP128 : P.toNat < 128 := by omega
  have hrem := rem_toNat hP128
  generalize hR : 128#64 - P.setWidth 64 = rem at hrem ⊢
  generalize hD : m.readAt data (8 * len.toNat) = D
  have hPw := setWidth_toNat (P := P)
  have hs128 : (self.add 128#64).offset.toNat + 56 < 2 ^ 64 := by
    simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]; omega
  have hroomP : Room m (self.add (P.setWidth 64)) (8 * rem.toNat) :=
    Room.add_of_le
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by omega) hroom
  have dst :
    (Range.of (self.add (P.setWidth 64)) (8 * rem.toNat)).Disjoint
      (Range.of (self.add 128#64) 512) :=
    rng_disj hso (by omega) (by decide)
      (by
        simp; omega)
  -- the whole blocks before the buffer's
  have hk : (M.take (M.length / 128 * 128)).length = M.length / 128 * 128 := by
    simp only [List.length_take]; omega
  have h1 :
    (m.storeAt (self.add (P.setWidth 64)) (m.readAt data (8 * rem.toNat))).Sha2Blocks self
      (M.take (M.length / 128 * 128)) := by
    refine
      ⟨hso, hroom.storeAt, hsf.storeAt, ?_, hcf.storeAt, ?_, by
        rw [hk]; omega⟩
    · rw [MemoryState.readSha512_storeAt_of_disjoint hs128 dst, hst, ← Sha512.compressBlocks_take]
    · rw [MemoryState.readAt_storeAt_disjoint
          (rng_disj hso (by omega) (by decide)
            (by
              simp; omega)),
        hc, hk]
      congr 1
      omega
  have :=
    blocks_compress (c := 1#128) h1 (bytes :=
      bytesLE
        ((m.storeAt (self.add (P.setWidth 64)) (m.readAt data (8 * rem.toNat))).readAt self 1024))
      (by simp) (by simp)
  refine (congrArg _ ?_).mp this
  rw [show 1024 = 8 * (M.length % 128) + 8 * rem.toNat by omega,
    MemoryState.bytesLE_readAt_append (off := P.setWidth 64)
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by omega) (by omega),
    MemoryState.readAt_storeAt_disjoint (rng_disj0 hso (by omega) (by omega)).symm, hb,
    MemoryState.readAt_storeAt_self hroomP, MemoryState.readAt_of_readAt_le (by omega) hD,
    bytesLE_setWidth _ (by omega) (by omega), show 8 * rem.toNat / 8 = rem.toNat by omega, ←
    List.append_assoc, List.take_append_drop]

/-- `update`'s memory: the object at `self` has absorbed the `len` bytes at `data` after `M`. -/
public theorem updateMem_absorbed {m : MemoryState} {self data : Pointer} {len : BitVec 64}
    {M : List (BitVec 8)} (h : m.Sha2Absorbed self M) (hdata : Fits m data (8 * len.toNat))
    (hdo : data.offset.toNat + len.toNat < 2 ^ 64) (hlen : len.toNat < 2 ^ 63)
    (hsd : self.id ≠ data.id) :
    (updateMem m self data len).Sha2Absorbed self
      (M ++ bytesLE (m.readAt data (8 * len.toNat))) := by
  have hp := h.pos
  have hP128 : (m.readAt (self.add 127#64) 8).toNat < 128 := by omega
  have hrem := rem_toNat hP128
  dsimp only [updateMem]
  split
  · rename_i hA
    simp only [BitVec.ult, decide_eq_true_eq, hrem] at hA
    exact absorbed_short h (by omega)
  split
  · rename_i hA h0
    rw [h0] at hp
    simp only [BitVec.toNat_ofNat] at hp
    exact absorbed_tail (blocks_of_absorbed h (by omega)) hdata hdo hlen hsd
  rename_i hA h0
  simp only [BitVec.ult, decide_eq_true_eq, hrem] at hA
  have hP0 : (m.readAt (self.add 127#64) 8).toNat ≠ 0 := fun h' => h0 (BitVec.eq_of_toNat_eq h')
  generalize hR : 128#64 - (m.readAt (self.add 127#64) 8).setWidth 64 = rem at hrem ⊢
  have hlr : (len - rem).toNat = len.toNat - rem.toNat :=
    BitVec.toNat_sub_of_le
      (by
        simp [BitVec.le_def]; omega)
  have hrov : ¬data.offset.uaddOverflow rem := noOverflow_of_le (k := len.toNat) (by omega) hdo
  have hfill := blocks_fill h (len := len) (data := data) (by omega)
  rw [hR] at hfill
  generalize hD : m.readAt data (8 * len.toNat) = D at hfill ⊢
  have hio : (data.add rem).offset.toNat + (len - rem).toNat < 2 ^ 64 := by
    simp only [Pointer.add, BitVec.toNat_add]
    rw [Nat.mod_eq_of_lt (by omega)]
    omega
  have hne : self.id ≠ (data.add rem).id := by simpa using hsd
  have hinp := Fits.add_of_le (w := 8 * (len - rem).toNat) hrov (by omega) hdata
  have :=
    absorbed_tail hfill (inp := data.add rem) (n := len - rem)
      (by
        simp only [compressMem]; exact hinp.storeAt.storeAt.storeSha512)
      hio (by omega) hne
  refine (congrArg _ ?_).mp this
  rw [readAt_compressMem h.off hne,
    MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne (by simpa using hsd)),
    MemoryState.readAt_add_of_readAt hdata.inBounds hrov (by omega) hD,
    bytesLE_extractLsb' D (by omega) (by omega) (by omega), List.append_assoc,
    show rem.toNat * 8 / 8 = rem.toNat by omega,
    show 8 * (len - rem).toNat / 8 = (len - rem).toNat by omega,
    List.take_of_length_le (l := List.drop rem.toNat (bytesLE D))
      (by
        simp only [List.length_drop, length_bytesLE]; omega),
    List.take_append_drop]

/-- `tailMem` keeps the globals table. -/
public theorem globals_tailMem {m : MemoryState} {self inp : Pointer} {n : BitVec 64} :
    (tailMem m self inp n).globals = m.globals := by
  simp only [tailMem]
  split <;> rfl

/-- `update`'s memory keeps the globals table (the steps do not see through its `if`s). -/
public theorem globals_updateMem {m : MemoryState} {self data : Pointer} {len : BitVec 64} :
    (updateMem m self data len).globals = m.globals := by
  dsimp only [updateMem]
  split
  · rfl
  split
  · exact globals_tailMem
  · exact globals_tailMem

/-- `update`'s memory keeps every block's writability (the steps do not see through its `if`s). -/
public theorem writable_updateMem {m : MemoryState} {self data p : Pointer} {len : BitVec 64}
    (h : Writable m p) : Writable (updateMem m self data len) p := by
  have hc {m : MemoryState} {c b} (h : Writable m p) : Writable (compressMem m self c b) p := by
    simp only [compressMem, MemoryState.storeSha512]
    exact h.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt.storeAt
  have ht {m : MemoryState} {inp n} (h : Writable m p) : Writable (tailMem m self inp n) p := by
    simp only [tailMem]
    split
    · exact h.storeAt.storeAt
    · exact (hc h).storeAt.storeAt
  dsimp only [updateMem]
  split
  · exact h.storeAt.storeAt
  split
  · exact ht h
  · exact ht (hc h.storeAt)

/-- `update`'s memory keeps room where there was. -/
public theorem room_updateMem {m : MemoryState} {self data p : Pointer} {len : BitVec 64}
    (h : Room m p w) : Room (updateMem m self data len) p w := by
  have hc {m : MemoryState} {c b} (h : Room m p w) : Room (compressMem m self c b) p w := by
    simp only [compressMem]; exact h.storeAt.storeSha512
  have ht {m : MemoryState} {inp n} (h : Room m p w) : Room (tailMem m self inp n) p w := by
    simp only [tailMem]
    split
    · exact h.storeAt.storeAt
    · exact (hc h).storeAt.storeAt
  dsimp only [updateMem]
  split
  · exact h.storeAt.storeAt
  split
  · exact ht h
  · exact ht (hc h.storeAt)

end Proof

end BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0

end MLIR.Agave.Serial
