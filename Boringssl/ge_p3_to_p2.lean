module

public import MLIR.Run.Tactic
public import Boringssl.Common.Point
public import Boringssl.fe_copy
public import Boringssl.Mlir.ge_p3_to_p2

namespace MLIR.Boringssl

/-! ## Specification -/

@[expose] public section

/-- `ge_p3` to `ge_p2`: `T` dropped. -/
def ge_p3_to_p2.spec (P : GeP3) : GeP2 :=
  ⟨P.X, P.Y, P.Z⟩

end

/-! ## Proof -/

section Proof

/-- `ge_p3_to_p2` stores `spec` of the `ge_p3` at `p` at `r`, in another block. -/
public theorem ge_p3_to_p2.call_eq (r p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.Fe3Room r) (hp : s.mem.PointFit p) (hsep : r.id ≠ p.id) :
    ge_p3_to_p2.call (ge_p3_to_p2.args (.value r) (.value p)) s =
      .value (.nil, { s with mem := s.mem.storeP2 r (ge_p3_to_p2.spec (s.mem.readP3 p)) }) := by
  func_init
  block_init
  step_call using fe_copy.call_eq
  iterate 2 step_pure
  step_call using fe_copy.call_eq
  iterate 2 step_pure
  step_call using fe_copy.call_eq
  finish_block
  subst hS
  rfl

end Proof

end MLIR.Boringssl
