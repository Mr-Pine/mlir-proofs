module

public import MLIR.Semantics.Effectful.Memory.Operations
public import MLIR.Semantics.Effectful.Memory.Fits
import MLIR.Run.Tactic.Memory
public meta import MLIR.Run.Tactic.Util
public meta import Lean.Elab.Tactic
import Std.Data.ExtHashMap.Lemmas
public import Mathlib.Tactic.FinCases
public import Mathlib.Data.Fintype.Basic

namespace MLIR

@[expose] public section

/-- The five 64-bit limbs of a field element at `p`. Each limb's pointer is spelled as
`getelementptr` produces it (`p.add 8#64`, …), so facts, steps and specs match syntactically. -/
def MemoryState.readLimbs (m : MemoryState) (p : Pointer) : Fin 5 → BitVec 64
  | ⟨0, _⟩ => m.readAt p 64
  | ⟨1, _⟩ => m.readAt (p.add 8#64) 64
  | ⟨2, _⟩ => m.readAt (p.add 16#64) 64
  | ⟨3, _⟩ => m.readAt (p.add 24#64) 64
  | ⟨4, _⟩ => m.readAt (p.add 32#64) 64

/-- Store five 64-bit limbs at `p`, lowest first, as the lifted code does. -/
def MemoryState.storeLimbs (m : MemoryState) (p : Pointer) (x : Fin 5 → BitVec 64) : MemoryState :=
  (((((m.storeAt p (x 0)).storeAt (p.add 8#64) (x 1)).storeAt (p.add 16#64) (x 2)).storeAt
        (p.add 24#64) (x 3)).storeAt
    (p.add 32#64) (x 4))

/-- Each of the five limbs at `p` fits in `m`, and the limb offsets do not wrap (`getelementptr`
is poison when they do). Spelled out at the offsets `getelementptr` produces, so `simp_all` finds
each one after splitting the conjunction. -/
abbrev MemoryState.LimbsFit (m : MemoryState) (p : Pointer) : Prop :=
  p.offset.toNat + 32 < 2 ^ 64 ∧
    Fits m p 64 ∧
    Fits m (p.add 8#64) 64 ∧
    Fits m (p.add 16#64) 64 ∧ Fits m (p.add 24#64) 64 ∧ Fits m (p.add 32#64) 64

-- `simp [mlir_mem]` unfolds it, so goals and facts split into the same `Fits` conjuncts
attribute [mlir_mem] MemoryState.LimbsFit

/-- `storeLimbs` keeps the set of blocks, so the state stays `WF`. -/
@[mlir_transport]
theorem GlobalState.WF.storeLimbs {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storeLimbs p l } : GlobalState).WF := by
  unfold MemoryState.storeLimbs
  exact h.storeAt.storeAt.storeAt.storeAt.storeAt

/-- `WF.storeLimbs` for a state written as a constructor, which unifies first-order. -/
@[mlir_transport]
theorem GlobalState.WF.storeLimbs_mk {a : AllocState} {m : MemoryState}
    (h : (⟨a, m⟩ : GlobalState).WF) : (⟨a, m.storeLimbs p l⟩ : GlobalState).WF :=
  GlobalState.WF.storeLimbs (s := ⟨a, m⟩) h

/-- A limb's bit offset, when the limb offsets do not wrap. -/
theorem Pointer.offsetInBits_add_limb {p : Pointer} (h : p.offset.toNat + 32 < 2 ^ 64)
    (hk : k ≤ 32) : (p.add (BitVec.ofNat 64 k)).offsetInBits = 8 * p.offset.toNat + 8 * k := by
  simp only [Pointer.offsetInBits, Pointer.add, BitVec.toNat_add, BitVec.toNat_ofNat]
  rw [Nat.mod_eq_of_lt (by omega : k < 2 ^ 64), Nat.mod_eq_of_lt (by omega)]
  omega

/-- Inserting twice at a key keeps the second. -/
public theorem insert_insert_self (m : Std.ExtHashMap BlockId MemoryBlock) (k : BlockId)
    (v v' : MemoryBlock) : (m.insert k v).insert k v' = m.insert k v' := by
  apply Std.ExtHashMap.ext_getElem?
  intro a
  simp only [Std.ExtHashMap.getElem?_insert]
  split <;> rfl

open Memory in
/-- Storing limbs twice at the same place keeps the second: the limbs don't overlap. -/
theorem MemoryState.storeLimbs_storeLimbs_self {m : MemoryState} {p : Pointer} :
    (m.storeLimbs p l).storeLimbs p l' = m.storeLimbs p l' := by
  cases hb : m[p.id]? with
  | none =>
    have hn :
      ∀ {m' : MemoryState} {q : Pointer} {x : BitVec 64},
        m'[q.id]? = none → m'.storeAt q x = m' := by
      intro m' q x hq; simp [MemoryState.storeAt, hq]
    simp [MemoryState.storeLimbs, hn, hb]
  | some blk =>
    rw [MemoryState.getElem?_eq] at hb
    simp [MemoryState.storeLimbs, MemoryState.storeAt, MemoryState.getElem?_eq, hb,
      insert_insert_self]
    simp only [Pointer.offsetInBits]
    congr 2
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp only [getLsbD_spliceBits]
    grind

/-- Limbs in another block are unaffected by `storeLimbs`. -/
@[mlir_read]
theorem MemoryState.readLimbs_storeLimbs_of_id_ne {m : MemoryState} {p q : Pointer}
    (h : q.id ≠ p.id) : (m.storeLimbs q l).readLimbs p = m.readLimbs p := by
  funext i
  fin_cases i <;> simp only [MemoryState.readLimbs, MemoryState.storeLimbs, Tactic.readThroughStore]

/-! ### Limbs and `alloca` frames -/

/-- `alloca` adds a block under a fresh id: limbs that fit elsewhere still fit. -/
@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsFit.alloca {s : GlobalState} (hne : p.id ≠ s.allocaPtr.id)
    (h : s.mem.LimbsFit p) : (s.alloca n).mem.LimbsFit p := by
  have hf : ∀ {q : Pointer} {w}, q.id = p.id → Fits s.mem q w → Fits (s.alloca n).mem q w :=
    fun hq ⟨b, hb, hs⟩ =>
    ⟨b, by
      rw [GlobalState.getElem?_alloca (hq ▸ hne)]; exact hb, hs⟩
  obtain ⟨ho, h0, h1, h2, h3, h4⟩ := h
  exact ⟨ho, hf rfl h0, hf rfl h1, hf rfl h2, hf rfl h3, hf rfl h4⟩

/-- A 40-byte `alloca` holds one field element. -/
@[simp, mlir_mem, mlir_frame]
theorem MemoryState.limbsFit_allocaPtr {s : GlobalState} :
    (s.alloca 40).mem.LimbsFit s.allocaPtr := by
  refine ⟨by simp [GlobalState.allocaPtr], ?_, ?_, ?_, ?_, ?_⟩ <;>
    exact
      ⟨⟨40, 0⟩, by
        simp [GlobalState.alloca, GlobalState.allocaPtr, MemoryState.getElem?_eq, Pointer.add], by
        simp [Pointer.offsetInBits, GlobalState.allocaPtr, Pointer.add, MemoryBlock.lengthInBits]⟩

/-- Reading limbs elsewhere is unaffected by `alloca`. -/
@[mlir_frame, mlir_read]
theorem MemoryState.readLimbs_alloca {s : GlobalState} (hne : p.id ≠ s.allocaPtr.id) :
    (s.alloca n).mem.readLimbs p = s.mem.readLimbs p := by
  funext i
  fin_cases i <;>
    simp only [MemoryState.readLimbs, MemoryState.readAt, Pointer.add_id,
      GlobalState.getElem?_alloca hne]

/-- `storeLimbs` keeps every block and its length. -/
@[simp]
theorem Fits.storeLimbs_iff {m : MemoryState} : Fits (m.storeLimbs q l) p w ↔ Fits m p w := by
  simp [MemoryState.storeLimbs]

@[mlir_transport]
theorem Fits.storeLimbs {m : MemoryState} (h : Fits m p w) : Fits (m.storeLimbs q l) p w :=
  Fits.storeLimbs_iff.mpr h

/-- Stores never change a block's length: `LimbsFit` is the store chain's base's. -/
@[simp, mlir_state]
theorem MemoryState.limbsFit_storeLimbs_iff {m : MemoryState} :
    (m.storeLimbs q l).LimbsFit p ↔ m.LimbsFit p := by simp [MemoryState.LimbsFit]

/-- Limbs stored where they fit read back. -/
@[mlir_frame, mlir_read]
theorem MemoryState.readLimbs_storeLimbs_self {m : MemoryState} (h : m.LimbsFit p) :
    (m.storeLimbs p l).readLimbs p = l := by
  funext i
  fin_cases i <;>
    simp only [MemoryState.readLimbs, MemoryState.storeLimbs, Tactic.readThroughStore] <;>
    rfl

/-- Limbs stored in a fresh 40-byte `alloca` read back. -/
@[mlir_frame]
theorem MemoryState.readLimbs_storeLimbs_allocaPtr {s : GlobalState} :
    ((s.alloca 40).mem.storeLimbs s.allocaPtr l).readLimbs s.allocaPtr = l :=
  readLimbs_storeLimbs_self limbsFit_allocaPtr

/-- Erasing a frame commutes with storing limbs. -/
@[mlir_frame, mlir_erase]
theorem MemoryState.eraseFrom_storeLimbs {m : MemoryState} :
    (m.storeLimbs p l).eraseFrom n = (m.eraseFrom n).storeLimbs p l := by
  simp [MemoryState.storeLimbs, MemoryState.eraseFrom_storeAt]

/-- In a `WF` state there is no block at `allocaPtr` yet: storing limbs there does nothing. -/
@[mlir_frame]
theorem GlobalState.WF.storeLimbs_allocaPtr {s : GlobalState} (h : s.WF) :
    s.mem.storeLimbs s.allocaPtr l = s.mem := by
  unfold MemoryState.storeLimbs
  rw [h.storeAt_allocaPtr (p := s.allocaPtr) rfl,
    h.storeAt_allocaPtr (p := s.allocaPtr.add 8#64) rfl,
    h.storeAt_allocaPtr (p := s.allocaPtr.add 16#64) rfl,
    h.storeAt_allocaPtr (p := s.allocaPtr.add 24#64) rfl,
    h.storeAt_allocaPtr (p := s.allocaPtr.add 32#64) rfl]

/-- Storing limbs into an erased block does nothing. -/
@[mlir_frame, mlir_erase]
theorem MemoryState.storeLimbs_eraseFrom_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.eraseFrom n).storeLimbs p l = m.eraseFrom n := by
  simp [MemoryState.storeLimbs, MemoryState.storeAt_eraseFrom_of_le, Pointer.add, h]

/-- Limbs stored into the frame, dropped before the erase moves past them: moved first, they stay
above a store outside the frame. -/
@[mlir_erase high]
theorem MemoryState.eraseFrom_storeLimbs_of_le {m : MemoryState} (h : n ≤ p.id.id) :
    (m.storeLimbs p l).eraseFrom n = m.eraseFrom n := by
  rw [eraseFrom_storeLimbs, storeLimbs_eraseFrom_of_le h]

/-- `storeLimbs` keeps the set of blocks, so `WF` does not depend on it. -/
@[simp, mlir_mem]
theorem GlobalState.WF_storeLimbs {s : GlobalState} :
    ({ s with mem := m.storeLimbs p l } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF := by
  simp [MemoryState.storeLimbs]

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsFit.storeAt (h : MemoryState.LimbsFit m p) :
    MemoryState.LimbsFit (m.storeAt q x) p := by
  unfold MemoryState.LimbsFit at h ⊢
  simpa using h

/-- `storeLimbs` keeps every block and its length, so limbs that fit still fit. -/
@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsFit.storeLimbs (h : MemoryState.LimbsFit m p) :
    MemoryState.LimbsFit (m.storeLimbs q l) p := by
  unfold MemoryState.storeLimbs
  exact h.storeAt.storeAt.storeAt.storeAt.storeAt

/-- A 320-bit block from its start holds one field element. -/
theorem MemoryState.LimbsFit.of_fits {m : MemoryState} (h : Fits m p 320) (ho : p.offset = 0) :
    m.LimbsFit p := by
  have hov : ∀ off : BitVec 64, off.toNat ≤ 32 → ¬p.offset.uaddOverflow off := by
    intro off hoff
    simp [ho, BitVec.uaddOverflow]
    omega
  refine ⟨by simp [ho], h.mono (by omega), ?_, ?_, ?_, ?_⟩ <;>
    exact Fits.add_of_le (hov _ (by decide)) (by decide) h

/-- The limbs of a 320-bit read from a block's start: its 64-bit slices. -/
theorem MemoryState.readLimbs_of_readAt {m : MemoryState} {x : BitVec 320} (hf : Fits m p 320)
    (ho : p.offset = 0) (h : m.readAt p 320 = x) :
    m.readLimbs p = fun i => x.extractLsb' (64 * i.val) 64 := by
  have hov : ∀ off : BitVec 64, off.toNat ≤ 32 → ¬p.offset.uaddOverflow off := by
    intro off hoff
    simp [ho, BitVec.uaddOverflow]
    omega
  have hread (off : BitVec 64) (hoff : off.toNat ≤ 32) :=
    MemoryState.readAt_add_of_readAt (w := 64) hf (hov off hoff) (by omega) h
  funext i
  fin_cases i
  · simpa [MemoryState.readLimbs, Pointer.add] using hread 0#64 (by decide)
  · exact hread 8#64 (by decide)
  · exact hread 16#64 (by decide)
  · exact hread 24#64 (by decide)
  · exact hread 32#64 (by decide)

/-- The limbs of a field element global's block, read back: its initializer's limbs. -/
theorem MemoryState.readLimbs_of_readAt_flattenRaw {m : MemoryState} {v : Vector (BitVec 64) 5}
    {hw : (Ty.array 1 (.struct [.array 5 (.bv 64)])).width = 320} (hf : Fits m p 320)
    (ho : p.offset = 0)
    (h :
      m.readAt p 320 = Ty.flatBits (t := .array 1 (.struct [.array 5 (.bv 64)])) #v[v] (hw := hw)) :
    m.readLimbs p = fun i => v[i] := by
  rw [Ty.flatBits_eq] at h
  rw [MemoryState.readLimbs_of_readAt hf ho h]
  funext i
  fin_cases i <;>
    simp (disch := decide) only [BitVec.extractLsb'_cast, Ty.extractLsb'_flattenRaw_array,
      Ty.extractLsb'_flattenRaw_struct_singleton, Ty.extractLsb'_flattenRaw_bv] <;>
    simp [Ty.stride, Ty.width, Ty.fieldsWidth, Ty.padding, Ty.align, Ty.fieldsAlign]

/-- A new block keeps limbs that fit. -/
@[mlir_transport]
theorem MemoryState.LimbsFit.addBlock {s : GlobalState} {x : BitVec v} (hwf : s.WF)
    (h : s.mem.LimbsFit p) : (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).LimbsFit p := by
  rw [← GlobalState.alloca_storeAt_allocaPtr]
  exact
    MemoryState.LimbsFit.storeAt
      (MemoryState.LimbsFit.alloca (GlobalState.ne_allocaPtr_of_fits hwf h.2.1) h)

/-- Limbs that fit before a new block: the limbs before it. -/
@[mlir_read]
theorem MemoryState.readLimbs_addBlock {s : GlobalState} {x : BitVec v} (hwf : s.WF)
    (h : s.mem.LimbsFit p) :
    (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).readLimbs p = s.mem.readLimbs p := by
  obtain ⟨_, h0, h1, h2, h3, h4⟩ := h
  funext i
  fin_cases i
  · exact MemoryState.readAt_addBlock hwf h0
  · exact MemoryState.readAt_addBlock hwf h1
  · exact MemoryState.readAt_addBlock hwf h2
  · exact MemoryState.readAt_addBlock hwf h3
  · exact MemoryState.readAt_addBlock hwf h4

/-- Limbs outside a new block: the limbs before it. For a block below others added since the state
(a second global's), where `readLimbs_addBlock` does not match. -/
@[mlir_read]
theorem MemoryState.readLimbs_addBlock_of_id_ne {m : MemoryState} {x : BitVec v} (h : p.id ≠ b) :
    (m.addBlock b n x).readLimbs p = m.readLimbs p := by
  have h' (k : BitVec 64) : (p.add k).id ≠ b := by simpa [Pointer.add_id] using h
  funext i
  fin_cases i
  · exact MemoryState.readAt_addBlock_of_id_ne h
  all_goals exact MemoryState.readAt_addBlock_of_id_ne (h' _)

end

end MLIR
