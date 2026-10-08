module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.Avx512.Mlir.fd_ed25519_point_set

namespace LeanMLIR.RIR.Firedancer.Avx512

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_set` copies the point at `a` to `r`, which is `a` itself or in another block,
and returns `r`. -/
public theorem fd_ed25519_point_set.call_eq (r a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.QuadFit r) (ha : s.mem.QuadFit a) (hsep : r.id ≠ a.id) :
    fd_ed25519_point_set.call (fd_ed25519_point_set.args (.value r) (.value a)) s =
      .value (.cons (.value r) .nil, { s with mem := s.mem.storeQuad r (s.mem.readQuad a) }) := by
  func_init
  block_init
  step_load
  step_store
  iterate 2
    step_pure
    step_load
    step_pure
    step_store
  finish_block
  subst hS
  rfl

end Proof

end LeanMLIR.RIR.Firedancer.Avx512
