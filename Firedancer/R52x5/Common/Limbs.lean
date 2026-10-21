module

public import Firedancer.Avx512.Common.Vec
public import Firedancer.Common.LimbBits
import Std.Data.ExtHashMap.Lemmas

/-! A `wl_t` stored in memory, and a `ulong[5]` stored as the compiled code does: limbs 0-3 as one
`<4 x i64>`, limb 4 after them. -/

namespace MLIR

@[expose] public section

open Firedancer.Avx512 (Wv)

/-- Store four lanes at `p`, as a store of a `<4 x i64>` writes them. -/
def MemoryState.storeWv (m : MemoryState) (p : Pointer) (v : Wv) : MemoryState :=
  m.storeAt p (BitVec.packLanes v)

/-- Store five limbs at `p`: limbs 0-3 as one vector, then limb 4. -/
def MemoryState.storeLimbsV (m : MemoryState) (p : Pointer) (l : Fin 5 → BitVec 64) : MemoryState :=
  (m.storeWv p #v[l 0, l 1, l 2, l 3]).storeAt (p.add 32#64) (l 4)

/-! ### Through `storeWv` -/

/-- Lanes stored and read back. -/
@[simp]
theorem MemoryState.readWv_packLanes {m : MemoryState} (h : m.readAt p 256 = BitVec.packLanes v) :
    m.readWv p = v := by
  rw [readWv, h]
  ext i hi
  simp [Ty.extractVecElem_packLanes (i := ⟨i, hi⟩)]

/-- `storeWv` keeps the set of blocks, so the state stays `WF`. -/
@[mlir_transport]
theorem GlobalState.WF.storeWv {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storeWv p v } : GlobalState).WF :=
  h.storeAt

/-- `WF.storeWv` for a state written as a constructor, which unifies first-order. -/
@[mlir_transport]
theorem GlobalState.WF.storeWv_mk {a : AllocState} {m : MemoryState}
    (h : (⟨a, m⟩ : GlobalState).WF) : (⟨a, m.storeWv p v⟩ : GlobalState).WF :=
  GlobalState.WF.storeWv (s := ⟨a, m⟩) h

/-- `storeWv` keeps the set of blocks, so `WF` does not depend on it. -/
@[simp, mlir_mem]
theorem GlobalState.WF_storeWv {s : GlobalState} :
    ({ s with mem := m.storeWv p v } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF := by
  simp [MemoryState.storeWv]

/-- `storeWv` keeps every block, its length and lifetime. -/
@[simp, mlir_state]
theorem Room.storeWv_iff {m : MemoryState} : Room (m.storeWv q v) p w ↔ Room m p w := by
  simp [MemoryState.storeWv]

@[mlir_mem, mlir_transport]
theorem Fits.storeWv {m : MemoryState} (h : Fits m p w) : Fits (m.storeWv q v) p w :=
  h.storeAt

@[mlir_mem, mlir_transport]
theorem Room.storeWv {m : MemoryState} (h : Room m p w) : Room (m.storeWv q v) p w :=
  h.storeAt

@[mlir_mem, mlir_transport]
theorem InBounds.storeWv {m : MemoryState} (h : InBounds m p w) : InBounds (m.storeWv q v) p w :=
  h.storeAt

/-- Lanes stored where there is room are known. -/
@[mlir_fresh, mlir_mem]
theorem Fits.storeWv_self {m : MemoryState} (h : Room m p 256) : Fits (m.storeWv p v) p 256 :=
  Fits.storeAt_self h

/-- A read of the stored lanes. -/
@[mlir_mem, mlir_read]
theorem MemoryState.readAt_storeWv_self {m : MemoryState} (h : Room m p 256) :
    (m.storeWv p v).readAt p 256 = BitVec.packLanes v :=
  readAt_storeAt_self h _

/-- A read disjoint from the stored lanes. -/
@[mlir_mem, mlir_read]
theorem MemoryState.readAt_storeWv_disjoint {m : MemoryState}
    (h : (Range.of p 256).Disjoint (Range.of q w)) : (m.storeWv p v).readAt q w = m.readAt q w :=
  readAt_storeAt_disjoint h _

/-- Lanes stored where there is room read back. -/
@[mlir_state, mlir_frame, mlir_read]
theorem MemoryState.readWv_storeWv_self {m : MemoryState} (h : Room m p 256) :
    (m.storeWv p v).readWv p = v :=
  readWv_packLanes (readAt_storeWv_self h)

/-- Lanes read apart from a store. -/
@[mlir_read]
theorem MemoryState.readWv_storeAt_disjoint {m : MemoryState} {x : BitVec w}
    (h : (Range.of q w).Disjoint (Range.of p 256)) : (m.storeAt q x).readWv p = m.readWv p := by
  rw [readWv, readWv, readAt_storeAt_disjoint h]

/-- Lanes read apart from stored lanes. -/
@[mlir_read]
theorem MemoryState.readWv_storeWv_disjoint {m : MemoryState}
    (h : (Range.of q 256).Disjoint (Range.of p 256)) : (m.storeWv q v).readWv p = m.readWv p :=
  readWv_storeAt_disjoint h

/-- Lanes in another block are unaffected by a store. -/
@[mlir_read]
theorem MemoryState.readWv_storeAt_of_id_ne {m : MemoryState} {x : BitVec w} (h : q.id ≠ p.id) :
    (m.storeAt q x).readWv p = m.readWv p :=
  readWv_storeAt_disjoint (Or.inl (by simpa [Range.of] using h))

/-- Lanes in another block are unaffected by `storeWv`. -/
@[mlir_state, mlir_read]
theorem MemoryState.readWv_storeWv_of_id_ne {m : MemoryState} (h : q.id ≠ p.id) :
    (m.storeWv q v).readWv p = m.readWv p :=
  readWv_storeAt_of_id_ne h

/-- Erasing a frame commutes with storing lanes. -/
@[mlir_frame, mlir_erase]
theorem MemoryState.eraseFrom_storeWv {m : MemoryState} :
    (m.storeWv p v).eraseFrom n = (m.eraseFrom n).storeWv p v :=
  eraseFrom_storeAt

/-- Storing lanes into an erased block does nothing. -/
@[mlir_frame, mlir_erase]
theorem MemoryState.storeWv_eraseFrom_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.eraseFrom n).storeWv p v = m.eraseFrom n :=
  storeAt_eraseFrom_of_le h

