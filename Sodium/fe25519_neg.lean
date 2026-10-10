module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Sodium.fe25519_0
public import Sodium.fe25519_sub
public import Sodium.Mlir.fe25519_neg

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

/-- `-f`: `0 - f` by `fe25519_sub`. -/
def fe25519_neg.spec (f : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  fe25519_sub.spec Boringssl.fe_0.spec f

end

/-! ## Proof -/

section Proof

attribute [local mlir_state] MemoryState.readLimbs_storeLimbs_self
  MemoryState.readLimbs_storeLimbs_of_id_ne MemoryState.LimbsFit.storeLimbs

/-- `fe25519_neg` stores `spec f` at `h`, by `fe25519_sub` from a zero temporary; `h` may alias
`f`. The temporary is freed again: only the counter moves on, by one block. -/
public theorem fe25519_neg.call_eq (h f : Pointer) (s : GlobalState) (hwf : s.WF)
    (hh : s.mem.LimbsRoom h) (hf : s.mem.LimbsFit f) :
    fe25519_neg.call (fe25519_neg.args (.value h) (.value f)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem := s.mem.storeLimbs h (fe25519_neg.spec (s.mem.readLimbs f)) }) := by
  func_init
  block_init
  step_pure
  -- fe25519 zero;
  step_alloca with zero
  step_pure
  limbs_room zero
  -- fe25519_0(zero);
  step_call using fe25519_0.call_eq
  -- fe25519_sub(h, zero, f);
  step_call using fe25519_sub.call_eq
  step_pure
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Sodium
