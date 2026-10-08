module

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Run.BasicBlock
public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Avx512.Common.FoldUnsigned
public import Firedancer.Avx512.Common.Wwl
import Std.Tactic.BVDecide
import Mathlib.Tactic.FinCases
import Mathlib.Data.Fintype.Basic

/-! `x = fd_r43x6_if( x_0 != x_mod_2, fd_r43x6_neg( x ), x )`, the sign fix-up of point
decompression: `fd_r43x6_neg` inlined as `2p - x` and `fd_r43x6_fold_signed`, selected by a lane
mask from comparing the two flags. -/

namespace LeanMLIR.RIR.Firedancer.Avx512

@[expose] public section

/-- `2p`'s limbs, `fd_r43x6_neg`'s minuend. -/
@[mlir_const]
def negP : Vector (BitVec 64) 8 :=
  #v[8795933638637, 8796091973631, 8796091973631, 8796091973631, 8796091973631, 1099510579199, 0, 0]

/-- `fd_r43x6_fold_signed`'s bias `_b`. -/
@[mlir_const]
def negBias : Vector (BitVec 64) 8 :=
  #v[159383552, 1048576, 1048576, 1048576, 1048576, 1048576, 0, 0]

/-- The carries' rotation: lane `i` takes the carry of lane `i - 1`, lane 0 lane 5's; lanes 6 and 7
the second operand's lane 0 (zero). -/
@[mlir_const]
def negIdx : Vector (BitVec 64) 8 :=
  #v[5, 0, 1, 2, 3, 4, 8, 8]

/-- `fd_r43x6_neg(x)` as compiled: `d = 2p - x`, then each lane's low bits plus the bias plus the
carry from the lane below, and lane 0 also `18 ×` the carry it takes from lane 5 (`19 ×` in all). -/
def negFold (x : Vector (BitVec 64) 8) : Vector (BitVec 64) 8 :=
  let d := Vector.zipWith (· - ·) negP x
  let h := Vector.zipWith (fun v s => v.sshiftRight s.toNat) d foldShifts
  let c : Vector (BitVec 64) 8 := #v[h[5], h[0], h[1], h[2], h[3], h[4], 0, 0]
  Vector.ofFn fun i =>
    (d[i] &&& foldMask[i]) + negBias[i] + c[i] + (if i.val = 0 then c[0] * 18 else 0)

