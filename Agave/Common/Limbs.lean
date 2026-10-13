module

public import MLIR.Semantics.Effectful.Memory.Operations
public import Firedancer.Common.LimbBits
import Std.Data.ExtHashMap.Lemmas
import MLIR.Run.Tactic.Memory
import Std.Tactic.BVDecide

/-! `FieldElement51` in memory: `readLimbs`' five limbs, stored limb by limb or as `vector<2xi64>`
pairs (`Firedancer.Common.LimbBits`). -/

namespace MLIR.Agave

open Memory

@[expose] public section

attribute [mlir_read] MemoryState.readLimbs_storeAt_of_id_ne MemoryState.readAt_storeLimbs_self

/-- Two limb stores at distinct limbs commute. -/
theorem storeAt_limb_comm {m : MemoryState} {p : Pointer} (h : p.offset.toNat + 32 < 2 ^ 64)
    {j k : Nat} (hj : j ≤ 32) (hk : k ≤ 32) (hjk : j + 8 ≤ k ∨ k + 8 ≤ j) (x y : BitVec 64) :
    (m.storeAt (p.add (BitVec.ofNat 64 j)) x).storeAt (p.add (BitVec.ofNat 64 k)) y =
      (m.storeAt (p.add (BitVec.ofNat 64 k)) y).storeAt (p.add (BitVec.ofNat 64 j)) x := by
  apply MemoryState.storeAt_comm
  simp only [Range.Disjoint, Range.of, Pointer.add, Pointer.offsetInBits, BitVec.toNat_add,
    BitVec.toNat_ofNat]
  right
  rw [Nat.mod_eq_of_lt (by omega : j < 2 ^ 64), Nat.mod_eq_of_lt (by omega : k < 2 ^ 64),
    Nat.mod_eq_of_lt (by omega), Nat.mod_eq_of_lt (by omega)]
  omega

/-- A limb store past one at limb 0 commutes with it. -/
theorem storeAt_limb0_comm {m : MemoryState} {p : Pointer} (h : p.offset.toNat + 32 < 2 ^ 64)
    {k : Nat} (hk8 : 8 ≤ k) (hk : k ≤ 32) (x y : BitVec 64) :
    (m.storeAt (p.add (BitVec.ofNat 64 k)) y).storeAt p x =
      (m.storeAt p x).storeAt (p.add (BitVec.ofNat 64 k)) y := by
  have := storeAt_limb_comm (m := m) h (j := k) (k := 0) hk (by omega) (by omega) y x
  simpa only [Pointer.add_zero'] using this

/-- Limbs stored as the pair at byte 8, limb 0, then the pair at byte 24 (`sub`, `neg`). -/
theorem storeAt_pairs_eq_storeLimbs' {m : MemoryState} {p : Pointer}
    (h : p.offset.toNat + 32 < 2 ^ 64) (x0 : BitVec 64) (v12 v34 : Vector (BitVec 64) 2) :
    ((m.storeAt (p.add 8#64) (BitVec.packLanes v12)).storeAt p x0).storeAt (p.add 24#64)
        (BitVec.packLanes v34) =
      m.storeLimbs p fun
        | 0 => x0
        | 1 => v12[0]
        | 2 => v12[1]
        | 3 => v34[0]
        | 4 => v34[1] := by
  rw [MemoryState.storeAt_packLanes_limb h (k := 8#64) (by decide),
    MemoryState.storeAt_packLanes_limb h (k := 24#64) (by decide)]
  rw [show (8#64 + 8#64 : BitVec 64) = BitVec.ofNat 64 16 from rfl,
    storeAt_limb0_comm h (k := 16) (by omega) (by omega),
    storeAt_limb0_comm (m := m) h (k := 8) (by omega) (by omega)]
  rfl

end

end MLIR.Agave
