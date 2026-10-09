module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.Runs
import Firedancer.Common.Tactics
public import Firedancer.R52x5.wc_bcast_wide
public import Firedancer.R52x5.Mlir.fd_ed25519_point_neg

namespace MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `-A`: `X` and `T` replaced by `32 p - X` and `32 p - T`, reduced. -/
def fd_ed25519_point_neg.spec (A : Quad5) : Quad5 :=
  let _p := A.negateLazy
  let _p := _p.reduce
  Quad5.laneIf 1 0 0 1 _p A

end

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn

attribute [local mlir_operation] zipWith_sub_wl

/-- `fd_ed25519_point_neg` stores `spec` of the point at `a` at `r`, which is `a` itself or in
another block, and returns `r`. -/
public theorem fd_ed25519_point_neg.call_eq (r a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.Quad5Fit r) (ha : s.mem.Quad5Fit a) (hsep : r = a ∨ r.id ≠ a.id) :
    fd_ed25519_point_neg.call (fd_ed25519_point_neg.args (.value r) (.value a)) s =
      .value
        (.cons (.value r) .nil,
          { s with
            mem := s.mem.storeQuad5 r (fd_ed25519_point_neg.spec (s.mem.readQuad5 a)) }) := by
  rcases hsep with rfl | hsep
  all_goals
    func_init
    block_init
    iterate 7 step_pure
    -- FD_R52X5_QUAD_NEGATE_LAZY( _p, a->P ), with the loads of a->P
    step_load [ofFn_extractVecElem_readAt] with a0
    step_pure with n0
    step_pure
    step_load [ofFn_extractVecElem_readAt] with a1
    step_pure with n1
    step_pure
    step_load [ofFn_extractVecElem_readAt] with a2
    step_pure with n2
    step_pure
    step_load [ofFn_extractVecElem_readAt] with a3
    step_pure with n3
    step_pure
    step_load [ofFn_extractVecElem_readAt] with a4
    step_pure with n4
    -- FD_R52X5_QUAD_REDUCE( _p, _p )
    step_pattern using runBodyFrom_reduceRun (Q := ⟨n0, n1, n2, n3, n4⟩) inline
    -- FD_R52X5_QUAD_LANE_IF( r->P, 1,0,0,1, _p, a->P ), a->P reloaded after each store
    step_call using wc_bcast_wide.call_eq
    iterate 3 step_pattern using runBodyFrom_bytesRun inline
    step_pattern using runBodyFrom_blendRun 1 0 0 1 inline
    step_store
    iterate 4 
      step_load [ofFn_extractVecElem_bytes] inline
      step_pattern using runBodyFrom_bytesRun inline
      step_pattern using runBodyFrom_blendRun 1 0 0 1 inline
      step_pure
      step_store
    finish_block
    rw [hS]
    simp only [MemoryState.storeAt_packLanes_wlBytes]
    clear_reads
    subst_vars
    rfl

end Proof

end MLIR.Firedancer.R52x5
