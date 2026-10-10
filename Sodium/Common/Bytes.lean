module

import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! The byte tests' `OR` of byte differences, the no-wrap facts of their flagged `add`s, and `Fin`
literals' values for their final `bv_decide` (the lanes `step_pure` extracts at literal
offsets). -/

namespace MLIR

@[expose] public section

/-- `c |= f i` for `i < k`, from `c`. -/
def orBytes (f : Nat → BitVec 8) (c : BitVec 8) : Nat → BitVec 8
  | 0 => c
  | k + 1 => orBytes f c k ||| f k

/-- A byte widened to 32 bits minus one does not wrap (signed). -/
theorem byte_sub_one_saddOverflow (x : BitVec 8) : ¬(x.setWidth 32).saddOverflow 4294967295#32 := by
  bv_decide

/-- A byte widened to 32 bits plus `511` does not wrap (signed). -/
theorem byte_add_511_saddOverflow (x : BitVec 8) : ¬(x.setWidth 32).saddOverflow 511#32 := by
  bv_decide

/-- A byte widened to 32 bits plus `511` does not wrap (unsigned). -/
theorem byte_add_511_uaddOverflow (x : BitVec 8) : ¬(x.setWidth 32).uaddOverflow 511#32 := by
  bv_decide

/-- A `Fin` literal's value. -/
theorem fin_val_ofNat (n i : Nat) [NeZero n] : ((no_index (OfNat.ofNat i : Fin n)) : Nat) = i % n :=
  rfl

end

end MLIR
