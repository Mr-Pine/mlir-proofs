module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.LaneNI.Mlir.wwv_st
public import Firedancer.LaneNI.Mlir.wwv_st_10

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512

/-! ## Proof -/

section Proof

/-- `wwv_st` stores the eight lanes of `v` at `p`. -/
public theorem _root_.Firedancer.LaneNI.Mlir.wwv_st.call_eq (p : Pointer) (v : Wwl)
    (s : GlobalState) (hwf : s.WF) (hp : Room s.mem p 512) :
    Firedancer.LaneNI.Mlir.wwv_st.call
        (Firedancer.LaneNI.Mlir.wwv_st.args (.value p) (Ty.wrap v)) s =
      .value (.nil, { s with mem := s.mem.storeVec p v }) := by
  func_init
  block_init
  step_store
  finish_block
  subst_vars
  rfl

/-- `wwv_st_10` is `wwv_st` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.wwv_st_10.call_eq (p : Pointer) (v : Wwl)
    (s : GlobalState) (hwf : s.WF) (hp : Room s.mem p 512) :
    Firedancer.LaneNI.Mlir.wwv_st_10.call
        (Firedancer.LaneNI.Mlir.wwv_st_10.args (.value p) (Ty.wrap v)) s =
      .value (.nil, { s with mem := s.mem.storeVec p v }) :=
  Firedancer.LaneNI.Mlir.wwv_st.call_eq p v s hwf hp

end Proof

end MLIR.Firedancer.LaneNI
