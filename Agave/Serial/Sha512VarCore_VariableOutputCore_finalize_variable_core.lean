module

public import MLIR.Run.Tactic
public import Agave.Common.Sha512
public import Agave.Serial.compress512
public import Agave.Serial.copy_from_slice_impl_u8
public import Agave.Serial.Mlir.Sha512VarCore_VariableOutputCore_finalize_variable_core
import Firedancer.Common.Memory
import Firedancer.Common.LimbBits
import Std.Data.ExtHashMap.Lemmas
import Mathlib.Tactic.Rename
import Mathlib.Tactic.FinCases
import Mathlib.Data.Fintype.Basic
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Serial

open _root_.Ed25519

/-! ## Specification -/

@[expose] public section

namespace Sha512VarCore_VariableOutputCore_finalize_variable_core

/-- The state words at `out`: each word's bytes swapped (big-endian), word `0` lowest, as the
code's four 16-byte stores leave them. -/
def outBits (H : Vector (BitVec 64) 8) : BitVec 512 :=
  (compress512.bswap64 H[7] ++ compress512.bswap64 H[6]) ++
    ((compress512.bswap64 H[5] ++ compress512.bswap64 H[4]) ++
      ((compress512.bswap64 H[3] ++ compress512.bswap64 H[2]) ++
        (compress512.bswap64 H[1] ++ compress512.bswap64 H[0])))

/-- `bit_len = 8 * (pos + 128 * block_len)` as the code computes it. -/
def bitLen (C : BitVec 128) (P : BitVec 8) : BitVec 128 :=
  C <<< 10 ||| P.setWidth 128 <<< 3

