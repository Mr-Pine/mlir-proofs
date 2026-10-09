module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.QuadOps
public import Firedancer.Avx512.Mlir.fd_ed25519_point_add_with_opts

namespace MLIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `A + B`: `FD_R43X6_GE_ADD_TABLE_ALT` when `b_is_precomputed`, else `FD_R43X6_GE_ADD`;
`b_Z_is_one` and `skip_last_mul` are unused. -/
def fd_ed25519_point_add_with_opts.spec (A B : Quad) (b_is_precomputed : BitVec 32) : Quad :=
  if b_is_precomputed ≠ 0 then geAddTable quadMul A B else geAdd quadMul A B

end

/-! ## Proof -/

section Proof

namespace fd_ed25519_point_add_with_opts

/-- The entry block's constants the branches read: `_1112d`, the folds' shifts, masks and biases,
the lane subtractions' `p` limbs, and `19` for the folds' top carries. -/
abbrev Consts (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := quad1112d.P25, %1 := quad1112d.P14, %2 := quad1112d.P03, %3 := m4340,
    %4 := Vector.replicate 8 1048576#64, %5 := bias03, %6 := Vector.replicate 8 8796093022207#64,
    %8 := s4340, %9 := Vector.replicate 8 43#64,
    %10 := Vector.replicate 8 18446744073708503040#64, %11 := negBias03,
    %33 := selPoison 1 0 0 0 quadP.P03, %42 := selPoison 1 0 0 0 quadP.P14,
    %51 := selPoison 1 0 0 0 quadP.P25, %60 := k19Lanes, %69 := selPoison 1 0 0 1 quadP.P03,
    %78 := selPoison 1 0 0 1 quadP.P14, %87 := selPoison 1 0 0 1 quadP.P25]

