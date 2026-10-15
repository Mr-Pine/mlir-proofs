module

public import MLIR.Run.Tactic
public import Firedancer.Lane.Common.SqrtRatio
public import Firedancer.LaneNI.fd_f25519_neg
public import Firedancer.LaneNI.fd_f25519_sgn
public import Firedancer.LaneNI.fd_f25519_if
public import Firedancer.LaneNI.Mlir.fd_f25519_abs
public import Firedancer.LaneNI.Mlir.fd_f25519_abs_81
import Std.Tactic.BVDecide

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512

/-! ## Proof -/

section Proof

/-- `fd_f25519_sgn`'s result is `0` or `1`. -/
private theorem sgn_01 (a : Wwl) :
    MLIR.Firedancer.Lane.fd_f25519_sqrt_ratio.sgn a = 0 ∨
      MLIR.Firedancer.Lane.fd_f25519_sqrt_ratio.sgn a = 1 := by
  rw [MLIR.Firedancer.Lane.fd_f25519_sqrt_ratio.sgn]
  generalize MLIR.Firedancer.Lane.tobytes a = t
  bv_decide

/-- `fd_f25519_abs` stores `|a|` at `r` and returns `r`; its temporary is freed, the counter moves
on by two blocks. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_abs.call_eq (r : Pointer) (a : Wwl)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_abs.call
        (Firedancer.LaneNI.Mlir.fd_f25519_abs.args (.value r) (Ty.wrap a)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩,
            mem := s.mem.storeVec r (MLIR.Firedancer.Lane.fd_f25519_sqrt_ratio.abs a) }) := by
  func_init
  block_init
  step_pure
  step_alloca with t
  step_pure
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_neg_70.call_eq
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_sgn_71.call_eq
  step_load with na
  step_call using (Firedancer.LaneNI.Mlir.fd_f25519_if.call_eq (hc := sgn_01 a))
  step_pure
  finish_block
  subst hS hna
  erase_frame
  rfl

/-- `fd_f25519_abs_81` stores `|a|` at `r` and returns `r`, as `fd_f25519_abs` does. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_abs_81.call_eq (r : Pointer) (a : Wwl)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) :
    Firedancer.LaneNI.Mlir.fd_f25519_abs_81.call
        (Firedancer.LaneNI.Mlir.fd_f25519_abs_81.args (.value r) (Ty.wrap a)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩,
            mem := s.mem.storeVec r (MLIR.Firedancer.Lane.fd_f25519_sqrt_ratio.abs a) }) := by
  func_init
  block_init
  step_pure
  step_alloca with t
  step_pure
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_neg_79.call_eq
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_sgn_82.call_eq
  step_load with na
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_if_85.call_eq
  step_pure
  finish_block
  subst hS hna
  erase_frame
  rfl

end Proof

end MLIR.Firedancer.LaneNI
