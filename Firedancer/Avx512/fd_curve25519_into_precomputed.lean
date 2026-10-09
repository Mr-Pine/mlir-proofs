module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.Avx512.Mlir.fd_curve25519_into_precomputed

namespace MLIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `(Y-X, Y+X, Z, T)` folded, times `(1, 1, 1, 2d)`, folded: the table form of `A`. -/
def fd_curve25519_into_precomputed.spec (A : Quad) : Quad :=
  let _ta := A.permute 1 0 2 3
  let _ta := _ta.laneSubFast 1 0 0 0 _ta A
  let _ta := _ta.laneAddFast 0 1 0 0 _ta A
  let r := _ta.foldSigned
  (quadMul r quad1112d).foldUnsigned

end

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn
attribute [local mlir_operation] zipWith_and_wrap zipWith_add_wrap zipWith_sub_wrap
  zipWith_mul_wrap zipWith_lshr_wrap zipWith_ashr_wrap zipWith_shl_wrap zipWith_add_nsw_wrap
  zipWith_add_nsw_nuw_wrap zipWith_sub_nsw_wrap

public theorem fd_curve25519_into_precomputed.call_eq (r : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.QuadFit r) :
    fd_curve25519_into_precomputed.call (fd_curve25519_into_precomputed.args (.value r)) s =
      .value (.nil,
        { alloc := ⟨s.alloc.nextFreeBlock + 3⟩,
          mem := s.mem.storeQuad r (fd_curve25519_into_precomputed.spec (s.mem.readQuad r)) }) := by
  func_init
  block_init
  iterate 61 step_pure
  step_alloca with z03
  step_alloca with z14
  step_alloca with z25
  -- FD_R43X6_QUAD_PERMUTE( _ta, 1,0,2,3, r->P )
  step_load with x03
  step_pure with ta03
  step_pure
  step_load with x14
  step_pure with ta14
  step_pure
  step_load with x25
  step_pure with ta25
  -- FD_R43X6_QUAD_LANE_SUB_FAST( _ta, _ta, 1,0,0,0, _ta, r->P )
  step_pure
  step_pure
  step_pure with tb03
  step_pure
  step_pure
  step_pure with tb14
  step_pure
  step_pure
  step_pure with tb25
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _ta, _ta, 0,1,0,0, _ta, r->P )
  step_pure
  step_pure with tc03
  step_pure
  step_pure with tc14
  step_pure
  step_pure with tc25
  -- FD_R43X6_QUAD_FOLD_SIGNED( r->P, _ta )
  step_pattern using runBodyFrom_foldSignedRun
  -- FD_R43X6_QUAD_MUL_FAST( r->P, r->P, _1112d )
  iterate 3 step_pure
  step_call using fd_r43x6_quad_mul_fast.call_eq
  step_load with g03
  step_load with g14
  step_load with g25
  iterate 3 step_pure
  -- FD_R43X6_QUAD_FOLD_UNSIGNED( r->P, r->P )
  step_pattern using runBodyFrom_foldUnsignedStoreRun'
  finish_block
  subst hS
  erase_frame
  simp only [fd_curve25519_into_precomputed.spec, Quad.permute_1023, Quad.laneSubFast_1000,
    Quad.laneAddFast_0100, Quad.foldSigned_eq, Quad.foldUnsigned_eq]
  -- the spec's stages, one by one, as the values the code computed
  have e0 : S₀.mem.readQuad r = ⟨x03, x14, x25⟩ := by rw [hx03, hx14, hx25]; rfl
  have e1 : Quad.perm4 1 0 2 3 ⟨x03, x14, x25⟩ = ⟨ta03, ta14, ta25⟩ := by
    rw [hta03, hta14, hta25]; rfl
  have e2 : Quad.subSel true false false false ⟨ta03, ta14, ta25⟩ ⟨x03, x14, x25⟩ =
      ⟨tb03, tb14, tb25⟩ := by
    rw [htb03, htb14, htb25]; rfl
  have e3 : Quad.addSel false true false false ⟨tb03, tb14, tb25⟩ ⟨x03, x14, x25⟩ =
      ⟨tc03, tc14, tc25⟩ := by
    rw [htc03, htc14, htc25]; rfl
  have e5 : quadMul ⟨s03, s14, s25⟩ quad1112d = ⟨g03, g14, g25⟩ := by
    rw [hg03, hg14, hg25]; rfl
  rw [e0, e1, e2, e3, _hs, e5, _hu]
  rfl

end Proof

end MLIR.Firedancer.Avx512
