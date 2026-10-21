module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.VecRun
public import Firedancer.R52x5.wc_bcast_wide
public import Firedancer.R52x5.wl_permute
public import Firedancer.R52x5.fd_r52x5_quad_sqr_fast
import Std.Tactic.BVDecide

/-! The `FD_R52X5_QUAD_*` macros as compiled, as patterns: each one's instructions over register
variables, and a continuation-form lemma stepping them (`step_pattern`). -/

namespace MLIR.Firedancer.R52x5

@[expose] public section

open Firedancer.Avx512 (Wwl)

/-- `<4 x i64>`, a `wl_t`. -/
abbrev Ty4x64 : Ty :=
  .vec 4 64

/-- `<32 x i8>`, a `wl_t`'s bytes. -/
abbrev Ty32x8 : Ty :=
  .vec 32 8

/-- `wc_bcast_wide`'s argument for an `FD_R52X5_QUAD_LANE_IF` immediate. -/
abbrev laneImm (i : Nat) : BitVec 32 :=
  BitVec.ofNat 32 i

theorem laneImm_eq_one {i : Nat} (h : i ≤ 1) : (laneImm i == 1#32) = (i != 0) := by
  obtain rfl | rfl : i = 0 ∨ i = 1 := by omega
  all_goals decide

theorem laneImm_01 {i : Nat} (h : i ≤ 1) : laneImm i = 0 ∨ laneImm i = 1 := by
  obtain rfl | rfl : i = 0 ∨ i = 1 := by omega
  all_goals decide

theorem laneImm_ne_intMin {i : Nat} (h : i ≤ 1) : laneImm i ≠ BitVec.intMin 32 := by
  obtain rfl | rfl : i = 0 ∨ i = 1 := by omega
  all_goals decide

/-- The mask of `FD_R52X5_QUAD_LANE_IF( D, i0,i1,i2,i3, S, T )`. -/
abbrev laneMask (i0 i1 i2 i3 : Nat) : Wl :=
  wcBcast (laneImm i0) (laneImm i1) (laneImm i2) (laneImm i3)

/-- A load of a `<32 x i8>` as the steps give it: the bytes of `readWv`. -/
theorem ofFn_extractVecElem_bytes {m : MemoryState} :
    (Vector.ofFn fun i => Ty.extractVecElem 32 8 i (m.readAt p 256)) = wlBytes (m.readWv p) := by
  rw [← MemoryState.packLanes_readWv]
  ext k hk : 1
  simp only [Vector.getElem_ofFn, Ty.extractVecElem_eq, wlBytes]
  exact extractLsb'_packLanes_byte _ hk

/-! ### Single instructions -/

section Patterns

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h
  Operation.pblendvb

attribute [local mlir_operation] vpmadd52l_wl vpmadd52h_wl zipWith_add_wl zipWith_sub_wl
  zipWith_and_wl zipWith_shl_wl zipWith_lshr_wl zipWith_add_nsw_nuw_reduce

/-- A `wl_t`'s bytes: `bitcast <4 x i64> → <32 x i8>` of `x` into `b`. -/
def bytesRun (x : Reg Γ Ty4x64) (b : Dst Γ Ty32x8) : List (Instr Γ) :=
  [.unop (.bitcast (by decide)) b x]

/-- Where the body at `pos` is `bytesRun` and `x` holds `X`: running on from `pos` then `g` gives
`K` if it does from `pos + 1` with `wlBytes X` in `b`. -/
theorem runBodyFrom_bytesRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {x : Reg Γ Ty4x64}
    {b : Dst Γ Ty32x8} {rest : List (Instr Γ)} {X : Wl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = bytesRun x b ++ rest) (hx : E ⊨ [x := X])
    (hK : (blk.runBodyFrom E[b := Ty.wrap (wlBytes X)] (pos + 1) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with bb
  rw [← wlBytes_eq] at hbb
  rw [hE, hbb]
  exact hK

/-- A `wl_t`'s bytes, concatenated back by lanes, as a `bitcast` step leaves them. -/
@[mlir_operation]
theorem wlBytes_concat (v : Wl) :
    #v[(wlBytes v)[7] ++ (wlBytes v)[6] ++ (wlBytes v)[5] ++ (wlBytes v)[4] ++ (wlBytes v)[3] ++
          (wlBytes v)[2] ++
          (wlBytes v)[1] ++
          (wlBytes v)[0],
        (wlBytes v)[15] ++ (wlBytes v)[14] ++ (wlBytes v)[13] ++ (wlBytes v)[12] ++
          (wlBytes v)[11] ++
          (wlBytes v)[10] ++
          (wlBytes v)[9] ++
          (wlBytes v)[8],
        (wlBytes v)[23] ++ (wlBytes v)[22] ++ (wlBytes v)[21] ++ (wlBytes v)[20] ++
          (wlBytes v)[19] ++
          (wlBytes v)[18] ++
          (wlBytes v)[17] ++
          (wlBytes v)[16],
        (wlBytes v)[31] ++ (wlBytes v)[30] ++ (wlBytes v)[29] ++ (wlBytes v)[28] ++
          (wlBytes v)[27] ++
          (wlBytes v)[26] ++
          (wlBytes v)[25] ++
          (wlBytes v)[24]] =
      v := by
  have e :
    ∀ x : BitVec 64,
      x.extractLsb' 56 8 ++ x.extractLsb' 48 8 ++ x.extractLsb' 40 8 ++ x.extractLsb' 32 8 ++
          x.extractLsb' 24 8 ++
          x.extractLsb' 16 8 ++
          x.extractLsb' 8 8 ++
          x.extractLsb' 0 8 =
        x := by
    intro x
    bv_decide
  ext i hi : 1
  obtain rfl | rfl | rfl | rfl : i = 0 ∨ i = 1 ∨ i = 2 ∨ i = 3 := by omega
  all_goals
    simp only [wlBytes, Vector.getElem_ofFn, Vector.getElem_mk, List.getElem_toArray,
      List.getElem_cons_zero, List.getElem_cons_succ, Nat.reduceDiv, Nat.reduceMod, Nat.reduceMul,
      e]

/-- Bytes as a `wl_t`: `bitcast <32 x i8> → <4 x i64>` of `b` into `x`. -/
def wlRun (b : Reg Γ Ty32x8) (x : Dst Γ Ty4x64) : List (Instr Γ) :=
  [.unop (.bitcast (by decide)) x b]

/-- Where the body at `pos` is `wlRun` and `b` holds `X`'s bytes: running on from `pos` then `g`
gives `K` if it does from `pos + 1` with `X` in `x`. -/
theorem runBodyFrom_wlRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat} {b : Reg Γ Ty32x8}
    {x : Dst Γ Ty4x64} {rest : List (Instr Γ)} {X : Wl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = wlRun b x ++ rest) (hb : E ⊨ [b := wlBytes X])
    (hK : (blk.runBodyFrom E[x := Ty.wrap X] (pos + 1) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure
  rw [hE]
  exact hK

/-- `wl_if( c, s, t )` on bytes: `pblendvb` of `t`'s and `s`'s bytes `tb`, `sb` by the mask's `mb`,
into `q`. -/
def blendRun (tb sb mb : Reg Γ Ty32x8) (q : Dst Γ Ty32x8) : List (Instr Γ) :=
  [.ternop .pblendvb q tb sb mb]

/-- Where the body at `pos` is `blendRun`, `tb`, `sb` hold the bytes of `T`, `X` and `mb` those of
`laneMask i0 i1 i2 i3`: running on from `pos` then `g` gives `K` if it does from `pos + 1` with
the bytes of `X` where `ik ≠ 0`, else of `T`, in `q`. -/
theorem runBodyFrom_blendRun (i0 i1 i2 i3 : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {tb sb mb : Reg Γ Ty32x8} {q : Dst Γ Ty32x8} {rest : List (Instr Γ)} {T X : Wl}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = blendRun tb sb mb q ++ rest)
    (hR : E ⊨ [tb := wlBytes T, sb := wlBytes X, mb := wlBytes (laneMask i0 i1 i2 i3)])
    (hi : i0 ≤ 1 ∧ i1 ≤ 1 ∧ i2 ≤ 1 ∧ i3 ≤ 1)
    (hK :
      (blk.runBodyFrom
            E[q := Ty.wrap (wlBytes (wlBlend (i0 != 0) (i1 != 0) (i2 != 0) (i3 != 0) X T))]
            (pos + 1) S >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨h0, h1, h2, h3⟩ := hi
  step_pure [pblendvb_wcBcast (laneImm_01 h0) (laneImm_01 h1) (laneImm_01 h2) (laneImm_01 h3),
    laneImm_eq_one h0, laneImm_eq_one h1, laneImm_eq_one h2, laneImm_eq_one h3] with qq
  rw [hE, hqq]
  exact hK

/-! ### `FD_R52X5_QUAD_LANE_IF` -/

/-- `bitcast`s of `t` and `s` to bytes `tb`, `sb`, their `pblendvb` by `mb` into `q`, and back into
`r`: one limb of `FD_R52X5_QUAD_LANE_IF`. -/
def blendLimbRun (t s : Dst Γ Ty4x64) (mb tb sb q : Dst Γ Ty32x8) (r : Dst Γ Ty4x64) :
    List (Instr Γ) :=
  [.unop (.bitcast (by decide)) tb (.val t.i t.h), .unop (.bitcast (by decide)) sb (.val s.i s.h),
    .ternop .pblendvb q (.val tb.i tb.h) (.val sb.i sb.h) (.val mb.i mb.h),
    .unop (.bitcast (by decide)) r (.val q.i q.h)]

/-- Where the body at `pos` is `blendLimbRun`, `t`, `s` hold `T`, `X` and `mb` the bytes of
`laneMask i0 i1 i2 i3`: running on from `pos` then `g` gives `K` if it does from `pos + 4` with
`X`'s lanes where `ik ≠ 0`, else `T`'s, in `r`, and the operands' and the result's bytes in
`tb`, `sb`, `q`. -/
theorem runBodyFrom_blendLimbRun (i0 i1 i2 i3 : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
    {pos : Nat} {t s : Dst Γ Ty4x64} {mb tb sb q : Dst Γ Ty32x8} {r : Dst Γ Ty4x64}
    {rest : List (Instr Γ)} {T X : Wl} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} (hbody : blk.body.drop pos = blendLimbRun t s mb tb sb q r ++ rest)
    (hR : E ⊨ [t := T, s := X, mb := wlBytes (laneMask i0 i1 i2 i3)])
    (hi : i0 ≤ 1 ∧ i1 ≤ 1 ∧ i2 ≤ 1 ∧ i3 ≤ 1)
    (hne : s.i ≠ tb.i ∧ mb.i ≠ tb.i ∧ tb.i ≠ sb.i ∧ mb.i ≠ sb.i)
    (hK :
      (blk.runBodyFrom
            E[tb := Ty.wrap (wlBytes T), sb := Ty.wrap (wlBytes X), q :=
              Ty.wrap (wlBytes (wlBlend (i0 != 0) (i1 != 0) (i2 != 0) (i3 != 0) X T)), r :=
              Ty.wrap (wlBlend (i0 != 0) (i1 != 0) (i2 != 0) (i3 != 0) X T)]
            (pos + 4) S >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨h0, h1, h2, h3⟩ := hi
  obtain ⟨hne1, hne2, hne3, hne4⟩ := hne
  step_pattern using runBodyFrom_bytesRun inline
  step_pattern using runBodyFrom_bytesRun inline
  step_pattern using runBodyFrom_blendRun i0 i1 i2 i3 inline
  step_pattern using runBodyFrom_wlRun inline
  rw [hE, hS]
  exact hK

/-- `FD_R52X5_QUAD_LANE_IF( d, i0,i1,i2,i3, s, t )` as compiled: `wc_bcast_wide` of `c0 … c3` into
`m`, then per limb `blendLimbRun`, the first with `m`'s bytes `mb` taken after `t0`'s and
`s0`'s. -/
def laneIfRun (c0 c1 c2 c3 : Reg Γ (.bv 32)) (m : Dst Γ Ty4x64)
    (t0 s0 t1 s1 t2 s2 t3 s3 t4 s4 : Dst Γ Ty4x64)
    (mb tb0 sb0 q0 tb1 sb1 q1 tb2 sb2 q2 tb3 sb3 q3 tb4 sb4 q4 : Dst Γ Ty32x8)
    (r0 r1 r2 r3 r4 : Dst Γ Ty4x64) : List (Instr Γ) :=
  .call wc_bcast_wide.call (.cons c0 (.cons c1 (.cons c2 (.cons c3 .nil)))) (.cons m .nil) ::
    .unop (.bitcast (by decide)) tb0 (.val t0.i t0.h) ::
    .unop (.bitcast (by decide)) sb0 (.val s0.i s0.h) ::
    .unop (.bitcast (by decide)) mb (.val m.i m.h) ::
    .ternop .pblendvb q0 (.val tb0.i tb0.h) (.val sb0.i sb0.h) (.val mb.i mb.h) ::
    .unop (.bitcast (by decide)) r0 (.val q0.i q0.h) ::
    (blendLimbRun t1 s1 mb tb1 sb1 q1 r1 ++ blendLimbRun t2 s2 mb tb2 sb2 q2 r2 ++
      blendLimbRun t3 s3 mb tb3 sb3 q3 r3 ++
      blendLimbRun t4 s4 mb tb4 sb4 q4 r4)

/-- Where the body at `pos` is `laneIfRun`, `c0 … c3` hold the immediates (each 0 or 1),
`t0 … t4` hold `T` and `s0 … s4` hold `X`: running on from `pos` then `g` gives `K` if it does
from `pos + 22` with `Quad5.laneIf i0 i1 i2 i3 X T` in `r0 … r4`, and the mask, the operands'
and the results' bytes in the other registers. -/
theorem runBodyFrom_laneIfRun (i0 i1 i2 i3 : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
    {pos : Nat} {c0 c1 c2 c3 : Reg Γ (.bv 32)} {m : Dst Γ Ty4x64}
    {t0 s0 t1 s1 t2 s2 t3 s3 t4 s4 : Dst Γ Ty4x64}
    {mb tb0 sb0 q0 tb1 sb1 q1 tb2 sb2 q2 tb3 sb3 q3 tb4 sb4 q4 : Dst Γ Ty32x8}
    {r0 r1 r2 r3 r4 : Dst Γ Ty4x64} {rest : List (Instr Γ)} {X T : Quad5} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        laneIfRun c0 c1 c2 c3 m t0 s0 t1 s1 t2 s2 t3 s3 t4 s4 mb tb0 sb0 q0 tb1 sb1 q1 tb2 sb2 q2
            tb3 sb3 q3 tb4 sb4 q4 r0 r1 r2 r3 r4 ++
          rest)
    (hR :
      E ⊨ [c0 := laneImm i0, c1 := laneImm i1, c2 := laneImm i2, c3 := laneImm i3, t0 := T.P0, t1 :=
        T.P1, t2 := T.P2, t3 := T.P3, t4 := T.P4, s0 := X.P0, s1 := X.P1, s2 := X.P2, s3 := X.P3,
        s4 := X.P4])
    (hi : i0 ≤ 1 ∧ i1 ≤ 1 ∧ i2 ≤ 1 ∧ i3 ≤ 1) (hwf : S.WF)
    (hd :
      [m.i, t0.i, s0.i, t1.i, s1.i, t2.i, s2.i, t3.i, s3.i, t4.i, s4.i, mb.i, tb0.i, sb0.i, q0.i,
          r0.i, tb1.i, sb1.i, q1.i, r1.i, tb2.i, sb2.i, q2.i, r2.i, tb3.i, sb3.i, q3.i, r3.i, tb4.i,
          sb4.i, q4.i].Nodup)
    (hK :
      (blk.runBodyFrom
            E[m := Ty.wrap (laneMask i0 i1 i2 i3), tb0 := Ty.wrap (wlBytes T.P0), sb0 :=
              Ty.wrap (wlBytes X.P0), mb := Ty.wrap (wlBytes (laneMask i0 i1 i2 i3)), q0 :=
              Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X T).P0), r0 :=
              Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X T).P0, tb1 := Ty.wrap (wlBytes T.P1), sb1 :=
              Ty.wrap (wlBytes X.P1), q1 := Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X T).P1),
              r1 := Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X T).P1, tb2 := Ty.wrap (wlBytes T.P2), sb2 :=
              Ty.wrap (wlBytes X.P2), q2 := Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X T).P2),
              r2 := Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X T).P2, tb3 := Ty.wrap (wlBytes T.P3), sb3 :=
              Ty.wrap (wlBytes X.P3), q3 := Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X T).P3),
              r3 := Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X T).P3, tb4 := Ty.wrap (wlBytes T.P4), sb4 :=
              Ty.wrap (wlBytes X.P4), q4 := Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X T).P4),
              r4 := Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X T).P4]
            (pos + 22) S >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨h0, h1, h2, h3⟩ := hi
  have hc0 := laneImm_ne_intMin h0
  have hc1 := laneImm_ne_intMin h1
  have hc2 := laneImm_ne_intMin h2
  have hc3 := laneImm_ne_intMin h3
  step_call using wc_bcast_wide.call_eq
  step_pattern using runBodyFrom_bytesRun inline
  step_pattern using runBodyFrom_bytesRun inline
  step_pattern using runBodyFrom_bytesRun inline
  step_pattern using runBodyFrom_blendRun i0 i1 i2 i3 inline
  step_pattern using runBodyFrom_wlRun inline
  step_pattern using runBodyFrom_blendLimbRun i0 i1 i2 i3 inline
  step_pattern using runBodyFrom_blendLimbRun i0 i1 i2 i3 inline
  step_pattern using runBodyFrom_blendLimbRun i0 i1 i2 i3 inline
  step_pattern using runBodyFrom_blendLimbRun i0 i1 i2 i3 inline
  rw [hE, hS]
  exact hK

