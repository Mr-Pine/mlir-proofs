module

import Firedancer.Common.Counter
public import Firedancer.Lane.Common.Mem
public import Firedancer.Lane.Common.Runs
public import Firedancer.Lane.Common.Tactics
public import Firedancer.Lane.Common.Verify
public import Firedancer.Lane.Mlir.fd_ed25519_lane_pow22523_2
meta import Lean.Elab.Tactic
public import MLIR.Run.Tactic

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h

attribute [local mlir_operation] vpmadd52l_wwl vpmadd52h_wwl zipWith_add_wwl zipWith_sub_wwl
  zipWith_and_wwl zipWith_mul_wwl zipWith_shl_wwl zipWith_lshr_wwl

/-! ### Tactics -/

meta section

open Lean Meta in
/-- The conjuncts of `pf : ty` (through reducible abbreviations), with their proofs. -/
partial def readConjuncts (pf ty : Expr) (acc : Array (Expr × Expr)) :
    MetaM (Array (Expr × Expr)) := do
  match_expr ← whnfR ty with
  | And a b =>
    readConjuncts (mkApp3 (mkConst ``And.right) a b pf) b
        (← readConjuncts (mkApp3 (mkConst ``And.left) a b pf) a acc)
  | _ =>
    return acc.push (pf, ty)

open Lean Elab Tactic Meta in
/-- `split_reads h…`: each conjunction `h` (an `E ⊨ […]`, also behind an abbreviation) as one fact
per read, so the steps seal the env past them. -/
elab "split_reads" hs:(ppSpace colGt ident)+ : tactic =>
  for h in hs do
    withMainContext do
        let d ← getLocalDeclFromUserName h.getId
        let parts ← readConjuncts d.toExpr (← instantiateMVars d.type) #[]
        let (_, g) ←
          (← getMainGoal).assertHypotheses
              (parts.mapIdx fun i (pf, ty) =>
                { userName := h.getId.appendIndexAfter i, type := ty, value := pf })
        replaceMainGoal [← g.clear d.fvarId]

open Lean Elab Tactic Meta in
/-- `subst_l4`: substitute the locals `v = x.l4` a pattern names after its last write, so the env
reads `x.l4`. -/
elab "subst_l4" : tactic => do
  let vs ←
    withMainContext do
        let mut vs := #[]
        for d in ← getLCtx do
          if d.isImplementationDetail then
            continue
          let some (_, .fvar v, r) := (← instantiateMVars d.type).consumeMData.eq? | continue
          if r.isAppOfArity ``Fe.l4 1 then
            vs := vs.push v
        pure vs
  for v in vs do
    liftMetaTactic fun g => return [← substVar g v]

end

set_option hygiene false in
/-- `sqrc x`: `fd_ed25519_lane_sqr` inlined, its square named `x`. -/
macro "sqrc " x:ident : tactic =>
  `(tactic| (step_pattern using runBodyFrom_sqrCRun with $x:ident; subst_l4))

set_option hygiene false in
/-- `mulc x`: `fd_ed25519_lane_mul` inlined, its product named `x`. -/
macro "mulc " x:ident : tactic =>
  `(tactic| (step_pattern using runBodyFrom_mulCRun with $x:ident; subst_l4))

/-- `sublist_tac`: `l₁ <+ l₂` for literal lists, `l₁` read off `l₂` in order. -/
macro "sublist_tac" : tactic =>
  `(tactic|
    repeat
      (first
        | exact List.nil_sublist _
        | apply List.Sublist.cons_cons
        | apply List.Sublist.cons))

set_option hygiene false in
/-- One iteration of a squaring loop (`LoopIter`): `SQR2`, count, test; out or around. -/
macro "iter_proof" : tactic =>
  `(tactic|
    ( intro i E hA hL hi hexit hback
      split_reads hL
      block_init
      sqrc ya
      sqrc yb
      step_pure [saddOverflow_one32 (i := i) (by omega), uaddOverflow_one32 (i := i) (by omega)]
      step_pure
      subst ya yb
      finish_block
      · step_loop using hexit (counter_eq (by decide) hi hbr)
      · step_loop using hback (counter_ne hi hbr)
        exact (BitVec.ofNat_add i 1).symm))

/-! ### The inlined field operations -/

/-- Whether `a` is among `l`. -/
def memB (a : Nat) : List Nat → Bool
  | [] => false
  | b :: l => a.beq b || memB a l

/-- Whether the elements of `l` are pairwise distinct: a composite pattern's register premise, which
the kernel decides several times faster than `List.Nodup`. -/
def distinctB : List Nat → Bool
  | [] => true
  | a :: l => !memB a l && distinctB l

/-- `memB` is membership. -/
theorem memB_iff {a : Nat} {l : List Nat} : memB a l = true ↔ a ∈ l := by
  induction l with
  | nil => simp [memB]
  | cons b l ih => simp [memB, ih, Nat.beq_eq]

/-- `distinctB` of the indices gives `Nodup`. -/
theorem nodup_of_distinctB {n : Nat} {l : List (Fin n)} (h : distinctB (l.map Fin.val) = true) :
    l.Nodup := by
  induction l with
  | nil => exact List.nodup_nil
  | cons a l
    ih =>
    simp only [List.map, distinctB, Bool.and_eq_true, Bool.not_eq_eq_eq_not, Bool.not_true] at h
    refine List.nodup_cons.2 ⟨fun ha => ?_, ih h.2⟩
    have : memB a.val (l.map Fin.val) = true := memB_iff.2 (List.mem_map_of_mem ha)
    rw [this] at h
    exact absurd h.1 (by decide)

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

/-- Where the body at `pos` is `carryRun'` and `x0 … x4` hold `X`: running on from `pos` gives `K` if
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

/-- `fd_ed25519_lane_sqr( r, a )` as compiled, 66 instructions: `sqrRun` into `s0 … s4`, then `carryRun'` of them into `d0 … d4`; `k51 km` hold `51` and the 51-bit mask. -/
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
/-- Where the body at `pos` is `sqrCRun` and `a0 … a4` hold `A`: running on from `pos` gives `K` if it does
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

/-- `fd_ed25519_lane_mul( r, a, b )` as compiled, 82 instructions: `mulLooseRun` into `s0 … s4`, then `carryRun'` of them into `d0 … d4`; `k51 km` hold `51` and the 51-bit mask. -/
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

