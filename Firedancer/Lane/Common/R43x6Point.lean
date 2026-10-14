module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.QuadOps
public import Firedancer.Avx512.Common.WwlRun
import Std.Tactic.BVDecide

/-! The `FD_R43X6_QUAD_*` macros and group operations as the lane build compiles them:
`fd_r43x6_quad_sqr_fast` and `fd_r43x6_quad_mul_fast` inlined, as patterns over register variables
(the `Avx512` callee proofs' steps), and the runs they sit in. -/

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

@[expose] public section

/-! ## `fd_r43x6_quad_sqr_fast` inlined -/

section Sqr

-- folded, so the steps' terms and the specs compare without unfolding the lanes
attribute [local irreducible] wwl_add wwl_and wwl_shl wwl_slide wwl_madd52lo wwl_madd52hi

/-- A step's lanes, as the `Wwl` operation they are. -/
local macro "lanes " h:ident : tactic =>
  `(tactic|
    (rw [$h:ident]; ext i hi : 1;
      rcases i with _ | _ | _ | _ | _ | _ | _ | _ | i <;>
        simp [wwl_pack_halves, wwl_pack_h0_h1, wwl_madd52lo, wwl_madd52hi, madd52lo, madd52hi,
          wwl_add, wwl_shl, mul24_eq_shl, lanesBelow, lanesFrom] <;>
        first
        | omega
        | ac_rfl))

/-- A lane below `2^45` doubles without signed overflow. -/
theorem shl1_sshiftRight_of_lt {x : BitVec 64} (h : x < 35184372088832#64) :
    (x <<< 1).sshiftRight 1 = x := by bv_decide

/-- `FD_R43X6_QUAD_LANE_ADD_FAST( _, T, 1,0,0,0, T, X )` of folded `T`, `X`: limbs 1 and 4 double
without signed overflow. -/
theorem laneAddFast_1000_shl1 {T X : Quad} (hT : ∀ i : Fin 8, T.P14[i] < 17592186044416#64)
    (hX : ∀ i : Fin 8, X.P14[i] < 17592186044416#64) :
    ∀ k : Fin 8,
      ((T.laneAddFast 1 0 0 0 T X).P14[k] <<< 1).sshiftRight 1 =
        (T.laneAddFast 1 0 0 0 T X).P14[k] := by
  rw [Quad.laneAddFast_sel (by decide)]
  intro ⟨k, hk⟩
  apply shl1_sshiftRight_of_lt
  have h1 := hT ⟨k, hk⟩
  have h2 := hX ⟨k, hk⟩
  simp only [Fin.getElem_fin] at h1 h2
  obtain _ | _ | _ | _ | _ | _ | _ | _ | k := k
  all_goals
    first
    | omega
    | simp only [wwl_lane_sel, selV, wwl_add, Vector.getElem_ofFn, Vector.getElem_mk,
        List.getElem_toArray, List.getElem_cons_succ, List.getElem_cons_zero, Fin.getElem_fin,
        reduceGetElemLit] at h1 h2 ⊢
      bv_decide

/-- Zero in lanes `0 … 3`, poison above: built by `insertelement`s. -/
abbrev zeroLo : ⟦.vec 8 64⟧ :=
  #v[.value 0#64, .value 0#64, .value 0#64, .value 0#64, .poison, .poison, .poison, .poison]

/-- Zero in lanes `4 … 7`, poison below. -/
abbrev zeroHi : ⟦.vec 8 64⟧ :=
  #v[.poison, .poison, .poison, .poison, .value 0#64, .value 0#64, .value 0#64, .value 0#64]

/-- `fd_r43x6_quad_sqr_fast`'s body on `x03 x14 x25` (`pz` an unused operand, `lo` and `hi` zero in
lanes `0 … 3` and `4 … 7`, the others splat constants), the squares into `z03 z14 z25`; `x14`
doubled under the flags `f`. -/
def quadSqrRun (f : OverflowFlags) (x03 x14 x25 pz lo hi zero one nine seven k24 : Dst Γ V)
    (x05 x12 x34 x41 x23 x52 x4z two_x03 two_x14 two_x05 two_x12 p0a p19 a47 p28 a49 p37 a51 a52 p46
      a54 p55 h56 q1b h58 q2a h60 h61 q39 h63 h64 q48 h66 h67 h68 q57 h70 h71 q66 l73 l74 za03 l76
      l77 za14 l79 l80 l81 l82 l83 l84 l85 zb03 l87 l88 zb14 l90 l91 zb25 s93 s94 m95 z03 s97 s98
      m99 z14 s101 m102 a103 a104 a105 z25 : Dst Γ V) :
    List (Instr Γ) :=
  [.binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 12, some 13, some 14, some 15])
      x05 (.val x03.i x03.h) (.val x25.i x25.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 8, some 9, some 10, some 11]) x12
      (.val x14.i x14.h) (.val x25.i x25.h),
    .binop (.shufflevector #v[some 4, some 5, some 6, some 7, some 12, some 13, some 14, some 15])
      x34 (.val x03.i x03.h) (.val x14.i x14.h),
    .binop (.shufflevector #v[some 4, some 5, some 6, some 7, some 0, some 1, some 2, some 3]) x41
      (.val x14.i x14.h) (.val pz.i pz.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 12, some 13, some 14, some 15])
      x23 (.val x25.i x25.h) (.val x03.i x03.h),
    .binop (.shufflevector #v[some 4, some 5, some 6, some 7, some 0, some 1, some 2, some 3]) x52
      (.val x25.i x25.h) (.val pz.i pz.h),
    .binop (.shufflevector #v[some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11]) x4z
      (.val x14.i x14.h) (.val lo.i lo.h),
    .binop (.vector (.shl {})) two_x03 (.val x03.i x03.h) (.val one.i one.h),
    .binop (.vector (.shl f)) two_x14 (.val x14.i x14.h) (.val one.i one.h),
    .binop (.vector (.shl {})) two_x05 (.val x05.i x05.h) (.val one.i one.h),
    .binop (.vector (.shl {})) two_x12 (.val x12.i x12.h) (.val one.i one.h),
    .ternop .vpmadd52l p0a (.val zero.i zero.h) (.val x05.i x05.h) (.val x05.i x05.h),
    .ternop .vpmadd52l p19 (.val zero.i zero.h) (.val two_x05.i two_x05.h) (.val x14.i x14.h),
    .ternop .vpmadd52l a47 (.val zero.i zero.h) (.val x14.i x14.h) (.val x14.i x14.h),
    .ternop .vpmadd52l p28 (.val a47.i a47.h) (.val two_x03.i two_x03.h) (.val x25.i x25.h),
    .ternop .vpmadd52l a49 (.val zero.i zero.h) (.val two_x03.i two_x03.h) (.val x34.i x34.h),
    .ternop .vpmadd52l p37 (.val a49.i a49.h) (.val two_x12.i two_x12.h) (.val x25.i x25.h),
    .ternop .vpmadd52l a51 (.val zero.i zero.h) (.val x23.i x23.h) (.val x23.i x23.h),
    .ternop .vpmadd52l a52 (.val a51.i a51.h) (.val two_x05.i two_x05.h) (.val x41.i x41.h),
    .ternop .vpmadd52l p46 (.val a52.i a52.h) (.val two_x12.i two_x12.h) (.val x34.i x34.h),
    .ternop .vpmadd52l a54 (.val zero.i zero.h) (.val two_x03.i two_x03.h) (.val x52.i x52.h),
    .ternop .vpmadd52l p55 (.val a54.i a54.h) (.val two_x14.i two_x14.h) (.val x4z.i x4z.h),
    .ternop .vpmadd52h h56 (.val zero.i zero.h) (.val x05.i x05.h) (.val x05.i x05.h),
    .binop (.vector (.shl {})) q1b (.val h56.i h56.h) (.val nine.i nine.h),
    .ternop .vpmadd52h h58 (.val zero.i zero.h) (.val two_x05.i two_x05.h) (.val x14.i x14.h),
    .binop (.vector (.shl {})) q2a (.val h58.i h58.h) (.val nine.i nine.h),
    .ternop .vpmadd52h h60 (.val zero.i zero.h) (.val x14.i x14.h) (.val x14.i x14.h),
    .ternop .vpmadd52h h61 (.val h60.i h60.h) (.val two_x03.i two_x03.h) (.val x25.i x25.h),
    .binop (.vector (.shl {})) q39 (.val h61.i h61.h) (.val nine.i nine.h),
    .ternop .vpmadd52h h63 (.val zero.i zero.h) (.val two_x03.i two_x03.h) (.val x34.i x34.h),
    .ternop .vpmadd52h h64 (.val h63.i h63.h) (.val two_x12.i two_x12.h) (.val x25.i x25.h),
    .binop (.vector (.shl {})) q48 (.val h64.i h64.h) (.val nine.i nine.h),
    .ternop .vpmadd52h h66 (.val zero.i zero.h) (.val x23.i x23.h) (.val x23.i x23.h),
    .ternop .vpmadd52h h67 (.val h66.i h66.h) (.val two_x05.i two_x05.h) (.val x41.i x41.h),
    .ternop .vpmadd52h h68 (.val h67.i h67.h) (.val two_x12.i two_x12.h) (.val x34.i x34.h),
    .binop (.vector (.shl {})) q57 (.val h68.i h68.h) (.val nine.i nine.h),
    .ternop .vpmadd52h h70 (.val zero.i zero.h) (.val two_x03.i two_x03.h) (.val x52.i x52.h),
    .ternop .vpmadd52h h71 (.val h70.i h70.h) (.val two_x14.i two_x14.h) (.val x4z.i x4z.h),
    .binop (.vector (.shl {})) q66 (.val h71.i h71.h) (.val nine.i nine.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 8, some 9, some 10, some 11]) l73
      (.val p0a.i p0a.h) (.val p37.i p37.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 8, some 9, some 10, some 11]) l74
      (.val lo.i lo.h) (.val q39.i q39.h),
    .binop (.vector (.add {})) za03 (.val l74.i l74.h) (.val l73.i l73.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 8, some 9, some 10, some 11]) l76
      (.val p19.i p19.h) (.val p46.i p46.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 8, some 9, some 10, some 11]) l77
      (.val q1b.i q1b.h) (.val q48.i q48.h),
    .binop (.vector (.add {})) za14 (.val l77.i l77.h) (.val l76.i l76.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 8, some 9, some 10, some 11]) l79
      (.val p28.i p28.h) (.val p55.i p55.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 8, some 9, some 10, some 11]) l80
      (.val q2a.i q2a.h) (.val q57.i q57.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 12, some 13, some 14, some 15])
      l81 (.val lo.i lo.h) (.val p55.i p55.h),
    .binop (.shufflevector #v[some 4, some 5, some 6, some 7, some 12, some 13, some 14, some 15])
      l82 (.val p46.i p46.h) (.val p19.i p19.h),
    .binop (.shufflevector #v[some 4, some 5, some 6, some 7, some 12, some 13, some 14, some 15])
      l83 (.val q66.i q66.h) (.val q39.i q39.h),
    .binop (.vector (.add {})) l84 (.val l83.i l83.h) (.val l82.i l82.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 12, some 13, some 14, some 15])
      l85 (.val q66.i q66.h) (.val hi.i hi.h),
    .binop (.vector (.add {})) zb03 (.val l84.i l84.h) (.val l85.i l85.h),
    .binop (.shufflevector #v[some 4, some 5, some 6, some 7, some 12, some 13, some 14, some 15])
      l87 (.val p37.i p37.h) (.val p0a.i p0a.h),
    .binop (.shufflevector #v[some 4, some 5, some 6, some 7, some 12, some 13, some 14, some 15])
      l88 (.val q57.i q57.h) (.val q2a.i q2a.h),
    .binop (.vector (.add {})) zb14 (.val l88.i l88.h) (.val l87.i l87.h),
    .binop (.shufflevector #v[some 4, some 5, some 6, some 7, some 12, some 13, some 14, some 15])
      l90 (.val p28.i p28.h) (.val hi.i hi.h),
    .binop (.shufflevector #v[some 4, some 5, some 6, some 7, some 12, some 13, some 14, some 15])
      l91 (.val q48.i q48.h) (.val q1b.i q1b.h),
    .binop (.vector (.add {})) zb25 (.val l91.i l91.h) (.val l90.i l90.h),
    .binop (.vector (.shl {})) s93 (.val zb03.i zb03.h) (.val seven.i seven.h),
    .binop (.vector (.add {})) s94 (.val za03.i za03.h) (.val s93.i s93.h),
    .binop (.vector (.mul {})) m95 (.val zb03.i zb03.h) (.val k24.i k24.h),
    .binop (.vector (.add {})) z03 (.val s94.i s94.h) (.val m95.i m95.h),
    .binop (.vector (.shl {})) s97 (.val zb14.i zb14.h) (.val seven.i seven.h),
    .binop (.vector (.add {})) s98 (.val za14.i za14.h) (.val s97.i s97.h),
    .binop (.vector (.mul {})) m99 (.val zb14.i zb14.h) (.val k24.i k24.h),
    .binop (.vector (.add {})) z14 (.val s98.i s98.h) (.val m99.i m99.h),
    .binop (.vector (.shl {})) s101 (.val zb25.i zb25.h) (.val seven.i seven.h),
    .binop (.vector (.mul {})) m102 (.val zb25.i zb25.h) (.val k24.i k24.h),
    .binop (.vector (.add {})) a103 (.val l81.i l81.h) (.val l79.i l79.h),
    .binop (.vector (.add {})) a104 (.val a103.i a103.h) (.val s101.i s101.h),
    .binop (.vector (.add {})) a105 (.val a104.i a104.h) (.val m102.i m102.h),
    .binop (.vector (.add {})) z25 (.val a105.i a105.h) (.val l80.i l80.h)]

-- the 70 steps' lane identities (`lanes`) all run inside this one declaration
set_option maxHeartbeats 1000000 in
/-- Where the body at `pos` is `quadSqrRun` and `x03 x14 x25` hold `X`: running on from `pos` then
`g` gives `K` if it does from `pos + 73` with `quadSqr X` (as `m03 m14 m25`) in `z03 z14 z25`
(`X14` doubling without signed overflow if `f` says `nsw`). -/
theorem runBodyFrom_quadSqrRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {f : OverflowFlags} {x03 x14 x25 pz lo hi zero one nine seven k24 : Dst Γ V}
    {x05 x12 x34 x41 x23 x52 x4z two_x03 two_x14 two_x05 two_x12 p0a p19 a47 p28 a49 p37 a51 a52 p46
      a54 p55 h56 q1b h58 q2a h60 h61 q39 h63 h64 q48 h66 h67 h68 q57 h70 h71 q66 l73 l74 za03 l76
      l77 za14 l79 l80 l81 l82 l83 l84 l85 zb03 l87 l88 zb14 l90 l91 zb25 s93 s94 m95 z03 s97 s98
      m99 z14 s101 m102 a103 a104 a105 z25 : Dst Γ V}
    {rest : List (Instr Γ)} {X03 X14 X25 : Wwl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        quadSqrRun f x03 x14 x25 pz lo hi zero one nine seven k24 x05 x12 x34 x41 x23 x52 x4z
            two_x03 two_x14 two_x05 two_x12 p0a p19 a47 p28 a49 p37 a51 a52 p46 a54 p55 h56 q1b h58
            q2a h60 h61 q39 h63 h64 q48 h66 h67 h68 q57 h70 h71 q66 l73 l74 za03 l76 l77 za14 l79
            l80 l81 l82 l83 l84 l85 zb03 l87 l88 zb14 l90 l91 zb25 s93 s94 m95 z03 s97 s98 m99 z14
            s101 m102 a103 a104 a105 z25 ++
          rest)
    (hR :
      E ⊨ [x03 := X03, x14 := X14, x25 := X25, zero := Vector.replicate 8 0#64, one :=
        Vector.replicate 8 1#64, nine := Vector.replicate 8 9#64, seven := Vector.replicate 8 7#64,
        k24 := Vector.replicate 8 24#64])
    (hf : f.nuw = false) (ho : f.nsw = true → ∀ k : Fin 8, (X14[k] <<< 1).sshiftRight 1 = X14[k])
    (hlo : E.read (.val lo.i lo.h) = zeroLo) (hhi : E.read (.val hi.i hi.h) = zeroHi)
    (hd :
      [x03.i, x14.i, x25.i, pz.i, lo.i, hi.i, zero.i, one.i, nine.i, seven.i, k24.i, x05.i, x12.i,
          x34.i, x41.i, x23.i, x52.i, x4z.i, two_x03.i, two_x14.i, two_x05.i, two_x12.i, p0a.i,
          p19.i, a47.i, p28.i, a49.i, p37.i, a51.i, a52.i, p46.i, a54.i, p55.i, h56.i, q1b.i, h58.i,
          q2a.i, h60.i, h61.i, q39.i, h63.i, h64.i, q48.i, h66.i, h67.i, h68.i, q57.i, h70.i, h71.i,
          q66.i, l73.i, l74.i, za03.i, l76.i, l77.i, za14.i, l79.i, l80.i, l81.i, l82.i, l83.i,
          l84.i, l85.i, zb03.i, l87.i, l88.i, zb14.i, l90.i, l91.i, zb25.i, s93.i, s94.i, m95.i,
          z03.i, s97.i, s98.i, m99.i, z14.i, s101.i, m102.i, a103.i, a104.i, a105.i].Nodup)
    (hK :
      ∀
        (vx05 vx12 vx34 vx41 vx23 vx52 vx4z vtwo_x03 vtwo_x14 vtwo_x05 vtwo_x12 vp0a vp19 va47 vp28
          va49 vp37 va51 va52 vp46 va54 vp55 vh56 vq1b vh58 vq2a vh60 vh61 vq39 vh63 vh64 vq48 vh66
          vh67 vh68 vq57 vh70 vh71 vq66 vl73 vl74 vza03 vl76 vl77 vza14 vl79 vl80 vl81 vl82 vl83
          vl84 vl85 vzb03 vl87 vl88 vzb14 vl90 vl91 vzb25 vs93 vs94 vm95 vs97 vs98 vm99 vs101 vm102
          va103 va104 va105 : ⟦V⟧)
        (m03 m14 m25 : Wwl) (_hm : quadSqr ⟨X03, X14, X25⟩ = ⟨m03, m14, m25⟩),
        (blk.runBodyFrom
              E[x05 := vx05, x12 := vx12, x34 := vx34, x41 := vx41, x23 := vx23, x52 := vx52, x4z :=
                vx4z, two_x03 := vtwo_x03, two_x14 := vtwo_x14, two_x05 := vtwo_x05, two_x12 :=
                vtwo_x12, p0a := vp0a, p19 := vp19, a47 := va47, p28 := vp28, a49 := va49, p37 :=
                vp37, a51 := va51, a52 := va52, p46 := vp46, a54 := va54, p55 := vp55, h56 := vh56,
                q1b := vq1b, h58 := vh58, q2a := vq2a, h60 := vh60, h61 := vh61, q39 := vq39, h63 :=
                vh63, h64 := vh64, q48 := vq48, h66 := vh66, h67 := vh67, h68 := vh68, q57 := vq57,
                h70 := vh70, h71 := vh71, q66 := vq66, l73 := vl73, l74 := vl74, za03 := vza03,
                l76 := vl76, l77 := vl77, za14 := vza14, l79 := vl79, l80 := vl80, l81 := vl81,
                l82 := vl82, l83 := vl83, l84 := vl84, l85 := vl85, zb03 := vzb03, l87 := vl87,
                l88 := vl88, zb14 := vzb14, l90 := vl90, l91 := vl91, zb25 := vzb25, s93 := vs93,
                s94 := vs94, m95 := vm95, z03 := Ty.wrap m03, s97 := vs97, s98 := vs98, m99 := vm99,
                z14 := Ty.wrap m14, s101 := vs101, m102 := vm102, a103 := va103, a104 := va104,
                a105 := va105, z25 := Ty.wrap m25]
              (pos + 73) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with vx05
  step_pure with vx12
  step_pure with vx34
  step_pure with vx41
  step_pure with vx23
  step_pure with vx52
  step_pure with vx4z
  step_pure with vtwo_x03
  have hno :
    ∀ k : Fin 8, (f.nsw = true ∧ ¬(X14[(k : Nat)] <<< 1).sshiftRight 1 = X14[(k : Nat)]) ↔ False :=
    fun k => ⟨fun h => h.2 (ho h.1 k), False.elim⟩
  step_pure [hf, hno] with vtwo_x14
  clear hno
  step_pure with vtwo_x05
  step_pure with vtwo_x12
  step_pure with vp0a
  step_pure with vp19
  step_pure with va47
  step_pure with vp28
  step_pure with va49
  step_pure with vp37
  step_pure with va51
  step_pure with va52
  step_pure with vp46
  step_pure with va54
  step_pure with vp55
  step_pure with vh56
  step_pure with vq1b
  step_pure with vh58
  step_pure with vq2a
  step_pure with vh60
  step_pure with vh61
  step_pure with vq39
  step_pure with vh63
  step_pure with vh64
  step_pure with vq48
  step_pure with vh66
  step_pure with vh67
  step_pure with vh68
  step_pure with vq57
  step_pure with vh70
  step_pure with vh71
  step_pure with vq66
  step_pure with vl73
  step_pure with vl74
  step_pure with vza03
  step_pure with vl76
  step_pure with vl77
  step_pure with vza14
  step_pure with vl79
  step_pure with vl80
  step_pure with vl81
  step_pure with vl82
  step_pure with vl83
  step_pure with vl84
  step_pure with vl85
  step_pure with vzb03
  step_pure with vl87
  step_pure with vl88
  step_pure with vzb14
  step_pure with vl90
  step_pure with vl91
  step_pure with vzb25
  step_pure
  step_pure
  step_pure
  step_pure with vz03
  step_pure
  step_pure
  step_pure
  step_pure with vz14
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure
  step_pure with vz25
  have e_x05 : vx05 = wwl_pack_h0_h1 X03 X25 := by lanes hvx05
  have e_x12 : vx12 = wwl_pack_halves X14 0 X25 0 := by lanes hvx12
  have e_x34 : vx34 = wwl_pack_halves X03 1 X14 1 := by lanes hvx34
  have e_x41 : vx41 = wwl_pack_halves X14 1 X14 0 := by lanes hvx41
  have e_x23 : vx23 = wwl_pack_h0_h1 X25 X03 := by lanes hvx23
  have e_x52 : vx52 = wwl_pack_halves X25 1 X25 0 := by lanes hvx52
  have e_x4z : vx4z = wwl_pack_halves X14 1 wwl_zero 0 := by lanes hvx4z
  have e_two_x03 : vtwo_x03 = wwl_shl X03 1 := by lanes hvtwo_x03
  have e_two_x14 : vtwo_x14 = wwl_shl X14 1 := by lanes hvtwo_x14
  have e_two_x05 : vtwo_x05 = wwl_shl vx05 1 := by lanes hvtwo_x05
  have e_two_x12 : vtwo_x12 = wwl_shl vx12 1 := by lanes hvtwo_x12
  have e_p0a : vp0a = wwl_madd52lo wwl_zero vx05 vx05 := by lanes hvp0a
  have e_p19 : vp19 = wwl_madd52lo wwl_zero vtwo_x05 X14 := by lanes hvp19
  have e_a47 : va47 = wwl_madd52lo wwl_zero X14 X14 := by lanes hva47
  have e_p28 : vp28 = wwl_madd52lo va47 vtwo_x03 X25 := by lanes hvp28
  have e_a49 : va49 = wwl_madd52lo wwl_zero vtwo_x03 vx34 := by lanes hva49
  have e_p37 : vp37 = wwl_madd52lo va49 vtwo_x12 X25 := by lanes hvp37
  have e_a51 : va51 = wwl_madd52lo wwl_zero vx23 vx23 := by lanes hva51
  have e_a52 : va52 = wwl_madd52lo va51 vtwo_x05 vx41 := by lanes hva52
  have e_p46 : vp46 = wwl_madd52lo va52 vtwo_x12 vx34 := by lanes hvp46
  have e_a54 : va54 = wwl_madd52lo wwl_zero vtwo_x03 vx52 := by lanes hva54
  have e_p55 : vp55 = wwl_madd52lo va54 vtwo_x14 vx4z := by lanes hvp55
  have e_h56 : vh56 = wwl_madd52hi wwl_zero vx05 vx05 := by lanes hvh56
  have e_q1b : vq1b = wwl_shl vh56 9 := by lanes hvq1b
  have e_h58 : vh58 = wwl_madd52hi wwl_zero vtwo_x05 X14 := by lanes hvh58
  have e_q2a : vq2a = wwl_shl vh58 9 := by lanes hvq2a
  have e_h60 : vh60 = wwl_madd52hi wwl_zero X14 X14 := by lanes hvh60
  have e_h61 : vh61 = wwl_madd52hi vh60 vtwo_x03 X25 := by lanes hvh61
  have e_q39 : vq39 = wwl_shl vh61 9 := by lanes hvq39
  have e_h63 : vh63 = wwl_madd52hi wwl_zero vtwo_x03 vx34 := by lanes hvh63
  have e_h64 : vh64 = wwl_madd52hi vh63 vtwo_x12 X25 := by lanes hvh64
  have e_q48 : vq48 = wwl_shl vh64 9 := by lanes hvq48
  have e_h66 : vh66 = wwl_madd52hi wwl_zero vx23 vx23 := by lanes hvh66
  have e_h67 : vh67 = wwl_madd52hi vh66 vtwo_x05 vx41 := by lanes hvh67
  have e_h68 : vh68 = wwl_madd52hi vh67 vtwo_x12 vx34 := by lanes hvh68
  have e_q57 : vq57 = wwl_shl vh68 9 := by lanes hvq57
  have e_h70 : vh70 = wwl_madd52hi wwl_zero vtwo_x03 vx52 := by lanes hvh70
  have e_h71 : vh71 = wwl_madd52hi vh70 vtwo_x14 vx4z := by lanes hvh71
  have e_q66 : vq66 = wwl_shl vh71 9 := by lanes hvq66
  have e_l73 : vl73 = wwl_pack_halves vp0a 0 vp37 0 := by lanes hvl73
  have e_l74 : vl74 = wwl_pack_halves wwl_zero 0 vq39 0 := by lanes hvl74
  have e_za03 : vza03 = wwl_add vl73 vl74 := by lanes hvza03
  have e_l76 : vl76 = wwl_pack_halves vp19 0 vp46 0 := by lanes hvl76
  have e_l77 : vl77 = wwl_pack_halves vq1b 0 vq48 0 := by lanes hvl77
  have e_za14 : vza14 = wwl_add vl76 vl77 := by lanes hvza14
  have e_l79 : vl79 = wwl_pack_halves vp28 0 vp55 0 := by lanes hvl79
  have e_l80 : vl80 = wwl_pack_halves vq2a 0 vq57 0 := by lanes hvl80
  have e_l81 : vl81 = wwl_pack_h0_h1 wwl_zero vp55 := by lanes hvl81
  have e_l82 : vl82 = wwl_pack_halves vp46 1 vp19 1 := by lanes hvl82
  have e_l83 : vl83 = wwl_pack_halves vq66 1 vq39 1 := by lanes hvl83
  have e_l84 : vl84 = wwl_add vl82 vl83 := by lanes hvl84
  have e_l85 : vl85 = wwl_pack_h0_h1 vq66 wwl_zero := by lanes hvl85
  have e_zb03 : vzb03 = wwl_add vl84 vl85 := by lanes hvzb03
  have e_l87 : vl87 = wwl_pack_halves vp37 1 vp0a 1 := by lanes hvl87
  have e_l88 : vl88 = wwl_pack_halves vq57 1 vq2a 1 := by lanes hvl88
  have e_zb14 : vzb14 = wwl_add vl87 vl88 := by lanes hvzb14
  have e_l90 : vl90 = wwl_pack_halves vp28 1 wwl_zero 1 := by lanes hvl90
  have e_l91 : vl91 = wwl_pack_halves vq48 1 vq1b 1 := by lanes hvl91
  have e_zb25 : vzb25 = wwl_add vl90 vl91 := by lanes hvzb25
  have e_z03 :
    vz03 =
      wwl_add (wwl_add vza03 (wwl_shl vzb03 7)) (wwl_add (wwl_shl vzb03 4) (wwl_shl vzb03 3)) := by
    lanes hvz03
  have e_z14 :
    vz14 =
      wwl_add (wwl_add vza14 (wwl_shl vzb14 7)) (wwl_add (wwl_shl vzb14 4) (wwl_shl vzb14 3)) := by
    lanes hvz14
  have e_z25 :
    vz25 =
      wwl_add
        (wwl_add (wwl_add (wwl_add vl81 vl79) (wwl_shl vzb25 7))
          (wwl_add (wwl_shl vzb25 4) (wwl_shl vzb25 3)))
        vl80 := by
    lanes hvz25
  replace e_z25 :
    vz25 =
      wwl_add (wwl_add (wwl_add (wwl_add vl79 vl80) vl81) (wwl_shl vzb25 7))
        (wwl_add (wwl_shl vzb25 4) (wwl_shl vzb25 3)) := by
    rw [e_z25]; ac_rfl
  have e : quadSqr ⟨X03, X14, X25⟩ = ⟨vz03, vz14, vz25⟩ := by
    clear hK hE hR hlo hhi hd hbody
    clear hvx05 hvx12 hvx34 hvx41 hvx23 hvx52 hvx4z hvtwo_x03 hvtwo_x14 hvtwo_x05 hvtwo_x12 hvp0a
      hvp19 hva47 hvp28 hva49 hvp37 hva51 hva52 hvp46 hva54 hvp55 hvh56 hvq1b hvh58 hvq2a hvh60
      hvh61 hvq39 hvh63 hvh64 hvq48 hvh66 hvh67 hvh68 hvq57 hvh70 hvh71 hvq66 hvl73 hvl74 hvza03
      hvl76 hvl77 hvza14 hvl79 hvl80 hvl81 hvl82 hvl83 hvl84 hvl85 hvzb03 hvl87 hvl88 hvzb14 hvl90
      hvl91 hvzb25 hvz03 hvz14 hvz25
    subst_vars
    rfl
  rw [hE]
  exact
    hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ e

end Sqr

/-! ## `fd_r43x6_quad_mul_fast` inlined -/

section Mul

attribute [local irreducible] wwl_add wwl_and wwl_shl wwl_slide wwl_madd52lo wwl_madd52hi

/-- A step's lanes, as the `Wwl` operation they are. -/
local macro "lanes " h:ident : tactic =>
  `(tactic|
    (rw [$h:ident]; ext i hi : 1;
      rcases i with _ | _ | _ | _ | _ | _ | _ | _ | i <;>
        simp [wwl_pack_halves, wwl_madd52lo, wwl_madd52hi, madd52lo, madd52hi, wwl_add, wwl_shl,
          wwv_add_if, add_mul152] <;>
        first
        | omega
        | ac_rfl))

/-- `fd_r43x6_quad_mul_fast.spec` from its operands' halves: `x00 … x55` are `x`'s `pack_halves`. -/
def quadMulCore (x00 x11 x22 x33 x44 x55 y03 y14 y25 : Wwl) : Quad :=
  let _zz := wwl_zero
  let p0_q3 := wwl_madd52lo _zz x00 y03
  let p1_q4 := wwl_madd52lo (wwl_madd52lo _zz x11 y03) x00 y14
  let p2_q5 := wwl_madd52lo (wwl_madd52lo (wwl_madd52lo _zz x22 y03) x11 y14) x00 y25
  let p3_q6 := wwl_madd52lo (wwl_madd52lo (wwl_madd52lo _zz x33 y03) x22 y14) x11 y25
  let p4_q7 := wwl_madd52lo (wwl_madd52lo (wwl_madd52lo _zz x44 y03) x33 y14) x22 y25
  let p5_q8 := wwl_madd52lo (wwl_madd52lo (wwl_madd52lo _zz x55 y03) x44 y14) x33 y25
  let p6_q9 := wwl_madd52lo (wwl_madd52lo _zz x55 y14) x44 y25
  let p7_qa := wwl_madd52lo _zz x55 y25
  let p1_q4 := wwl_add p1_q4 (wwl_shl (wwl_madd52hi _zz x00 y03) 9)
  let p2_q5 := wwl_add p2_q5 (wwl_shl (wwl_madd52hi (wwl_madd52hi _zz x11 y03) x00 y14) 9)
  let p3_q6 :=
    wwl_add p3_q6
      (wwl_shl (wwl_madd52hi (wwl_madd52hi (wwl_madd52hi _zz x22 y03) x11 y14) x00 y25) 9)
  let p4_q7 :=
    wwl_add p4_q7
      (wwl_shl (wwl_madd52hi (wwl_madd52hi (wwl_madd52hi _zz x33 y03) x22 y14) x11 y25) 9)
  let p5_q8 :=
    wwl_add p5_q8
      (wwl_shl (wwl_madd52hi (wwl_madd52hi (wwl_madd52hi _zz x44 y03) x33 y14) x22 y25) 9)
  let p6_q9 :=
    wwl_add p6_q9
      (wwl_shl (wwl_madd52hi (wwl_madd52hi (wwl_madd52hi _zz x55 y03) x44 y14) x33 y25) 9)
  let p7_qa := wwl_add p7_qa (wwl_shl (wwl_madd52hi (wwl_madd52hi _zz x55 y14) x44 y25) 9)
  let p8_qb := wwl_shl (wwl_madd52hi _zz x55 y25) 9
  let q6_p3 := wwl_pack_halves p3_q6 1 p3_q6 0
  let q7_p4 := wwl_pack_halves p4_q7 1 p4_q7 0
  let q8_p5 := wwl_pack_halves p5_q8 1 p5_q8 0
  let za03 := wwv_add_if 0xF0 p0_q3 q6_p3 p0_q3
  let za14 := wwv_add_if 0xF0 p1_q4 q7_p4 p1_q4
  let za25 := wwv_add_if 0xF0 p2_q5 q8_p5 p2_q5
  let zb03 := wwv_add_if 0x0F p6_q9 q6_p3 p6_q9
  let zb14 := wwv_add_if 0x0F p7_qa q7_p4 p7_qa
  let zb25 := wwv_add_if 0x0F p8_qb q8_p5 p8_qb
  let z03 := wwl_add (wwl_add za03 (wwl_shl zb03 7)) (wwl_add (wwl_shl zb03 4) (wwl_shl zb03 3))
  let z14 := wwl_add (wwl_add za14 (wwl_shl zb14 7)) (wwl_add (wwl_shl zb14 4) (wwl_shl zb14 3))
  let z25 := wwl_add (wwl_add za25 (wwl_shl zb25 7)) (wwl_add (wwl_shl zb25 4) (wwl_shl zb25 3))
  ⟨z03, z14, z25⟩

/-- `quadMul` through `quadMulCore`. -/
theorem quadMul_eq_core (X Y : Quad) :
    quadMul X Y =
      quadMulCore (wwl_pack_halves X.P03 0 X.P03 0) (wwl_pack_halves X.P14 0 X.P14 0)
        (wwl_pack_halves X.P25 0 X.P25 0) (wwl_pack_halves X.P03 1 X.P03 1)
        (wwl_pack_halves X.P14 1 X.P14 1) (wwl_pack_halves X.P25 1 X.P25 1) Y.P03 Y.P14 Y.P25 :=
  rfl

/-- `fd_r43x6_quad_mul_fast`'s body after the operand halves `x00 … x55` (`pz` an unused operand,
the others splat constants), the products into `z03 z14 z25`. -/
def quadMulCoreRun (x00 x11 x22 x33 x44 x55 y03 y14 y25 pz zero nine seven k24 : Dst Γ V)
    (p0_q3 a12 p1_q4 a14 a15 p2_q5 a17 a18 p3_q6 a20 a21 p4_q7 a23 a24 p5_q8 a26 p6_q9 h29 s30
      p1_q4' h32 h33 s34 p2_q5' h36 h37 h38 s39 p3_q6' h41 h42 h43 s44 p4_q7' h46 h47 h48 s49 p5_q8'
      h51 h52 h53 s54 p6_q9' h56 h57 s58 p7_qa' h60 p8_qb q6_p3 q7_p4 q8_p5 t0 za03 t1 za14 t2 za25
      t3 zb03 t4 zb14 t5 zb25 t6 t7 t8 z03 t9 t10 t11 z14 t12 t13 t14 z25 : Dst Γ V) :
    List (Instr Γ) :=
  [.ternop .vpmadd52l p0_q3 (.val zero.i zero.h) (.val x00.i x00.h) (.val y03.i y03.h),
    .ternop .vpmadd52l a12 (.val zero.i zero.h) (.val x11.i x11.h) (.val y03.i y03.h),
    .ternop .vpmadd52l p1_q4 (.val a12.i a12.h) (.val x00.i x00.h) (.val y14.i y14.h),
    .ternop .vpmadd52l a14 (.val zero.i zero.h) (.val x22.i x22.h) (.val y03.i y03.h),
    .ternop .vpmadd52l a15 (.val a14.i a14.h) (.val x11.i x11.h) (.val y14.i y14.h),
    .ternop .vpmadd52l p2_q5 (.val a15.i a15.h) (.val x00.i x00.h) (.val y25.i y25.h),
    .ternop .vpmadd52l a17 (.val zero.i zero.h) (.val x33.i x33.h) (.val y03.i y03.h),
    .ternop .vpmadd52l a18 (.val a17.i a17.h) (.val x22.i x22.h) (.val y14.i y14.h),
    .ternop .vpmadd52l p3_q6 (.val a18.i a18.h) (.val x11.i x11.h) (.val y25.i y25.h),
    .ternop .vpmadd52l a20 (.val zero.i zero.h) (.val x44.i x44.h) (.val y03.i y03.h),
    .ternop .vpmadd52l a21 (.val a20.i a20.h) (.val x33.i x33.h) (.val y14.i y14.h),
    .ternop .vpmadd52l p4_q7 (.val a21.i a21.h) (.val x22.i x22.h) (.val y25.i y25.h),
    .ternop .vpmadd52l a23 (.val zero.i zero.h) (.val x55.i x55.h) (.val y03.i y03.h),
    .ternop .vpmadd52l a24 (.val a23.i a23.h) (.val x44.i x44.h) (.val y14.i y14.h),
    .ternop .vpmadd52l p5_q8 (.val a24.i a24.h) (.val x33.i x33.h) (.val y25.i y25.h),
    .ternop .vpmadd52l a26 (.val zero.i zero.h) (.val x55.i x55.h) (.val y14.i y14.h),
    .ternop .vpmadd52l p6_q9 (.val a26.i a26.h) (.val x44.i x44.h) (.val y25.i y25.h),
    .ternop .vpmadd52h h29 (.val zero.i zero.h) (.val x00.i x00.h) (.val y03.i y03.h),
    .binop (.vector (.shl {})) s30 (.val h29.i h29.h) (.val nine.i nine.h),
    .binop (.vector (.add {})) p1_q4' (.val s30.i s30.h) (.val p1_q4.i p1_q4.h),
    .ternop .vpmadd52h h32 (.val zero.i zero.h) (.val x11.i x11.h) (.val y03.i y03.h),
    .ternop .vpmadd52h h33 (.val h32.i h32.h) (.val x00.i x00.h) (.val y14.i y14.h),
    .binop (.vector (.shl {})) s34 (.val h33.i h33.h) (.val nine.i nine.h),
    .binop (.vector (.add {})) p2_q5' (.val s34.i s34.h) (.val p2_q5.i p2_q5.h),
    .ternop .vpmadd52h h36 (.val zero.i zero.h) (.val x22.i x22.h) (.val y03.i y03.h),
    .ternop .vpmadd52h h37 (.val h36.i h36.h) (.val x11.i x11.h) (.val y14.i y14.h),
    .ternop .vpmadd52h h38 (.val h37.i h37.h) (.val x00.i x00.h) (.val y25.i y25.h),
    .binop (.vector (.shl {})) s39 (.val h38.i h38.h) (.val nine.i nine.h),
    .binop (.vector (.add {})) p3_q6' (.val s39.i s39.h) (.val p3_q6.i p3_q6.h),
    .ternop .vpmadd52h h41 (.val zero.i zero.h) (.val x33.i x33.h) (.val y03.i y03.h),
    .ternop .vpmadd52h h42 (.val h41.i h41.h) (.val x22.i x22.h) (.val y14.i y14.h),
    .ternop .vpmadd52h h43 (.val h42.i h42.h) (.val x11.i x11.h) (.val y25.i y25.h),
    .binop (.vector (.shl {})) s44 (.val h43.i h43.h) (.val nine.i nine.h),
    .binop (.vector (.add {})) p4_q7' (.val s44.i s44.h) (.val p4_q7.i p4_q7.h),
    .ternop .vpmadd52h h46 (.val zero.i zero.h) (.val x44.i x44.h) (.val y03.i y03.h),
    .ternop .vpmadd52h h47 (.val h46.i h46.h) (.val x33.i x33.h) (.val y14.i y14.h),
    .ternop .vpmadd52h h48 (.val h47.i h47.h) (.val x22.i x22.h) (.val y25.i y25.h),
    .binop (.vector (.shl {})) s49 (.val h48.i h48.h) (.val nine.i nine.h),
    .binop (.vector (.add {})) p5_q8' (.val s49.i s49.h) (.val p5_q8.i p5_q8.h),
    .ternop .vpmadd52h h51 (.val zero.i zero.h) (.val x55.i x55.h) (.val y03.i y03.h),
    .ternop .vpmadd52h h52 (.val h51.i h51.h) (.val x44.i x44.h) (.val y14.i y14.h),
    .ternop .vpmadd52h h53 (.val h52.i h52.h) (.val x33.i x33.h) (.val y25.i y25.h),
    .binop (.vector (.shl {})) s54 (.val h53.i h53.h) (.val nine.i nine.h),
    .binop (.vector (.add {})) p6_q9' (.val s54.i s54.h) (.val p6_q9.i p6_q9.h),
    .ternop .vpmadd52h h56 (.val zero.i zero.h) (.val x55.i x55.h) (.val y14.i y14.h),
    .ternop .vpmadd52h h57 (.val h56.i h56.h) (.val x44.i x44.h) (.val y25.i y25.h),
    .binop (.vector (.shl {})) s58 (.val h57.i h57.h) (.val nine.i nine.h),
    .ternop .vpmadd52l p7_qa' (.val s58.i s58.h) (.val x55.i x55.h) (.val y25.i y25.h),
    .ternop .vpmadd52h h60 (.val zero.i zero.h) (.val x55.i x55.h) (.val y25.i y25.h),
    .binop (.vector (.shl {})) p8_qb (.val h60.i h60.h) (.val nine.i nine.h),
    .binop (.shufflevector #v[some 4, some 5, some 6, some 7, some 0, some 1, some 2, some 3]) q6_p3
      (.val p3_q6'.i p3_q6'.h) (.val pz.i pz.h),
    .binop (.shufflevector #v[some 4, some 5, some 6, some 7, some 0, some 1, some 2, some 3]) q7_p4
      (.val p4_q7'.i p4_q7'.h) (.val pz.i pz.h),
    .binop (.shufflevector #v[some 4, some 5, some 6, some 7, some 0, some 1, some 2, some 3]) q8_p5
      (.val p5_q8'.i p5_q8'.h) (.val pz.i pz.h),
    .binop (.vector (.add {})) t0 (.val q6_p3.i q6_p3.h) (.val p0_q3.i p0_q3.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 12, some 13, some 14, some 15])
      za03 (.val p0_q3.i p0_q3.h) (.val t0.i t0.h),
    .binop (.vector (.add {})) t1 (.val q7_p4.i q7_p4.h) (.val p1_q4'.i p1_q4'.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 12, some 13, some 14, some 15])
      za14 (.val p1_q4'.i p1_q4'.h) (.val t1.i t1.h),
    .binop (.vector (.add {})) t2 (.val q8_p5.i q8_p5.h) (.val p2_q5'.i p2_q5'.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 12, some 13, some 14, some 15])
      za25 (.val p2_q5'.i p2_q5'.h) (.val t2.i t2.h),
    .binop (.vector (.add {})) t3 (.val p6_q9'.i p6_q9'.h) (.val q6_p3.i q6_p3.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 12, some 13, some 14, some 15])
      zb03 (.val t3.i t3.h) (.val p6_q9'.i p6_q9'.h),
    .binop (.vector (.add {})) t4 (.val p7_qa'.i p7_qa'.h) (.val q7_p4.i q7_p4.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 12, some 13, some 14, some 15])
      zb14 (.val t4.i t4.h) (.val p7_qa'.i p7_qa'.h),
    .binop (.vector (.add {})) t5 (.val p8_qb.i p8_qb.h) (.val q8_p5.i q8_p5.h),
    .binop (.shufflevector #v[some 0, some 1, some 2, some 3, some 12, some 13, some 14, some 15])
      zb25 (.val t5.i t5.h) (.val p8_qb.i p8_qb.h),
    .binop (.vector (.shl {})) t6 (.val zb03.i zb03.h) (.val seven.i seven.h),
    .binop (.vector (.add {})) t7 (.val t6.i t6.h) (.val za03.i za03.h),
    .binop (.vector (.mul {})) t8 (.val zb03.i zb03.h) (.val k24.i k24.h),
    .binop (.vector (.add {})) z03 (.val t7.i t7.h) (.val t8.i t8.h),
    .binop (.vector (.shl {})) t9 (.val zb14.i zb14.h) (.val seven.i seven.h),
    .binop (.vector (.add {})) t10 (.val t9.i t9.h) (.val za14.i za14.h),
    .binop (.vector (.mul {})) t11 (.val zb14.i zb14.h) (.val k24.i k24.h),
    .binop (.vector (.add {})) z14 (.val t10.i t10.h) (.val t11.i t11.h),
    .binop (.vector (.shl {})) t12 (.val zb25.i zb25.h) (.val seven.i seven.h),
    .binop (.vector (.add {})) t13 (.val t12.i t12.h) (.val za25.i za25.h),
    .binop (.vector (.mul {})) t14 (.val zb25.i zb25.h) (.val k24.i k24.h),
    .binop (.vector (.add {})) z25 (.val t13.i t13.h) (.val t14.i t14.h)]

