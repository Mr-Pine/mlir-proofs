module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.FoldUnsigned
public import Firedancer.LaneNI.fd_r43x6_mul_fast
public import Firedancer.LaneNI.Mlir.fd_f25519_mul
public import Firedancer.LaneNI.Mlir.fd_f25519_mul_38
public import Firedancer.LaneNI.Mlir.fd_f25519_mul_61
public import Firedancer.LaneNI.Mlir.fd_f25519_mul_78

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512

/-! ## Proof -/

section Proof

/-- `fd_f25519_mul` stores `fd_r43x6_mul a b` at `r` and returns `r`. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_mul.call_eq (r : Pointer) (a b : Wwl)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_mul.call
        (Firedancer.LaneNI.Mlir.fd_f25519_mul.args (.value r) (Ty.wrap a) (Ty.wrap b)) s =
      .value (.cons (.value r) .nil, { s with mem := s.mem.storeVec r (fd_r43x6_mul a b) }) := by
  func_init
  block_init
  iterate 4 step_pure
  step_call using Firedancer.LaneNI.Mlir.fd_r43x6_mul_fast_22.call_eq with z
  step_pattern using runBodyFrom_foldRun with f
  step_store
  finish_block
  subst_vars
  rfl

/-- `fd_f25519_mul_38` is `fd_f25519_mul` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_mul_38.call_eq (r : Pointer) (a b : Wwl)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_mul_38.call
        (Firedancer.LaneNI.Mlir.fd_f25519_mul_38.args (.value r) (Ty.wrap a) (Ty.wrap b)) s =
      .value (.cons (.value r) .nil, { s with mem := s.mem.storeVec r (fd_r43x6_mul a b) }) :=
  Firedancer.LaneNI.Mlir.fd_f25519_mul.call_eq r a b s hwf hr

/-- `fd_f25519_mul_61` is `fd_f25519_mul` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_mul_61.call_eq (r : Pointer) (a b : Wwl)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_mul_61.call
        (Firedancer.LaneNI.Mlir.fd_f25519_mul_61.args (.value r) (Ty.wrap a) (Ty.wrap b)) s =
      .value (.cons (.value r) .nil, { s with mem := s.mem.storeVec r (fd_r43x6_mul a b) }) :=
  Firedancer.LaneNI.Mlir.fd_f25519_mul.call_eq r a b s hwf hr

/-- `fd_f25519_mul_78` is `fd_f25519_mul` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_mul_78.call_eq (r : Pointer) (a b : Wwl)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_mul_78.call
        (Firedancer.LaneNI.Mlir.fd_f25519_mul_78.args (.value r) (Ty.wrap a) (Ty.wrap b)) s =
      .value (.cons (.value r) .nil, { s with mem := s.mem.storeVec r (fd_r43x6_mul a b) }) :=
  Firedancer.LaneNI.Mlir.fd_f25519_mul.call_eq r a b s hwf hr

end Proof

end MLIR.Firedancer.LaneNI
