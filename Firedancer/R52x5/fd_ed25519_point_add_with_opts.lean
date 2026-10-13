module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.GeAdd
public import Firedancer.R52x5.fd_curve25519_into_precomputed
public import Firedancer.R52x5.Mlir.fd_ed25519_point_add_with_opts
import Firedancer.Common.Tactics

namespace MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `A + B`: `FD_R52X5_GE_ADD_TABLE` of `A` and `B` when `b_is_precomputed`, else of `A` and
`B`'s `FD_R52X5_TO_TABLE` (`FD_R52X5_GE_ADD`). -/
def fd_ed25519_point_add_with_opts.spec (A B : Quad5) (b_is_precomputed : BitVec 32) : Quad5 :=
  if b_is_precomputed = 0 then geAddTable A (fd_curve25519_into_precomputed.spec B)
  else geAddTable A B

end

/-! ## Proof -/

section Proof

namespace fd_ed25519_point_add_with_opts

/-- The entry block's constants: the permutes' immediates, `NEGATE_LAZY`'s `32 p`, `REDUCE`'s
shift, mask and `19`, `MUL_CONSTANT`'s operands, and the `LANE_IF( 1,0,1,0 )` mask. -/
abbrev Consts (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%3281 := 1#32, %3282 := 0#32, %3283 := 3#32, %3284 := 2#32, %3285 :=
    (Vector.replicate 4 72057594037927328#64 : Wl), %3286 :=
    (Vector.replicate 4 72057594037927904#64 : Wl), %3287 := (Vector.replicate 4 51#64 : Wl),
    %3288 := (Vector.replicate 4 2251799813685247#64 : Wl), %3289 :=
    (Vector.replicate 4 19#64 : Wl), %3290 := (Vector.replicate 4 0#64 : Wl), %3291 :=
    wl 121666 121666 243332 243330, %3292 := (Vector.replicate 4 1#64 : Wl), %3314 :=
    laneMask 1 0 1 0]

/-- `FD_R52X5_GE_ADD_TABLE`'s `_ta` before its second product, from its first `M`. -/
def tailTa (M : Quad5) : Quad5 :=
  (M.permute 0 1 3 2).diffSum.reduce

/-- `FD_R52X5_GE_ADD_TABLE`'s second product, from its first `M`. -/
def tailMul (M : Quad5) : Quad5 :=
  fd_r52x5_quad_mul_fast.spec ((tailTa M).permute 0 3 3 0) ((tailTa M).permute 2 1 2 1)

/-- `^bb1` up to `FD_R52X5_GE_ADD_TABLE`'s first product `M` of `_ta` (from the point at `a`) and
the point at `b`, in `z0 … z4`. -/
theorem table_run0 {β : Type} {blk : BasicBlock Γ [Ty.ptr] blockTys}
    (hbody : blk.body.drop 0 = bb1.body.drop 0) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {r a b : Pointer} {pre : BitVec 32}
    {z0 z1 z2 z3 z4 z5 z6 z7 z8 z9 : Pointer}
    (hArgs : E.args = (args (.value r) (.value a) (.value b) (.value pre)).get) (hC : Consts E)
    (hZ :
      E ⊨ [%3293 := z0, %3294 := z1, %3295 := z2, %3296 := z3, %3297 := z4, %3298 := z5, %3299 :=
        z6, %3300 := z7, %3301 := z8, %3302 := z9])
    (hwf : S.WF) (ha : S.mem.Quad5Fit a) (hb : S.mem.Quad5Fit b)
    (hbz : b.id ≠ z0.id ∧ b.id ≠ z1.id ∧ b.id ≠ z2.id ∧ b.id ≠ z3.id ∧ b.id ≠ z4.id)
    (hz :
      InBounds S.mem z0 256 ∧
        InBounds S.mem z1 256 ∧
        InBounds S.mem z2 256 ∧ InBounds S.mem z3 256 ∧ InBounds S.mem z4 256)
    (hzw :
      Writable S.mem z0 ∧
        Writable S.mem z1 ∧ Writable S.mem z2 ∧ Writable S.mem z3 ∧ Writable S.mem z4)
    (hne :
      z1.id ≠ z0.id ∧
        z2.id ≠ z0.id ∧
        z3.id ≠ z0.id ∧
        z4.id ≠ z0.id ∧
        z2.id ≠ z1.id ∧
        z3.id ≠ z1.id ∧ z4.id ≠ z1.id ∧ z3.id ≠ z2.id ∧ z4.id ≠ z2.id ∧ z4.id ≠ z3.id)
    (hK :
      ∀ (E' : ⟪Γ⟫) (M : Quad5),
        (hArgs : E'.args = (args (.value r) (.value a) (.value b) (.value pre)).get) →
          (hC : Consts E') →
          (hR :
            E' ⊨ [%3298 := z5, %3299 := z6, %3300 := z7, %3301 := z8, %3302 := z9, %3336 :=
              wlBytes (laneMask 1 0 1 0), %3406 := M.P0, %3407 := M.P1, %3408 := M.P2, %3409 :=
              M.P3, %3410 := M.P4]) →
          (hM :
            M =
              fd_r52x5_quad_mul_fast.spec
                (Quad5.laneIf 1 1 0 0 (S.mem.readQuad5 a).diffSum (S.mem.readQuad5 a)).reduce
                (S.mem.readQuad5 b)) →
          (blk.runBodyFrom E' 107
                { alloc := ⟨S.alloc.nextFreeBlock + 5⟩, mem := S.mem.callTmp5 z0 z1 z2 z3 z4 M } >>=
              g) =
            K) :
    (blk.runBodyFrom E 0 S >>= g) = K := by
  obtain ⟨hz0, hz1, hz2, hz3, hz4⟩ := hz
  obtain ⟨hw0, hw1, hw2, hw3, hw4⟩ := hzw
  obtain ⟨h10, h20, h30, h40, h21, h31, h41, h32, h42, h43⟩ := hne
  obtain ⟨hb0, hb1, hb2, hb3, hb4⟩ := hbz
  generalize hA : S.mem.readQuad5 a = A at hK
  -- FD_R52X5_QUAD_DIFF_SUM( _ta, P1 )
  step_pattern using runBodyFrom_permuteLoadRun 1 0 3 2 inline
  obtain rfl := hA.symm.trans _hA
  clear ha
  step_pattern using runBodyFrom_negateLazyRun inline
  step_pattern using runBodyFrom_laneIfRun0 1 0 1 0 inline
  step_pattern using runBodyFrom_addFastRun inline
  -- FD_R52X5_QUAD_LANE_IF( _ta, 1,1,0,0, _ta, P1 ); FD_R52X5_QUAD_REDUCE( _ta, _ta )
  step_pattern using runBodyFrom_laneIfRun' 1 1 0 0 inline
  step_pattern using runBodyFrom_reduceCastRun inline
  -- FD_R52X5_QUAD_MUL_FAST( _ta, _ta, T2 )
  step_pattern using runBodyFrom_qpMulLoadRun inline
  rw [hS]
  refine hK E _ hArgs (by env_reads) ?_ rfl
  env_reads

/-- `^bb1` from `FD_R52X5_GE_ADD_TABLE`'s first product `M` on: its second, through `z5 … z9`,
reduced into the point at `r`. -/
theorem table_run107 {β : Type} {blk : BasicBlock Γ [Ty.ptr] blockTys}
    (hbody : blk.body.drop 107 = bb1.body.drop 107) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {r a b : Pointer} {pre : BitVec 32}
    {M : Quad5} {z5 z6 z7 z8 z9 : Pointer}
    (hArgs : E.args = (args (.value r) (.value a) (.value b) (.value pre)).get) (hC : Consts E)
    (hR :
      E ⊨ [%3298 := z5, %3299 := z6, %3300 := z7, %3301 := z8, %3302 := z9, %3336 :=
        wlBytes (laneMask 1 0 1 0), %3406 := M.P0, %3407 := M.P1, %3408 := M.P2, %3409 := M.P3,
        %3410 := M.P4])
    (hwf : S.WF) (hr : S.mem.Quad5Room r)
    (hrz : r.id ≠ z5.id ∧ r.id ≠ z6.id ∧ r.id ≠ z7.id ∧ r.id ≠ z8.id ∧ r.id ≠ z9.id)
    (hz :
      InBounds S.mem z5 256 ∧
        InBounds S.mem z6 256 ∧
        InBounds S.mem z7 256 ∧ InBounds S.mem z8 256 ∧ InBounds S.mem z9 256)
    (hzw :
      Writable S.mem z5 ∧
        Writable S.mem z6 ∧ Writable S.mem z7 ∧ Writable S.mem z8 ∧ Writable S.mem z9)
    (hne :
      z6.id ≠ z5.id ∧
        z7.id ≠ z5.id ∧
        z8.id ≠ z5.id ∧
        z9.id ≠ z5.id ∧
        z7.id ≠ z6.id ∧
        z8.id ≠ z6.id ∧ z9.id ≠ z6.id ∧ z8.id ≠ z7.id ∧ z9.id ≠ z7.id ∧ z9.id ≠ z8.id)
    (hK :
      ∀ E' : ⟪Γ⟫,
        (hArgs : E'.args = (args (.value r) (.value a) (.value b) (.value pre)).get) →
          (blk.runBodyFrom E' 212
                { alloc := ⟨S.alloc.nextFreeBlock + 20⟩,
                  mem :=
                    (S.mem.callTmp5 z5 z6 z7 z8 z9 (tailMul M)).storeQuad5 r
                      (tailMul M).reduce } >>=
              g) =
            K) :
    (blk.runBodyFrom E 107 S >>= g) = K := by
  obtain ⟨hz5, hz6, hz7, hz8, hz9⟩ := hz
  obtain ⟨hw5, hw6, hw7, hw8, hw9⟩ := hzw
  obtain ⟨h65, h75, h85, h95, h76, h86, h96, h87, h97, h98⟩ := hne
  obtain ⟨hr5, hr6, hr7, hr8, hr9⟩ := hrz
  -- FD_R52X5_QUAD_PERMUTE( _ta, 0,1,3,2, _ta ); FD_R52X5_QUAD_DIFF_SUM( _ta, _ta )
  step_pattern using runBodyFrom_permuteRun 0 1 3 2 inline
  step_pattern using runBodyFrom_permuteRun 1 0 3 2 inline
  step_pattern using runBodyFrom_negateLazyRun inline
  step_pattern using runBodyFrom_laneIfMaskRun 1 0 1 0 inline
  step_pattern using runBodyFrom_addFastRun inline
  -- FD_R52X5_QUAD_REDUCE( _ta, _ta )
  step_pattern using runBodyFrom_reduceRun inline
  -- FD_R52X5_QUAD_PERMUTE( _tb, 0,3,3,0, _ta ); FD_R52X5_QUAD_PERMUTE( _ta, 2,1,2,1, _ta );
  -- FD_R52X5_QUAD_MUL_FAST( P3, _tb, _ta ); FD_R52X5_QUAD_REDUCE( P3, P3 )
  step_pattern using runBodyFrom_geAddEndRun inline
  rw [hS]
  exact hK E' (‹E'.args = E.args›.trans hArgs)

/-- `^bb2` up to `FD_R52X5_TO_TABLE( _table, P2 )`: `T`, of the point at `b`. -/
theorem add_run0 {β : Type} {blk : BasicBlock Γ [Ty.ptr] blockTys}
    (hbody : blk.body.drop 0 = bb2.body.drop 0) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {r a b : Pointer} {pre : BitVec 32}
    {z0 z1 z2 z3 z4 z5 z6 z7 z8 z9 : Pointer}
    (hArgs : E.args = (args (.value r) (.value a) (.value b) (.value pre)).get) (hC : Consts E)
    (hZ :
      E ⊨ [%3303 := z0, %3304 := z1, %3305 := z2, %3306 := z3, %3307 := z4, %3308 := z5, %3309 :=
        z6, %3310 := z7, %3311 := z8, %3312 := z9])
    (hwf : S.WF) (hb : S.mem.Quad5Fit b)
    (hK :
      ∀ (E' : ⟪Γ⟫) (T : Quad5),
        (hArgs : E'.args = (args (.value r) (.value a) (.value b) (.value pre)).get) →
          (hC : Consts E') →
          (hR :
            E' ⊨ [%3303 := z0, %3304 := z1, %3305 := z2, %3306 := z3, %3307 := z4, %3308 := z5,
              %3309 := z6, %3310 := z7, %3311 := z8, %3312 := z9, %3521 :=
              wlBytes (laneMask 1 0 1 0), %3547 := wlBytes (laneMask 1 1 0 0), %3632 := T.P0,
              %3635 := T.P1, %3638 := T.P2, %3641 := T.P3, %3644 := T.P4]) →
          (hT : T = fd_curve25519_into_precomputed.spec (S.mem.readQuad5 b)) →
          (blk.runBodyFrom E' 145 { alloc := ⟨S.alloc.nextFreeBlock + 5⟩, mem := S.mem } >>= g) =
            K) :
    (blk.runBodyFrom E 0 S >>= g) = K := by
  generalize hB : S.mem.readQuad5 b = B at hK
  -- FD_R52X5_QUAD_DIFF_SUM( _ta, S )
  step_pattern using runBodyFrom_permuteLoadRun 1 0 3 2 inline
  obtain rfl := hB.symm.trans _hA
  step_pattern using runBodyFrom_negateLazyRun inline
  step_pattern using runBodyFrom_laneIfRun0 1 0 1 0 inline
  step_pattern using runBodyFrom_addFastRun inline
  -- FD_R52X5_QUAD_LANE_IF( _ta, 1,1,0,0, _ta, S ); FD_R52X5_QUAD_REDUCE( _ta, _ta )
  step_pattern using runBodyFrom_laneIfRun' 1 1 0 0 inline
  step_pattern using runBodyFrom_reduceCastRun inline
  -- FD_R52X5_QUAD_MUL_CONSTANT( _ta, _ta, _1122d )
  step_pattern using runBodyFrom_mulConstRun inline
  -- FD_R52X5_QUAD_NEGATE_LAZY( _tb, _ta ); FD_R52X5_QUAD_LANE_IF( _ta, 0,0,0,1, _tb, _ta )
  step_pattern using runBodyFrom_negateLazyRun inline
  step_pattern using runBodyFrom_laneIfRun 0 0 0 1 inline
  -- FD_R52X5_QUAD_REDUCE( D, _ta )
  step_pattern using runBodyFrom_reduceCastRun inline
  rw [hS]
  refine hK E _ hArgs (by env_reads) ?_ rfl
  env_reads

/-- `^bb2` from `FD_R52X5_TO_TABLE`'s `T` up to `FD_R52X5_GE_ADD_TABLE`'s first product `M` of
`_ta` (from the point at `a`) and `T`, in `z0 … z4`. -/
theorem add_run145 {β : Type} {blk : BasicBlock Γ [Ty.ptr] blockTys}
    (hbody : blk.body.drop 145 = bb2.body.drop 145) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {r a b : Pointer} {pre : BitVec 32}
    {T : Quad5} {z0 z1 z2 z3 z4 z5 z6 z7 z8 z9 : Pointer}
    (hArgs : E.args = (args (.value r) (.value a) (.value b) (.value pre)).get) (hC : Consts E)
    (hR :
      E ⊨ [%3303 := z0, %3304 := z1, %3305 := z2, %3306 := z3, %3307 := z4, %3308 := z5, %3309 :=
        z6, %3310 := z7, %3311 := z8, %3312 := z9, %3521 := wlBytes (laneMask 1 0 1 0), %3547 :=
        wlBytes (laneMask 1 1 0 0), %3632 := T.P0, %3635 := T.P1, %3638 := T.P2, %3641 := T.P3,
        %3644 := T.P4])
    (hwf : S.WF) (ha : S.mem.Quad5Fit a)
    (hz :
      InBounds S.mem z0 256 ∧
        InBounds S.mem z1 256 ∧
        InBounds S.mem z2 256 ∧ InBounds S.mem z3 256 ∧ InBounds S.mem z4 256)
    (hzw :
      Writable S.mem z0 ∧
        Writable S.mem z1 ∧ Writable S.mem z2 ∧ Writable S.mem z3 ∧ Writable S.mem z4)
    (hne :
      z1.id ≠ z0.id ∧
        z2.id ≠ z0.id ∧
        z3.id ≠ z0.id ∧
        z4.id ≠ z0.id ∧
        z2.id ≠ z1.id ∧
        z3.id ≠ z1.id ∧ z4.id ≠ z1.id ∧ z3.id ≠ z2.id ∧ z4.id ≠ z2.id ∧ z4.id ≠ z3.id)
    (hK :
      ∀ (E' : ⟪Γ⟫) (M : Quad5),
        (hArgs : E'.args = (args (.value r) (.value a) (.value b) (.value pre)).get) →
          (hC : Consts E') →
          (hR :
            E' ⊨ [%3308 := z5, %3309 := z6, %3310 := z7, %3311 := z8, %3312 := z9, %3521 :=
              wlBytes (laneMask 1 0 1 0), %3724 := M.P0, %3725 := M.P1, %3726 := M.P2, %3727 :=
              M.P3, %3728 := M.P4]) →
          (hM :
            M =
              fd_r52x5_quad_mul_fast.spec
                (Quad5.laneIf 1 1 0 0 (S.mem.readQuad5 a).diffSum (S.mem.readQuad5 a)).reduce T) →
          (blk.runBodyFrom E' 240
                { alloc := ⟨S.alloc.nextFreeBlock + 5⟩, mem := S.mem.callTmp5 z0 z1 z2 z3 z4 M } >>=
              g) =
            K) :
    (blk.runBodyFrom E 145 S >>= g) = K := by
  obtain ⟨hz0, hz1, hz2, hz3, hz4⟩ := hz
  obtain ⟨hw0, hw1, hw2, hw3, hw4⟩ := hzw
  obtain ⟨h10, h20, h30, h40, h21, h31, h41, h32, h42, h43⟩ := hne
  generalize hA : S.mem.readQuad5 a = A at hK
  -- FD_R52X5_QUAD_DIFF_SUM( _ta, P1 )
  step_pattern using runBodyFrom_permuteLoadRun 1 0 3 2 inline
  obtain rfl := hA.symm.trans _hA
  clear ha
  step_pattern using runBodyFrom_negateLazyRun inline
  step_pattern using runBodyFrom_laneIfMaskRun 1 0 1 0 inline
  step_pattern using runBodyFrom_addFastRun inline
  -- FD_R52X5_QUAD_LANE_IF( _ta, 1,1,0,0, _ta, P1 ); FD_R52X5_QUAD_REDUCE( _ta, _ta )
  step_pattern using runBodyFrom_laneIfMaskRun' 1 1 0 0 inline
  step_pattern using runBodyFrom_reduceCastRun inline
  -- FD_R52X5_QUAD_MUL_FAST( _ta, _ta, T2 )
  step_pattern using runBodyFrom_qpMulRun inline
  rw [hS]
  refine hK E _ hArgs (by env_reads) ?_ rfl
  env_reads

/-- `^bb2` from `FD_R52X5_GE_ADD_TABLE`'s first product `M` on: its second, through `z5 … z9`,
reduced into the point at `r`. -/
theorem add_run240 {β : Type} {blk : BasicBlock Γ [Ty.ptr] blockTys}
    (hbody : blk.body.drop 240 = bb2.body.drop 240) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {r a b : Pointer} {pre : BitVec 32}
    {M : Quad5} {z5 z6 z7 z8 z9 : Pointer}
    (hArgs : E.args = (args (.value r) (.value a) (.value b) (.value pre)).get) (hC : Consts E)
    (hR :
      E ⊨ [%3308 := z5, %3309 := z6, %3310 := z7, %3311 := z8, %3312 := z9, %3521 :=
        wlBytes (laneMask 1 0 1 0), %3724 := M.P0, %3725 := M.P1, %3726 := M.P2, %3727 := M.P3,
        %3728 := M.P4])
    (hwf : S.WF) (hr : S.mem.Quad5Room r)
    (hrz : r.id ≠ z5.id ∧ r.id ≠ z6.id ∧ r.id ≠ z7.id ∧ r.id ≠ z8.id ∧ r.id ≠ z9.id)
    (hz :
      InBounds S.mem z5 256 ∧
        InBounds S.mem z6 256 ∧
        InBounds S.mem z7 256 ∧ InBounds S.mem z8 256 ∧ InBounds S.mem z9 256)
    (hzw :
      Writable S.mem z5 ∧
        Writable S.mem z6 ∧ Writable S.mem z7 ∧ Writable S.mem z8 ∧ Writable S.mem z9)
    (hne :
      z6.id ≠ z5.id ∧
        z7.id ≠ z5.id ∧
        z8.id ≠ z5.id ∧
        z9.id ≠ z5.id ∧
        z7.id ≠ z6.id ∧
        z8.id ≠ z6.id ∧ z9.id ≠ z6.id ∧ z8.id ≠ z7.id ∧ z9.id ≠ z7.id ∧ z9.id ≠ z8.id)
    (hK :
      ∀ E' : ⟪Γ⟫,
        (hArgs : E'.args = (args (.value r) (.value a) (.value b) (.value pre)).get) →
          (blk.runBodyFrom E' 345
                { alloc := ⟨S.alloc.nextFreeBlock + 20⟩,
                  mem :=
                    (S.mem.callTmp5 z5 z6 z7 z8 z9 (tailMul M)).storeQuad5 r
                      (tailMul M).reduce } >>=
              g) =
            K) :
    (blk.runBodyFrom E 240 S >>= g) = K := by
  obtain ⟨hz5, hz6, hz7, hz8, hz9⟩ := hz
  obtain ⟨hw5, hw6, hw7, hw8, hw9⟩ := hzw
  obtain ⟨h65, h75, h85, h95, h76, h86, h96, h87, h97, h98⟩ := hne
  obtain ⟨hr5, hr6, hr7, hr8, hr9⟩ := hrz
  -- FD_R52X5_QUAD_PERMUTE( _ta, 0,1,3,2, _ta ); FD_R52X5_QUAD_DIFF_SUM( _ta, _ta )
  step_pattern using runBodyFrom_permuteRun 0 1 3 2 inline
  step_pattern using runBodyFrom_permuteRun 1 0 3 2 inline
  step_pattern using runBodyFrom_negateLazyRun inline
  step_pattern using runBodyFrom_laneIfMaskRun 1 0 1 0 inline
  step_pattern using runBodyFrom_addFastRun inline
  -- FD_R52X5_QUAD_REDUCE( _ta, _ta )
  step_pattern using runBodyFrom_reduceRun inline
  -- FD_R52X5_QUAD_PERMUTE( _tb, 0,3,3,0, _ta ); FD_R52X5_QUAD_PERMUTE( _ta, 2,1,2,1, _ta );
  -- FD_R52X5_QUAD_MUL_FAST( P3, _tb, _ta ); FD_R52X5_QUAD_REDUCE( P3, P3 )
  step_pattern using runBodyFrom_geAddEndRun inline
  rw [hS]
  exact hK E' (‹E'.args = E.args›.trans hArgs)

end fd_ed25519_point_add_with_opts

-- the twenty slots' facts, `Writable` ones among them, through both branches: over 200000
-- heartbeats
set_option maxHeartbeats 400000 in
/-- `fd_ed25519_point_add_with_opts` stores `spec` of the points at `a` and `b` at `r` and returns
`r`; `r` may be `a` or `b`. Its twenty product slots and `wl_permute`'s unions are freed. -/
public theorem fd_ed25519_point_add_with_opts.call_eq (r a b : Pointer) (pre : BitVec 32)
    (s : GlobalState) (hwf : s.WF) (hr : s.mem.Quad5Room r) (ha : s.mem.Quad5Fit a)
    (hb : s.mem.Quad5Fit b) :
    fd_ed25519_point_add_with_opts.call
        (fd_ed25519_point_add_with_opts.args (.value r) (.value a) (.value b) (.value pre)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + if pre = 0 then 50 else 45⟩,
            mem :=
              s.mem.storeQuad5 r
                (fd_ed25519_point_add_with_opts.spec (s.mem.readQuad5 a) (s.mem.readQuad5 b)
                  pre) }) := by
  func_init
  have hra : S.mem.readQuad5 a = S₀.mem.readQuad5 a := by rw [hS]
  have hrb : S.mem.readQuad5 b = S₀.mem.readQuad5 b := by rw [hS]
  block_init
  iterate 12 step_pure
  iterate 20 step_alloca
  step_pure
  step_call using wc_bcast_wide.call_eq
  rw [hS] at hra hrb
  finish_block
  · -- `!b_is_precomputed`: FD_R52X5_GE_ADD
    block_init
    step_pattern using fd_ed25519_point_add_with_opts.add_run0
    step_pattern using fd_ed25519_point_add_with_opts.add_run145
    step_pattern using fd_ed25519_point_add_with_opts.add_run240
    finish_block
    block_init
    finish_block
    dsimp only at hT hM
    rw [hrb] at hT
    rw [hra] at hM
    subst hT hM hS hbr
    erase_frame
    simp only [fd_ed25519_point_add_with_opts.spec]
    rfl
  · -- `b_is_precomputed`: FD_R52X5_GE_ADD_TABLE
    block_init
    step_pattern using fd_ed25519_point_add_with_opts.table_run0
    step_pattern using fd_ed25519_point_add_with_opts.table_run107
    finish_block
    block_init
    finish_block
    rw [hra, hrb] at hM
    subst hM hS
    erase_frame
    have hpre : pre ≠ 0 := hbr
    simp only [fd_ed25519_point_add_with_opts.spec, hpre, ↓reduceIte]
    rfl

end Proof

end MLIR.Firedancer.R52x5
