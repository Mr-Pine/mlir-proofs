module

public import MLIR.Run.Tactic
public import Firedancer.Common.Limbs
public import Firedancer.Common.Tactics
public import Firedancer.Ref.fd_f25519_sub
public import Firedancer.Ref.fd_f25519_is_zero
public import Firedancer.Ref.Mlir.fd_f25519_eq

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `1` when `a - b`, carried, has the limbs of `0` or of `p`, else `0`. -/
def fd_f25519_eq.spec (a b : Fin 5 → BitVec 64) : BitVec 32 :=
  let r := fd_f25519_sub.spec a b
  fd_f25519_is_zero.spec r

end

/-! ## Proof -/

section Proof

/-- `fd_f25519_eq` returns `spec` of `a`'s and `b`'s limbs, which may be one element; its temporary
is freed, the counter moves on by one block. -/
public theorem fd_f25519_eq.call_eq (a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (ha : s.mem.LimbsFit a) (hb : s.mem.LimbsFit b) :
    fd_f25519_eq.call (fd_f25519_eq.args (.value a) (.value b)) s =
      .value
        (.cons (.value (fd_f25519_eq.spec (s.mem.readLimbs a) (s.mem.readLimbs b))) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩, mem := s.mem }) := by
  func_init
  block_init
  -- fd_f25519_t r[1];
  step_pure
  step_alloca with r
  step_pure
  limbs_room r
  -- fd_f25519_sub( r, a, b );
  step_call using fd_f25519_sub.call_eq consuming ha
  clear hb
  -- return fd_f25519_is_zero( r );
  step_call using fd_f25519_is_zero.call_eq consuming hread_r
  step_pure
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Firedancer.Ref
