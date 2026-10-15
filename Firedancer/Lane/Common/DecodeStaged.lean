module

public import Firedancer.Lane.Common.Decode
public import Firedancer.Lane.Common.Mem
public import Firedancer.Avx512.fd_r43x6_ge_decode2
import Firedancer.Common.Memory
import Mathlib.Data.Fintype.Basic
import Mathlib.Tactic.FinCases
import Std.Tactic.BVDecide
import Mathlib.Tactic.IntervalCases

/-! The staged decode (`fd_r43x6_ge_decode_init`, `_step`, `_fini`): its state, as an object in
memory, and the runs its lifts share. -/

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

set_option hygiene false in
/-- A field's fit through the stores of the state: transported past the others, known at its
own. -/
local macro "dec_fits" h:ident : tactic =>
  `(tactic|
    ( repeat (first | with_reducible apply Fits.storeAt_self | apply Fits.storeAt)
      try simp only [Room.storeAt_iff, Room.storeOpt_iff]
      first
        | (refine decRoom_room $h _ _ ?_; decide)
        | (refine ($h).2.mono ?_; decide)))

set_option hygiene false in
/-- A field's read through the stores of the state: past the others, then its own. -/
local macro "dec_read" h:ident : tactic =>
  `(tactic|
    ( repeat
        (first
          | rw [readAt_storeAt_dec ($h).1 (by decide)]
          | rw [readAt_storeAt_dec0 ($h).1 (by decide)]
          | rw [readAt_storeAt_dec0' ($h).1 (by decide)])
      refine MemoryState.readAt_storeAt_self ?_ _
      try simp only [Room.storeAt_iff, Room.storeOpt_iff]
      first
        | (refine decRoom_room $h _ _ ?_; decide)
        | (refine ($h).2.mono ?_; decide)))

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

set_option hygiene false in
/-- Stores to the state's fields, sorted by offset and the overwritten ones dropped. -/
local macro "dec_norm" h:term : tactic =>
  `(tactic|
    simp (disch := decide) only [MemoryState.storeDec, MemoryState.storeVec, storeAt_comm_dec $h,
      storeAt_comm_dec0 $h, storeOpt_comm_dec $h, storeOpt_comm_dec0 $h,
      MemoryState.storeAt_storeAt_self, storeOpt_storeAt_self])

@[expose] public section

/-! ## `fd_r43x6_sub` as `fd_r43x6_neg`'s fold compiles -/

/-- `fd_r43x6_sub( x, one )` as nine instructions: `x + k` in `d`, then `negRun`'s fold: low bits
`lo`, carries `hi` rotated into `c`, `18 ×` lane 0's in `u`, summed as `lo + b`, `+ c`, `+ u` into
`r`. -/
def subRunB (x k mask shifts b z o m18 d lo hi c t u s1 s2 r : Dst Γ V) : List (Instr Γ) :=
  [.binop (.vector (.add {})) d (.val x.i x.h) (.val k.i k.h),
    .binop (.vector .and) lo (.val d.i d.h) (.val mask.i mask.h),
    .binop (.vector (.ashr false)) hi (.val d.i d.h) (.val shifts.i shifts.h),
    .binop (.shufflevector negRotMask) c (.val hi.i hi.h) (.val z.i z.h),
    .binop (.vector (.mul {})) t (.val c.i c.h) (.val o.i o.h),
    .binop (.vector .and) u (.val t.i t.h) (.val m18.i m18.h),
    .binop (.vector (.add { nsw := true, nuw := true })) s1 (.val lo.i lo.h) (.val b.i b.h),
    .binop (.vector (.add {})) s2 (.val s1.i s1.h) (.val c.i c.h),
    .binop (.vector (.add {})) r (.val s2.i s2.h) (.val u.i u.h)]

/-- Where the body at `pos` is `subRunB`, `x` holds `X`, `k` holds `K` and the others the fold's
constants: running on from `pos` then `g` gives `K'` if it does from `pos + 9` with
`foldSignedPre (vadd X K)` plus the bias in `r`, whatever the intermediates hold. -/
theorem runBodyFrom_subRunB {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x k mask shifts b z o m18 d lo hi c t u s1 s2 r : Dst Γ V} {rest : List (Instr Γ)}
    {X K : Wwl} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K' : PoisonOr β}
    (hbody : blk.body.drop pos = subRunB x k mask shifts b z o m18 d lo hi c t u s1 s2 r ++ rest)
    (hR :
      E ⊨ [x := X, k := K, mask := foldMask, shifts := foldShifts, b := negBias, z := zeroLo,
        o := neg18, m18 := negSel])
    (hd :
      [x.i, k.i, mask.i, shifts.i, b.i, z.i, o.i, m18.i, d.i, lo.i, hi.i, c.i, t.i, u.i, s1.i,
          s2.i].Nodup)
    (hK :
      ∀ vd vlo vhi vc vt vu vs1 vs2 : ⟦V⟧,
        (blk.runBodyFrom
              E[d := vd, lo := vlo, hi := vhi, c := vc, t := vt, u := vu, s1 := vs1, s2 := vs2, r :=
                Ty.wrap (vadd (foldSignedPre (vadd X K)) negBias)]
              (pos + 9) S >>=
            g) =
          K') :
    (blk.runBodyFrom E pos S >>= g) = K' := by
  simp only [subRunB] at hbody
  step_pure with transparent vd
  step_pure with transparent vlo
  step_pure [foldShifts_lt] with transparent vhi
  step_pure with transparent vc
  step_pure with transparent vt
  step_pure with transparent vu
  step_pure with transparent vs1
  step_pure with transparent vs2
  step_pure with vr
  rw [hE, ← hK]
  congr
  subst hvr
  delta foldSignedPre
  apply vec_ext_fin
  intro i
  fin_cases i <;>
    simp [Ty.wrap_vec, and40_add_b20, and43_add_bias, and_allOnes_lit, negRot, foldMask,
      foldShifts, negBias, neg18, negSel, wwl_add, wwl_and] <;>
    ac_rfl

/-! ## `fd_r43x6_diagnose`, lane by lane -/

/-- `fd_r43x6_diagnose(x)` as compiled: `nz1Run`'s reduction of lanes `0 … 5` of `x`, then `-1`
(`m1`) if it is zero, else the reduced limb `0`'s low bit (`o1` holds `1`) as an `int`, in `r`. -/
def diag1Run (x : Dst Γ V)
    (i0 i1 i2 i3 i4 i5 nb s40 m40 k19 s43 m43 b20 two40 m19 w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11
      w12 w13 w14 w15 w16 w17 w18 w19 w20 w21 w22 w23 w24 w25 w26 w27 w28 w29 w30 w31 w32 w33 w34
      w35 w36 w37 w38 w39 w40 w41 w42 w43 w45 w46 w47 w48 w49 w50 w51 w52 w53 w54 w55 w56 w57 w58
      w59 w60 w61 w62 : Dst Γ (.bv 64))
    (w44 w63 : Dst Γ (.bv 1)) (m1 o1 t a r : Dst Γ (.bv 32)) : List (Instr Γ) :=
  [.binop .extractelement w0 (.val x.i x.h) (.val i0.i i0.h),
    .binop .extractelement w1 (.val x.i x.h) (.val i1.i i1.h),
    .binop .extractelement w2 (.val x.i x.h) (.val i2.i i2.h),
    .binop .extractelement w3 (.val x.i x.h) (.val i3.i i3.h),
    .binop .extractelement w4 (.val x.i x.h) (.val i4.i i4.h),
    .binop .extractelement w5 (.val x.i x.h) (.val i5.i i5.h),
    .binop (.add {}) w6 (.val w5.i w5.h) (.val nb.i nb.h),
    .binop (.ashr false) w7 (.val w6.i w6.h) (.val s40.i s40.h),
    .binop .and w8 (.val w6.i w6.h) (.val m40.i m40.h),
    .binop (.mul { nsw := true }) w9 (.val w7.i w7.h) (.val k19.i k19.h),
    .binop (.add {}) w10 (.val w9.i w9.h) (.val w0.i w0.h),
    .binop (.ashr false) w11 (.val w10.i w10.h) (.val s43.i s43.h),
    .binop .and w12 (.val w10.i w10.h) (.val m43.i m43.h),
    .binop (.add {}) w13 (.val w11.i w11.h) (.val w1.i w1.h),
    .binop (.ashr false) w14 (.val w13.i w13.h) (.val s43.i s43.h),
    .binop .and w15 (.val w13.i w13.h) (.val m43.i m43.h),
    .binop (.add {}) w16 (.val w14.i w14.h) (.val w2.i w2.h),
    .binop (.ashr false) w17 (.val w16.i w16.h) (.val s43.i s43.h),
    .binop .and w18 (.val w16.i w16.h) (.val m43.i m43.h),
    .binop (.add {}) w19 (.val w17.i w17.h) (.val w3.i w3.h),
    .binop (.ashr false) w20 (.val w19.i w19.h) (.val s43.i s43.h),
    .binop .and w21 (.val w19.i w19.h) (.val m43.i m43.h),
    .binop (.add {}) w22 (.val w20.i w20.h) (.val w4.i w4.h),
    .binop (.ashr false) w23 (.val w22.i w22.h) (.val s43.i s43.h),
    .binop .and w24 (.val w22.i w22.h) (.val m43.i m43.h),
    .binop (.add { nsw := true, nuw := true }) w25 (.val w12.i w12.h) (.val k19.i k19.h),
    .binop (.lshr false) w26 (.val w25.i w25.h) (.val s43.i s43.h),
    .binop .and w27 (.val w25.i w25.h) (.val m43.i m43.h),
    .binop (.add { nsw := true, nuw := true }) w28 (.val w15.i w15.h) (.val w26.i w26.h),
    .binop (.lshr false) w29 (.val w28.i w28.h) (.val s43.i s43.h),
    .binop .and w30 (.val w28.i w28.h) (.val m43.i m43.h),
    .binop (.add { nsw := true, nuw := true }) w31 (.val w18.i w18.h) (.val w29.i w29.h),
    .binop (.lshr false) w32 (.val w31.i w31.h) (.val s43.i s43.h),
    .binop .and w33 (.val w31.i w31.h) (.val m43.i m43.h),
    .binop (.add { nsw := true, nuw := true }) w34 (.val w21.i w21.h) (.val w32.i w32.h),
    .binop (.lshr false) w35 (.val w34.i w34.h) (.val s43.i s43.h),
    .binop .and w36 (.val w34.i w34.h) (.val m43.i m43.h),
    .binop (.add { nsw := true, nuw := true }) w37 (.val w24.i w24.h) (.val w35.i w35.h),
    .binop (.lshr false) w38 (.val w37.i w37.h) (.val s43.i s43.h),
    .binop .and w39 (.val w37.i w37.h) (.val m43.i m43.h),
    .binop (.add { nsw := true, nuw := true }) w40 (.val w8.i w8.h) (.val b20.i b20.h),
    .binop (.add { nsw := true }) w41 (.val w40.i w40.h) (.val w23.i w23.h),
    .binop (.add { nsw := true, nuw := true }) w42 (.val w41.i w41.h) (.val w38.i w38.h),
    .binop .and w43 (.val w42.i w42.h) (.val m40.i m40.h),
    .binop (.icmp .ult) w44 (.val w42.i w42.h) (.val two40.i two40.h),
    .ternop (.select (τ := (.bv 64))) w45 (.val w44.i w44.h) (.val m19.i m19.h) (.val i0.i i0.h),
    .binop (.add { nsw := true }) w46 (.val w45.i w45.h) (.val w27.i w27.h),
    .binop (.ashr false) w47 (.val w46.i w46.h) (.val s43.i s43.h),
    .binop (.add { nsw := true }) w48 (.val w47.i w47.h) (.val w30.i w30.h),
    .binop (.ashr false) w49 (.val w48.i w48.h) (.val s43.i s43.h),
    .binop (.add { nsw := true }) w50 (.val w49.i w49.h) (.val w33.i w33.h),
    .binop (.ashr false) w51 (.val w50.i w50.h) (.val s43.i s43.h),
    .binop (.add { nsw := true }) w52 (.val w51.i w51.h) (.val w36.i w36.h),
    .binop (.ashr false) w53 (.val w52.i w52.h) (.val s43.i s43.h),
    .binop (.add { nsw := true }) w54 (.val w53.i w53.h) (.val w39.i w39.h),
    .binop (.ashr false) w55 (.val w54.i w54.h) (.val s43.i s43.h),
    .binop (.add { nsw := true }) w56 (.val w55.i w55.h) (.val w43.i w43.h),
    .binop (.or false) w57 (.val w48.i w48.h) (.val w46.i w46.h),
    .binop (.or false) w58 (.val w57.i w57.h) (.val w50.i w50.h),
    .binop (.or false) w59 (.val w58.i w58.h) (.val w52.i w52.h),
    .binop (.or false) w60 (.val w59.i w59.h) (.val w54.i w54.h),
    .binop .and w61 (.val w60.i w60.h) (.val m43.i m43.h),
    .binop (.or false) w62 (.val w61.i w61.h) (.val w56.i w56.h),
    .binop (.icmp .eq) w63 (.val w62.i w62.h) (.val i0.i i0.h),
    .unop (.trunc (w := 64) (w' := 32) {}) t (.val w46.i w46.h),
    .binop .and a (.val t.i t.h) (.val o1.i o1.h),
    .ternop (.select (τ := (.bv 32))) r (.val w63.i w63.h) (.val m1.i m1.h) (.val a.i a.h)]

/-- The zero test of the reduction, either way round. -/
theorem ite_ofBool_beq (e : BitVec 64) (a b : BitVec 32) :
    (if BitVec.ofBool (e == 0#64) = 1#1 then a else b) =
      if BitVec.ofBool (e != 0#64) = 0#1 then a else b := by
  by_cases h : e = 0#64
  · subst h
    rfl
  · have h' : (e == 0#64) = false := by simpa using h
    have h'' : (e != 0#64) = true := by simpa using h
    rw [h', h'']
    rfl

-- 67 steps, the select's over the unnamed reduction: over 200000 heartbeats
set_option maxHeartbeats 1000000 in
/-- Where the body at `pos` is `diag1Run`, `x` holds `X` and the others the constants: running on
from `pos` then `g` gives `K` if it does from `pos + 67` with `fd_r43x6_diagnose X` in `r`,
whatever the intermediates hold. -/
theorem runBodyFrom_diag1Run {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x : Dst Γ V} {i0 i1 i2 i3 i4 i5 nb s40 m40 k19 s43 m43 b20 two40 m19 w0 w1 w2 w3 w4 w5 w6 w7
        w8 w9 w10 w11 w12 w13 w14 w15 w16 w17 w18 w19 w20 w21 w22 w23 w24 w25 w26 w27 w28 w29 w30
        w31 w32 w33 w34 w35 w36 w37 w38 w39 w40 w41 w42 w43 w45 w46 w47 w48 w49 w50 w51 w52 w53 w54
        w55 w56 w57 w58 w59 w60 w61 w62 : Dst Γ (.bv 64)} {w44 w63 : Dst Γ (.bv 1)}
    {m1 o1 t a r : Dst Γ (.bv 32)} {rest : List (Instr Γ)} {X : Wwl}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = diag1Run x i0 i1 i2 i3 i4 i5 nb s40 m40 k19 s43 m43 b20 two40 m19
        w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16 w17 w18 w19 w20 w21 w22 w23 w24
        w25 w26 w27 w28 w29 w30 w31 w32 w33 w34 w35 w36 w37 w38 w39 w40 w41 w42 w43 w45 w46 w47 w48
        w49 w50 w51 w52 w53 w54 w55 w56 w57 w58 w59 w60 w61 w62 w44 w63 m1 o1 t a r ++ rest)
    (hR : E ⊨ [x := X, m1 := 4294967295#32, o1 := 1#32])
    (hC : NzConsts E i0 i1 i2 i3 i4 i5 nb s40 m40 k19 s43 m43 b20 two40 m19)
    (hd : [x.i, i0.i, i1.i, i2.i, i3.i, i4.i, i5.i, nb.i, s40.i, m40.i, k19.i, s43.i, m43.i, b20.i,
        two40.i, m19.i, w0.i, w1.i, w2.i, w3.i, w4.i, w5.i, w6.i, w7.i, w8.i, w9.i, w10.i, w11.i,
        w12.i, w13.i, w14.i, w15.i, w16.i, w17.i, w18.i, w19.i, w20.i, w21.i, w22.i, w23.i, w24.i,
        w25.i, w26.i, w27.i, w28.i, w29.i, w30.i, w31.i, w32.i, w33.i, w34.i, w35.i, w36.i, w37.i,
        w38.i, w39.i, w40.i, w41.i, w42.i, w43.i, w44.i, w45.i, w46.i, w47.i, w48.i, w49.i, w50.i,
        w51.i, w52.i, w53.i, w54.i, w55.i, w56.i, w57.i, w58.i, w59.i, w60.i, w61.i, w62.i, w63.i,
        m1.i, o1.i, t.i, a.i].Nodup)
    (hK :
      ∀ (vw0 vw1 vw2 vw3 vw4 vw5 vw6 vw7 vw8 vw9 vw10 vw11 vw12 vw13 vw14 vw15 vw16 vw17 vw18 vw19
          vw20 vw21 vw22 vw23 vw24 vw25 vw26 vw27 vw28 vw29 vw30 vw31 vw32 vw33 vw34 vw35 vw36 vw37
          vw38 vw39 vw40 vw41 vw42 vw43 : ⟦(.bv 64)⟧) (vw44 : ⟦(.bv 1)⟧) (vw45 vw46 vw47 vw48 vw49
          vw50 vw51 vw52 vw53 vw54 vw55 vw56 vw57 vw58 vw59 vw60 vw61 vw62 : ⟦(.bv 64)⟧)
          (vw63 : ⟦(.bv 1)⟧) (vt va : ⟦(.bv 32)⟧),
        (blk.runBodyFrom E[w0 := vw0, w1 := vw1, w2 := vw2, w3 := vw3, w4 := vw4, w5 := vw5, w6 :=
            vw6, w7 := vw7, w8 := vw8, w9 := vw9, w10 := vw10, w11 := vw11, w12 := vw12, w13 :=
            vw13, w14 := vw14, w15 := vw15, w16 := vw16, w17 := vw17, w18 := vw18, w19 := vw19, w20
            := vw20, w21 := vw21, w22 := vw22, w23 := vw23, w24 := vw24, w25 := vw25, w26 := vw26,
            w27 := vw27, w28 := vw28, w29 := vw29, w30 := vw30, w31 := vw31, w32 := vw32, w33 :=
            vw33, w34 := vw34, w35 := vw35, w36 := vw36, w37 := vw37, w38 := vw38, w39 := vw39, w40
            := vw40, w41 := vw41, w42 := vw42, w43 := vw43, w44 := vw44, w45 := vw45, w46 := vw46,
            w47 := vw47, w48 := vw48, w49 := vw49, w50 := vw50, w51 := vw51, w52 := vw52, w53 :=
            vw53, w54 := vw54, w55 := vw55, w56 := vw56, w57 := vw57, w58 := vw58, w59 := vw59, w60
            := vw60, w61 := vw61, w62 := vw62, w63 := vw63, t := vt, a := va, r :=
            .value (fd_r43x6_diagnose.spec X)] (pos + 67) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  simp only [diag1Run] at hbody
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step_with vt5
  nz_step
  nz_step
  nz_step
  nz_step_with vt0
  nz_step
  nz_step
  nz_step_with vt1
  nz_step
  nz_step
  nz_step_with vt2
  nz_step
  nz_step
  nz_step_with vt3
  nz_step
  nz_step
  nz_step_with vt4
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
  nz_step_with wz
  step_pure with wt
  step_pure with wa
  step_pure with wr
  have e : wr = fd_r43x6_diagnose.spec X := by
    rw [diagnose_eq, ← nzLimbs_eq]
    subst_vars
    simp only [nzLimbs, parLimbs, redLimbs, ite_ofBool_beq]
    rfl
  rw [hE, e]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

/-- `x_0 == fd_r43x6_diagnose(x)` as compiled: `nz1Run`'s reduction of lanes `0 … 5` of `x` and
its nonzero test, the reduced limb `0`'s low bit (`o1` holds `1`) tested against `x0`, false (`f`)
for a zero reduction, in `k`. -/
def keep1Run (x : Dst Γ V)
    (i0 i1 i2 i3 i4 i5 nb s40 m40 k19 s43 m43 b20 two40 m19 w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11
      w12 w13 w14 w15 w16 w17 w18 w19 w20 w21 w22 w23 w24 w25 w26 w27 w28 w29 w30 w31 w32 w33 w34
      w35 w36 w37 w38 w39 w40 w41 w42 w43 w45 w46 w47 w48 w49 w50 w51 w52 w53 w54 w55 w56 w57 w58
      w59 w60 w61 w62 : Dst Γ (.bv 64))
    (w44 w63 : Dst Γ (.bv 1)) (o1 x0 t a : Dst Γ (.bv 32)) (e f k : Dst Γ (.bv 1)) :
    List (Instr Γ) :=
  [.binop .extractelement w0 (.val x.i x.h) (.val i0.i i0.h),
    .binop .extractelement w1 (.val x.i x.h) (.val i1.i i1.h),
    .binop .extractelement w2 (.val x.i x.h) (.val i2.i i2.h),
    .binop .extractelement w3 (.val x.i x.h) (.val i3.i i3.h),
    .binop .extractelement w4 (.val x.i x.h) (.val i4.i i4.h),
    .binop .extractelement w5 (.val x.i x.h) (.val i5.i i5.h),
    .binop (.add {}) w6 (.val w5.i w5.h) (.val nb.i nb.h),
    .binop (.ashr false) w7 (.val w6.i w6.h) (.val s40.i s40.h),
    .binop .and w8 (.val w6.i w6.h) (.val m40.i m40.h),
    .binop (.mul { nsw := true }) w9 (.val w7.i w7.h) (.val k19.i k19.h),
    .binop (.add {}) w10 (.val w9.i w9.h) (.val w0.i w0.h),
    .binop (.ashr false) w11 (.val w10.i w10.h) (.val s43.i s43.h),
    .binop .and w12 (.val w10.i w10.h) (.val m43.i m43.h),
    .binop (.add {}) w13 (.val w11.i w11.h) (.val w1.i w1.h),
    .binop (.ashr false) w14 (.val w13.i w13.h) (.val s43.i s43.h),
    .binop .and w15 (.val w13.i w13.h) (.val m43.i m43.h),
    .binop (.add {}) w16 (.val w14.i w14.h) (.val w2.i w2.h),
    .binop (.ashr false) w17 (.val w16.i w16.h) (.val s43.i s43.h),
    .binop .and w18 (.val w16.i w16.h) (.val m43.i m43.h),
    .binop (.add {}) w19 (.val w17.i w17.h) (.val w3.i w3.h),
    .binop (.ashr false) w20 (.val w19.i w19.h) (.val s43.i s43.h),
    .binop .and w21 (.val w19.i w19.h) (.val m43.i m43.h),
    .binop (.add {}) w22 (.val w20.i w20.h) (.val w4.i w4.h),
    .binop (.ashr false) w23 (.val w22.i w22.h) (.val s43.i s43.h),
    .binop .and w24 (.val w22.i w22.h) (.val m43.i m43.h),
    .binop (.add { nsw := true, nuw := true }) w25 (.val w12.i w12.h) (.val k19.i k19.h),
    .binop (.lshr false) w26 (.val w25.i w25.h) (.val s43.i s43.h),
    .binop .and w27 (.val w25.i w25.h) (.val m43.i m43.h),
    .binop (.add { nsw := true, nuw := true }) w28 (.val w15.i w15.h) (.val w26.i w26.h),
    .binop (.lshr false) w29 (.val w28.i w28.h) (.val s43.i s43.h),
    .binop .and w30 (.val w28.i w28.h) (.val m43.i m43.h),
    .binop (.add { nsw := true, nuw := true }) w31 (.val w18.i w18.h) (.val w29.i w29.h),
    .binop (.lshr false) w32 (.val w31.i w31.h) (.val s43.i s43.h),
    .binop .and w33 (.val w31.i w31.h) (.val m43.i m43.h),
    .binop (.add { nsw := true, nuw := true }) w34 (.val w21.i w21.h) (.val w32.i w32.h),
    .binop (.lshr false) w35 (.val w34.i w34.h) (.val s43.i s43.h),
    .binop .and w36 (.val w34.i w34.h) (.val m43.i m43.h),
    .binop (.add { nsw := true, nuw := true }) w37 (.val w24.i w24.h) (.val w35.i w35.h),
    .binop (.lshr false) w38 (.val w37.i w37.h) (.val s43.i s43.h),
    .binop .and w39 (.val w37.i w37.h) (.val m43.i m43.h),
    .binop (.add { nsw := true, nuw := true }) w40 (.val w8.i w8.h) (.val b20.i b20.h),
    .binop (.add { nsw := true }) w41 (.val w40.i w40.h) (.val w23.i w23.h),
    .binop (.add { nsw := true, nuw := true }) w42 (.val w41.i w41.h) (.val w38.i w38.h),
    .binop .and w43 (.val w42.i w42.h) (.val m40.i m40.h),
    .binop (.icmp .ult) w44 (.val w42.i w42.h) (.val two40.i two40.h),
    .ternop (.select (τ := (.bv 64))) w45 (.val w44.i w44.h) (.val m19.i m19.h) (.val i0.i i0.h),
    .binop (.add { nsw := true }) w46 (.val w45.i w45.h) (.val w27.i w27.h),
    .binop (.ashr false) w47 (.val w46.i w46.h) (.val s43.i s43.h),
    .binop (.add { nsw := true }) w48 (.val w47.i w47.h) (.val w30.i w30.h),
    .binop (.ashr false) w49 (.val w48.i w48.h) (.val s43.i s43.h),
    .binop (.add { nsw := true }) w50 (.val w49.i w49.h) (.val w33.i w33.h),
    .binop (.ashr false) w51 (.val w50.i w50.h) (.val s43.i s43.h),
    .binop (.add { nsw := true }) w52 (.val w51.i w51.h) (.val w36.i w36.h),
    .binop (.ashr false) w53 (.val w52.i w52.h) (.val s43.i s43.h),
    .binop (.add { nsw := true }) w54 (.val w53.i w53.h) (.val w39.i w39.h),
    .binop (.ashr false) w55 (.val w54.i w54.h) (.val s43.i s43.h),
    .binop (.add { nsw := true }) w56 (.val w55.i w55.h) (.val w43.i w43.h),
    .binop (.or false) w57 (.val w48.i w48.h) (.val w46.i w46.h),
    .binop (.or false) w58 (.val w57.i w57.h) (.val w50.i w50.h),
    .binop (.or false) w59 (.val w58.i w58.h) (.val w52.i w52.h),
    .binop (.or false) w60 (.val w59.i w59.h) (.val w54.i w54.h),
    .binop .and w61 (.val w60.i w60.h) (.val m43.i m43.h),
    .binop (.or false) w62 (.val w61.i w61.h) (.val w56.i w56.h),
    .binop (.icmp .ne) w63 (.val w62.i w62.h) (.val i0.i i0.h),
    .unop (.trunc (w := 64) (w' := 32) {}) t (.val w46.i w46.h),
    .binop .and a (.val t.i t.h) (.val o1.i o1.h),
    .binop (.icmp .eq) e (.val a.i a.h) (.val x0.i x0.h),
    .ternop (.select (τ := (.bv 1))) k (.val w63.i w63.h) (.val e.i e.h) (.val f.i f.h)]

/-- The compiled `x_0 == x_mod_2` for `x_0` a bit: false when the reduction is zero (`diagnose`
gives `-1`), else the low bit's test. -/
theorem keep_eq_diag (n : BitVec 1) (p x0 : BitVec 32) (h01 : x0 = 0 ∨ x0 = 1) :
    (if n = 1#1 then BitVec.ofBool (p == x0) else 0#1) =
      BitVec.ofBool ((if n = 0#1 then -1 else p) == x0) := by
  rcases h01 with rfl | rfl <;> bv_decide

-- 68 steps, the select's over the unnamed reduction: over 200000 heartbeats
set_option maxHeartbeats 1000000 in
/-- Where the body at `pos` is `keep1Run`, `x` holds `X`, `x0` a bit `X0` and the others the
constants: running on from `pos` then `g` gives `K` if it does from `pos + 68` with whether
`fd_r43x6_diagnose X = X0` in `k`, whatever the intermediates hold. -/
theorem runBodyFrom_keep1Run {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x : Dst Γ V} {i0 i1 i2 i3 i4 i5 nb s40 m40 k19 s43 m43 b20 two40 m19 w0 w1 w2 w3 w4 w5 w6 w7
        w8 w9 w10 w11 w12 w13 w14 w15 w16 w17 w18 w19 w20 w21 w22 w23 w24 w25 w26 w27 w28 w29 w30
        w31 w32 w33 w34 w35 w36 w37 w38 w39 w40 w41 w42 w43 w45 w46 w47 w48 w49 w50 w51 w52 w53 w54
        w55 w56 w57 w58 w59 w60 w61 w62 : Dst Γ (.bv 64)} {w44 w63 : Dst Γ (.bv 1)}
    {o1 x0 t a : Dst Γ (.bv 32)} {e f k : Dst Γ (.bv 1)} {rest : List (Instr Γ)} {X : Wwl}
    {X0 : BitVec 32} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = keep1Run x i0 i1 i2 i3 i4 i5 nb s40 m40 k19 s43 m43 b20 two40 m19
        w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16 w17 w18 w19 w20 w21 w22 w23 w24
        w25 w26 w27 w28 w29 w30 w31 w32 w33 w34 w35 w36 w37 w38 w39 w40 w41 w42 w43 w45 w46 w47 w48
        w49 w50 w51 w52 w53 w54 w55 w56 w57 w58 w59 w60 w61 w62 w44 w63 o1 x0 t a e f k ++ rest)
    (hR : E ⊨ [x := X, o1 := 1#32, x0 := X0, f := 0#1]) (hX0 : X0 = 0 ∨ X0 = 1)
    (hC : NzConsts E i0 i1 i2 i3 i4 i5 nb s40 m40 k19 s43 m43 b20 two40 m19)
    (hd : [x.i, i0.i, i1.i, i2.i, i3.i, i4.i, i5.i, nb.i, s40.i, m40.i, k19.i, s43.i, m43.i, b20.i,
        two40.i, m19.i, w0.i, w1.i, w2.i, w3.i, w4.i, w5.i, w6.i, w7.i, w8.i, w9.i, w10.i, w11.i,
        w12.i, w13.i, w14.i, w15.i, w16.i, w17.i, w18.i, w19.i, w20.i, w21.i, w22.i, w23.i, w24.i,
        w25.i, w26.i, w27.i, w28.i, w29.i, w30.i, w31.i, w32.i, w33.i, w34.i, w35.i, w36.i, w37.i,
        w38.i, w39.i, w40.i, w41.i, w42.i, w43.i, w44.i, w45.i, w46.i, w47.i, w48.i, w49.i, w50.i,
        w51.i, w52.i, w53.i, w54.i, w55.i, w56.i, w57.i, w58.i, w59.i, w60.i, w61.i, w62.i, w63.i,
        o1.i, x0.i, t.i, a.i, e.i, f.i].Nodup)
    (hK :
      ∀ (vw0 vw1 vw2 vw3 vw4 vw5 vw6 vw7 vw8 vw9 vw10 vw11 vw12 vw13 vw14 vw15 vw16 vw17 vw18 vw19
          vw20 vw21 vw22 vw23 vw24 vw25 vw26 vw27 vw28 vw29 vw30 vw31 vw32 vw33 vw34 vw35 vw36 vw37
          vw38 vw39 vw40 vw41 vw42 vw43 : ⟦(.bv 64)⟧) (vw44 : ⟦(.bv 1)⟧) (vw45 vw46 vw47 vw48 vw49
          vw50 vw51 vw52 vw53 vw54 vw55 vw56 vw57 vw58 vw59 vw60 vw61 vw62 : ⟦(.bv 64)⟧)
          (vw63 : ⟦(.bv 1)⟧) (vt va : ⟦(.bv 32)⟧) (ve : ⟦(.bv 1)⟧),
        (blk.runBodyFrom E[w0 := vw0, w1 := vw1, w2 := vw2, w3 := vw3, w4 := vw4, w5 := vw5, w6 :=
            vw6, w7 := vw7, w8 := vw8, w9 := vw9, w10 := vw10, w11 := vw11, w12 := vw12, w13 :=
            vw13, w14 := vw14, w15 := vw15, w16 := vw16, w17 := vw17, w18 := vw18, w19 := vw19, w20
            := vw20, w21 := vw21, w22 := vw22, w23 := vw23, w24 := vw24, w25 := vw25, w26 := vw26,
            w27 := vw27, w28 := vw28, w29 := vw29, w30 := vw30, w31 := vw31, w32 := vw32, w33 :=
            vw33, w34 := vw34, w35 := vw35, w36 := vw36, w37 := vw37, w38 := vw38, w39 := vw39, w40
            := vw40, w41 := vw41, w42 := vw42, w43 := vw43, w44 := vw44, w45 := vw45, w46 := vw46,
            w47 := vw47, w48 := vw48, w49 := vw49, w50 := vw50, w51 := vw51, w52 := vw52, w53 :=
            vw53, w54 := vw54, w55 := vw55, w56 := vw56, w57 := vw57, w58 := vw58, w59 := vw59, w60
            := vw60, w61 := vw61, w62 := vw62, w63 := vw63, t := vt, a := va, e := ve, k :=
            .value (BitVec.ofBool (fd_r43x6_diagnose.spec X == X0))] (pos + 68) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  simp only [keep1Run] at hbody
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step
  nz_step_with vt5
  nz_step
  nz_step
  nz_step
  nz_step_with vt0
  nz_step
  nz_step
  nz_step_with vt1
  nz_step
  nz_step
  nz_step_with vt2
  nz_step
  nz_step
  nz_step_with vt3
  nz_step
  nz_step
  nz_step_with vt4
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
  step_pure with wt
  step_pure with wa
  step_pure with we
  step_pure with wk
  have e : wk = BitVec.ofBool (fd_r43x6_diagnose.spec X == X0) := by
    rw [diagnose_eq, ← nzLimbs_eq, ← keep_eq_diag _ _ _ hX0]
    subst_vars
    rfl
  rw [hE, e]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

/-! ## A `<6 x i64>` load, broadcast -/

/-- Lanes `0 … 5` of `x` as a `<6 x i64>`, as a narrowed load reads them. -/
abbrev lanes6 (x : Wwl) : Vector (BitVec 64) 6 :=
  Vector.ofFn fun i : Fin 6 => x[i.1]

/-- A `<6 x i64>` load of the vector stored at a place: its lanes `0 … 5`. -/
theorem load6_eq (x : Wwl) :
    (Vector.ofFn fun i : Fin 6 => Ty.extractVecElem 6 64 i ((BitVec.packLanes x).setWidth 384)) =
      lanes6 x := by
  apply Vector.ext
  intro i hi
  simp only [Vector.getElem_ofFn, Ty.extractVecElem_eq, lanes6]
  rw [BitVec.extractLsb'_setWidth_of_le (by omega)]
  exact BitVec.extractLsb'_packLanes x i (by omega)

/-- `u`'s six lanes broadcast into `x0 … x5` (`p` the shuffles' unused operand). -/
def bcast6Run (u p : Dst Γ (.vec 6 64)) (x0 x1 x2 x3 x4 x5 : Dst Γ V) : List (Instr Γ) :=
  [.binop (.shufflevector #v[some 0, some 0, some 0, some 0, some 0, some 0, some 0, some 0]) x0
      (.val u.i u.h) (.val p.i p.h),
    .binop (.shufflevector #v[some 1, some 1, some 1, some 1, some 1, some 1, some 1, some 1]) x1
      (.val u.i u.h) (.val p.i p.h),
    .binop (.shufflevector #v[some 2, some 2, some 2, some 2, some 2, some 2, some 2, some 2]) x2
      (.val u.i u.h) (.val p.i p.h),
    .binop (.shufflevector #v[some 3, some 3, some 3, some 3, some 3, some 3, some 3, some 3]) x3
      (.val u.i u.h) (.val p.i p.h),
    .binop (.shufflevector #v[some 4, some 4, some 4, some 4, some 4, some 4, some 4, some 4]) x4
      (.val u.i u.h) (.val p.i p.h),
    .binop (.shufflevector #v[some 5, some 5, some 5, some 5, some 5, some 5, some 5, some 5]) x5
      (.val u.i u.h) (.val p.i p.h)]

/-- Where the body at `pos` is `bcast6Run` and `u` holds lanes `0 … 5` of `X`: running on from
`pos` then `g` gives `K` if it does from `pos + 6` with `X`'s lanes broadcast in `x0 … x5`. -/
theorem runBodyFrom_bcast6Run {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {u p : Dst Γ (.vec 6 64)} {x0 x1 x2 x3 x4 x5 : Dst Γ V} {rest : List (Instr Γ)} {X : Wwl}
    {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody : blk.body.drop pos = bcast6Run u p x0 x1 x2 x3 x4 x5 ++ rest)
    (hR : E ⊨ [u := lanes6 X]) (hd : [u.i, x0.i, x1.i, x2.i, x3.i, x4.i, x5.i].Nodup)
    (hK :
      (blk.runBodyFrom
            E[x0 := Vector.replicate 8 X[0], x1 := Vector.replicate 8 X[1], x2 :=
              Vector.replicate 8 X[2], x3 := Vector.replicate 8 X[3], x4 := Vector.replicate 8 X[4],
              x5 := Vector.replicate 8 X[5]]
            (pos + 6) S >>= g) =
        K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  simp only [bcast6Run] at hbody
  step_pure with v0
  step_pure with v1
  step_pure with v2
  step_pure with v3
  step_pure with v4
  step_pure with v5
  have e (k : Nat) (hk : k < 8) (v : Vector (BitVec 64) 8)
      (hv : v = #v[X[k], X[k], X[k], X[k], X[k], X[k], X[k], X[k]]) :
      v = Vector.replicate 8 X[k] := by
    rw [hv]
    rfl
  rw [hE, e 0 (by decide) v0 hv0, e 1 (by decide) v1 hv1, e 2 (by decide) v2 hv2,
    e 3 (by decide) v3 hv3, e 4 (by decide) v4 hv4, e 5 (by decide) v5 hv5]
  exact hK

/-! ## `FD_R43X6_QUAD_PACK`, its last vector kept -/

/-- `runBodyFrom_quadPackRun` with `q25`'s vector given: the stored QUAD's lanes `2 5`. -/
theorem runBodyFrom_quadPackRunV {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {x y zlo zhi t a b c d e f g h q03 q14 q25 : Dst Γ V} {p03 p14 p25 : Fin Γ.args.length}
    {h03 : Γ.args[p03] = .ptr} {h14 : Γ.args[p14] = .ptr} {h25 : Γ.args[p25] = .ptr}
    {rest : List (Instr Γ)} {X Y T : Vector (BitVec 64) 8} {P03 P14 P25 : Pointer} {S : GlobalState}
    {k : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        quadPackRun x y zlo zhi t a b c d e f g h q03 q14 q25 p03 p14 p25 h03 h14 h25 ++ rest)
    (hR :
      E ⊨ [x := X, y := Y, zlo := oneLo, zhi := oneHi, t := T, .arg p03 h03 := P03, .arg p14 h14 :=
        P14, .arg p25 h25 := P25])
    (hf03 : Room S.mem P03 512) (hf14 : Room S.mem P14 512) (hf25 : Room S.mem P25 512)
    (hd : [x.i, y.i, zlo.i, zhi.i, t.i, a.i, b.i, c.i, d.i, e.i, f.i, g.i, h.i, q03.i, q14.i].Nodup)
    (hK :
      ∀ va vb vc vd ve vf vg vh vq03 vq14 : ⟦V⟧,
        (blk.runBodyFrom
              E[a := va, b := vb, c := vc, d := vd, e := ve, f := vf, g := vg, h := vh, q03 := vq03,
                q14 := vq14, q25 := Ty.wrap (quadLanes 2 X Y one T)]
              (pos + 14)
              { S with
                mem :=
                  ((S.mem.storeAt P03 (BitVec.packLanes (quadLanes 0 X Y one T))).storeAt P14
                        (BitVec.packLanes (quadLanes 1 X Y one T))).storeAt
                    P25 (BitVec.packLanes (quadLanes 2 X Y one T)) } >>=
            k) =
          K) :
    (blk.runBodyFrom E pos S >>= k) = K := by
  simp only [quadPackRun] at hbody
  iterate 8 step_pure
  step_pure with vq03
  step_store
  step_pure with vq14
  step_store
  step_pure with vq25
  step_store
  have e03 : vq03 = quadLanes 0 X Y one T := by
    rw [hvq03]; rfl
  have e14 : vq14 = quadLanes 1 X Y one T := by
    rw [hvq14]; rfl
  have e25 : vq25 = quadLanes 2 X Y one T := by
    rw [hvq25]; rfl
  subst hE hS
  rw [e03, e14, e25]
  exact hK _ _ _ _ _ _ _ _ _ _

/-! ## `FD_R43X6_QUAD_FOLD_UNSIGNED` on a just stored QUAD -/

/-- `quadFoldRun` with the vector at `p25` not reloaded: its stored value `x25` shifted. -/
def quadFoldRunV (x25 s43 s m43 m k ld03 sh03 ld14 sh14 sh25 c t lo03 r03 ld14' lo14 r14 ld25' lo25
      r25 : Dst Γ V)
    (p03 p14 p25 : Fin Γ.args.length) (h03 : Γ.args[p03] = .ptr) (h14 : Γ.args[p14] = .ptr)
    (h25 : Γ.args[p25] = .ptr) : List (Instr Γ) :=
  [.load ld03 (.arg p03 h03),
    .binop (.vector (.lshr false)) sh03 (.val ld03.i ld03.h) (.val s43.i s43.h),
    .load ld14 (.arg p14 h14),
    .binop (.vector (.lshr false)) sh14 (.val ld14.i ld14.h) (.val s43.i s43.h),
    .binop (.vector (.lshr false)) sh25 (.val x25.i x25.h) (.val s.i s.h),
    .binop (.vector (.mul { nsw := true, nuw := true })) c (.val sh25.i sh25.h) (.val k.i k.h),
    .binop (.vector .and) lo03 (.val ld03.i ld03.h) (.val m43.i m43.h),
    .binop
      (.shufflevector
        (#v[some 4, some 5, some 6, some 7, some 8, some 9, some 10, some 11] :
          Vector (Option (Fin (2 * 8))) 8))
      t (.val c.i c.h) (.val sh25.i sh25.h),
    .binop (.vector (.add { nsw := true, nuw := true })) r03 (.val t.i t.h) (.val lo03.i lo03.h),
    .store (.arg p03 h03) (.val r03.i r03.h), .load ld14' (.arg p14 h14),
    .binop (.vector .and) lo14 (.val ld14'.i ld14'.h) (.val m43.i m43.h),
    .binop (.vector (.add { nsw := true, nuw := true })) r14 (.val lo14.i lo14.h)
      (.val sh03.i sh03.h),
    .store (.arg p14 h14) (.val r14.i r14.h), .load ld25' (.arg p25 h25),
    .binop (.vector .and) lo25 (.val ld25'.i ld25'.h) (.val m.i m.h),
    .binop (.vector (.add { nsw := true, nuw := true })) r25 (.val lo25.i lo25.h)
      (.val sh14.i sh14.h)]

/-- `runBodyFrom_quadFoldRun` for `quadFoldRunV`, `x25` holding what `P25` holds. -/
theorem runBodyFrom_quadFoldRunV {blk : BasicBlock Γ tRets bp} {E₀ : ⟪Γ⟫} {pos : Nat}
    {x25 s43 s m43 m k ld03 sh03 ld14 sh14 sh25 c t lo03 r03 ld14' lo14 r14 ld25' lo25 r25 :
      Dst Γ V}
    {p03 p14 p25 : Fin Γ.args.length} {h03 : Γ.args[p03] = .ptr} {h14 : Γ.args[p14] = .ptr}
    {h25 : Γ.args[p25] = .ptr} {rest : List (Instr Γ)} {X03 X14 X25 : Vector (BitVec 64) 8}
    {P03 P14 P25 : Pointer} {S₀ : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        quadFoldRunV x25 s43 s m43 m k ld03 sh03 ld14 sh14 sh25 c t lo03 r03 ld14' lo14 r14 ld25'
            lo25 r25 p03 p14 p25 h03 h14 h25 ++
          rest)
    (hR :
      E₀ ⊨ [x25 := X25, s43 := Vector.replicate 8 43, s := quadShifts, m43 :=
        Vector.replicate 8 8796093022207, m := quadFoldMask, k := quad19, .arg p03 h03 := P03,
        .arg p14 h14 := P14, .arg p25 h25 := P25])
    (hf03 : Fits S₀.mem P03 512) (hf14 : Fits S₀.mem P14 512) (hf25 : Fits S₀.mem P25 512)
    (hw03 : Writable S₀.mem P03) (hw14 : Writable S₀.mem P14) (hw25 : Writable S₀.mem P25)
    (hd0314 : P03.id ≠ P14.id) (hd0325 : P03.id ≠ P25.id) (hd1425 : P14.id ≠ P25.id)
    (hx03 : S₀.mem.readAt P03 512 = BitVec.packLanes X03)
    (hx14 : S₀.mem.readAt P14 512 = BitVec.packLanes X14)
    (hx25 : S₀.mem.readAt P25 512 = BitVec.packLanes X25)
    (hd :
      [x25.i, s43.i, s.i, m43.i, m.i, k.i, ld03.i, sh03.i, ld14.i, sh14.i, sh25.i, c.i, t.i, lo03.i,
          r03.i, ld14'.i, lo14.i, r14.i, ld25'.i, lo25.i].Nodup)
    (hK :
      ∀ vld03 vsh03 vld14 vsh14 vsh25 vc vlo03 vt vr03 vld14' vlo14 vr14 vld25' vlo25 : ⟦V⟧,
        (blk.runBodyFrom
              E₀[ld03 := vld03, sh03 := vsh03, ld14 := vld14, sh14 := vsh14, sh25 := vsh25, c := vc,
                lo03 := vlo03, t := vt, r03 := vr03, ld14' := vld14', lo14 := vlo14, r14 := vr14,
                ld25' := vld25', lo25 := vlo25, r25 := Ty.wrap (quadFold25 X25 X14)]
              (pos + 17)
              { S₀ with
                mem :=
                  (S₀.mem.storeAt P03 (BitVec.packLanes (quadFold03 X03 X25))).storeAt P14
                    (BitVec.packLanes (quadFold14 X14 X03)) } >>=
            g) =
          K) :
    (blk.runBodyFrom E₀ pos S₀ >>= g) = K := by
  simp only [quadFoldRunV] at hbody
  step_load with vld03
  step_pure with transparent vsh03
  step_load with vld14
  step_pure with transparent vsh14
  step_pure [quadShifts_lt] with transparent vsh25
  step_pure [quadShifts_lt, shr40_mul19] with transparent vc
  step_pure with transparent vlo03
  step_pure [shr40_mul19] with transparent vt
  step_pure [carry_add_low_lanes] with vr03
  replace hvr03 : vr03 = quadFold03 X03 X25 := by
    simp [quadFold03, hvr03]
    apply vec_ext_fin
    intro i
    fin_cases i <;> simp
  step_store
  step_load with vld14'
  step_pure with transparent vlo14
  step_pure [carry_add_low] with vr14
  replace hvr14 : vr14 = quadFold14 X14 X03 := by simp [quadFold14, hvr14]
  step_store
  step_load with vld25'
  step_pure with transparent vlo25
  step_pure [low_add_carry] with vr25
  replace hvr25 : vr25 = quadFold25 X25 X14 := by simp [quadFold25, hvr25]
  subst hE hS
  rw [hvr03, hvr14, hvr25]
  exact hK _ _ _ _ _ _ _ _ _ _ _ _ _ _

/-! ## The state -/

/-- `fd_r43x6_ge_decode_t`: the chain's accumulator `x`, its value `m` at the stage's start, the
named multipliers (`none` until their stage stores them), the head's results, the stage, the
squarings left in it, and the sign bit `x_0`. -/
structure DecSt where
  x : Wwl
  m : Wwl
  z : Wwl
  z2 : Option Wwl
  z9 : Option Wwl
  z2e10m1 : Option Wwl
  z2e50m1 : Option Wwl
  y : Wwl
  u : Wwl
  v : Wwl
  uv3 : Wwl
  stage : BitVec 64
  rem : BitVec 64
  x0 : BitVec 32

/-- Store `v` at `p` if there is one. -/
def _root_.MLIR.MemoryState.storeOpt (m : MemoryState) (p : Pointer) : Option Wwl → MemoryState
  | none => m
  | some v => m.storeVec p v

/-- Store the state `D` at `st`, its fields in the order of their byte offsets. -/
def _root_.MLIR.MemoryState.storeDec (m : MemoryState) (st : Pointer) (D : DecSt) : MemoryState :=
  (((((((((((((m.storeVec st D.x).storeVec (st.add 64#64) D.m).storeVec (st.add 128#64)
                                  D.z).storeOpt (st.add 192#64) D.z2).storeOpt
                              (st.add 256#64) D.z9).storeOpt
                          (st.add 320#64) D.z2e10m1).storeOpt
                      (st.add 384#64) D.z2e50m1).storeVec
                  (st.add 448#64) D.y).storeVec
              (st.add 512#64) D.u).storeVec
          (st.add 576#64) D.v).storeVec
        (st.add 640#64) D.uv3).storeAt (st.add 704#64) D.stage).storeAt (st.add 712#64)
        D.rem).storeAt (st.add 720#64) D.x0

/-- Room for the state at `st` (its 724 bytes), and its offsets do not wrap. -/
abbrev _root_.MLIR.MemoryState.DecRoom (m : MemoryState) (st : Pointer) : Prop :=
  ¬st.offset.uaddOverflow 724#64 ∧ Room m st 5792

/-- A vector field holds `v`, if there is one. -/
def _root_.MLIR.MemoryState.OptHolds (m : MemoryState) (p : Pointer) : Option Wwl → Prop
  | none => True
  | some v => Fits m p 512 ∧ m.readAt p 512 = BitVec.packLanes v

/-- The state at `st` is `D`: each field known, as a load reads it. -/
abbrev _root_.MLIR.MemoryState.DecHolds (m : MemoryState) (st : Pointer) (D : DecSt) : Prop :=
  (Fits m st 512 ∧ m.readAt st 512 = BitVec.packLanes D.x) ∧
    (Fits m (st.add 64#64) 512 ∧ m.readAt (st.add 64#64) 512 = BitVec.packLanes D.m) ∧
    (Fits m (st.add 128#64) 512 ∧ m.readAt (st.add 128#64) 512 = BitVec.packLanes D.z) ∧
    m.OptHolds (st.add 192#64) D.z2 ∧ m.OptHolds (st.add 256#64) D.z9 ∧
    m.OptHolds (st.add 320#64) D.z2e10m1 ∧ m.OptHolds (st.add 384#64) D.z2e50m1 ∧
    (Fits m (st.add 448#64) 512 ∧ m.readAt (st.add 448#64) 512 = BitVec.packLanes D.y) ∧
    (Fits m (st.add 512#64) 512 ∧ m.readAt (st.add 512#64) 512 = BitVec.packLanes D.u) ∧
    (Fits m (st.add 576#64) 512 ∧ m.readAt (st.add 576#64) 512 = BitVec.packLanes D.v) ∧
    (Fits m (st.add 640#64) 512 ∧ m.readAt (st.add 640#64) 512 = BitVec.packLanes D.uv3) ∧
    (Fits m (st.add 704#64) 64 ∧ m.readAt (st.add 704#64) 64 = D.stage) ∧
    (Fits m (st.add 712#64) 64 ∧ m.readAt (st.add 712#64) 64 = D.rem) ∧
    (Fits m (st.add 720#64) 32 ∧ m.readAt (st.add 720#64) 32 = D.x0)

/-- The encoding's lanes, the top bit cleared, as a `<4 x i64>` load masks it. -/
theorem decLanes_mask (s : BitVec 256) :
    (Vector.ofFn fun i : Fin 4 =>
        (Vector.ofFn fun j : Fin 4 => Ty.extractVecElem 4 64 j s)[(i : Nat)] &&&
          [18446744073709551615#64, 18446744073709551615#64, 18446744073709551615#64,
            9223372036854775807#64][(i : Nat)]) =
      Vector.ofFn fun i =>
        Ty.extractVecElem 4 64 i (Memory.spliceBits s 192 (s.extractLsb' 192 64 &&&
          0x7FFFFFFFFFFFFFFF)) := by
  apply vec_ext_fin
  intro i
  fin_cases i <;> simp only [Ty.extractVecElem_eq] <;> simp
  · rw [Memory.extractLsb'_spliceBits_of_disjoint _ _ _ _ (by omega), and_allOnes_lit]
  · rw [Memory.extractLsb'_spliceBits_of_disjoint _ _ _ _ (by omega), and_allOnes_lit]
  · rw [Memory.extractLsb'_spliceBits_of_disjoint _ _ _ _ (by omega), and_allOnes_lit]
  · rw [Memory.extractLsb'_spliceBits_self _ _ _ (by omega)]

/-! ## The specs -/

open Firedancer.Avx512.fd_r43x6_ge_decode2 (d pSubOne) in
/-- `fd_r43x6_ge_decode_init` on the encoding `s`: `y` its low 255 bits unpacked, `u = y² - 1`,
`v = d y² + 1`, `u v³`, and the chain started on `z = u v⁷` (stage `0`, one squaring left). -/
def DecSt.init (s : BitVec 256) : DecSt :=
  let y3 := s.extractLsb' 192 64
  let x0 := (y3 >>> 63).setWidth 32
  let y3 := y3 &&& 0x7FFFFFFFFFFFFFFF
  let y :=
    fd_r43x6_unpack.spec
      (Vector.ofFn fun i => Ty.extractVecElem 4 64 i (Memory.spliceBits s 192 y3))
  let ysq := fd_r43x6_sqr y
  let u := vadd (foldSignedPre (vadd ysq pSubOne)) negBias
  let v := vadd (fd_r43x6_mul d ysq) one
  let v2 := fd_r43x6_sqr v
  let v4 := fd_r43x6_sqr v2
  let v3 := fd_r43x6_mul v v2
  let uv3 := fd_r43x6_mul u v3
  let uv7 := fd_r43x6_mul uv3 v4
  ⟨uv7, uv7, uv7, none, none, none, none, y, u, v, uv3, 0, 1, x0⟩

/-- `n` pairs of squarings after one: `x` squared `2 n + 2` times. -/
def sqrPairs : Nat → Wwl → Wwl
  | 0, x => fd_r43x6_sqr (fd_r43x6_sqr x)
  | n + 1, x => sqrPairs n (fd_r43x6_sqr (fd_r43x6_sqr x))

/-- `sqrPairs` is `fd_r43x6_repsqr_mul2.sqrN`. -/
theorem sqrPairs_eq : ∀ n x, sqrPairs n x = Avx512.fd_r43x6_repsqr_mul2.sqrN (2 * n + 2) x
  | 0, _ => rfl
  | n + 1, x => by
    rw [sqrPairs, sqrPairs_eq n]
    show _ = Avx512.fd_r43x6_repsqr_mul2.sqrN (2 * n + 2 + 2) x
    rfl

/-- `decode_stage.sqr_cnt`: the squarings of each stage. -/
def sqrCnt (i : BitVec 64) : BitVec 64 :=
  ([1, 2, 0, 1, 5, 10, 20, 10, 50, 100, 50, 2] : List (BitVec 64)).getD i.toNat 0

/-- `decode_stage`'s multiply: the stage's multiplier, and the named results it keeps. -/
def DecSt.stageMul (D : DecSt) : DecSt :=
  match D.stage.toNat with
  | 0 => { D with z2 := some D.x }
  | 1 =>
    let x := fd_r43x6_mul D.x D.z
    { D with x := x, z9 := some x }
  | 2 => { D with x := fd_r43x6_mul D.x (D.z2.getD 0) }
  | 3 => { D with x := fd_r43x6_mul D.x (D.z9.getD 0) }
  | 4 =>
    let x := fd_r43x6_mul D.x D.m
    { D with x := x, z2e10m1 := some x }
  | 5 => { D with x := fd_r43x6_mul D.x D.m }
  | 6 => { D with x := fd_r43x6_mul D.x D.m }
  | 7 =>
    let x := fd_r43x6_mul D.x (D.z2e10m1.getD 0)
    { D with x := x, z2e50m1 := some x }
  | 8 => { D with x := fd_r43x6_mul D.x D.m }
  | 9 => { D with x := fd_r43x6_mul D.x D.m }
  | 10 => { D with x := fd_r43x6_mul D.x (D.z2e50m1.getD 0) }
  | _ => { D with x := fd_r43x6_mul D.x D.z }

/-- The multiply keeps the stage. -/
theorem DecSt.stageMul_stage (D : DecSt) : D.stageMul.stage = D.stage := by
  unfold DecSt.stageMul
  split <;> rfl

/-- The multiply keeps `rem`. -/
theorem DecSt.stageMul_rem (D : DecSt) : D.stageMul.rem = D.rem := by
  unfold DecSt.stageMul
  split <;> rfl

/-- `decode_stage` before its stores of `x`, `m`, the stage and `rem`: the multiply's named
results only. -/
def DecSt.preStage (D : DecSt) : DecSt :=
  { D.stageMul with x := D.x }

/-- `decode_stage`: the multiply, then the next stage started with its squarings. -/
def DecSt.stageOp (D : DecSt) : DecSt :=
  let D := D.stageMul
  let stage := D.stage + 1
  { D with m := D.x, stage := stage, rem := if stage < 12 then sqrCnt stage else 0 }

/-- `decode_stage`'s stores of `x`, `m` and the stage after its multiply's. -/
theorem DecSt.preStage_stores (D : DecSt) :
    { { { D.preStage with x := D.stageMul.x } with m := D.stageMul.x } with stage := D.stage + 1 } =
      { D.stageOp with rem := D.rem } := by
  have h1 := D.stageMul_stage
  have h2 := D.stageMul_rem
  simp only [DecSt.preStage, DecSt.stageOp]
  revert h1 h2
  generalize D.stageMul = M
  intro h1 h2
  rw [← h1, ← h2]

/-- `k` squarings of the accumulator, counted off `rem`. -/
def DecSt.sqrs (D : DecSt) (k : BitVec 64) : DecSt :=
  { D with x := Avx512.fd_r43x6_repsqr_mul2.sqrN k.toNat D.x, rem := D.rem - k }

/-- `fd_r43x6_ge_decode_step_slow( st, n )`'s loop, at most `f` more times round: squarings up to
the stage's end or `n`, then the stage's multiply if `n` is not used up. -/
def DecSt.stepSlowF : Nat → DecSt → BitVec 64 → DecSt
  | 0, D, _ => D
  | f + 1, D, n =>
    if n ≠ 0 ∧ D.stage < 12 then
      let k := if D.rem.ult n then D.rem else n
      let D := D.sqrs k
      let n := n - k
      if n ≠ 0 ∧ D.rem = 0 then DecSt.stepSlowF f D.stageOp (n - 1) else DecSt.stepSlowF f D n
    else D

/-- `fd_r43x6_ge_decode_step_slow( st, n )`: its loop runs at most `13` times. -/
def DecSt.stepSlow (D : DecSt) (n : BitVec 64) : DecSt :=
  D.stepSlowF 13 n

/-- The named multipliers are set once their stage is past: what the stages read is there. -/
def DecSt.Ok (D : DecSt) : Prop :=
  (1 ≤ D.stage.toNat → D.z2.isSome) ∧ (2 ≤ D.stage.toNat → D.z9.isSome) ∧
    (5 ≤ D.stage.toNat → D.z2e10m1.isSome) ∧ (8 ≤ D.stage.toNat → D.z2e50m1.isSome)

/-- The squarings keep `Ok`. -/
theorem DecSt.Ok.sqrs {D : DecSt} (h : D.Ok) (k : BitVec 64) : (D.sqrs k).Ok :=
  h

/-- A stage's multiply and start keep `Ok`. -/
theorem DecSt.Ok.stageOp {D : DecSt} (h : D.Ok) (hs : D.stage.toNat < 12) : D.stageOp.Ok := by
  obtain ⟨h2, h9, h10, h50⟩ := h
  have e : (D.stage + 1).toNat = D.stage.toNat + 1 := by
    rw [BitVec.toNat_add]
    simp
    omega
  obtain ⟨c, hc⟩ : ∃ c, D.stage.toNat = c := ⟨_, rfl⟩
  have hc12 : c < 12 := hc ▸ hs
  simp only [DecSt.Ok, DecSt.stageOp, DecSt.stageMul, hc]
  interval_cases c <;> simp_all

/-- The loop with nothing to do. -/
theorem DecSt.stepSlowF_zero (f : Nat) (D : DecSt) : D.stepSlowF f 0#64 = D := by
  cases f <;> simp [DecSt.stepSlowF]

/-- The loop ending in the squarings: `n` used up. -/
theorem DecSt.stepSlowF_sqrs {D : DecSt} {n k : BitVec 64} (f : Nat) (hn : n ≠ 0)
    (hs : D.stage < 12) (hk : (if D.rem.ult n then D.rem else n) = k) (h0 : n - k = 0#64) :
    D.stepSlowF (f + 1) n = D.sqrs k := by
  simp only [DecSt.stepSlowF, ne_eq, hn, not_false_eq_true, hs, and_self, ite_true, hk, h0]
  exact DecSt.stepSlowF_zero f _

/-- The loop past a stage's end: its multiply, then round again. -/
theorem DecSt.stepSlowF_stage {D : DecSt} {n k : BitVec 64} (f : Nat) (hn : n ≠ 0)
    (hs : D.stage < 12) (hk : (if D.rem.ult n then D.rem else n) = k) (h1 : n - k ≠ 0)
    (h2 : (D.sqrs k).rem = 0) :
    D.stepSlowF (f + 1) n = (D.sqrs k).stageOp.stepSlowF f (n - k - 1) := by
  have h1' : ¬n - k = 0 := h1
  simp only [DecSt.stepSlowF, ne_eq, hn, not_false_eq_true, hs, and_self, ite_true, hk, h1', h2]

/-- `fd_r43x6_ge_decode_step( st, n )`: `n` squarings if the stage has them left, else
`fd_r43x6_ge_decode_step_slow` unless the chain is done. -/
def DecSt.step (D : DecSt) (n : BitVec 64) : DecSt :=
  if ¬D.rem.ult n then D.sqrs n else if D.stage < 12 then D.stepSlow n else D

/-- No squarings. -/
theorem DecSt.sqrs_zero (D : DecSt) : D.sqrs 0#64 = D := by
  simp [DecSt.sqrs, Avx512.fd_r43x6_repsqr_mul2.sqrN]

/-- The slow step with nothing to do. -/
theorem DecSt.stepSlowF_done {D : DecSt} {n : BitVec 64} (f : Nat)
    (h : ¬(n ≠ 0 ∧ D.stage < 12)) : D.stepSlowF f n = D := by
  cases f with
  | zero => rfl
  | succ f => simp only [DecSt.stepSlowF, h, ite_false]

/-- No squarings left once the stages are done. -/
def DecSt.Fin (D : DecSt) : Prop :=
  12 ≤ D.stage.toNat → D.rem = 0

/-- The inline step is `fd_r43x6_ge_decode_step_slow`'s, for a chain whose end has no squarings
left. -/
theorem DecSt.step_eq_stepSlow {D : DecSt} (h : D.Fin) (n : BitVec 64) :
    D.step n = D.stepSlow n := by
  unfold DecSt.step DecSt.stepSlow
  by_cases hr : D.rem.ult n
  · by_cases hs : D.stage < 12
    · rw [ite_eq_right (not_not.2 hr), ite_eq_left hs]
    · rw [ite_eq_right (not_not.2 hr), ite_eq_right hs]
      exact (DecSt.stepSlowF_done 13 (fun hc => hs hc.2)).symm
  · rw [ite_eq_left hr]
    by_cases hn : n = 0#64
    · subst hn
      rw [DecSt.sqrs_zero, DecSt.stepSlowF_zero]
    by_cases hs : D.stage < 12
    · have hk : (if D.rem.ult n then D.rem else n) = n := by simp [hr]
      exact (DecSt.stepSlowF_sqrs 12 hn hs hk (by simp)).symm
    · have h0 := h (by
        rw [BitVec.lt_def] at hs
        simp at hs
        omega)
      rw [h0] at hr
      exact absurd (BitVec.eq_of_toNat_eq (by simpa [BitVec.ult] using hr)) hn

/-- The slow step keeps `Ok`. -/
theorem DecSt.Ok.stepSlowF : ∀ (f : Nat) {D : DecSt} (n : BitVec 64), D.Ok → (D.stepSlowF f n).Ok
  | 0, _, _, h => h
  | f + 1, D, n, h => by
    by_cases hc : n ≠ 0 ∧ D.stage < 12
    · have hs : D.stage.toNat < 12 := by
        have := BitVec.lt_def.mp hc.2
        simpa using this
      rw [DecSt.stepSlowF, ite_eq_left hc]
      generalize (if D.rem.ult n then D.rem else n) = k
      by_cases hc2 : n - k ≠ 0 ∧ (D.sqrs k).rem = 0
      · rw [ite_eq_left hc2]
        exact DecSt.Ok.stepSlowF f _ ((h.sqrs k).stageOp hs)
      · rw [ite_eq_right hc2]
        exact DecSt.Ok.stepSlowF f _ (h.sqrs k)
    · rw [DecSt.stepSlowF_done _ hc]
      exact h

/-- A stage's multiply and start keep `Fin`. -/
theorem DecSt.Fin.stageOp (D : DecSt) : D.stageOp.Fin := by
  intro h
  simp only [DecSt.stageOp] at h ⊢
  refine ite_eq_right_iff.2 ?_
  intro h'
  have := BitVec.lt_def.mp h'
  have e : (12 : BitVec 64).toNat = 12 := rfl
  omega

/-- The slow step keeps `Fin`. -/
theorem DecSt.Fin.stepSlowF : ∀ (f : Nat) {D : DecSt} (n : BitVec 64), D.Fin → (D.stepSlowF f n).Fin
  | 0, _, _, h => h
  | f + 1, D, n, h => by
    by_cases hc : n ≠ 0 ∧ D.stage < 12
    · have hs : ¬12 ≤ D.stage.toNat := by
        have := BitVec.lt_def.mp hc.2
        simp at this
        omega
      rw [DecSt.stepSlowF, ite_eq_left hc]
      generalize (if D.rem.ult n then D.rem else n) = k
      by_cases hc2 : n - k ≠ 0 ∧ (D.sqrs k).rem = 0
      · rw [ite_eq_left hc2]
        exact DecSt.Fin.stepSlowF f _ (DecSt.Fin.stageOp _)
      · rw [ite_eq_right hc2]
        exact DecSt.Fin.stepSlowF f _ fun h' => absurd h' hs
    · rw [DecSt.stepSlowF_done _ hc]
      exact h

/-- The inline step keeps `Ok`. -/
theorem DecSt.Ok.step {D : DecSt} (h : D.Ok) (n : BitVec 64) : (D.step n).Ok := by
  unfold DecSt.step
  split
  · exact h.sqrs n
  split
  · exact DecSt.Ok.stepSlowF 13 n h
  · exact h

/-- The inline step keeps `Fin`. -/
theorem DecSt.Fin.step {D : DecSt} (h : D.Fin) (n : BitVec 64) : (D.step n).Fin := by
  rw [DecSt.step_eq_stepSlow h]
  exact DecSt.Fin.stepSlowF 13 n h

open Firedancer.Avx512.fd_r43x6_ge_decode2 (decodePt sqrtM1 quadOf zeroQuad vsub) in
/-- `fd_r43x6_ge_decode_fini` on the state `D`: the chain finished, `x = u v³ t0`, the checks of
`v x² ∓ u`; `-1` and zeros if both are nonzero, else `0` and the point `(x, y, 1, x y)`, `x`
times `√-1` unless `v x² = u`, of the sign `x_0`, packed and folded. -/
def DecSt.fini (D : DecSt) : BitVec 32 × Quad :=
  let D := D.stepSlow 18446744073709551615#64
  let x := fd_r43x6_mul D.uv3 D.x
  let vx2 := fd_r43x6_mul D.v (fd_r43x6_sqr x)
  let t1nz := fd_r43x6_is_nonzero.spec (vadd (vsub vx2 D.u) fd_r43x6_p)
  let t2nz := fd_r43x6_is_nonzero.spec (vadd vx2 D.u)
  if t2nz &&& t1nz = 0#32 then
    (0, quadOf (decodePt fd_r43x6_mul_fast.spec fd_r43x6_diagnose.spec sqrtM1 one x D.y t1nz D.x0))
  else (-1, zeroQuad)

/-- Store the QUAD `Q` at `p03 p14 p25`. -/
abbrev _root_.MLIR.MemoryState.storeQuad3 (m : MemoryState) (p03 p14 p25 : Pointer) (Q : Quad) :
    MemoryState :=
  ((m.storeVec p03 Q.P03).storeVec p14 Q.P14).storeVec p25 Q.P25

open Firedancer.Avx512.fd_r43x6_ge_decode2 (dec decodePt sqrtM1 quadOf zeroQuad) in
/-- `fd_r43x6_ge_decode` on the encoding `s`: `fd_r43x6_ge_decode2`'s steps on one point; `-1` and
zeros unless its checks pass, else `0` and the point packed and folded. -/
noncomputable def fd_r43x6_ge_decode.spec (s : BitVec 256) : BitVec 32 × Quad :=
  let A := dec s
  if A.ok then
    (0, quadOf
      (decodePt fd_r43x6_mul_fast.spec fd_r43x6_diagnose.spec sqrtM1 one A.x A.y A.t1nz A.x0))
  else (-1, zeroQuad)

open Firedancer.Avx512.fd_r43x6_ge_decode2 (vsub) in
/-- `v x² - u` as compiled from `u = pre + _b`: `(v x² - pre) + (p - _b)`. -/
theorem vsub_u_p (a pre : Wwl) :
    vadd (vsub a (vadd pre negBias)) fd_r43x6_p = vadd (vsub a pre) negP := by
  have e (x y b q : BitVec 64) : x - (y + b) + q = x - y + (q - b) := by bv_decide
  have c : ∀ j : Fin 8, fd_r43x6_p[j] - negBias[j] = negP[j] := by decide
  apply Vector.ext
  intro i hi
  simp only [vadd, Firedancer.Avx512.fd_r43x6_ge_decode2.vsub, Vector.getElem_ofFn, e]
  congr 1
  exact c ⟨i, hi⟩

section Mem

variable {m : MemoryState} {st : Pointer} {D : DecSt}

/-- Two fields of the state are disjoint. -/
theorem decDisj (h : ¬st.offset.uaddOverflow 724#64) (a b : BitVec 64) (v w : Nat)
    (ha : a.toNat ≤ 724 := by decide) (hb : b.toNat ≤ 724 := by decide)
    (hab : a.toNat * 8 + v ≤ b.toNat * 8 ∨ b.toNat * 8 + w ≤ a.toNat * 8 := by decide) :
    (Range.of (st.add a) v).Disjoint (Range.of (st.add b) w) :=
  Range.disjoint_of_add_le h ha hb hab

/-- `decDisj` with the first field at `st`. -/
theorem decDisj0 (h : ¬st.offset.uaddOverflow 724#64) (b : BitVec 64) (w : Nat)
    (hb : b.toNat ≤ 724 := by decide) (hab : 512 ≤ b.toNat * 8 := by decide) :
    (Range.of st 512).Disjoint (Range.of (st.add b) w) := by
  simpa using decDisj h 0#64 b 512 w (by decide) hb (.inl (by simpa using hab))

/-- A field past a store to another field. -/
theorem readAt_storeAt_dec (h : ¬st.offset.uaddOverflow 724#64) {a b : BitVec 64} {x : BitVec v}
    (hc : a.toNat ≤ 724 ∧ b.toNat ≤ 724 ∧ (a.toNat * 8 + v ≤ b.toNat * 8 ∨ b.toNat * 8 + w ≤
      a.toNat * 8)) :
    (m.storeAt (st.add a) x).readAt (st.add b) w = m.readAt (st.add b) w :=
  MemoryState.readAt_storeAt_disjoint (decDisj h a b v w hc.1 hc.2.1 hc.2.2) x

/-- `readAt_storeAt_dec` for a store at `st`. -/
theorem readAt_storeAt_dec0 (h : ¬st.offset.uaddOverflow 724#64) {b : BitVec 64} {x : BitVec 512}
    (hc : b.toNat ≤ 724 ∧ 512 ≤ b.toNat * 8) :
    (m.storeAt st x).readAt (st.add b) w = m.readAt (st.add b) w :=
  MemoryState.readAt_storeAt_disjoint (decDisj0 h b w hc.1 hc.2) x

/-- `readAt_storeAt_dec` for a read at `st`. -/
theorem readAt_storeAt_dec0' (h : ¬st.offset.uaddOverflow 724#64) {a : BitVec 64} {x : BitVec v}
    (hc : a.toNat ≤ 724 ∧ 512 ≤ a.toNat * 8) :
    (m.storeAt (st.add a) x).readAt st 512 = m.readAt st 512 :=
  MemoryState.readAt_storeAt_disjoint (decDisj0 h a v hc.1 hc.2).symm x

/-- A field past a `storeOpt` to another field. -/
theorem readAt_storeOpt_dec (h : ¬st.offset.uaddOverflow 724#64) {a b : BitVec 64}
    {o : Option Wwl} (hc : a.toNat ≤ 724 ∧ b.toNat ≤ 724 ∧ (a.toNat * 8 + 512 ≤ b.toNat * 8 ∨
      b.toNat * 8 + w ≤ a.toNat * 8)) :
    (m.storeOpt (st.add a) o).readAt (st.add b) w = m.readAt (st.add b) w := by
  cases o
  · rfl
  · exact readAt_storeAt_dec h hc

/-- `readAt_storeOpt_dec` for a read at `st`. -/
theorem readAt_storeOpt_dec0' (h : ¬st.offset.uaddOverflow 724#64) {a : BitVec 64}
    {o : Option Wwl} (hc : a.toNat ≤ 724 ∧ 512 ≤ a.toNat * 8) :
    (m.storeOpt (st.add a) o).readAt st 512 = m.readAt st 512 := by
  cases o
  · rfl
  · exact readAt_storeAt_dec0' h hc

@[simp]
theorem Fits.storeOpt {p q : Pointer} {o : Option Wwl} (hf : Fits m p w) :
    Fits (m.storeOpt q o) p w := by
  cases o
  · exact hf
  · exact hf.storeAt

@[simp]
theorem Room.storeOpt_iff {p q : Pointer} {o : Option Wwl} :
    Room (m.storeOpt q o) p w ↔ Room m p w := by
  cases o
  · rfl
  · exact Room.storeAt_iff

/-- A field of the state has room. -/
theorem decRoom_room (h : m.DecRoom st) (a : BitVec 64) (w : Nat)
    (hc : a.toNat * 8 + w ≤ 5792 := by decide) : Room m (st.add a) w :=
  h.2.add_of_le (BitVec.not_uaddOverflow_of_le h.1 (by
    have : (724#64).toNat = 724 := rfl
    omega)) hc

/-- Stores to two fields commute: the one at the lower offset moves inward. -/
theorem storeAt_comm_dec (h : ¬st.offset.uaddOverflow 724#64) {a b : BitVec 64} {x : BitVec v}
    {y : BitVec w}
    (hc : b.toNat < a.toNat ∧ a.toNat ≤ 724 ∧ b.toNat * 8 + w ≤ a.toNat * 8) :
    (m.storeAt (st.add a) x).storeAt (st.add b) y = (m.storeAt (st.add b) y).storeAt (st.add a) x :=
  MemoryState.storeAt_comm (decDisj h a b v w hc.2.1 (by omega) (.inr hc.2.2))

/-- `storeAt_comm_dec` for a store at `st`, which moves inward past any other field. -/
theorem storeAt_comm_dec0 (h : ¬st.offset.uaddOverflow 724#64) {a : BitVec 64} {x : BitVec v}
    {y : BitVec 512} (hc : a.toNat ≤ 724 ∧ 512 ≤ a.toNat * 8) :
    (m.storeAt (st.add a) x).storeAt st y = (m.storeAt st y).storeAt (st.add a) x :=
  MemoryState.storeAt_comm (decDisj0 h a v hc.1 hc.2).symm

/-- The state stored where there is room reads back. -/
theorem MemoryState.DecHolds.storeDec (h : m.DecRoom st) : (m.storeDec st D).DecHolds st D := by
  rcases D with ⟨x, mm, z, z2, z9, z10, z50, y, u, v, uv3, sg, rem, x0⟩
  cases z2 <;> cases z9 <;> cases z10 <;> cases z50 <;>
    simp only [MemoryState.DecHolds, MemoryState.OptHolds, MemoryState.storeDec,
      MemoryState.storeOpt, MemoryState.storeVec, true_and] <;>
    repeat' apply And.intro
  all_goals first | dec_read h | dec_fits h

/-- A store past an unset-or-stored field at a higher offset commutes with it. -/
theorem storeOpt_comm_dec (h : ¬st.offset.uaddOverflow 724#64) {a b : BitVec 64} {o : Option Wwl}
    {y : BitVec w} (hc : b.toNat < a.toNat ∧ a.toNat ≤ 724 ∧ b.toNat * 8 + w ≤ a.toNat * 8) :
    (m.storeOpt (st.add a) o).storeAt (st.add b) y =
      (m.storeAt (st.add b) y).storeOpt (st.add a) o := by
  cases o
  · rfl
  · exact storeAt_comm_dec h hc

/-- `storeOpt_comm_dec` for a store at `st`. -/
theorem storeOpt_comm_dec0 (h : ¬st.offset.uaddOverflow 724#64) {a : BitVec 64} {o : Option Wwl}
    {y : BitVec 512} (hc : a.toNat ≤ 724 ∧ 512 ≤ a.toNat * 8) :
    (m.storeOpt (st.add a) o).storeAt st y = (m.storeAt st y).storeOpt (st.add a) o := by
  cases o
  · rfl
  · exact storeAt_comm_dec0 h hc

/-- A store over an unset-or-stored field sets it. -/
theorem storeOpt_storeAt_self {p : Pointer} {o : Option Wwl} (v : Wwl) :
    (m.storeOpt p o).storeAt p (BitVec.packLanes v) = m.storeOpt p (some v) := by
  cases o
  · rfl
  · exact MemoryState.storeAt_storeAt_self

/-- Storing what a range holds changes nothing. -/
theorem storeAt_self_of {p : Pointer} {x : BitVec w} (hf : Fits m p w) (hr : m.readAt p w = x) :
    m.storeAt p x = m := by
  rw [← hr, MemoryState.storeAt_readAt_self hf]

/-- `storeAt_self_of` for a field that may be unset. -/
theorem storeOpt_self_of {p : Pointer} {o : Option Wwl} (h : m.OptHolds p o) :
    m.storeOpt p o = m := by
  cases o
  · rfl
  · exact storeAt_self_of h.1 h.2

/-- Storing the state the memory holds changes nothing. -/
theorem MemoryState.storeDec_self (h : m.DecHolds st D) : m.storeDec st D = m := by
  obtain ⟨⟨f1, r1⟩, ⟨f2, r2⟩, ⟨f3, r3⟩, o2, o9, o10, o50, ⟨f4, r4⟩, ⟨f5, r5⟩, ⟨f6, r6⟩, ⟨f7, r7⟩,
    ⟨f8, r8⟩, ⟨f9, r9⟩, ⟨f10, r10⟩⟩ := h
  simp only [MemoryState.storeDec, MemoryState.storeVec]
  rw [storeAt_self_of f1 r1, storeAt_self_of f2 r2, storeAt_self_of f3 r3, storeOpt_self_of o2,
    storeOpt_self_of o9, storeOpt_self_of o10, storeOpt_self_of o50, storeAt_self_of f4 r4,
    storeAt_self_of f5 r5, storeAt_self_of f6 r6, storeAt_self_of f7 r7, storeAt_self_of f8 r8,
    storeAt_self_of f9 r9, storeAt_self_of f10 r10]

-- unfolding it makes the normalizer's matches `st.add a =?= st` time out
attribute [local irreducible] Pointer.add

/-- A store to `x` over the state. -/
theorem MemoryState.storeDec_storeAt_x (h : ¬st.offset.uaddOverflow 724#64) (v : Wwl) :
    (m.storeDec st D).storeAt st (BitVec.packLanes v) = m.storeDec st { D with x := v } := by
  dec_norm h

/-- A store to `m` over the state. -/
theorem MemoryState.storeDec_storeAt_m (h : ¬st.offset.uaddOverflow 724#64) (v : Wwl) :
    (m.storeDec st D).storeAt (st.add 64#64) (BitVec.packLanes v) =
      m.storeDec st { D with m := v } := by
  dec_norm h

/-- A store to `z2` over the state. -/
theorem MemoryState.storeDec_storeAt_z2 (h : ¬st.offset.uaddOverflow 724#64) (v : Wwl) :
    (m.storeDec st D).storeAt (st.add 192#64) (BitVec.packLanes v) =
      m.storeDec st { D with z2 := some v } := by
  dec_norm h

/-- A store to `z9` over the state. -/
theorem MemoryState.storeDec_storeAt_z9 (h : ¬st.offset.uaddOverflow 724#64) (v : Wwl) :
    (m.storeDec st D).storeAt (st.add 256#64) (BitVec.packLanes v) =
      m.storeDec st { D with z9 := some v } := by
  dec_norm h

/-- A store to `z2e10m1` over the state. -/
theorem MemoryState.storeDec_storeAt_z2e10m1 (h : ¬st.offset.uaddOverflow 724#64) (v : Wwl) :
    (m.storeDec st D).storeAt (st.add 320#64) (BitVec.packLanes v) =
      m.storeDec st { D with z2e10m1 := some v } := by
  dec_norm h

/-- A store to `z2e50m1` over the state. -/
theorem MemoryState.storeDec_storeAt_z2e50m1 (h : ¬st.offset.uaddOverflow 724#64) (v : Wwl) :
    (m.storeDec st D).storeAt (st.add 384#64) (BitVec.packLanes v) =
      m.storeDec st { D with z2e50m1 := some v } := by
  dec_norm h

/-- A store to `stage` over the state. -/
theorem MemoryState.storeDec_storeAt_stage (h : ¬st.offset.uaddOverflow 724#64) (v : BitVec 64) :
    (m.storeDec st D).storeAt (st.add 704#64) (v) =
      m.storeDec st { D with stage := v } := by
  dec_norm h

/-- A store to `rem` over the state. -/
theorem MemoryState.storeDec_storeAt_rem (h : ¬st.offset.uaddOverflow 724#64) (v : BitVec 64) :
    (m.storeDec st D).storeAt (st.add 712#64) (v) =
      m.storeDec st { D with rem := v } := by
  dec_norm h

/-- `fd_r43x6_ge_decode_init`'s stores, in its order: the state with the multipliers unset. -/
theorem MemoryState.storeDec_initOrder (h : ¬st.offset.uaddOverflow 724#64) (x0 : BitVec 32)
    (y u v uv3 uv7 : Wwl) :
    (((((((((m.storeAt (st.add 720#64) x0).storeAt (st.add 448#64) (BitVec.packLanes y)).storeAt
                                  (st.add 512#64) (BitVec.packLanes u)).storeAt
                              (st.add 576#64) (BitVec.packLanes v)).storeAt
                          (st.add 640#64) (BitVec.packLanes uv3)).storeAt
                      (st.add 128#64) (BitVec.packLanes uv7)).storeAt
                  st (BitVec.packLanes uv7)).storeAt
              (st.add 64#64) (BitVec.packLanes uv7)).storeAt
          (st.add 704#64) 0#64).storeAt
        (st.add 712#64) 1#64 =
      m.storeDec st ⟨uv7, uv7, uv7, none, none, none, none, y, u, v, uv3, 0, 1, x0⟩ := by
  dec_norm h
  rfl

/-- `storeOpt` keeps the set of blocks, so `WF` does not depend on it. -/
@[simp, mlir_mem]
theorem GlobalState.WF_storeOpt {s : GlobalState} {p : Pointer} {o : Option Wwl} :
    ({ s with mem := m.storeOpt p o } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF := by
  cases o
  · rfl
  · exact GlobalState.WF_storeAt

/-- `storeDec` keeps the set of blocks, so `WF` does not depend on it. -/
@[simp, mlir_mem]
theorem GlobalState.WF_storeDec {s : GlobalState} :
    ({ s with mem := m.storeDec st D } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF := by
  simp only [MemoryState.storeDec, MemoryState.storeVec, GlobalState.WF_storeOpt (m := _),
    GlobalState.WF_storeAt]

/-- `storeDec` keeps the set of blocks, so the state stays `WF`. -/
@[mlir_transport]
theorem GlobalState.WF.storeDec {s : GlobalState} (h : s.WF) :
    ({ s with mem := s.mem.storeDec st D } : GlobalState).WF :=
  GlobalState.WF_storeDec.2 h

/-- `storeOpt` keeps every block, its length and lifetime. -/
@[simp, mlir_state]
theorem Room.storeOpt_iff' {p q : Pointer} {o : Option Wwl} :
    Room (m.storeOpt q o) p w ↔ Room m p w :=
  Room.storeOpt_iff

/-- `storeDec` keeps every block, its length and lifetime. -/
@[simp, mlir_state]
theorem Room.storeDec_iff {p : Pointer} : Room (m.storeDec st D) p w ↔ Room m p w := by
  simp only [MemoryState.storeDec, MemoryState.storeVec, Room.storeAt_iff, Room.storeOpt_iff]

/-- `storeDec` keeps every block and its length. -/
@[simp, mlir_state]
theorem InBounds.storeDec_iff {p : Pointer} : InBounds (m.storeDec st D) p w ↔ InBounds m p w := by
  rcases D with ⟨x, mm, z, z2, z9, z10, z50, y, u, v, uv3, sg, rem, x0⟩
  cases z2 <;> cases z9 <;> cases z10 <;> cases z50 <;>
    simp only [MemoryState.storeDec, MemoryState.storeOpt, MemoryState.storeVec,
      InBounds.storeAt_iff]

/-- `storeDec` keeps known bits known. -/
@[mlir_mem, mlir_transport]
theorem Fits.storeDec {p : Pointer} (h : Fits m p w) : Fits (m.storeDec st D) p w := by
  simp only [MemoryState.storeDec, MemoryState.storeVec]
  repeat (first | apply Fits.storeAt | apply Fits.storeOpt)
  exact h

/-- A read of another block is unaffected by `storeDec`. -/
@[mlir_read]
theorem MemoryState.readAt_storeDec_of_id_ne {q : Pointer} (h : st.id ≠ q.id) :
    (m.storeDec st D).readAt q w = m.readAt q w := by
  have d (o : BitVec 64) (v : Nat) : (Range.of (st.add o) v).Disjoint (Range.of q w) := by
    simp [Range.Disjoint, Range.of, Pointer.add, h]
  have d0 (v : Nat) : (Range.of st v).Disjoint (Range.of q w) := by
    simp [Range.Disjoint, Range.of, h]
  have dO (o : BitVec 64) (x : Option Wwl) (m' : MemoryState) :
      (m'.storeOpt (st.add o) x).readAt q w = m'.readAt q w := by
    cases x
    · rfl
    · exact MemoryState.readAt_storeAt_disjoint (d o 512) _
  simp only [MemoryState.storeDec, MemoryState.storeVec, dO,
    MemoryState.readAt_storeAt_disjoint (d _ _), MemoryState.readAt_storeAt_disjoint (d0 _)]

/-- `storeDec` keeps every block, its length and lifetime. -/
@[mlir_mem, mlir_transport]
theorem Room.storeDec {p : Pointer} (h : Room m p w) : Room (m.storeDec st D) p w :=
  Room.storeDec_iff.2 h

/-- `storeDec` keeps every block and its length. -/
@[mlir_mem, mlir_transport]
theorem InBounds.storeDec {p : Pointer} (h : InBounds m p w) : InBounds (m.storeDec st D) p w :=
  InBounds.storeDec_iff.2 h

/-- `storeDec` keeps every block writable that was. -/
@[mlir_mem, mlir_transport]
theorem Writable.storeDec {p : Pointer} (h : Writable m p) : Writable (m.storeDec st D) p := by
  rcases D with ⟨x, mm, z, z2, z9, z10, z50, y, u, v, uv3, sg, rem, x0⟩
  cases z2 <;> cases z9 <;> cases z10 <;> cases z50 <;>
    simp only [MemoryState.storeDec, MemoryState.storeOpt, MemoryState.storeVec] <;>
    repeat (first | apply Writable.storeAt | exact h)

/-- `storeDec` keeps a point's room. -/
@[mlir_mem, mlir_transport]
theorem MemoryState.QuadRoom.storeDec {p : Pointer} (h : m.QuadRoom p) :
    (m.storeDec st D).QuadRoom p :=
  ⟨h.1, Room.storeDec h.2.1, Room.storeDec h.2.2.1, Room.storeDec h.2.2.2⟩

/-- A vector store keeps every block writable that was. -/
@[mlir_mem, mlir_transport]
theorem writable_storeVec {m : MemoryState} {p q : Pointer} {v : Wwl} (h : Writable m p) :
    Writable (m.storeVec q v) p :=
  Writable.storeAt h

/-- Erasing a frame commutes with `storeDec`. -/
@[mlir_frame, mlir_erase]
theorem MemoryState.eraseFrom_storeDec :
    (m.storeDec st D).eraseFrom n = (m.eraseFrom n).storeDec st D := by
  rcases D with ⟨x, mm, z, z2, z9, z10, z50, y, u, v, uv3, sg, rem, x0⟩
  cases z2 <;> cases z9 <;> cases z10 <;> cases z50 <;>
    simp only [MemoryState.storeDec, MemoryState.storeOpt, MemoryState.storeVec,
      MemoryState.eraseFrom_storeAt]

/-- `storeDec` keeps the state's room. -/
@[mlir_transport]
theorem MemoryState.DecRoom.storeDec {p : Pointer} (h : m.DecRoom p) :
    (m.storeDec st D).DecRoom p :=
  ⟨h.1, Room.storeDec_iff.2 h.2⟩

/-- `storeDec` keeps the globals' table. -/
theorem MemoryState.globals_storeDec : (m.storeDec st D).globals = m.globals := by
  rcases D with ⟨x, mm, z, z2, z9, z10, z50, y, u, v, uv3, sg, rem, x0⟩
  cases z2 <;> cases z9 <;> cases z10 <;> cases z50 <;> rfl

/-- `storeDec` keeps the globals. -/
@[mlir_transport]
theorem MemoryState.Globals.storeDec {G : List Global} (h : m.Globals G) :
    (m.storeDec st D).Globals G :=
  h.mono MemoryState.globals_storeDec fun _ h => h

/-- An `alloca` keeps the globals. -/
@[mlir_transport]
theorem MemoryState.Globals.alloca {s : GlobalState} {G : List Global} (h : s.mem.Globals G) :
    (s.alloca n d).mem.Globals G :=
  h.mono rfl fun _ h => h

/-- An `alloca` keeps the room at `st`. -/
@[mlir_transport]
theorem MemoryState.DecRoom.alloca {s : GlobalState} (hwf : s.WF) (h : s.mem.DecRoom st) :
    (s.alloca n d).mem.DecRoom st :=
  ⟨h.1, h.2.alloca hwf⟩

/-- An `alloca` keeps a stored-or-unset field. -/
theorem MemoryState.OptHolds.alloca {s : GlobalState} (hwf : s.WF) {o : Option Wwl}
    (h : s.mem.OptHolds p o) : (s.alloca n d).mem.OptHolds p o := by
  cases o with
  | none => trivial
  | some v => exact ⟨h.1.alloca hwf, (MemoryState.readAt_alloca hwf h.1.inBounds).trans h.2⟩

/-- An `alloca` keeps the state at `st`. -/
@[mlir_transport]
theorem MemoryState.DecHolds.alloca {s : GlobalState} (hwf : s.WF) (h : s.mem.DecHolds st D) :
    (s.alloca n d).mem.DecHolds st D := by
  obtain ⟨⟨f1, r1⟩, ⟨f2, r2⟩, ⟨f3, r3⟩, o2, o9, o10, o50, ⟨f4, r4⟩, ⟨f5, r5⟩, ⟨f6, r6⟩, ⟨f7, r7⟩,
    ⟨f8, r8⟩, ⟨f9, r9⟩, ⟨f10, r10⟩⟩ := h
  refine ⟨⟨f1.alloca hwf, ?_⟩, ⟨f2.alloca hwf, ?_⟩, ⟨f3.alloca hwf, ?_⟩,
    MemoryState.OptHolds.alloca hwf o2, MemoryState.OptHolds.alloca hwf o9,
    MemoryState.OptHolds.alloca hwf o10, MemoryState.OptHolds.alloca hwf o50,
    ⟨f4.alloca hwf, ?_⟩, ⟨f5.alloca hwf, ?_⟩,
    ⟨f6.alloca hwf, ?_⟩, ⟨f7.alloca hwf, ?_⟩, ⟨f8.alloca hwf, ?_⟩, ⟨f9.alloca hwf, ?_⟩,
    ⟨f10.alloca hwf, ?_⟩⟩
  all_goals rw [MemoryState.readAt_alloca hwf (by assumption : Fits _ _ _).inBounds]
  all_goals assumption

/-- A lifetime marker on another block keeps the room at `st`. -/
@[mlir_transport]
theorem MemoryState.DecRoom.lifetimeStart (h : m.DecRoom st) (hne : st.id ≠ q.id) :
    (m.lifetimeStart q).DecRoom st :=
  ⟨h.1, h.2.lifetimeStart hne⟩

/-- A lifetime marker on another block keeps a stored-or-unset field. -/
theorem MemoryState.OptHolds.lifetimeStart {o : Option Wwl} (h : m.OptHolds p o)
    (hne : p.id ≠ q.id) : (m.lifetimeStart q).OptHolds p o := by
  cases o with
  | none => trivial
  | some v => exact ⟨h.1.lifetimeStart hne, MemoryState.readAt_lifetimeStart.trans h.2⟩

/-- A lifetime marker on another block keeps the state at `st`. -/
@[mlir_transport]
theorem MemoryState.DecHolds.lifetimeStart (h : m.DecHolds st D) (hne : st.id ≠ q.id) :
    (m.lifetimeStart q).DecHolds st D := by
  have e : ∀ k, (st.add k).id ≠ q.id := fun k => (Pointer.add_id st k).trans_ne hne
  obtain ⟨⟨f1, r1⟩, ⟨f2, r2⟩, ⟨f3, r3⟩, o2, o9, o10, o50, ⟨f4, r4⟩, ⟨f5, r5⟩, ⟨f6, r6⟩, ⟨f7, r7⟩,
    ⟨f8, r8⟩, ⟨f9, r9⟩, ⟨f10, r10⟩⟩ := h
  refine ⟨⟨f1.lifetimeStart hne, ?_⟩, ⟨f2.lifetimeStart (e _), ?_⟩, ⟨f3.lifetimeStart (e _), ?_⟩,
    MemoryState.OptHolds.lifetimeStart o2 (e _), MemoryState.OptHolds.lifetimeStart o9 (e _),
    MemoryState.OptHolds.lifetimeStart o10 (e _), MemoryState.OptHolds.lifetimeStart o50 (e _),
    ⟨f4.lifetimeStart (e _), ?_⟩, ⟨f5.lifetimeStart (e _), ?_⟩, ⟨f6.lifetimeStart (e _), ?_⟩,
    ⟨f7.lifetimeStart (e _), ?_⟩, ⟨f8.lifetimeStart (e _), ?_⟩, ⟨f9.lifetimeStart (e _), ?_⟩,
    ⟨f10.lifetimeStart (e _), ?_⟩⟩
  all_goals rw [MemoryState.readAt_lifetimeStart]
  all_goals assumption

/-- `storeQuad3` keeps the set of blocks, so `WF` does not depend on it. -/
@[simp, mlir_mem]
theorem GlobalState.WF_storeQuad3 {s : GlobalState} {p03 p14 p25 : Pointer} {Q : Quad} :
    ({ s with mem := m.storeQuad3 p03 p14 p25 Q } : GlobalState).WF ↔
      ({ s with mem := m } : GlobalState).WF := by
  simp only [MemoryState.storeQuad3, MemoryState.storeVec, GlobalState.WF_storeAt]

end Mem

end

end MLIR.Firedancer.Lane
