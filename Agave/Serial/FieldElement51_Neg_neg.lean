module

public import MLIR.Run.Tactic
public import Agave.Common.Limbs
public import Agave.Serial.FieldElement51
public import Agave.Serial.Mlir.FieldElement51_Neg_neg

namespace MLIR.Agave.Serial

/-! ## Specification -/

@[expose] public section

/-- `negate`: `reduce` of `16 p[i] - self.0[i]`. -/
def FieldElement51_Neg_neg.spec (a : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  FieldElement51.reduce fun i => p16 i - a i

end

/-! ## Proof -/

section Proof

/-- `-&a` stores `spec a` at `out`, limbs 1 to 4 as two vector pairs. `out` is the fresh `sret`
slot, apart from `a`. -/
public theorem FieldElement51_Neg_neg.call_eq (out a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (ha : s.mem.LimbsFit a) (hsep : out.id ≠ a.id) :
    FieldElement51_Neg_neg.call (FieldElement51_Neg_neg.args (.value out) (.value a)) s =
      .value
        (.nil,
          { s with
            mem := s.mem.storeLimbs out (FieldElement51_Neg_neg.spec (s.mem.readLimbs a)) }) := by
  func_init
  have ha₀ : S₀.mem.LimbsFit a := hS ▸ ha
  have ha_0 := fits_pair0 ha
  have ha_8 := fits_pair ha (k := 8#64) (by decide)
  have ha_24 := fits_pair ha (k := 24#64) (by decide)
  have hout_8 := room_pair hout (k := 8#64) (by decide)
  have hout_24 := room_pair hout (k := 24#64) (by decide)
  have hoff := hout.1
  block_init
  iterate 12 step_pure
  step_load
  step_load
  iterate 7 step_pure
  step_store
  step_pure
  step_load
  iterate 9 step_pure
  step_store
  step_store
  finish_block
  rw [hS, storeAt_pairs_eq_storeLimbs' hoff]
  simp only [Vector.getElem_ofFn, Fin.zero_eta, Fin.mk_one, lane0_readAt, lane1_readAt0 ha₀,
    lane1_readAt ha₀ (k := 8#64) (by decide), lane1_readAt ha₀ (k := 24#64) (by decide)]
  congr

end Proof

end MLIR.Agave.Serial
