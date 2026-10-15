module

public import MLIR.Run.Tactic
public import Firedancer.LaneNI.fd_ed25519_point_add_with_opts
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_add

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_add` stores `A + B` of the points at `a` and `b` at `r` and returns `r`; `r`
may be `a` or `b`. Its frame is `fd_ed25519_point_add_with_opts`'s fifteen blocks. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_ed25519_point_add.call_eq (r a b : Pointer)
    (s : GlobalState) (hwf : s.WF) (hr : s.mem.QuadRoom r) (ha : s.mem.QuadFit a)
    (hb : s.mem.QuadFit b) :
    Firedancer.LaneNI.Mlir.fd_ed25519_point_add.call
        (Firedancer.LaneNI.Mlir.fd_ed25519_point_add.args (.value r) (.value a) (.value b)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 15⟩,
            mem :=
              s.mem.storeQuad r
                (fd_ed25519_point_add_with_opts.spec (s.mem.readQuad a) (s.mem.readQuad b)
                  0) }) := by
  func_init
  block_init
  step_pure
  step_call using Firedancer.LaneNI.Mlir.fd_ed25519_point_add_with_opts.call_eq
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Firedancer.LaneNI
