module

public import MLIR.Run.Tactic
public import Boringssl.Common.Point
public import Boringssl.ge_p3_to_p2
public import Sodium.fe25519_copy
public import Sodium.Mlir.ge25519_p3_to_p2

namespace MLIR.Sodium

/-! ## Proof -/

section Proof

/-- `ge25519_p3_to_p2` stores BoringSSL's `ge_p3_to_p2.spec` (`T` dropped) of the `ge25519_p3` at
`p` at `r`, in another block. -/
public theorem ge25519_p3_to_p2.call_eq (r p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.Fe3Room r) (hp : s.mem.PointFit p) (hsep : r.id ≠ p.id) :
    ge25519_p3_to_p2.call (ge25519_p3_to_p2.args (.value r) (.value p)) s =
      .value
        (.nil,
          { s with mem := s.mem.storeP2 r (Boringssl.ge_p3_to_p2.spec (s.mem.readP3 p)) }) := by
  func_init
  block_init
  -- fe25519_copy(r->X, p->X); fe25519_copy(r->Y, p->Y); fe25519_copy(r->Z, p->Z);
  step_call using fe25519_copy.call_eq
  iterate 2 step_pure
  step_call using fe25519_copy.call_eq
  iterate 2 step_pure
  step_call using fe25519_copy.call_eq
  finish_block
  subst hS
  rfl

end Proof

end MLIR.Sodium
