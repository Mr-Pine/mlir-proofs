module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Boringssl.Common.Point
public import Boringssl.Globals
public import Boringssl.fe_add
public import Boringssl.fe_sub
public import Boringssl.fe_copy_lt
public import Boringssl.fe_mul_ltt
public import Boringssl.Mlir.x25519_ge_p3_to_cached

namespace MLIR.Boringssl

/-! ## Specification -/

@[expose] public section

/-- `ge_p3` to `ge_cached`: `(Y + X, Y - X, Z, 2d T)`, the sums not carried. -/
def x25519_ge_p3_to_cached.spec (P : GeP3) : GeCached :=
  ⟨Firedancer.Ref.fiat_25519_add.spec P.Y P.X, Firedancer.Ref.fiat_25519_sub.spec P.Y P.X, P.Z,
    Firedancer.Ref.fiat_25519_carry_mul.spec P.T Firedancer.Ref.fd_f25519_k.limbs⟩

end

/-! ## Proof -/

section Proof

/-- `x25519_ge_p3_to_cached` stores `spec` of the `ge_p3` at `p` at `r`, in another block. The
global `d2`'s block is freed again: only the counter moves on. -/
public theorem x25519_ge_p3_to_cached.call_eq (r p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.PointRoom r) (hp : s.mem.PointFit p) (hsep : r.id ≠ p.id) :
    x25519_ge_p3_to_cached.call (x25519_ge_p3_to_cached.args (.value r) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem := s.mem.storeCached r (x25519_ge_p3_to_cached.spec (s.mem.readP3 p)) }) := by
  func_init
  have hp₀ : S₀.mem.PointFit p := hS ▸ hp
  block_init
  step_addressof d2.value_eq with d2
  have hd2_read := Boringssl.d2.readLimbs hd2_fits hd2_off hread_d2
  clear hread_d2
  limbs_fit d2
  step_pure
  -- fe_add(&r->YplusX, &p->Y, &p->X);
  step_call using fe_add.call_eq
  step_pure
  -- fe_sub(&r->YminusX, &p->Y, &p->X);
  step_call using fe_sub.call_eq
  iterate 2 step_pure
  -- fe_copy_lt(&r->Z, &p->Z);
  step_call using fe_copy_lt.call_eq
  iterate 2 step_pure
  -- fe_mul_ltt(&r->T2d, &p->T, &d2);
  step_call using fe_mul_ltt.call_eq
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Boringssl