/-- `blendLimbRun` with `t`'s bytes `tb` computed earlier: `s`'s bytes, the `pblendvb`, back. -/
def blendLimbRun' (s : Dst Γ Ty4x64) (mb tb sb q : Dst Γ Ty32x8) (r : Dst Γ Ty4x64) :
    List (Instr Γ) :=
  [.unop (.bitcast (by decide)) sb (.val s.i s.h),
    .ternop .pblendvb q (.val tb.i tb.h) (.val sb.i sb.h) (.val mb.i mb.h),
    .unop (.bitcast (by decide)) r (.val q.i q.h)]

/-- `runBodyFrom_blendLimbRun` for `blendLimbRun'`, `tb` holding `T`'s bytes. -/
theorem runBodyFrom_blendLimbRun' (i0 i1 i2 i3 : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
    {pos : Nat} {s : Dst Γ Ty4x64} {mb tb sb q : Dst Γ Ty32x8} {r : Dst Γ Ty4x64}
    {rest : List (Instr Γ)} {T X : Wl} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β} (hbody : blk.body.drop pos = blendLimbRun' s mb tb sb q r ++ rest)
    (hR : E ⊨ [tb := wlBytes T, s := X, mb := wlBytes (laneMask i0 i1 i2 i3)])
    (hi : i0 ≤ 1 ∧ i1 ≤ 1 ∧ i2 ≤ 1 ∧ i3 ≤ 1) (hne : tb.i ≠ sb.i ∧ mb.i ≠ sb.i)
    (hK :
      (blk.runBodyFrom
            E[sb := Ty.wrap (wlBytes X), q :=
              Ty.wrap (wlBytes (wlBlend (i0 != 0) (i1 != 0) (i2 != 0) (i3 != 0) X T)), r :=
              Ty.wrap (wlBlend (i0 != 0) (i1 != 0) (i2 != 0) (i3 != 0) X T)]
            (pos + 3) S >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨h0, h1, h2, h3⟩ := hi
  obtain ⟨hne1, hne2⟩ := hne
  step_pattern using runBodyFrom_bytesRun inline
  step_pattern using runBodyFrom_blendRun i0 i1 i2 i3 inline
  step_pattern using runBodyFrom_wlRun inline
  rw [hE, hS]
  exact hK

/-- `FD_R52X5_QUAD_LANE_IF( d, i0,i1,i2,i3, s, t )` as compiled when `t`'s bytes `tb0 … tb4` are
at hand (an earlier `LANE_IF`'s, or zero): `wc_bcast_wide` into `m`, `s0`'s bytes, `m`'s bytes
`mb`, then per limb the `pblendvb` and back (`blendLimbRun'`). -/
def laneIfRun' (c0 c1 c2 c3 : Reg Γ (.bv 32)) (m : Dst Γ Ty4x64) (s0 s1 s2 s3 s4 : Dst Γ Ty4x64)
    (tb0 tb1 tb2 tb3 tb4 mb sb0 q0 sb1 q1 sb2 q2 sb3 q3 sb4 q4 : Dst Γ Ty32x8)
    (r0 r1 r2 r3 r4 : Dst Γ Ty4x64) : List (Instr Γ) :=
  .call wc_bcast_wide.call (.cons c0 (.cons c1 (.cons c2 (.cons c3 .nil)))) (.cons m .nil) ::
    .unop (.bitcast (by decide)) sb0 (.val s0.i s0.h) ::
    .unop (.bitcast (by decide)) mb (.val m.i m.h) ::
    .ternop .pblendvb q0 (.val tb0.i tb0.h) (.val sb0.i sb0.h) (.val mb.i mb.h) ::
    .unop (.bitcast (by decide)) r0 (.val q0.i q0.h) ::
    (blendLimbRun' s1 mb tb1 sb1 q1 r1 ++ blendLimbRun' s2 mb tb2 sb2 q2 r2 ++
      blendLimbRun' s3 mb tb3 sb3 q3 r3 ++
      blendLimbRun' s4 mb tb4 sb4 q4 r4)

/-- Where the body at `pos` is `laneIfRun'`, `c0 … c3` hold the immediates (each 0 or 1),
`tb0 … tb4` the bytes of `T` and `s0 … s4` hold `X`: running on from `pos` then `g` gives `K` if
it does from `pos + 17` with `Quad5.laneIf i0 i1 i2 i3 X T` in `r0 … r4`, and the mask, `X`'s and
the results' bytes in the other registers. -/
theorem runBodyFrom_laneIfRun' (i0 i1 i2 i3 : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
    {pos : Nat} {c0 c1 c2 c3 : Reg Γ (.bv 32)} {m : Dst Γ Ty4x64} {s0 s1 s2 s3 s4 : Dst Γ Ty4x64}
    {tb0 tb1 tb2 tb3 tb4 mb sb0 q0 sb1 q1 sb2 q2 sb3 q3 sb4 q4 : Dst Γ Ty32x8}
    {r0 r1 r2 r3 r4 : Dst Γ Ty4x64} {rest : List (Instr Γ)} {X T : Quad5} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        laneIfRun' c0 c1 c2 c3 m s0 s1 s2 s3 s4 tb0 tb1 tb2 tb3 tb4 mb sb0 q0 sb1 q1 sb2 q2 sb3 q3
            sb4 q4 r0 r1 r2 r3 r4 ++
          rest)
    (hR :
      E ⊨ [c0 := laneImm i0, c1 := laneImm i1, c2 := laneImm i2, c3 := laneImm i3, tb0 :=
        wlBytes T.P0, tb1 := wlBytes T.P1, tb2 := wlBytes T.P2, tb3 := wlBytes T.P3, tb4 :=
        wlBytes T.P4, s0 := X.P0, s1 := X.P1, s2 := X.P2, s3 := X.P3, s4 := X.P4])
    (hi : i0 ≤ 1 ∧ i1 ≤ 1 ∧ i2 ≤ 1 ∧ i3 ≤ 1) (hwf : S.WF)
    (hd :
      [m.i, s0.i, s1.i, s2.i, s3.i, s4.i, tb0.i, tb1.i, tb2.i, tb3.i, tb4.i, mb.i, sb0.i, q0.i,
          r0.i, sb1.i, q1.i, r1.i, sb2.i, q2.i, r2.i, sb3.i, q3.i, r3.i, sb4.i].Nodup)
    (hK :
      (blk.runBodyFrom
            E[m := Ty.wrap (laneMask i0 i1 i2 i3), sb0 := Ty.wrap (wlBytes X.P0), mb :=
              Ty.wrap (wlBytes (laneMask i0 i1 i2 i3)), q0 :=
              Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X T).P0), r0 :=
              Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X T).P0, sb1 := Ty.wrap (wlBytes X.P1), q1 :=
              Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X T).P1), r1 :=
              Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X T).P1, sb2 := Ty.wrap (wlBytes X.P2), q2 :=
              Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X T).P2), r2 :=
              Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X T).P2, sb3 := Ty.wrap (wlBytes X.P3), q3 :=
              Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X T).P3), r3 :=
              Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X T).P3, sb4 := Ty.wrap (wlBytes X.P4), q4 :=
              Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X T).P4), r4 :=
              Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X T).P4]
            (pos + 17) S >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨h0, h1, h2, h3⟩ := hi
  have hc0 := laneImm_ne_intMin h0
  have hc1 := laneImm_ne_intMin h1
  have hc2 := laneImm_ne_intMin h2
  have hc3 := laneImm_ne_intMin h3
  step_call using wc_bcast_wide.call_eq
  step_pattern using runBodyFrom_bytesRun inline
  step_pattern using runBodyFrom_bytesRun inline
  step_pattern using runBodyFrom_blendRun i0 i1 i2 i3 inline
  step_pattern using runBodyFrom_wlRun inline
  step_pattern using runBodyFrom_blendLimbRun' i0 i1 i2 i3 inline
  step_pattern using runBodyFrom_blendLimbRun' i0 i1 i2 i3 inline
  step_pattern using runBodyFrom_blendLimbRun' i0 i1 i2 i3 inline
  step_pattern using runBodyFrom_blendLimbRun' i0 i1 i2 i3 inline
  rw [hE, hS]
  exact hK

/-- `FD_R52X5_QUAD_LANE_IF( d, i0,i1,i2,i3, s, t )` as compiled when the mask's bytes `mb` are at
hand: `blendLimbRun` per limb. -/
def laneIfMaskRun (t0 s0 t1 s1 t2 s2 t3 s3 t4 s4 : Dst Γ Ty4x64)
    (mb tb0 sb0 q0 tb1 sb1 q1 tb2 sb2 q2 tb3 sb3 q3 tb4 sb4 q4 : Dst Γ Ty32x8)
    (r0 r1 r2 r3 r4 : Dst Γ Ty4x64) : List (Instr Γ) :=
  blendLimbRun t0 s0 mb tb0 sb0 q0 r0 ++ blendLimbRun t1 s1 mb tb1 sb1 q1 r1 ++
    blendLimbRun t2 s2 mb tb2 sb2 q2 r2 ++
    blendLimbRun t3 s3 mb tb3 sb3 q3 r3 ++
    blendLimbRun t4 s4 mb tb4 sb4 q4 r4

