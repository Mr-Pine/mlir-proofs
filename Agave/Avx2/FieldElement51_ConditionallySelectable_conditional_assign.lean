module

public import MLIR.Run.Tactic
public import Agave.Common.LimbQuads
public import Agave.Serial.FieldElement51_ConditionallySelectable_conditional_assign
public import Agave.Avx2.Mlir.FieldElement51_ConditionallySelectable_conditional_assign
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Avx2

/-! ## Proof -/

section Proof

theorem neg_zext_no_ssubOverflow (c : BitVec 8) : ¬(0#64).ssubOverflow (c.setWidth 64) := by
  bv_decide

/-- `self.conditional_assign(&other, choice)` stores
`Serial.FieldElement51_ConditionallySelectable_conditional_assign.spec self other choice` at
`self`, the first four limbs as one vector quad. `other` is apart from `self`. -/
public theorem FieldElement51_ConditionallySelectable_conditional_assign.call_eq
    (self other : Pointer) (choice : BitVec 8) (s : GlobalState) (hwf : s.WF)
    (hself : s.mem.LimbsFit self) (hselfw : Writable s.mem self) (hother : s.mem.LimbsFit other)
    (hsep : self.id ≠ other.id) :
    FieldElement51_ConditionallySelectable_conditional_assign.call
        (FieldElement51_ConditionallySelectable_conditional_assign.args (.value self) (.value other)
          (.value choice))
        s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs self
                (Serial.FieldElement51_ConditionallySelectable_conditional_assign.spec
                  (s.mem.readLimbs self) (s.mem.readLimbs other) choice) }) := by
  func_init
  have hself₀ : S₀.mem.LimbsFit self := hS ▸ hself
  have hother₀ : S₀.mem.LimbsFit other := hS ▸ hother
  have hself_q := fits_quad0 hself
  have hother_q := fits_quad0 hother
  have hoff := hself.1
  block_init
  iterate 2 step_pure
  -- mask = -(choice as i64) as u64
  step_pure
  step_pure [neg_zext_no_ssubOverflow]
  -- self ^= mask & (self ^ other), limbs 0 to 3
  step_load
  step_load
  iterate 5 step_pure
  step_store
  -- limb 4
  step_pure
  step_load
  step_pure
  step_load
  iterate 3 step_pure
  step_store
  finish_block
  rw [hS, storeAt_quad_eq_storeLimbs hoff]
  simp only [Vector.getElem_ofFn, lane_readAt0 hself₀, lane_readAt0 hother₀]
  congr
  funext k
  fin_cases k <;> rfl

end Proof

end MLIR.Agave.Avx2