/-- `^bb2`, `FD_R43X6_GE_ADD( P3, A, B )`, then `^bb3`: `r` gets `geAdd` of the points at `a` and
`b`, through the temporaries `z0 … z8` (block ids from `n` on). -/
theorem geAdd_run (r a b : Pointer) (pre : BitVec 32) (z0 z1 z2 z3 z4 z5 z6 z7 z8 : Pointer)
    (n : Nat) (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (hArgs : E.args = (args (.value r) (.value a) (.value b) (.value pre)).get)
    (hC : Consts E)
    (hZ :
      E ⊨ [%94 := z0, %95 := z1, %96 := z2, %97 := z3, %98 := z4, %99 := z5, %100 := z6,
        %101 := z7, %102 := z8])
    (hwf : S.WF) (hr : S.mem.QuadFit r) (ha : S.mem.QuadFit a) (hb : S.mem.QuadFit b)
    (hz :
      Fits S.mem z0 512 ∧ Fits S.mem z1 512 ∧ Fits S.mem z2 512 ∧ Fits S.mem z3 512 ∧
        Fits S.mem z4 512 ∧ Fits S.mem z5 512 ∧ Fits S.mem z6 512 ∧ Fits S.mem z7 512 ∧
        Fits S.mem z8 512)
    (hne :
      z0.id ≠ z1.id ∧ z0.id ≠ z2.id ∧ z1.id ≠ z2.id ∧ z3.id ≠ z4.id ∧ z3.id ≠ z5.id ∧
        z4.id ≠ z5.id ∧ z6.id ≠ z7.id ∧ z6.id ≠ z8.id ∧ z7.id ≠ z8.id)
    (hn :
      n ≤ z0.id.id ∧ n ≤ z1.id.id ∧ n ≤ z2.id.id ∧ n ≤ z3.id.id ∧ n ≤ z4.id.id ∧
        n ≤ z5.id.id ∧ n ≤ z6.id.id ∧ n ≤ z7.id.id ∧ n ≤ z8.id.id)
    (hK :
      ∀ S' : GlobalState, S'.alloc = S.alloc →
        S'.mem.eraseFrom n =
          (S.mem.eraseFrom n).storeQuad r (geAdd quadMul (S.mem.readQuad a) (S.mem.readQuad b)) →
        g (.cons (.value r) .nil, S') = K) :
    (fd_ed25519_point_add_with_opts.runFrom E 2 S >>= g) = K := by
  obtain ⟨hz0, hz1, hz2, hz3, hz4, hz5, hz6, hz7, hz8⟩ := hz
  obtain ⟨h01, h02, h12, h34, h35, h45, h67, h68, h78⟩ := hne
  obtain ⟨hn0, hn1, hn2, hn3, hn4, hn5, hn6, hn7, hn8⟩ := hn
  generalize hA : S.mem.readQuad a = A at hK
  generalize hB : S.mem.readQuad b = B at hK
  block_init
  -- FD_R43X6_QUAD_PERMUTE( _ta, 1,0,2,3, P1 ); FD_R43X6_QUAD_PERMUTE( _tb, 1,0,2,3, P2 )
  step_pattern using runBodyFrom_permuteLoadRun 1 0 2 3
  have eA : A = ⟨l03, l14, l25⟩ := by rw [← hA]; simpa only [hS] using _hx
  have e1 := _hp
  step_pattern using runBodyFrom_permuteLoadRun 1 0 2 3
  have eB : B = ⟨l03, l14, l25⟩ := by rw [← hB]; simpa only [hS] using _hx
  have e1' := _hp
  -- FD_R43X6_QUAD_LANE_SUB_FAST( _ta, _ta, 1,0,0,0, _ta, P1 ); the same for `_tb`, `P2`
  step_pattern using runBodyFrom_laneSubRun 1 0 0 0
  have e2 := _hl
  step_pattern using runBodyFrom_laneSubRun 1 0 0 0
  have e2' := _hl
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _ta, _ta, 0,1,1,0, _ta, P1 ); `( _tb, _tb, 0,1,0,0, _tb, P2 )`
  step_pattern using runBodyFrom_laneAddRun 0 1 1 0
  have e3 := _hl
  step_pattern using runBodyFrom_laneAddRun 0 1 0 0
  have e3' := _hl
  -- FD_R43X6_QUAD_FOLD_SIGNED( _ta, _ta ); FD_R43X6_QUAD_FOLD_SIGNED( _tb, _tb )
  step_pattern using runBodyFrom_foldSignedRun
  have eF1 := _hs
  step_pattern using runBodyFrom_foldSignedRun
  have eF2 := _hs
  -- FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _1112d )
  step_pattern using runBodyFrom_mulRun
  have e4 := _hm
  -- FD_R43X6_QUAD_FOLD_UNSIGNED( _ta, _ta )
  step_pattern using runBodyFrom_foldUnsignedRun
  have eU1 := _hu
  -- FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _tb )
  step_pattern using runBodyFrom_mulRun
  have e5 := _hm
  -- FD_R43X6_QUAD_PERMUTE( _tb, 1,0,3,2, _ta )
  step_pattern using runBodyFrom_permuteRun 1 0 3 2
  have e6 := _hp
  -- FD_R43X6_QUAD_LANE_SUB_FAST( _tb, _tb, 1,0,0,1, _tb, _ta )
  step_pattern using runBodyFrom_laneSubRun 1 0 0 1
  have e7 := _hl
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _tb, _tb, 0,1,1,0, _tb, _ta )
  step_pattern using runBodyFrom_laneAddRun 0 1 1 0
  have e8 := _hl
  -- FD_R43X6_QUAD_FOLD_SIGNED( _tb, _tb )
  step_pattern using runBodyFrom_foldSignedRun
  have eF3 := _hs
  -- FD_R43X6_QUAD_PERMUTE( _ta, 0,2,2,0, _tb ); FD_R43X6_QUAD_PERMUTE( _tb, 3,1,3,1, _tb )
  step_pattern using runBodyFrom_permuteRun 0 2 2 0
  have e9 := _hp
  step_pattern using runBodyFrom_permuteRun 3 1 3 1
  have e10 := _hp
  -- FD_R43X6_QUAD_MUL_FAST( P3, _ta, _tb )
  step_pattern using runBodyFrom_mulRun
  have e11 := _hm
  finish_block
  -- FD_R43X6_QUAD_FOLD_UNSIGNED( P3, _ta )
  block_init
  step_pattern using runBodyFrom_foldUnsignedStoreRun
  have eU2 := _hu
  finish_block
  apply hK
  · rw [hS]
  · have e4' : quadMul _ quad1112d = _ := e4
    rw [hS]
    simp only [MemoryState.eraseFrom_storeAt, MemoryState.storeVec,
      MemoryState.storeAt_eraseFrom_of_le hn0, MemoryState.storeAt_eraseFrom_of_le hn1,
      MemoryState.storeAt_eraseFrom_of_le hn2, MemoryState.storeAt_eraseFrom_of_le hn3,
      MemoryState.storeAt_eraseFrom_of_le hn4, MemoryState.storeAt_eraseFrom_of_le hn5,
      MemoryState.storeAt_eraseFrom_of_le hn6, MemoryState.storeAt_eraseFrom_of_le hn7,
      MemoryState.storeAt_eraseFrom_of_le hn8, geAdd, Quad.foldSigned_eq, Quad.foldUnsigned_eq]
    rw [eA, eB, e1, e1', e2, e2', e3, e3', eF1, eF2, e4', eU1, e5, e6, e7, e8, eF3, e9, e10, e11,
      eU2]
    subst_vars
    rfl