-- the 60 steps' lane identities (`lanes`) all run inside this one declaration
set_option maxHeartbeats 1000000 in
/-- Where the body at `pos` is `quadMulCoreRun`, `x00 … x55` hold `X00 … X55` and `y03 y14 y25` hold
`Y`: running on from `pos` then `g` gives `K` if it does from `pos + 77` with
`quadMulCore X00 … Y25` (as `m03 m14 m25`) in `z03 z14 z25`. -/
theorem runBodyFrom_quadMulCoreRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x00 x11 x22 x33 x44 x55 y03 y14 y25 pz zero nine seven k24 : Dst Γ V}
    {p0_q3 a12 p1_q4 a14 a15 p2_q5 a17 a18 p3_q6 a20 a21 p4_q7 a23 a24 p5_q8 a26 p6_q9 h29 s30
      p1_q4' h32 h33 s34 p2_q5' h36 h37 h38 s39 p3_q6' h41 h42 h43 s44 p4_q7' h46 h47 h48 s49 p5_q8'
      h51 h52 h53 s54 p6_q9' h56 h57 s58 p7_qa' h60 p8_qb q6_p3 q7_p4 q8_p5 t0 za03 t1 za14 t2 za25
      t3 zb03 t4 zb14 t5 zb25 t6 t7 t8 z03 t9 t10 t11 z14 t12 t13 t14 z25 : Dst Γ V}
    {rest : List (Instr Γ)} {X00 X11 X22 X33 X44 X55 Y03 Y14 Y25 : Wwl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        quadMulCoreRun x00 x11 x22 x33 x44 x55 y03 y14 y25 pz zero nine seven k24 p0_q3 a12 p1_q4
            a14 a15 p2_q5 a17 a18 p3_q6 a20 a21 p4_q7 a23 a24 p5_q8 a26 p6_q9 h29 s30 p1_q4' h32 h33
            s34 p2_q5' h36 h37 h38 s39 p3_q6' h41 h42 h43 s44 p4_q7' h46 h47 h48 s49 p5_q8' h51 h52
            h53 s54 p6_q9' h56 h57 s58 p7_qa' h60 p8_qb q6_p3 q7_p4 q8_p5 t0 za03 t1 za14 t2 za25 t3
            zb03 t4 zb14 t5 zb25 t6 t7 t8 z03 t9 t10 t11 z14 t12 t13 t14 z25 ++
          rest)
    (hR :
      E ⊨ [x00 := X00, x11 := X11, x22 := X22, x33 := X33, x44 := X44, x55 := X55, y03 := Y03,
        y14 := Y14, y25 := Y25, zero := Vector.replicate 8 0#64, nine := Vector.replicate 8 9#64,
        seven := Vector.replicate 8 7#64, k24 := Vector.replicate 8 24#64])
    (hd :
      [x00.i, x11.i, x22.i, x33.i, x44.i, x55.i, y03.i, y14.i, y25.i, pz.i, zero.i, nine.i, seven.i,
          k24.i, p0_q3.i, a12.i, p1_q4.i, a14.i, a15.i, p2_q5.i, a17.i, a18.i, p3_q6.i, a20.i,
          a21.i, p4_q7.i, a23.i, a24.i, p5_q8.i, a26.i, p6_q9.i, h29.i, s30.i, p1_q4'.i, h32.i,
          h33.i, s34.i, p2_q5'.i, h36.i, h37.i, h38.i, s39.i, p3_q6'.i, h41.i, h42.i, h43.i, s44.i,
          p4_q7'.i, h46.i, h47.i, h48.i, s49.i, p5_q8'.i, h51.i, h52.i, h53.i, s54.i, p6_q9'.i,
          h56.i, h57.i, s58.i, p7_qa'.i, h60.i, p8_qb.i, q6_p3.i, q7_p4.i, q8_p5.i, t0.i, za03.i,
          t1.i, za14.i, t2.i, za25.i, t3.i, zb03.i, t4.i, zb14.i, t5.i, zb25.i, t6.i, t7.i, t8.i,
          z03.i, t9.i, t10.i, t11.i, z14.i, t12.i, t13.i, t14.i].Nodup)
    (hK :
      ∀
        (vp0_q3 va12 vp1_q4 va14 va15 vp2_q5 va17 va18 vp3_q6 va20 va21 vp4_q7 va23 va24 vp5_q8 va26
          vp6_q9 vh29 vs30 vp1_q4' vh32 vh33 vs34 vp2_q5' vh36 vh37 vh38 vs39 vp3_q6' vh41 vh42 vh43
          vs44 vp4_q7' vh46 vh47 vh48 vs49 vp5_q8' vh51 vh52 vh53 vs54 vp6_q9' vh56 vh57 vs58
          vp7_qa' vh60 vp8_qb vq6_p3 vq7_p4 vq8_p5 vt0 vza03 vt1 vza14 vt2 vza25 vt3 vzb03 vt4 vzb14
          vt5 vzb25 vt6 vt7 vt8 vt9 vt10 vt11 vt12 vt13 vt14 : ⟦V⟧)
        (m03 m14 m25 : Wwl)
        (_hm : quadMulCore X00 X11 X22 X33 X44 X55 Y03 Y14 Y25 = ⟨m03, m14, m25⟩),
        (blk.runBodyFrom
              E[p0_q3 := vp0_q3, a12 := va12, p1_q4 := vp1_q4, a14 := va14, a15 := va15, p2_q5 :=
                vp2_q5, a17 := va17, a18 := va18, p3_q6 := vp3_q6, a20 := va20, a21 := va21,
                p4_q7 := vp4_q7, a23 := va23, a24 := va24, p5_q8 := vp5_q8, a26 := va26, p6_q9 :=
                vp6_q9, h29 := vh29, s30 := vs30, p1_q4' := vp1_q4', h32 := vh32, h33 := vh33,
                s34 := vs34, p2_q5' := vp2_q5', h36 := vh36, h37 := vh37, h38 := vh38, s39 := vs39,
                p3_q6' := vp3_q6', h41 := vh41, h42 := vh42, h43 := vh43, s44 := vs44, p4_q7' :=
                vp4_q7', h46 := vh46, h47 := vh47, h48 := vh48, s49 := vs49, p5_q8' := vp5_q8',
                h51 := vh51, h52 := vh52, h53 := vh53, s54 := vs54, p6_q9' := vp6_q9', h56 := vh56,
                h57 := vh57, s58 := vs58, p7_qa' := vp7_qa', h60 := vh60, p8_qb := vp8_qb, q6_p3 :=
                vq6_p3, q7_p4 := vq7_p4, q8_p5 := vq8_p5, t0 := vt0, za03 := vza03, t1 := vt1,
                za14 := vza14, t2 := vt2, za25 := vza25, t3 := vt3, zb03 := vzb03, t4 := vt4,
                zb14 := vzb14, t5 := vt5, zb25 := vzb25, t6 := vt6, t7 := vt7, t8 := vt8, z03 :=
                Ty.wrap m03, t9 := vt9, t10 := vt10, t11 := vt11, z14 := Ty.wrap m14, t12 := vt12,
                t13 := vt13, t14 := vt14, z25 := Ty.wrap m25]
              (pos + 77) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with vp0_q3
  step_pure with va12
  step_pure with vp1_q4
  step_pure with va14
  step_pure with va15
  step_pure with vp2_q5
  step_pure with va17
  step_pure with va18
  step_pure with vp3_q6
  step_pure with va20
  step_pure with va21
  step_pure with vp4_q7
  step_pure with va23
  step_pure with va24
  step_pure with vp5_q8
  step_pure with va26
  step_pure with vp6_q9
  step_pure with vh29
  step_pure with vs30
  step_pure with vp1_q4'
  step_pure with vh32
  step_pure with vh33
  step_pure with vs34
  step_pure with vp2_q5'
  step_pure with vh36
  step_pure with vh37
  step_pure with vh38
  step_pure with vs39
  step_pure with vp3_q6'
  step_pure with vh41
  step_pure with vh42
  step_pure with vh43
  step_pure with vs44
  step_pure with vp4_q7'
  step_pure with vh46
  step_pure with vh47
  step_pure with vh48
  step_pure with vs49
  step_pure with vp5_q8'
  step_pure with vh51
  step_pure with vh52
  step_pure with vh53
  step_pure with vs54
  step_pure with vp6_q9'
  step_pure with vh56
  step_pure with vh57
  step_pure with vs58
  step_pure with vp7_qa'
  step_pure with vh60
  step_pure with vp8_qb
  step_pure with vq6_p3
  step_pure with vq7_p4
  step_pure with vq8_p5
  step_pure
  step_pure with vza03
  step_pure
  step_pure with vza14
  step_pure
  step_pure with vza25
  step_pure
  step_pure with vzb03
  step_pure
  step_pure with vzb14
  step_pure
  step_pure with vzb25
  step_pure
  step_pure
  step_pure
  step_pure with vz03
  step_pure
  step_pure
  step_pure
  step_pure with vz14
  step_pure
  step_pure
  step_pure
  step_pure with vz25
  have e_p0_q3 : vp0_q3 = wwl_madd52lo wwl_zero X00 Y03 := by lanes hvp0_q3
  have e_a12 : va12 = wwl_madd52lo wwl_zero X11 Y03 := by lanes hva12
  have e_p1_q4 : vp1_q4 = wwl_madd52lo va12 X00 Y14 := by lanes hvp1_q4
  have e_a14 : va14 = wwl_madd52lo wwl_zero X22 Y03 := by lanes hva14
  have e_a15 : va15 = wwl_madd52lo va14 X11 Y14 := by lanes hva15
  have e_p2_q5 : vp2_q5 = wwl_madd52lo va15 X00 Y25 := by lanes hvp2_q5
  have e_a17 : va17 = wwl_madd52lo wwl_zero X33 Y03 := by lanes hva17
  have e_a18 : va18 = wwl_madd52lo va17 X22 Y14 := by lanes hva18
  have e_p3_q6 : vp3_q6 = wwl_madd52lo va18 X11 Y25 := by lanes hvp3_q6
  have e_a20 : va20 = wwl_madd52lo wwl_zero X44 Y03 := by lanes hva20
  have e_a21 : va21 = wwl_madd52lo va20 X33 Y14 := by lanes hva21
  have e_p4_q7 : vp4_q7 = wwl_madd52lo va21 X22 Y25 := by lanes hvp4_q7
  have e_a23 : va23 = wwl_madd52lo wwl_zero X55 Y03 := by lanes hva23
  have e_a24 : va24 = wwl_madd52lo va23 X44 Y14 := by lanes hva24
  have e_p5_q8 : vp5_q8 = wwl_madd52lo va24 X33 Y25 := by lanes hvp5_q8
  have e_a26 : va26 = wwl_madd52lo wwl_zero X55 Y14 := by lanes hva26
  have e_p6_q9 : vp6_q9 = wwl_madd52lo va26 X44 Y25 := by lanes hvp6_q9
  have e_h29 : vh29 = wwl_madd52hi wwl_zero X00 Y03 := by lanes hvh29
  have e_s30 : vs30 = wwl_shl vh29 9 := by lanes hvs30
  have e_p1_q4' : vp1_q4' = wwl_add vp1_q4 vs30 := by lanes hvp1_q4'
  have e_h32 : vh32 = wwl_madd52hi wwl_zero X11 Y03 := by lanes hvh32
  have e_h33 : vh33 = wwl_madd52hi vh32 X00 Y14 := by lanes hvh33
  have e_s34 : vs34 = wwl_shl vh33 9 := by lanes hvs34
  have e_p2_q5' : vp2_q5' = wwl_add vp2_q5 vs34 := by lanes hvp2_q5'
  have e_h36 : vh36 = wwl_madd52hi wwl_zero X22 Y03 := by lanes hvh36
  have e_h37 : vh37 = wwl_madd52hi vh36 X11 Y14 := by lanes hvh37
  have e_h38 : vh38 = wwl_madd52hi vh37 X00 Y25 := by lanes hvh38
  have e_s39 : vs39 = wwl_shl vh38 9 := by lanes hvs39
  have e_p3_q6' : vp3_q6' = wwl_add vp3_q6 vs39 := by lanes hvp3_q6'
  have e_h41 : vh41 = wwl_madd52hi wwl_zero X33 Y03 := by lanes hvh41
  have e_h42 : vh42 = wwl_madd52hi vh41 X22 Y14 := by lanes hvh42
  have e_h43 : vh43 = wwl_madd52hi vh42 X11 Y25 := by lanes hvh43
  have e_s44 : vs44 = wwl_shl vh43 9 := by lanes hvs44
  have e_p4_q7' : vp4_q7' = wwl_add vp4_q7 vs44 := by lanes hvp4_q7'
  have e_h46 : vh46 = wwl_madd52hi wwl_zero X44 Y03 := by lanes hvh46
  have e_h47 : vh47 = wwl_madd52hi vh46 X33 Y14 := by lanes hvh47
  have e_h48 : vh48 = wwl_madd52hi vh47 X22 Y25 := by lanes hvh48
  have e_s49 : vs49 = wwl_shl vh48 9 := by lanes hvs49
  have e_p5_q8' : vp5_q8' = wwl_add vp5_q8 vs49 := by lanes hvp5_q8'
  have e_h51 : vh51 = wwl_madd52hi wwl_zero X55 Y03 := by lanes hvh51
  have e_h52 : vh52 = wwl_madd52hi vh51 X44 Y14 := by lanes hvh52
  have e_h53 : vh53 = wwl_madd52hi vh52 X33 Y25 := by lanes hvh53
  have e_s54 : vs54 = wwl_shl vh53 9 := by lanes hvs54
  have e_p6_q9' : vp6_q9' = wwl_add vp6_q9 vs54 := by lanes hvp6_q9'
  have e_h56 : vh56 = wwl_madd52hi wwl_zero X55 Y14 := by lanes hvh56
  have e_h57 : vh57 = wwl_madd52hi vh56 X44 Y25 := by lanes hvh57
  have e_s58 : vs58 = wwl_shl vh57 9 := by lanes hvs58
  have e_p7_qa' : vp7_qa' = wwl_add (wwl_madd52lo wwl_zero X55 Y25) vs58 := by lanes hvp7_qa'
  have e_h60 : vh60 = wwl_madd52hi wwl_zero X55 Y25 := by lanes hvh60
  have e_p8_qb : vp8_qb = wwl_shl vh60 9 := by lanes hvp8_qb
  have e_q6_p3 : vq6_p3 = wwl_pack_halves vp3_q6' 1 vp3_q6' 0 := by lanes hvq6_p3
  have e_q7_p4 : vq7_p4 = wwl_pack_halves vp4_q7' 1 vp4_q7' 0 := by lanes hvq7_p4
  have e_q8_p5 : vq8_p5 = wwl_pack_halves vp5_q8' 1 vp5_q8' 0 := by lanes hvq8_p5
  have e_za03 : vza03 = wwv_add_if 0xF0 vp0_q3 vq6_p3 vp0_q3 := by lanes hvza03
  have e_za14 : vza14 = wwv_add_if 0xF0 vp1_q4' vq7_p4 vp1_q4' := by lanes hvza14
  have e_za25 : vza25 = wwv_add_if 0xF0 vp2_q5' vq8_p5 vp2_q5' := by lanes hvza25
  have e_zb03 : vzb03 = wwv_add_if 0x0F vp6_q9' vq6_p3 vp6_q9' := by lanes hvzb03
  have e_zb14 : vzb14 = wwv_add_if 0x0F vp7_qa' vq7_p4 vp7_qa' := by lanes hvzb14
  have e_zb25 : vzb25 = wwv_add_if 0x0F vp8_qb vq8_p5 vp8_qb := by lanes hvzb25
  have e_z03 :
    vz03 =
      wwl_add (wwl_add vza03 (wwl_shl vzb03 7)) (wwl_add (wwl_shl vzb03 4) (wwl_shl vzb03 3)) := by
    lanes hvz03
  have e_z14 :
    vz14 =
      wwl_add (wwl_add vza14 (wwl_shl vzb14 7)) (wwl_add (wwl_shl vzb14 4) (wwl_shl vzb14 3)) := by
    lanes hvz14
  have e_z25 :
    vz25 =
      wwl_add (wwl_add vza25 (wwl_shl vzb25 7)) (wwl_add (wwl_shl vzb25 4) (wwl_shl vzb25 3)) := by
    lanes hvz25
  have e : quadMulCore X00 X11 X22 X33 X44 X55 Y03 Y14 Y25 = ⟨vz03, vz14, vz25⟩ := by
    clear hK hE hR hd hbody
    clear hvp0_q3 hva12 hvp1_q4 hva14 hva15 hvp2_q5 hva17 hva18 hvp3_q6 hva20 hva21 hvp4_q7 hva23
      hva24 hvp5_q8 hva26 hvp6_q9 hvh29 hvs30 hvp1_q4' hvh32 hvh33 hvs34 hvp2_q5' hvh36 hvh37 hvh38
      hvs39 hvp3_q6' hvh41 hvh42 hvh43 hvs44 hvp4_q7' hvh46 hvh47 hvh48 hvs49 hvp5_q8' hvh51 hvh52
      hvh53 hvs54 hvp6_q9' hvh56 hvh57 hvs58 hvp7_qa' hvh60 hvp8_qb hvq6_p3 hvq7_p4 hvq8_p5 hvza03
      hvza14 hvza25 hvzb03 hvzb14 hvzb25 hvz03 hvz14 hvz25
    subst_vars
    rfl
  rw [hE]
  exact
    hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ e

end Mul

/-! ## `FD_R43X6_QUAD_FOLD_SIGNED` with the limb-5 sum reordered -/

/-- `Quad.foldSignedC'` with limb 5 as `(low bits + bias) + Ph14`. -/
def _root_.MLIR.Firedancer.Avx512.Quad.foldSignedC2 (P : Quad) : Quad :=
  let d03 := wwl_add P.P03 negBias03
  let d14 := wwl_add P.P14 (Vector.replicate 8 18446744073708503040#64)
  let d25 := wwl_add P.P25 (Vector.replicate 8 18446744073708503040#64)
  let h03 := wwl_shr_vector d03 (Vector.replicate 8 43#64)
  let h14 := wwl_shr_vector d14 (Vector.replicate 8 43#64)
  let h25 := wwl_shr_vector d25 s4340
  ⟨wwl_add (wwl_add (wwl_pack_halves (wwl_mul h25 (wwl_bcast 19#64)) 1 h25 0) bias03)
      (wwl_and d03 (Vector.replicate 8 8796093022207#64)),
    wwl_add
      (wwl_add (wwl_and d14 (Vector.replicate 8 8796093022207#64)) (Vector.replicate 8 1048576#64))
      h03,
    wwl_add (wwl_add (wwl_and d25 m4340) (Vector.replicate 8 1048576#64)) h14⟩

theorem _root_.MLIR.Firedancer.Avx512.Quad.foldSignedC_eq2 (P : Quad) :
    P.foldSignedC = P.foldSignedC2 := by
  rw [Quad.foldSignedC_eq']
  simp only [Quad.foldSignedC', Quad.foldSignedC2, Quad.mk.injEq]
  exact ⟨trivial, trivial, wwl_add_add_swap _ _ _⟩

/-- Limb 5's low bits plus `_bias`: no overflow either way. -/
theorem mask4340_add_bias_ok (d : Wwl) :
    ∀ i : Fin 8,
      (wwl_and d m4340)[i].saddOverflow (Vector.replicate 8 1048576#64)[i] = false ∧
        (wwl_and d m4340)[i].uaddOverflow (Vector.replicate 8 1048576#64)[i] = false := by
  intro ⟨i, hi⟩
  obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
  all_goals
    first
    | omega
    | wwl_lanes
      constructor <;> bv_decide

/-- Limb 5's low bits plus `_bias`, plus a signed carry: no signed overflow. -/
theorem mask4340_add_bias_add_shr_ok (d e : Wwl) :
    ∀ i : Fin 8,
      (wwl_add (wwl_and e m4340) (Vector.replicate 8 1048576#64))[i].saddOverflow
          (wwl_shr_vector d (Vector.replicate 8 43#64))[i] =
        false := by
  intro ⟨i, hi⟩
  obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
  all_goals
    first
    | omega
    | wwl_lanes
      bv_decide

/-! ## `FD_R43X6_GE_DBL` between the fold and the final fold -/

theorem laneAddFast_0010_of {m03 m14 m25 c03 c14 c25 : Wwl}
    (h03 : c03 = wwl_shl_vector m03 #v[0#64, 0#64, 1#64, 0#64, 0#64, 0#64, 1#64, 0#64])
    (h14 : c14 = wwl_shl_vector m14 #v[0#64, 0#64, 1#64, 0#64, 0#64, 0#64, 1#64, 0#64])
    (h25 : c25 = wwl_shl_vector m25 #v[0#64, 0#64, 1#64, 0#64, 0#64, 0#64, 1#64, 0#64]) :
    Quad.laneAddFast ⟨m03, m14, m25⟩ 0 0 1 0 ⟨m03, m14, m25⟩ ⟨m03, m14, m25⟩ = ⟨c03, c14, c25⟩ := by
  rw [Quad.laneAddFast_0010_self, h03, h14, h25]

/-- `FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _tb )` on `FD_R43X6_QUAD_PERMUTE`s of `F`, the first fused
into the operand halves. -/
theorem quadMul_of_core {F Y M : Quad} {i0 i1 i2 i3 j0 j1 j2 j3 : Nat}
    (hY : F.permute j0 j1 j2 j3 = Y)
    (h :
      quadMulCore (wwl_pack_halves (F.permute i0 i1 i2 i3).P03 0 (F.permute i0 i1 i2 i3).P03 0)
          (wwl_pack_halves (F.permute i0 i1 i2 i3).P14 0 (F.permute i0 i1 i2 i3).P14 0)
          (wwl_pack_halves (F.permute i0 i1 i2 i3).P25 0 (F.permute i0 i1 i2 i3).P25 0)
          (wwl_pack_halves (F.permute i0 i1 i2 i3).P03 1 (F.permute i0 i1 i2 i3).P03 1)
          (wwl_pack_halves (F.permute i0 i1 i2 i3).P14 1 (F.permute i0 i1 i2 i3).P14 1)
          (wwl_pack_halves (F.permute i0 i1 i2 i3).P25 1 (F.permute i0 i1 i2 i3).P25 1) Y.P03 Y.P14
          Y.P25 =
        M) :
    quadMul (F.permute i0 i1 i2 i3) (F.permute j0 j1 j2 j3) = M := by
  rw [hY, quadMul_eq_core]
  exact h

/-- `geDblMid` from its steps' equations. -/
theorem geDblMid_of {T Q C P B U V W F M : Quad} (h3 : quadSqr T = Q)
    (h4 : Q.laneAddFast 0 0 1 0 Q Q = C) (h5 : C.permute 3 3 3 3 = P) (h6 : C.permute 1 1 1 1 = B)
    (h7 : (P.laneAddFast 1 0 0 1 P B).laneSubFast 0 1 1 0 (P.laneAddFast 1 0 0 1 P B) B = U)
    (h8 : U.laneAddFast 0 0 1 0 U C = V) (h9 : V.laneSubFast 1 0 0 0 V C = W)
    (h10 : W.foldSigned = F) (h12 : quadMul (F.permute 0 1 1 0) (F.permute 2 3 2 3) = M) :
    geDblMid quadMul quadSqr T = M := by
  subst_vars
  rfl

section Patterns

attribute [-mlir_operation] zipWith_eq_ofFn

attribute [local mlir_operation] zipWith_and_wrap zipWith_add_wrap zipWith_sub_wrap zipWith_mul_wrap
  zipWith_lshr_wrap zipWith_ashr_wrap zipWith_shl_wrap zipWith_add_nsw_wrap zipWith_add_nsw_nuw_wrap
  zipWith_sub_nsw_wrap

/-- `foldSignedRun'` with limb 5 as `(l25 + b) + h14`. -/
def foldSignedRun2 (x03 x14 x25 nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 : Dst Γ (.vec 8 64))
    (d03 d14 d25 h03 h14 h25 p l03 c e03 r03 l14 e14 r14 l25 e25 r25 : Dst Γ (.vec 8 64)) :
    List (Instr Γ) :=
  [.binop (.vector (.add {})) d03 (.val x03.i x03.h) (.val nb03.i nb03.h),
    .binop (.vector (.add {})) d14 (.val x14.i x14.h) (.val nb.i nb.h),
    .binop (.vector (.add {})) d25 (.val x25.i x25.h) (.val nb.i nb.h),
    .binop (.vector (.ashr false)) h03 (.val d03.i d03.h) (.val sh43.i sh43.h),
    .binop (.vector (.ashr false)) h14 (.val d14.i d14.h) (.val sh43.i sh43.h),
    .binop (.vector (.ashr false)) h25 (.val d25.i d25.h) (.val sh4340.i sh4340.h),
    .binop (.vector (.mul { nsw := true })) p (.val h25.i h25.h) (.val k19.i k19.h),
    .binop (.vector .and) l03 (.val d03.i d03.h) (.val mk43.i mk43.h),
    .binop (.shufflevector #v[some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11]) c
      (.val p.i p.h) (.val h25.i h25.h),
    .binop (.vector (.add {})) e03 (.val c.i c.h) (.val b03.i b03.h),
    .binop (.vector (.add {})) r03 (.val e03.i e03.h) (.val l03.i l03.h),
    .binop (.vector .and) l14 (.val d14.i d14.h) (.val mk43.i mk43.h),
    .binop (.vector (.add { nsw := true, nuw := true })) e14 (.val l14.i l14.h) (.val b.i b.h),
    .binop (.vector (.add { nsw := true })) r14 (.val e14.i e14.h) (.val h03.i h03.h),
    .binop (.vector .and) l25 (.val d25.i d25.h) (.val mk4340.i mk4340.h),
    .binop (.vector (.add { nsw := true, nuw := true })) e25 (.val l25.i l25.h) (.val b.i b.h),
    .binop (.vector (.add { nsw := true })) r25 (.val e25.i e25.h) (.val h14.i h14.h)]

/-- `runBodyFrom_foldSignedRun'` for `foldSignedRun2`: `Quad.foldSignedC2 X` in `r03 r14 r25`. -/
theorem runBodyFrom_foldSignedRun2 {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x03 x14 x25 nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 : Dst Γ (.vec 8 64)}
    {d03 d14 d25 h03 h14 h25 p l03 c e03 r03 l14 e14 r14 l25 e25 r25 : Dst Γ (.vec 8 64)}
    {rest : List (Instr Γ)} {X03 X14 X25 : Wwl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        foldSignedRun2 x03 x14 x25 nb03 nb sh43 sh4340 k19 mk43 b03 b mk4340 d03 d14 d25 h03 h14 h25
            p l03 c e03 r03 l14 e14 r14 l25 e25 r25 ++
          rest)
    (hR : E ⊨ [x03 := X03, x14 := X14, x25 := X25])
    (hC : FoldSignedConsts E nb03 nb sh43 sh4340 mk43 b03 b mk4340)
    (hk19 : E.read (.val k19.i k19.h) = k19Lanes)
    (hd :
      [x03.i, x14.i, x25.i, nb03.i, nb.i, sh43.i, sh4340.i, k19.i, mk43.i, b03.i, b.i, mk4340.i,
          d03.i, d14.i, d25.i, h03.i, h14.i, h25.i, p.i, l03.i, c.i, e03.i, r03.i, l14.i, e14.i,
          r14.i, l25.i, e25.i].Nodup)
    (hK :
      ∀ (vd03 vd14 vd25 vh03 vh14 vh25 vp vl03 vc ve03 vl14 ve14 vl25 ve25 : ⟦.vec 8 64⟧)
        (s03 s14 s25 : Wwl) (_hs : Quad.foldSignedC2 ⟨X03, X14, X25⟩ = ⟨s03, s14, s25⟩),
        (blk.runBodyFrom
              E[d03 := vd03, d14 := vd14, d25 := vd25, h03 := vh03, h14 := vh14, h25 := vh25, p :=
                vp, l03 := vl03, c := vc, e03 := ve03, r03 := Ty.wrap s03, l14 := vl14, e14 := ve14,
                r14 := Ty.wrap s14, l25 := vl25, e25 := ve25, r25 := Ty.wrap s25]
              (pos + 17) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with sd03
  step_pure with sd14
  step_pure with sd25
  step_pure with sh03
  step_pure with sh14
  step_pure with transparent sh25
  step_pure [k19Lanes, zipWith_eq_ofFn, expandOfFn, wwl_shr_vector,
    sshr40_mul19_no_overflow] with transparent sp
  step_pure with sl03
  step_pure with sc03
  have hsc03' :
    sc03 =
      wwl_pack_halves (wwl_mul (wwl_shr_vector sd25 s4340) (wwl_bcast 19#64)) 1
        (wwl_shr_vector sd25 s4340) 0 := by
    rw [hsc03]
    ext i hi : 1
    obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
    all_goals
      first
      | omega
      | wwl_lanes
  step_pure [hsc03'] with se03
  step_pure with sf03
  step_pure with sl14
  have hok14 := mask_add_bias_ok sd14
  rw [← hsl14] at hok14
  step_pure with se14
  have hok14' := mask_add_bias_add_shr_ok sd03 sd14
  rw [← hsh03, ← hsl14, ← hse14] at hok14'
  step_pure with sf14
  step_pure with sl25
  have hok25 := mask4340_add_bias_ok sd25
  rw [← hsl25] at hok25
  step_pure with se25
  have hok25' := mask4340_add_bias_add_shr_ok sd14 sd25
  rw [← hsh14, ← hsl25, ← hse25] at hok25'
  step_pure with sf25
  have e : Quad.foldSignedC2 ⟨X03, X14, X25⟩ = ⟨sf03, sf14, sf25⟩ := by
    rw [hsf03, hsf14, hsf25, hse03, hse14, hse25, hsl03, hsl14, hsl25, hsh03, hsh14, hsd03, hsd14,
      hsd25]
    rfl
  rw [hE]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ e

/-! ## A permute fused into `fd_r43x6_quad_mul_fast`'s operand halves -/

/-- `x`'s halves `h` after `FD_R43X6_QUAD_PERMUTE( imm )` as one shuffle: lanes `immj + 4 h`,
twice. -/
def halfMask (i0 i1 i2 i3 h : Nat) : Vector (Option (Fin (2 * 8))) 8 :=
  #v[some (Fin.ofNat _ (i0 + 4 * h)), some (Fin.ofNat _ (i1 + 4 * h)),
    some (Fin.ofNat _ (i2 + 4 * h)), some (Fin.ofNat _ (i3 + 4 * h)),
    some (Fin.ofNat _ (i0 + 4 * h)), some (Fin.ofNat _ (i1 + 4 * h)),
    some (Fin.ofNat _ (i2 + 4 * h)), some (Fin.ofNat _ (i3 + 4 * h))]

/-- A shuffle by `halfMask imm h`: the halves `h` of `wwl_perm4 imm`. -/
theorem shufflevector_halfMask {i0 i1 i2 i3 h : Nat} {m : Vector (Option (Fin (2 * 8))) 8}
    (hm : m = halfMask i0 i1 i2 i3 h) (hi : i0 < 4 ∧ i1 < 4 ∧ i2 < 4 ∧ i3 < 4) (hh : h < 2)
    (x : ⟦.vec 8 64⟧ᵣ) (y : ⟦.vec 8 64⟧) :
    Operation.shufflevector m (Ty.wrap (t := .vec 8 64) x) y =
      Ty.wrap (t := .vec 8 64)
        (wwl_pack_halves (wwl_perm4 i0 i1 i2 i3 x) h (wwl_perm4 i0 i1 i2 i3 x) h) := by
  subst hm
  obtain ⟨h0, h1, h2, h3⟩ := hi
  obtain rfl | rfl : h = 0 ∨ h = 1 := by omega
  all_goals
    ext k hk
    obtain _ | _ | _ | _ | _ | _ | _ | _ | k := k
    all_goals
      first
      | omega
      |
        simp (disch := omega) [Operation.shufflevector, halfMask, wwl_perm4, wwl_pack_halves,
          Ty.wrap_vec, Nat.mod_eq_of_lt, dite_eq_left]

/-- `fd_r43x6_quad_mul_fast`'s operand halves `x00 … x55` of `FD_R43X6_QUAD_PERMUTE( imm, x )`,
shuffles by `m0`, `m1` (`pz` the unused operand). -/
def halvesRun (m0 m1 : Vector (Option (Fin (2 * 8))) 8)
    (x03 x14 x25 pz x00 x11 x22 x33 x44 x55 : Dst Γ (.vec 8 64)) : List (Instr Γ) :=
  [.binop (.shufflevector m0) x00 (.val x03.i x03.h) (.val pz.i pz.h),
    .binop (.shufflevector m0) x11 (.val x14.i x14.h) (.val pz.i pz.h),
    .binop (.shufflevector m0) x22 (.val x25.i x25.h) (.val pz.i pz.h),
    .binop (.shufflevector m1) x33 (.val x03.i x03.h) (.val pz.i pz.h),
    .binop (.shufflevector m1) x44 (.val x14.i x14.h) (.val pz.i pz.h),
    .binop (.shufflevector m1) x55 (.val x25.i x25.h) (.val pz.i pz.h)]

/-- Where the body at `pos` is `halvesRun` by `halfMask imm 0`, `halfMask imm 1` and `x03 x14 x25`
hold `X`: running on from `pos` then `g` gives `K` if it does from `pos + 6` with the halves of
`X.permute imm` in `x00 … x55`, as `quadMul_eq_core` reads them. -/
theorem runBodyFrom_halvesRun (i0 i1 i2 i3 : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
    {pos : Nat} {m0 m1 : Vector (Option (Fin (2 * 8))) 8}
    {x03 x14 x25 pz x00 x11 x22 x33 x44 x55 : Dst Γ (.vec 8 64)} {rest : List (Instr Γ)}
    {X03 X14 X25 : Wwl} {PZ : ⟦.vec 8 64⟧} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody : blk.body.drop pos = halvesRun m0 m1 x03 x14 x25 pz x00 x11 x22 x33 x44 x55 ++ rest)
    (hR : E ⊨ [x03 := X03, x14 := X14, x25 := X25]) (hz : E.read (.val pz.i pz.h) = PZ)
    (hm0 : m0 = halfMask i0 i1 i2 i3 0) (hm1 : m1 = halfMask i0 i1 i2 i3 1)
    (hi : i0 < 4 ∧ i1 < 4 ∧ i2 < 4 ∧ i3 < 4)
    (hd : [x03.i, x14.i, x25.i, x00.i, x11.i, x22.i, x33.i, x44.i].Nodup)
    (hK :
      (blk.runBodyFrom
            E[x00 :=
              Ty.wrap
                (wwl_pack_halves (Quad.permute i0 i1 i2 i3 ⟨X03, X14, X25⟩).P03 0
                  (Quad.permute i0 i1 i2 i3 ⟨X03, X14, X25⟩).P03 0),
              x11 :=
              Ty.wrap
                (wwl_pack_halves (Quad.permute i0 i1 i2 i3 ⟨X03, X14, X25⟩).P14 0
                  (Quad.permute i0 i1 i2 i3 ⟨X03, X14, X25⟩).P14 0),
              x22 :=
              Ty.wrap
                (wwl_pack_halves (Quad.permute i0 i1 i2 i3 ⟨X03, X14, X25⟩).P25 0
                  (Quad.permute i0 i1 i2 i3 ⟨X03, X14, X25⟩).P25 0),
              x33 :=
              Ty.wrap
                (wwl_pack_halves (Quad.permute i0 i1 i2 i3 ⟨X03, X14, X25⟩).P03 1
                  (Quad.permute i0 i1 i2 i3 ⟨X03, X14, X25⟩).P03 1),
              x44 :=
              Ty.wrap
                (wwl_pack_halves (Quad.permute i0 i1 i2 i3 ⟨X03, X14, X25⟩).P14 1
                  (Quad.permute i0 i1 i2 i3 ⟨X03, X14, X25⟩).P14 1),
              x55 :=
              Ty.wrap
                (wwl_pack_halves (Quad.permute i0 i1 i2 i3 ⟨X03, X14, X25⟩).P25 1
                  (Quad.permute i0 i1 i2 i3 ⟨X03, X14, X25⟩).P25 1)]
            (pos + 6) S >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  rw [Quad.permute_eq_perm4 hi] at hK
  step_pure [shufflevector_halfMask hm0 hi (by decide)]
  step_pure [shufflevector_halfMask hm0 hi (by decide)]
  step_pure [shufflevector_halfMask hm0 hi (by decide)]
  step_pure [shufflevector_halfMask hm1 hi (by decide)]
  step_pure [shufflevector_halfMask hm1 hi (by decide)]
  step_pure [shufflevector_halfMask hm1 hi (by decide)]
  rw [hE]
  exact hK

end Patterns

/-- `FD_R43X6_GE_DBL` from `QUAD_SQR_FAST( _ta, _ta )` to `QUAD_MUL_FAST( _ta, _ta, _tb )` as the
lane build compiles it, the result in registers: `hD : geDblMid quadMul quadSqr T = ⟨m03, m14, m25⟩`
for the squaring's input `T`; `using h` proves the squaring's `nsw` doubling of limbs 1 and 4. The
caller has `zipWith_eq_ofFn` erased and `zipWith_shl_wrap` as an `mlir_operation`. -/
syntax "quad_dbl_mid" (" using " term)? : tactic

set_option hygiene false in
macro_rules
  | `(tactic| quad_dbl_mid$[ using $ho]?) => do
    let sqr ←
      match ho with
      | some ho =>
        `(tactic| step_pattern using runBodyFrom_quadSqrRun (ho := fun _ => $ho))
      | none =>
        `(tactic| step_pattern using runBodyFrom_quadSqrRun)
    `(tactic|
        ( $sqr:tactic
          have d3 := _hm
          clear _hm
          -- FD_R43X6_QUAD_LANE_ADD_FAST( _ta, _ta, 0,0,1,0, _ta, _ta ): `Z` doubled by a shift
          step_pure with c03
          step_pure with c14
          step_pure with c25
          have d4 := laneAddFast_0010_of hc03 hc14 hc25
          clear hc03 hc14 hc25
          -- FD_R43X6_QUAD_PERMUTE( _tb, 3,3,3,3, _ta ); FD_R43X6_QUAD_PERMUTE( _BB, 1,1,1,1, _ta )
          step_pattern using runBodyFrom_permuteRun 3 3 3 3
          have d5 := _hp
          clear _hp
          step_pattern using runBodyFrom_permuteRun 1 1 1 1
          have d6 := _hp
          clear _hp
          -- FD_R43X6_QUAD_LANE_ADD_FAST( _tb, _tb, 1,0,0,1, _tb, _BB ) and
          -- FD_R43X6_QUAD_LANE_SUB_FAST( _tb, _tb, 0,1,1,0, _tb, _BB ), one select
          step_pattern using runBodyFrom_laneAddSubRun
          have d7 := _hl
          clear _hl
          -- FD_R43X6_QUAD_LANE_ADD_FAST( _tb, _tb, 0,0,1,0, _tb, _ta )
          step_pattern using runBodyFrom_laneAddRun 0 0 1 0
          have d8 := _hl
          clear _hl
          -- FD_R43X6_QUAD_LANE_SUB_FAST( _tb, _tb, 1,0,0,0, _tb, _ta )
          step_pattern using runBodyFrom_laneSubRun 1 0 0 0
          have d9 := _hl
          clear _hl
          -- FD_R43X6_QUAD_FOLD_SIGNED( _tb, _tb )
          step_pattern using runBodyFrom_foldSignedRun2
          have d10 := (Quad.foldSigned_eq _).trans ((Quad.foldSignedC_eq2 _).trans _hs)
          clear _hs
          -- FD_R43X6_QUAD_PERMUTE( _tb, 2,3,2,3, _tb ), then FD_R43X6_QUAD_PERMUTE( _ta, 0,1,1,0,
          -- _tb ) fused into FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _tb )
          step_pattern using runBodyFrom_permuteRun 2 3 2 3
          have d11 := _hp
          clear _hp
          step_pattern using runBodyFrom_halvesRun 0 1 1 0 inline
          step_pattern using runBodyFrom_quadMulCoreRun
          have hD := geDblMid_of d3 d4 d5 d6 d7 d8 d9 d10 (quadMul_of_core d11 _hm)
          clear d3 d4 d5 d6 d7 d8 d9 d10 d11 _hm))

end

end MLIR.Firedancer.Lane
