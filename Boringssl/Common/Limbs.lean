module

public import MLIR.Semantics.Effectful.Memory.Operations
public import Firedancer.Common.LimbBits
import Std.Data.ExtHashMap.Lemmas
import Std.Tactic.BVDecide
import Mathlib.Tactic.FinCases

/-! A field element's limbs as one 320-bit store and read, as the fiat code moves them. -/

namespace MLIR

open Memory

@[expose] public section

/-- A 320-bit store from `p`: the five limbs' stores. -/
theorem MemoryState.storeAt_eq_storeLimbs {m : MemoryState} {p : Pointer}
    (h : p.offset.toNat + 32 < 2 ^ 64) (x : BitVec 320) :
    m.storeAt p x = m.storeLimbs p fun i => x.extractLsb' (64 * i.val) 64 := by
  have hx :
    x =
      x.extractLsb' 256 64 ++ x.extractLsb' 192 64 ++ x.extractLsb' 128 64 ++ x.extractLsb' 64 64 ++
        x.extractLsb' 0 64 := by
    bv_decide
  have hov (k : BitVec 64) (hk : k.toNat ≤ 32) (j : BitVec 64) (hj : j.toNat + k.toNat ≤ 32) :
    ¬(p.add j).offset.uaddOverflow k := by
    simp only [Pointer.add, BitVec.uaddOverflow, ge_iff_le, decide_eq_true_eq, Nat.not_le,
      BitVec.toNat_add]
    rw [Nat.mod_eq_of_lt (by omega)]
    omega
  conv_lhs => rw [hx]
  rw [MemoryState.storeAt_append (off := 8#64) (Pointer.not_uaddOverflow_of_limbs h (by decide))
      (by decide),
    MemoryState.storeAt_append (off := 8#64) (hov 8#64 (by decide) 8#64 (by decide)) (by decide)]
  simp only [Pointer.add_add, BitVec.reduceAdd]
  rw [MemoryState.storeAt_append (off := 8#64) (hov 8#64 (by decide) 16#64 (by decide)) (by decide)]
  simp only [Pointer.add_add, BitVec.reduceAdd]
  rw [MemoryState.storeAt_append (off := 8#64) (hov 8#64 (by decide) 24#64 (by decide)) (by decide)]
  simp only [Pointer.add_add, BitVec.reduceAdd, MemoryState.storeLimbs]
  rfl

/-- A 320-bit read of limbs that fit: their reads. -/
theorem MemoryState.LimbsFit.extractLsb'_readAt {m : MemoryState} (h : m.LimbsFit p) :
    (fun i : Fin 5 => (m.readAt p 320).extractLsb' (64 * i.val) 64) = m.readLimbs p := by
  have hf := h.fits
  have hr (k : BitVec 64) (hk : k.toNat ≤ 32) :=
    MemoryState.readAt_add_of_readAt (w := 64) hf.inBounds
      (Pointer.not_uaddOverflow_of_limbs h.1 hk) (by omega) rfl
  funext i
  fin_cases i
  · show _ = m.readAt p 64
    rw [MemoryState.readAt_of_readAt_le (w := 64) (v := 320) (by decide) rfl]
    ext j hj
    simp
  · exact (hr 8#64 (by decide)).symm
  · exact (hr 16#64 (by decide)).symm
  · exact (hr 24#64 (by decide)).symm
  · exact (hr 32#64 (by decide)).symm

/-- A 64-bit store over the first stored limb: that limb replaced. -/
theorem MemoryState.storeLimbs_storeAt_self {m : MemoryState} {p : Pointer}
    (h : p.offset.toNat + 32 < 2 ^ 64) (l : Fin 5 → BitVec 64) (x : BitVec 64) :
    (m.storeLimbs p l).storeAt p x =
      m.storeLimbs p fun
        | 0 => x
        | 1 => l 1
        | 2 => l 2
        | 3 => l 3
        | 4 => l 4 := by
  simp only [MemoryState.storeLimbs, MemoryState.storeAt, Pointer.add_id,
    MemoryState.modifyBlock_modifyBlock_self, implies_true, Function.comp_apply]
  congr 1
  funext blk
  have ho (k : Nat) (hk : k ≤ 32) := Pointer.offsetInBits_add_limb (p := p) h hk
  simp only [Function.comp_apply, MemoryBlock.mk.injEq, true_and, and_true]
  rw [show (8#64 : BitVec 64) = BitVec.ofNat 64 8 from rfl,
    show (16#64 : BitVec 64) = BitVec.ofNat 64 16 from rfl,
    show (24#64 : BitVec 64) = BitVec.ofNat 64 24 from rfl,
    show (32#64 : BitVec 64) = BitVec.ofNat 64 32 from rfl, ho 8 (by decide), ho 16 (by decide),
    ho 24 (by decide), ho 32 (by decide), show p.offsetInBits = 8 * p.offset.toNat from rfl]
  refine ⟨heq_of_eq ?_, heq_of_eq ?_⟩ <;> apply BitVec.eq_of_getLsbD_eq <;> intro i hi <;>
    simp only [getLsbD_spliceBits, BitVec.getLsbD_allOnes] <;>
    grind

end

end MLIR