/-- A constant `getelementptr` inside a field element's 320 bytes that do not wrap. -/
theorem gepConst_ofNat_fe {R : Pointer} {o : Nat} (hov : ¬R.offset.uaddOverflow 320#64)
    (ho : o ≤ 320) :
    Operation.gep { nusw := true, nuw := true } (.value (BitVec.ofNat 64 o)) (.value R) =
      .value (R.add (BitVec.ofNat 64 o)) := by
  have h1 : ¬R.offset.uaddOverflow (BitVec.ofNat 64 o) = true :=
    BitVec.not_uaddOverflow_of_le hov
      (by
        simp; omega)
  have h2 : (BitVec.ofNat 64 o).msb = false := by
    rw [BitVec.msb_eq_decide]; simp; omega
  simp [Operation.gep, h1, h2]

-- 91 steps in one declaration, their values unnamed
set_option maxHeartbeats 1000000 in
/-- `runBodyFrom_mulStoreRun` for a field element: where the body at `pos` is `mulStoreRun`, `a0 … a4` hold `A`, `b0 … b4` hold `B`, `p0` the pointer `P0` and
`r` the start `R` of a field element's 320 bytes that do not wrap: running on from `pos` gives `K` if it does
from `pos + 86` with `mul A B` stored at `P0` and `R` plus `o1 … o4`. -/
theorem runBodyFrom_mulStoreRun_fe (o1 o2 o3 o4 : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
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
      [z.i, one.i, k19.i, k38.i, k51.i, km.i, a0.i, a1.i, a2.i, a3.i, a4.i, b0.i, b1.i, b2.i, b3.i,
          b4.i, t0.i, t1.i, t2.i, t3.i, t4.i, t5.i, t6.i, t7.i, t8.i, t9.i, t10.i, t11.i, t12.i,
          t13.i, t14.i, t15.i, t16.i, t17.i, t18.i, t19.i, t20.i, t21.i, t22.i, t23.i, t24.i, t25.i,
          t26.i, t27.i, t28.i, t29.i, t30.i, t31.i, t32.i, t33.i, t34.i, t35.i, t36.i, t37.i, t38.i,
          t39.i, t40.i, t41.i, t42.i, t43.i, t44.i, t45.i, t46.i, t47.i, t48.i, t49.i, t50.i, t51.i,
          t52.i, t53.i, t54.i, t55.i, t56.i, t57.i, t58.i, t59.i, t60.i, g1.i, t62.i, t63.i, g2.i,
          t65.i, t66.i, g3.i, t68.i, t69.i, g4.i, t71.i, t72.i, t73.i, t74.i, t75.i, t76.i, d0.i,
          t78.i, d1.i, t80.i, d2.i, t82.i, d3.i, t84.i, d4.i].Nodup)
    (hp :
      r ≠ .val g1.i g1.h ∧
        r ≠ .val g2.i g2.h ∧
        r ≠ .val g3.i g3.h ∧
        p0 ≠ .val g1.i g1.h ∧ p0 ≠ .val g2.i g2.h ∧ p0 ≠ .val g3.i g3.h ∧ p0 ≠ .val g4.i g4.h)
    (hov : ¬R.offset.uaddOverflow 320#64) (ho : o1 ≤ 320 ∧ o2 ≤ 320 ∧ o3 ≤ 320 ∧ o4 ≤ 320)
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
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hr1, hr2, hr3, hp1, hp2, hp3, hp4⟩ := hp
  obtain ⟨ho1, ho2, ho3, ho4⟩ := ho
  obtain ⟨hq0, hq1, hq2, hq3, hq4⟩ := hroom
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
  step_pure [gepConst_ofNat_fe hov (by omega)]
  step_pure
  step_pure
  step_pure [gepConst_ofNat_fe hov (by omega)]
  step_pure
  step_pure
  step_pure [gepConst_ofNat_fe hov (by omega)]
  step_pure
  step_pure
  step_pure [gepConst_ofNat_fe hov (by omega)]
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_store
  step_pure
  step_pure
  step_store
  rw [hE, hS]
  rw [mul_eq_carry, mul_compiled, carry_compiled'] at hK
  exact
    hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

/-! ### The loops and blocks -/

namespace pow22523_2

open Firedancer.Lane.Mlir Firedancer.Lane.Mlir.fd_ed25519_lane_pow22523_2

/-- The counter's exit test at `N`, back in `ℕ`. -/
theorem counter_eq {i N : Nat} (hN : N < 2 ^ 31) (hi : i + 1 ≤ N)
    (h : BitVec.ofNat 32 i + 1#32 = BitVec.ofNat 32 N) : i + 1 = N := by
  have := congrArg BitVec.toNat h
  simp [BitVec.toNat_add] at this
  omega

/-- The counter's test failing at `N`: another iteration. -/
theorem counter_ne {i N : Nat} (hi : i + 1 ≤ N)
    (h : ¬BitVec.ofNat 32 i + 1#32 = BitVec.ofNat 32 N) : i + 1 < N := by
  rcases Nat.lt_or_eq_of_le hi with h' | h'
  · exact h'
  · subst h'
    exact absurd (by rw [BitVec.ofNat_add]) h

section Loops

variable {β : Type} (r0 a0 r1 a1 : Pointer) (k ex : Fin 15) (N : Nat)
  (hdr : ⟪Γ⟫ → Fe → Fe → Nat → ⟪Γ⟫) (Live LiveX : ⟪Γ⟫ → Prop) (Out : ⟪Γ⟫ → Fe → Fe → Prop)
  (Xa Xb : Fe) (S : GlobalState) (K : PoisonOr (Vals [] × GlobalState))

/-- One iteration of the loop at header `k` (env `hdr E Ya Yb i` at counter `i`, `Live` the
registers before it that it and the blocks after it read): `SQR2`, count, test; on to `ex` after the
`N`-th, the squares in `Out`, else around. -/
abbrev LoopIter : Prop :=
  ∀ i (E : ⟪Γ⟫),
    E.args = (args (.value r0) (.value a0) (.value r1) (.value a1)).get →
      Live E →
      i + 1 ≤ N →
      (i + 1 = N →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r0) (.value a0) (.value r1) (.value a1)).get →
            LiveX E' →
            Out E' (sqrN (i + 1) Xa) (sqrN (i + 1) Xb) →
            fd_ed25519_lane_pow22523_2.runFrom E' ex S = K) →
      (i + 1 < N →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r0) (.value a0) (.value r1) (.value a1)).get →
            Live E' →
            fd_ed25519_lane_pow22523_2.runFrom (hdr E' (sqrN (i + 1) Xa) (sqrN (i + 1) Xb) (i + 1))
                k S =
              K) →
      fd_ed25519_lane_pow22523_2.runFrom (hdr E (sqrN i Xa) (sqrN i Xb) i) k S = K

/-- The loop at header `k` from counter `i`, `n + 1` iterations left: `Xa`, `Xb` squared `N` times. -/
abbrev Loop : Prop :=
  ∀ n i (E : ⟪Γ⟫),
    E.args = (args (.value r0) (.value a0) (.value r1) (.value a1)).get →
      Live E →
      i + n + 1 = N →
      (∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r0) (.value a0) (.value r1) (.value a1)).get →
          LiveX E' →
          Out E' (sqrN N Xa) (sqrN N Xb) → fd_ed25519_lane_pow22523_2.runFrom E' ex S = K) →
      fd_ed25519_lane_pow22523_2.runFrom (hdr E (sqrN i Xa) (sqrN i Xb) i) k S = K

variable {r0 a0 r1 a1 k ex N hdr Live LiveX Out Xa Xb S K} in
/-- The loop from one iteration, by induction on the iterations left. -/
theorem loop_of_iter (h : LoopIter r0 a0 r1 a1 k ex N hdr Live LiveX Out Xa Xb S K) :
    Loop r0 a0 r1 a1 k ex N hdr Live LiveX Out Xa Xb S K := by
  intro n
  induction n with
  | zero =>
    intro i E hA hL hi hK
    subst hi
    exact h i E hA hL (by omega) (fun _ => hK) (by omega)
  | succ n ih =>
    intro i E hA hL hi hK
    exact h i E hA hL (by omega) (by omega) fun _ E' hA' hL' => ih (i + 1) E' hA' hL' (by omega) hK

end Loops

/-- What the blocks after `^bb2` read of the registers before it. -/
abbrev liveX2 (A B Ta Tb : Fe) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := Vector.replicate 8 0#64, %1 := Vector.replicate 8 1#64, %2 := Vector.replicate 8 2#64,
    %3 := Vector.replicate 8 38#64, %4 := Vector.replicate 8 19#64, %5 := Vector.replicate 8 51#64,
    %6 := Vector.replicate 8 2251799813685247#64, %7 := 1#32, %9 := 10#32, %10 := 20#32, %11 :=
    50#32, %12 := 100#32, %13 := A.l0, %15 := A.l1, %17 := A.l2, %19 := A.l3, %21 := A.l4, %22 :=
    B.l0, %24 := B.l1, %26 := B.l2, %28 := B.l3, %30 := B.l4, rir_reg% hty 960 := Ta.l0,
    rir_reg% hty 962 := Ta.l1, rir_reg% hty 964 := Ta.l2, rir_reg% hty 966 := Ta.l3,
    rir_reg% hty 968 := Ta.l4, rir_reg% hty 1042 := Tb.l0, rir_reg% hty 1044 := Tb.l1,
    rir_reg% hty 1046 := Tb.l2, rir_reg% hty 1048 := Tb.l3, rir_reg% hty 1050 := Tb.l4]

