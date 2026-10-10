module

public import MLIR.Run.Tactic
public import Firedancer.Ref.Fiat
public meta import Std.Tactic.BVDecide.Reflect

/-! Spec functions the `FieldElement51` operations share. -/

namespace MLIR.Agave.Serial

@[expose] public section

/-- `LOW_51_BIT_MASK`, `2^51 - 1`. -/
abbrev mask51 : BitVec 64 :=
  2251799813685247#64

/-- `16 p`'s limbs, `sub`'s and `negate`'s offset against underflow. -/
abbrev p16 : Fin 5 → BitVec 64
  | 0 => 36028797018963664#64
  | _ => 36028797018963952#64

/-- `m(x, y)`: the 128-bit product of two limbs. -/
abbrev mulWide (x y : BitVec 64) : BitVec 128 :=
  x.setWidth 128 * y.setWidth 128

/-- `((c >> 51) as u64) as u128`: a column's carry. -/
abbrev carry128 (c : BitVec 128) : BitVec 128 :=
  c >>> 51 &&& 18446744073709551615#128

/-- `FieldElement51::reduce`: each limb's carry `cᵢ = limbs[i] >> 51` moved into the next limb,
`c4 * 19` into limb 0, in the code's operand order. -/
def FieldElement51.reduce (limbs : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let c (i : Fin 5) := limbs i >>> 51
  fun
  | 0 => c 4 * 19#64 + (limbs 0 &&& mask51)
  | 1 => (limbs 1 &&& mask51) + c 0
  | 2 => (limbs 2 &&& mask51) + c 1
  | 3 => (limbs 3 &&& mask51) + c 2
  | 4 => (limbs 4 &&& mask51) + c 3

end

/-! The no-overflow facts of `reduce`'s carries in the other operand order (`Fiat`'s have the
carry first). -/

@[simp]
public theorem mask_shift_saddOverflow (x y : BitVec 64) :
    ¬(y &&& 2251799813685247#64).saddOverflow (x >>> 51) := by bv_decide

@[simp]
public theorem mask_shift_uaddOverflow (x y : BitVec 64) :
    ¬(y &&& 2251799813685247#64).uaddOverflow (x >>> 51) := by bv_decide

end MLIR.Agave.Serial
