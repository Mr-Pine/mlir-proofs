module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.Avx512.fd_ed25519_point_set
public import Firedancer.Avx512.Mlir.fd_ed25519_point_add_final_mul_projective

namespace LeanMLIR.RIR.Firedancer.Avx512

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_add_final_mul_projective` copies the point at `a` to `r`, in another block,
and returns `r`. -/
public theorem fd_ed25519_point_add_final_mul_projective.call_eq (r a : Pointer) (s : GlobalState)
    (hwf : s.WF) (hr : s.mem.QuadFit r) (ha : s.mem.QuadFit a) (hsep : r.id ≠ a.id) :
    fd_ed25519_point_add_final_mul_projective.call
        (fd_ed25519_point_add_final_mul_projective.args (.value r) (.value a)) s =
      .value (.cons (.value r) .nil, { s with mem := s.mem.storeQuad r (s.mem.readQuad a) }) := by
  func_init
  block_init
  step_call using fd_ed25519_point_set.call_eq
  finish_block
  subst hS
  rfl

end Proof

end LeanMLIR.RIR.Firedancer.Avx512
