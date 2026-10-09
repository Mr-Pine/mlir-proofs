module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.QuadMem
public import Firedancer.R52x5.Mlir.fd_ed25519_point_set

namespace MLIR.Firedancer.R52x5

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_set` copies the point at `a` to `r`, which is `a` or in another block, and
returns `r`. -/
public theorem fd_ed25519_point_set.call_eq (r a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.Quad5Fit r) (ha : s.mem.Quad5Fit a) (hsep : r = a ∨ r.id ≠ a.id) :
    fd_ed25519_point_set.call (fd_ed25519_point_set.args (.value r) (.value a)) s =
      .value (.cons (.value r) .nil, { s with mem := s.mem.storeQuad5 r (s.mem.readQuad5 a) }) := by
  rcases hsep with rfl | hsep
  all_goals
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
    subst hS
    rfl

end Proof

end MLIR.Firedancer.R52x5
