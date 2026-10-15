module

public import MLIR.Run.Tactic
public import Firedancer.LaneNI.fd_r43x6_mod
public import Firedancer.LaneNI.fd_r43x6_pack
public import Firedancer.LaneNI.wv_stu
public import Firedancer.LaneNI.Mlir.fd_f25519_tobytes
public import Firedancer.LaneNI.Mlir.fd_f25519_tobytes_74
public import Firedancer.LaneNI.Mlir.fd_f25519_tobytes_54
public import Firedancer.LaneNI.Mlir.fd_f25519_tobytes_39
public import Firedancer.LaneNI.Mlir.fd_f25519_tobytes_30

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512

/-- `fd_r43x6_pack( fd_r43x6_mod( a ) )`'s bytes are `tobytes a`: the pack of `r43x6Mod` of the
limbs. -/
public theorem fd_f25519_tobytes.packLanes_eq (a : Wwl) :
    BitVec.packLanes (fd_r43x6_pack.spec (fd_r43x6_mod.spec a)) =
      MLIR.Firedancer.Lane.tobytes a := by
  rw [fd_r43x6_pack.packLanes_spec]
  rfl

/-! ## Proof -/

section Proof

/-- `fd_f25519_tobytes` stores the 32 bytes `tobytes a` at `out` and returns `out`. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_tobytes.call_eq (out : Pointer) (a : Wwl)
    (s : GlobalState) (hwf : s.WF) (ho : Room s.mem out 256) :
    Firedancer.LaneNI.Mlir.fd_f25519_tobytes.call
        (Firedancer.LaneNI.Mlir.fd_f25519_tobytes.args (.value out) (Ty.wrap a)) s =
      .value
        (.cons (.value out) .nil,
          { s with mem := s.mem.storeAt out (MLIR.Firedancer.Lane.tobytes a) }) := by
  func_init
  block_init
  step_call using Firedancer.LaneNI.Mlir.fd_r43x6_mod.call_eq
  step_call using Firedancer.LaneNI.Mlir.fd_r43x6_pack.call_eq
  step_call using Firedancer.LaneNI.Mlir.wv_stu.call_eq
  finish_block
  subst_vars
  rw [fd_f25519_tobytes.packLanes_eq]

/-- `fd_f25519_tobytes_30` is `fd_f25519_tobytes` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_tobytes_30.call_eq (out : Pointer) (a : Wwl)
    (s : GlobalState) (hwf : s.WF) (ho : Room s.mem out 256) :
    Firedancer.LaneNI.Mlir.fd_f25519_tobytes_30.call
        (Firedancer.LaneNI.Mlir.fd_f25519_tobytes_30.args (.value out) (Ty.wrap a)) s =
      .value
        (.cons (.value out) .nil,
          { s with mem := s.mem.storeAt out (MLIR.Firedancer.Lane.tobytes a) }) :=
  Firedancer.LaneNI.Mlir.fd_f25519_tobytes.call_eq out a s hwf ho

/-- `fd_f25519_tobytes_39` is `fd_f25519_tobytes` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_tobytes_39.call_eq (out : Pointer) (a : Wwl)
    (s : GlobalState) (hwf : s.WF) (ho : Room s.mem out 256) :
    Firedancer.LaneNI.Mlir.fd_f25519_tobytes_39.call
        (Firedancer.LaneNI.Mlir.fd_f25519_tobytes_39.args (.value out) (Ty.wrap a)) s =
      .value
        (.cons (.value out) .nil,
          { s with mem := s.mem.storeAt out (MLIR.Firedancer.Lane.tobytes a) }) :=
  Firedancer.LaneNI.Mlir.fd_f25519_tobytes.call_eq out a s hwf ho

/-- `fd_f25519_tobytes_54` is `fd_f25519_tobytes` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_tobytes_54.call_eq (out : Pointer) (a : Wwl)
    (s : GlobalState) (hwf : s.WF) (ho : Room s.mem out 256) :
    Firedancer.LaneNI.Mlir.fd_f25519_tobytes_54.call
        (Firedancer.LaneNI.Mlir.fd_f25519_tobytes_54.args (.value out) (Ty.wrap a)) s =
      .value
        (.cons (.value out) .nil,
          { s with mem := s.mem.storeAt out (MLIR.Firedancer.Lane.tobytes a) }) :=
  Firedancer.LaneNI.Mlir.fd_f25519_tobytes.call_eq out a s hwf ho

/-- `fd_f25519_tobytes_74` is `fd_f25519_tobytes` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_tobytes_74.call_eq (out : Pointer) (a : Wwl)
    (s : GlobalState) (hwf : s.WF) (ho : Room s.mem out 256) :
    Firedancer.LaneNI.Mlir.fd_f25519_tobytes_74.call
        (Firedancer.LaneNI.Mlir.fd_f25519_tobytes_74.args (.value out) (Ty.wrap a)) s =
      .value
        (.cons (.value out) .nil,
          { s with mem := s.mem.storeAt out (MLIR.Firedancer.Lane.tobytes a) }) :=
  Firedancer.LaneNI.Mlir.fd_f25519_tobytes.call_eq out a s hwf ho

end Proof

end MLIR.Firedancer.LaneNI
