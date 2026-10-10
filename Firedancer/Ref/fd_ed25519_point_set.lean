module

public import MLIR.Run.Tactic
public import Firedancer.Common.Point
public import Firedancer.Ref.fd_f25519_set
public import Firedancer.Ref.Mlir.fd_ed25519_point_set

namespace MLIR.Firedancer.Ref

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_set` copies the point at `a` to `r`, in another block, and returns `r`. -/
public theorem fd_ed25519_point_set.call_eq (r a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.PointRoom r) (ha : s.mem.PointFit a) (hsep : r.id ≠ a.id) :
    fd_ed25519_point_set.call (fd_ed25519_point_set.args (.value r) (.value a)) s =
      .value (.cons (.value r) .nil, { s with mem := s.mem.storePoint r (s.mem.readPoint a) }) := by
  func_init
  block_init
  step_call using (fd_f25519_set.call_eq (hsep := .inr ?_))
  iterate 3 
    step_pure
    step_pure
    step_call using (fd_f25519_set.call_eq (hsep := .inr ?_))
  finish_block
  subst hS
  rfl

end Proof

end MLIR.Firedancer.Ref
