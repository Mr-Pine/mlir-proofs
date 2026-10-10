module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Boringssl.fe_sq_tt
public import Boringssl.fe_add
public import Boringssl.fe_carry
public import Boringssl.Mlir.fe_sq2_tt

namespace MLIR.Boringssl

/-! ## Specification -/

@[expose] public section

/-- `2 f²`: the square, added to itself, carried. -/
def fe_sq2_tt.spec (f : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let h := Firedancer.Ref.fiat_25519_carry_square.spec f
  Firedancer.Ref.fiat_25519_carry.spec (Firedancer.Ref.fiat_25519_add.spec h h)

end

/-! ## Proof -/

section Proof

attribute [local mlir_state] MemoryState.readLimbs_storeLimbs_self
  MemoryState.readLimbs_storeLimbs_of_id_ne MemoryState.readLimbs_alloca

/-- `fe_sq2_tt` stores `spec f` at `h`; `h` may alias `f`. The temporary is freed again: only the
counter moves on. -/
public theorem fe_sq2_tt.call_eq (h f : Pointer) (s : GlobalState) (hwf : s.WF)
    (hh : s.mem.LimbsRoom h) (hf : s.mem.LimbsFit f) :
    fe_sq2_tt.call (fe_sq2_tt.args (.value h) (.value f)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem := s.mem.storeLimbs h (fe_sq2_tt.spec (s.mem.readLimbs f)) }) := by
  func_init
  block_init
  step_pure
  -- fe_loose tmp;
  step_alloca with tmp
  -- fe_sq_tt(h, f);
  step_call using fe_sq_tt.call_eq
  name_limbs sq
  step_pure
  limbs_room tmp
  -- fe_add(&tmp, h, h);
  step_call using fe_add.call_eq
  -- fe_carry(h, &tmp);
  step_call using fe_carry.call_eq
  step_pure
  finish_block
  subst hS
  erase_frame
  clear_reads
  subst_vars
  rw [MemoryState.storeLimbs_storeLimbs_self]
  rfl

end Proof

end MLIR.Boringssl
