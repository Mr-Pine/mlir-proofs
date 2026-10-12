module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fd_sha512_append
public import Boringssl.Common.Memory
import Std.Data.ExtHashMap.Lemmas
import Std.Tactic.BVDecide

/-! `SHA512_CTX` (`sha512_state_st`) in memory: `h[8]`, `num`, `md_len`, `bytes_so_far_high`,
`bytes_so_far_low` and `p[128]` at byte offsets 0, 64, 66, 68, 72 and 80, stored as one masked
store of its 208 bytes, `p`'s bits defined as they were written. -/

namespace MLIR

open Memory

@[expose] public section

/-! ### Masked stores -/

/-- A store inside a masked store's range: one masked store, the new bits spliced in, defined. -/
theorem MemoryState.overlay_storeAt_add {m : MemoryState} {p : Pointer} {x d : BitVec v}
    {y : BitVec w} {off : BitVec 64} (hov : ¬p.offset.uaddOverflow off)
    (hw : off.toNat * 8 + w ≤ v) :
    (m.overlay p x d).storeAt (p.add off) y =
      m.overlay p (spliceBits x (off.toNat * 8) y)
        (spliceBits d (off.toNat * 8) (BitVec.allOnes w)) := by
  have ho : (p.add off).offset.toNat = p.offset.toNat + off.toNat := by
    simp only [Pointer.add, BitVec.toNat_add_of_not_uaddOverflow hov]
  simp only [MemoryState.storeAt, MemoryState.overlay, Pointer.add_id,
    MemoryState.modifyBlock_modifyBlock_self]
  congr 1
  funext blk
  simp only [Function.comp_apply, Pointer.offsetInBits, ho, MemoryBlock.mk.injEq, true_and,
    and_true]
  refine ⟨heq_of_eq ?_, heq_of_eq ?_⟩ <;> apply BitVec.eq_of_getLsbD_eq <;> intro i hi <;>
    simp only [getLsbD_spliceBits] <;>
    grind

/-! ### The struct -/

/-- A `SHA512_CTX`'s fields, and which bits of `p` are defined. -/
structure Sha512Ctx where
  h : Vector (BitVec 64) 8
  num : BitVec 16
  mdLen : BitVec 16
  hi : BitVec 32
  lo : BitVec 64
  p : BitVec 1024
  pDef : BitVec 1024

/-- The struct's first 80 bytes, its fields but `p`, least significant first. -/
def Sha512Ctx.low (v : Sha512Ctx) : BitVec 640 :=
  v.lo ++ v.hi ++ v.mdLen ++ v.num ++ v.h[7] ++ v.h[6] ++ v.h[5] ++ v.h[4] ++ v.h[3] ++ v.h[2] ++
    v.h[1] ++
    v.h[0]

/-- The struct's 208 bytes, least significant first. -/
def Sha512Ctx.bits (v : Sha512Ctx) : BitVec 1664 :=
  v.p ++ v.low

/-- Which of the struct's bits are defined: all but `p`'s undefined ones. -/
def Sha512Ctx.defs (v : Sha512Ctx) : BitVec 1664 :=
  v.pDef ++ BitVec.allOnes 640

/-- The struct of 208 bytes `x`, defined where `d` is set. -/
def Sha512Ctx.ofBits (x d : BitVec 1664) : Sha512Ctx :=
  ⟨#v[x.extractLsb' 0 64, x.extractLsb' 64 64, x.extractLsb' 128 64, x.extractLsb' 192 64,
      x.extractLsb' 256 64, x.extractLsb' 320 64, x.extractLsb' 384 64, x.extractLsb' 448 64],
    x.extractLsb' 512 16, x.extractLsb' 528 16, x.extractLsb' 544 32, x.extractLsb' 576 64,
    x.extractLsb' 640 1024, d.extractLsb' 640 1024⟩

/-- The first `k` bytes of `p` are known. -/
def Sha512Ctx.Prefix (v : Sha512Ctx) (k : Nat) : Prop :=
  v.pDef.extractLsb' 0 (8 * k) = BitVec.allOnes (8 * k)

/-- What the code keeps between calls: fewer than 128 bytes buffered, all of them known. -/
def Sha512Ctx.Valid (v : Sha512Ctx) : Prop :=
  v.num.toNat < 128 ∧ v.Prefix v.num.toNat

