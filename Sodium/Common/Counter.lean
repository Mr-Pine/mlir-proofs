module

/-! Small loop counters and indices as 64-bit vectors. -/

namespace MLIR.Sodium

public section

/-- `i + k` on a small counter does not overflow, signed. -/
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

/-- Two small counters are equal as 64-bit values exactly when they are. -/
theorem ofNat64_eq_iff {a b : Nat} (ha : a < 2 ^ 64) (hb : b < 2 ^ 64) :
    BitVec.ofNat 64 a = BitVec.ofNat 64 b ↔ a = b := by
  constructor
  · intro h
    have := congrArg BitVec.toNat h
    rwa [BitVec.toNat_ofNat, BitVec.toNat_ofNat, Nat.mod_eq_of_lt ha, Nat.mod_eq_of_lt hb] at this
  · rintro rfl
    rfl

/-- `i + 1` on a small counter equals `x` exactly when it does as a number. -/
theorem ofNat64_add_one_eq_iff {i : Nat} {x : BitVec 64} (hi : i + 1 < 2 ^ 64) :
    BitVec.ofNat 64 i + 1#64 = x ↔ i + 1 = x.toNat := by
  constructor
  · rintro rfl
    simp only [BitVec.toNat_add, BitVec.toNat_ofNat]
    omega
  · intro h
    apply BitVec.eq_of_toNat_eq
    simp only [BitVec.toNat_add, BitVec.toNat_ofNat]
    omega

end

end MLIR.Sodium
