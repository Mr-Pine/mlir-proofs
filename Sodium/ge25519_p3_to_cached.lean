module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Boringssl.Common.Point
public import Sodium.Globals
public import Sodium.fe25519_add
public import Sodium.fe25519_sub
public import Sodium.fe25519_copy
public import Sodium.fe25519_mul
public import Sodium.Mlir.ge25519_p3_to_cached

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

/-- `ge25519_p3` to `ge25519_cached`: `(Y + X, Y - X, Z, 2d T)`, the sum not carried. -/
def ge25519_p3_to_cached.spec (P : GeP3) : GeCached :=
  ⟨Firedancer.Ref.fiat_25519_add.spec P.Y P.X, fe25519_sub.spec P.Y P.X, P.Z,
    fe25519_mul.spec P.T Firedancer.Ref.fd_f25519_k.limbs⟩

end

/-! ## Proof -/

section Proof

/-- `ge25519_p3_to_cached` stores `spec` of the `ge25519_p3` at `p` at `r`, in another block. The
global `d2`'s block is freed again: only the counter moves on. -/
public theorem ge25519_p3_to_cached.call_eq (r p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.PointRoom r) (hp : s.mem.PointFit p) (hsep : r.id ≠ p.id) :
    ge25519_p3_to_cached.call (ge25519_p3_to_cached.args (.value r) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem := s.mem.storeCached r (ge25519_p3_to_cached.spec (s.mem.readP3 p)) }) := by
  func_init
  have hp₀ : S₀.mem.PointFit p := hS ▸ hp
  block_init
  step_addressof d2.value_eq with d2
  have hd2_read := Sodium.d2.readLimbs hd2_fits hd2_off hread_d2
  clear hread_d2
  limbs_fit d2
  step_pure
  -- fe25519_add(r->YplusX, p->Y, p->X);
  step_call using fe25519_add.call_eq
  step_pure
  -- fe25519_sub(r->YminusX, p->Y, p->X);
  step_call using fe25519_sub.call_eq
  iterate 2 step_pure
  -- fe25519_copy(r->Z, p->Z);
  step_call using fe25519_copy.call_eq
  iterate 2 step_pure
  -- fe25519_mul(r->T2d, p->T, d2);
  step_call using fe25519_mul.call_eq
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Sodium
