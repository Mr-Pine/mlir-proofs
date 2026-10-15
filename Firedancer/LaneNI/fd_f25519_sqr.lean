module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.FoldUnsigned
public import Firedancer.LaneNI.fd_r43x6_sqr_fast
public import Firedancer.LaneNI.Mlir.fd_f25519_sqr
public import Firedancer.LaneNI.Mlir.fd_f25519_sqr_75
public import Firedancer.LaneNI.Mlir.fd_f25519_sqr_60
public import Firedancer.LaneNI.Mlir.fd_f25519_sqr_47

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512

/-! ## Proof -/

section Proof

/-- `fd_f25519_sqr` stores `fd_r43x6_sqr a` at `r` and returns `r`. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_sqr.call_eq (r : Pointer) (a : Wwl)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_sqr.call
        (Firedancer.LaneNI.Mlir.fd_f25519_sqr.args (.value r) (Ty.wrap a)) s =
      .value (.cons (.value r) .nil, { s with mem := s.mem.storeVec r (fd_r43x6_sqr a) }) := by
  func_init
  block_init
  iterate 4 step_pure
  step_call using Firedancer.LaneNI.Mlir.fd_r43x6_sqr_fast_20.call_eq with z
  step_pattern using runBodyFrom_foldRun with f
  step_store
  finish_block
  subst_vars
  rfl

/-- `fd_f25519_sqr_47` is `fd_f25519_sqr` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_sqr_47.call_eq (r : Pointer) (a : Wwl)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_sqr_47.call
        (Firedancer.LaneNI.Mlir.fd_f25519_sqr_47.args (.value r) (Ty.wrap a)) s =
      .value (.cons (.value r) .nil, { s with mem := s.mem.storeVec r (fd_r43x6_sqr a) }) :=
  Firedancer.LaneNI.Mlir.fd_f25519_sqr.call_eq r a s hwf hr

/-- `fd_f25519_sqr_60` is `fd_f25519_sqr` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_sqr_60.call_eq (r : Pointer) (a : Wwl)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_sqr_60.call
        (Firedancer.LaneNI.Mlir.fd_f25519_sqr_60.args (.value r) (Ty.wrap a)) s =
      .value (.cons (.value r) .nil, { s with mem := s.mem.storeVec r (fd_r43x6_sqr a) }) :=
  Firedancer.LaneNI.Mlir.fd_f25519_sqr.call_eq r a s hwf hr

/-- `fd_f25519_sqr_75` is `fd_f25519_sqr` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_sqr_75.call_eq (r : Pointer) (a : Wwl)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_sqr_75.call
        (Firedancer.LaneNI.Mlir.fd_f25519_sqr_75.args (.value r) (Ty.wrap a)) s =
      .value (.cons (.value r) .nil, { s with mem := s.mem.storeVec r (fd_r43x6_sqr a) }) :=
  Firedancer.LaneNI.Mlir.fd_f25519_sqr.call_eq r a s hwf hr

end Proof

end MLIR.Firedancer.LaneNI
