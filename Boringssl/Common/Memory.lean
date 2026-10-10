module

public import MLIR.Semantics.Effectful.Memory.Operations
import Std.Data.ExtHashMap.Lemmas

/-! Memory lemmas the BoringSSL proofs share. -/

namespace MLIR

open Memory

@[expose] public section

/-- A store of no bits changes nothing. -/
theorem MemoryState.storeAt_of_width_zero {m : MemoryState} {p : Pointer} {x : BitVec w}
    (hw : w = 0) : m.storeAt p x = m := by
  subst hw
  have hs {n : Nat} (b : BitVec n) (o : Nat) (y : BitVec 0) : spliceBits b o y = b := by
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp only [getLsbD_spliceBits]
    split <;>
      first
      | rfl
      | omega
  simp only [MemoryState.storeAt, MemoryState.storeDef, MemoryState.modifyBlock, hs]
  congr 1
  apply Std.ExtHashMap.ext_getElem?
  intro k
  simp only [Std.ExtHashMap.getElem?_modify]
  split <;> simp_all

end

end MLIR
