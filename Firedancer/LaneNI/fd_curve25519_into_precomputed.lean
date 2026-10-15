module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.QuadOps
public import Firedancer.LaneNI.Mlir.fd_curve25519_into_precomputed
public import Firedancer.LaneNI.Common.Point
public import Firedancer.Avx512.fd_curve25519_into_precomputed

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512

/-! ## Proof -/

section Proof

public theorem _root_.Firedancer.LaneNI.Mlir.fd_curve25519_into_precomputed.call_eq
    (r : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.QuadFit r) (hrw : Writable s.mem r) :
    Firedancer.LaneNI.Mlir.fd_curve25519_into_precomputed.call
        (Firedancer.LaneNI.Mlir.fd_curve25519_into_precomputed.args (.value r)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 3⟩,
            mem :=
              s.mem.storeQuad r (fd_curve25519_into_precomputed.spec (s.mem.readQuad r)) }) := by
  func_init
  have hrr : S.mem.readQuad r = S₀.mem.readQuad r := by rw [hS]
  block_init
  iterate 26 step_pure
  iterate 4 step_pattern using runBodyFrom_insertRun
  step_alloca with z03
  step_alloca with z14
  step_alloca with z25
  -- FD_R43X6_QUAD_PERMUTE( _ta, 1,0,2,3, r->P ), only the lanes the subtraction reads
  step_pattern using runBodyFrom_permuteLoadRun_poison 1 0 2 3 1 0 0 0
  have e0 := hrr ▸ _hx
  -- FD_R43X6_QUAD_LANE_SUB_FAST( _ta, _ta, 1,0,0,0, _ta, r->P )
  step_pattern using runBodyFrom_laneSubPermRun 1 0 2 3 1 0 0 0
  have e1 := _hl
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _ta, _ta, 0,1,0,0, _ta, r->P )
  step_pattern using runBodyFrom_laneAddRun 0 1 0 0
  have e2 := _hl
  -- FD_R43X6_QUAD_FOLD_SIGNED( r->P, _ta )
  step_pattern using runBodyFrom_foldSignedRun
  have e3 := _hs
  -- FD_R43X6_QUAD_MUL_FAST( r->P, r->P, _1112d )
  step_pattern using runBodyFrom_mulRunNI
  have e4 : quadMul _ quad1112d = _ := _hm
  -- FD_R43X6_QUAD_FOLD_UNSIGNED( r->P, r->P )
  step_pattern using runBodyFrom_foldUnsignedStoreRun'
  have e5 := _hu
  finish_block
  subst hS
  erase_frame
  simp only [fd_curve25519_into_precomputed.spec, Quad.foldSigned_eq, Quad.foldUnsigned_eq]
  rw [e0, e1, e2, e3, e4, e5]
  rfl

end Proof

end MLIR.Firedancer.LaneNI
