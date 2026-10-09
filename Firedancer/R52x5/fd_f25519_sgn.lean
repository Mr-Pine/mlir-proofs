module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.R52x5.fd_f25519_canonical_limbs
public import Firedancer.R52x5.Mlir.fd_f25519_sgn

namespace MLIR.Firedancer.R52x5

open Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_f25519_sgn`: the low bit of `a`'s canonical limb 0, `(int)(h[0] & 1)`. -/
def fd_f25519_sgn.spec (a : Wwl) : BitVec 32 :=
  (fd_f25519_canonical_limbs.spec a 0).setWidth 32 &&& 1#32

end

/-! ## Proof -/

section Proof

/-- `fd_f25519_sgn( a )` returns `spec` of the element at `a`; its temporary and
`fd_f25519_reduce`'s are freed, the counter moves on by two blocks. -/
public theorem fd_f25519_sgn.call_eq (a : Pointer) (s : GlobalState) (hwf : s.WF)
    (ha : Fits s.mem a 512) :
    fd_f25519_sgn.call (fd_f25519_sgn.args (.value a)) s =
      .value
        (.cons (.value (fd_f25519_sgn.spec (s.mem.readVec a))) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩, mem := s.mem }) := by
  func_init
  block_init
  step_pure
  -- ulong h[5];
  step_alloca with h
  step_pure
  have hh_limbs : S.mem.LimbsFit h := .of_fits hh_fits hh_off
  rw [hS] at hh_limbs
  -- fd_f25519_canonical_limbs( h, a );
  step_call using fd_f25519_canonical_limbs.call_eq
  generalize hl : fd_f25519_canonical_limbs.spec (S₀.mem.readVec a) = l at hS
  have hread_h : S.mem.readAt h 64 = l 0 := by
    rw [hS]; exact congrFun (MemoryState.readLimbs_storeLimbs_self hh_limbs) 0
  -- return (int)(h[0] & 1);
  step_load
  iterate 3 step_pure
  finish_block
  subst hS hl
  erase_frame
  rfl

end Proof

end MLIR.Firedancer.R52x5
