module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Boringssl.fe_copy_lt
public import Boringssl.fe_loose_invert
public import Boringssl.Mlir.fe_invert

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

attribute [local mlir_state] MemoryState.readLimbs_storeLimbs_self
  MemoryState.readLimbs_storeLimbs_of_id_ne MemoryState.readLimbs_alloca

/-- `fe_invert` stores `fe_loose_invert.spec z` (`z ^ (p - 2)`) at `out`; `out` may alias `z`. The
loose copy and `fe_loose_invert`'s four temporaries are freed again: only the counter moves on. -/
public theorem fe_invert.call_eq (out z : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (hz : s.mem.LimbsFit z) :
    fe_invert.call (fe_invert.args (.value out) (.value z)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 5⟩,
            mem := s.mem.storeLimbs out (fe_loose_invert.spec (s.mem.readLimbs z)) }) := by
  func_init
  block_init
  step_pure
  -- fe_loose l;
  step_alloca with l
  step_pure
  limbs_room l
  -- fe_copy_lt(&l, z);
  step_call using fe_copy_lt.call_eq
  -- fe_loose_invert(out, &l);
  step_call using fe_loose_invert.call_eq
  step_pure
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Boringssl