/-- What `^bb2` and the blocks after it read of the registers before it: its count too. -/
abbrev live2 (A B Ta Tb : Fe) (E : ⟪Γ⟫) : Prop :=
  liveX2 A B Ta Tb E ∧ E ⊨ [%8 := 5#32]

/-- `^bb2`'s header: the counter `i`, `Ya` and `Yb` in its parameters. -/
abbrev hdr2 (E : ⟪Γ⟫) (Ya Yb : Fe) (i : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 1479 := PoisonOr.value (BitVec.ofNat 32 i), rir_dst% hty 1480 := Ty.wrap Ya.l0,
    rir_dst% hty 1481 := Ty.wrap Ya.l1, rir_dst% hty 1482 := Ty.wrap Ya.l2, rir_dst% hty 1483 :=
    Ty.wrap Ya.l3, rir_dst% hty 1484 := Ty.wrap Ya.l4, rir_dst% hty 1485 := Ty.wrap Yb.l0,
    rir_dst% hty 1486 := Ty.wrap Yb.l1, rir_dst% hty 1487 := Ty.wrap Yb.l2, rir_dst% hty 1488 :=
    Ty.wrap Yb.l3, rir_dst% hty 1489 := Ty.wrap Yb.l4]

/-- `^bb2`'s squares `Ya`, `Yb`, as `^bb1` reads them. -/
abbrev out2 (E : ⟪Γ⟫) (Ya Yb : Fe) : Prop :=
  E ⊨ [rir_reg% hty 1547 := Ya.l0, rir_reg% hty 1549 := Ya.l1, rir_reg% hty 1551 := Ya.l2,
    rir_reg% hty 1553 := Ya.l3, rir_reg% hty 1555 := Ya.l4, rir_reg% hty 1613 := Yb.l0,
    rir_reg% hty 1615 := Yb.l1, rir_reg% hty 1617 := Yb.l2, rir_reg% hty 1619 := Yb.l3,
    rir_reg% hty 1621 := Yb.l4]

/-- What the blocks after `^bb4` read of the registers before it. -/
abbrev liveX4 (A B Ta Tb : Fe) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := Vector.replicate 8 0#64, %1 := Vector.replicate 8 1#64, %2 := Vector.replicate 8 2#64,
    %3 := Vector.replicate 8 38#64, %4 := Vector.replicate 8 19#64, %5 := Vector.replicate 8 51#64,
    %6 := Vector.replicate 8 2251799813685247#64, %7 := 1#32, %9 := 10#32, %10 := 20#32, %11 :=
    50#32, %12 := 100#32, %13 := A.l0, %15 := A.l1, %17 := A.l2, %19 := A.l3, %21 := A.l4, %22 :=
    B.l0, %24 := B.l1, %26 := B.l2, %28 := B.l3, %30 := B.l4, rir_reg% hty 1256 := Ta.l0,
    rir_reg% hty 1258 := Ta.l1, rir_reg% hty 1260 := Ta.l2, rir_reg% hty 1262 := Ta.l3,
    rir_reg% hty 1264 := Ta.l4, rir_reg% hty 1338 := Tb.l0, rir_reg% hty 1340 := Tb.l1,
    rir_reg% hty 1342 := Tb.l2, rir_reg% hty 1344 := Tb.l3, rir_reg% hty 1346 := Tb.l4]

/-- What `^bb4` and the blocks after it read of the registers before it. -/
abbrev live4 (A B Ta Tb : Fe) (E : ⟪Γ⟫) : Prop :=
  liveX4 A B Ta Tb E

/-- `^bb4`'s header: the counter `i`, `Ya` and `Yb` in its parameters. -/
abbrev hdr4 (E : ⟪Γ⟫) (Ya Yb : Fe) (i : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 1920 := PoisonOr.value (BitVec.ofNat 32 i), rir_dst% hty 1921 := Ty.wrap Ya.l0,
    rir_dst% hty 1922 := Ty.wrap Ya.l1, rir_dst% hty 1923 := Ty.wrap Ya.l2, rir_dst% hty 1924 :=
    Ty.wrap Ya.l3, rir_dst% hty 1925 := Ty.wrap Ya.l4, rir_dst% hty 1926 := Ty.wrap Yb.l0,
    rir_dst% hty 1927 := Ty.wrap Yb.l1, rir_dst% hty 1928 := Ty.wrap Yb.l2, rir_dst% hty 1929 :=
    Ty.wrap Yb.l3, rir_dst% hty 1930 := Ty.wrap Yb.l4]

/-- `^bb4`'s squares `Ya`, `Yb`, as `^bb3` reads them. -/
abbrev out4 (E : ⟪Γ⟫) (Ya Yb : Fe) : Prop :=
  E ⊨ [rir_reg% hty 1988 := Ya.l0, rir_reg% hty 1990 := Ya.l1, rir_reg% hty 1992 := Ya.l2,
    rir_reg% hty 1994 := Ya.l3, rir_reg% hty 1996 := Ya.l4, rir_reg% hty 2054 := Yb.l0,
    rir_reg% hty 2056 := Yb.l1, rir_reg% hty 2058 := Yb.l2, rir_reg% hty 2060 := Yb.l3,
    rir_reg% hty 2062 := Yb.l4]

/-- What the blocks after `^bb6` read of the registers before it. -/
abbrev liveX6 (A B Ta Tb Ua Ub : Fe) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := Vector.replicate 8 0#64, %1 := Vector.replicate 8 1#64, %2 := Vector.replicate 8 2#64,
    %3 := Vector.replicate 8 38#64, %4 := Vector.replicate 8 19#64, %5 := Vector.replicate 8 51#64,
    %6 := Vector.replicate 8 2251799813685247#64, %7 := 1#32, %9 := 10#32, %11 := 50#32, %12 :=
    100#32, %13 := A.l0, %15 := A.l1, %17 := A.l2, %19 := A.l3, %21 := A.l4, %22 := B.l0, %24 :=
    B.l1, %26 := B.l2, %28 := B.l3, %30 := B.l4, rir_reg% hty 1256 := Ta.l0, rir_reg% hty 1258 :=
    Ta.l1, rir_reg% hty 1260 := Ta.l2, rir_reg% hty 1262 := Ta.l3, rir_reg% hty 1264 := Ta.l4,
    rir_reg% hty 1338 := Tb.l0, rir_reg% hty 1340 := Tb.l1, rir_reg% hty 1342 := Tb.l2,
    rir_reg% hty 1344 := Tb.l3, rir_reg% hty 1346 := Tb.l4, rir_reg% hty 1697 := Ua.l0,
    rir_reg% hty 1699 := Ua.l1, rir_reg% hty 1701 := Ua.l2, rir_reg% hty 1703 := Ua.l3,
    rir_reg% hty 1705 := Ua.l4, rir_reg% hty 1779 := Ub.l0, rir_reg% hty 1781 := Ub.l1,
    rir_reg% hty 1783 := Ub.l2, rir_reg% hty 1785 := Ub.l3, rir_reg% hty 1787 := Ub.l4]

