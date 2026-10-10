module

public import MLIR.Run.Tactic
public import Boringssl.Common.Point
public import Boringssl.fe_0
public import Boringssl.fe_1
public import Boringssl.Mlir.ge_p2_0

namespace MLIR.Boringssl

/-! ## Specification -/

@[expose] public section

/-- The neutral point `(0 : 1 : 1)`. -/
def ge_p2_0.spec : GeP2 :=
  ⟨fe_0.spec, fe_1.spec, fe_1.spec⟩

end

/-! ## Proof -/

section Proof

/-- `ge_p2_0` stores `spec` at `h`. -/
public theorem ge_p2_0.call_eq (h : Pointer) (s : GlobalState) (hwf : s.WF) (hh : s.mem.Fe3Room h) :
    ge_p2_0.call (ge_p2_0.args (.value h)) s =
      .value (.nil, { s with mem := s.mem.storeP2 h ge_p2_0.spec }) := by
  func_init
  block_init
  -- fe_0(&h->X); fe_1(&h->Y); fe_1(&h->Z);
  step_call using fe_0.call_eq
  step_pure
  step_call using fe_1.call_eq
  step_pure
  step_call using fe_1.call_eq
  finish_block
  subst hS
  rfl

end Proof

end MLIR.Boringssl
