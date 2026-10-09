module

public import Init.Data.BitVec.Lemmas
public import Std.Tactic.BVDecide
public meta import Std.Tactic.BVDecide.Reflect

/-! The no-overflow facts of the fiat-crypto carries: every flagged operand of a carry is a
13-bit carry (times 19) and a 51-bit limb, or a product of zero-extended 64-bit limbs. -/

namespace MLIR.Firedancer.Ref

public section

@[simp]
theorem shift_no_smulOverflow (x : BitVec 64) : ¬(x >>> 51).smulOverflow 19#64 := by bv_decide

@[simp]
theorem shift_no_umulOverflow (x : BitVec 64) : ¬(x >>> 51).umulOverflow 19#64 := by bv_decide

@[simp]
theorem shift_mask_saddOverflow (x y : BitVec 64) :
    ¬(x >>> 51).saddOverflow (y &&& 2251799813685247#64) := by bv_decide

@[simp]
theorem shift_mask_uaddOverflow (x y : BitVec 64) :
    ¬(x >>> 51).uaddOverflow (y &&& 2251799813685247#64) := by bv_decide

@[simp]
theorem shift_mul19_mask_saddOverflow (x y : BitVec 64) :
    ¬(x >>> 51 * 19#64).saddOverflow (y &&& 2251799813685247#64) := by bv_decide

@[simp]
theorem shift_mul19_mask_uaddOverflow (x y : BitVec 64) :
    ¬(x >>> 51 * 19#64).uaddOverflow (y &&& 2251799813685247#64) := by bv_decide

@[simp]
theorem setWidth_no_umulOverflow (x y : BitVec 64) :
    ¬(x.setWidth 128).umulOverflow (y.setWidth 128) := by
  have := Nat.mul_lt_mul'' x.isLt y.isLt
  simp [BitVec.umulOverflow, Nat.mod_eq_of_lt (Nat.lt_trans x.isLt (by decide : 2 ^ 64 < 2 ^ 128)),
    Nat.mod_eq_of_lt (Nat.lt_trans y.isLt (by decide : 2 ^ 64 < 2 ^ 128))]
  omega

end

end MLIR.Firedancer.Ref
