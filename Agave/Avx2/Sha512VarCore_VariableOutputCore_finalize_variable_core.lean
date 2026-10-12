module

public import MLIR.Run.Tactic
public import Agave.Common.Sha512
public import Agave.Avx2.compress512
public import Agave.Serial.Sha512VarCore_VariableOutputCore_finalize_variable_core
public import Agave.Serial.copy_from_slice_impl_u8
public import Agave.Avx2.Mlir.Sha512VarCore_VariableOutputCore_finalize_variable_core
import Firedancer.Common.Memory
import Std.Data.ExtHashMap.Lemmas
import Mathlib.Tactic.Rename
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Avx2

open _root_.Ed25519

/-! ## Specification -/

@[expose] public section

namespace Sha512VarCore_VariableOutputCore_finalize_variable_core

open Serial.Sha512VarCore_VariableOutputCore_finalize_variable_core (twoBlocks)

/-- The blocks `finalize_variable_core` allocates: the panic location, the padding block, four per
`compress512`. -/
def frames (P : BitVec 8) : Nat :=
  if twoBlocks P then 10 else 6

/-- `frames` after absorbing `M`: a second padding block when the `M.length % 128` buffered bytes
leave no room for the length. -/
def framesOf (M : List (BitVec 8)) : Nat :=
  if 112 ≤ M.length % 128 then 10 else 6

end Sha512VarCore_VariableOutputCore_finalize_variable_core

end

/-! ## Proof -/

namespace Sha512VarCore_VariableOutputCore_finalize_variable_core

open Serial.Sha512VarCore_VariableOutputCore_finalize_variable_core (outBits bitLen bswap128
  padBlock twoBlocks spec state state_eq)

section Proof

