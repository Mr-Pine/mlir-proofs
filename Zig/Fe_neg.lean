module

public import SSA.Projects.RIR.Run.Tactic
public import Common.LimbsBits
public import Common.Tactics
public import Zig.Fe_sub
public import Zig.Globals
public import Zig.Mlir.Fe_neg

namespace LeanMLIR.RIR.Zig

/-! ## Specification -/

@[expose] public section

/-- `-a`: `0 - a`. -/
def Fe.neg.spec (a : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  Fe.sub.spec (fun _ => 0#64) a

end

/-! ## Proof -/

section Proof

/-- `Fe.neg` stores `spec a` at `out`, for limbs below `2^63`. -/
public theorem Fe_neg.call_eq (out a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsFit out) (ha : s.mem.LimbsFit a) (ha' : Fe.Lt (s.mem.readLimbs a) (2 ^ 63)) :
    Fe_neg.call (Fe_neg.args (.value out) (.value a)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩,
            mem := s.mem.storeLimbs out (Fe.neg.spec (s.mem.readLimbs a)) }) := by
  func_init
  have haL₀ : S₀.mem.LimbsFit a := hS ▸ ha
  block_init
  step_pure
  step_addressof Fe_zero.value_eq with z
  have hzl : S.mem.readLimbs z = fun _ => 0#64 := by
    rw [MemoryState.readLimbs_of_readAt_fe hz_fits hz_off hread_z]
    funext i; fin_cases i <;> rfl
  have hz' : Fe.Lt (S.mem.readLimbs z) (2 ^ 63) := by
    rw [hzl]; intro i; simp
  have hzl₀ := hzl
  rw [hS] at hzl₀
  dsimp only at hzl₀
  limbs_fit z
  clear hread_z hzl
  have hz_ne : z.id ≠ S.allocaPtr.id := by
    subst hz hS; simp [GlobalState.allocaPtr, GlobalState.slot]
  step_pure
  step_alloca with t
  limbs_fit t
  have htL₀ := hS ▸ ht_limbs
  step_call using Fe_sub.call_eq
  have hout320 := hout.fits
  have ht320 := ht_limbs.fits
  step_memcpy consuming hout320 ht320 ha' hz'
  finish_block
  have hT := ht_limbs.fits
  rw [hS, Fits.storeAt_iff] at hT
  rw [hS, MemoryState.storeAt_readAt_eq_storeLimbs hT ht_limbs.1 hout.1,
    MemoryState.readLimbs_storeLimbs_self htL₀]
  simp only [hzl₀]
  erase_frame
  simp [GlobalState.alloca, Fe.neg.spec]

end Proof

end LeanMLIR.RIR.Zig