/-- What `^bb6` and the blocks after it read of the registers before it: its count too. -/
abbrev live6 (A B Ta Tb Ua Ub : Fe) (E : ⟪Γ⟫) : Prop :=
  liveX6 A B Ta Tb Ua Ub E ∧ E ⊨ [%10 := 20#32]

/-- `^bb6`'s header: the counter `i`, `Ya` and `Yb` in its parameters. -/
abbrev hdr6 (E : ⟪Γ⟫) (Ya Yb : Fe) (i : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 2361 := PoisonOr.value (BitVec.ofNat 32 i), rir_dst% hty 2362 := Ty.wrap Ya.l0,
    rir_dst% hty 2363 := Ty.wrap Ya.l1, rir_dst% hty 2364 := Ty.wrap Ya.l2, rir_dst% hty 2365 :=
    Ty.wrap Ya.l3, rir_dst% hty 2366 := Ty.wrap Ya.l4, rir_dst% hty 2367 := Ty.wrap Yb.l0,
    rir_dst% hty 2368 := Ty.wrap Yb.l1, rir_dst% hty 2369 := Ty.wrap Yb.l2, rir_dst% hty 2370 :=
    Ty.wrap Yb.l3, rir_dst% hty 2371 := Ty.wrap Yb.l4]

/-- `^bb6`'s squares `Ya`, `Yb`, as `^bb5` reads them. -/
abbrev out6 (E : ⟪Γ⟫) (Ya Yb : Fe) : Prop :=
  E ⊨ [rir_reg% hty 2429 := Ya.l0, rir_reg% hty 2431 := Ya.l1, rir_reg% hty 2433 := Ya.l2,
    rir_reg% hty 2435 := Ya.l3, rir_reg% hty 2437 := Ya.l4, rir_reg% hty 2495 := Yb.l0,
    rir_reg% hty 2497 := Yb.l1, rir_reg% hty 2499 := Yb.l2, rir_reg% hty 2501 := Yb.l3,
    rir_reg% hty 2503 := Yb.l4]

/-- What the blocks after `^bb8` read of the registers before it. -/
abbrev liveX8 (A B Ta Tb : Fe) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := Vector.replicate 8 0#64, %1 := Vector.replicate 8 1#64, %2 := Vector.replicate 8 2#64,
    %3 := Vector.replicate 8 38#64, %4 := Vector.replicate 8 19#64, %5 := Vector.replicate 8 51#64,
    %6 := Vector.replicate 8 2251799813685247#64, %7 := 1#32, %11 := 50#32, %12 := 100#32, %13 :=
    A.l0, %15 := A.l1, %17 := A.l2, %19 := A.l3, %21 := A.l4, %22 := B.l0, %24 := B.l1, %26 := B.l2,
    %28 := B.l3, %30 := B.l4, rir_reg% hty 1256 := Ta.l0, rir_reg% hty 1258 := Ta.l1,
    rir_reg% hty 1260 := Ta.l2, rir_reg% hty 1262 := Ta.l3, rir_reg% hty 1264 := Ta.l4,
    rir_reg% hty 1338 := Tb.l0, rir_reg% hty 1340 := Tb.l1, rir_reg% hty 1342 := Tb.l2,
    rir_reg% hty 1344 := Tb.l3, rir_reg% hty 1346 := Tb.l4]

/-- What `^bb8` and the blocks after it read of the registers before it: its count too. -/
abbrev live8 (A B Ta Tb : Fe) (E : ⟪Γ⟫) : Prop :=
  liveX8 A B Ta Tb E ∧ E ⊨ [%9 := 10#32]

/-- `^bb8`'s header: the counter `i`, `Ya` and `Yb` in its parameters. -/
abbrev hdr8 (E : ⟪Γ⟫) (Ya Yb : Fe) (i : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 2802 := PoisonOr.value (BitVec.ofNat 32 i), rir_dst% hty 2803 := Ty.wrap Ya.l0,
    rir_dst% hty 2804 := Ty.wrap Ya.l1, rir_dst% hty 2805 := Ty.wrap Ya.l2, rir_dst% hty 2806 :=
    Ty.wrap Ya.l3, rir_dst% hty 2807 := Ty.wrap Ya.l4, rir_dst% hty 2808 := Ty.wrap Yb.l0,
    rir_dst% hty 2809 := Ty.wrap Yb.l1, rir_dst% hty 2810 := Ty.wrap Yb.l2, rir_dst% hty 2811 :=
    Ty.wrap Yb.l3, rir_dst% hty 2812 := Ty.wrap Yb.l4]

/-- `^bb8`'s squares `Ya`, `Yb`, as `^bb7` reads them. -/
abbrev out8 (E : ⟪Γ⟫) (Ya Yb : Fe) : Prop :=
  E ⊨ [rir_reg% hty 2870 := Ya.l0, rir_reg% hty 2872 := Ya.l1, rir_reg% hty 2874 := Ya.l2,
    rir_reg% hty 2876 := Ya.l3, rir_reg% hty 2878 := Ya.l4, rir_reg% hty 2936 := Yb.l0,
    rir_reg% hty 2938 := Yb.l1, rir_reg% hty 2940 := Yb.l2, rir_reg% hty 2942 := Yb.l3,
    rir_reg% hty 2944 := Yb.l4]

/-- What the blocks after `^bb10` read of the registers before it. -/
abbrev liveX10 (A B Ta Tb : Fe) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := Vector.replicate 8 0#64, %1 := Vector.replicate 8 1#64, %2 := Vector.replicate 8 2#64,
    %3 := Vector.replicate 8 38#64, %4 := Vector.replicate 8 19#64, %5 := Vector.replicate 8 51#64,
    %6 := Vector.replicate 8 2251799813685247#64, %7 := 1#32, %11 := 50#32, %12 := 100#32, %13 :=
    A.l0, %15 := A.l1, %17 := A.l2, %19 := A.l3, %21 := A.l4, %22 := B.l0, %24 := B.l1, %26 := B.l2,
    %28 := B.l3, %30 := B.l4, rir_reg% hty 2579 := Ta.l0, rir_reg% hty 2581 := Ta.l1,
    rir_reg% hty 2583 := Ta.l2, rir_reg% hty 2585 := Ta.l3, rir_reg% hty 2587 := Ta.l4,
    rir_reg% hty 2661 := Tb.l0, rir_reg% hty 2663 := Tb.l1, rir_reg% hty 2665 := Tb.l2,
    rir_reg% hty 2667 := Tb.l3, rir_reg% hty 2669 := Tb.l4]

/-- What `^bb10` and the blocks after it read of the registers before it. -/
abbrev live10 (A B Ta Tb : Fe) (E : ⟪Γ⟫) : Prop :=
  liveX10 A B Ta Tb E

/-- `^bb10`'s header: the counter `i`, `Ya` and `Yb` in its parameters. -/
abbrev hdr10 (E : ⟪Γ⟫) (Ya Yb : Fe) (i : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 3243 := PoisonOr.value (BitVec.ofNat 32 i), rir_dst% hty 3244 := Ty.wrap Ya.l0,
    rir_dst% hty 3245 := Ty.wrap Ya.l1, rir_dst% hty 3246 := Ty.wrap Ya.l2, rir_dst% hty 3247 :=
    Ty.wrap Ya.l3, rir_dst% hty 3248 := Ty.wrap Ya.l4, rir_dst% hty 3249 := Ty.wrap Yb.l0,
    rir_dst% hty 3250 := Ty.wrap Yb.l1, rir_dst% hty 3251 := Ty.wrap Yb.l2, rir_dst% hty 3252 :=
    Ty.wrap Yb.l3, rir_dst% hty 3253 := Ty.wrap Yb.l4]

