module

public import Firedancer.LaneNI.Mlir.fd_int_min
public import MLIR.Run.Tactic

namespace MLIR.Firedancer.LaneNI

/-! ## Proof -/

section Proof

/-- `fd_int_min( a, b )` returns the signed minimum and leaves the state as it is. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_int_min.call_eq (a b : BitVec 32) (s : GlobalState)
    (hwf : s.WF) :
    Firedancer.LaneNI.Mlir.fd_int_min.call
        (Firedancer.LaneNI.Mlir.fd_int_min.args (.value a) (.value b)) s =
      .value (.cons (.value (if a.slt b then a else b)) .nil, s) := by
  func_init
  block_init
  step_pure
  finish_block
  subst hS
  rfl

end Proof

end MLIR.Firedancer.LaneNI
