module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.Avx512.Mlir.fd_ed25519_partial_dbl
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace LeanMLIR.RIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `2 A` by `FD_R43X6_GE_DBL`. -/
def fd_ed25519_partial_dbl.spec (A : Quad) : Quad :=
  geDbl quadMul quadSqr A

end

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn

/-- `FD_R43X6_GE_DBL` as compiled from the squaring to the multiplication: `T` is `_ta` before
`QUAD_SQR_FAST`, the result `_ta` before the last fold. -/
@[expose] public def dblMid (T : Quad) : Quad :=
  let Q := quadSqr T
  let C : Quad :=
    ⟨wwl_shl_vector Q.P03 #v[0#64, 0#64, 1#64, 0#64, 0#64, 0#64, 1#64, 0#64],
      wwl_shl_vector Q.P14 #v[0#64, 0#64, 1#64, 0#64, 0#64, 0#64, 1#64, 0#64],
      wwl_shl_vector Q.P25 #v[0#64, 0#64, 1#64, 0#64, 0#64, 0#64, 1#64, 0#64]⟩
  let B := C.perm4 1 1 1 1
  let U := (C.perm4 3 3 3 3).addSel true false false true B
  let Y := ((U.subSel false true true false B).addSel false false true false C).subSel true false
    false false C
  let F := Y.foldSignedC
  quadMul (F.perm4 0 1 1 0) (F.perm4 2 3 2 3)

/-- A shuffle's lanes: `3 3 3 3 7 7 7 7`. -/
public abbrev mask3333 : Vector (Option (Fin 16)) 8 :=
  #v[some 3, some 3, some 3, some 3, some 7, some 7, some 7, some 7]

/-- A shuffle's lanes: `1 1 1 1 5 5 5 5`. -/
public abbrev mask1111 : Vector (Option (Fin 16)) 8 :=
  #v[some 1, some 1, some 1, some 1, some 5, some 5, some 5, some 5]

/-- A shuffle's lanes: the second operand's in coordinates 1 and 2. -/
public abbrev mask0110s : Vector (Option (Fin 16)) 8 :=
  #v[some 0, some 9, some 10, some 3, some 4, some 13, some 14, some 7]

/-- A shuffle's lanes: the second operand's in coordinate 2. -/
public abbrev mask0010s : Vector (Option (Fin 16)) 8 :=
  #v[some 0, some 1, some 10, some 3, some 4, some 5, some 14, some 7]

/-- A shuffle's lanes: the second operand's in coordinates 1 to 3. -/
public abbrev mask0111s : Vector (Option (Fin 16)) 8 :=
  #v[some 0, some 9, some 10, some 11, some 4, some 13, some 14, some 15]

/-- A shuffle's lanes: `0 1 1 0 4 5 5 4`. -/
public abbrev mask0110 : Vector (Option (Fin 16)) 8 :=
  #v[some 0, some 1, some 1, some 0, some 4, some 5, some 5, some 4]

/-- A shuffle's lanes: `2 3 2 3 6 7 6 7`. -/
public abbrev mask2323 : Vector (Option (Fin 16)) 8 :=
  #v[some 2, some 3, some 2, some 3, some 6, some 7, some 6, some 7]