/-- The sign fix-up as thirteen instructions: `xmod == x0` in `e`, as a byte mask in `m`; `negFold
x` through `d lo hi c t u s1 s2` into `n` (`p b k z o m18` hold `2p`, `_b`, the rotation, zero,
`18` and `[-1, 0, …]`, `mask shifts` the fold's constants); then `x` where the mask is set, `n`
elsewhere, into `r`. -/
def negIfRun (xmod x0 : Dst Γ (.bv 32)) (e : Dst Γ (.bv 1)) (m : Dst Γ (.bv 8))
    (p x mask shifts b k z o m18 d lo hi c t u s1 s2 n : Dst Γ V) (mk : Dst Γ (.vec 8 1))
    (r : Dst Γ V) : List (Instr Γ) :=
  [.binop (.icmp .eq) e (.val xmod.i xmod.h) (.val x0.i x0.h),
    .unop (.sext (w := 1) (w' := 8)) m (.val e.i e.h),
    .binop (.vector (.sub {})) d (.val p.i p.h) (.val x.i x.h),
    .binop (.vector .and) lo (.val d.i d.h) (.val mask.i mask.h),
    .binop (.vector (.ashr false)) hi (.val d.i d.h) (.val shifts.i shifts.h),
    .ternop .vpermi2var c (.val hi.i hi.h) (.val k.i k.h) (.val z.i z.h),
    .binop (.vector (.mul {})) t (.val c.i c.h) (.val o.i o.h),
    .binop (.vector .and) u (.val t.i t.h) (.val m18.i m18.h),
    .binop (.vector (.add { nsw := true, nuw := true })) s1 (.val lo.i lo.h) (.val b.i b.h),
    .binop (.vector (.add {})) s2 (.val s1.i s1.h) (.val c.i c.h),
    .binop (.vector (.add {})) n (.val s2.i s2.h) (.val u.i u.h),
    .unop (.bitcast (t := .bv 8) (t' := .vec 8 1) rfl) mk (.val m.i m.h),
    .ternop (.vector (.select (τ := .bv 64))) r (.val mk.i mk.h) (.val x.i x.h) (.val n.i n.h)]

/-- `18` in every lane. -/
@[mlir_const]
def neg18 : Vector (BitVec 64) 8 :=
  Vector.replicate 8 18

/-- Lane 0 only: `[-1, 0, …]`. -/
@[mlir_const]
def negSel : Vector (BitVec 64) 8 :=
  #v[18446744073709551615, 0, 0, 0, 0, 0, 0, 0]

/-- Below `2^44`, a masked value plus a small bias overflows neither way. -/
theorem and_add_no_overflow (a m b : BitVec 64) (hm : m < 0x100000000000#64)
    (hb : b < 0x100000000000#64) :
    (a &&& m).saddOverflow b = false ∧ (a &&& m).uaddOverflow b = false := by bv_decide

/-- The all-ones mask, as the constant spells it. -/
theorem allOnes_64 : (18446744073709551615#64) = BitVec.allOnes 64 := by
  decide

/-- The masked low bits plus `fd_r43x6_fold_signed`'s bias: no overflow, the `nsw nuw` add. -/
theorem negBias_no_overflow (a : BitVec 64) (i : Nat) (hi : i < 8) :
    (a &&& foldMask[i]).saddOverflow negBias[i] = false ∧
      (a &&& foldMask[i]).uaddOverflow negBias[i] = false :=
  and_add_no_overflow _ _ _
    (by
      revert i; decide)
    (by
      revert i; decide)

/-- Where the body at `pos` is `negIfRun`, `xmod x0` hold `XM X0`, `x` holds `X` and the others the
constants: running on from `pos` then `g` gives `K` if it does from `pos + 13` with
`if XM = X0 then X else negFold X` in `r`, whatever the intermediates hold. -/
theorem runBodyFrom_negIfRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {xmod x0 : Dst Γ (.bv 32)} {e : Dst Γ (.bv 1)} {m : Dst Γ (.bv 8)}
    {p x mask shifts b k z o m18 d lo hi c t u s1 s2 n : Dst Γ V} {mk : Dst Γ (.vec 8 1)}
    {r : Dst Γ V} {rest : List (Instr Γ)} {XM X0 : BitVec 32} {X : Vector (BitVec 64) 8}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        negIfRun xmod x0 e m p x mask shifts b k z o m18 d lo hi c t u s1 s2 n mk r ++ rest)
    (hR :
      E ⊨ [xmod := XM, x0 := X0, x := X, p := negP, mask := foldMask, shifts := foldShifts, b :=
        negBias, k := negIdx, z := Vector.replicate 8 0, o := neg18, m18 := negSel])
    (hd :
      [x.i, p.i, mask.i, shifts.i, b.i, k.i, z.i, o.i, m18.i, e.i, m.i, d.i, lo.i, hi.i, c.i, t.i,
          u.i, s1.i, s2.i, n.i, mk.i].Nodup)
    (hK :
      ∀ (ve : ⟦.bv 1⟧) (vm : ⟦.bv 8⟧) (vd vlo vhi vc vt vu vs1 vs2 vn : ⟦V⟧) (vmk : ⟦.vec 8 1⟧),
        (blk.runBodyFrom
              E[e := ve, m := vm, d := vd, lo := vlo, hi := vhi, c := vc, t := vt, u := vu, s1 :=
                vs1, s2 := vs2, n := vn, mk := vmk, r := Ty.wrap (if XM = X0 then X else negFold X)]
              (pos + 13) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with transparent ve
  step_pure with transparent vm
  step_pure with transparent vd
  step_pure with transparent vlo
  step_pure [foldShifts_lt] with transparent vhi
  step_pure with transparent vc
  step_pure with transparent vt
  step_pure with transparent vu
  step_pure with transparent vs1
  step_pure with transparent vs2
  step_pure with transparent vn
  step_pure with transparent vmk
  step_pure with vr
  rw [hE, ← hK]
  congr
  subst hvr
  by_cases hXM : XM = X0 <;> apply vec_ext_fin <;> intro i <;>
    simp [hXM, Ty.wrap_vec, Ty.extractVecElem_eq, negBias_no_overflow _ i.1 i.2,
      show (XM == X0) = decide (XM = X0) from rfl]
  · intro h
    exfalso
    revert i
    decide
  · split
    · exfalso
      rename_i h
      revert i
      decide
    · fin_cases i
      all_goals
        first
        | omega
        | simp [negFold, negIdx, negP, foldMask, foldShifts, negBias, neg18, negSel]
      simp only [allOnes_64, BitVec.and_allOnes]

end

end LeanMLIR.RIR.Firedancer.Avx512
