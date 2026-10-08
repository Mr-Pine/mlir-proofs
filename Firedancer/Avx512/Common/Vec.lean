module

public import SSA.Projects.RIR.Semantics.Effectful.Memory.Operations
public import SSA.Projects.RIR.Semantics.Effectful.Memory.Fits
public import Firedancer.Avx512.Common.Wwl

/-! A `wwl_t` (an `fd_f25519_t`, 64 bytes) and a `wv_t` (32 bytes) in memory: read and store
functions in the shape the steps produce, and their lemmas for the step tactics. An object's fit
predicate is the plain `Fits m p 512` (`256`), which the framework already transports. -/

namespace LeanMLIR.RIR

@[expose] public section

open Firedancer.Avx512

/-- The eight lanes at `p`, as a load of a `<8 x i64>` reads them. -/
def MemoryState.readVec (m : MemoryState) (p : Pointer) : Wwl :=
  Vector.ofFn fun i => Ty.extractVecElem 8 64 i (m.readAt p 512)

/-- The four lanes at `p`, as a load of a `<4 x i64>` reads them. -/
def MemoryState.readWv (m : MemoryState) (p : Pointer) : Wv :=
  Vector.ofFn fun i => Ty.extractVecElem 4 64 i (m.readAt p 256)

/-- Store eight lanes at `p`, as a store of a `<8 x i64>` writes them. -/
def MemoryState.storeVec (m : MemoryState) (p : Pointer) (v : Wwl) : MemoryState :=
  m.storeAt p (BitVec.packLanes v)

/-- The lanes of a 512-bit read. -/
theorem MemoryState.readVec_eq_of_readAt {m : MemoryState} (h : m.readAt p 512 = x) :
    m.readVec p = Vector.ofFn fun i => Ty.extractVecElem 8 64 i x := by
  rw [readVec, h]

/-- Lanes stored and read back. -/
@[simp]
theorem MemoryState.readVec_packLanes {m : MemoryState} (h : m.readAt p 512 = BitVec.packLanes v) :
    m.readVec p = v := by
  rw [readVec_eq_of_readAt h]
  ext i hi
  simp [Ty.extractVecElem_packLanes (i := ⟨i, hi⟩)]

/-! ### Through `storeVec` -/

/-- `storeVec` keeps the set of blocks, so the state stays `WF`. -/
@[mlir_transport]
theorem GlobalState.WF.storeVec {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storeVec p v } : GlobalState).WF :=
  h.storeAt

/-- `WF.storeVec` for a state written as a constructor, which unifies first-order. -/
@[mlir_transport]
theorem GlobalState.WF.storeVec_mk {a : AllocState} {m : MemoryState}
    (h : (⟨a, m⟩ : GlobalState).WF) : (⟨a, m.storeVec p v⟩ : GlobalState).WF :=
  GlobalState.WF.storeVec (s := ⟨a, m⟩) h

/-- `storeVec` keeps the set of blocks, so `WF` does not depend on it. -/
@[simp, mlir_mem]
theorem GlobalState.WF_storeVec {s : GlobalState} :
    ({ s with mem := m.storeVec p v } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF := by
  simp [MemoryState.storeVec]

/-- `storeVec` keeps every block and its length. -/
@[simp, mlir_state]
theorem Fits.storeVec_iff {m : MemoryState} : Fits (m.storeVec q v) p w ↔ Fits m p w := by
  simp [MemoryState.storeVec]

@[mlir_mem, mlir_transport]
theorem Fits.storeVec {m : MemoryState} (h : Fits m p w) : Fits (m.storeVec q v) p w :=
  Fits.storeVec_iff.mpr h

/-- A read of the stored lanes. -/
@[mlir_mem, mlir_read]
theorem MemoryState.readAt_storeVec_self {m : MemoryState} (h : Fits m p 512) :
    (m.storeVec p v).readAt p 512 = BitVec.packLanes v :=
  readAt_storeAt_self h _

/-- A read disjoint from the stored lanes. -/
@[mlir_mem, mlir_read]
theorem MemoryState.readAt_storeVec_disjoint {m : MemoryState}
    (h : (Range.of p 512).Disjoint (Range.of q w)) :
    (m.storeVec p v).readAt q w = m.readAt q w :=
  readAt_storeAt_disjoint h _

/-- Lanes stored where they fit read back. -/
@[mlir_state, mlir_frame, mlir_read]
theorem MemoryState.readVec_storeVec_self {m : MemoryState} (h : Fits m p 512) :
    (m.storeVec p v).readVec p = v :=
  readVec_packLanes (readAt_storeVec_self h)

/-- Lanes in another block are unaffected by `storeVec`. -/
@[mlir_state, mlir_read]
theorem MemoryState.readVec_storeVec_of_id_ne {m : MemoryState} (h : q.id ≠ p.id) :
    (m.storeVec q v).readVec p = m.readVec p := by
  rw [readVec, readVec, readAt_storeVec_disjoint]
  simp [Range.Disjoint, Range.of, h]

/-! ### Frames -/

/-- Erasing a frame commutes with storing lanes. -/
@[mlir_frame, mlir_erase]
theorem MemoryState.eraseFrom_storeVec {m : MemoryState} :
    (m.storeVec p v).eraseFrom n = (m.eraseFrom n).storeVec p v :=
  eraseFrom_storeAt

/-- Storing lanes into an erased block does nothing. -/
@[mlir_frame, mlir_erase]
theorem MemoryState.storeVec_eraseFrom_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.eraseFrom n).storeVec p v = m.eraseFrom n :=
  storeAt_eraseFrom_of_le h

/-- Lanes stored into the frame, dropped before the erase moves past them. -/
@[mlir_erase high]
theorem MemoryState.eraseFrom_storeVec_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.storeVec p v).eraseFrom n = m.eraseFrom n :=
  eraseFrom_storeAt_of_le h

/-- In a `WF` state there is no block at `allocaPtr` yet: storing lanes there does nothing. -/
@[mlir_frame]
theorem GlobalState.WF.storeVec_allocaPtr {s : GlobalState} (h : s.WF) :
    s.mem.storeVec s.allocaPtr v = s.mem :=
  h.storeAt_allocaPtr rfl

/-- Reading lanes elsewhere is unaffected by `alloca`. -/
@[mlir_frame, mlir_read]
theorem MemoryState.readVec_alloca {s : GlobalState} (hne : p.id ≠ s.allocaPtr.id) :
    (s.alloca n).mem.readVec p = s.mem.readVec p := by
  simp only [readVec, readAt, GlobalState.getElem?_alloca hne]

end

end LeanMLIR.RIR