/-- `FD_R43X6_GE_DBL` as compiled from `QUAD_SQR_FAST( _ta, _ta )` (`_ta` in `t03 t14 t25`, squared
through the slots `z0 z1 z2` into `q03 q14 q25`) to the loads after `QUAD_MUL_FAST( _ta, _ta, _tb )`
(through `z3 z4 z5`, into `g03 g14 g25`): `s0010` holds the doubling's shifts, `pz` an unused
operand, `k32 … k77` the lane subtractions' `p` limbs, the others the signed fold's constants.
-/
@[expose] public def dblRun (z0 z1 z2 z3 z4 z5 : Dst Γ .ptr)
    (t03 t14 t25 s0010 pz k32 k41 k50 k59 k68 k77 : Dst Γ (.vec 8 64))
    (nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 : Dst Γ (.vec 8 64))
    (q03 q14 q25 c03 c14 c25 pa03 pa14 pa25 pb03 pb14 pb25 : Dst Γ (.vec 8 64))
    (ua03 u03 ua14 u14 ua25 u25 va03 vb03 v03 va14 vb14 v14 va25 vb25 v25 : Dst Γ (.vec 8 64))
    (wa03 w03 wa14 w14 wa25 w25 : Dst Γ (.vec 8 64))
    (ya03 yb03 y03 ya14 yb14 y14 ya25 yb25 y25 : Dst Γ (.vec 8 64))
    (fd03 fd14 fd25 fh03 fh14 fh25 fp fl03 fc fe03 f03 fl14 fe14 f14 fl25 fe25 f25 :
      Dst Γ (.vec 8 64))
    (ma03 ma14 ma25 mb03 mb14 mb25 g03 g14 g25 : Dst Γ (.vec 8 64)) : List (Instr Γ) :=
  [.lifetimeStart (.val z0.i z0.h) 64, .lifetimeStart (.val z1.i z1.h) 64,
    .lifetimeStart (.val z2.i z2.h) 64,
    .call fd_r43x6_quad_sqr_fast.call
      (.cons (.val z0.i z0.h) (.cons (.val z1.i z1.h) (.cons (.val z2.i z2.h)
        (.cons (.val t03.i t03.h) (.cons (.val t14.i t14.h) (.cons (.val t25.i t25.h) .nil))))))
      .nil,
    .load q03 (.val z0.i z0.h), .load q14 (.val z1.i z1.h), .load q25 (.val z2.i z2.h),
    .lifetimeEnd (.val z2.i z2.h) 64, .lifetimeEnd (.val z1.i z1.h) 64,
    .lifetimeEnd (.val z0.i z0.h) 64,
    .binop (.vector (.shl {})) c03 (.val q03.i q03.h) (.val s0010.i s0010.h),
    .binop (.vector (.shl {})) c14 (.val q14.i q14.h) (.val s0010.i s0010.h),
    .binop (.vector (.shl {})) c25 (.val q25.i q25.h) (.val s0010.i s0010.h),
    .binop (.shufflevector mask3333) pa03 (.val c03.i c03.h) (.val pz.i pz.h),
    .binop (.shufflevector mask3333) pa14 (.val c14.i c14.h) (.val pz.i pz.h),
    .binop (.shufflevector mask3333) pa25 (.val c25.i c25.h) (.val pz.i pz.h),
    .binop (.shufflevector mask1111) pb03 (.val c03.i c03.h) (.val pz.i pz.h),
    .binop (.shufflevector mask1111) pb14 (.val c14.i c14.h) (.val pz.i pz.h),
    .binop (.shufflevector mask1111) pb25 (.val c25.i c25.h) (.val pz.i pz.h),
    .binop (.vector (.add {})) ua03 (.val pa03.i pa03.h) (.val pb03.i pb03.h),
    .binop (.shufflevector mask0110s) u03 (.val ua03.i ua03.h) (.val pa03.i pa03.h),
    .binop (.vector (.add {})) ua14 (.val pa14.i pa14.h) (.val pb14.i pb14.h),
    .binop (.shufflevector mask0110s) u14 (.val ua14.i ua14.h) (.val pa14.i pa14.h),
    .binop (.vector (.add {})) ua25 (.val pa25.i pa25.h) (.val pb25.i pb25.h),
    .binop (.shufflevector mask0110s) u25 (.val ua25.i ua25.h) (.val pa25.i pa25.h),
    .binop (.vector (.sub {})) va03 (.val u03.i u03.h) (.val pb03.i pb03.h),
    .binop (.vector (.add {})) vb03 (.val va03.i va03.h) (.val k32.i k32.h),
    .binop (.shufflevector mask0110s) v03 (.val u03.i u03.h) (.val vb03.i vb03.h),
    .binop (.vector (.sub {})) va14 (.val u14.i u14.h) (.val pb14.i pb14.h),
    .binop (.vector (.add {})) vb14 (.val va14.i va14.h) (.val k41.i k41.h),
    .binop (.shufflevector mask0110s) v14 (.val u14.i u14.h) (.val vb14.i vb14.h),
    .binop (.vector (.sub {})) va25 (.val u25.i u25.h) (.val pb25.i pb25.h),
    .binop (.vector (.add {})) vb25 (.val va25.i va25.h) (.val k50.i k50.h),
    .binop (.shufflevector mask0110s) v25 (.val u25.i u25.h) (.val vb25.i vb25.h),
    .binop (.vector (.add {})) wa03 (.val v03.i v03.h) (.val c03.i c03.h),
    .binop (.shufflevector mask0010s) w03 (.val v03.i v03.h) (.val wa03.i wa03.h),
    .binop (.vector (.add {})) wa14 (.val v14.i v14.h) (.val c14.i c14.h),
    .binop (.shufflevector mask0010s) w14 (.val v14.i v14.h) (.val wa14.i wa14.h),
    .binop (.vector (.add {})) wa25 (.val v25.i v25.h) (.val c25.i c25.h),
    .binop (.shufflevector mask0010s) w25 (.val v25.i v25.h) (.val wa25.i wa25.h),
    .binop (.vector (.sub {})) ya03 (.val w03.i w03.h) (.val c03.i c03.h),
    .binop (.vector (.add {})) yb03 (.val ya03.i ya03.h) (.val k59.i k59.h),
    .binop (.shufflevector mask0111s) y03 (.val yb03.i yb03.h) (.val w03.i w03.h),
    .binop (.vector (.sub {})) ya14 (.val w14.i w14.h) (.val c14.i c14.h),
    .binop (.vector (.add {})) yb14 (.val ya14.i ya14.h) (.val k68.i k68.h),
    .binop (.shufflevector mask0111s) y14 (.val yb14.i yb14.h) (.val w14.i w14.h),
    .binop (.vector (.sub {})) ya25 (.val w25.i w25.h) (.val c25.i c25.h),
    .binop (.vector (.add {})) yb25 (.val ya25.i ya25.h) (.val k77.i k77.h),
    .binop (.shufflevector mask0111s) y25 (.val yb25.i yb25.h) (.val w25.i w25.h)] ++
    foldSignedRun y03 y14 y25 nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 fd03 fd14 fd25 fh03 fh14
      fh25 fp fl03 fc fe03 f03 fl14 fe14 f14 fl25 fe25 f25 ++
    [.binop (.shufflevector mask0110) ma03 (.val f03.i f03.h) (.val pz.i pz.h),
      .binop (.shufflevector mask0110) ma14 (.val f14.i f14.h) (.val pz.i pz.h),
      .binop (.shufflevector mask0110) ma25 (.val f25.i f25.h) (.val pz.i pz.h),
      .binop (.shufflevector mask2323) mb03 (.val f03.i f03.h) (.val pz.i pz.h),
      .binop (.shufflevector mask2323) mb14 (.val f14.i f14.h) (.val pz.i pz.h),
      .binop (.shufflevector mask2323) mb25 (.val f25.i f25.h) (.val pz.i pz.h),
      .lifetimeStart (.val z3.i z3.h) 64, .lifetimeStart (.val z4.i z4.h) 64,
      .lifetimeStart (.val z5.i z5.h) 64,
      .call fd_r43x6_quad_mul_fast.call
        (.cons (.val z3.i z3.h) (.cons (.val z4.i z4.h) (.cons (.val z5.i z5.h)
          (.cons (.val ma03.i ma03.h) (.cons (.val ma14.i ma14.h) (.cons (.val ma25.i ma25.h)
            (.cons (.val mb03.i mb03.h) (.cons (.val mb14.i mb14.h) (.cons (.val mb25.i mb25.h)
              .nil)))))))))
        .nil,
      .load g03 (.val z3.i z3.h), .load g14 (.val z4.i z4.h), .load g25 (.val z5.i z5.h),
      .lifetimeEnd (.val z5.i z5.h) 64, .lifetimeEnd (.val z4.i z4.h) 64,
      .lifetimeEnd (.val z3.i z3.h) 64]

