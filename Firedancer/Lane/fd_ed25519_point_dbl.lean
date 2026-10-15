module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.fd_ed25519_partial_dbl
public import Firedancer.Lane.Common.R43x6Point
public import Firedancer.Lane.Mlir.fd_ed25519_point_dbl

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn

attribute [local mlir_operation] zipWith_shl_wrap

/-- `fd_ed25519_point_dbl` stores `2A` of the point at `a` at `r` and returns `r`. -/
public theorem fd_ed25519_point_dbl.call_eq (r a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.QuadRoom r) (ha : s.mem.QuadFit a) :
    _root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbl.call
        (_root_.Firedancer.Lane.Mlir.fd_ed25519_point_dbl.args (.value r) (.value a)) s =
      .value
        (.cons (.value r) .nil,
          { s with
            mem := s.mem.storeQuad r (fd_ed25519_partial_dbl.spec (s.mem.readQuad a)) }) := by
  func_init
  have hra : S.mem.readQuad a = S₀.mem.readQuad a := by rw [hS]
  block_init
  iterate 30 step_pure
  iterate 9 step_pattern using runBodyFrom_insertRun
  -- FD_R43X6_QUAD_PERMUTE( _ta, 1,1,2,0, a->P )
  step_pattern using runBodyFrom_permuteLoadRun 1 1 2 0
  have e0 := hra ▸ _hx
  have e1 := _hp
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _ta, _ta, 1,0,0,0, _ta, a->P )
  step_pattern using runBodyFrom_laneAddRun' 1 0 0 0
  have e2 := _hl
  -- FD_R43X6_QUAD_SQR_FAST( _ta, _ta ) up to FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _tb )
  quad_dbl_mid
  -- FD_R43X6_QUAD_FOLD_UNSIGNED( r->P, _ta )
  step_pattern using runBodyFrom_foldUnsignedStoreRun
  have e3 := _hu
  finish_block
  subst hS
  rw [fd_ed25519_partial_dbl.spec, geDbl_eq_mid, e0, e1, e2, hD, Quad.foldUnsigned_eq, e3]
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.Lane
