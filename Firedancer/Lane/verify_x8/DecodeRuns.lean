module

public import Firedancer.Lane.verify_x8.DecodeLib

/-! The field operations of `fd_ed25519_lane_decode2` as `verify_x8` compiles them where they differ
from `Runs`: products and squares with the next stores' addresses interleaved, a carry with its
stores, and `Runs`' patterns over registers kept apart by `distinctB`. -/

namespace MLIR.Firedancer.Lane.VerifyX8.Decode

open Firedancer.Avx512

@[expose] public section

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h

attribute [local mlir_operation] vpmadd52l_wwl vpmadd52h_wwl zipWith_add_wwl zipWith_sub_wwl
  zipWith_and_wwl zipWith_mul_wwl zipWith_shl_wwl zipWith_lshr_wwl

/-- `sublist_tac`: `l₁ <+ l₂` for literal lists, `l₁` read off `l₂` in order. -/
macro "sublist_tac" : tactic =>
  `(tactic|
    repeat
      (first
        | exact List.nil_sublist _
        | apply List.Sublist.cons_cons
        | apply List.Sublist.cons))

/-- `fd_ed25519_lane_carry( r )` as the products' carries compile it, 15 instructions: `carryRun`
with limb 1's add commuted (`carry_compiled'`). -/
def carryRun' (k51 km k19 x0 x1 x2 x3 x4 : Dst Γ V)
    (t0 t1 t2 t3 t4 t5 d0 t7 d1 t9 d2 t11 d3 t13 d4 : Dst Γ V) : List (Instr Γ) :=
  [.binop (.vector (.lshr false)) t0 (.val x0.i x0.h) (.val k51.i k51.h),
    .binop (.vector (.lshr false)) t1 (.val x1.i x1.h) (.val k51.i k51.h),
    .binop (.vector (.lshr false)) t2 (.val x2.i x2.h) (.val k51.i k51.h),
    .binop (.vector (.lshr false)) t3 (.val x3.i x3.h) (.val k51.i k51.h),
    .binop (.vector (.lshr false)) t4 (.val x4.i x4.h) (.val k51.i k51.h),
    .binop (.vector .and) t5 (.val x0.i x0.h) (.val km.i km.h),
    .ternop .vpmadd52l d0 (.val t5.i t5.h) (.val t4.i t4.h) (.val k19.i k19.h),
    .binop (.vector .and) t7 (.val x1.i x1.h) (.val km.i km.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d1 (.val t0.i t0.h) (.val t7.i t7.h),
    .binop (.vector .and) t9 (.val x2.i x2.h) (.val km.i km.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d2 (.val t9.i t9.h) (.val t1.i t1.h),
    .binop (.vector .and) t11 (.val x3.i x3.h) (.val km.i km.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d3 (.val t11.i t11.h) (.val t2.i t2.h),
    .binop (.vector .and) t13 (.val x4.i x4.h) (.val km.i km.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d4 (.val t13.i t13.h) (.val t3.i t3.h)]

/-- Where the body at `pos` is `carryRun'` and `x0 … x4` hold `X`: running on from `pos` gives `K`
if
it does from `pos + 15` with `carry X` in `d0 … d4`. -/
theorem runBodyFrom_carryRun' {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {k51 km k19 x0 x1 x2 x3 x4 t0 t1 t2 t3 t4 t5 d0 t7 d1 t9 d2 t11 d3 t13 d4 : Dst Γ V}
    {rest : List (Instr Γ)} {X0 X1 X2 X3 X4 : Wwl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        carryRun' k51 km k19 x0 x1 x2 x3 x4 t0 t1 t2 t3 t4 t5 d0 t7 d1 t9 d2 t11 d3 t13 d4 ++ rest)
    (hR :
      E ⊨ [k51 := Vector.replicate 8 51#64, km := Vector.replicate 8 2251799813685247#64, k19 :=
        Vector.replicate 8 19#64, x0 := X0, x1 := X1, x2 := X2, x3 := X3, x4 := X4])
    (hd :
      [k51.i, km.i, k19.i, x0.i, x1.i, x2.i, x3.i, x4.i, t0.i, t1.i, t2.i, t3.i, t4.i, t5.i, d0.i,
          t7.i, d1.i, t9.i, d2.i, t11.i, d3.i, t13.i, d4.i].Nodup)
    (hK :
      ∀ v_t0 v_t1 v_t2 v_t3 v_t4 v_t5 v_t7 v_t9 v_t11 v_t13 : ⟦V⟧,
        (blk.runBodyFrom
              E[t0 := v_t0, t1 := v_t1, t2 := v_t2, t3 := v_t3, t4 := v_t4, t5 := v_t5, d0 :=
                Ty.wrap (carry ⟨X0, X1, X2, X3, X4⟩).l0, t7 := v_t7, d1 :=
                Ty.wrap (carry ⟨X0, X1, X2, X3, X4⟩).l1, t9 := v_t9, d2 :=
                Ty.wrap (carry ⟨X0, X1, X2, X3, X4⟩).l2, t11 := v_t11, d3 :=
                Ty.wrap (carry ⟨X0, X1, X2, X3, X4⟩).l3, t13 := v_t13, d4 :=
                Ty.wrap (carry ⟨X0, X1, X2, X3, X4⟩).l4]
              (pos + 15) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
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
  rw [hE]
  rw [carry_compiled'] at hK
  exact hK _ _ _ _ _ _ _ _ _ _

/-- `fd_ed25519_lane_sqr( r, a )` as compiled, 66 instructions: `sqrRun` into `s0 … s4`, then
`carryRun'` of them into `d0 … d4`; `k51 km` hold `51` and the 51-bit mask. -/
def sqrCRun (z one two k38 k19 k51 km a0 a1 a2 a3 a4 : Dst Γ V)
    (t0 t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25
      t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 s0 t43 s1 t45 s2 t47 s3 t49 s4
      c0 c1 c2 c3 c4 c5 d0 c7 d1 c9 d2 c11 d3 c13 d4 : Dst Γ V) :
    List (Instr Γ) :=
  sqrRun z one two k38 k19 a0 a1 a2 a3 a4 t0 t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16
      t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39
      t40 t41 s0 t43 s1 t45 s2 t47 s3 t49 s4 ++
    carryRun' k51 km k19 s0 s1 s2 s3 s4 c0 c1 c2 c3 c4 c5 d0 c7 d1 c9 d2 c11 d3 c13 d4

-- 66 steps in one declaration
set_option maxHeartbeats 800000 in
/-- Where the body at `pos` is `sqrCRun` and `a0 … a4` hold `A`: running on from `pos` gives `K` if
it does
from `pos + 66` with `sqr A` in `d0 … d4`, whatever the intermediates hold. -/
theorem runBodyFrom_sqrCRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {z one two k38 k19 k51 km a0 a1 a2 a3 a4 t0 t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15
      t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38
      t39 t40 t41 s0 t43 s1 t45 s2 t47 s3 t49 s4 c0 c1 c2 c3 c4 c5 d0 c7 d1 c9 d2 c11 d3 c13 d4 :
      Dst Γ V}
    {rest : List (Instr Γ)} {A : Fe} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        sqrCRun z one two k38 k19 k51 km a0 a1 a2 a3 a4 t0 t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12
            t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29 t30 t31 t32 t33 t34
            t35 t36 t37 t38 t39 t40 t41 s0 t43 s1 t45 s2 t47 s3 t49 s4 c0 c1 c2 c3 c4 c5 d0 c7 d1 c9
            d2 c11 d3 c13 d4 ++
          rest)
    (hR :
      E ⊨ [z := Vector.replicate 8 0#64, one := Vector.replicate 8 1#64, two :=
        Vector.replicate 8 2#64, k38 := Vector.replicate 8 38#64, k19 := Vector.replicate 8 19#64,
        k51 := Vector.replicate 8 51#64, km := Vector.replicate 8 2251799813685247#64, a0 := A.l0,
        a1 := A.l1, a2 := A.l2, a3 := A.l3, a4 := A.l4])
    (hd :
      distinctB
          [z.i.val, one.i.val, two.i.val, k38.i.val, k51.i.val, km.i.val, k19.i.val, a0.i.val,
            a1.i.val, a2.i.val, a3.i.val, a4.i.val, t0.i.val, t1.i.val, t2.i.val, t3.i.val,
            t4.i.val, t5.i.val, t6.i.val, t7.i.val, t8.i.val, t9.i.val, t10.i.val, t11.i.val,
            t12.i.val, t13.i.val, t14.i.val, t15.i.val, t16.i.val, t17.i.val, t18.i.val, t19.i.val,
            t20.i.val, t21.i.val, t22.i.val, t23.i.val, t24.i.val, t25.i.val, t26.i.val, t27.i.val,
            t28.i.val, t29.i.val, t30.i.val, t31.i.val, t32.i.val, t33.i.val, t34.i.val, t35.i.val,
            t36.i.val, t37.i.val, t38.i.val, t39.i.val, t40.i.val, t41.i.val, s0.i.val, t43.i.val,
            s1.i.val, t45.i.val, s2.i.val, t47.i.val, s3.i.val, t49.i.val, s4.i.val, c0.i.val,
            c1.i.val, c2.i.val, c3.i.val, c4.i.val, c5.i.val, d0.i.val, c7.i.val, d1.i.val,
            c9.i.val, d2.i.val, c11.i.val, d3.i.val, c13.i.val, d4.i.val] =
        true)
    (hK :
      ∀ v_t0 v_t1 v_t2 v_t3 v_t4 v_t5 v_t6 v_t7 v_t8 v_t9 v_t10 v_t11 v_t12 v_t13 v_t14 v_t15 v_t16
        v_t17 v_t18 v_t19 v_t20 v_t21 v_t22 v_t23 v_t24 v_t25 v_t26 v_t27 v_t28 v_t29 v_t30 v_t31
        v_t32 v_t33 v_t34 v_t35 v_t36 v_t37 v_t38 v_t39 v_t40 v_t41 v_t43 v_t45 v_t47 v_t49 v_s0
        v_s1 v_s2 v_s3 v_s4 v_c0 v_c1 v_c2 v_c3 v_c4 v_c5 v_c7 v_c9 v_c11 v_c13 : ⟦V⟧,
        ∀ R : Fe,
          R = sqr A →
            (blk.runBodyFrom
                  E[t0 := v_t0, t1 := v_t1, t2 := v_t2, t3 := v_t3, t4 := v_t4, t5 := v_t5, t6 :=
                    v_t6, t7 := v_t7, t8 := v_t8, t9 := v_t9, t10 := v_t10, t11 := v_t11, t12 :=
                    v_t12, t13 := v_t13, t14 := v_t14, t15 := v_t15, t16 := v_t16, t17 := v_t17,
                    t18 := v_t18, t19 := v_t19, t20 := v_t20, t21 := v_t21, t22 := v_t22, t23 :=
                    v_t23, t24 := v_t24, t25 := v_t25, t26 := v_t26, t27 := v_t27, t28 := v_t28,
                    t29 := v_t29, t30 := v_t30, t31 := v_t31, t32 := v_t32, t33 := v_t33, t34 :=
                    v_t34, t35 := v_t35, t36 := v_t36, t37 := v_t37, t38 := v_t38, t39 := v_t39,
                    t40 := v_t40, t41 := v_t41, s0 := v_s0, t43 := v_t43, s1 := v_s1, t45 := v_t45,
                    s2 := v_s2, t47 := v_t47, s3 := v_s3, t49 := v_t49, s4 := v_s4, c0 := v_c0,
                    c1 := v_c1, c2 := v_c2, c3 := v_c3, c4 := v_c4, c5 := v_c5, d0 := Ty.wrap R.l0,
                    c7 := v_c7, d1 := Ty.wrap R.l1, c9 := v_c9, d2 := Ty.wrap R.l2, c11 := v_c11,
                    d3 := Ty.wrap R.l3, c13 := v_c13, d4 := Ty.wrap R.l4]
                  (pos + 66) S >>=
                g) =
              K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  have hd :
    List.Nodup
      [z.i, one.i, two.i, k38.i, k51.i, km.i, k19.i, a0.i, a1.i, a2.i, a3.i, a4.i, t0.i, t1.i, t2.i,
        t3.i, t4.i, t5.i, t6.i, t7.i, t8.i, t9.i, t10.i, t11.i, t12.i, t13.i, t14.i, t15.i, t16.i,
        t17.i, t18.i, t19.i, t20.i, t21.i, t22.i, t23.i, t24.i, t25.i, t26.i, t27.i, t28.i, t29.i,
        t30.i, t31.i, t32.i, t33.i, t34.i, t35.i, t36.i, t37.i, t38.i, t39.i, t40.i, t41.i, s0.i,
        t43.i, s1.i, t45.i, s2.i, t47.i, s3.i, t49.i, s4.i, c0.i, c1.i, c2.i, c3.i, c4.i, c5.i,
        d0.i, c7.i, d1.i, c9.i, d2.i, c11.i, d3.i, c13.i, d4.i] :=
    nodup_of_distinctB hd
  have hd₁ :
    List.Nodup
      [z.i, one.i, two.i, k38.i, k19.i, a0.i, a1.i, a2.i, a3.i, a4.i, t0.i, t1.i, t2.i, t3.i, t4.i,
        t5.i, t6.i, t7.i, t8.i, t9.i, t10.i, t11.i, t12.i, t13.i, t14.i, t15.i, t16.i, t17.i, t18.i,
        t19.i, t20.i, t21.i, t22.i, t23.i, t24.i, t25.i, t26.i, t27.i, t28.i, t29.i, t30.i, t31.i,
        t32.i, t33.i, t34.i, t35.i, t36.i, t37.i, t38.i, t39.i, t40.i, t41.i, s0.i, t43.i, s1.i,
        t45.i, s2.i, t47.i, s3.i, t49.i, s4.i] :=
    List.Nodup.sublist (by sublist_tac) hd
  have hd₂ :
    List.Nodup
      [k51.i, km.i, k19.i, s0.i, s1.i, s2.i, s3.i, s4.i, c0.i, c1.i, c2.i, c3.i, c4.i, c5.i, d0.i,
        c7.i, d1.i, c9.i, d2.i, c11.i, d3.i, c13.i, d4.i] :=
    List.Nodup.sublist (by sublist_tac) hd
  step_pattern using runBodyFrom_sqrRun
  step_pattern using runBodyFrom_carryRun'
  rw [hE]
  subst_vars
  rw [sqr_eq_carry] at hK
  exact
    hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ rfl

/-- `fd_ed25519_lane_mul( r, a, b )` as compiled, 82 instructions: `mulLooseRun` into `s0 … s4`,
then `carryRun'` of them into `d0 … d4`; `k51 km` hold `51` and the 51-bit mask. -/
def mulCRun (z one k19 k38 k51 km a0 a1 a2 a3 a4 b0 b1 b2 b3 b4 : Dst Γ V)
    (t0 t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25
      t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48
      t49 t50 t51 t52 t53 t54 t55 t56 t57 s0 t59 s1 t61 s2 t63 s3 t65 s4 c0 c1 c2 c3 c4 c5 d0 c7 d1
      c9 d2 c11 d3 c13 d4 : Dst Γ V) :
    List (Instr Γ) :=
  mulLooseRun z one k19 k38 a0 a1 a2 a3 a4 b0 b1 b2 b3 b4 t0 t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12
      t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29 t30 t31 t32 t33 t34 t35
      t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 s0 t59
      s1 t61 s2 t63 s3 t65 s4 ++
    carryRun' k51 km k19 s0 s1 s2 s3 s4 c0 c1 c2 c3 c4 c5 d0 c7 d1 c9 d2 c11 d3 c13 d4

-- 82 steps in one declaration
set_option maxHeartbeats 800000 in
/-- Where the body at `pos` is `mulCRun`, `a0 … a4` hold `A` and `b0 … b4` hold `B`: running on from
`pos` gives `K` if it does from `pos + 82` with `mul A B` in `d0 … d4`. -/
theorem runBodyFrom_mulCRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {z one k19 k38 k51 km a0 a1 a2 a3 a4 b0 b1 b2 b3 b4 t0 t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12
      t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29 t30 t31 t32 t33 t34 t35
      t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 s0 t59
      s1 t61 s2 t63 s3 t65 s4 c0 c1 c2 c3 c4 c5 d0 c7 d1 c9 d2 c11 d3 c13 d4 : Dst Γ V}
    {rest : List (Instr Γ)} {A B : Fe} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        mulCRun z one k19 k38 k51 km a0 a1 a2 a3 a4 b0 b1 b2 b3 b4 t0 t1 t2 t3 t4 t5 t6 t7 t8 t9 t10
            t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29 t30 t31 t32
            t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54
            t55 t56 t57 s0 t59 s1 t61 s2 t63 s3 t65 s4 c0 c1 c2 c3 c4 c5 d0 c7 d1 c9 d2 c11 d3 c13
            d4 ++
          rest)
    (hR :
      E ⊨ [z := Vector.replicate 8 0#64, one := Vector.replicate 8 1#64, k19 :=
        Vector.replicate 8 19#64, k38 := Vector.replicate 8 38#64, k51 := Vector.replicate 8 51#64,
        km := Vector.replicate 8 2251799813685247#64, a0 := A.l0, a1 := A.l1, a2 := A.l2, a3 :=
        A.l3, a4 := A.l4, b0 := B.l0, b1 := B.l1, b2 := B.l2, b3 := B.l3, b4 := B.l4])
    (hd :
      distinctB
          [z.i.val, one.i.val, k51.i.val, km.i.val, k19.i.val, k38.i.val, a0.i.val, a1.i.val,
            a2.i.val, a3.i.val, a4.i.val, b0.i.val, b1.i.val, b2.i.val, b3.i.val, b4.i.val,
            t0.i.val, t1.i.val, t2.i.val, t3.i.val, t4.i.val, t5.i.val, t6.i.val, t7.i.val,
            t8.i.val, t9.i.val, t10.i.val, t11.i.val, t12.i.val, t13.i.val, t14.i.val, t15.i.val,
            t16.i.val, t17.i.val, t18.i.val, t19.i.val, t20.i.val, t21.i.val, t22.i.val, t23.i.val,
            t24.i.val, t25.i.val, t26.i.val, t27.i.val, t28.i.val, t29.i.val, t30.i.val, t31.i.val,
            t32.i.val, t33.i.val, t34.i.val, t35.i.val, t36.i.val, t37.i.val, t38.i.val, t39.i.val,
            t40.i.val, t41.i.val, t42.i.val, t43.i.val, t44.i.val, t45.i.val, t46.i.val, t47.i.val,
            t48.i.val, t49.i.val, t50.i.val, t51.i.val, t52.i.val, t53.i.val, t54.i.val, t55.i.val,
            t56.i.val, t57.i.val, s0.i.val, t59.i.val, s1.i.val, t61.i.val, s2.i.val, t63.i.val,
            s3.i.val, t65.i.val, s4.i.val, c0.i.val, c1.i.val, c2.i.val, c3.i.val, c4.i.val,
            c5.i.val, d0.i.val, c7.i.val, d1.i.val, c9.i.val, d2.i.val, c11.i.val, d3.i.val,
            c13.i.val, d4.i.val] =
        true)
    (hK :
      ∀ v_t0 v_t1 v_t2 v_t3 v_t4 v_t5 v_t6 v_t7 v_t8 v_t9 v_t10 v_t11 v_t12 v_t13 v_t14 v_t15 v_t16
        v_t17 v_t18 v_t19 v_t20 v_t21 v_t22 v_t23 v_t24 v_t25 v_t26 v_t27 v_t28 v_t29 v_t30 v_t31
        v_t32 v_t33 v_t34 v_t35 v_t36 v_t37 v_t38 v_t39 v_t40 v_t41 v_t42 v_t43 v_t44 v_t45 v_t46
        v_t47 v_t48 v_t49 v_t50 v_t51 v_t52 v_t53 v_t54 v_t55 v_t56 v_t57 v_t59 v_t61 v_t63 v_t65
        v_s0 v_s1 v_s2 v_s3 v_s4 v_c0 v_c1 v_c2 v_c3 v_c4 v_c5 v_c7 v_c9 v_c11 v_c13 : ⟦V⟧,
        ∀ R : Fe,
          R = mul A B →
            (blk.runBodyFrom
                  E[t0 := v_t0, t1 := v_t1, t2 := v_t2, t3 := v_t3, t4 := v_t4, t5 := v_t5, t6 :=
                    v_t6, t7 := v_t7, t8 := v_t8, t9 := v_t9, t10 := v_t10, t11 := v_t11, t12 :=
                    v_t12, t13 := v_t13, t14 := v_t14, t15 := v_t15, t16 := v_t16, t17 := v_t17,
                    t18 := v_t18, t19 := v_t19, t20 := v_t20, t21 := v_t21, t22 := v_t22, t23 :=
                    v_t23, t24 := v_t24, t25 := v_t25, t26 := v_t26, t27 := v_t27, t28 := v_t28,
                    t29 := v_t29, t30 := v_t30, t31 := v_t31, t32 := v_t32, t33 := v_t33, t34 :=
                    v_t34, t35 := v_t35, t36 := v_t36, t37 := v_t37, t38 := v_t38, t39 := v_t39,
                    t40 := v_t40, t41 := v_t41, t42 := v_t42, t43 := v_t43, t44 := v_t44, t45 :=
                    v_t45, t46 := v_t46, t47 := v_t47, t48 := v_t48, t49 := v_t49, t50 := v_t50,
                    t51 := v_t51, t52 := v_t52, t53 := v_t53, t54 := v_t54, t55 := v_t55, t56 :=
                    v_t56, t57 := v_t57, s0 := v_s0, t59 := v_t59, s1 := v_s1, t61 := v_t61, s2 :=
                    v_s2, t63 := v_t63, s3 := v_s3, t65 := v_t65, s4 := v_s4, c0 := v_c0, c1 :=
                    v_c1, c2 := v_c2, c3 := v_c3, c4 := v_c4, c5 := v_c5, d0 := Ty.wrap R.l0, c7 :=
                    v_c7, d1 := Ty.wrap R.l1, c9 := v_c9, d2 := Ty.wrap R.l2, c11 := v_c11, d3 :=
                    Ty.wrap R.l3, c13 := v_c13, d4 := Ty.wrap R.l4]
                  (pos + 82) S >>=
                g) =
              K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  have hd :
    List.Nodup
      [z.i, one.i, k51.i, km.i, k19.i, k38.i, a0.i, a1.i, a2.i, a3.i, a4.i, b0.i, b1.i, b2.i, b3.i,
        b4.i, t0.i, t1.i, t2.i, t3.i, t4.i, t5.i, t6.i, t7.i, t8.i, t9.i, t10.i, t11.i, t12.i,
        t13.i, t14.i, t15.i, t16.i, t17.i, t18.i, t19.i, t20.i, t21.i, t22.i, t23.i, t24.i, t25.i,
        t26.i, t27.i, t28.i, t29.i, t30.i, t31.i, t32.i, t33.i, t34.i, t35.i, t36.i, t37.i, t38.i,
        t39.i, t40.i, t41.i, t42.i, t43.i, t44.i, t45.i, t46.i, t47.i, t48.i, t49.i, t50.i, t51.i,
        t52.i, t53.i, t54.i, t55.i, t56.i, t57.i, s0.i, t59.i, s1.i, t61.i, s2.i, t63.i, s3.i,
        t65.i, s4.i, c0.i, c1.i, c2.i, c3.i, c4.i, c5.i, d0.i, c7.i, d1.i, c9.i, d2.i, c11.i, d3.i,
        c13.i, d4.i] :=
    nodup_of_distinctB hd
  have hd₁ :
    List.Nodup
      [z.i, one.i, k19.i, k38.i, a0.i, a1.i, a2.i, a3.i, a4.i, b0.i, b1.i, b2.i, b3.i, b4.i, t0.i,
        t1.i, t2.i, t3.i, t4.i, t5.i, t6.i, t7.i, t8.i, t9.i, t10.i, t11.i, t12.i, t13.i, t14.i,
        t15.i, t16.i, t17.i, t18.i, t19.i, t20.i, t21.i, t22.i, t23.i, t24.i, t25.i, t26.i, t27.i,
        t28.i, t29.i, t30.i, t31.i, t32.i, t33.i, t34.i, t35.i, t36.i, t37.i, t38.i, t39.i, t40.i,
        t41.i, t42.i, t43.i, t44.i, t45.i, t46.i, t47.i, t48.i, t49.i, t50.i, t51.i, t52.i, t53.i,
        t54.i, t55.i, t56.i, t57.i, s0.i, t59.i, s1.i, t61.i, s2.i, t63.i, s3.i, t65.i, s4.i] :=
    List.Nodup.sublist (by sublist_tac) hd
  have hd₂ :
    List.Nodup
      [k51.i, km.i, k19.i, s0.i, s1.i, s2.i, s3.i, s4.i, c0.i, c1.i, c2.i, c3.i, c4.i, c5.i, d0.i,
        c7.i, d1.i, c9.i, d2.i, c11.i, d3.i, c13.i, d4.i] :=
    List.Nodup.sublist (by sublist_tac) hd
  step_pattern using runBodyFrom_mulLooseRun
  step_pattern using runBodyFrom_carryRun'
  rw [hE]
  subst_vars
  rw [mul_eq_carry] at hK
  exact
    hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ rfl


/-- `fd_ed25519_lane_mul_( r, a, b, 0 )` as compiled with the next product's four `getelementptr`s
interleaved, 71 instructions: `mulLooseRun` into `t58 t60 t63 t66 t69`, `g1 … g4` holding `r` plus
`o1 … o4`. -/
def mulGepRun (o1 o2 o3 o4 : Nat) (z one k19 k38 a0 a1 a2 a3 a4 b0 b1 b2 b3 b4 : Dst Γ V)
    (r : Reg Γ .ptr)
    (t0 t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25
        t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48
        t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 : Dst Γ V)
    (g1 : Dst Γ .ptr) (t62 t63 : Dst Γ V) (g2 : Dst Γ .ptr) (t65 t66 : Dst Γ V) (g3 : Dst Γ .ptr)
    (t68 t69 : Dst Γ V) (g4 : Dst Γ .ptr) :
    List (Instr Γ) :=
  [.ternop .vpmadd52h t0 (.val z.i z.h) (.val a0.i a0.h) (.val b0.i b0.h),
    .binop (.vector (.shl {})) t1 (.val t0.i t0.h) (.val one.i one.h),
    .ternop .vpmadd52l t2 (.val t1.i t1.h) (.val a0.i a0.h) (.val b1.i b1.h),
    .ternop .vpmadd52l t3 (.val t2.i t2.h) (.val a1.i a1.h) (.val b0.i b0.h),
    .ternop .vpmadd52h t4 (.val z.i z.h) (.val a0.i a0.h) (.val b1.i b1.h),
    .ternop .vpmadd52h t5 (.val t4.i t4.h) (.val a1.i a1.h) (.val b0.i b0.h),
    .binop (.vector (.shl {})) t6 (.val t5.i t5.h) (.val one.i one.h),
    .ternop .vpmadd52l t7 (.val t6.i t6.h) (.val a0.i a0.h) (.val b2.i b2.h),
    .ternop .vpmadd52l t8 (.val t7.i t7.h) (.val a1.i a1.h) (.val b1.i b1.h),
    .ternop .vpmadd52l t9 (.val t8.i t8.h) (.val a2.i a2.h) (.val b0.i b0.h),
    .ternop .vpmadd52h t10 (.val z.i z.h) (.val a0.i a0.h) (.val b2.i b2.h),
    .ternop .vpmadd52h t11 (.val t10.i t10.h) (.val a1.i a1.h) (.val b1.i b1.h),
    .ternop .vpmadd52h t12 (.val t11.i t11.h) (.val a2.i a2.h) (.val b0.i b0.h),
    .binop (.vector (.shl {})) t13 (.val t12.i t12.h) (.val one.i one.h),
    .ternop .vpmadd52l t14 (.val t13.i t13.h) (.val a0.i a0.h) (.val b3.i b3.h),
    .ternop .vpmadd52l t15 (.val t14.i t14.h) (.val a1.i a1.h) (.val b2.i b2.h),
    .ternop .vpmadd52l t16 (.val t15.i t15.h) (.val a2.i a2.h) (.val b1.i b1.h),
    .ternop .vpmadd52l t17 (.val t16.i t16.h) (.val a3.i a3.h) (.val b0.i b0.h),
    .ternop .vpmadd52h t18 (.val z.i z.h) (.val a0.i a0.h) (.val b3.i b3.h),
    .ternop .vpmadd52h t19 (.val t18.i t18.h) (.val a1.i a1.h) (.val b2.i b2.h),
    .ternop .vpmadd52h t20 (.val t19.i t19.h) (.val a2.i a2.h) (.val b1.i b1.h),
    .ternop .vpmadd52h t21 (.val t20.i t20.h) (.val a3.i a3.h) (.val b0.i b0.h),
    .binop (.vector (.shl {})) t22 (.val t21.i t21.h) (.val one.i one.h),
    .ternop .vpmadd52l t23 (.val t22.i t22.h) (.val a0.i a0.h) (.val b4.i b4.h),
    .ternop .vpmadd52l t24 (.val t23.i t23.h) (.val a1.i a1.h) (.val b3.i b3.h),
    .ternop .vpmadd52l t25 (.val t24.i t24.h) (.val a2.i a2.h) (.val b2.i b2.h),
    .ternop .vpmadd52l t26 (.val t25.i t25.h) (.val a3.i a3.h) (.val b1.i b1.h),
    .ternop .vpmadd52l t27 (.val t26.i t26.h) (.val a4.i a4.h) (.val b0.i b0.h),
    .ternop .vpmadd52h t28 (.val z.i z.h) (.val a0.i a0.h) (.val b4.i b4.h),
    .ternop .vpmadd52h t29 (.val t28.i t28.h) (.val a1.i a1.h) (.val b3.i b3.h),
    .ternop .vpmadd52h t30 (.val t29.i t29.h) (.val a2.i a2.h) (.val b2.i b2.h),
    .ternop .vpmadd52h t31 (.val t30.i t30.h) (.val a3.i a3.h) (.val b1.i b1.h),
    .ternop .vpmadd52h t32 (.val t31.i t31.h) (.val a4.i a4.h) (.val b0.i b0.h),
    .binop (.vector (.shl {})) t33 (.val t32.i t32.h) (.val one.i one.h),
    .ternop .vpmadd52l t34 (.val t33.i t33.h) (.val a1.i a1.h) (.val b4.i b4.h),
    .ternop .vpmadd52l t35 (.val t34.i t34.h) (.val a2.i a2.h) (.val b3.i b3.h),
    .ternop .vpmadd52l t36 (.val t35.i t35.h) (.val a3.i a3.h) (.val b2.i b2.h),
    .ternop .vpmadd52l t37 (.val t36.i t36.h) (.val a4.i a4.h) (.val b1.i b1.h),
    .ternop .vpmadd52h t38 (.val z.i z.h) (.val a1.i a1.h) (.val b4.i b4.h),
    .ternop .vpmadd52h t39 (.val t38.i t38.h) (.val a2.i a2.h) (.val b3.i b3.h),
    .ternop .vpmadd52h t40 (.val t39.i t39.h) (.val a3.i a3.h) (.val b2.i b2.h),
    .ternop .vpmadd52h t41 (.val t40.i t40.h) (.val a4.i a4.h) (.val b1.i b1.h),
    .binop (.vector (.shl {})) t42 (.val t41.i t41.h) (.val one.i one.h),
    .ternop .vpmadd52l t43 (.val t42.i t42.h) (.val a2.i a2.h) (.val b4.i b4.h),
    .ternop .vpmadd52l t44 (.val t43.i t43.h) (.val a3.i a3.h) (.val b3.i b3.h),
    .ternop .vpmadd52l t45 (.val t44.i t44.h) (.val a4.i a4.h) (.val b2.i b2.h),
    .ternop .vpmadd52h t46 (.val z.i z.h) (.val a2.i a2.h) (.val b4.i b4.h),
    .ternop .vpmadd52h t47 (.val t46.i t46.h) (.val a3.i a3.h) (.val b3.i b3.h),
    .ternop .vpmadd52h t48 (.val t47.i t47.h) (.val a4.i a4.h) (.val b2.i b2.h),
    .binop (.vector (.shl {})) t49 (.val t48.i t48.h) (.val one.i one.h),
    .ternop .vpmadd52l t50 (.val t49.i t49.h) (.val a3.i a3.h) (.val b4.i b4.h),
    .ternop .vpmadd52l t51 (.val t50.i t50.h) (.val a4.i a4.h) (.val b3.i b3.h),
    .ternop .vpmadd52h t52 (.val z.i z.h) (.val a3.i a3.h) (.val b4.i b4.h),
    .ternop .vpmadd52h t53 (.val t52.i t52.h) (.val a4.i a4.h) (.val b3.i b3.h),
    .binop (.vector (.shl {})) t54 (.val t53.i t53.h) (.val one.i one.h),
    .ternop .vpmadd52l t55 (.val t54.i t54.h) (.val a4.i a4.h) (.val b4.i b4.h),
    .ternop .vpmadd52h t56 (.val z.i z.h) (.val a4.i a4.h) (.val b4.i b4.h),
    .binop (.vector (.mul {})) t57 (.val t37.i t37.h) (.val k19.i k19.h),
    .ternop .vpmadd52l t58 (.val t57.i t57.h) (.val a0.i a0.h) (.val b0.i b0.h),
    .binop (.vector (.mul {})) t59 (.val t45.i t45.h) (.val k19.i k19.h),
    .binop (.vector (.add {})) t60 (.val t59.i t59.h) (.val t3.i t3.h),
    .unop (.gepConst { nusw := true, nuw := true } (o1 : Int)) g1 r,
    .binop (.vector (.mul {})) t62 (.val t51.i t51.h) (.val k19.i k19.h),
    .binop (.vector (.add {})) t63 (.val t62.i t62.h) (.val t9.i t9.h),
    .unop (.gepConst { nusw := true, nuw := true } (o2 : Int)) g2 r,
    .binop (.vector (.mul {})) t65 (.val t55.i t55.h) (.val k19.i k19.h),
    .binop (.vector (.add {})) t66 (.val t65.i t65.h) (.val t17.i t17.h),
    .unop (.gepConst { nusw := true, nuw := true } (o3 : Int)) g3 r,
    .binop (.vector (.mul {})) t68 (.val t56.i t56.h) (.val k38.i k38.h),
    .binop (.vector (.add {})) t69 (.val t68.i t68.h) (.val t27.i t27.h),
    .unop (.gepConst { nusw := true, nuw := true } (o4 : Int)) g4 r]

-- 71 steps in one declaration
set_option maxHeartbeats 800000 in
/-- Where the body at `pos` is `mulGepRun`, `a0 … a4` hold `A`, `b0 … b4` hold `B` and `r` the start
`R` of a range of 1280 bytes that does not wrap: running on from `pos` gives `K` if it does from
`pos + 71` with `mul A B false` in `t58 t60 t63 t66 t69` and `R` plus `o1 … o4` in `g1 … g4`. -/
theorem runBodyFrom_mulGepRun (o1 o2 o3 o4 : Nat) {nb : Nat} {tRets : List Ty}
    {bp : Fin nb → List Ty} {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {z one k19 k38 a0 a1 a2 a3 a4 b0 b1 b2 b3 b4 t0 t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14
      t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37
      t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60
      t62 t63 t65 t66 t68 t69 : Dst Γ V}
    {g1 g2 g3 g4 : Dst Γ .ptr} {r : Reg Γ .ptr} {rest : List (Instr Γ)}
    {A0 A1 A2 A3 A4 B0 B1 B2 B3 B4 : Wwl} {R : Pointer} {S : GlobalState} {β : Type}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        mulGepRun o1 o2 o3 o4 z one k19 k38 a0 a1 a2 a3 a4 b0 b1 b2 b3 b4 r t0 t1 t2 t3 t4 t5 t6 t7
          t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29 t30
          t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52
          t53 t54 t55 t56 t57 t58 t59 t60 g1 t62 t63 g2 t65 t66 g3 t68 t69 g4 ++
          rest)
    (hR :
      E ⊨ [z := Vector.replicate 8 0#64, one := Vector.replicate 8 1#64, k19 :=
        Vector.replicate 8 19#64, k38 := Vector.replicate 8 38#64, a0 := A0, a1 := A1, a2 := A2,
        a3 := A3, a4 := A4, b0 := B0, b1 := B1, b2 := B2, b3 := B3, b4 := B4, r := R])
    (hd :
      distinctB
         [z.i.val, one.i.val, k19.i.val, k38.i.val, a0.i.val, a1.i.val, a2.i.val, a3.i.val,
          a4.i.val, b0.i.val, b1.i.val, b2.i.val, b3.i.val, b4.i.val, t0.i.val, t1.i.val, t2.i.val,
          t3.i.val, t4.i.val, t5.i.val, t6.i.val, t7.i.val, t8.i.val, t9.i.val, t10.i.val,
          t11.i.val, t12.i.val, t13.i.val, t14.i.val, t15.i.val, t16.i.val, t17.i.val, t18.i.val,
          t19.i.val, t20.i.val, t21.i.val, t22.i.val, t23.i.val, t24.i.val, t25.i.val, t26.i.val,
          t27.i.val, t28.i.val, t29.i.val, t30.i.val, t31.i.val, t32.i.val, t33.i.val, t34.i.val,
          t35.i.val, t36.i.val, t37.i.val, t38.i.val, t39.i.val, t40.i.val, t41.i.val, t42.i.val,
          t43.i.val, t44.i.val, t45.i.val, t46.i.val, t47.i.val, t48.i.val, t49.i.val, t50.i.val,
          t51.i.val, t52.i.val, t53.i.val, t54.i.val, t55.i.val, t56.i.val, t57.i.val, t58.i.val,
          t59.i.val, t60.i.val, g1.i.val, t62.i.val, t63.i.val, g2.i.val, t65.i.val, t66.i.val,
          g3.i.val, t68.i.val, t69.i.val, g4.i.val] =
        true)
    (hp : r ≠ .val g1.i g1.h ∧ r ≠ .val g2.i g2.h ∧ r ≠ .val g3.i g3.h)
    (hov : ¬R.offset.uaddOverflow 1280#64) (ho : o1 ≤ 1280 ∧ o2 ≤ 1280 ∧ o3 ≤ 1280 ∧ o4 ≤ 1280)
    (hK :
      ∀ v_t0 v_t1 v_t2 v_t3 v_t4 v_t5 v_t6 v_t7 v_t8 v_t9 v_t10 v_t11 v_t12 v_t13 v_t14 v_t15 v_t16
        v_t17 v_t18 v_t19 v_t20 v_t21 v_t22 v_t23 v_t24 v_t25 v_t26 v_t27 v_t28 v_t29 v_t30 v_t31
        v_t32 v_t33 v_t34 v_t35 v_t36 v_t37 v_t38 v_t39 v_t40 v_t41 v_t42 v_t43 v_t44 v_t45 v_t46
        v_t47 v_t48 v_t49 v_t50 v_t51 v_t52 v_t53 v_t54 v_t55 v_t56 v_t57 v_t59 v_t62 v_t65 v_t68
        : ⟦V⟧,
        (blk.runBodyFrom
              E[t0 := v_t0, t1 := v_t1, t2 := v_t2, t3 := v_t3, t4 := v_t4, t5 := v_t5, t6 := v_t6,
              t7 := v_t7, t8 := v_t8, t9 := v_t9, t10 := v_t10, t11 := v_t11, t12 := v_t12,
              t13 := v_t13, t14 := v_t14, t15 := v_t15, t16 := v_t16, t17 := v_t17, t18 := v_t18,
              t19 := v_t19, t20 := v_t20, t21 := v_t21, t22 := v_t22, t23 := v_t23, t24 := v_t24,
              t25 := v_t25, t26 := v_t26, t27 := v_t27, t28 := v_t28, t29 := v_t29, t30 := v_t30,
              t31 := v_t31, t32 := v_t32, t33 := v_t33, t34 := v_t34, t35 := v_t35, t36 := v_t36,
              t37 := v_t37, t38 := v_t38, t39 := v_t39, t40 := v_t40, t41 := v_t41, t42 := v_t42,
              t43 := v_t43, t44 := v_t44, t45 := v_t45, t46 := v_t46, t47 := v_t47, t48 := v_t48,
              t49 := v_t49, t50 := v_t50, t51 := v_t51, t52 := v_t52, t53 := v_t53, t54 := v_t54,
              t55 := v_t55, t56 := v_t56, t57 := v_t57,
              t58 := Ty.wrap (mul ⟨A0, A1, A2, A3, A4⟩ ⟨B0, B1, B2, B3, B4⟩ false).l0, t59 := v_t59,
              t60 := Ty.wrap (mul ⟨A0, A1, A2, A3, A4⟩ ⟨B0, B1, B2, B3, B4⟩ false).l1,
              g1 := .value (R.add (BitVec.ofNat 64 o1)), t62 := v_t62,
              t63 := Ty.wrap (mul ⟨A0, A1, A2, A3, A4⟩ ⟨B0, B1, B2, B3, B4⟩ false).l2,
              g2 := .value (R.add (BitVec.ofNat 64 o2)), t65 := v_t65,
              t66 := Ty.wrap (mul ⟨A0, A1, A2, A3, A4⟩ ⟨B0, B1, B2, B3, B4⟩ false).l3,
              g3 := .value (R.add (BitVec.ofNat 64 o3)), t68 := v_t68,
              t69 := Ty.wrap (mul ⟨A0, A1, A2, A3, A4⟩ ⟨B0, B1, B2, B3, B4⟩ false).l4,
              g4 := .value (R.add (BitVec.ofNat 64 o4))]
              (pos + 71) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  have hd :
    List.Nodup
     [z.i, one.i, k19.i, k38.i, a0.i, a1.i, a2.i, a3.i, a4.i, b0.i, b1.i, b2.i, b3.i, b4.i, t0.i,
      t1.i, t2.i, t3.i, t4.i, t5.i, t6.i, t7.i, t8.i, t9.i, t10.i, t11.i, t12.i, t13.i, t14.i,
      t15.i, t16.i, t17.i, t18.i, t19.i, t20.i, t21.i, t22.i, t23.i, t24.i, t25.i, t26.i, t27.i,
      t28.i, t29.i, t30.i, t31.i, t32.i, t33.i, t34.i, t35.i, t36.i, t37.i, t38.i, t39.i, t40.i,
      t41.i, t42.i, t43.i, t44.i, t45.i, t46.i, t47.i, t48.i, t49.i, t50.i, t51.i, t52.i, t53.i,
      t54.i, t55.i, t56.i, t57.i, t58.i, t59.i, t60.i, g1.i, t62.i, t63.i, g2.i, t65.i, t66.i, g3.i,
      t68.i, t69.i, g4.i] :=
    nodup_of_distinctB hd
  obtain ⟨hr1, hr2, hr3⟩ := hp
  obtain ⟨ho1, ho2, ho3, ho4⟩ := ho
  iterate 61 step_pure
  step_pure [gepConst_ofNat hov (by omega)]
  iterate 2 step_pure
  step_pure [gepConst_ofNat hov (by omega)]
  iterate 2 step_pure
  step_pure [gepConst_ofNat hov (by omega)]
  iterate 2 step_pure
  step_pure [gepConst_ofNat hov (by omega)]
  rw [hE]
  rw [mul_compiled] at hK
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

/-- `fd_ed25519_lane_carry` of a loose product as compiled, its limbs stored, 20 instructions:
`x0 … x4` carried into `d0 … d4`, stored at `p0` and `g1 … g4`. -/
def carryStoreRun (k51 km k19 x0 x1 x2 x3 x4 : Dst Γ V) (p0 g1 g2 g3 g4 : Reg Γ .ptr)
    (t71 t72 t73 t74 t75 t76 d0 t78 d1 t80 d2 t82 d3 t84 d4 : Dst Γ V) :
    List (Instr Γ) :=
  [.binop (.vector (.lshr false)) t71 (.val x0.i x0.h) (.val k51.i k51.h),
    .binop (.vector (.lshr false)) t72 (.val x1.i x1.h) (.val k51.i k51.h),
    .binop (.vector (.lshr false)) t73 (.val x2.i x2.h) (.val k51.i k51.h),
    .binop (.vector (.lshr false)) t74 (.val x3.i x3.h) (.val k51.i k51.h),
    .binop (.vector (.lshr false)) t75 (.val x4.i x4.h) (.val k51.i k51.h),
    .binop (.vector .and) t76 (.val x0.i x0.h) (.val km.i km.h),
    .ternop .vpmadd52l d0 (.val t76.i t76.h) (.val t75.i t75.h) (.val k19.i k19.h),
    .store p0 (.val d0.i d0.h),
    .binop (.vector .and) t78 (.val x1.i x1.h) (.val km.i km.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d1 (.val t71.i t71.h) (.val t78.i t78.h),
    .store g1 (.val d1.i d1.h),
    .binop (.vector .and) t80 (.val x2.i x2.h) (.val km.i km.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d2 (.val t80.i t80.h) (.val t72.i t72.h),
    .store g2 (.val d2.i d2.h),
    .binop (.vector .and) t82 (.val x3.i x3.h) (.val km.i km.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d3 (.val t82.i t82.h) (.val t73.i t73.h),
    .store g3 (.val d3.i d3.h),
    .binop (.vector .and) t84 (.val x4.i x4.h) (.val km.i km.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d4 (.val t84.i t84.h) (.val t74.i t74.h),
    .store g4 (.val d4.i d4.h)]

/-- Where the body at `pos` is `carryStoreRun` and `x0 … x4` hold `X`: running on from `pos` gives
`K` if it does from `pos + 20` with `carry X` in `d0 … d4` and stored at `P0` and `G1 … G4`. -/
theorem runBodyFrom_carryStoreRun {nb : Nat} {tRets : List Ty} {bp : Fin nb → List Ty}
    {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {k51 km k19 x0 x1 x2 x3 x4 t71 t72 t73 t74 t75 t76 d0 t78 d1 t80 d2 t82 d3 t84 d4 : Dst Γ V}
    {p0 g1 g2 g3 g4 : Reg Γ .ptr} {rest : List (Instr Γ)} {X : Fe}
    {P0 G1 G2 G3 G4 : Pointer} {S : GlobalState} {β : Type}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        carryStoreRun k51 km k19 x0 x1 x2 x3 x4 p0 g1 g2 g3 g4 t71 t72 t73 t74 t75 t76 d0 t78 d1 t80
          d2 t82 d3 t84 d4 ++
          rest)
    (hR :
      E ⊨ [k51 := Vector.replicate 8 51#64, km := Vector.replicate 8 2251799813685247#64, k19 :=
        Vector.replicate 8 19#64, x0 := X.l0, x1 := X.l1, x2 := X.l2, x3 := X.l3, x4 := X.l4,
            p0 := P0,
        g1 := G1, g2 := G2, g3 := G3, g4 := G4])
    (hd :
      distinctB
         [k51.i.val, km.i.val, k19.i.val, x0.i.val, x1.i.val, x2.i.val, x3.i.val, x4.i.val,
          t71.i.val, t72.i.val, t73.i.val, t74.i.val, t75.i.val, t76.i.val, d0.i.val, t78.i.val,
          d1.i.val, t80.i.val, d2.i.val, t82.i.val, d3.i.val, t84.i.val, d4.i.val] =
        true)
    (hroom :
      Room S.mem P0 512 ∧ Room S.mem G1 512 ∧ Room S.mem G2 512 ∧ Room S.mem G3 512 ∧
        Room S.mem G4 512)
    (hK :
      ∀ v_t71 v_t72 v_t73 v_t74 v_t75 v_t76 v_t78 v_t80 v_t82 v_t84 : ⟦V⟧,
        (blk.runBodyFrom
              E[t71 := v_t71, t72 := v_t72, t73 := v_t73, t74 := v_t74, t75 := v_t75, t76 := v_t76,
              d0 := Ty.wrap (carry X).l0, t78 := v_t78, d1 := Ty.wrap (carry X).l1, t80 := v_t80,
              d2 := Ty.wrap (carry X).l2, t82 := v_t82, d3 := Ty.wrap (carry X).l3, t84 := v_t84,
              d4 := Ty.wrap (carry X).l4]
              (pos + 20)
              { S with
                mem :=
                  ((((S.mem.storeVec P0 (carry X).l0).storeVec G1 (carry X).l1).storeVec G2
                          (carry X).l2).storeVec G3 (carry X).l3).storeVec G4
                    (carry X).l4 } >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  have hd :
    List.Nodup
     [k51.i, km.i, k19.i, x0.i, x1.i, x2.i, x3.i, x4.i, t71.i, t72.i, t73.i, t74.i, t75.i, t76.i,
      d0.i, t78.i, d1.i, t80.i, d2.i, t82.i, d3.i, t84.i, d4.i] :=
    nodup_of_distinctB hd
  obtain ⟨hq0, hq1, hq2, hq3, hq4⟩ := hroom
  iterate 7 step_pure
  step_store
  iterate 2 step_pure
  step_store
  iterate 2 step_pure
  step_store
  iterate 2 step_pure
  step_store
  iterate 2 step_pure
  step_store
  rw [hE, hS]
  rw [carry_compiled'] at hK
  exact hK _ _ _ _ _ _ _ _ _ _

/-- `fd_ed25519_lane_sqr_( r, a, 0 )` as compiled with the next store's four `getelementptr`s
interleaved, 55 instructions: `sqrRun` into `d0 … d4`, `g1 … g4` holding `r` plus `o1 … o4`. -/
def sqrGepRun (o1 o2 o3 o4 : Nat) (z one two k38 k19 a0 a1 a2 a3 a4 : Dst Γ V) (r : Reg Γ .ptr)
    (t0 t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25
        t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 d0 t43 d1 : Dst Γ V)
    (g1 : Dst Γ .ptr) (t45 d2 : Dst Γ V) (g2 : Dst Γ .ptr) (t47 d3 : Dst Γ V) (g3 : Dst Γ .ptr)
    (t49 d4 : Dst Γ V) (g4 : Dst Γ .ptr) :
    List (Instr Γ) :=
  [.ternop .vpmadd52h t0 (.val z.i z.h) (.val a0.i a0.h) (.val a0.i a0.h),
    .ternop .vpmadd52l t1 (.val t0.i t0.h) (.val a0.i a0.h) (.val a1.i a1.h),
    .binop (.vector (.shl {})) t2 (.val t1.i t1.h) (.val one.i one.h),
    .ternop .vpmadd52h t3 (.val z.i z.h) (.val a0.i a0.h) (.val a1.i a1.h),
    .binop (.vector (.shl {})) t4 (.val t3.i t3.h) (.val one.i one.h),
    .ternop .vpmadd52l t5 (.val t4.i t4.h) (.val a0.i a0.h) (.val a2.i a2.h),
    .binop (.vector (.shl {})) t6 (.val t5.i t5.h) (.val one.i one.h),
    .ternop .vpmadd52l t7 (.val t6.i t6.h) (.val a1.i a1.h) (.val a1.i a1.h),
    .ternop .vpmadd52h t8 (.val z.i z.h) (.val a0.i a0.h) (.val a2.i a2.h),
    .binop (.vector (.shl {})) t9 (.val t8.i t8.h) (.val one.i one.h),
    .ternop .vpmadd52h t10 (.val t9.i t9.h) (.val a1.i a1.h) (.val a1.i a1.h),
    .ternop .vpmadd52l t11 (.val t10.i t10.h) (.val a0.i a0.h) (.val a3.i a3.h),
    .ternop .vpmadd52l t12 (.val t11.i t11.h) (.val a1.i a1.h) (.val a2.i a2.h),
    .binop (.vector (.shl {})) t13 (.val t12.i t12.h) (.val one.i one.h),
    .ternop .vpmadd52h t14 (.val z.i z.h) (.val a0.i a0.h) (.val a3.i a3.h),
    .ternop .vpmadd52h t15 (.val t14.i t14.h) (.val a1.i a1.h) (.val a2.i a2.h),
    .binop (.vector (.shl {})) t16 (.val t15.i t15.h) (.val one.i one.h),
    .ternop .vpmadd52l t17 (.val t16.i t16.h) (.val a0.i a0.h) (.val a4.i a4.h),
    .ternop .vpmadd52l t18 (.val t17.i t17.h) (.val a1.i a1.h) (.val a3.i a3.h),
    .binop (.vector (.shl {})) t19 (.val t18.i t18.h) (.val one.i one.h),
    .ternop .vpmadd52l t20 (.val t19.i t19.h) (.val a2.i a2.h) (.val a2.i a2.h),
    .ternop .vpmadd52h t21 (.val z.i z.h) (.val a0.i a0.h) (.val a4.i a4.h),
    .ternop .vpmadd52h t22 (.val t21.i t21.h) (.val a1.i a1.h) (.val a3.i a3.h),
    .binop (.vector (.shl {})) t23 (.val t22.i t22.h) (.val one.i one.h),
    .ternop .vpmadd52h t24 (.val t23.i t23.h) (.val a2.i a2.h) (.val a2.i a2.h),
    .ternop .vpmadd52l t25 (.val t24.i t24.h) (.val a1.i a1.h) (.val a4.i a4.h),
    .ternop .vpmadd52l t26 (.val t25.i t25.h) (.val a2.i a2.h) (.val a3.i a3.h),
    .ternop .vpmadd52h t27 (.val z.i z.h) (.val a1.i a1.h) (.val a4.i a4.h),
    .ternop .vpmadd52h t28 (.val t27.i t27.h) (.val a2.i a2.h) (.val a3.i a3.h),
    .binop (.vector (.shl {})) t29 (.val t28.i t28.h) (.val one.i one.h),
    .ternop .vpmadd52l t30 (.val t29.i t29.h) (.val a2.i a2.h) (.val a4.i a4.h),
    .binop (.vector (.shl {})) t31 (.val t30.i t30.h) (.val one.i one.h),
    .ternop .vpmadd52l t32 (.val t31.i t31.h) (.val a3.i a3.h) (.val a3.i a3.h),
    .ternop .vpmadd52h t33 (.val z.i z.h) (.val a2.i a2.h) (.val a4.i a4.h),
    .binop (.vector (.shl {})) t34 (.val t33.i t33.h) (.val one.i one.h),
    .ternop .vpmadd52h t35 (.val t34.i t34.h) (.val a3.i a3.h) (.val a3.i a3.h),
    .ternop .vpmadd52l t36 (.val t35.i t35.h) (.val a3.i a3.h) (.val a4.i a4.h),
    .ternop .vpmadd52h t37 (.val z.i z.h) (.val a3.i a3.h) (.val a4.i a4.h),
    .binop (.vector (.shl {})) t38 (.val t37.i t37.h) (.val two.i two.h),
    .ternop .vpmadd52l t39 (.val t38.i t38.h) (.val a4.i a4.h) (.val a4.i a4.h),
    .ternop .vpmadd52h t40 (.val z.i z.h) (.val a4.i a4.h) (.val a4.i a4.h),
    .binop (.vector (.mul {})) t41 (.val t26.i t26.h) (.val k38.i k38.h),
    .ternop .vpmadd52l d0 (.val t41.i t41.h) (.val a0.i a0.h) (.val a0.i a0.h),
    .binop (.vector (.mul {})) t43 (.val t32.i t32.h) (.val k19.i k19.h),
    .binop (.vector (.add {})) d1 (.val t43.i t43.h) (.val t2.i t2.h),
    .unop (.gepConst { nusw := true, nuw := true } (o1 : Int)) g1 r,
    .binop (.vector (.mul {})) t45 (.val t36.i t36.h) (.val k38.i k38.h),
    .binop (.vector (.add {})) d2 (.val t45.i t45.h) (.val t7.i t7.h),
    .unop (.gepConst { nusw := true, nuw := true } (o2 : Int)) g2 r,
    .binop (.vector (.mul {})) t47 (.val t39.i t39.h) (.val k19.i k19.h),
    .binop (.vector (.add {})) d3 (.val t47.i t47.h) (.val t13.i t13.h),
    .unop (.gepConst { nusw := true, nuw := true } (o3 : Int)) g3 r,
    .binop (.vector (.mul {})) t49 (.val t40.i t40.h) (.val k38.i k38.h),
    .binop (.vector (.add {})) d4 (.val t49.i t49.h) (.val t20.i t20.h),
    .unop (.gepConst { nusw := true, nuw := true } (o4 : Int)) g4 r]

-- 55 steps in one declaration
set_option maxHeartbeats 800000 in
/-- Where the body at `pos` is `sqrGepRun`, `a0 … a4` hold `A` and `r` the start `R` of a range of
1280
bytes that does not wrap: running on from `pos` gives `K` if it does from `pos + 55` with
`sqr A false` in `d0 … d4` and `R` plus `o1 … o4` in `g1 … g4`. -/
theorem runBodyFrom_sqrGepRun (o1 o2 o3 o4 : Nat) {nb : Nat} {tRets : List Ty}
    {bp : Fin nb → List Ty} {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {z one two k38 k19 a0 a1 a2 a3 a4 t0 t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17
      t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40
      t41 d0 t43 d1 t45 d2 t47 d3 t49 d4 : Dst Γ V}
    {g1 g2 g3 g4 : Dst Γ .ptr} {r : Reg Γ .ptr} {rest : List (Instr Γ)}
    {A0 A1 A2 A3 A4 : Wwl} {R : Pointer} {S : GlobalState} {β : Type}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        sqrGepRun o1 o2 o3 o4 z one two k38 k19 a0 a1 a2 a3 a4 r t0 t1 t2 t3 t4 t5 t6 t7 t8 t9 t10
          t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29 t30 t31 t32
          t33 t34 t35 t36 t37 t38 t39 t40 t41 d0 t43 d1 g1 t45 d2 g2 t47 d3 g3 t49 d4 g4 ++
          rest)
    (hR :
      E ⊨ [z := Vector.replicate 8 0#64, one := Vector.replicate 8 1#64, two :=
        Vector.replicate 8 2#64, k38 := Vector.replicate 8 38#64, k19 := Vector.replicate 8 19#64,
        a0 := A0, a1 := A1, a2 := A2, a3 := A3, a4 := A4, r := R])
    (hd :
      distinctB
         [z.i.val, one.i.val, two.i.val, k38.i.val, k19.i.val, a0.i.val, a1.i.val, a2.i.val,
          a3.i.val, a4.i.val, t0.i.val, t1.i.val, t2.i.val, t3.i.val, t4.i.val, t5.i.val, t6.i.val,
          t7.i.val, t8.i.val, t9.i.val, t10.i.val, t11.i.val, t12.i.val, t13.i.val, t14.i.val,
          t15.i.val, t16.i.val, t17.i.val, t18.i.val, t19.i.val, t20.i.val, t21.i.val, t22.i.val,
          t23.i.val, t24.i.val, t25.i.val, t26.i.val, t27.i.val, t28.i.val, t29.i.val, t30.i.val,
          t31.i.val, t32.i.val, t33.i.val, t34.i.val, t35.i.val, t36.i.val, t37.i.val, t38.i.val,
          t39.i.val, t40.i.val, t41.i.val, d0.i.val, t43.i.val, d1.i.val, g1.i.val, t45.i.val,
          d2.i.val, g2.i.val, t47.i.val, d3.i.val, g3.i.val, t49.i.val, d4.i.val, g4.i.val] =
        true)
    (hp : r ≠ .val g1.i g1.h ∧ r ≠ .val g2.i g2.h ∧ r ≠ .val g3.i g3.h)
    (hov : ¬R.offset.uaddOverflow 1280#64) (ho : o1 ≤ 1280 ∧ o2 ≤ 1280 ∧ o3 ≤ 1280 ∧ o4 ≤ 1280)
    (hK :
      ∀ v_t0 v_t1 v_t2 v_t3 v_t4 v_t5 v_t6 v_t7 v_t8 v_t9 v_t10 v_t11 v_t12 v_t13 v_t14 v_t15 v_t16
        v_t17 v_t18 v_t19 v_t20 v_t21 v_t22 v_t23 v_t24 v_t25 v_t26 v_t27 v_t28 v_t29 v_t30 v_t31
        v_t32 v_t33 v_t34 v_t35 v_t36 v_t37 v_t38 v_t39 v_t40 v_t41 v_t43 v_t45 v_t47 v_t49 : ⟦V⟧,
        (blk.runBodyFrom
              E[t0 := v_t0, t1 := v_t1, t2 := v_t2, t3 := v_t3, t4 := v_t4, t5 := v_t5, t6 := v_t6,
              t7 := v_t7, t8 := v_t8, t9 := v_t9, t10 := v_t10, t11 := v_t11, t12 := v_t12,
              t13 := v_t13, t14 := v_t14, t15 := v_t15, t16 := v_t16, t17 := v_t17, t18 := v_t18,
              t19 := v_t19, t20 := v_t20, t21 := v_t21, t22 := v_t22, t23 := v_t23, t24 := v_t24,
              t25 := v_t25, t26 := v_t26, t27 := v_t27, t28 := v_t28, t29 := v_t29, t30 := v_t30,
              t31 := v_t31, t32 := v_t32, t33 := v_t33, t34 := v_t34, t35 := v_t35, t36 := v_t36,
              t37 := v_t37, t38 := v_t38, t39 := v_t39, t40 := v_t40, t41 := v_t41,
              d0 := Ty.wrap (sqr ⟨A0, A1, A2, A3, A4⟩ false).l0, t43 := v_t43,
              d1 := Ty.wrap (sqr ⟨A0, A1, A2, A3, A4⟩ false).l1,
              g1 := .value (R.add (BitVec.ofNat 64 o1)), t45 := v_t45,
              d2 := Ty.wrap (sqr ⟨A0, A1, A2, A3, A4⟩ false).l2,
              g2 := .value (R.add (BitVec.ofNat 64 o2)), t47 := v_t47,
              d3 := Ty.wrap (sqr ⟨A0, A1, A2, A3, A4⟩ false).l3,
              g3 := .value (R.add (BitVec.ofNat 64 o3)), t49 := v_t49,
              d4 := Ty.wrap (sqr ⟨A0, A1, A2, A3, A4⟩ false).l4,
              g4 := .value (R.add (BitVec.ofNat 64 o4))]
              (pos + 55) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  have hd :
    List.Nodup
     [z.i, one.i, two.i, k38.i, k19.i, a0.i, a1.i, a2.i, a3.i, a4.i, t0.i, t1.i, t2.i, t3.i, t4.i,
      t5.i, t6.i, t7.i, t8.i, t9.i, t10.i, t11.i, t12.i, t13.i, t14.i, t15.i, t16.i, t17.i, t18.i,
      t19.i, t20.i, t21.i, t22.i, t23.i, t24.i, t25.i, t26.i, t27.i, t28.i, t29.i, t30.i, t31.i,
      t32.i, t33.i, t34.i, t35.i, t36.i, t37.i, t38.i, t39.i, t40.i, t41.i, d0.i, t43.i, d1.i, g1.i,
      t45.i, d2.i, g2.i, t47.i, d3.i, g3.i, t49.i, d4.i, g4.i] :=
    nodup_of_distinctB hd
  obtain ⟨hr1, hr2, hr3⟩ := hp
  obtain ⟨ho1, ho2, ho3, ho4⟩ := ho
  iterate 45 step_pure
  step_pure [gepConst_ofNat hov (by omega)]
  iterate 2 step_pure
  step_pure [gepConst_ofNat hov (by omega)]
  iterate 2 step_pure
  step_pure [gepConst_ofNat hov (by omega)]
  iterate 2 step_pure
  step_pure [gepConst_ofNat hov (by omega)]
  rw [hE]
  rw [sqr_compiled] at hK
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
      _

/-- `runBodyFrom_mulLooseRun` over registers kept apart by `distinctB`. -/
theorem runBodyFrom_mulLooseRun' {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {z one k19 k38 a0 a1 a2 a3 a4 b0 b1 b2 b3 b4 t0 t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14
      t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37
      t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 d0 t59 d1 t61
      d2 t63 d3 t65 d4 : Dst Γ V}
    {rest : List (Instr Γ)} {A0 A1 A2 A3 A4 B0 B1 B2 B3 B4 : Wwl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        mulLooseRun z one k19 k38 a0 a1 a2 a3 a4 b0 b1 b2 b3 b4 t0 t1 t2 t3 t4 t5 t6 t7 t8 t9 t10
            t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29 t30 t31 t32
            t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54
            t55 t56 t57 d0 t59 d1 t61 d2 t63 d3 t65 d4 ++
          rest)
    (hR :
      E ⊨ [z := Vector.replicate 8 0#64, one := Vector.replicate 8 1#64, k19 :=
        Vector.replicate 8 19#64, k38 := Vector.replicate 8 38#64, a0 := A0, a1 := A1, a2 := A2,
        a3 := A3, a4 := A4, b0 := B0, b1 := B1, b2 := B2, b3 := B3, b4 := B4])
    (hd :
      distinctB
         [z.i.val, one.i.val, k19.i.val, k38.i.val, a0.i.val, a1.i.val, a2.i.val, a3.i.val,
          a4.i.val, b0.i.val, b1.i.val, b2.i.val, b3.i.val, b4.i.val, t0.i.val, t1.i.val, t2.i.val,
          t3.i.val, t4.i.val, t5.i.val, t6.i.val, t7.i.val, t8.i.val, t9.i.val, t10.i.val,
          t11.i.val, t12.i.val, t13.i.val, t14.i.val, t15.i.val, t16.i.val, t17.i.val, t18.i.val,
          t19.i.val, t20.i.val, t21.i.val, t22.i.val, t23.i.val, t24.i.val, t25.i.val, t26.i.val,
          t27.i.val, t28.i.val, t29.i.val, t30.i.val, t31.i.val, t32.i.val, t33.i.val, t34.i.val,
          t35.i.val, t36.i.val, t37.i.val, t38.i.val, t39.i.val, t40.i.val, t41.i.val, t42.i.val,
          t43.i.val, t44.i.val, t45.i.val, t46.i.val, t47.i.val, t48.i.val, t49.i.val, t50.i.val,
          t51.i.val, t52.i.val, t53.i.val, t54.i.val, t55.i.val, t56.i.val, t57.i.val, d0.i.val,
          t59.i.val, d1.i.val, t61.i.val, d2.i.val, t63.i.val, d3.i.val, t65.i.val, d4.i.val] =
        true)
    (hK :
      ∀ v_t0 v_t1 v_t2 v_t3 v_t4 v_t5 v_t6 v_t7 v_t8 v_t9 v_t10 v_t11 v_t12 v_t13 v_t14 v_t15 v_t16
        v_t17 v_t18 v_t19 v_t20 v_t21 v_t22 v_t23 v_t24 v_t25 v_t26 v_t27 v_t28 v_t29 v_t30 v_t31
        v_t32 v_t33 v_t34 v_t35 v_t36 v_t37 v_t38 v_t39 v_t40 v_t41 v_t42 v_t43 v_t44 v_t45 v_t46
        v_t47 v_t48 v_t49 v_t50 v_t51 v_t52 v_t53 v_t54 v_t55 v_t56 v_t57 v_t59 v_t61 v_t63 v_t65 :
        ⟦V⟧,
        (blk.runBodyFrom
              E[t0 := v_t0, t1 := v_t1, t2 := v_t2, t3 := v_t3, t4 := v_t4, t5 := v_t5, t6 := v_t6,
                t7 := v_t7, t8 := v_t8, t9 := v_t9, t10 := v_t10, t11 := v_t11, t12 := v_t12, t13 :=
                v_t13, t14 := v_t14, t15 := v_t15, t16 := v_t16, t17 := v_t17, t18 := v_t18, t19 :=
                v_t19, t20 := v_t20, t21 := v_t21, t22 := v_t22, t23 := v_t23, t24 := v_t24, t25 :=
                v_t25, t26 := v_t26, t27 := v_t27, t28 := v_t28, t29 := v_t29, t30 := v_t30, t31 :=
                v_t31, t32 := v_t32, t33 := v_t33, t34 := v_t34, t35 := v_t35, t36 := v_t36, t37 :=
                v_t37, t38 := v_t38, t39 := v_t39, t40 := v_t40, t41 := v_t41, t42 := v_t42, t43 :=
                v_t43, t44 := v_t44, t45 := v_t45, t46 := v_t46, t47 := v_t47, t48 := v_t48, t49 :=
                v_t49, t50 := v_t50, t51 := v_t51, t52 := v_t52, t53 := v_t53, t54 := v_t54, t55 :=
                v_t55, t56 := v_t56, t57 := v_t57, d0 :=
                Ty.wrap (mul ⟨A0, A1, A2, A3, A4⟩ ⟨B0, B1, B2, B3, B4⟩ false).l0, t59 := v_t59,
                d1 := Ty.wrap (mul ⟨A0, A1, A2, A3, A4⟩ ⟨B0, B1, B2, B3, B4⟩ false).l1, t61 :=
                v_t61, d2 := Ty.wrap (mul ⟨A0, A1, A2, A3, A4⟩ ⟨B0, B1, B2, B3, B4⟩ false).l2,
                t63 := v_t63, d3 :=
                Ty.wrap (mul ⟨A0, A1, A2, A3, A4⟩ ⟨B0, B1, B2, B3, B4⟩ false).l3, t65 := v_t65,
                d4 := Ty.wrap (mul ⟨A0, A1, A2, A3, A4⟩ ⟨B0, B1, B2, B3, B4⟩ false).l4]
              (pos + 67) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K :=
  runBodyFrom_mulLooseRun hbody hR (nodup_of_distinctB hd) hK

/-- `runBodyFrom_mulStoreRun` over registers kept apart by `distinctB`. -/
theorem runBodyFrom_mulStoreRun' (o1 o2 o3 o4 : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
    {pos : Nat}
    {z one k19 k38 k51 km a0 a1 a2 a3 a4 b0 b1 b2 b3 b4 t0 t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12
      t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29 t30 t31 t32 t33 t34 t35
      t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58
      t59 t60 t62 t63 t65 t66 t68 t69 t71 t72 t73 t74 t75 t76 d0 t78 d1 t80 d2 t82 d3 t84 d4 :
      Dst Γ V}
    {g1 g2 g3 g4 : Dst Γ .ptr} {r p0 : Reg Γ .ptr} {rest : List (Instr Γ)}
    {A0 A1 A2 A3 A4 B0 B1 B2 B3 B4 : Wwl} {R P0 : Pointer} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        mulStoreRun o1 o2 o3 o4 z one k19 k38 k51 km a0 a1 a2 a3 a4 b0 b1 b2 b3 b4 r p0 t0 t1 t2 t3
            t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26
            t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48
            t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 g1 t62 t63 g2 t65 t66 g3 t68 t69 g4 t71
            t72 t73 t74 t75 t76 d0 t78 d1 t80 d2 t82 d3 t84 d4 ++
          rest)
    (hR :
      E ⊨ [z := Vector.replicate 8 0#64, one := Vector.replicate 8 1#64, k19 :=
        Vector.replicate 8 19#64, k38 := Vector.replicate 8 38#64, k51 := Vector.replicate 8 51#64,
        km := Vector.replicate 8 2251799813685247#64, a0 := A0, a1 := A1, a2 := A2, a3 := A3, a4 :=
        A4, b0 := B0, b1 := B1, b2 := B2, b3 := B3, b4 := B4, r := R, p0 := P0])
    (hd :
      distinctB
         [z.i.val, one.i.val, k19.i.val, k38.i.val, k51.i.val, km.i.val, a0.i.val, a1.i.val,
          a2.i.val, a3.i.val, a4.i.val, b0.i.val, b1.i.val, b2.i.val, b3.i.val, b4.i.val, t0.i.val,
          t1.i.val, t2.i.val, t3.i.val, t4.i.val, t5.i.val, t6.i.val, t7.i.val, t8.i.val, t9.i.val,
          t10.i.val, t11.i.val, t12.i.val, t13.i.val, t14.i.val, t15.i.val, t16.i.val, t17.i.val,
          t18.i.val, t19.i.val, t20.i.val, t21.i.val, t22.i.val, t23.i.val, t24.i.val, t25.i.val,
          t26.i.val, t27.i.val, t28.i.val, t29.i.val, t30.i.val, t31.i.val, t32.i.val, t33.i.val,
          t34.i.val, t35.i.val, t36.i.val, t37.i.val, t38.i.val, t39.i.val, t40.i.val, t41.i.val,
          t42.i.val, t43.i.val, t44.i.val, t45.i.val, t46.i.val, t47.i.val, t48.i.val, t49.i.val,
          t50.i.val, t51.i.val, t52.i.val, t53.i.val, t54.i.val, t55.i.val, t56.i.val, t57.i.val,
          t58.i.val, t59.i.val, t60.i.val, g1.i.val, t62.i.val, t63.i.val, g2.i.val, t65.i.val,
          t66.i.val, g3.i.val, t68.i.val, t69.i.val, g4.i.val, t71.i.val, t72.i.val, t73.i.val,
          t74.i.val, t75.i.val, t76.i.val, d0.i.val, t78.i.val, d1.i.val, t80.i.val, d2.i.val,
          t82.i.val, d3.i.val, t84.i.val, d4.i.val] =
        true)
    (hp :
      r ≠ .val g1.i g1.h ∧
        r ≠ .val g2.i g2.h ∧
        r ≠ .val g3.i g3.h ∧
        p0 ≠ .val g1.i g1.h ∧ p0 ≠ .val g2.i g2.h ∧ p0 ≠ .val g3.i g3.h ∧ p0 ≠ .val g4.i g4.h)
    (hov : ¬R.offset.uaddOverflow 1280#64) (ho : o1 ≤ 1280 ∧ o2 ≤ 1280 ∧ o3 ≤ 1280 ∧ o4 ≤ 1280)
    (hroom :
      Room S.mem P0 512 ∧
        Room S.mem (R.add (BitVec.ofNat 64 o1)) 512 ∧
        Room S.mem (R.add (BitVec.ofNat 64 o2)) 512 ∧
        Room S.mem (R.add (BitVec.ofNat 64 o3)) 512 ∧ Room S.mem (R.add (BitVec.ofNat 64 o4)) 512)
    (hK :
      ∀ v_t0 v_t1 v_t2 v_t3 v_t4 v_t5 v_t6 v_t7 v_t8 v_t9 v_t10 v_t11 v_t12 v_t13 v_t14 v_t15 v_t16
        v_t17 v_t18 v_t19 v_t20 v_t21 v_t22 v_t23 v_t24 v_t25 v_t26 v_t27 v_t28 v_t29 v_t30 v_t31
        v_t32 v_t33 v_t34 v_t35 v_t36 v_t37 v_t38 v_t39 v_t40 v_t41 v_t42 v_t43 v_t44 v_t45 v_t46
        v_t47 v_t48 v_t49 v_t50 v_t51 v_t52 v_t53 v_t54 v_t55 v_t56 v_t57 v_t58 v_t59 v_t60 v_t62
        v_t63 v_t65 v_t66 v_t68 v_t69 v_t71 v_t72 v_t73 v_t74 v_t75 v_t76 v_t78 v_t80 v_t82 v_t84 :
        ⟦V⟧,
        (blk.runBodyFrom
              E[t0 := v_t0, t1 := v_t1, t2 := v_t2, t3 := v_t3, t4 := v_t4, t5 := v_t5, t6 := v_t6,
                t7 := v_t7, t8 := v_t8, t9 := v_t9, t10 := v_t10, t11 := v_t11, t12 := v_t12, t13 :=
                v_t13, t14 := v_t14, t15 := v_t15, t16 := v_t16, t17 := v_t17, t18 := v_t18, t19 :=
                v_t19, t20 := v_t20, t21 := v_t21, t22 := v_t22, t23 := v_t23, t24 := v_t24, t25 :=
                v_t25, t26 := v_t26, t27 := v_t27, t28 := v_t28, t29 := v_t29, t30 := v_t30, t31 :=
                v_t31, t32 := v_t32, t33 := v_t33, t34 := v_t34, t35 := v_t35, t36 := v_t36, t37 :=
                v_t37, t38 := v_t38, t39 := v_t39, t40 := v_t40, t41 := v_t41, t42 := v_t42, t43 :=
                v_t43, t44 := v_t44, t45 := v_t45, t46 := v_t46, t47 := v_t47, t48 := v_t48, t49 :=
                v_t49, t50 := v_t50, t51 := v_t51, t52 := v_t52, t53 := v_t53, t54 := v_t54, t55 :=
                v_t55, t56 := v_t56, t57 := v_t57, t58 := v_t58, t59 := v_t59, t60 := v_t60, g1 :=
                .value (R.add (BitVec.ofNat 64 o1)), t62 := v_t62, t63 := v_t63, g2 :=
                .value (R.add (BitVec.ofNat 64 o2)), t65 := v_t65, t66 := v_t66, g3 :=
                .value (R.add (BitVec.ofNat 64 o3)), t68 := v_t68, t69 := v_t69, g4 :=
                .value (R.add (BitVec.ofNat 64 o4)), t71 := v_t71, t72 := v_t72, t73 := v_t73,
                t74 := v_t74, t75 := v_t75, t76 := v_t76, d0 :=
                Ty.wrap (mul ⟨A0, A1, A2, A3, A4⟩ ⟨B0, B1, B2, B3, B4⟩).l0, t78 := v_t78, d1 :=
                Ty.wrap (mul ⟨A0, A1, A2, A3, A4⟩ ⟨B0, B1, B2, B3, B4⟩).l1, t80 := v_t80, d2 :=
                Ty.wrap (mul ⟨A0, A1, A2, A3, A4⟩ ⟨B0, B1, B2, B3, B4⟩).l2, t82 := v_t82, d3 :=
                Ty.wrap (mul ⟨A0, A1, A2, A3, A4⟩ ⟨B0, B1, B2, B3, B4⟩).l3, t84 := v_t84, d4 :=
                Ty.wrap (mul ⟨A0, A1, A2, A3, A4⟩ ⟨B0, B1, B2, B3, B4⟩).l4]
              (pos + 91)
              { S with
                mem :=
                  ((((S.mem.storeVec P0 (mul ⟨A0, A1, A2, A3, A4⟩ ⟨B0, B1, B2, B3, B4⟩).l0).storeVec
                                (R.add (BitVec.ofNat 64 o1))
                                (mul ⟨A0, A1, A2, A3, A4⟩ ⟨B0, B1, B2, B3, B4⟩).l1).storeVec
                            (R.add (BitVec.ofNat 64 o2))
                            (mul ⟨A0, A1, A2, A3, A4⟩ ⟨B0, B1, B2, B3, B4⟩).l2).storeVec
                        (R.add (BitVec.ofNat 64 o3))
                        (mul ⟨A0, A1, A2, A3, A4⟩ ⟨B0, B1, B2, B3, B4⟩).l3).storeVec
                    (R.add (BitVec.ofNat 64 o4))
                    (mul ⟨A0, A1, A2, A3, A4⟩ ⟨B0, B1, B2, B3, B4⟩).l4 } >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K :=
  runBodyFrom_mulStoreRun o1 o2 o3 o4 hbody hR (nodup_of_distinctB hd) hp hov ho hroom hK

end

end MLIR.Firedancer.Lane.VerifyX8.Decode
