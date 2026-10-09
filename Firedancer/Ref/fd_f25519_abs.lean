module

public import MLIR.Run.Tactic
public import Firedancer.Common.Limbs
public import Firedancer.Common.Tactics
public import Firedancer.Ref.fd_f25519_neg
public import Firedancer.Ref.fd_f25519_sgn
public import Firedancer.Ref.fd_f25519_if
public import Firedancer.Ref.Mlir.fd_f25519_abs

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `|a|`: `-a` when `a`'s sign is set, else `a`. -/
def fd_f25519_abs.spec (a : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let neg_a := fd_f25519_neg.spec a
  fd_f25519_if.spec (fd_f25519_sgn.spec a) neg_a a

end

/-! ## Proof -/

section Proof

/-- The sign is `0` or `1`: it fits `fd_f25519_if`'s `uchar`. -/
theorem fd_f25519_sgn.spec_lt (a : Fin 5 → BitVec 64) : (fd_f25519_sgn.spec a).toNat < 256 := by
  simp only [fd_f25519_sgn.spec, BitVec.toNat_and]
  exact lt_of_le_of_lt Nat.and_le_right (by simp)

/-- `fd_f25519_abs` stores `spec a` at `r` and returns `r`; `r` may alias `a`. The temporary and
the callees' blocks are freed again: only the counter moves on, by 28 blocks. -/
public theorem fd_f25519_abs.call_eq (r a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.LimbsFit r) (ha : s.mem.LimbsFit a) :
    fd_f25519_abs.call (fd_f25519_abs.args (.value r) (.value a)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 28⟩,
            mem := s.mem.storeLimbs r (fd_f25519_abs.spec (s.mem.readLimbs a)) }) := by
  func_init
  block_init
  step_pure
  -- fd_f25519_t neg_a[1];
  step_alloca with neg_a
  step_pure
  have hneg_a_limbs := MemoryState.LimbsFit.of_fits hneg_a_fits hneg_a_off
  -- fd_f25519_neg( neg_a, a );
  step_call using fd_f25519_neg.call_eq
  -- return fd_f25519_if( r, fd_f25519_sgn(a), neg_a, a );
  step_call using fd_f25519_sgn.call_eq
  have hsgn := fd_f25519_sgn.spec_lt
  step_call using fd_f25519_if.call_eq consuming hread_neg_a
  step_pure
  finish_block
  clear_reads
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Firedancer.Ref
