module

public import MLIR.Run.Tactic
public import Agave.Common.LimbQuads
public import Agave.Serial.FieldElement51_Neg_neg
public import Agave.Avx2.Mlir.FieldElement51_Neg_neg

namespace MLIR.Agave.Avx2

/-! ## Proof -/

section Proof

/-- `-&a` stores `Serial.FieldElement51_Neg_neg.spec a` at `out`: limbs 0 to 3 and 1 to 4 loaded
as two vector quads, limbs 1 to 4 stored as one. The input is loaded before the stores, so `out` may
alias `a`. -/
public theorem FieldElement51_Neg_neg.call_eq (out a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (ha : s.mem.LimbsFit a) :
    FieldElement51_Neg_neg.call (FieldElement51_Neg_neg.args (.value out) (.value a)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs out (Serial.FieldElement51_Neg_neg.spec (s.mem.readLimbs a)) }) := by
  func_init
  have ha₀ : S₀.mem.LimbsFit a := hS ▸ ha
  have ha_0 := fits_quad0 ha
  have ha_8 := fits_quad ha (k := 8#64) (by decide)
  have hout_8 := room_quad hout (k := 8#64) (by decide)
  have hoff := hout.1
  block_init
  iterate 11 step_pure
  -- 16 p[i] - self.0[i], for limbs 0 to 3 and 1 to 4
  step_load
  step_load
  step_pure
  step_pure
  -- reduce: the carries, limb 0 taking c4 * 19
  iterate 9 step_pure
  step_store
  step_store
  finish_block
  rw [hS, storeAt_quad8_eq_storeLimbs hoff]
  simp only [Vector.getElem_ofFn, lane_readAt0 ha₀, lane_readAt8 ha₀]
  congr

end Proof

end MLIR.Agave.Avx2
