module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.Runs

/-! `FD_R52X5_GE_DBL` as a function, and the `FD_R52X5_QUAD_LANE_IF` shapes of its compiled copies:
masks taken from an earlier `LANE_IF` (or hoisted out of a loop), the operands' bytes reused. -/

namespace MLIR.Firedancer.R52x5

@[expose] public section

/-- `FD_R52X5_QUAD_ZERO`: every limb zero. -/
def quad5Zero : Quad5 :=
  ⟨wl_zero, wl_zero, wl_zero, wl_zero, wl_zero⟩

/-- `FD_R52X5_GE_DBL( P2, P1 )`: `2 P1` in extended coordinates, as the macro's steps. -/
def geDbl (P1 : Quad5) : Quad5 :=
  let _zero := quad5Zero
  let _ta := P1.permute 1 0 3 2
  let _ta := _ta.addFast P1
  let _ta := _ta.permute 0 1 0 1
  let _ta := Quad5.laneIf 0 0 0 1 _ta P1
  let _ta := _ta.reduce
  let _ta := fd_r52x5_quad_sqr_fast.spec _ta
  let _1111 := _ta.permute 0 0 0 0
  let _2222 := _ta.permute 1 1 1 1
  let _2224 := Quad5.laneIf 0 0 0 1 _ta _2222
  let _2224 := _2224.negateLazy
  let _ta := _ta.addFast _ta
  let _ta := Quad5.laneIf 0 0 1 0 _ta _zero
  let _ta := _1111.addFast _ta
  let _tb := Quad5.laneIf 1 0 0 1 _2222 _zero
  let _ta := _ta.addFast _tb
  let _tb := Quad5.laneIf 0 1 1 1 _2224 _zero
  let _ta := _ta.addFast _tb
  let _ta := _ta.reduce
  let _tb := _ta.permute 3 1 1 3
  let _ta := _ta.permute 2 0 2 0
  (fd_r52x5_quad_mul_fast.spec _ta _tb).reduce

/-- `wl_zero()`'s bytes. -/
theorem wlBytes_zero : wlBytes wl_zero = Vector.replicate 32 0#8 := by
  ext k hk
  simp [wlBytes]

/-! ### `FD_R52X5_QUAD_LANE_IF` with the mask's bytes at hand -/

section Patterns

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h
  Operation.pblendvb

attribute [local mlir_operation] zipWith_shl_wl

/-- `pblendvb` of `tb`, `sb` by `mb` into `q`, and back into `r`: one limb of
`FD_R52X5_QUAD_LANE_IF` with both operands' bytes at hand. -/
def blendBackRun (tb sb mb q : Dst Γ Ty32x8) (r : Dst Γ Ty4x64) : List (Instr Γ) :=
  [.ternop .pblendvb q (.val tb.i tb.h) (.val sb.i sb.h) (.val mb.i mb.h),
    .unop (.bitcast (by decide)) r (.val q.i q.h)]