set_option hygiene false in
/-- `^bb2`: the length stored, the last block compressed, the position reset, the words stored
big-endian at `out`. -/
local macro "last_block" : tactic =>
  `(tactic|
    ( block_init
      step_pure
      step_pure [pos_msb hP128]
      step_pure [shl3_nuw, shl3_nsw]
      step_pure [len_disjoint _ hP128] with transparent bit_len
      step_pure with transparent len_be
      step_pure
      step_store
      rw [storeAt_storeAt_add (off := 112#64) (by simp [BitVec.uaddOverflow, hblock_off])
          (by decide)] at hS
      have hread_b : S.mem.readAt block 1024 = _ := readBack hS hfits_block.inBounds
      step_call using
        (compress_one (hst := sha_fit hso h0 h1 h2 h3 h4 h5 h6 h7) (hH :=
          sha_of_words hw0 hw1 hw2 hw3 hw4 hw5 hw6 hw7) (hBr := hread_b) (hne := ?_)) consuming
        hw0 hw1 hw2 hw3 hw4 hw5 hw6 hw7
      have hH1 := words_after hS hd hdo
      obtain ⟨hw0, hw1, hw2, hw3, hw4, hw5, hw6, hw7⟩ := sha_words hH1
      clear hH1
      step_store
      have hf0 := fits_quad hdo 128 (by decide) h0 h1 h2 h3
      have hf1 := fits_quad hdo 160 (by decide) h4 h5 h6 h7
      have e0 := readAt_quad hdo 128 (by decide) hw0 hw1 hw2 hw3
      have e1 := readAt_quad hdo 160 (by decide) hw4 hw5 hw6 hw7
      step_load
      step_pure
      step_store
      step_pure
      step_pure
      step_load
      step_pure
      step_store
      finish_block))

/-- `copy_from_slice` of the buffer's `pos` bytes into the padding block. -/
theorem copy_pos {P : BitVec 8} (hP : P.toNat < 128) (dst src loc : Pointer) (s : GlobalState)
    (hwf : s.WF) (hdst : Room s.mem dst 1024) (hsrc : Fits s.mem src (8 * P.toNat))
    (hsep : dst.id ≠ src.id) :
    Serial.copy_from_slice_impl_u8.call
        (Serial.copy_from_slice_impl_u8.args (.value dst) (.value (P.setWidth 64)) (.value src)
          (.value (P.setWidth 64)) (.value loc))
        s =
      .value (.nil, { s with mem := s.mem.storeAt dst (s.mem.readAt src (8 * P.toNat)) }) := by
  have hP64 : (P.setWidth 64).toNat = P.toNat := by
    simp; omega
  have h :=
    Serial.copy_from_slice_impl_u8.call_eq dst src loc (P.setWidth 64) s hwf (hdst.mono (by omega))
      (hP64 ▸ hsrc) hsep
  rwa [hP64] at h

/-- The buffer's length is non-negative. -/
theorem pos_msb {pos : BitVec 8} (h : pos.toNat < 128) : pos.msb = false := by
  have : pos < 128#8 := by
    simp [BitVec.lt_def]; omega
  bv_decide

/-- `(pos as u128) << 3` loses no bits. -/
theorem shl3_nuw (P : BitVec 8) : P.setWidth 128 <<< 3 >>> 3 = P.setWidth 128 := by bv_decide

/-- `(pos as u128) << 3` keeps its sign. -/
theorem shl3_nsw (P : BitVec 8) : (P.setWidth 128 <<< 3).sshiftRight 3 = P.setWidth 128 := by
  bv_decide

/-- The block count's bits and the buffer's, shifted to bits, do not meet. -/
theorem len_disjoint (C : BitVec 128) {P : BitVec 8} (h : P.toNat < 128) :
    C <<< 10 &&& P.setWidth 128 <<< 3 = 0#128 := by
  have : P < 128#8 := by
    simp [BitVec.lt_def]; omega
  bv_decide

/-- `assume(pos > -1)` holds. -/
theorem pos_slt {pos : BitVec 8} (h : pos.toNat < 128) : (255#8).slt pos = true := by
  have : pos < 128#8 := by
    simp [BitVec.lt_def]; omega
  bv_decide

/-- A store right after another: one store of both. -/
theorem storeAt_storeAt_concat {m : MemoryState} {p : Pointer} {off : BitVec 64} {x : BitVec v}
    {y : BitVec w} (hov : ¬p.offset.uaddOverflow off) (hoff : off.toNat * 8 = v) :
    (m.storeAt p x).storeAt (p.add off) y = m.storeAt p (y ++ x) := by
  simp only [MemoryState.storeAt, Pointer.add_id, MemoryState.modifyBlock_modifyBlock_self]
  congr 1
  funext blk
  simp only [Function.comp_apply, Pointer.offsetInBits_add hov, hoff, MemoryBlock.mk.injEq,
    true_and, and_true]
  refine ⟨heq_of_eq ?_, heq_of_eq ?_⟩ <;> apply BitVec.eq_of_getLsbD_eq <;> intro i hi <;>
    simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_append, BitVec.getLsbD_allOnes]
  · grind
  · split <;> split <;> (try split) <;> (try simp only [decide_eq_decide]) <;> omega

/-- A splice into a splice that covers it: one splice of the inner value. -/
theorem spliceBits_spliceBits_add {n wx wy : Nat} (b : BitVec n) (o k : Nat) (x : BitVec wx)
    (y : BitVec wy) (h : k + wy ≤ wx) :
    Memory.spliceBits (Memory.spliceBits b o x) (o + k) y =
      Memory.spliceBits b o (Memory.spliceBits x k y) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [Memory.getLsbD_spliceBits]
  grind

/-- A store inside a stored value: one store, the inner value spliced. -/
theorem storeAt_storeAt_add {m : MemoryState} {p : Pointer} {u : BitVec wu} {off : BitVec 64}
    (hov : ¬p.offset.uaddOverflow off) (hw : off.toNat * 8 + wy ≤ wu) (y : BitVec wy) :
    (m.storeAt p u).storeAt (p.add off) y =
      m.storeAt p (Memory.spliceBits u (off.toNat * 8) y) := by
  have hones :
    Memory.spliceBits (BitVec.allOnes wu) (off.toNat * 8) (BitVec.allOnes wy) =
      BitVec.allOnes wu := by
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_allOnes]
    grind
  simp only [MemoryState.storeAt, Pointer.add_id, MemoryState.modifyBlock_modifyBlock_self]
  congr 1
  funext blk
  simp only [Function.comp_apply, Pointer.offsetInBits_add hov,
    spliceBits_spliceBits_add _ _ _ _ _ hw, hones]

/-- A store at a stored value's start: one store, the inner value spliced. -/
theorem storeAt_storeAt_low {m : MemoryState} {p : Pointer} {u : BitVec wu} (hw : wy ≤ wu)
    (y : BitVec wy) : (m.storeAt p u).storeAt p y = m.storeAt p (Memory.spliceBits u 0 y) := by
  have h :=
    storeAt_storeAt_add (m := m) (p := p) (u := u) (off := 0#64)
      (by
        simp [BitVec.uaddOverflow]; exact p.offset.isLt)
      (by simpa using hw) y
  rwa [Pointer.add_zero] at h

open Memory in
/-- Storing the known bits a range holds changes nothing. -/
theorem storeAt_readAt_self {m : MemoryState} (h : Fits m p w) :
    m.storeAt p (m.readAt p w) = m := by
  obtain ⟨blk, hblk, -, hsz, hd⟩ := h
  have hb : m.mem[p.id]? = some blk := hblk
  unfold MemoryBlock.lengthInBits at hsz
  simp only [MemoryState.storeAt, MemoryState.readAt, hblk, MemoryState.modifyBlock]
  refine MemoryState.ext ?_ rfl
  apply Std.ExtHashMap.ext_getElem?
  intro k
  simp only [Std.ExtHashMap.getElem?_modify, beq_iff_eq]
  split
  · subst_vars
    rw [hb]
    simp only [Option.map_some, Option.some.injEq]
    cases blk
    simp only [MemoryBlock.mk.injEq, true_and, and_true] at hsz hd ⊢
    refine ⟨heq_of_eq ?_, heq_of_eq ?_⟩ <;> apply BitVec.eq_of_getLsbD_eq <;> intro i hi <;>
      rw [getLsbD_spliceBits]
    · rw [BitVec.getLsbD_extractLsb']
      split
      · have h1 : p.offsetInBits + (i - p.offsetInBits) = i := by omega
        have h2 : i - p.offsetInBits < w := by omega
        simp [h1, h2]
      · rfl
    · split
      · have := congrArg (·.getLsbD (i - p.offsetInBits)) hd
        have h1 : p.offsetInBits + (i - p.offsetInBits) = i := by omega
        simp only [BitVec.getLsbD_extractLsb', BitVec.getLsbD_allOnes] at this
        have h2 : i - p.offsetInBits < w := by omega
        simp_all
      · rfl
  · rfl

/-- A state's memory with a known range: the same memory, the range's bits stored again. -/
theorem restore {S : GlobalState} {a : AllocState} {m : MemoryState} {p : Pointer} {X : BitVec w}
    (hS : S = ⟨a, m⟩) (hf : Fits S.mem p w) (hr : S.mem.readAt p w = X) :
    S = ⟨a, m.storeAt p X⟩ := by
  subst hS
  rw [← hr, storeAt_readAt_self hf]

/-- A state's memory after a store, read back there. -/
theorem readBack {S : GlobalState} {a : AllocState} {m : MemoryState} {p : Pointer} {X : BitVec w}
    (hS : S = ⟨a, m.storeAt p X⟩) (h : InBounds S.mem p w) : S.mem.readAt p w = X := by
  subst hS
  exact MemoryState.readAt_storeAt_self (InBounds.storeAt_iff.1 h) _

/-- A store right before another: one store of both. -/
theorem storeAt_storeAt_below {m : MemoryState} {p : Pointer} {off : BitVec 64} {x : BitVec v}
    {y : BitVec w} (hov : ¬p.offset.uaddOverflow off) (hoff : off.toNat * 8 = v) :
    (m.storeAt (p.add off) y).storeAt p x = m.storeAt p (y ++ x) := by
  simp only [MemoryState.storeAt, Pointer.add_id, MemoryState.modifyBlock_modifyBlock_self]
  congr 1
  funext blk
  simp only [Function.comp_apply, Pointer.offsetInBits_add hov, hoff, MemoryBlock.mk.injEq,
    true_and, and_true]
  refine ⟨heq_of_eq ?_, heq_of_eq ?_⟩ <;> apply BitVec.eq_of_getLsbD_eq <;> intro i hi <;>
    simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_append, BitVec.getLsbD_allOnes]
  · grind
  · split <;> split <;> (try split) <;> (try simp only [decide_eq_decide]) <;> omega

/-- `storeSha512` as one store of the eight words, word `0` lowest. -/
theorem storeSha512_eq {m : MemoryState} {p : Pointer} {v : Vector (BitVec 64) 8}
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
  rw [e 16 (by decide) (by decide), storeAt_storeAt_concat (hov 8 (by decide)) rfl,
    e 24 (by decide) (by decide), storeAt_storeAt_concat (hov 16 (by decide)) rfl,
    e 32 (by decide) (by decide), storeAt_storeAt_concat (hov 24 (by decide)) rfl,
    e 40 (by decide) (by decide), storeAt_storeAt_concat (hov 32 (by decide)) rfl,
    e 48 (by decide) (by decide), storeAt_storeAt_concat (hov 40 (by decide)) rfl,
    e 56 (by decide) (by decide), storeAt_storeAt_concat (hov 48 (by decide)) rfl,
    storeAt_storeAt_below
      (by
        simp [BitVec.uaddOverflow]; omega)
      rfl]

/-- A second `storeSha512` to the same words overwrites the first. -/
theorem storeSha512_storeSha512 {m : MemoryState} {p : Pointer} {v u : Vector (BitVec 64) 8}
    (hp : p.offset.toNat + 56 < 2 ^ 64) :
    (m.storeSha512 p v).storeSha512 p u = m.storeSha512 p u := by
  rw [storeSha512_eq hp, storeSha512_eq hp, storeSha512_eq hp, MemoryState.storeAt_storeAt_self]

/-- `d + k` steps by `j` bytes without wrapping, inside `d`'s 208 bytes. -/
theorem obj_noOverflow {d : Pointer} (hdo : d.offset.toNat + 208 < 2 ^ 64) (k j : Nat)
    (hk : k + j ≤ 208) : ¬(d.add (BitVec.ofNat 64 k)).offset.uaddOverflow (BitVec.ofNat 64 j) := by
  simp only [Pointer.add, BitVec.uaddOverflow, BitVec.toNat_add, BitVec.toNat_ofNat]
  rw [Nat.mod_eq_of_lt (show k < 2 ^ 64 by omega), Nat.mod_eq_of_lt (show j < 2 ^ 64 by omega),
    Nat.mod_eq_of_lt (by omega)]
  simp
  omega

/-- Two state words at `d + k`, `d + k + 8`: their 128 bits. -/
theorem fits_pair {m : MemoryState} {d : Pointer} (hdo : d.offset.toNat + 208 < 2 ^ 64) (k : Nat)
    (hk : k + 16 ≤ 208) (h₁ : Fits m (d.add (BitVec.ofNat 64 k)) 64)
    (h₂ : Fits m (d.add (BitVec.ofNat 64 (k + 8))) 64) : Fits m (d.add (BitVec.ofNat 64 k)) 128 :=
  Fits.append (off := 8#64) (obj_noOverflow hdo k 8 (by omega)) rfl rfl h₁
    (by rwa [Pointer.add_add, ← BitVec.ofNat_add])

/-- Four state words from `d + k`: their 256 bits. -/
theorem fits_quad {m : MemoryState} {d : Pointer} (hdo : d.offset.toNat + 208 < 2 ^ 64) (k : Nat)
    (hk : k + 32 ≤ 208) (h₁ : Fits m (d.add (BitVec.ofNat 64 k)) 64)
    (h₂ : Fits m (d.add (BitVec.ofNat 64 (k + 8))) 64)
    (h₃ : Fits m (d.add (BitVec.ofNat 64 (k + 16))) 64)
    (h₄ : Fits m (d.add (BitVec.ofNat 64 (k + 24))) 64) : Fits m (d.add (BitVec.ofNat 64 k)) 256 :=
  Fits.append (off := 16#64) (obj_noOverflow hdo k 16 (by omega)) rfl rfl
    (fits_pair hdo k (by omega) h₁ h₂)
    (by
      rw [Pointer.add_add, ← BitVec.ofNat_add]
      exact fits_pair hdo (k + 16) (by omega) h₃ h₄)

/-- The state words at `d + 128` as eight reads. -/
theorem sha_words {m : MemoryState} {d : Pointer} {H : Vector (BitVec 64) 8}
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
theorem sha_of_words {m : MemoryState} {d : Pointer} {H : Vector (BitVec 64) 8}
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
theorem words_after {S : GlobalState} {a : AllocState} {m : MemoryState} {d : Pointer}
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
        (by decide) (Room.storeSha512_iff.1 h)).inBounds
  exact this

/-- The state words at `d + 128` fit, from their eight words'. -/
theorem sha_fit {m : MemoryState} {d : Pointer} (hso : (d.add 128#64).offset.toNat + 56 < 2 ^ 64)
    (h0 : Fits m (d.add 128#64) 64) (h1 : Fits m (d.add 136#64) 64) (h2 : Fits m (d.add 144#64) 64)
    (h3 : Fits m (d.add 152#64) 64) (h4 : Fits m (d.add 160#64) 64) (h5 : Fits m (d.add 168#64) 64)
    (h6 : Fits m (d.add 176#64) 64) (h7 : Fits m (d.add 184#64) 64) : m.Sha512Fit (d.add 128#64) :=
  ⟨hso, h0, by simpa using h1, by simpa using h2, by simpa using h3, by simpa using h4, by
    simpa using h5, by simpa using h6, by simpa using h7⟩

/-- Four lanes packed: lane `3` highest. -/
theorem packLanes_four (v : Vector (BitVec 64) 4) :
    BitVec.packLanes v = v[3] ++ v[2] ++ (v[1] ++ v[0]) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have h := congrArg (·.getLsbD (i % 64)) (BitVec.extractLsb'_packLanes v (i / 64) (by omega))
  simp only [BitVec.getLsbD_extractLsb', Nat.mod_lt _ (by decide : 0 < 64), decide_true,
    Bool.true_and] at h
  rw [show i / 64 * 64 + i % 64 = i by omega] at h
  rw [h]
  simp only [BitVec.getLsbD_append]
  rcases (by omega : i < 64 ∨ (64 ≤ i ∧ i < 128) ∨ (128 ≤ i ∧ i < 192) ∨ 192 ≤ i) with h | h | h | h
  · simp [h, show i / 64 = 0 by omega, Nat.mod_eq_of_lt h, show i < 128 by omega]
  · simp [show i / 64 = 1 by omega, show i < 128 by omega, show ¬i < 64 by omega,
      show i % 64 = i - 64 by omega]
  · simp [show i / 64 = 2 by omega, show ¬i < 128 by omega, show i - 128 < 64 by omega,
      show i % 64 = i - 128 by omega]
  · simp [show i / 64 = 3 by omega, show ¬i < 128 by omega, show ¬i - 128 < 64 by omega,
      show i % 64 = i - 128 - 64 by omega]

/-- A `<4 x i64>` byte-swapped per lane and packed: the four words swapped. -/
theorem quad_eq (a b c e : BitVec 64) :
    BitVec.packLanes
        (Vector.ofFn fun i =>
          List.foldl
            (fun acc j =>
              acc |||
                (Ty.extractVecElem 4 64 i (e ++ c ++ (b ++ a)) >>> (8 * j) &&& 255#64) <<<
                  (64 - 8 * (j + 1)))
            (0#64) (List.range 8)) =
      Serial.compress512.bswap64 e ++ Serial.compress512.bswap64 c ++
        (Serial.compress512.bswap64 b ++ Serial.compress512.bswap64 a) := by
  rw [packLanes_four]
  simp only [Vector.getElem_ofFn, Ty.extractVecElem_eq, Serial.compress512.bswap64, List.range,
    List.range.loop, List.foldl]
  bv_decide

/-- Four words from `d + k`: their 256 bits, the first lowest. -/
theorem readAt_quad {m : MemoryState} {d : Pointer} (hdo : d.offset.toNat + 208 < 2 ^ 64) (k : Nat)
    (hk : k + 32 ≤ 208) {a b c e : BitVec 64} (h₁ : m.readAt (d.add (BitVec.ofNat 64 k)) 64 = a)
    (h₂ : m.readAt (d.add (BitVec.ofNat 64 (k + 8))) 64 = b)
    (h₃ : m.readAt (d.add (BitVec.ofNat 64 (k + 16))) 64 = c)
    (h₄ : m.readAt (d.add (BitVec.ofNat 64 (k + 24))) 64 = e) :
    m.readAt (d.add (BitVec.ofNat 64 k)) 256 = e ++ c ++ (b ++ a) := by
  rw [MemoryState.readAt_append (w := 128) (v := 128) (obj_noOverflow hdo k 16 (by omega)) rfl,
    MemoryState.readAt_append (w := 64) (v := 64) (obj_noOverflow hdo k 8 (by omega)) rfl,
    Pointer.add_add, ← BitVec.ofNat_add,
    MemoryState.readAt_append (w := 64) (v := 64) (obj_noOverflow hdo (k + 16) 8 (by omega)) rfl]
  simp only [Pointer.add_add, ← BitVec.ofNat_add]
  rw [h₁, h₂, h₃, show k + 16 + 8 = k + 24 by omega, h₄]

/-- `outBits` as the two 256-bit halves the code stores. -/
theorem outBits_eq (H : Vector (BitVec 64) 8) :
    outBits H =
      Serial.compress512.bswap64 H[7] ++ Serial.compress512.bswap64 H[6] ++
        (Serial.compress512.bswap64 H[5] ++ Serial.compress512.bswap64 H[4]) ++
        (Serial.compress512.bswap64 H[3] ++ Serial.compress512.bswap64 H[2] ++
          (Serial.compress512.bswap64 H[1] ++ Serial.compress512.bswap64 H[0])) := by
  simp only [outBits]
  generalize Serial.compress512.bswap64 H[0] = x0
  generalize Serial.compress512.bswap64 H[1] = x1
  generalize Serial.compress512.bswap64 H[2] = x2
  generalize Serial.compress512.bswap64 H[3] = x3
  generalize Serial.compress512.bswap64 H[4] = x4
  generalize Serial.compress512.bswap64 H[5] = x5
  generalize Serial.compress512.bswap64 H[6] = x6
  generalize Serial.compress512.bswap64 H[7] = x7
  bv_decide

/-- The second half of `out`'s 64 bytes does not wrap. -/
theorem hov32 {out : Pointer} (hoo : ¬out.offset.uaddOverflow 64#64) :
    ¬out.offset.uaddOverflow 32#64 := by
  simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq, Nat.not_le] at hoo ⊢
  omega

/-- `compress512` of one block at `blk` (in its own slot) into the state words `H` at `st`. -/
theorem compress_one (st blk : Pointer) (s : GlobalState) (hwf : s.WF) (hst : s.mem.Sha512Fit st)
    (hB : Fits s.mem blk 1024) (hbo : blk.offset = 0) (hne : st.id ≠ blk.id)
    {H : Vector (BitVec 64) 8} {B : BitVec 1024} (hH : s.mem.readSha512 st = H)
    (hBr : s.mem.readAt blk 1024 = B) :
    compress512.call (compress512.args (.value st) (.value blk) (.value 1#64)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 4⟩,
            mem := s.mem.storeSha512 st (Serial.compress512.spec H (bytesLE B)) }) := by
  have hBr' : s.mem.readAt blk (1024 * (1#64).toNat) = B := hBr
  rw [compress512.call_eq st blk 1#64 s hwf hst (by decide) hB (by simp [hbo])
      (Range.disjoint_of_id_ne hne),
    hH, hBr']

/-- `<Sha512VarCore as VariableOutputCore>::finalize_variable_core(core, buffer, out)` on sha2's
`Sha512` at `d` (buffer at `d`, its position in `d + 127`, core at `d + 128`): the padded last
block(s) compressed into the state words (`state`), the position reset, the words stored
big-endian at `out` (`outBits`). The buffer's `pos < 128` first bytes are known; `out` is in
another block. -/
public theorem call_eq (d out : Pointer) (s : GlobalState) (hwf : s.WF) (hd : Room s.mem d 1664)
    (hdo : d.offset.toNat + 208 < 2 ^ 64) (hpos : Fits s.mem (d.add 127#64) 8)
    (hP128 : (s.mem.readAt (d.add 127#64) 8).toNat < 128)
    (hbuf : Fits s.mem d (8 * (s.mem.readAt (d.add 127#64) 8).toNat))
    (hst : s.mem.Sha512Fit (d.add 128#64)) (hbl : Fits s.mem (d.add 192#64) 128)
    (hout : Room s.mem out 512) (hoo : ¬out.offset.uaddOverflow 64#64) (hsep : out.id ≠ d.id) :
    Sha512VarCore_VariableOutputCore_finalize_variable_core.call
        (args (.value (d.add 128#64)) (.value d) (.value out)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + frames (s.mem.readAt (d.add 127#64) 8)⟩,
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
  iterate 4 step_pure
  step_addressof anon_e79fcfe266c5706188f989b4d452749f_44 with loc
  have hck0 := hS.symm
  clear hS
  rename' S => S₁
  iterate 6 step_pure
  step_alloca with block
  step_pure
  step_load
  step_pure
  step_assume [pos_slt hP128]
  step_pure
  step_load with block_len
  step_memset
  step_pure [pos_msb hP128]
  step_call using (copy_pos hP128)
  have hroom_pos : Room S.mem (block.add (P.setWidth 64)) 8 :=
    Room.add_of_le
      (by
        simp [BitVec.uaddOverflow, hblock_off]; omega)
      (by
        simp; omega)
      hblock_room
  step_pure
  step_store
  step_pure
  step_pure
  have hP64 : (P.setWidth 64).toNat = P.toNat := by
    simp; omega
  rw [storeAt_storeAt_low (by omega) D,
    storeAt_storeAt_add
      (by
        simp [BitVec.uaddOverflow, hblock_off]; omega)
      (by omega) 128#8,
    hP64, ← padBlock] at hS
  have hread_blk : S.mem.readAt block 1024 = padBlock P D := readBack hS hfits_block.inBounds
  finish_block
  case isFalse =>
    have htwo : twoBlocks P = false := by simpa [twoBlocks] using hbr
    last_block
    subst hS hck0
    erase_frame
    rw [quad_eq, quad_eq, storeAt_storeAt_concat (hov32 hoo) rfl]
    simp only [spec, frames, htwo, outBits_eq]
    rfl
  case isTrue =>
    have htwo : twoBlocks P = true := by simpa [twoBlocks] using hbr
    block_init
    step_call using
      (compress_one (hst := sha_fit hso h0 h1 h2 h3 h4 h5 h6 h7) (hH :=
        sha_of_words hw0 hw1 hw2 hw3 hw4 hw5 hw6 hw7) (hBr := hread_blk) (hne := ?_)) consuming
      hw0 hw1 hw2 hw3 hw4 hw5 hw6 hw7
    have hH1 := words_after hS hd hdo
    obtain ⟨hw0, hw1, hw2, hw3, hw4, hw5, hw6, hw7⟩ := sha_words hH1
    clear hH1
    replace hS := restore hS hfits_block hread_blk
    step_memset
    rw [storeAt_storeAt_low (by decide) 0#896] at hS
    finish_block
    last_block
    subst hS hck0
    erase_frame
    rw [quad_eq, quad_eq, storeAt_storeAt_concat (hov32 hoo) rfl]
    simp only [storeSha512_storeSha512 hso, spec, frames, htwo, outBits_eq]
    rfl

end Proof

/-- `twoBlocks`: the position is at least `112`. -/
theorem twoBlocks_iff {P : BitVec 8} (h : P.toNat < 128) :
    twoBlocks P = decide (112 ≤ P.toNat) := by
  have : P < 128#8 := by
    simp [BitVec.lt_def]; omega
  have e : twoBlocks P = decide (112#8 ≤ P) := by
    rw [twoBlocks]
    bv_decide
  rw [e, Bool.eq_iff_iff, decide_eq_true_iff, decide_eq_true_iff, BitVec.le_def]
  rfl

/-- `frames` of sha2's `Sha512` having absorbed `M`. -/
public theorem frames_eq {m : MemoryState} {d : Pointer} {M : List (BitVec 8)}
    (h : m.Sha2Absorbed d M) : frames (m.readAt (d.add 127#64) 8) = framesOf M := by
  have hP := h.pos
  rw [frames, framesOf, twoBlocks_iff (by omega), hP]
  by_cases h112 : 112 ≤ M.length % 128 <;> simp [h112]

/-- `call_eq` on sha2's `Sha512` at `d` having absorbed `M`: the state words become SHA-512's of
`pad M`, and `out` holds them big-endian, the bytes `digest M` (`bytesLE_outBits_pad`). -/
public theorem call_eq_absorbed (d out : Pointer) (M : List (BitVec 8)) (s : GlobalState)
    (hwf : s.WF) (hA : s.mem.Sha2Absorbed d M) (hout : Room s.mem out 512)
    (hoo : ¬out.offset.uaddOverflow 64#64) (hsep : out.id ≠ d.id) :
    Sha512VarCore_VariableOutputCore_finalize_variable_core.call
        (args (.value (d.add 128#64)) (.value d) (.value out)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + framesOf M⟩,
            mem :=
              ((s.mem.storeSha512 (d.add 128#64)
                        (Sha512.compressBlocks Sha512.IV (Sha512.pad M))).storeAt
                    (d.add 127#64) 0#8).storeAt
                out (outBits (Sha512.compressBlocks Sha512.IV (Sha512.pad M))) }) := by
  have hP := hA.pos
  rw [call_eq d out s hwf hA.room hA.off hA.posFits (by omega)
      (by
        rw [hP]; exact hA.bufFits)
      hA.stateFit hA.countFits hout hoo hsep,
    state_eq hA, frames_eq hA]

end Sha512VarCore_VariableOutputCore_finalize_variable_core

end MLIR.Agave.Avx2
