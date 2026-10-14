module

public import Firedancer.Avx512.fd_r43x6_mul_fast
public import Firedancer.Avx512.fd_r43x6_sqr_fast
public import MLIR.Run.BasicBlock
public import MLIR.Run.Tactic
public import MLIR.Run.Vector
public import MLIR.Semantics.Func
import Mathlib.Data.Fintype.Basic
import Mathlib.Tactic.FinCases
import Std.Tactic.BVDecide

/-! `fd_r43x6_sqr_fast` and `fd_r43x6_mul_fast` inlined, each with the `fd_r43x6_fold_unsigned`
after it, as the lane build compiles them: one pattern each (`sqrRun`, `mulRun`), its constants
read from the entry block. The parts are the `Avx512` callee proofs' patterns, copied (they are
private there) with the input a value or an argument. -/

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

-- folded, so the steps' terms and the specs compare without unfolding the lanes
attribute [local irreducible] wwl_add wwl_and wwl_shl wwl_slide wwl_madd52lo wwl_madd52hi

@[expose] public section

set_option hygiene false in
/-- `mulRun`'s steps: the broadcasts, the eleven row patterns, the slides, the sums, `za + 152 zb`
and the fold; then `tail`'s lets. -/
local macro "mul_run_steps" : tactic =>
  `(tactic|
    ( simp only [mulRun, List.cons_append] at hbody
      step_pure with transparent vx0
      step_pure with transparent vx1
      step_pure with transparent vx2
      step_pure with transparent vx3
      step_pure with transparent vx4
      step_pure with transparent vx5
      step_pattern using runBodyFrom_hiRun
      step_pattern using runBodyFrom_loRun
      step_pattern using runBodyFrom_hiRun
      step_pattern using runBodyFrom_loRun
      step_pattern using runBodyFrom_hiRun
      step_pattern using runBodyFrom_loRun
      step_pattern using runBodyFrom_hiRun
      step_pattern using runBodyFrom_loRun
      step_pattern using runBodyFrom_hiRun
      step_pattern using runBodyFrom_loRun
      step_pattern using runBodyFrom_hiRun
      step_pattern using runBodyFrom_slidesRun with vq6
      subst hvq6
      step_pattern using runBodyFrom_loRun
      step_pattern using runBodyFrom_sumsRun with vzh
      subst hvzh
      step_pattern using runBodyFrom_fold152Run with vz
      step_pattern using runBodyFrom_foldRun with vr
      have e : vr = fd_r43x6_mul X Y := by
        rw [hvr, hvz, fd_r43x6_mul, fd_r43x6_mul_fast.spec, tail_eq]
        rfl
      rw [hE, hS, e]
      exact
        hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
          _ _ _ _ _ _))

set_option hygiene false in
/-- `sqrRun`'s steps, the permutes by `perm`: the five patterns; then `reduce`'s lets. -/
local macro "sqr_run_steps " perm:ident : tactic =>
  `(tactic|
    ( simp only [sqrRun] at hbody
      step_pattern using $perm:ident with vd4
      step_pattern using runBodyFrom_sqrProdRun with vp2h
      step_pattern using runBodyFrom_sqrSumsRun with vzh
      subst hvzh
      step_pattern using runBodyFrom_fold152Run with vz
      step_pattern using runBodyFrom_foldRun with vr
      have e : vr = fd_r43x6_sqr X := by
        rw [hvr, hvz, hvp2h, hvd4, fd_r43x6_sqr, fd_r43x6_sqr_fast.spec_eq]
        rfl
      rw [hE, hS, e]
      exact
        hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
          _))

