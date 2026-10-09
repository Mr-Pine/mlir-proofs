module

public import MLIR.Run.Tactic
public import Firedancer.Common.Point
public import Firedancer.Ref.fd_memcpy
public import Firedancer.Ref.fd_sha512_core_ref
public import Firedancer.Ref.Mlir.fd_sha512_append
import Std.Data.ExtHashMap.Lemmas
import Std.Tactic.BVDecide

namespace MLIR

open Memory

/-! ## Staged for Common -/

@[expose] public section

/-- A second store to the same range overwrites the first. -/
theorem MemoryState.storeAt_storeAt_self {m : MemoryState} {p : Pointer} {x y : BitVec w} :
    (m.storeAt p x).storeAt p y = m.storeAt p y := by
  rcases m with ⟨mm⟩
  unfold MemoryState.storeAt
  cases hb : (⟨mm⟩ : MemoryState)[p.id]? with
  | none => simp [hb]
  | some blk =>
    simp only [MemoryState.getElem?_eq, Std.ExtHashMap.getElem?_insert_self] at hb ⊢
    simp only [spliceBits_spliceBits_self]
    congr 1
    apply Std.ExtHashMap.ext_getElem?
    intro a
    simp only [Std.ExtHashMap.getElem?_insert]
    split <;> rfl

/-- A store inside a stored range: one store of the bits with the new ones spliced in. -/
theorem MemoryState.storeAt_storeAt_add {m : MemoryState} {p : Pointer} {x : BitVec v}
    {y : BitVec w} {off : BitVec 64} (hov : ¬p.offset.uaddOverflow off)
    (hw : off.toNat * 8 + w ≤ v) :
    (m.storeAt p x).storeAt (p.add off) y = m.storeAt p (spliceBits x (off.toNat * 8) y) := by
  rcases m with ⟨mm⟩
  unfold MemoryState.storeAt
  cases hb : (⟨mm⟩ : MemoryState)[p.id]? with
  | none => simp [hb]
  | some
    blk =>
    simp only [MemoryState.getElem?_eq, Pointer.add_id, Std.ExtHashMap.getElem?_insert_self] at hb ⊢
    congr 1
    apply Std.ExtHashMap.ext_getElem?
    intro a
    simp only [Std.ExtHashMap.getElem?_insert]
    split
    · have ho : (p.add off).offset.toNat = p.offset.toNat + off.toNat := by
        simp only [Pointer.add, BitVec.toNat_add_of_not_uaddOverflow hov]
      congr 2
      apply BitVec.eq_of_getLsbD_eq
      intro i hi
      simp only [getLsbD_spliceBits, Pointer.offsetInBits, ho]
      grind
    · rfl

/-- `storeAt` past `storeWords8` to a disjoint range. -/
theorem MemoryState.storeWords8_storeAt_comm {m : MemoryState} {p q : Pointer} {x : BitVec w}
    (hq : q.offset.toNat + 56 < 2 ^ 64) (h : (Range.of p w).Disjoint (Range.of q 512)) :
    (m.storeWords8 q v).storeAt p x = (m.storeAt p x).storeWords8 q v := by
  have hw :
    ∀ k : Nat, k ≤ 56 → (Range.of p w).Disjoint (Range.of (q.add (BitVec.ofNat 64 k)) 64) := by
    intro k hk
    simp only [Range.Disjoint, Range.of, Pointer.offsetInBits, Pointer.add, BitVec.toNat_add,
      BitVec.toNat_ofNat] at h ⊢
    rw [Nat.mod_eq_of_lt (by omega : k < 2 ^ 64), Nat.mod_eq_of_lt (by omega)]
    rcases h with h | h
    · exact Or.inl h
    · right; omega
  have h0 : (Range.of p w).Disjoint (Range.of q 64) := by simpa using hw 0 (by decide)
  unfold MemoryState.storeWords8
  rw [MemoryState.storeAt_comm (hw 56 (by decide)).symm,
    MemoryState.storeAt_comm (hw 48 (by decide)).symm,
    MemoryState.storeAt_comm (hw 40 (by decide)).symm,
    MemoryState.storeAt_comm (hw 32 (by decide)).symm,
    MemoryState.storeAt_comm (hw 24 (by decide)).symm,
    MemoryState.storeAt_comm (hw 16 (by decide)).symm,
    MemoryState.storeAt_comm (hw 8 (by decide)).symm, MemoryState.storeAt_comm h0.symm]

/-- `fd_sha512_core_ref`'s result state is `WF`: two more blocks counted, the state words stored. -/
@[mlir_transport]
theorem GlobalState.WF.add_blocks_storeWords8 {s : GlobalState} (h : s.WF) :
    (⟨⟨s.alloc.nextFreeBlock + k⟩, s.mem.storeWords8 p v⟩ : GlobalState).WF :=
  GlobalState.WF.storeWords8 (s := ⟨⟨s.alloc.nextFreeBlock + k⟩, s.mem⟩) h.add_blocks

/-- Storing the eight words that are there changes nothing. -/
theorem MemoryState.storeWords8_readWords8_self {m : MemoryState} (h : m.Words8Fit p) :
    m.storeWords8 p (m.readWords8 p) = m := by
  obtain ⟨-, h0, h1, h2, h3, h4, h5, h6, h7⟩ := h
  simp only [MemoryState.storeWords8, MemoryState.readWords8, Vector.getElem_mk,
    List.getElem_toArray, List.getElem_cons_zero, List.getElem_cons_succ]
  rw [MemoryState.storeAt_readAt_self h0, MemoryState.storeAt_readAt_self h1,
    MemoryState.storeAt_readAt_self h2, MemoryState.storeAt_readAt_self h3,
    MemoryState.storeAt_readAt_self h4, MemoryState.storeAt_readAt_self h5,
    MemoryState.storeAt_readAt_self h6, MemoryState.storeAt_readAt_self h7]

/-- Eight words stored where they fit read back. -/
theorem MemoryState.readWords8_storeWords8_self {m : MemoryState} (h : m.Words8Fit p) :
    (m.storeWords8 p v).readWords8 p = v := by
  obtain ⟨ho, h0, h1, h2, h3, h4, h5, h6, h7⟩ := h
  ext k hk
  simp only [MemoryState.readWords8, MemoryState.storeWords8]
  match k, hk with
  | 0, _ | 1, _ | 2, _ | 3, _ | 4, _ | 5, _ | 6, _ | 7,
    _ =>
    simp only [Tactic.readThroughStore]
    rfl

