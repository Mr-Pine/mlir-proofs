module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.Runs
public import Firedancer.R52x5.fd_r52x5_quad_mul_fast

/-! `FD_R52X5_GE_ADD_TABLE` as a function, and the runs of its compiled code `Runs` lacks: lane-ifs
on a mask computed earlier, and products whose loads interleave with `getelementptr`s. -/

namespace MLIR.Firedancer.R52x5

@[expose] public section

/-- `FD_R52X5_GE_ADD_TABLE( P3, P1, T2, _ta, _tb )`: `P1 + T2`, `T2` in the precomputed form. -/
def geAddTable (P1 T2 : Quad5) : Quad5 :=
  let _ta := P1.diffSum
  let _ta := Quad5.laneIf 1 1 0 0 _ta P1
  let _ta := _ta.reduce
  let _ta := fd_r52x5_quad_mul_fast.spec _ta T2
  let _ta := _ta.permute 0 1 3 2
  let _ta := _ta.diffSum
  let _ta := _ta.reduce
  let _tb := _ta.permute 0 3 3 0
  let _ta := _ta.permute 2 1 2 1
  let P3 := fd_r52x5_quad_mul_fast.spec _tb _ta
  P3.reduce

/-! ### `FD_R52X5_QUAD_LANE_IF` on an earlier mask -/

/-- `laneIfMaskRun` with `t`'s bytes `tb0 … tb4` at hand too: `blendLimbRun'` per limb. -/
def laneIfMaskRun' (s0 s1 s2 s3 s4 : Dst Γ Ty4x64)
    (tb0 tb1 tb2 tb3 tb4 mb sb0 q0 sb1 q1 sb2 q2 sb3 q3 sb4 q4 : Dst Γ Ty32x8)
    (r0 r1 r2 r3 r4 : Dst Γ Ty4x64) : List (Instr Γ) :=
  blendLimbRun' s0 mb tb0 sb0 q0 r0 ++ blendLimbRun' s1 mb tb1 sb1 q1 r1 ++
    blendLimbRun' s2 mb tb2 sb2 q2 r2 ++
    blendLimbRun' s3 mb tb3 sb3 q3 r3 ++
    blendLimbRun' s4 mb tb4 sb4 q4 r4

/-- `runBodyFrom_laneIfMaskRun` for `laneIfMaskRun'`, `tb0 … tb4` holding `T`'s bytes. -/
theorem runBodyFrom_laneIfMaskRun' (i0 i1 i2 i3 : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
    {pos : Nat} {s0 s1 s2 s3 s4 : Dst Γ Ty4x64}
    {tb0 tb1 tb2 tb3 tb4 mb sb0 q0 sb1 q1 sb2 q2 sb3 q3 sb4 q4 : Dst Γ Ty32x8}
    {r0 r1 r2 r3 r4 : Dst Γ Ty4x64} {rest : List (Instr Γ)} {X T : Quad5} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        laneIfMaskRun' s0 s1 s2 s3 s4 tb0 tb1 tb2 tb3 tb4 mb sb0 q0 sb1 q1 sb2 q2 sb3 q3 sb4 q4 r0
            r1 r2 r3 r4 ++
          rest)
    (hR :
      E ⊨ [tb0 := wlBytes T.P0, tb1 := wlBytes T.P1, tb2 := wlBytes T.P2, tb3 := wlBytes T.P3,
        tb4 := wlBytes T.P4, s0 := X.P0, s1 := X.P1, s2 := X.P2, s3 := X.P3, s4 := X.P4, mb :=
        wlBytes (laneMask i0 i1 i2 i3)])
    (hi : i0 ≤ 1 ∧ i1 ≤ 1 ∧ i2 ≤ 1 ∧ i3 ≤ 1)
    (hd :
      [s0.i, s1.i, s2.i, s3.i, s4.i, tb0.i, tb1.i, tb2.i, tb3.i, tb4.i, mb.i, sb0.i, q0.i, r0.i,
          sb1.i, q1.i, r1.i, sb2.i, q2.i, r2.i, sb3.i, q3.i, r3.i, sb4.i].Nodup)
    (hK :
      (blk.runBodyFrom
            E[sb0 := Ty.wrap (wlBytes X.P0), q0 :=
              Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X T).P0), r0 :=
              Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X T).P0, sb1 := Ty.wrap (wlBytes X.P1), q1 :=
              Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X T).P1), r1 :=
              Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X T).P1, sb2 := Ty.wrap (wlBytes X.P2), q2 :=
              Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X T).P2), r2 :=
              Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X T).P2, sb3 := Ty.wrap (wlBytes X.P3), q3 :=
              Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X T).P3), r3 :=
              Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X T).P3, sb4 := Ty.wrap (wlBytes X.P4), q4 :=
              Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X T).P4), r4 :=
              Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X T).P4]
            (pos + 15) S >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨h0, h1, h2, h3⟩ := hi
  step_pattern using runBodyFrom_blendLimbRun' i0 i1 i2 i3 inline
  step_pattern using runBodyFrom_blendLimbRun' i0 i1 i2 i3 inline
  step_pattern using runBodyFrom_blendLimbRun' i0 i1 i2 i3 inline
  step_pattern using runBodyFrom_blendLimbRun' i0 i1 i2 i3 inline
  step_pattern using runBodyFrom_blendLimbRun' i0 i1 i2 i3 inline
  rw [hE, hS]
  exact hK