/-- `^bb10`'s squares `Ya`, `Yb`, as `^bb9` reads them. -/
abbrev out10 (E : ⟪Γ⟫) (Ya Yb : Fe) : Prop :=
  E ⊨ [rir_reg% hty 3311 := Ya.l0, rir_reg% hty 3313 := Ya.l1, rir_reg% hty 3315 := Ya.l2,
    rir_reg% hty 3317 := Ya.l3, rir_reg% hty 3319 := Ya.l4, rir_reg% hty 3377 := Yb.l0,
    rir_reg% hty 3379 := Yb.l1, rir_reg% hty 3381 := Yb.l2, rir_reg% hty 3383 := Yb.l3,
    rir_reg% hty 3385 := Yb.l4]

/-- What the blocks after `^bb12` read of the registers before it. -/
abbrev liveX12 (A B Ta Tb Ua Ub : Fe) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := Vector.replicate 8 0#64, %1 := Vector.replicate 8 1#64, %2 := Vector.replicate 8 2#64,
    %3 := Vector.replicate 8 38#64, %4 := Vector.replicate 8 19#64, %5 := Vector.replicate 8 51#64,
    %6 := Vector.replicate 8 2251799813685247#64, %7 := 1#32, %11 := 50#32, %13 := A.l0, %15 :=
    A.l1, %17 := A.l2, %19 := A.l3, %21 := A.l4, %22 := B.l0, %24 := B.l1, %26 := B.l2, %28 := B.l3,
    %30 := B.l4, rir_reg% hty 2579 := Ta.l0, rir_reg% hty 2581 := Ta.l1, rir_reg% hty 2583 := Ta.l2,
    rir_reg% hty 2585 := Ta.l3, rir_reg% hty 2587 := Ta.l4, rir_reg% hty 2661 := Tb.l0,
    rir_reg% hty 2663 := Tb.l1, rir_reg% hty 2665 := Tb.l2, rir_reg% hty 2667 := Tb.l3,
    rir_reg% hty 2669 := Tb.l4, rir_reg% hty 3020 := Ua.l0, rir_reg% hty 3022 := Ua.l1,
    rir_reg% hty 3024 := Ua.l2, rir_reg% hty 3026 := Ua.l3, rir_reg% hty 3028 := Ua.l4,
    rir_reg% hty 3102 := Ub.l0, rir_reg% hty 3104 := Ub.l1, rir_reg% hty 3106 := Ub.l2,
    rir_reg% hty 3108 := Ub.l3, rir_reg% hty 3110 := Ub.l4]

/-- What `^bb12` and the blocks after it read of the registers before it: its count too. -/
abbrev live12 (A B Ta Tb Ua Ub : Fe) (E : ⟪Γ⟫) : Prop :=
  liveX12 A B Ta Tb Ua Ub E ∧ E ⊨ [%12 := 100#32]

/-- `^bb12`'s header: the counter `i`, `Ya` and `Yb` in its parameters. -/
abbrev hdr12 (E : ⟪Γ⟫) (Ya Yb : Fe) (i : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 3684 := PoisonOr.value (BitVec.ofNat 32 i), rir_dst% hty 3685 := Ty.wrap Ya.l0,
    rir_dst% hty 3686 := Ty.wrap Ya.l1, rir_dst% hty 3687 := Ty.wrap Ya.l2, rir_dst% hty 3688 :=
    Ty.wrap Ya.l3, rir_dst% hty 3689 := Ty.wrap Ya.l4, rir_dst% hty 3690 := Ty.wrap Yb.l0,
    rir_dst% hty 3691 := Ty.wrap Yb.l1, rir_dst% hty 3692 := Ty.wrap Yb.l2, rir_dst% hty 3693 :=
    Ty.wrap Yb.l3, rir_dst% hty 3694 := Ty.wrap Yb.l4]

/-- `^bb12`'s squares `Ya`, `Yb`, as `^bb11` reads them. -/
abbrev out12 (E : ⟪Γ⟫) (Ya Yb : Fe) : Prop :=
  E ⊨ [rir_reg% hty 3752 := Ya.l0, rir_reg% hty 3754 := Ya.l1, rir_reg% hty 3756 := Ya.l2,
    rir_reg% hty 3758 := Ya.l3, rir_reg% hty 3760 := Ya.l4, rir_reg% hty 3818 := Yb.l0,
    rir_reg% hty 3820 := Yb.l1, rir_reg% hty 3822 := Yb.l2, rir_reg% hty 3824 := Yb.l3,
    rir_reg% hty 3826 := Yb.l4]

/-- What the blocks after `^bb14` read of the registers before it. -/
abbrev liveX14 (A B Ta Tb : Fe) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := Vector.replicate 8 0#64, %1 := Vector.replicate 8 1#64, %2 := Vector.replicate 8 2#64,
    %3 := Vector.replicate 8 38#64, %4 := Vector.replicate 8 19#64, %5 := Vector.replicate 8 51#64,
    %6 := Vector.replicate 8 2251799813685247#64, %13 := A.l0, %15 := A.l1, %17 := A.l2, %19 :=
    A.l3, %21 := A.l4, %22 := B.l0, %24 := B.l1, %26 := B.l2, %28 := B.l3, %30 := B.l4,
    rir_reg% hty 2579 := Ta.l0, rir_reg% hty 2581 := Ta.l1, rir_reg% hty 2583 := Ta.l2,
    rir_reg% hty 2585 := Ta.l3, rir_reg% hty 2587 := Ta.l4, rir_reg% hty 2661 := Tb.l0,
    rir_reg% hty 2663 := Tb.l1, rir_reg% hty 2665 := Tb.l2, rir_reg% hty 2667 := Tb.l3,
    rir_reg% hty 2669 := Tb.l4]

