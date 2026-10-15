module

public import MLIR.Run.Tactic
public import Firedancer.Lane.fd_curve25519_affine_frombytes
public import Firedancer.LaneNI.fd_r43x6_unpack
public import Firedancer.LaneNI.Mlir.fd_f25519_frombytes
public import Firedancer.LaneNI.Mlir.fd_f25519_frombytes_36
public import Firedancer.LaneNI.Mlir.fd_f25519_frombytes_50
public import Firedancer.LaneNI.Mlir.fd_f25519_frombytes_73

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512 MLIR.Firedancer.Lane

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn

/-- `fd_f25519_frombytes` stores `feFrombytes` of the 32 bytes at `buf` at `r` and returns `r`. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_frombytes.call_eq (r buf : Pointer)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) (hb : Fits s.mem buf 256) :
    Firedancer.LaneNI.Mlir.fd_f25519_frombytes.call
        (Firedancer.LaneNI.Mlir.fd_f25519_frombytes.args (.value r) (.value buf)) s =
      .value
        (.cons (.value r) .nil,
          { s with mem := s.mem.storeVec r (feFrombytes (s.mem.readAt buf 256)) }) := by
  func_init
  block_init
  step_pure
  step_load with transparent lb
  step_pure [zipWith_eq_ofFn] with ub
  step_call using Firedancer.LaneNI.Mlir.fd_r43x6_unpack_23.call_eq with y
  step_store
  finish_block
  rw [hS, hy, hub]
  rfl

/-- `fd_f25519_frombytes_36` is `fd_f25519_frombytes` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_frombytes_36.call_eq (r buf : Pointer)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) (hb : Fits s.mem buf 256) :
    Firedancer.LaneNI.Mlir.fd_f25519_frombytes_36.call
        (Firedancer.LaneNI.Mlir.fd_f25519_frombytes_36.args (.value r) (.value buf)) s =
      .value
        (.cons (.value r) .nil,
          { s with mem := s.mem.storeVec r (feFrombytes (s.mem.readAt buf 256)) }) :=
  Firedancer.LaneNI.Mlir.fd_f25519_frombytes.call_eq r buf s hwf hr hb

/-- `fd_f25519_frombytes_50` is `fd_f25519_frombytes` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_frombytes_50.call_eq (r buf : Pointer)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) (hb : Fits s.mem buf 256) :
    Firedancer.LaneNI.Mlir.fd_f25519_frombytes_50.call
        (Firedancer.LaneNI.Mlir.fd_f25519_frombytes_50.args (.value r) (.value buf)) s =
      .value
        (.cons (.value r) .nil,
          { s with mem := s.mem.storeVec r (feFrombytes (s.mem.readAt buf 256)) }) :=
  Firedancer.LaneNI.Mlir.fd_f25519_frombytes.call_eq r buf s hwf hr hb

/-- `fd_f25519_frombytes_73` is `fd_f25519_frombytes` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_frombytes_73.call_eq (r buf : Pointer)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) (hb : Fits s.mem buf 256) :
    Firedancer.LaneNI.Mlir.fd_f25519_frombytes_73.call
        (Firedancer.LaneNI.Mlir.fd_f25519_frombytes_73.args (.value r) (.value buf)) s =
      .value
        (.cons (.value r) .nil,
          { s with mem := s.mem.storeVec r (feFrombytes (s.mem.readAt buf 256)) }) :=
  Firedancer.LaneNI.Mlir.fd_f25519_frombytes.call_eq r buf s hwf hr hb

end Proof

end MLIR.Firedancer.LaneNI
