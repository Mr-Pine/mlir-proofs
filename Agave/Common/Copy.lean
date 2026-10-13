module

public import MLIR.Run.Tactic
public import Agave.Common.Limbs
import Mathlib.Tactic.FinCases
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! Field elements copied whole (a `memcpy` of 40 bytes) and read back as limbs, and limbs read
one by one. -/

namespace MLIR.Agave

/-- Limbs read one by one. -/
public theorem readLimbs_of_reads {m : MemoryState} {p : Pointer} {l : Fin 5 → BitVec 64}
    (h0 : m.readAt p 64 = l 0) (h1 : m.readAt (p.add 8#64) 64 = l 1)
    (h2 : m.readAt (p.add 16#64) 64 = l 2) (h3 : m.readAt (p.add 24#64) 64 = l 3)
    (h4 : m.readAt (p.add 32#64) 64 = l 4) : m.readLimbs p = l := by
  funext i
  fin_cases i <;> assumption

/-- A field element global's limbs, from its block's 320 bits. -/
public theorem readLimbs_global {m : MemoryState} {p : Pointer} {x : BitVec 320}
    {l : Fin 5 → BitVec 64} (hf : Fits m p 320) (ho : p.offset = 0) (h : m.readAt p 320 = x)
    (hx : (fun i : Fin 5 => x.extractLsb' (64 * i.val) 64) = l) : m.readLimbs p = l :=
  (MemoryState.readLimbs_of_readAt hf ho h).trans hx

/-- `limbsBits`' 64-bit pieces. -/
public theorem extractLsb'_limbsBits (l : Fin 5 → BitVec 64) :
    (limbsBits l).extractLsb' 0 64 = l 0 ∧
      (limbsBits l).extractLsb' 64 64 = l 1 ∧
      (limbsBits l).extractLsb' 128 64 = l 2 ∧
      (limbsBits l).extractLsb' 192 64 = l 3 ∧ (limbsBits l).extractLsb' 256 64 = l 4 := by
  have h (a b c d e : BitVec 64) :
    (e ++ d ++ c ++ b ++ a).extractLsb' 0 64 = a ∧
      (e ++ d ++ c ++ b ++ a).extractLsb' 64 64 = b ∧
      (e ++ d ++ c ++ b ++ a).extractLsb' 128 64 = c ∧
      (e ++ d ++ c ++ b ++ a).extractLsb' 192 64 = d ∧
      (e ++ d ++ c ++ b ++ a).extractLsb' 256 64 = e := by
    bv_decide
  exact h _ _ _ _ _

/-- The limbs of 320 bits read as `limbsBits l`: `l`. -/
public theorem readLimbs_of_readAt_limbsBits {m : MemoryState} {p : Pointer} {l : Fin 5 → BitVec 64}
    (hb : InBounds m p 320) (ho : p.offset.toNat + 32 < 2 ^ 64) (h : m.readAt p 320 = limbsBits l) :
    m.readLimbs p = l := by
  have hr (k : BitVec 64) (hk : k.toNat ≤ 32) :=
    MemoryState.readAt_add_of_readAt (w := 64) hb (Pointer.not_uaddOverflow_of_limbs ho hk)
      (by omega) h
  obtain ⟨e0, e1, e2, e3, e4⟩ := extractLsb'_limbsBits l
  refine
    readLimbs_of_reads ?_
      (by
        rw [hr 8#64 (by decide)]; exact e1)
      (by
        rw [hr 16#64 (by decide)]; exact e2)
      (by
        rw [hr 24#64 (by decide)]; exact e3)
      (by
        rw [hr 32#64 (by decide)]; exact e4)
  rw [MemoryState.readAt_of_readAt_le (w := 64) (by decide) h, ← e0]
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  simp [hi]

/-- Room for the limbs `k` bytes into a slot of `n` bits. -/
public theorem limbsRoom_add {m : MemoryState} {p : Pointer} {n : Nat} {k : BitVec 64}
    (h : Room m p n) (ho : p.offset = 0) (hk : k.toNat * 8 + 320 ≤ n) (hn : n < 2 ^ 64) :
    m.LimbsRoom (p.add k) := by
  have hov : ¬p.offset.uaddOverflow k := by
    simp [BitVec.uaddOverflow, ho]
    omega
  have hr : Room m (p.add k) 320 := Room.add_of_le hov (by omega) h
  have hoff : (p.add k).offset.toNat = k.toNat := by simp [Pointer.add, ho]
  have hov' (off : BitVec 64) (hoff' : off.toNat ≤ 32) : ¬(p.add k).offset.uaddOverflow off := by
    simp only [BitVec.uaddOverflow, decide_eq_true_eq, Nat.not_le, hoff]
    omega
  refine ⟨by omega, hr.mono (by omega), ?_, ?_, ?_, ?_⟩ <;>
    exact Room.add_of_le (hov' _ (by decide)) (by decide) hr

end MLIR.Agave
