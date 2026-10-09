module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Avx512.fd_f25519_sub
public import Firedancer.Avx512.fd_f25519_is_zero
public import Firedancer.Avx512.Mlir.fd_f25519_eq

namespace LeanMLIR.RIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `1` when `a - b`, folded, has the lanes of `0` or of `p`, else `0`. -/
def fd_f25519_eq.spec (a b : Wwl) : BitVec 32 :=
  let r := fd_f25519_sub.spec a b
  fd_f25519_is_zero.spec r

end

/-! ## Proof -/

section Proof

/-- `fd_f25519_eq` returns `spec` of the lanes at `a` and `b`, which may be one element; its
temporary is freed, the counter moves on by one block. -/
public theorem fd_f25519_eq.call_eq (a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (ha : Fits s.mem a 512) (hb : Fits s.mem b 512) :
    fd_f25519_eq.call (fd_f25519_eq.args (.value a) (.value b)) s =
      .value
        (.cons (.value (fd_f25519_eq.spec (s.mem.readVec a) (s.mem.readVec b))) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩, mem := s.mem }) := by
  func_init
  block_init
  -- fd_f25519_t r[1];
  step_pure
  step_alloca with r
  step_pure
  -- fd_f25519_sub( r, a, b );
  step_call using fd_f25519_sub.call_eq consuming ha hb
  -- return fd_f25519_is_zero( r );
  step_call using fd_f25519_is_zero.call_eq consuming hread_r
  clear hr_fits hread_r_readAt
  step_pure
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

end LeanMLIR.RIR.Firedancer.Avx512
