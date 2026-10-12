module

public import MLIR.Semantics.Effectful.Memory.Operations
public import MLIR.Semantics.Effectful.Memory.Fits
public import Firedancer.Avx512.Common.Vec
public import Firedancer.R52x5.Common.Limbs
public import Agave.Math.Field
import MLIR.Run.Tactic.Memory
import Mathlib.Tactic.FinCases

/-! The AVX2 `FieldElement2625x4` in memory: five `u32x8` registers 32 bytes apart, as
`vector<8xi32>` loads read them; `reduce64`'s argument, ten `u64x4`s 32 bytes apart, which its
callers store into a 320-byte slot; and a register's limbs as `unpack_pair` spreads them over
`u64x4` lanes. Each register's pointer is spelled as `getelementptr` produces it. -/

namespace MLIR

open Agave Firedancer.Avx512

@[expose] public section

/-- The eight 32-bit lanes at `p`, as a load of a `<8 x i32>` reads them. -/
def MemoryState.readU32x8 (m : MemoryState) (p : Pointer) : Vector (BitVec 32) 8 :=
  Vector.ofFn fun i => Ty.extractVecElem 8 32 i (m.readAt p 256)

/-- The five registers at `p`. -/
def MemoryState.readFe4 (m : MemoryState) (p : Pointer) : Fe2625x4
  | 0 => m.readU32x8 p
  | 1 => m.readU32x8 (p.add 32#64)
  | 2 => m.readU32x8 (p.add 64#64)
  | 3 => m.readU32x8 (p.add 96#64)
  | 4 => m.readU32x8 (p.add 128#64)

/-- Store five registers at `p`, lowest first, as the lifted code does. -/
def MemoryState.storeFe4 (m : MemoryState) (p : Pointer) (v : Fe2625x4) : MemoryState :=
  ((((m.storeAt p (BitVec.packLanes (v 0))).storeAt (p.add 32#64) (BitVec.packLanes (v 1))).storeAt
            (p.add 64#64) (BitVec.packLanes (v 2))).storeAt
        (p.add 96#64) (BitVec.packLanes (v 3))).storeAt
    (p.add 128#64) (BitVec.packLanes (v 4))

/-- Each register at `p` fits, and the register offsets do not wrap. -/
abbrev MemoryState.Fe4Fit (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 128 < 2 ^ 64 ∧
    Fits m p 256 ∧
    Fits m (p.add 32#64) 256 ∧
    Fits m (p.add 64#64) 256 ∧ Fits m (p.add 96#64) 256 ∧ Fits m (p.add 128#64) 256

/-- Room for the five registers at `p` (an output), and the register offsets do not wrap. -/
abbrev MemoryState.Fe4Room (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 128 < 2 ^ 64 ∧
    Room m p 256 ∧
    Room m (p.add 32#64) 256 ∧
    Room m (p.add 64#64) 256 ∧ Room m (p.add 96#64) 256 ∧ Room m (p.add 128#64) 256

/-- The ten `u64x4`s at `z`. -/
def MemoryState.readZ10 (m : MemoryState) (z : Pointer) : Fin 10 → Vector (BitVec 64) 4
  | 0 => m.readWv z
  | 1 => m.readWv (z.add 32#64)
  | 2 => m.readWv (z.add 64#64)
  | 3 => m.readWv (z.add 96#64)
  | 4 => m.readWv (z.add 128#64)
  | 5 => m.readWv (z.add 160#64)
  | 6 => m.readWv (z.add 192#64)
  | 7 => m.readWv (z.add 224#64)
  | 8 => m.readWv (z.add 256#64)
  | 9 => m.readWv (z.add 288#64)

/-- Store ten `u64x4`s at `z`, lowest first. -/
def MemoryState.storeZ10 (m : MemoryState) (z : Pointer) (v : Fin 10 → Vector (BitVec 64) 4) :
    MemoryState :=
  (((((((((m.storeAt z (BitVec.packLanes (v 0))).storeAt (z.add 32#64)
                                    (BitVec.packLanes (v 1))).storeAt
                                (z.add 64#64) (BitVec.packLanes (v 2))).storeAt
                            (z.add 96#64) (BitVec.packLanes (v 3))).storeAt
                        (z.add 128#64) (BitVec.packLanes (v 4))).storeAt
                    (z.add 160#64) (BitVec.packLanes (v 5))).storeAt
                (z.add 192#64) (BitVec.packLanes (v 6))).storeAt
            (z.add 224#64) (BitVec.packLanes (v 7))).storeAt
        (z.add 256#64) (BitVec.packLanes (v 8))).storeAt
    (z.add 288#64) (BitVec.packLanes (v 9))

/-- Each `u64x4` at `z` fits, and the offsets do not wrap. -/
abbrev MemoryState.Z10Fit (m : MemoryState) (z : Pointer) : Prop :=
  z.offset.toNat + 288 < 2 ^ 64 ∧
    Fits m z 256 ∧
    Fits m (z.add 32#64) 256 ∧
    Fits m (z.add 64#64) 256 ∧
    Fits m (z.add 96#64) 256 ∧
    Fits m (z.add 128#64) 256 ∧
    Fits m (z.add 160#64) 256 ∧
    Fits m (z.add 192#64) 256 ∧
    Fits m (z.add 224#64) 256 ∧ Fits m (z.add 256#64) 256 ∧ Fits m (z.add 288#64) 256

/-- `unpack_pair(v).0` as `u64x4` lanes: `v`'s lanes 0, 1, 4, 5 zero-extended, limb `2 i` of each
element for register `i`. -/
def unpackLo (v : Vector (BitVec 32) 8) : Vector (BitVec 64) 4 :=
  #v[0#32 ++ v[0], 0#32 ++ v[1], 0#32 ++ v[4], 0#32 ++ v[5]]

/-- `unpack_pair(v).1` as `u64x4` lanes: `v`'s lanes 2, 3, 6, 7 zero-extended, limb `2 i + 1`. -/
def unpackHi (v : Vector (BitVec 32) 8) : Vector (BitVec 64) 4 :=
  #v[0#32 ++ v[2], 0#32 ++ v[3], 0#32 ++ v[6], 0#32 ++ v[7]]

/-- `unpackLo v` doubled in its 32-bit lanes (`x.shl::<1>()`). -/
def unpackLo2 (v : Vector (BitVec 32) 8) : Vector (BitVec 64) 4 :=
  #v[0#32 ++ v[0] <<< 1, 0#32 ++ v[1] <<< 1, 0#32 ++ v[4] <<< 1, 0#32 ++ v[5] <<< 1]

/-- `unpackHi v` doubled in its 32-bit lanes (`twice(x)`, `x.shl::<1>()`). -/
def unpackHi2 (v : Vector (BitVec 32) 8) : Vector (BitVec 64) 4 :=
  #v[0#32 ++ v[2] <<< 1, 0#32 ++ v[3] <<< 1, 0#32 ++ v[6] <<< 1, 0#32 ++ v[7] <<< 1]

attribute [mlir_mem] MemoryState.Fe4Fit MemoryState.Fe4Room MemoryState.Z10Fit

/-- Ten stores, lowest first, as `storeZ10` of their values. -/
theorem MemoryState.storeZ10_eq {m : MemoryState} {z : Pointer}
    {z0 z1 z2 z3 z4 z5 z6 z7 z8 z9 : Vector (BitVec 64) 4} :
    (((((((((m.storeAt z (BitVec.packLanes z0)).storeAt (z.add 32#64) (BitVec.packLanes z1)).storeAt
                                    (z.add 64#64) (BitVec.packLanes z2)).storeAt
                                (z.add 96#64) (BitVec.packLanes z3)).storeAt
                            (z.add 128#64) (BitVec.packLanes z4)).storeAt
                        (z.add 160#64) (BitVec.packLanes z5)).storeAt
                    (z.add 192#64) (BitVec.packLanes z6)).storeAt
                (z.add 224#64) (BitVec.packLanes z7)).storeAt
            (z.add 256#64) (BitVec.packLanes z8)).storeAt
        (z.add 288#64) (BitVec.packLanes z9) =
      m.storeZ10 z ![z0, z1, z2, z3, z4, z5, z6, z7, z8, z9] :=
  rfl

/-! ### Through stores -/

/-- `storeFe4` keeps the set of blocks, so `WF` does not depend on it. -/
@[simp, mlir_mem]
theorem GlobalState.WF_storeFe4 {s : GlobalState} :
    ({ s with mem := m.storeFe4 p v } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF := by
  simp [MemoryState.storeFe4]

@[mlir_transport]
theorem GlobalState.WF.storeFe4 {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storeFe4 p v } : GlobalState).WF :=
  GlobalState.WF_storeFe4.mpr h

/-- `WF.storeFe4` for a state written as a constructor, which unifies first-order. -/
@[mlir_transport]
theorem GlobalState.WF.storeFe4_mk {a : AllocState} {m : MemoryState}
    (h : (⟨a, m⟩ : GlobalState).WF) : (⟨a, m.storeFe4 p v⟩ : GlobalState).WF :=
  GlobalState.WF.storeFe4 (s := ⟨a, m⟩) h

/-- `storeZ10` keeps the set of blocks, so `WF` does not depend on it. -/
@[simp, mlir_mem]
theorem GlobalState.WF_storeZ10 {s : GlobalState} :
    ({ s with mem := m.storeZ10 p v } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF := by
  simp [MemoryState.storeZ10]

/-- `storeFe4` keeps every block, its length and lifetime. -/
@[simp, mlir_state]
theorem Room.storeFe4_iff {m : MemoryState} : Room (m.storeFe4 q v) p w ↔ Room m p w := by
  simp [MemoryState.storeFe4]

@[mlir_transport]
theorem Room.storeFe4 {m : MemoryState} (h : Room m p w) : Room (m.storeFe4 q v) p w :=
  Room.storeFe4_iff.mpr h

/-- `storeFe4` keeps known bits known. -/
@[mlir_transport]
theorem Fits.storeFe4 {m : MemoryState} (h : Fits m p w) : Fits (m.storeFe4 q v) p w :=
  h.storeAt.storeAt.storeAt.storeAt.storeAt

@[mlir_transport]
theorem InBounds.storeFe4 {m : MemoryState} (h : InBounds m p w) : InBounds (m.storeFe4 q v) p w :=
  h.storeAt.storeAt.storeAt.storeAt.storeAt

/-- Lanes stored and read back. -/
theorem MemoryState.readU32x8_packLanes {m : MemoryState}
    (h : m.readAt p 256 = BitVec.packLanes v) : m.readU32x8 p = v := by
  rw [readU32x8, h]
  ext i hi
  simp [Ty.extractVecElem_packLanes (i := ⟨i, hi⟩)]

/-- Registers stored where there is room read back. -/
@[mlir_read]
theorem MemoryState.readFe4_storeFe4_self {m : MemoryState} (h : m.Fe4Room p) :
    (m.storeFe4 p v).readFe4 p = v := by
  obtain ⟨ho, h0, h1, h2, h3, h4⟩ := h
  funext i
  fin_cases i <;> refine MemoryState.readU32x8_packLanes ?_ <;>
    simp only [MemoryState.storeFe4, Tactic.readThroughStore] <;>
    rfl

/-- Registers in another block are unaffected by `storeFe4`. -/
@[mlir_read]
theorem MemoryState.readFe4_storeFe4_of_id_ne {m : MemoryState} (h : q.id ≠ p.id) :
    (m.storeFe4 q v).readFe4 p = m.readFe4 p := by
  funext i
  fin_cases i <;>
    simp only [MemoryState.readFe4, MemoryState.readU32x8, MemoryState.storeFe4,
      Tactic.readThroughStore]

/-- `u64x4`s stored where there is room read back. -/
@[mlir_read]
theorem MemoryState.readZ10_storeZ10_self {m : MemoryState} (ho : z.offset.toNat + 288 < 2 ^ 64)
    (h : Room m z 2560) : (m.storeZ10 z v).readZ10 z = v := by
  have hr (k : Nat) (hk : k ≤ 288) : Room m (z.add (BitVec.ofNat 64 k)) 256 :=
    Room.add_of_le
      (by
        simp [BitVec.uaddOverflow]; omega)
      (by
        simp; omega)
      h
  have h0 : Room m z 256 := h.mono (by decide)
  have h1 := hr 32 (by decide)
  have h2 := hr 64 (by decide)
  have h3 := hr 96 (by decide)
  have h4 := hr 128 (by decide)
  have h5 := hr 160 (by decide)
  have h6 := hr 192 (by decide)
  have h7 := hr 224 (by decide)
  have h8 := hr 256 (by decide)
  have h9 := hr 288 (by decide)
  clear hr h
  funext i
  fin_cases i <;> refine MemoryState.readWv_packLanes ?_ <;>
    simp only [MemoryState.storeZ10, Tactic.readThroughStore] <;>
    rfl

/-! ### Frames -/

/-- Erasing a frame commutes with storing registers. -/
@[mlir_frame, mlir_erase]
theorem MemoryState.eraseFrom_storeFe4 {m : MemoryState} :
    (m.storeFe4 p v).eraseFrom n = (m.eraseFrom n).storeFe4 p v := by
  simp [MemoryState.storeFe4, MemoryState.eraseFrom_storeAt]

/-- Storing registers into an erased block does nothing. -/
@[mlir_frame, mlir_erase]
theorem MemoryState.storeFe4_eraseFrom_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.eraseFrom n).storeFe4 p v = m.eraseFrom n := by
  simp [MemoryState.storeFe4, MemoryState.storeAt_eraseFrom_of_le, Pointer.add, h]

/-- Registers stored into the frame, dropped before the erase moves past them. -/
@[mlir_erase high]
theorem MemoryState.eraseFrom_storeFe4_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.storeFe4 p v).eraseFrom n = m.eraseFrom n := by
  rw [eraseFrom_storeFe4, storeFe4_eraseFrom_of_le h]

/-- Erasing a frame commutes with storing `u64x4`s. -/
@[mlir_frame, mlir_erase]
theorem MemoryState.eraseFrom_storeZ10 {m : MemoryState} :
    (m.storeZ10 p v).eraseFrom n = (m.eraseFrom n).storeZ10 p v := by
  simp [MemoryState.storeZ10, MemoryState.eraseFrom_storeAt]

/-- Storing `u64x4`s into an erased block does nothing. -/
@[mlir_frame, mlir_erase]
theorem MemoryState.storeZ10_eraseFrom_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.eraseFrom n).storeZ10 p v = m.eraseFrom n := by
  simp [MemoryState.storeZ10, MemoryState.storeAt_eraseFrom_of_le, Pointer.add, h]

/-- `u64x4`s stored into the frame (`reduce64`'s argument slot), dropped before the erase moves
past them. -/
@[mlir_erase high]
theorem MemoryState.eraseFrom_storeZ10_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.storeZ10 p v).eraseFrom n = m.eraseFrom n := by
  rw [eraseFrom_storeZ10, storeZ10_eraseFrom_of_le h]

/-- Reading registers elsewhere is unaffected by `alloca`. -/
@[mlir_frame, mlir_read]
theorem MemoryState.readFe4_alloca {s : GlobalState} (hne : p.id ≠ s.allocaPtr.id) :
    (s.alloca n d).mem.readFe4 p = s.mem.readFe4 p := by
  have hne' (k : BitVec 64) : (p.add k).id ≠ s.allocaPtr.id := by simpa [Pointer.add_id] using hne
  funext i
  fin_cases i <;>
    simp only [MemoryState.readFe4, MemoryState.readU32x8, MemoryState.readAt,
      GlobalState.getElem?_alloca hne, GlobalState.getElem?_alloca (hne' _)]

end

end MLIR
