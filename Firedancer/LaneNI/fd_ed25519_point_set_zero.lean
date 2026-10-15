module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_set_zero
public import Firedancer.Avx512.fd_ed25519_point_set_zero

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_set_zero` stores the neutral point at `r` and returns `r`. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_ed25519_point_set_zero.call_eq
    (r : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.QuadRoom r) :
    Firedancer.LaneNI.Mlir.fd_ed25519_point_set_zero.call
        (Firedancer.LaneNI.Mlir.fd_ed25519_point_set_zero.args (.value r)) s =
      .value
        (.cons (.value r) .nil,
          { s with mem := s.mem.storeQuad r fd_ed25519_point_set_zero.spec }) := by
  func_init
  block_init
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  have hr_1024 := hr.room_14_25
  step_memset consuming hr_1024
  finish_block
  subst hS
  rw [MemoryState.storeAt_zero_14_25 hr.1]
  rfl

end Proof

end MLIR.Firedancer.LaneNI