-- 82 instructions, two calls
set_option maxHeartbeats 600000 in
/-- Where the body at `pos` is `dblRun`, `t03 t14 t25` hold `T`, `z0 … z5` six distinct slots and
the others the constants (`k32 … k77` the lane subtractions' `p` limbs, for `0,1,1,0` in coordinates
1 and 2, for `1,0,0,0` in coordinate 0): running on from `pos` then `g` gives `K` if it does from
`pos + 82` with `dblMid T` (as `d03 d14 d25`) in `g03 g14 g25`, the square and `dblMid T` left in
the slots, whatever the intermediates hold. -/
public theorem runBodyFrom_dblRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {z0 z1 z2 z3 z4 z5 : Dst Γ .ptr}
    {t03 t14 t25 s0010 pz k32 k41 k50 k59 k68 k77 : Dst Γ (.vec 8 64)}
    {nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 : Dst Γ (.vec 8 64)}
    {q03 q14 q25 c03 c14 c25 pa03 pa14 pa25 pb03 pb14 pb25 : Dst Γ (.vec 8 64)}
    {ua03 u03 ua14 u14 ua25 u25 va03 vb03 v03 va14 vb14 v14 va25 vb25 v25 : Dst Γ (.vec 8 64)}
    {wa03 w03 wa14 w14 wa25 w25 : Dst Γ (.vec 8 64)}
    {ya03 yb03 y03 ya14 yb14 y14 ya25 yb25 y25 : Dst Γ (.vec 8 64)}
    {fd03 fd14 fd25 fh03 fh14 fh25 fp fl03 fc fe03 f03 fl14 fe14 f14 fl25 fe25 f25 :
      Dst Γ (.vec 8 64)}
    {ma03 ma14 ma25 mb03 mb14 mb25 g03 g14 g25 : Dst Γ (.vec 8 64)}
    {rest : List (Instr Γ)} {T03 T14 T25 : Wwl} {Z0 Z1 Z2 Z3 Z4 Z5 : Pointer} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        dblRun z0 z1 z2 z3 z4 z5 t03 t14 t25 s0010 pz k32 k41 k50 k59 k68 k77 nb03 nb sh43 sh4340
            k19 mk43 b03 b mk4340 q03 q14 q25 c03 c14 c25 pa03 pa14 pa25 pb03 pb14 pb25 ua03 u03
            ua14 u14 ua25 u25 va03 vb03 v03 va14 vb14 v14 va25 vb25 v25 wa03 w03 wa14 w14 wa25 w25
            ya03 yb03 y03 ya14 yb14 y14 ya25 yb25 y25 fd03 fd14 fd25 fh03 fh14 fh25 fp fl03 fc fe03
            f03 fl14 fe14 f14 fl25 fe25 f25 ma03 ma14 ma25 mb03 mb14 mb25 g03 g14 g25 ++
          rest)
    (hR :
      E ⊨ [t03 := T03, t14 := T14, t25 := T25,
        s0010 := #v[0#64, 0#64, 1#64, 0#64, 0#64, 0#64, 1#64, 0#64], z0 := Z0, z1 := Z1,
        z2 := Z2, z3 := Z3, z4 := Z4, z5 := Z5])
    (hk :
      E.read (.val k32.i k32.h) =
          #v[.poison, .value 8796093022189#64, .value 8796093022189#64, .poison, .poison,
            .value 8796093022207#64, .value 8796093022207#64, .poison] ∧
        E.read (.val k41.i k41.h) =
          #v[.poison, .value 8796093022207#64, .value 8796093022207#64, .poison, .poison,
            .value 8796093022207#64, .value 8796093022207#64, .poison] ∧
        E.read (.val k50.i k50.h) =
          #v[.poison, .value 8796093022207#64, .value 8796093022207#64, .poison, .poison,
            .value 1099511627775#64, .value 1099511627775#64, .poison] ∧
        E.read (.val k59.i k59.h) =
          #v[.value 8796093022189#64, .poison, .poison, .poison, .value 8796093022207#64,
            .poison, .poison, .poison] ∧
        E.read (.val k68.i k68.h) =
          #v[.value 8796093022207#64, .poison, .poison, .poison, .value 8796093022207#64,
            .poison, .poison, .poison] ∧
        E.read (.val k77.i k77.h) =
          #v[.value 8796093022207#64, .poison, .poison, .poison, .value 1099511627775#64,
            .poison, .poison, .poison])
    (hC :
      E ⊨ [nb03 := negBias03, nb := Vector.replicate 8 18446744073708503040#64,
        sh43 := Vector.replicate 8 43#64,
        sh4340 := #v[43#64, 43#64, 43#64, 43#64, 40#64, 40#64, 40#64, 40#64],
        mk43 := Vector.replicate 8 8796093022207#64, b03 := bias03,
        b := Vector.replicate 8 1048576#64,
        mk4340 := #v[8796093022207#64, 8796093022207#64, 8796093022207#64, 8796093022207#64,
          1099511627775#64, 1099511627775#64, 1099511627775#64, 1099511627775#64]])
    (hk19 : E.read (.val k19.i k19.h) = k19Lanes)
    (hwf : S.WF)
    (hZ :
      Fits S.mem Z0 512 ∧ Fits S.mem Z1 512 ∧ Fits S.mem Z2 512 ∧ Fits S.mem Z3 512 ∧
        Fits S.mem Z4 512 ∧ Fits S.mem Z5 512)
    (hne :
      Z0.id ≠ Z1.id ∧ Z0.id ≠ Z2.id ∧ Z1.id ≠ Z2.id ∧ Z3.id ≠ Z4.id ∧ Z3.id ≠ Z5.id ∧
        Z4.id ≠ Z5.id)
    (hd :
      [z0.i, z1.i, z2.i, z3.i, z4.i, z5.i, t03.i, t14.i, t25.i, s0010.i, pz.i, k32.i, k41.i, k50.i,
          k59.i, k68.i, k77.i, nb03.i, nb.i, sh43.i, sh4340.i, k19.i, mk43.i, b03.i, b.i, mk4340.i,
          q03.i, q14.i, q25.i, c03.i, c14.i, c25.i, pa03.i, pa14.i, pa25.i, pb03.i, pb14.i, pb25.i,
          ua03.i, u03.i, ua14.i, u14.i, ua25.i, u25.i, va03.i, vb03.i, v03.i, va14.i, vb14.i,
          v14.i, va25.i, vb25.i, v25.i, wa03.i, w03.i, wa14.i, w14.i, wa25.i, w25.i, ya03.i,
          yb03.i, y03.i, ya14.i, yb14.i, y14.i, ya25.i, yb25.i, y25.i, fd03.i, fd14.i, fd25.i,
          fh03.i, fh14.i, fh25.i, fp.i, fl03.i, fc.i, fe03.i, f03.i, fl14.i, fe14.i, f14.i, fl25.i,
          fe25.i, f25.i, ma03.i, ma14.i, ma25.i, mb03.i, mb14.i, mb25.i, g03.i, g14.i].Nodup)
    (hK :
      ∀ (vq03 vq14 vq25 vc03 vc14 vc25 vpa03 vpa14 vpa25 vpb03 vpb14 vpb25 : ⟦.vec 8 64⟧)
        (vua03 vu03 vua14 vu14 vua25 vu25 vva03 vvb03 vv03 vva14 vvb14 vv14 : ⟦.vec 8 64⟧)
        (vva25 vvb25 vv25 vwa03 vw03 vwa14 vw14 vwa25 vw25 : ⟦.vec 8 64⟧)
        (vya03 vyb03 vy03 vya14 vyb14 vy14 vya25 vyb25 vy25 : ⟦.vec 8 64⟧)
        (vfd03 vfd14 vfd25 vfh03 vfh14 vfh25 vfp vfl03 vfc vfe03 vf03 vfl14 : ⟦.vec 8 64⟧)
        (vfe14 vf14 vfl25 vfe25 vf25 vma03 vma14 vma25 vmb03 vmb14 vmb25 : ⟦.vec 8 64⟧)
        (d03 d14 d25 : Wwl) (_hdbl : dblMid ⟨T03, T14, T25⟩ = ⟨d03, d14, d25⟩),
        (blk.runBodyFrom
              E[q03 := vq03, q14 := vq14, q25 := vq25, c03 := vc03, c14 := vc14, c25 := vc25,
                pa03 := vpa03, pa14 := vpa14, pa25 := vpa25, pb03 := vpb03, pb14 := vpb14,
                pb25 := vpb25, ua03 := vua03, u03 := vu03, ua14 := vua14, u14 := vu14,
                ua25 := vua25, u25 := vu25, va03 := vva03, vb03 := vvb03, v03 := vv03,
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
              (pos + 82)
              { alloc := S.alloc,
                mem :=
                  (((((S.mem.storeVec Z0 (quadSqr ⟨T03, T14, T25⟩).P03).storeVec Z1
                              (quadSqr ⟨T03, T14, T25⟩).P14).storeVec Z2
                          (quadSqr ⟨T03, T14, T25⟩).P25).storeVec Z3 d03).storeVec Z4 d14).storeVec
                    Z5 d25 } >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hz0, hz1, hz2, hz3, hz4, hz5⟩ := hZ
  obtain ⟨h01, h02, h12, h34, h35, h45⟩ := hne
  obtain ⟨hk32, hk41, hk50, hk59, hk68, hk77⟩ := hk
  simp only [k19Lanes] at hk19
  -- FD_R43X6_QUAD_SQR_FAST( _ta, _ta )
  iterate 3 step_pure
  step_call using fd_r43x6_quad_sqr_fast.call_eq
  step_load with q03
  step_load with q14
  step_load with q25
  iterate 3 step_pure
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _ta, _ta, 0,0,1,0, _ta, _ta ): `Z` doubled
  step_pure [wrapZipWith] with tc03
  step_pure [wrapZipWith] with tc14
  step_pure [wrapZipWith] with tc25
  -- FD_R43X6_QUAD_PERMUTE( _tb, 3,3,3,3, _ta ); FD_R43X6_QUAD_PERMUTE( _BB, 1,1,1,1, _ta )
  step_pure with pa03
  step_pure with pa14
  step_pure with pa25
  step_pure with pb03
  step_pure with pb14
  step_pure with pb25
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _tb, _tb, 1,0,0,1, _tb, _BB )
  step_pure [wrapZipWith]
  step_pure with u03
  step_pure [wrapZipWith]
  step_pure with u14
  step_pure [wrapZipWith]
  step_pure with u25
  -- FD_R43X6_QUAD_LANE_SUB_FAST( _tb, _tb, 0,1,1,0, _tb, _BB )
  step_pure [wrapZipWith]
  step_pure [expandOfFn]
  step_pure with v03
  step_pure [wrapZipWith]
  step_pure [expandOfFn]
  step_pure with v14
  step_pure [wrapZipWith]
  step_pure [expandOfFn]
  step_pure with v25
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _tb, _tb, 0,0,1,0, _tb, _ta )
  step_pure [wrapZipWith]
  step_pure with w03
  step_pure [wrapZipWith]
  step_pure with w14
  step_pure [wrapZipWith]
  step_pure with w25
  -- FD_R43X6_QUAD_LANE_SUB_FAST( _tb, _tb, 1,0,0,0, _tb, _ta )
  step_pure [wrapZipWith]
  step_pure [expandOfFn]
  step_pure with y03
  step_pure [wrapZipWith]
  step_pure [expandOfFn]
  step_pure with y14
  step_pure [wrapZipWith]
  step_pure [expandOfFn]
  step_pure with y25
  -- FD_R43X6_QUAD_FOLD_SIGNED( _tb, _tb )
  step_pure [wrapZipWith] with sd03
  step_pure [wrapZipWith] with sd14
  step_pure [wrapZipWith] with sd25
  step_pure [wrapZipWith] with sh03
  step_pure [wrapZipWith] with sh14
  step_pure [wrapZipWith] with transparent sh25
  step_pure [expandOfFn, wwl_shr_vector] with transparent sp
  step_pure [wrapZipWith] with sl03
  step_pure with sc03
  have hsc03' : sc03 =
      wwl_pack_halves (wwl_mul (wwl_shr_vector sd25 s4340) (wwl_bcast 19#64)) 1
        (wwl_shr_vector sd25 s4340) 0 := by
    rw [hsc03]
    ext i hi : 1
    obtain _|_|_|_|_|_|_|_|i := i
    all_goals first | omega | wwl_lanes
  have hok03 := mask_add_bias03_ok sd03
  rw [← hsl03] at hok03
  step_pure [wrapZipWith] with se03
  step_pure [hsc03', wrapZipWith] with sf03
  step_pure [wrapZipWith] with sl14
  have hok14 := shr_add_bias_ok sd03 _ (.inl rfl)
  rw [← hsh03] at hok14
  step_pure [wrapZipWith] with se14
  have hok14' := shr_add_bias_add_mask_ok sd03 sd14 _ _ (.inl rfl) (.inl rfl)
  rw [← hsh03, ← hse14, ← hsl14] at hok14'
  step_pure [wrapZipWith] with sf14
  step_pure [wrapZipWith] with sl25
  have hok25 := shr_add_bias_ok sd14 _ (.inl rfl)
  rw [← hsh14] at hok25
  step_pure [wrapZipWith] with se25
  have hok25' := shr_add_bias_add_mask_ok sd14 sd25 _ _ (.inl rfl) (.inr rfl)
  rw [← hsh14, ← hse25, ← hsl25] at hok25'
  step_pure [wrapZipWith] with sf25
  -- FD_R43X6_QUAD_PERMUTE( _ta, 0,1,1,0, _tb ); FD_R43X6_QUAD_PERMUTE( _tb, 2,3,2,3, _tb )
  step_pure with ma03
  step_pure with ma14
  step_pure with ma25
  step_pure with mb03
  step_pure with mb14
  step_pure with mb25
  -- FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _tb )
  iterate 3 step_pure
  step_call using fd_r43x6_quad_mul_fast.call_eq
  step_load with g03
  step_load with g14
  step_load with g25
  iterate 3 step_pure
  -- `dblMid T`, stage by stage, as the values the code computed
  have e : dblMid ⟨T03, T14, T25⟩ = ⟨g03, g14, g25⟩ := by
    have dm2 : quadSqr ⟨T03, T14, T25⟩ = ⟨q03, q14, q25⟩ := by rw [hq03, hq14, hq25]; rfl
    have dm3 : (⟨wwl_shl_vector q03 #v[0#64, 0#64, 1#64, 0#64, 0#64, 0#64, 1#64, 0#64],
        wwl_shl_vector q14 #v[0#64, 0#64, 1#64, 0#64, 0#64, 0#64, 1#64, 0#64],
        wwl_shl_vector q25 #v[0#64, 0#64, 1#64, 0#64, 0#64, 0#64, 1#64, 0#64]⟩ : Quad) =
        ⟨tc03, tc14, tc25⟩ := by
      rw [htc03, htc14, htc25]
    have dm4 : Quad.perm4 3 3 3 3 ⟨tc03, tc14, tc25⟩ = ⟨pa03, pa14, pa25⟩ := by
      rw [hpa03, hpa14, hpa25]; rfl
    have dm5 : Quad.perm4 1 1 1 1 ⟨tc03, tc14, tc25⟩ = ⟨pb03, pb14, pb25⟩ := by
      rw [hpb03, hpb14, hpb25]; rfl
    have dm6 : Quad.addSel true false false true ⟨pa03, pa14, pa25⟩ ⟨pb03, pb14, pb25⟩ =
        ⟨u03, u14, u25⟩ := by
      rw [hu03, hu14, hu25]; rfl
    have dm7 : Quad.subSel false true true false ⟨u03, u14, u25⟩ ⟨pb03, pb14, pb25⟩ =
        ⟨v03, v14, v25⟩ := by
      rw [hv03, hv14, hv25]; rfl
    have dm8 : Quad.addSel false false true false ⟨v03, v14, v25⟩ ⟨tc03, tc14, tc25⟩ =
        ⟨w03, w14, w25⟩ := by
      rw [hw03, hw14, hw25]; rfl
    have dm9 : Quad.subSel true false false false ⟨w03, w14, w25⟩ ⟨tc03, tc14, tc25⟩ =
        ⟨y03, y14, y25⟩ := by
      rw [hy03, hy14, hy25]; rfl
    have dm10 : Quad.foldSignedC ⟨y03, y14, y25⟩ = ⟨sf03, sf14, sf25⟩ := by
      rw [hsf03, hsf14, hsf25, hse03, hse14, hse25, hsl03, hsl14, hsl25, hsh03, hsh14, hsd03,
        hsd14, hsd25]
      rfl
    have dm11 : Quad.perm4 0 1 1 0 ⟨sf03, sf14, sf25⟩ = ⟨ma03, ma14, ma25⟩ := by
      rw [hma03, hma14, hma25]; rfl
    have dm12 : Quad.perm4 2 3 2 3 ⟨sf03, sf14, sf25⟩ = ⟨mb03, mb14, mb25⟩ := by
      rw [hmb03, hmb14, hmb25]; rfl
    have dm13 : quadMul ⟨ma03, ma14, ma25⟩ ⟨mb03, mb14, mb25⟩ = ⟨g03, g14, g25⟩ := by
      rw [hg03, hg14, hg25]; rfl
    simp only [dblMid]
    rw [dm2]
    dsimp only
    rw [dm3, dm4, dm5, dm6, dm7, dm8, dm9, dm10, dm11, dm12, dm13]
  rw [hE, hS, ← hg03, ← hg14, ← hg25]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ e

/-- `FD_R43X6_GE_DBL` as compiled. -/
public theorem geDbl_eq (A : Quad) :
    geDbl quadMul quadSqr A =
      (dblMid ((A.perm4 1 1 2 0).addSel true false false false A)).foldUnsignedC := by
  simp only [geDbl, dblMid, Quad.permute_1120, Quad.permute_3333, Quad.permute_1111,
    Quad.permute_0110, Quad.permute_2323, Quad.laneAddFast_1000, Quad.laneAddFast_0010_self,
    Quad.laneAddFast_0010, Quad.laneAddFast_1001, Quad.laneSubFast_0110, Quad.laneSubFast_1000,
    Quad.foldSigned_eq, Quad.foldUnsigned_eq]

public theorem fd_ed25519_partial_dbl.call_eq (r a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.QuadFit r) (ha : s.mem.QuadFit a) :
    fd_ed25519_partial_dbl.call (fd_ed25519_partial_dbl.args (.value r) (.value a)) s =
      .value (.cons (.value r) .nil,
        { alloc := ⟨s.alloc.nextFreeBlock + 6⟩,
          mem := s.mem.storeQuad r (fd_ed25519_partial_dbl.spec (s.mem.readQuad a)) }) := by
  func_init
  -- the point's vectors as the entry state holds them, carried past the temporaries
  have ha03 : S.mem.readAt a 512 = S₀.mem.readAt a 512 := by rw [hS]
  have ha14 : S.mem.readAt (a.add 64#64) 512 = S₀.mem.readAt (a.add 64#64) 512 := by rw [hS]
  have ha25 : S.mem.readAt (a.add 128#64) 512 = S₀.mem.readAt (a.add 128#64) 512 := by rw [hS]
  block_init
  iterate 86 step_pure
  step_alloca with z03
  step_alloca with z14
  step_alloca with z25
  step_alloca with w03
  step_alloca with w14
  step_alloca with w25
  -- FD_R43X6_QUAD_PERMUTE( _ta, 1,1,2,0, a->P )
  step_load with x03
  step_pure with ta03
  step_pure
  step_load with x14
  step_pure with ta14
  step_pure
  step_load with x25
  step_pure with ta25
  -- FD_R43X6_QUAD_LANE_ADD_FAST( _ta, _ta, 1,0,0,0, _ta, a->P )
  step_pure [wrapZipWith]
  step_pure with tb03
  step_pure [wrapZipWith]
  step_pure with tb14
  step_pure [wrapZipWith]
  step_pure with tb25
  -- FD_R43X6_QUAD_SQR_FAST( _ta, _ta ) up to FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _tb )
  -- FD_R43X6_QUAD_SQR_FAST( _ta, _ta ) up to FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _tb )
  step_pattern using runBodyFrom_dblRun
  -- FD_R43X6_QUAD_FOLD_UNSIGNED( r->P, _ta )
  step_pattern using runBodyFrom_foldUnsignedStoreRun
  finish_block
  subst hS
  erase_frame
  have e0 : S₀.mem.readQuad a = ⟨x03, x14, x25⟩ := by rw [hx03, hx14, hx25]; rfl
  have e1 : Quad.addSel true false false false (Quad.perm4 1 1 2 0 ⟨x03, x14, x25⟩)
      ⟨x03, x14, x25⟩ = ⟨tb03, tb14, tb25⟩ := by
    rw [htb03, htb14, htb25, hta03, hta14, hta25]; rfl
  rw [fd_ed25519_partial_dbl.spec, geDbl_eq, e0, e1, _hdbl, _hu]
  subst_vars
  rfl

end Proof

end LeanMLIR.RIR.Firedancer.Avx512
