module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.VecRun
public import Firedancer.Crc.Common.Wl
public import Firedancer.Crc.Verify.Reads
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_quad_sqr

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_quad_sqr( _z0 … _z4, x0 … x4 )`: the squares of the QUAD `X`, lane by lane, reduced:
the cross products doubled by shifts, limbs `5 … 9` folded into `0 … 4` by 19 (38 for the doubled
ones) in 64-bit arithmetic, then one carry pass. The operands are in the compiled order. -/
def fd_r52x5_quad_sqr.spec (X : Quad5) : Quad5 :=
  let x0 := X.P0
  let x1 := X.P1
  let x2 := X.P2
  let x3 := X.P3
  let x4 := X.P4
  let t0 := wl_madd52lo wl_zero x2 x3
  let t1 := wl_madd52lo t0 x1 x4
  let t2 := wl_madd52hi wl_zero x1 x3
  let t3 := wl_madd52hi t2 x0 x4
  let t4 := wl_shl t3 1
  let t5 := wl_madd52hi t4 x2 x2
  let t6 := wl_add t5 t1
  let t7 := wl_mul t6 (wl_bcast 38)
  let t8 := wl_madd52lo t7 x0 x0
  let t9 := wl_and t8 (wl_bcast 2251799813685247)
  let t10 := wl_madd52lo wl_zero x1 x3
  let t11 := wl_madd52lo t10 x0 x4
  let t12 := wl_madd52hi wl_zero x1 x2
  let t13 := wl_madd52hi t12 x0 x3
  let t14 := wl_shl t13 2
  let t15 := wl_shl t11 1
  let t16 := wl_add t14 t15
  let t17 := wl_madd52lo t16 x2 x2
  let t18 := wl_madd52hi wl_zero x4 x4
  let t19 := wl_mul t18 (wl_bcast 38)
  let t20 := wl_add t19 t17
  let t21 := wl_shru t20 51
  let t22 := wl_madd52lo t9 (wl_bcast 19) t21
  let t23 := wl_shru t8 51
  let t24 := wl_madd52lo wl_zero x0 x1
  let t25 := wl_madd52hi t24 x0 x0
  let t26 := wl_shl t25 1
  let t27 := wl_madd52hi wl_zero x2 x3
  let t28 := wl_madd52hi t27 x1 x4
  let t29 := wl_shl t28 1
  let t30 := wl_madd52lo t29 x2 x4
  let t31 := wl_shl t30 1
  let t32 := wl_madd52lo t31 x3 x3
  let t33 := wl_mul t32 (wl_bcast 19)
  let t34 := wl_add t33 t26
  let t35 := wl_and t34 (wl_bcast 2251799813685247)
  let t36 := wl_add t35 t23
  let t37 := wl_shru t34 51
  let t38 := wl_madd52hi wl_zero x0 x1
  let t39 := wl_shl t38 1
  let t40 := wl_madd52lo t39 x0 x2
  let t41 := wl_shl t40 1
  let t42 := wl_madd52lo t41 x1 x1
  let t43 := wl_madd52hi wl_zero x2 x4
  let t44 := wl_shl t43 1
  let t45 := wl_madd52hi t44 x3 x3
  let t46 := wl_madd52lo t45 x3 x4
  let t47 := wl_mul t46 (wl_bcast 38)
  let t48 := wl_add t47 t42
  let t49 := wl_and t48 (wl_bcast 2251799813685247)
  let t50 := wl_add t49 t37
  let t51 := wl_shru t48 51
  let t52 := wl_madd52lo wl_zero x1 x2
  let t53 := wl_madd52lo t52 x0 x3
  let t54 := wl_madd52hi wl_zero x0 x2
  let t55 := wl_shl t54 1
  let t56 := wl_madd52hi t55 x1 x1
  let t57 := wl_add t56 t53
  let t58 := wl_shl t57 1
  let t59 := wl_madd52hi wl_zero x3 x4
  let t60 := wl_shl t59 2
  let t61 := wl_madd52lo t60 x4 x4
  let t62 := wl_mul t61 (wl_bcast 19)
  let t63 := wl_add t62 t58
  let t64 := wl_and t63 (wl_bcast 2251799813685247)
  let t65 := wl_add t64 t51
  let t66 := wl_shru t63 51
  let t67 := wl_and t20 (wl_bcast 2251799813685247)
  let t68 := wl_add t66 t67
  ⟨t22, t36, t50, t65, t68⟩

end

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h

attribute [local mlir_operation] vpmadd52l_wl vpmadd52h_wl zipWith_add_wl zipWith_sub_wl
  zipWith_and_wl zipWith_shl_wl zipWith_lshr_wl zipWith_add_nsw_nuw_reduce
  zipWith_add_nsw_nuw_reduce' zipWith_mul_wl

namespace fd_r52x5_quad_sqr

/-- `fd_r52x5_quad_sqr` from position 7 to 16: its ops there, over the registers live into them. -/
theorem chunk0 {β : Type} {blk : BasicBlock Γ [] blockTys}
    (hbody : blk.body.drop 7 = entry.body.drop 7) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {Z0 Z1 Z2 Z3 Z4 : Pointer}
    {X : Quad5}
    (hArgs : E.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4)
      (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4)).get)
    (hR : E ⊨ [rir_reg% hty 0 := ((Vector.replicate 4 0#64) : Wl),
      rir_reg% hty 1 := ((Vector.replicate 4 1#64) : Wl),
      rir_reg% hty 2 := ((Vector.replicate 4 38#64) : Wl),
      rir_reg% hty 3 := ((Vector.replicate 4 2251799813685247#64) : Wl),
      rir_reg% hty 4 := ((Vector.replicate 4 2#64) : Wl),
      rir_reg% hty 5 := ((Vector.replicate 4 51#64) : Wl),
      rir_reg% hty 6 := ((Vector.replicate 4 19#64) : Wl)])
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4) (Ty.wrap X.P0)
          (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4)).get →
        E' ⊨ [rir_reg% hty 0 := ((Vector.replicate 4 0#64) : Wl),
          rir_reg% hty 1 := ((Vector.replicate 4 1#64) : Wl),
          rir_reg% hty 2 := ((Vector.replicate 4 38#64) : Wl),
          rir_reg% hty 3 := ((Vector.replicate 4 2251799813685247#64) : Wl),
          rir_reg% hty 4 := ((Vector.replicate 4 2#64) : Wl),
          rir_reg% hty 5 := ((Vector.replicate 4 51#64) : Wl),
          rir_reg% hty 6 := ((Vector.replicate 4 19#64) : Wl),
          rir_reg% hty 15 := ((wl_madd52lo (wl_mul (wl_add (wl_madd52hi (wl_shl (wl_madd52hi (wl_madd52hi (Vector.replicate 4 0#64) X.P1 X.P3) X.P0 X.P4) 1) X.P2 X.P2) (wl_madd52lo (wl_madd52lo (Vector.replicate 4 0#64) X.P2 X.P3) X.P1 X.P4)) (Vector.replicate 4 38#64)) X.P0 X.P0) : Wl)] →
        (blk.runBodyFrom E' 16 S >>= g) = K) :
    (blk.runBodyFrom E 7 S >>= g) = K := by
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with t8
  subst_vars
  refine hK _ hArgs ?_
  lemma_reads

/-- `fd_r52x5_quad_sqr` from position 16 to 30: its ops there, over the registers live into them. -/
theorem chunk1 {β : Type} {blk : BasicBlock Γ [] blockTys}
    (hbody : blk.body.drop 16 = entry.body.drop 16) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {Z0 Z1 Z2 Z3 Z4 : Pointer}
    {X : Quad5} {a15 : Wl}
    (hArgs : E.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4)
      (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4)).get)
    (hR : E ⊨ [rir_reg% hty 0 := ((Vector.replicate 4 0#64) : Wl),
      rir_reg% hty 1 := ((Vector.replicate 4 1#64) : Wl),
      rir_reg% hty 2 := ((Vector.replicate 4 38#64) : Wl),
      rir_reg% hty 3 := ((Vector.replicate 4 2251799813685247#64) : Wl),
      rir_reg% hty 4 := ((Vector.replicate 4 2#64) : Wl),
      rir_reg% hty 5 := ((Vector.replicate 4 51#64) : Wl),
      rir_reg% hty 6 := ((Vector.replicate 4 19#64) : Wl), rir_reg% hty 15 := (a15 : Wl)])
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4) (Ty.wrap X.P0)
          (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4)).get →
        E' ⊨ [rir_reg% hty 0 := ((Vector.replicate 4 0#64) : Wl),
          rir_reg% hty 1 := ((Vector.replicate 4 1#64) : Wl),
          rir_reg% hty 2 := ((Vector.replicate 4 38#64) : Wl),
          rir_reg% hty 3 := ((Vector.replicate 4 2251799813685247#64) : Wl),
          rir_reg% hty 4 := ((Vector.replicate 4 2#64) : Wl),
          rir_reg% hty 5 := ((Vector.replicate 4 51#64) : Wl),
          rir_reg% hty 6 := ((Vector.replicate 4 19#64) : Wl), rir_reg% hty 15 := (a15 : Wl),
          rir_reg% hty 27 := ((wl_add (wl_mul (wl_madd52hi (Vector.replicate 4 0#64) X.P4 X.P4) (Vector.replicate 4 38#64)) (wl_madd52lo (wl_add (wl_shl (wl_madd52hi (wl_madd52hi (Vector.replicate 4 0#64) X.P1 X.P2) X.P0 X.P3) 2) (wl_shl (wl_madd52lo (wl_madd52lo (Vector.replicate 4 0#64) X.P1 X.P3) X.P0 X.P4) 1)) X.P2 X.P2)) : Wl),
          rir_reg% hty 29 := ((wl_madd52lo (wl_and a15 (Vector.replicate 4 2251799813685247#64)) (Vector.replicate 4 19#64) (wl_shru (wl_add (wl_mul (wl_madd52hi (Vector.replicate 4 0#64) X.P4 X.P4) (Vector.replicate 4 38#64)) (wl_madd52lo (wl_add (wl_shl (wl_madd52hi (wl_madd52hi (Vector.replicate 4 0#64) X.P1 X.P2) X.P0 X.P3) 2) (wl_shl (wl_madd52lo (wl_madd52lo (Vector.replicate 4 0#64) X.P1 X.P3) X.P0 X.P4) 1)) X.P2 X.P2)) 51)) : Wl)] →
        (blk.runBodyFrom E' 30 S >>= g) = K) :
    (blk.runBodyFrom E 16 S >>= g) = K := by
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
  step_pure with t20
  step_pure
  step_pure
  subst_vars
  refine hK _ hArgs ?_
  lemma_reads

/-- `fd_r52x5_quad_sqr` from position 30 to 44: its ops there, over the registers live into them. -/
theorem chunk2 {β : Type} {blk : BasicBlock Γ [] blockTys}
    (hbody : blk.body.drop 30 = entry.body.drop 30) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {Z0 Z1 Z2 Z3 Z4 : Pointer}
    {X : Quad5} {a15 a27 a29 : Wl}
    (hArgs : E.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4)
      (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4)).get)
    (hR : E ⊨ [rir_reg% hty 0 := ((Vector.replicate 4 0#64) : Wl),
      rir_reg% hty 1 := ((Vector.replicate 4 1#64) : Wl),
      rir_reg% hty 2 := ((Vector.replicate 4 38#64) : Wl),
      rir_reg% hty 3 := ((Vector.replicate 4 2251799813685247#64) : Wl),
      rir_reg% hty 4 := ((Vector.replicate 4 2#64) : Wl),
      rir_reg% hty 5 := ((Vector.replicate 4 51#64) : Wl),
      rir_reg% hty 6 := ((Vector.replicate 4 19#64) : Wl), rir_reg% hty 15 := (a15 : Wl),
      rir_reg% hty 27 := (a27 : Wl), rir_reg% hty 29 := (a29 : Wl)])
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4) (Ty.wrap X.P0)
          (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4)).get →
        E' ⊨ [rir_reg% hty 0 := ((Vector.replicate 4 0#64) : Wl),
          rir_reg% hty 1 := ((Vector.replicate 4 1#64) : Wl),
          rir_reg% hty 2 := ((Vector.replicate 4 38#64) : Wl),
          rir_reg% hty 3 := ((Vector.replicate 4 2251799813685247#64) : Wl),
          rir_reg% hty 4 := ((Vector.replicate 4 2#64) : Wl),
          rir_reg% hty 5 := ((Vector.replicate 4 51#64) : Wl),
          rir_reg% hty 6 := ((Vector.replicate 4 19#64) : Wl), rir_reg% hty 27 := (a27 : Wl),
          rir_reg% hty 29 := (a29 : Wl),
          rir_reg% hty 41 := ((wl_add (wl_mul (wl_madd52lo (wl_shl (wl_madd52lo (wl_shl (wl_madd52hi (wl_madd52hi (Vector.replicate 4 0#64) X.P2 X.P3) X.P1 X.P4) 1) X.P2 X.P4) 1) X.P3 X.P3) (Vector.replicate 4 19#64)) (wl_shl (wl_madd52hi (wl_madd52lo (Vector.replicate 4 0#64) X.P0 X.P1) X.P0 X.P0) 1)) : Wl),
          rir_reg% hty 43 := ((wl_add (wl_and (wl_add (wl_mul (wl_madd52lo (wl_shl (wl_madd52lo (wl_shl (wl_madd52hi (wl_madd52hi (Vector.replicate 4 0#64) X.P2 X.P3) X.P1 X.P4) 1) X.P2 X.P4) 1) X.P3 X.P3) (Vector.replicate 4 19#64)) (wl_shl (wl_madd52hi (wl_madd52lo (Vector.replicate 4 0#64) X.P0 X.P1) X.P0 X.P0) 1)) (Vector.replicate 4 2251799813685247#64)) (wl_shru a15 51)) : Wl)] →
        (blk.runBodyFrom E' 44 S >>= g) = K) :
    (blk.runBodyFrom E 30 S >>= g) = K := by
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
  step_pure with t34
  step_pure
  step_pure
  subst_vars
  refine hK _ hArgs ?_
  lemma_reads

/-- `fd_r52x5_quad_sqr` from position 44 to 58: its ops there, over the registers live into them. -/
theorem chunk3 {β : Type} {blk : BasicBlock Γ [] blockTys}
    (hbody : blk.body.drop 44 = entry.body.drop 44) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {Z0 Z1 Z2 Z3 Z4 : Pointer}
    {X : Quad5} {a27 a29 a41 a43 : Wl}
    (hArgs : E.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4)
      (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4)).get)
    (hR : E ⊨ [rir_reg% hty 0 := ((Vector.replicate 4 0#64) : Wl),
      rir_reg% hty 1 := ((Vector.replicate 4 1#64) : Wl),
      rir_reg% hty 2 := ((Vector.replicate 4 38#64) : Wl),
      rir_reg% hty 3 := ((Vector.replicate 4 2251799813685247#64) : Wl),
      rir_reg% hty 4 := ((Vector.replicate 4 2#64) : Wl),
      rir_reg% hty 5 := ((Vector.replicate 4 51#64) : Wl),
      rir_reg% hty 6 := ((Vector.replicate 4 19#64) : Wl), rir_reg% hty 27 := (a27 : Wl),
      rir_reg% hty 29 := (a29 : Wl), rir_reg% hty 41 := (a41 : Wl), rir_reg% hty 43 := (a43 : Wl)])
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4) (Ty.wrap X.P0)
          (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4)).get →
        E' ⊨ [rir_reg% hty 0 := ((Vector.replicate 4 0#64) : Wl),
          rir_reg% hty 1 := ((Vector.replicate 4 1#64) : Wl),
          rir_reg% hty 3 := ((Vector.replicate 4 2251799813685247#64) : Wl),
          rir_reg% hty 4 := ((Vector.replicate 4 2#64) : Wl),
          rir_reg% hty 5 := ((Vector.replicate 4 51#64) : Wl),
          rir_reg% hty 6 := ((Vector.replicate 4 19#64) : Wl), rir_reg% hty 27 := (a27 : Wl),
          rir_reg% hty 29 := (a29 : Wl), rir_reg% hty 43 := (a43 : Wl),
          rir_reg% hty 55 := ((wl_add (wl_mul (wl_madd52lo (wl_madd52hi (wl_shl (wl_madd52hi (Vector.replicate 4 0#64) X.P2 X.P4) 1) X.P3 X.P3) X.P3 X.P4) (Vector.replicate 4 38#64)) (wl_madd52lo (wl_shl (wl_madd52lo (wl_shl (wl_madd52hi (Vector.replicate 4 0#64) X.P0 X.P1) 1) X.P0 X.P2) 1) X.P1 X.P1)) : Wl),
          rir_reg% hty 57 := ((wl_add (wl_and (wl_add (wl_mul (wl_madd52lo (wl_madd52hi (wl_shl (wl_madd52hi (Vector.replicate 4 0#64) X.P2 X.P4) 1) X.P3 X.P3) X.P3 X.P4) (Vector.replicate 4 38#64)) (wl_madd52lo (wl_shl (wl_madd52lo (wl_shl (wl_madd52hi (Vector.replicate 4 0#64) X.P0 X.P1) 1) X.P0 X.P2) 1) X.P1 X.P1)) (Vector.replicate 4 2251799813685247#64)) (wl_shru a41 51)) : Wl)] →
        (blk.runBodyFrom E' 58 S >>= g) = K) :
    (blk.runBodyFrom E 44 S >>= g) = K := by
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
  step_pure with t48
  step_pure
  step_pure
  subst_vars
  refine hK _ hArgs ?_
  lemma_reads

/-- `fd_r52x5_quad_sqr` from position 58 to 76: its ops there, over the registers live into them. -/
theorem chunk4 {β : Type} {blk : BasicBlock Γ [] blockTys}
    (hbody : blk.body.drop 58 = entry.body.drop 58) {E : ⟪Γ⟫} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} {Z0 Z1 Z2 Z3 Z4 : Pointer}
    {X : Quad5} {a27 a29 a43 a55 a57 : Wl}
    (hArgs : E.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4)
      (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4)).get)
    (hR : E ⊨ [rir_reg% hty 0 := ((Vector.replicate 4 0#64) : Wl),
      rir_reg% hty 1 := ((Vector.replicate 4 1#64) : Wl),
      rir_reg% hty 3 := ((Vector.replicate 4 2251799813685247#64) : Wl),
      rir_reg% hty 4 := ((Vector.replicate 4 2#64) : Wl),
      rir_reg% hty 5 := ((Vector.replicate 4 51#64) : Wl),
      rir_reg% hty 6 := ((Vector.replicate 4 19#64) : Wl), rir_reg% hty 27 := (a27 : Wl),
      rir_reg% hty 29 := (a29 : Wl), rir_reg% hty 43 := (a43 : Wl), rir_reg% hty 55 := (a55 : Wl),
      rir_reg% hty 57 := (a57 : Wl)])
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value Z0) (.value Z1) (.value Z2) (.value Z3) (.value Z4) (Ty.wrap X.P0)
          (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4)).get →
        E' ⊨ [rir_reg% hty 29 := (a29 : Wl), rir_reg% hty 43 := (a43 : Wl),
          rir_reg% hty 57 := (a57 : Wl),
          rir_reg% hty 72 := ((wl_add (wl_and (wl_add (wl_mul (wl_madd52lo (wl_shl (wl_madd52hi (Vector.replicate 4 0#64) X.P3 X.P4) 2) X.P4 X.P4) (Vector.replicate 4 19#64)) (wl_shl (wl_add (wl_madd52hi (wl_shl (wl_madd52hi (Vector.replicate 4 0#64) X.P0 X.P2) 1) X.P1 X.P1) (wl_madd52lo (wl_madd52lo (Vector.replicate 4 0#64) X.P1 X.P2) X.P0 X.P3)) 1)) (Vector.replicate 4 2251799813685247#64)) (wl_shru a55 51)) : Wl),
          rir_reg% hty 75 := ((wl_add (wl_shru (wl_add (wl_mul (wl_madd52lo (wl_shl (wl_madd52hi (Vector.replicate 4 0#64) X.P3 X.P4) 2) X.P4 X.P4) (Vector.replicate 4 19#64)) (wl_shl (wl_add (wl_madd52hi (wl_shl (wl_madd52hi (Vector.replicate 4 0#64) X.P0 X.P2) 1) X.P1 X.P1) (wl_madd52lo (wl_madd52lo (Vector.replicate 4 0#64) X.P1 X.P2) X.P0 X.P3)) 1)) 51) (wl_and a27 (Vector.replicate 4 2251799813685247#64))) : Wl)] →
        (blk.runBodyFrom E' 76 S >>= g) = K) :
    (blk.runBodyFrom E 58 S >>= g) = K := by
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
  step_pure with t63
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  subst_vars
  refine hK _ hArgs ?_
  lemma_reads

end fd_r52x5_quad_sqr

/-- `fd_r52x5_quad_sqr` stores `spec`'s `wl_t`s at `_z0 … _z4`, in that order. -/
public theorem fd_r52x5_quad_sqr.call_eq (_z0 _z1 _z2 _z3 _z4 : Pointer) (X : Quad5)
    (s : GlobalState) (hwf : s.WF) (h0 : Room s.mem _z0 256) (h1 : Room s.mem _z1 256)
    (h2 : Room s.mem _z2 256) (h3 : Room s.mem _z3 256) (h4 : Room s.mem _z4 256) :
    fd_r52x5_quad_sqr.call
        (fd_r52x5_quad_sqr.args (.value _z0) (.value _z1) (.value _z2) (.value _z3) (.value _z4)
          (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4))
        s =
      .value
        (.nil,
          { s with
            mem := s.mem.storeTmp5 _z0 _z1 _z2 _z3 _z4 (fd_r52x5_quad_sqr.spec X) }) := by
  func_init
  block_init
  iterate 7 step_pure
  refine fd_r52x5_quad_sqr.chunk0 (blk := entry) rfl hArgs (by rw [hE]; lemma_reads)
    fun E hArgs hR => ?_
  clear hE
  refine fd_r52x5_quad_sqr.chunk1 (blk := entry) rfl hArgs hR fun E hArgs hR => ?_
  refine fd_r52x5_quad_sqr.chunk2 (blk := entry) rfl hArgs hR fun E hArgs hR => ?_
  refine fd_r52x5_quad_sqr.chunk3 (blk := entry) rfl hArgs hR fun E hArgs hR => ?_
  refine fd_r52x5_quad_sqr.chunk4 (blk := entry) rfl hArgs hR fun E hArgs hR => ?_
  iterate 5 step_store
  finish_block
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.Crc.Verify
