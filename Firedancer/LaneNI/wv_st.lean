module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.LaneNI.Mlir.wv_st

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512

/-! ## Proof -/

section Proof

/-- `wv_st` stores the four lanes of `v` at `p`. -/
public theorem _root_.Firedancer.LaneNI.Mlir.wv_st.call_eq (p : Pointer) (v : Wv)
    (s : GlobalState) (hwf : s.WF) (hp : Room s.mem p 256) :
    Firedancer.LaneNI.Mlir.wv_st.call
        (Firedancer.LaneNI.Mlir.wv_st.args (.value p) (Ty.wrap (t := .vec 4 64) v)) s =
      .value (.nil, { s with mem := s.mem.storeAt p (BitVec.packLanes v) }) := by
  func_init
  block_init
  step_store
  finish_block
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.LaneNI