/-- The `SHA512_CTX` at `c`. -/
def MemoryState.readShaCtx (m : MemoryState) (c : Pointer) : Sha512Ctx :=
  Sha512Ctx.ofBits (m.readAt c 1664) (m.definedAt c 1664)

/-- Store a `SHA512_CTX` at `c`, `p` defined where `pDef` says. -/
def MemoryState.storeShaCtx (m : MemoryState) (c : Pointer) (v : Sha512Ctx) : MemoryState :=
  m.overlay c v.bits v.defs

/-- Room for the struct at `c`, its fields but `p` known, and its offsets do not wrap. -/
abbrev MemoryState.ShaCtxFit (m : MemoryState) (c : Pointer) : Prop :=
  ¬c.offset.uaddOverflow 208#64 ∧ Room m c 1664 ∧ Fits m c 640

attribute [mlir_mem] MemoryState.ShaCtxFit

theorem Sha512Ctx.ofBits_bits_defs (v : Sha512Ctx) : Sha512Ctx.ofBits v.bits v.defs = v := by
  obtain ⟨⟨⟨l⟩, hl⟩, num, mdLen, hi, lo, p, pDef⟩ := v
  match l, hl with
  | [h0, h1, h2, h3, h4, h5, h6, h7],
    _ =>
    simp only [Sha512Ctx.ofBits, Sha512Ctx.bits, Sha512Ctx.low, Sha512Ctx.defs, Sha512Ctx.mk.injEq,
      Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero, List.getElem_cons_succ]
    refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
    · congr 2
      bv_decide
    all_goals bv_decide

/-! ### Reads and stores of the struct -/

