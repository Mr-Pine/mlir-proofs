module

public import MLIR.Run.Tactic
public import Firedancer.Lane.Common.SqrtRatio
public import Firedancer.LaneNI.fd_f25519_tobytes
public import Firedancer.LaneNI.Mlir.fd_f25519_sgn
public import Firedancer.LaneNI.Mlir.fd_f25519_sgn_82
public import Firedancer.LaneNI.Mlir.fd_f25519_sgn_71

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512

/-! ## Proof -/

section Proof

/-- Byte 0's low bit, widened. -/
private theorem sgn_bit (t : BitVec 256) :
    BitVec.setWidth 32 (BitVec.setWidth 8 t) &&& 1#32 = (t.setWidth 8 &&& 1).setWidth 32 := by
  bv_decide

/-- `fd_f25519_sgn` returns `a`'s sign, bit 0 of `tobytes a`; its buffer is freed, the counter moves
on by one block. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_sgn.call_eq (a : Wwl) (s : GlobalState)
    (hwf : s.WF) :
    Firedancer.LaneNI.Mlir.fd_f25519_sgn.call
        (Firedancer.LaneNI.Mlir.fd_f25519_sgn.args (Ty.wrap a)) s =
      .value
        (.cons (.value (MLIR.Firedancer.Lane.fd_f25519_sqrt_ratio.sgn a)) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩, mem := s.mem }) := by
  func_init
  block_init
  iterate 2 step_pure
  step_alloca with buf
  step_pure
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_tobytes_30.call_eq
  step_load with b
  iterate 2 step_pure
  step_pure
  finish_block
  subst hS
  erase_frame
  rw [hb, MLIR.Firedancer.Lane.fd_f25519_sqrt_ratio.sgn, sgn_bit]
  rfl

/-- `fd_f25519_sgn_71` is `fd_f25519_sgn` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_sgn_71.call_eq (a : Wwl) (s : GlobalState)
    (hwf : s.WF) :
    Firedancer.LaneNI.Mlir.fd_f25519_sgn_71.call
        (Firedancer.LaneNI.Mlir.fd_f25519_sgn_71.args (Ty.wrap a)) s =
      .value
        (.cons (.value (MLIR.Firedancer.Lane.fd_f25519_sqrt_ratio.sgn a)) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩, mem := s.mem }) :=
  Firedancer.LaneNI.Mlir.fd_f25519_sgn.call_eq a s hwf

/-- `fd_f25519_sgn_82` is `fd_f25519_sgn` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_sgn_82.call_eq (a : Wwl) (s : GlobalState)
    (hwf : s.WF) :
    Firedancer.LaneNI.Mlir.fd_f25519_sgn_82.call
        (Firedancer.LaneNI.Mlir.fd_f25519_sgn_82.args (Ty.wrap a)) s =
      .value
        (.cons (.value (MLIR.Firedancer.Lane.fd_f25519_sqrt_ratio.sgn a)) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩, mem := s.mem }) :=
  Firedancer.LaneNI.Mlir.fd_f25519_sgn.call_eq a s hwf

end Proof

end MLIR.Firedancer.LaneNI
