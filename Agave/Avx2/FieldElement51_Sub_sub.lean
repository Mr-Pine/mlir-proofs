module

public import MLIR.Run.Tactic
public import Agave.Common.LimbQuads
public import Agave.Serial.FieldElement51_Sub_sub
public import Agave.Avx2.Mlir.FieldElement51_Sub_sub

namespace MLIR.Agave.Avx2

/-! ## Proof -/

section Proof

/-- `&a - &b` stores `Serial.FieldElement51_Sub_sub.spec a b` at `out`: limbs 0 to 3 and 1 to 4
loaded as two vector quads, limbs 1 to 4 stored as one. Both inputs are loaded before the stores,
so `out` may alias `a` or `b`. -/
public theorem FieldElement51_Sub_sub.call_eq (out a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (ha : s.mem.LimbsFit a) (hb : s.mem.LimbsFit b) :
    FieldElement51_Sub_sub.call (FieldElement51_Sub_sub.args (.value out) (.value a) (.value b)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs out
                (Serial.FieldElement51_Sub_sub.spec (s.mem.readLimbs a)
                  (s.mem.readLimbs b)) }) := by
  func_init
  have ha₀ : S₀.mem.LimbsFit a := hS ▸ ha
  have hb₀ : S₀.mem.LimbsFit b := hS ▸ hb
  have ha_0 := fits_quad0 ha
  have ha_8 := fits_quad ha (k := 8#64) (by decide)
  have hb_0 := fits_quad0 hb
  have hb_8 := fits_quad hb (k := 8#64) (by decide)
  have hout_8 := room_quad hout (k := 8#64) (by decide)
  have hoff := hout.1
  block_init
  iterate 12 step_pure
  -- (self.0[i] + 16 p[i]) - _rhs.0[i], for limbs 0 to 3 and 1 to 4
  step_load
  step_load
  step_pure
  step_load
  step_pure
  step_load
  step_pure
  step_pure
  -- reduce: the carries, limb 0 taking c4 * 19
  iterate 9 step_pure
  step_store
  step_store
  finish_block
  rw [hS, storeAt_quad8_eq_storeLimbs hoff]
  simp only [Vector.getElem_ofFn, lane_readAt0 ha₀, lane_readAt0 hb₀, lane_readAt8 ha₀,
    lane_readAt8 hb₀]
  congr

end Proof

end MLIR.Agave.Avx2
