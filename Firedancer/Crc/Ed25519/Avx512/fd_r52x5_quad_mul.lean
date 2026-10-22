module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.VecRun
public import Firedancer.Crc.Ed25519.Common.Wl
public import Firedancer.Crc.Ed25519.Common.Reads
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_quad_mul

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

open MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_quad_mul( _z0 … _z4, x0 … x4, y0 … y4 )`: the products of the QUADs `X` and `Y`, lane
by lane, reduced: the halves of the 52-bit partial products summed into limbs `0 … 9`, limbs `5 … 9`
folded into `0 … 4` by 19 in 64-bit arithmetic, then one carry pass. The operands are in the
compiled order. -/
def fd_r52x5_quad_mul.spec (X Y : Quad5) : Quad5 :=
  let x0 := X.P0
  let x1 := X.P1
  let x2 := X.P2
  let x3 := X.P3
  let x4 := X.P4
  let y0 := Y.P0
  let y1 := Y.P1
  let y2 := Y.P2
  let y3 := Y.P3
  let y4 := Y.P4
  let t0 := wl_madd52lo wl_zero x2 y3
  let t1 := wl_madd52lo t0 x1 y4
  let t2 := wl_madd52lo t1 x3 y2
  let t3 := wl_madd52lo t2 x4 y1
  let t4 := wl_madd52hi wl_zero x1 y3
  let t5 := wl_madd52hi t4 x0 y4
  let t6 := wl_madd52hi t5 x2 y2
  let t7 := wl_madd52hi t6 x3 y1
  let t8 := wl_madd52hi t7 x4 y0
  let t9 := wl_shl t8 1
  let t10 := wl_add t9 t3
  let t11 := wl_mul t10 (wl_bcast 19)
  let t12 := wl_madd52lo t11 x0 y0
  let t13 := wl_and t12 (wl_bcast 2251799813685247)
  let t14 := wl_madd52lo wl_zero x1 y3
  let t15 := wl_madd52lo t14 x0 y4
  let t16 := wl_madd52lo t15 x2 y2
  let t17 := wl_madd52lo t16 x3 y1
  let t18 := wl_madd52lo t17 x4 y0
  let t19 := wl_madd52hi wl_zero x1 y2
  let t20 := wl_madd52hi t19 x0 y3
  let t21 := wl_madd52hi t20 x2 y1
  let t22 := wl_madd52hi t21 x3 y0
  let t23 := wl_shl t22 1
  let t24 := wl_add t23 t18
  let t25 := wl_madd52hi wl_zero x4 y4
  let t26 := wl_mul t25 (wl_bcast 38)
  let t27 := wl_add t24 t26
  let t28 := wl_shru t27 51
  let t29 := wl_madd52lo t13 (wl_bcast 19) t28
  let t30 := wl_shru t12 51
  let t31 := wl_madd52lo wl_zero x1 y0
  let t32 := wl_madd52lo t31 x0 y1
  let t33 := wl_madd52hi wl_zero x0 y0
  let t34 := wl_shl t33 1
  let t35 := wl_add t34 t32
  let t36 := wl_madd52lo wl_zero x3 y3
  let t37 := wl_madd52lo t36 x2 y4
  let t38 := wl_madd52lo t37 x4 y2
  let t39 := wl_madd52hi wl_zero x2 y3
  let t40 := wl_madd52hi t39 x1 y4
  let t41 := wl_madd52hi t40 x3 y2
  let t42 := wl_madd52hi t41 x4 y1
  let t43 := wl_shl t42 1
  let t44 := wl_add t43 t38
  let t45 := wl_mul t44 (wl_bcast 19)
  let t46 := wl_add t35 t45
  let t47 := wl_and t46 (wl_bcast 2251799813685247)
  let t48 := wl_add t47 t30
  let t49 := wl_shru t46 51
  let t50 := wl_madd52lo wl_zero x1 y1
  let t51 := wl_madd52lo t50 x0 y2
  let t52 := wl_madd52lo t51 x2 y0
  let t53 := wl_madd52hi wl_zero x1 y0
  let t54 := wl_madd52hi t53 x0 y1
  let t55 := wl_shl t54 1
  let t56 := wl_add t55 t52
  let t57 := wl_madd52lo wl_zero x4 y3
  let t58 := wl_madd52lo t57 x3 y4
  let t59 := wl_madd52hi wl_zero x3 y3
  let t60 := wl_madd52hi t59 x2 y4
  let t61 := wl_madd52hi t60 x4 y2
  let t62 := wl_shl t61 1
  let t63 := wl_add t62 t58
  let t64 := wl_mul t63 (wl_bcast 19)
  let t65 := wl_add t56 t64
  let t66 := wl_and t65 (wl_bcast 2251799813685247)
  let t67 := wl_add t66 t49
  let t68 := wl_shru t65 51
  let t69 := wl_madd52lo wl_zero x1 y2
  let t70 := wl_madd52lo t69 x0 y3
  let t71 := wl_madd52lo t70 x2 y1
  let t72 := wl_madd52lo t71 x3 y0
  let t73 := wl_madd52hi wl_zero x1 y1
  let t74 := wl_madd52hi t73 x0 y2
  let t75 := wl_madd52hi t74 x2 y0
  let t76 := wl_shl t75 1
  let t77 := wl_add t76 t72
  let t78 := wl_madd52hi wl_zero x4 y3
  let t79 := wl_madd52hi t78 x3 y4
  let t80 := wl_shl t79 1
  let t81 := wl_madd52lo t80 x4 y4
  let t82 := wl_mul t81 (wl_bcast 19)
  let t83 := wl_add t77 t82
  let t84 := wl_and t83 (wl_bcast 2251799813685247)
  let t85 := wl_add t84 t68
  let t86 := wl_shru t83 51
  let t87 := wl_and t27 (wl_bcast 2251799813685247)
  let t88 := wl_add t86 t87
  ⟨t29, t48, t67, t85, t88⟩

end

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h

attribute [local mlir_operation] vpmadd52l_wl vpmadd52h_wl zipWith_add_wl zipWith_sub_wl
  zipWith_and_wl zipWith_shl_wl zipWith_lshr_wl zipWith_add_nsw_nuw_reduce
  zipWith_add_nsw_nuw_reduce' zipWith_mul_wl

namespace fd_r52x5_quad_mul

/-- `fd_r52x5_quad_mul` from position 6 to 19: its ops there, over the registers live into them. -/
theorem chunk0 {β : Type} {blk : BasicBlock Γ [] blockTys}
    (hbody : blk.body.drop 6 = entry.body.drop 6) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {Z0 Z1 Z2 Z3 Z4 : Pointer}
    {X Y : Quad5}
    (hArgs : E.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4)
      (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4) (Ty.wrap Y.P0)
      (Ty.wrap Y.P1) (Ty.wrap Y.P2) (Ty.wrap Y.P3) (Ty.wrap Y.P4)).get)
    (hR : E ⊨ [rir_reg% hty 0 := ((Vector.replicate 4 0#64) : Wl),
      rir_reg% hty 1 := ((Vector.replicate 4 1#64) : Wl),
      rir_reg% hty 2 := ((Vector.replicate 4 19#64) : Wl),
      rir_reg% hty 3 := ((Vector.replicate 4 2251799813685247#64) : Wl),
      rir_reg% hty 4 := ((Vector.replicate 4 38#64) : Wl),
      rir_reg% hty 5 := ((Vector.replicate 4 51#64) : Wl)])
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4) (Ty.wrap X.P0)
          (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4) (Ty.wrap Y.P0) (Ty.wrap Y.P1)
          (Ty.wrap Y.P2) (Ty.wrap Y.P3) (Ty.wrap Y.P4)).get →
        E' ⊨ [rir_reg% hty 0 := ((Vector.replicate 4 0#64) : Wl),
          rir_reg% hty 1 := ((Vector.replicate 4 1#64) : Wl),
          rir_reg% hty 2 := ((Vector.replicate 4 19#64) : Wl),
          rir_reg% hty 3 := ((Vector.replicate 4 2251799813685247#64) : Wl),
          rir_reg% hty 4 := ((Vector.replicate 4 38#64) : Wl),
          rir_reg% hty 5 := ((Vector.replicate 4 51#64) : Wl),
          rir_reg% hty 18 := ((wl_madd52lo (wl_mul (wl_add (wl_shl (wl_madd52hi (wl_madd52hi (wl_madd52hi (wl_madd52hi (wl_madd52hi (Vector.replicate 4 0#64) X.P1 Y.P3) X.P0 Y.P4) X.P2 Y.P2) X.P3 Y.P1) X.P4 Y.P0) 1) (wl_madd52lo (wl_madd52lo (wl_madd52lo (wl_madd52lo (Vector.replicate 4 0#64) X.P2 Y.P3) X.P1 Y.P4) X.P3 Y.P2) X.P4 Y.P1)) (Vector.replicate 4 19#64)) X.P0 Y.P0) : Wl)] →
        (blk.runBodyFrom E' 19 S >>= g) = K) :
    (blk.runBodyFrom E 6 S >>= g) = K := by
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with t12
  subst_vars
  refine hK _ hArgs ?_
  lemma_reads

/-- `fd_r52x5_quad_mul` from position 19 to 36: its ops there, over the registers live into them. -/
theorem chunk1 {β : Type} {blk : BasicBlock Γ [] blockTys}
    (hbody : blk.body.drop 19 = entry.body.drop 19) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {Z0 Z1 Z2 Z3 Z4 : Pointer}
    {X Y : Quad5} {a18 : Wl}
    (hArgs : E.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4)
      (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4) (Ty.wrap Y.P0)
      (Ty.wrap Y.P1) (Ty.wrap Y.P2) (Ty.wrap Y.P3) (Ty.wrap Y.P4)).get)
    (hR : E ⊨ [rir_reg% hty 0 := ((Vector.replicate 4 0#64) : Wl),
      rir_reg% hty 1 := ((Vector.replicate 4 1#64) : Wl),
      rir_reg% hty 2 := ((Vector.replicate 4 19#64) : Wl),
      rir_reg% hty 3 := ((Vector.replicate 4 2251799813685247#64) : Wl),
      rir_reg% hty 4 := ((Vector.replicate 4 38#64) : Wl),
      rir_reg% hty 5 := ((Vector.replicate 4 51#64) : Wl), rir_reg% hty 18 := (a18 : Wl)])
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4) (Ty.wrap X.P0)
          (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4) (Ty.wrap Y.P0) (Ty.wrap Y.P1)
          (Ty.wrap Y.P2) (Ty.wrap Y.P3) (Ty.wrap Y.P4)).get →
        E' ⊨ [rir_reg% hty 0 := ((Vector.replicate 4 0#64) : Wl),
          rir_reg% hty 1 := ((Vector.replicate 4 1#64) : Wl),
          rir_reg% hty 2 := ((Vector.replicate 4 19#64) : Wl),
          rir_reg% hty 3 := ((Vector.replicate 4 2251799813685247#64) : Wl),
          rir_reg% hty 5 := ((Vector.replicate 4 51#64) : Wl), rir_reg% hty 18 := (a18 : Wl),
          rir_reg% hty 33 := ((wl_add (wl_add (wl_shl (wl_madd52hi (wl_madd52hi (wl_madd52hi (wl_madd52hi (Vector.replicate 4 0#64) X.P1 Y.P2) X.P0 Y.P3) X.P2 Y.P1) X.P3 Y.P0) 1) (wl_madd52lo (wl_madd52lo (wl_madd52lo (wl_madd52lo (wl_madd52lo (Vector.replicate 4 0#64) X.P1 Y.P3) X.P0 Y.P4) X.P2 Y.P2) X.P3 Y.P1) X.P4 Y.P0)) (wl_mul (wl_madd52hi (Vector.replicate 4 0#64) X.P4 Y.P4) (Vector.replicate 4 38#64))) : Wl),
          rir_reg% hty 35 := ((wl_madd52lo (wl_and a18 (Vector.replicate 4 2251799813685247#64)) (Vector.replicate 4 19#64) (wl_shru (wl_add (wl_add (wl_shl (wl_madd52hi (wl_madd52hi (wl_madd52hi (wl_madd52hi (Vector.replicate 4 0#64) X.P1 Y.P2) X.P0 Y.P3) X.P2 Y.P1) X.P3 Y.P0) 1) (wl_madd52lo (wl_madd52lo (wl_madd52lo (wl_madd52lo (wl_madd52lo (Vector.replicate 4 0#64) X.P1 Y.P3) X.P0 Y.P4) X.P2 Y.P2) X.P3 Y.P1) X.P4 Y.P0)) (wl_mul (wl_madd52hi (Vector.replicate 4 0#64) X.P4 Y.P4) (Vector.replicate 4 38#64))) 51)) : Wl)] →
        (blk.runBodyFrom E' 36 S >>= g) = K) :
    (blk.runBodyFrom E 19 S >>= g) = K := by
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with t27
  step_pure
  step_pure
  subst_vars
  refine hK _ hArgs ?_
  lemma_reads

/-- `fd_r52x5_quad_mul` from position 36 to 55: its ops there, over the registers live into them. -/
theorem chunk2 {β : Type} {blk : BasicBlock Γ [] blockTys}
    (hbody : blk.body.drop 36 = entry.body.drop 36) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {Z0 Z1 Z2 Z3 Z4 : Pointer}
    {X Y : Quad5} {a18 a33 a35 : Wl}
    (hArgs : E.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4)
      (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4) (Ty.wrap Y.P0)
      (Ty.wrap Y.P1) (Ty.wrap Y.P2) (Ty.wrap Y.P3) (Ty.wrap Y.P4)).get)
    (hR : E ⊨ [rir_reg% hty 0 := ((Vector.replicate 4 0#64) : Wl),
      rir_reg% hty 1 := ((Vector.replicate 4 1#64) : Wl),
      rir_reg% hty 2 := ((Vector.replicate 4 19#64) : Wl),
      rir_reg% hty 3 := ((Vector.replicate 4 2251799813685247#64) : Wl),
      rir_reg% hty 5 := ((Vector.replicate 4 51#64) : Wl), rir_reg% hty 18 := (a18 : Wl),
      rir_reg% hty 33 := (a33 : Wl), rir_reg% hty 35 := (a35 : Wl)])
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4) (Ty.wrap X.P0)
          (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4) (Ty.wrap Y.P0) (Ty.wrap Y.P1)
          (Ty.wrap Y.P2) (Ty.wrap Y.P3) (Ty.wrap Y.P4)).get →
        E' ⊨ [rir_reg% hty 0 := ((Vector.replicate 4 0#64) : Wl),
          rir_reg% hty 1 := ((Vector.replicate 4 1#64) : Wl),
          rir_reg% hty 2 := ((Vector.replicate 4 19#64) : Wl),
          rir_reg% hty 3 := ((Vector.replicate 4 2251799813685247#64) : Wl),
          rir_reg% hty 5 := ((Vector.replicate 4 51#64) : Wl), rir_reg% hty 33 := (a33 : Wl),
          rir_reg% hty 35 := (a35 : Wl),
          rir_reg% hty 52 := ((wl_add (wl_add (wl_shl (wl_madd52hi (Vector.replicate 4 0#64) X.P0 Y.P0) 1) (wl_madd52lo (wl_madd52lo (Vector.replicate 4 0#64) X.P1 Y.P0) X.P0 Y.P1)) (wl_mul (wl_add (wl_shl (wl_madd52hi (wl_madd52hi (wl_madd52hi (wl_madd52hi (Vector.replicate 4 0#64) X.P2 Y.P3) X.P1 Y.P4) X.P3 Y.P2) X.P4 Y.P1) 1) (wl_madd52lo (wl_madd52lo (wl_madd52lo (Vector.replicate 4 0#64) X.P3 Y.P3) X.P2 Y.P4) X.P4 Y.P2)) (Vector.replicate 4 19#64))) : Wl),
          rir_reg% hty 54 := ((wl_add (wl_and (wl_add (wl_add (wl_shl (wl_madd52hi (Vector.replicate 4 0#64) X.P0 Y.P0) 1) (wl_madd52lo (wl_madd52lo (Vector.replicate 4 0#64) X.P1 Y.P0) X.P0 Y.P1)) (wl_mul (wl_add (wl_shl (wl_madd52hi (wl_madd52hi (wl_madd52hi (wl_madd52hi (Vector.replicate 4 0#64) X.P2 Y.P3) X.P1 Y.P4) X.P3 Y.P2) X.P4 Y.P1) 1) (wl_madd52lo (wl_madd52lo (wl_madd52lo (Vector.replicate 4 0#64) X.P3 Y.P3) X.P2 Y.P4) X.P4 Y.P2)) (Vector.replicate 4 19#64))) (Vector.replicate 4 2251799813685247#64)) (wl_shru a18 51)) : Wl)] →
        (blk.runBodyFrom E' 55 S >>= g) = K) :
    (blk.runBodyFrom E 36 S >>= g) = K := by
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with t46
  step_pure
  step_pure
  subst_vars
  refine hK _ hArgs ?_
  lemma_reads

/-- `fd_r52x5_quad_mul` from position 55 to 74: its ops there, over the registers live into them. -/
theorem chunk3 {β : Type} {blk : BasicBlock Γ [] blockTys}
    (hbody : blk.body.drop 55 = entry.body.drop 55) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {Z0 Z1 Z2 Z3 Z4 : Pointer}
    {X Y : Quad5} {a33 a35 a52 a54 : Wl}
    (hArgs : E.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4)
      (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4) (Ty.wrap Y.P0)
      (Ty.wrap Y.P1) (Ty.wrap Y.P2) (Ty.wrap Y.P3) (Ty.wrap Y.P4)).get)
    (hR : E ⊨ [rir_reg% hty 0 := ((Vector.replicate 4 0#64) : Wl),
      rir_reg% hty 1 := ((Vector.replicate 4 1#64) : Wl),
      rir_reg% hty 2 := ((Vector.replicate 4 19#64) : Wl),
      rir_reg% hty 3 := ((Vector.replicate 4 2251799813685247#64) : Wl),
      rir_reg% hty 5 := ((Vector.replicate 4 51#64) : Wl), rir_reg% hty 33 := (a33 : Wl),
      rir_reg% hty 35 := (a35 : Wl), rir_reg% hty 52 := (a52 : Wl), rir_reg% hty 54 := (a54 : Wl)])
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4) (Ty.wrap X.P0)
          (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4) (Ty.wrap Y.P0) (Ty.wrap Y.P1)
          (Ty.wrap Y.P2) (Ty.wrap Y.P3) (Ty.wrap Y.P4)).get →
        E' ⊨ [rir_reg% hty 0 := ((Vector.replicate 4 0#64) : Wl),
          rir_reg% hty 1 := ((Vector.replicate 4 1#64) : Wl),
          rir_reg% hty 2 := ((Vector.replicate 4 19#64) : Wl),
          rir_reg% hty 3 := ((Vector.replicate 4 2251799813685247#64) : Wl),
          rir_reg% hty 5 := ((Vector.replicate 4 51#64) : Wl), rir_reg% hty 33 := (a33 : Wl),
          rir_reg% hty 35 := (a35 : Wl), rir_reg% hty 54 := (a54 : Wl),
          rir_reg% hty 71 := ((wl_add (wl_add (wl_shl (wl_madd52hi (wl_madd52hi (Vector.replicate 4 0#64) X.P1 Y.P0) X.P0 Y.P1) 1) (wl_madd52lo (wl_madd52lo (wl_madd52lo (Vector.replicate 4 0#64) X.P1 Y.P1) X.P0 Y.P2) X.P2 Y.P0)) (wl_mul (wl_add (wl_shl (wl_madd52hi (wl_madd52hi (wl_madd52hi (Vector.replicate 4 0#64) X.P3 Y.P3) X.P2 Y.P4) X.P4 Y.P2) 1) (wl_madd52lo (wl_madd52lo (Vector.replicate 4 0#64) X.P4 Y.P3) X.P3 Y.P4)) (Vector.replicate 4 19#64))) : Wl),
          rir_reg% hty 73 := ((wl_add (wl_and (wl_add (wl_add (wl_shl (wl_madd52hi (wl_madd52hi (Vector.replicate 4 0#64) X.P1 Y.P0) X.P0 Y.P1) 1) (wl_madd52lo (wl_madd52lo (wl_madd52lo (Vector.replicate 4 0#64) X.P1 Y.P1) X.P0 Y.P2) X.P2 Y.P0)) (wl_mul (wl_add (wl_shl (wl_madd52hi (wl_madd52hi (wl_madd52hi (Vector.replicate 4 0#64) X.P3 Y.P3) X.P2 Y.P4) X.P4 Y.P2) 1) (wl_madd52lo (wl_madd52lo (Vector.replicate 4 0#64) X.P4 Y.P3) X.P3 Y.P4)) (Vector.replicate 4 19#64))) (Vector.replicate 4 2251799813685247#64)) (wl_shru a52 51)) : Wl)] →
        (blk.runBodyFrom E' 74 S >>= g) = K) :
    (blk.runBodyFrom E 55 S >>= g) = K := by
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with t65
  step_pure
  step_pure
  subst_vars
  refine hK _ hArgs ?_
  lemma_reads

/-- `fd_r52x5_quad_mul` from position 74 to 92: its ops there, over the registers live into them. -/
theorem chunk4 {β : Type} {blk : BasicBlock Γ [] blockTys}
    (hbody : blk.body.drop 74 = entry.body.drop 74) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {Z0 Z1 Z2 Z3 Z4 : Pointer}
    {X Y : Quad5} {a33 a35 a54 a71 a73 : Wl}
    (hArgs : E.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4)
      (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4) (Ty.wrap Y.P0)
      (Ty.wrap Y.P1) (Ty.wrap Y.P2) (Ty.wrap Y.P3) (Ty.wrap Y.P4)).get)
    (hR : E ⊨ [rir_reg% hty 0 := ((Vector.replicate 4 0#64) : Wl),
      rir_reg% hty 1 := ((Vector.replicate 4 1#64) : Wl),
      rir_reg% hty 2 := ((Vector.replicate 4 19#64) : Wl),
      rir_reg% hty 3 := ((Vector.replicate 4 2251799813685247#64) : Wl),
      rir_reg% hty 5 := ((Vector.replicate 4 51#64) : Wl), rir_reg% hty 33 := (a33 : Wl),
      rir_reg% hty 35 := (a35 : Wl), rir_reg% hty 54 := (a54 : Wl), rir_reg% hty 71 := (a71 : Wl),
      rir_reg% hty 73 := (a73 : Wl)])
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4) (Ty.wrap X.P0)
          (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4) (Ty.wrap Y.P0) (Ty.wrap Y.P1)
          (Ty.wrap Y.P2) (Ty.wrap Y.P3) (Ty.wrap Y.P4)).get →
        E' ⊨ [rir_reg% hty 3 := ((Vector.replicate 4 2251799813685247#64) : Wl),
          rir_reg% hty 5 := ((Vector.replicate 4 51#64) : Wl), rir_reg% hty 33 := (a33 : Wl),
          rir_reg% hty 35 := (a35 : Wl), rir_reg% hty 54 := (a54 : Wl),
          rir_reg% hty 73 := (a73 : Wl),
          rir_reg% hty 89 := ((wl_add (wl_add (wl_shl (wl_madd52hi (wl_madd52hi (wl_madd52hi (Vector.replicate 4 0#64) X.P1 Y.P1) X.P0 Y.P2) X.P2 Y.P0) 1) (wl_madd52lo (wl_madd52lo (wl_madd52lo (wl_madd52lo (Vector.replicate 4 0#64) X.P1 Y.P2) X.P0 Y.P3) X.P2 Y.P1) X.P3 Y.P0)) (wl_mul (wl_madd52lo (wl_shl (wl_madd52hi (wl_madd52hi (Vector.replicate 4 0#64) X.P4 Y.P3) X.P3 Y.P4) 1) X.P4 Y.P4) (Vector.replicate 4 19#64))) : Wl),
          rir_reg% hty 91 := ((wl_add (wl_and (wl_add (wl_add (wl_shl (wl_madd52hi (wl_madd52hi (wl_madd52hi (Vector.replicate 4 0#64) X.P1 Y.P1) X.P0 Y.P2) X.P2 Y.P0) 1) (wl_madd52lo (wl_madd52lo (wl_madd52lo (wl_madd52lo (Vector.replicate 4 0#64) X.P1 Y.P2) X.P0 Y.P3) X.P2 Y.P1) X.P3 Y.P0)) (wl_mul (wl_madd52lo (wl_shl (wl_madd52hi (wl_madd52hi (Vector.replicate 4 0#64) X.P4 Y.P3) X.P3 Y.P4) 1) X.P4 Y.P4) (Vector.replicate 4 19#64))) (Vector.replicate 4 2251799813685247#64)) (wl_shru a71 51)) : Wl)] →
        (blk.runBodyFrom E' 92 S >>= g) = K) :
    (blk.runBodyFrom E 74 S >>= g) = K := by
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with t83
  step_pure
  step_pure
  subst_vars
  refine hK _ hArgs ?_
  lemma_reads

/-- `fd_r52x5_quad_mul` from position 92 to 95: its ops there, over the registers live into them. -/
theorem chunk5 {β : Type} {blk : BasicBlock Γ [] blockTys}
    (hbody : blk.body.drop 92 = entry.body.drop 92) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {Z0 Z1 Z2 Z3 Z4 : Pointer}
    {X Y : Quad5} {a33 a35 a54 a73 a89 a91 : Wl}
    (hArgs : E.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4)
      (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4) (Ty.wrap Y.P0)
      (Ty.wrap Y.P1) (Ty.wrap Y.P2) (Ty.wrap Y.P3) (Ty.wrap Y.P4)).get)
    (hR : E ⊨ [rir_reg% hty 3 := ((Vector.replicate 4 2251799813685247#64) : Wl),
      rir_reg% hty 5 := ((Vector.replicate 4 51#64) : Wl), rir_reg% hty 33 := (a33 : Wl),
      rir_reg% hty 35 := (a35 : Wl), rir_reg% hty 54 := (a54 : Wl), rir_reg% hty 73 := (a73 : Wl),
      rir_reg% hty 89 := (a89 : Wl), rir_reg% hty 91 := (a91 : Wl)])
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4) (Ty.wrap X.P0)
          (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4) (Ty.wrap Y.P0) (Ty.wrap Y.P1)
          (Ty.wrap Y.P2) (Ty.wrap Y.P3) (Ty.wrap Y.P4)).get →
        E' ⊨ [rir_reg% hty 35 := (a35 : Wl), rir_reg% hty 54 := (a54 : Wl),
          rir_reg% hty 73 := (a73 : Wl), rir_reg% hty 91 := (a91 : Wl),
          rir_reg% hty 94 := ((wl_add (wl_shru a89 51) (wl_and a33 (Vector.replicate 4 2251799813685247#64))) : Wl)] →
        (blk.runBodyFrom E' 95 S >>= g) = K) :
    (blk.runBodyFrom E 92 S >>= g) = K := by
  step_pure
  step_pure
  step_pure
  subst_vars
  refine hK _ hArgs ?_
  lemma_reads

end fd_r52x5_quad_mul

/-- `fd_r52x5_quad_mul` stores `spec`'s `wl_t`s at `_z0 … _z4`, in that order. -/
public theorem fd_r52x5_quad_mul.call_eq (_z0 _z1 _z2 _z3 _z4 : Pointer) (X Y : Quad5)
    (s : GlobalState) (hwf : s.WF) (h0 : Room s.mem _z0 256) (h1 : Room s.mem _z1 256)
    (h2 : Room s.mem _z2 256) (h3 : Room s.mem _z3 256) (h4 : Room s.mem _z4 256) :
    fd_r52x5_quad_mul.call
        (fd_r52x5_quad_mul.args (.value _z0) (.value _z1) (.value _z2) (.value _z3) (.value _z4)
          (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4) (Ty.wrap Y.P0)
          (Ty.wrap Y.P1) (Ty.wrap Y.P2) (Ty.wrap Y.P3) (Ty.wrap Y.P4))
        s =
      .value
        (.nil,
          { s with
            mem := s.mem.storeTmp5 _z0 _z1 _z2 _z3 _z4 (fd_r52x5_quad_mul.spec X Y) }) := by
  func_init
  block_init
  iterate 6 step_pure
  refine fd_r52x5_quad_mul.chunk0 (blk := entry) rfl hArgs (by rw [hE]; lemma_reads)
    fun E hArgs hR => ?_
  clear hE
  refine fd_r52x5_quad_mul.chunk1 (blk := entry) rfl hArgs hR fun E hArgs hR => ?_
  refine fd_r52x5_quad_mul.chunk2 (blk := entry) rfl hArgs hR fun E hArgs hR => ?_
  refine fd_r52x5_quad_mul.chunk3 (blk := entry) rfl hArgs hR fun E hArgs hR => ?_
  refine fd_r52x5_quad_mul.chunk4 (blk := entry) rfl hArgs hR fun E hArgs hR => ?_
  refine fd_r52x5_quad_mul.chunk5 (blk := entry) rfl hArgs hR fun E hArgs hR => ?_
  iterate 5 step_store
  finish_block
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.Crc.Ed25519.Avx512
