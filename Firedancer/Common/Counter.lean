module

/-! Small loop counters as bit vectors, shared by `fd_curve25519_scalar_wnaf` and
`fd_ed25519_double_scalar_mul_base`. -/

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

end

end MLIR.Firedancer
