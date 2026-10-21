module

public import MLIR.Run.Tactic
public import Boringssl.Common.Sha512
public import Sodium.Common.Memory
import Std.Data.ExtHashMap.Lemmas
import Std.Tactic.BVDecide

/-! `crypto_hash_sha512_state` in memory: `state[8]`, `count[2]` and `buf[128]` at byte offsets 0,
64 and 80, stored as one masked store of its 208 bytes, `buf`'s bits defined as they were written. -/

namespace MLIR

open Memory

@[expose] public section

namespace Sodium

/-- A `crypto_hash_sha512_state`'s fields, and which bits of `buf` are defined. `count[0]` holds
the high 64 bits of the message's bit length, `count[1]` the low ones. -/
structure HashState where
  state : Vector (BitVec 64) 8
  count0 : BitVec 64
  count1 : BitVec 64
  buf : BitVec 1024
  bufDef : BitVec 1024

namespace HashState

/-- The struct's first 80 bytes, its fields but `buf`, least significant first. -/
def low (v : HashState) : BitVec 640 :=
  v.count1 ++ v.count0 ++ v.state[7] ++ v.state[6] ++ v.state[5] ++ v.state[4] ++ v.state[3] ++
    v.state[2] ++
    v.state[1] ++
    v.state[0]

/-- The struct's 208 bytes, least significant first. -/
def bits (v : HashState) : BitVec 1664 :=
  v.buf ++ v.low

/-- Which of the struct's bits are defined: all but `buf`'s undefined ones. -/
def defs (v : HashState) : BitVec 1664 :=
  v.bufDef ++ BitVec.allOnes 640

/-- The struct of 208 bytes `x`, defined where `d` is set. -/
def ofBits (x d : BitVec 1664) : HashState :=
  ⟨#v[x.extractLsb' 0 64, x.extractLsb' 64 64, x.extractLsb' 128 64, x.extractLsb' 192 64,
      x.extractLsb' 256 64, x.extractLsb' 320 64, x.extractLsb' 384 64, x.extractLsb' 448 64],
    x.extractLsb' 512 64, x.extractLsb' 576 64, x.extractLsb' 640 1024, d.extractLsb' 640 1024⟩

/-- The first `k` bytes of `buf` are known. -/
def Prefix (v : HashState) (k : Nat) : Prop :=
  v.bufDef.extractLsb' 0 (8 * k) = BitVec.allOnes (8 * k)

/-- Bytes `x` written into `buf`, `off` bytes in, their bits defined. -/
def fill (v : HashState) (off : BitVec 64) (x : BitVec w) : HashState :=
  { v with
    buf := Firedancer.Ref.fd_sha512_append.copy v.buf off x
    bufDef := Firedancer.Ref.fd_sha512_append.copy v.bufDef off (BitVec.allOnes w) }

end HashState

end Sodium

open Sodium

/-- The `crypto_hash_sha512_state` at `c`. -/
def MemoryState.readHashState (m : MemoryState) (c : Pointer) : HashState :=
  HashState.ofBits (m.readAt c 1664) (m.definedAt c 1664)

/-- Store a `crypto_hash_sha512_state` at `c`, `buf` defined where `bufDef` says. -/
def MemoryState.storeHashState (m : MemoryState) (c : Pointer) (v : HashState) : MemoryState :=
  m.overlay c v.bits v.defs

/-- Room for the struct at `c`, its fields but `buf` known, and its offsets do not wrap. -/
abbrev MemoryState.HashStateFit (m : MemoryState) (c : Pointer) : Prop :=
  ¬c.offset.uaddOverflow 208#64 ∧ Room m c 1664 ∧ Fits m c 640

attribute [mlir_mem] MemoryState.HashStateFit

namespace Sodium.HashState

