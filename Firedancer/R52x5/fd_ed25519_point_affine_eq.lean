module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.fd_ed25519_point_eq
public import Firedancer.R52x5.Mlir.fd_ed25519_point_affine_eq

namespace MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `fd_ed25519_point_eq` of the points `A` and `B` (`B` with `Z = 1` at the call sites). -/
def fd_ed25519_point_affine_eq.spec (A B : Quad5) : BitVec 32 :=
  fd_ed25519_point_eq.spec A B

end

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_affine_eq` returns `spec` of the points at `a` and `b`; as
`fd_ed25519_point_eq`, 22 blocks. -/
public theorem fd_ed25519_point_affine_eq.call_eq (a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (ha : s.mem.Quad5Fit a) (hb : s.mem.Quad5Fit b) :
    fd_ed25519_point_affine_eq.call (fd_ed25519_point_affine_eq.args (.value a) (.value b)) s =
      .value
        (.cons (.value (fd_ed25519_point_affine_eq.spec (s.mem.readQuad5 a) (s.mem.readQuad5 b)))
            .nil,
          { s with alloc := ⟨s.alloc.nextFreeBlock + 22⟩ }) := by
  func_init
  block_init
  -- return fd_ed25519_point_eq( a, b );
  step_call using fd_ed25519_point_eq.call_eq
  finish_block
  have he := congrArg GlobalState.mem (GlobalState.eraseFrom_self hwf₀)
  simp only at he
  subst_vars
  simp only [he]
  rfl

end Proof

end MLIR.Firedancer.R52x5
