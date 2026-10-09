module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.fd_f25519_sub
public import Firedancer.R52x5.fd_f25519_is_zero
public import Firedancer.R52x5.Mlir.fd_f25519_eq

namespace MLIR.Firedancer.R52x5

open Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_f25519_eq`: `fd_f25519_is_zero( a - b )`. -/
def fd_f25519_eq.spec (a b : Wwl) : BitVec 32 :=
  fd_f25519_is_zero.spec (fd_f25519_sub.spec a b)

end

/-! ## Proof -/

section Proof

/-- `fd_f25519_eq( a, b )` returns `spec` of the elements at `a` and `b`, which may be one; its
temporary and `fd_f25519_is_zero`'s two are freed, the counter moves on by three blocks. -/
public theorem fd_f25519_eq.call_eq (a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (ha : Fits s.mem a 512) (hb : Fits s.mem b 512) :
    fd_f25519_eq.call (fd_f25519_eq.args (.value a) (.value b)) s =
      .value
        (.cons (.value (fd_f25519_eq.spec (s.mem.readVec a) (s.mem.readVec b))) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 3⟩, mem := s.mem }) := by
  func_init
  block_init
  step_pure
  -- fd_f25519_t r[1];
  step_alloca with r
  step_pure
  -- fd_f25519_sub( r, a, b );
  step_call using fd_f25519_sub.call_eq consuming ha hb
  -- return fd_f25519_is_zero( r );
  step_call using fd_f25519_is_zero.call_eq consuming hread_r
  step_pure
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Firedancer.R52x5
