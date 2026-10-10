module

public import MLIR.Run.Tactic
public import Boringssl.Common.Point
public import Sodium.fe25519_mul
public import Sodium.Mlir.ge25519_p1p1_to_p2

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

/-- `ge25519_p1p1` to `ge25519_p2`: `(X T : Y Z : Z T)`. -/
def ge25519_p1p1_to_p2.spec (P : GeP1p1) : GeP2 :=
  ⟨fe25519_mul.spec P.X P.T, fe25519_mul.spec P.Y P.Z, fe25519_mul.spec P.Z P.T⟩

end

/-! ## Proof -/

section Proof

/-- `ge25519_p1p1_to_p2` stores `spec` of the `ge25519_p1p1` at `p` at `r`, in another block. -/
public theorem ge25519_p1p1_to_p2.call_eq (r p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.Fe3Room r) (hp : s.mem.PointFit p) (hsep : r.id ≠ p.id) :
    ge25519_p1p1_to_p2.call (ge25519_p1p1_to_p2.args (.value r) (.value p)) s =
      .value
        (.nil, { s with mem := s.mem.storeP2 r (ge25519_p1p1_to_p2.spec (s.mem.readP1p1 p)) }) := by
  func_init
  block_init
  -- fe25519_mul(r->X, p->X, p->T);
  step_pure
  step_call using fe25519_mul.call_eq
  -- fe25519_mul(r->Y, p->Y, p->Z);
  iterate 3 step_pure
  step_call using fe25519_mul.call_eq
  -- fe25519_mul(r->Z, p->Z, p->T);
  step_pure
  step_call using fe25519_mul.call_eq
  finish_block
  subst hS
  rfl

end Proof

end MLIR.Sodium
