module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.fd_r52x5_ge_is_eq
public import Firedancer.R52x5.Mlir.fd_ed25519_point_eq

namespace MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `FD_R52X5_GE_IS_EQ` of the points `A` and `B`. -/
def fd_ed25519_point_eq.spec (A B : Quad5) : BitVec 32 :=
  fd_r52x5_ge_is_eq.spec A B

end

/-! ## Proof -/

section Proof

/-- `fd_ed25519_point_eq` returns `spec` of the points at `a` and `b`; `fd_r52x5_ge_is_eq` moves
the counter on by 22 blocks. -/
public theorem fd_ed25519_point_eq.call_eq (a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (ha : s.mem.Quad5Fit a) (hb : s.mem.Quad5Fit b) :
    fd_ed25519_point_eq.call (fd_ed25519_point_eq.args (.value a) (.value b)) s =
      .value
        (.cons (.value (fd_ed25519_point_eq.spec (s.mem.readQuad5 a) (s.mem.readQuad5 b))) .nil,
          { s with alloc := ⟨s.alloc.nextFreeBlock + 22⟩ }) := by
  func_init
  block_init
  -- FD_R52X5_GE_IS_EQ( a->P, b->P ), with the loads of a->P and b->P
  step_load [ofFn_extractVecElem_readAt]
  iterate 4 
    step_pure
    step_load [ofFn_extractVecElem_readAt]
  step_load [ofFn_extractVecElem_readAt]
  iterate 4 
    step_pure
    step_load [ofFn_extractVecElem_readAt]
  step_call using (fd_r52x5_ge_is_eq.call_eq (S₀.mem.readQuad5 a) (S₀.mem.readQuad5 b))
  finish_block
  have he := congrArg GlobalState.mem (GlobalState.eraseFrom_self hwf₀)
  simp only at he
  subst_vars
  simp only [he]
  rfl

end Proof

end MLIR.Firedancer.R52x5