/-- `laneIfRun` with the mask `m` computed earlier: no `wc_bcast_wide` call. -/
def laneIfRun0 (m t0 s0 t1 s1 t2 s2 t3 s3 t4 s4 : Dst Γ Ty4x64)
    (mb tb0 sb0 q0 tb1 sb1 q1 tb2 sb2 q2 tb3 sb3 q3 tb4 sb4 q4 : Dst Γ Ty32x8)
    (r0 r1 r2 r3 r4 : Dst Γ Ty4x64) : List (Instr Γ) :=
  .unop (.bitcast (by decide)) tb0 (.val t0.i t0.h) ::
    .unop (.bitcast (by decide)) sb0 (.val s0.i s0.h) ::
    .unop (.bitcast (by decide)) mb (.val m.i m.h) ::
    .ternop .pblendvb q0 (.val tb0.i tb0.h) (.val sb0.i sb0.h) (.val mb.i mb.h) ::
    .unop (.bitcast (by decide)) r0 (.val q0.i q0.h) ::
    (blendLimbRun t1 s1 mb tb1 sb1 q1 r1 ++ blendLimbRun t2 s2 mb tb2 sb2 q2 r2 ++
      blendLimbRun t3 s3 mb tb3 sb3 q3 r3 ++
      blendLimbRun t4 s4 mb tb4 sb4 q4 r4)

/-- `runBodyFrom_laneIfRun` for `laneIfRun0`, `m` holding `laneMask i0 i1 i2 i3`. -/
theorem runBodyFrom_laneIfRun0 (i0 i1 i2 i3 : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
    {pos : Nat} {m t0 s0 t1 s1 t2 s2 t3 s3 t4 s4 : Dst Γ Ty4x64}
    {mb tb0 sb0 q0 tb1 sb1 q1 tb2 sb2 q2 tb3 sb3 q3 tb4 sb4 q4 : Dst Γ Ty32x8}
    {r0 r1 r2 r3 r4 : Dst Γ Ty4x64} {rest : List (Instr Γ)} {X T : Quad5} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        laneIfRun0 m t0 s0 t1 s1 t2 s2 t3 s3 t4 s4 mb tb0 sb0 q0 tb1 sb1 q1 tb2 sb2 q2 tb3 sb3 q3
            tb4 sb4 q4 r0 r1 r2 r3 r4 ++
          rest)
    (hR :
      E ⊨ [m := laneMask i0 i1 i2 i3, t0 := T.P0, t1 := T.P1, t2 := T.P2, t3 := T.P3, t4 := T.P4,
        s0 := X.P0, s1 := X.P1, s2 := X.P2, s3 := X.P3, s4 := X.P4])
    (hi : i0 ≤ 1 ∧ i1 ≤ 1 ∧ i2 ≤ 1 ∧ i3 ≤ 1)
    (hd :
      [m.i, t0.i, s0.i, t1.i, s1.i, t2.i, s2.i, t3.i, s3.i, t4.i, s4.i, mb.i, tb0.i, sb0.i, q0.i,
          r0.i, tb1.i, sb1.i, q1.i, r1.i, tb2.i, sb2.i, q2.i, r2.i, tb3.i, sb3.i, q3.i, r3.i, tb4.i,
          sb4.i].Nodup)
    (hK :
      (blk.runBodyFrom
            E[tb0 := Ty.wrap (wlBytes T.P0), sb0 := Ty.wrap (wlBytes X.P0), mb :=
              Ty.wrap (wlBytes (laneMask i0 i1 i2 i3)), q0 :=
              Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X T).P0), r0 :=
              Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X T).P0, tb1 := Ty.wrap (wlBytes T.P1), sb1 :=
              Ty.wrap (wlBytes X.P1), q1 := Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X T).P1),
              r1 := Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X T).P1, tb2 := Ty.wrap (wlBytes T.P2), sb2 :=
              Ty.wrap (wlBytes X.P2), q2 := Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X T).P2),
              r2 := Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X T).P2, tb3 := Ty.wrap (wlBytes T.P3), sb3 :=
              Ty.wrap (wlBytes X.P3), q3 := Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X T).P3),
              r3 := Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X T).P3, tb4 := Ty.wrap (wlBytes T.P4), sb4 :=
              Ty.wrap (wlBytes X.P4), q4 := Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X T).P4),
              r4 := Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X T).P4]
            (pos + 21) S >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨h0, h1, h2, h3⟩ := hi
  step_pattern using runBodyFrom_bytesRun inline
  step_pattern using runBodyFrom_bytesRun inline
  step_pattern using runBodyFrom_bytesRun inline
  step_pattern using runBodyFrom_blendRun i0 i1 i2 i3 inline
  step_pattern using runBodyFrom_wlRun inline
  step_pattern using runBodyFrom_blendLimbRun i0 i1 i2 i3 inline
  step_pattern using runBodyFrom_blendLimbRun i0 i1 i2 i3 inline
  step_pattern using runBodyFrom_blendLimbRun i0 i1 i2 i3 inline
  step_pattern using runBodyFrom_blendLimbRun i0 i1 i2 i3 inline
  rw [hE, hS]
  exact hK

