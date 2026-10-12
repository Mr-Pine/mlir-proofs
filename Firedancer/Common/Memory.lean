module

public import MLIR.Semantics.Effectful.Memory.Operations
import Std.Data.ExtHashMap.Lemmas

/-! Changes of memory blocks, as stores and lifetime markers make them. -/

namespace MLIR

@[expose] public section

/-- Two changes of one block: their composition. -/
theorem MemoryState.modifyBlock_modifyBlock_self {m : MemoryState} {i : BlockId}
    {f g : MemoryBlock → MemoryBlock} :
    (m.modifyBlock i f).modifyBlock i g = m.modifyBlock i (g ∘ f) := by
  simp only [modifyBlock, MemoryState.mk.injEq, and_true]
  apply Std.ExtHashMap.ext_getElem?
  intro k
  simp only [Std.ExtHashMap.getElem?_modify, beq_iff_eq]
  split <;> simp_all [Option.map_map]

/-- Changes of two blocks commute. -/
theorem MemoryState.modifyBlock_comm {m : MemoryState} {i j : BlockId}
    {f g : MemoryBlock → MemoryBlock} (h : i ≠ j) :
    (m.modifyBlock i f).modifyBlock j g = (m.modifyBlock j g).modifyBlock i f := by
  simp only [modifyBlock, MemoryState.mk.injEq, and_true]
  apply Std.ExtHashMap.ext_getElem?
  intro k
  simp only [Std.ExtHashMap.getElem?_modify, beq_iff_eq]
  split <;> split <;> simp_all

open Memory in
/-- A second store to the same range overwrites the first. -/
theorem MemoryState.storeAt_storeAt_self {m : MemoryState} {p : Pointer} {x y : BitVec w} :
    (m.storeAt p x).storeAt p y = m.storeAt p y := by
  simp only [MemoryState.storeAt, MemoryState.modifyBlock_modifyBlock_self]
  congr 1
  funext blk
  simp only [Function.comp_apply, spliceBits_spliceBits_self]

open Memory in
/-- Two adjacent stores are one store of both values, the later one above. -/
theorem MemoryState.storeAt_storeAt_append {m : MemoryState} {p : Pointer} {x : BitVec a}
    {y : BitVec b} (hov : ¬p.offset.uaddOverflow (BitVec.ofNat 64 k)) (ha : a = 8 * k)
    (hk : k < 2 ^ 64) :
    (m.storeAt p x).storeAt (p.add (BitVec.ofNat 64 k)) y = m.storeAt p (y ++ x) := by
  have hoff : (p.add (BitVec.ofNat 64 k)).offsetInBits = p.offsetInBits + a := by
    rw [Pointer.offsetInBits_add hov, BitVec.toNat_ofNat, Nat.mod_eq_of_lt hk]
    omega
  have happ {n : Nat} (bs : BitVec n) (o : Nat) (x : BitVec a) (y : BitVec b) :
    spliceBits (spliceBits bs o x) (o + a) y = spliceBits bs o (y ++ x) := by
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp only [getLsbD_spliceBits, BitVec.getLsbD_append]
    grind
  have hones : BitVec.allOnes b ++ BitVec.allOnes a = BitVec.allOnes (b + a) := by
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp only [BitVec.getLsbD_append, BitVec.getLsbD_allOnes]
    split <;> simp <;> omega
  simp only [MemoryState.storeAt, Pointer.add_id,
    MemoryState.modifyBlock_modifyBlock_self]
  congr 1
  funext blk
  simp only [Function.comp_apply, hoff, happ, hones]

end

end MLIR
