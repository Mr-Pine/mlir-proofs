module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Zig.Fe_reduce
public import Zig.Mlir.Fe_isZero

namespace MLIR.Zig

/-! ## Specification -/

@[expose] public section

/-- Whether `a`'s canonical limbs are all zero: `1` exactly then. -/
def Fe.isZero.spec (a : Fin 5 → BitVec 64) : BitVec 1 :=
  let r := Fe.reduce.spec a
  BitVec.ofBool (r 1 ||| r 0 ||| r 2 ||| r 3 ||| r 4 == 0#64)

end

/-! ## Proof -/

section Proof

/-- `Fe.isZero` returns `spec a`, for limbs below `2^63`. -/
public theorem Fe_isZero.call_eq (a : Pointer) (s : GlobalState) (hwf : s.WF)
    (ha : s.mem.LimbsFit a) (ha' : Fe.Lt (s.mem.readLimbs a) (2 ^ 63)) :
    Fe_isZero.call (Fe_isZero.args (.value a)) s =
      .value
        (.cons (.value (Fe.isZero.spec (s.mem.readLimbs a))) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩, mem := s.mem }) := by
  func_init
  have haL₀ : S₀.mem.LimbsFit a := hS ▸ ha
  have ha'₀ : Fe.Lt (S₀.mem.readLimbs a) (2 ^ 63) := hS ▸ ha'
  block_init
  iterate 3 step_pure
  step_alloca with t
  have htR : (S₀.alloca 40).mem.LimbsRoom t := MemoryState.LimbsRoom.of_room (hS ▸ ht_room) ht_off
  have ht320 := ht_room
  have ha320 := ha.fits
  step_memcpy consuming ha320 ht320
  have hcopy : S.mem.readLimbs t = S₀.mem.readLimbs a := by
    rw [hS]
    dsimp only
    rw [MemoryState.storeAt_readAt_eq_storeLimbs haL₀ htR.1,
      MemoryState.readLimbs_storeLimbs_self htR]
  have ht_limbs := MemoryState.LimbsFit.of_fits' hfits_t htR.1
  have ht' : Fe.Lt (S.mem.readLimbs t) (2 ^ 63) := hcopy ▸ ha'₀
  have hcopy₀ := hcopy
  rw [hS] at hcopy₀
  dsimp only at hcopy₀
  step_call using Fe_reduce.call_eq consuming ht' hcopy
  step_load
  iterate 4 
    step_pure
    step_load
    step_pure
  step_pure
  finish_block
  rw [hS]
  erase_frame
  simp [GlobalState.alloca, Fe.isZero.spec]

/-- `call_eq` on the limbs `A` read at `a`. -/
public theorem Fe_isZero.call_eq_of (a : Pointer) (s : GlobalState) (hwf : s.WF)
    (ha : s.mem.LimbsFit a) (hA : s.mem.readLimbs a = A) (hA' : Fe.Lt A (2 ^ 63)) :
    Fe_isZero.call (Fe_isZero.args (.value a)) s =
      .value
        (.cons (.value (Fe.isZero.spec A)) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩, mem := s.mem }) := by
  subst hA
  exact Fe_isZero.call_eq a s hwf ha hA'

end Proof

end MLIR.Zig
