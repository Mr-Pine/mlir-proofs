module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.fd_ed25519_point_eq_z1
public import Firedancer.Lane.Common.R43x6Point
public import Firedancer.Lane.Common.Decode
public import Firedancer.Lane.Mlir.fd_ed25519_point_eq_z1
import Mathlib.Data.Fintype.Basic
import Mathlib.Tactic.FinCases

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Proof -/

section Proof


set_option hygiene false in
/-- A shuffle of `<7 x i64>` loads, lane by lane. -/
local macro "lanes7" : tactic =>
  `(tactic|
    ( apply vec_ext_fin
      intro k
      fin_cases k <;>
        simp [Quad.perm4, wwl_perm4, wwl_pack_halves, MemoryState.readQuad, readAt448_lane]))

set_option hygiene false in
/-- A step of the reductions' runs, the lanes' no-overflow facts as simp arguments. -/
local macro "nz_step" : tactic =>
  `(tactic|
    step_pure [sshiftRight40_smulOverflow, and40_add_b20, and43_add_19, and43_add_lshr43,
      tail5_add_sshr43, tail5_add_lshr43, sshr43_add_and43, sshr43_add_and40, sel19_add_and43,
      lanesBelow_getElem])

set_option hygiene false in
/-- `nz_step`, its value named `x`. -/
local macro "nz_step_with " x:ident : tactic =>
  `(tactic|
    step_pure [sshiftRight40_smulOverflow, and40_add_b20, and43_add_19, and43_add_lshr43,
      tail5_add_sshr43, tail5_add_lshr43, sshr43_add_and43, sshr43_add_and40, sel19_add_and43,
      lanesBelow_getElem] with $x:ident)

-- the patterns, also stepped where `fd_ed25519_verify_equation` inlines this function
@[expose] public section

/-- The code's `select( z_dy, z_dx, false )`, widened, from the two `is_nonzero` answers. -/
theorem zero_test_and (u v : BitVec 32) (hu : u = 0 ∨ u = 1) (hv : v = 0 ∨ v = 1) :
    BitVec.setWidth 32
        (if BitVec.ofBool (!v != 0#32) = 1#1 then BitVec.ofBool (!u != 0#32) else 0#1) =
      (if u = 0 then 1 else 0) &&& (if v = 0 then 1 else 0) := by
  rcases hu with rfl | rfl <;> rcases hv with rfl | rfl <;> decide

/-- `== 0` as the negated `!= 0`. -/
theorem ofBool_beq_zero (x : BitVec 64) :
    BitVec.ofBool (x == 0#64) = ~~~BitVec.ofBool (x != 0#64) := by
  simp [bne]

/-- `nz2Run` with the last test `== 0`: whether `fd_r43x6_is_nonzero` of `a` and of `b` is zero, in
`nz`'s lanes `0` and `1`. -/
def zr2Run (a b : Dst Γ V) (nb m40 s40 k19 b20 s43 m43 two40 m19 zero : Dst Γ V2)
    (x1 x2 x3 x4 x5 t5 y5 c5 d x0 t0 u5 c0 t1 c1 t2 c2 t3 c3 t4 y0 y1 y2 y3 c4 y4 : Dst Γ V2)
    (e0 f0 z0 e1 f1 z1 e2 f2 z2 e3 f3 z3 e4 f4 z4 w5 v5 g5 : Dst Γ V2) (q : Dst Γ B2)
    (f r0 h0 r1 h1 r2 h2 r3 h3 r4 h4 r5 o1 o2 o3 o4 o5 o6 : Dst Γ V2) (nz : Dst Γ B2) :
    List (Instr Γ) :=
  [.binop (.shufflevector #v[some 1, some 9]) x1 (.val a.i a.h) (.val b.i b.h),
    .binop (.shufflevector #v[some 2, some 10]) x2 (.val a.i a.h) (.val b.i b.h),
    .binop (.shufflevector #v[some 3, some 11]) x3 (.val a.i a.h) (.val b.i b.h),
    .binop (.shufflevector #v[some 4, some 12]) x4 (.val a.i a.h) (.val b.i b.h),
    .binop (.shufflevector #v[some 5, some 13]) x5 (.val a.i a.h) (.val b.i b.h),
    .binop (.vector (.add {})) t5 (.val x5.i x5.h) (.val nb.i nb.h),
    .binop (.vector .and) y5 (.val t5.i t5.h) (.val m40.i m40.h),
    .binop (.vector (.ashr false)) c5 (.val t5.i t5.h) (.val s40.i s40.h),
    .binop (.vector (.mul { nsw := true })) d (.val c5.i c5.h) (.val k19.i k19.h),
    .binop (.shufflevector #v[some 0, some 8]) x0 (.val a.i a.h) (.val b.i b.h),
    .binop (.vector (.add {})) t0 (.val d.i d.h) (.val x0.i x0.h),
    .binop (.vector (.add { nsw := true, nuw := true })) u5 (.val y5.i y5.h) (.val b20.i b20.h),
    .binop (.vector (.ashr false)) c0 (.val t0.i t0.h) (.val s43.i s43.h),
    .binop (.vector (.add {})) t1 (.val c0.i c0.h) (.val x1.i x1.h),
    .binop (.vector (.ashr false)) c1 (.val t1.i t1.h) (.val s43.i s43.h),
    .binop (.vector (.add {})) t2 (.val c1.i c1.h) (.val x2.i x2.h),
    .binop (.vector (.ashr false)) c2 (.val t2.i t2.h) (.val s43.i s43.h),
    .binop (.vector (.add {})) t3 (.val c2.i c2.h) (.val x3.i x3.h),
    .binop (.vector (.ashr false)) c3 (.val t3.i t3.h) (.val s43.i s43.h),
    .binop (.vector (.add {})) t4 (.val c3.i c3.h) (.val x4.i x4.h),
    .binop (.vector .and) y0 (.val t0.i t0.h) (.val m43.i m43.h),
    .binop (.vector .and) y1 (.val t1.i t1.h) (.val m43.i m43.h),
    .binop (.vector .and) y2 (.val t2.i t2.h) (.val m43.i m43.h),
    .binop (.vector .and) y3 (.val t3.i t3.h) (.val m43.i m43.h),
    .binop (.vector (.ashr false)) c4 (.val t4.i t4.h) (.val s43.i s43.h),
    .binop (.vector .and) y4 (.val t4.i t4.h) (.val m43.i m43.h),
    .binop (.vector (.add { nsw := true, nuw := true })) e0 (.val y0.i y0.h) (.val k19.i k19.h),
    .binop (.vector (.lshr false)) f0 (.val e0.i e0.h) (.val s43.i s43.h),
    .binop (.vector .and) z0 (.val e0.i e0.h) (.val m43.i m43.h),
    .binop (.vector (.add { nsw := true, nuw := true })) e1 (.val y1.i y1.h) (.val f0.i f0.h),
    .binop (.vector (.lshr false)) f1 (.val e1.i e1.h) (.val s43.i s43.h),
    .binop (.vector .and) z1 (.val e1.i e1.h) (.val m43.i m43.h),
    .binop (.vector (.add { nsw := true, nuw := true })) e2 (.val y2.i y2.h) (.val f1.i f1.h),
    .binop (.vector (.lshr false)) f2 (.val e2.i e2.h) (.val s43.i s43.h),
    .binop (.vector .and) z2 (.val e2.i e2.h) (.val m43.i m43.h),
    .binop (.vector (.add { nsw := true, nuw := true })) e3 (.val y3.i y3.h) (.val f2.i f2.h),
    .binop (.vector (.lshr false)) f3 (.val e3.i e3.h) (.val s43.i s43.h),
    .binop (.vector .and) z3 (.val e3.i e3.h) (.val m43.i m43.h),
    .binop (.vector (.add { nsw := true, nuw := true })) e4 (.val y4.i y4.h) (.val f3.i f3.h),
    .binop (.vector (.lshr false)) f4 (.val e4.i e4.h) (.val s43.i s43.h),
    .binop (.vector .and) z4 (.val e4.i e4.h) (.val m43.i m43.h),
    .binop (.vector (.add { nsw := true })) w5 (.val u5.i u5.h) (.val c4.i c4.h),
    .binop (.vector (.add { nsw := true, nuw := true })) v5 (.val w5.i w5.h) (.val f4.i f4.h),
    .binop (.vector .and) g5 (.val v5.i v5.h) (.val m40.i m40.h),
    .binop (.vector (.icmp .ult)) q (.val v5.i v5.h) (.val two40.i two40.h),
    .ternop (.vector (.select (τ := .bv 64))) f (.val q.i q.h) (.val m19.i m19.h)
      (.val zero.i zero.h),
    .binop (.vector (.add { nsw := true })) r0 (.val f.i f.h) (.val z0.i z0.h),
    .binop (.vector (.ashr false)) h0 (.val r0.i r0.h) (.val s43.i s43.h),
    .binop (.vector (.add { nsw := true })) r1 (.val h0.i h0.h) (.val z1.i z1.h),
    .binop (.vector (.ashr false)) h1 (.val r1.i r1.h) (.val s43.i s43.h),
    .binop (.vector (.add { nsw := true })) r2 (.val h1.i h1.h) (.val z2.i z2.h),
    .binop (.vector (.ashr false)) h2 (.val r2.i r2.h) (.val s43.i s43.h),
    .binop (.vector (.add { nsw := true })) r3 (.val h2.i h2.h) (.val z3.i z3.h),
    .binop (.vector (.ashr false)) h3 (.val r3.i r3.h) (.val s43.i s43.h),
    .binop (.vector (.add { nsw := true })) r4 (.val h3.i h3.h) (.val z4.i z4.h),
    .binop (.vector (.ashr false)) h4 (.val r4.i r4.h) (.val s43.i s43.h),
    .binop (.vector (.add { nsw := true })) r5 (.val h4.i h4.h) (.val g5.i g5.h),
    .binop (.vector (.or false)) o1 (.val r1.i r1.h) (.val r0.i r0.h),
    .binop (.vector (.or false)) o2 (.val o1.i o1.h) (.val r2.i r2.h),
    .binop (.vector (.or false)) o3 (.val o2.i o2.h) (.val r3.i r3.h),
    .binop (.vector (.or false)) o4 (.val o3.i o3.h) (.val r4.i r4.h),
    .binop (.vector .and) o5 (.val o4.i o4.h) (.val m43.i m43.h),
    .binop (.vector (.or false)) o6 (.val o5.i o5.h) (.val r5.i r5.h),
    .binop (.vector (.icmp .eq)) nz (.val o6.i o6.h) (.val zero.i zero.h)]

-- 64 steps over two lanes, over 200000 heartbeats
set_option maxHeartbeats 400000 in
/-- Where the body at `pos` is `zr2Run`, `a` and `b` hold lanes `0 … 5` of `A` and `B` and the
others the constants: running on from `pos` then `g` gives `K` if it does from `pos + 64` with
whether `fd_r43x6_is_nonzero` of `A` and of `B` is zero in `nz`'s lanes, whatever the intermediates
hold. -/
theorem runBodyFrom_zr2Run {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {a b : Dst Γ V}
    {nb m40 s40 k19 b20 s43 m43 two40 m19 zero : Dst Γ V2}
    {x1 x2 x3 x4 x5 t5 y5 c5 d x0 t0 u5 c0 t1 c1 t2 c2 t3 c3 t4 y0 y1 y2 y3 c4 y4 : Dst Γ V2}
    {e0 f0 z0 e1 f1 z1 e2 f2 z2 e3 f3 z3 e4 f4 z4 w5 v5 g5 : Dst Γ V2} {q : Dst Γ B2}
    {f r0 h0 r1 h1 r2 h2 r3 h3 r4 h4 r5 o1 o2 o3 o4 o5 o6 : Dst Γ V2} {nz : Dst Γ B2}
    {rest : List (Instr Γ)}
    {A B : Wwl} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = zr2Run a b nb m40 s40 k19 b20 s43 m43 two40 m19 zero x1 x2 x3 x4
        x5 t5 y5 c5 d x0 t0 u5 c0 t1 c1 t2 c2 t3 c3 t4 y0 y1 y2 y3 c4 y4 e0 f0 z0 e1 f1 z1 e2 f2 z2
        e3 f3 z3 e4 f4 z4 w5 v5 g5 q f r0 h0 r1 h1 r2 h2 r3 h3 r4 h4 r5 o1 o2 o3 o4 o5 o6 nz ++
        rest)
    (hR : E ⊨ [a := lanesBelow 6 A, b := lanesBelow 6 B])
    (hC : Nz2Consts E nb m40 s40 k19 b20 s43 m43 two40 m19 zero)
    (hd : [a.i, b.i, nb.i, m40.i, s40.i, k19.i, b20.i, s43.i, m43.i, two40.i, m19.i, zero.i, x1.i,
        x2.i, x3.i, x4.i, x5.i, t5.i, y5.i, c5.i, d.i, x0.i, t0.i, u5.i, c0.i, t1.i, c1.i, t2.i,
        c2.i, t3.i, c3.i, t4.i, y0.i, y1.i, y2.i, y3.i, c4.i, y4.i, e0.i, f0.i, z0.i, e1.i, f1.i,
        z1.i, e2.i, f2.i, z2.i, e3.i, f3.i, z3.i, e4.i, f4.i, z4.i, w5.i, v5.i, g5.i, q.i, f.i,
        r0.i, h0.i, r1.i, h1.i, r2.i, h2.i, r3.i, h3.i, r4.i, h4.i, r5.i, o1.i, o2.i, o3.i, o4.i,
        o5.i, o6.i].Nodup)
    (hK :
      ∀ (vx1 vx2 vx3 vx4 vx5 vt5 vy5 vc5 vd vx0 vt0 vu5 vc0 vt1 vc1 vt2 vc2 vt3 vc3 vt4 vy0 vy1 vy2
          vy3 vc4 vy4 ve0 vf0 vz0 ve1 vf1 vz1 ve2 vf2 vz2 ve3 vf3 vz3 ve4 vf4 vz4 vw5 vv5 vg5 vf
          vr0 vh0 vr1 vh1 vr2 vh2 vr3 vh3 vr4 vh4 vr5 vo1 vo2 vo3 vo4 vo5 vo6 : ⟦V2⟧) (vq : ⟦B2⟧),
        (blk.runBodyFrom E[x1 := vx1, x2 := vx2, x3 := vx3, x4 := vx4, x5 := vx5, t5 := vt5, y5 :=
            vy5, c5 := vc5, d := vd, x0 := vx0, t0 := vt0, u5 := vu5, c0 := vc0, t1 := vt1, c1 :=
            vc1, t2 := vt2, c2 := vc2, t3 := vt3, c3 := vc3, t4 := vt4, y0 := vy0, y1 := vy1, y2 :=
            vy2, y3 := vy3, c4 := vc4, y4 := vy4, e0 := ve0, f0 := vf0, z0 := vz0, e1 := ve1, f1 :=
            vf1, z1 := vz1, e2 := ve2, f2 := vf2, z2 := vz2, e3 := ve3, f3 := vf3, z3 := vz3, e4 :=
            ve4, f4 := vf4, z4 := vz4, w5 := vw5, v5 := vv5, g5 := vg5, q := vq, f := vf, r0 :=
            vr0, h0 := vh0, r1 := vr1, h1 := vh1, r2 := vr2, h2 := vh2, r3 := vr3, h3 := vh3, r4 :=
            vr4, h4 := vh4, r5 := vr5, o1 := vo1, o2 := vo2, o3 := vo3, o4 := vo4, o5 := vo5, o6 :=
            vo6, nz := Ty.wrap #v[~~~nzBit A, ~~~nzBit B]] (pos + 64) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  simp only [zr2Run] at hbody
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step_with vt5
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step_with vt0
  nz_step
  nz_step
  nz_step_with vt1
  nz_step
  nz_step_with vt2
  nz_step
  nz_step_with vt3
  nz_step
  nz_step_with vt4
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step_with ve0
  nz_step
  nz_step
  nz_step_with ve1
  nz_step
  nz_step
  nz_step_with ve2
  nz_step
  nz_step
  nz_step_with ve3
  nz_step
  nz_step
  nz_step_with ve4
  nz_step
  nz_step
  nz_step
  nz_step_with vv5
  nz_step
  nz_step
  nz_step
  nz_step_with vr0
  nz_step
  nz_step_with vr1
  nz_step
  nz_step_with vr2
  nz_step
  nz_step_with vr3
  nz_step
  nz_step_with vr4
  nz_step
  nz_step_with vr5
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step_with wnz
  have e : wnz = #v[~~~nzBit A, ~~~nzBit B] := by
    rw [← nzLimbs_eq, ← nzLimbs_eq]
    subst_vars
    apply vec_ext_fin
    intro i
    fin_cases i <;> exact ofBool_beq_zero _
  rw [hE, e]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

attribute [-mlir_operation] zipWith_eq_ofFn

attribute [local mlir_operation] zipWith_and_wrap zipWith_add_wrap zipWith_sub_wrap zipWith_mul_wrap
  zipWith_lshr_wrap zipWith_ashr_wrap zipWith_shl_wrap zipWith_add_nsw_wrap zipWith_add_nsw_nuw_wrap
  zipWith_sub_nsw_wrap

/-- A `<7 x i64>` load's lanes: the point vector's first seven. -/
theorem readAt448_lane {m : MemoryState} {p : Pointer} (i : Fin 7) :
    Ty.extractVecElem 7 64 i (m.readAt p 448) = (m.readVec p)[i.val] := by
  rw [MemoryState.readAt_of_readAt_le (v := 512) (w := 448) (by decide) rfl]
  simp only [MemoryState.readVec, Vector.getElem_ofFn, Ty.extractVecElem_eq]
  apply BitVec.eq_of_getLsbD_eq
  intro j hj
  have := i.isLt
  simp only [BitVec.getLsbD_extractLsb', BitVec.getLsbD_setWidth, hj, decide_true,
    Bool.true_and]
  have : i.val * 64 + j < 448 := by omega
  simp [this]

/-- Even lanes zero, odd ones poison. -/
abbrev zeroEven : ⟦.vec 8 64⟧ :=
  #v[.value 0#64, .poison, .value 0#64, .poison, .value 0#64, .poison, .value 0#64, .poison]

/-- Odd lanes zero, even ones poison. -/
abbrev zeroOdd : ⟦.vec 8 64⟧ :=
  #v[.poison, .value 0#64, .poison, .value 0#64, .poison, .value 0#64, .poison, .value 0#64]

/-- `p`'s limbs in lanes `0 … 5`, poison above. -/
abbrev pLow6 : ⟦.vec 8 64⟧ :=
  #v[.value 8796093022189#64, .value 8796093022207#64, .value 8796093022207#64,
    .value 8796093022207#64, .value 8796093022207#64, .value 1099511627775#64, .poison, .poison]

/-- `FD_R43X6_QUAD_UNPACK( xn2, xn1, yn2, yn1, M )` and `fd_r43x6_sub_fast( xn1, xn2 )`,
`fd_r43x6_sub_fast( yn1, yn2 )` as compiled: interleaves of `m03 m14` and of `m25` with the zeros
in `ze zo`, the limbs picked into `xx xy xz xt`, the differences plus `p` (in `pl`) into `dx dy`. -/
def unpackSubRun (m03 m14 m25 ze zo pl : Dst Γ V) (a b c d xx xy xz xt dx0 dx dy0 dy : Dst Γ V) :
    List (Instr Γ) :=
  [.binop (.shufflevector #v[some 0, some 8, some 2, some 10, some 4, some 12, some 6, some 14]) a
      (.val m03.i m03.h) (.val m14.i m14.h),
    .binop (.shufflevector #v[some 1, some 9, some 3, some 11, some 5, some 13, some 7, some 15]) b
      (.val m03.i m03.h) (.val m14.i m14.h),
    .binop (.shufflevector #v[some 0, some 8, some 2, some 10, some 4, some 12, some 6, some 14]) c
      (.val m25.i m25.h) (.val ze.i ze.h),
    .binop (.shufflevector #v[some 1, some 9, some 3, some 11, some 5, some 13, some 7, some 15]) d
      (.val m25.i m25.h) (.val zo.i zo.h),
    .binop (.shufflevector #v[some 0, some 1, some 8, some 4, some 5, some 12, none, none]) xx
      (.val a.i a.h) (.val c.i c.h),
    .binop (.shufflevector #v[some 0, some 1, some 8, some 4, some 5, some 12, none, none]) xy
      (.val b.i b.h) (.val d.i d.h),
    .binop (.shufflevector #v[some 2, some 3, some 10, some 6, some 7, some 14, none, none]) xz
      (.val a.i a.h) (.val c.i c.h),
    .binop (.shufflevector #v[some 2, some 3, some 10, some 6, some 7, some 14, none, none]) xt
      (.val b.i b.h) (.val d.i d.h),
    .binop (.vector (.sub {})) dx0 (.val xy.i xy.h) (.val xx.i xx.h),
    .binop (.vector (.add {})) dx (.val dx0.i dx0.h) (.val pl.i pl.h),
    .binop (.vector (.sub {})) dy0 (.val xt.i xt.h) (.val xz.i xz.h),
    .binop (.vector (.add {})) dy (.val dy0.i dy0.h) (.val pl.i pl.h)]

/-- Where the body at `pos` is `unpackSubRun` and `m03 m14 m25` hold `M`: running on from `pos` then
`g` gives `K` if it does from `pos + 12` with `fd_r43x6_sub_fast M.Y M.X` and
`fd_r43x6_sub_fast M.T M.Z`, lanes `0 … 5`, in `dx` and `dy`. -/
theorem runBodyFrom_unpackSubRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {m03 m14 m25 ze zo pl a b c d xx xy xz xt dx0 dx dy0 dy : Dst Γ V} {rest : List (Instr Γ)}
    {M03 M14 M25 : Wwl} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        unpackSubRun m03 m14 m25 ze zo pl a b c d xx xy xz xt dx0 dx dy0 dy ++ rest)
    (hR : E ⊨ [m03 := M03, m14 := M14, m25 := M25, ze := zeroEven, zo := zeroOdd, pl := pLow6])
    (hd :
      [m03.i, m14.i, m25.i, ze.i, zo.i, pl.i, a.i, b.i, c.i, d.i, xx.i, xy.i, xz.i, xt.i, dx0.i,
          dx.i, dy0.i].Nodup)
    (hK :
      ∀ (va vb vc vd vxx vxy vxz vxt vdx0 vdy0 : ⟦V⟧),
        (blk.runBodyFrom
              E[a := va, b := vb, c := vc, d := vd, xx := vxx, xy := vxy, xz := vxz, xt := vxt,
                dx0 := vdx0, dx :=
                lanesBelow 6
                  (fd_r43x6_sub_fast (Quad.Y ⟨M03, M14, M25⟩) (Quad.X ⟨M03, M14, M25⟩)),
                dy0 := vdy0, dy :=
                lanesBelow 6
                  (fd_r43x6_sub_fast (Quad.T ⟨M03, M14, M25⟩) (Quad.Z ⟨M03, M14, M25⟩))]
              (pos + 12) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  iterate 12 step_pure
  have hx :
      lanesBelow 6 (fd_r43x6_sub_fast (Quad.Y ⟨M03, M14, M25⟩) (Quad.X ⟨M03, M14, M25⟩)) =
        #v[.value (M03[1] - M03[0] + 8796093022189#64), .value (M14[1] - M14[0] + 8796093022207#64),
          .value (M25[1] - M25[0] + 8796093022207#64), .value (M03[5] - M03[4] + 8796093022207#64),
          .value (M14[5] - M14[4] + 8796093022207#64), .value (M25[5] - M25[4] + 1099511627775#64),
          .poison, .poison] := by
    apply vec_ext_fin
    intro k
    fin_cases k <;>
      simp [lanesBelow, fd_r43x6_sub_fast, fd_r43x6_p, wwl_add, wwl_sub, wwl, Quad.X, Quad.Y, m43,
        m40, add_sub_comm']
  have hy :
      lanesBelow 6 (fd_r43x6_sub_fast (Quad.T ⟨M03, M14, M25⟩) (Quad.Z ⟨M03, M14, M25⟩)) =
        #v[.value (M03[3] - M03[2] + 8796093022189#64), .value (M14[3] - M14[2] + 8796093022207#64),
          .value (M25[3] - M25[2] + 8796093022207#64), .value (M03[7] - M03[6] + 8796093022207#64),
          .value (M14[7] - M14[6] + 8796093022207#64), .value (M25[7] - M25[6] + 1099511627775#64),
          .poison, .poison] := by
    apply vec_ext_fin
    intro k
    fin_cases k <;>
      simp [lanesBelow, fd_r43x6_sub_fast, fd_r43x6_p, wwl_add, wwl_sub, wwl, Quad.T, Quad.Z, m43,
        m40, add_sub_comm']
  rw [hE, ← hx, ← hy]
  exact hK _ _ _ _ _ _ _ _ _ _

end

/-- `fd_ed25519_point_eq_z1` returns `spec` of the points at `a` and `b` and leaves the state as it
is. -/
public theorem fd_ed25519_point_eq_z1.call_eq (a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (ha : s.mem.QuadFit a) (hb : s.mem.QuadFit b) :
    _root_.Firedancer.Lane.Mlir.fd_ed25519_point_eq_z1.call
        (_root_.Firedancer.Lane.Mlir.fd_ed25519_point_eq_z1.args (.value a) (.value b)) s =
      .value (.cons (.value (fd_ed25519_point_eq_z1.spec (s.mem.readQuad a) (s.mem.readQuad b)))
        .nil, s) := by
  func_init
  block_init
  iterate 32 step_pure
  iterate 3 step_pattern using runBodyFrom_insertRun
  -- the points' first seven lanes, the permutes into `fd_r43x6_quad_mul_fast`'s operands
  step_load with xa03
  step_pure
  step_load with xa14
  step_pure
  step_load with xa25
  step_load with ya03
  step_pure
  step_load with ya14
  step_pure
  step_load with ya25
  step_pure with y03
  step_pure with y14
  step_pure with y25
  step_pure with x00
  step_pure with x11
  step_pure with x22
  step_pure with x33
  step_pure with x44
  step_pure with x55
  have ey03 : y03 = (Quad.permute 0 2 1 2 (S₀.mem.readQuad b)).P03 := by
    rw [hy03, hya03, Quad.permute_eq_perm4 (by decide)]
    lanes7
  have ey14 : y14 = (Quad.permute 0 2 1 2 (S₀.mem.readQuad b)).P14 := by
    rw [hy14, hya14, Quad.permute_eq_perm4 (by decide)]
    lanes7
  have ey25 : y25 = (Quad.permute 0 2 1 2 (S₀.mem.readQuad b)).P25 := by
    rw [hy25, hya25, Quad.permute_eq_perm4 (by decide)]
    lanes7
  have ex00 :
      x00 =
        wwl_pack_halves (Quad.permute 2 0 2 1 (S₀.mem.readQuad a)).P03 0
          (Quad.permute 2 0 2 1 (S₀.mem.readQuad a)).P03 0 := by
    rw [hx00, hxa03, Quad.permute_eq_perm4 (by decide)]
    lanes7
  have ex11 :
      x11 =
        wwl_pack_halves (Quad.permute 2 0 2 1 (S₀.mem.readQuad a)).P14 0
          (Quad.permute 2 0 2 1 (S₀.mem.readQuad a)).P14 0 := by
    rw [hx11, hxa14, Quad.permute_eq_perm4 (by decide)]
    lanes7
  have ex22 :
      x22 =
        wwl_pack_halves (Quad.permute 2 0 2 1 (S₀.mem.readQuad a)).P25 0
          (Quad.permute 2 0 2 1 (S₀.mem.readQuad a)).P25 0 := by
    rw [hx22, hxa25, Quad.permute_eq_perm4 (by decide)]
    lanes7
  have ex33 :
      x33 =
        wwl_pack_halves (Quad.permute 2 0 2 1 (S₀.mem.readQuad a)).P03 1
          (Quad.permute 2 0 2 1 (S₀.mem.readQuad a)).P03 1 := by
    rw [hx33, hxa03, Quad.permute_eq_perm4 (by decide)]
    lanes7
  have ex44 :
      x44 =
        wwl_pack_halves (Quad.permute 2 0 2 1 (S₀.mem.readQuad a)).P14 1
          (Quad.permute 2 0 2 1 (S₀.mem.readQuad a)).P14 1 := by
    rw [hx44, hxa14, Quad.permute_eq_perm4 (by decide)]
    lanes7
  have ex55 :
      x55 =
        wwl_pack_halves (Quad.permute 2 0 2 1 (S₀.mem.readQuad a)).P25 1
          (Quad.permute 2 0 2 1 (S₀.mem.readQuad a)).P25 1 := by
    rw [hx55, hxa25, Quad.permute_eq_perm4 (by decide)]
    lanes7
  clear hy03 hy14 hy25 hx00 hx11 hx22 hx33 hx44 hx55 hxa03 hxa14 hxa25 hya03 hya14 hya25
  -- FD_R43X6_QUAD_MUL_FAST( X, X, Y ), the permutes fused into its operands
  step_pattern using runBodyFrom_quadMulCoreRun
  have e3 :
      quadMul ((S₀.mem.readQuad a).permute 2 0 2 1) ((S₀.mem.readQuad b).permute 0 2 1 2) =
        ⟨m03, m14, m25⟩ := by
    rw [quadMul_eq_core, ← ex00, ← ex11, ← ex22, ← ex33, ← ex44, ← ex55, ← ey03, ← ey14, ← ey25]
    exact _hm
  clear ex00 ex11 ex22 ex33 ex44 ex55 ey03 ey14 ey25 _hm
  -- FD_R43X6_QUAD_UNPACK( xn2, xn1, yn2, yn1, X ), the differences
  step_pattern using runBodyFrom_unpackSubRun
  -- !fd_r43x6_is_nonzero( … ) & !fd_r43x6_is_nonzero( … ), over two lanes
  step_pattern using runBodyFrom_zr2Run
  iterate 4 step_pure
  finish_block
  subst hS
  simp only [fd_ed25519_point_eq_z1.spec, fd_ed25519_point_eq.spec, fd_r43x6_ge_is_eq.spec, e3]
  rw [zero_test_and _ _ (fd_r43x6_is_nonzero.spec_01 _) (fd_r43x6_is_nonzero.spec_01 _)]

end Proof

end MLIR.Firedancer.Lane