set_option hygiene false in
/-- `sqrPermRun`'s steps: the shuffles' lanes, the doublings checked below the lane width. -/
local macro "sqr_perm_steps" : tactic =>
  `(tactic|
    ( step_pure with transparent v0
      step_pure with transparent v1
      step_pure with transparent v2
      step_pure with transparent v3
      step_pure with transparent v4
      step_pure with transparent v5
      step_pure [sqrDbl_lt] with w0
      step_pure [sqrDbl_lt] with w2
      step_pure [sqrDbl_lt] with w4
      rw [hE, ← hK (Ty.wrap v0) (Ty.wrap v2) (Ty.wrap v4)]
      subst hv1 hv3 hv5
      congr <;> simp [hw0, hw2, hw4, sqrDbl0, sqrDbl2, sqrDbl4, expandOfFn]))

/-! ## `fd_r43x6_sqr_fast` -/

/-- The permutes and doublings, lane by lane. -/
theorem fd_r43x6_sqr_fast.spec_eq (x : Wwl) :
    fd_r43x6_sqr_fast.spec x =
      fd_r43x6_sqr_fast.reduce
        #v[x[0], x[0] <<< 1, x[0] <<< 1, x[0] <<< 1, x[0] <<< 1, x[0] <<< 1, x[3], x[3] <<< 1]
        #v[x[0], x[1], x[2], x[3], x[4], x[5], x[3], x[4]]
        #v[x[4], x[4] <<< 1, x[1], x[1] <<< 1, x[1] <<< 1, x[1] <<< 1, x[1] <<< 1, x[7] <<< 1]
        #v[x[4], x[5], x[1], x[2], x[3], x[4], x[5], x[7]]
        #v[x[3] <<< 1, x[7] <<< 1, x[5], x[7] <<< 1, x[2], x[2] <<< 1, x[2] <<< 1, x[2] <<< 1]
        #v[x[5], x[7], x[5], x[7], x[2], x[3], x[4], x[5]] := by
  delta fd_r43x6_sqr_fast.spec
  dsimp only
  congr 1 <;> apply vec_ext_fin <;> intro i <;> fin_cases i <;>
    simp [wwl_permute, wwl_shl_vector, wwl]

/-! ## The permutes -/

/-- `x0`'s doubling shifts: the non-square terms. -/
def sqrDbl0 : Vector (BitVec 64) 8 :=
  #v[0, 1, 1, 1, 1, 1, 0, 1]

/-- `x2`'s doubling shifts. -/
def sqrDbl2 : Vector (BitVec 64) 8 :=
  #v[0, 1, 0, 1, 1, 1, 1, 1]

/-- `x4`'s doubling shifts. -/
def sqrDbl4 : Vector (BitVec 64) 8 :=
  #v[1, 1, 0, 1, 0, 1, 1, 1]

/-- Every doubling shift is below the lane width. -/
theorem sqrDbl_lt (i : Nat) (h : i < 8) :
    ¬64 ≤ sqrDbl0[i].toNat ∧ ¬64 ≤ sqrDbl2[i].toNat ∧ ¬64 ≤ sqrDbl4[i].toNat := by
  revert i; decide

/-- The six `wwl_permute`s of `x` into `x0 … x5` (`p` the shuffles' unused operand), then
`x0 x2 x4` doubled by the shifts in `s0 s2 s4` into `d0 d2 d4`. -/
def sqrPermRun (x : Reg Γ V) (p x0 x1 x2 x3 x4 x5 s0 s2 s4 d0 d2 d4 : Dst Γ V) : List (Instr Γ) :=
  [.binop (.shufflevector #v[some 0, some 0, some 0, some 0, some 0, some 0, some 3, some 3]) x0 x
      (.val p.i p.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 4, some 5, some 3, some 4]) x1 x
      (.val p.i p.h),
    .binop (.shufflevector #v[some 4, some 4, some 1, some 1, some 1, some 1, some 1, some 7]) x2 x
      (.val p.i p.h),
    .binop (.shufflevector #v[some 4, some 5, some 1, some 2, some 3, some 4, some 5, some 7]) x3 x
      (.val p.i p.h),
    .binop (.shufflevector #v[some 3, some 7, some 5, some 7, some 2, some 2, some 2, some 2]) x4 x
      (.val p.i p.h),
    .binop (.shufflevector #v[some 5, some 7, some 5, some 7, some 2, some 3, some 4, some 5]) x5 x
      (.val p.i p.h),
    .binop (.vector (.shl {})) d0 (.val x0.i x0.h) (.val s0.i s0.h),
    .binop (.vector (.shl {})) d2 (.val x2.i x2.h) (.val s2.i s2.h),
    .binop (.vector (.shl {})) d4 (.val x4.i x4.h) (.val s4.i s4.h)]

/-- Where the body at `pos` is `sqrPermRun` on a value `x` holding `X`, and `s0 s2 s4` hold the
shifts: running on from `pos` then `g` gives `K` if it does from `pos + 9` with the permutes in
`x1 x3 x5` and the doubled ones in `d0 d2 d4`, whatever `x0 x2 x4` hold. -/
theorem runBodyFrom_sqrPermRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x p x0 x1 x2 x3 x4 x5 s0 s2 s4 d0 d2 d4 : Dst Γ V} {rest : List (Instr Γ)}
    {X : Vector (BitVec 64) 8} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody :
      blk.body.drop pos = sqrPermRun (.val x.i x.h) p x0 x1 x2 x3 x4 x5 s0 s2 s4 d0 d2 d4 ++ rest)
    (hR : E ⊨ [x := X, s0 := sqrDbl0, s2 := sqrDbl2, s4 := sqrDbl4])
    (hd : [x.i, x0.i, x1.i, x2.i, x3.i, x4.i, x5.i, s0.i, s2.i, s4.i, d0.i, d2.i, d4.i].Nodup)
    (hK :
      ∀ v0 v2 v4 : ⟦V⟧,
        (blk.runBodyFrom
              E[x0 := v0, x1 := Ty.wrap #v[X[0], X[1], X[2], X[3], X[4], X[5], X[3], X[4]], x2 :=
                v2, x3 := Ty.wrap #v[X[4], X[5], X[1], X[2], X[3], X[4], X[5], X[7]], x4 := v4,
                x5 := Ty.wrap #v[X[5], X[7], X[5], X[7], X[2], X[3], X[4], X[5]], d0 :=
                Ty.wrap
                  #v[X[0], X[0] <<< 1, X[0] <<< 1, X[0] <<< 1, X[0] <<< 1, X[0] <<< 1, X[3],
                    X[3] <<< 1],
                d2 :=
                Ty.wrap
                  #v[X[4], X[4] <<< 1, X[1], X[1] <<< 1, X[1] <<< 1, X[1] <<< 1, X[1] <<< 1,
                    X[7] <<< 1],
                d4 :=
                Ty.wrap
                  #v[X[3] <<< 1, X[7] <<< 1, X[5], X[7] <<< 1, X[2], X[2] <<< 1, X[2] <<< 1,
                    X[2] <<< 1]]
              (pos + 9) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by sqr_perm_steps

/-- `runBodyFrom_sqrPermRun` with `x` an argument. -/
theorem runBodyFrom_sqrPermRunA {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {xa : Fin Γ.args.length} {hxa : Γ.args[xa] = V}
    {p x0 x1 x2 x3 x4 x5 s0 s2 s4 d0 d2 d4 : Dst Γ V} {rest : List (Instr Γ)}
    {X : Vector (BitVec 64) 8} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody :
      blk.body.drop pos = sqrPermRun (.arg xa hxa) p x0 x1 x2 x3 x4 x5 s0 s2 s4 d0 d2 d4 ++ rest)
    (hx : E.read (.arg xa hxa) = Ty.wrap X) (hR : E ⊨ [s0 := sqrDbl0, s2 := sqrDbl2, s4 := sqrDbl4])
    (hd : [x0.i, x1.i, x2.i, x3.i, x4.i, x5.i, s0.i, s2.i, s4.i, d0.i, d2.i, d4.i].Nodup)
    (hK :
      ∀ v0 v2 v4 : ⟦V⟧,
        (blk.runBodyFrom
              E[x0 := v0, x1 := Ty.wrap #v[X[0], X[1], X[2], X[3], X[4], X[5], X[3], X[4]], x2 :=
                v2, x3 := Ty.wrap #v[X[4], X[5], X[1], X[2], X[3], X[4], X[5], X[7]], x4 := v4,
                x5 := Ty.wrap #v[X[5], X[7], X[5], X[7], X[2], X[3], X[4], X[5]], d0 :=
                Ty.wrap
                  #v[X[0], X[0] <<< 1, X[0] <<< 1, X[0] <<< 1, X[0] <<< 1, X[0] <<< 1, X[3],
                    X[3] <<< 1],
                d2 :=
                Ty.wrap
                  #v[X[4], X[4] <<< 1, X[1], X[1] <<< 1, X[1] <<< 1, X[1] <<< 1, X[1] <<< 1,
                    X[7] <<< 1],
                d4 :=
                Ty.wrap
                  #v[X[3] <<< 1, X[7] <<< 1, X[5], X[7] <<< 1, X[2], X[2] <<< 1, X[2] <<< 1,
                    X[2] <<< 1]]
              (pos + 9) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by sqr_perm_steps

/-- A lane below `2^43` doubles without losing a bit. -/
theorem shl_one_ok (a : BitVec 64) (h : a < 0x80000000000#64) :
    a <<< 1 >>> 1 = a ∧ (a <<< 1).sshiftRight 1 = a := by
  constructor <;> bv_decide

/-- `sqrPermRun` with the doublings flagged `nuw nsw`, as compiled where `x`'s lanes are known
small. -/
def sqrPermRunNW (x : Reg Γ V) (p x0 x1 x2 x3 x4 x5 s0 s2 s4 d0 d2 d4 : Dst Γ V) : List (Instr Γ) :=
  [.binop (.shufflevector #v[some 0, some 0, some 0, some 0, some 0, some 0, some 3, some 3]) x0 x
      (.val p.i p.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 4, some 5, some 3, some 4]) x1 x
      (.val p.i p.h),
    .binop (.shufflevector #v[some 4, some 4, some 1, some 1, some 1, some 1, some 1, some 7]) x2 x
      (.val p.i p.h),
    .binop (.shufflevector #v[some 4, some 5, some 1, some 2, some 3, some 4, some 5, some 7]) x3 x
      (.val p.i p.h),
    .binop (.shufflevector #v[some 3, some 7, some 5, some 7, some 2, some 2, some 2, some 2]) x4 x
      (.val p.i p.h),
    .binop (.shufflevector #v[some 5, some 7, some 5, some 7, some 2, some 3, some 4, some 5]) x5 x
      (.val p.i p.h),
    .binop (.vector (.shl { nsw := true, nuw := true })) d0 (.val x0.i x0.h) (.val s0.i s0.h),
    .binop (.vector (.shl { nsw := true, nuw := true })) d2 (.val x2.i x2.h) (.val s2.i s2.h),
    .binop (.vector (.shl { nsw := true, nuw := true })) d4 (.val x4.i x4.h) (.val s4.i s4.h)]

/-- `runBodyFrom_sqrPermRun` for `sqrPermRunNW`, `X`'s lanes below `2^43`. -/
theorem runBodyFrom_sqrPermRunNW {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x p x0 x1 x2 x3 x4 x5 s0 s2 s4 d0 d2 d4 : Dst Γ V} {rest : List (Instr Γ)}
    {X : Vector (BitVec 64) 8} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody :
      blk.body.drop pos = sqrPermRunNW (.val x.i x.h) p x0 x1 x2 x3 x4 x5 s0 s2 s4 d0 d2 d4 ++ rest)
    (hR : E ⊨ [x := X, s0 := sqrDbl0, s2 := sqrDbl2, s4 := sqrDbl4])
    (hX : ∀ i (h : i < 8), X[i] < 0x80000000000#64)
    (hd : [x.i, x0.i, x1.i, x2.i, x3.i, x4.i, x5.i, s0.i, s2.i, s4.i, d0.i, d2.i, d4.i].Nodup)
    (hK :
      ∀ v0 v2 v4 : ⟦V⟧,
        (blk.runBodyFrom
              E[x0 := v0, x1 := Ty.wrap #v[X[0], X[1], X[2], X[3], X[4], X[5], X[3], X[4]], x2 :=
                v2, x3 := Ty.wrap #v[X[4], X[5], X[1], X[2], X[3], X[4], X[5], X[7]], x4 := v4,
                x5 := Ty.wrap #v[X[5], X[7], X[5], X[7], X[2], X[3], X[4], X[5]], d0 :=
                Ty.wrap
                  #v[X[0], X[0] <<< 1, X[0] <<< 1, X[0] <<< 1, X[0] <<< 1, X[0] <<< 1, X[3],
                    X[3] <<< 1],
                d2 :=
                Ty.wrap
                  #v[X[4], X[4] <<< 1, X[1], X[1] <<< 1, X[1] <<< 1, X[1] <<< 1, X[1] <<< 1,
                    X[7] <<< 1],
                d4 :=
                Ty.wrap
                  #v[X[3] <<< 1, X[7] <<< 1, X[5], X[7] <<< 1, X[2], X[2] <<< 1, X[2] <<< 1,
                    X[2] <<< 1]]
              (pos + 9) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨o0, o0'⟩ := shl_one_ok _ (hX 0 (by decide))
  obtain ⟨o1, o1'⟩ := shl_one_ok _ (hX 1 (by decide))
  obtain ⟨o2, o2'⟩ := shl_one_ok _ (hX 2 (by decide))
  obtain ⟨o3, o3'⟩ := shl_one_ok _ (hX 3 (by decide))
  obtain ⟨o4, o4'⟩ := shl_one_ok _ (hX 4 (by decide))
  obtain ⟨o7, o7'⟩ := shl_one_ok _ (hX 7 (by decide))
  step_pure with transparent v0
  step_pure with transparent v1
  step_pure with transparent v2
  step_pure with transparent v3
  step_pure with transparent v4
  step_pure with transparent v5
  step_pure [sqrDbl_lt] with w0
  step_pure [sqrDbl_lt] with w2
  step_pure [sqrDbl_lt] with w4
  rw [hE, ← hK (Ty.wrap v0) (Ty.wrap v2) (Ty.wrap v4)]
  subst hv1 hv3 hv5
  congr <;> simp [hw0, hw2, hw4, sqrDbl0, sqrDbl2, sqrDbl4, expandOfFn, o0, o0', o1, o1', o2, o2',
    o3, o3', o4, o4', o7, o7']

/-- `~mask1` (`wwl_andnot`'s complement): lanes 2 to 7. -/
def sqrMaskN1 : Vector (BitVec 64) 8 :=
  #v[0, 0, 0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF,
    0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF]

/-- `~mask2`: lanes 1 and 3 to 7. -/
def sqrMaskN2 : Vector (BitVec 64) 8 :=
  #v[0, 0xFFFFFFFFFFFFFFFF, 0, 0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF,
    0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF]

/-- `wwl_andnot(mask1, p)`, as compiled: `p` and `mask1`'s complement. -/
theorem and_sqrMaskN1 (p : Vector (BitVec 64) 8) : wwl_and p sqrMaskN1 = wwl_andnot sqrMask1 p := by
  rw [wwl_and, wwl_andnot]
  ext i hi : 1
  simp [sqrMask1, sqrMaskN1, ← List.getElem_map (~~~·)]
  rw [BitVec.and_comm]

/-- `wwl_andnot(mask2, p)`, as compiled. -/
theorem and_sqrMaskN2 (p : Vector (BitVec 64) 8) : wwl_and p sqrMaskN2 = wwl_andnot sqrMask2 p := by
  rw [wwl_and, wwl_andnot]
  ext i hi : 1
  simp [sqrMask2, sqrMaskN2, ← List.getElem_map (~~~·)]
  rw [BitVec.and_comm]

/-! ## The products -/

/-- The products but `x0 x1`'s low part as eight instructions: `madd52lo` of `x2 x3`, `x4 x5` into
`p1l p2l`, `madd52hi` of `x0 x1`, `x2 x3`, `x4 x5` into `t0 t1 t2` shifted by `9` into
`p0h p1h p2h` (`zero nine` hold the splats). -/
def sqrProdRun (x0 x1 x2 x3 x4 x5 zero nine p1l p2l t0 p0h t1 p1h t2 p2h : Dst Γ V) :
    List (Instr Γ) :=
  [.ternop .vpmadd52l p1l (.val zero.i zero.h) (.val x2.i x2.h) (.val x3.i x3.h),
    .ternop .vpmadd52l p2l (.val zero.i zero.h) (.val x4.i x4.h) (.val x5.i x5.h),
    .ternop .vpmadd52h t0 (.val zero.i zero.h) (.val x0.i x0.h) (.val x1.i x1.h),
    .binop (.vector (.shl {})) p0h (.val t0.i t0.h) (.val nine.i nine.h),
    .ternop .vpmadd52h t1 (.val zero.i zero.h) (.val x2.i x2.h) (.val x3.i x3.h),
    .binop (.vector (.shl {})) p1h (.val t1.i t1.h) (.val nine.i nine.h),
    .ternop .vpmadd52h t2 (.val zero.i zero.h) (.val x4.i x4.h) (.val x5.i x5.h),
    .binop (.vector (.shl {})) p2h (.val t2.i t2.h) (.val nine.i nine.h)]

/-- Where the body at `pos` is `sqrProdRun` and `x0 … x5` hold `X0 … X5`: running on from `pos` then
`g` gives `K` if it does from `pos + 8` with the products in `p1l … p2h`, whatever `t0 t1 t2`
hold. -/
theorem runBodyFrom_sqrProdRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x0 x1 x2 x3 x4 x5 zero nine p1l p2l t0 p0h t1 p1h t2 p2h : Dst Γ V} {rest : List (Instr Γ)}
    {X0 X1 X2 X3 X4 X5 : Vector (BitVec 64) 8} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        sqrProdRun x0 x1 x2 x3 x4 x5 zero nine p1l p2l t0 p0h t1 p1h t2 p2h ++ rest)
    (hR :
      E ⊨ [x0 := X0, x1 := X1, x2 := X2, x3 := X3, x4 := X4, x5 := X5, zero := Vector.replicate 8 0,
        nine := Vector.replicate 8 9])
    (hd :
      [x0.i, x1.i, x2.i, x3.i, x4.i, x5.i, zero.i, nine.i, p1l.i, p2l.i, t0.i, p0h.i, t1.i, p1h.i,
          t2.i].Nodup)
    (hK :
      ∀ vt0 vt1 vt2 : ⟦V⟧,
        (blk.runBodyFrom
              E[p1l := wwl_madd52lo wwl_zero X2 X3, p2l := wwl_madd52lo wwl_zero X4 X5, t0 := vt0,
                p0h := wwl_shl (wwl_madd52hi wwl_zero X0 X1) 9, t1 := vt1, p1h :=
                wwl_shl (wwl_madd52hi wwl_zero X2 X3) 9, t2 := vt2, p2h :=
                wwl_shl (wwl_madd52hi wwl_zero X4 X5) 9]
              (pos + 8) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with v1
  step_pure with v2
  step_pure with transparent w0
  step_pure with h0
  step_pure with transparent w1
  step_pure with h1
  step_pure with transparent w2
  step_pure with h2
  have e1 : v1 = wwl_madd52lo wwl_zero X2 X3 := by
    rw [hv1]; ext i hi : 1; simp [wwl_madd52lo, madd52lo]
  have e2 : v2 = wwl_madd52lo wwl_zero X4 X5 := by
    rw [hv2]; ext i hi : 1; simp [wwl_madd52lo, madd52lo]
  have f0 : h0 = wwl_shl (wwl_madd52hi wwl_zero X0 X1) 9 := by
    rw [hh0]; ext i hi : 1; simp [wwl_shl, wwl_madd52hi, madd52hi]
  have f1 : h1 = wwl_shl (wwl_madd52hi wwl_zero X2 X3) 9 := by
    rw [hh1]; ext i hi : 1; simp [wwl_shl, wwl_madd52hi, madd52hi]
  have f2 : h2 = wwl_shl (wwl_madd52hi wwl_zero X4 X5) 9 := by
    rw [hh2]; ext i hi : 1; simp [wwl_shl, wwl_madd52hi, madd52hi]
  rw [hE, e1, e2, f0, f1, f2]
  exact hK _ _ _

/-! ## The sums -/

/-- The sums as twenty instructions: `wwl_andnot`s (as `and`s with `mn1 mn2`, the masks'
complements) into `l* h*`, `x0 x1`'s low product accumulated onto `l2 + l1` into `zll`, `wwl_and`s
with `m1l m2l m1h m2h` (the masks on the read lanes) into `k* j*`, the adds, and the slides (`pz zp`
the zero operands) into `zl` and `zh`. -/
def sqrSumsRun
    (x0 x1 p1l p2l p0h p1h p2h mn1 mn2 m1l m2l m1h m2h pz zp l1 l2 ls zll h1 h2 zlh0 zlh k1 k2 j1 j2
      zhh zlhs zl zhhs zlht zhl zh0 zh : Dst Γ V) :
    List (Instr Γ) :=
  [.binop (.vector .and) l1 (.val p1l.i p1l.h) (.val mn1.i mn1.h),
    .binop (.vector .and) l2 (.val p2l.i p2l.h) (.val mn2.i mn2.h),
    .binop (.vector (.add {})) ls (.val l2.i l2.h) (.val l1.i l1.h),
    .ternop .vpmadd52l zll (.val ls.i ls.h) (.val x0.i x0.h) (.val x1.i x1.h),
    .binop (.vector .and) h1 (.val p1h.i p1h.h) (.val mn1.i mn1.h),
    .binop (.vector .and) h2 (.val p2h.i p2h.h) (.val mn2.i mn2.h),
    .binop (.vector (.add {})) zlh0 (.val h1.i h1.h) (.val p0h.i p0h.h),
    .binop (.vector (.add {})) zlh (.val zlh0.i zlh0.h) (.val h2.i h2.h),
    .binop (.vector .and) k1 (.val p1l.i p1l.h) (.val m1l.i m1l.h),
    .binop (.vector .and) k2 (.val p2l.i p2l.h) (.val m2l.i m2l.h),
    .binop (.vector .and) j1 (.val p1h.i p1h.h) (.val m1h.i m1h.h),
    .binop (.vector .and) j2 (.val p2h.i p2h.h) (.val m2h.i m2h.h),
    .binop (.vector (.add {})) zhh (.val j2.i j2.h) (.val j1.i j1.h),
    .binop (.shufflevector #v[some 7, some 8, some 9, some 10, some 11, some 12, some 13, some 14])
      zlhs (.val pz.i pz.h) (.val zlh.i zlh.h),
    .binop (.vector (.add {})) zl (.val zlhs.i zlhs.h) (.val zll.i zll.h),
    .binop (.shufflevector #v[some 7, some 8, some 9, some 10, some 11, some 12, none, none]) zhhs
      (.val pz.i pz.h) (.val zhh.i zhh.h),
    .binop (.shufflevector #v[some 7, some 8, some 9, some 10, some 11, some 12, none, none]) zlht
      (.val zlh.i zlh.h) (.val zp.i zp.h),
    .binop (.vector (.add {})) zhl (.val k2.i k2.h) (.val k1.i k1.h),
    .binop (.vector (.add {})) zh0 (.val zhl.i zhl.h) (.val zhhs.i zhhs.h),
    .binop (.vector (.add {})) zh (.val zh0.i zh0.h) (.val zlht.i zlht.h)]

/-- Where the body at `pos` is `sqrSumsRun`, `x0 x1` hold `X0 X1`, `p1l … p2h` the products and the
others the masks: running on from `pos` then `g` gives `K` if it does from `pos + 20` with `sums`'
`zl` in `zl` and its `zh` in `zh`'s lanes `0 … 5`, whatever the intermediates hold. -/
theorem runBodyFrom_sqrSumsRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x0 x1 p1l p2l p0h p1h p2h mn1 mn2 m1l m2l m1h m2h pz zp l1 l2 ls zll h1 h2 zlh0 zlh k1 k2 j1 j2
      zhh zlhs zl zhhs zlht zhl zh0 zh : Dst Γ V}
    {rest : List (Instr Γ)} {X0 X1 P1L P2L P0H P1H P2H : Vector (BitVec 64) 8} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        sqrSumsRun x0 x1 p1l p2l p0h p1h p2h mn1 mn2 m1l m2l m1h m2h pz zp l1 l2 ls zll h1 h2 zlh0
            zlh k1 k2 j1 j2 zhh zlhs zl zhhs zlht zhl zh0 zh ++
          rest)
    (hR :
      E ⊨ [x0 := X0, x1 := X1, p1l := P1L, p2l := P2L, p0h := P0H, p1h := P1H, p2h := P2H, mn1 :=
        sqrMaskN1, mn2 := sqrMaskN2, m1l := lanesBelow 6 sqrMask1, m2l := lanesBelow 6 sqrMask2,
        m1h := lanesBelow 5 sqrMask1, m2h := lanesBelow 5 sqrMask2, pz := lanesFrom 7 wwl_zero,
        zp := lanesBelow 5 wwl_zero])
    (hd :
      [x0.i, x1.i, p1l.i, p2l.i, p0h.i, p1h.i, p2h.i, mn1.i, mn2.i, m1l.i, m2l.i, m1h.i, m2h.i,
          pz.i, zp.i, l1.i, l2.i, ls.i, zll.i, h1.i, h2.i, zlh0.i, zlh.i, k1.i, k2.i, j1.i, j2.i,
          zhh.i, zlhs.i, zl.i, zhhs.i, zlht.i, zhl.i, zh0.i].Nodup)
    (hK :
      ∀ vl1 vl2 vls vzll vh1 vh2 vzlh0 vzlh vk1 vk2 vj1 vj2 vzhh vzlhs vzhhs vzlht vzhl vzh0 : ⟦V⟧,
        (blk.runBodyFrom
              E[l1 := vl1, l2 := vl2, ls := vls, zll := vzll, h1 := vh1, h2 := vh2, zlh0 := vzlh0,
                zlh := vzlh, k1 := vk1, k2 := vk2, j1 := vj1, j2 := vj2, zhh := vzhh, zlhs := vzlhs,
                zl :=
                Ty.wrap
                  (fd_r43x6_sqr_fast.sums (wwl_madd52lo wwl_zero X0 X1) P1L P2L P0H P1H P2H).1,
                zhhs := vzhhs, zlht := vzlht, zhl := vzhl, zh0 := vzh0, zh :=
                low6 (fd_r43x6_sqr_fast.sums (wwl_madd52lo wwl_zero X0 X1) P1L P2L P0H P1H P2H).2]
              (pos + 20) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with vl1
  step_pure with vl2
  step_pure with vls
  step_pure with vzll
  step_pure with vh1
  step_pure with vh2
  step_pure with vzlh0
  step_pure with vzlh
  step_pure with vk1
  step_pure with vk2
  step_pure with vj1
  step_pure with vj2
  step_pure with vzhh
  step_pure with vzlhs
  step_pure with vzl
  step_pure with vzhhs
  step_pure with vzlht
  step_pure with vzhl
  step_pure with vzh0
  step_pure with vzh
  have ezll : vzll = wwl_add vls (wwl_madd52lo wwl_zero X0 X1) := by
    rw [hvzll]; ext i hi : 1; simp [wwl_add, wwl_madd52lo, madd52lo, wwl_zero]
  subst ezll
  -- the steps' lanes as the intrinsics they are
  simp only [← wwl_add_getElem, ← wwl_and_getElem, Vector.ofFn_getElem, lanesFrom_getElem,
    Nat.le_refl, ↓reduceIte, Vector.getElem_replicate, BitVec.ofNat_eq_ofNat, pullWrap,
    ← wwl_slide_zero_7] at hvl1 hvl2 hvls hvh1 hvh2 hvzlh0 hvzlh hvzlhs
  subst hvl1 hvl2 hvls hvh1 hvh2 hvzlh0 hvzlh hvzlhs
  simp only [ofFn_and_lanesBelow] at hvk1 hvk2 hvj1 hvj2
  subst hvk1 hvk2 hvj1 hvj2
  simp only [ofFn_add_lanesBelow] at hvzhh hvzhl
  subst hvzhh hvzhl
  simp only [lanesFrom_getElem, lanesBelow_getElem, Nat.reduceLeDiff, Nat.reduceLT, ↓reduceIte,
    Vector.getElem_replicate, BitVec.ofNat_eq_ofNat, ← low6_wwl_slide_zero_7,
    ← low6_wwl_slide_7_zero] at hvzhhs hvzlht
  subst hvzhhs hvzlht
  simp only [ofFn_add_lanesBelow] at hvzh0
  subst hvzh0
  simp only [ofFn_add_lanesBelow] at hvzh
  have e1 :
    vzl =
      Ty.wrap (t := V)
        (fd_r43x6_sqr_fast.sums (wwl_madd52lo wwl_zero X0 X1) P1L P2L P0H P1H P2H).1 := by
    simp only [hvzl, wrapGetElem, PoisonOr.value_bind, pullWrapOfFn, ← wwl_add_getElem,
      Vector.ofFn_getElem, fd_r43x6_sqr_fast.sums, and_sqrMaskN1, and_sqrMaskN2]
    ac_rfl
  have e2 :
    vzh = low6 (fd_r43x6_sqr_fast.sums (wwl_madd52lo wwl_zero X0 X1) P1L P2L P0H P1H P2H).2 := by
    simp only [hvzh, fd_r43x6_sqr_fast.sums, and_sqrMaskN1, and_sqrMaskN2]
    ac_rfl
  rw [hE, e1, e2]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

/-! ## `fd_r43x6_mul_fast` -/

open Firedancer.Avx512.fd_r43x6_mul_fast (tail)

/-- Setting all eight lanes of `w` gives the literal, whatever `w` is. -/
theorem set_lanes (w : Vector α 8) (a0 a1 a2 a3 a4 a5 a6 a7 : α) :
    ((((((((w.set 0 a0).set 1 a1).set 2 a2).set 3 a3).set 4 a4).set 5 a5).set 6 a6).set 7 a7) =
      #v[a0, a1, a2, a3, a4, a5, a6, a7] := by
  apply vec_ext_fin
  intro i
  fin_cases i <;> simp

/-- `wwl_zero()` as a slide reads it: lane `k` of the vector `u` set to `s_k`, `0` or poison. -/
def padRun (u r0 r1 r2 r3 r4 r5 r6 r7 : Dst Γ V) (s0 s1 s2 s3 s4 s5 s6 s7 : Dst Γ (.bv 64))
    (i0 i1 i2 i3 i4 i5 i6 i7 : Dst Γ (.bv 32)) : List (Instr Γ) :=
  [.ternop .insertelement r0 (.val u.i u.h) (.val s0.i s0.h) (.val i0.i i0.h),
    .ternop .insertelement r1 (.val r0.i r0.h) (.val s1.i s1.h) (.val i1.i i1.h),
    .ternop .insertelement r2 (.val r1.i r1.h) (.val s2.i s2.h) (.val i2.i i2.h),
    .ternop .insertelement r3 (.val r2.i r2.h) (.val s3.i s3.h) (.val i3.i i3.h),
    .ternop .insertelement r4 (.val r3.i r3.h) (.val s4.i s4.h) (.val i4.i i4.h),
    .ternop .insertelement r5 (.val r4.i r4.h) (.val s5.i s5.h) (.val i5.i i5.h),
    .ternop .insertelement r6 (.val r5.i r5.h) (.val s6.i s6.h) (.val i6.i i6.h),
    .ternop .insertelement r7 (.val r6.i r6.h) (.val s7.i s7.h) (.val i7.i i7.h)]

/-- Where the body at `pos` is `padRun`, `s_k` hold `S_k` and `i_k` hold `k`: `r7` gets
`#v[S0, …, S7]`. -/
theorem runBodyFrom_padRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {u r0 r1 r2 r3 r4 r5 r6 r7 : Dst Γ V} {s0 s1 s2 s3 s4 s5 s6 s7 : Dst Γ (.bv 64)}
    {i0 i1 i2 i3 i4 i5 i6 i7 : Dst Γ (.bv 32)} {rest : List (Instr Γ)}
    {S0 S1 S2 S3 S4 S5 S6 S7 : PoisonOr (BitVec 64)} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        padRun u r0 r1 r2 r3 r4 r5 r6 r7 s0 s1 s2 s3 s4 s5 s6 s7 i0 i1 i2 i3 i4 i5 i6 i7 ++ rest)
    (hR :
      E ⊨ [s0 := S0, s1 := S1, s2 := S2, s3 := S3, s4 := S4, s5 := S5, s6 := S6, s7 := S7, i0 :=
        0#32, i1 := 1#32, i2 := 2#32, i3 := 3#32, i4 := 4#32, i5 := 5#32, i6 := 6#32, i7 := 7#32])
    (hd1 : [s1.i, i1.i, r0.i, r1.i, r2.i, r3.i, r4.i, r5.i, r6.i].Nodup)
    (hd2 : [s2.i, i2.i, r0.i, r1.i, r2.i, r3.i, r4.i, r5.i, r6.i].Nodup)
    (hd3 : [s3.i, i3.i, r0.i, r1.i, r2.i, r3.i, r4.i, r5.i, r6.i].Nodup)
    (hd4 : [s4.i, i4.i, r0.i, r1.i, r2.i, r3.i, r4.i, r5.i, r6.i].Nodup)
    (hd5 : [s5.i, i5.i, r0.i, r1.i, r2.i, r3.i, r4.i, r5.i, r6.i].Nodup)
    (hd6 : [s6.i, i6.i, r0.i, r1.i, r2.i, r3.i, r4.i, r5.i, r6.i].Nodup)
    (hd7 : [s7.i, i7.i, r0.i, r1.i, r2.i, r3.i, r4.i, r5.i, r6.i].Nodup)
    (hK :
      ∀ v0 v1 v2 v3 v4 v5 v6 : ⟦V⟧,
        (blk.runBodyFrom
              E[r0 := v0, r1 := v1, r2 := v2, r3 := v3, r4 := v4, r5 := v5, r6 := v6, r7 :=
                (#v[S0, S1, S2, S3, S4, S5, S6, S7] : ⟦V⟧)]
              (pos + 8) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with v0
  step_pure with v1
  step_pure with v2
  step_pure with v3
  step_pure with v4
  step_pure with v5
  step_pure with v6
  step_pure with v7
  subst hv0 hv1 hv2 hv3 hv4 hv5 hv6
  rw [set_lanes] at hv7
  rw [hE, hv7]
  exact hK _ _ _ _ _ _ _

/-- `runBodyFrom_padRun`, the vector given as `W` (`lanesBelow 6 sqrMask1`, …). -/
theorem runBodyFrom_padRunAs (W : ⟦V⟧) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {u r0 r1 r2 r3 r4 r5 r6 r7 : Dst Γ V} {s0 s1 s2 s3 s4 s5 s6 s7 : Dst Γ (.bv 64)}
    {i0 i1 i2 i3 i4 i5 i6 i7 : Dst Γ (.bv 32)} {rest : List (Instr Γ)}
    {S0 S1 S2 S3 S4 S5 S6 S7 : PoisonOr (BitVec 64)} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        padRun u r0 r1 r2 r3 r4 r5 r6 r7 s0 s1 s2 s3 s4 s5 s6 s7 i0 i1 i2 i3 i4 i5 i6 i7 ++ rest)
    (hR :
      E ⊨ [s0 := S0, s1 := S1, s2 := S2, s3 := S3, s4 := S4, s5 := S5, s6 := S6, s7 := S7, i0 :=
        0#32, i1 := 1#32, i2 := 2#32, i3 := 3#32, i4 := 4#32, i5 := 5#32, i6 := 6#32, i7 := 7#32])
    (hd1 : [s1.i, i1.i, r0.i, r1.i, r2.i, r3.i, r4.i, r5.i, r6.i].Nodup)
    (hd2 : [s2.i, i2.i, r0.i, r1.i, r2.i, r3.i, r4.i, r5.i, r6.i].Nodup)
    (hd3 : [s3.i, i3.i, r0.i, r1.i, r2.i, r3.i, r4.i, r5.i, r6.i].Nodup)
    (hd4 : [s4.i, i4.i, r0.i, r1.i, r2.i, r3.i, r4.i, r5.i, r6.i].Nodup)
    (hd5 : [s5.i, i5.i, r0.i, r1.i, r2.i, r3.i, r4.i, r5.i, r6.i].Nodup)
    (hd6 : [s6.i, i6.i, r0.i, r1.i, r2.i, r3.i, r4.i, r5.i, r6.i].Nodup)
    (hd7 : [s7.i, i7.i, r0.i, r1.i, r2.i, r3.i, r4.i, r5.i, r6.i].Nodup)
    (hW : (#v[S0, S1, S2, S3, S4, S5, S6, S7] : ⟦V⟧) = W)
    (hK :
      ∀ v0 v1 v2 v3 v4 v5 v6 : ⟦V⟧,
        (blk.runBodyFrom E[r0 := v0, r1 := v1, r2 := v2, r3 := v3, r4 := v4, r5 := v5, r6 := v6,
              r7 := W]
              (pos + 8) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K :=
  runBodyFrom_padRun hbody hR hd1 hd2 hd3 hd4 hd5 hd6 hd7 (hW ▸ hK)

/-- Row `k`'s high half: `wwl_madd52hi(wwl_zero(), x_k, y)` in `uh`, shifted up by `9` into `ph`. -/
def hiRun (zr nine xk : Dst Γ V) (y : Reg Γ V) (uh ph : Dst Γ V) : List (Instr Γ) :=
  [.ternop .vpmadd52h uh (.val zr.i zr.h) (.val xk.i xk.h) y,
    .binop (.vector (.shl {})) ph (.val uh.i uh.h) (.val nine.i nine.h)]

/-- Where the body at `pos` is `hiRun`, `xk` holds `XK` and `y` holds `Y`: `ph` gets
`wwl_shl (wwl_madd52hi wwl_zero XK Y) 9`. -/
theorem runBodyFrom_hiRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {zr nine xk : Dst Γ V}
    {y : Reg Γ V} {uh ph : Dst Γ V} {rest : List (Instr Γ)} {XK Y : Vector (BitVec 64) 8}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = hiRun zr nine xk y uh ph ++ rest)
    (hR : E ⊨ [zr := wwl_zero, nine := Vector.replicate 8 9, xk := XK]) (hy : E.read y = Ty.wrap Y)
    (hd : [uh.i, nine.i].Nodup)
    (hK :
      ∀ vuh : ⟦V⟧,
        (blk.runBodyFrom E[uh := vuh, ph := Ty.wrap (wwl_shl (wwl_madd52hi wwl_zero XK Y) 9)]
              (pos + 2) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure [hy] with transparent vuh
  step_pure with vph
  have h : vph = wwl_shl (wwl_madd52hi wwl_zero XK Y) 9 := by
    rw [hvph]; ext i hi : 1; simp [wwl_shl, wwl_madd52hi, madd52hi]
  rw [hE, h, ← hK (Ty.wrap vuh)]

/-- `t = wwl_madd52lo(a, x_k, y)`. -/
def loRun (a xk : Dst Γ V) (y : Reg Γ V) (t : Dst Γ V) : List (Instr Γ) :=
  [.ternop .vpmadd52l t (.val a.i a.h) (.val xk.i xk.h) y]

/-- Where the body at `pos` is `loRun`, `a` holds `A`, `xk` holds `XK` and `y` holds `Y`: `t` gets
`wwl_madd52lo A XK Y`. -/
theorem runBodyFrom_loRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {a xk : Dst Γ V}
    {y : Reg Γ V} {t : Dst Γ V} {rest : List (Instr Γ)} {A XK Y : Vector (BitVec 64) 8}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = loRun a xk y t ++ rest) (hR : E ⊨ [a := A, xk := XK])
    (hy : E.read y = Ty.wrap Y)
    (hK : (blk.runBodyFrom E[t := Ty.wrap (wwl_madd52lo A XK Y)] (pos + 1) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure [hy] with vt
  have h : vt = wwl_madd52lo A XK Y := by
    rw [hvt]; ext i hi : 1; simp [wwl_madd52lo, madd52lo]
  rw [hE, h, hK]

/-- The slides as shuffles, `p_k` from `a_k` (wwl_zero where read) and `t_k`, `q_k` from `t_k` and
`b_k` (wwl_zero where read), poison from lane `6`. -/
def slidesRun (a1 a2 a3 b3 a4 b4 a5 b5 a6 pz t1 t2 t3 t4 t5 t6 : Dst Γ V)
    (p1 p2 p3 q3 p4 q4 p5 q5 p6 q6 : Dst Γ V) : List (Instr Γ) :=
  [.binop (.shufflevector #v[some 7, some 8, some 9, some 10, some 11, some 12, some 13, some 14])
      p1 (.val a1.i a1.h) (.val t1.i t1.h),
    .binop (.shufflevector #v[some 6, some 7, some 8, some 9, some 10, some 11, some 12, some 13])
      p2 (.val a2.i a2.h) (.val t2.i t2.h),
    .binop (.shufflevector #v[some 5, some 6, some 7, some 8, some 9, some 10, some 11, some 12]) p3
      (.val a3.i a3.h) (.val t3.i t3.h),
    .binop (.shufflevector #v[some 5, some 6, some 7, some 8, some 9, some 10, none, none]) q3
      (.val t3.i t3.h) (.val b3.i b3.h),
    .binop (.shufflevector #v[some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11]) p4
      (.val a4.i a4.h) (.val t4.i t4.h),
    .binop (.shufflevector #v[some 4, some 5, some 6, some 7, some 8, some 9, none, none]) q4
      (.val t4.i t4.h) (.val b4.i b4.h),
    .binop (.shufflevector #v[some 3, some 4, some 5, some 6, some 7, some 8, some 9, some 10]) p5
      (.val a5.i a5.h) (.val t5.i t5.h),
    .binop (.shufflevector #v[some 3, some 4, some 5, some 6, some 7, some 8, none, none]) q5
      (.val t5.i t5.h) (.val b5.i b5.h),
    .binop (.shufflevector #v[some 2, some 3, some 4, some 5, some 6, some 7, some 8, some 9]) p6
      (.val a6.i a6.h) (.val t6.i t6.h),
    .binop (.shufflevector #v[some 2, some 3, some 4, some 5, some 6, some 7, none, none]) q6
      (.val t6.i t6.h) (.val pz.i pz.h)]

/-- Where the body at `pos` is `slidesRun` and `t_k` hold `T_k`: `tail`'s `p_kj`, and its `q_kj` but
lanes `6` and `7`. -/
theorem runBodyFrom_slidesRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {a1 a2 a3 b3 a4 b4 a5 b5 a6 pz t1 t2 t3 t4 t5 t6 : Dst Γ V}
    {p1 p2 p3 q3 p4 q4 p5 q5 p6 q6 : Dst Γ V} {rest : List (Instr Γ)}
    {T1 T2 T3 T4 T5 T6 : Vector (BitVec 64) 8} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        slidesRun a1 a2 a3 b3 a4 b4 a5 b5 a6 pz t1 t2 t3 t4 t5 t6 p1 p2 p3 q3 p4 q4 p5 q5 p6 q6 ++
          rest)
    (hR :
      E ⊨ [a1 := lanesFrom 7 wwl_zero, a2 := lanesFrom 6 wwl_zero, a3 := lanesFrom 5 wwl_zero, b3 :=
        lanesBelow 3 wwl_zero, a4 := lanesFrom 4 wwl_zero, b4 := lanesBelow 2 wwl_zero, a5 :=
        lanesFrom 3 wwl_zero, b5 := lanesBelow 1 wwl_zero, a6 := lanesFrom 2 wwl_zero, t1 := T1,
        t2 := T2, t3 := T3, t4 := T4, t5 := T5, t6 := T6])
    (hd :
      [a1.i, a2.i, a3.i, b3.i, a4.i, b4.i, a5.i, b5.i, a6.i, t1.i, t2.i, t3.i, t4.i, t5.i, t6.i,
          p1.i, p2.i, p3.i, q3.i, p4.i, q4.i, p5.i, q5.i, p6.i].Nodup)
    (hK :
      (blk.runBodyFrom
            E[p1 := Ty.wrap (wwl_slide wwl_zero T1 7), p2 := Ty.wrap (wwl_slide wwl_zero T2 6),
              p3 := Ty.wrap (wwl_slide wwl_zero T3 5), q3 := low6 (wwl_slide T3 wwl_zero 5), p4 :=
              Ty.wrap (wwl_slide wwl_zero T4 4), q4 := low6 (wwl_slide T4 wwl_zero 4), p5 :=
              Ty.wrap (wwl_slide wwl_zero T5 3), q5 := low6 (wwl_slide T5 wwl_zero 3), p6 :=
              Ty.wrap (wwl_slide wwl_zero T6 2), q6 := low6 (wwl_slide T6 wwl_zero 2)]
            (pos + 10) S >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with vp1
  step_pure with vp2
  step_pure with vp3
  step_pure with vq3
  step_pure with vp4
  step_pure with vq4
  step_pure with vp5
  step_pure with vq5
  step_pure with vp6
  step_pure with vq6
  -- the shuffles' lanes as the slides they are
  simp only [lanesFrom_getElem, lanesBelow_getElem, Nat.reduceLeDiff, Nat.reduceLT, ↓reduceIte,
    Vector.getElem_replicate, BitVec.ofNat_eq_ofNat, pullWrap, ← wwl_slide_zero_6,
    ← wwl_slide_zero_5, ← wwl_slide_zero_4, ← wwl_slide_zero_3, ← wwl_slide_zero_2,
    ← low6_wwl_slide_5_zero, ← low6_wwl_slide_4_zero, ← low6_wwl_slide_3_zero,
    ← low6_wwl_slide_2_zero,
    ← wwl_slide_zero_7] at hvp1 hvp2 hvp3 hvq3 hvp4 hvq4 hvp5 hvq5 hvp6 hvq6
  subst hvp1 hvp2 hvp3 hvq3 hvp4 hvq4 hvp5 hvq5 hvp6 hvq6
  rw [hE]
  exact hK

/-- `zl` and `zh` as compiled: `p3j + p2j + p4j + p5j + s1 + p6j` and `q4j + q3j + q5j + q6j`. -/
def sumsRun (s1 p2 p3 p4 p5 p6 q3 q4 q5 q6 : Dst Γ V) (s2 s3 s4 s5 zl h1 h2 zh : Dst Γ V) :
    List (Instr Γ) :=
  [.binop (.vector (.add {})) s2 (.val p3.i p3.h) (.val p2.i p2.h),
    .binop (.vector (.add {})) s3 (.val s2.i s2.h) (.val p4.i p4.h),
    .binop (.vector (.add {})) s4 (.val s3.i s3.h) (.val p5.i p5.h),
    .binop (.vector (.add {})) s5 (.val s4.i s4.h) (.val s1.i s1.h),
    .binop (.vector (.add {})) zl (.val s5.i s5.h) (.val p6.i p6.h),
    .binop (.vector (.add {})) h1 (.val q4.i q4.h) (.val q3.i q3.h),
    .binop (.vector (.add {})) h2 (.val h1.i h1.h) (.val q5.i q5.h),
    .binop (.vector (.add {})) zh (.val h2.i h2.h) (.val q6.i q6.h)]

/-- Where the body at `pos` is `sumsRun`: `zl` and `zh` get the sums, `zh` but lanes `6` and `7`. -/
theorem runBodyFrom_sumsRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {s1 p2 p3 p4 p5 p6 q3 q4 q5 q6 s2 s3 s4 s5 zl h1 h2 zh : Dst Γ V} {rest : List (Instr Γ)}
    {S1 P2 P3 P4 P5 P6 Q3 Q4 Q5 Q6 : Vector (BitVec 64) 8} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos = sumsRun s1 p2 p3 p4 p5 p6 q3 q4 q5 q6 s2 s3 s4 s5 zl h1 h2 zh ++ rest)
    (hR :
      E ⊨ [s1 := S1, p2 := P2, p3 := P3, p4 := P4, p5 := P5, p6 := P6, q3 := low6 Q3, q4 := low6 Q4,
        q5 := low6 Q5, q6 := low6 Q6])
    (hd :
      [s1.i, p2.i, p3.i, p4.i, p5.i, p6.i, q3.i, q4.i, q5.i, q6.i, s2.i, s3.i, s4.i, s5.i, zl.i,
          h1.i, h2.i].Nodup)
    (hK :
      ∀ vs2 vs3 vs4 vs5 vh1 vh2 : ⟦V⟧,
        (blk.runBodyFrom
              E[s2 := vs2, s3 := vs3, s4 := vs4, s5 := vs5, zl :=
                Ty.wrap (wwl_add (wwl_add (wwl_add (wwl_add (wwl_add P3 P2) P4) P5) S1) P6), h1 :=
                vh1, h2 := vh2, zh := low6 (wwl_add (wwl_add (wwl_add Q4 Q3) Q5) Q6)]
              (pos + 8) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with vs2
  step_pure with vs3
  step_pure with vs4
  step_pure with vs5
  step_pure with vzl
  step_pure with vh1
  step_pure with vh2
  step_pure with vzh
  simp only [← wwl_add_getElem, Vector.ofFn_getElem] at hvs2 hvs3 hvs4 hvs5 hvzl
  subst hvs2 hvs3 hvs4 hvs5
  simp only [ofFn_add_lanesBelow] at hvh1
  subst hvh1
  simp only [ofFn_add_lanesBelow] at hvh2
  subst hvh2
  simp only [ofFn_add_lanesBelow] at hvzh
  rw [hE, hvzl, hvzh]
  exact hK _ _ _ _ _ _

/-- `tail` is `fold152` of the add chains as compiled, `t0 + p1j` as one `wwl_madd52lo`. -/
theorem tail_eq (x0 y t1 t2 t3 t4 t5 t6 : Vector (BitVec 64) 8) :
    tail (wwl_madd52lo wwl_zero x0 y) t1 t2 t3 t4 t5 t6 =
      fold152
        (wwl_add
          (wwl_add
            (wwl_add
              (wwl_add (wwl_add (wwl_slide wwl_zero t3 5) (wwl_slide wwl_zero t2 6))
                (wwl_slide wwl_zero t4 4))
              (wwl_slide wwl_zero t5 3))
            (wwl_madd52lo (wwl_slide wwl_zero t1 7) x0 y))
          (wwl_slide wwl_zero t6 2))
        (wwl_add
          (wwl_add (wwl_add (wwl_slide t4 wwl_zero 4) (wwl_slide t3 wwl_zero 5))
            (wwl_slide t5 wwl_zero 3))
          (wwl_slide t6 wwl_zero 2)) := by
  have hl :
    wwl_add
        (wwl_add (wwl_add (wwl_madd52lo wwl_zero x0 y) (wwl_slide wwl_zero t1 7))
          (wwl_add (wwl_slide wwl_zero t2 6) (wwl_slide wwl_zero t3 5)))
        (wwl_add (wwl_add (wwl_slide wwl_zero t4 4) (wwl_slide wwl_zero t5 3))
          (wwl_slide wwl_zero t6 2)) =
      wwl_add
        (wwl_add
          (wwl_add
            (wwl_add (wwl_add (wwl_slide wwl_zero t3 5) (wwl_slide wwl_zero t2 6))
              (wwl_slide wwl_zero t4 4))
            (wwl_slide wwl_zero t5 3))
          (wwl_madd52lo (wwl_slide wwl_zero t1 7) x0 y))
        (wwl_slide wwl_zero t6 2) := by
    ext i hi : 1; simp [wwl_add, wwl_madd52lo]; ac_rfl
  have hh :
    wwl_add (wwl_add (wwl_slide t3 wwl_zero 5) (wwl_slide t4 wwl_zero 4))
        (wwl_add (wwl_slide t5 wwl_zero 3) (wwl_slide t6 wwl_zero 2)) =
      wwl_add
        (wwl_add (wwl_add (wwl_slide t4 wwl_zero 4) (wwl_slide t3 wwl_zero 5))
          (wwl_slide t5 wwl_zero 3))
        (wwl_slide t6 wwl_zero 2) := by
    ext i hi : 1; simp [wwl_add]; ac_rfl
  simp only [tail, hl, hh]

/-! ## The whole runs

The runs nest their `++` to the right: left-nested, matching a site's body took `step_pattern`
23 s instead of 0.5 s for `mulRun`'s 52 instructions. -/

/-- `fd_r43x6_mul_fast` then `fd_r43x6_fold_unsigned` on `x` and `y` into `r`: `x`'s lanes
broadcast, the rows, the slides, the sums, `za + 152 zb`, the fold. -/
def mulRun (x : Dst Γ V) (y : Reg Γ V)
    (p x0 x1 x2 x3 x4 x5 zr nine uh0 ph0 t1 uh1 ph1 t2 uh2 ph2 t3 uh3 ph3 t4 uh4 ph4 t5 uh5 t6 :
      Dst Γ V)
    (a1 a2 a3 b3 a4 b4 a5 b5 a6 pz p1 p2 p3 q3 p4 q4 p5 q5 p6 q6 s1 s2 s3 s4 s5 zl h1 h2 zh :
      Dst Γ V)
    (mask c7 c24 za zb b7 s7 b24 z m s k a b c r : Dst Γ V) : List (Instr Γ) :=
  [.binop (.shufflevector #v[some 0, some 0, some 0, some 0, some 0, some 0, some 0, some 0]) x0
        (.val x.i x.h) (.val p.i p.h),
      .binop (.shufflevector #v[some 1, some 1, some 1, some 1, some 1, some 1, some 1, some 1]) x1
        (.val x.i x.h) (.val p.i p.h),
      .binop (.shufflevector #v[some 2, some 2, some 2, some 2, some 2, some 2, some 2, some 2]) x2
        (.val x.i x.h) (.val p.i p.h),
      .binop (.shufflevector #v[some 3, some 3, some 3, some 3, some 3, some 3, some 3, some 3]) x3
        (.val x.i x.h) (.val p.i p.h),
      .binop (.shufflevector #v[some 4, some 4, some 4, some 4, some 4, some 4, some 4, some 4]) x4
        (.val x.i x.h) (.val p.i p.h),
      .binop (.shufflevector #v[some 5, some 5, some 5, some 5, some 5, some 5, some 5, some 5]) x5
        (.val x.i x.h) (.val p.i p.h)] ++
    (hiRun zr nine x0 y uh0 ph0 ++
      (loRun ph0 x1 y t1 ++
        (hiRun zr nine x1 y uh1 ph1 ++
          (loRun ph1 x2 y t2 ++
            (hiRun zr nine x2 y uh2 ph2 ++
              (loRun ph2 x3 y t3 ++
                (hiRun zr nine x3 y uh3 ph3 ++
                  (loRun ph3 x4 y t4 ++
                    (hiRun zr nine x4 y uh4 ph4 ++
                      (loRun ph4 x5 y t5 ++
                        (hiRun zr nine x5 y uh5 t6 ++
                          (slidesRun a1 a2 a3 b3 a4 b4 a5 b5 a6 pz t1 t2 t3 t4 t5 t6 p1 p2 p3 q3 p4
                              q4 p5 q5 p6 q6 ++
                            (loRun p1 x0 y s1 ++
                              (sumsRun s1 p2 p3 p4 p5 p6 q3 q4 q5 q6 s2 s3 s4 s5 zl h1 h2 zh ++
                                (fold152Run zl zh mask c7 c24 za zb b7 s7 b24 z ++
                                  foldRun z m s p k a b c r)))))))))))))))

/-- `mulRun`'s constants: the splats, the slides' zero operands, `za`'s mask and `7 24`, the
fold's. -/
abbrev MulConsts (E : ⟪Γ⟫) (zr nine a1 a2 a3 b3 a4 b4 a5 b5 a6 mask c7 c24 m s k : Dst Γ V) :
    Prop :=
  E ⊨ [zr := wwl_zero, nine := Vector.replicate 8 9, a1 := lanesFrom 7 wwl_zero, a2 :=
    lanesFrom 6 wwl_zero, a3 := lanesFrom 5 wwl_zero, b3 := lanesBelow 3 wwl_zero, a4 :=
    lanesFrom 4 wwl_zero, b4 := lanesBelow 2 wwl_zero, a5 := lanesFrom 3 wwl_zero, b5 :=
    lanesBelow 1 wwl_zero, a6 := lanesFrom 2 wwl_zero, mask := #v[-1, -1, -1, -1, -1, -1, 0, 0],
    c7 := Vector.replicate 8 7, c24 := Vector.replicate 8 24, m := foldMask, s := foldShifts, k :=
    foldK]

/-- Where the body at `pos` is `mulRun` on a value `y`, `x` holds `X`, `y` holds `Y` and the others
the constants: running on from `pos` then `g` gives `K` if it does from `pos + 52` with
`fd_r43x6_mul X Y` in `r`, whatever the intermediates hold. -/
theorem runBodyFrom_mulRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {x y : Dst Γ V}
    {p x0 x1 x2 x3 x4 x5 zr nine uh0 ph0 t1 uh1 ph1 t2 uh2 ph2 t3 uh3 ph3 t4 uh4 ph4 t5 uh5 t6 :
      Dst Γ V}
    {a1 a2 a3 b3 a4 b4 a5 b5 a6 pz p1 p2 p3 q3 p4 q4 p5 q5 p6 q6 s1 s2 s3 s4 s5 zl h1 h2 zh :
      Dst Γ V}
    {mask c7 c24 za zb b7 s7 b24 z m s k a b c r : Dst Γ V} {rest : List (Instr Γ)}
    {X Y : Vector (BitVec 64) 8} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        mulRun x (.val y.i y.h) p x0 x1 x2 x3 x4 x5 zr nine uh0 ph0 t1 uh1 ph1 t2 uh2 ph2 t3 uh3 ph3
            t4 uh4 ph4 t5 uh5 t6 a1 a2 a3 b3 a4 b4 a5 b5 a6 pz p1 p2 p3 q3 p4 q4 p5 q5 p6 q6 s1 s2
            s3 s4 s5 zl h1 h2 zh mask c7 c24 za zb b7 s7 b24 z m s k a b c r ++
          rest)
    (hR : E ⊨ [x := X, y := Y])
    (hC : MulConsts E zr nine a1 a2 a3 b3 a4 b4 a5 b5 a6 mask c7 c24 m s k)
    (hd :
      [x.i, y.i, x0.i, x1.i, x2.i, x3.i, x4.i, x5.i, zr.i, nine.i, uh0.i, ph0.i, t1.i, uh1.i, ph1.i,
          t2.i, uh2.i, ph2.i, t3.i, uh3.i, ph3.i, t4.i, uh4.i, ph4.i, t5.i, uh5.i, t6.i, a1.i, a2.i,
          a3.i, b3.i, a4.i, b4.i, a5.i, b5.i, a6.i, p1.i, p2.i, p3.i, q3.i, p4.i, q4.i, p5.i, q5.i,
          p6.i, q6.i, s1.i, s2.i, s3.i, s4.i, s5.i, zl.i, h1.i, h2.i, zh.i, mask.i, c7.i, c24.i,
          za.i, zb.i, b7.i, s7.i, b24.i, z.i, m.i, s.i, k.i, a.i, b.i, c.i].Nodup)
    (hd0 : [uh0.i, nine.i].Nodup) (hd1 : [uh1.i, nine.i].Nodup) (hd2 : [uh2.i, nine.i].Nodup)
    (hd3 : [uh3.i, nine.i].Nodup) (hd4 : [uh4.i, nine.i].Nodup) (hd5 : [uh5.i, nine.i].Nodup)
    (hd6 :
      [a1.i, a2.i, a3.i, b3.i, a4.i, b4.i, a5.i, b5.i, a6.i, t1.i, t2.i, t3.i, t4.i, t5.i, t6.i,
          p1.i, p2.i, p3.i, q3.i, p4.i, q4.i, p5.i, q5.i, p6.i].Nodup)
    (hd7 :
      [s1.i, p2.i, p3.i, p4.i, p5.i, p6.i, q3.i, q4.i, q5.i, q6.i, s2.i, s3.i, s4.i, s5.i, zl.i,
          h1.i, h2.i].Nodup)
    (hd8 : [zl.i, zh.i, mask.i, c7.i, c24.i, za.i, zb.i, b7.i, s7.i, b24.i].Nodup)
    (hd9 : [z.i, s.i, k.i, a.i, b.i, c.i].Nodup)
    (hK :
      ∀ vx0 vx1 vx2 vx3 vx4 vx5 vuh0 vph0 vt1 vuh1 vph1 vt2 vuh2 vph2 vt3 vuh3 vph3 vt4 vuh4 vph4
        vt5 vuh5 vt6 : ⟦V⟧,
        ∀ vp1 vp2 vp3 vq3 vp4 vq4 vp5 vq5 vp6 vq6 vs1 vs2 vs3 vs4 vs5 vzl vh1 vh2 vzh : ⟦V⟧,
          ∀ vza vzb vb7 vs7 vb24 vz va vb vc : ⟦V⟧,
            (blk.runBodyFrom
                  E[x0 := vx0, x1 := vx1, x2 := vx2, x3 := vx3, x4 := vx4, x5 := vx5, uh0 := vuh0,
                    ph0 := vph0, t1 := vt1, uh1 := vuh1, ph1 := vph1, t2 := vt2, uh2 := vuh2, ph2 :=
                    vph2, t3 := vt3, uh3 := vuh3, ph3 := vph3, t4 := vt4, uh4 := vuh4, ph4 := vph4,
                    t5 := vt5, uh5 := vuh5, t6 := vt6, p1 := vp1, p2 := vp2, p3 := vp3, q3 := vq3,
                    p4 := vp4, q4 := vq4, p5 := vp5, q5 := vq5, p6 := vp6, q6 := vq6, s1 := vs1,
                    s2 := vs2, s3 := vs3, s4 := vs4, s5 := vs5, zl := vzl, h1 := vh1, h2 := vh2,
                    zh := vzh, za := vza, zb := vzb, b7 := vb7, s7 := vs7, b24 := vb24, z := vz,
                    a := va, b := vb, c := vc, r := Ty.wrap (fd_r43x6_mul X Y)]
                  (pos + 52) S >>=
                g) =
              K) :
    (blk.runBodyFrom E pos S >>= g) = K := by mul_run_steps

/-- `runBodyFrom_mulRun` with `y` an argument. -/
theorem runBodyFrom_mulRunA {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {x : Dst Γ V}
    {ya : Fin Γ.args.length} {hya : Γ.args[ya] = V}
    {p x0 x1 x2 x3 x4 x5 zr nine uh0 ph0 t1 uh1 ph1 t2 uh2 ph2 t3 uh3 ph3 t4 uh4 ph4 t5 uh5 t6 :
      Dst Γ V}
    {a1 a2 a3 b3 a4 b4 a5 b5 a6 pz p1 p2 p3 q3 p4 q4 p5 q5 p6 q6 s1 s2 s3 s4 s5 zl h1 h2 zh :
      Dst Γ V}
    {mask c7 c24 za zb b7 s7 b24 z m s k a b c r : Dst Γ V} {rest : List (Instr Γ)}
    {X Y : Vector (BitVec 64) 8} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        mulRun x (.arg ya hya) p x0 x1 x2 x3 x4 x5 zr nine uh0 ph0 t1 uh1 ph1 t2 uh2 ph2 t3 uh3 ph3
            t4 uh4 ph4 t5 uh5 t6 a1 a2 a3 b3 a4 b4 a5 b5 a6 pz p1 p2 p3 q3 p4 q4 p5 q5 p6 q6 s1 s2
            s3 s4 s5 zl h1 h2 zh mask c7 c24 za zb b7 s7 b24 z m s k a b c r ++
          rest)
    (hR : E ⊨ [x := X]) (hy : E.read (.arg ya hya) = Ty.wrap Y)
    (hC : MulConsts E zr nine a1 a2 a3 b3 a4 b4 a5 b5 a6 mask c7 c24 m s k)
    (hd :
      [x.i, x0.i, x1.i, x2.i, x3.i, x4.i, x5.i, zr.i, nine.i, uh0.i, ph0.i, t1.i, uh1.i, ph1.i,
          t2.i, uh2.i, ph2.i, t3.i, uh3.i, ph3.i, t4.i, uh4.i, ph4.i, t5.i, uh5.i, t6.i, a1.i, a2.i,
          a3.i, b3.i, a4.i, b4.i, a5.i, b5.i, a6.i, p1.i, p2.i, p3.i, q3.i, p4.i, q4.i, p5.i, q5.i,
          p6.i, q6.i, s1.i, s2.i, s3.i, s4.i, s5.i, zl.i, h1.i, h2.i, zh.i, mask.i, c7.i, c24.i,
          za.i, zb.i, b7.i, s7.i, b24.i, z.i, m.i, s.i, k.i, a.i, b.i, c.i].Nodup)
    (hd0 : [uh0.i, nine.i].Nodup) (hd1 : [uh1.i, nine.i].Nodup) (hd2 : [uh2.i, nine.i].Nodup)
    (hd3 : [uh3.i, nine.i].Nodup) (hd4 : [uh4.i, nine.i].Nodup) (hd5 : [uh5.i, nine.i].Nodup)
    (hd6 :
      [a1.i, a2.i, a3.i, b3.i, a4.i, b4.i, a5.i, b5.i, a6.i, t1.i, t2.i, t3.i, t4.i, t5.i, t6.i,
          p1.i, p2.i, p3.i, q3.i, p4.i, q4.i, p5.i, q5.i, p6.i].Nodup)
    (hd7 :
      [s1.i, p2.i, p3.i, p4.i, p5.i, p6.i, q3.i, q4.i, q5.i, q6.i, s2.i, s3.i, s4.i, s5.i, zl.i,
          h1.i, h2.i].Nodup)
    (hd8 : [zl.i, zh.i, mask.i, c7.i, c24.i, za.i, zb.i, b7.i, s7.i, b24.i].Nodup)
    (hd9 : [z.i, s.i, k.i, a.i, b.i, c.i].Nodup)
    (hK :
      ∀ vx0 vx1 vx2 vx3 vx4 vx5 vuh0 vph0 vt1 vuh1 vph1 vt2 vuh2 vph2 vt3 vuh3 vph3 vt4 vuh4 vph4
        vt5 vuh5 vt6 : ⟦V⟧,
        ∀ vp1 vp2 vp3 vq3 vp4 vq4 vp5 vq5 vp6 vq6 vs1 vs2 vs3 vs4 vs5 vzl vh1 vh2 vzh : ⟦V⟧,
          ∀ vza vzb vb7 vs7 vb24 vz va vb vc : ⟦V⟧,
            (blk.runBodyFrom
                  E[x0 := vx0, x1 := vx1, x2 := vx2, x3 := vx3, x4 := vx4, x5 := vx5, uh0 := vuh0,
                    ph0 := vph0, t1 := vt1, uh1 := vuh1, ph1 := vph1, t2 := vt2, uh2 := vuh2, ph2 :=
                    vph2, t3 := vt3, uh3 := vuh3, ph3 := vph3, t4 := vt4, uh4 := vuh4, ph4 := vph4,
                    t5 := vt5, uh5 := vuh5, t6 := vt6, p1 := vp1, p2 := vp2, p3 := vp3, q3 := vq3,
                    p4 := vp4, q4 := vq4, p5 := vp5, q5 := vq5, p6 := vp6, q6 := vq6, s1 := vs1,
                    s2 := vs2, s3 := vs3, s4 := vs4, s5 := vs5, zl := vzl, h1 := vh1, h2 := vh2,
                    zh := vzh, za := vza, zb := vzb, b7 := vb7, s7 := vs7, b24 := vb24, z := vz,
                    a := va, b := vb, c := vc, r := Ty.wrap (fd_r43x6_mul X Y)]
                  (pos + 52) S >>=
                g) =
              K) :
    (blk.runBodyFrom E pos S >>= g) = K := by mul_run_steps

/-- `mulRun` past the broadcasts: `x`'s lanes already broadcast in `x0 … x5` (a constant `x`'s
splats, or an earlier `mulRun`'s broadcasts of the same `x`). -/
def mulRowsRun (y : Reg Γ V)
    (p x0 x1 x2 x3 x4 x5 zr nine uh0 ph0 t1 uh1 ph1 t2 uh2 ph2 t3 uh3 ph3 t4 uh4 ph4 t5 uh5 t6 :
      Dst Γ V)
    (a1 a2 a3 b3 a4 b4 a5 b5 a6 pz p1 p2 p3 q3 p4 q4 p5 q5 p6 q6 s1 s2 s3 s4 s5 zl h1 h2 zh :
      Dst Γ V)
    (mask c7 c24 za zb b7 s7 b24 z m s k a b c r : Dst Γ V) : List (Instr Γ) :=
  hiRun zr nine x0 y uh0 ph0 ++
    (loRun ph0 x1 y t1 ++
      (hiRun zr nine x1 y uh1 ph1 ++
        (loRun ph1 x2 y t2 ++
          (hiRun zr nine x2 y uh2 ph2 ++
            (loRun ph2 x3 y t3 ++
              (hiRun zr nine x3 y uh3 ph3 ++
                (loRun ph3 x4 y t4 ++
                  (hiRun zr nine x4 y uh4 ph4 ++
                    (loRun ph4 x5 y t5 ++
                      (hiRun zr nine x5 y uh5 t6 ++
                        (slidesRun a1 a2 a3 b3 a4 b4 a5 b5 a6 pz t1 t2 t3 t4 t5 t6 p1 p2 p3 q3 p4 q4
                            p5 q5 p6 q6 ++
                          (loRun p1 x0 y s1 ++
                            (sumsRun s1 p2 p3 p4 p5 p6 q3 q4 q5 q6 s2 s3 s4 s5 zl h1 h2 zh ++
                              (fold152Run zl zh mask c7 c24 za zb b7 s7 b24 z ++
                                foldRun z m s p k a b c r))))))))))))))

/-- Where the body at `pos` is `mulRowsRun` on a value `y` holding `Y`, `x0 … x5` hold `X`'s lanes
`0 … 5` broadcast and the others the constants: running on from `pos` then `g` gives `K` if it does
from `pos + 46` with `fd_r43x6_mul X Y` in `r`, whatever the intermediates hold. -/
theorem runBodyFrom_mulRowsRun (X : Wwl) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {y : Dst Γ V}
    {p x0 x1 x2 x3 x4 x5 zr nine uh0 ph0 t1 uh1 ph1 t2 uh2 ph2 t3 uh3 ph3 t4 uh4 ph4 t5 uh5 t6 :
      Dst Γ V}
    {a1 a2 a3 b3 a4 b4 a5 b5 a6 pz p1 p2 p3 q3 p4 q4 p5 q5 p6 q6 s1 s2 s3 s4 s5 zl h1 h2 zh :
      Dst Γ V}
    {mask c7 c24 za zb b7 s7 b24 z m s k a b c r : Dst Γ V} {rest : List (Instr Γ)}
    {Y : Vector (BitVec 64) 8} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        mulRowsRun (.val y.i y.h) p x0 x1 x2 x3 x4 x5 zr nine uh0 ph0 t1 uh1 ph1 t2 uh2 ph2 t3 uh3
            ph3 t4 uh4 ph4 t5 uh5 t6 a1 a2 a3 b3 a4 b4 a5 b5 a6 pz p1 p2 p3 q3 p4 q4 p5 q5 p6 q6 s1
            s2 s3 s4 s5 zl h1 h2 zh mask c7 c24 za zb b7 s7 b24 z m s k a b c r ++
          rest)
    (hR :
      E ⊨ [y := Y, x0 := Vector.replicate 8 X[0], x1 := Vector.replicate 8 X[1], x2 :=
        Vector.replicate 8 X[2], x3 := Vector.replicate 8 X[3], x4 := Vector.replicate 8 X[4], x5 :=
        Vector.replicate 8 X[5]])
    (hC : MulConsts E zr nine a1 a2 a3 b3 a4 b4 a5 b5 a6 mask c7 c24 m s k)
    (hd :
      [y.i, x0.i, x1.i, x2.i, x3.i, x4.i, x5.i, zr.i, nine.i, uh0.i, ph0.i, t1.i, uh1.i, ph1.i,
          t2.i, uh2.i, ph2.i, t3.i, uh3.i, ph3.i, t4.i, uh4.i, ph4.i, t5.i, uh5.i, t6.i, a1.i, a2.i,
          a3.i, b3.i, a4.i, b4.i, a5.i, b5.i, a6.i, p1.i, p2.i, p3.i, q3.i, p4.i, q4.i, p5.i, q5.i,
          p6.i, q6.i, s1.i, s2.i, s3.i, s4.i, s5.i, zl.i, h1.i, h2.i, zh.i, mask.i, c7.i, c24.i,
          za.i, zb.i, b7.i, s7.i, b24.i, z.i, m.i, s.i, k.i, a.i, b.i, c.i].Nodup)
    (hd0 : [uh0.i, nine.i].Nodup) (hd1 : [uh1.i, nine.i].Nodup) (hd2 : [uh2.i, nine.i].Nodup)
    (hd3 : [uh3.i, nine.i].Nodup) (hd4 : [uh4.i, nine.i].Nodup) (hd5 : [uh5.i, nine.i].Nodup)
    (hd6 :
      [a1.i, a2.i, a3.i, b3.i, a4.i, b4.i, a5.i, b5.i, a6.i, t1.i, t2.i, t3.i, t4.i, t5.i, t6.i,
          p1.i, p2.i, p3.i, q3.i, p4.i, q4.i, p5.i, q5.i, p6.i].Nodup)
    (hd7 :
      [s1.i, p2.i, p3.i, p4.i, p5.i, p6.i, q3.i, q4.i, q5.i, q6.i, s2.i, s3.i, s4.i, s5.i, zl.i,
          h1.i, h2.i].Nodup)
    (hd8 : [zl.i, zh.i, mask.i, c7.i, c24.i, za.i, zb.i, b7.i, s7.i, b24.i].Nodup)
    (hd9 : [z.i, s.i, k.i, a.i, b.i, c.i].Nodup)
    (hK :
      ∀ vuh0 vph0 vt1 vuh1 vph1 vt2 vuh2 vph2 vt3 vuh3 vph3 vt4 vuh4 vph4 vt5 vuh5 vt6 : ⟦V⟧,
        ∀ vp1 vp2 vp3 vq3 vp4 vq4 vp5 vq5 vp6 vq6 vs1 vs2 vs3 vs4 vs5 vzl vh1 vh2 vzh : ⟦V⟧,
          ∀ vza vzb vb7 vs7 vb24 vz va vb vc : ⟦V⟧,
            (blk.runBodyFrom
                  E[uh0 := vuh0, ph0 := vph0, t1 := vt1, uh1 := vuh1, ph1 := vph1, t2 := vt2, uh2 :=
                    vuh2, ph2 := vph2, t3 := vt3, uh3 := vuh3, ph3 := vph3, t4 := vt4, uh4 := vuh4,
                    ph4 := vph4, t5 := vt5, uh5 := vuh5, t6 := vt6, p1 := vp1, p2 := vp2, p3 := vp3,
                    q3 := vq3, p4 := vp4, q4 := vq4, p5 := vp5, q5 := vq5, p6 := vp6, q6 := vq6,
                    s1 := vs1, s2 := vs2, s3 := vs3, s4 := vs4, s5 := vs5, zl := vzl, h1 := vh1,
                    h2 := vh2, zh := vzh, za := vza, zb := vzb, b7 := vb7, s7 := vs7, b24 := vb24,
                    z := vz, a := va, b := vb, c := vc, r := Ty.wrap (fd_r43x6_mul X Y)]
                  (pos + 46) S >>=
                g) =
              K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  simp only [mulRowsRun] at hbody
  step_pattern using runBodyFrom_hiRun
  step_pattern using runBodyFrom_loRun
  step_pattern using runBodyFrom_hiRun
  step_pattern using runBodyFrom_loRun
  step_pattern using runBodyFrom_hiRun
  step_pattern using runBodyFrom_loRun
  step_pattern using runBodyFrom_hiRun
  step_pattern using runBodyFrom_loRun
  step_pattern using runBodyFrom_hiRun
  step_pattern using runBodyFrom_loRun
  step_pattern using runBodyFrom_hiRun
  step_pattern using runBodyFrom_slidesRun with vq6
  subst hvq6
  step_pattern using runBodyFrom_loRun
  step_pattern using runBodyFrom_sumsRun with vzh
  subst hvzh
  step_pattern using runBodyFrom_fold152Run with vz
  step_pattern using runBodyFrom_foldRun with vr
  have e : vr = fd_r43x6_mul X Y := by
    rw [hvr, hvz, fd_r43x6_mul, fd_r43x6_mul_fast.spec, tail_eq]
  rw [hE, hS, e]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

/-- `fd_r43x6_sqr_fast` then `fd_r43x6_fold_unsigned` on `x` into `r`: the permutes, the products,
the sums, `za + 152 zb`, the fold. -/
def sqrRun (x : Reg Γ V)
    (p x0 x1 x2 x3 x4 x5 s0 s2 s4 d0 d2 d4 zero nine p1l p2l t0 p0h t1 p1h t2 p2h : Dst Γ V)
    (mn1 mn2 m1l m2l m1h m2h pz zp l1 l2 ls zll h1 h2 zlh0 zlh k1 k2 j1 j2 zhh zlhs zl zhhs zlht zhl
      zh0 zh : Dst Γ V)
    (mask c7 c24 za zb b7 s7 b24 z m s k a b c r : Dst Γ V) : List (Instr Γ) :=
  sqrPermRun x p x0 x1 x2 x3 x4 x5 s0 s2 s4 d0 d2 d4 ++
    (sqrProdRun d0 x1 d2 x3 d4 x5 zero nine p1l p2l t0 p0h t1 p1h t2 p2h ++
      (sqrSumsRun d0 x1 p1l p2l p0h p1h p2h mn1 mn2 m1l m2l m1h m2h pz zp l1 l2 ls zll h1 h2 zlh0
          zlh k1 k2 j1 j2 zhh zlhs zl zhhs zlht zhl zh0 zh ++
        (fold152Run zl zh mask c7 c24 za zb b7 s7 b24 z ++ foldRun z m s p k a b c r)))

/-- `sqrRun`'s constants: the doublings' shifts, the splats, the masks and their complements, the
slides' zero operands, `za`'s mask and `7 24`, the fold's. -/
abbrev SqrConsts (E : ⟪Γ⟫)
    (s0 s2 s4 zero nine mn1 mn2 m1l m2l m1h m2h pz zp mask c7 c24 m s k : Dst Γ V) : Prop :=
  E ⊨ [s0 := sqrDbl0, s2 := sqrDbl2, s4 := sqrDbl4, zero := Vector.replicate 8 0, nine :=
    Vector.replicate 8 9, mn1 := sqrMaskN1, mn2 := sqrMaskN2, m1l := lanesBelow 6 sqrMask1, m2l :=
    lanesBelow 6 sqrMask2, m1h := lanesBelow 5 sqrMask1, m2h := lanesBelow 5 sqrMask2, pz :=
    lanesFrom 7 wwl_zero, zp := lanesBelow 5 wwl_zero, mask := #v[-1, -1, -1, -1, -1, -1, 0, 0],
    c7 := Vector.replicate 8 7, c24 := Vector.replicate 8 24, m := foldMask, s := foldShifts, k :=
    foldK]

/-- Where the body at `pos` is `sqrRun`, `x` holds `X` and the others the constants: running on from
`pos` then `g` gives `K` if it does from `pos + 47` with `fd_r43x6_sqr X` in `r`, whatever the
intermediates hold. -/
theorem runBodyFrom_sqrRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x p x0 x1 x2 x3 x4 x5 s0 s2 s4 d0 d2 d4 zero nine p1l p2l t0 p0h t1 p1h t2 p2h : Dst Γ V}
    {mn1 mn2 m1l m2l m1h m2h pz zp l1 l2 ls zll h1 h2 zlh0 zlh k1 k2 j1 j2 zhh zlhs zl zhhs zlht zhl
      zh0 zh : Dst Γ V}
    {mask c7 c24 za zb b7 s7 b24 z m s k a b c r : Dst Γ V} {rest : List (Instr Γ)}
    {X : Vector (BitVec 64) 8} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        sqrRun (.val x.i x.h) p x0 x1 x2 x3 x4 x5 s0 s2 s4 d0 d2 d4 zero nine p1l p2l t0 p0h t1 p1h
            t2 p2h mn1 mn2 m1l m2l m1h m2h pz zp l1 l2 ls zll h1 h2 zlh0 zlh k1 k2 j1 j2 zhh zlhs zl
            zhhs zlht zhl zh0 zh mask c7 c24 za zb b7 s7 b24 z m s k a b c r ++
          rest)
    (hx : E.read (.val x.i x.h) = Ty.wrap X)
    (hC : SqrConsts E s0 s2 s4 zero nine mn1 mn2 m1l m2l m1h m2h pz zp mask c7 c24 m s k)
    (hd :
      [x.i, x0.i, x1.i, x2.i, x3.i, x4.i, x5.i, s0.i, s2.i, s4.i, d0.i, d2.i, d4.i, zero.i, nine.i,
          p1l.i, p2l.i, t0.i, p0h.i, t1.i, p1h.i, t2.i, p2h.i, mn1.i, mn2.i, m1l.i, m2l.i, m1h.i,
          m2h.i, pz.i, zp.i, l1.i, l2.i, ls.i, zll.i, h1.i, h2.i, zlh0.i, zlh.i, k1.i, k2.i, j1.i,
          j2.i, zhh.i, zlhs.i, zl.i, zhhs.i, zlht.i, zhl.i, zh0.i, zh.i, mask.i, c7.i, c24.i, za.i,
          zb.i, b7.i, s7.i, b24.i, z.i, m.i, s.i, k.i, a.i, b.i, c.i].Nodup)
    (hd1 : [x.i, x0.i, x1.i, x2.i, x3.i, x4.i, x5.i, s0.i, s2.i, s4.i, d0.i, d2.i, d4.i].Nodup)
    (hd2 :
      [d0.i, x1.i, d2.i, x3.i, d4.i, x5.i, zero.i, nine.i, p1l.i, p2l.i, t0.i, p0h.i, t1.i, p1h.i,
          t2.i].Nodup)
    (hd3 :
      [d0.i, x1.i, p1l.i, p2l.i, p0h.i, p1h.i, p2h.i, mn1.i, mn2.i, m1l.i, m2l.i, m1h.i, m2h.i,
          pz.i, zp.i, l1.i, l2.i, ls.i, zll.i, h1.i, h2.i, zlh0.i, zlh.i, k1.i, k2.i, j1.i, j2.i,
          zhh.i, zlhs.i, zl.i, zhhs.i, zlht.i, zhl.i, zh0.i].Nodup)
    (hd4 : [zl.i, zh.i, mask.i, c7.i, c24.i, za.i, zb.i, b7.i, s7.i, b24.i].Nodup)
    (hd5 : [z.i, s.i, k.i, a.i, b.i, c.i].Nodup)
    (hK :
      ∀ vx0 vx1 vx2 vx3 vx4 vx5 vd0 vd2 vd4 vp1l vp2l vt0 vp0h vt1 vp1h vt2 vp2h : ⟦V⟧,
        ∀ vl1 vl2 vls vzll vh1 vh2 vzlh0 vzlh vk1 vk2 vj1 vj2 vzhh vzlhs vzl vzhhs vzlht vzhl vzh0
          vzh : ⟦V⟧,
          ∀ vza vzb vb7 vs7 vb24 vz va vb vc : ⟦V⟧,
            (blk.runBodyFrom
                  E[x0 := vx0, x1 := vx1, x2 := vx2, x3 := vx3, x4 := vx4, x5 := vx5, d0 := vd0,
                    d2 := vd2, d4 := vd4, p1l := vp1l, p2l := vp2l, t0 := vt0, p0h := vp0h, t1 :=
                    vt1, p1h := vp1h, t2 := vt2, p2h := vp2h, l1 := vl1, l2 := vl2, ls := vls,
                    zll := vzll, h1 := vh1, h2 := vh2, zlh0 := vzlh0, zlh := vzlh, k1 := vk1, k2 :=
                    vk2, j1 := vj1, j2 := vj2, zhh := vzhh, zlhs := vzlhs, zl := vzl, zhhs := vzhhs,
                    zlht := vzlht, zhl := vzhl, zh0 := vzh0, zh := vzh, za := vza, zb := vzb, b7 :=
                    vb7, s7 := vs7, b24 := vb24, z := vz, a := va, b := vb, c := vc, r :=
                    Ty.wrap (fd_r43x6_sqr X)]
                  (pos + 47) S >>=
                g) =
              K) :
    (blk.runBodyFrom E pos S >>= g) = K := by sqr_run_steps runBodyFrom_sqrPermRun

/-- `runBodyFrom_sqrRun` with `x` an argument. -/
theorem runBodyFrom_sqrRunA {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {xa : Fin Γ.args.length} {hxa : Γ.args[xa] = V}
    {p x0 x1 x2 x3 x4 x5 s0 s2 s4 d0 d2 d4 zero nine p1l p2l t0 p0h t1 p1h t2 p2h : Dst Γ V}
    {mn1 mn2 m1l m2l m1h m2h pz zp l1 l2 ls zll h1 h2 zlh0 zlh k1 k2 j1 j2 zhh zlhs zl zhhs zlht zhl
      zh0 zh : Dst Γ V}
    {mask c7 c24 za zb b7 s7 b24 z m s k a b c r : Dst Γ V} {rest : List (Instr Γ)}
    {X : Vector (BitVec 64) 8} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        sqrRun (.arg xa hxa) p x0 x1 x2 x3 x4 x5 s0 s2 s4 d0 d2 d4 zero nine p1l p2l t0 p0h t1 p1h
            t2 p2h mn1 mn2 m1l m2l m1h m2h pz zp l1 l2 ls zll h1 h2 zlh0 zlh k1 k2 j1 j2 zhh zlhs zl
            zhhs zlht zhl zh0 zh mask c7 c24 za zb b7 s7 b24 z m s k a b c r ++
          rest)
    (hx : E.read (.arg xa hxa) = Ty.wrap X)
    (hC : SqrConsts E s0 s2 s4 zero nine mn1 mn2 m1l m2l m1h m2h pz zp mask c7 c24 m s k)
    (hd :
      [x0.i, x1.i, x2.i, x3.i, x4.i, x5.i, s0.i, s2.i, s4.i, d0.i, d2.i, d4.i, zero.i, nine.i,
          p1l.i, p2l.i, t0.i, p0h.i, t1.i, p1h.i, t2.i, p2h.i, mn1.i, mn2.i, m1l.i, m2l.i, m1h.i,
          m2h.i, pz.i, zp.i, l1.i, l2.i, ls.i, zll.i, h1.i, h2.i, zlh0.i, zlh.i, k1.i, k2.i, j1.i,
          j2.i, zhh.i, zlhs.i, zl.i, zhhs.i, zlht.i, zhl.i, zh0.i, zh.i, mask.i, c7.i, c24.i, za.i,
          zb.i, b7.i, s7.i, b24.i, z.i, m.i, s.i, k.i, a.i, b.i, c.i].Nodup)
    (hd1 : [x0.i, x1.i, x2.i, x3.i, x4.i, x5.i, s0.i, s2.i, s4.i, d0.i, d2.i, d4.i].Nodup)
    (hd2 :
      [d0.i, x1.i, d2.i, x3.i, d4.i, x5.i, zero.i, nine.i, p1l.i, p2l.i, t0.i, p0h.i, t1.i, p1h.i,
          t2.i].Nodup)
    (hd3 :
      [d0.i, x1.i, p1l.i, p2l.i, p0h.i, p1h.i, p2h.i, mn1.i, mn2.i, m1l.i, m2l.i, m1h.i, m2h.i,
          pz.i, zp.i, l1.i, l2.i, ls.i, zll.i, h1.i, h2.i, zlh0.i, zlh.i, k1.i, k2.i, j1.i, j2.i,
          zhh.i, zlhs.i, zl.i, zhhs.i, zlht.i, zhl.i, zh0.i].Nodup)
    (hd4 : [zl.i, zh.i, mask.i, c7.i, c24.i, za.i, zb.i, b7.i, s7.i, b24.i].Nodup)
    (hd5 : [z.i, s.i, k.i, a.i, b.i, c.i].Nodup)
    (hK :
      ∀ vx0 vx1 vx2 vx3 vx4 vx5 vd0 vd2 vd4 vp1l vp2l vt0 vp0h vt1 vp1h vt2 vp2h : ⟦V⟧,
        ∀ vl1 vl2 vls vzll vh1 vh2 vzlh0 vzlh vk1 vk2 vj1 vj2 vzhh vzlhs vzl vzhhs vzlht vzhl vzh0
          vzh : ⟦V⟧,
          ∀ vza vzb vb7 vs7 vb24 vz va vb vc : ⟦V⟧,
            (blk.runBodyFrom
                  E[x0 := vx0, x1 := vx1, x2 := vx2, x3 := vx3, x4 := vx4, x5 := vx5, d0 := vd0,
                    d2 := vd2, d4 := vd4, p1l := vp1l, p2l := vp2l, t0 := vt0, p0h := vp0h, t1 :=
                    vt1, p1h := vp1h, t2 := vt2, p2h := vp2h, l1 := vl1, l2 := vl2, ls := vls,
                    zll := vzll, h1 := vh1, h2 := vh2, zlh0 := vzlh0, zlh := vzlh, k1 := vk1, k2 :=
                    vk2, j1 := vj1, j2 := vj2, zhh := vzhh, zlhs := vzlhs, zl := vzl, zhhs := vzhhs,
                    zlht := vzlht, zhl := vzhl, zh0 := vzh0, zh := vzh, za := vza, zb := vzb, b7 :=
                    vb7, s7 := vs7, b24 := vb24, z := vz, a := va, b := vb, c := vc, r :=
                    Ty.wrap (fd_r43x6_sqr X)]
                  (pos + 47) S >>=
                g) =
              K) :
    (blk.runBodyFrom E pos S >>= g) = K := by sqr_run_steps runBodyFrom_sqrPermRunA

/-- `sqrRun` with `sqrPermRunNW`'s flagged doublings. -/
def sqrRunNW (x : Reg Γ V)
    (p x0 x1 x2 x3 x4 x5 s0 s2 s4 d0 d2 d4 zero nine p1l p2l t0 p0h t1 p1h t2 p2h : Dst Γ V)
    (mn1 mn2 m1l m2l m1h m2h pz zp l1 l2 ls zll h1 h2 zlh0 zlh k1 k2 j1 j2 zhh zlhs zl zhhs zlht zhl
      zh0 zh : Dst Γ V)
    (mask c7 c24 za zb b7 s7 b24 z m s k a b c r : Dst Γ V) : List (Instr Γ) :=
  sqrPermRunNW x p x0 x1 x2 x3 x4 x5 s0 s2 s4 d0 d2 d4 ++
    (sqrProdRun d0 x1 d2 x3 d4 x5 zero nine p1l p2l t0 p0h t1 p1h t2 p2h ++
      (sqrSumsRun d0 x1 p1l p2l p0h p1h p2h mn1 mn2 m1l m2l m1h m2h pz zp l1 l2 ls zll h1 h2 zlh0
          zlh k1 k2 j1 j2 zhh zlhs zl zhhs zlht zhl zh0 zh ++
        (fold152Run zl zh mask c7 c24 za zb b7 s7 b24 z ++ foldRun z m s p k a b c r)))

/-- `runBodyFrom_sqrRun` for `sqrRunNW`, `X`'s lanes below `2^43`. -/
theorem runBodyFrom_sqrRunNW {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x p x0 x1 x2 x3 x4 x5 s0 s2 s4 d0 d2 d4 zero nine p1l p2l t0 p0h t1 p1h t2 p2h : Dst Γ V}
    {mn1 mn2 m1l m2l m1h m2h pz zp l1 l2 ls zll h1 h2 zlh0 zlh k1 k2 j1 j2 zhh zlhs zl zhhs zlht zhl
      zh0 zh : Dst Γ V}
    {mask c7 c24 za zb b7 s7 b24 z m s k a b c r : Dst Γ V} {rest : List (Instr Γ)}
    {X : Vector (BitVec 64) 8} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        sqrRunNW (.val x.i x.h) p x0 x1 x2 x3 x4 x5 s0 s2 s4 d0 d2 d4 zero nine p1l p2l t0 p0h t1 p1h
            t2 p2h mn1 mn2 m1l m2l m1h m2h pz zp l1 l2 ls zll h1 h2 zlh0 zlh k1 k2 j1 j2 zhh zlhs zl
            zhhs zlht zhl zh0 zh mask c7 c24 za zb b7 s7 b24 z m s k a b c r ++
          rest)
    (hx : E.read (.val x.i x.h) = Ty.wrap X) (hX : ∀ i (h : i < 8), X[i] < 0x80000000000#64)
    (hC : SqrConsts E s0 s2 s4 zero nine mn1 mn2 m1l m2l m1h m2h pz zp mask c7 c24 m s k)
    (hd :
      [x.i, x0.i, x1.i, x2.i, x3.i, x4.i, x5.i, s0.i, s2.i, s4.i, d0.i, d2.i, d4.i, zero.i, nine.i,
          p1l.i, p2l.i, t0.i, p0h.i, t1.i, p1h.i, t2.i, p2h.i, mn1.i, mn2.i, m1l.i, m2l.i, m1h.i,
          m2h.i, pz.i, zp.i, l1.i, l2.i, ls.i, zll.i, h1.i, h2.i, zlh0.i, zlh.i, k1.i, k2.i, j1.i,
          j2.i, zhh.i, zlhs.i, zl.i, zhhs.i, zlht.i, zhl.i, zh0.i, zh.i, mask.i, c7.i, c24.i, za.i,
          zb.i, b7.i, s7.i, b24.i, z.i, m.i, s.i, k.i, a.i, b.i, c.i].Nodup)
    (hd1 : [x.i, x0.i, x1.i, x2.i, x3.i, x4.i, x5.i, s0.i, s2.i, s4.i, d0.i, d2.i, d4.i].Nodup)
    (hd2 :
      [d0.i, x1.i, d2.i, x3.i, d4.i, x5.i, zero.i, nine.i, p1l.i, p2l.i, t0.i, p0h.i, t1.i, p1h.i,
          t2.i].Nodup)
    (hd3 :
      [d0.i, x1.i, p1l.i, p2l.i, p0h.i, p1h.i, p2h.i, mn1.i, mn2.i, m1l.i, m2l.i, m1h.i, m2h.i,
          pz.i, zp.i, l1.i, l2.i, ls.i, zll.i, h1.i, h2.i, zlh0.i, zlh.i, k1.i, k2.i, j1.i, j2.i,
          zhh.i, zlhs.i, zl.i, zhhs.i, zlht.i, zhl.i, zh0.i].Nodup)
    (hd4 : [zl.i, zh.i, mask.i, c7.i, c24.i, za.i, zb.i, b7.i, s7.i, b24.i].Nodup)
    (hd5 : [z.i, s.i, k.i, a.i, b.i, c.i].Nodup)
    (hK :
      ∀ vx0 vx1 vx2 vx3 vx4 vx5 vd0 vd2 vd4 vp1l vp2l vt0 vp0h vt1 vp1h vt2 vp2h : ⟦V⟧,
        ∀ vl1 vl2 vls vzll vh1 vh2 vzlh0 vzlh vk1 vk2 vj1 vj2 vzhh vzlhs vzl vzhhs vzlht vzhl vzh0
          vzh : ⟦V⟧,
          ∀ vza vzb vb7 vs7 vb24 vz va vb vc : ⟦V⟧,
            (blk.runBodyFrom
                  E[x0 := vx0, x1 := vx1, x2 := vx2, x3 := vx3, x4 := vx4, x5 := vx5, d0 := vd0,
                    d2 := vd2, d4 := vd4, p1l := vp1l, p2l := vp2l, t0 := vt0, p0h := vp0h, t1 :=
                    vt1, p1h := vp1h, t2 := vt2, p2h := vp2h, l1 := vl1, l2 := vl2, ls := vls,
                    zll := vzll, h1 := vh1, h2 := vh2, zlh0 := vzlh0, zlh := vzlh, k1 := vk1, k2 :=
                    vk2, j1 := vj1, j2 := vj2, zhh := vzhh, zlhs := vzlhs, zl := vzl, zhhs := vzhhs,
                    zlht := vzlht, zhl := vzhl, zh0 := vzh0, zh := vzh, za := vza, zb := vzb, b7 :=
                    vb7, s7 := vs7, b24 := vb24, z := vz, a := va, b := vb, c := vc, r :=
                    Ty.wrap (fd_r43x6_sqr X)]
                  (pos + 47) S >>=
                g) =
              K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  simp only [sqrRunNW] at hbody
  step_pattern using runBodyFrom_sqrPermRunNW (hX := hX) with vd4
  step_pattern using runBodyFrom_sqrProdRun with vp2h
  step_pattern using runBodyFrom_sqrSumsRun with vzh
  subst hvzh
  step_pattern using runBodyFrom_fold152Run with vz
  step_pattern using runBodyFrom_foldRun with vr
  have e : vr = fd_r43x6_sqr X := by
    rw [hvr, hvz, hvp2h, hvd4, fd_r43x6_sqr, fd_r43x6_sqr_fast.spec_eq]
    rfl
  rw [hE, hS, e]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    _


end

end MLIR.Firedancer.Lane
