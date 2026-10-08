module

public import SSA.Projects.RIR.Semantics.Func
public import SSA.Projects.RIR.Run.Call
public import SSA.Projects.RIR.Run.BasicBlock
public import SSA.Projects.RIR.Run.Vector
public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Avx512.Common.Callees
public import Firedancer.Avx512.Common.WwlRun
public import Firedancer.Avx512.Mlir.fd_r43x6_sqr_fast

namespace LeanMLIR.RIR.Firedancer.Avx512

-- folded, so the steps' terms and the specs compare without unfolding the lanes
attribute [local irreducible] wwl_add wwl_and wwl_shl wwl_slide wwl_madd52lo wwl_madd52hi

@[expose] public section

/-! ## Specification -/

/-- `mask1`: the lanes whose `p1` products are high. -/
def sqrMask1 : Vector (BitVec 64) 8 :=
  #v[-1, -1, 0, 0, 0, 0, 0, 0]

/-- `mask2`: the lanes whose `p2` products are high. -/
def sqrMask2 : Vector (BitVec 64) 8 :=
  #v[-1, 0, -1, 0, 0, 0, 0, 0]

/-- `fd_r43x6_sqr_fast`'s sums: the low parts `p*l` and high parts `p*h` (times `2^9`) of the lane
products, split by `mask1 mask2` into the low sum `zl` and the high sum `zh`. -/
def fd_r43x6_sqr_fast.sums (p0l p1l p2l p0h p1h p2h : Vector (BitVec 64) 8) :
    Vector (BitVec 64) 8 × Vector (BitVec 64) 8 :=
  let mask1 := sqrMask1
  let mask2 := sqrMask2
  let zll := wwl_add p0l (wwl_add (wwl_andnot mask1 p1l) (wwl_andnot mask2 p2l))
  let zlh := wwl_add p0h (wwl_add (wwl_andnot mask1 p1h) (wwl_andnot mask2 p2h))
  let zhl := wwl_add (wwl_and mask1 p1l) (wwl_and mask2 p2l)
  let zhh := wwl_add (wwl_and mask1 p1h) (wwl_and mask2 p2h)
  let zl := wwl_add zll (wwl_slide wwl_zero zlh 7)
  let zh := wwl_add zhl (wwl_add (wwl_slide wwl_zero zhh 7) (wwl_slide zlh wwl_zero 7))
  (zl, zh)

/-- `fd_r43x6_sqr_fast` past its permutes: the lane products `x0 x1`, `x2 x3`, `x4 x5` split by
`madd52`, summed, then `za + 152 zb`. -/
def fd_r43x6_sqr_fast.reduce (x0 x1 x2 x3 x4 x5 : Vector (BitVec 64) 8) : Vector (BitVec 64) 8 :=
  let p0l := wwl_madd52lo wwl_zero x0 x1
  let p1l := wwl_madd52lo wwl_zero x2 x3
  let p2l := wwl_madd52lo wwl_zero x4 x5
  let p0h := wwl_shl (wwl_madd52hi wwl_zero x0 x1) 9
  let p1h := wwl_shl (wwl_madd52hi wwl_zero x2 x3) 9
  let p2h := wwl_shl (wwl_madd52hi wwl_zero x4 x5) 9
  let z := fd_r43x6_sqr_fast.sums p0l p1l p2l p0h p1h p2h
  fold152 z.1 z.2

/-- `fd_r43x6_sqr_fast(x)`: the permutes `x0 … x5` of `x`, the non-square terms of `x0 x2 x4`
doubled, then `reduce`. -/
@[irreducible]
def fd_r43x6_sqr_fast.spec (x : Wwl) : Wwl :=
  let x0 := wwl_permute (wwl 0 0 0 0 0 0 3 3) x
  let x1 := wwl_permute (wwl 0 1 2 3 4 5 3 4) x
  let x2 := wwl_permute (wwl 4 4 1 1 1 1 1 7) x
  let x3 := wwl_permute (wwl 4 5 1 2 3 4 5 7) x
  let x4 := wwl_permute (wwl 3 7 5 7 2 2 2 2) x
  let x5 := wwl_permute (wwl 5 7 5 7 2 3 4 5) x
  -- double the non-square terms
  let x0 := wwl_shl_vector x0 (wwl 0 1 1 1 1 1 0 1)
  let x2 := wwl_shl_vector x2 (wwl 0 1 0 1 1 1 1 1)
  let x4 := wwl_shl_vector x4 (wwl 1 1 0 1 0 1 1 1)
  fd_r43x6_sqr_fast.reduce x0 x1 x2 x3 x4 x5