/-- Lanes stored into the frame, dropped before the erase moves past them. -/
@[mlir_erase high]
theorem MemoryState.eraseFrom_storeWv_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.storeWv p v).eraseFrom n = m.eraseFrom n :=
  eraseFrom_storeAt_of_le h

/-- In a `WF` state there is no block at `allocaPtr` yet: storing lanes there does nothing. -/
@[mlir_frame]
theorem GlobalState.WF.storeWv_allocaPtr {s : GlobalState} (h : s.WF) :
    s.mem.storeWv s.allocaPtr v = s.mem :=
  h.storeAt_allocaPtr rfl

/-- Reading lanes elsewhere is unaffected by `alloca`. -/
@[mlir_frame, mlir_read]
theorem MemoryState.readWv_alloca {s : GlobalState} (hne : p.id ≠ s.allocaPtr.id) :
    (s.alloca n d).mem.readWv p = s.mem.readWv p := by
  simp only [readWv, readAt, GlobalState.getElem?_alloca hne]

/-- A lifetime marker keeps the bits. -/
@[mlir_read]
theorem MemoryState.readWv_lifetimeStart {m : MemoryState} :
    (m.lifetimeStart q).readWv p = m.readWv p := by simp only [readWv, readAt_lifetimeStart]

/-- A lifetime marker keeps the bits. -/
@[mlir_read]
theorem MemoryState.readWv_lifetimeEnd {m : MemoryState} :
    (m.lifetimeEnd q).readWv p = m.readWv p := by simp only [readWv, readAt_lifetimeEnd]

/-- Lanes outside a new block: the lanes before it. -/
@[mlir_read]
theorem MemoryState.readWv_addBlock_of_id_ne {m : MemoryState} {x : BitVec v} (h : p.id ≠ b) :
    (m.addBlock b n x).readWv p = m.readWv p := by simp only [readWv, readAt_addBlock_of_id_ne h]

/-- Lanes in bounds before a new block: the lanes before it. -/
@[mlir_read]
theorem MemoryState.readWv_addBlock {s : GlobalState} {x : BitVec v} (hwf : s.WF)
    (h : InBounds s.mem p 256) :
    (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).readWv p = s.mem.readWv p := by
  simp only [readWv, readAt_addBlock hwf h]

