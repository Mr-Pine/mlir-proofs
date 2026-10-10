module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.fd_ed25519_point_set
public import Firedancer.R52x5.Mlir.fd_ed25519_point_add_final_mul

namespace MLIR.Firedancer.R52x5

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_add_final_mul` copies the point at `a` to `r`, which is `a` or in another
block, and returns `r`. -/
public theorem fd_ed25519_point_add_final_mul.call_eq (r a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.Quad5Room r) (ha : s.mem.Quad5Fit a) (hsep : r = a ∨ r.id ≠ a.id) :
    fd_ed25519_point_add_final_mul.call (fd_ed25519_point_add_final_mul.args (.value r) (.value a))
        s =
      .value (.cons (.value r) .nil, { s with mem := s.mem.storeQuad5 r (s.mem.readQuad5 a) }) := by
  func_init
  block_init
  step_call using fd_ed25519_point_set.call_eq
  finish_block
  subst hS
  rfl

end Proof

end MLIR.Firedancer.R52x5
