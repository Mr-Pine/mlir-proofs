module

public import MLIR.Run.Tactic
public import Boringssl.Common.Point
public import Boringssl.ge_p2_0
public import Sodium.fe25519_0
public import Sodium.fe25519_1
public import Sodium.Mlir.ge25519_p2_0

namespace MLIR.Sodium

/-! ## Proof -/

section Proof

/-- `ge25519_p2_0` stores BoringSSL's `ge_p2_0.spec`, the neutral point `(0 : 1 : 1)`, at `h`. -/
public theorem ge25519_p2_0.call_eq (h : Pointer) (s : GlobalState) (hwf : s.WF)
    (hh : s.mem.Fe3Room h) :
    ge25519_p2_0.call (ge25519_p2_0.args (.value h)) s =
      .value (.nil, { s with mem := s.mem.storeP2 h Boringssl.ge_p2_0.spec }) := by
  func_init
  block_init
  -- fe25519_0(h->X); fe25519_1(h->Y); fe25519_1(h->Z);
  step_call using fe25519_0.call_eq
  step_pure
  step_call using fe25519_1.call_eq
  step_pure
  step_call using fe25519_1.call_eq
  finish_block
  subst hS
  rfl

end Proof

end MLIR.Sodium
