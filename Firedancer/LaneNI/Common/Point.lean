module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.QuadOps
public import Firedancer.LaneNI.fd_r43x6_quad_mul_fast
public import Firedancer.LaneNI.fd_r43x6_quad_sqr_fast

/-! The `FD_R43X6_QUAD_*` patterns that call `fd_r43x6_quad_mul_fast` and `fd_r43x6_quad_sqr_fast`,
over this build's functions. -/

namespace MLIR.Firedancer.LaneNI

@[expose] public section

open Firedancer.Avx512 Memory

section Patterns

attribute [-mlir_operation] zipWith_eq_ofFn

attribute [local mlir_operation] zipWith_shl_wrap

/-- `FD_R43X6_QUAD_MUL_FAST( q, x, y )` as compiled: `fd_r43x6_quad_mul_fast` into the slots
`z0 z1 z2`, then loaded into `q03 q14 q25`. -/
def mulRunNI (z0 z1 z2 : Dst Γ .ptr) (x03 x14 x25 y03 y14 y25 q03 q14 q25 : Dst Γ (.vec 8 64)) :
    List (Instr Γ) :=
  [.lifetimeStart (.val z0.i z0.h) 64, .lifetimeStart (.val z1.i z1.h) 64,
    .lifetimeStart (.val z2.i z2.h) 64,
    .call Firedancer.LaneNI.Mlir.fd_r43x6_quad_mul_fast.call
      (.cons (.val z0.i z0.h)
        (.cons (.val z1.i z1.h)
          (.cons (.val z2.i z2.h)
            (.cons (.val x03.i x03.h)
              (.cons (.val x14.i x14.h)
                (.cons (.val x25.i x25.h)
                  (.cons (.val y03.i y03.h)
                    (.cons (.val y14.i y14.h) (.cons (.val y25.i y25.h) .nil)))))))))
      .nil,
    .load q03 (.val z0.i z0.h), .load q14 (.val z1.i z1.h), .load q25 (.val z2.i z2.h),
    .lifetimeEnd (.val z2.i z2.h) 64, .lifetimeEnd (.val z1.i z1.h) 64,
    .lifetimeEnd (.val z0.i z0.h) 64]

