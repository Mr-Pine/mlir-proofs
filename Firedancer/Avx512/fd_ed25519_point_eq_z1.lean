module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.Avx512.fd_ed25519_point_eq
public import Firedancer.Avx512.Mlir.fd_ed25519_point_eq_z1

namespace LeanMLIR.RIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_ed25519_point_eq` of `A` and `B`; `B`'s `Z = 1` is not used. -/
def fd_ed25519_point_eq_z1.spec (A B : Quad) : BitVec 32 :=
  fd_ed25519_point_eq.spec A B

end

/-! ## Proof -/

/-- `fd_ed25519_point_eq_z1` returns `spec` of the points at `a` and `b`; `fd_r43x6_ge_is_eq`'s
temporaries use up three block ids. -/
public theorem fd_ed25519_point_eq_z1.call_eq (a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (ha : s.mem.QuadFit a) (hb : s.mem.QuadFit b) :
    fd_ed25519_point_eq_z1.call (fd_ed25519_point_eq_z1.args (.value a) (.value b)) s =
      .value (.cons (.value (fd_ed25519_point_eq_z1.spec (s.mem.readQuad a) (s.mem.readQuad b)))
        .nil, { s with alloc := ⟨s.alloc.nextFreeBlock + 3⟩ }) := by
  func_init
  block_init
  step_call using fd_ed25519_point_eq.call_eq
  finish_block
  have he := congrArg GlobalState.mem (GlobalState.eraseFrom_self hwf₀)
  simp only at he
  subst_vars
  simp only [he]
  rfl

end LeanMLIR.RIR.Firedancer.Avx512