/-! ### `FD_R52X5_QUAD_MUL_FAST` with interleaved loads and `getelementptr`s -/

/-- `qpMulRun` with `y` loaded from the point at `p` (through `g1 … g4`) between the slots'
`lifetime.start`s and the call. -/
def qpMulLoadRun (z0 z1 z2 z3 z4 : Dst Γ .ptr) (p : Reg Γ .ptr) (g1 g2 g3 g4 : Dst Γ .ptr)
    (x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 q0 q1 q2 q3 q4 : Dst Γ Ty4x64) : List (Instr Γ) :=
  [.lifetimeStart (.val z0.i z0.h) 32, .lifetimeStart (.val z1.i z1.h) 32,
    .lifetimeStart (.val z2.i z2.h) 32, .lifetimeStart (.val z3.i z3.h) 32,
    .lifetimeStart (.val z4.i z4.h) 32, .load y0 p, .unop (.gepConst 32) g1 p,
    .load y1 (.val g1.i g1.h), .unop (.gepConst 64) g2 p, .load y2 (.val g2.i g2.h),
    .unop (.gepConst 96) g3 p, .load y3 (.val g3.i g3.h), .unop (.gepConst 128) g4 p,
    .load y4 (.val g4.i g4.h),
    .call fd_r52x5_quad_mul_fast.call
      (.cons (.val z0.i z0.h)
        (.cons (.val z1.i z1.h)
          (.cons (.val z2.i z2.h)
            (.cons (.val z3.i z3.h)
              (.cons (.val z4.i z4.h)
                (.cons (.val x0.i x0.h)
                  (.cons (.val x1.i x1.h)
                    (.cons (.val x2.i x2.h)
                      (.cons (.val x3.i x3.h)
                        (.cons (.val x4.i x4.h)
                          (.cons (.val y0.i y0.h)
                            (.cons (.val y1.i y1.h)
                              (.cons (.val y2.i y2.h)
                                (.cons (.val y3.i y3.h) (.cons (.val y4.i y4.h) .nil)))))))))))))))
      .nil,
    .load q0 (.val z0.i z0.h), .load q1 (.val z1.i z1.h), .load q2 (.val z2.i z2.h),
    .load q3 (.val z3.i z3.h), .load q4 (.val z4.i z4.h), .lifetimeEnd (.val z4.i z4.h) 32,
    .lifetimeEnd (.val z3.i z3.h) 32, .lifetimeEnd (.val z2.i z2.h) 32,
    .lifetimeEnd (.val z1.i z1.h) 32, .lifetimeEnd (.val z0.i z0.h) 32]

