module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_set
public import Firedancer.Avx512.fd_ed25519_point_set

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_set` copies the point at `a` to `r`, which is `a` itself or in another block,
and returns `r`. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_ed25519_point_set.call_eq
    (r a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.QuadRoom r) (ha : s.mem.QuadFit a) (hsep : r.id ≠ a.id) :
    Firedancer.LaneNI.Mlir.fd_ed25519_point_set.call
        (Firedancer.LaneNI.Mlir.fd_ed25519_point_set.args (.value r) (.value a)) s =
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

end MLIR.Firedancer.LaneNI
