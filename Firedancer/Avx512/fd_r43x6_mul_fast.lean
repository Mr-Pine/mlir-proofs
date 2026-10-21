module

public import MLIR.Semantics.Func
public import MLIR.Run.Call
public import MLIR.Run.BasicBlock
public import MLIR.Run.Vector
public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Callees
public import Firedancer.Avx512.Common.WwlRun
public import Firedancer.Avx512.Mlir.fd_r43x6_mul_fast
import Std.Tactic.BVDecide
import Mathlib.Tactic.FinCases
import Mathlib.Data.Fintype.Basic

meta import MLIR.Semantics.Func
meta import MLIR.Run.Vector
meta import Firedancer.Avx512.Mlir.fd_r43x6_mul_fast

namespace MLIR.Firedancer.Avx512

-- folded, so the steps' terms and the specs compare without unfolding the lanes
attribute [local irreducible] wwl_add wwl_and wwl_shl wwl_slide wwl_madd52lo wwl_madd52hi

@[expose] public section

/-! ## Specification -/

namespace fd_r43x6_mul_fast

/-- The rows `t0 … t6` slid into the sums `zl` and `zh`, then `za + 152 zb`. -/
@[irreducible]
def tail (t0 t1 t2 t3 t4 t5 t6 : Vector (BitVec 64) 8) : Vector (BitVec 64) 8 :=
  let p0j := t0
  let p1j := wwl_slide wwl_zero t1 7
  let p2j := wwl_slide wwl_zero t2 6
  let p3j := wwl_slide wwl_zero t3 5
  let q3j := wwl_slide t3 wwl_zero 5
  let p4j := wwl_slide wwl_zero t4 4
  let q4j := wwl_slide t4 wwl_zero 4
  let p5j := wwl_slide wwl_zero t5 3
  let q5j := wwl_slide t5 wwl_zero 3
  let p6j := wwl_slide wwl_zero t6 2
  let q6j := wwl_slide t6 wwl_zero 2
  let zl := wwl_add (wwl_add (wwl_add p0j p1j) (wwl_add p2j p3j)) (wwl_add (wwl_add p4j p5j) p6j)
  let zh := wwl_add (wwl_add q3j q4j) (wwl_add q5j q6j)
  fold152 zl zh

end fd_r43x6_mul_fast

open fd_r43x6_mul_fast in
/-- `fd_r43x6_mul_fast(x, y)`: row `t_k` is `x_k y`'s low 52 bits plus `x_(k-1) y`'s high bits
shifted up by `9`, then `tail`. -/
@[irreducible]
def fd_r43x6_mul_fast.spec (x y : Vector (BitVec 64) 8) : Vector (BitVec 64) 8 :=
  let x0 := Vector.replicate 8 x[0]
  let x1 := Vector.replicate 8 x[1]
  let x2 := Vector.replicate 8 x[2]
  let x3 := Vector.replicate 8 x[3]
  let x4 := Vector.replicate 8 x[4]
  let x5 := Vector.replicate 8 x[5]
  let t0 := wwl_madd52lo wwl_zero x0 y
  let t1 := wwl_madd52lo (wwl_shl (wwl_madd52hi wwl_zero x0 y) 9) x1 y
  let t2 := wwl_madd52lo (wwl_shl (wwl_madd52hi wwl_zero x1 y) 9) x2 y
  let t3 := wwl_madd52lo (wwl_shl (wwl_madd52hi wwl_zero x2 y) 9) x3 y
  let t4 := wwl_madd52lo (wwl_shl (wwl_madd52hi wwl_zero x3 y) 9) x4 y
  let t5 := wwl_madd52lo (wwl_shl (wwl_madd52hi wwl_zero x4 y) 9) x5 y
  let t6 := wwl_shl (wwl_madd52hi wwl_zero x5 y) 9
  tail t0 t1 t2 t3 t4 t5 t6

/-- `fd_r43x6_mul(x, y)`: `fd_r43x6_fold_unsigned(fd_r43x6_mul_fast(x, y))`. -/
def fd_r43x6_mul (x y : Wwl) : Wwl :=
  fold (fd_r43x6_mul_fast.spec x y)

end

/-! ## Proof -/

namespace fd_r43x6_mul_fast

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

/-- Row `k`'s high half: `wwl_madd52hi(wwl_zero(), x_k, y)` in `uh`, shifted up by `9` into `ph`. -/
def hiRun (zr nine xk : Dst Γ V) (ya : Fin Γ.args.length) (hya : Γ.args[ya] = V) (uh ph : Dst Γ V) :
    List (Instr Γ) :=
  [.ternop .vpmadd52h uh (.val zr.i zr.h) (.val xk.i xk.h) (.arg ya hya),
    .binop (.vector (.shl {})) ph (.val uh.i uh.h) (.val nine.i nine.h)]

