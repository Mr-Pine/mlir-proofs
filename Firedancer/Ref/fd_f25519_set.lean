module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Common.Limbs
public import Firedancer.Ref.Mlir.fd_f25519_set

namespace LeanMLIR.RIR.Firedancer.Ref

/-! ## Proof -/

section Proof

/-- With both field elements in memory, in separate blocks, `set` copies `src`'s limbs to `dst`
and returns `dst`. -/
public theorem fd_f25519_set.call_eq (dst src : Pointer) (s : GlobalState) (hwf : s.WF)
    (hdst : s.mem.LimbsFit dst) (hsrc : s.mem.LimbsFit src) (hsep : dst.id ≠ src.id) :
    fd_f25519_set.call (fd_f25519_set.args (.value dst) (.value src)) s =
      .value
        (.cons (.value dst) .nil,
          { s with mem := s.mem.storeLimbs dst (s.mem.readLimbs src) }) := by
  func_init
  block_init
  step_load
  step_store
  iterate 4 
    step_pure
    step_load
    step_pure
    step_store
  finish_block
  simp [hS, MemoryState.storeLimbs]
  rfl

end Proof

end LeanMLIR.RIR.Firedancer.Ref
