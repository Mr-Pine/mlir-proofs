module

public import MLIR.Run.Tactic
public import Agave.Common.LimbQuads
public import Agave.Serial.FieldElement51_Add_add
public import Agave.Avx2.Mlir.FieldElement51_Add_add

namespace MLIR.Agave.Avx2

/-! ## Proof -/

section Proof

/-- `&a + &b` stores `Serial.FieldElement51_Add_add.spec a b` at `out`, the first four limbs as one
vector quad. Both inputs are loaded before the stores, so `out` may alias `a` or `b`. -/
public theorem FieldElement51_Add_add.call_eq (out a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (ha : s.mem.LimbsFit a) (hb : s.mem.LimbsFit b) :
    FieldElement51_Add_add.call (FieldElement51_Add_add.args (.value out) (.value a) (.value b)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs out
                (Serial.FieldElement51_Add_add.spec (s.mem.readLimbs a)
                  (s.mem.readLimbs b)) }) := by
  func_init
  have ha₀ : S₀.mem.LimbsFit a := hS ▸ ha
  have hb₀ : S₀.mem.LimbsFit b := hS ▸ hb
  have ha_q := fits_quad0 ha
  have hb_q := fits_quad0 hb
  have hout_q := room_quad0 hout
  have hoff := hout.1
  block_init
  -- the last limb
  step_pure
  step_load
  step_pure
  step_load
  step_pure
  -- the limb quad
  step_load
  step_load
  step_pure
  step_store
  step_pure
  step_store
  finish_block
  rw [hS, storeAt_quad_eq_storeLimbs hoff]
  simp only [Vector.getElem_ofFn, lane_readAt0 ha₀, lane_readAt0 hb₀]
  congr
  funext k
  fin_cases k <;> rfl

end Proof

end MLIR.Agave.Avx2