theorem Pointer.not_uaddOverflow_of_ctx {c : Pointer} (h : ¬c.offset.uaddOverflow 208#64)
    {off : BitVec 64} (hoff : off.toNat ≤ 208) : ¬c.offset.uaddOverflow off :=
  BitVec.not_uaddOverflow_of_le h (by simpa using hoff)

/-- A store inside the struct: the struct with the bits spliced in, defined. -/
theorem MemoryState.storeShaCtx_storeAt {m : MemoryState} {c : Pointer} {v v' : Sha512Ctx}
    {off : BitVec 64} {x : BitVec w} (hc : ¬c.offset.uaddOverflow 208#64)
    (hw : off.toNat * 8 + w ≤ 1664) (hv : spliceBits v.bits (off.toNat * 8) x = v'.bits)
    (hd : spliceBits v.defs (off.toNat * 8) (BitVec.allOnes w) = v'.defs) :
    (m.storeShaCtx c v).storeAt (c.add off) x = m.storeShaCtx c v' := by
  rw [MemoryState.storeShaCtx,
    MemoryState.overlay_storeAt_add (Pointer.not_uaddOverflow_of_ctx hc (by omega)) hw, hv, hd]
  rfl

/-- A read inside the struct: its bits. -/
theorem MemoryState.readAt_storeShaCtx {m : MemoryState} {c : Pointer} {v : Sha512Ctx}
    {off : BitVec 64} (hm : InBounds m c 1664) (hc : ¬c.offset.uaddOverflow 208#64)
    (hw : off.toNat * 8 + w ≤ 1664) :
    (m.storeShaCtx c v).readAt (c.add off) w = v.bits.extractLsb' (off.toNat * 8) w :=
  MemoryState.readAt_overlay_add hm (Pointer.not_uaddOverflow_of_ctx hc (by omega)) hw _ _

theorem MemoryState.readShaCtx_storeShaCtx_self {m : MemoryState} (hm : InBounds m c 1664) :
    (m.storeShaCtx c v).readShaCtx c = v := by
  rw [MemoryState.readShaCtx, MemoryState.storeShaCtx, MemoryState.readAt_overlay_self hm,
    MemoryState.definedAt_overlay_self hm, Sha512Ctx.ofBits_bits_defs]

/-- Storing the struct that is there changes nothing. -/
theorem MemoryState.storeShaCtx_readShaCtx_self {m : MemoryState} (h : m.ShaCtxFit c) :
    m.storeShaCtx c (m.readShaCtx c) = m := by
  have hd : (m.definedAt c 1664).extractLsb' 0 640 = BitVec.allOnes 640 := by
    obtain ⟨blk, hblk, -, -, hdef⟩ := h.2.2
    simp only [MemoryState.definedAt, hblk,
      BitVec.extractLsb'_extractLsb'_add (by decide : 0 + 640 ≤ 1664), Nat.add_zero]
    exact hdef
  have hb : (m.readShaCtx c).bits = m.readAt c 1664 := by
    simp only [MemoryState.readShaCtx, Sha512Ctx.ofBits, Sha512Ctx.bits, Sha512Ctx.low,
      Vector.getElem_mk, List.getElem_toArray, List.getElem_cons_zero, List.getElem_cons_succ]
    generalize m.readAt c 1664 = x
    bv_decide
  have hdd : (m.readShaCtx c).defs = m.definedAt c 1664 := by
    simp only [MemoryState.readShaCtx, Sha512Ctx.ofBits, Sha512Ctx.defs]
    revert hd
    generalize m.definedAt c 1664 = x
    intro hd
    bv_decide
  rw [MemoryState.storeShaCtx, hb, hdd, MemoryState.overlay_readAt_definedAt h.2.1.inBounds]

/-- The state words of a stored struct. -/
theorem MemoryState.readWords8_storeShaCtx {m : MemoryState} (hm : InBounds m c 1664)
    (hc : ¬c.offset.uaddOverflow 208#64) : (m.storeShaCtx c v).readWords8 c = v.h := by
  have e : (m.storeShaCtx c v).readAt c 64 = (m.storeShaCtx c v).readAt (c.add 0#64) 64 := by
    rw [Pointer.add_zero]
  rw [MemoryState.readWords8, e]
  simp (disch := decide) only [MemoryState.readAt_storeShaCtx hm hc]
  obtain ⟨⟨⟨l⟩, hl⟩, num, mdLen, hi, lo, p, pDef⟩ := v
  match l, hl with
  | [h0, h1, h2, h3, h4, h5, h6, h7],
    _ =>
    simp only [Sha512Ctx.bits, Sha512Ctx.low, Vector.getElem_mk, List.getElem_toArray,
      List.getElem_cons_zero, List.getElem_cons_succ, BitVec.toNat_ofNat]
    congr 2
    simp only [List.cons.injEq, and_true]
    refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> bv_decide

/-- `p` of a stored struct. -/
theorem MemoryState.readAt_storeShaCtx_p {m : MemoryState} (hm : InBounds m c 1664)
    (hc : ¬c.offset.uaddOverflow 208#64) : (m.storeShaCtx c v).readAt (c.add 80#64) 1024 = v.p := by
  rw [MemoryState.readAt_storeShaCtx hm hc (by decide)]
  simp only [Sha512Ctx.bits, Sha512Ctx.low, BitVec.toNat_ofNat]
  bv_decide

/-- `p`'s first `8 * k` bits known, when `pDef` says so. -/
theorem Fits.storeShaCtx_p {m : MemoryState} (hm : Room m c 1664)
    (hc : ¬c.offset.uaddOverflow 208#64) (hk : k ≤ 1024)
    (hd : v.pDef.extractLsb' 0 k = BitVec.allOnes k) :
    Fits (m.storeShaCtx c v) (c.add 80#64) k := by
  have e : v.defs.extractLsb' 640 k = v.pDef.extractLsb' 0 k := by
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp only [Sha512Ctx.defs, BitVec.getLsbD_extractLsb', BitVec.getLsbD_append, hi, decide_true,
      Bool.true_and, Nat.zero_add]
    rw [ite_eq_right (by omega), Nat.add_sub_cancel_left]
  exact
    Fits.overlay_of_mask hm (Pointer.not_uaddOverflow_of_ctx hc (by decide))
      (by
        simp; omega)
      (e.trans hd)

/-! ### The fields -/

/-- `spliceBits` as bit operations, for `bv_decide`. -/
theorem spliceBits_eq {n w : Nat} (b : BitVec n) (o : Nat) (x : BitVec w) :
    spliceBits b o x =
      (b &&& ~~~((BitVec.allOnes w).setWidth n <<< o)) ||| (x.setWidth n <<< o) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [getLsbD_spliceBits, BitVec.getLsbD_or, BitVec.getLsbD_and, BitVec.getLsbD_not,
    BitVec.getLsbD_shiftLeft, BitVec.getLsbD_setWidth, BitVec.getLsbD_allOnes]
  grind

/-- A splice of a field into the struct's bits. -/
local macro "splice_bits" : tactic =>
  `(tactic|
    ( simp only [Sha512Ctx.bits, Sha512Ctx.low, Sha512Ctx.defs, spliceBits_eq, BitVec.toNat_ofNat,
        reduceGetElemLit]
      bv_decide))

/-- Bytes `x` written into `p`, `off` bytes in, their bits defined. -/
def Sha512Ctx.fill (v : Sha512Ctx) (off : BitVec 64) (x : BitVec w) : Sha512Ctx :=
  { v with
    p := Firedancer.Ref.fd_sha512_append.copy v.p off x
    pDef := Firedancer.Ref.fd_sha512_append.copy v.pDef off (BitVec.allOnes w) }

@[simp]
theorem Sha512Ctx.fill_h (v : Sha512Ctx) (off : BitVec 64) (x : BitVec w) :
    (v.fill off x).h = v.h :=
  rfl

@[simp]
theorem Sha512Ctx.fill_num (v : Sha512Ctx) (off : BitVec 64) (x : BitVec w) :
    (v.fill off x).num = v.num :=
  rfl

@[simp]
theorem Sha512Ctx.fill_mdLen (v : Sha512Ctx) (off : BitVec 64) (x : BitVec w) :
    (v.fill off x).mdLen = v.mdLen :=
  rfl

@[simp]
theorem Sha512Ctx.fill_hi (v : Sha512Ctx) (off : BitVec 64) (x : BitVec w) :
    (v.fill off x).hi = v.hi :=
  rfl

@[simp]
theorem Sha512Ctx.fill_lo (v : Sha512Ctx) (off : BitVec 64) (x : BitVec w) :
    (v.fill off x).lo = v.lo :=
  rfl

theorem Sha512Ctx.bits_fill (v : Sha512Ctx) (off : BitVec 64) (x : BitVec w) :
    (v.fill off x).bits = Firedancer.Ref.fd_sha512_append.copy v.p off x ++ v.low :=
  rfl

theorem Sha512Ctx.defs_fill (v : Sha512Ctx) (off : BitVec 64) (x : BitVec w) :
    (v.fill off x).defs =
      Firedancer.Ref.fd_sha512_append.copy v.pDef off (BitVec.allOnes w) ++ BitVec.allOnes 640 :=
  rfl

theorem Sha512Ctx.prefix_zero (v : Sha512Ctx) : v.Prefix 0 := by simp [Sha512Ctx.Prefix]

/-- A fill right after the known bytes extends them. -/
theorem Sha512Ctx.Prefix.fill {v : Sha512Ctx} (h : v.Prefix k) {off : BitVec 64}
    (hoff : off.toNat = k) (x : BitVec w) (hw : w = 8 * j) (hkj : k + j ≤ 128) :
    (v.fill off x).Prefix (k + j) := by
  unfold Sha512Ctx.Prefix at h ⊢
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have := congrArg (·.getLsbD i) h
  simp only [BitVec.getLsbD_extractLsb', BitVec.getLsbD_allOnes, Nat.zero_add] at this
  simp only [BitVec.getLsbD_extractLsb', BitVec.getLsbD_allOnes, Nat.zero_add, hi, decide_true,
    Bool.true_and, Sha512Ctx.fill, Firedancer.Ref.fd_sha512_append.copy, getLsbD_spliceBits, hoff]
  split
  · simp only [decide_eq_true_eq]
    omega
  · have hik : i < 8 * k := by omega
    simpa [hik] using this

section Fields

variable {m : MemoryState} {c : Pointer} {v : Sha512Ctx}

theorem MemoryState.readShaCtx_field (hm : InBounds m c 1664) (hc : ¬c.offset.uaddOverflow 208#64)
    {off : BitVec 64} (hw : off.toNat * 8 + w ≤ 1664) :
    (m.readAt c 1664).extractLsb' (off.toNat * 8) w = m.readAt (c.add off) w :=
  (MemoryState.readAt_add_of_readAt hm (Pointer.not_uaddOverflow_of_ctx hc (by omega)) hw rfl).symm

theorem MemoryState.readShaCtx_num (hm : InBounds m c 1664) (hc : ¬c.offset.uaddOverflow 208#64) :
    (m.readShaCtx c).num = m.readAt (c.add 64#64) 16 :=
  MemoryState.readShaCtx_field hm hc (off := 64#64) (by decide)

theorem MemoryState.readShaCtx_mdLen (hm : InBounds m c 1664) (hc : ¬c.offset.uaddOverflow 208#64) :
    (m.readShaCtx c).mdLen = m.readAt (c.add 66#64) 16 :=
  MemoryState.readShaCtx_field hm hc (off := 66#64) (by decide)

theorem MemoryState.readShaCtx_hi (hm : InBounds m c 1664) (hc : ¬c.offset.uaddOverflow 208#64) :
    (m.readShaCtx c).hi = m.readAt (c.add 68#64) 32 :=
  MemoryState.readShaCtx_field hm hc (off := 68#64) (by decide)

theorem MemoryState.readShaCtx_lo (hm : InBounds m c 1664) (hc : ¬c.offset.uaddOverflow 208#64) :
    (m.readShaCtx c).lo = m.readAt (c.add 72#64) 64 :=
  MemoryState.readShaCtx_field hm hc (off := 72#64) (by decide)

theorem MemoryState.storeShaCtx_storeAt_num (hc : ¬c.offset.uaddOverflow 208#64) {x : BitVec 16} :
    (m.storeShaCtx c v).storeAt (c.add 64#64) x = m.storeShaCtx c { v with num := x } :=
  MemoryState.storeShaCtx_storeAt hc (by decide) (by splice_bits) (by splice_bits)

theorem MemoryState.storeShaCtx_storeAt_hi (hc : ¬c.offset.uaddOverflow 208#64) {x : BitVec 32} :
    (m.storeShaCtx c v).storeAt (c.add 68#64) x = m.storeShaCtx c { v with hi := x } :=
  MemoryState.storeShaCtx_storeAt hc (by decide) (by splice_bits) (by splice_bits)

theorem MemoryState.storeShaCtx_storeAt_lo (hc : ¬c.offset.uaddOverflow 208#64) {x : BitVec 64} :
    (m.storeShaCtx c v).storeAt (c.add 72#64) x = m.storeShaCtx c { v with lo := x } :=
  MemoryState.storeShaCtx_storeAt hc (by decide) (by splice_bits) (by splice_bits)

/-- Bytes stored into `p`, at `c`'s byte `off ≥ 80`: `fill`. -/
theorem MemoryState.storeShaCtx_storeAt_p (hc : ¬c.offset.uaddOverflow 208#64) {off : BitVec 64}
    {x : BitVec w} (h80 : 80 ≤ off.toNat) (hw : off.toNat * 8 + w ≤ 1664) :
    (m.storeShaCtx c v).storeAt (c.add off) x = m.storeShaCtx c (v.fill (off - 80#64) x) := by
  have hs : (off - 80#64).toNat = off.toNat - 80 :=
    BitVec.toNat_sub_of_le (by simpa [BitVec.le_def] using h80)
  refine MemoryState.storeShaCtx_storeAt hc hw ?_ ?_ <;>
    simp only [Sha512Ctx.bits_fill, Sha512Ctx.defs_fill] <;>
    apply BitVec.eq_of_getLsbD_eq <;>
    intro i hi <;>
    simp only [Sha512Ctx.bits, Sha512Ctx.defs, Firedancer.Ref.fd_sha512_append.copy,
      getLsbD_spliceBits, BitVec.getLsbD_append, hs, BitVec.getLsbD_allOnes] <;>
    split_ifs <;>
    first
    | omega
    | rw [show i - off.toNat * 8 = i - 640 - (off.toNat - 80) * 8 by omega]
    | rfl

/-- The state words stored over the struct. -/
theorem MemoryState.storeShaCtx_storeWords8 (hc : ¬c.offset.uaddOverflow 208#64)
    {w : Vector (BitVec 64) 8} :
    (m.storeShaCtx c v).storeWords8 c w = m.storeShaCtx c { v with h := w } := by
  have e (m' : MemoryState) (x : BitVec 64) : m'.storeAt c x = m'.storeAt (c.add 0#64) x := by
    rw [Pointer.add_zero]
  simp only [MemoryState.storeWords8, MemoryState.storeShaCtx, e]
  simp (disch :=
    first
    | decide
    | exact Pointer.not_uaddOverflow_of_ctx hc (by decide)) only [MemoryState.overlay_storeAt_add]
  congr 1 <;> splice_bits

@[simp]
theorem Sha512Ctx.low_num (v : Sha512Ctx) : v.low.extractLsb' 512 16 = v.num := by
  simp only [Sha512Ctx.low]; bv_decide

@[simp]
theorem Sha512Ctx.low_mdLen (v : Sha512Ctx) : v.low.extractLsb' 528 16 = v.mdLen := by
  simp only [Sha512Ctx.low]; bv_decide

@[simp]
theorem Sha512Ctx.low_hi (v : Sha512Ctx) : v.low.extractLsb' 544 32 = v.hi := by
  simp only [Sha512Ctx.low]; bv_decide

@[simp]
theorem Sha512Ctx.low_lo (v : Sha512Ctx) : v.low.extractLsb' 576 64 = v.lo := by
  simp only [Sha512Ctx.low]; bv_decide

/-- The struct's fields but `p`, of a stored struct. -/
@[mlir_read]
theorem MemoryState.readAt_storeShaCtx_low (hm : InBounds m c 1664) :
    (m.storeShaCtx c v).readAt c 640 = v.low := by
  rw [MemoryState.storeShaCtx, MemoryState.readAt_overlay_le hm (by decide), Sha512Ctx.bits]
  bv_decide

@[mlir_read]
theorem MemoryState.readAt_storeShaCtx_num (hm : InBounds m c 1664)
    (hc : ¬c.offset.uaddOverflow 208#64) : (m.storeShaCtx c v).readAt (c.add 64#64) 16 = v.num := by
  rw [MemoryState.readAt_storeShaCtx hm hc (by decide)]
  splice_bits

@[mlir_read]
theorem MemoryState.readAt_storeShaCtx_mdLen (hm : InBounds m c 1664)
    (hc : ¬c.offset.uaddOverflow 208#64) :
    (m.storeShaCtx c v).readAt (c.add 66#64) 16 = v.mdLen := by
  rw [MemoryState.readAt_storeShaCtx hm hc (by decide)]
  splice_bits

@[mlir_read]
theorem MemoryState.readAt_storeShaCtx_hi (hm : InBounds m c 1664)
    (hc : ¬c.offset.uaddOverflow 208#64) : (m.storeShaCtx c v).readAt (c.add 68#64) 32 = v.hi := by
  rw [MemoryState.readAt_storeShaCtx hm hc (by decide)]
  splice_bits

@[mlir_read]
theorem MemoryState.readAt_storeShaCtx_lo (hm : InBounds m c 1664)
    (hc : ¬c.offset.uaddOverflow 208#64) : (m.storeShaCtx c v).readAt (c.add 72#64) 64 = v.lo := by
  rw [MemoryState.readAt_storeShaCtx hm hc (by decide)]
  splice_bits

/-- A field stored over the struct at `c`: the struct with that field. -/
theorem MemoryState.storeAt_lo_eq (h : m.ShaCtxFit c) {x : BitVec 64} :
    m.storeAt (c.add 72#64) x = m.storeShaCtx c { m.readShaCtx c with lo := x } := by
  conv_lhs => rw [← MemoryState.storeShaCtx_readShaCtx_self h]
  exact MemoryState.storeShaCtx_storeAt_lo h.1

/-- Bytes stored into `p` of the struct at `c`, as a store of the whole struct. -/
theorem MemoryState.storeAt_p_eq (h : m.ShaCtxFit c) {off : BitVec 64} {x : BitVec w}
    (h80 : 80 ≤ off.toNat) (hw : off.toNat * 8 + w ≤ 1664) :
    m.storeAt (c.add off) x = m.storeShaCtx c ((m.readShaCtx c).fill (off - 80#64) x) := by
  conv_lhs => rw [← MemoryState.storeShaCtx_readShaCtx_self h]
  exact MemoryState.storeShaCtx_storeAt_p h.1 h80 hw

end Fields

/-- The state words of a struct that fits. -/
theorem MemoryState.ShaCtxFit.words8Fit {m : MemoryState} (h : m.ShaCtxFit c) : m.Words8Fit c := by
  obtain ⟨ho, -, hf⟩ := h
  have hof : ∀ k : Nat, k ≤ 56 → ¬c.offset.uaddOverflow (BitVec.ofNat 64 k) := fun k hk =>
    Pointer.not_uaddOverflow_of_ctx ho
      (by
        simp; omega)
  refine
      ⟨by
        simp [BitVec.uaddOverflow] at ho; omega, hf.mono (by decide), ?_, ?_, ?_, ?_, ?_, ?_,
        ?_⟩ <;>
    exact Fits.add_of_le (hof _ (by decide)) (by decide) hf

theorem Sha512Ctx.toNat_80_add {x : BitVec 16} : (80#64 + x.setWidth 64).toNat = 80 + x.toNat := by
  rw [BitVec.toNat_add]
  simp only [BitVec.toNat_ofNat, BitVec.toNat_setWidth]
  have := x.isLt
  omega

theorem Sha512Ctx.add_80_sub (x : BitVec 64) : 80#64 + x - 80#64 = x := by
  rw [BitVec.add_comm, BitVec.add_sub_cancel]

/-- `p + off`, `off ≤ 128`, does not wrap. -/
theorem Sha512Ctx.not_uaddOverflow_p {c : Pointer} (hco : ¬c.offset.uaddOverflow 208#64)
    {off : BitVec 64} (h : off.toNat ≤ 128) : ¬(c.add 80#64).offset.uaddOverflow off := by
  simp [BitVec.uaddOverflow, Pointer.add, BitVec.toNat_add] at hco ⊢
  omega

/-! ### Facts carried past writes -/

@[mlir_mem, mlir_transport]
theorem MemoryState.ShaCtxFit.storeAt {m : MemoryState} {x : BitVec w} (h : m.ShaCtxFit c) :
    (m.storeAt q x).ShaCtxFit c :=
  ⟨h.1, h.2.1.storeAt, h.2.2.storeAt⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.ShaCtxFit.storeWords8 {m : MemoryState} (h : m.ShaCtxFit c) :
    (m.storeWords8 q v).ShaCtxFit c :=
  ⟨h.1, h.2.1.storeWords8, h.2.2.storeWords8⟩

/-- The struct stored where there is room: its fields known. -/
@[mlir_fresh, mlir_mem]
theorem MemoryState.ShaCtxFit.storeShaCtx_self {m : MemoryState} (h : Room m c 1664)
    (hco : ¬c.offset.uaddOverflow 208#64) : (m.storeShaCtx c v).ShaCtxFit c := by
  refine ⟨hco, Room.overlay h, Fits.overlay_of_mask_self h (by decide) ?_⟩
  simp only [Sha512Ctx.defs]
  bv_decide

/-- Storing the struct keeps its fields known. -/
@[mlir_mem, mlir_transport]
theorem MemoryState.ShaCtxFit.storeShaCtx {m : MemoryState} (h : m.ShaCtxFit c) :
    (m.storeShaCtx c v).ShaCtxFit c :=
  MemoryState.ShaCtxFit.storeShaCtx_self h.2.1 h.1

/-- Storing another struct, in another block. -/
@[mlir_mem, mlir_transport]
theorem MemoryState.ShaCtxFit.storeShaCtx_of_id_ne {m : MemoryState} (h : m.ShaCtxFit c)
    (hne : c.id ≠ c'.id) : (m.storeShaCtx c' v).ShaCtxFit c :=
  ⟨h.1, Room.overlay h.2.1, Fits.overlay_of_disjoint h.2.2 (Range.disjoint_of_id_ne hne.symm)⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.ShaCtxFit.alloca {s : GlobalState} (hwf : s.WF) (h : s.mem.ShaCtxFit c) :
    (s.alloca n d).mem.ShaCtxFit c :=
  ⟨h.1, h.2.1.alloca hwf, h.2.2.alloca hwf⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.ShaCtxFit.addBlock {s : GlobalState} {x : BitVec v} (hwf : s.WF)
    (h : s.mem.ShaCtxFit c) : (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).ShaCtxFit c :=
  ⟨h.1, h.2.1.addBlock hwf, h.2.2.addBlock hwf⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.ShaCtxFit.lifetimeStart {m : MemoryState} (h : m.ShaCtxFit c)
    (hne : c.id ≠ q.id) : (m.lifetimeStart q).ShaCtxFit c :=
  ⟨h.1, h.2.1.lifetimeStart hne, h.2.2.lifetimeStart hne⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.ShaCtxFit.lifetimeEnd {m : MemoryState} (h : m.ShaCtxFit c)
    (hne : c.id ≠ q.id) : (m.lifetimeEnd q).ShaCtxFit c :=
  ⟨h.1, h.2.1.lifetimeEnd hne, h.2.2.lifetimeEnd hne⟩

/-- Another block's known bits stay known. -/
@[mlir_transport]
theorem Fits.storeShaCtx {m : MemoryState} (h : Fits m p w) (hne : p.id ≠ c.id) :
    Fits (m.storeShaCtx c v) p w :=
  Fits.overlay_of_disjoint h (Range.disjoint_of_id_ne hne.symm)

/-- `storeShaCtx` keeps every block, its length and lifetime. -/
@[simp]
theorem Room.storeShaCtx_iff {m : MemoryState} : Room (m.storeShaCtx c v) p w ↔ Room m p w :=
  Room.overlay_iff

@[mlir_transport]
theorem Room.storeShaCtx {m : MemoryState} (h : Room m p w) : Room (m.storeShaCtx c v) p w :=
  Room.overlay h

@[mlir_mem, mlir_transport]
theorem MemoryState.Words8Room.storeShaCtx {m : MemoryState} (h : m.Words8Room p) :
    (m.storeShaCtx c v).Words8Room p := by
  unfold MemoryState.Words8Room at h ⊢
  simpa using h

@[mlir_mem, mlir_transport]
theorem MemoryState.Words8Fit.storeShaCtx {m : MemoryState} (h : m.Words8Fit p)
    (hne : p.id ≠ c.id) : (m.storeShaCtx c v).Words8Fit p :=
  ⟨h.1, h.2.1.storeShaCtx hne, h.2.2.1.storeShaCtx hne, h.2.2.2.1.storeShaCtx hne,
    h.2.2.2.2.1.storeShaCtx hne, h.2.2.2.2.2.1.storeShaCtx hne, h.2.2.2.2.2.2.1.storeShaCtx hne,
    h.2.2.2.2.2.2.2.1.storeShaCtx hne, h.2.2.2.2.2.2.2.2.storeShaCtx hne⟩

@[mlir_transport]
theorem InBounds.storeShaCtx {m : MemoryState} (h : InBounds m p w) :
    InBounds (m.storeShaCtx c v) p w :=
  InBounds.overlay h

@[mlir_transport]
theorem GlobalState.WF.storeShaCtx {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storeShaCtx c v } : GlobalState).WF :=
  h.overlay

/-- `storeShaCtx` keeps the set of blocks, so `WF` does not depend on it. -/
@[simp, mlir_mem]
theorem GlobalState.WF_storeShaCtx {s : GlobalState} :
    ({ s with mem := m.storeShaCtx c v } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF :=
  GlobalState.WF_overlay

/-- A callee's result state: blocks counted, the struct stored. -/
@[mlir_transport]
theorem GlobalState.WF.add_blocks_storeShaCtx {s : GlobalState} (h : s.WF) :
    (⟨⟨s.alloc.nextFreeBlock + k⟩, s.mem.storeShaCtx c v⟩ : GlobalState).WF :=
  GlobalState.WF.storeShaCtx (s := ⟨⟨s.alloc.nextFreeBlock + k⟩, s.mem⟩) h.add_blocks

/-- `final`'s result state: blocks counted, the struct and the digest stored. -/
@[mlir_transport]
theorem GlobalState.WF.add_blocks_storeShaCtx_storeWords8 {s : GlobalState} (h : s.WF) :
    (⟨⟨s.alloc.nextFreeBlock + k⟩, (s.mem.storeShaCtx c v).storeWords8 p w⟩ : GlobalState).WF :=
  GlobalState.WF.storeWords8 (s := ⟨_, s.mem.storeShaCtx c v⟩) h.add_blocks_storeShaCtx

/-- Reads in another block are unaffected by `storeShaCtx`. -/
@[mlir_read]
theorem MemoryState.readAt_storeShaCtx_of_id_ne {m : MemoryState} (h : q.id ≠ c.id) :
    (m.storeShaCtx c v).readAt q w = m.readAt q w :=
  MemoryState.readAt_overlay_disjoint (Range.disjoint_of_id_ne h.symm) _ _

/-- Erasing a frame commutes with storing the struct. -/
@[mlir_frame, mlir_erase]
theorem MemoryState.eraseFrom_storeShaCtx {m : MemoryState} :
    (m.storeShaCtx c v).eraseFrom n = (m.eraseFrom n).storeShaCtx c v :=
  MemoryState.eraseFrom_overlay

end

end MLIR
