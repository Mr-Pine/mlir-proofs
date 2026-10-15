module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.fd_f25519_eq
public import Firedancer.LaneNI.fd_f25519_sub
public import Firedancer.LaneNI.fd_f25519_is_zero
public import Firedancer.LaneNI.Mlir.fd_f25519_eq
public import Firedancer.LaneNI.Mlir.fd_f25519_eq_154
public import Firedancer.LaneNI.Mlir.fd_f25519_eq_129

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512

/-! ## Proof -/

section Proof

/-- `fd_f25519_eq` returns `fd_f25519_eq.spec a b`; its temporary is freed, the counter moves on by
one block. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_eq.call_eq (a b : Wwl) (s : GlobalState)
    (hwf : s.WF) :
    Firedancer.LaneNI.Mlir.fd_f25519_eq.call
        (Firedancer.LaneNI.Mlir.fd_f25519_eq.args (Ty.wrap a) (Ty.wrap b)) s =
      .value
        (.cons (.value (fd_f25519_eq.spec a b)) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩, mem := s.mem }) := by
  func_init
  block_init
  -- fd_f25519_t r[1];
  step_pure
  step_alloca with r
  step_pure
  -- fd_f25519_sub( r, a, b );
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_sub_72.call_eq
  step_load with d
  -- return fd_f25519_is_zero( r );
  step_call using Firedancer.LaneNI.Mlir.fd_f25519_is_zero.call_eq
  step_pure
  finish_block
  subst hS
  erase_frame
  subst hd
  rfl

/-- `fd_f25519_eq_129` is `fd_f25519_eq` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_eq_129.call_eq (a b : Wwl) (s : GlobalState)
    (hwf : s.WF) :
    Firedancer.LaneNI.Mlir.fd_f25519_eq_129.call
        (Firedancer.LaneNI.Mlir.fd_f25519_eq_129.args (Ty.wrap a) (Ty.wrap b)) s =
      .value
        (.cons (.value (fd_f25519_eq.spec a b)) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩, mem := s.mem }) :=
  Firedancer.LaneNI.Mlir.fd_f25519_eq.call_eq a b s hwf

/-- `fd_f25519_eq_154` is `fd_f25519_eq` under another name. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_f25519_eq_154.call_eq (a b : Wwl) (s : GlobalState)
    (hwf : s.WF) :
    Firedancer.LaneNI.Mlir.fd_f25519_eq_154.call
        (Firedancer.LaneNI.Mlir.fd_f25519_eq_154.args (Ty.wrap a) (Ty.wrap b)) s =
      .value
        (.cons (.value (fd_f25519_eq.spec a b)) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩, mem := s.mem }) :=
  Firedancer.LaneNI.Mlir.fd_f25519_eq.call_eq a b s hwf

end Proof

end MLIR.Firedancer.LaneNI
