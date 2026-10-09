module

public import MLIR.Semantics.Func
public import MLIR.Run.BasicBlock
public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.FoldUnsigned

/-! `fd_r43x6_if(c, x, y)`: `x` if `c` is nonzero, else `y`. Compiled for a `c` that is `0` or `1`
(an `is_nonzero` result): the low byte of `c` minus one is the lane mask, all set exactly when
`c = 0`. -/

namespace MLIR.Firedancer.Avx512

@[expose] public section

/-- `fd_r43x6_if(c, x, y)` as four instructions: `c`'s low byte in `b` (a `trunc nsw nuw`), minus
one (`m1` holds `-1`) in `t`, as a lane mask in `mask`, selecting `y` where set and `x` elsewhere
into `r`. -/
def ifRun (c : Dst Γ (.bv 32)) (m1 b t : Dst Γ (.bv 8)) (mask : Dst Γ (.vec 8 1))
    (x y r : Dst Γ V) : List (Instr Γ) :=
  [.unop (.trunc { nsw := true, nuw := true }) b (.val c.i c.h),
    .binop (.add { nsw := true }) t (.val b.i b.h) (.val m1.i m1.h),
    .unop (.bitcast (t := .bv 8) (t' := .vec 8 1) rfl) mask (.val t.i t.h),
    .ternop (.vector (.select (τ := .bv 64))) r (.val mask.i mask.h) (.val y.i y.h) (.val x.i x.h)]

/-- A flag `0` or `1` truncates to a byte losslessly. -/
theorem trunc_01 {C : BitVec 32} (hC : C = 0 ∨ C = 1) :
    (C.setWidth 8).setWidth 32 = C ∧ (C.setWidth 8).signExtend 32 = C := by
  rcases hC with rfl | rfl <;> decide

/-- Where the body at `pos` is `ifRun`, `c` holds `0` or `1`, and `x y` hold `X Y`: running on from
`pos` then `g` gives `K` if it does from `pos + 4` with `if C = 0 then Y else X` in `r`, whatever
the intermediates hold. -/
theorem runBodyFrom_ifRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {c : Dst Γ (.bv 32)}
    {m1 b t : Dst Γ (.bv 8)} {mask : Dst Γ (.vec 8 1)} {x y r : Dst Γ V} {rest : List (Instr Γ)}
    {C : BitVec 32} {X Y : Vector (BitVec 64) 8} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = ifRun c m1 b t mask x y r ++ rest)
    (hR : E ⊨ [c := C, m1 := 255#8, x := X, y := Y]) (hC : C = 0 ∨ C = 1)
    (hd : [m1.i, x.i, y.i, b.i, t.i, mask.i].Nodup)
    (hK :
      ∀ (vb vt : ⟦.bv 8⟧) (vm : ⟦.vec 8 1⟧),
        (blk.runBodyFrom E[b := vb, t := vt, mask := vm, r := Ty.wrap (if C = 0 then Y else X)]
              (pos + 4) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  have htr := trunc_01 hC
  step_pure [htr.1, htr.2] with transparent vb
  step_pure with transparent vt
  step_pure with transparent vm
  step_pure with vr
  rw [hE, ← hK (.value vb) vt vm]
  congr
  subst hvr
  rcases hC with rfl | rfl <;> ext i hi : 1 <;> simp +decide [Ty.wrap_vec, Ty.extractVecElem_eq] <;>
    intro h <;>
    exfalso <;>
    revert i <;>
    decide

end

end MLIR.Firedancer.Avx512