/-- A buffer of `b` bytes at `p`, advanced by `a ≤ b`: the remaining `b - a` bytes do not wrap
either. -/
theorem Pointer.not_uaddOverflow_add_sub {p : Pointer} {a b : BitVec 64}
    (h : ¬p.offset.uaddOverflow b) (hab : a.toNat ≤ b.toNat) :
    ¬(p.add a).offset.uaddOverflow (b - a) := by
  have ha := BitVec.not_uaddOverflow_of_le h hab
  simp only [BitVec.uaddOverflow, Pointer.add, BitVec.toNat_add_of_not_uaddOverflow ha,
    BitVec.toNat_sub_of_le (BitVec.le_def.2 hab), decide_eq_true_eq, ge_iff_le, Nat.not_le] at h ⊢
  omega

/-- The fields of `fd_sha512_t` that `append` and `fini` use: `buf`, `state`, `buf_used`,
`bit_cnt_lo` and `bit_cnt_hi`, at byte offsets 0, 128, 200, 208 and 216. -/
structure ShaState where
  buf : BitVec 1024
  state : Vector (BitVec 64) 8
  bufUsed : BitVec 64
  bitCntLo : BitVec 64
  bitCntHi : BitVec 64

/-- The `fd_sha512_t` at `p`. -/
def MemoryState.readSha (m : MemoryState) (p : Pointer) : ShaState :=
  ⟨m.readAt p 1024, m.readWords8 (p.add 128#64), m.readAt (p.add 200#64) 64,
    m.readAt (p.add 208#64) 64, m.readAt (p.add 216#64) 64⟩

/-- Store the fields of an `fd_sha512_t` at `p`; `magic` and the padding stay. -/
def MemoryState.storeSha (m : MemoryState) (p : Pointer) (v : ShaState) : MemoryState :=
  ((((m.storeAt p v.buf).storeAt (p.add 200#64) v.bufUsed).storeAt (p.add 208#64)
            v.bitCntLo).storeAt
        (p.add 216#64) v.bitCntHi).storeWords8
    (p.add 128#64) v.state

/-- The 256 bytes of an `fd_sha512_t` at `p` fit, and their offsets do not wrap. -/
abbrev MemoryState.ShaFit (m : MemoryState) (p : Pointer) : Prop :=
  Fits m p (8 * 256) ∧ ¬p.offset.uaddOverflow 256#64

attribute [mlir_mem] MemoryState.ShaFit

theorem Pointer.offsetInBits_add_of_le {p : Pointer} (h : ¬p.offset.uaddOverflow 256#64) {k : Nat}
    (hk : k ≤ 256) : (p.add (BitVec.ofNat 64 k)).offsetInBits = p.offsetInBits + 8 * k := by
  rw [Pointer.offsetInBits_add
      (BitVec.not_uaddOverflow_of_le h
        (by
          simp; omega))]
  simp only [BitVec.toNat_ofNat]
  rw [Nat.mod_eq_of_lt (by omega)]
  omega

/-- Two ranges inside an `fd_sha512_t`, `a` and `b` bytes in, apart. -/
theorem Range.disjoint_sha {p : Pointer} (h : ¬p.offset.uaddOverflow 256#64) {a b wa wb : Nat}
    (ha : a ≤ 256) (hb : b ≤ 256) (hab : 8 * a + wa ≤ 8 * b ∨ 8 * b + wb ≤ 8 * a) :
    (Range.of (p.add (BitVec.ofNat 64 a)) wa).Disjoint
      (Range.of (p.add (BitVec.ofNat 64 b)) wb) := by
  simp only [Range.Disjoint, Range.of, Pointer.offsetInBits_add_of_le h ha,
    Pointer.offsetInBits_add_of_le h hb]
  omega

theorem Range.disjoint_sha_base {p : Pointer} (h : ¬p.offset.uaddOverflow 256#64) {b wa wb : Nat}
    (hb : b ≤ 256) (hab : wa ≤ 8 * b) :
    (Range.of p wa).Disjoint (Range.of (p.add (BitVec.ofNat 64 b)) wb) := by
  simpa using Range.disjoint_sha h (a := 0) (by decide) hb (wa := wa) (wb := wb) (by omega)

theorem MemoryState.ShaFit.words8Fit {m : MemoryState} (h : m.ShaFit p) :
    m.Words8Fit (p.add 128#64) := by
  obtain ⟨hf, ho⟩ := h
  have hof : ∀ k : Nat, k ≤ 56 → ¬(p.add 128#64).offset.uaddOverflow (BitVec.ofNat 64 k) := by
    intro k hk
    simp only [BitVec.uaddOverflow, Pointer.add] at ho ⊢
    simp at ho ⊢
    omega
  have h128 : Fits m (p.add 128#64) 512 :=
    Fits.add_of_le (BitVec.not_uaddOverflow_of_le ho (by decide)) (by decide) hf
  refine
      ⟨by
        simp [BitVec.uaddOverflow, Pointer.add] at ho ⊢; omega, h128.mono (by decide), ?_, ?_, ?_,
        ?_, ?_, ?_, ?_⟩ <;>
    exact Fits.add_of_le (hof _ (by decide)) (by decide) h128

@[mlir_read]
theorem MemoryState.readAt_storeWords8_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : q.id ≠ p.id) : (m.storeWords8 p v).readAt q w = m.readAt q w := by
  have hd : ∀ k : BitVec 64, (Range.of (p.add k) 64).Disjoint (Range.of q w) := fun _ =>
    Range.disjoint_of_id_ne h.symm
  unfold MemoryState.storeWords8
  rw [MemoryState.readAt_storeAt_disjoint (hd _), MemoryState.readAt_storeAt_disjoint (hd _),
    MemoryState.readAt_storeAt_disjoint (hd _), MemoryState.readAt_storeAt_disjoint (hd _),
    MemoryState.readAt_storeAt_disjoint (hd _), MemoryState.readAt_storeAt_disjoint (hd _),
    MemoryState.readAt_storeAt_disjoint (hd _),
    MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne h.symm)]

theorem Pointer.state_offset {p : Pointer} (h : ¬p.offset.uaddOverflow 256#64) :
    (p.add 128#64).offset.toNat + 56 < 2 ^ 64 := by
  simp only [BitVec.uaddOverflow, Pointer.add] at h ⊢
  simp at h ⊢
  omega

/-- A field of the `fd_sha512_t` at `p`, `k` bytes in, fits. -/
theorem MemoryState.ShaFit.fits_add {m : MemoryState} (h : m.ShaFit p) {k w : Nat}
    (hk : 8 * k + w ≤ 2048) : Fits m (p.add (BitVec.ofNat 64 k)) w :=
  Fits.add_of_le
    (BitVec.not_uaddOverflow_of_le h.2
      (by
        simp; omega))
    (by
      simp; omega)
    h.1

theorem MemoryState.ShaFit.fits_buf {m : MemoryState} (h : m.ShaFit p) (hw : w ≤ 1024) :
    Fits m p w :=
  h.1.mono (by omega)

/-- `bit_cnt_hi` stored after the struct. -/
theorem MemoryState.storeSha_storeAt_bitCntHi {m : MemoryState} (h : ¬p.offset.uaddOverflow 256#64)
    {x : BitVec 64} :
    (m.storeSha p v).storeAt (p.add 216#64) x = m.storeSha p { v with bitCntHi := x } := by
  unfold MemoryState.storeSha
  rw [MemoryState.storeWords8_storeAt_comm (Pointer.state_offset h)
      (Range.disjoint_sha h (by decide) (by decide) (by decide)),
    MemoryState.storeAt_storeAt_self]

/-- `bit_cnt_lo` stored after the struct. -/
theorem MemoryState.storeSha_storeAt_bitCntLo {m : MemoryState} (h : ¬p.offset.uaddOverflow 256#64)
    {x : BitVec 64} :
    (m.storeSha p v).storeAt (p.add 208#64) x = m.storeSha p { v with bitCntLo := x } := by
  unfold MemoryState.storeSha
  rw [MemoryState.storeWords8_storeAt_comm (Pointer.state_offset h)
      (Range.disjoint_sha h (by decide) (by decide) (by decide)),
    MemoryState.storeAt_comm
      (Range.disjoint_sha h (a := 216) (b := 208) (by decide) (by decide) (by decide)),
    MemoryState.storeAt_storeAt_self]

/-- `buf_used` stored after the struct. -/
theorem MemoryState.storeSha_storeAt_bufUsed {m : MemoryState} (h : ¬p.offset.uaddOverflow 256#64)
    {x : BitVec 64} :
    (m.storeSha p v).storeAt (p.add 200#64) x = m.storeSha p { v with bufUsed := x } := by
  unfold MemoryState.storeSha
  rw [MemoryState.storeWords8_storeAt_comm (Pointer.state_offset h)
      (Range.disjoint_sha h (by decide) (by decide) (by decide)),
    MemoryState.storeAt_comm
      (Range.disjoint_sha h (a := 216) (b := 200) (by decide) (by decide) (by decide)),
    MemoryState.storeAt_comm
      (Range.disjoint_sha h (a := 208) (b := 200) (by decide) (by decide) (by decide)),
    MemoryState.storeAt_storeAt_self]

/-- `state` stored after the struct. -/
theorem MemoryState.storeSha_storeWords8_state {m : MemoryState} :
    (m.storeSha p v).storeWords8 (p.add 128#64) w = m.storeSha p { v with state := w } := by
  unfold MemoryState.storeSha
  rw [MemoryState.storeWords8_storeWords8_self]

/-- Bytes stored into `buf`, `off` bytes in, after the struct. -/
theorem MemoryState.storeSha_storeAt_buf {m : MemoryState} (h : ¬p.offset.uaddOverflow 256#64)
    {off : BitVec 64} {x : BitVec w} (hw : off.toNat * 8 + w ≤ 1024) :
    (m.storeSha p v).storeAt (p.add off) x =
      m.storeSha p { v with buf := spliceBits v.buf (off.toNat * 8) x } := by
  have hoff : off = BitVec.ofNat 64 off.toNat := by simp
  have hd :
    ∀ b,
      128 ≤ b →
        b ≤ 256 → (Range.of (p.add off) w).Disjoint (Range.of (p.add (BitVec.ofNat 64 b)) 64) := by
    intro b hb hb'
    rw [hoff]
    exact Range.disjoint_sha h (by omega) hb' (by omega)
  unfold MemoryState.storeSha
  rw [MemoryState.storeWords8_storeAt_comm (Pointer.state_offset h)
      (by
        rw [hoff]; exact Range.disjoint_sha h (by omega) (by decide) (by omega)),
    MemoryState.storeAt_comm (hd 216 (by decide) (by decide)).symm,
    MemoryState.storeAt_comm (hd 208 (by decide) (by decide)).symm,
    MemoryState.storeAt_comm (hd 200 (by decide) (by decide)).symm,
    MemoryState.storeAt_storeAt_add
      (BitVec.not_uaddOverflow_of_le h
        (by
          simp; omega))
      hw]

/-- Bytes stored at the start of `buf`, after the struct. -/
theorem MemoryState.storeSha_storeAt_buf_base {m : MemoryState} (h : ¬p.offset.uaddOverflow 256#64)
    {x : BitVec w} (hw : w ≤ 1024) :
    (m.storeSha p v).storeAt p x = m.storeSha p { v with buf := spliceBits v.buf 0 x } := by
  have := MemoryState.storeSha_storeAt_buf (m := m) (v := v) (off := 0#64) (x := x) h (by simpa)
  simpa using this

/-- The struct stored where it fits reads back. -/
theorem MemoryState.readSha_storeSha_self {m : MemoryState} (h : m.ShaFit p) :
    (m.storeSha p v).readSha p = v := by
  have h0 := h.fits_buf (w := 1024) (by decide)
  have hu := h.fits_add (k := 200) (w := 64) (by decide)
  have hl := h.fits_add (k := 208) (w := 64) (by decide)
  have hh := h.fits_add (k := 216) (w := 64) (by decide)
  have hs := Pointer.state_offset h.2
  have hd :
    ∀ a w',
      8 * a + w' ≤ 1024 ∨ 1536 ≤ 8 * a →
        a ≤ 256 →
        (Range.of (p.add 128#64) 512).Disjoint (Range.of (p.add (BitVec.ofNat 64 a)) w') :=
    fun a w' ha ha' => Range.disjoint_sha h.2 (a := 128) (b := a) (by decide) ha' (by omega)
  rcases v with ⟨buf, st, u, lo, hi⟩
  simp only [MemoryState.readSha, MemoryState.storeSha, ShaState.mk.injEq]
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · rw [MemoryState.readAt_storeWords8_of_disjoint hs
        (by simpa using hd 0 1024 (by decide) (by decide)),
      MemoryState.readAt_storeAt_disjoint
        (Range.disjoint_sha_base h.2 (by decide) (by decide)).symm,
      MemoryState.readAt_storeAt_disjoint
        (Range.disjoint_sha_base h.2 (by decide) (by decide)).symm,
      MemoryState.readAt_storeAt_disjoint
        (Range.disjoint_sha_base h.2 (by decide) (by decide)).symm,
      MemoryState.readAt_storeAt_self h0]
  · exact MemoryState.readWords8_storeWords8_self h.words8Fit.storeAt.storeAt.storeAt.storeAt
  · rw [MemoryState.readAt_storeWords8_of_disjoint hs (hd 200 64 (by decide) (by decide)),
      MemoryState.readAt_storeAt_disjoint
        (Range.disjoint_sha h.2 (a := 216) (b := 200) (by decide) (by decide) (by decide)),
      MemoryState.readAt_storeAt_disjoint
        (Range.disjoint_sha h.2 (a := 208) (b := 200) (by decide) (by decide) (by decide)),
      MemoryState.readAt_storeAt_self (hu.storeAt)]
  · rw [MemoryState.readAt_storeWords8_of_disjoint hs (hd 208 64 (by decide) (by decide)),
      MemoryState.readAt_storeAt_disjoint
        (Range.disjoint_sha h.2 (a := 216) (b := 208) (by decide) (by decide) (by decide)),
      MemoryState.readAt_storeAt_self (hl.storeAt.storeAt)]
  · rw [MemoryState.readAt_storeWords8_of_disjoint hs (hd 216 64 (by decide) (by decide)),
      MemoryState.readAt_storeAt_self (hh.storeAt.storeAt.storeAt)]

theorem MemoryState.readAt_storeSha_buf {m : MemoryState} (h : m.ShaFit p) :
    (m.storeSha p v).readAt p 1024 = v.buf :=
  congrArg ShaState.buf (MemoryState.readSha_storeSha_self h)

theorem MemoryState.readWords8_storeSha_state {m : MemoryState} (h : m.ShaFit p) :
    (m.storeSha p v).readWords8 (p.add 128#64) = v.state :=
  congrArg ShaState.state (MemoryState.readSha_storeSha_self h)

/-- The state words of a stored struct, at the offsets `getelementptr` gives them. -/
theorem MemoryState.readAt_storeSha_state {m : MemoryState} (h : m.ShaFit p) :
    (m.storeSha p v).readAt (p.add 128#64) 64 = v.state[0] ∧
      (m.storeSha p v).readAt (p.add 136#64) 64 = v.state[1] ∧
      (m.storeSha p v).readAt (p.add 144#64) 64 = v.state[2] ∧
      (m.storeSha p v).readAt (p.add 152#64) 64 = v.state[3] ∧
      (m.storeSha p v).readAt (p.add 160#64) 64 = v.state[4] ∧
      (m.storeSha p v).readAt (p.add 168#64) 64 = v.state[5] ∧
      (m.storeSha p v).readAt (p.add 176#64) 64 = v.state[6] ∧
      (m.storeSha p v).readAt (p.add 184#64) 64 = v.state[7] := by
  have hw := MemoryState.readWords8_storeSha_state (v := v) h
  simp only [MemoryState.readWords8, Pointer.add_add, BitVec.reduceAdd] at hw
  rw [← hw]
  simp

/-- Storing the struct that is there changes nothing. -/
theorem MemoryState.storeSha_readSha_self {m : MemoryState} (h : m.ShaFit p) :
    m.storeSha p (m.readSha p) = m := by
  simp only [MemoryState.storeSha, MemoryState.readSha]
  rw [MemoryState.storeAt_readAt_self (h.fits_buf (by decide)),
    MemoryState.storeAt_readAt_self (h.fits_add (k := 200) (by decide)),
    MemoryState.storeAt_readAt_self (h.fits_add (k := 208) (by decide)),
    MemoryState.storeAt_readAt_self (h.fits_add (k := 216) (by decide)),
    MemoryState.storeWords8_readWords8_self h.words8Fit]

/-- A store of `bit_cnt_lo` into the struct at `p`, as a store of the whole struct. -/
theorem MemoryState.storeAt_bitCntLo_eq {m : MemoryState} (h : m.ShaFit p) {x : BitVec 64} :
    m.storeAt (p.add 208#64) x = m.storeSha p { m.readSha p with bitCntLo := x } := by
  conv_lhs => rw [← MemoryState.storeSha_readSha_self h]
  exact MemoryState.storeSha_storeAt_bitCntLo h.2

/-- A store into `buf`, `off` bytes in, as a store of the whole struct. -/
theorem MemoryState.storeAt_buf_eq {m : MemoryState} (h : m.ShaFit p) {off : BitVec 64}
    {x : BitVec w} (hw : off.toNat * 8 + w ≤ 1024) :
    m.storeAt (p.add off) x =
      m.storeSha p { m.readSha p with buf := spliceBits (m.readAt p 1024) (off.toNat * 8) x } := by
  conv_lhs => rw [← MemoryState.storeSha_readSha_self h]
  exact MemoryState.storeSha_storeAt_buf h.2 hw

/-- Reads in another block are unaffected by `storeSha`. -/
@[mlir_read]
theorem MemoryState.readAt_storeSha_of_id_ne {m : MemoryState} {p q : Pointer} (h : q.id ≠ p.id) :
    (m.storeSha p v).readAt q w = m.readAt q w := by
  unfold MemoryState.storeSha
  rw [MemoryState.readAt_storeWords8_of_id_ne (p := p.add 128#64) h,
    MemoryState.readAt_storeAt_disjoint (p := p.add 216#64) (Range.disjoint_of_id_ne h.symm),
    MemoryState.readAt_storeAt_disjoint (p := p.add 208#64) (Range.disjoint_of_id_ne h.symm),
    MemoryState.readAt_storeAt_disjoint (p := p.add 200#64) (Range.disjoint_of_id_ne h.symm),
    MemoryState.readAt_storeAt_disjoint (Range.disjoint_of_id_ne h.symm)]

@[simp]
theorem Fits.storeSha_iff {m : MemoryState} : Fits (m.storeSha q v) p w ↔ Fits m p w := by
  simp [MemoryState.storeSha]

@[mlir_transport]
theorem Fits.storeSha {m : MemoryState} (h : Fits m p w) : Fits (m.storeSha q v) p w :=
  Fits.storeSha_iff.2 h

@[mlir_mem, mlir_transport]
theorem MemoryState.ShaFit.storeAt {m : MemoryState} {x : BitVec w} (h : m.ShaFit p) :
    (m.storeAt q x).ShaFit p :=
  ⟨h.1.storeAt, h.2⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.ShaFit.storeWords8 {m : MemoryState} (h : m.ShaFit p) :
    (m.storeWords8 q v).ShaFit p :=
  ⟨h.1.storeWords8, h.2⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.ShaFit.storeSha {m : MemoryState} (h : m.ShaFit p) :
    (m.storeSha q v).ShaFit p :=
  ⟨h.1.storeSha, h.2⟩

@[mlir_mem, mlir_transport]
theorem MemoryState.Words8Fit.storeSha (h : MemoryState.Words8Fit m p) :
    MemoryState.Words8Fit (m.storeSha q v) p := by
  unfold MemoryState.Words8Fit at h ⊢
  simpa using h

@[mlir_transport]
theorem GlobalState.WF.storeSha {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storeSha p v } : GlobalState).WF := by
  unfold MemoryState.storeSha
  exact h.storeAt.storeAt.storeAt.storeAt.storeWords8

/-- `storeSha` keeps the set of blocks, so `WF` does not depend on it. -/
@[simp, mlir_mem]
theorem GlobalState.WF_storeSha {s : GlobalState} :
    ({ s with mem := m.storeSha p v } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF := by
  simp [MemoryState.storeSha, MemoryState.storeWords8]

/-- Erasing a frame commutes with storing the struct. -/
theorem MemoryState.eraseFrom_storeSha {m : MemoryState} :
    (m.storeSha p v).eraseFrom n = (m.eraseFrom n).storeSha p v := by
  simp [MemoryState.storeSha, MemoryState.eraseFrom_storeAt, MemoryState.eraseFrom_storeWords8]

end

end MLIR

namespace MLIR.Firedancer.Ref

open Memory

/-! ## Specification -/

@[expose] public section

namespace fd_sha512_append

/-- `fd_memcpy( buf + off, x, … )` on `buf`'s bytes. -/
def copy (buf : BitVec 1024) (off : BitVec 64) (x : BitVec w) : BitVec 1024 :=
  spliceBits buf (off.toNat * 8) x

/-- "Buffer any leftover bytes": the last `sz & 127` bytes of `data`, past its
`block_cnt = sz >> 7` blocks, to the start of `buf`. -/
def leftover (sha : ShaState) (sz : BitVec 64) (data : BitVec (8 * sz.toNat)) : ShaState :=
  let buf_used := sz &&& 127#64
  if buf_used ≠ 0#64 then
    { sha with
      buf := copy sha.buf 0#64 (data.extractLsb' (1024 * (sz >>> 7).toNat) (8 * buf_used.toNat))
      bufUsed := buf_used }
  else sha

/-- "Append the bulk of the data": the `block_cnt = sz >> 7` whole blocks of `data` compressed into
`state`; then the leftover. -/
def bulk (sha : ShaState) (sz : BitVec 64) (data : BitVec (8 * sz.toNat)) : ShaState :=
  let block_cnt := sz >>> 7
  let sha :=
    if block_cnt ≠ 0#64 then
      { sha with
        state :=
          fd_sha512_core_ref.spec sha.state (n := block_cnt.toNat)
            (data.setWidth (1024 * block_cnt.toNat)) }
    else sha
  leftover sha sz data

/-- How many `fd_sha512_core` calls `append` makes. -/
def cores (sha : ShaState) (sz : BitVec 64) : Nat :=
  if sz = 0#64 then 0
  else
    if sha.bufUsed ≠ 0#64 then
      if sz.ult (128#64 - sha.bufUsed) then 0
      else 1 + if (sz - (128#64 - sha.bufUsed)) >>> 7 ≠ 0#64 then 1 else 0
    else if sz >>> 7 ≠ 0#64 then 1 else 0

end fd_sha512_append

open fd_sha512_append in
/-- The struct after appending the `sz` bytes `data`. -/
def fd_sha512_append.spec (sha : ShaState) (sz : BitVec 64) (data : BitVec (8 * sz.toNat)) :
    ShaState :=
  if sz = 0#64 then sha
  else
    let buf_used := sha.bufUsed
    let bit_cnt_lo := sha.bitCntLo + (sz <<< 3)
    let bit_cnt_hi :=
      sha.bitCntHi + (sz >>> 61) + (BitVec.ofBool (bit_cnt_lo.ult sha.bitCntLo)).setWidth 64
    let sha :=
      { sha with
        bitCntLo := bit_cnt_lo, bitCntHi := bit_cnt_hi }
    if buf_used ≠ 0#64 then
      let buf_rem := 128#64 - buf_used
      if sz.ult buf_rem then
        { sha with
          buf := copy sha.buf buf_used data, bufUsed := buf_used + sz }
      else
        let buf := copy sha.buf buf_used (data.setWidth (8 * buf_rem.toNat))
        bulk
          { sha with
            buf, state := fd_sha512_core_ref.spec (n := 1) sha.state buf, bufUsed := 0#64 }
          (sz - buf_rem) (data.extractLsb' (8 * buf_rem.toNat) (8 * (sz - buf_rem).toNat))
    else bulk sha sz data

end

/-! ## Proof -/

section Proof

namespace fd_sha512_append

/-! ### Sizes -/

theorem toNat_and_127 (n : BitVec 64) : (n &&& 127#64).toNat = n.toNat % 128 := by
  rw [BitVec.toNat_and, show (127#64).toNat = 2 ^ 7 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod]

theorem toNat_ushiftRight_7 (n : BitVec 64) : (n >>> 7).toNat = n.toNat / 128 := by
  rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]

theorem toNat_and_neg128 (n : BitVec 64) :
    (n &&& 18446744073709551488#64).toNat = n.toNat / 128 * 128 := by
  have h : n &&& 18446744073709551488#64 = n - (n &&& 127#64) := by bv_decide
  rw [h,
    BitVec.toNat_sub_of_le
      (by
        rw [BitVec.le_def, toNat_and_127]; omega),
    toNat_and_127]
  omega

/-! ### The leftover: `^bb7 … ^bb10` -/

/-- `^bb7`, the leftover of the `n` bytes at `d`. -/
abbrev hdr7 (sha d : Pointer) (n : BitVec 64) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  E[%1031 := .value 0#64, %1037 := .value 127#64, %1038 := .value 18446744073709551488#64,
    %1041 := .value (sha.add 200#64), %1063 := .value d, %1064 := .value n]

/-- "Buffer any leftover bytes", then return `sha`. -/
theorem leftover_block (sha data d : Pointer) (sz n : BitVec 64) (D : BitVec (8 * n.toNat))
    (M : MemoryState) (v : ShaState) (S : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (fd_sha512_append.args (.value sha) (.value data) (.value sz)).get)
    (hwf : S.WF) (hM : S.mem = M.storeSha sha v) (hMf : M.ShaFit sha)
    (hd : Fits S.mem d (8 * n.toNat)) (hdo : ¬d.offset.uaddOverflow n) (hsep : d.id ≠ sha.id)
    (hD : S.mem.readAt d (8 * n.toNat) = D) (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β)
    (hK :
      (PoisonOr.value
            (.cons (.value sha) .nil, { S with mem := M.storeSha sha (leftover v n D) }) >>=
          g) =
        K) :
    (fd_sha512_append.runFrom (hdr7 sha d n E) 7 S >>= g) = K := by
  subst hK
  have hSf : S.mem.ShaFit sha := hM ▸ hMf.storeSha
  block_init
  -- buf_used = sz & (FD_SHA512_PRIVATE_BUF_MAX-1UL);
  step_pure
  step_pure
  finish_block
  · block_init
    finish_block
    rw [show leftover v n D = v by simp [leftover, hbr], ← hM]
  · have htail : (n &&& 127#64).toNat < 128 := by
      rw [toNat_and_127]; omega
    have hoff : ¬d.offset.uaddOverflow (n &&& 18446744073709551488#64) :=
      BitVec.not_uaddOverflow_of_le hdo
        (by
          rw [toNat_and_neg128]; omega)
    have hsrc : Fits S.mem (d.add (n &&& 18446744073709551488#64)) (8 * (n &&& 127#64).toNat) :=
      Fits.add_of_le hoff
        (by
          rw [toNat_and_neg128, toNat_and_127]; omega)
        hd
    have hdst : Fits S.mem sha (8 * (n &&& 127#64).toNat) := hSf.fits_buf (by omega)
    have hX :
      S.mem.readAt (d.add (n &&& 18446744073709551488#64)) (8 * (n &&& 127#64).toNat) =
        D.extractLsb' (1024 * (n >>> 7).toNat) (8 * (n &&& 127#64).toNat) := by
      rw [MemoryState.readAt_add_of_readAt hd hoff
          (by
            rw [toNat_and_neg128, toNat_and_127]; omega)
          hD,
        toNat_and_neg128, toNat_ushiftRight_7]
      congr 1
      omega
    clear hD
    block_init
    -- fd_memcpy( buf, data + (block_cnt << FD_SHA512_PRIVATE_LG_BUF_MAX), buf_used );
    have hlt : n.toNat &&& 18446744073709551488 < 18446744073709551616 :=
      Nat.lt_of_le_of_lt Nat.and_le_left n.isLt
    step_pure
    step_pure [hlt, gep_value hoff]
    step_call using fd_memcpy.call_eq
    finish_block
    block_init
    -- sha->buf_used = buf_used;
    step_store
    finish_block
    block_init
    finish_block
    rw [hS, hM, MemoryState.storeSha_storeAt_buf_base hMf.2 (by omega),
      MemoryState.storeSha_storeAt_bufUsed hMf.2]
    simp only [leftover, ne_eq, hbr, not_false_eq_true, ite_true]
    rfl

/-! ### The bulk: `^bb5`, `^bb6` -/

/-- `^bb5`, the bulk of the `n` bytes at `d`. -/
abbrev hdr5 (sha d : Pointer) (n : BitVec 64) (E : ⟪Γ⟫) : ⟪Γ⟫ :=
  (hdr7 sha d n E)[%1036 := .value 7#64, %1040 := .value (sha.add 128#64)]

/-- "Append the bulk of the data", then the leftover. -/
theorem bulk_block (sha data d : Pointer) (sz n : BitVec 64) (D : BitVec (8 * n.toNat))
    (M : MemoryState) (v : ShaState) (S₁ : GlobalState) (E : ⟪Γ⟫)
    (hArgs : E.args = (fd_sha512_append.args (.value sha) (.value data) (.value sz)).get)
    (hwf : S₁.WF) (hM : S₁.mem = M.storeSha sha v) (hMf : M.ShaFit sha)
    (hd : Fits S₁.mem d (8 * n.toNat)) (hdo : ¬d.offset.uaddOverflow n) (hsep : d.id ≠ sha.id)
    (hD : S₁.mem.readAt d (8 * n.toNat) = D) (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β)
    (hK :
      (PoisonOr.value
            (.cons (.value sha) .nil,
              { alloc := ⟨S₁.alloc.nextFreeBlock + 2 * if n >>> 7 ≠ 0#64 then 1 else 0⟩,
                mem := M.storeSha sha (bulk v n D) }) >>=
          g) =
        K) :
    (fd_sha512_append.runFrom (hdr5 sha d n E) 5 S₁ >>= g) = K := by
  subst hK
  have hSf : S₁.mem.ShaFit sha := hM ▸ hMf.storeSha
  block_init
  -- ulong block_cnt = sz >> FD_SHA512_PRIVATE_LG_BUF_MAX;
  step_pure
  step_pure
  finish_block
  · -- block_cnt == 0
    have h0 : n >>> 7 = 0#64 := by
      have := hbr
      bv_decide
    step_loop using leftover_block sha data d sz n D M v (hK := ?_)
    simp [bulk, h0]
  · -- fd_sha512_core( state, data, block_cnt );
    have h0 : n >>> 7 ≠ 0#64 := by
      have := hbr
      bv_decide
    have hst := hSf.words8Fit
    have hblk : Fits S₁.mem d (1024 * (n >>> 7).toNat) :=
      hd.mono
        (by
          rw [toNat_ushiftRight_7]; omega)
    have hblko : d.offset.toNat + 128 * (n >>> 7).toNat < 2 ^ 64 := by
      rw [toNat_ushiftRight_7]
      simp [BitVec.uaddOverflow] at hdo
      omega
    block_init
    step_call using fd_sha512_core_ref.call_eq
    finish_block
    have hstate : S₁.mem.readWords8 (sha.add 128#64) = v.state := by
      rw [hM]
      exact congrArg ShaState.state (MemoryState.readSha_storeSha_self hMf)
    have hblock :
      S₁.mem.readAt d (1024 * (n >>> 7).toNat) = D.setWidth (1024 * (n >>> 7).toNat) := by
      rw [← hread_d]
      exact
        MemoryState.readAt_of_readAt_le
          (by
            rw [toNat_ushiftRight_7]; omega)
          hD
    rw [hstate, hblock, hM, MemoryState.storeSha_storeWords8_state] at hS
    have hM' := congrArg GlobalState.mem hS
    clear hread_d hblock hstate
    step_loop using leftover_block sha data d sz n D M _ (hK := ?_)
    simp [bulk, h0]

end fd_sha512_append

/-- `fd_sha512_append` appends the `sz` bytes at `data` to the struct at `sha` and returns `sha`.
Each `fd_sha512_core` call it makes leaves two blocks counted; `data` is in another block. -/
public theorem fd_sha512_append.call_eq (sha data : Pointer) (sz : BitVec 64) (s : GlobalState)
    (hwf : s.WF) (hsha : s.mem.ShaFit sha) (hu : (s.mem.readSha sha).bufUsed.toNat < 128)
    (hdata : Fits s.mem data (8 * sz.toNat)) (hdo : ¬data.offset.uaddOverflow sz)
    (hsep : data.id ≠ sha.id) :
    fd_sha512_append.call (fd_sha512_append.args (.value sha) (.value data) (.value sz)) s =
      .value
        (.cons (.value sha) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2 * fd_sha512_append.cores (s.mem.readSha sha) sz⟩,
            mem :=
              s.mem.storeSha sha
                (fd_sha512_append.spec (s.mem.readSha sha) sz
                  (s.mem.readAt data (8 * sz.toNat))) }) := by
  func_init
  have hsha₀ : S₀.mem.ShaFit sha := hS ▸ hsha
  have hu₀ : (S₀.mem.readSha sha).bufUsed.toNat < 128 := hS ▸ hu
  clear hu
  block_init
  iterate 9 step_pure
  finish_block
  · -- if( FD_UNLIKELY( !sz ) ) return sha;
    block_init
    finish_block
    subst hS hbr
    simp only [fd_sha512_append.spec, cores, ↓reduceIte, Nat.mul_zero, Nat.add_zero, hwf₀.eraseFrom,
      MemoryState.storeSha_readSha_self hsha₀]
  · have hsz : sz ≠ 0#64 := hbr
    block_init
    -- ulong buf_used = sha->buf_used; ulong bit_cnt_lo = …; ulong bit_cnt_hi = …;
    step_pure
    step_pure
    step_load with transparent buf_used
    step_pure
    step_load with transparent bit_cnt_lo
    step_pure
    step_load with transparent bit_cnt_hi
    -- new_bit_cnt_lo, new_bit_cnt_hi
    iterate 7 step_pure
    -- sha->bit_cnt_lo = new_bit_cnt_lo; sha->bit_cnt_hi = new_bit_cnt_hi;
    step_store
    step_store
    rw [MemoryState.storeAt_bitCntLo_eq hsha₀, MemoryState.storeSha_storeAt_bitCntHi hsha₀.2] at hS
    have hM := congrArg GlobalState.mem hS
    dsimp only at hM
    have hD : S.mem.readAt data (8 * sz.toNat) = S₀.mem.readAt data (8 * sz.toNat) := by
      rw [hM, MemoryState.readAt_storeSha_of_id_ne hsep]
    step_pure
    finish_block
    · -- buf_used == 0
      step_loop using fd_sha512_append.bulk_block sha data data sz sz _ S₀.mem _ (hK := ?_)
      refine ⟨by simp [cores, MemoryState.readSha, hbr, hsz], ?_⟩
      rw [MemoryState.eraseFrom_storeSha, hwf₀.eraseFrom]
      simp [fd_sha512_append.spec, hsz, MemoryState.readSha, hbr]
    · -- buf_used ≠ 0
      have hu0 := hbr
      have hu1 : (S₀.mem.readAt (sha.add 200#64) 64).toNat < 128 := hu₀
      have hov : ¬sha.offset.uaddOverflow (S₀.mem.readAt (sha.add 200#64) 64) :=
        BitVec.not_uaddOverflow_of_le hsha₀.2
          (by
            simp; omega)
      have hlt : (S₀.mem.readAt (sha.add 200#64) 64).toNat < 18446744073709551616 := by omega
      block_init
      -- ulong buf_rem = FD_SHA512_PRIVATE_BUF_MAX - buf_used;
      step_pure
      step_pure
      step_pure [hlt, gep_value hov]
      finish_block
      · -- if( FD_UNLIKELY( sz < buf_rem ) ): fd_memcpy( buf + buf_used, data, sz );
        have hbuf : Fits S.mem (sha.add (S₀.mem.readAt (sha.add 200#64) 64)) (8 * sz.toNat) :=
          Fits.add_of_le hov
            (by
              have := hbr; simp [BitVec.ult] at this; omega)
            hsha.1
        clear hM
        block_init
        step_call using fd_memcpy.call_eq consuming hD
        step_pure
        finish_block
        block_init
        -- sha->buf_used = buf_used + sz;
        step_store
        finish_block
        block_init
        finish_block
        have hb : (S₀.mem.readAt (sha.add 200#64) 64).toNat * 8 + 8 * sz.toNat ≤ 1024 := by
          have := hbr
          simp [BitVec.ult] at this
          omega
        rw [hS, MemoryState.storeSha_storeAt_buf hsha₀.2 hb,
          MemoryState.storeSha_storeAt_bufUsed hsha₀.2, MemoryState.eraseFrom_storeSha,
          hwf₀.eraseFrom]
        simp [fd_sha512_append.spec, cores, hsz, hbr, hu0, MemoryState.readSha, copy]
      · -- fd_memcpy( buf + buf_used, data, buf_rem ); data += buf_rem; sz -= buf_rem;
        have hrem :
          (128#64 - S₀.mem.readAt (sha.add 200#64) 64).toNat =
            128 - (S₀.mem.readAt (sha.add 200#64) 64).toNat := by
          rw [BitVec.toNat_sub_of_le
              (by
                rw [BitVec.le_def]; simp; omega)]
          rfl
        have hge : 128 - (S₀.mem.readAt (sha.add 200#64) 64).toNat ≤ sz.toNat := by
          have := hbr
          simp [BitVec.ult] at this
          omega
        have hbuf :
          Fits S.mem (sha.add (S₀.mem.readAt (sha.add 200#64) 64))
            (8 * (128#64 - S₀.mem.readAt (sha.add 200#64) 64).toNat) :=
          Fits.add_of_le hov
            (by
              rw [hrem]; omega)
            hsha.1
        have hsrc : Fits S.mem data (8 * (128#64 - S₀.mem.readAt (sha.add 200#64) 64).toNat) :=
          hdata.mono
            (by
              rw [hrem]; omega)
        have hov' : ¬data.offset.uaddOverflow (128#64 - S₀.mem.readAt (sha.add 200#64) 64) :=
          BitVec.not_uaddOverflow_of_le hdo
            (by
              rw [hrem]; omega)
        have hlt' : (128#64 - S₀.mem.readAt (sha.add 200#64) 64).toNat < 18446744073709551616 := by
          omega
        have hnuw : sz.usubOverflow (128#64 - S₀.mem.readAt (sha.add 200#64) 64) = false := by
          simp only [BitVec.usubOverflow, hrem, decide_eq_false_iff_not]; omega
        clear hM
        block_init
        step_call using fd_memcpy.call_eq consuming hsrc hbuf
        step_pure [hlt', gep_value hov']
        step_pure [hnuw]
        -- fd_sha512_core( state, buf, 1UL ); sha->buf_used = 0UL;
        have hst := hsha.words8Fit
        have h1 : Fits S.mem sha (1024 * (1#64).toNat) := hsha.fits_buf (by decide)
        have h1o : sha.offset.toNat + 128 * (1#64).toNat < 2 ^ 64 := by
          simp [BitVec.uaddOverflow] at hov ⊢
          have := hsha.2
          simp [BitVec.uaddOverflow] at this
          omega
        have h1d : (Range.of (sha.add 128#64) 512).Disjoint (Range.of sha (1024 * (1#64).toNat)) :=
          (Range.disjoint_sha_base hsha.2 (b := 128) (by decide) (by decide)).symm
        step_call using fd_sha512_core_ref.call_eq
        rw [MemoryState.storeSha_storeAt_buf hsha₀.2
            (by
              rw [hrem]; omega),
          MemoryState.readWords8_storeSha_state hsha₀, MemoryState.readAt_storeSha_buf hsha₀,
          MemoryState.storeSha_storeWords8_state] at hS
        step_store
        rw [MemoryState.storeSha_storeAt_bufUsed hsha₀.2] at hS
        have hM := congrArg GlobalState.mem hS
        dsimp only at hM
        have hD' :
          S.mem.readAt (data.add (128#64 - S₀.mem.readAt (sha.add 200#64) 64))
              (8 * (sz - (128#64 - S₀.mem.readAt (sha.add 200#64) 64)).toNat) =
            (S₀.mem.readAt data (8 * sz.toNat)).extractLsb'
              (8 * (128#64 - S₀.mem.readAt (sha.add 200#64) 64).toNat)
              (8 * (sz - (128#64 - S₀.mem.readAt (sha.add 200#64) 64)).toNat) := by
          have hsub :
            (sz - (128#64 - S₀.mem.readAt (sha.add 200#64) 64)).toNat =
              sz.toNat - (128#64 - S₀.mem.readAt (sha.add 200#64) 64).toNat :=
            BitVec.toNat_sub_of_le
              (by
                rw [BitVec.le_def]; omega)
          rw [MemoryState.readAt_add_of_readAt hdata hov'
              (by
                rw [hsub]; omega)
              hD]
          congr 1
          omega
        have hsub :
          (sz - (128#64 - S₀.mem.readAt (sha.add 200#64) 64)).toNat =
            sz.toNat - (128#64 - S₀.mem.readAt (sha.add 200#64) 64).toNat :=
          BitVec.toNat_sub_of_le
            (by
              rw [BitVec.le_def]; omega)
        have hd' :
          Fits S.mem (data.add (128#64 - S₀.mem.readAt (sha.add 200#64) 64))
            (8 * (sz - (128#64 - S₀.mem.readAt (sha.add 200#64) 64)).toNat) :=
          Fits.add_of_le hov'
            (by
              rw [hsub]; omega)
            hdata
        have hdo' :
          ¬(data.add (128#64 - S₀.mem.readAt (sha.add 200#64) 64)).offset.uaddOverflow
              (sz - (128#64 - S₀.mem.readAt (sha.add 200#64) 64)) :=
          Pointer.not_uaddOverflow_add_sub hdo (by omega)
        have hsep' : (data.add (128#64 - S₀.mem.readAt (sha.add 200#64) 64)).id ≠ sha.id := hsep
        have hpre :
          S₀.mem.readAt data (8 * (128#64 - S₀.mem.readAt (sha.add 200#64) 64).toNat) =
            (S₀.mem.readAt data (8 * sz.toNat)).setWidth _ :=
          MemoryState.readAt_of_readAt_le (by omega) rfl
        -- `buf_rem` and the size left as variables, so the step's simp keeps their `toNat`s folded
        clear hrem hge hlt' hov' h1o h1d hsub
        generalize hr : 128#64 - S₀.mem.readAt (sha.add 200#64) 64 = rem at *
        generalize hn : sz - rem = n at *
        finish_block
        step_loop using fd_sha512_append.bulk_block sha data _ sz _ _ S₀.mem _ (hK := ?_)
        refine ⟨?_, ?_⟩
        · simp only [cores, MemoryState.readSha, hsz, hr, hbr, hn]
          split <;> simp_all
        · rw [MemoryState.eraseFrom_storeSha, hwf₀.eraseFrom]
          simp only [fd_sha512_append.spec, MemoryState.readSha, ne_eq, hsz, hu0, not_false_eq_true,
            ite_true, ite_false]
          have hbr' : ¬sz.ult (128#64 - S₀.mem.readAt (sha.add 200#64) 64) = true := hr ▸ hbr
          simp only [hbr', Bool.false_eq_true, ite_false]
          rw [hr, hn, ← hpre]
          rfl

open fd_sha512_append in
/-- `append` leaves `buf_used` below a block, so calls chain. -/
public theorem fd_sha512_append.spec_bufUsed_lt (sha : ShaState) (sz : BitVec 64)
    (data : BitVec (8 * sz.toNat)) (h : sha.bufUsed.toNat < 128) :
    (fd_sha512_append.spec sha sz data).bufUsed.toNat < 128 := by
  have hl (sha : ShaState) (sz data) (h : sha.bufUsed.toNat < 128) :
    (leftover sha sz data).bufUsed.toNat < 128 := by
    unfold leftover
    dsimp only
    split
    · simp only [toNat_and_127]
      omega
    · exact h
  have hb (sha : ShaState) (sz data) (h : sha.bufUsed.toNat < 128) :
    (bulk sha sz data).bufUsed.toNat < 128 := by
    unfold bulk
    apply hl
    split <;> exact h
  unfold spec
  dsimp only
  split
  · exact h
  split
  · split
    · rename_i h₁ h₂
      simp only [BitVec.ult, decide_eq_true_eq] at h₂
      rw [BitVec.toNat_sub_of_le
          (by
            rw [BitVec.le_def]; simp; omega)] at h₂
      rw [BitVec.toNat_add_of_lt
          (by
            simp at h₂ ⊢; omega)]
      simp at h₂ ⊢
      omega
    · exact hb _ _ _ (by simp)
  · exact hb _ _ _ h

end Proof

end MLIR.Firedancer.Ref
