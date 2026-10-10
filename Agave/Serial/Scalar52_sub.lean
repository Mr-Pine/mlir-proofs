module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Agave.Common.Scalar
public import Agave.Serial.black_box_u8
public import Agave.Serial.Mlir.Scalar52_sub
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Serial

/-! ## Proof -/

section Proof

/-! The `nsw`/`nuw` flags: every flagged operand is a masked limb, a carry or a part of `ℓ`. -/

@[simp]
theorem trunc_shift63_nuw (x : BitVec 64) : ((x >>> 63).setWidth 8).setWidth 64 = x >>> 63 := by
  bv_decide

@[simp]
theorem trunc_shift63_nsw (x : BitVec 64) : ((x >>> 63).setWidth 8).signExtend 64 = x >>> 63 := by
  bv_decide

@[simp]
theorem neg_zext8_ssubOverflow (c : BitVec 8) : ¬(0#64).ssubOverflow (c.setWidth 64) := by bv_decide

@[simp]
theorem mask_add_l0_uaddOverflow (x y : BitVec 64) :
    ¬(x &&& 4503599627370495#64).uaddOverflow (y &&& 671914833335277#64) := by bv_decide

@[simp]
theorem mask_add_l0_saddOverflow (x y : BitVec 64) :
    ¬(x &&& 4503599627370495#64).saddOverflow (y &&& 671914833335277#64) := by bv_decide

@[simp]
theorem mask_add_carry_uaddOverflow (x y : BitVec 64) :
    ¬(x &&& 4503599627370495#64).uaddOverflow (y >>> 52) := by bv_decide

@[simp]
theorem mask_add_carry_saddOverflow (x y : BitVec 64) :
    ¬(x &&& 4503599627370495#64).saddOverflow (y >>> 52) := by bv_decide

@[simp]
theorem mask_add_carry_add_l1_uaddOverflow (x y z : BitVec 64) :
    ¬((x &&& 4503599627370495#64) + (y >>> 52)).uaddOverflow (z &&& 3916664325105025#64) := by
  bv_decide

@[simp]
theorem mask_add_carry_add_l1_saddOverflow (x y z : BitVec 64) :
    ¬((x &&& 4503599627370495#64) + (y >>> 52)).saddOverflow (z &&& 3916664325105025#64) := by
  bv_decide

@[simp]
theorem mask_add_carry_add_l2_uaddOverflow (x y z : BitVec 64) :
    ¬((x &&& 4503599627370495#64) + (y >>> 52)).uaddOverflow (z &&& 1367801#64) := by bv_decide

@[simp]
theorem mask_add_carry_add_l2_saddOverflow (x y z : BitVec 64) :
    ¬((x &&& 4503599627370495#64) + (y >>> 52)).saddOverflow (z &&& 1367801#64) := by bv_decide

/-- `Scalar52::sub(a, &L)` stores `spec a` at `out`. The loads all come before the stores, so `out`
may alias `a`; `black_box`'s slot leaves one block counted. -/
public theorem Scalar52_sub.call_eq (out a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (ha : s.mem.LimbsFit a) :
    Scalar52_sub.call (Scalar52_sub.args (.value out) (.value a)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩
            mem := s.mem.storeLimbs out (Scalar52_sub.spec (s.mem.readLimbs a)) }) := by
  func_init
  block_init
  iterate 12 step_pure
  -- `borrow = a[i].wrapping_sub(b[i] + (borrow >> 63)); difference[i] = borrow & mask;`
  step_load
  step_pure with borrow0
  step_pure
  step_pure
  step_load
  iterate 2 step_pure
  step_pure with borrow1
  step_pure
  step_pure
  step_load
  iterate 2 step_pure
  step_pure with borrow2
  step_pure
  step_pure
  step_load
  step_pure
  step_pure with borrow3
  step_pure
  step_pure
  step_load
  iterate 2 step_pure
  step_pure with borrow4
  -- `difference.conditional_add_l(Choice::from((borrow >> 63) as u8))`
  step_pure
  step_pure
  step_call using black_box_u8.call_eq with condition
  iterate 23 step_pure
  step_store
  iterate 4 
    step_pure
    step_store
  finish_block
  subst hS
  erase_frame
  clear_reads
  subst_vars
  refine
      congrArg (fun m => PoisonOr.value (Vals.nil, ({ alloc := _, mem := m } : GlobalState)))
        (Agave.storeLimbs_of_eq ?_ ?_ ?_ ?_ ?_).symm <;>
    simp only [Scalar52_sub.spec, MemoryState.readLimbs, Scalar52.L, Matrix.cons_val] <;>
    generalize S₀.mem.readAt a 64 = x0 <;>
    generalize S₀.mem.readAt (a.add 8#64) 64 = x1 <;>
    generalize S₀.mem.readAt (a.add 16#64) 64 = x2 <;>
    generalize S₀.mem.readAt (a.add 24#64) 64 = x3 <;>
    generalize S₀.mem.readAt (a.add 32#64) 64 = x4 <;>
    bv_decide

end Proof

end MLIR.Agave.Serial
