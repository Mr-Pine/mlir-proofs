module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.LaneNI.Mlir.wv_stu
public import Firedancer.LaneNI.Mlir.wv_stu_17
public import Firedancer.LaneNI.Mlir.wv_stu_33
public import Firedancer.LaneNI.Mlir.wv_stu_42
public import Firedancer.LaneNI.Mlir.wv_stu_59
public import Firedancer.LaneNI.Mlir.wv_stu_91

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512

/-! ## Proof -/

section Proof

/-- `wv_stu` stores the four lanes of `v` at `p`, unaligned. -/
public theorem _root_.Firedancer.LaneNI.Mlir.wv_stu.call_eq (p : Pointer) (v : Wv)
    (s : GlobalState) (hwf : s.WF) (hp : Room s.mem p 256) :
    Firedancer.LaneNI.Mlir.wv_stu.call
        (Firedancer.LaneNI.Mlir.wv_stu.args (.value p) (Ty.wrap (t := .vec 4 64) v)) s =
      .value (.nil, { s with mem := s.mem.storeAt p (BitVec.packLanes v) }) := by
  func_init
  block_init
  step_store
  finish_block
  subst_vars
  rfl

/-- `wv_stu_17` is `wv_stu` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.wv_stu_17.call_eq (p : Pointer) (v : Wv)
    (s : GlobalState) (hwf : s.WF) (hp : Room s.mem p 256) :
    Firedancer.LaneNI.Mlir.wv_stu_17.call
        (Firedancer.LaneNI.Mlir.wv_stu_17.args (.value p) (Ty.wrap (t := .vec 4 64) v)) s =
      .value (.nil, { s with mem := s.mem.storeAt p (BitVec.packLanes v) }) :=
  Firedancer.LaneNI.Mlir.wv_stu.call_eq p v s hwf hp

/-- `wv_stu_33` is `wv_stu` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.wv_stu_33.call_eq (p : Pointer) (v : Wv)
    (s : GlobalState) (hwf : s.WF) (hp : Room s.mem p 256) :
    Firedancer.LaneNI.Mlir.wv_stu_33.call
        (Firedancer.LaneNI.Mlir.wv_stu_33.args (.value p) (Ty.wrap (t := .vec 4 64) v)) s =
      .value (.nil, { s with mem := s.mem.storeAt p (BitVec.packLanes v) }) :=
  Firedancer.LaneNI.Mlir.wv_stu.call_eq p v s hwf hp

/-- `wv_stu_42` is `wv_stu` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.wv_stu_42.call_eq (p : Pointer) (v : Wv)
    (s : GlobalState) (hwf : s.WF) (hp : Room s.mem p 256) :
    Firedancer.LaneNI.Mlir.wv_stu_42.call
        (Firedancer.LaneNI.Mlir.wv_stu_42.args (.value p) (Ty.wrap (t := .vec 4 64) v)) s =
      .value (.nil, { s with mem := s.mem.storeAt p (BitVec.packLanes v) }) :=
  Firedancer.LaneNI.Mlir.wv_stu.call_eq p v s hwf hp

/-- `wv_stu_59` is `wv_stu` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.wv_stu_59.call_eq (p : Pointer) (v : Wv)
    (s : GlobalState) (hwf : s.WF) (hp : Room s.mem p 256) :
    Firedancer.LaneNI.Mlir.wv_stu_59.call
        (Firedancer.LaneNI.Mlir.wv_stu_59.args (.value p) (Ty.wrap (t := .vec 4 64) v)) s =
      .value (.nil, { s with mem := s.mem.storeAt p (BitVec.packLanes v) }) :=
  Firedancer.LaneNI.Mlir.wv_stu.call_eq p v s hwf hp

/-- `wv_stu_91` is `wv_stu` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.wv_stu_91.call_eq (p : Pointer) (v : Wv)
    (s : GlobalState) (hwf : s.WF) (hp : Room s.mem p 256) :
    Firedancer.LaneNI.Mlir.wv_stu_91.call
        (Firedancer.LaneNI.Mlir.wv_stu_91.args (.value p) (Ty.wrap (t := .vec 4 64) v)) s =
      .value (.nil, { s with mem := s.mem.storeAt p (BitVec.packLanes v) }) :=
  Firedancer.LaneNI.Mlir.wv_stu.call_eq p v s hwf hp

end Proof

end MLIR.Firedancer.LaneNI
