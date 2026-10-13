module

public import MLIR.Run.Tactic
public import Agave.Common.Limbs
public import Agave.Serial.Mlir.FieldElement51_Add_add

namespace MLIR.Agave.Serial

/-! ## Specification -/

@[expose] public section

/-- `self + _rhs` limbwise, without carrying (`add_assign`'s `self.0[i] += _rhs.0[i]`). -/
def FieldElement51_Add_add.spec (a b : Fin 5 → BitVec 64) : Fin 5 → BitVec 64
  | k => a k + b k

end

/-! ## Proof -/

section Proof

/-- `&a + &b` stores `spec a b` at `out`, the first four limbs as two vector pairs. `out` is the
fresh `sret` slot, apart from `a` and `b`; `a` and `b` may alias. -/
public theorem FieldElement51_Add_add.call_eq (out a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (ha : s.mem.LimbsFit a) (hb : s.mem.LimbsFit b)
    (hsepa : out.id ≠ a.id) (hsepb : out.id ≠ b.id) :
    FieldElement51_Add_add.call (FieldElement51_Add_add.args (.value out) (.value a) (.value b)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs out
                (FieldElement51_Add_add.spec (s.mem.readLimbs a) (s.mem.readLimbs b)) }) := by
  func_init
  have ha₀ : S₀.mem.LimbsFit a := hS ▸ ha
  have hb₀ : S₀.mem.LimbsFit b := hS ▸ hb
  have ha_lo := MemoryState.LimbsFit.fits_lo ha
  have ha_hi := MemoryState.LimbsFit.fits_pair ha (k := 16#64) (by decide)
  have hb_lo := MemoryState.LimbsFit.fits_lo hb
  have hb_hi := MemoryState.LimbsFit.fits_pair hb (k := 16#64) (by decide)
  have hout_lo := MemoryState.LimbsRoom.room_lo hout
  have hout_hi := MemoryState.LimbsRoom.room_pair hout (k := 16#64) (by decide)
  have hoff := hout.1
  block_init
  -- the last limb
  step_pure
  step_pure
  step_load
  step_pure
  step_pure
  step_load
  step_pure
  -- the limb pairs
  step_load
  step_load
  step_pure
  step_store
  step_pure
  step_load
  step_load
  step_pure
  step_store
  step_pure
  step_store
  finish_block
  rw [hS, MemoryState.storeAt_packLanes_limbs hoff]
  simp only [Vector.getElem_ofFn, Fin.zero_eta, Fin.mk_one, MemoryState.extractVecElem_zero_readAt,
    MemoryState.LimbsFit.extractVecElem_one_lo ha₀, MemoryState.LimbsFit.extractVecElem_one_lo hb₀,
    MemoryState.LimbsFit.extractVecElem_one ha₀ (k := 16#64) (by decide),
    MemoryState.LimbsFit.extractVecElem_one hb₀ (k := 16#64) (by decide)]
  congr
  funext k
  fin_cases k <;> rfl

end Proof

end MLIR.Agave.Serial
