module

public import MLIR.Run.Tactic
public import Agave.Common.Point
public import Firedancer.Common.Tactics
public import Agave.Serial.FieldElement51_Add_add
public import Agave.Serial.FieldElement51_Sub_sub
public import Agave.Serial.FieldElement51_Mul_mul
public import Agave.Serial.Mlir.EdwardsPoint_as_projective_niels
import Mathlib.Tactic.FinCases
import all MLIR.Ty

namespace MLIR.Agave.Serial

/-! ## Specification -/

@[expose] public section

/-- `constants::EDWARDS_D2`'s limbs, `2d`. -/
def EDWARDS_D2 : Fin 5 → BitVec 64 := fun i =>
  #v[1859910466990425#64, 932731440258426#64, 1072319116312658#64, 1815898335770999#64,
      633789495995903#64][i]

/-- `EdwardsPoint::as_projective_niels`: `(Y + X, Y - X, Z, T · 2d)`. -/
def EdwardsPoint_as_projective_niels.spec (P : EdwardsPoint) : ProjectiveNielsPoint :=
  ⟨FieldElement51_Add_add.spec P.Y P.X, FieldElement51_Sub_sub.spec P.Y P.X, P.Z,
    FieldElement51_Mul_mul.spec P.T EDWARDS_D2⟩

end

/-! ## Proof -/

section Proof

public theorem anon_042b818bc72209407b52bd0e4d6c8368_50.value_eq (s : GlobalState) :
    anon_042b818bc72209407b52bd0e4d6c8368_50.value s =
      .value (Ty.wrap anon_042b818bc72209407b52bd0e4d6c8368_50.lit, s) :=
  GlobalInitializer.compute_value _ _ ⟨_, by with_unfolding_all rfl⟩

/-- `EDWARDS_D2`'s limbs, at the block `addressof` stores them in. -/
public theorem anon_042b818bc72209407b52bd0e4d6c8368_50.readLimbs {m : MemoryState} {p : Pointer}
    {hw : (Ty.array 40 (.bv 8)).width = 320} (hf : Fits m p 320) (ho : p.offset = 0)
    (h : m.readAt p 320 = Ty.flatBits anon_042b818bc72209407b52bd0e4d6c8368_50.lit (hw := hw)) :
    m.readLimbs p = EDWARDS_D2 := by
  rw [MemoryState.readLimbs_of_readAt hf ho h]
  funext i
  fin_cases i <;> clear h hf ho <;> decide +kernel +revert

/-- `P.as_projective_niels()` stores `spec P` at `out`, the `sret` slot, apart from `P`; `Z` is a
copy. The global `EDWARDS_D2` counts one block. -/
public theorem EdwardsPoint_as_projective_niels.call_eq (out p : Pointer) (s : GlobalState)
    (hwf : s.WF) (hout : s.mem.PointRoom out) (hp : s.mem.PointFit p) (hsep : out.id ≠ p.id) :
    EdwardsPoint_as_projective_niels.call
        (EdwardsPoint_as_projective_niels.args (.value out) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem :=
              s.mem.storeNiels out
                (EdwardsPoint_as_projective_niels.spec (s.mem.readEdwards p)) }) := by
  func_init
  block_init
  -- `P`'s coordinates, read before the global's block
  have hX : S.mem.readLimbs p = S₀.mem.readLimbs p := by rw [hS]
  have hY : S.mem.readLimbs (p.add 40#64) = S₀.mem.readLimbs (p.add 40#64) := by rw [hS]
  have hZ : S.mem.readAt (p.add 80#64) 320 = limbsBits (S₀.mem.readLimbs (p.add 80#64)) := by
    rw [hS]; exact readAt_eq_limbsBits (hS ▸ hp).limbsFit_T
  have hT : S.mem.readLimbs (p.add 120#64) = S₀.mem.readLimbs (p.add 120#64) := by rw [hS]
  step_pure
  step_addressof anon_042b818bc72209407b52bd0e4d6c8368_50.value_eq with d2
  have hd2_read :=
    MLIR.Agave.Serial.anon_042b818bc72209407b52bd0e4d6c8368_50.readLimbs hd2_fits hd2_off hread_d2
  clear hread_d2
  limbs_fit d2
  -- Y_plus_X: &self.Y + &self.X
  step_pure
  step_call using FieldElement51_Add_add.call_eq
  -- Y_minus_X: &self.Y - &self.X
  step_pure
  step_call using FieldElement51_Sub_sub.call_eq
  -- Z: self.Z
  step_pure
  step_pure
  have hroom_Z := room_of_limbsRoom hout.limbsRoom_T
  have hfits_Z := fits_of_limbsFit hp.limbsFit_T
  step_memcpy
  -- T2d: &self.T * &constants::EDWARDS_D2
  step_pure
  step_pure
  step_call using FieldElement51_Mul_mul.call_eq
  finish_block
  have hoZ := hout.limbsRoom_T.1
  subst hS
  erase_frame
  rw [← storeLimbs_eq_storeAt hoZ]
  rfl

end Proof

end MLIR.Agave.Serial