/-- Where the body at `pos` is `qpMulLoadRun`, `x0 … x4` hold `X`, `p` the point `P` and
`z0 … z4` five slots in distinct blocks: running on from `pos` then `g` gives `K` if it does from
`pos + 25` with `P`'s `wl_t`s in `y0 … y4`, `P + 32 k` in `gk` and their product with `X` in
`q0 … q4` and left in the slots, their lifetimes ended (`callTmp5`). -/
theorem runBodyFrom_qpMulLoadRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {z0 z1 z2 z3 z4 : Dst Γ .ptr} {p : Reg Γ .ptr} {g1 g2 g3 g4 : Dst Γ .ptr}
    {x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 q0 q1 q2 q3 q4 : Dst Γ Ty4x64} {rest : List (Instr Γ)}
    {X : Quad5} {P Z0 Z1 Z2 Z3 Z4 : Pointer} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        qpMulLoadRun z0 z1 z2 z3 z4 p g1 g2 g3 g4 x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 q0 q1 q2 q3 q4 ++
          rest)
    (hR :
      E ⊨ [x0 := X.P0, x1 := X.P1, x2 := X.P2, x3 := X.P3, x4 := X.P4, p := P, z0 := Z0, z1 := Z1,
        z2 := Z2, z3 := Z3, z4 := Z4])
    (hwf : S.WF) (hP : S.mem.Quad5Fit P)
    (hp : p ≠ .val g1.i g1.h ∧ p ≠ .val g2.i g2.h ∧ p ≠ .val g3.i g3.h)
    (hd :
      [z0.i, z1.i, z2.i, z3.i, z4.i, x0.i, x1.i, x2.i, x3.i, x4.i, y0.i, g1.i, y1.i, g2.i, y2.i,
          g3.i, y3.i, g4.i, y4.i].Nodup)
    (hZ :
      InBounds S.mem Z0 256 ∧
        InBounds S.mem Z1 256 ∧
        InBounds S.mem Z2 256 ∧ InBounds S.mem Z3 256 ∧ InBounds S.mem Z4 256)
    (hPZ : P.id ≠ Z0.id ∧ P.id ≠ Z1.id ∧ P.id ≠ Z2.id ∧ P.id ≠ Z3.id ∧ P.id ≠ Z4.id)
    (hne :
      Z1.id ≠ Z0.id ∧
        Z2.id ≠ Z0.id ∧
        Z3.id ≠ Z0.id ∧
        Z4.id ≠ Z0.id ∧
        Z2.id ≠ Z1.id ∧
        Z3.id ≠ Z1.id ∧ Z4.id ≠ Z1.id ∧ Z3.id ≠ Z2.id ∧ Z4.id ≠ Z2.id ∧ Z4.id ≠ Z3.id)
    (hK :
      (blk.runBodyFrom
            E[y0 := Ty.wrap (S.mem.readQuad5 P).P0, g1 := .value (P.add 32#64), y1 :=
              Ty.wrap (S.mem.readQuad5 P).P1, g2 := .value (P.add 64#64), y2 :=
              Ty.wrap (S.mem.readQuad5 P).P2, g3 := .value (P.add 96#64), y3 :=
              Ty.wrap (S.mem.readQuad5 P).P3, g4 := .value (P.add 128#64), y4 :=
              Ty.wrap (S.mem.readQuad5 P).P4, q0 :=
              Ty.wrap (fd_r52x5_quad_mul_fast.spec X (S.mem.readQuad5 P)).P0, q1 :=
              Ty.wrap (fd_r52x5_quad_mul_fast.spec X (S.mem.readQuad5 P)).P1, q2 :=
              Ty.wrap (fd_r52x5_quad_mul_fast.spec X (S.mem.readQuad5 P)).P2, q3 :=
              Ty.wrap (fd_r52x5_quad_mul_fast.spec X (S.mem.readQuad5 P)).P3, q4 :=
              Ty.wrap (fd_r52x5_quad_mul_fast.spec X (S.mem.readQuad5 P)).P4]
            (pos + 25)
            { alloc := S.alloc,
              mem :=
                S.mem.callTmp5 Z0 Z1 Z2 Z3 Z4
                  (fd_r52x5_quad_mul_fast.spec X (S.mem.readQuad5 P)) } >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hz0, hz1, hz2, hz3, hz4⟩ := hZ
  obtain ⟨h10, h20, h30, h40, h21, h31, h41, h32, h42, h43⟩ := hne
  obtain ⟨hP0, hP1, hP2, hP3, hP4⟩ := hPZ
  obtain ⟨hp1, hp2, hp3⟩ := hp
  iterate 5 step_pure
  step_load [ofFn_extractVecElem_readAt] with v0
  step_pure
  step_load [ofFn_extractVecElem_readAt] with v1
  step_pure
  step_load [ofFn_extractVecElem_readAt] with v2
  step_pure
  step_load [ofFn_extractVecElem_readAt] with v3
  step_pure
  step_load [ofFn_extractVecElem_readAt] with v4
  step_call using (fd_r52x5_quad_mul_fast.call_eq (Y := ⟨v0, v1, v2, v3, v4⟩))
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  iterate 5 step_pure
  rw [hE, hS]
  subst hv0 hv1 hv2 hv3 hv4
  exact hK

/-! ### The end of `FD_R52X5_GE_ADD_TABLE` -/

/-- `FD_R52X5_GE_ADD_TABLE`'s last permutes, product and reduce as compiled: `x` permuted
`0,3,3,0` into `tb` (immediates `c0 … c3`) and `2,1,2,1` into `ta` (`e0 … e3`), their product
(`qpMulGepRun`, through `z0 … z4`) reduced into the point at `p` (`reduceStoreRun`). -/
def geAddEndRun (c0 c1 c2 c3 e0 e1 e2 e3 : Reg Γ (.bv 32))
    (x0 x1 x2 x3 x4 tb0 tb1 tb2 tb3 tb4 ta0 ta1 ta2 ta3 ta4 : Dst Γ Ty4x64)
    (z0 z1 z2 z3 z4 : Dst Γ .ptr) (p : Reg Γ .ptr) (q0 q1 : Dst Γ Ty4x64) (g1 : Dst Γ .ptr)
    (q2 : Dst Γ Ty4x64) (g2 : Dst Γ .ptr) (q3 : Dst Γ Ty4x64) (g3 : Dst Γ .ptr) (q4 : Dst Γ Ty4x64)
    (g4 : Dst Γ .ptr) (k mask r19 h0 h1 h2 h3 h4 a0 d0 a1 d1 a2 d2 a3 d3 a4 d4 : Dst Γ Ty4x64) :
    List (Instr Γ) :=
  permuteRun c0 c1 c2 c3 x0 x1 x2 x3 x4 tb0 tb1 tb2 tb3 tb4 ++
    permuteRun e0 e1 e2 e3 x0 x1 x2 x3 x4 ta0 ta1 ta2 ta3 ta4 ++
    qpMulGepRun z0 z1 z2 z3 z4 tb0 tb1 tb2 tb3 tb4 ta0 ta1 ta2 ta3 ta4 p q0 q1 g1 q2 g2 q3 g3 q4
      g4 ++
    reduceStoreRun q0 q1 q2 q3 q4 k mask r19 h0 h1 h2 h3 h4 a0 d0 a1 d1 a2 d2 a3 d3 a4 d4 p
      (.val g1.i g1.h) (.val g2.i g2.h) (.val g3.i g3.h) (.val g4.i g4.h)

/-- Where the body at `pos` is `geAddEndRun`, `x0 … x4` hold `X`, `p` the point `P` and
`z0 … z4` five slots in distinct blocks: running on from `pos` then `g` gives `K` if it does from
`pos + 50`, ten blocks on, with the product left in the ended slots and reduced at `P`, in any
env with the same arguments: the writes are dropped, as `add_with_opts`'s past register 512 defeat
the steps. -/
theorem runBodyFrom_geAddEndRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {c0 c1 c2 c3 e0 e1 e2 e3 : Reg Γ (.bv 32)}
    {x0 x1 x2 x3 x4 tb0 tb1 tb2 tb3 tb4 ta0 ta1 ta2 ta3 ta4 : Dst Γ Ty4x64}
    {z0 z1 z2 z3 z4 : Dst Γ .ptr} {p : Reg Γ .ptr} {q0 q1 q2 q3 q4 : Dst Γ Ty4x64}
    {g1 g2 g3 g4 : Dst Γ .ptr}
    {k mask r19 h0 h1 h2 h3 h4 a0 d0 a1 d1 a2 d2 a3 d3 a4 d4 : Dst Γ Ty4x64} {rest : List (Instr Γ)}
    {X : Quad5} {P Z0 Z1 Z2 Z3 Z4 : Pointer} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        geAddEndRun c0 c1 c2 c3 e0 e1 e2 e3 x0 x1 x2 x3 x4 tb0 tb1 tb2 tb3 tb4 ta0 ta1 ta2 ta3 ta4
            z0 z1 z2 z3 z4 p q0 q1 g1 q2 g2 q3 g3 q4 g4 k mask r19 h0 h1 h2 h3 h4 a0 d0 a1 d1 a2 d2
            a3 d3 a4 d4 ++
          rest)
    (hR :
      E ⊨ [c0 := laneImm 0, c1 := laneImm 3, c2 := laneImm 3, c3 := laneImm 0, e0 := laneImm 2,
        e1 := laneImm 1, e2 := laneImm 2, e3 := laneImm 1, x0 := X.P0, x1 := X.P1, x2 := X.P2, x3 :=
        X.P3, x4 := X.P4, z0 := Z0, z1 := Z1, z2 := Z2, z3 := Z3, z4 := Z4, p := P, k :=
        (Vector.replicate 4 51#64 : Wl), mask := (Vector.replicate 4 2251799813685247#64 : Wl),
        r19 := (Vector.replicate 4 19#64 : Wl)])
    (hwf : S.WF) (hP : S.mem.Quad5Room P)
    (hZ :
      InBounds S.mem Z0 256 ∧
        InBounds S.mem Z1 256 ∧
        InBounds S.mem Z2 256 ∧ InBounds S.mem Z3 256 ∧ InBounds S.mem Z4 256)
    (hPZ : P.id ≠ Z0.id ∧ P.id ≠ Z1.id ∧ P.id ≠ Z2.id ∧ P.id ≠ Z3.id ∧ P.id ≠ Z4.id)
    (hne :
      Z1.id ≠ Z0.id ∧
        Z2.id ≠ Z0.id ∧
        Z3.id ≠ Z0.id ∧
        Z4.id ≠ Z0.id ∧
        Z2.id ≠ Z1.id ∧
        Z3.id ≠ Z1.id ∧ Z4.id ≠ Z1.id ∧ Z3.id ≠ Z2.id ∧ Z4.id ≠ Z2.id ∧ Z4.id ≠ Z3.id)
    (hp : p ≠ .val g1.i g1.h ∧ p ≠ .val g2.i g2.h ∧ p ≠ .val g3.i g3.h ∧ p ≠ .val g4.i g4.h)
    (hd :
      [x0.i, x1.i, x2.i, x3.i, x4.i, tb0.i, tb1.i, tb2.i, tb3.i, tb4.i, ta0.i, ta1.i, ta2.i, ta3.i,
          ta4.i, q0.i, q1.i, q2.i, q3.i, q4.i, k.i, mask.i, r19.i].Nodup)
    (hdb : [x0.i, x1.i, x2.i, x3.i, x4.i, tb0.i, tb1.i, tb2.i, tb3.i].Nodup)
    (hda : [x0.i, x1.i, x2.i, x3.i, x4.i, ta0.i, ta1.i, ta2.i, ta3.i].Nodup)
    (hdz : [z0.i, z1.i, z2.i, z3.i, z4.i, g1.i, g2.i, g3.i, g4.i].Nodup)
    (hdr :
      [q0.i, q1.i, q2.i, q3.i, q4.i, k.i, mask.i, r19.i, h0.i, h1.i, h2.i, h3.i, h4.i, a0.i, d0.i,
          a1.i, d1.i, a2.i, d2.i, a3.i, d3.i, a4.i].Nodup)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = E.args →
          (blk.runBodyFrom E' (pos + 50)
                { alloc := ⟨S.alloc.nextFreeBlock + 10⟩,
                  mem :=
                    (S.mem.callTmp5 Z0 Z1 Z2 Z3 Z4
                          (fd_r52x5_quad_mul_fast.spec (X.permute 0 3 3 0)
                            (X.permute 2 1 2 1))).storeQuad5
                      P
                      (fd_r52x5_quad_mul_fast.spec (X.permute 0 3 3 0)
                          (X.permute 2 1 2 1)).reduce } >>=
              g) =
            K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hz0, hz1, hz2, hz3, hz4⟩ := hZ
  obtain ⟨h10, h20, h30, h40, h21, h31, h41, h32, h42, h43⟩ := hne
  obtain ⟨hP0, hP1, hP2, hP3, hP4⟩ := hPZ
  obtain ⟨hp1, hp2, hp3, hp4⟩ := hp
  step_pattern using runBodyFrom_permuteRun 0 3 3 0 inline
  step_pattern using runBodyFrom_permuteRun 2 1 2 1 inline
  step_pattern using runBodyFrom_qpMulGepRun inline
  step_pattern using runBodyFrom_reduceStoreRun inline
  rw [hS]
  exact
    hK E
      (by
        rw [hE]; simp only [Env.write_args])

end

end MLIR.Firedancer.R52x5