/-- `llvm.intr.bswap` on 128 bits, as the step leaves it. -/
abbrev bswap128 (x : BitVec 128) : BitVec 128 :=
  List.foldl (fun acc i => acc ||| (x >>> (8 * i) &&& 255#128) <<< (128 - 8 * (i + 1))) 0#128
    (List.range 16)

/-- `pad_with_zeros` then `buf[pos] = 0x80`: the `pos` buffered bytes `D`, `0x80`, zeros. -/
def padBlock (P : BitVec 8) (D : BitVec (8 * P.toNat)) : BitVec 1024 :=
  Memory.spliceBits (Memory.spliceBits 0#1024 0 D) (P.toNat * 8) 128#8

/-- The length's 16 bytes do not fit after `0x80` (`pos ≥ 112`): two blocks. -/
def twoBlocks (P : BitVec 8) : Bool :=
  (P.setWidth 64 ^^^ 112#64).ult 16#64

/-- `finalize_variable_core`'s state words: from `H`, the block count `C`, the buffer's `P` bytes
`D`, the padded last block(s) compressed (`len128_padding_be`). -/
def spec (H : Vector (BitVec 64) 8) (C : BitVec 128) (P : BitVec 8) (D : BitVec (8 * P.toNat)) :
    Vector (BitVec 64) 8 :=
  let block := padBlock P D
  let len_be := bswap128 (bitLen C P)
  if twoBlocks P then
    compress512.spec (compress512.spec H (bytesLE block))
      (bytesLE (Memory.spliceBits (Memory.spliceBits block 0 0#896) 896 len_be))
  else compress512.spec H (bytesLE (Memory.spliceBits block 896 len_be))

/-- `spec` of sha2's `Sha512` at `d` in `m`: its state words, count, position and buffer. -/
abbrev state (m : MemoryState) (d : Pointer) : Vector (BitVec 64) 8 :=
  spec (m.readSha512 (d.add 128#64)) (m.readAt (d.add 192#64) 128) (m.readAt (d.add 127#64) 8)
    (m.readAt d (8 * (m.readAt (d.add 127#64) 8).toNat))

end Sha512VarCore_VariableOutputCore_finalize_variable_core

end

/-! ## Proof -/

namespace Sha512VarCore_VariableOutputCore_finalize_variable_core

section Proof

/-- A `<2 x i64>` load at `p`, byte-swapped per lane and stored: the two words swapped. -/
theorem pair_eq (m : MemoryState) (p : Pointer) (hov : ¬p.offset.uaddOverflow 8#64) :
    BitVec.packLanes
        (Vector.ofFn fun i =>
          List.foldl
            (fun acc j =>
              acc |||
                (Ty.extractVecElem 2 64 i (m.readAt p 128) >>> (8 * j) &&& 255#64) <<<
                  (64 - 8 * (j + 1)))
            (0#64) (List.range 8)) =
      compress512.bswap64 (m.readAt (p.add 8#64) 64) ++ compress512.bswap64 (m.readAt p 64) := by
  have h : m.readAt p 128 = m.readAt (p.add 8#64) 64 ++ m.readAt p 64 :=
    MemoryState.readAt_append (w := 64) (v := 64) hov rfl
  rw [BitVec.packLanes_pair, h]
  generalize m.readAt (p.add 8#64) 64 = a
  generalize m.readAt p 64 = b
  simp only [Vector.getElem_ofFn, Ty.extractVecElem_eq, compress512.bswap64, List.range,
    List.range.loop, List.foldl]
  bv_decide

/-- `copy_from_slice` of the buffer's `pos` bytes into the padding block. -/
theorem copy_pos {P : BitVec 8} (hP : P.toNat < 128) (dst src loc : Pointer) (s : GlobalState)
    (hwf : s.WF) (hdst : Room s.mem dst 1024) (hsrc : Fits s.mem src (8 * P.toNat))
    (hsep : dst.id ≠ src.id) :
    copy_from_slice_impl_u8.call
        (copy_from_slice_impl_u8.args (.value dst) (.value (P.setWidth 64)) (.value src)
          (.value (P.setWidth 64)) (.value loc))
        s =
      .value (.nil, { s with mem := s.mem.storeAt dst (s.mem.readAt src (8 * P.toNat)) }) := by
  have hP64 : (P.setWidth 64).toNat = P.toNat := by
    simp; omega
  have h :=
    copy_from_slice_impl_u8.call_eq dst src loc (P.setWidth 64) s hwf (hdst.mono (by omega))
      (hP64 ▸ hsrc) hsep
  rwa [hP64] at h

/-- The buffer's length is non-negative. -/
public theorem pos_msb {pos : BitVec 8} (h : pos.toNat < 128) : pos.msb = false := by
  have : pos < 128#8 := by
    simp [BitVec.lt_def]; omega
  bv_decide

/-- `(pos as u128) << 3` loses no bits. -/
public theorem shl3_nuw (P : BitVec 8) : P.setWidth 128 <<< 3 >>> 3 = P.setWidth 128 := by bv_decide

/-- `(pos as u128) << 3` keeps its sign. -/
public theorem shl3_nsw (P : BitVec 8) : (P.setWidth 128 <<< 3).sshiftRight 3 = P.setWidth 128 := by
  bv_decide

/-- The block count's bits and the buffer's, shifted to bits, do not meet. -/
public theorem len_disjoint (C : BitVec 128) {P : BitVec 8} (h : P.toNat < 128) :
    C <<< 10 &&& P.setWidth 128 <<< 3 = 0#128 := by
  have : P < 128#8 := by
    simp [BitVec.lt_def]; omega
  bv_decide

/-- `assume(pos > -1)` holds. -/
public theorem pos_slt {pos : BitVec 8} (h : pos.toNat < 128) : (255#8).slt pos = true := by
  have : pos < 128#8 := by
    simp [BitVec.lt_def]; omega
  bv_decide

/-- Storing the known bits a range holds changes nothing. -/
public theorem storeAt_readAt_self {m : MemoryState} (h : Fits m p w) :
    m.storeAt p (m.readAt p w) = m :=
  MemoryState.storeAt_readAt_self h

/-- A state's memory with a known range: the same memory, the range's bits stored again. -/
public theorem restore {S : GlobalState} {a : AllocState} {m : MemoryState} {p : Pointer}
    {X : BitVec w} (hS : S = ⟨a, m⟩) (hf : Fits S.mem p w) (hr : S.mem.readAt p w = X) :
    S = ⟨a, m.storeAt p X⟩ := by
  subst hS
  rw [← hr, storeAt_readAt_self hf]

/-- A state's memory after a store, read back there. -/
public theorem readBack {S : GlobalState} {a : AllocState} {m : MemoryState} {p : Pointer}
    {X : BitVec w} (hS : S = ⟨a, m.storeAt p X⟩) (h : Room S.mem p w) : S.mem.readAt p w = X := by
  subst hS
  exact MemoryState.readAt_storeAt_self (Room.storeAt_iff.1 h) _

/-- `storeSha512` as one store of the eight words, word `0` lowest. -/
public theorem storeSha512_eq {m : MemoryState} {p : Pointer} {v : Vector (BitVec 64) 8}
    (hp : p.offset.toNat + 56 < 2 ^ 64) :
    m.storeSha512 p v =
      m.storeAt p ((v[7] ++ (v[6] ++ (v[5] ++ (v[4] ++ (v[3] ++ (v[2] ++ v[1])))))) ++ v[0]) := by
  have hov (k : Nat) (hk : k ≤ 48) : ¬(p.add 8#64).offset.uaddOverflow (BitVec.ofNat 64 k) := by
    simp only [Pointer.add, BitVec.uaddOverflow, BitVec.toNat_add, BitVec.toNat_ofNat]
    rw [Nat.mod_eq_of_lt (show 8 < 2 ^ 64 by decide), Nat.mod_eq_of_lt (by omega),
      Nat.mod_eq_of_lt (by omega)]
    simp
    omega
  have e (k : Nat) (hk : 8 ≤ k) (hk' : k < 2 ^ 64) :
    p.add (BitVec.ofNat 64 k) = (p.add 8#64).add (BitVec.ofNat 64 (k - 8)) := by
    rw [Pointer.add_add, ← BitVec.ofNat_add, show 8 + (k - 8) = k by omega]
  unfold MemoryState.storeSha512
  rw [e 16 (by decide) (by decide), MemoryState.storeAt_storeAt_concat (hov 8 (by decide)) rfl,
    e 24 (by decide) (by decide), MemoryState.storeAt_storeAt_concat (hov 16 (by decide)) rfl,
    e 32 (by decide) (by decide), MemoryState.storeAt_storeAt_concat (hov 24 (by decide)) rfl,
    e 40 (by decide) (by decide), MemoryState.storeAt_storeAt_concat (hov 32 (by decide)) rfl,
    e 48 (by decide) (by decide), MemoryState.storeAt_storeAt_concat (hov 40 (by decide)) rfl,
    e 56 (by decide) (by decide), MemoryState.storeAt_storeAt_concat (hov 48 (by decide)) rfl,
    MemoryState.storeAt_storeAt_below
      (by
        simp [BitVec.uaddOverflow]; omega)
      rfl]

/-- A second `storeSha512` to the same words overwrites the first. -/
public theorem storeSha512_storeSha512 {m : MemoryState} {p : Pointer} {v u : Vector (BitVec 64) 8}
    (hp : p.offset.toNat + 56 < 2 ^ 64) :
    (m.storeSha512 p v).storeSha512 p u = m.storeSha512 p u := by
  rw [storeSha512_eq hp, storeSha512_eq hp, storeSha512_eq hp, MemoryState.storeAt_storeAt_self]

/-- `d + k` steps by `j` bytes without wrapping, inside `d`'s 208 bytes. -/
public theorem obj_noOverflow {d : Pointer} (hdo : d.offset.toNat + 208 < 2 ^ 64) (k j : Nat)
    (hk : k + j ≤ 208) : ¬(d.add (BitVec.ofNat 64 k)).offset.uaddOverflow (BitVec.ofNat 64 j) := by
  simp only [Pointer.add, BitVec.uaddOverflow, BitVec.toNat_add, BitVec.toNat_ofNat]
  rw [Nat.mod_eq_of_lt (show k < 2 ^ 64 by omega), Nat.mod_eq_of_lt (show j < 2 ^ 64 by omega),
    Nat.mod_eq_of_lt (by omega)]
  simp
  omega

/-- Two state words at `d + k`, `d + k + 8`: their 128 bits. -/
public theorem fits_pair {m : MemoryState} {d : Pointer} (hdo : d.offset.toNat + 208 < 2 ^ 64)
    (k : Nat) (hk : k + 16 ≤ 208) (h₁ : Fits m (d.add (BitVec.ofNat 64 k)) 64)
    (h₂ : Fits m (d.add (BitVec.ofNat 64 (k + 8))) 64) : Fits m (d.add (BitVec.ofNat 64 k)) 128 :=
  Fits.append (off := 8#64) (obj_noOverflow hdo k 8 (by omega)) rfl rfl h₁
    (by rwa [Pointer.add_add, ← BitVec.ofNat_add])

/-- `^bb3`: the buffer's position reset, the state words stored big-endian at `out`. -/
theorem tail_eq (d out : Pointer) (S : GlobalState) (E : ⟪Γ⟫) (hwf : S.WF)
    (hArgs : E.args = (args (.value (d.add 128#64)) (.value d) (.value out)).get)
    (hR : E ⊨ [%337 := 0#8, %348 := d.add 127#64]) (hdo : d.offset.toNat + 208 < 2 ^ 64)
    (hpos : Room S.mem (d.add 127#64) 8) (hst : S.mem.Sha512Fit (d.add 128#64))
    (hout : Room S.mem out 512) (hoo : ¬out.offset.uaddOverflow 64#64) (hsep : out.id ≠ d.id)
    {H : Vector (BitVec 64) 8} (hH : S.mem.readSha512 (d.add 128#64) = H) :
    Sha512VarCore_VariableOutputCore_finalize_variable_core.runFrom E 3 S =
      .value
        (.nil, { S with mem := (S.mem.storeAt (d.add 127#64) 0#8).storeAt out (outBits H) }) := by
  subst hH
  obtain ⟨hso, h0, h1, h2, h3, h4, h5, h6, h7⟩ := hst
  simp only [Pointer.add_add, BitVec.reduceAdd] at h1 h2 h3 h4 h5 h6 h7
  have hq0 := fits_pair hdo 128 (by decide) h0 h1
  have hq1 := fits_pair hdo 144 (by decide) h2 h3
  have hq2 := fits_pair hdo 160 (by decide) h4 h5
  have hq3 := fits_pair hdo 176 (by decide) h6 h7
  block_init
  step_store
  step_load
  step_pure
  step_store
  iterate 3 
    step_pure
    step_pure
    step_load
    step_pure
    step_store
  finish_block
  subst hS
  have hov (k : Nat) (hk : k ≤ 64) : ¬out.offset.uaddOverflow (BitVec.ofNat 64 k) := by
    simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, Nat.not_le] at hoo ⊢
    rw [Nat.mod_eq_of_lt (by omega)]
    omega
  rw [pair_eq _ _ (obj_noOverflow hdo 128 8 (by decide)),
    pair_eq _ _ (obj_noOverflow hdo 144 8 (by decide)),
    pair_eq _ _ (obj_noOverflow hdo 160 8 (by decide)),
    pair_eq _ _ (obj_noOverflow hdo 176 8 (by decide)),
    MemoryState.storeAt_storeAt_concat (hov 16 (by decide)) rfl,
    MemoryState.storeAt_storeAt_concat (hov 32 (by decide)) rfl,
    MemoryState.storeAt_storeAt_concat (hov 48 (by decide)) rfl]
  simp only [MemoryState.readSha512, outBits, Pointer.add_add, BitVec.reduceAdd]
  rfl

/-- `compress512` of one block at `blk` (in its own slot) into the state words `H` at `st`. -/
theorem compress_one (st blk : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals compress512.globals) (hst : s.mem.Sha512Fit st) (hstw : Writable s.mem st)
    (hB : Fits s.mem blk 1024) (hbo : blk.offset = 0) {H : Vector (BitVec 64) 8} {B : BitVec 1024}
    (hH : s.mem.readSha512 st = H) (hBr : s.mem.readAt blk 1024 = B) :
    compress512.call (compress512.args (.value st) (.value blk) (.value 1#64)) s =
      .value
        (.nil,
          { s with mem := s.mem.storeSha512 st (compress512.spec H (bytesLE B)) }) := by
  have hBr' : s.mem.readAt blk (1024 * (1#64).toNat) = B := hBr
  rw [compress512.call_eq st blk 1#64 s hwf hg hst hstw (by decide) (by decide) hB (by simp [hbo]),
    hH, hBr']

/-- The state words at `d + 128` as eight reads. -/
public theorem sha_words {m : MemoryState} {d : Pointer} {H : Vector (BitVec 64) 8}
    (h : m.readSha512 (d.add 128#64) = H) :
    m.readAt (d.add 128#64) 64 = H[0] ∧
      m.readAt (d.add 136#64) 64 = H[1] ∧
      m.readAt (d.add 144#64) 64 = H[2] ∧
      m.readAt (d.add 152#64) 64 = H[3] ∧
      m.readAt (d.add 160#64) 64 = H[4] ∧
      m.readAt (d.add 168#64) 64 = H[5] ∧
      m.readAt (d.add 176#64) 64 = H[6] ∧ m.readAt (d.add 184#64) 64 = H[7] := by
  subst h
  simp [MemoryState.readSha512]

/-- The state words at `d + 128` from eight reads. -/
public theorem sha_of_words {m : MemoryState} {d : Pointer} {H : Vector (BitVec 64) 8}
    (h0 : m.readAt (d.add 128#64) 64 = H[0]) (h1 : m.readAt (d.add 136#64) 64 = H[1])
    (h2 : m.readAt (d.add 144#64) 64 = H[2]) (h3 : m.readAt (d.add 152#64) 64 = H[3])
    (h4 : m.readAt (d.add 160#64) 64 = H[4]) (h5 : m.readAt (d.add 168#64) 64 = H[5])
    (h6 : m.readAt (d.add 176#64) 64 = H[6]) (h7 : m.readAt (d.add 184#64) 64 = H[7]) :
    m.readSha512 (d.add 128#64) = H := by
  simp only [MemoryState.readSha512, Pointer.add_add, BitVec.reduceAdd, h0, h1, h2, h3, h4, h5, h6,
    h7]
  ext i hi
  rcases i with _ | _ | _ | _ | _ | _ | _ | _ | i <;>
    first
    | rfl
    | omega

/-- The state words at `d + 128` stored, read back. -/
public theorem words_after {S : GlobalState} {a : AllocState} {m : MemoryState} {d : Pointer}
    {v : Vector (BitVec 64) 8} (hS : S = ⟨a, m.storeSha512 (d.add 128#64) v⟩)
    (h : Room S.mem d 1664) (hdo : d.offset.toNat + 208 < 2 ^ 64) :
    S.mem.readSha512 (d.add 128#64) = v := by
  subst hS
  have hso : (d.add 128#64).offset.toNat + 56 < 2 ^ 64 := by
    simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]; omega
  refine MemoryState.readSha512_storeSha512_self hso ?_
  have :=
    (Room.add_of_le (off := 128#64) (w := 512)
        (by
          simp [BitVec.uaddOverflow]; omega)
        (by decide) (Room.storeSha512_iff.1 h))
  exact this

/-- The state words at `d + 128` fit, from their eight words'. -/
public theorem sha_fit {m : MemoryState} {d : Pointer}
    (hso : (d.add 128#64).offset.toNat + 56 < 2 ^ 64) (h0 : Fits m (d.add 128#64) 64)
    (h1 : Fits m (d.add 136#64) 64) (h2 : Fits m (d.add 144#64) 64) (h3 : Fits m (d.add 152#64) 64)
    (h4 : Fits m (d.add 160#64) 64) (h5 : Fits m (d.add 168#64) 64) (h6 : Fits m (d.add 176#64) 64)
    (h7 : Fits m (d.add 184#64) 64) : m.Sha512Fit (d.add 128#64) :=
  ⟨hso, h0, by simpa using h1, by simpa using h2, by simpa using h3, by simpa using h4, by
    simpa using h5, by simpa using h6, by simpa using h7⟩

/-- `<Sha512VarCore as VariableOutputCore>::finalize_variable_core(core, buffer, out)` on sha2's
`Sha512` at `d` (buffer at `d`, its position in `d + 127`, core at `d + 128`): the padded last
block(s) compressed into the state words (`state`), the position reset, the words stored
big-endian at `out` (`outBits`). The buffer's `pos < 128` first bytes are known; `out` is in
another block. Its four buffers count four blocks. -/
public theorem call_eq (d out : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals Sha512VarCore_VariableOutputCore_finalize_variable_core.globals)
    (hd : Room s.mem d 1664)
    (hdo : d.offset.toNat + 208 < 2 ^ 64) (hpos : Fits s.mem (d.add 127#64) 8)
    (hP128 : (s.mem.readAt (d.add 127#64) 8).toNat < 128)
    (hbuf : Fits s.mem d (8 * (s.mem.readAt (d.add 127#64) 8).toNat))
    (hst : s.mem.Sha512Fit (d.add 128#64)) (hbl : Fits s.mem (d.add 192#64) 128)
    (hout : Room s.mem out 512) (hoo : ¬out.offset.uaddOverflow 64#64) (hsep : out.id ≠ d.id) :
    Sha512VarCore_VariableOutputCore_finalize_variable_core.call
        (args (.value (d.add 128#64)) (.value d) (.value out)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 4⟩,
            mem :=
              ((s.mem.storeSha512 (d.add 128#64) (state s.mem d)).storeAt (d.add 127#64)
                    0#8).storeAt
                out (outBits (state s.mem d)) }) := by
  simp only [state]
  generalize hP : s.mem.readAt (d.add 127#64) 8 = P at hP128 hbuf ⊢
  generalize hD : s.mem.readAt d (8 * P.toNat) = D
  generalize hC : s.mem.readAt (d.add 192#64) 128 = C
  generalize hH : s.mem.readSha512 (d.add 128#64) = H
  obtain ⟨hw0, hw1, hw2, hw3, hw4, hw5, hw6, hw7⟩ := sha_words hH
  obtain ⟨hso, h0, h1, h2, h3, h4, h5, h6, h7⟩ := hst
  simp only [Pointer.add_add, BitVec.reduceAdd] at h1 h2 h3 h4 h5 h6 h7
  func_init
  block_init
  iterate 6 step_pure
  step_addressof anon_042b818bc72209407b52bd0e4d6c8368_43 with loc
  have hck0 := hS.symm
  clear hS
  rename' S => S₁
  iterate 4 step_pure
  step_alloca with b344
  step_alloca with b345
  step_alloca with b346
  step_alloca with block
  step_pure
  step_load
  step_pure
  step_assume [pos_slt hP128]
  step_pure [pos_msb hP128]
  step_pure
  step_load with block_len
  step_pure
  step_pure [shl3_nuw, shl3_nsw]
  step_pure [len_disjoint _ hP128] with transparent bit_len
  step_pure with transparent len_be
  step_memset
  step_pure [pos_msb hP128]
  step_call using (copy_pos hP128)
  step_pure
  have hroom_pos : Room S.mem (block.add (P.setWidth 64)) 8 :=
    Room.add_of_le
      (by
        simp [BitVec.uaddOverflow, hblock_off]; omega)
      (by
        simp; omega)
      hblock_room
  step_store
  step_pure
  step_pure
  have hP64 : (P.setWidth 64).toNat = P.toNat := by
    simp; omega
  rw [MemoryState.storeAt_storeAt_low (by omega) D,
    MemoryState.storeAt_storeAt_add
      (by
        simp [BitVec.uaddOverflow, hblock_off]; omega)
      (by omega) 128#8,
    hP64, ← padBlock] at hS
  have hread_blk : S.mem.readAt block 1024 = padBlock P D :=
    readBack hS (hfits_block.room hblock_room.writable)
  finish_block
  case isFalse =>
    have htwo : twoBlocks P = false := by simpa [twoBlocks] using hbr
    block_init
    step_pure
    step_store
    rw [MemoryState.storeAt_storeAt_add (off := 112#64) (by simp [BitVec.uaddOverflow, hblock_off])
        (by decide)] at hS
    step_pure
    step_memcpy
    step_call using
      (compress_one (hst := sha_fit hso h0 h1 h2 h3 h4 h5 h6 h7) (hH :=
        sha_of_words hw0 hw1 hw2 hw3 hw4 hw5 hw6 hw7) (hBr := hread_b344)) consuming
      hw0 hw1 hw2 hw3 hw4 hw5 hw6 hw7
    have hH1 := words_after hS hd hdo
    obtain ⟨hw0, hw1, hw2, hw3, hw4, hw5, hw6, hw7⟩ := sha_words hH1
    clear hH1
    step_pure
    finish_block
    rw [tail_eq d out S E hwf hArgs (by env_reads) hdo (hpos.room (by mem_fact))
        (sha_fit hso h0 h1 h2 h3 h4 h5 h6 h7) hout hoo hsep
        (sha_of_words hw0 hw1 hw2 hw3 hw4 hw5 hw6 hw7)]
    subst hS hck0
    simp only [PoisonOr.value_bind]
    erase_frame
    simp only [spec, htwo]
    rfl
  case isTrue =>
    have htwo : twoBlocks P = true := by simpa [twoBlocks] using hbr
    block_init
    step_pure
    step_memcpy
    step_call using
      (compress_one (hst := sha_fit hso h0 h1 h2 h3 h4 h5 h6 h7) (hH :=
        sha_of_words hw0 hw1 hw2 hw3 hw4 hw5 hw6 hw7) (hBr := hread_b346)) consuming
      hw0 hw1 hw2 hw3 hw4 hw5 hw6 hw7
    have hH1 := words_after hS hd hdo
    obtain ⟨hw0, hw1, hw2, hw3, hw4, hw5, hw6, hw7⟩ := sha_words hH1
    clear hH1
    step_pure
    replace hS := restore hS hfits_block hread_blk
    step_memset
    rw [MemoryState.storeAt_storeAt_low (by decide) 0#896] at hS
    step_pure
    step_store
    rw [MemoryState.storeAt_storeAt_add (off := 112#64) (by simp [BitVec.uaddOverflow, hblock_off])
        (by decide)] at hS
    step_pure
    step_memcpy
    step_call using
      (compress_one (hst := sha_fit hso h0 h1 h2 h3 h4 h5 h6 h7) (hH :=
        sha_of_words hw0 hw1 hw2 hw3 hw4 hw5 hw6 hw7) (hBr := hread_b345)) consuming
      hw0 hw1 hw2 hw3 hw4 hw5 hw6 hw7
    have hH2 := words_after hS hd hdo
    obtain ⟨hw0, hw1, hw2, hw3, hw4, hw5, hw6, hw7⟩ := sha_words hH2
    clear hH2
    step_pure
    finish_block
    rw [tail_eq d out S E hwf hArgs (by env_reads) hdo (hpos.room (by mem_fact))
        (sha_fit hso h0 h1 h2 h3 h4 h5 h6 h7) hout hoo hsep
        (sha_of_words hw0 hw1 hw2 hw3 hw4 hw5 hw6 hw7)]
    subst hS hck0
    simp only [PoisonOr.value_bind]
    erase_frame
    simp only [storeSha512_storeSha512 hso, spec, htwo]
    rfl

end Proof

/-! ## Meaning -/

section Meaning

/-- A byte-aligned splice's bytes: the bytes before, the spliced value's, the bytes after. -/
theorem bytesLE_spliceBits {n w : Nat} (X : BitVec n) (o : Nat) (y : BitVec w) (ho : o % 8 = 0)
    (hw : w % 8 = 0) (h : o + w ≤ n) :
    bytesLE (Memory.spliceBits X o y) =
      (bytesLE X).take (o / 8) ++ bytesLE y ++ (bytesLE X).drop ((o + w) / 8) := by
  apply List.ext_getElem
  · simp only [length_bytesLE, List.length_append, List.length_take, List.length_drop]; omega
  · intro i h1 h2
    simp only [length_bytesLE] at h1
    rw [getElem_bytesLE]
    by_cases hi : i < o / 8
    · rw [List.getElem_append_left
          (by
            simp; omega),
        List.getElem_append_left
          (by
            simp; omega),
        List.getElem_take, getElem_bytesLE,
        Memory.extractLsb'_spliceBits_of_disjoint _ _ _ _ (Or.inl (by omega))]
    · by_cases hi' : i < (o + w) / 8
      · rw [List.getElem_append_left
            (by
              simp; omega),
          List.getElem_append_right
            (by
              simp; omega),
          getElem_bytesLE,
          Memory.extractLsb'_spliceBits_of_subrange _ _ _ _ (by omega) (by omega) h]
        congr 1
        simp only [List.length_take, length_bytesLE]
        omega
      · rw [List.getElem_append_right
            (by
              simp; omega),
          List.getElem_drop, getElem_bytesLE,
          Memory.extractLsb'_spliceBits_of_disjoint _ _ _ _ (Or.inr (by omega))]
        congr 1
        simp only [List.length_append, List.length_take, length_bytesLE]
        omega

/-- Zero bits' bytes are zeros. -/
theorem bytesLE_zero (n : Nat) : bytesLE (0#n) = List.replicate (n / 8) 0#8 := by
  apply List.ext_getElem
  · simp
  · intro i h1 h2
    rw [getElem_bytesLE, List.getElem_replicate]
    simp

/-- Byte `k` of `bswap128 x` is byte `15 - k` of `x`. -/
theorem bswap128_byte (x : BitVec 128) (k : Fin 16) :
    (bswap128 x).extractLsb' (8 * k) 8 = x.extractLsb' (8 * (15 - k)) 8 := by
  fin_cases k <;> simp only [bswap128, List.range, List.range.loop, List.foldl] <;> bv_decide

/-- `bswap128`'s bytes, lowest first, are `x`'s big-endian. -/
theorem bytesLE_bswap128 (x : BitVec 128) : bytesLE (bswap128 x) = Sha512.bytesBE x := by
  apply List.ext_getElem
  · simp [Sha512.bytesBE]
  · intro i h1 h2
    simp only [length_bytesLE] at h1
    simp only [Sha512.bytesBE, List.getElem_reverse]
    rw [getElem_bytesLE, getElem_bytesLE, bswap128_byte x ⟨i, h1⟩]
    simp only [length_bytesLE]

/-- Byte `k` of `bswap64 x` is byte `7 - k` of `x`. -/
theorem bswap64_byte (x : BitVec 64) (k : Fin 8) :
    (compress512.bswap64 x).extractLsb' (8 * k) 8 = x.extractLsb' (8 * (7 - k)) 8 := by
  fin_cases k <;> simp only [compress512.bswap64, List.range, List.range.loop, List.foldl] <;>
    bv_decide

/-- `bswap64`'s bytes, lowest first, are `x`'s big-endian. -/
theorem bytesLE_bswap64 (x : BitVec 64) : bytesLE (compress512.bswap64 x) = Sha512.bytesBE x := by
  apply List.ext_getElem
  · simp [Sha512.bytesBE]
  · intro i h1 h2
    simp only [length_bytesLE] at h1
    simp only [Sha512.bytesBE, List.getElem_reverse]
    rw [getElem_bytesLE, getElem_bytesLE, bswap64_byte x ⟨i, h1⟩]
    simp only [length_bytesLE]

/-- `bitLen` of `q` blocks and `pos` bytes: `8 (128 q + pos)` bits. -/
theorem bitLen_eq {q : Nat} {P : BitVec 8} (h : P.toNat < 128) :
    bitLen (BitVec.ofNat 128 q) P = BitVec.ofNat 128 (8 * (128 * q + P.toNat)) := by
  rw [bitLen, ← BitVec.add_eq_or_of_and_eq_zero _ _ (len_disjoint _ h)]
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_add, BitVec.toNat_shiftLeft, BitVec.toNat_ofNat, BitVec.toNat_setWidth,
    Nat.shiftLeft_eq]
  omega

/-- `twoBlocks`: the position is at least `112`. -/
public theorem twoBlocks_iff {P : BitVec 8} (h : P.toNat < 128) :
    twoBlocks P = decide (112 ≤ P.toNat) := by
  have : P < 128#8 := by
    simp [BitVec.lt_def]; omega
  have e : twoBlocks P = decide (112#8 ≤ P) := by
    rw [twoBlocks]
    bv_decide
  rw [e, Bool.eq_iff_iff, decide_eq_true_iff, decide_eq_true_iff, BitVec.le_def]
  rfl

/-- `padBlock`'s bytes: the buffered bytes, `0x80`, zeros to 128. -/
theorem padBlock_bytes {P : BitVec 8} (D : BitVec (8 * P.toNat)) (h : P.toNat < 128) :
    bytesLE (padBlock P D) = bytesLE D ++ [128#8] ++ List.replicate (127 - P.toNat) 0#8 := by
  rw [padBlock, bytesLE_spliceBits _ _ _ (by omega) (by decide) (by omega),
    bytesLE_spliceBits _ _ _ (by decide) (by omega) (by omega), bytesLE_zero]
  have hD : (bytesLE D).length = P.toNat := by simp
  have h8 : bytesLE (128#8) = [128#8] := rfl
  rw [show (0 + 8 * P.toNat) / 8 = P.toNat by omega, show P.toNat * 8 / 8 = P.toNat by omega,
    show (P.toNat * 8 + 8) / 8 = (bytesLE D).length + 1 by omega, List.take_zero, List.nil_append,
    List.drop_replicate, List.take_left' hD, List.drop_append, h8, List.drop_replicate,
    List.drop_eq_nil_of_le (by omega), List.nil_append]
  congr 2
  omega

/-- Eight words as a list. -/
theorem toList_eight (V : Vector (BitVec 64) 8) :
    V.toList = [V[0], V[1], V[2], V[3], V[4], V[5], V[6], V[7]] := by
  obtain ⟨⟨l⟩, h⟩ := V
  match l, h with
  | [_, _, _, _, _, _, _, _], _ => rfl

/-- `outBits`'s bytes: each word big-endian, word `0` first. -/
theorem outBits_bytes (V : Vector (BitVec 64) 8) :
    bytesLE (outBits V) = V.toList.flatMap Sha512.bytesBE := by
  simp (disch := decide) only [outBits, bytesLE_append, bytesLE_bswap64, toList_eight,
    List.flatMap_cons, List.flatMap_nil, List.append_nil, List.append_assoc]

/-- The whole blocks of `M`, then the rest of `M` and `X`. -/
theorem compressBlocks_split (H : Vector (BitVec 64) 8) (M X : List (BitVec 8)) :
    Sha512.compressBlocks H (M ++ X) =
      Sha512.compressBlocks (Sha512.compressBlocks H M) (M.drop (M.length / 128 * 128) ++ X) := by
  have hA : (M.take (M.length / 128 * 128)).length % 128 = 0 := by
    simp; omega
  conv_lhs => rw [← List.take_append_drop (M.length / 128 * 128) M]
  rw [List.append_assoc, Sha512.compressBlocks_append _ hA, ← Sha512.compressBlocks_take M]

/-- The second block: zeros, then the length. -/
theorem lastBlock_bytes (X : BitVec 1024) (y : BitVec 128) :
    bytesLE (Memory.spliceBits (Memory.spliceBits X 0 0#896) 896 y) =
      List.replicate 112 0#8 ++ bytesLE y := by
  rw [bytesLE_spliceBits _ _ _ (by decide) (by decide) (by decide),
    bytesLE_spliceBits _ _ _ (by decide) (by decide) (by decide), bytesLE_zero]
  simp only [List.take_zero, List.nil_append, Nat.reduceDiv]
  rw [List.take_left' (by simp), List.drop_eq_nil_of_le (by simp), List.append_nil]

/-- The one block: the buffer, `0x80`, zeros, the length. -/
theorem oneBlock_bytes {P : BitVec 8} (D : BitVec (8 * P.toNat)) (y : BitVec 128)
    (h : P.toNat < 112) :
    bytesLE (Memory.spliceBits (padBlock P D) 896 y) =
      bytesLE D ++ [128#8] ++ List.replicate (111 - P.toNat) 0#8 ++ bytesLE y := by
  rw [bytesLE_spliceBits _ _ _ (by decide) (by decide) (by decide), padBlock_bytes D (by omega)]
  have hD : (bytesLE D).length = P.toNat := by simp
  rw [List.drop_eq_nil_of_le
      (by
        simp; omega),
    List.append_nil]
  simp only [Nat.reduceDiv, List.take_append, hD, List.length_singleton, List.take_replicate,
    List.length_append]
  rw [List.take_of_length_le (l := bytesLE D) (by omega),
    List.take_of_length_le (l := [128#8])
      (by
        simp; omega),
    show min (112 - (P.toNat + 1)) (127 - P.toNat) = 111 - P.toNat by omega]

/-- `spec` on what sha2's `Sha512` holds after absorbing `M`: the hash of `pad M`. -/
theorem spec_eq {M : List (BitVec 8)} {P : BitVec 8} (D : BitVec (8 * P.toNat))
    (hP : P.toNat = M.length % 128) (hD : bytesLE D = M.drop (M.length / 128 * 128)) :
    spec (Sha512.compressBlocks Sha512.IV M) (BitVec.ofNat 128 (M.length / 128)) P D =
      Sha512.compressBlocks Sha512.IV (Sha512.pad M) := by
  have hP128 : P.toNat < 128 := by omega
  have hlen :
    bytesLE (bswap128 (bitLen (BitVec.ofNat 128 (M.length / 128)) P)) =
      Sha512.bytesBE (BitVec.ofNat 128 (8 * M.length)) := by
    rw [bitLen_eq hP128, show 128 * (M.length / 128) + P.toNat = M.length by omega,
      bytesLE_bswap128]
  have hb1 : (bytesLE (padBlock P D)).length % 128 = 0 := by simp
  unfold Sha512.pad
  rw [List.append_assoc, List.append_assoc, compressBlocks_split, ← hD]
  simp only [spec, twoBlocks_iff hP128, compress512.spec]
  by_cases h112 : 112 ≤ P.toNat
  · simp only [h112, decide_true, ↓reduceIte]
    rw [lastBlock_bytes, hlen, ← Sha512.compressBlocks_append _ hb1, padBlock_bytes D hP128,
      show (239 - M.length % 128) % 128 = (127 - P.toNat) + 112 by omega, List.replicate_add]
    simp only [List.append_assoc]
  · simp only [h112, decide_false, Bool.false_eq_true, ↓reduceIte]
    rw [oneBlock_bytes D _ (by omega), hlen,
      show (239 - M.length % 128) % 128 = 111 - P.toNat by omega]
    simp only [List.append_assoc]

end Meaning

/-- The digest's words packed as `call_eq` stores them: their bytes are the digest. -/
public theorem bytesLE_outBits_pad (M : List (BitVec 8)) :
    bytesLE (outBits (Sha512.compressBlocks Sha512.IV (Sha512.pad M))) = Sha512.digest M := by
  rw [outBits_bytes, Sha512.digest]

/-- `state` of sha2's `Sha512` having absorbed `M`: the hash of `pad M`. -/
public theorem state_eq {m : MemoryState} {d : Pointer} {M : List (BitVec 8)}
    (h : m.Sha2Absorbed d M) : state m d = Sha512.compressBlocks Sha512.IV (Sha512.pad M) := by
  have hD :
    bytesLE (m.readAt d (8 * (m.readAt (d.add 127#64) 8).toNat)) =
      M.drop (M.length / 128 * 128) := by
    rw [h.pos]
    exact h.buf
  rw [state, h.state, h.count, spec_eq _ h.pos hD]

/-- `finalize_variable_core` against SHA-512: when sha2's `Sha512` at `d` has absorbed `M`, the 64
bytes `call_eq` stores at `out` are `digest M`. -/
public theorem digest_eq {m : MemoryState} {d : Pointer} {M : List (BitVec 8)}
    (h : m.Sha2Absorbed d M) : bytesLE (outBits (state m d)) = Sha512.digest M := by
  rw [state_eq h, bytesLE_outBits_pad]

/-- `call_eq` on sha2's `Sha512` at `d` having absorbed `M`: the state words become SHA-512's of
`pad M`, and `out` holds them big-endian, the bytes `digest M` (`bytesLE_outBits_pad`). -/
public theorem call_eq_absorbed (d out : Pointer) (M : List (BitVec 8)) (s : GlobalState)
    (hwf : s.WF)
    (hg : s.mem.Globals Sha512VarCore_VariableOutputCore_finalize_variable_core.globals)
    (hA : s.mem.Sha2Absorbed d M) (hout : Room s.mem out 512)
    (hoo : ¬out.offset.uaddOverflow 64#64) (hsep : out.id ≠ d.id) :
    Sha512VarCore_VariableOutputCore_finalize_variable_core.call
        (args (.value (d.add 128#64)) (.value d) (.value out)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 4⟩,
            mem :=
              ((s.mem.storeSha512 (d.add 128#64)
                        (Sha512.compressBlocks Sha512.IV (Sha512.pad M))).storeAt
                    (d.add 127#64) 0#8).storeAt
                out (outBits (Sha512.compressBlocks Sha512.IV (Sha512.pad M))) }) := by
  have hP := hA.pos
  rw [call_eq d out s hwf hg hA.room hA.off hA.posFits (by omega)
      (by
        rw [hP]; exact hA.bufFits)
      hA.stateFit hA.countFits hout hoo hsep,
    state_eq hA]

end Sha512VarCore_VariableOutputCore_finalize_variable_core

end MLIR.Agave.Serial
