module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.LaneNI.fd_f25519_one
public import Firedancer.LaneNI.Mlir.fd_f25519_set
public import Firedancer.LaneNI.Mlir.fd_f25519_set_80
public import Firedancer.LaneNI.Mlir.fd_f25519_set_44
public import Firedancer.LaneNI.Mlir.fd_f25519_set_21

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512

/-! ## Proof -/

section Proof

/-- `fd_f25519_set` stores `a` at `r` and returns `r`. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_set.call_eq (r : Pointer) (a : Wwl)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_set.call
        (Firedancer.LaneNI.Mlir.fd_f25519_set.args (.value r) (Ty.wrap a)) s =
      .value (.cons (.value r) .nil, { s with mem := s.mem.storeVec r a }) := by
  func_init
  block_init
  step_store
  finish_block
  subst_vars
  rfl

/-- `fd_f25519_set_21` with `a` fixed to `fd_f25519_one`: stores `1` at `r` and returns `r`. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_set_21.call_eq (r : Pointer)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_set_21.call
        (Firedancer.LaneNI.Mlir.fd_f25519_set_21.args (.value r)) s =
      .value (.cons (.value r) .nil, { s with mem := s.mem.storeVec r fd_f25519_one.vec }) := by
  func_init
  block_init
  step_pure
  step_store
  finish_block
  subst_vars
  rfl

/-- `fd_f25519_set_44` is `fd_f25519_set` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_set_44.call_eq (r : Pointer) (a : Wwl)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_set_44.call
        (Firedancer.LaneNI.Mlir.fd_f25519_set_44.args (.value r) (Ty.wrap a)) s =
      .value (.cons (.value r) .nil, { s with mem := s.mem.storeVec r a }) :=
  Firedancer.LaneNI.Mlir.fd_f25519_set.call_eq r a s hwf hr

/-- `fd_f25519_set_80` is `fd_f25519_set` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_set_80.call_eq (r : Pointer) (a : Wwl)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_set_80.call
        (Firedancer.LaneNI.Mlir.fd_f25519_set_80.args (.value r) (Ty.wrap a)) s =
      .value (.cons (.value r) .nil, { s with mem := s.mem.storeVec r a }) :=
  Firedancer.LaneNI.Mlir.fd_f25519_set.call_eq r a s hwf hr

end Proof

end MLIR.Firedancer.LaneNI
