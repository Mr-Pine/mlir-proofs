module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.R52x5.fd_f25519_reduce
public import Firedancer.R52x5.fd_r52x5_reduce
public import Firedancer.R52x5.Mlir.fd_f25519_canonical_limbs

namespace MLIR.Firedancer.R52x5

open Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_f25519_canonical_limbs`: `a` folded, then `fd_r52x5_reduce`d. -/
def fd_f25519_canonical_limbs.spec (a : Wwl) : Fin 5 → BitVec 64 :=
  fd_r52x5_reduce.spec (limbs (fold a))

end

/-! ## Proof -/

section Proof

/-- `fd_f25519_canonical_limbs( h, a )` stores `spec` of the element at `a` as limbs at `h`;
`fd_f25519_reduce`'s temporary moves the counter on by one block. -/
public theorem fd_f25519_canonical_limbs.call_eq (h a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hh : s.mem.LimbsRoom h) (ha : Fits s.mem a 512) :
    fd_f25519_canonical_limbs.call (fd_f25519_canonical_limbs.args (.value h) (.value a)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem := s.mem.storeLimbs h (fd_f25519_canonical_limbs.spec (s.mem.readVec a)) }) := by
  func_init
  block_init
  step_load
  -- fd_f25519_reduce( h, a->el );
  step_call using fd_f25519_reduce.call_eq
  -- fd_r52x5_reduce( h );
  step_call using fd_r52x5_reduce.call_eq
  finish_block
  subst hS
  erase_frame
  rw [MemoryState.storeLimbs_storeLimbs_self]
  rfl

end Proof

end MLIR.Firedancer.R52x5
