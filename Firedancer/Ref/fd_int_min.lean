module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Ref.Mlir.fd_int_min

namespace LeanMLIR.RIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `fd_int_min( x, 14 )`, the call `fd_curve25519_scalar_wnaf` makes: the signed minimum. -/
def fd_int_min.spec (x : BitVec 32) : BitVec 32 :=
  if x.slt 14#32 then x else 14#32

end

/-! ## Proof -/

section Proof

public theorem fd_int_min.call_eq (x : BitVec 32) (s : GlobalState) (hwf : s.WF) :
    fd_int_min.call (fd_int_min.args (.value x)) s =
      .value (.cons (.value (fd_int_min.spec x)) .nil, s) := by
  func_init
  block_init
  step_pure
  step_pure
  finish_block
  rw [hS, fd_int_min.spec]

end Proof

end LeanMLIR.RIR.Firedancer.Ref
