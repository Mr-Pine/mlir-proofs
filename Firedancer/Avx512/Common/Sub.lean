module

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Run.BasicBlock
public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Avx512.Common.Neg
public import Firedancer.Avx512.Common.WwlRun

/-! `fd_r43x6_sub(x, y)`: `fd_r43x6_fold_signed` of `x + (p - y)`, compiled for a constant `y` as
`x + k` with `k` folded, then the signed fold's carries. -/

namespace LeanMLIR.RIR.Firedancer.Avx512

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

set_option hygiene false in
/-- `subRun`'s nine steps, their results folded into `foldSignedPre`'s operations, `hK` unfolded to
them; the env rewritten to its values. -/
local macro "sub_fold" : tactic =>
  `(tactic|
    ( step_pure with vd
      step_pure with vlo
      step_pure [foldShifts_lt] with vhi
      step_pure with vc
      step_pure with vt
      step_pure with vu
      step_pure with vs1
      step_pure with vs2
      step_pure with vr
      -- the steps as the vector operations `foldSignedPre` is written with
      rw [permute_negIdx] at hvc
      subst hvc
      simp only [wrapGetElem, PoisonOr.value_bind, pullWrapOfFn] at hvt
      subst hvt
      simp only [wrapGetElem, PoisonOr.value_bind, pullWrapOfFn, ← wwl_and_getElem,
        Vector.ofFn_getElem] at hvu hvlo
      subst hvu hvlo
      simp only [wrapGetElem, PoisonOr.value_bind, pullWrapOfFn, ← wwl_add_getElem,
        Vector.ofFn_getElem] at hvs1
      subst hvs1
      simp only [wrapGetElem, PoisonOr.value_bind, pullWrapOfFn, ← wwl_add_getElem,
        Vector.ofFn_getElem] at hvs2
      subst hvs2
      simp only [wrapGetElem, PoisonOr.value_bind, pullWrapOfFn] at hvr
      subst hvhi hvd
      delta foldSignedPre at hK
      rw [hE, hvr]))

/-- `vpermi2var` by `negIdx` with a zero second operand, as the step gives it: `negRot`. -/
theorem permute_negIdx (v : Vector (BitVec 64) 8) :
    (Vector.ofFn fun i : Fin 8 =>
        if h : negIdx[i.1].toNat % 16 < 8 then PoisonOr.value v[negIdx[i.1].toNat % 16]
        else PoisonOr.value 0#64) =
      Ty.wrap (t := V) (negRot v) := by
  ext i hi : 1
  rcases i with _ | _ | _ | _ | _ | _ | _ | _ | i <;> simp [negIdx, negRot, Ty.wrap_vec] <;> omega

/-- `fd_r43x6_sub` as nine instructions: `x + k` in `d`, its low bits in `lo`, carries `hi`
rotated into `c`, `18 ×` lane 0's in `u` (`t` before masking), summed into `s1 = c + lo` and
`s2 = s1 + u`, and the bias `b` added into `r` (`mask shifts idx z o sel` the fold's constants). -/
def subRun (x k mask shifts idx z o sel b d lo hi c t u s1 s2 r : Dst Γ V) : List (Instr Γ) :=
  [.binop (.vector (.add {})) d (.val x.i x.h) (.val k.i k.h),
    .binop (.vector .and) lo (.val d.i d.h) (.val mask.i mask.h),
    .binop (.vector (.ashr false)) hi (.val d.i d.h) (.val shifts.i shifts.h),
    .ternop .vpermi2var c (.val hi.i hi.h) (.val idx.i idx.h) (.val z.i z.h),
    .binop (.vector (.mul {})) t (.val c.i c.h) (.val o.i o.h),
    .binop (.vector .and) u (.val t.i t.h) (.val sel.i sel.h),
    .binop (.vector (.add {})) s1 (.val c.i c.h) (.val lo.i lo.h),
    .binop (.vector (.add {})) s2 (.val s1.i s1.h) (.val u.i u.h),
    .binop (.vector (.add {})) r (.val s2.i s2.h) (.val b.i b.h)]

/-- `subRun` with `s1 = lo + c`, as the compiler also orders it. -/
def subRun' (x k mask shifts idx z o sel b d lo hi c t u s1 s2 r : Dst Γ V) : List (Instr Γ) :=
  [.binop (.vector (.add {})) d (.val x.i x.h) (.val k.i k.h),
    .binop (.vector .and) lo (.val d.i d.h) (.val mask.i mask.h),
    .binop (.vector (.ashr false)) hi (.val d.i d.h) (.val shifts.i shifts.h),
    .ternop .vpermi2var c (.val hi.i hi.h) (.val idx.i idx.h) (.val z.i z.h),
    .binop (.vector (.mul {})) t (.val c.i c.h) (.val o.i o.h),
    .binop (.vector .and) u (.val t.i t.h) (.val sel.i sel.h),
    .binop (.vector (.add {})) s1 (.val lo.i lo.h) (.val c.i c.h),
    .binop (.vector (.add {})) s2 (.val s1.i s1.h) (.val u.i u.h),
    .binop (.vector (.add {})) r (.val s2.i s2.h) (.val b.i b.h)]

/-- Where the body at `pos` is `subRun`, `x` holds `X`, `k` holds `K` and the others the fold's
constants: running on from `pos` then `g` gives `K'` if it does from `pos + 9` with `foldSignedPre
(vadd X K)` in `s2` and that plus the bias in `r`, whatever the intermediates hold. -/
theorem runBodyFrom_subRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x k mask shifts idx z o sel b d lo hi c t u s1 s2 r : Dst Γ V} {rest : List (Instr Γ)}
    {X K : Vector (BitVec 64) 8} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K' : PoisonOr β}
    (hbody : blk.body.drop pos = subRun x k mask shifts idx z o sel b d lo hi c t u s1 s2 r ++ rest)
    (hR :
      E ⊨ [x := X, k := K, mask := foldMask, shifts := foldShifts, idx := negIdx, z :=
        Vector.replicate 8 0, o := neg18, sel := negSel, b := negBias])
    (hd :
      [x.i, k.i, mask.i, shifts.i, idx.i, z.i, o.i, sel.i, b.i, d.i, lo.i, hi.i, c.i, t.i, u.i,
          s1.i, s2.i].Nodup)
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
  sub_fold
  exact hK _ _ _ _ _ _ _

/-- `runBodyFrom_subRun` for `subRun'`. -/
theorem runBodyFrom_subRun' {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x k mask shifts idx z o sel b d lo hi c t u s1 s2 r : Dst Γ V} {rest : List (Instr Γ)}
    {X K : Vector (BitVec 64) 8} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K' : PoisonOr β}
    (hbody :
      blk.body.drop pos = subRun' x k mask shifts idx z o sel b d lo hi c t u s1 s2 r ++ rest)
    (hR :
      E ⊨ [x := X, k := K, mask := foldMask, shifts := foldShifts, idx := negIdx, z :=
        Vector.replicate 8 0, o := neg18, sel := negSel, b := negBias])
    (hd :
      [x.i, k.i, mask.i, shifts.i, idx.i, z.i, o.i, sel.i, b.i, d.i, lo.i, hi.i, c.i, t.i, u.i,
          s1.i, s2.i].Nodup)
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
  sub_fold
  -- `s1 = lo + c`
  rw [Std.Commutative.comm (op := wwl_add) (wwl_and _ foldMask)]
  exact hK _ _ _ _ _ _ _

end

end LeanMLIR.RIR.Firedancer.Avx512
