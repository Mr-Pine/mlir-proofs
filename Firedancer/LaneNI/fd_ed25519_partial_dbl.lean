module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.QuadOps
public import Firedancer.LaneNI.Mlir.fd_ed25519_partial_dbl
public import Firedancer.LaneNI.Common.Point
public import Firedancer.Avx512.fd_ed25519_partial_dbl

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512

/-! ## Proof -/

section Proof

public theorem _root_.Firedancer.LaneNI.Mlir.fd_ed25519_partial_dbl.call_eq
    (r a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.QuadRoom r) (ha : s.mem.QuadFit a) :
    Firedancer.LaneNI.Mlir.fd_ed25519_partial_dbl.call
        (Firedancer.LaneNI.Mlir.fd_ed25519_partial_dbl.args (.value r) (.value a)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 6⟩,
            mem := s.mem.storeQuad r (fd_ed25519_partial_dbl.spec (s.mem.readQuad a)) }) := by
  func_init
  have hra : S.mem.readQuad a = S₀.mem.readQuad a := by rw [hS]
  block_init
  iterate 24 step_pure
  iterate 7 step_pattern using runBodyFrom_insertRun
  iterate 6 step_alloca
  -- FD_R43X6_QUAD_PERMUTE( _ta, 1,1,2,0, a->P )
  step_pattern using runBodyFrom_permuteLoadRun 1 1 2 0
  have e0 := hra ▸ _hx
  have e1 := _hp
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _ta, _ta, 1,0,0,0, _ta, a->P )
  step_pattern using runBodyFrom_laneAddRun' 1 0 0 0
  have e2 := _hl
  -- FD_R43X6_QUAD_SQR_FAST( _ta, _ta ) up to FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _tb )
  step_pattern using runBodyFrom_dblMidRunNI
  have e3 := _hdbl
  -- FD_R43X6_QUAD_FOLD_UNSIGNED( r->P, _ta )
  step_pattern using runBodyFrom_foldUnsignedStoreRun
  have e4 := _hu
  finish_block
  subst hS
  erase_frame
  rw [fd_ed25519_partial_dbl.spec, geDbl_eq_mid, e0, e1, e2, e3, Quad.foldUnsigned_eq, e4]
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.LaneNI
