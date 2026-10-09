module

public import Firedancer.Avx512.Common.Vec
public import Firedancer.Common.Limbs
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

/-- `storeWv` keeps every block and its length. -/
@[simp, mlir_state]
theorem Fits.storeWv_iff {m : MemoryState} : Fits (m.storeWv q v) p w ↔ Fits m p w := by
  simp [MemoryState.storeWv]

@[mlir_mem, mlir_transport]
theorem Fits.storeWv {m : MemoryState} (h : Fits m p w) : Fits (m.storeWv q v) p w :=
  Fits.storeWv_iff.mpr h

/-- A read of the stored lanes. -/
@[mlir_mem, mlir_read]
theorem MemoryState.readAt_storeWv_self {m : MemoryState} (h : Fits m p 256) :
    (m.storeWv p v).readAt p 256 = BitVec.packLanes v :=
  readAt_storeAt_self h _

/-- A read disjoint from the stored lanes. -/
@[mlir_mem, mlir_read]
theorem MemoryState.readAt_storeWv_disjoint {m : MemoryState}
    (h : (Range.of p 256).Disjoint (Range.of q w)) : (m.storeWv p v).readAt q w = m.readAt q w :=
  readAt_storeAt_disjoint h _

/-- Lanes stored where they fit read back. -/
@[mlir_state, mlir_frame, mlir_read]
theorem MemoryState.readWv_storeWv_self {m : MemoryState} (h : Fits m p 256) :
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
    (s.alloca n).mem.readWv p = s.mem.readWv p := by
  simp only [readWv, readAt, GlobalState.getElem?_alloca hne]

/-- Lanes outside a new block: the lanes before it. -/
@[mlir_read]
theorem MemoryState.readWv_addBlock_of_id_ne {m : MemoryState} {x : BitVec v} (h : p.id ≠ b) :
    (m.addBlock b n x).readWv p = m.readWv p := by simp only [readWv, readAt_addBlock_of_id_ne h]

/-- Lanes that fit before a new block: the lanes before it. -/
@[mlir_read]
theorem MemoryState.readWv_addBlock {s : GlobalState} {x : BitVec v} (hwf : s.WF)
    (h : Fits s.mem p 256) :
    (s.mem.addBlock ⟨s.alloc.nextFreeBlock⟩ n x).readWv p = s.mem.readWv p := by
  simp only [readWv, readAt_addBlock hwf h]

/-- A read of four lanes at byte `o` of a known read: its bits. -/
theorem MemoryState.readWv_add_of_readAt {m : MemoryState} {p : Pointer} {x : BitVec v}
    (hf : Fits m p v) (h : m.readAt p v = x) (hp : p.offset.toNat + o + 32 ≤ 2 ^ 64)
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

/-- A store of a value cast to an equal width is a store of the value. -/
theorem MemoryState.storeAt_cast {m : MemoryState} {x : BitVec w} (h : w = w') :
    m.storeAt p (x.cast h) = m.storeAt p x := by
  subst h; rfl

open Memory in
/-- Two adjacent stores are one store of both values, the later one above. -/
theorem MemoryState.storeAt_storeAt_append {m : MemoryState} {p : Pointer} {x : BitVec a}
    {y : BitVec b} (hov : ¬p.offset.uaddOverflow (BitVec.ofNat 64 k)) (ha : a = 8 * k)
    (hk : k < 2 ^ 64) :
    (m.storeAt p x).storeAt (p.add (BitVec.ofNat 64 k)) y = m.storeAt p (y ++ x) := by
  cases hb : m[p.id]? with
  | none =>
    have hn :
      ∀ {m' : MemoryState} {q : Pointer} {w} {z : BitVec w},
        m'[q.id]? = none → m'.storeAt q z = m' := by
      intro m' q w z hq
      simp [MemoryState.storeAt, hq]
    rw [hn hb, hn (q := p.add _) hb, hn hb]
  | some blk =>
    rw [MemoryState.getElem?_eq] at hb
    have hid : (p.add (BitVec.ofNat 64 k)).id = p.id := rfl
    have hoff : (p.add (BitVec.ofNat 64 k)).offsetInBits = p.offsetInBits + a := by
      rw [Pointer.offsetInBits_add hov, BitVec.toNat_ofNat, Nat.mod_eq_of_lt hk]
      omega
    have hsp :
      spliceBits (spliceBits blk.bytes p.offsetInBits x) (p.offsetInBits + a) y =
        spliceBits blk.bytes p.offsetInBits (y ++ x) := by
      apply BitVec.eq_of_getLsbD_eq
      intro i hi
      simp only [getLsbD_spliceBits, BitVec.getLsbD_append]
      grind
    simp only [MemoryState.storeAt, MemoryState.getElem?_eq, hb, hid,
      Std.ExtHashMap.getElem?_insert_self, hoff, hsp]
    congr 1
    apply Std.ExtHashMap.ext_getElem?
    intro j
    simp only [Std.ExtHashMap.getElem?_insert]
    split <;> rfl

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
theorem MemoryState.storeLimbsV_eq {m : MemoryState} (h : m.LimbsFit p) :
    m.storeLimbsV p l = m.storeLimbs p l := by
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
theorem Fits.storeLimbsV_iff {m : MemoryState} : Fits (m.storeLimbsV q l) p w ↔ Fits m p w := by
  simp [MemoryState.storeLimbsV, MemoryState.storeWv]

@[mlir_mem, mlir_transport]
theorem Fits.storeLimbsV {m : MemoryState} (h : Fits m p w) : Fits (m.storeLimbsV q l) p w :=
  Fits.storeLimbsV_iff.mpr h

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsFit.storeWv (h : MemoryState.LimbsFit m p) :
    MemoryState.LimbsFit (m.storeWv q v) p :=
  h.storeAt

@[mlir_mem, mlir_transport]
theorem MemoryState.LimbsFit.storeLimbsV (h : MemoryState.LimbsFit m p) :
    MemoryState.LimbsFit (m.storeLimbsV q l) p :=
  h.storeAt.storeAt

end

end MLIR
