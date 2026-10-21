module

import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! Small loop counters as bit vectors. -/

namespace MLIR.Firedancer

public section

/-- A non-negative `int` counter's sign bit is clear. -/
theorem msb_ofNat32 {i : Nat} (h : i < 2 ^ 31) : (BitVec.ofNat 32 i).msb = false := by
  simp only [BitVec.msb_eq_decide, BitVec.toNat_ofNat, decide_eq_false_iff_not]
  omega

/-- A small `int` counter zero-extends to the same `long`. -/
theorem setWidth_ofNat32 {i : Nat} (h : i < 2 ^ 32) :
    BitVec.setWidth 64 (BitVec.ofNat 32 i) = BitVec.ofNat 64 i := by
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_setWidth, BitVec.toNat_ofNat]
  omega

/-- `i + 1` on a small `long` counter does not overflow, signed. -/
theorem saddOverflow_one64 {i : Nat} (h : i + 1 < 2 ^ 63) :
    (BitVec.ofNat 64 i).saddOverflow 1#64 = false := by
  have : (BitVec.ofNat 64 i).toInt = i := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp [BitVec.saddOverflow, this]
  omega

/-- Nor unsigned. -/
theorem uaddOverflow_one64 {i : Nat} (h : i + 1 < 2 ^ 64) :
    (BitVec.ofNat 64 i).uaddOverflow 1#64 = false := by
  simp [BitVec.uaddOverflow]
  omega


/-- `i + 1` on a small `int` counter does not overflow, signed. -/
theorem saddOverflow_one32 {i : Nat} (h : i + 1 < 2 ^ 31) :
    (BitVec.ofNat 32 i).saddOverflow 1#32 = false := by
  have : (BitVec.ofNat 32 i).toInt = i := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp [BitVec.saddOverflow, this]
  omega

/-- Nor unsigned. -/
theorem uaddOverflow_one32 {i : Nat} (h : i + 1 < 2 ^ 31) :
    (BitVec.ofNat 32 i).uaddOverflow 1#32 = false := by
  simp [BitVec.uaddOverflow]
  omega

/-- `i + k` on a small `long` counter does not overflow, signed. -/
theorem saddOverflow_ofNat64 {i k : Nat} (h : i + k < 2 ^ 63) :
    (BitVec.ofNat 64 i).saddOverflow (BitVec.ofNat 64 k) = false := by
  have hi : (BitVec.ofNat 64 i).toInt = i := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have hk : (BitVec.ofNat 64 k).toInt = k := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp [BitVec.saddOverflow, hi, hk]
  omega

/-- Nor unsigned. -/
theorem uaddOverflow_ofNat64 {i k : Nat} (h : i + k < 2 ^ 64) :
    (BitVec.ofNat 64 i).uaddOverflow (BitVec.ofNat 64 k) = false := by
  simp [BitVec.uaddOverflow]
  omega

/-- `i + k` on a small `int` counter does not overflow, signed. -/
theorem saddOverflow_ofNat32 {i k : Nat} (h : i + k < 2 ^ 31) :
    (BitVec.ofNat 32 i).saddOverflow (BitVec.ofNat 32 k) = false := by
  have hi : (BitVec.ofNat 32 i).toInt = i := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  have hk : (BitVec.ofNat 32 k).toInt = k := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp [BitVec.saddOverflow, hi, hk]
  omega

/-- Nor unsigned. -/
theorem uaddOverflow_ofNat32 {i k : Nat} (h : i + k < 2 ^ 32) :
    (BitVec.ofNat 32 i).uaddOverflow (BitVec.ofNat 32 k) = false := by
  simp [BitVec.uaddOverflow]
  omega

/-- Distinct small counters differ as `long`s. -/
theorem ofNat64_ne {a b : Nat} (ha : a < 2 ^ 64) (hb : b < 2 ^ 64) (h : a ≠ b) :
    BitVec.ofNat 64 a ≠ BitVec.ofNat 64 b := by
  intro e
  have := congrArg BitVec.toNat e
  simp only [BitVec.toNat_ofNat, Nat.mod_eq_of_lt ha, Nat.mod_eq_of_lt hb] at this
  exact h this

/-- A buffer offset's low seven bits: the offset mod `128`. -/
theorem toNat_and_127 (n : BitVec 64) : (n &&& 127#64).toNat = n.toNat % 128 := by
  rw [BitVec.toNat_and, show (127#64).toNat = 2 ^ 7 - 1 from rfl, Nat.and_two_pow_sub_one_eq_mod]

/-- A byte count shifted by 7: its 128-byte blocks. -/
theorem toNat_ushiftRight_7 (n : BitVec 64) : (n >>> 7).toNat = n.toNat / 128 := by
  rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]

/-- A byte shifted right by 7 has a clear sign bit. -/
theorem lshr_seven_msb (b : BitVec 8) : (b >>> 7).msb = false := by bv_decide

/-- A small `int` sign-extends to the same `long`. -/
theorem signExtend_ofNat32 {a : Nat} (h : a < 2 ^ 31) :
    (BitVec.ofNat 32 a).signExtend 64 = BitVec.ofNat 64 a := by
  rw [BitVec.signExtend_eq_setWidth_of_msb_false (msb_ofNat32 h)]
  exact setWidth_ofNat32 (by omega)

/-- The counter's test at `N`, back in `ℕ`. -/
theorem counter_eq {i N : Nat} (hN : N < 2 ^ 31) (hi : i + 1 ≤ N)
    (h : BitVec.ofNat 32 i + 1#32 = BitVec.ofNat 32 N) : i + 1 = N := by
  have := congrArg BitVec.toNat h
  simp [BitVec.toNat_add] at this
  omega

/-- The counter's test failing at `N`: still below it. -/
theorem counter_ne {i N : Nat} (hN : N < 2 ^ 31) (hi : i + 1 ≤ N)
    (h : ¬BitVec.ofNat 32 i + 1#32 = BitVec.ofNat 32 N) : i + 1 < N := by
  rcases Nat.lt_or_eq_of_le hi with h' | h'
  · exact h'
  · subst h'
    exact absurd (by rw [BitVec.ofNat_add]) h

end

end MLIR.Firedancer