/-- `^bb1`, `FD_R43X6_GE_ADD_TABLE_ALT( P3, A, T )`, then `^bb3`: `r` gets `geAddTable` of the
points at `a` and `b`, through the temporaries `z0 … z5` (block ids from `n` on). -/
theorem geAddTable_run (r a b : Pointer) (pre : BitVec 32) (z0 z1 z2 z3 z4 z5 : Pointer)
    (n : Nat) (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (hArgs : E.args = (args (.value r) (.value a) (.value b) (.value pre)).get)
    (hC : Consts E)
    (hZ : E ⊨ [%88 := z0, %89 := z1, %90 := z2, %91 := z3, %92 := z4, %93 := z5])
    (hwf : S.WF) (hr : S.mem.QuadFit r) (ha : S.mem.QuadFit a) (hb : S.mem.QuadFit b)
    (hz :
      Fits S.mem z0 512 ∧ Fits S.mem z1 512 ∧ Fits S.mem z2 512 ∧ Fits S.mem z3 512 ∧
        Fits S.mem z4 512 ∧ Fits S.mem z5 512)
    (hne :
      z0.id ≠ z1.id ∧ z0.id ≠ z2.id ∧ z1.id ≠ z2.id ∧ z3.id ≠ z4.id ∧ z3.id ≠ z5.id ∧
        z4.id ≠ z5.id)
    (hn :
      n ≤ z0.id.id ∧ n ≤ z1.id.id ∧ n ≤ z2.id.id ∧ n ≤ z3.id.id ∧ n ≤ z4.id.id ∧
        n ≤ z5.id.id)
    (hK :
      ∀ S' : GlobalState, S'.alloc = S.alloc →
        S'.mem.eraseFrom n =
          (S.mem.eraseFrom n).storeQuad r
            (geAddTable quadMul (S.mem.readQuad a) (S.mem.readQuad b)) →
        g (.cons (.value r) .nil, S') = K) :
    (fd_ed25519_point_add_with_opts.runFrom E 1 S >>= g) = K := by
  obtain ⟨hz0, hz1, hz2, hz3, hz4, hz5⟩ := hz
  obtain ⟨h01, h02, h12, h34, h35, h45⟩ := hne
  obtain ⟨hn0, hn1, hn2, hn3, hn4, hn5⟩ := hn
  generalize hA : S.mem.readQuad a = A at hK
  generalize hB : S.mem.readQuad b = B at hK
  block_init
  step_pattern using runBodyFrom_quadLoadRun
  have eB : B = ⟨l03, l14, l25⟩ := by rw [← hB]; simpa only [hS] using _hx
  -- FD_R43X6_QUAD_PERMUTE( _tb, 1,0,2,3, P1 )
  step_pattern using runBodyFrom_permuteLoadRun 1 0 2 3
  have eA : A = ⟨l03, l14, l25⟩ := by rw [← hA]; simpa only [hS] using _hx
  have e1 := _hp
  -- FD_R43X6_QUAD_LANE_SUB_FAST( _tb, _tb, 1,0,0,0, _tb, P1 )
  step_pattern using runBodyFrom_laneSubRun 1 0 0 0
  have e2 := _hl
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _tb, _tb, 0,1,1,0, _tb, P1 )
  step_pattern using runBodyFrom_laneAddRun 0 1 1 0
  have e3 := _hl
  -- FD_R43X6_QUAD_FOLD_SIGNED( _tb, _tb )
  step_pattern using runBodyFrom_foldSignedRun
  have eF1 := _hs
  -- FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _tb )
  step_pattern using runBodyFrom_mulRun
  have e4 := _hm
  -- FD_R43X6_QUAD_FOLD_UNSIGNED( _ta, _ta ); its lanes are below `2^44`
  step_pattern using runBodyFrom_foldUnsignedRun
  have eU1 := _hu
  obtain ⟨hu03, hu14, hu25⟩ := Quad.foldUnsignedC_lt eU1
  -- FD_R43X6_QUAD_PERMUTE( _tb, 1,0,3,2, _ta ), lanes below `2^44` too
  step_pattern using runBodyFrom_permuteRun 1 0 3 2
  have e5 := _hp
  have e5' := (Quad.permute_1032 _).symm.trans e5
  have hpa03 := wwl_perm4_lt_of_eq hu03 (congrArg Quad.P03 e5')
  have hpa14 := wwl_perm4_lt_of_eq hu14 (congrArg Quad.P14 e5')
  have hpa25 := wwl_perm4_lt_of_eq hu25 (congrArg Quad.P25 e5')
  -- FD_R43X6_QUAD_LANE_SUB_FAST( _tb, _tb, 1,0,0,1, _tb, _ta ): the code's `nsw` holds
  step_pattern using runBodyFrom_laneSubRun 1 0 0 1 (hs03 := fun _ => sub_lt_ok hpa03 hu03)
    (hs14 := fun _ => sub_lt_ok hpa14 hu14) (hs25 := fun _ => sub_lt_ok hpa25 hu25)
    (ha03 := fun _ => sub_add_lt_ok hpa03 hu03 quadP_lt.1)
    (ha14 := fun _ => sub_add_lt_ok hpa14 hu14 quadP_lt.2.1)
    (ha25 := fun _ => sub_add_lt_ok hpa25 hu25 quadP_lt.2.2)
  have e6 := _hl
  have e6' := (Quad.laneSubFast_1001 _ _).symm.trans e6
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _tb, _tb, 0,1,1,0, _tb, _ta ): the code's `nsw` holds
  step_pattern using runBodyFrom_laneAddRun 0 1 1 0
    (ho14 := fun _ => sub_sel_add_ok hpa14 hu14 hu14 (by decide) (by decide)
      (congrArg Quad.P14 e6'))
    (ho25 := fun _ => sub_sel_add_ok hpa25 hu25 hu25 (by decide) (by decide)
      (congrArg Quad.P25 e6'))
  have e7 := _hl
  -- FD_R43X6_QUAD_FOLD_SIGNED( _tb, _tb )
  step_pattern using runBodyFrom_foldSignedRun'
  have eF2 := _hs
  -- FD_R43X6_QUAD_PERMUTE( _ta, 0,2,2,0, _tb ); FD_R43X6_QUAD_PERMUTE( _tb, 3,1,3,1, _tb )
  step_pattern using runBodyFrom_permuteRun 0 2 2 0
  have e8 := _hp
  step_pattern using runBodyFrom_permuteRun 3 1 3 1
  have e9 := _hp
  -- FD_R43X6_QUAD_MUL_FAST( P3, _ta, _tb )
  step_pattern using runBodyFrom_mulRun
  have e10 := _hm
  finish_block
  -- FD_R43X6_QUAD_FOLD_UNSIGNED( P3, _ta )
  block_init
  step_pattern using runBodyFrom_foldUnsignedStoreRun
  have eU2 := _hu
  finish_block
  apply hK
  · rw [hS]
  · rw [hS]
    simp only [MemoryState.eraseFrom_storeAt, MemoryState.storeVec,
      MemoryState.storeAt_eraseFrom_of_le hn0, MemoryState.storeAt_eraseFrom_of_le hn1,
      MemoryState.storeAt_eraseFrom_of_le hn2, MemoryState.storeAt_eraseFrom_of_le hn3,
      MemoryState.storeAt_eraseFrom_of_le hn4, MemoryState.storeAt_eraseFrom_of_le hn5,
      geAddTable, Quad.foldSigned_eq, Quad.foldUnsigned_eq]
    rw [eA, eB, e1, e2, e3, eF1, e4, eU1, e5, e6, e7, Quad.foldSignedC_eq', eF2, e8, e9, e10, eU2]
    subst_vars
    rfl

end fd_ed25519_point_add_with_opts

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
  have hra : S.mem.readQuad a = S₀.mem.readQuad a := by rw [hS]
  have hrb : S.mem.readQuad b = S₀.mem.readQuad b := by rw [hS]
  block_init
  iterate 25 step_pure
  iterate 7 step_pattern using runBodyFrom_vecRun inline
  iterate 15 step_alloca
  step_pure
  have hC : fd_ed25519_point_add_with_opts.Consts E := by
    dsimp only [fd_ed25519_point_add_with_opts.Consts]
    env_reads
  finish_block
  · -- `!b_is_precomputed`: FD_R43X6_GE_ADD
    subst hbr
    refine fd_ed25519_point_add_with_opts.geAdd_run r a b 0 v94 v95 v96 v97 v98 v99 v100 v101
      v102 S₀.alloc.nextFreeBlock S E _ _ hArgs hC ?_ hwf hr ha hb ?_ ?_ ?_ ?_
    · env_reads
    · exact ⟨hv94_fits, hv95_fits, hv96_fits, hv97_fits, hv98_fits, hv99_fits, hv100_fits,
        hv101_fits, hv102_fits⟩
    · refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> mem_fact
    · refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> slot_bound
    · intro S' h1 h2
      simp only [h1, h2, hra, hrb, fd_ed25519_point_add_with_opts.spec, ne_eq]
      subst hS
      erase_frame
      rw [ite_eq_right (by decide)]
      rfl
  · -- `b_is_precomputed`: FD_R43X6_GE_ADD_TABLE_ALT
    have hpre : pre ≠ 0 := hbr
    refine fd_ed25519_point_add_with_opts.geAddTable_run r a b pre v88 v89 v90 v91 v92 v93
      S₀.alloc.nextFreeBlock S E _ _ hArgs hC ?_ hwf hr ha hb ?_ ?_ ?_ ?_
    · env_reads
    · exact ⟨hv88_fits, hv89_fits, hv90_fits, hv91_fits, hv92_fits, hv93_fits⟩
    · refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;> mem_fact
    · refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;> slot_bound
    · intro S' h1 h2
      simp only [h1, h2, hra, hrb, fd_ed25519_point_add_with_opts.spec, ne_eq, hpre,
        not_false_eq_true, ↓reduceIte]
      subst hS
      erase_frame
      rfl

end Proof

end MLIR.Firedancer.Avx512
