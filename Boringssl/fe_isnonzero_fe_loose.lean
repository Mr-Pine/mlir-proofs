module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Boringssl.fe_carry
public import Boringssl.fe_isnonzero_fe
public import Boringssl.Mlir.fe_isnonzero_fe_loose

namespace MLIR.Boringssl

/-! ## Specification -/

@[expose] public section

/-- `fe_isnonzero` of `f` carried. -/
def fe_isnonzero_fe_loose.spec (f : Fin 5 → BitVec 64) : BitVec 32 :=
  fe_isnonzero_fe.spec (Firedancer.Ref.fiat_25519_carry.spec f)

end

/-! ## Proof -/

section Proof

attribute [local mlir_state] MemoryState.readLimbs_storeLimbs_self
  MemoryState.readLimbs_storeLimbs_of_id_ne MemoryState.readLimbs_alloca

/-- `fe_isnonzero` (of a `fe_loose`) returns `spec f`. The tight copy and `fe_isnonzero`'s 23
blocks are freed again: only the counter moves on. -/
public theorem fe_isnonzero_fe_loose.call_eq (f : Pointer) (s : GlobalState) (hwf : s.WF)
    (hf : s.mem.LimbsFit f) :
    fe_isnonzero_fe_loose.call (fe_isnonzero_fe_loose.args (.value f)) s =
      .value
        (.cons (.value (fe_isnonzero_fe_loose.spec (s.mem.readLimbs f))) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 24⟩, mem := s.mem }) := by
  func_init
  block_init
  step_pure
  -- fe tight;
  step_alloca with tight
  step_pure
  limbs_room tight
  -- fe_carry(&tight, f);
  step_call using fe_carry.call_eq consuming hf
  -- return fe_isnonzero(&tight);
  step_call using fe_isnonzero_fe.call_eq
  step_pure
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Boringssl
