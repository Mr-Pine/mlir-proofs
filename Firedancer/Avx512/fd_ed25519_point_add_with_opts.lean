module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.Avx512.Mlir.fd_ed25519_point_add_with_opts

namespace LeanMLIR.RIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `A + B`: `FD_R43X6_GE_ADD_TABLE_ALT` when `b_is_precomputed`, else `FD_R43X6_GE_ADD`;
`b_Z_is_one` and `skip_last_mul` are unused. -/
def fd_ed25519_point_add_with_opts.spec (A B : Quad) (b_is_precomputed : BitVec 32) : Quad :=
  if b_is_precomputed ≠ 0 then geAddTable quadMul A B else geAdd quadMul A B

end

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn

-- both branches' 250-300 instructions of vector code in one proof
set_option maxHeartbeats 2000000 in
/-- `fd_ed25519_point_add_with_opts` stores `spec` of the points at `a` and `b` at `r` and returns
`r`; `r` may be `a` or `b`. -/
public theorem fd_ed25519_point_add_with_opts.call_eq (r a b : Pointer) (pre : BitVec 32)
    (s : GlobalState) (hwf : s.WF) (hr : s.mem.QuadFit r) (ha : s.mem.QuadFit a)
    (hb : s.mem.QuadFit b) :
    fd_ed25519_point_add_with_opts.call
        (fd_ed25519_point_add_with_opts.args (.value r) (.value a) (.value b) (.value pre)) s =
      .value (.cons (.value r) .nil,
        { alloc := ⟨s.alloc.nextFreeBlock + 15⟩,
          mem := s.mem.storeQuad r
            (fd_ed25519_point_add_with_opts.spec (s.mem.readQuad a) (s.mem.readQuad b) pre) }) := by
  func_init
  have ha03 : S.mem.readAt a 512 = S₀.mem.readAt a 512 := by rw [hS]
  have ha14 : S.mem.readAt (a.add 64#64) 512 = S₀.mem.readAt (a.add 64#64) 512 := by rw [hS]
  have ha25 : S.mem.readAt (a.add 128#64) 512 = S₀.mem.readAt (a.add 128#64) 512 := by rw [hS]
  have hb03 : S.mem.readAt b 512 = S₀.mem.readAt b 512 := by rw [hS]
  have hb14 : S.mem.readAt (b.add 64#64) 512 = S₀.mem.readAt (b.add 64#64) 512 := by rw [hS]
  have hb25 : S.mem.readAt (b.add 128#64) 512 = S₀.mem.readAt (b.add 128#64) 512 := by rw [hS]
  block_init
  iterate 88 step_pure
  iterate 15 step_alloca
  step_pure
  finish_block
  · -- `!b_is_precomputed`: FD_R43X6_GE_ADD
    subst hbr
    block_init
    -- FD_R43X6_QUAD_PERMUTE( _ta, 1,0,2,3, P1 ); FD_R43X6_QUAD_PERMUTE( _tb, 1,0,2,3, P2 )
    step_load with x03
    step_pure with ta03
    step_pure
    step_load with x14
    step_pure with ta14
    step_pure
    step_load with x25
    step_pure with ta25
    step_load with y03
    step_pure with tb03
    step_pure
    step_load with y14
    step_pure with tb14
    step_pure
    step_load with y25
    step_pure with tb25
    -- FD_R43X6_QUAD_LANE_SUB_FAST( _ta, _ta, 1,0,0,0, _ta, P1 ); the same for `_tb`, `P2`
    step_pure [wrapZipWith]
    step_pure [expandOfFn]
    step_pure with tc03
    step_pure [wrapZipWith]
    step_pure [expandOfFn]
    step_pure with tc14
    step_pure [wrapZipWith]
    step_pure [expandOfFn]
    step_pure with tc25
    step_pure [wrapZipWith]
    step_pure [expandOfFn]
    step_pure with td03
    step_pure [wrapZipWith]
    step_pure [expandOfFn]
    step_pure with td14
    step_pure [wrapZipWith]
    step_pure [expandOfFn]
    step_pure with td25
    -- FD_R43X6_QUAD_LANE_ADD_FAST( _ta, _ta, 0,1,1,0, _ta, P1 ); `( _tb, _tb, 0,1,0,0, _tb, P2 )`
    step_pure [wrapZipWith]
    step_pure with te03
    step_pure [wrapZipWith]
    step_pure with te14
    step_pure [wrapZipWith]
    step_pure with te25
    step_pure [wrapZipWith]
    step_pure with tf03
    step_pure [wrapZipWith]
    step_pure with tf14
    step_pure [wrapZipWith]
    step_pure with tf25
    -- FD_R43X6_QUAD_FOLD_SIGNED( _ta, _ta ); FD_R43X6_QUAD_FOLD_SIGNED( _tb, _tb )
    step_pattern using runBodyFrom_foldSignedRun
    have eF1 := _hs
    step_pattern using runBodyFrom_foldSignedRun
    have eF2 := _hs
    -- FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _1112d )
    iterate 3 step_pure
    step_call using fd_r43x6_quad_mul_fast.call_eq
    step_load with g03
    step_load with g14
    step_load with g25
    iterate 3 step_pure
    have e4 : quadMul (Quad.foldSignedC ⟨te03, te14, te25⟩) quad1112d = ⟨g03, g14, g25⟩ := by
      rw [eF1, hg03, hg14, hg25]; rfl
    -- FD_R43X6_QUAD_FOLD_UNSIGNED( _ta, _ta )
    step_pattern using runBodyFrom_foldUnsignedRun
    have eU1 := _hu
    -- FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _tb )
    iterate 3 step_pure
    step_call using fd_r43x6_quad_mul_fast.call_eq
    step_load with h03
    step_load with h14
    step_load with h25
    iterate 3 step_pure
    have e5 : quadMul ⟨u03, u14, u25⟩ (Quad.foldSignedC ⟨tf03, tf14, tf25⟩) = ⟨h03, h14, h25⟩ := by
      rw [eF2, hh03, hh14, hh25]; rfl
    -- FD_R43X6_QUAD_PERMUTE( _tb, 1,0,3,2, _ta )
    step_pure with pa03
    step_pure with pa14
    step_pure with pa25
    -- FD_R43X6_QUAD_LANE_SUB_FAST( _tb, _tb, 1,0,0,1, _tb, _ta )
    step_pure [wrapZipWith]
    step_pure [expandOfFn]
    step_pure with pb03
    step_pure [wrapZipWith]
    step_pure [expandOfFn]
    step_pure with pb14
    step_pure [wrapZipWith]
    step_pure [expandOfFn]
    step_pure with pb25
    -- FD_R43X6_QUAD_LANE_ADD_FAST( _tb, _tb, 0,1,1,0, _tb, _ta )
    step_pure [wrapZipWith]
    step_pure with pc03
    step_pure [wrapZipWith]
    step_pure with pc14
    step_pure [wrapZipWith]
    step_pure with pc25
    have e6 : Quad.perm4 1 0 3 2 ⟨h03, h14, h25⟩ = ⟨pa03, pa14, pa25⟩ := by
      rw [hpa03, hpa14, hpa25]; rfl
    have e7 : Quad.subSel true false false true ⟨pa03, pa14, pa25⟩ ⟨h03, h14, h25⟩ =
        ⟨pb03, pb14, pb25⟩ := by
      rw [hpb03, hpb14, hpb25]; rfl
    have e8 : Quad.addSel false true true false ⟨pb03, pb14, pb25⟩ ⟨h03, h14, h25⟩ =
        ⟨pc03, pc14, pc25⟩ := by
      rw [hpc03, hpc14, hpc25]; rfl
    -- FD_R43X6_QUAD_FOLD_SIGNED( _tb, _tb )
    step_pattern using runBodyFrom_foldSignedRun
    have eF3 := _hs
    -- FD_R43X6_QUAD_PERMUTE( _ta, 0,2,2,0, _tb ); FD_R43X6_QUAD_PERMUTE( _tb, 3,1,3,1, _tb )
    step_pure with ma03
    step_pure with ma14
    step_pure with ma25
    step_pure with mb03
    step_pure with mb14
    step_pure with mb25
    -- FD_R43X6_QUAD_MUL_FAST( P3, _ta, _tb )
    iterate 3 step_pure
    step_call using fd_r43x6_quad_mul_fast.call_eq
    step_load with k03
    step_load with k14
    step_load with k25
    iterate 3 step_pure
    have e9 : quadMul (Quad.perm4 0 2 2 0 ⟨s03, s14, s25⟩) (Quad.perm4 3 1 3 1 ⟨s03, s14, s25⟩) =
        ⟨k03, k14, k25⟩ := by
      rw [hk03, hk14, hk25, hma03, hma14, hma25, hmb03, hmb14, hmb25]; rfl
    finish_block
    -- FD_R43X6_QUAD_FOLD_UNSIGNED( P3, _ta )
    block_init
    step_pattern using runBodyFrom_foldUnsignedStoreRun
    have eU2 := _hu
    finish_block
    subst hS
    erase_frame
    have e0a : S₀.mem.readQuad a = ⟨x03, x14, x25⟩ := by rw [hx03, hx14, hx25]; rfl
    have e0b : S₀.mem.readQuad b = ⟨y03, y14, y25⟩ := by rw [hy03, hy14, hy25]; rfl
    have e1 : Quad.perm4 1 0 2 3 ⟨x03, x14, x25⟩ = ⟨ta03, ta14, ta25⟩ := by
      rw [hta03, hta14, hta25]; rfl
    have e1' : Quad.perm4 1 0 2 3 ⟨y03, y14, y25⟩ = ⟨tb03, tb14, tb25⟩ := by
      rw [htb03, htb14, htb25]; rfl
    have e2 : Quad.subSel true false false false ⟨ta03, ta14, ta25⟩ ⟨x03, x14, x25⟩ =
        ⟨tc03, tc14, tc25⟩ := by
      rw [htc03, htc14, htc25]; rfl
    have e2' : Quad.subSel true false false false ⟨tb03, tb14, tb25⟩ ⟨y03, y14, y25⟩ =
        ⟨td03, td14, td25⟩ := by
      rw [htd03, htd14, htd25]; rfl
    have e3 : Quad.addSel false true true false ⟨tc03, tc14, tc25⟩ ⟨x03, x14, x25⟩ =
        ⟨te03, te14, te25⟩ := by
      rw [hte03, hte14, hte25]; rfl
    have e3' : Quad.addSel false true false false ⟨td03, td14, td25⟩ ⟨y03, y14, y25⟩ =
        ⟨tf03, tf14, tf25⟩ := by
      rw [htf03, htf14, htf25]; rfl
    simp only [fd_ed25519_point_add_with_opts.spec, ne_eq, geAdd,
      Quad.permute_1023, Quad.laneSubFast_1000, Quad.laneAddFast_0110, Quad.laneAddFast_0100,
      Quad.permute_1032, Quad.laneSubFast_1001, Quad.permute_0220, Quad.permute_3131,
      Quad.foldSigned_eq, Quad.foldUnsigned_eq]
    rw [e0a, e0b, e1, e1', e2, e2', e3, e3', e4, eU1, e5, e6, e7, e8, eF3, e9, eU2]
    subst_vars
    rfl
  · -- `b_is_precomputed`: FD_R43X6_GE_ADD_TABLE_ALT
    have hpre : pre ≠ 0 := hbr
    block_init
    step_load with b03
    step_pure
    step_load with b14
    step_pure
    step_load with b25
    -- FD_R43X6_QUAD_PERMUTE( _tb, 1,0,2,3, P1 )
    step_load with x03
    step_pure with ta03
    step_pure
    step_load with x14
    step_pure with ta14
    step_pure
    step_load with x25
    step_pure with ta25
    -- FD_R43X6_QUAD_LANE_SUB_FAST( _tb, _tb, 1,0,0,0, _tb, P1 )
    step_pure [wrapZipWith]
    step_pure [expandOfFn]
    step_pure with tb03
    step_pure [wrapZipWith]
    step_pure [expandOfFn]
    step_pure with tb14
    step_pure [wrapZipWith]
    step_pure [expandOfFn]
    step_pure with tb25
    -- FD_R43X6_QUAD_LANE_ADD_FAST( _tb, _tb, 0,1,1,0, _tb, P1 )
    step_pure [wrapZipWith]
    step_pure with tc03
    step_pure [wrapZipWith]
    step_pure with tc14
    step_pure [wrapZipWith]
    step_pure with tc25
    -- FD_R43X6_QUAD_FOLD_SIGNED( _tb, _tb )
    step_pattern using runBodyFrom_foldSignedRun
    have eF1 := _hs
    -- FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _tb )
    iterate 3 step_pure
    step_call using fd_r43x6_quad_mul_fast.call_eq
    step_load with g03
    step_load with g14
    step_load with g25
    iterate 3 step_pure
    have e4 : quadMul ⟨b03, b14, b25⟩ (Quad.foldSignedC ⟨tc03, tc14, tc25⟩) = ⟨g03, g14, g25⟩ := by
      rw [eF1, hg03, hg14, hg25]; rfl
    -- FD_R43X6_QUAD_FOLD_UNSIGNED( _ta, _ta )
    step_pattern using runBodyFrom_foldUnsignedRun
    have eU1 := _hu
    -- FD_R43X6_QUAD_PERMUTE( _tb, 1,0,3,2, _ta )
    step_pure with pa03
    step_pure with pa14
    step_pure with pa25
    have e5 : Quad.perm4 1 0 3 2 ⟨u03, u14, u25⟩ = ⟨pa03, pa14, pa25⟩ := by
      rw [hpa03, hpa14, hpa25]; rfl
    -- the folded lanes are below `2^44`: the code's `sub nsw` and `add nsw` do not overflow
    obtain ⟨hu03, hu14, hu25⟩ := Quad.foldUnsignedC_lt eU1
    have hpa03' := wwl_perm4_lt_of_eq hu03 (v := pa03) (congrArg Quad.P03 e5)
    have hpa14' := wwl_perm4_lt_of_eq hu14 (v := pa14) (congrArg Quad.P14 e5)
    have hpa25' := wwl_perm4_lt_of_eq hu25 (v := pa25) (congrArg Quad.P25 e5)
    -- FD_R43X6_QUAD_LANE_SUB_FAST( _tb, _tb, 1,0,0,1, _tb, _ta )
    have hs03 := sub_lt_ok hpa03' hu03
    have ho03 := sub_add_lt_ok1001 hpa03' hu03 8796093022189#64 8796093022207#64
      (by decide) (by decide)
    step_pure [wrapZipWith]
    step_pure [expandOfFn]
    step_pure [ho03.1, ho03.2.1, ho03.2.2.1, ho03.2.2.2] with pb03
    have hs14 := sub_lt_ok hpa14' hu14
    have ho14 := sub_add_lt_ok1001 hpa14' hu14 8796093022207#64 8796093022207#64
      (by decide) (by decide)
    step_pure [wrapZipWith]
    step_pure [expandOfFn]
    step_pure [ho14.1, ho14.2.1, ho14.2.2.1, ho14.2.2.2] with pb14
    have hs25 := sub_lt_ok hpa25' hu25
    have ho25 := sub_add_lt_ok1001 hpa25' hu25 8796093022207#64 1099511627775#64
      (by decide) (by decide)
    step_pure [wrapZipWith]
    step_pure [expandOfFn]
    step_pure [ho25.1, ho25.2.1, ho25.2.2.1, ho25.2.2.2] with pb25
    have e6 : Quad.subSel true false false true ⟨pa03, pa14, pa25⟩ ⟨u03, u14, u25⟩ =
        ⟨pb03, pb14, pb25⟩ := by
      rw [hpb03, hpb14, hpb25]; rfl
    -- FD_R43X6_QUAD_LANE_ADD_FAST( _tb, _tb, 0,1,1,0, _tb, _ta )
    step_pure [wrapZipWith]
    step_pure with pc03
    have hc14 := sub_sel_add_ok hpa14' hu14 hu14 (by decide) (by decide) (congrArg Quad.P14 e6)
    step_pure [wrapZipWith]
    step_pure with pc14
    have hc25 := sub_sel_add_ok hpa25' hu25 hu25 (by decide) (by decide) (congrArg Quad.P25 e6)
    step_pure [wrapZipWith]
    step_pure with pc25
    have e7 : Quad.addSel false true true false ⟨pb03, pb14, pb25⟩ ⟨u03, u14, u25⟩ =
        ⟨pc03, pc14, pc25⟩ := by
      rw [hpc03, hpc14, hpc25]; rfl
    -- FD_R43X6_QUAD_FOLD_SIGNED( _tb, _tb )
    step_pattern using runBodyFrom_foldSignedRun'
    have eF2 := _hs
    -- FD_R43X6_QUAD_PERMUTE( _ta, 0,2,2,0, _tb ); FD_R43X6_QUAD_PERMUTE( _tb, 3,1,3,1, _tb )
    step_pure with ma03
    step_pure with ma14
    step_pure with ma25
    step_pure with mb03
    step_pure with mb14
    step_pure with mb25
    -- FD_R43X6_QUAD_MUL_FAST( P3, _ta, _tb )
    iterate 3 step_pure
    step_call using fd_r43x6_quad_mul_fast.call_eq
    step_load with h03
    step_load with h14
    step_load with h25
    iterate 3 step_pure
    have e8 : quadMul (Quad.perm4 0 2 2 0 ⟨s03, s14, s25⟩) (Quad.perm4 3 1 3 1 ⟨s03, s14, s25⟩) =
        ⟨h03, h14, h25⟩ := by
      rw [hh03, hh14, hh25, hma03, hma14, hma25, hmb03, hmb14, hmb25]; rfl
    finish_block
    -- FD_R43X6_QUAD_FOLD_UNSIGNED( P3, _ta )
    block_init
    step_pattern using runBodyFrom_foldUnsignedStoreRun
    have eU2 := _hu
    finish_block
    subst hS
    erase_frame
    have e0a : S₀.mem.readQuad a = ⟨x03, x14, x25⟩ := by rw [hx03, hx14, hx25]; rfl
    have e0b : S₀.mem.readQuad b = ⟨b03, b14, b25⟩ := by rw [hb03, hb14, hb25]; rfl
    have e1 : Quad.perm4 1 0 2 3 ⟨x03, x14, x25⟩ = ⟨ta03, ta14, ta25⟩ := by
      rw [hta03, hta14, hta25]; rfl
    have e2 : Quad.subSel true false false false ⟨ta03, ta14, ta25⟩ ⟨x03, x14, x25⟩ =
        ⟨tb03, tb14, tb25⟩ := by
      rw [htb03, htb14, htb25]; rfl
    have e3 : Quad.addSel false true true false ⟨tb03, tb14, tb25⟩ ⟨x03, x14, x25⟩ =
        ⟨tc03, tc14, tc25⟩ := by
      rw [htc03, htc14, htc25]; rfl
    simp only [fd_ed25519_point_add_with_opts.spec, ne_eq, hpre, not_false_eq_true, ↓reduceIte,
      geAddTable, Quad.permute_1023, Quad.laneSubFast_1000, Quad.laneAddFast_0110,
      Quad.permute_1032, Quad.laneSubFast_1001, Quad.permute_0220, Quad.permute_3131,
      Quad.foldSigned_eq, Quad.foldUnsigned_eq]
    rw [e0a, e0b, e1, e2, e3, e4, eU1, e5, e6, e7, Quad.foldSignedC_eq', eF2, e8, eU2]
    subst_vars
    rfl

end Proof

end LeanMLIR.RIR.Firedancer.Avx512
