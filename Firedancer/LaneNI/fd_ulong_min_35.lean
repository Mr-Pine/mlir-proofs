module

public import Firedancer.LaneNI.Mlir.fd_ulong_min_35
public import MLIR.Run.Tactic

namespace MLIR.Firedancer.LaneNI

/-! ## Proof -/

section Proof

/-- `fd_ulong_min( x, FD_BALLET_CURVE25519_MSM_BATCH_SZ )`, specialized: the unsigned minimum of
`x` and `32`; the state is left as it is. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_ulong_min_35.call_eq (x : BitVec 64)
    (s : GlobalState) (hwf : s.WF) :
    Firedancer.LaneNI.Mlir.fd_ulong_min_35.call
        (Firedancer.LaneNI.Mlir.fd_ulong_min_35.args (.value x)) s =
      .value (.cons (.value (if x.ult 32#64 then x else 32#64)) .nil, s) := by
  func_init
  block_init
  step_pure
  step_pure
  finish_block
  subst hS
  rfl

end Proof

end MLIR.Firedancer.LaneNI