/-- Where the body at `pos` is `hiRun`, `xk` holds `XK` and argument `ya` holds `Y`: `ph` gets
`wwl_shl (wwl_madd52hi wwl_zero XK Y) 9`. -/
theorem runBodyFrom_hiRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {zr nine xk : Dst Γ V} {ya : Fin Γ.args.length} {hya : Γ.args[ya] = V} {uh ph : Dst Γ V}
    {rest : List (Instr Γ)} {XK Y : Vector (BitVec 64) 8} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = hiRun zr nine xk ya hya uh ph ++ rest)
    (hR : E ⊨ [zr := wwl_zero, nine := Vector.replicate 8 9, xk := XK])
    (hy : E.read (.arg ya hya) = Ty.wrap Y) (hd : [uh.i, nine.i].Nodup)
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
def loRun (a xk : Dst Γ V) (ya : Fin Γ.args.length) (hya : Γ.args[ya] = V) (t : Dst Γ V) :
    List (Instr Γ) :=
  [.ternop .vpmadd52l t (.val a.i a.h) (.val xk.i xk.h) (.arg ya hya)]

/-- Where the body at `pos` is `loRun`, `a` holds `A`, `xk` holds `XK` and argument `ya` holds
`Y`: `t` gets `wwl_madd52lo A XK Y`. -/
theorem runBodyFrom_loRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {a xk : Dst Γ V}
    {ya : Fin Γ.args.length} {hya : Γ.args[ya] = V} {t : Dst Γ V} {rest : List (Instr Γ)}
    {A XK Y : Vector (BitVec 64) 8} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} (hbody : blk.body.drop pos = loRun a xk ya hya t ++ rest)
    (hR : E ⊨ [a := A, xk := XK]) (hy : E.read (.arg ya hya) = Ty.wrap Y)
    (hK : (blk.runBodyFrom E[t := Ty.wrap (wwl_madd52lo A XK Y)] (pos + 1) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure [hy] with vt
  have h : vt = wwl_madd52lo A XK Y := by
    rw [hvt]; ext i hi : 1; simp [wwl_madd52lo, madd52lo]
  rw [hE, h, hK]

/-- The slides as shuffles, `p_k` from `a_k` (wwl_zero where read) and `t_k`, `q_k` from `t_k` and
`b_k` (wwl_zero where read), poison from lane `6`; then `p0j + p1j` as
`wwl_madd52lo(p1j, x_0, y)`. -/
def slidesRun (a1 a2 a3 b3 a4 b4 a5 b5 a6 pz t1 t2 t3 t4 t5 t6 x0 : Dst Γ V)
    (ya : Fin Γ.args.length) (hya : Γ.args[ya] = V) (p1 p2 p3 q3 p4 q4 p5 q5 p6 q6 s1 : Dst Γ V) :
    List (Instr Γ) :=
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
      (.val t6.i t6.h) (.val pz.i pz.h),
    .ternop .vpmadd52l s1 (.val p1.i p1.h) (.val x0.i x0.h) (.arg ya hya)]

/-- Where the body at `pos` is `slidesRun`, `t_k` hold `T_k`, `x0` holds `X0` and argument `ya`
holds `Y`: `tail`'s `p_kj`, its `q_kj` but lanes `6` and `7`, and
`wwl_madd52lo p1j X0 Y` in `s1`. -/
theorem runBodyFrom_slidesRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {a1 a2 a3 b3 a4 b4 a5 b5 a6 pz t1 t2 t3 t4 t5 t6 x0 : Dst Γ V} {ya : Fin Γ.args.length}
    {hya : Γ.args[ya] = V} {p1 p2 p3 q3 p4 q4 p5 q5 p6 q6 s1 : Dst Γ V} {rest : List (Instr Γ)}
    {T1 T2 T3 T4 T5 T6 X0 Y : Vector (BitVec 64) 8} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        slidesRun a1 a2 a3 b3 a4 b4 a5 b5 a6 pz t1 t2 t3 t4 t5 t6 x0 ya hya p1 p2 p3 q3 p4 q4 p5
            q5 p6 q6 s1 ++
          rest)
    (hR :
      E ⊨ [a1 := lanesFrom 7 wwl_zero, a2 := lanesFrom 6 wwl_zero, a3 := lanesFrom 5 wwl_zero, b3 :=
        lanesBelow 3 wwl_zero, a4 := lanesFrom 4 wwl_zero, b4 := lanesBelow 2 wwl_zero, a5 :=
        lanesFrom 3 wwl_zero, b5 := lanesBelow 1 wwl_zero, a6 := lanesFrom 2 wwl_zero, t1 := T1,
        t2 := T2, t3 := T3, t4 := T4, t5 := T5, t6 := T6, x0 := X0])
    (hy : E.read (.arg ya hya) = Ty.wrap Y)
    (hd :
      [a1.i, a2.i, a3.i, b3.i, a4.i, b4.i, a5.i, b5.i, a6.i, t1.i, t2.i, t3.i, t4.i, t5.i, t6.i,
          x0.i, p1.i, p2.i, p3.i, q3.i, p4.i, q4.i, p5.i, q5.i, p6.i, q6.i].Nodup)
    (hK :
      ∀ vp1 : ⟦V⟧,
        (blk.runBodyFrom
              E[p1 := vp1, p2 := Ty.wrap (wwl_slide wwl_zero T2 6), p3 :=
                Ty.wrap (wwl_slide wwl_zero T3 5), q3 := low6 (wwl_slide T3 wwl_zero 5), p4 :=
                Ty.wrap (wwl_slide wwl_zero T4 4), q4 := low6 (wwl_slide T4 wwl_zero 4), p5 :=
                Ty.wrap (wwl_slide wwl_zero T5 3), q5 := low6 (wwl_slide T5 wwl_zero 3), p6 :=
                Ty.wrap (wwl_slide wwl_zero T6 2), q6 := low6 (wwl_slide T6 wwl_zero 2), s1 :=
                Ty.wrap (wwl_madd52lo (wwl_slide wwl_zero T1 7) X0 Y)]
              (pos + 11) S >>=
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
  step_pure [hy] with vs1
  -- the shuffles' lanes as the slides they are
  simp only [lanesFrom_getElem, lanesBelow_getElem, Nat.reduceLeDiff, Nat.reduceLT, ↓reduceIte,
    Vector.getElem_replicate, BitVec.ofNat_eq_ofNat, pullWrap, wwl_slide_zero_6,
    wwl_slide_zero_5, wwl_slide_zero_4, wwl_slide_zero_3, wwl_slide_zero_2,
    low6_wwl_slide_5_zero, low6_wwl_slide_4_zero, low6_wwl_slide_3_zero,
    wwl_slide_zero_7] at hvp1 hvp2 hvp3 hvq3 hvp4 hvq4 hvp5 hvq5 hvp6 hvq6
  subst hvp1
  simp only [wrapGetElem, PoisonOr.value_bind, pullWrapOfFn] at hvs1
  have h1 : vs1 = Ty.wrap (t := V) (wwl_madd52lo (wwl_slide wwl_zero T1 7) X0 Y) := by
    rw [hvs1]; congr 1; ext i hi : 1; simp [wwl_madd52lo, madd52lo]
  subst hvp2 hvp3 hvq3 hvp4 hvq4 hvp5 hvq5 hvp6 hvq6
  rw [hE, h1]
  exact hK _

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
  subst hvs2 hvs3 hvs4 hvs5
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

end fd_r43x6_mul_fast

open fd_r43x6_mul_fast in
/-- `fd_r43x6_mul_fast` returns `spec x y` and leaves the state as it is. -/
public theorem fd_r43x6_mul_fast.call_eq (x y : Wwl) (s : GlobalState) (hwf : s.WF) :
    fd_r43x6_mul_fast.call (fd_r43x6_mul_fast.args (Ty.wrap x) (Ty.wrap y)) s =
      .value (.cons (Ty.wrap (fd_r43x6_mul_fast.spec x y)) .nil, s) := by
  func_init
  block_init
  iterate 17 step_pure
  -- the slides' `wwl_zero()` operands
  step_pattern using runBodyFrom_padRun with pad335
  step_pattern using runBodyFrom_padRun with pad343
  step_pattern using runBodyFrom_padRun with pad351
  step_pattern using runBodyFrom_padRun with pad359
  step_pattern using runBodyFrom_padRun with pad367
  step_pattern using runBodyFrom_padRun with pad375
  step_pattern using runBodyFrom_padRun with pad383
  step_pattern using runBodyFrom_padRun with pad391
  step_pattern using runBodyFrom_padRun with pad399
  step_pure with x0
  step_pure with x1
  step_pure with x2
  step_pure with x3
  step_pure with x4
  step_pure with x5
  -- `t1 … t6`: the high bits shifted up, plus the next row's low bits
  step_pattern using runBodyFrom_hiRun with ph0
  step_pattern using runBodyFrom_loRun with t1
  step_pattern using runBodyFrom_hiRun with ph1
  step_pattern using runBodyFrom_loRun with t2
  step_pattern using runBodyFrom_hiRun with ph2
  step_pattern using runBodyFrom_loRun with t3
  step_pattern using runBodyFrom_hiRun with ph3
  step_pattern using runBodyFrom_loRun with t4
  step_pattern using runBodyFrom_hiRun with ph4
  step_pattern using runBodyFrom_loRun with t5
  step_pattern using runBodyFrom_hiRun with t6
  step_pattern using runBodyFrom_slidesRun with p01j
  step_pattern using runBodyFrom_sumsRun with zh
  step_pattern using runBodyFrom_fold152Run with z
  finish_block
  subst_vars
  rw [fd_r43x6_mul_fast.spec, tail_eq]
  rfl

end MLIR.Firedancer.Avx512