/-- Where the body at `pos` is `blendBackRun`, `tb`, `sb` hold the bytes of `T`, `X` and `mb`
those of `laneMask i0 i1 i2 i3`: running on from `pos` then `g` gives `K` if it does from
`pos + 2` with `X`'s lanes where `ik ≠ 0`, else `T`'s, in `r` (and its bytes in `q`). -/
theorem runBodyFrom_blendBackRun (i0 i1 i2 i3 : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
    {pos : Nat} {tb sb mb q : Dst Γ Ty32x8} {r : Dst Γ Ty4x64} {rest : List (Instr Γ)} {T X : Wl}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = blendBackRun tb sb mb q r ++ rest)
    (hR : E ⊨ [tb := wlBytes T, sb := wlBytes X, mb := wlBytes (laneMask i0 i1 i2 i3)])
    (hi : i0 ≤ 1 ∧ i1 ≤ 1 ∧ i2 ≤ 1 ∧ i3 ≤ 1)
    (hK :
      (blk.runBodyFrom
            E[q := Ty.wrap (wlBytes (wlBlend (i0 != 0) (i1 != 0) (i2 != 0) (i3 != 0) X T)), r :=
              Ty.wrap (wlBlend (i0 != 0) (i1 != 0) (i2 != 0) (i3 != 0) X T)]
            (pos + 2) S >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨h0, h1, h2, h3⟩ := hi
  step_pattern using runBodyFrom_blendRun i0 i1 i2 i3 inline
  step_pattern using runBodyFrom_wlRun inline
  rw [hE, hS]
  exact hK

/-- `FD_R52X5_QUAD_LANE_IF( d, i0,i1,i2,i3, s, _zero )` with the mask's bytes `mb` at hand: per
limb `s`'s bytes and their `pblendvb` with the zero bytes `z` (`blendLimbRun'`). -/
def laneIfZeroMaskRun (z mb : Dst Γ Ty32x8) (s0 s1 s2 s3 s4 : Dst Γ Ty4x64)
    (sb0 q0 sb1 q1 sb2 q2 sb3 q3 sb4 q4 : Dst Γ Ty32x8) (r0 r1 r2 r3 r4 : Dst Γ Ty4x64) :
    List (Instr Γ) :=
  blendLimbRun' s0 mb z sb0 q0 r0 ++ blendLimbRun' s1 mb z sb1 q1 r1 ++
    blendLimbRun' s2 mb z sb2 q2 r2 ++
    blendLimbRun' s3 mb z sb3 q3 r3 ++
    blendLimbRun' s4 mb z sb4 q4 r4

/-- Where the body at `pos` is `laneIfZeroMaskRun`, `z` holds zero bytes, `mb` the bytes of
`laneMask i0 i1 i2 i3` and `s0 … s4` hold `X`: running on from `pos` then `g` gives `K` if it does
from `pos + 15` with `Quad5.laneIf i0 i1 i2 i3 X quad5Zero` in `r0 … r4`, and `X`'s and the
results' bytes in the others. -/
theorem runBodyFrom_laneIfZeroMaskRun (i0 i1 i2 i3 : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
    {pos : Nat} {z mb : Dst Γ Ty32x8} {s0 s1 s2 s3 s4 : Dst Γ Ty4x64}
    {sb0 q0 sb1 q1 sb2 q2 sb3 q3 sb4 q4 : Dst Γ Ty32x8} {r0 r1 r2 r3 r4 : Dst Γ Ty4x64}
    {rest : List (Instr Γ)} {X : Quad5} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        laneIfZeroMaskRun z mb s0 s1 s2 s3 s4 sb0 q0 sb1 q1 sb2 q2 sb3 q3 sb4 q4 r0 r1 r2 r3 r4 ++
          rest)
    (hR :
      E ⊨ [z := (Vector.replicate 32 0#8 : Vector (BitVec 8) 32), mb :=
        wlBytes (laneMask i0 i1 i2 i3), s0 := X.P0, s1 := X.P1, s2 := X.P2, s3 := X.P3, s4 := X.P4])
    (hi : i0 ≤ 1 ∧ i1 ≤ 1 ∧ i2 ≤ 1 ∧ i3 ≤ 1)
    (hd :
      [z.i, mb.i, s0.i, s1.i, s2.i, s3.i, s4.i, sb0.i, q0.i, r0.i, sb1.i, q1.i, r1.i, sb2.i, q2.i,
          r2.i, sb3.i, q3.i, r3.i, sb4.i].Nodup)
    (hK :
      (blk.runBodyFrom
            E[sb0 := Ty.wrap (wlBytes X.P0), q0 :=
              Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P0), r0 :=
              Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P0, sb1 := Ty.wrap (wlBytes X.P1),
              q1 := Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P1), r1 :=
              Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P1, sb2 := Ty.wrap (wlBytes X.P2),
              q2 := Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P2), r2 :=
              Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P2, sb3 := Ty.wrap (wlBytes X.P3),
              q3 := Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P3), r3 :=
              Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P3, sb4 := Ty.wrap (wlBytes X.P4),
              q4 := Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P4), r4 :=
              Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P4]
            (pos + 15) S >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨h0, h1, h2, h3⟩ := hi
  obtain ⟨hz, hR⟩ := hR
  rw [← wlBytes_zero] at hz
  step_pattern using runBodyFrom_blendLimbRun' i0 i1 i2 i3 (T := wl_zero) inline
  step_pattern using runBodyFrom_blendLimbRun' i0 i1 i2 i3 (T := wl_zero) inline
  step_pattern using runBodyFrom_blendLimbRun' i0 i1 i2 i3 (T := wl_zero) inline
  step_pattern using runBodyFrom_blendLimbRun' i0 i1 i2 i3 (T := wl_zero) inline
  step_pattern using runBodyFrom_blendLimbRun' i0 i1 i2 i3 (T := wl_zero) inline
  rw [hE, hS]
  exact hK

/-- `laneIfZeroMaskRun` with its mask: `wc_bcast_wide` of `c0 … c3` into `m`, `s0`'s bytes, `m`'s
bytes `mb`, limb 0's `pblendvb` and back, then limbs 1 … 4. -/
def laneIfZeroRun (c0 c1 c2 c3 : Reg Γ (.bv 32)) (m : Dst Γ Ty4x64) (z mb : Dst Γ Ty32x8)
    (s0 s1 s2 s3 s4 : Dst Γ Ty4x64) (sb0 q0 sb1 q1 sb2 q2 sb3 q3 sb4 q4 : Dst Γ Ty32x8)
    (r0 r1 r2 r3 r4 : Dst Γ Ty4x64) : List (Instr Γ) :=
  .call wc_bcast_wide.call (.cons c0 (.cons c1 (.cons c2 (.cons c3 .nil)))) (.cons m .nil) ::
    .unop (.bitcast (by decide)) sb0 (.val s0.i s0.h) ::
    .unop (.bitcast (by decide)) mb (.val m.i m.h) ::
    (blendBackRun z sb0 mb q0 r0 ++ blendLimbRun' s1 mb z sb1 q1 r1 ++
      blendLimbRun' s2 mb z sb2 q2 r2 ++
      blendLimbRun' s3 mb z sb3 q3 r3 ++
      blendLimbRun' s4 mb z sb4 q4 r4)

/-- `runBodyFrom_laneIfZeroMaskRun` for `laneIfZeroRun`, `c0 … c3` holding the immediates: from
`pos + 17`, the mask and its bytes in `m`, `mb`. -/
theorem runBodyFrom_laneIfZeroRun (i0 i1 i2 i3 : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
    {pos : Nat} {c0 c1 c2 c3 : Reg Γ (.bv 32)} {m : Dst Γ Ty4x64} {z mb : Dst Γ Ty32x8}
    {s0 s1 s2 s3 s4 : Dst Γ Ty4x64} {sb0 q0 sb1 q1 sb2 q2 sb3 q3 sb4 q4 : Dst Γ Ty32x8}
    {r0 r1 r2 r3 r4 : Dst Γ Ty4x64} {rest : List (Instr Γ)} {X : Quad5} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        laneIfZeroRun c0 c1 c2 c3 m z mb s0 s1 s2 s3 s4 sb0 q0 sb1 q1 sb2 q2 sb3 q3 sb4 q4 r0 r1 r2
            r3 r4 ++
          rest)
    (hR :
      E ⊨ [z := (Vector.replicate 32 0#8 : Vector (BitVec 8) 32), c0 := laneImm i0, c1 :=
        laneImm i1, c2 := laneImm i2, c3 := laneImm i3, s0 := X.P0, s1 := X.P1, s2 := X.P2, s3 :=
        X.P3, s4 := X.P4])
    (hi : i0 ≤ 1 ∧ i1 ≤ 1 ∧ i2 ≤ 1 ∧ i3 ≤ 1) (hwf : S.WF)
    (hd :
      [m.i, z.i, mb.i, s0.i, s1.i, s2.i, s3.i, s4.i, sb0.i, q0.i, r0.i, sb1.i, q1.i, r1.i, sb2.i,
          q2.i, r2.i, sb3.i, q3.i, r3.i, sb4.i].Nodup)
    (hK :
      (blk.runBodyFrom
            E[m := Ty.wrap (laneMask i0 i1 i2 i3), sb0 := Ty.wrap (wlBytes X.P0), mb :=
              Ty.wrap (wlBytes (laneMask i0 i1 i2 i3)), q0 :=
              Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P0), r0 :=
              Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P0, sb1 := Ty.wrap (wlBytes X.P1),
              q1 := Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P1), r1 :=
              Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P1, sb2 := Ty.wrap (wlBytes X.P2),
              q2 := Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P2), r2 :=
              Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P2, sb3 := Ty.wrap (wlBytes X.P3),
              q3 := Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P3), r3 :=
              Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P3, sb4 := Ty.wrap (wlBytes X.P4),
              q4 := Ty.wrap (wlBytes (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P4), r4 :=
              Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P4]
            (pos + 17) S >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨h0, h1, h2, h3⟩ := hi
  have hc0 := laneImm_ne_intMin h0
  have hc1 := laneImm_ne_intMin h1
  have hc2 := laneImm_ne_intMin h2
  have hc3 := laneImm_ne_intMin h3
  obtain ⟨hz, hR⟩ := hR
  rw [← wlBytes_zero] at hz
  step_call using wc_bcast_wide.call_eq
  step_pattern using runBodyFrom_bytesRun inline
  step_pattern using runBodyFrom_bytesRun inline
  step_pattern using runBodyFrom_blendBackRun i0 i1 i2 i3 (T := wl_zero) inline
  step_pattern using runBodyFrom_blendLimbRun' i0 i1 i2 i3 (T := wl_zero) inline
  step_pattern using runBodyFrom_blendLimbRun' i0 i1 i2 i3 (T := wl_zero) inline
  step_pattern using runBodyFrom_blendLimbRun' i0 i1 i2 i3 (T := wl_zero) inline
  step_pattern using runBodyFrom_blendLimbRun' i0 i1 i2 i3 (T := wl_zero) inline
  rw [hE, hS]
  exact hK

/-- `FD_R52X5_QUAD_LANE_IF( d, i0,i1,i2,i3, s, _zero )` with the mask's bytes `mb` and `s`'s bytes
`sb0 … sb4` at hand: per limb the `pblendvb` with the zero bytes `z` and back (`blendBackRun`). -/
def laneIfBytesMaskRun (z mb sb0 sb1 sb2 sb3 sb4 q0 q1 q2 q3 q4 : Dst Γ Ty32x8)
    (r0 r1 r2 r3 r4 : Dst Γ Ty4x64) : List (Instr Γ) :=
  blendBackRun z sb0 mb q0 r0 ++ blendBackRun z sb1 mb q1 r1 ++ blendBackRun z sb2 mb q2 r2 ++
    blendBackRun z sb3 mb q3 r3 ++
    blendBackRun z sb4 mb q4 r4

/-- Where the body at `pos` is `laneIfBytesMaskRun`, `z` holds zero bytes, `mb` the bytes of
`laneMask i0 i1 i2 i3` and `sb0 … sb4` those of `X`: running on from `pos` then `g` gives `K` if
it does from `pos + 10` with `Quad5.laneIf i0 i1 i2 i3 X quad5Zero` in `r0 … r4`, whatever the
bytes in `q0 … q4`. -/
theorem runBodyFrom_laneIfBytesMaskRun (i0 i1 i2 i3 : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
    {pos : Nat} {z mb sb0 sb1 sb2 sb3 sb4 q0 q1 q2 q3 q4 : Dst Γ Ty32x8}
    {r0 r1 r2 r3 r4 : Dst Γ Ty4x64} {rest : List (Instr Γ)} {X : Quad5} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        laneIfBytesMaskRun z mb sb0 sb1 sb2 sb3 sb4 q0 q1 q2 q3 q4 r0 r1 r2 r3 r4 ++ rest)
    (hR :
      E ⊨ [z := (Vector.replicate 32 0#8 : Vector (BitVec 8) 32), mb :=
        wlBytes (laneMask i0 i1 i2 i3), sb0 := wlBytes X.P0, sb1 := wlBytes X.P1, sb2 :=
        wlBytes X.P2, sb3 := wlBytes X.P3, sb4 := wlBytes X.P4])
    (hi : i0 ≤ 1 ∧ i1 ≤ 1 ∧ i2 ≤ 1 ∧ i3 ≤ 1)
    (hd : [z.i, mb.i, sb0.i, sb1.i, sb2.i, sb3.i, sb4.i, q0.i, q1.i, q2.i, q3.i].Nodup)
    (hK :
      ∀ vq0 vq1 vq2 vq3 vq4 : ⟦Ty32x8⟧,
        (blk.runBodyFrom
              E[q0 := vq0, r0 := Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P0, q1 := vq1, r1 :=
                Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P1, q2 := vq2, r2 :=
                Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P2, q3 := vq3, r3 :=
                Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P3, q4 := vq4, r4 :=
                Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P4]
              (pos + 10) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  obtain ⟨h0, h1, h2, h3⟩ := hi
  obtain ⟨hz, hR⟩ := hR
  rw [← wlBytes_zero] at hz
  step_pattern using runBodyFrom_blendBackRun i0 i1 i2 i3 (T := wl_zero) inline
  step_pattern using runBodyFrom_blendBackRun i0 i1 i2 i3 (T := wl_zero) inline
  step_pattern using runBodyFrom_blendBackRun i0 i1 i2 i3 (T := wl_zero) inline
  step_pattern using runBodyFrom_blendBackRun i0 i1 i2 i3 (T := wl_zero) inline
  step_pattern using runBodyFrom_blendBackRun i0 i1 i2 i3 (T := wl_zero) inline
  rw [hE, hS]
  exact hK _ _ _ _ _

/-- `laneIfBytesMaskRun` with its mask: `wc_bcast_wide` of `c0 … c3` into `m`, its bytes into
`mb`. -/
def laneIfBytesRun (c0 c1 c2 c3 : Reg Γ (.bv 32)) (m : Dst Γ Ty4x64)
    (z mb sb0 sb1 sb2 sb3 sb4 q0 q1 q2 q3 q4 : Dst Γ Ty32x8) (r0 r1 r2 r3 r4 : Dst Γ Ty4x64) :
    List (Instr Γ) :=
  .call wc_bcast_wide.call (.cons c0 (.cons c1 (.cons c2 (.cons c3 .nil)))) (.cons m .nil) ::
    .unop (.bitcast (by decide)) mb (.val m.i m.h) ::
    laneIfBytesMaskRun z mb sb0 sb1 sb2 sb3 sb4 q0 q1 q2 q3 q4 r0 r1 r2 r3 r4

/-- `runBodyFrom_laneIfBytesMaskRun` for `laneIfBytesRun`, `c0 … c3` holding the immediates: from
`pos + 12`, the mask and its bytes in `m`, `mb`. -/
theorem runBodyFrom_laneIfBytesRun (i0 i1 i2 i3 : Nat) {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫}
    {pos : Nat} {c0 c1 c2 c3 : Reg Γ (.bv 32)} {m : Dst Γ Ty4x64}
    {z mb sb0 sb1 sb2 sb3 sb4 q0 q1 q2 q3 q4 : Dst Γ Ty32x8} {r0 r1 r2 r3 r4 : Dst Γ Ty4x64}
    {rest : List (Instr Γ)} {X : Quad5} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        laneIfBytesRun c0 c1 c2 c3 m z mb sb0 sb1 sb2 sb3 sb4 q0 q1 q2 q3 q4 r0 r1 r2 r3 r4 ++ rest)
    (hR :
      E ⊨ [c0 := laneImm i0, c1 := laneImm i1, c2 := laneImm i2, c3 := laneImm i3, z :=
        (Vector.replicate 32 0#8 : Vector (BitVec 8) 32), sb0 := wlBytes X.P0, sb1 := wlBytes X.P1,
        sb2 := wlBytes X.P2, sb3 := wlBytes X.P3, sb4 := wlBytes X.P4])
    (hi : i0 ≤ 1 ∧ i1 ≤ 1 ∧ i2 ≤ 1 ∧ i3 ≤ 1) (hwf : S.WF)
    (hd : [z.i, mb.i, sb0.i, sb1.i, sb2.i, sb3.i, sb4.i, q0.i, q1.i, q2.i, q3.i].Nodup)
    (hK :
      ∀ vq0 vq1 vq2 vq3 vq4 : ⟦Ty32x8⟧,
        (blk.runBodyFrom
              E[m := Ty.wrap (laneMask i0 i1 i2 i3), mb := Ty.wrap (wlBytes (laneMask i0 i1 i2 i3)),
                q0 := vq0, r0 := Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P0, q1 := vq1, r1 :=
                Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P1, q2 := vq2, r2 :=
                Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P2, q3 := vq3, r3 :=
                Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P3, q4 := vq4, r4 :=
                Ty.wrap (Quad5.laneIf i0 i1 i2 i3 X quad5Zero).P4]
              (pos + 12) S >>=
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
  step_pattern using runBodyFrom_laneIfBytesMaskRun i0 i1 i2 i3 inline
  rw [hE, hS]
  exact hK _ _ _ _ _

/-! ### `FD_R52X5_QUAD_ADD_FAST( d, s, s )` -/

/-- `FD_R52X5_QUAD_ADD_FAST( d, s, s )` as compiled: `sk << 1` (`one` the splat 1) into `dk`. -/
def addSelfRun (one s0 s1 s2 s3 s4 d0 d1 d2 d3 d4 : Dst Γ Ty4x64) : List (Instr Γ) :=
  [.binop (.vector (.shl {})) d0 (.val s0.i s0.h) (.val one.i one.h),
    .binop (.vector (.shl {})) d1 (.val s1.i s1.h) (.val one.i one.h),
    .binop (.vector (.shl {})) d2 (.val s2.i s2.h) (.val one.i one.h),
    .binop (.vector (.shl {})) d3 (.val s3.i s3.h) (.val one.i one.h),
    .binop (.vector (.shl {})) d4 (.val s4.i s4.h) (.val one.i one.h)]

/-- Where the body at `pos` is `addSelfRun` and `s0 … s4` hold `Q`: running on from `pos` then
`g` gives `K` if it does from `pos + 5` with `Q.addFast Q` in `d0 … d4`. -/
theorem runBodyFrom_addSelfRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {one s0 s1 s2 s3 s4 d0 d1 d2 d3 d4 : Dst Γ Ty4x64} {rest : List (Instr Γ)} {Q : Quad5}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = addSelfRun one s0 s1 s2 s3 s4 d0 d1 d2 d3 d4 ++ rest)
    (hR :
      E ⊨ [one := (Vector.replicate 4 1#64 : Wl), s0 := Q.P0, s1 := Q.P1, s2 := Q.P2, s3 := Q.P3,
        s4 := Q.P4])
    (hd : [one.i, s0.i, s1.i, s2.i, s3.i, s4.i, d0.i, d1.i, d2.i, d3.i].Nodup)
    (hK :
      (blk.runBodyFrom
            E[d0 := Ty.wrap (Q.addFast Q).P0, d1 := Ty.wrap (Q.addFast Q).P1, d2 :=
              Ty.wrap (Q.addFast Q).P2, d3 := Ty.wrap (Q.addFast Q).P3, d4 :=
              Ty.wrap (Q.addFast Q).P4]
            (pos + 5) S >>=
          g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  step_pure with e0
  step_pure with e1
  step_pure with e2
  step_pure with e3
  step_pure with e4
  rw [wl_shl_one] at he0 he1 he2 he3 he4
  rw [hE, he0, he1, he2, he3, he4]
  exact hK

/-! ### `FD_R52X5_QUAD_REDUCE` with its result named -/

/-- `runBodyFrom_reduceRun` with the result named: `Q.reduce` as `D`. -/
theorem runBodyFrom_reduceRun_as {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
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
      ∀ (D : Quad5) (_hD : Q.reduce = D) (vc0 vc1 vc2 vc3 vc4 va0 va1 va2 va3 va4 : ⟦Ty4x64⟧),
        (blk.runBodyFrom
              E[c0 := vc0, c1 := vc1, c2 := vc2, c3 := vc3, c4 := vc4, a0 := va0, d0 :=
                Ty.wrap D.P0, a1 := va1, d1 := Ty.wrap D.P1, a2 := va2, d2 := Ty.wrap D.P2, a3 :=
                va3, d3 := Ty.wrap D.P3, a4 := va4, d4 := Ty.wrap D.P4]
              (pos + 15) S >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K :=
  runBodyFrom_reduceRun hbody hR hd (hK _ rfl)

/-- `runBodyFrom_reduceStoreRun` with the result named: `Q.reduce` as `D`. -/
theorem runBodyFrom_reduceStoreRun_as {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
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
    (hwf : S.WF) (hP : S.mem.Quad5Fit P)
    (hK :
      ∀ (D : Quad5) (_hD : Q.reduce = D) (vc0 vc1 vc2 vc3 vc4 va0 va1 va2 va3 va4 : ⟦Ty4x64⟧),
        (blk.runBodyFrom
              E[c0 := vc0, c1 := vc1, c2 := vc2, c3 := vc3, c4 := vc4, a0 := va0, d0 :=
                Ty.wrap D.P0, a1 := va1, d1 := Ty.wrap D.P1, a2 := va2, d2 := Ty.wrap D.P2, a3 :=
                va3, d3 := Ty.wrap D.P3, a4 := va4, d4 := Ty.wrap D.P4]
              (pos + 20) { alloc := S.alloc, mem := S.mem.storeQuad5 P D } >>=
            g) =
          K) :
    (blk.runBodyFrom E pos S >>= g) = K :=
  runBodyFrom_reduceStoreRun hbody hR hd hwf hP (hK _ rfl)

end Patterns

end

end MLIR.Firedancer.R52x5
