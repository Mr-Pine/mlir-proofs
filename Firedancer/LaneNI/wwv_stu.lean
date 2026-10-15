module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.LaneNI.Mlir.wwv_stu

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512

/-! ## Proof -/

section Proof

/-- `wwv_stu` stores the eight lanes of `v` at `p`, unaligned. -/
public theorem _root_.Firedancer.LaneNI.Mlir.wwv_stu.call_eq (p : Pointer) (v : Wwl)
    (s : GlobalState) (hwf : s.WF) (hp : Room s.mem p 512) :
    Firedancer.LaneNI.Mlir.wwv_stu.call
        (Firedancer.LaneNI.Mlir.wwv_stu.args (.value p) (Ty.wrap v)) s =
      .value (.nil, { s with mem := s.mem.storeVec p v }) := by
  func_init
  block_init
  step_store
  finish_block
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.LaneNI
