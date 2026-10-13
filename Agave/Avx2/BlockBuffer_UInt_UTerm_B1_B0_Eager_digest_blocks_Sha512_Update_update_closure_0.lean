module

public import MLIR.Run.Tactic
public import Agave.Common.Sha512
public import Agave.Avx2.compress512
public import Agave.Serial.BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0
public import Agave.Avx2.Mlir.BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Avx2

open _root_.Ed25519

namespace BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0

open Serial.BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0
  (compressMem tailCalls tailMem updateMem updateCalls)

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

/-- Nothing at or above a well-formed state's counter. -/
theorem eraseFrom_of_wf {a : AllocState} {m : MemoryState} (h : (⟨a, m⟩ : GlobalState).WF) :
    m.eraseFrom a.nextFreeBlock = m :=
  h.eraseFrom

/-- A range from an object's start and one apart from it. -/
theorem rng_disj0 {p : Pointer} {b : BitVec 64} {v w : Nat} (hp : p.offset.toNat + 208 < 2 ^ 64)
    (hb : b.toNat ≤ 208) (h : v ≤ b.toNat * 8 ∨ b.toNat * 8 + w ≤ 0) :
    (Range.of p v).Disjoint (Range.of (p.add b) w) := by
  simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add]
  rw [Nat.mod_eq_of_lt (by omega)]
  omega

/-- `^bb3` on `n` bytes at `inp`, the buffer empty: `tailMem`. -/
theorem tail_eq (self data inp : Pointer) (len n : BitVec 64) (S : GlobalState) (E : ⟪Γ⟫)
    (hwf : S.WF)
    (hg :
      S.mem.Globals
        BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0.globals)
    (hArgs :
      E.args = (args (.value self) (.value data) (.value len) (.value (self.add 128#64))).get)
    (hR :
      E ⊨ [%490 := 127#64, %496 := 7#64, %497 := 9223372036854775680#64, %498 := 0#64, %499 :=
        self.add 127#64, %509 := n, %510 := inp])
    (hself : Room S.mem self 1664) (hso : self.offset.toNat + 208 < 2 ^ 64)
    (hst : S.mem.Sha512Fit (self.add 128#64)) (hbl : Fits S.mem (self.add 192#64) 128)
    (hinp : Fits S.mem inp (8 * n.toNat)) (hio : inp.offset.toNat + n.toNat < 2 ^ 64)
    (hn : n.toNat < 2 ^ 63) (hsi : self.id ≠ inp.id) :
    BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0.runFrom E 3 S =
      .value
        (.nil,
          { alloc := ⟨S.alloc.nextFreeBlock + 3 * tailCalls n⟩,
            mem := tailMem S.mem self inp n }) := by
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
    simp only [tailMem, tailCalls, hbr, ↓reduceIte, Nat.mul_zero, Nat.add_zero]
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
    step_call using
      (compress512.call_eq (hn56 := hnb56) (hB := hnbB) (hdo := hnbo) (hsep :=
        Range.disjoint_of_id_ne (by simpa using hsi)))
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
    simp only [tailMem, tailCalls, compressMem, hbr, ↓reduceIte, Nat.mul_one]

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
          { alloc := ⟨s.alloc.nextFreeBlock + 3 * updateCalls s.mem self len⟩
            mem := updateMem s.mem self data len }) := by
  generalize hP : s.mem.readAt (self.add 127#64) 8 = P at hP128 hbuf
  simp only [updateMem, updateCalls]
  simp only [hP]
  func_init
  have hP₀ : S₀.mem.readAt (self.add 127#64) 8 = P := hS ▸ hP
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
    erase_frame
    simp only [hbr, ↓reduceIte, Nat.mul_zero, Nat.add_zero]
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
      simp only [PoisonOr.value_bind, hbr0, ↓reduceIte, Bool.false_eq_true,
        eraseFrom_of_wf (wf_tailMem hwf)]
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
        (compress512.call_eq (hn56 := by decide) (hB := hblk) (hdo := by
          simp; omega) (hsep := (rng_disj0 hso (b := 128#64) (by decide) (by simp)).symm))
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
      simp only [PoisonOr.value_bind, hbr0, hbr, ↓reduceIte, Bool.false_eq_true]
      rw [eraseFrom_of_wf
          (wf_tailMem
            (GlobalState.WF.storeSha512_mk
              (GlobalState.WF.storeAt_mk (GlobalState.WF.storeAt_mk hwf₀))))]
      rw [hP₀, ← hrem]
      simp only [compressMem, Nat.mul_add, Nat.mul_one, Nat.add_assoc]

end Proof

end BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0

end MLIR.Agave.Avx2
