module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Zig.Fe_sub
public import Zig.Common.Globals
public import Zig.Mlir.Fe_neg

namespace MLIR.Zig

/-! ## Specification -/

@[expose] public section

/-- `-a`: `0 - a`. -/
def Fe.neg.spec (a : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  Fe.sub.spec (fun _ => 0#64) a

end

/-- `-a`'s limbs are below `2^53`, whatever `a`'s. -/
public theorem Fe.neg.spec_lt53 (a : Fin 5 → BitVec 64) : Fe.Lt (Fe.neg.spec a) (2 ^ 53) :=
  (Fe.sub.spec_lt (A := 1) (b := a) (fun _ => by simp) (by decide)).mono (by decide)

/-! ## Proof -/

section Proof

/-- `Fe.neg` stores `spec a` at `out`, for limbs below `2^63`. -/
public theorem Fe_neg.call_eq (out a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals Fe_neg.globals) (hout : s.mem.LimbsRoom out) (ha : s.mem.LimbsFit a)
    (ha' : Fe.Lt (s.mem.readLimbs a) (2 ^ 63)) :
    Fe_neg.call (Fe_neg.args (.value out) (.value a)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem := s.mem.storeLimbs out (Fe.neg.spec (s.mem.readLimbs a)) }) := by
  func_init
  have ha₀ : S₀.mem.LimbsFit a := hS ▸ ha
  have hoa : out.offset.toNat + 32 < 2 ^ 64 := hout.1
  block_init
  step_pure
  step_addressof Fe_zero.value_eq with z
  have hzl : S.mem.readLimbs z = fun _ => 0#64 := by
    rw [MemoryState.readLimbs_of_readAt_fe hz_fits hz_off hread_z]
    funext i; fin_cases i <;> rfl
  have hz' : Fe.Lt (S.mem.readLimbs z) (2 ^ 63) := by
    rw [hzl]; intro i; simp
  limbs_fit z
  step_pure
  step_alloca with t
  limbs_room t
  step_call using Fe_sub.call_eq
  have hout320 := hout.room
  have ht320 := ht_limbs.fits
  have htm := hS ▸ ht_limbs
  have htr := hS ▸ hread_t_readLimbs
  step_memcpy consuming hout320 ht320 ha' hz'
  finish_block
  rw [hS]
  dsimp only
  rw [MemoryState.storeAt_readAt_eq_storeLimbs htm hoa, htr]
  erase_frame
  simp [GlobalState.alloca, Fe.neg.spec]

end Proof

end MLIR.Zig
