module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.Runs
public import Firedancer.R52x5.Mlir.fd_curve25519_into_precomputed
import Firedancer.Common.Tactics

namespace MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `FD_R52X5_TO_TABLE( D, S )`: `121666 [Y-X, X+Y, 2Z, 2dT]`, as the macro's steps. -/
def fd_curve25519_into_precomputed.spec (S : Quad5) : Quad5 :=
  let _ta := S.diffSum
  let _ta := Quad5.laneIf 1 1 0 0 _ta S
  let _ta := _ta.reduce
  let _1122d := wl 121666 121666 (2 * 121666) (2 * 121665)
  let _ta := _ta.mulConstant _1122d
  let _tb := _ta.negateLazy
  let _ta := Quad5.laneIf 0 0 0 1 _tb _ta
  _ta.reduce

end

/-! ## Proof -/

section Proof

/-- `fd_curve25519_into_precomputed` stores `spec` of the point at `r` at `r`; its five
`wl_permute` calls' unions are freed, the counter moves on by five blocks. -/
public theorem fd_curve25519_into_precomputed.call_eq (r : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.Quad5Fit r) (hrw : Writable s.mem r) :
    fd_curve25519_into_precomputed.call (fd_curve25519_into_precomputed.args (.value r)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 5⟩,
            mem :=
              s.mem.storeQuad5 r (fd_curve25519_into_precomputed.spec (s.mem.readQuad5 r)) }) := by
  func_init
  block_init
  iterate 12 step_pure
  -- FD_R52X5_QUAD_DIFF_SUM( _ta, S )
  step_pattern using runBodyFrom_permuteLoadRun 1 0 3 2 inline
  have hA : S₀.mem.readQuad5 r = A := by
    rw [hS] at _hA; exact _hA
  clear _hA
  step_pattern using runBodyFrom_negateLazyRun inline
  step_pattern using runBodyFrom_laneIfRun 1 0 1 0 inline
  step_pattern using runBodyFrom_addFastRun inline
  -- FD_R52X5_QUAD_LANE_IF( _ta, 1,1,0,0, _ta, S )
  step_pattern using runBodyFrom_laneIfRun' 1 1 0 0 inline
  -- FD_R52X5_QUAD_REDUCE( _ta, _ta )
  step_pattern using runBodyFrom_reduceCastRun inline
  -- FD_R52X5_QUAD_MUL_CONSTANT( _ta, _ta, _1122d )
  step_pattern using runBodyFrom_mulConstRun inline
  -- FD_R52X5_QUAD_NEGATE_LAZY( _tb, _ta ), FD_R52X5_QUAD_LANE_IF( _ta, 0,0,0,1, _tb, _ta )
  step_pattern using runBodyFrom_negateLazyRun inline
  step_pattern using runBodyFrom_laneIfRun 0 0 0 1 inline
  -- FD_R52X5_QUAD_REDUCE( D, _ta )
  step_pattern using runBodyFrom_reduceCastStoreRun inline
  finish_block
  clear_reads
  subst hS
  erase_frame
  rw [hA]
  rfl

end Proof

end MLIR.Firedancer.R52x5