/-- Where the body at `pos` is `mulRunNI`, `x03 x14 x25` hold `X`, `y03 y14 y25` hold `Y` and
`z0 z1 z2` three distinct writable slots: running on from `pos` then `g` gives `K` if it does from
`pos + 10` with `quadMul X Y` (as `m03 m14 m25`) in `q03 q14 q25` and left in the slots. -/
theorem runBodyFrom_mulRunNI {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {z0 z1 z2 : Dst Γ .ptr} {x03 x14 x25 y03 y14 y25 q03 q14 q25 : Dst Γ (.vec 8 64)}
    {rest : List (Instr Γ)} {X03 X14 X25 Y03 Y14 Y25 : Wwl} {Z0 Z1 Z2 : Pointer} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = mulRunNI z0 z1 z2 x03 x14 x25 y03 y14 y25 q03 q14 q25 ++ rest)
    (hR :
      E ⊨ [x03 := X03, x14 := X14, x25 := X25, y03 := Y03, y14 := Y14, y25 := Y25, z0 := Z0, z1 :=
        Z1, z2 := Z2])
    (hwf : S.WF) (hZ : InBounds S.mem Z0 512 ∧ InBounds S.mem Z1 512 ∧ InBounds S.mem Z2 512)
    (hZw : Writable S.mem Z0 ∧ Writable S.mem Z1 ∧ Writable S.mem Z2)
    (hne : Z0.id ≠ Z1.id ∧ Z0.id ≠ Z2.id ∧ Z1.id ≠ Z2.id)
    (hK :
      ∀ (m03 m14 m25 : Wwl) (_hm : quadMul ⟨X03, X14, X25⟩ ⟨Y03, Y14, Y25⟩ = ⟨m03, m14, m25⟩),
        (blk.runBodyFrom E[q03 := Ty.wrap m03, q14 := Ty.wrap m14, q25 := Ty.wrap m25] (pos + 10)
              { alloc := S.alloc,
                mem :=
                  ((((((((S.mem.lifetimeStart Z0).lifetimeStart Z1).lifetimeStart Z2).storeVec Z0
                                        m03).storeVec
                                    Z1 m14).storeVec
                                Z2 m25).lifetimeEnd
                            Z2).lifetimeEnd
                        Z1).lifetimeEnd
                    Z0 } >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hz0, hz1, hz2⟩ := hZ
  obtain ⟨hw0, hw1, hw2⟩ := hZw
  obtain ⟨h01, h02, h12⟩ := hne
  iterate 3 step_pure
  step_call using Firedancer.LaneNI.Mlir.fd_r43x6_quad_mul_fast.call_eq
  step_load with qm03
  step_load with qm14
  step_load with qm25
  iterate 3 step_pure
  have e : quadMul ⟨X03, X14, X25⟩ ⟨Y03, Y14, Y25⟩ = ⟨qm03, qm14, qm25⟩ := by
    rw [hqm03, hqm14, hqm25]
    rfl
  rw [hE, hS, ← hqm03, ← hqm14, ← hqm25]
  exact hK _ _ _ e

/-- `FD_R43X6_QUAD_SQR_FAST( q, x )` as compiled: `fd_r43x6_quad_sqr_fast` into the slots
`z0 z1 z2`, then loaded into `q03 q14 q25`. -/
def sqrRunNI (z0 z1 z2 : Dst Γ .ptr) (x03 x14 x25 q03 q14 q25 : Dst Γ (.vec 8 64)) :
    List (Instr Γ) :=
  [.lifetimeStart (.val z0.i z0.h) 64, .lifetimeStart (.val z1.i z1.h) 64,
    .lifetimeStart (.val z2.i z2.h) 64,
    .call Firedancer.LaneNI.Mlir.fd_r43x6_quad_sqr_fast.call
      (.cons (.val z0.i z0.h)
        (.cons (.val z1.i z1.h)
          (.cons (.val z2.i z2.h)
            (.cons (.val x03.i x03.h) (.cons (.val x14.i x14.h) (.cons (.val x25.i x25.h) .nil))))))
      .nil,
    .load q03 (.val z0.i z0.h), .load q14 (.val z1.i z1.h), .load q25 (.val z2.i z2.h),
    .lifetimeEnd (.val z2.i z2.h) 64, .lifetimeEnd (.val z1.i z1.h) 64,
    .lifetimeEnd (.val z0.i z0.h) 64]

/-- Where the body at `pos` is `sqrRunNI`, `x03 x14 x25` hold `X` and `z0 z1 z2` three distinct
writable slots: running on from `pos` then `g` gives `K` if it does from `pos + 10` with
`quadSqr X` (as `m03 m14 m25`) in `q03 q14 q25` and left in the slots. -/
theorem runBodyFrom_sqrRunNI {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {z0 z1 z2 : Dst Γ .ptr} {x03 x14 x25 q03 q14 q25 : Dst Γ (.vec 8 64)} {rest : List (Instr Γ)}
    {X03 X14 X25 : Wwl} {Z0 Z1 Z2 : Pointer} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} (hbody : blk.body.drop pos = sqrRunNI z0 z1 z2 x03 x14 x25 q03 q14 q25 ++ rest)
    (hR : E ⊨ [x03 := X03, x14 := X14, x25 := X25, z0 := Z0, z1 := Z1, z2 := Z2]) (hwf : S.WF)
    (hZ : InBounds S.mem Z0 512 ∧ InBounds S.mem Z1 512 ∧ InBounds S.mem Z2 512)
    (hZw : Writable S.mem Z0 ∧ Writable S.mem Z1 ∧ Writable S.mem Z2)
    (hne : Z0.id ≠ Z1.id ∧ Z0.id ≠ Z2.id ∧ Z1.id ≠ Z2.id)
    (hK :
      ∀ (m03 m14 m25 : Wwl) (_hm : quadSqr ⟨X03, X14, X25⟩ = ⟨m03, m14, m25⟩),
        (blk.runBodyFrom E[q03 := Ty.wrap m03, q14 := Ty.wrap m14, q25 := Ty.wrap m25] (pos + 10)
              { alloc := S.alloc,
                mem :=
                  ((((((((S.mem.lifetimeStart Z0).lifetimeStart Z1).lifetimeStart Z2).storeVec Z0
                                        m03).storeVec
                                    Z1 m14).storeVec
                                Z2 m25).lifetimeEnd
                            Z2).lifetimeEnd
                        Z1).lifetimeEnd
                    Z0 } >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hz0, hz1, hz2⟩ := hZ
  obtain ⟨hw0, hw1, hw2⟩ := hZw
  obtain ⟨h01, h02, h12⟩ := hne
  iterate 3 step_pure
  step_call using Firedancer.LaneNI.Mlir.fd_r43x6_quad_sqr_fast.call_eq
  step_load with qm03
  step_load with qm14
  step_load with qm25
  iterate 3 step_pure
  have e : quadSqr ⟨X03, X14, X25⟩ = ⟨qm03, qm14, qm25⟩ := by
    rw [hqm03, hqm14, hqm25]
    rfl
  rw [hE, hS, ← hqm03, ← hqm14, ← hqm25]
  exact hK _ _ _ e

/-- `FD_R43X6_GE_DBL` as compiled from `QUAD_SQR_FAST( _ta, _ta )` (`_ta` in `t03 t14 t25`,
squared through the slots `z0 z1 z2`) to `QUAD_MUL_FAST( _ta, _ta, _tb )` (through `z3 z4 z5`, into
`g03 g14 g25`): `s0010` holds the doubling's shifts, `pz` an unused operand, `k32 … k77` the lane
subtractions' `p` limbs, `nb03 … mk4340` the signed fold's constants. -/
def dblMidRunNI (z0 z1 z2 z3 z4 z5 : Dst Γ .ptr)
    (t03 t14 t25 s0010 pz k32 k41 k50 k59 k68 k77 : Dst Γ (.vec 8 64))
    (nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 : Dst Γ (.vec 8 64))
    (q03 q14 q25 c03 c14 c25 pa03 pa14 pa25 pb03 pb14 pb25 : Dst Γ (.vec 8 64))
    (ua03 ua14 ua25 va03 vb03 v03 va14 vb14 v14 va25 vb25 v25 : Dst Γ (.vec 8 64))
    (wa03 w03 wa14 w14 wa25 w25 : Dst Γ (.vec 8 64))
    (ya03 yb03 y03 ya14 yb14 y14 ya25 yb25 y25 : Dst Γ (.vec 8 64))
    (fd03 fd14 fd25 fh03 fh14 fh25 fp fl03 fc fe03 f03 fl14 fe14 f14 fl25 fe25 f25 :
      Dst Γ (.vec 8 64))
    (ma03 ma14 ma25 mb03 mb14 mb25 g03 g14 g25 : Dst Γ (.vec 8 64)) : List (Instr Γ) :=
  sqrRunNI z0 z1 z2 t03 t14 t25 q03 q14 q25 ++
    [.binop (.vector (.shl {})) c03 (.val q03.i q03.h) (.val s0010.i s0010.h),
      .binop (.vector (.shl {})) c14 (.val q14.i q14.h) (.val s0010.i s0010.h),
      .binop (.vector (.shl {})) c25 (.val q25.i q25.h) (.val s0010.i s0010.h)] ++
    permuteRun (permMask 3 3 3 3) c03 c14 c25 pz pa03 pa14 pa25 ++
    permuteRun (permMask 1 1 1 1) c03 c14 c25 pz pb03 pb14 pb25 ++
    laneAddSubRun (selMask 0 1 1 0) pa03 pa14 pa25 pb03 pb14 pb25 k32 k41 k50 ua03 ua14 ua25 va03
      vb03 v03 va14 vb14 v14 va25 vb25 v25 ++
    laneAddRun (selMask 0 0 1 0) {} {} {} v03 v14 v25 c03 c14 c25 wa03 w03 wa14 w14 wa25 w25 ++
    laneSubRun (selMask 0 1 1 1) {} {} w03 w14 w25 c03 c14 c25 k59 k68 k77 ya03 yb03 y03 ya14 yb14
      y14 ya25 yb25 y25 ++
    foldSignedRun y03 y14 y25 nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 fd03 fd14 fd25 fh03 fh14
      fh25 fp fl03 fc fe03 f03 fl14 fe14 f14 fl25 fe25 f25 ++
    permuteRun (permMask 0 1 1 0) f03 f14 f25 pz ma03 ma14 ma25 ++
    permuteRun (permMask 2 3 2 3) f03 f14 f25 pz mb03 mb14 mb25 ++
    mulRunNI z3 z4 z5 ma03 ma14 ma25 mb03 mb14 mb25 g03 g14 g25

-- 79 instructions through ten nested patterns, two calls
set_option maxHeartbeats 600000 in
/-- Where the body at `pos` is `dblMidRunNI`, `t03 t14 t25` hold `T`, `z0 … z5` six distinct slots
and the others the constants: running on from `pos` then `g` gives `K` if it does from `pos + 79`
with `geDblMid quadMul quadSqr T` (as `d03 d14 d25`) in `g03 g14 g25`, the square (as
`s03 s14 s25`) and the result left in the slots. -/
theorem runBodyFrom_dblMidRunNI {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {z0 z1 z2 z3 z4 z5 : Dst Γ .ptr}
    {t03 t14 t25 s0010 pz k32 k41 k50 k59 k68 k77 : Dst Γ (.vec 8 64)}
    {nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 : Dst Γ (.vec 8 64)}
    {q03 q14 q25 c03 c14 c25 pa03 pa14 pa25 pb03 pb14 pb25 : Dst Γ (.vec 8 64)}
    {ua03 ua14 ua25 va03 vb03 v03 va14 vb14 v14 va25 vb25 v25 : Dst Γ (.vec 8 64)}
    {wa03 w03 wa14 w14 wa25 w25 : Dst Γ (.vec 8 64)}
    {ya03 yb03 y03 ya14 yb14 y14 ya25 yb25 y25 : Dst Γ (.vec 8 64)}
    {fd03 fd14 fd25 fh03 fh14 fh25 fp fl03 fc fe03 f03 fl14 fe14 f14 fl25 fe25 f25 :
      Dst Γ (.vec 8 64)}
    {ma03 ma14 ma25 mb03 mb14 mb25 g03 g14 g25 : Dst Γ (.vec 8 64)}
    {rest : List (Instr Γ)} {T03 T14 T25 : Wwl} {Z0 Z1 Z2 Z3 Z4 Z5 : Pointer} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        dblMidRunNI z0 z1 z2 z3 z4 z5 t03 t14 t25 s0010 pz k32 k41 k50 k59 k68 k77 nb03 nb sh43
            sh4340 k19 mk43 b03 b mk4340 q03 q14 q25 c03 c14 c25 pa03 pa14 pa25 pb03 pb14 pb25 ua03
            ua14 ua25 va03 vb03 v03 va14 vb14 v14 va25 vb25 v25 wa03 w03 wa14 w14 wa25 w25 ya03
            yb03 y03 ya14 yb14 y14 ya25 yb25 y25 fd03 fd14 fd25 fh03 fh14 fh25 fp fl03 fc fe03 f03
            fl14 fe14 f14 fl25 fe25 f25 ma03 ma14 ma25 mb03 mb14 mb25 g03 g14 g25 ++ rest)
    (hR :
      E ⊨ [t03 := T03, t14 := T14, t25 := T25,
        s0010 := #v[0#64, 0#64, 1#64, 0#64, 0#64, 0#64, 1#64, 0#64], z0 := Z0, z1 := Z1,
        z2 := Z2, z3 := Z3, z4 := Z4, z5 := Z5])
    (hk :
      E.read (.val k32.i k32.h) = selPoison 0 1 1 0 quadP.P03 ∧
        E.read (.val k41.i k41.h) = selPoison 0 1 1 0 quadP.P14 ∧
        E.read (.val k50.i k50.h) = selPoison 0 1 1 0 quadP.P25 ∧
        E.read (.val k59.i k59.h) = selPoison 1 0 0 0 quadP.P03 ∧
        E.read (.val k68.i k68.h) = selPoison 1 0 0 0 quadP.P14 ∧
        E.read (.val k77.i k77.h) = selPoison 1 0 0 0 quadP.P25)
    (hC : FoldSignedConsts E nb03 nb sh43 sh4340 mk43 b03 b mk4340)
    (hk19 : E.read (.val k19.i k19.h) = k19Lanes)
    (hwf : S.WF)
    (hZ :
      InBounds S.mem Z0 512 ∧ InBounds S.mem Z1 512 ∧ InBounds S.mem Z2 512 ∧
        InBounds S.mem Z3 512 ∧ InBounds S.mem Z4 512 ∧ InBounds S.mem Z5 512)
    (hZw :
      Writable S.mem Z0 ∧ Writable S.mem Z1 ∧ Writable S.mem Z2 ∧ Writable S.mem Z3 ∧
        Writable S.mem Z4 ∧ Writable S.mem Z5)
    (hne :
      Z0.id ≠ Z1.id ∧ Z0.id ≠ Z2.id ∧ Z1.id ≠ Z2.id ∧ Z3.id ≠ Z4.id ∧ Z3.id ≠ Z5.id ∧
        Z4.id ≠ Z5.id)
    (hd :
      [z0.i, z1.i, z2.i, z3.i, z4.i, z5.i, t03.i, t14.i, t25.i, s0010.i, pz.i, k32.i, k41.i, k50.i,
          k59.i, k68.i, k77.i, nb03.i, nb.i, sh43.i, sh4340.i, k19.i, mk43.i, b03.i, b.i, mk4340.i,
          q03.i, q14.i, q25.i, c03.i, c14.i, c25.i, pa03.i, pa14.i, pa25.i, pb03.i, pb14.i, pb25.i,
          ua03.i, ua14.i, ua25.i, va03.i, vb03.i, v03.i, va14.i, vb14.i,
          v14.i, va25.i, vb25.i, v25.i, wa03.i, w03.i, wa14.i, w14.i, wa25.i, w25.i, ya03.i,
          yb03.i, y03.i, ya14.i, yb14.i, y14.i, ya25.i, yb25.i, y25.i, fd03.i, fd14.i, fd25.i,
          fh03.i, fh14.i, fh25.i, fp.i, fl03.i, fc.i, fe03.i, f03.i, fl14.i, fe14.i, f14.i, fl25.i,
          fe25.i, f25.i, ma03.i, ma14.i, ma25.i, mb03.i, mb14.i, mb25.i, g03.i, g14.i].Nodup)
    (hd1 : [c03.i, c14.i, c25.i, pa03.i, pa14.i].Nodup)
    (hd2 : [c03.i, c14.i, c25.i, pb03.i, pb14.i].Nodup)
    (hd3 :
      [pa03.i, pa14.i, pa25.i, pb03.i, pb14.i, pb25.i, k32.i, k41.i, k50.i, ua03.i, ua14.i, ua25.i,
          va03.i, vb03.i, v03.i, va14.i, vb14.i, v14.i, va25.i, vb25.i].Nodup)
    (hd5 : [v03.i, v14.i, v25.i, c03.i, c14.i, c25.i, wa03.i, w03.i, wa14.i, w14.i, wa25.i].Nodup)
    (hd6 :
      [w03.i, w14.i, w25.i, c03.i, c14.i, c25.i, k59.i, k68.i, k77.i, ya03.i, yb03.i, y03.i,
          ya14.i, yb14.i, y14.i, ya25.i, yb25.i].Nodup)
    (hd7 :
      [y03.i, y14.i, y25.i, nb03.i, nb.i, sh43.i, sh4340.i, k19.i, mk43.i, b03.i, b.i, mk4340.i,
          fd03.i, fd14.i, fd25.i, fh03.i, fh14.i, fh25.i, fp.i, fl03.i, fc.i, fe03.i, f03.i, fl14.i,
          fe14.i, f14.i, fl25.i, fe25.i].Nodup)
    (hd8 : [f03.i, f14.i, f25.i, ma03.i, ma14.i].Nodup)
    (hd9 : [f03.i, f14.i, f25.i, mb03.i, mb14.i].Nodup)
    (hK :
      ∀ (vq03 vq14 vq25 vc03 vc14 vc25 vpa03 vpa14 vpa25 vpb03 vpb14 vpb25 : ⟦.vec 8 64⟧)
        (vua03 vua14 vua25 vva03 vvb03 vv03 vva14 vvb14 vv14 : ⟦.vec 8 64⟧)
        (vva25 vvb25 vv25 vwa03 vw03 vwa14 vw14 vwa25 vw25 : ⟦.vec 8 64⟧)
        (vya03 vyb03 vy03 vya14 vyb14 vy14 vya25 vyb25 vy25 : ⟦.vec 8 64⟧)
        (vfd03 vfd14 vfd25 vfh03 vfh14 vfh25 vfp vfl03 vfc vfe03 vf03 vfl14 : ⟦.vec 8 64⟧)
        (vfe14 vf14 vfl25 vfe25 vf25 vma03 vma14 vma25 vmb03 vmb14 vmb25 : ⟦.vec 8 64⟧)
        (s03 s14 s25 : Wwl) (_hsq : quadSqr ⟨T03, T14, T25⟩ = ⟨s03, s14, s25⟩) (d03 d14 d25 : Wwl)
        (_hdbl : geDblMid quadMul quadSqr ⟨T03, T14, T25⟩ = ⟨d03, d14, d25⟩),
        (blk.runBodyFrom
              E[q03 := vq03, q14 := vq14, q25 := vq25, c03 := vc03, c14 := vc14, c25 := vc25,
                pa03 := vpa03, pa14 := vpa14, pa25 := vpa25, pb03 := vpb03, pb14 := vpb14,
                pb25 := vpb25, ua03 := vua03, ua14 := vua14, ua25 := vua25, va03 := vva03,
                vb03 := vvb03, v03 := vv03,
                va14 := vva14, vb14 := vvb14, v14 := vv14, va25 := vva25, vb25 := vvb25,
                v25 := vv25, wa03 := vwa03, w03 := vw03, wa14 := vwa14, w14 := vw14,
                wa25 := vwa25, w25 := vw25, ya03 := vya03, yb03 := vyb03, y03 := vy03,
                ya14 := vya14, yb14 := vyb14, y14 := vy14, ya25 := vya25, yb25 := vyb25,
                y25 := vy25, fd03 := vfd03, fd14 := vfd14, fd25 := vfd25, fh03 := vfh03,
                fh14 := vfh14, fh25 := vfh25, fp := vfp, fl03 := vfl03, fc := vfc, fe03 := vfe03,
                f03 := vf03, fl14 := vfl14, fe14 := vfe14, f14 := vf14, fl25 := vfl25,
                fe25 := vfe25, f25 := vf25, ma03 := vma03, ma14 := vma14, ma25 := vma25,
                mb03 := vmb03, mb14 := vmb14, mb25 := vmb25, g03 := Ty.wrap d03,
                g14 := Ty.wrap d14, g25 := Ty.wrap d25]
              (pos + 79)
              { alloc := S.alloc,
                mem :=
                  (((((((((((((((((S.mem.lifetimeStart Z0).lifetimeStart Z1).lifetimeStart
                                                          Z2).storeVec Z0 s03).storeVec Z1
                                                    s14).storeVec Z2 s25).lifetimeEnd
                                              Z2).lifetimeEnd Z1).lifetimeEnd Z0).lifetimeStart
                                      Z3).lifetimeStart Z4).lifetimeStart Z5).storeVec Z3
                              d03).storeVec Z4 d14).storeVec Z5 d25).lifetimeEnd Z5).lifetimeEnd
                      Z4).lifetimeEnd Z3 } >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hz0, hz1, hz2, hz3, hz4, hz5⟩ := hZ
  obtain ⟨hw0, hw1, hw2, hw3, hw4, hw5⟩ := hZw
  obtain ⟨h01, h02, h12, h34, h35, h45⟩ := hne
  -- FD_R43X6_QUAD_SQR_FAST( _ta, _ta )
  step_pattern using runBodyFrom_sqrRunNI
  have e3 := _hm
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _ta, _ta, 0,0,1,0, _ta, _ta ): `Z` doubled by a shift
  step_pure with c03
  step_pure with c14
  step_pure with c25
  have e4 :
      Quad.laneAddFast ⟨m03, m14, m25⟩ 0 0 1 0 ⟨m03, m14, m25⟩ ⟨m03, m14, m25⟩ =
        ⟨c03, c14, c25⟩ := by
    rw [Quad.laneAddFast_0010_self, hc03, hc14, hc25]
  -- FD_R43X6_QUAD_PERMUTE( _tb, 3,3,3,3, _ta ); FD_R43X6_QUAD_PERMUTE( _BB, 1,1,1,1, _ta )
  step_pattern using runBodyFrom_permuteRun 3 3 3 3
  have e5 := _hp
  step_pattern using runBodyFrom_permuteRun 1 1 1 1
  have e6 := _hp
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _tb, _tb, 1,0,0,1, _tb, _BB )
  -- FD_R43X6_QUAD_LANE_SUB_FAST( _tb, _tb, 0,1,1,0, _tb, _BB ), merged into one select
  step_pattern using runBodyFrom_laneAddSubRun
  have e7 := _hl
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _tb, _tb, 0,0,1,0, _tb, _ta )
  step_pattern using runBodyFrom_laneAddRun 0 0 1 0
  have e9 := _hl
  -- FD_R43X6_QUAD_LANE_SUB_FAST( _tb, _tb, 1,0,0,0, _tb, _ta )
  step_pattern using runBodyFrom_laneSubRun 1 0 0 0
  have e10 := _hl
  -- FD_R43X6_QUAD_FOLD_SIGNED( _tb, _tb )
  step_pattern using runBodyFrom_foldSignedRun
  have e11 := _hs
  -- FD_R43X6_QUAD_PERMUTE( _ta, 0,1,1,0, _tb ); FD_R43X6_QUAD_PERMUTE( _tb, 2,3,2,3, _tb )
  step_pattern using runBodyFrom_permuteRun 0 1 1 0
  have e12 := _hp
  step_pattern using runBodyFrom_permuteRun 2 3 2 3
  have e13 := _hp
  -- FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _tb )
  step_pattern using runBodyFrom_mulRunNI
  have e14 := _hm
  have e : geDblMid quadMul quadSqr ⟨T03, T14, T25⟩ = ⟨m03, m14, m25⟩ := by
    simp only [geDblMid, Quad.foldSigned_eq]
    rw [e3, e4, e5, e6, e7, e9, e10, e11, e12, e13, e14]
  rw [hE, hS]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ e3 _ _ _ e


end Patterns

end

end MLIR.Firedancer.LaneNI