/-- What `^bb14` and the blocks after it read of the registers before it: its count too. -/
abbrev live14 (A B Ta Tb : Fe) (E : ⟪Γ⟫) : Prop :=
  liveX14 A B Ta Tb E ∧ E ⊨ [%11 := 50#32, %7 := 1#32]

/-- `^bb14`'s header: the counter `i`, `Ya` and `Yb` in its parameters. -/
abbrev hdr14 (E : ⟪Γ⟫) (Ya Yb : Fe) (i : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 4429 := PoisonOr.value (BitVec.ofNat 32 i), rir_dst% hty 4430 := Ty.wrap Ya.l0,
    rir_dst% hty 4431 := Ty.wrap Ya.l1, rir_dst% hty 4432 := Ty.wrap Ya.l2, rir_dst% hty 4433 :=
    Ty.wrap Ya.l3, rir_dst% hty 4434 := Ty.wrap Ya.l4, rir_dst% hty 4435 := Ty.wrap Yb.l0,
    rir_dst% hty 4436 := Ty.wrap Yb.l1, rir_dst% hty 4437 := Ty.wrap Yb.l2, rir_dst% hty 4438 :=
    Ty.wrap Yb.l3, rir_dst% hty 4439 := Ty.wrap Yb.l4]

/-- `^bb14`'s squares `Ya`, `Yb`, as `^bb13` reads them. -/
abbrev out14 (E : ⟪Γ⟫) (Ya Yb : Fe) : Prop :=
  E ⊨ [rir_reg% hty 4497 := Ya.l0, rir_reg% hty 4499 := Ya.l1, rir_reg% hty 4501 := Ya.l2,
    rir_reg% hty 4503 := Ya.l3, rir_reg% hty 4505 := Ya.l4, rir_reg% hty 4563 := Yb.l0,
    rir_reg% hty 4565 := Yb.l1, rir_reg% hty 4567 := Yb.l2, rir_reg% hty 4569 := Yb.l3,
    rir_reg% hty 4571 := Yb.l4]

/-- `^bb2`: an iteration of `SQRN2( t1, t0, 5 )`. -/
theorem iter2 (r0 a0 r1 a1 : Pointer) (A B Ta Tb Xa Xb : Fe) (S : GlobalState)
    (K : PoisonOr (Vals [] × GlobalState)) :
    LoopIter r0 a0 r1 a1 2 1 5 hdr2 (live2 A B Ta Tb) (liveX2 A B Ta Tb) out2 Xa Xb S K := by
  iter_proof

/-- `^bb4`: an iteration of `SQRN2( t1, t0, 10 )`. -/
theorem iter4 (r0 a0 r1 a1 : Pointer) (A B Ta Tb Xa Xb : Fe) (S : GlobalState)
    (K : PoisonOr (Vals [] × GlobalState)) :
    LoopIter r0 a0 r1 a1 4 3 10 hdr4 (live4 A B Ta Tb) (liveX4 A B Ta Tb) out4 Xa Xb S K := by
  iter_proof

/-- `^bb6`: an iteration of `SQRN2( t2, t1, 20 )`. -/
theorem iter6 (r0 a0 r1 a1 : Pointer) (A B Ta Tb Ua Ub Xa Xb : Fe) (S : GlobalState)
    (K : PoisonOr (Vals [] × GlobalState)) :
    LoopIter r0 a0 r1 a1 6 5 20 hdr6 (live6 A B Ta Tb Ua Ub) (liveX6 A B Ta Tb Ua Ub) out6 Xa Xb S
      K := by
  iter_proof

/-- `^bb8`: an iteration of `SQRN2( t1, t1, 10 )`. -/
theorem iter8 (r0 a0 r1 a1 : Pointer) (A B Ta Tb Xa Xb : Fe) (S : GlobalState)
    (K : PoisonOr (Vals [] × GlobalState)) :
    LoopIter r0 a0 r1 a1 8 7 10 hdr8 (live8 A B Ta Tb) (liveX8 A B Ta Tb) out8 Xa Xb S K := by
  iter_proof

/-- `^bb10`: an iteration of `SQRN2( t1, t0, 50 )`. -/
theorem iter10 (r0 a0 r1 a1 : Pointer) (A B Ta Tb Xa Xb : Fe) (S : GlobalState)
    (K : PoisonOr (Vals [] × GlobalState)) :
    LoopIter r0 a0 r1 a1 10 9 50 hdr10 (live10 A B Ta Tb) (liveX10 A B Ta Tb) out10 Xa Xb S K := by
  iter_proof

/-- `^bb12`: an iteration of `SQRN2( t2, t1, 100 )`. -/
theorem iter12 (r0 a0 r1 a1 : Pointer) (A B Ta Tb Ua Ub Xa Xb : Fe) (S : GlobalState)
    (K : PoisonOr (Vals [] × GlobalState)) :
    LoopIter r0 a0 r1 a1 12 11 100 hdr12 (live12 A B Ta Tb Ua Ub) (liveX12 A B Ta Tb Ua Ub) out12 Xa
      Xb S K := by
  iter_proof

/-- `^bb14`: an iteration of `SQRN2( t1, t1, 50 )`. -/
theorem iter14 (r0 a0 r1 a1 : Pointer) (A B Ta Tb Xa Xb : Fe) (S : GlobalState)
    (K : PoisonOr (Vals [] × GlobalState)) :
    LoopIter r0 a0 r1 a1 14 13 50 hdr14 (live14 A B Ta Tb) (liveX14 A B Ta Tb) out14 Xa Xb S K := by
  iter_proof

/-- The limbs of `readFe`, as the loads read them. -/
theorem readFe_l0 {m : MemoryState} {p : Pointer} : (m.readFe p).l0 = m.readVec p :=
  rfl

/-- `readFe_l0` for limb 1. -/
theorem readFe_l1 {m : MemoryState} {p : Pointer} : (m.readFe p).l1 = m.readVec (p.add 64#64) :=
  rfl

/-- `readFe_l0` for limb 2. -/
theorem readFe_l2 {m : MemoryState} {p : Pointer} : (m.readFe p).l2 = m.readVec (p.add 128#64) :=
  rfl

/-- `readFe_l0` for limb 3. -/
theorem readFe_l3 {m : MemoryState} {p : Pointer} : (m.readFe p).l3 = m.readVec (p.add 192#64) :=
  rfl

/-- `readFe_l0` for limb 4. -/
theorem readFe_l4 {m : MemoryState} {p : Pointer} : (m.readFe p).l4 = m.readVec (p.add 256#64) :=
  rfl

/-- `pow22523`'s chain up to its first `SQRN2`: `a^(2^5 - 1)`. -/
def chain5 (a : Fe) : Fe :=
  let t0 := sqr a
  let t1 := sqrN 2 t0
  let t1 := mul a t1
  let t0 := mul t0 t1
  let t0 := sqr t0
  mul t1 t0

-- `^bb0`'s 16 inlined products and squares in one declaration
set_option maxHeartbeats 1000000 in
/-- `^bb0` past its loads: `SQR2( t0, a )` up to the first `SQR2` of `SQRN2( t1, t0, 5 )`. -/
theorem bb0_run (r0 a0 r1 a1 : Pointer) (A B : Fe) (S : GlobalState)
    {g : ⟪Γ⟫ × GlobalState → PoisonOr (Vals [] × GlobalState)}
    {K : PoisonOr (Vals [] × GlobalState)} (E : ⟪Γ⟫)
    (hg :
      g = fun x =>
        @bind PoisonOr _ ((⟪Γ⟫ × ExitResult [] 15) × GlobalState) (Vals [] × GlobalState)
          (Exit.run blockParams x.1 bb0.exit x.2) fun y =>
          Func.continue (func := fd_ed25519_lane_pow22523_2) y.1.1 y.1.2 y.2)
    (hA : E.args = (args (.value r0) (.value a0) (.value r1) (.value a1)).get)
    (hR :
      E ⊨ [%0 := Vector.replicate 8 0#64, %1 := Vector.replicate 8 1#64, %2 :=
        Vector.replicate 8 2#64, %3 := Vector.replicate 8 38#64, %4 := Vector.replicate 8 19#64,
        %5 := Vector.replicate 8 51#64, %6 := Vector.replicate 8 2251799813685247#64, %7 := 1#32,
        %8 := 5#32, %9 := 10#32, %10 := 20#32, %11 := 50#32, %12 := 100#32, %13 := A.l0, %15 :=
        A.l1, %17 := A.l2, %19 := A.l3, %21 := A.l4, %22 := B.l0, %24 := B.l1, %26 := B.l2, %28 :=
        B.l3, %30 := B.l4])
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r0) (.value a0) (.value r1) (.value a1)).get →
          (E' ⊨ [%0 := Vector.replicate 8 0#64, %1 := Vector.replicate 8 1#64, %2 :=
            Vector.replicate 8 2#64, %3 := Vector.replicate 8 38#64, %4 := Vector.replicate 8 19#64,
            %5 := Vector.replicate 8 51#64, %6 := Vector.replicate 8 2251799813685247#64, %7 :=
            1#32, %8 := 5#32, %9 := 10#32, %10 := 20#32, %11 := 50#32, %12 := 100#32, %13 := A.l0,
            %15 := A.l1, %17 := A.l2, %19 := A.l3, %21 := A.l4, %22 := B.l0, %24 := B.l1, %26 :=
            B.l2, %28 := B.l3, %30 := B.l4, rir_reg% hty 960 := (chain5 A).l0, rir_reg% hty 962 :=
            (chain5 A).l1, rir_reg% hty 964 := (chain5 A).l2, rir_reg% hty 966 := (chain5 A).l3,
            rir_reg% hty 968 := (chain5 A).l4, rir_reg% hty 1042 := (chain5 B).l0,
            rir_reg% hty 1044 := (chain5 B).l1, rir_reg% hty 1046 := (chain5 B).l2,
            rir_reg% hty 1048 := (chain5 B).l3, rir_reg% hty 1050 := (chain5 B).l4,
            rir_reg% hty 1108 := (sqr (chain5 A)).l0, rir_reg% hty 1110 := (sqr (chain5 A)).l1,
            rir_reg% hty 1112 := (sqr (chain5 A)).l2, rir_reg% hty 1114 := (sqr (chain5 A)).l3,
            rir_reg% hty 1116 := (sqr (chain5 A)).l4, rir_reg% hty 1174 := (sqr (chain5 B)).l0,
            rir_reg% hty 1176 := (sqr (chain5 B)).l1, rir_reg% hty 1178 := (sqr (chain5 B)).l2,
            rir_reg% hty 1180 := (sqr (chain5 B)).l3, rir_reg% hty 1182 := (sqr (chain5 B)).l4]) →
          (bb0.runBodyFrom E' 1183 S >>= g) = K) :
    (bb0.runBodyFrom E 31 S >>= g) = K := by
  subst hg
  split_reads hR
  sqrc z2a
  sqrc z2b
  sqrc z4a
  sqrc z4b
  sqrc z8a
  sqrc z8b
  mulc z9a
  mulc z9b
  mulc z11a
  mulc z11b
  sqrc z22a
  sqrc z22b
  mulc z2e5m1a
  mulc z2e5m1b
  sqrc ua
  sqrc ub
  subst z2a z2b z4a z4b z8a z8b z9a z9b z11a z11b z22a z22b z2e5m1a z2e5m1b ua ub
  subst hS
  exact hK E hArgs (by env_reads)

/-- A field element is its limbs. -/
theorem fe_eta (x : Fe) : (⟨x.l0, x.l1, x.l2, x.l3, x.l4⟩ : Fe) = x :=
  rfl

/-- `^bb13`: `MUL2( t0, t1, t0 )`, `SQRN2( t0, t0, 2 )`, and the two products by `a` stored at
`r0`, then `r1`. -/
theorem bb13 (r0 a0 r1 a1 : Pointer) (A B Ta Tb Ya Yb : Fe) (S : GlobalState)
    (K : PoisonOr (Vals [] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r0) (.value a0) (.value r1) (.value a1)).get)
    (hL : liveX14 A B Ta Tb E) (hO : out14 E Ya Yb) (hr0 : S.mem.FeRoom r0) (hr1 : S.mem.FeRoom r1)
    (hK :
      .value
          (.nil,
            { S with
              mem :=
                (S.mem.storeFe r0 (mul (sqrN 2 (mul Ya Ta)) A)).storeFe r1
                  (mul (sqrN 2 (mul Yb Tb)) B) }) =
        K) :
    fd_ed25519_lane_pow22523_2.runFrom E 13 S = K := by
  split_reads hL hO
  block_init
  mulc oa
  mulc ob
  sqrc pa
  sqrc pb
  sqrc qa
  sqrc qb
  step_pattern using runBodyFrom_mulStoreRun_fe 64 128 192 256 (hov := hr0.1)
  clear_stored
  step_pattern using runBodyFrom_mulStoreRun_fe 64 128 192 256 (hov := hr1.1)
  clear_stored
  finish_block
  subst_l4
  rw [← hK, hS]
  simp only [fe_eta]
  subst oa ob pa pb qa qb
  rfl

/-- `^bb1`, then the loop at `^bb4`: `MUL2( t0, t1, t0 )`, then `SQRN2( t1, t0, 10 )`, the squares on to `^bb3`. -/
theorem bb1 (r0 a0 r1 a1 : Pointer) (A B Ta Tb Ya Yb : Fe) (S : GlobalState)
    (K : PoisonOr (Vals [] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r0) (.value a0) (.value r1) (.value a1)).get)
    (hL : liveX2 A B Ta Tb E) (hO : out2 E Ya Yb)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r0) (.value a0) (.value r1) (.value a1)).get →
          liveX4 A B (mul Ya Ta) (mul Yb Tb) E' →
          out4 E' (sqrN 10 (mul Ya Ta)) (sqrN 10 (mul Yb Tb)) →
          fd_ed25519_lane_pow22523_2.runFrom E' 3 S = K) :
    fd_ed25519_lane_pow22523_2.runFrom E 1 S = K := by
  split_reads hL hO
  block_init
  mulc za
  mulc zb
  sqrc ua
  sqrc ub
  finish_block
  subst za zb ua ub
  step_loop using
    loop_of_iter (iter4 r0 a0 r1 a1 A B (mul Ya Ta) (mul Yb Tb) (mul Ya Ta) (mul Yb Tb) S K) 8 1
  subst hS
  exact hK _ hArgs₀

