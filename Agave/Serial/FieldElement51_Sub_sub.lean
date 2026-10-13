module

public import MLIR.Run.Tactic
public import Agave.Common.Limbs
public import Agave.Serial.FieldElement51
public import Agave.Serial.Mlir.FieldElement51_Sub_sub

namespace MLIR.Agave.Serial

/-! ## Specification -/

@[expose] public section

/-- `reduce` of `(self.0[i] + 16 p[i]) - _rhs.0[i]`. -/
def FieldElement51_Sub_sub.spec (a b : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  FieldElement51.reduce fun i => a i + p16 i - b i

end

/-! ## Proof -/

section Proof

/-- `&a - &b` stores `spec a b` at `out`, limbs 1 to 4 as two vector pairs. `out` is the fresh
`sret` slot, apart from `a` and `b`; `a` and `b` may alias. -/
public theorem FieldElement51_Sub_sub.call_eq (out a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (ha : s.mem.LimbsFit a) (hb : s.mem.LimbsFit b)
    (hsepa : out.id ≠ a.id) (hsepb : out.id ≠ b.id) :
    FieldElement51_Sub_sub.call (FieldElement51_Sub_sub.args (.value out) (.value a) (.value b)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs out
                (FieldElement51_Sub_sub.spec (s.mem.readLimbs a) (s.mem.readLimbs b)) }) := by
  func_init
  have ha₀ : S₀.mem.LimbsFit a := hS ▸ ha
  have hb₀ : S₀.mem.LimbsFit b := hS ▸ hb
  have ha_0 := MemoryState.LimbsFit.fits_lo ha
  have ha_8 := MemoryState.LimbsFit.fits_pair ha (k := 8#64) (by decide)
  have ha_24 := MemoryState.LimbsFit.fits_pair ha (k := 24#64) (by decide)
  have hb_0 := MemoryState.LimbsFit.fits_lo hb
  have hb_8 := MemoryState.LimbsFit.fits_pair hb (k := 8#64) (by decide)
  have hb_24 := MemoryState.LimbsFit.fits_pair hb (k := 24#64) (by decide)
  have hout_8 := MemoryState.LimbsRoom.room_pair hout (k := 8#64) (by decide)
  have hout_24 := MemoryState.LimbsRoom.room_pair hout (k := 24#64) (by decide)
  have hoff := hout.1
  block_init
  iterate 14 step_pure
  step_load
  step_load
  step_pure
  step_load
  step_pure
  step_load
  iterate 7 step_pure
  step_store
  step_pure
  step_load
  step_pure
  step_load
  iterate 9 step_pure
  step_store
  step_store
  finish_block
  rw [hS, storeAt_pairs_eq_storeLimbs' hoff]
  simp only [Vector.getElem_ofFn, Fin.zero_eta, Fin.mk_one, MemoryState.extractVecElem_zero_readAt,
    MemoryState.LimbsFit.extractVecElem_one_lo ha₀, MemoryState.LimbsFit.extractVecElem_one_lo hb₀,
    MemoryState.LimbsFit.extractVecElem_one ha₀ (k := 8#64) (by decide),
    MemoryState.LimbsFit.extractVecElem_one hb₀ (k := 8#64) (by decide),
    MemoryState.LimbsFit.extractVecElem_one ha₀ (k := 24#64) (by decide),
    MemoryState.LimbsFit.extractVecElem_one hb₀ (k := 24#64) (by decide)]
  congr

end Proof

end MLIR.Agave.Serial
