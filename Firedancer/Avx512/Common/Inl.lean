module

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Run.BasicBlock
public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Avx512.Common.Callees

/-! `FD_R43X6_MUL_INL` and `FD_R43X6_SQR_INL`: a `fd_r43x6_mul_fast` / `fd_r43x6_sqr_fast` call,
then `fd_r43x6_fold_unsigned` of its result. -/

namespace LeanMLIR.RIR.Firedancer.Avx512

@[expose] public section

/-- `FD_R43X6_MUL_INL` as five instructions: `mul x y` into `z`, then its fold into `r`
(`foldRun`'s registers). -/
def mulInlRun (mul : MulFast) (x y z m s p k a b c r : Dst Γ V) : List (Instr Γ) :=
  .call mul (.cons (.val x.i x.h) (.cons (.val y.i y.h) .nil)) (.cons z .nil) ::
    foldRun z m s p k a b c r

/-- `FD_R43X6_SQR_INL` as five instructions: `sqr x` into `z`, then its fold into `r`. -/
def sqrInlRun (sqr : SqrFast) (x z m s p k a b c r : Dst Γ V) : List (Instr Γ) :=
  .call sqr (.cons (.val x.i x.h) .nil) (.cons z .nil) :: foldRun z m s p k a b c r

/-- Where the body at `pos` is `mulInlRun`, `mul` is `mulS`, and `x y m s k` hold `X Y` and the
fold's constants: running on from `pos` then `g` gives `K` if it does from `pos + 5` with
`fold (mulS X Y)` in `r`, whatever the intermediates hold. -/
theorem runBodyFrom_mulInlRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {mul : MulFast}
    {mulS : Vector (BitVec 64) 8 → Vector (BitVec 64) 8 → Vector (BitVec 64) 8}
    {x y z m s p k a b c r : Dst Γ V} {rest : List (Instr Γ)} {X Y : Vector (BitVec 64) 8}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} (hmul : mul.Spec mulS)
    (hwf : S.WF) (hbody : blk.body.drop pos = mulInlRun mul x y z m s p k a b c r ++ rest)
    (hR : E ⊨ [x := X, y := Y, m := foldMask, s := foldShifts, k := foldK])
    (hd : [z.i, m.i, s.i, k.i, a.i, b.i, c.i].Nodup)
    (hK :
      ∀ vz va vb vc : ⟦V⟧,
        (blk.runBodyFrom E[z := vz, a := va, b := vb, c := vc, r := Ty.wrap (fold (mulS X Y))]
              (pos + 5) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_call using hmul with transparent vz
  step_pure with transparent va
  step_pure [foldShifts_lt] with transparent vb
  step_pure with transparent vc
  step_pure with vd
  rw [hE, ← hK]
  congr
  rw [hvd, fold]
  ext i hi : 1
  simp [Vector.getElem_ofFn hi]

/-- `runBodyFrom_mulInlRun` for `sqrInlRun`: `fold (sqrS X)` in `r`. -/
theorem runBodyFrom_sqrInlRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {sqr : SqrFast}
    {sqrS : Vector (BitVec 64) 8 → Vector (BitVec 64) 8} {x z m s p k a b c r : Dst Γ V}
    {rest : List (Instr Γ)} {X : Vector (BitVec 64) 8} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β} (hsqr : sqr.Spec sqrS) (hwf : S.WF)
    (hbody : blk.body.drop pos = sqrInlRun sqr x z m s p k a b c r ++ rest)
    (hR : E ⊨ [x := X, m := foldMask, s := foldShifts, k := foldK])
    (hd : [z.i, m.i, s.i, k.i, a.i, b.i, c.i].Nodup)
    (hK :
      ∀ vz va vb vc : ⟦V⟧,
        (blk.runBodyFrom E[z := vz, a := va, b := vb, c := vc, r := Ty.wrap (fold (sqrS X))]
              (pos + 5) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_call using hsqr with transparent vz
  step_pure with transparent va
  step_pure [foldShifts_lt] with transparent vb
  step_pure with transparent vc
  step_pure with vd
  rw [hE, ← hK]
  congr
  rw [hvd, fold]
  ext i hi : 1
  simp [Vector.getElem_ofFn hi]

end

end LeanMLIR.RIR.Firedancer.Avx512
