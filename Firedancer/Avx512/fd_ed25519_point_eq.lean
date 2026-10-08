module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.Avx512.fd_r43x6_ge_is_eq
public import Firedancer.Avx512.Mlir.fd_ed25519_point_eq

namespace LeanMLIR.RIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `FD_R43X6_GE_IS_EQ` of the points `A` and `B`. -/
def fd_ed25519_point_eq.spec (A B : Quad) : BitVec 32 :=
  fd_r43x6_ge_is_eq.spec A B

end

/-! ## Proof -/

/-- `fd_ed25519_point_eq` returns `spec` of the points at `a` and `b`; `fd_r43x6_ge_is_eq`'s
temporaries use up three block ids. -/
public theorem fd_ed25519_point_eq.call_eq (a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (ha : s.mem.QuadFit a) (hb : s.mem.QuadFit b) :
    fd_ed25519_point_eq.call (fd_ed25519_point_eq.args (.value a) (.value b)) s =
      .value (.cons (.value (fd_ed25519_point_eq.spec (s.mem.readQuad a) (s.mem.readQuad b))) .nil,
        { s with alloc := ⟨s.alloc.nextFreeBlock + 3⟩ }) := by
  func_init
  block_init
  step_load with x03
  step_pure
  step_load with x14
  step_pure
  step_load with x25
  step_load with y03
  step_pure
  step_load with y14
  step_pure
  step_load with y25
  step_call using fd_r43x6_ge_is_eq.call_eq
  finish_block
  have he := congrArg GlobalState.mem (GlobalState.eraseFrom_self hwf₀)
  simp only at he
  subst_vars
  simp only [he]
  rfl

end LeanMLIR.RIR.Firedancer.Avx512