/-- `^bb3`, then the loop at `^bb6`: `MUL2( t1, t1, t0 )`, then `SQRN2( t2, t1, 20 )`, the squares on to `^bb5`. -/
theorem bb3 (r0 a0 r1 a1 : Pointer) (A B Ta Tb Ya Yb : Fe) (S : GlobalState)
    (K : PoisonOr (Vals [] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r0) (.value a0) (.value r1) (.value a1)).get)
    (hL : liveX4 A B Ta Tb E) (hO : out4 E Ya Yb)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r0) (.value a0) (.value r1) (.value a1)).get →
          liveX6 A B Ta Tb (mul Ya Ta) (mul Yb Tb) E' →
          out6 E' (sqrN 20 (mul Ya Ta)) (sqrN 20 (mul Yb Tb)) →
          fd_ed25519_lane_pow22523_2.runFrom E' 5 S = K) :
    fd_ed25519_lane_pow22523_2.runFrom E 3 S = K := by
  split_reads hL hO
  block_init
  mulc za
  mulc zb
  sqrc ua
  sqrc ub
  finish_block
  subst za zb ua ub
  step_loop using
    loop_of_iter (iter6 r0 a0 r1 a1 A B Ta Tb (mul Ya Ta) (mul Yb Tb) (mul Ya Ta) (mul Yb Tb) S K)
      18 1
  subst hS
  exact hK _ hArgs₀

/-- `^bb5`, then the loop at `^bb8`: `MUL2( t1, t2, t1 )`, then `SQRN2( t1, t1, 10 )`, the squares on to `^bb7`. -/
theorem bb5 (r0 a0 r1 a1 : Pointer) (A B Ta Tb Ua Ub Ya Yb : Fe) (S : GlobalState)
    (K : PoisonOr (Vals [] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r0) (.value a0) (.value r1) (.value a1)).get)
    (hL : liveX6 A B Ta Tb Ua Ub E) (hO : out6 E Ya Yb)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r0) (.value a0) (.value r1) (.value a1)).get →
          liveX8 A B Ta Tb E' →
          out8 E' (sqrN 10 (mul Ya Ua)) (sqrN 10 (mul Yb Ub)) →
          fd_ed25519_lane_pow22523_2.runFrom E' 7 S = K) :
    fd_ed25519_lane_pow22523_2.runFrom E 5 S = K := by
  split_reads hL hO
  block_init
  mulc za
  mulc zb
  sqrc ua
  sqrc ub
  finish_block
  subst za zb ua ub
  step_loop using loop_of_iter (iter8 r0 a0 r1 a1 A B Ta Tb (mul Ya Ua) (mul Yb Ub) S K) 8 1
  subst hS
  exact hK _ hArgs₀