/-- `fd_r43x6_sqr(x)`: `fd_r43x6_fold_unsigned(fd_r43x6_sqr_fast(x))`. -/
def fd_r43x6_sqr (x : Wwl) : Wwl :=
  fold (fd_r43x6_sqr_fast.spec x)

end

/-! ## Proof -/

section Proof

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
  congr 1 <;> ext i hi : 1 <;>
    rcases i with _ | _ | _ | _ | _ | _ | _ | _ | i <;>
    simp [wwl_permute, wwl_shl_vector, wwl] <;> omega

/-! ## The permutes -/

/-- `x0`'s doubling shifts: the non-square terms. -/
@[mlir_const]
def sqrDbl0 : Vector (BitVec 64) 8 :=
  #v[0, 1, 1, 1, 1, 1, 0, 1]

/-- `x2`'s doubling shifts. -/
@[mlir_const]
def sqrDbl2 : Vector (BitVec 64) 8 :=
  #v[0, 1, 0, 1, 1, 1, 1, 1]

/-- `x4`'s doubling shifts. -/
@[mlir_const]
def sqrDbl4 : Vector (BitVec 64) 8 :=
  #v[1, 1, 0, 1, 0, 1, 1, 1]

/-- Every doubling shift is below the lane width. -/
theorem sqrDbl_lt (i : Nat) (h : i < 8) :
    ¬64 ≤ sqrDbl0[i].toNat ∧ ¬64 ≤ sqrDbl2[i].toNat ∧ ¬64 ≤ sqrDbl4[i].toNat := by
  revert i; decide

