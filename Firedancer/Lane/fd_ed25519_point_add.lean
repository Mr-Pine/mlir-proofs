module

public import MLIR.Run.Tactic
public import Firedancer.Lane.fd_ed25519_point_add_with_opts
public import Firedancer.Lane.Mlir.fd_ed25519_point_add

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_add` stores `A + B` of the points at `a` and `b` at `r` and returns `r`; `r`
may be `a` or `b`. -/
public theorem fd_ed25519_point_add.call_eq (r a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.QuadRoom r) (ha : s.mem.QuadFit a) (hb : s.mem.QuadFit b) :
    _root_.Firedancer.Lane.Mlir.fd_ed25519_point_add.call
        (_root_.Firedancer.Lane.Mlir.fd_ed25519_point_add.args (.value r) (.value a) (.value b))
        s =
      .value
        (.cons (.value r) .nil,
          { s with
            mem :=
              s.mem.storeQuad r
                (fd_ed25519_point_add_with_opts.spec (s.mem.readQuad a) (s.mem.readQuad b)
                  0) }) := by
  func_init
  block_init
  step_pure
  step_call using fd_ed25519_point_add_with_opts.call_eq
  finish_block
  subst hS
  rfl

end Proof

end MLIR.Firedancer.Lane
