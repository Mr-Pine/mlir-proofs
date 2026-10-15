module

public import MLIR.Run.Tactic
public import Firedancer.Lane.fd_r43x6_ge_decode_init
public import Firedancer.Lane.Mlir.fd_ed25519_point_decode_init

namespace MLIR.Firedancer.Lane

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_decode_init` stores `DecSt.init` of the encoding at `buf` at `st`. -/
public theorem fd_ed25519_point_decode_init.call_eq (st buf : Pointer) (s : GlobalState)
    (hwf : s.WF) (hbuf : Fits s.mem buf 256) (hbo : ¬buf.offset.uaddOverflow 32#64)
    (hst : s.mem.DecRoom st) :
    _root_.Firedancer.Lane.Mlir.fd_ed25519_point_decode_init.call
        (_root_.Firedancer.Lane.Mlir.fd_ed25519_point_decode_init.args (.value st) (.value buf))
        s =
      .value (.nil, { s with mem := s.mem.storeDec st (DecSt.init (s.mem.readAt buf 256)) }) := by
  func_init
  block_init
  step_call using fd_r43x6_ge_decode_init.call_eq
  finish_block
  subst hS
  rfl

end Proof

end MLIR.Firedancer.Lane
