module

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Run.BasicBlock
public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Avx512.Common.FoldUnsigned

/-! `fd_r43x6_extract_limbs(x, y)`: lanes `0 … 5` of `x` into the longs `y0 … y5`. -/

namespace LeanMLIR.RIR.Firedancer.Avx512

@[expose] public section

/-- Six longs `y0 … y5`, the limbs of an `fd_r43x6_t`. -/
structure Limbs where
  y0 : BitVec 64
  y1 : BitVec 64
  y2 : BitVec 64
  y3 : BitVec 64
  y4 : BitVec 64
  y5 : BitVec 64

/-- `fd_r43x6_extract_limbs(x, y)`. -/
def extractLimbs (x : Vector (BitVec 64) 8) : Limbs :=
  ⟨x[0], x[1], x[2], x[3], x[4], x[5]⟩

/-- `fd_r43x6_extract_limbs` as six `extractelement`s: lane `k` of the argument `x` (index in `ik`)
into `yk`. -/
def extractLimbsRun (x : Fin Γ.args.length) (hx : Γ.args[x] = V)
    (i0 i1 i2 i3 i4 i5 : Dst Γ (.bv 64)) (y0 y1 y2 y3 y4 y5 : Dst Γ (.bv 64)) : List (Instr Γ) :=
  [.binop .extractelement y0 (.arg x hx) (.val i0.i i0.h),
    .binop .extractelement y1 (.arg x hx) (.val i1.i i1.h),
    .binop .extractelement y2 (.arg x hx) (.val i2.i i2.h),
    .binop .extractelement y3 (.arg x hx) (.val i3.i i3.h),
    .binop .extractelement y4 (.arg x hx) (.val i4.i i4.h),
    .binop .extractelement y5 (.arg x hx) (.val i5.i i5.h)]

/-- Where the body at `pos` is `extractLimbsRun` and `x` holds `X`: running on from `pos` then `g`
gives `K` if it does from `pos + 6` with `extractLimbs X` in `y0 … y5`. -/
theorem runBodyFrom_extractLimbsRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x : Fin Γ.args.length} {hx : Γ.args[x] = V}
    {i0 i1 i2 i3 i4 i5 y0 y1 y2 y3 y4 y5 : Dst Γ (.bv 64)} {rest : List (Instr Γ)}
    {X : Vector (BitVec 64) 8} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody : blk.body.drop pos = extractLimbsRun x hx i0 i1 i2 i3 i4 i5 y0 y1 y2 y3 y4 y5 ++ rest)
    (hR :
      E ⊨ [.arg x hx := X, i0 := 0#64, i1 := 1#64, i2 := 2#64, i3 := 3#64, i4 := 4#64, i5 := 5#64])
    (hd : [i0.i, i1.i, i2.i, i3.i, i4.i, i5.i, y0.i, y1.i, y2.i, y3.i, y4.i].Nodup)
    (hK :
      (blk.runBodyFrom
            E[y0 := (extractLimbs X).y0, y1 := (extractLimbs X).y1, y2 := (extractLimbs X).y2, y3 :=
              (extractLimbs X).y3, y4 := (extractLimbs X).y4, y5 := (extractLimbs X).y5]
            (pos + 6) S >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with v0
  step_pure with v1
  step_pure with v2
  step_pure with v3
  step_pure with v4
  step_pure with v5
  rw [hE, ← hK]
  subst_vars
  rfl

end

end LeanMLIR.RIR.Firedancer.Avx512
