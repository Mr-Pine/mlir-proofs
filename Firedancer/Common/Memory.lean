module

public import MLIR.Semantics.Effectful.Memory.Operations
import Std.Data.ExtHashMap.Lemmas

/-! Changes of memory blocks, as stores and lifetime markers make them. -/

namespace MLIR

@[expose] public section

/-- Two changes of one block, the first keeping its writability: their composition. -/
theorem MemoryState.modifyBlock_modifyBlock_self {m : MemoryState} {i : BlockId}
    {f g : MemoryBlock → MemoryBlock} (hf : ∀ b, (f b).writable = b.writable) :
    (m.modifyBlock i f).modifyBlock i g = m.modifyBlock i (g ∘ f) := by
  simp only [modifyBlock, MemoryState.mk.injEq, and_true]
  apply Std.ExtHashMap.ext_getElem?
  intro k
  simp only [Std.ExtHashMap.getElem?_modify, beq_iff_eq]
  split
  · rename_i h; subst h
    cases m.mem[i]? with
    | none => simp
    | some b => by_cases hw : b.writable <;> simp [MemoryBlock.update, hw, hf]
  · rfl

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
  simp only [MemoryState.storeAt, MemoryState.modifyBlock_modifyBlock_self, implies_true]
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
    MemoryState.modifyBlock_modifyBlock_self, implies_true]
  congr 1
  funext blk
  simp only [Function.comp_apply, hoff, happ, hones]

/-- A splice into a splice that covers it: one splice of the inner value. -/
theorem Memory.spliceBits_spliceBits_add {n wx wy : Nat} (b : BitVec n) (o k : Nat) (x : BitVec wx)
    (y : BitVec wy) (h : k + wy ≤ wx) :
    Memory.spliceBits (Memory.spliceBits b o x) (o + k) y =
      Memory.spliceBits b o (Memory.spliceBits x k y) := by
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp only [Memory.getLsbD_spliceBits]
  grind

/-- A store inside a stored value: one store, the inner value spliced. -/
theorem MemoryState.storeAt_storeAt_add {m : MemoryState} {p : Pointer} {u : BitVec wu}
    {off : BitVec 64} (hov : ¬p.offset.uaddOverflow off) (hw : off.toNat * 8 + wy ≤ wu)
    (y : BitVec wy) :
    (m.storeAt p u).storeAt (p.add off) y =
      m.storeAt p (Memory.spliceBits u (off.toNat * 8) y) := by
  have hones :
    Memory.spliceBits (BitVec.allOnes wu) (off.toNat * 8) (BitVec.allOnes wy) =
      BitVec.allOnes wu := by
    apply BitVec.eq_of_getLsbD_eq
    intro i hi
    simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_allOnes]
    grind
  simp only [MemoryState.storeAt, Pointer.add_id, MemoryState.modifyBlock_modifyBlock_self,
    implies_true]
  congr 1
  funext blk
  simp only [Function.comp_apply, Pointer.offsetInBits_add hov,
    Memory.spliceBits_spliceBits_add _ _ _ _ _ hw, hones]

/-- A store at a stored value's start: one store, the inner value spliced. -/
theorem MemoryState.storeAt_storeAt_low {m : MemoryState} {p : Pointer} {u : BitVec wu}
    (hw : wy ≤ wu) (y : BitVec wy) :
    (m.storeAt p u).storeAt p y = m.storeAt p (Memory.spliceBits u 0 y) := by
  have h :=
    MemoryState.storeAt_storeAt_add (m := m) (p := p) (u := u) (off := 0#64)
      (by
        simp [BitVec.uaddOverflow]; exact p.offset.isLt)
      (by simpa using hw) y
  rwa [Pointer.add_zero] at h

/-- A store inside a range stored with definedness: one such store, both spliced. -/
theorem MemoryState.overlay_storeAt_add {m : MemoryState} {p : Pointer} {u d : BitVec wu}
    {off : BitVec 64} (hov : ¬p.offset.uaddOverflow off) (hw : off.toNat * 8 + wy ≤ wu)
    (y : BitVec wy) :
    (m.overlay p u d).storeAt (p.add off) y =
      m.overlay p (Memory.spliceBits u (off.toNat * 8) y)
        (Memory.spliceBits d (off.toNat * 8) (BitVec.allOnes wy)) := by
  simp only [MemoryState.storeAt, MemoryState.overlay, Pointer.add_id,
    MemoryState.modifyBlock_modifyBlock_self, implies_true]
  congr 1
  funext blk
  simp only [Function.comp_apply, Pointer.offsetInBits_add hov,
    Memory.spliceBits_spliceBits_add _ _ _ _ _ hw]

/-- A store right after another: one store of both. -/
theorem MemoryState.storeAt_storeAt_concat {m : MemoryState} {p : Pointer} {off : BitVec 64}
    {x : BitVec v} {y : BitVec w} (hov : ¬p.offset.uaddOverflow off) (hoff : off.toNat * 8 = v) :
    (m.storeAt p x).storeAt (p.add off) y = m.storeAt p (y ++ x) := by
  simp only [MemoryState.storeAt, Pointer.add_id, MemoryState.modifyBlock_modifyBlock_self,
    implies_true]
  congr 1
  funext blk
  simp only [Function.comp_apply, Pointer.offsetInBits_add hov, hoff, MemoryBlock.mk.injEq,
    true_and, and_true]
  refine ⟨heq_of_eq ?_, heq_of_eq ?_⟩ <;> apply BitVec.eq_of_getLsbD_eq <;> intro i hi <;>
    simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_append, BitVec.getLsbD_allOnes]
  · grind
  · split <;> split <;> (try split) <;> (try simp only [decide_eq_decide]) <;> omega

/-- A store of `y ++ x`: `x`, then `y` right after it. -/
theorem MemoryState.storeAt_append {m : MemoryState} {p : Pointer} {off : BitVec 64} {x : BitVec v}
    {y : BitVec w} (hov : ¬p.offset.uaddOverflow off) (hoff : off.toNat * 8 = v) :
    m.storeAt p (y ++ x) = (m.storeAt p x).storeAt (p.add off) y :=
  (MemoryState.storeAt_storeAt_concat hov hoff).symm

/-- A store right before another: one store of both. -/
theorem MemoryState.storeAt_storeAt_below {m : MemoryState} {p : Pointer} {off : BitVec 64}
    {x : BitVec v} {y : BitVec w} (hov : ¬p.offset.uaddOverflow off) (hoff : off.toNat * 8 = v) :
    (m.storeAt (p.add off) y).storeAt p x = m.storeAt p (y ++ x) := by
  simp only [MemoryState.storeAt, Pointer.add_id, MemoryState.modifyBlock_modifyBlock_self,
    implies_true]
  congr 1
  funext blk
  simp only [Function.comp_apply, Pointer.offsetInBits_add hov, hoff, MemoryBlock.mk.injEq,
    true_and, and_true]
  refine ⟨heq_of_eq ?_, heq_of_eq ?_⟩ <;> apply BitVec.eq_of_getLsbD_eq <;> intro i hi <;>
    simp only [Memory.getLsbD_spliceBits, BitVec.getLsbD_append, BitVec.getLsbD_allOnes]
  · grind
  · split <;> split <;> (try split) <;> (try simp only [decide_eq_decide]) <;> omega

/-- A store of a cast value: the value's store. -/
theorem MemoryState.storeAt_cast {m : MemoryState} {x : BitVec w} (h : w = w') :
    m.storeAt p (x.cast h) = m.storeAt p x := by
  subst h; rfl

end

end MLIR