/-- Where the body at `pos` is `laneIfMaskRun`, `t0 … t4` hold `T`, `s0 … s4` hold `X` and `mb`
the bytes of `laneMask i0 i1 i2 i3`: running on from `pos` then `g` gives `K` if it does from
`pos + 20` with `Quad5.laneIf i0 i1 i2 i3 X T` in `r0 … r4`, and the operands' and the results'
bytes in the other registers. -/
theorem runBodyFrom_laneIfMaskRun (i0 i1 i2 i3 : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
    {pos : Nat} {t0 s0 t1 s1 t2 s2 t3 s3 t4 s4 : Dst Γ Ty4x64}
    {mb tb0 sb0 q0 tb1 sb1 q1 tb2 sb2 q2 tb3 sb3 q3 tb4 sb4 q4 : Dst Γ Ty32x8}
    {r0 r1 r2 r3 r4 : Dst Γ Ty4x64} {rest : List (Instr Γ)} {X T : Quad5} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        laneIfMaskRun t0 s0 t1 s1 t2 s2 t3 s3 t4 s4 mb tb0 sb0 q0 tb1 sb1 q1 tb2 sb2 q2 tb3 sb3 q3
            tb4 sb4 q4 r0 r1 r2 r3 r4 ++
          rest)
    (hR :
      E ⊨ [t0 := T.P0, t1 := T.P1, t2 := T.P2, t3 := T.P3, t4 := T.P4, s0 := X.P0, s1 := X.P1, s2 :=
        X.P2, s3 := X.P3, s4 := X.P4, mb := wlBytes (laneMask i0 i1 i2 i3)])
    (hi : i0 ≤ 1 ∧ i1 ≤ 1 ∧ i2 ≤ 1 ∧ i3 ≤ 1)
    (hd :
      [t0.i, s0.i, t1.i, s1.i, t2.i, s2.i, t3.i, s3.i, t4.i, s4.i, mb.i, tb0.i, sb0.i, q0.i, r0.i,
          tb1.i, sb1.i, q1.i, r1.i, tb2.i, sb2.i, q2.i, r2.i, tb3.i, sb3.i, q3.i, r3.i, tb4.i,
          sb4.i].Nodup)
    (hK :
      (blk.runBodyFrom
            E[tb0 := Ty.wrap (wlBytes T.P0), sb0 := Ty.wrap (wlBytes X.P0), q0 :=
              Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X T).P0), r0 :=
              Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X T).P0, tb1 := Ty.wrap (wlBytes T.P1), sb1 :=
              Ty.wrap (wlBytes X.P1), q1 := Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X T).P1),
              r1 := Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X T).P1, tb2 := Ty.wrap (wlBytes T.P2), sb2 :=
              Ty.wrap (wlBytes X.P2), q2 := Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X T).P2),
              r2 := Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X T).P2, tb3 := Ty.wrap (wlBytes T.P3), sb3 :=
              Ty.wrap (wlBytes X.P3), q3 := Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X T).P3),
              r3 := Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X T).P3, tb4 := Ty.wrap (wlBytes T.P4), sb4 :=
              Ty.wrap (wlBytes X.P4), q4 := Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X T).P4),
              r4 := Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X T).P4]
            (pos + 20) S >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨h0, h1, h2, h3⟩ := hi
  step_pattern using runBodyFrom_blendLimbRun i0 i1 i2 i3 inline
  step_pattern using runBodyFrom_blendLimbRun i0 i1 i2 i3 inline
  step_pattern using runBodyFrom_blendLimbRun i0 i1 i2 i3 inline
  step_pattern using runBodyFrom_blendLimbRun i0 i1 i2 i3 inline
  step_pattern using runBodyFrom_blendLimbRun i0 i1 i2 i3 inline
  rw [hE, hS]
  exact hK

/-! ### `FD_R52X5_QUAD_NEGATE_LAZY`, `FD_R52X5_QUAD_ADD_FAST` -/

/-- `FD_R52X5_QUAD_NEGATE_LAZY( d, s )` as compiled: `lo - s0` and `hi - sk` into `d0 … d4`. -/
def negateLazyRun (lo hi s0 s1 s2 s3 s4 d0 d1 d2 d3 d4 : Dst Γ Ty4x64) : List (Instr Γ) :=
  [.binop (.vector (.sub {})) d0 (.val lo.i lo.h) (.val s0.i s0.h),
    .binop (.vector (.sub {})) d1 (.val hi.i hi.h) (.val s1.i s1.h),
    .binop (.vector (.sub {})) d2 (.val hi.i hi.h) (.val s2.i s2.h),
    .binop (.vector (.sub {})) d3 (.val hi.i hi.h) (.val s3.i s3.h),
    .binop (.vector (.sub {})) d4 (.val hi.i hi.h) (.val s4.i s4.h)]

