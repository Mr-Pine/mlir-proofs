module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.GeDbl
public import Firedancer.R52x5.Mlir.fd_ed25519_partial_dbl

namespace MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `2 A`: `FD_R52X5_GE_DBL`. -/
def fd_ed25519_partial_dbl.spec (A : Quad5) : Quad5 :=
  geDbl A

end

/-! ## Proof -/

section Proof

/-- `fd_ed25519_partial_dbl` stores `spec` of the point at `a` at `r` and returns `r`; `r` may be
`a`. Its ten temporaries and thirty `wl_permute` calls use up forty block ids. -/
public theorem fd_ed25519_partial_dbl.call_eq (r a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.Quad5Fit r) (ha : s.mem.Quad5Fit a) :
    fd_ed25519_partial_dbl.call (fd_ed25519_partial_dbl.args (.value r) (.value a)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 40⟩,
            mem := s.mem.storeQuad5 r (fd_ed25519_partial_dbl.spec (s.mem.readQuad5 a)) }) := by
  func_init
  have hra : S.mem.readQuad5 a = S₀.mem.readQuad5 a := by rw [hS]
  block_init
  iterate 11 step_pure
  iterate 10 step_alloca
  -- FD_R52X5_QUAD_PERMUTE( _ta, 1,0,3,2, P1 ), FD_R52X5_QUAD_ADD_FAST( _ta, _ta, P1 )
  step_pattern using runBodyFrom_permuteLoadRun 1 0 3 2 inline
  have hA := hra ▸ _hA
  clear _hA hra
  step_pattern using runBodyFrom_addFastRun inline
  -- FD_R52X5_QUAD_PERMUTE( _ta, 0,1,0,1, _ta ), FD_R52X5_QUAD_LANE_IF( _ta, 0,0,0,1, _ta, P1 )
  step_pattern using runBodyFrom_permuteRun 0 1 0 1 inline
  step_pattern using runBodyFrom_laneIfRun 0 0 0 1 inline
  -- FD_R52X5_QUAD_REDUCE( _ta, _ta ), FD_R52X5_QUAD_SQR_FAST( _ta, _ta )
  step_pattern using runBodyFrom_reduceCastRun inline
  step_pattern using runBodyFrom_qpSqrRun inline
  -- _1111, _2222, _2224
  step_pattern using runBodyFrom_permuteRun 0 0 0 0 inline
  step_pattern using runBodyFrom_permuteRun 1 1 1 1 inline
  step_pattern using runBodyFrom_laneIfMaskRun 0 0 0 1 inline
  step_pattern using runBodyFrom_negateLazyRun inline
  -- FD_R52X5_QUAD_ADD_FAST( _ta, _ta, _ta ) up to FD_R52X5_QUAD_REDUCE( _ta, _ta )
  step_pattern using runBodyFrom_addSelfRun inline
  step_pattern using runBodyFrom_laneIfZeroRun 0 0 1 0 inline
  step_pattern using runBodyFrom_addFastRun inline
  step_pattern using runBodyFrom_laneIfBytesRun 1 0 0 1 inline
  step_pattern using runBodyFrom_addFastRun inline
  step_pattern using runBodyFrom_laneIfZeroRun 0 1 1 1 inline
  step_pattern using runBodyFrom_addFastRun inline
  step_pattern using runBodyFrom_reduceRun inline
  -- _tb, _ta, FD_R52X5_QUAD_MUL_FAST( P2, _ta, _tb ), FD_R52X5_QUAD_REDUCE( P2, P2 )
  step_pattern using runBodyFrom_permuteRun 3 1 1 3 inline
  step_pattern using runBodyFrom_permuteRun 2 0 2 0 inline
  step_pattern using runBodyFrom_qpMulGepRun inline
  step_pattern using runBodyFrom_reduceStoreRun inline
  finish_block
  subst hS
  erase_frame
  rw [hA]
  rfl

end Proof

end MLIR.Firedancer.R52x5