/-- `^bb7`, then the loop at `^bb10`: `MUL2( t0, t1, t0 )`, then `SQRN2( t1, t0, 50 )`, the squares on to `^bb9`. -/
theorem bb7 (r0 a0 r1 a1 : Pointer) (A B Ta Tb Ya Yb : Fe) (S : GlobalState)
    (K : PoisonOr (Vals [] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r0) (.value a0) (.value r1) (.value a1)).get)
    (hL : liveX8 A B Ta Tb E) (hO : out8 E Ya Yb)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r0) (.value a0) (.value r1) (.value a1)).get →
          liveX10 A B (mul Ya Ta) (mul Yb Tb) E' →
          out10 E' (sqrN 50 (mul Ya Ta)) (sqrN 50 (mul Yb Tb)) →
          fd_ed25519_lane_pow22523_2.runFrom E' 9 S = K) :
    fd_ed25519_lane_pow22523_2.runFrom E 7 S = K := by
  split_reads hL hO
  block_init
  mulc za
  mulc zb
  sqrc ua
  sqrc ub
  finish_block
  subst za zb ua ub
  step_loop using
    loop_of_iter (iter10 r0 a0 r1 a1 A B (mul Ya Ta) (mul Yb Tb) (mul Ya Ta) (mul Yb Tb) S K) 48 1
  subst hS
  exact hK _ hArgs₀

/-- `^bb9`, then the loop at `^bb12`: `MUL2( t1, t1, t0 )`, then `SQRN2( t2, t1, 100 )`, the squares on to `^bb11`. -/
theorem bb9 (r0 a0 r1 a1 : Pointer) (A B Ta Tb Ya Yb : Fe) (S : GlobalState)
    (K : PoisonOr (Vals [] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r0) (.value a0) (.value r1) (.value a1)).get)
    (hL : liveX10 A B Ta Tb E) (hO : out10 E Ya Yb)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r0) (.value a0) (.value r1) (.value a1)).get →
          liveX12 A B Ta Tb (mul Ya Ta) (mul Yb Tb) E' →
          out12 E' (sqrN 100 (mul Ya Ta)) (sqrN 100 (mul Yb Tb)) →
          fd_ed25519_lane_pow22523_2.runFrom E' 11 S = K) :
    fd_ed25519_lane_pow22523_2.runFrom E 9 S = K := by
  split_reads hL hO
  block_init
  mulc za
  mulc zb
  sqrc ua
  sqrc ub
  finish_block
  subst za zb ua ub
  step_loop using
    loop_of_iter (iter12 r0 a0 r1 a1 A B Ta Tb (mul Ya Ta) (mul Yb Tb) (mul Ya Ta) (mul Yb Tb) S K)
      98 1
  subst hS
  exact hK _ hArgs₀

/-- `^bb11`, then the loop at `^bb14`: `MUL2( t1, t2, t1 )`, then `SQRN2( t1, t1, 50 )`, the squares on to `^bb13`. -/
theorem bb11 (r0 a0 r1 a1 : Pointer) (A B Ta Tb Ua Ub Ya Yb : Fe) (S : GlobalState)
    (K : PoisonOr (Vals [] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r0) (.value a0) (.value r1) (.value a1)).get)
    (hL : liveX12 A B Ta Tb Ua Ub E) (hO : out12 E Ya Yb)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r0) (.value a0) (.value r1) (.value a1)).get →
          liveX14 A B Ta Tb E' →
          out14 E' (sqrN 50 (mul Ya Ua)) (sqrN 50 (mul Yb Ub)) →
          fd_ed25519_lane_pow22523_2.runFrom E' 13 S = K) :
    fd_ed25519_lane_pow22523_2.runFrom E 11 S = K := by
  split_reads hL hO
  block_init
  mulc za
  mulc zb
  sqrc ua
  sqrc ub
  finish_block
  subst za zb ua ub
  step_loop using loop_of_iter (iter14 r0 a0 r1 a1 A B Ta Tb (mul Ya Ua) (mul Yb Ub) S K) 48 1
  subst hS
  exact hK _ hArgs₀

/-- `fd_ed25519_lane_pow22523_2( r0, a0, r1, a1 )` stores `pow22523` of the field element at `a0`
at `r0`, then that of `a1` at `r1`. All loads come before the stores, so the outputs may alias the
inputs and each other. -/
public theorem _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_pow22523_2.call_eq
    (r0 a0 r1 a1 : Pointer) (s : GlobalState) (hwf : s.WF) (ha0 : s.mem.FeFit a0)
    (ha1 : s.mem.FeFit a1) (hr0 : s.mem.FeRoom r0) (hr1 : s.mem.FeRoom r1) :
    Firedancer.Lane.Mlir.fd_ed25519_lane_pow22523_2.call
        (Firedancer.Lane.Mlir.fd_ed25519_lane_pow22523_2.args (.value r0) (.value a0) (.value r1)
          (.value a1))
        s =
      .value
        (.nil,
          { s with
            mem :=
              (s.mem.storeFe r0 (pow22523 (s.mem.readFe a0))).storeFe r1
                (pow22523 (s.mem.readFe a1)) }) := by
  func_init
  block_init
  iterate 13 step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt, ← readFe_l0] inline
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt, ← readFe_l1] inline
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt, ← readFe_l2] inline
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt, ← readFe_l3] inline
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt, ← readFe_l4] inline
  step_load [MemoryState.ofFn_extractVecElem_readAt, ← readFe_l0] inline
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt, ← readFe_l1] inline
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt, ← readFe_l2] inline
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt, ← readFe_l3] inline
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt, ← readFe_l4] inline
  refine
    bb0_run r0 a0 r1 a1 (S₀.mem.readFe a0) (S₀.mem.readFe a1) S E rfl hArgs (by env_reads)
      fun E hA hR => ?_
  split_reads hR
  finish_block
  step_loop using
    loop_of_iter
      (iter2 r0 a0 r1 a1 (S₀.mem.readFe a0) (S₀.mem.readFe a1) (chain5 (S₀.mem.readFe a0))
        (chain5 (S₀.mem.readFe a1)) (chain5 (S₀.mem.readFe a0)) (chain5 (S₀.mem.readFe a1)) S _)
      3 1
  intro hL hO
  refine bb1 r0 a0 r1 a1 _ _ _ _ _ _ S _ E₀ hArgs₀ hL hO fun E hA hL hO => ?_
  refine bb3 r0 a0 r1 a1 _ _ _ _ _ _ S _ E hA hL hO fun E hA hL hO => ?_
  refine bb5 r0 a0 r1 a1 _ _ _ _ _ _ _ _ S _ E hA hL hO fun E hA hL hO => ?_
  refine bb7 r0 a0 r1 a1 _ _ _ _ _ _ S _ E hA hL hO fun E hA hL hO => ?_
  refine bb9 r0 a0 r1 a1 _ _ _ _ _ _ S _ E hA hL hO fun E hA hL hO => ?_
  refine bb11 r0 a0 r1 a1 _ _ _ _ _ _ _ _ S _ E hA hL hO fun E hA hL hO => ?_
  refine bb13 r0 a0 r1 a1 _ _ _ _ _ _ S _ E hA hL hO hr0 hr1 ?_
  subst hS
  rfl

end pow22523_2

end Proof

end MLIR.Firedancer.Lane