theorem ofBits_bits_defs (v : HashState) : ofBits v.bits v.defs = v := by
  obtain ⟨⟨⟨l⟩, hl⟩, count0, count1, buf, bufDef⟩ := v
  match l, hl with
  | [h0, h1, h2, h3, h4, h5, h6, h7],
    _ =>
    simp only [ofBits, bits, low, defs, HashState.mk.injEq, Vector.getElem_mk, List.getElem_toArray,
      List.getElem_cons_zero, List.getElem_cons_succ]
    refine ⟨?_, ?_, ?_, ?_, ?_⟩
    · congr 2
      bv_decide
    all_goals bv_decide

@[simp]
theorem fill_state (v : HashState) (off : BitVec 64) (x : BitVec w) :
    (v.fill off x).state = v.state :=
  rfl

@[simp]
theorem fill_count0 (v : HashState) (off : BitVec 64) (x : BitVec w) :
    (v.fill off x).count0 = v.count0 :=
  rfl

@[simp]
theorem fill_count1 (v : HashState) (off : BitVec 64) (x : BitVec w) :
    (v.fill off x).count1 = v.count1 :=
  rfl

theorem bits_fill (v : HashState) (off : BitVec 64) (x : BitVec w) :
    (v.fill off x).bits = Firedancer.Ref.fd_sha512_append.copy v.buf off x ++ v.low :=
  rfl

theorem defs_fill (v : HashState) (off : BitVec 64) (x : BitVec w) :
    (v.fill off x).defs =
      Firedancer.Ref.fd_sha512_append.copy v.bufDef off (BitVec.allOnes w) ++ BitVec.allOnes 640 :=
  rfl

theorem prefix_zero (v : HashState) : v.Prefix 0 := by simp [Prefix]

