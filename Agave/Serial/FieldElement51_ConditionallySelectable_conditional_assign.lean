module

public import MLIR.Run.Tactic
public import Agave.Common.Limbs
public import Agave.Serial.Mlir.FieldElement51_ConditionallySelectable_conditional_assign
public import Std.Tactic.BVDecide
public meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Agave.Serial

/-! ## Specification -/

@[expose] public section

/-- `u64::conditional_assign` limbwise: `mask = -(choice as i64) as u64`,
`self ^= mask & (self ^ other)`, in the code's operand order. -/
def FieldElement51_ConditionallySelectable_conditional_assign.spec (self other : Fin 5 → BitVec 64)
    (choice : BitVec 8) : Fin 5 → BitVec 64 :=
  let mask := -choice.setWidth 64
  fun i => (other i ^^^ self i) &&& mask ^^^ self i

end

/-- For a `Choice` (`0` or `1`): `other` if `1`, else `self`. -/
public theorem FieldElement51_ConditionallySelectable_conditional_assign.spec_eq
    (self other : Fin 5 → BitVec 64) {choice : BitVec 8} (hc : choice = 0 ∨ choice = 1) :
    FieldElement51_ConditionallySelectable_conditional_assign.spec self other choice =
      if choice = 1 then other else self := by
  funext i
  rcases hc with rfl | rfl <;>
    simp only [FieldElement51_ConditionallySelectable_conditional_assign.spec] <;>
    bv_decide

/-! ## Proof -/

section Proof

public theorem neg_zext_no_ssubOverflow (c : BitVec 8) : ¬(0#64).ssubOverflow (c.setWidth 64) := by
  bv_decide

/-- `self.conditional_assign(&other, choice)` stores `spec self other choice` at `self`, the first
four limbs as two vector pairs. `other` is apart from `self`. -/
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
                (FieldElement51_ConditionallySelectable_conditional_assign.spec
                  (s.mem.readLimbs self) (s.mem.readLimbs other) choice) }) := by
  func_init
  have hself₀ : S₀.mem.LimbsFit self := hS ▸ hself
  have hother₀ : S₀.mem.LimbsFit other := hS ▸ hother
  have hself_lo := MemoryState.LimbsFit.fits_lo hself
  have hself_hi := MemoryState.LimbsFit.fits_pair hself (k := 16#64) (by decide)
  have hother_lo := MemoryState.LimbsFit.fits_lo hother
  have hother_hi := MemoryState.LimbsFit.fits_pair hother (k := 16#64) (by decide)
  have hoff := hself.1
  block_init
  iterate 3 step_pure
  step_pure [neg_zext_no_ssubOverflow]
  step_load
  step_load
  iterate 5 step_pure
  step_store
  step_pure
  step_pure
  step_load
  step_load
  iterate 3 step_pure
  step_store
  step_pure
  step_load
  step_pure
  step_load
  iterate 3 step_pure
  step_store
  finish_block
  rw [hS, MemoryState.storeAt_packLanes_limbs hoff]
  simp only [Vector.getElem_ofFn, Fin.zero_eta, Fin.mk_one, MemoryState.extractVecElem_zero_readAt,
    MemoryState.LimbsFit.extractVecElem_one_lo hself₀,
    MemoryState.LimbsFit.extractVecElem_one_lo hother₀,
    MemoryState.LimbsFit.extractVecElem_one hself₀ (k := 16#64) (by decide),
    MemoryState.LimbsFit.extractVecElem_one hother₀ (k := 16#64) (by decide)]
  congr
  funext k
  fin_cases k <;> rfl

end Proof

end MLIR.Agave.Serial