/-- The six `wwl_permute`s of argument `x` into `x0 … x5` (`p` the shuffles' unused operand), then
`x0 x2 x4` doubled by the shifts in `s0 s2 s4` into `d0 d2 d4`. -/
def sqrPermRun (x : Fin Γ.args.length) (hx : Γ.args[x] = V)
    (p x0 x1 x2 x3 x4 x5 s0 s2 s4 d0 d2 d4 : Dst Γ V) : List (Instr Γ) :=
  [.binop (.shufflevector #v[some 0, some 0, some 0, some 0, some 0, some 0, some 3, some 3]) x0
      (.arg x hx) (.val p.i p.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 4, some 5, some 3, some 4]) x1
      (.arg x hx) (.val p.i p.h),
    .binop (.shufflevector #v[some 4, some 4, some 1, some 1, some 1, some 1, some 1, some 7]) x2
      (.arg x hx) (.val p.i p.h),
    .binop (.shufflevector #v[some 4, some 5, some 1, some 2, some 3, some 4, some 5, some 7]) x3
      (.arg x hx) (.val p.i p.h),
    .binop (.shufflevector #v[some 3, some 7, some 5, some 7, some 2, some 2, some 2, some 2]) x4
      (.arg x hx) (.val p.i p.h),
    .binop (.shufflevector #v[some 5, some 7, some 5, some 7, some 2, some 3, some 4, some 5]) x5
      (.arg x hx) (.val p.i p.h),
    .binop (.vector (.shl {})) d0 (.val x0.i x0.h) (.val s0.i s0.h),
    .binop (.vector (.shl {})) d2 (.val x2.i x2.h) (.val s2.i s2.h),
    .binop (.vector (.shl {})) d4 (.val x4.i x4.h) (.val s4.i s4.h)]

/-- Where the body at `pos` is `sqrPermRun`, `x` holds `X` and `s0 s2 s4` the shifts, running on
from `pos` then `g` gives `K` if it does from `pos + 9` with the permutes in `x1 x3 x5` and the
doubled ones in `d0 d2 d4`, whatever `x0 x2 x4` hold. -/
theorem runBodyFrom_sqrPermRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x : Fin Γ.args.length} {hx : Γ.args[x] = V} {p x0 x1 x2 x3 x4 x5 s0 s2 s4 d0 d2 d4 : Dst Γ V}
    {rest : List (Instr Γ)} {X : Vector (BitVec 64) 8} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = sqrPermRun x hx p x0 x1 x2 x3 x4 x5 s0 s2 s4 d0 d2 d4 ++ rest)
    (hR : E ⊨ [Reg.arg x hx := X, s0 := sqrDbl0, s2 := sqrDbl2, s4 := sqrDbl4])
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
    (blk.runBodyFrom E pos S >>= g) = K := by
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
  congr <;> simp [hw0, hw2, hw4, sqrDbl0, sqrDbl2, sqrDbl4, expandOfFn]

/-! ## The masks -/

/-- `~mask1` (`wwl_andnot`'s complement): lanes 2 to 7. -/
@[mlir_const]
def sqrMaskN1 : Vector (BitVec 64) 8 :=
  #v[0, 0, 0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF,
    0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF]

/-- `~mask2`: lanes 1 and 3 to 7. -/
@[mlir_const]
def sqrMaskN2 : Vector (BitVec 64) 8 :=
  #v[0, 0xFFFFFFFFFFFFFFFF, 0, 0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF,
    0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF]

/-- `za`'s mask: lanes 0 to 5. -/
@[mlir_const]
def sqrMaskA : Vector (BitVec 64) 8 :=
  #v[0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF,
    0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFF, 0, 0]

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

/-- The products as nine instructions: `madd52lo` of `x0 x1`, `x2 x3`, `x4 x5` into `p0l p1l p2l`,
`madd52hi` into `t0 t1 t2` shifted by `9` into `p0h p1h p2h` (`zero nine` hold the splats). -/
def sqrProdRun (x0 x1 x2 x3 x4 x5 zero nine p0l p1l p2l t0 p0h t1 p1h t2 p2h : Dst Γ V) :
    List (Instr Γ) :=
  [.ternop .vpmadd52l p0l (.val zero.i zero.h) (.val x0.i x0.h) (.val x1.i x1.h),
    .ternop .vpmadd52l p1l (.val zero.i zero.h) (.val x2.i x2.h) (.val x3.i x3.h),
    .ternop .vpmadd52l p2l (.val zero.i zero.h) (.val x4.i x4.h) (.val x5.i x5.h),
    .ternop .vpmadd52h t0 (.val zero.i zero.h) (.val x0.i x0.h) (.val x1.i x1.h),
    .binop (.vector (.shl {})) p0h (.val t0.i t0.h) (.val nine.i nine.h),
    .ternop .vpmadd52h t1 (.val zero.i zero.h) (.val x2.i x2.h) (.val x3.i x3.h),
    .binop (.vector (.shl {})) p1h (.val t1.i t1.h) (.val nine.i nine.h),
    .ternop .vpmadd52h t2 (.val zero.i zero.h) (.val x4.i x4.h) (.val x5.i x5.h),
    .binop (.vector (.shl {})) p2h (.val t2.i t2.h) (.val nine.i nine.h)]

/-- Where the body at `pos` is `sqrProdRun` and `x0 … x5` hold `X0 … X5`: running on from `pos` then
`g` gives `K` if it does from `pos + 9` with the products in `p0l … p2h`, whatever `t0 t1 t2`
hold. -/
theorem runBodyFrom_sqrProdRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x0 x1 x2 x3 x4 x5 zero nine p0l p1l p2l t0 p0h t1 p1h t2 p2h : Dst Γ V} {rest : List (Instr Γ)}
    {X0 X1 X2 X3 X4 X5 : Vector (BitVec 64) 8} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        sqrProdRun x0 x1 x2 x3 x4 x5 zero nine p0l p1l p2l t0 p0h t1 p1h t2 p2h ++ rest)
    (hR :
      E ⊨ [x0 := X0, x1 := X1, x2 := X2, x3 := X3, x4 := X4, x5 := X5, zero := Vector.replicate 8 0,
        nine := Vector.replicate 8 9])
    (hd :
      [x0.i, x1.i, x2.i, x3.i, x4.i, x5.i, zero.i, nine.i, p0l.i, p1l.i, p2l.i, t0.i, p0h.i, t1.i,
          p1h.i, t2.i].Nodup)
    (hK :
      ∀ vt0 vt1 vt2 : ⟦V⟧,
        (blk.runBodyFrom
              E[p0l := wwl_madd52lo wwl_zero X0 X1, p1l := wwl_madd52lo wwl_zero X2 X3, p2l :=
                wwl_madd52lo wwl_zero X4 X5, t0 := vt0, p0h :=
                wwl_shl (wwl_madd52hi wwl_zero X0 X1) 9, t1 := vt1, p1h :=
                wwl_shl (wwl_madd52hi wwl_zero X2 X3) 9, t2 := vt2, p2h :=
                wwl_shl (wwl_madd52hi wwl_zero X4 X5) 9]
              (pos + 9) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with v0
  step_pure with v1
  step_pure with v2
  step_pure with transparent w0
  step_pure with h0
  step_pure with transparent w1
  step_pure with h1
  step_pure with transparent w2
  step_pure with h2
  have e0 : v0 = wwl_madd52lo wwl_zero X0 X1 := by
    rw [hv0]; ext i hi : 1; simp [wwl_madd52lo, madd52lo]
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
  rw [hE, e0, e1, e2, f0, f1, f2]
  exact hK _ _ _

/-! ## The sums -/

/-- The sums as twenty instructions: `wwl_andnot`s (as `and`s with `mn1 mn2`, the masks'
complements) into `l* h*`, `wwl_and`s with `m1l m2l m1h m2h` (the masks on the read lanes) into
`k* j*`, the adds, and the slides (`pz zp` the zero operands) into `zl` and `zh`. -/
def sqrSumsRun
    (p0l p1l p2l p0h p1h p2h mn1 mn2 m1l m2l m1h m2h pz zp l1 l2 h1 h2 zlh0 zlh k1 k2 j1 j2 zhh zlhs
      zll0 zll zl zhhs zlht zhl zh0 zh : Dst Γ V) :
    List (Instr Γ) :=
  [.binop (.vector .and) l1 (.val p1l.i p1l.h) (.val mn1.i mn1.h),
    .binop (.vector .and) l2 (.val p2l.i p2l.h) (.val mn2.i mn2.h),
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
    .binop (.vector (.add {})) zll0 (.val l1.i l1.h) (.val p0l.i p0l.h),
    .binop (.vector (.add {})) zll (.val zll0.i zll0.h) (.val l2.i l2.h),
    .binop (.vector (.add {})) zl (.val zll.i zll.h) (.val zlhs.i zlhs.h),
    .binop (.shufflevector #v[some 7, some 8, some 9, some 10, some 11, some 12, none, none]) zhhs
      (.val pz.i pz.h) (.val zhh.i zhh.h),
    .binop (.shufflevector #v[some 7, some 8, some 9, some 10, some 11, some 12, none, none]) zlht
      (.val zlh.i zlh.h) (.val zp.i zp.h),
    .binop (.vector (.add {})) zhl (.val k2.i k2.h) (.val k1.i k1.h),
    .binop (.vector (.add {})) zh0 (.val zhl.i zhl.h) (.val zhhs.i zhhs.h),
    .binop (.vector (.add {})) zh (.val zh0.i zh0.h) (.val zlht.i zlht.h)]

/-- Where the body at `pos` is `sqrSumsRun`, `p0l … p2h` hold the products and the others the masks:
running on from `pos` then `g` gives `K` if it does from `pos + 20` with `sums`' `zl` in `zl` and
its `zh` in `zh`'s lanes `0 … 5`, whatever the intermediates hold. -/
theorem runBodyFrom_sqrSumsRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {p0l p1l p2l p0h p1h p2h mn1 mn2 m1l m2l m1h m2h pz zp l1 l2 h1 h2 zlh0 zlh k1 k2 j1 j2 zhh zlhs
      zll0 zll zl zhhs zlht zhl zh0 zh : Dst Γ V}
    {rest : List (Instr Γ)} {P0L P1L P2L P0H P1H P2H : Vector (BitVec 64) 8} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        sqrSumsRun p0l p1l p2l p0h p1h p2h mn1 mn2 m1l m2l m1h m2h pz zp l1 l2 h1 h2 zlh0 zlh k1 k2
            j1 j2 zhh zlhs zll0 zll zl zhhs zlht zhl zh0 zh ++
          rest)
    (hR :
      E ⊨ [p0l := P0L, p1l := P1L, p2l := P2L, p0h := P0H, p1h := P1H, p2h := P2H, mn1 := sqrMaskN1,
        mn2 := sqrMaskN2, m1l := lanesBelow 6 sqrMask1, m2l := lanesBelow 6 sqrMask2, m1h :=
        lanesBelow 5 sqrMask1, m2h := lanesBelow 5 sqrMask2, pz := lanesFrom 7 wwl_zero, zp :=
        lanesBelow 5 wwl_zero])
    (hd :
      [p0l.i, p1l.i, p2l.i, p0h.i, p1h.i, p2h.i, mn1.i, mn2.i, m1l.i, m2l.i, m1h.i, m2h.i, pz.i,
          zp.i, l1.i, l2.i, h1.i, h2.i, zlh0.i, zlh.i, k1.i, k2.i, j1.i, j2.i, zhh.i, zlhs.i,
          zll0.i, zll.i, zl.i, zhhs.i, zlht.i, zhl.i, zh0.i].Nodup)
    (hK :
      ∀ vl1 vl2 vh1 vh2 vzlh0 vzlh vk1 vk2 vj1 vj2 vzhh vzlhs vzll0 vzll vzhhs vzlht vzhl vzh0 :
        ⟦V⟧,
        (blk.runBodyFrom
              E[l1 := vl1, l2 := vl2, h1 := vh1, h2 := vh2, zlh0 := vzlh0, zlh := vzlh, k1 := vk1,
                k2 := vk2, j1 := vj1, j2 := vj2, zhh := vzhh, zlhs := vzlhs, zll0 := vzll0, zll :=
                vzll, zl := Ty.wrap (fd_r43x6_sqr_fast.sums P0L P1L P2L P0H P1H P2H).1, zhhs :=
                vzhhs, zlht := vzlht, zhl := vzhl, zh0 := vzh0, zh :=
                low6 (fd_r43x6_sqr_fast.sums P0L P1L P2L P0H P1H P2H).2]
              (pos + 20) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with vl1
  step_pure with vl2
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
  step_pure with vzll0
  step_pure with vzll
  step_pure with vzl
  step_pure with vzhhs
  step_pure with vzlht
  step_pure with vzhl
  step_pure with vzh0
  step_pure with vzh
  -- the steps' lanes as the intrinsics they are
  simp only [← wwl_add_getElem, ← wwl_and_getElem, Vector.ofFn_getElem, lanesFrom_getElem,
    Nat.le_refl, ↓reduceIte, Vector.getElem_replicate, BitVec.ofNat_eq_ofNat, pullWrap,
    ← wwl_slide_zero_7] at hvl1 hvl2 hvh1 hvh2 hvzlh0 hvzlh hvzll0 hvzll hvzlhs
  subst hvl1 hvl2 hvh1 hvh2 hvzlh0 hvzlh hvzll0 hvzll hvzlhs
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
  have e1 : vzl = Ty.wrap (t := V) (fd_r43x6_sqr_fast.sums P0L P1L P2L P0H P1H P2H).1 := by
    simp only [hvzl, wrapGetElem, PoisonOr.value_bind, pullWrapOfFn, ← wwl_add_getElem,
      Vector.ofFn_getElem, fd_r43x6_sqr_fast.sums, and_sqrMaskN1, and_sqrMaskN2]
    ac_rfl
  have e2 : vzh = low6 (fd_r43x6_sqr_fast.sums P0L P1L P2L P0H P1H P2H).2 := by
    simp only [hvzh, fd_r43x6_sqr_fast.sums, and_sqrMaskN1, and_sqrMaskN2]
    ac_rfl
  rw [hE, e1, e2]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

/-- `fd_r43x6_sqr_fast` returns `spec x` and leaves the state as it is. -/
public theorem fd_r43x6_sqr_fast.call_eq (x : Wwl) (s : GlobalState) (hwf : s.WF) :
    fd_r43x6_sqr_fast.call (fd_r43x6_sqr_fast.args (Ty.wrap x)) s =
      .value (.cons (Ty.wrap (fd_r43x6_sqr_fast.spec x)) .nil, s) := by
  func_init
  block_init
  iterate 76 step_pure
  -- the permutes, `x0 … x5`, the three doubled
  step_pattern using runBodyFrom_sqrPermRun with x4
  -- the lane products `p0l … p2h`
  step_pattern using runBodyFrom_sqrProdRun with p2h
  -- `zl`, `zh`
  step_pattern using runBodyFrom_sqrSumsRun with zh
  -- `za + 152 zb`
  step_pattern using runBodyFrom_fold152Run with z
  finish_block
  subst_vars
  rw [fd_r43x6_sqr_fast.spec_eq]
  delta fd_r43x6_sqr_fast.reduce
  rfl

end Proof

end LeanMLIR.RIR.Firedancer.Avx512