/-- A read of four lanes at byte `o` of a known read: its bits. -/
theorem MemoryState.readWv_add_of_readAt {m : MemoryState} {p : Pointer} {x : BitVec v}
    (hf : InBounds m p v) (h : m.readAt p v = x) (hp : p.offset.toNat + o + 32 ≤ 2 ^ 64)
    (hv : 8 * o + 256 ≤ v) :
    m.readWv (p.add (BitVec.ofNat 64 o)) =
      Vector.ofFn fun i => x.extractLsb' (8 * o + 64 * i.val) 64 := by
  have ho : (BitVec.ofNat 64 o).toNat = o := by
    simp; omega
  rw [MemoryState.readWv,
    MemoryState.readAt_add_of_readAt hf
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by
        rw [ho]; omega)
      h,
    ho]
  apply Vector.ext
  intro i hi
  simp only [Vector.getElem_ofFn, Ty.extractVecElem_eq]
  apply BitVec.eq_of_getLsbD_eq
  intro j hj
  simp only [BitVec.getLsbD_extractLsb', hj, decide_true, Bool.true_and,
    show i * 64 + j < 256 by omega]
  congr 1
  omega

/-! ### `storeLimbsV` -/

/-- Four lanes' bits, lane 0 lowest. -/
theorem BitVec.packLanes_four (a b c d : BitVec 64) :
    BitVec.packLanes #v[a, b, c, d] = (d ++ (c ++ (b ++ a))).cast (by decide) := by
  have key (k : Nat) (hk : k < 4) (j : Nat) (hj : j < 64) :
    (BitVec.packLanes #v[a, b, c, d]).getLsbD (k * 64 + j) = #v[a, b, c, d][k].getLsbD j := by
    rw [← BitVec.extractLsb'_packLanes #v[a, b, c, d] k hk, BitVec.getLsbD_extractLsb']
    simp [hj]
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have hk := key (i / 64) (by omega) (i % 64) (by omega)
  rw [show i / 64 * 64 + i % 64 = i by omega] at hk
  rw [hk, BitVec.getLsbD_cast]
  obtain h | h | h | h : i / 64 = 0 ∨ i / 64 = 1 ∨ i / 64 = 2 ∨ i / 64 = 3 := by omega
  all_goals
    simp only [h, BitVec.getLsbD_append, Vector.getElem_mk, List.getElem_toArray,
      List.getElem_cons_zero, List.getElem_cons_succ]
    grind

/-- The vector store of limbs is the five limb stores. -/
theorem MemoryState.storeLimbsV_eq {m : MemoryState} (h : m.LimbsRoom p) :
    m.storeLimbs p l = m.storeLimbsV p l := by
  have hov (k : Nat) (hk : k ≤ 32) : ¬p.offset.uaddOverflow (BitVec.ofNat 64 k) := by
    have := h.1
    simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, decide_eq_true_eq]
    omega
  simp only [storeLimbsV, storeLimbs, storeWv, BitVec.packLanes_four, storeAt_cast]
  rw [show (8#64 : BitVec 64) = BitVec.ofNat 64 8 from rfl,
    show (16#64 : BitVec 64) = BitVec.ofNat 64 16 from rfl,
    show (24#64 : BitVec 64) = BitVec.ofNat 64 24 from rfl,
    storeAt_storeAt_append (hov 8 (by omega)) rfl (by omega),
    storeAt_storeAt_append (hov 16 (by omega)) rfl (by omega),
    storeAt_storeAt_append (hov 24 (by omega)) rfl (by omega)]

/-- Limbs 0-3 stored and read back as one `<4 x i64>`. -/
theorem MemoryState.readAt_storeLimbs_wv {m : MemoryState} {p : Pointer} (h : m.LimbsRoom p) :
    (m.storeLimbs p l).readAt p 256 = BitVec.packLanes #v[l 0, l 1, l 2, l 3] := by
  have hf : Room m p 256 := h.room320.mono (by omega)
  rw [MemoryState.storeLimbsV_eq h, MemoryState.storeLimbsV, MemoryState.readAt_storeAt_disjoint,
    MemoryState.readAt_storeWv_self hf]
  simp only [Range.Disjoint, Range.of]
  right; right
  rw [show (32#64 : BitVec 64) = BitVec.ofNat 64 32 from rfl,
    Pointer.offsetInBits_add_limb h.1 (by omega)]
  unfold Pointer.offsetInBits
  omega

/-- `storeLimbsV` keeps the set of blocks, so the state stays `WF`. -/
@[mlir_transport]
theorem GlobalState.WF.storeLimbsV {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storeLimbsV p l } : GlobalState).WF :=
  h.storeAt.storeAt

/-- `storeLimbsV` keeps the set of blocks, so `WF` does not depend on it. -/
@[simp, mlir_mem]
theorem GlobalState.WF_storeLimbsV {s : GlobalState} :
    ({ s with mem := m.storeLimbsV p l } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF := by
  simp [MemoryState.storeLimbsV, MemoryState.storeWv]

@[simp, mlir_state]
theorem Room.storeLimbsV_iff {m : MemoryState} : Room (m.storeLimbsV q l) p w ↔ Room m p w := by
  simp [MemoryState.storeLimbsV, MemoryState.storeWv]

@[mlir_mem, mlir_transport]
theorem Fits.storeLimbsV {m : MemoryState} (h : Fits m p w) : Fits (m.storeLimbsV q l) p w :=
  h.storeAt.storeAt

@[mlir_mem, mlir_transport]
theorem Room.storeLimbsV {m : MemoryState} (h : Room m p w) : Room (m.storeLimbsV q l) p w :=
  h.storeAt.storeAt

@[mlir_mem, mlir_transport]
theorem InBounds.storeLimbsV {m : MemoryState} (h : InBounds m p w) :
    InBounds (m.storeLimbsV q l) p w :=
  h.storeAt.storeAt

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsFit.storeWv (h : MemoryState.LimbsFit m p) :
    MemoryState.LimbsFit (m.storeWv q v) p :=
  h.storeAt

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsFit.storeVec (h : MemoryState.LimbsFit m p) :
    MemoryState.LimbsFit (m.storeVec q v) p :=
  h.storeAt

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsFit.storeLimbsV (h : MemoryState.LimbsFit m p) :
    MemoryState.LimbsFit (m.storeLimbsV q l) p :=
  h.storeAt.storeAt

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsRoom.storeWv (h : MemoryState.LimbsRoom m p) :
    MemoryState.LimbsRoom (m.storeWv q v) p :=
  h.storeAt

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsRoom.storeVec (h : MemoryState.LimbsRoom m p) :
    MemoryState.LimbsRoom (m.storeVec q v) p :=
  h.storeAt

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsRoom.storeLimbsV (h : MemoryState.LimbsRoom m p) :
    MemoryState.LimbsRoom (m.storeLimbsV q l) p :=
  h.storeAt.storeAt

-- the Fit-to-Room projection last among the transports (see `Firedancer.Common.Point`)
attribute [-mlir_transport] MemoryState.LimbsFit.room

attribute [mlir_transport] MemoryState.LimbsFit.room

/-- Lane `k` of a `<4 x i64>` slot `t`: in its `Fits`. -/
theorem Fits.wl_lane {m : MemoryState} {t : Pointer} (h : Fits m t 256) (ho : t.offset = 0)
    (hk : k < 4) : Fits m (t.add (BitVec.ofNat 64 (k * 8))) 64 :=
  Fits.add_of_le
    (by
      simp [BitVec.uaddOverflow, ho]; omega)
    (by
      simp; omega)
    h

/-- Lane `k` of a `<4 x i64>` slot `t` holding `x`: `x[k]`. -/
theorem MemoryState.readAt_wl_lane {m : MemoryState} {t : Pointer} {x : Vector (BitVec 64) 4}
    (h : Fits m t 256) (ho : t.offset = 0) (hr : m.readAt t 256 = BitVec.packLanes x) (hk : k < 4) :
    m.readAt (t.add (BitVec.ofNat 64 (k * 8))) 64 = x[k] := by
  rw [MemoryState.readAt_add_of_readAt h.inBounds
      (by
        simp [BitVec.uaddOverflow, ho]; omega)
      (by
        simp; omega)
      hr]
  have e : (BitVec.ofNat 64 (k * 8)).toNat * 8 = k * 64 := by
    simp; omega
  rw [e, BitVec.extractLsb'_packLanes x k hk]

end

end MLIR
