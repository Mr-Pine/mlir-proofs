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
  E ⊨ [%2462 := quad1112d.P25, %2463 := quad1112d.P14, %2464 := quad1112d.P03, %2465 := m4340,
    %2466 := Vector.replicate 8 1048576#64, %2467 := bias03, %2468 :=
    Vector.replicate 8 8796093022207#64, %2470 := s4340, %2471 := Vector.replicate 8 43#64, %2472 :=
    Vector.replicate 8 18446744073708503040#64, %2473 := negBias03, %2495 :=
    selPoison 1 0 0 0 quadP.P03, %2503 := selPoison 1 0 0 0 quadP.P14, %2511 :=
    selPoison 1 0 0 0 quadP.P25, %2519 := k19Lanes, %2527 := selPoison 1 0 0 1 quadP.P03, %2535 :=
    selPoison 1 0 0 1 quadP.P14, %2543 := selPoison 1 0 0 1 quadP.P25]

/-- `^bb2`, `FD_R43X6_GE_ADD( P3, A, B )`, then `^bb3`: `r` gets `geAdd` of the points at `a` and
`b`, through the temporaries `z0 … z8` (block ids from `n` on). -/
theorem geAdd_run (r a b : Pointer) (pre : BitVec 32) (z0 z1 z2 z3 z4 z5 z6 z7 z8 : Pointer)
    (n : Nat) (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β)
    (K : PoisonOr β) (hArgs : E.args = (args (.value r) (.value a) (.value b) (.value pre)).get)
    (hC : Consts E)
    (hZ :
      E ⊨ [%2550 := z0, %2551 := z1, %2552 := z2, %2553 := z3, %2554 := z4, %2555 := z5, %2556 :=
        z6, %2557 := z7, %2558 := z8])
    (hwf : S.WF) (hr : S.mem.QuadRoom r) (ha : S.mem.QuadFit a) (hb : S.mem.QuadFit b)
    (hz :
      InBounds S.mem z0 512 ∧
        InBounds S.mem z1 512 ∧
        InBounds S.mem z2 512 ∧
        InBounds S.mem z3 512 ∧
        InBounds S.mem z4 512 ∧
        InBounds S.mem z5 512 ∧
        InBounds S.mem z6 512 ∧ InBounds S.mem z7 512 ∧ InBounds S.mem z8 512)
    (hne :
      z0.id ≠ z1.id ∧
        z0.id ≠ z2.id ∧
        z1.id ≠ z2.id ∧
        z3.id ≠ z4.id ∧
        z3.id ≠ z5.id ∧ z4.id ≠ z5.id ∧ z6.id ≠ z7.id ∧ z6.id ≠ z8.id ∧ z7.id ≠ z8.id)
    (hrz :
      r.id ≠ z0.id ∧
        r.id ≠ z1.id ∧
        r.id ≠ z2.id ∧
        r.id ≠ z3.id ∧ r.id ≠ z4.id ∧ r.id ≠ z5.id ∧ r.id ≠ z6.id ∧ r.id ≠ z7.id ∧ r.id ≠ z8.id)
    (hn :
      n ≤ z0.id.id ∧
        n ≤ z1.id.id ∧
        n ≤ z2.id.id ∧
        n ≤ z3.id.id ∧ n ≤ z4.id.id ∧ n ≤ z5.id.id ∧ n ≤ z6.id.id ∧ n ≤ z7.id.id ∧ n ≤ z8.id.id)
    (hK :
      ∀ S' : GlobalState,
        S'.alloc = S.alloc →
          S'.mem.eraseFrom n =
            (S.mem.eraseFrom n).storeQuad r (geAdd quadMul (S.mem.readQuad a) (S.mem.readQuad b)) →
          g (.cons (.value r) .nil, S') = K) :
    (fd_ed25519_point_add_with_opts.runFrom E 2 S >>= g) = K := by
  obtain ⟨hz0, hz1, hz2, hz3, hz4, hz5, hz6, hz7, hz8⟩ := hz
  obtain ⟨h01, h02, h12, h34, h35, h45, h67, h68, h78⟩ := hne
  obtain ⟨hn0, hn1, hn2, hn3, hn4, hn5, hn6, hn7, hn8⟩ := hn
  obtain ⟨hr0, hr1, hr2, hr3, hr4, hr5, hr6, hr7, hr8⟩ := hrz
  generalize hA : S.mem.readQuad a = A at hK
  generalize hB : S.mem.readQuad b = B at hK
  block_init
  -- FD_R43X6_QUAD_PERMUTE( _ta, 1,0,2,3, P1 ); FD_R43X6_QUAD_PERMUTE( _tb, 1,0,2,3, P2 ), only
  -- the lanes the subtractions read
  step_pattern using runBodyFrom_permuteLoadRun_poison 1 0 2 3 1 0 0 0
  have eA : A = ⟨l03, l14, l25⟩ := by
    rw [← hA]; simpa only [hS] using _hx
  step_pattern using runBodyFrom_permuteLoadRun_poison 1 0 2 3 1 0 0 0
  have eB : B = ⟨l03, l14, l25⟩ := by
    rw [← hB]; simpa only [hS] using _hx
  clear ha hb
  -- FD_R43X6_QUAD_LANE_SUB_FAST( _ta, _ta, 1,0,0,0, _ta, P1 ); the same for `_tb`, `P2`
  step_pattern using runBodyFrom_laneSubPermRun 1 0 2 3 1 0 0 0
  have e2 := _hl
  step_pattern using runBodyFrom_laneSubPermRun 1 0 2 3 1 0 0 0
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
  -- FD_R43X6_QUAD_PERMUTE( _tb, 1,0,3,2, _ta ), FD_R43X6_QUAD_LANE_SUB_FAST( _tb, _tb, 1,0,0,1,
  -- _tb, _ta ) and FD_R43X6_QUAD_LANE_ADD_FAST( _tb, _tb, 0,1,1,0, _tb, _ta ), fused
  step_pattern using runBodyFrom_permSubAddRun
  have e6 := _hl
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
      MemoryState.eraseFrom_lifetimeStart, MemoryState.eraseFrom_lifetimeEnd,
      MemoryState.lifetimeStart_eraseFrom_of_le hn0, MemoryState.lifetimeStart_eraseFrom_of_le hn1,
      MemoryState.lifetimeStart_eraseFrom_of_le hn2, MemoryState.lifetimeStart_eraseFrom_of_le hn3,
      MemoryState.lifetimeStart_eraseFrom_of_le hn4, MemoryState.lifetimeStart_eraseFrom_of_le hn5,
      MemoryState.lifetimeEnd_eraseFrom_of_le hn0, MemoryState.lifetimeEnd_eraseFrom_of_le hn1,
      MemoryState.lifetimeEnd_eraseFrom_of_le hn2, MemoryState.lifetimeEnd_eraseFrom_of_le hn3,
      MemoryState.lifetimeEnd_eraseFrom_of_le hn4, MemoryState.lifetimeEnd_eraseFrom_of_le hn5,
      MemoryState.storeAt_eraseFrom_of_le hn0, MemoryState.storeAt_eraseFrom_of_le hn1,
      MemoryState.storeAt_eraseFrom_of_le hn2, MemoryState.storeAt_eraseFrom_of_le hn3,
      MemoryState.storeAt_eraseFrom_of_le hn4, MemoryState.storeAt_eraseFrom_of_le hn5,
      MemoryState.lifetimeStart_eraseFrom_of_le hn6, MemoryState.lifetimeStart_eraseFrom_of_le hn7,
      MemoryState.lifetimeStart_eraseFrom_of_le hn8, MemoryState.lifetimeEnd_eraseFrom_of_le hn6,
      MemoryState.lifetimeEnd_eraseFrom_of_le hn7, MemoryState.lifetimeEnd_eraseFrom_of_le hn8,
      MemoryState.storeAt_eraseFrom_of_le hn6, MemoryState.storeAt_eraseFrom_of_le hn7,
      MemoryState.storeAt_eraseFrom_of_le hn8, geAdd, Quad.foldSigned_eq, Quad.foldUnsigned_eq]
    rw [eA, eB, e2, e2', e3, e3', eF1, eF2, e4', eU1, e5, e6, eF3, e9, e10, e11, eU2]
    subst_vars
    rfl

/-- `^bb1`, `FD_R43X6_GE_ADD_TABLE_ALT( P3, A, T )`, then `^bb3`: `r` gets `geAddTable` of the
points at `a` and `b`, through the temporaries `z0 … z5` (block ids from `n` on). -/
theorem geAddTable_run (r a b : Pointer) (pre : BitVec 32) (z0 z1 z2 z3 z4 z5 : Pointer) (n : Nat)
    (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs : E.args = (args (.value r) (.value a) (.value b) (.value pre)).get) (hC : Consts E)
    (hZ : E ⊨ [%2544 := z0, %2545 := z1, %2546 := z2, %2547 := z3, %2548 := z4, %2549 := z5])
    (hwf : S.WF) (hr : S.mem.QuadRoom r) (ha : S.mem.QuadFit a) (hb : S.mem.QuadFit b)
    (hz :
      InBounds S.mem z0 512 ∧
        InBounds S.mem z1 512 ∧
        InBounds S.mem z2 512 ∧
        InBounds S.mem z3 512 ∧ InBounds S.mem z4 512 ∧ InBounds S.mem z5 512)
    (hne :
      z0.id ≠ z1.id ∧ z0.id ≠ z2.id ∧ z1.id ≠ z2.id ∧ z3.id ≠ z4.id ∧ z3.id ≠ z5.id ∧ z4.id ≠ z5.id)
    (hrz : r.id ≠ z0.id ∧ r.id ≠ z1.id ∧ r.id ≠ z2.id ∧ r.id ≠ z3.id ∧ r.id ≠ z4.id ∧ r.id ≠ z5.id)
    (hn : n ≤ z0.id.id ∧ n ≤ z1.id.id ∧ n ≤ z2.id.id ∧ n ≤ z3.id.id ∧ n ≤ z4.id.id ∧ n ≤ z5.id.id)
    (hK :
      ∀ S' : GlobalState,
        S'.alloc = S.alloc →
          S'.mem.eraseFrom n =
            (S.mem.eraseFrom n).storeQuad r
              (geAddTable quadMul (S.mem.readQuad a) (S.mem.readQuad b)) →
          g (.cons (.value r) .nil, S') = K) :
    (fd_ed25519_point_add_with_opts.runFrom E 1 S >>= g) = K := by
  obtain ⟨hz0, hz1, hz2, hz3, hz4, hz5⟩ := hz
  obtain ⟨h01, h02, h12, h34, h35, h45⟩ := hne
  obtain ⟨hn0, hn1, hn2, hn3, hn4, hn5⟩ := hn
  obtain ⟨hr0, hr1, hr2, hr3, hr4, hr5⟩ := hrz
  generalize hA : S.mem.readQuad a = A at hK
  generalize hB : S.mem.readQuad b = B at hK
  block_init
  step_pattern using runBodyFrom_quadLoadRun
  have eB : B = ⟨l03, l14, l25⟩ := by
    rw [← hB]; simpa only [hS] using _hx
  -- FD_R43X6_QUAD_PERMUTE( _tb, 1,0,2,3, P1 ), only the lanes the subtraction reads
  step_pattern using runBodyFrom_permuteLoadRun_poison 1 0 2 3 1 0 0 0
  have eA : A = ⟨l03, l14, l25⟩ := by
    rw [← hA]; simpa only [hS] using _hx
  clear ha hb
  -- FD_R43X6_QUAD_LANE_SUB_FAST( _tb, _tb, 1,0,0,0, _tb, P1 )
  step_pattern using runBodyFrom_laneSubPermRun 1 0 2 3 1 0 0 0
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
  have hpa03 := wwl_perm4_lt hu03 1 0 3 2
  have hpa14 := wwl_perm4_lt hu14 1 0 3 2
  have hpa25 := wwl_perm4_lt hu25 1 0 3 2
  -- FD_R43X6_QUAD_PERMUTE( _tb, 1,0,3,2, _ta ), FD_R43X6_QUAD_LANE_SUB_FAST( _tb, _tb, 1,0,0,1,
  -- _tb, _ta ) and FD_R43X6_QUAD_LANE_ADD_FAST( _tb, _tb, 0,1,1,0, _tb, _ta ), fused; the code's
  -- `nsw` holds
  step_pattern using runBodyFrom_permSubAddRun (hs03 := fun _ => sub_lt_ok hpa03 hu03) (hs14 :=
    fun _ => sub_lt_ok hpa14 hu14) (hs25 := fun _ => sub_lt_ok hpa25 hu25) (ha03 := fun _ =>
    sub_add_lt_ok hpa03 hu03 quadP_lt.1) (ha14 := fun _ => sub_add_lt_ok hpa14 hu14 quadP_lt.2.1)
    (ha25 := fun _ => sub_add_lt_ok hpa25 hu25 quadP_lt.2.2) (ho14 := fun _ k =>
    add_lane_ok (hpa14 k) (hu14 k)) (ho25 := fun _ k => add_lane_ok (hpa25 k) (hu25 k))
  have e5 := _hl
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
      MemoryState.eraseFrom_lifetimeStart, MemoryState.eraseFrom_lifetimeEnd,
      MemoryState.lifetimeStart_eraseFrom_of_le hn0, MemoryState.lifetimeStart_eraseFrom_of_le hn1,
      MemoryState.lifetimeStart_eraseFrom_of_le hn2, MemoryState.lifetimeStart_eraseFrom_of_le hn3,
      MemoryState.lifetimeStart_eraseFrom_of_le hn4, MemoryState.lifetimeStart_eraseFrom_of_le hn5,
      MemoryState.lifetimeEnd_eraseFrom_of_le hn0, MemoryState.lifetimeEnd_eraseFrom_of_le hn1,
      MemoryState.lifetimeEnd_eraseFrom_of_le hn2, MemoryState.lifetimeEnd_eraseFrom_of_le hn3,
      MemoryState.lifetimeEnd_eraseFrom_of_le hn4, MemoryState.lifetimeEnd_eraseFrom_of_le hn5,
      MemoryState.storeAt_eraseFrom_of_le hn0, MemoryState.storeAt_eraseFrom_of_le hn1,
      MemoryState.storeAt_eraseFrom_of_le hn2, MemoryState.storeAt_eraseFrom_of_le hn3,
      MemoryState.storeAt_eraseFrom_of_le hn4, MemoryState.storeAt_eraseFrom_of_le hn5, geAddTable,
      Quad.foldSigned_eq, Quad.foldUnsigned_eq]
    rw [eA, eB, e2, e3, eF1, e4, eU1, e5, Quad.foldSignedC_eq', eF2, e8, e9, e10, eU2]
    subst_vars
    rfl

end fd_ed25519_point_add_with_opts

/-- `fd_ed25519_point_add_with_opts` stores `spec` of the points at `a` and `b` at `r` and returns
`r`; `r` may be `a` or `b`. -/
public theorem fd_ed25519_point_add_with_opts.call_eq (r a b : Pointer) (pre : BitVec 32)
    (s : GlobalState) (hwf : s.WF) (hr : s.mem.QuadRoom r) (ha : s.mem.QuadFit a)
    (hb : s.mem.QuadFit b) :
    fd_ed25519_point_add_with_opts.call
        (fd_ed25519_point_add_with_opts.args (.value r) (.value a) (.value b) (.value pre)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 15⟩,
            mem :=
              s.mem.storeQuad r
                (fd_ed25519_point_add_with_opts.spec (s.mem.readQuad a) (s.mem.readQuad b)
                  pre) }) := by
  func_init
  have hra : S.mem.readQuad a = S₀.mem.readQuad a := by rw [hS]
  have hrb : S.mem.readQuad b = S₀.mem.readQuad b := by rw [hS]
  block_init
  iterate 26 step_pure
  iterate 7 step_pattern using runBodyFrom_insertRun
  iterate 15 step_alloca
  step_pure
  have hC : fd_ed25519_point_add_with_opts.Consts E := by
    dsimp only [fd_ed25519_point_add_with_opts.Consts]
    env_reads
    · rw [hv33]; rfl
    · rw [hv41]; rfl
    · rw [hv49]; rfl
    · rw [hv57]
    · rw [hv65]; rfl
    · rw [hv73]; rfl
    · rw [hv81]; rfl
  finish_block
  · -- `!b_is_precomputed`: FD_R43X6_GE_ADD
    subst hbr
    refine
      fd_ed25519_point_add_with_opts.geAdd_run r a b 0 v88 v89 v90 v91 v92 v93 v94 v95 v96
        S₀.alloc.nextFreeBlock S E _ _ hArgs hC ?_ hwf hr ha hb ?_ ?_ ?_ ?_ ?_
    · env_reads
    · exact
        ⟨hv88_bounds, hv89_bounds, hv90_bounds, hv91_bounds, hv92_bounds, hv93_bounds, hv94_bounds,
          hv95_bounds, hv96_bounds⟩
    · refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> mem_fact
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
    refine
      fd_ed25519_point_add_with_opts.geAddTable_run r a b pre v82 v83 v84 v85 v86 v87
        S₀.alloc.nextFreeBlock S E _ _ hArgs hC ?_ hwf hr ha hb ?_ ?_ ?_ ?_ ?_
    · env_reads
    · exact ⟨hv82_bounds, hv83_bounds, hv84_bounds, hv85_bounds, hv86_bounds, hv87_bounds⟩
    · refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;> mem_fact
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