/-- Where the body at `pos` is `negateLazyRun`, `lo`, `hi` hold `32 p`'s limbs and `s0 … s4`
hold `Q`: running on from `pos` then `g` gives `K` if it does from `pos + 5` with
`Q.negateLazy` in `d0 … d4`. -/
theorem runBodyFrom_negateLazyRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {lo hi s0 s1 s2 s3 s4 d0 d1 d2 d3 d4 : Dst Γ Ty4x64} {rest : List (Instr Γ)} {Q : Quad5}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = negateLazyRun lo hi s0 s1 s2 s3 s4 d0 d1 d2 d3 d4 ++ rest)
    (hR :
      E ⊨ [lo := (Vector.replicate 4 72057594037927328#64 : Wl), hi :=
        (Vector.replicate 4 72057594037927904#64 : Wl), s0 := Q.P0, s1 := Q.P1, s2 := Q.P2, s3 :=
        Q.P3, s4 := Q.P4])
    (hd : [lo.i, hi.i, s0.i, s1.i, s2.i, s3.i, s4.i, d0.i, d1.i, d2.i, d3.i].Nodup)
    (hK :
      (blk.runBodyFrom
            E[d0 := Ty.wrap Q.negateLazy.P0, d1 := Ty.wrap Q.negateLazy.P1, d2 :=
              Ty.wrap Q.negateLazy.P2, d3 := Ty.wrap Q.negateLazy.P3, d4 := Ty.wrap Q.negateLazy.P4]
            (pos + 5) S >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with e0
  step_pure with e1
  step_pure with e2
  step_pure with e3
  step_pure with e4
  rw [hE, he0, he1, he2, he3, he4]
  exact hK

/-- `FD_R52X5_QUAD_ADD_FAST( d, x, y )` as compiled: `xk + yk` into `dk`. -/
def addFastRun (x0 y0 x1 y1 x2 y2 x3 y3 x4 y4 d0 d1 d2 d3 d4 : Dst Γ Ty4x64) : List (Instr Γ) :=
  [.binop (.vector (.add {})) d0 (.val x0.i x0.h) (.val y0.i y0.h),
    .binop (.vector (.add {})) d1 (.val x1.i x1.h) (.val y1.i y1.h),
    .binop (.vector (.add {})) d2 (.val x2.i x2.h) (.val y2.i y2.h),
    .binop (.vector (.add {})) d3 (.val x3.i x3.h) (.val y3.i y3.h),
    .binop (.vector (.add {})) d4 (.val x4.i x4.h) (.val y4.i y4.h)]

/-- Where the body at `pos` is `addFastRun`, `x0 … x4` hold `X` and `y0 … y4` hold `Y`: running
on from `pos` then `g` gives `K` if it does from `pos + 5` with `X.addFast Y` in `d0 … d4`. -/
theorem runBodyFrom_addFastRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x0 y0 x1 y1 x2 y2 x3 y3 x4 y4 d0 d1 d2 d3 d4 : Dst Γ Ty4x64} {rest : List (Instr Γ)}
    {X Y : Quad5} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = addFastRun x0 y0 x1 y1 x2 y2 x3 y3 x4 y4 d0 d1 d2 d3 d4 ++ rest)
    (hR :
      E ⊨ [x0 := X.P0, x1 := X.P1, x2 := X.P2, x3 := X.P3, x4 := X.P4, y0 := Y.P0, y1 := Y.P1, y2 :=
        Y.P2, y3 := Y.P3, y4 := Y.P4])
    (hd :
      [x0.i, y0.i, x1.i, y1.i, x2.i, y2.i, x3.i, y3.i, x4.i, y4.i, d0.i, d1.i, d2.i, d3.i].Nodup)
    (hK :
      (blk.runBodyFrom
            E[d0 := Ty.wrap (X.addFast Y).P0, d1 := Ty.wrap (X.addFast Y).P1, d2 :=
              Ty.wrap (X.addFast Y).P2, d3 := Ty.wrap (X.addFast Y).P3, d4 :=
              Ty.wrap (X.addFast Y).P4]
            (pos + 5) S >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with e0
  step_pure with e1
  step_pure with e2
  step_pure with e3
  step_pure with e4
  rw [hE, he0, he1, he2, he3, he4]
  exact hK

/-! ### `FD_R52X5_QUAD_MUL_CONSTANT` -/

/-- `FD_R52X5_QUAD_MUL_CONSTANT( d, s, y )` as compiled: the products' low halves `z01` and high
halves `z12 … z52` (`zero` the accumulator), `2 z52` (`one` the splat 1) folded by 19 (`r19`) into
`d0`, and `dk = (zk2 + lo(y sk)) + zk2` through `ek`. -/
def mulConstRun
    (zero y r19 one s0 s1 s2 s3 s4 z01 z12 z22 z32 z42 z52 t5 d0 e1 d1 e2 d2 e3 d3 e4 d4 :
      Dst Γ Ty4x64) :
    List (Instr Γ) :=
  [.ternop .vpmadd52l z01 (.val zero.i zero.h) (.val y.i y.h) (.val s0.i s0.h),
    .ternop .vpmadd52h z12 (.val zero.i zero.h) (.val y.i y.h) (.val s0.i s0.h),
    .ternop .vpmadd52h z22 (.val zero.i zero.h) (.val y.i y.h) (.val s1.i s1.h),
    .ternop .vpmadd52h z32 (.val zero.i zero.h) (.val y.i y.h) (.val s2.i s2.h),
    .ternop .vpmadd52h z42 (.val zero.i zero.h) (.val y.i y.h) (.val s3.i s3.h),
    .ternop .vpmadd52h z52 (.val zero.i zero.h) (.val y.i y.h) (.val s4.i s4.h),
    .binop (.vector (.shl {})) t5 (.val z52.i z52.h) (.val one.i one.h),
    .ternop .vpmadd52l d0 (.val z01.i z01.h) (.val t5.i t5.h) (.val r19.i r19.h),
    .ternop .vpmadd52l e1 (.val z12.i z12.h) (.val y.i y.h) (.val s1.i s1.h),
    .binop (.vector (.add {})) d1 (.val e1.i e1.h) (.val z12.i z12.h),
    .ternop .vpmadd52l e2 (.val z22.i z22.h) (.val y.i y.h) (.val s2.i s2.h),
    .binop (.vector (.add {})) d2 (.val e2.i e2.h) (.val z22.i z22.h),
    .ternop .vpmadd52l e3 (.val z32.i z32.h) (.val y.i y.h) (.val s3.i s3.h),
    .binop (.vector (.add {})) d3 (.val e3.i e3.h) (.val z32.i z32.h),
    .ternop .vpmadd52l e4 (.val z42.i z42.h) (.val y.i y.h) (.val s4.i s4.h),
    .binop (.vector (.add {})) d4 (.val e4.i e4.h) (.val z42.i z42.h)]

/-- Where the body at `pos` is `mulConstRun`, `s0 … s4` hold `Q` and `y` holds `Y`: running on
from `pos` then `g` gives `K` if it does from `pos + 16` with `Q.mulConstant Y` in `d0 … d4`,
whatever the intermediates hold. -/
theorem runBodyFrom_mulConstRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {zero y r19 one s0 s1 s2 s3 s4 z01 z12 z22 z32 z42 z52 t5 d0 e1 d1 e2 d2 e3 d3 e4 d4 :
      Dst Γ Ty4x64}
    {rest : List (Instr Γ)} {Q : Quad5} {Y : Wl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        mulConstRun zero y r19 one s0 s1 s2 s3 s4 z01 z12 z22 z32 z42 z52 t5 d0 e1 d1 e2 d2 e3 d3 e4
            d4 ++
          rest)
    (hR :
      E ⊨ [zero := (Vector.replicate 4 0#64 : Wl), y := Y, r19 := (Vector.replicate 4 19#64 : Wl),
        one := (Vector.replicate 4 1#64 : Wl), s0 := Q.P0, s1 := Q.P1, s2 := Q.P2, s3 := Q.P3, s4 :=
        Q.P4])
    (hd :
      [zero.i, y.i, r19.i, one.i, s0.i, s1.i, s2.i, s3.i, s4.i, z01.i, z12.i, z22.i, z32.i, z42.i,
          z52.i, t5.i, d0.i, e1.i, d1.i, e2.i, d2.i, e3.i, d3.i, e4.i].Nodup)
    (hK :
      ∀ vz01 vz12 vz22 vz32 vz42 vz52 vt5 ve1 ve2 ve3 ve4 : ⟦Ty4x64⟧,
        (blk.runBodyFrom
              E[z01 := vz01, z12 := vz12, z22 := vz22, z32 := vz32, z42 := vz42, z52 := vz52, t5 :=
                vt5, d0 := Ty.wrap (Q.mulConstant Y).P0, e1 := ve1, d1 :=
                Ty.wrap (Q.mulConstant Y).P1, e2 := ve2, d2 := Ty.wrap (Q.mulConstant Y).P2, e3 :=
                ve3, d3 := Ty.wrap (Q.mulConstant Y).P3, e4 := ve4, d4 :=
                Ty.wrap (Q.mulConstant Y).P4]
              (pos + 16) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with transparent vz01
  step_pure with transparent vz12
  step_pure with transparent vz22
  step_pure with transparent vz32
  step_pure with transparent vz42
  step_pure with transparent vz52
  step_pure with transparent vt5
  step_pure with f0
  step_pure with transparent ve1
  step_pure with f1
  step_pure with transparent ve2
  step_pure with f2
  step_pure with transparent ve3
  step_pure with f3
  step_pure with transparent ve4
  step_pure with f4
  rw [wl_shl_one] at hf0
  rw [wl_add_madd52lo] at hf1 hf2 hf3 hf4
  rw [hE, hf0, hf1, hf2, hf3, hf4]
  exact hK _ _ _ _ _ _ _ _ _ _ _

/-! ### `FD_R52X5_QUAD_MUL_FAST`, `FD_R52X5_QUAD_SQR_FAST` -/

/-- `FD_R52X5_QUAD_MUL_FAST( q, x, y )` as compiled: `fd_r52x5_quad_mul_fast` into the slots
`z0 … z4`, then loaded into `q0 … q4`. -/
def qpMulRun (z0 z1 z2 z3 z4 : Dst Γ .ptr)
    (x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 q0 q1 q2 q3 q4 : Dst Γ Ty4x64) : List (Instr Γ) :=
  [.lifetimeStart (.val z0.i z0.h) 32, .lifetimeStart (.val z1.i z1.h) 32,
    .lifetimeStart (.val z2.i z2.h) 32, .lifetimeStart (.val z3.i z3.h) 32,
    .lifetimeStart (.val z4.i z4.h) 32,
    .call fd_r52x5_quad_mul_fast.call
      (.cons (.val z0.i z0.h)
        (.cons (.val z1.i z1.h)
          (.cons (.val z2.i z2.h)
            (.cons (.val z3.i z3.h)
              (.cons (.val z4.i z4.h)
                (.cons (.val x0.i x0.h)
                  (.cons (.val x1.i x1.h)
                    (.cons (.val x2.i x2.h)
                      (.cons (.val x3.i x3.h)
                        (.cons (.val x4.i x4.h)
                          (.cons (.val y0.i y0.h)
                            (.cons (.val y1.i y1.h)
                              (.cons (.val y2.i y2.h)
                                (.cons (.val y3.i y3.h) (.cons (.val y4.i y4.h) .nil)))))))))))))))
      .nil,
    .load q0 (.val z0.i z0.h), .load q1 (.val z1.i z1.h), .load q2 (.val z2.i z2.h),
    .load q3 (.val z3.i z3.h), .load q4 (.val z4.i z4.h), .lifetimeEnd (.val z4.i z4.h) 32,
    .lifetimeEnd (.val z3.i z3.h) 32, .lifetimeEnd (.val z2.i z2.h) 32,
    .lifetimeEnd (.val z1.i z1.h) 32, .lifetimeEnd (.val z0.i z0.h) 32]

/-- Where the body at `pos` is `qpMulRun`, `x0 … x4` hold `X`, `y0 … y4` hold `Y` and `z0 … z4`
five slots in distinct blocks: running on from `pos` then `g` gives `K` if it does from `pos + 16`
with the product (`fd_r52x5_quad_mul_fast.spec X Y`) in `q0 … q4` and left in the slots, their
lifetimes ended (`callTmp5`). -/
theorem runBodyFrom_qpMulRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {z0 z1 z2 z3 z4 : Dst Γ .ptr} {x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 q0 q1 q2 q3 q4 : Dst Γ Ty4x64}
    {rest : List (Instr Γ)} {X Y : Quad5} {Z0 Z1 Z2 Z3 Z4 : Pointer} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        qpMulRun z0 z1 z2 z3 z4 x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 q0 q1 q2 q3 q4 ++ rest)
    (hR :
      E ⊨ [x0 := X.P0, x1 := X.P1, x2 := X.P2, x3 := X.P3, x4 := X.P4, y0 := Y.P0, y1 := Y.P1, y2 :=
        Y.P2, y3 := Y.P3, y4 := Y.P4, z0 := Z0, z1 := Z1, z2 := Z2, z3 := Z3, z4 := Z4])
    (hwf : S.WF)
    (hZ :
      InBounds S.mem Z0 256 ∧
        InBounds S.mem Z1 256 ∧
        InBounds S.mem Z2 256 ∧ InBounds S.mem Z3 256 ∧ InBounds S.mem Z4 256)
    (hZw :
      Writable S.mem Z0 ∧
        Writable S.mem Z1 ∧ Writable S.mem Z2 ∧ Writable S.mem Z3 ∧ Writable S.mem Z4)
    (hne :
      Z1.id ≠ Z0.id ∧
        Z2.id ≠ Z0.id ∧
        Z3.id ≠ Z0.id ∧
        Z4.id ≠ Z0.id ∧
        Z2.id ≠ Z1.id ∧
        Z3.id ≠ Z1.id ∧ Z4.id ≠ Z1.id ∧ Z3.id ≠ Z2.id ∧ Z4.id ≠ Z2.id ∧ Z4.id ≠ Z3.id)
    (hK :
      (blk.runBodyFrom
            E[q0 := Ty.wrap (fd_r52x5_quad_mul_fast.spec X Y).P0, q1 :=
              Ty.wrap (fd_r52x5_quad_mul_fast.spec X Y).P1, q2 :=
              Ty.wrap (fd_r52x5_quad_mul_fast.spec X Y).P2, q3 :=
              Ty.wrap (fd_r52x5_quad_mul_fast.spec X Y).P3, q4 :=
              Ty.wrap (fd_r52x5_quad_mul_fast.spec X Y).P4]
            (pos + 16)
            { alloc := S.alloc,
              mem := S.mem.callTmp5 Z0 Z1 Z2 Z3 Z4 (fd_r52x5_quad_mul_fast.spec X Y) } >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hz0, hz1, hz2, hz3, hz4⟩ := hZ
  obtain ⟨hw0, hw1, hw2, hw3, hw4⟩ := hZw
  obtain ⟨h10, h20, h30, h40, h21, h31, h41, h32, h42, h43⟩ := hne
  iterate 5 step_pure
  step_call using fd_r52x5_quad_mul_fast.call_eq
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  iterate 5 step_pure
  rw [hE, hS]
  exact hK

/-- `qpMulRun` whose loads interleave with `getelementptr`s `g1 … g4` of the point at `p` the
product is then stored to (`reduceStoreRun`). -/
def qpMulGepRun (z0 z1 z2 z3 z4 : Dst Γ .ptr) (x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 : Dst Γ Ty4x64)
    (p : Reg Γ .ptr) (q0 q1 : Dst Γ Ty4x64) (g1 : Dst Γ .ptr) (q2 : Dst Γ Ty4x64) (g2 : Dst Γ .ptr)
    (q3 : Dst Γ Ty4x64) (g3 : Dst Γ .ptr) (q4 : Dst Γ Ty4x64) (g4 : Dst Γ .ptr) : List (Instr Γ) :=
  [.lifetimeStart (.val z0.i z0.h) 32, .lifetimeStart (.val z1.i z1.h) 32,
    .lifetimeStart (.val z2.i z2.h) 32, .lifetimeStart (.val z3.i z3.h) 32,
    .lifetimeStart (.val z4.i z4.h) 32,
    .call fd_r52x5_quad_mul_fast.call
      (.cons (.val z0.i z0.h)
        (.cons (.val z1.i z1.h)
          (.cons (.val z2.i z2.h)
            (.cons (.val z3.i z3.h)
              (.cons (.val z4.i z4.h)
                (.cons (.val x0.i x0.h)
                  (.cons (.val x1.i x1.h)
                    (.cons (.val x2.i x2.h)
                      (.cons (.val x3.i x3.h)
                        (.cons (.val x4.i x4.h)
                          (.cons (.val y0.i y0.h)
                            (.cons (.val y1.i y1.h)
                              (.cons (.val y2.i y2.h)
                                (.cons (.val y3.i y3.h) (.cons (.val y4.i y4.h) .nil)))))))))))))))
      .nil,
    .load q0 (.val z0.i z0.h), .load q1 (.val z1.i z1.h),
    .unop (.gepConst { nusw := true, nuw := true } 32) g1 p, .load q2 (.val z2.i z2.h),
    .unop (.gepConst { nusw := true, nuw := true } 64) g2 p, .load q3 (.val z3.i z3.h),
    .unop (.gepConst { nusw := true, nuw := true } 96) g3 p, .load q4 (.val z4.i z4.h),
    .unop (.gepConst { nusw := true, nuw := true } 128) g4 p, .lifetimeEnd (.val z4.i z4.h) 32,
    .lifetimeEnd (.val z3.i z3.h) 32, .lifetimeEnd (.val z2.i z2.h) 32,
    .lifetimeEnd (.val z1.i z1.h) 32, .lifetimeEnd (.val z0.i z0.h) 32]

/-- `runBodyFrom_qpMulRun` for `qpMulGepRun`, `p` holding the point `P`: also `P + 32 k` in
`gk`. -/
theorem runBodyFrom_qpMulGepRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {z0 z1 z2 z3 z4 : Dst Γ .ptr} {x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 : Dst Γ Ty4x64} {p : Reg Γ .ptr}
    {q0 q1 q2 q3 q4 : Dst Γ Ty4x64} {g1 g2 g3 g4 : Dst Γ .ptr} {rest : List (Instr Γ)} {X Y : Quad5}
    {P Z0 Z1 Z2 Z3 Z4 : Pointer} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        qpMulGepRun z0 z1 z2 z3 z4 x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 p q0 q1 g1 q2 g2 q3 g3 q4 g4 ++
          rest)
    (hR :
      E ⊨ [x0 := X.P0, x1 := X.P1, x2 := X.P2, x3 := X.P3, x4 := X.P4, y0 := Y.P0, y1 := Y.P1, y2 :=
        Y.P2, y3 := Y.P3, y4 := Y.P4, z0 := Z0, z1 := Z1, z2 := Z2, z3 := Z3, z4 := Z4, p := P])
    (hwf : S.WF) (hP : S.mem.Quad5Room P)
    (hPZ : P.id ≠ Z0.id ∧ P.id ≠ Z1.id ∧ P.id ≠ Z2.id ∧ P.id ≠ Z3.id ∧ P.id ≠ Z4.id)
    (hp : p ≠ .val g1.i g1.h ∧ p ≠ .val g2.i g2.h ∧ p ≠ .val g3.i g3.h)
    (hd : [z0.i, z1.i, z2.i, z3.i, z4.i, g1.i, g2.i, g3.i, g4.i].Nodup)
    (hZ :
      InBounds S.mem Z0 256 ∧
        InBounds S.mem Z1 256 ∧
        InBounds S.mem Z2 256 ∧ InBounds S.mem Z3 256 ∧ InBounds S.mem Z4 256)
    (hZw :
      Writable S.mem Z0 ∧
        Writable S.mem Z1 ∧ Writable S.mem Z2 ∧ Writable S.mem Z3 ∧ Writable S.mem Z4)
    (hne :
      Z1.id ≠ Z0.id ∧
        Z2.id ≠ Z0.id ∧
        Z3.id ≠ Z0.id ∧
        Z4.id ≠ Z0.id ∧
        Z2.id ≠ Z1.id ∧
        Z3.id ≠ Z1.id ∧ Z4.id ≠ Z1.id ∧ Z3.id ≠ Z2.id ∧ Z4.id ≠ Z2.id ∧ Z4.id ≠ Z3.id)
    (hK :
      (blk.runBodyFrom
            E[q0 := Ty.wrap (fd_r52x5_quad_mul_fast.spec X Y).P0, q1 :=
              Ty.wrap (fd_r52x5_quad_mul_fast.spec X Y).P1, g1 := .value (P.add 32#64), q2 :=
              Ty.wrap (fd_r52x5_quad_mul_fast.spec X Y).P2, g2 := .value (P.add 64#64), q3 :=
              Ty.wrap (fd_r52x5_quad_mul_fast.spec X Y).P3, g3 := .value (P.add 96#64), q4 :=
              Ty.wrap (fd_r52x5_quad_mul_fast.spec X Y).P4, g4 := .value (P.add 128#64)]
            (pos + 20)
            { alloc := S.alloc,
              mem := S.mem.callTmp5 Z0 Z1 Z2 Z3 Z4 (fd_r52x5_quad_mul_fast.spec X Y) } >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hz0, hz1, hz2, hz3, hz4⟩ := hZ
  obtain ⟨hw0, hw1, hw2, hw3, hw4⟩ := hZw
  obtain ⟨h10, h20, h30, h40, h21, h31, h41, h32, h42, h43⟩ := hne
  obtain ⟨hP0, hP1, hP2, hP3, hP4⟩ := hPZ
  obtain ⟨hp1, hp2, hp3⟩ := hp
  iterate 5 step_pure
  step_call using fd_r52x5_quad_mul_fast.call_eq
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  step_pure
  step_load [ofFn_extractVecElem_readAt] inline
  step_pure
  step_load [ofFn_extractVecElem_readAt] inline
  step_pure
  step_load [ofFn_extractVecElem_readAt] inline
  step_pure
  iterate 5 step_pure
  rw [hE, hS]
  exact hK

/-- `FD_R52X5_QUAD_SQR_FAST( q, x )` as compiled: `fd_r52x5_quad_sqr_fast` into the slots
`z0 … z4`, then loaded into `q0 … q4`. -/
def qpSqrRun (z0 z1 z2 z3 z4 : Dst Γ .ptr) (x0 x1 x2 x3 x4 q0 q1 q2 q3 q4 : Dst Γ Ty4x64) :
    List (Instr Γ) :=
  [.lifetimeStart (.val z0.i z0.h) 32, .lifetimeStart (.val z1.i z1.h) 32,
    .lifetimeStart (.val z2.i z2.h) 32, .lifetimeStart (.val z3.i z3.h) 32,
    .lifetimeStart (.val z4.i z4.h) 32,
    .call fd_r52x5_quad_sqr_fast.call
      (.cons (.val z0.i z0.h)
        (.cons (.val z1.i z1.h)
          (.cons (.val z2.i z2.h)
            (.cons (.val z3.i z3.h)
              (.cons (.val z4.i z4.h)
                (.cons (.val x0.i x0.h)
                  (.cons (.val x1.i x1.h)
                    (.cons (.val x2.i x2.h)
                      (.cons (.val x3.i x3.h) (.cons (.val x4.i x4.h) .nil))))))))))
      .nil,
    .load q0 (.val z0.i z0.h), .load q1 (.val z1.i z1.h), .load q2 (.val z2.i z2.h),
    .load q3 (.val z3.i z3.h), .load q4 (.val z4.i z4.h), .lifetimeEnd (.val z4.i z4.h) 32,
    .lifetimeEnd (.val z3.i z3.h) 32, .lifetimeEnd (.val z2.i z2.h) 32,
    .lifetimeEnd (.val z1.i z1.h) 32, .lifetimeEnd (.val z0.i z0.h) 32]

/-- `runBodyFrom_qpMulRun` for `qpSqrRun`: the square `fd_r52x5_quad_sqr_fast.spec X`. -/
theorem runBodyFrom_qpSqrRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {z0 z1 z2 z3 z4 : Dst Γ .ptr} {x0 x1 x2 x3 x4 q0 q1 q2 q3 q4 : Dst Γ Ty4x64}
    {rest : List (Instr Γ)} {X : Quad5} {Z0 Z1 Z2 Z3 Z4 : Pointer} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = qpSqrRun z0 z1 z2 z3 z4 x0 x1 x2 x3 x4 q0 q1 q2 q3 q4 ++ rest)
    (hR :
      E ⊨ [x0 := X.P0, x1 := X.P1, x2 := X.P2, x3 := X.P3, x4 := X.P4, z0 := Z0, z1 := Z1, z2 := Z2,
        z3 := Z3, z4 := Z4])
    (hwf : S.WF)
    (hZ :
      InBounds S.mem Z0 256 ∧
        InBounds S.mem Z1 256 ∧
        InBounds S.mem Z2 256 ∧ InBounds S.mem Z3 256 ∧ InBounds S.mem Z4 256)
    (hZw :
      Writable S.mem Z0 ∧
        Writable S.mem Z1 ∧ Writable S.mem Z2 ∧ Writable S.mem Z3 ∧ Writable S.mem Z4)
    (hne :
      Z1.id ≠ Z0.id ∧
        Z2.id ≠ Z0.id ∧
        Z3.id ≠ Z0.id ∧
        Z4.id ≠ Z0.id ∧
        Z2.id ≠ Z1.id ∧
        Z3.id ≠ Z1.id ∧ Z4.id ≠ Z1.id ∧ Z3.id ≠ Z2.id ∧ Z4.id ≠ Z2.id ∧ Z4.id ≠ Z3.id)
    (hK :
      (blk.runBodyFrom
            E[q0 := Ty.wrap (fd_r52x5_quad_sqr_fast.spec X).P0, q1 :=
              Ty.wrap (fd_r52x5_quad_sqr_fast.spec X).P1, q2 :=
              Ty.wrap (fd_r52x5_quad_sqr_fast.spec X).P2, q3 :=
              Ty.wrap (fd_r52x5_quad_sqr_fast.spec X).P3, q4 :=
              Ty.wrap (fd_r52x5_quad_sqr_fast.spec X).P4]
            (pos + 16)
            { alloc := S.alloc,
              mem := S.mem.callTmp5 Z0 Z1 Z2 Z3 Z4 (fd_r52x5_quad_sqr_fast.spec X) } >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hz0, hz1, hz2, hz3, hz4⟩ := hZ
  obtain ⟨hw0, hw1, hw2, hw3, hw4⟩ := hZw
  obtain ⟨h10, h20, h30, h40, h21, h31, h41, h32, h42, h43⟩ := hne
  iterate 5 step_pure
  step_call using fd_r52x5_quad_sqr_fast.call_eq
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  step_load [ofFn_extractVecElem_readAt] inline
  iterate 5 step_pure
  rw [hE, hS]
  exact hK

/-! ### `FD_R52X5_QUAD_PACK` -/

/-- Bytes `8 k …` of a `long[8]` array at offset 0 fit. -/
theorem fits_wwl_lane {m : MemoryState} {t : Pointer} (h : Fits m t 512) (ho : t.offset = 0)
    (hk : k ≤ 4) (hw : 8 * k * 8 + w ≤ 512) : Fits m (t.add (BitVec.ofNat 64 (8 * k))) w :=
  Fits.add_of_le
    (by
      simp [BitVec.uaddOverflow, ho]; omega)
    (by
      simp; omega)
    h

/-- The `i64` at `t + 8 k` of an array holding `X`: `X[k]`. -/
theorem readAt_wwl_lane {m : MemoryState} {t : Pointer} {X : Wwl} (h : Fits m t 512)
    (ho : t.offset = 0) (hr : m.readAt t 512 = BitVec.packLanes X) (hk : k < 8) :
    m.readAt (t.add (BitVec.ofNat 64 (8 * k))) 64 = X[k] := by
  rw [MemoryState.readAt_add_of_readAt h.inBounds
      (by
        simp [BitVec.uaddOverflow, ho]; omega)
      (by
        simp; omega)
      hr]
  have e : (BitVec.ofNat 64 (8 * k)).toNat * 8 = k * 64 := by
    simp; omega
  rw [e, BitVec.extractLsb'_packLanes X k hk]

/-- The `<4 x i64>` at `t + 8 k` of an array holding `X`: lanes `k … k + 3`. -/
theorem readAt_wwl_lanes {m : MemoryState} {t : Pointer} {X : Wwl} (h : Fits m t 512)
    (ho : t.offset = 0) (hr : m.readAt t 512 = BitVec.packLanes X) (hk : k ≤ 4) :
    m.readAt (t.add (BitVec.ofNat 64 (8 * k))) 256 =
      BitVec.packLanes (#v[X[k], X[k + 1], X[k + 2], X[k + 3]] : Wl) := by
  rw [MemoryState.readAt_add_of_readAt h.inBounds
      (by
        simp [BitVec.uaddOverflow, ho]; omega)
      (by
        simp; omega)
      hr]
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  have e : (BitVec.ofNat 64 (8 * k)).toNat * 8 = k * 64 := by
    simp; omega
  rw [e, BitVec.getLsbD_extractLsb', BitVec.getLsbD_packLanes_wl _ hi]
  simp only [hi, decide_true, Bool.true_and]
  have h1 := BitVec.extractLsb'_packLanes X (k + i / 64) (by omega)
  have h2 := congrArg (fun y => y.getLsbD (i % 64)) h1
  simp only [BitVec.getLsbD_extractLsb', show i % 64 < 64 by omega, decide_true, Bool.true_and,
    show (k + i / 64) * 64 + i % 64 = k * 64 + i by omega] at h2
  rw [h2]
  obtain h | h | h | h : i / 64 = 0 ∨ i / 64 = 1 ∨ i / 64 = 2 ∨ i / 64 = 3 := by omega
  all_goals simp [h]

/-- One `Qk = wl( _x[k], _y[k], _z[k], _t[k] )` of `FD_R52X5_QUAD_PACK`, `k ≥ 1`, as compiled from
the `long[8]` arrays `tx ty tz tt`: a `<4 x i64>` load at `tx + 8k` (through `gx`) into `vx`, the
`i64`s at `ty, tz, tt + 8k` into `vy vz vt`, inserted at lanes `1 2 3` (`n1 n2 n3`) through
`w1 w2` into `w3`. -/
def packLimbRun (o : Int) (tx ty tz tt : Reg Γ .ptr) (n1 n2 n3 : Reg Γ (.bv 64))
    (gx gy gz gt : Dst Γ .ptr) (vx : Dst Γ Ty4x64) (vy vz vt : Dst Γ (.bv 64))
    (w1 w2 w3 : Dst Γ Ty4x64) : List (Instr Γ) :=
  [.unop (.gepConst { nusw := true, nuw := true } o) gx tx, .load vx (.val gx.i gx.h),
    .unop (.gepConst { nusw := true, nuw := true } o) gy ty, .load vy (.val gy.i gy.h),
    .unop (.gepConst { nusw := true, nuw := true } o) gz tz, .load vz (.val gz.i gz.h),
    .unop (.gepConst { nusw := true, nuw := true } o) gt tt, .load vt (.val gt.i gt.h),
    .ternop .insertelement w1 (.val vx.i vx.h) (.val vy.i vy.h) n1,
    .ternop .insertelement w2 (.val w1.i w1.h) (.val vz.i vz.h) n2,
    .ternop .insertelement w3 (.val w2.i w2.h) (.val vt.i vt.h) n3]

/-- Where the body at `pos` is `packLimbRun (8 k)`, `n1 n2 n3` hold `1 2 3` and `tx … tt` the
arrays holding `X Y Z T`: running on from `pos` then `g` gives `K` if it does from `pos + 11` with
`(Quad5.pack X Y Z T)`'s limb `k` in `w3`, whatever the intermediates hold. -/
theorem runBodyFrom_packLimbRun (k : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {o : Int} {tx ty tz tt : Reg Γ .ptr} {n1 n2 n3 : Reg Γ (.bv 64)} {gx gy gz gt : Dst Γ .ptr}
    {vx : Dst Γ Ty4x64} {vy vz vt : Dst Γ (.bv 64)} {w1 w2 w3 : Dst Γ Ty4x64}
    {rest : List (Instr Γ)} {TX TY TZ TT : Pointer} {X Y Z T : Wwl}
    {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        packLimbRun o tx ty tz tt n1 n2 n3 gx gy gz gt vx vy vz vt w1 w2 w3 ++ rest)
    (hR :
      E ⊨ [tx := TX, ty := TY, tz := TZ, tt := TT, n1 := 1#64, n2 := 2#64, n3 := 3#64])
    (ho : o = 8 * k) (hk : 1 ≤ k ∧ k ≤ 4)
    (hX : S.mem.readAt TX 512 = BitVec.packLanes X) (hY : S.mem.readAt TY 512 = BitVec.packLanes Y)
    (hZ : S.mem.readAt TZ 512 = BitVec.packLanes Z) (hT : S.mem.readAt TT 512 = BitVec.packLanes T)
    (hF : Fits S.mem TX 512 ∧ Fits S.mem TY 512 ∧ Fits S.mem TZ 512 ∧ Fits S.mem TT 512)
    (hO : TX.offset = 0 ∧ TY.offset = 0 ∧ TZ.offset = 0 ∧ TT.offset = 0)
    (hp :
      ty ≠ .val gx.i gx.h ∧ tz ≠ .val gx.i gx.h ∧ tz ≠ .val gy.i gy.h ∧ tt ≠ .val gx.i gx.h ∧
        tt ≠ .val gy.i gy.h ∧ tt ≠ .val gz.i gz.h)
    (hn :
      n1 ≠ .val vy.i vy.h ∧ n1 ≠ .val vz.i vz.h ∧ n1 ≠ .val vt.i vt.h ∧ n2 ≠ .val vy.i vy.h ∧
        n2 ≠ .val vz.i vz.h ∧ n2 ≠ .val vt.i vt.h ∧ n3 ≠ .val vy.i vy.h ∧ n3 ≠ .val vz.i vz.h ∧
        n3 ≠ .val vt.i vt.h)
    (hd : [vy.i, vz.i, vt.i].Nodup)
    (hK :
      ∀ (pgx pgy pgz pgt : Pointer) (vvx : ⟦Ty4x64⟧) (vvy vvz vvt : BitVec 64) (vw1 vw2 : ⟦Ty4x64⟧),
        (blk.runBodyFrom
              E[gx := .value pgx, vx := vvx, gy := .value pgy, vy := .value vvy, gz := .value pgz,
                vz := .value vvz, gt := .value pgt, vt := .value vvt, w1 := vw1, w2 := vw2,
                w3 := Ty.wrap (wl (X[k]'(by omega)) (Y[k]'(by omega)) (Z[k]'(by omega))
                  (T[k]'(by omega)))] (pos + 11) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  subst ho
  obtain ⟨hk1, hk4⟩ := hk
  obtain ⟨hfx, hfy, hfz, hft⟩ := hF
  obtain ⟨hox, hoy, hoz, hot⟩ := hO
  obtain ⟨hp1, hp2, hp3, hp4, hp5, hp6⟩ := hp
  obtain ⟨hn1, hn2, hn3, hn4, hn5, hn6, hn7, hn8, hn9⟩ := hn
  have h0 : (0 : Int) ≤ 8 * ↑k := by omega
  have hn : (8 * (k : Int)).toNat = 8 * k := by omega
  have fx := fits_wwl_lane hfx hox hk4 (w := 256) (by omega)
  have fy := fits_wwl_lane hfy hoy hk4 (w := 64) (by omega)
  have fz := fits_wwl_lane hfz hoz hk4 (w := 64) (by omega)
  have ft := fits_wwl_lane hft hot hk4 (w := 64) (by omega)
  have rx := readAt_wwl_lanes hfx hox hX hk4
  have ry := readAt_wwl_lane hfy hoy hY (k := k) (by omega)
  have rz := readAt_wwl_lane hfz hoz hZ (k := k) (by omega)
  have rt := readAt_wwl_lane hft hot hT (k := k) (by omega)
  step_pure [h0, hn]
  step_load
  step_pure [h0, hn]
  step_load
  step_pure [h0, hn]
  step_load
  step_pure [h0, hn]
  step_load
  step_pure
  step_pure
  step_pure
  rw [hE, hS]
  convert hK _ _ _ _ _ _ _ _ _ _ using 6
  ext i hi
  obtain rfl | rfl | rfl | rfl : i = 0 ∨ i = 1 ∨ i = 2 ∨ i = 3 := by omega
  all_goals simp [wl]

/-- `packLimbRun` for `Q0 = wl( _x[0], _y[0], _z[0], _t[0] )`: no `getelementptr`s. -/
def packLimbRun0 (tx ty tz tt : Reg Γ .ptr) (n1 n2 n3 : Reg Γ (.bv 64)) (vx : Dst Γ Ty4x64)
    (vy vz vt : Dst Γ (.bv 64)) (w1 w2 w3 : Dst Γ Ty4x64) : List (Instr Γ) :=
  [.load vx tx, .load vy ty, .load vz tz, .load vt tt,
    .ternop .insertelement w1 (.val vx.i vx.h) (.val vy.i vy.h) n1,
    .ternop .insertelement w2 (.val w1.i w1.h) (.val vz.i vz.h) n2,
    .ternop .insertelement w3 (.val w2.i w2.h) (.val vt.i vt.h) n3]

/-- `runBodyFrom_packLimbRun` for `packLimbRun0`: limb 0 in `w3`. -/
theorem runBodyFrom_packLimbRun0 {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {tx ty tz tt : Reg Γ .ptr} {n1 n2 n3 : Reg Γ (.bv 64)} {vx : Dst Γ Ty4x64}
    {vy vz vt : Dst Γ (.bv 64)} {w1 w2 w3 : Dst Γ Ty4x64} {rest : List (Instr Γ)}
    {TX TY TZ TT : Pointer} {X Y Z T : Wwl} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = packLimbRun0 tx ty tz tt n1 n2 n3 vx vy vz vt w1 w2 w3 ++ rest)
    (hR :
      E ⊨ [tx := TX, ty := TY, tz := TZ, tt := TT, n1 := 1#64, n2 := 2#64, n3 := 3#64])
    (hX : S.mem.readAt TX 512 = BitVec.packLanes X) (hY : S.mem.readAt TY 512 = BitVec.packLanes Y)
    (hZ : S.mem.readAt TZ 512 = BitVec.packLanes Z) (hT : S.mem.readAt TT 512 = BitVec.packLanes T)
    (hF : Fits S.mem TX 512 ∧ Fits S.mem TY 512 ∧ Fits S.mem TZ 512 ∧ Fits S.mem TT 512)
    (hO : TX.offset = 0 ∧ TY.offset = 0 ∧ TZ.offset = 0 ∧ TT.offset = 0)
    (hn :
      n1 ≠ .val vy.i vy.h ∧ n1 ≠ .val vz.i vz.h ∧ n1 ≠ .val vt.i vt.h ∧ n2 ≠ .val vy.i vy.h ∧
        n2 ≠ .val vz.i vz.h ∧ n2 ≠ .val vt.i vt.h ∧ n3 ≠ .val vy.i vy.h ∧ n3 ≠ .val vz.i vz.h ∧
        n3 ≠ .val vt.i vt.h)
    (hd : [vy.i, vz.i, vt.i].Nodup)
    (hK :
      ∀ (vvx : ⟦Ty4x64⟧) (vvy vvz vvt : BitVec 64) (vw1 vw2 : ⟦Ty4x64⟧),
        (blk.runBodyFrom
              E[vx := vvx, vy := .value vvy, vz := .value vvz, vt := .value vvt, w1 := vw1,
                w2 := vw2, w3 := Ty.wrap (wl X[0] Y[0] Z[0] T[0])] (pos + 7) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨hfx, hfy, hfz, hft⟩ := hF
  obtain ⟨hox, hoy, hoz, hot⟩ := hO
  obtain ⟨hn1, hn2, hn3, hn4, hn5, hn6, hn7, hn8, hn9⟩ := hn
  have fx := fits_wwl_lane hfx hox (k := 0) (by omega) (w := 256) (by omega)
  have fy := fits_wwl_lane hfy hoy (k := 0) (by omega) (w := 64) (by omega)
  have fz := fits_wwl_lane hfz hoz (k := 0) (by omega) (w := 64) (by omega)
  have ft := fits_wwl_lane hft hot (k := 0) (by omega) (w := 64) (by omega)
  have rx := readAt_wwl_lanes hfx hox hX (k := 0) (by omega)
  have ry := readAt_wwl_lane hfy hoy hY (k := 0) (by omega)
  have rz := readAt_wwl_lane hfz hoz hZ (k := 0) (by omega)
  have rt := readAt_wwl_lane hft hot hT (k := 0) (by omega)
  simp only [Nat.mul_zero, Pointer.add_ofNat_zero, Nat.zero_add] at fx fy fz ft rx ry rz rt
  iterate 4 step_load
  iterate 3 step_pure
  rw [hE, hS]
  convert hK _ _ _ _ _ _ using 6
  ext i hi
  obtain rfl | rfl | rfl | rfl : i = 0 ∨ i = 1 ∨ i = 2 ∨ i = 3 := by omega
  all_goals simp [wl]

/-! ### `FD_R52X5_QUAD_PERMUTE` -/

theorem laneImm_toNat {j : Nat} (h : j < 4) : (laneImm j).toNat = j := by
  simp only [laneImm, BitVec.toNat_ofNat]
  omega

/-- `FD_R52X5_QUAD_PERMUTE( d, j0,j1,j2,j3, x )` as compiled: five `wl_permute` calls, of `x0 … x4`
by the immediates in `c0 … c3`, into `r0 … r4`. -/
def permuteRun (c0 c1 c2 c3 : Reg Γ (.bv 32)) (x0 x1 x2 x3 x4 r0 r1 r2 r3 r4 : Dst Γ Ty4x64) :
    List (Instr Γ) :=
  [.call wl_permute.call (.cons (.val x0.i x0.h) (.cons c0 (.cons c1 (.cons c2 (.cons c3 .nil)))))
      (.cons r0 .nil),
    .call wl_permute.call (.cons (.val x1.i x1.h) (.cons c0 (.cons c1 (.cons c2 (.cons c3 .nil)))))
      (.cons r1 .nil),
    .call wl_permute.call (.cons (.val x2.i x2.h) (.cons c0 (.cons c1 (.cons c2 (.cons c3 .nil)))))
      (.cons r2 .nil),
    .call wl_permute.call (.cons (.val x3.i x3.h) (.cons c0 (.cons c1 (.cons c2 (.cons c3 .nil)))))
      (.cons r3 .nil),
    .call wl_permute.call (.cons (.val x4.i x4.h) (.cons c0 (.cons c1 (.cons c2 (.cons c3 .nil)))))
      (.cons r4 .nil)]

/-- Where the body at `pos` is `permuteRun`, `c0 … c3` hold the immediates (each below 4) and
`x0 … x4` hold `X`: running on from `pos` then `g` gives `K` if it does from `pos + 5` with
`X.permute j0 j1 j2 j3` in `r0 … r4`, five blocks on (the calls' freed unions). -/
theorem runBodyFrom_permuteRun (j0 j1 j2 j3 : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
    {pos : Nat} {c0 c1 c2 c3 : Reg Γ (.bv 32)} {x0 x1 x2 x3 x4 r0 r1 r2 r3 r4 : Dst Γ Ty4x64}
    {rest : List (Instr Γ)} {X : Quad5} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody : blk.body.drop pos = permuteRun c0 c1 c2 c3 x0 x1 x2 x3 x4 r0 r1 r2 r3 r4 ++ rest)
    (hR :
      E ⊨ [c0 := laneImm j0, c1 := laneImm j1, c2 := laneImm j2, c3 := laneImm j3, x0 := X.P0, x1 :=
        X.P1, x2 := X.P2, x3 := X.P3, x4 := X.P4])
    (hj : j0 < 4 ∧ j1 < 4 ∧ j2 < 4 ∧ j3 < 4) (hwf : S.WF)
    (hd : [x0.i, x1.i, x2.i, x3.i, x4.i, r0.i, r1.i, r2.i, r3.i].Nodup)
    (hK :
      (blk.runBodyFrom
            E[r0 := Ty.wrap (X.permute j0 j1 j2 j3).P0, r1 := Ty.wrap (X.permute j0 j1 j2 j3).P1,
              r2 := Ty.wrap (X.permute j0 j1 j2 j3).P2, r3 := Ty.wrap (X.permute j0 j1 j2 j3).P3,
              r4 := Ty.wrap (X.permute j0 j1 j2 j3).P4]
            (pos + 5) { alloc := ⟨S.alloc.nextFreeBlock + 5⟩, mem := S.mem } >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨h0, h1, h2, h3⟩ := hj
  have e0 := laneImm_toNat h0
  have e1 := laneImm_toNat h1
  have e2 := laneImm_toNat h2
  have e3 := laneImm_toNat h3
  have hi :
    (laneImm j0).toNat < 4 ∧
      (laneImm j1).toNat < 4 ∧ (laneImm j2).toNat < 4 ∧ (laneImm j3).toNat < 4 := by
    simp only [e0, e1, e2, e3]
    exact ⟨h0, h1, h2, h3⟩
  step_call using wl_permute.call_eq [e0, e1, e2, e3]
  step_call using wl_permute.call_eq [e0, e1, e2, e3]
  step_call using wl_permute.call_eq [e0, e1, e2, e3]
  step_call using wl_permute.call_eq [e0, e1, e2, e3]
  step_call using wl_permute.call_eq [e0, e1, e2, e3]
  rw [hE, hS]
  exact hK

/-- `FD_R52X5_QUAD_PERMUTE( d, j0,j1,j2,j3, p->P )` as compiled: each `wl_t` of the point at `p`
loaded into `xk` (through `g1 … g4`, `p + 32 k`) and permuted into `rk`. -/
def permuteLoadRun (c0 c1 c2 c3 : Reg Γ (.bv 32)) (p : Reg Γ .ptr) (g1 g2 g3 g4 : Dst Γ .ptr)
    (x0 x1 x2 x3 x4 r0 r1 r2 r3 r4 : Dst Γ Ty4x64) : List (Instr Γ) :=
  [.load x0 p,
    .call wl_permute.call (.cons (.val x0.i x0.h) (.cons c0 (.cons c1 (.cons c2 (.cons c3 .nil)))))
      (.cons r0 .nil),
    .unop (.gepConst { nusw := true, nuw := true } 32) g1 p, .load x1 (.val g1.i g1.h),
    .call wl_permute.call (.cons (.val x1.i x1.h) (.cons c0 (.cons c1 (.cons c2 (.cons c3 .nil)))))
      (.cons r1 .nil),
    .unop (.gepConst { nusw := true, nuw := true } 64) g2 p, .load x2 (.val g2.i g2.h),
    .call wl_permute.call (.cons (.val x2.i x2.h) (.cons c0 (.cons c1 (.cons c2 (.cons c3 .nil)))))
      (.cons r2 .nil),
    .unop (.gepConst { nusw := true, nuw := true } 96) g3 p, .load x3 (.val g3.i g3.h),
    .call wl_permute.call (.cons (.val x3.i x3.h) (.cons c0 (.cons c1 (.cons c2 (.cons c3 .nil)))))
      (.cons r3 .nil),
    .unop (.gepConst { nusw := true, nuw := true } 128) g4 p, .load x4 (.val g4.i g4.h),
    .call wl_permute.call (.cons (.val x4.i x4.h) (.cons c0 (.cons c1 (.cons c2 (.cons c3 .nil)))))
      (.cons r4 .nil)]

/-- Where the body at `pos` is `permuteLoadRun`, `c0 … c3` hold the immediates (each below 4)
and `p` the point `P`: running on from `pos` then `g` gives `K` if it does from `pos + 14` with
`P`'s `wl_t`s (as `A`) in `x0 … x4`, their permutation in `r0 … r4` and `P + 32 k` in `gk`, five
blocks on. -/
theorem runBodyFrom_permuteLoadRun (j0 j1 j2 j3 : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
    {pos : Nat} {c0 c1 c2 c3 : Reg Γ (.bv 32)} {p : Reg Γ .ptr} {g1 g2 g3 g4 : Dst Γ .ptr}
    {x0 x1 x2 x3 x4 r0 r1 r2 r3 r4 : Dst Γ Ty4x64} {rest : List (Instr Γ)} {P : Pointer}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        permuteLoadRun c0 c1 c2 c3 p g1 g2 g3 g4 x0 x1 x2 x3 x4 r0 r1 r2 r3 r4 ++ rest)
    (hR : E ⊨ [c0 := laneImm j0, c1 := laneImm j1, c2 := laneImm j2, c3 := laneImm j3, p := P])
    (hj : j0 < 4 ∧ j1 < 4 ∧ j2 < 4 ∧ j3 < 4) (hwf : S.WF) (hP : S.mem.Quad5Fit P)
    (hp : p ≠ .val g1.i g1.h ∧ p ≠ .val g2.i g2.h ∧ p ≠ .val g3.i g3.h)
    (hK :
      ∀ (A : Quad5) (_hA : S.mem.readQuad5 P = A),
        (blk.runBodyFrom
              E[x0 := Ty.wrap A.P0, r0 := Ty.wrap (A.permute j0 j1 j2 j3).P0, g1 :=
                .value (P.add 32#64), x1 := Ty.wrap A.P1, r1 := Ty.wrap (A.permute j0 j1 j2 j3).P1,
                g2 := .value (P.add 64#64), x2 := Ty.wrap A.P2, r2 :=
                Ty.wrap (A.permute j0 j1 j2 j3).P2, g3 := .value (P.add 96#64), x3 := Ty.wrap A.P3,
                r3 := Ty.wrap (A.permute j0 j1 j2 j3).P3, g4 := .value (P.add 128#64), x4 :=
                Ty.wrap A.P4, r4 := Ty.wrap (A.permute j0 j1 j2 j3).P4]
              (pos + 14) { alloc := ⟨S.alloc.nextFreeBlock + 5⟩, mem := S.mem } >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨h0, h1, h2, h3⟩ := hj
  obtain ⟨hp1, hp2, hp3⟩ := hp
  have eA :
    ∀ v0 v1 v2 v3 v4,
      v0 = S.mem.readWv P →
        v1 = S.mem.readWv (P.add 32#64) →
        v2 = S.mem.readWv (P.add 64#64) →
        v3 = S.mem.readWv (P.add 96#64) →
        v4 = S.mem.readWv (P.add 128#64) → S.mem.readQuad5 P = ⟨v0, v1, v2, v3, v4⟩ := by
    intros
    subst_vars
    rfl
  have e0 := laneImm_toNat h0
  have e1 := laneImm_toNat h1
  have e2 := laneImm_toNat h2
  have e3 := laneImm_toNat h3
  have hi :
    (laneImm j0).toNat < 4 ∧
      (laneImm j1).toNat < 4 ∧ (laneImm j2).toNat < 4 ∧ (laneImm j3).toNat < 4 := by
    simp only [e0, e1, e2, e3]
    exact ⟨h0, h1, h2, h3⟩
  step_load [ofFn_extractVecElem_readAt] with v0
  step_call using wl_permute.call_eq [e0, e1, e2, e3]
  step_pure
  step_load [ofFn_extractVecElem_readAt] with v1
  step_call using wl_permute.call_eq [e0, e1, e2, e3]
  step_pure
  step_load [ofFn_extractVecElem_readAt] with v2
  step_call using wl_permute.call_eq [e0, e1, e2, e3]
  step_pure
  step_load [ofFn_extractVecElem_readAt] with v3
  step_call using wl_permute.call_eq [e0, e1, e2, e3]
  step_pure
  step_load [ofFn_extractVecElem_readAt] with v4
  step_call using wl_permute.call_eq [e0, e1, e2, e3]
  rw [hE, hS]
  have h := hK ⟨v0, v1, v2, v3, v4⟩ (eA _ _ _ _ _ hv0 hv1 hv2 hv3 hv4)
  exact h

/-! ### `FD_R52X5_QUAD_REDUCE` -/

/-- `FD_R52X5_QUAD_REDUCE( d, s )` as compiled: the five carries `c0 … c4` (`s >> 51`, the splat
`51` in `k`), then each limb masked (`mask`) into `ak` and its carry added into `dk`, limb 4's
times 19 (`r19`) by `vpmadd52luq`. -/
def reduceRun
    (s0 s1 s2 s3 s4 k mask r19 c0 c1 c2 c3 c4 a0 d0 a1 d1 a2 d2 a3 d3 a4 d4 : Dst Γ Ty4x64) :
    List (Instr Γ) :=
  [.binop (.vector (.lshr false)) c0 (.val s0.i s0.h) (.val k.i k.h),
    .binop (.vector (.lshr false)) c1 (.val s1.i s1.h) (.val k.i k.h),
    .binop (.vector (.lshr false)) c2 (.val s2.i s2.h) (.val k.i k.h),
    .binop (.vector (.lshr false)) c3 (.val s3.i s3.h) (.val k.i k.h),
    .binop (.vector (.lshr false)) c4 (.val s4.i s4.h) (.val k.i k.h),
    .binop (.vector .and) a0 (.val s0.i s0.h) (.val mask.i mask.h),
    .ternop .vpmadd52l d0 (.val a0.i a0.h) (.val c4.i c4.h) (.val r19.i r19.h),
    .binop (.vector .and) a1 (.val s1.i s1.h) (.val mask.i mask.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d1 (.val a1.i a1.h) (.val c0.i c0.h),
    .binop (.vector .and) a2 (.val s2.i s2.h) (.val mask.i mask.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d2 (.val a2.i a2.h) (.val c1.i c1.h),
    .binop (.vector .and) a3 (.val s3.i s3.h) (.val mask.i mask.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d3 (.val a3.i a3.h) (.val c2.i c2.h),
    .binop (.vector .and) a4 (.val s4.i s4.h) (.val mask.i mask.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d4 (.val a4.i a4.h) (.val c3.i c3.h)]

/-- Where the body at `pos` is `reduceRun` and `s0 … s4` hold `Q`: running on from `pos` then `g`
gives `K` if it does from `pos + 15` with `Q.reduce` in `d0 … d4`, whatever the intermediates
hold. -/
theorem runBodyFrom_reduceRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {s0 s1 s2 s3 s4 k mask r19 c0 c1 c2 c3 c4 a0 d0 a1 d1 a2 d2 a3 d3 a4 d4 : Dst Γ Ty4x64}
    {rest : List (Instr Γ)} {Q : Quad5} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        reduceRun s0 s1 s2 s3 s4 k mask r19 c0 c1 c2 c3 c4 a0 d0 a1 d1 a2 d2 a3 d3 a4 d4 ++ rest)
    (hR :
      E ⊨ [s0 := Q.P0, s1 := Q.P1, s2 := Q.P2, s3 := Q.P3, s4 := Q.P4, k :=
        (Vector.replicate 4 51#64 : Wl), mask := (Vector.replicate 4 2251799813685247#64 : Wl),
        r19 := (Vector.replicate 4 19#64 : Wl)])
    (hd :
      [s0.i, s1.i, s2.i, s3.i, s4.i, k.i, mask.i, r19.i, c0.i, c1.i, c2.i, c3.i, c4.i, a0.i, d0.i,
          a1.i, d1.i, a2.i, d2.i, a3.i, d3.i, a4.i].Nodup)
    (hK :
      ∀ vc0 vc1 vc2 vc3 vc4 va0 va1 va2 va3 va4 : ⟦Ty4x64⟧,
        (blk.runBodyFrom
              E[c0 := vc0, c1 := vc1, c2 := vc2, c3 := vc3, c4 := vc4, a0 := va0, d0 :=
                Ty.wrap Q.reduce.P0, a1 := va1, d1 := Ty.wrap Q.reduce.P1, a2 := va2, d2 :=
                Ty.wrap Q.reduce.P2, a3 := va3, d3 := Ty.wrap Q.reduce.P3, a4 := va4, d4 :=
                Ty.wrap Q.reduce.P4]
              (pos + 15) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with transparent vc0
  step_pure with transparent vc1
  step_pure with transparent vc2
  step_pure with transparent vc3
  step_pure with transparent vc4
  step_pure with transparent va0
  step_pure with e0
  step_pure with transparent va1
  step_pure with e1
  step_pure with transparent va2
  step_pure with e2
  step_pure with transparent va3
  step_pure with e3
  step_pure with transparent va4
  step_pure with e4
  rw [hE, he0, he1, he2, he3, he4]
  exact hK _ _ _ _ _ _ _ _ _ _

/-- `reduceRun` for limbs that are bitcasts of bytes (a `LANE_IF`'s): the carries from `s0 … s4`,
the masks from `bk`, the bitcasts of `qb0 … qb4`, as compiled when both are taken. -/
def reduceCastRun (s0 s1 s2 s3 s4 : Dst Γ Ty4x64) (qb0 qb1 qb2 qb3 qb4 : Dst Γ Ty32x8)
    (k mask r19 c0 c1 c2 c3 c4 b0 a0 d0 b1 a1 d1 b2 a2 d2 b3 a3 d3 b4 a4 d4 : Dst Γ Ty4x64) :
    List (Instr Γ) :=
  [.binop (.vector (.lshr false)) c0 (.val s0.i s0.h) (.val k.i k.h),
    .binop (.vector (.lshr false)) c1 (.val s1.i s1.h) (.val k.i k.h),
    .binop (.vector (.lshr false)) c2 (.val s2.i s2.h) (.val k.i k.h),
    .binop (.vector (.lshr false)) c3 (.val s3.i s3.h) (.val k.i k.h),
    .binop (.vector (.lshr false)) c4 (.val s4.i s4.h) (.val k.i k.h),
    .unop (.bitcast (by decide)) b0 (.val qb0.i qb0.h),
    .binop (.vector .and) a0 (.val b0.i b0.h) (.val mask.i mask.h),
    .ternop .vpmadd52l d0 (.val a0.i a0.h) (.val c4.i c4.h) (.val r19.i r19.h),
    .unop (.bitcast (by decide)) b1 (.val qb1.i qb1.h),
    .binop (.vector .and) a1 (.val b1.i b1.h) (.val mask.i mask.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d1 (.val a1.i a1.h) (.val c0.i c0.h),
    .unop (.bitcast (by decide)) b2 (.val qb2.i qb2.h),
    .binop (.vector .and) a2 (.val b2.i b2.h) (.val mask.i mask.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d2 (.val a2.i a2.h) (.val c1.i c1.h),
    .unop (.bitcast (by decide)) b3 (.val qb3.i qb3.h),
    .binop (.vector .and) a3 (.val b3.i b3.h) (.val mask.i mask.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d3 (.val a3.i a3.h) (.val c2.i c2.h),
    .unop (.bitcast (by decide)) b4 (.val qb4.i qb4.h),
    .binop (.vector .and) a4 (.val b4.i b4.h) (.val mask.i mask.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d4 (.val a4.i a4.h) (.val c3.i c3.h)]

/-- `runBodyFrom_reduceRun` for `reduceCastRun`, `qb0 … qb4` holding `Q`'s bytes. -/
theorem runBodyFrom_reduceCastRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {s0 s1 s2 s3 s4 : Dst Γ Ty4x64} {qb0 qb1 qb2 qb3 qb4 : Dst Γ Ty32x8}
    {k mask r19 c0 c1 c2 c3 c4 b0 a0 d0 b1 a1 d1 b2 a2 d2 b3 a3 d3 b4 a4 d4 : Dst Γ Ty4x64}
    {rest : List (Instr Γ)} {Q : Quad5} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        reduceCastRun s0 s1 s2 s3 s4 qb0 qb1 qb2 qb3 qb4 k mask r19 c0 c1 c2 c3 c4 b0 a0 d0 b1 a1 d1
            b2 a2 d2 b3 a3 d3 b4 a4 d4 ++
          rest)
    (hR :
      E ⊨ [s0 := Q.P0, s1 := Q.P1, s2 := Q.P2, s3 := Q.P3, s4 := Q.P4, qb0 := wlBytes Q.P0, qb1 :=
        wlBytes Q.P1, qb2 := wlBytes Q.P2, qb3 := wlBytes Q.P3, qb4 := wlBytes Q.P4, k :=
        (Vector.replicate 4 51#64 : Wl), mask := (Vector.replicate 4 2251799813685247#64 : Wl),
        r19 := (Vector.replicate 4 19#64 : Wl)])
    (hd :
      [s0.i, s1.i, s2.i, s3.i, s4.i, k.i, mask.i, r19.i, c0.i, c1.i, c2.i, c3.i, c4.i, b0.i, a0.i,
          d0.i, b1.i, a1.i, d1.i, b2.i, a2.i, d2.i, b3.i, a3.i, d3.i, b4.i, a4.i].Nodup)
    (hK :
      ∀ vc0 vc1 vc2 vc3 vc4 vb0 va0 vb1 va1 vb2 va2 vb3 va3 vb4 va4 : ⟦Ty4x64⟧,
        (blk.runBodyFrom
              E[c0 := vc0, c1 := vc1, c2 := vc2, c3 := vc3, c4 := vc4, b0 := vb0, a0 := va0, d0 :=
                Ty.wrap Q.reduce.P0, b1 := vb1, a1 := va1, d1 := Ty.wrap Q.reduce.P1, b2 := vb2,
                a2 := va2, d2 := Ty.wrap Q.reduce.P2, b3 := vb3, a3 := va3, d3 :=
                Ty.wrap Q.reduce.P3, b4 := vb4, a4 := va4, d4 := Ty.wrap Q.reduce.P4]
              (pos + 20) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with transparent vc0
  step_pure with transparent vc1
  step_pure with transparent vc2
  step_pure with transparent vc3
  step_pure with transparent vc4
  step_pattern using runBodyFrom_wlRun inline
  step_pure with transparent va0
  step_pure with e0
  step_pattern using runBodyFrom_wlRun inline
  step_pure with transparent va1
  step_pure with e1
  step_pattern using runBodyFrom_wlRun inline
  step_pure with transparent va2
  step_pure with e2
  step_pattern using runBodyFrom_wlRun inline
  step_pure with transparent va3
  step_pure with e3
  step_pattern using runBodyFrom_wlRun inline
  step_pure with transparent va4
  step_pure with e4
  rw [hE, hS, he0, he1, he2, he3, he4]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

/-- `reduceRun` storing each result limb at `p0 … p4` right after it is computed: the reduce at
the end of `FD_R52X5_GE_ADD_TABLE` and `FD_R52X5_GE_DBL` into a point. -/
def reduceStoreRun
    (s0 s1 s2 s3 s4 k mask r19 c0 c1 c2 c3 c4 a0 d0 a1 d1 a2 d2 a3 d3 a4 d4 : Dst Γ Ty4x64)
    (p0 p1 p2 p3 p4 : Reg Γ .ptr) : List (Instr Γ) :=
  [.binop (.vector (.lshr false)) c0 (.val s0.i s0.h) (.val k.i k.h),
    .binop (.vector (.lshr false)) c1 (.val s1.i s1.h) (.val k.i k.h),
    .binop (.vector (.lshr false)) c2 (.val s2.i s2.h) (.val k.i k.h),
    .binop (.vector (.lshr false)) c3 (.val s3.i s3.h) (.val k.i k.h),
    .binop (.vector (.lshr false)) c4 (.val s4.i s4.h) (.val k.i k.h),
    .binop (.vector .and) a0 (.val s0.i s0.h) (.val mask.i mask.h),
    .ternop .vpmadd52l d0 (.val a0.i a0.h) (.val c4.i c4.h) (.val r19.i r19.h),
    .store p0 (.val d0.i d0.h), .binop (.vector .and) a1 (.val s1.i s1.h) (.val mask.i mask.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d1 (.val a1.i a1.h) (.val c0.i c0.h),
    .store p1 (.val d1.i d1.h), .binop (.vector .and) a2 (.val s2.i s2.h) (.val mask.i mask.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d2 (.val a2.i a2.h) (.val c1.i c1.h),
    .store p2 (.val d2.i d2.h), .binop (.vector .and) a3 (.val s3.i s3.h) (.val mask.i mask.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d3 (.val a3.i a3.h) (.val c2.i c2.h),
    .store p3 (.val d3.i d3.h), .binop (.vector .and) a4 (.val s4.i s4.h) (.val mask.i mask.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d4 (.val a4.i a4.h) (.val c3.i c3.h),
    .store p4 (.val d4.i d4.h)]

/-- Where the body at `pos` is `reduceStoreRun`, `s0 … s4` hold `Q` and `p0 … p4` the `wl_t`s of
the point `P`: running on from `pos` then `g` gives `K` if it does from `pos + 20` with
`Q.reduce` stored at `P` (and in `d0 … d4`). -/
theorem runBodyFrom_reduceStoreRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {s0 s1 s2 s3 s4 k mask r19 c0 c1 c2 c3 c4 a0 d0 a1 d1 a2 d2 a3 d3 a4 d4 : Dst Γ Ty4x64}
    {p0 p1 p2 p3 p4 : Reg Γ .ptr} {rest : List (Instr Γ)} {Q : Quad5} {P : Pointer}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        reduceStoreRun s0 s1 s2 s3 s4 k mask r19 c0 c1 c2 c3 c4 a0 d0 a1 d1 a2 d2 a3 d3 a4 d4 p0 p1
            p2 p3 p4 ++
          rest)
    (hR :
      E ⊨ [s0 := Q.P0, s1 := Q.P1, s2 := Q.P2, s3 := Q.P3, s4 := Q.P4, k :=
        (Vector.replicate 4 51#64 : Wl), mask := (Vector.replicate 4 2251799813685247#64 : Wl),
        r19 := (Vector.replicate 4 19#64 : Wl), p0 := P, p1 := P.add 32#64, p2 := P.add 64#64, p3 :=
        P.add 96#64, p4 := P.add 128#64])
    (hd :
      [s0.i, s1.i, s2.i, s3.i, s4.i, k.i, mask.i, r19.i, c0.i, c1.i, c2.i, c3.i, c4.i, a0.i, d0.i,
          a1.i, d1.i, a2.i, d2.i, a3.i, d3.i, a4.i].Nodup)
    (hwf : S.WF) (hP : S.mem.Quad5Room P)
    (hK :
      ∀ vc0 vc1 vc2 vc3 vc4 va0 va1 va2 va3 va4 : ⟦Ty4x64⟧,
        (blk.runBodyFrom
              E[c0 := vc0, c1 := vc1, c2 := vc2, c3 := vc3, c4 := vc4, a0 := va0, d0 :=
                Ty.wrap Q.reduce.P0, a1 := va1, d1 := Ty.wrap Q.reduce.P1, a2 := va2, d2 :=
                Ty.wrap Q.reduce.P2, a3 := va3, d3 := Ty.wrap Q.reduce.P3, a4 := va4, d4 :=
                Ty.wrap Q.reduce.P4]
              (pos + 20) { alloc := S.alloc, mem := S.mem.storeQuad5 P Q.reduce } >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with transparent vc0
  step_pure with transparent vc1
  step_pure with transparent vc2
  step_pure with transparent vc3
  step_pure with transparent vc4
  step_pure with transparent va0
  step_pure with e0
  step_store
  step_pure with transparent va1
  step_pure with e1
  step_store
  step_pure with transparent va2
  step_pure with e2
  step_store
  step_pure with transparent va3
  step_pure with e3
  step_store
  step_pure with transparent va4
  step_pure with e4
  step_store
  rw [hE, hS, MemoryState.storeQuad5_mk,
    show (⟨e0, e1, e2, e3, e4⟩ : Quad5) = Q.reduce by
      rw [he0, he1, he2, he3, he4]; rfl]
  rw [he0, he1, he2, he3, he4]
  exact hK _ _ _ _ _ _ _ _ _ _

/-- `reduceStoreRun` for limbs that are bitcasts of bytes, as `reduceCastRun`. -/
def reduceCastStoreRun (s0 s1 s2 s3 s4 : Dst Γ Ty4x64) (qb0 qb1 qb2 qb3 qb4 : Dst Γ Ty32x8)
    (k mask r19 c0 c1 c2 c3 c4 b0 a0 d0 b1 a1 d1 b2 a2 d2 b3 a3 d3 b4 a4 d4 : Dst Γ Ty4x64)
    (p0 p1 p2 p3 p4 : Reg Γ .ptr) : List (Instr Γ) :=
  [.binop (.vector (.lshr false)) c0 (.val s0.i s0.h) (.val k.i k.h),
    .binop (.vector (.lshr false)) c1 (.val s1.i s1.h) (.val k.i k.h),
    .binop (.vector (.lshr false)) c2 (.val s2.i s2.h) (.val k.i k.h),
    .binop (.vector (.lshr false)) c3 (.val s3.i s3.h) (.val k.i k.h),
    .binop (.vector (.lshr false)) c4 (.val s4.i s4.h) (.val k.i k.h),
    .unop (.bitcast (by decide)) b0 (.val qb0.i qb0.h),
    .binop (.vector .and) a0 (.val b0.i b0.h) (.val mask.i mask.h),
    .ternop .vpmadd52l d0 (.val a0.i a0.h) (.val c4.i c4.h) (.val r19.i r19.h),
    .store p0 (.val d0.i d0.h), .unop (.bitcast (by decide)) b1 (.val qb1.i qb1.h),
    .binop (.vector .and) a1 (.val b1.i b1.h) (.val mask.i mask.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d1 (.val a1.i a1.h) (.val c0.i c0.h),
    .store p1 (.val d1.i d1.h), .unop (.bitcast (by decide)) b2 (.val qb2.i qb2.h),
    .binop (.vector .and) a2 (.val b2.i b2.h) (.val mask.i mask.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d2 (.val a2.i a2.h) (.val c1.i c1.h),
    .store p2 (.val d2.i d2.h), .unop (.bitcast (by decide)) b3 (.val qb3.i qb3.h),
    .binop (.vector .and) a3 (.val b3.i b3.h) (.val mask.i mask.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d3 (.val a3.i a3.h) (.val c2.i c2.h),
    .store p3 (.val d3.i d3.h), .unop (.bitcast (by decide)) b4 (.val qb4.i qb4.h),
    .binop (.vector .and) a4 (.val b4.i b4.h) (.val mask.i mask.h),
    .binop (.vector (.add { nsw := true, nuw := true })) d4 (.val a4.i a4.h) (.val c3.i c3.h),
    .store p4 (.val d4.i d4.h)]

/-- `runBodyFrom_reduceStoreRun` for `reduceCastStoreRun`, `qb0 … qb4` holding `Q`'s bytes. -/
theorem runBodyFrom_reduceCastStoreRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {s0 s1 s2 s3 s4 : Dst Γ Ty4x64} {qb0 qb1 qb2 qb3 qb4 : Dst Γ Ty32x8}
    {k mask r19 c0 c1 c2 c3 c4 b0 a0 d0 b1 a1 d1 b2 a2 d2 b3 a3 d3 b4 a4 d4 : Dst Γ Ty4x64}
    {p0 p1 p2 p3 p4 : Reg Γ .ptr} {rest : List (Instr Γ)} {Q : Quad5} {P : Pointer}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        reduceCastStoreRun s0 s1 s2 s3 s4 qb0 qb1 qb2 qb3 qb4 k mask r19 c0 c1 c2 c3 c4 b0 a0 d0 b1
            a1 d1 b2 a2 d2 b3 a3 d3 b4 a4 d4 p0 p1 p2 p3 p4 ++
          rest)
    (hR :
      E ⊨ [s0 := Q.P0, s1 := Q.P1, s2 := Q.P2, s3 := Q.P3, s4 := Q.P4, qb0 := wlBytes Q.P0, qb1 :=
        wlBytes Q.P1, qb2 := wlBytes Q.P2, qb3 := wlBytes Q.P3, qb4 := wlBytes Q.P4, k :=
        (Vector.replicate 4 51#64 : Wl), mask := (Vector.replicate 4 2251799813685247#64 : Wl),
        r19 := (Vector.replicate 4 19#64 : Wl), p0 := P, p1 := P.add 32#64, p2 := P.add 64#64, p3 :=
        P.add 96#64, p4 := P.add 128#64])
    (hd :
      [s0.i, s1.i, s2.i, s3.i, s4.i, k.i, mask.i, r19.i, c0.i, c1.i, c2.i, c3.i, c4.i, b0.i, a0.i,
          d0.i, b1.i, a1.i, d1.i, b2.i, a2.i, d2.i, b3.i, a3.i, d3.i, b4.i, a4.i].Nodup)
    (hwf : S.WF) (hP : S.mem.Quad5Room P)
    (hK :
      ∀ vc0 vc1 vc2 vc3 vc4 vb0 va0 vb1 va1 vb2 va2 vb3 va3 vb4 va4 : ⟦Ty4x64⟧,
        (blk.runBodyFrom
              E[c0 := vc0, c1 := vc1, c2 := vc2, c3 := vc3, c4 := vc4, b0 := vb0, a0 := va0, d0 :=
                Ty.wrap Q.reduce.P0, b1 := vb1, a1 := va1, d1 := Ty.wrap Q.reduce.P1, b2 := vb2,
                a2 := va2, d2 := Ty.wrap Q.reduce.P2, b3 := vb3, a3 := va3, d3 :=
                Ty.wrap Q.reduce.P3, b4 := vb4, a4 := va4, d4 := Ty.wrap Q.reduce.P4]
              (pos + 25) { alloc := S.alloc, mem := S.mem.storeQuad5 P Q.reduce } >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with transparent vc0
  step_pure with transparent vc1
  step_pure with transparent vc2
  step_pure with transparent vc3
  step_pure with transparent vc4
  step_pattern using runBodyFrom_wlRun inline
  step_pure with transparent va0
  step_pure with e0
  step_store
  step_pattern using runBodyFrom_wlRun inline
  step_pure with transparent va1
  step_pure with e1
  step_store
  step_pattern using runBodyFrom_wlRun inline
  step_pure with transparent va2
  step_pure with e2
  step_store
  step_pattern using runBodyFrom_wlRun inline
  step_pure with transparent va3
  step_pure with e3
  step_store
  step_pattern using runBodyFrom_wlRun inline
  step_pure with transparent va4
  step_pure with e4
  step_store
  rw [hE, hS, MemoryState.storeQuad5_mk,
    show (⟨e0, e1, e2, e3, e4⟩ : Quad5) = Q.reduce by
      rw [he0, he1, he2, he3, he4]; rfl]
  rw [he0, he1, he2, he3, he4]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

end Patterns

end

end MLIR.Firedancer.R52x5
