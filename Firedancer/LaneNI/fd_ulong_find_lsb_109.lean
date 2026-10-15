module

public import Firedancer.LaneNI.Mlir.fd_ulong_find_lsb_109
public import MLIR.Run.Tactic
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.LaneNI

/-! ## Proof -/

section Proof

/-- A 64-bit trailing zero count fits an `int`: truncated and widened again, it is itself. -/
private theorem ctz_trunc32 (x : BitVec 64) :
    (x.ctz.setWidth 32).setWidth 64 = x.ctz ∧ (x.ctz.setWidth 32).signExtend 64 = x.ctz := by
  bv_decide

/-- `fd_ulong_find_lsb( x )` of a nonzero `x` returns its trailing zero count and leaves the state
as it is. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_ulong_find_lsb_109.call_eq (x : BitVec 64)
    (s : GlobalState) (hwf : s.WF) (hx : x ≠ 0#64) :
    Firedancer.LaneNI.Mlir.fd_ulong_find_lsb_109.call
        (Firedancer.LaneNI.Mlir.fd_ulong_find_lsb_109.args (.value x)) s =
      .value (.cons (.value (x.ctz.setWidth 32)) .nil, s) := by
  func_init
  block_init
  step_pure [hx]
  step_pure [hx, ctz_trunc32]
  finish_block
  subst hS
  rfl

end Proof

end MLIR.Firedancer.LaneNI
