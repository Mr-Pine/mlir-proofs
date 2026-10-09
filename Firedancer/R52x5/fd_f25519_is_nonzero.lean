module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.fd_f25519_is_zero
public import Firedancer.R52x5.Mlir.fd_f25519_is_nonzero

namespace MLIR.Firedancer.R52x5

open Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_f25519_is_nonzero`: `!fd_f25519_is_zero( a )`, compiled as `^ 1`. -/
def fd_f25519_is_nonzero.spec (a : Wwl) : BitVec 32 :=
  fd_f25519_is_zero.spec a ^^^ 1#32

end

/-! ## Proof -/

section Proof

/-- `fd_f25519_is_nonzero( a )` returns `spec` of the element at `a`; `fd_f25519_is_zero` moves
the counter on by two blocks. -/
public theorem fd_f25519_is_nonzero.call_eq (a : Pointer) (s : GlobalState) (hwf : s.WF)
    (ha : Fits s.mem a 512) :
    fd_f25519_is_nonzero.call (fd_f25519_is_nonzero.args (.value a)) s =
      .value
        (.cons (.value (fd_f25519_is_nonzero.spec (s.mem.readVec a))) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩, mem := s.mem }) := by
  func_init
  block_init
  step_pure
  step_call using fd_f25519_is_zero.call_eq
  step_pure
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Firedancer.R52x5
