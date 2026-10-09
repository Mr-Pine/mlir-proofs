module

public import MLIR.Semantics.Func
public import MLIR.Run.BasicBlock
public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Neg
public import Firedancer.Avx512.Common.WwlRun

/-! `fd_r43x6_sub(x, y)`: `fd_r43x6_fold_signed` of `x + (p - y)`, compiled for a constant `y` as
`x + k` with `k` folded, then the signed fold's carries. -/

namespace MLIR.Firedancer.Avx512

@[expose] public section

/-- Lane-wise `x + y`. -/
abbrev vadd (x y : Vector (BitVec 64) 8) : Vector (BitVec 64) 8 :=
  Vector.ofFn fun i => x[i.1] + y[i.1]

/-- Lane-wise `x >>ₛ s`. -/
abbrev vsar (x s : Vector (BitVec 64) 8) : Vector (BitVec 64) 8 :=
  Vector.ofFn fun i => x[i.1].sshiftRight s[i.1].toNat

/-- Lane-wise `x * y`. -/
abbrev vmul (x y : Vector (BitVec 64) 8) : Vector (BitVec 64) 8 :=
  Vector.ofFn fun i => x[i.1] * y[i.1]

/-- The carries rotated up a lane, lane 5's into lane 0; lanes 6 and 7 zero. -/
def negRot (h : Vector (BitVec 64) 8) : Vector (BitVec 64) 8 :=
  #v[h[5], h[0], h[1], h[2], h[3], h[4], 0, 0]

/-- `fd_r43x6_fold_signed(d)` as compiled, before adding its bias back: each lane's low bits plus
the carry `c` from the lane below, and lane 0 also `18 ×` lane 5's carry (`19 ×` in all). -/
@[irreducible]
def foldSignedPre (d : Vector (BitVec 64) 8) : Vector (BitVec 64) 8 :=
  let c := negRot (vsar d foldShifts)
  wwl_add (wwl_add c (wwl_and d foldMask)) (wwl_and (vmul c neg18) negSel)

/-- `fd_r43x6_sub` as nine instructions: `x + k` in `d`, its low bits in `lo`, carries `hi`
rotated into `c`, `18 ×` lane 0's in `u` (`t` before masking), summed into `s1 = c + lo` and
`s2 = s1 + u`, and the bias `b` added into `r` (`mask shifts z o sel` the fold's constants,
`zeroLo` the rotation's second operand). -/
def subRun (x k mask shifts z o sel b d lo hi c t u s1 s2 r : Dst Γ V) : List (Instr Γ) :=
  [.binop (.vector (.add {})) d (.val x.i x.h) (.val k.i k.h),
    .binop (.vector .and) lo (.val d.i d.h) (.val mask.i mask.h),
    .binop (.vector (.ashr false)) hi (.val d.i d.h) (.val shifts.i shifts.h),
    .binop (.shufflevector negRotMask) c (.val hi.i hi.h) (.val z.i z.h),
    .binop (.vector (.mul {})) t (.val c.i c.h) (.val o.i o.h),
    .binop (.vector .and) u (.val t.i t.h) (.val sel.i sel.h),
    .binop (.vector (.add {})) s1 (.val c.i c.h) (.val lo.i lo.h),
    .binop (.vector (.add {})) s2 (.val s1.i s1.h) (.val u.i u.h),
    .binop (.vector (.add {})) r (.val s2.i s2.h) (.val b.i b.h)]

/-- Where the body at `pos` is `subRun`, `x` holds `X`, `k` holds `K` and the others the fold's
constants: running on from `pos` then `g` gives `K'` if it does from `pos + 9` with `foldSignedPre
(vadd X K)` in `s2` and that plus the bias in `r`, whatever the intermediates hold. -/
theorem runBodyFrom_subRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x k mask shifts z o sel b d lo hi c t u s1 s2 r : Dst Γ V} {rest : List (Instr Γ)}
    {X K : Vector (BitVec 64) 8} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K' : PoisonOr β}
    (hbody : blk.body.drop pos = subRun x k mask shifts z o sel b d lo hi c t u s1 s2 r ++ rest)
    (hR :
      E ⊨ [x := X, k := K, mask := foldMask, shifts := foldShifts, z := zeroLo, o := neg18, sel :=
        negSel, b := negBias])
    (hd :
      [x.i, k.i, mask.i, shifts.i, z.i, o.i, sel.i, b.i, d.i, lo.i, hi.i, c.i, t.i, u.i, s1.i,
          s2.i].Nodup)
    (hK :
      ∀ vd vlo vhi vc vt vu vs1 : ⟦V⟧,
        (blk.runBodyFrom
              E[d := vd, lo := vlo, hi := vhi, c := vc, t := vt, u := vu, s1 := vs1, s2 :=
                Ty.wrap (foldSignedPre (vadd X K)), r :=
                Ty.wrap (vadd (foldSignedPre (vadd X K)) negBias)]
              (pos + 9) S >>=
            g) =
          K') :
    (blk.runBodyFrom E pos S >>= g) = K' := by
  step_pure with vd
  step_pure with vlo
  step_pure [foldShifts_lt] with vhi
  step_pure with vc
  step_pure with vt
  step_pure with vu
  step_pure with vs1
  step_pure with vs2
  step_pure with vr
  have e : vs2 = foldSignedPre (vadd X K) := by
    subst_vars
    delta foldSignedPre
    rfl
  subst hvr e
  rw [hE]
  exact hK _ _ _ _ _ _ _

end

end MLIR.Firedancer.Avx512
