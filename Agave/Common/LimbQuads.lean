module

public import Agave.Common.Limbs
import MLIR.Run.Tactic.Memory
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! `FieldElement51` as the AVX2 build loads and stores it: `vector<4xi64>` quads of adjacent
limbs, at limb 0 or limb 1, and the remaining limb. -/

namespace MLIR.Agave

open Memory

@[expose] public section

/-- The limb quad at byte `k ≤ 8` fits. -/
theorem fits_quad {m : MemoryState} {p : Pointer} (h : m.LimbsFit p) {k : BitVec 64}
    (hk : k.toNat ≤ 8) : Fits m (p.add k) 256 :=
  Fits.add_of_le (not_uaddOverflow_limb h.1 (by omega)) (by omega) (fits_of_limbsFit h)

/-- Room for the limb quad at byte `k ≤ 8`. -/
theorem room_quad {m : MemoryState} {p : Pointer} (h : m.LimbsRoom p) {k : BitVec 64}
    (hk : k.toNat ≤ 8) : Room m (p.add k) 256 :=
  Room.add_of_le (not_uaddOverflow_limb h.1 (by omega)) (by omega) (room_of_limbsRoom h)

/-- The first limb quad fits. -/
theorem fits_quad0 {m : MemoryState} {p : Pointer} (h : m.LimbsFit p) : Fits m p 256 :=
  (fits_of_limbsFit h).mono (by decide)

/-- Room for the first limb quad. -/
theorem room_quad0 {m : MemoryState} {p : Pointer} (h : m.LimbsRoom p) : Room m p 256 :=
  (room_of_limbsRoom h).mono (by decide)

/-- Lane `i` of the quad at limb 0: limb `i`. -/
theorem lane_readAt0 {m : MemoryState} {p : Pointer} (h : m.LimbsFit p) (i : Fin 4) :
    Ty.extractVecElem 4 64 i (m.readAt p 256) = m.readLimbs p ⟨i, by omega⟩ := by
  rw [MemoryState.readAt_of_readAt_le (w := 256) (v := 320) (by decide) (readAt_eq_limbsBits h),
    Ty.extractVecElem_eq]
  fin_cases i <;> simp only [limbsBits, MemoryState.readLimbs] <;> bv_decide

/-- Lane `i` of the quad at limb 1: limb `i + 1`. -/
theorem lane_readAt8 {m : MemoryState} {p : Pointer} (h : m.LimbsFit p) (i : Fin 4) :
    Ty.extractVecElem 4 64 i (m.readAt (p.add 8#64) 256) = m.readLimbs p ⟨i + 1, by omega⟩ := by
  rw [MemoryState.readAt_add_of_readAt (fits_of_limbsFit h).inBounds
      (not_uaddOverflow_limb h.1 (by decide)) (by decide) (readAt_eq_limbsBits h),
    Ty.extractVecElem_eq]
  fin_cases i <;> simp only [limbsBits, MemoryState.readLimbs] <;> bv_decide

/-- A packed quad: its four lanes, the first lowest. -/
theorem packLanes_four (v : Vector (BitVec 64) 4) :
    BitVec.packLanes v = v[3] ++ (v[2] ++ (v[1] ++ v[0])) := by
  simp only [BitVec.packLanes, Vector.tail_eq_cast_extract, Vector.getElem_cast,
    Vector.getElem_extract, Nat.reduceAdd]
  generalize v[0] = a, v[1] = b, v[2] = c, v[3] = d
  bv_decide

/-- A store of a packed quad: the stores of its four lanes. -/
theorem storeAt_packLanes4 {m : MemoryState} {q : Pointer} (h : q.offset.toNat + 24 < 2 ^ 64)
    (v : Vector (BitVec 64) 4) :
    m.storeAt q (BitVec.packLanes v) =
      (((m.storeAt q v[0]).storeAt (q.add 8#64) v[1]).storeAt (q.add 16#64) v[2]).storeAt
        (q.add 24#64) v[3] := by
  have hov (k : Nat) (hk : k ≤ 24) : ¬q.offset.uaddOverflow (BitVec.ofNat 64 k) := by
    simp only [BitVec.uaddOverflow, BitVec.toNat_ofNat, ge_iff_le, decide_eq_true_eq, Nat.not_le]
    rw [Nat.mod_eq_of_lt (by omega)]
    omega
  rw [MemoryState.storeAt_storeAt_append (hov 8 (by omega)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (hov 16 (by omega)) rfl (by decide),
    MemoryState.storeAt_storeAt_append (hov 24 (by omega)) rfl (by decide), packLanes_four]

/-- Limbs stored as the quad at byte 0 and the last limb (`add`, `conditional_assign`). -/
theorem storeAt_quad_eq_storeLimbs {m : MemoryState} {p : Pointer}
    (h : p.offset.toNat + 32 < 2 ^ 64) (v : Vector (BitVec 64) 4) (x4 : BitVec 64) :
    (m.storeAt p (BitVec.packLanes v)).storeAt (p.add 32#64) x4 =
      m.storeLimbs p fun
        | 0 => v[0]
        | 1 => v[1]
        | 2 => v[2]
        | 3 => v[3]
        | 4 => x4 := by
  rw [storeAt_packLanes4 (by omega)]
  rfl

/-- Limbs stored as limb 0 and the quad at byte 8 (`sub`, `neg`). -/
theorem storeAt_quad8_eq_storeLimbs {m : MemoryState} {p : Pointer}
    (h : p.offset.toNat + 32 < 2 ^ 64) (x0 : BitVec 64) (v : Vector (BitVec 64) 4) :
    (m.storeAt p x0).storeAt (p.add 8#64) (BitVec.packLanes v) =
      m.storeLimbs p fun
        | 0 => x0
        | 1 => v[0]
        | 2 => v[1]
        | 3 => v[2]
        | 4 => v[3] := by
  rw [storeAt_packLanes4
      (by
        simp only [Pointer.add, BitVec.toNat_add]
        rw [Nat.mod_eq_of_lt
            (by
              simp; omega)]
        simp
        omega),
    Pointer.add_add, Pointer.add_add, Pointer.add_add]
  rfl

end

end MLIR.Agave
