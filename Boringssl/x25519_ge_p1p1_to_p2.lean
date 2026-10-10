module

public import MLIR.Run.Tactic
public import Boringssl.Common.Point
public import Boringssl.fe_mul_tll
public import Boringssl.Mlir.x25519_ge_p1p1_to_p2

namespace MLIR.Boringssl

/-! ## Specification -/

@[expose] public section

/-- `ge_p1p1` to `ge_p2`: `(X T : Y Z : Z T)`. -/
def x25519_ge_p1p1_to_p2.spec (P : GeP1p1) : GeP2 :=
  ⟨Firedancer.Ref.fiat_25519_carry_mul.spec P.X P.T,
    Firedancer.Ref.fiat_25519_carry_mul.spec P.Y P.Z,
    Firedancer.Ref.fiat_25519_carry_mul.spec P.Z P.T⟩

end

/-! ## Proof -/

section Proof

/-- `x25519_ge_p1p1_to_p2` stores `spec` of the `ge_p1p1` at `p` at `r`, in another block. -/
public theorem x25519_ge_p1p1_to_p2.call_eq (r p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.Fe3Room r) (hp : s.mem.PointFit p) (hsep : r.id ≠ p.id) :
    x25519_ge_p1p1_to_p2.call (x25519_ge_p1p1_to_p2.args (.value r) (.value p)) s =
      .value
        (.nil,
          { s with mem := s.mem.storeP2 r (x25519_ge_p1p1_to_p2.spec (s.mem.readP1p1 p)) }) := by
  func_init
  block_init
  step_pure
  -- fe_mul_tll(&r->X, &p->X, &p->T);
  step_call using fe_mul_tll.call_eq
  iterate 3 step_pure
  -- fe_mul_tll(&r->Y, &p->Y, &p->Z);
  step_call using fe_mul_tll.call_eq
  step_pure
  -- fe_mul_tll(&r->Z, &p->Z, &p->T);
  step_call using fe_mul_tll.call_eq
  finish_block
  subst hS
  rfl

end Proof

end MLIR.Boringssl