/-- A fill right after the known bytes extends them. -/
theorem Prefix.fill {v : HashState} (h : v.Prefix k) {off : BitVec 64} (hoff : off.toNat = k)
    (x : BitVec w) (hw : w = 8 * j) (hkj : k + j ≤ 128) : (v.fill off x).Prefix (k + j) := by
  unfold Prefix at h ⊢
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have := congrArg (·.getLsbD i) h
  simp only [BitVec.getLsbD_extractLsb', BitVec.getLsbD_allOnes, Nat.zero_add] at this
  simp only [BitVec.getLsbD_extractLsb', BitVec.getLsbD_allOnes, Nat.zero_add, hi, decide_true,
    Bool.true_and, HashState.fill, Firedancer.Ref.fd_sha512_append.copy, getLsbD_spliceBits, hoff]
  split
  · simp only [decide_eq_true_eq]
    omega
  · have hik : i < 8 * k := by omega
    simpa [hik] using this

/-- A prefix of a prefix. -/
theorem Prefix.mono {v : HashState} (h : v.Prefix k) (hjk : j ≤ k) : v.Prefix j := by
  unfold Prefix at h ⊢
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have := congrArg (·.getLsbD i) h
  simp only [BitVec.getLsbD_extractLsb', BitVec.getLsbD_allOnes, Nat.zero_add,
    show i < 8 * k by omega, decide_true, Bool.true_and] at this
  simp [hi, this]

/-- Two adjacent runs of `D`'s bytes copied into `buf`: one run. -/
theorem fill_fill_extract (v : HashState) {n : Nat} (D : BitVec n) {a i k c : Nat}
    (ha : a + k + c ≤ 128) :
    (v.fill (BitVec.ofNat 64 a) (D.extractLsb' (8 * i) (8 * k))).fill (BitVec.ofNat 64 (a + k))
        (D.extractLsb' (8 * (i + k)) (8 * c)) =
      v.fill (BitVec.ofNat 64 a) (D.extractLsb' (8 * i) (8 * (k + c))) := by
  have h1 : (BitVec.ofNat 64 a).toNat = a := by
    simp; omega
  have h2 : (BitVec.ofNat 64 (a + k)).toNat = a + k := by
    simp; omega
  simp only [fill, Firedancer.Ref.fd_sha512_append.copy, h1, h2, HashState.mk.injEq, true_and]
  constructor <;> apply BitVec.eq_of_getLsbD_eq <;> intro j hj <;>
    simp only [getLsbD_spliceBits, BitVec.getLsbD_extractLsb', BitVec.getLsbD_allOnes] <;>
    split_ifs <;>
    first
    | omega
    | ( rw [decide_eq_true (show j - (a + k) * 8 < 8 * c by omega),
          decide_eq_true (show j - a * 8 < 8 * (k + c) by omega), Bool.true_and, Bool.true_and]
        congr 1
        omega)
    |
      (rw [decide_eq_true (show j - a * 8 < 8 * k by omega),
          decide_eq_true (show j - a * 8 < 8 * (k + c) by omega)])
    | (simp only [decide_eq_decide]; omega)
    | simp_all

@[simp]
theorem low_count0 (v : HashState) : v.low.extractLsb' 512 64 = v.count0 := by
  simp only [low]; bv_decide

@[simp]
theorem low_count1 (v : HashState) : v.low.extractLsb' 576 64 = v.count1 := by
  simp only [low]; bv_decide

end Sodium.HashState

/-! ### Reads and stores of the struct -/

theorem Pointer.not_uaddOverflow_of_hashState {c : Pointer} (h : ¬c.offset.uaddOverflow 208#64)
    {off : BitVec 64} (hoff : off.toNat ≤ 208) : ¬c.offset.uaddOverflow off :=
  BitVec.not_uaddOverflow_of_le h (by simpa using hoff)

/-- The struct's 208 bytes do not wrap. -/
theorem Pointer.offset_lt_of_hashState {c : Pointer} (h : ¬c.offset.uaddOverflow 208#64) :
    c.offset.toNat + 208 < 2 ^ 64 := by
  simp [BitVec.uaddOverflow] at h
  omega

/-- Byte `k ≤ 208` of the struct, its offset. -/
theorem Pointer.offset_add_of_hashState {c : Pointer} (h : ¬c.offset.uaddOverflow 208#64) {k : Nat}
    (hk : k ≤ 208) : (c.add (BitVec.ofNat 64 k)).offset.toNat = c.offset.toNat + k := by
  have := Pointer.offset_lt_of_hashState h
  simp only [Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
  omega

section Struct

variable {m : MemoryState} {c : Pointer} {v : HashState}

/-- A store inside the struct: the struct with the bits spliced in, defined. -/
theorem MemoryState.storeHashState_storeAt {v' : HashState} {off : BitVec 64} {x : BitVec w}
    (hc : ¬c.offset.uaddOverflow 208#64) (hw : off.toNat * 8 + w ≤ 1664)
    (hv : spliceBits v.bits (off.toNat * 8) x = v'.bits)
    (hd : spliceBits v.defs (off.toNat * 8) (BitVec.allOnes w) = v'.defs) :
    (m.storeHashState c v).storeAt (c.add off) x = m.storeHashState c v' := by
  rw [MemoryState.storeHashState,
    MemoryState.overlay_storeAt_add (Pointer.not_uaddOverflow_of_hashState hc (by omega)) hw, hv,
    hd]
  rfl

/-- A read inside the struct: its bits. -/
theorem MemoryState.readAt_storeHashState {off : BitVec 64} (hm : Room m c 1664)
    (hc : ¬c.offset.uaddOverflow 208#64) (hw : off.toNat * 8 + w ≤ 1664) :
    (m.storeHashState c v).readAt (c.add off) w = v.bits.extractLsb' (off.toNat * 8) w :=
  MemoryState.readAt_overlay_add hm (Pointer.not_uaddOverflow_of_hashState hc (by omega)) hw _ _

theorem MemoryState.readHashState_storeHashState_self (hm : Room m c 1664) :
    (m.storeHashState c v).readHashState c = v := by
  rw [MemoryState.readHashState, MemoryState.storeHashState, MemoryState.readAt_overlay_self hm,
    MemoryState.definedAt_overlay_self hm, HashState.ofBits_bits_defs]

/-- Storing the struct that is there changes nothing. -/
theorem MemoryState.storeHashState_readHashState_self (h : m.HashStateFit c) :
    m.storeHashState c (m.readHashState c) = m := by
  have hd : (m.definedAt c 1664).extractLsb' 0 640 = BitVec.allOnes 640 := by
    obtain ⟨blk, hblk, -, -, hdef⟩ := h.2.2
    simp only [MemoryState.definedAt, hblk,
      BitVec.extractLsb'_extractLsb'_add (by decide : 0 + 640 ≤ 1664), Nat.add_zero]
    exact hdef
  have hb : (m.readHashState c).bits = m.readAt c 1664 := by
    simp only [MemoryState.readHashState, HashState.ofBits, HashState.bits, HashState.low,
      Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero, List.getElem_cons_succ]
    generalize m.readAt c 1664 = x
    bv_decide
  have hdd : (m.readHashState c).defs = m.definedAt c 1664 := by
    simp only [MemoryState.readHashState, HashState.ofBits, HashState.defs]
    revert hd
    generalize m.definedAt c 1664 = x
    intro hd
    bv_decide
  rw [MemoryState.storeHashState, hb, hdd, MemoryState.overlay_readAt_definedAt h.2.1.inBounds]

/-- The state words of a stored struct. -/
theorem MemoryState.readWords8_storeHashState (hm : Room m c 1664)
    (hc : ¬c.offset.uaddOverflow 208#64) : (m.storeHashState c v).readWords8 c = v.state := by
  have e : (m.storeHashState c v).readAt c 64 = (m.storeHashState c v).readAt (c.add 0#64) 64 := by
    rw [Pointer.add_zero]
  rw [MemoryState.readWords8, e]
  simp (disch := decide) only [MemoryState.readAt_storeHashState hm hc]
  obtain ⟨⟨⟨l⟩, hl⟩, count0, count1, buf, bufDef⟩ := v
  match l, hl with
  | [h0, h1, h2, h3, h4, h5, h6, h7],
    _ =>
    simp only [HashState.bits, HashState.low, Vector.getElem_mk, List.getElem_toArray,
      List.getElem_cons_zero, List.getElem_cons_succ, BitVec.toNat_ofNat]
    congr 2
    simp only [List.cons.injEq, and_true]
    refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> bv_decide

/-- `buf` of a stored struct. -/
theorem MemoryState.readAt_storeHashState_buf (hm : Room m c 1664)
    (hc : ¬c.offset.uaddOverflow 208#64) :
    (m.storeHashState c v).readAt (c.add 80#64) 1024 = v.buf := by
  rw [MemoryState.readAt_storeHashState hm hc (by decide)]
  simp only [HashState.bits, HashState.low, BitVec.toNat_ofNat]
  bv_decide

/-- `buf`'s first `8 k` bits known, when `bufDef` says so. -/
theorem Fits.storeHashState_buf (hm : Room m c 1664) (hc : ¬c.offset.uaddOverflow 208#64)
    (hk : k ≤ 1024) (hd : v.bufDef.extractLsb' 0 k = BitVec.allOnes k) :
    Fits (m.storeHashState c v) (c.add 80#64) k := by
  have e : v.defs.extractLsb' 640 k = v.bufDef.extractLsb' 0 k := by
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp only [HashState.defs, BitVec.getLsbD_extractLsb', BitVec.getLsbD_append, hi, decide_true,
      Bool.true_and, Nat.zero_add]
    rw [ite_eq_right (by omega), Nat.add_sub_cancel_left]
  exact
    Fits.overlay_of_mask hm (Pointer.not_uaddOverflow_of_hashState hc (by decide))
      (by
        simp; omega)
      (e.trans hd)

/-! ### The fields -/

/-- A splice of a field into the struct's bits. -/
local macro "splice_bits" : tactic =>
  `(tactic|
    ( simp only [HashState.bits, HashState.low, HashState.defs, spliceBits_eq, BitVec.toNat_ofNat,
        reduceGetElemLit]
      bv_decide))

theorem MemoryState.storeHashState_storeAt_count0 (hc : ¬c.offset.uaddOverflow 208#64)
    {x : BitVec 64} :
    (m.storeHashState c v).storeAt (c.add 64#64) x = m.storeHashState c { v with count0 := x } :=
  MemoryState.storeHashState_storeAt hc (by decide) (by splice_bits) (by splice_bits)

theorem MemoryState.storeHashState_storeAt_count1 (hc : ¬c.offset.uaddOverflow 208#64)
    {x : BitVec 64} :
    (m.storeHashState c v).storeAt (c.add 72#64) x = m.storeHashState c { v with count1 := x } :=
  MemoryState.storeHashState_storeAt hc (by decide) (by splice_bits) (by splice_bits)

/-- Bytes stored into `buf`, at `c`'s byte `off ≥ 80`: `fill`. -/
theorem MemoryState.storeHashState_storeAt_buf (hc : ¬c.offset.uaddOverflow 208#64)
    {off : BitVec 64} {x : BitVec w} (h80 : 80 ≤ off.toNat) (hw : off.toNat * 8 + w ≤ 1664) :
    (m.storeHashState c v).storeAt (c.add off) x = m.storeHashState c (v.fill (off - 80#64) x) := by
  have hs : (off - 80#64).toNat = off.toNat - 80 :=
    BitVec.toNat_sub_of_le (by simpa [BitVec.le_def] using h80)
  refine MemoryState.storeHashState_storeAt hc hw ?_ ?_ <;>
    simp only [HashState.bits_fill, HashState.defs_fill] <;>
    apply BitVec.eq_of_getLsbD_eq <;>
    intro i hi <;>
    simp only [HashState.bits, HashState.defs, Firedancer.Ref.fd_sha512_append.copy,
      getLsbD_spliceBits, BitVec.getLsbD_append, hs, BitVec.getLsbD_allOnes] <;>
    split_ifs <;>
    first
    | omega
    | rw [show i - off.toNat * 8 = i - 640 - (off.toNat - 80) * 8 by omega]
    | rfl

/-- The state words stored over the struct. -/
theorem MemoryState.storeHashState_storeWords8 (hc : ¬c.offset.uaddOverflow 208#64)
    {w : Vector (BitVec 64) 8} :
    (m.storeHashState c v).storeWords8 c w = m.storeHashState c { v with state := w } := by
  have e (m' : MemoryState) (x : BitVec 64) : m'.storeAt c x = m'.storeAt (c.add 0#64) x := by
    rw [Pointer.add_zero]
  simp only [MemoryState.storeWords8, MemoryState.storeHashState, e]
  simp (disch :=
    first
    | decide
    |
      exact
        Pointer.not_uaddOverflow_of_hashState hc
          (by decide)) only [MemoryState.overlay_storeAt_add]
  congr 1 <;> splice_bits

/-- State word `i` of a stored struct. -/
theorem MemoryState.readAt_storeHashState_word (hm : Room m c 1664)
    (hc : ¬c.offset.uaddOverflow 208#64) {i : Nat} (hi : i < 8) :
    (m.storeHashState c v).readAt (c.add (BitVec.ofNat 64 (8 * i))) 64 = v.state[i]! := by
  rw [MemoryState.readAt_storeHashState hm hc
      (by
        simp; omega),
    getElem!_pos v.state i (by simpa using hi)]
  obtain ⟨⟨⟨l⟩, hl⟩, count0, count1, buf, bufDef⟩ := v
  match l, hl, i, hi with
  | [h0, h1, h2, h3, h4, h5, h6, h7], _, 0, _ | [h0, h1, h2, h3, h4, h5, h6, h7], _, 1, _ |
    [h0, h1, h2, h3, h4, h5, h6, h7], _, 2, _ | [h0, h1, h2, h3, h4, h5, h6, h7], _, 3, _ |
    [h0, h1, h2, h3, h4, h5, h6, h7], _, 4, _ | [h0, h1, h2, h3, h4, h5, h6, h7], _, 5, _ |
    [h0, h1, h2, h3, h4, h5, h6, h7], _, 6, _ | [h0, h1, h2, h3, h4, h5, h6, h7], _, 7,
    _ =>
    simp only [HashState.bits, HashState.low, Vector.getElem_mk, List.getElem_toArray,
      List.getElem_cons_zero, List.getElem_cons_succ, BitVec.toNat_ofNat]
    bv_decide

/-- The whole struct overwritten. -/
theorem MemoryState.storeHashState_storeAt_self {y : BitVec w} (hw : w = 1664) :
    (m.storeHashState c v).storeAt c y = m.storeAt c y := by
  subst hw
  simp only [MemoryState.storeHashState, MemoryState.storeAt, MemoryState.overlay,
    MemoryState.modifyBlock_modifyBlock_self, implies_true]
  congr 1
  funext blk
  simp only [Function.comp_apply, spliceBits_spliceBits_self]

/-- The struct's fields but `buf`, of a stored struct. -/
@[mlir_read]
theorem MemoryState.readAt_storeHashState_low (hm : Room m c 1664) :
    (m.storeHashState c v).readAt c 640 = v.low := by
  rw [MemoryState.storeHashState, MemoryState.readAt_overlay_le hm (by decide), HashState.bits]
  bv_decide

@[mlir_read]
theorem MemoryState.readAt_storeHashState_count0 (hm : Room m c 1664)
    (hc : ¬c.offset.uaddOverflow 208#64) :
    (m.storeHashState c v).readAt (c.add 64#64) 64 = v.count0 := by
  rw [MemoryState.readAt_storeHashState hm hc (by decide)]
  splice_bits

@[mlir_read]
theorem MemoryState.readAt_storeHashState_count1 (hm : Room m c 1664)
    (hc : ¬c.offset.uaddOverflow 208#64) :
    (m.storeHashState c v).readAt (c.add 72#64) 64 = v.count1 := by
  rw [MemoryState.readAt_storeHashState hm hc (by decide)]
  splice_bits

theorem MemoryState.readHashState_field (hm : InBounds m c 1664)
    (hc : ¬c.offset.uaddOverflow 208#64) {off : BitVec 64} (hw : off.toNat * 8 + w ≤ 1664) :
    (m.readAt c 1664).extractLsb' (off.toNat * 8) w = m.readAt (c.add off) w :=
  (MemoryState.readAt_add_of_readAt hm (Pointer.not_uaddOverflow_of_hashState hc (by omega)) hw
      rfl).symm

theorem MemoryState.readHashState_count0 (hm : InBounds m c 1664)
    (hc : ¬c.offset.uaddOverflow 208#64) : (m.readHashState c).count0 = m.readAt (c.add 64#64) 64 :=
  MemoryState.readHashState_field hm hc (off := 64#64) (by decide)

theorem MemoryState.readHashState_count1 (hm : InBounds m c 1664)
    (hc : ¬c.offset.uaddOverflow 208#64) : (m.readHashState c).count1 = m.readAt (c.add 72#64) 64 :=
  MemoryState.readHashState_field hm hc (off := 72#64) (by decide)

/-- A field stored over the struct at `c`: the struct with that field. -/
theorem MemoryState.storeAt_count1_eq (h : m.HashStateFit c) {x : BitVec 64} :
    m.storeAt (c.add 72#64) x = m.storeHashState c { m.readHashState c with count1 := x } := by
  conv_lhs => rw [← MemoryState.storeHashState_readHashState_self h]
  exact MemoryState.storeHashState_storeAt_count1 h.1

end Struct

/-! ### Facts carried past writes -/

section Transport

variable {m : MemoryState} {c : Pointer} {v : HashState}

/-- The state words of a struct that fits. -/
theorem MemoryState.HashStateFit.words8Fit (h : m.HashStateFit c) : m.Words8Fit c := by
  obtain ⟨ho, -, hf⟩ := h
  have hof : ∀ k : Nat, k ≤ 56 → ¬c.offset.uaddOverflow (BitVec.ofNat 64 k) := fun k hk =>
    Pointer.not_uaddOverflow_of_hashState ho
      (by
        simp; omega)
  refine
      ⟨by
        simp [BitVec.uaddOverflow] at ho; omega, hf.mono (by decide), ?_, ?_, ?_, ?_, ?_, ?_,
        ?_⟩ <;>
    exact Fits.add_of_le (hof _ (by decide)) (by decide) hf

@[mlir_mem, mlir_transport]
theorem MemoryState.HashStateFit.storeAt {x : BitVec w} (h : m.HashStateFit c) :
    (m.storeAt q x).HashStateFit c :=
  ⟨h.1, h.2.1.storeAt, h.2.2.storeAt⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.HashStateFit.storeWords8 (h : m.HashStateFit c) :
    (m.storeWords8 q w).HashStateFit c :=
  ⟨h.1, h.2.1.storeWords8, h.2.2.storeWords8⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.HashStateFit.storeWords (h : m.HashStateFit c) :
    (m.storeWords q f n).HashStateFit c :=
  ⟨h.1, h.2.1.storeWords, h.2.2.storeWords⟩

/-- The struct stored where there is room: its fields known. -/
@[mlir_fresh, mlir_mem]
theorem MemoryState.HashStateFit.storeHashState_self (h : Room m c 1664)
    (hco : ¬c.offset.uaddOverflow 208#64) : (m.storeHashState c v).HashStateFit c := by
  refine ⟨hco, Room.overlay h, Fits.overlay_of_mask_self h (by decide) ?_⟩
  simp only [HashState.defs]
  bv_decide

/-- Storing the struct keeps its fields known. -/
@[mlir_mem, mlir_transport]
theorem MemoryState.HashStateFit.storeHashState (h : m.HashStateFit c) :
    (m.storeHashState c v).HashStateFit c :=
  MemoryState.HashStateFit.storeHashState_self h.2.1 h.1

@[mlir_mem, mlir_transport]
theorem MemoryState.HashStateFit.alloca {s : GlobalState} (hwf : s.WF) (h : s.mem.HashStateFit c) :
    (s.alloca n d).mem.HashStateFit c :=
  ⟨h.1, h.2.1.alloca hwf, h.2.2.alloca hwf⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.HashStateFit.addBlock {s : GlobalState} {x : BitVec w} (hwf : s.WF)
    (h : s.mem.HashStateFit c) : (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).HashStateFit c :=
  ⟨h.1, h.2.1.addBlock hwf, h.2.2.addBlock hwf⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.HashStateFit.lifetimeStart (h : m.HashStateFit c) (hne : c.id ≠ q.id) :
    (m.lifetimeStart q).HashStateFit c :=
  ⟨h.1, h.2.1.lifetimeStart hne, h.2.2.lifetimeStart hne⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.HashStateFit.lifetimeEnd (h : m.HashStateFit c) (hne : c.id ≠ q.id) :
    (m.lifetimeEnd q).HashStateFit c :=
  ⟨h.1, h.2.1.lifetimeEnd hne, h.2.2.lifetimeEnd hne⟩

/-- Another block's known bits stay known. -/
@[mlir_transport]
theorem Fits.storeHashState (h : Fits m p w) (hne : p.id ≠ c.id) :
    Fits (m.storeHashState c v) p w :=
  Fits.overlay_of_disjoint h (Range.disjoint_of_id_ne hne.symm)

/-- `storeHashState` keeps every block, its length and lifetime. -/
@[simp]
theorem Room.storeHashState_iff : Room (m.storeHashState c v) p w ↔ Room m p w :=
  Room.overlay_iff

@[mlir_transport]
theorem Room.storeHashState (h : Room m p w) : Room (m.storeHashState c v) p w :=
  Room.overlay h

@[mlir_transport]
theorem InBounds.storeHashState (h : InBounds m p w) : InBounds (m.storeHashState c v) p w :=
  InBounds.overlay h

@[mlir_transport]
theorem GlobalState.WF.storeHashState {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storeHashState c v } : GlobalState).WF :=
  h.overlay

/-- `storeHashState` keeps the set of blocks, so `WF` does not depend on it. -/
@[simp, mlir_mem]
theorem GlobalState.WF_storeHashState {s : GlobalState} :
    ({ s with mem := m.storeHashState c v } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF :=
  GlobalState.WF_overlay

/-- `SHA512_Transform`'s result state: a block counted, `tmp64` and the state words stored. -/
@[mlir_transport]
theorem GlobalState.WF.add_blocks_storeAt_storeWords8 {s : GlobalState} {x : BitVec w}
    {u : Vector (BitVec 64) 8} (h : s.WF) :
    (⟨⟨s.alloc.nextFreeBlock + k⟩, (s.mem.storeAt p x).storeWords8 q u⟩ : GlobalState).WF :=
  GlobalState.WF.storeWords8 (s := ⟨_, s.mem.storeAt p x⟩)
    (GlobalState.WF.storeAt (s := ⟨⟨s.alloc.nextFreeBlock + k⟩, s.mem⟩) h.add_blocks)

/-- `SHA512_Transform`'s result state: `tmp64` and the state words stored. -/
@[mlir_transport]
theorem GlobalState.WF.storeAt_storeWords8 {s : GlobalState} {x : BitVec w}
    {u : Vector (BitVec 64) 8} (h : s.WF) :
    (⟨s.alloc, (s.mem.storeAt p x).storeWords8 q u⟩ : GlobalState).WF :=
  GlobalState.WF.storeWords8 (s := ⟨s.alloc, s.mem.storeAt p x⟩) (GlobalState.WF.storeAt h)

/-- `SHA512_Pad`'s result state: `tmp64` and the struct stored. -/
@[mlir_transport]
theorem GlobalState.WF.storeAt_storeHashState {s : GlobalState} {x : BitVec w} (h : s.WF) :
    (⟨s.alloc, (s.mem.storeAt p x).storeHashState c v⟩ : GlobalState).WF :=
  GlobalState.WF.storeHashState (s := ⟨s.alloc, s.mem.storeAt p x⟩) (GlobalState.WF.storeAt h)

/-- `SHA512_Pad`'s result state: blocks counted, `tmp64` and the struct stored. -/
@[mlir_transport]
theorem GlobalState.WF.add_blocks_storeAt_storeHashState {s : GlobalState} {x : BitVec w}
    (h : s.WF) :
    (⟨⟨s.alloc.nextFreeBlock + k⟩, (s.mem.storeAt p x).storeHashState c v⟩ : GlobalState).WF :=
  GlobalState.WF.storeHashState (s := ⟨_, s.mem.storeAt p x⟩)
    (GlobalState.WF.storeAt (s := ⟨⟨s.alloc.nextFreeBlock + k⟩, s.mem⟩) h.add_blocks)

/-- Reads in another block are unaffected by `storeHashState`. -/
@[mlir_read]
theorem MemoryState.readAt_storeHashState_of_id_ne (h : q.id ≠ c.id) :
    (m.storeHashState c v).readAt q w = m.readAt q w :=
  MemoryState.readAt_overlay_disjoint (Range.disjoint_of_id_ne h.symm) _ _

/-- The struct depends only on its block. -/
theorem MemoryState.readHashState_of_getElem?_eq {m' : MemoryState} (h : m'[c.id]? = m[c.id]?) :
    m'.readHashState c = m.readHashState c := by
  simp only [MemoryState.readHashState, MemoryState.readAt, MemoryState.definedAt, h]

/-- Erasing a frame commutes with storing the struct. -/
@[mlir_frame, mlir_erase]
theorem MemoryState.eraseFrom_storeHashState :
    (m.storeHashState c v).eraseFrom n = (m.eraseFrom n).storeHashState c v :=
  MemoryState.eraseFrom_overlay

/-- A store to another block commutes with storing the struct. -/
theorem MemoryState.storeHashState_storeAt_comm {x : BitVec w} (hne : q.id ≠ c.id) :
    (m.storeHashState c v).storeAt q x = (m.storeAt q x).storeHashState c v := by
  simp only [MemoryState.storeHashState, MemoryState.storeAt, MemoryState.overlay]
  exact MemoryState.modifyBlock_comm hne.symm

end Transport

end

end MLIR
