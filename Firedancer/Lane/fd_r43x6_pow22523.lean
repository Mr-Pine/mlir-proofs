module

public import Firedancer.Avx512.fd_r43x6_pow22523_2
public import Firedancer.Lane.Common.R43x6
public import Firedancer.Lane.Mlir.fd_r43x6_pow22523
public import MLIR.Run.Tactic

/-! `fd_r43x6_pow22523` as the lane build compiles it: every `fd_r43x6_repsqr_mul` inlined, the
squarings of counts `10` and up as loops of two squarings per iteration. -/

namespace MLIR.Firedancer.Lane.fd_r43x6_pow22523

open Firedancer.Avx512

/-- The lift's registers' context. -/
local notation "Γ" => _root_.Firedancer.Lane.Mlir.fd_r43x6_pow22523.Γ

/-- The lift's run from a block. -/
local notation "runP" => _root_.Firedancer.Lane.Mlir.fd_r43x6_pow22523.runFrom

/-- Register `k`, its type from the lift's proof (deciding it would unfold `Γ`). -/
local macro "%%" k:num : term => `(rir_reg% _root_.Firedancer.Lane.Mlir.fd_r43x6_pow22523.hty $k)

@[expose] public section

/-- `n` pairs of squarings after one: `x` squared `2 n + 2` times. -/
def sqrN2 : Nat → Wwl → Wwl
  | 0, x => fd_r43x6_sqr (fd_r43x6_sqr x)
  | n + 1, x => sqrN2 n (fd_r43x6_sqr (fd_r43x6_sqr x))

/-- `sqrN2` is `fd_r43x6_repsqr_mul2.sqrN`. -/
theorem sqrN2_eq : ∀ n x, sqrN2 n x = Avx512.fd_r43x6_repsqr_mul2.sqrN (2 * n + 2) x
  | 0, _ => rfl
  | n + 1, x => by
    rw [sqrN2, sqrN2_eq n]
    show _ = Avx512.fd_r43x6_repsqr_mul2.sqrN (2 * n + 2 + 2) x
    rfl

/-- The counter's `k - 2` (`add nsw k, -2`) does not overflow. -/
theorem sub2_nsw (n : Nat) (h : 2 * n + 2 < 2 ^ 63) :
    ¬(BitVec.ofNat 64 (2 * n + 2)).saddOverflow 18446744073709551614#64 := by
  have hx : (BitVec.ofNat 64 (2 * n + 2)).toInt = ↑(2 * n + 2) := by
    rw [BitVec.toInt_eq_toNat_of_lt] <;> simp [BitVec.toNat_ofNat] <;> omega
  have hm : (18446744073709551614#64).toInt = -2 := by decide
  simp only [BitVec.saddOverflow, hx, hm]
  simp
  omega

/-- The counter's `k - 2`. -/
theorem sub2_eq (n : Nat) :
    BitVec.ofNat 64 (2 * n + 2) + 18446744073709551614#64 = BitVec.ofNat 64 (2 * n) := by
  apply BitVec.eq_of_toNat_eq
  rw [show (18446744073709551614#64) = -2#64 from rfl, BitVec.toNat_add, BitVec.toNat_ofNat,
    BitVec.toNat_ofNat, BitVec.toNat_neg, BitVec.toNat_ofNat]
  omega

/-- The counter after a pair that is not the last is nonzero. -/
theorem sub2_ne (n : Nat) (h : 2 * (n + 1) + 2 < 2 ^ 63) :
    BitVec.ofNat 64 (2 * (n + 1)) ≠ 0#64 := by
  intro h0
  have := congrArg BitVec.toNat h0
  rw [BitVec.toNat_ofNat] at this
  simp at this
  omega

set_option hygiene false in
/-- A squaring loop's proof, by induction on the pairs left: two squarings, count, test. -/
local macro "loop_proof" : tactic =>
  `(tactic|
    ( intro n
      induction n with
      | zero =>
        intro x E hA hC hn hR hK
        dsimp only [Consts] at hC
        casesm* _ ∧ _
        block_init
        step_pattern using runBodyFrom_r43SqrRun with x1
        step_pattern using runBodyFrom_r43SqrRun with x2
        step_pure [sub2_nsw 0 hn, sub2_eq 0]
        step_pure
        finish_block
        step_loop using hK
        rfl
      | succ n ih =>
        intro x E hA hC hn hR hK
        dsimp only [Consts] at hC
        casesm* _ ∧ _
        block_init
        step_pattern using runBodyFrom_r43SqrRun with x1
        step_pattern using runBodyFrom_r43SqrRun with x2
        step_pure [sub2_nsw (n + 1) hn, sub2_eq (n + 1)]
        step_pure
        finish_block
        · exact absurd hbr (sub2_ne n hn)
        · step_loop using ih x2
          intro hC' hR'
          rw [hx2, hx1] at hR'
          rw [hS]
          exact hK _ hArgs₀ hC' hR'))

set_option hygiene false in
/-- A block between loops: the product, then into the next loop. -/
local macro "mid_proof" : tactic =>
  `(tactic|
    ( dsimp only [Consts] at hC
      casesm* _ ∧ _
      block_init
      step_pattern using runBodyFrom_mulRun with u
      finish_block
      step_loop using hK
      all_goals first | assumption | rfl))

/-- The entry block's constants the other blocks read: the squarings', the products', the fold's,
and the counters' starts, `-2` and `0`. -/
abbrev Consts (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := .value 100#64, %1 := .value 50#64, %2 := .value 20#64, %4 := .value 10#64, %3 :=
    .value 18446744073709551614#64, %%5 := Ty.wrap foldK, %%6 := Ty.wrap foldShifts, %%7 :=
    Ty.wrap foldMask, %%8 := Ty.wrap (Vector.replicate 8 24), %%9 :=
    Ty.wrap (Vector.replicate 8 7), %%10 := Ty.wrap #v[-1, -1, -1, -1, -1, -1, 0, 0], %%19 :=
    Ty.wrap sqrDbl0, %%20 := Ty.wrap sqrDbl2, %%21 := Ty.wrap sqrDbl4, %%22 := .value 0#64,
    %%23 := Ty.wrap (Vector.replicate 8 0), %%24 := Ty.wrap (Vector.replicate 8 9), %%25 :=
    Ty.wrap sqrMaskN1, %%26 := Ty.wrap sqrMaskN2, %%38 := lanesBelow 6 sqrMask1, %%46 :=
    lanesBelow 6 sqrMask2, %%54 := lanesBelow 5 sqrMask1, %%62 := lanesBelow 5 sqrMask2, %%70 :=
    lanesFrom 7 wwl_zero, %%78 := lanesBelow 5 wwl_zero, %%86 := lanesFrom 6 wwl_zero, %%94 :=
    lanesFrom 5 wwl_zero, %%102 := lanesBelow 3 wwl_zero, %%110 := lanesFrom 4 wwl_zero, %%118 :=
    lanesBelow 2 wwl_zero, %%126 := lanesFrom 3 wwl_zero, %%134 := lanesBelow 1 wwl_zero, %%142 :=
    lanesFrom 2 wwl_zero]

/-- The arguments. -/
abbrev argsOf (z : Wwl) : Vals (Ctx.args Γ) :=
  _root_.Firedancer.Lane.Mlir.fd_r43x6_pow22523.args (Ty.wrap z)

variable (z : Wwl) (S : GlobalState) (K : PoisonOr (Vals [V] × GlobalState))

/-- `^bb1`: `n + 1` pairs of squarings of `x`, then `^bb2` with the result in `%869`. -/
theorem loop1 (w : Wwl) :
    ∀ n (x : Wwl) (E : ⟪Γ⟫), E.args = (argsOf z).get → Consts E → 2 * n + 2 < 2 ^ 63 →
      E ⊨ [%%773 := w, %%774 := x, %%775 := .value (BitVec.ofNat 64 (2 * n + 2))] →
      (∀ E' : ⟪Γ⟫, E'.args = (argsOf z).get → Consts E' → E' ⊨ [%%773 := w, %%869 := sqrN2 n x] →
        runP E' 2 S = K) →
      runP E 1 S = K := by
  loop_proof

/-- `^bb3`: `n + 1` pairs of squarings of `x`, then `^bb4` with the result in `%1019`. -/
theorem loop3 (w u : Wwl) :
    ∀ n (x : Wwl) (E : ⟪Γ⟫), E.args = (argsOf z).get → Consts E → 2 * n + 2 < 2 ^ 63 →
      E ⊨ [%%773 := w, %%923 := u, %%924 := x, %%925 := .value (BitVec.ofNat 64 (2 * n + 2))] →
      (∀ E' : ⟪Γ⟫, E'.args = (argsOf z).get → Consts E' →
        E' ⊨ [%%773 := w, %%923 := u, %%1019 := sqrN2 n x] → runP E' 4 S = K) →
      runP E 3 S = K := by
  loop_proof

/-- `^bb5`: `n + 1` pairs of squarings of `x`, then `^bb6` with the result in `%1169`. -/
theorem loop5 (w : Wwl) :
    ∀ n (x : Wwl) (E : ⟪Γ⟫), E.args = (argsOf z).get → Consts E → 2 * n + 2 < 2 ^ 63 →
      E ⊨ [%%773 := w, %%1074 := x, %%1075 := .value (BitVec.ofNat 64 (2 * n + 2))] →
      (∀ E' : ⟪Γ⟫, E'.args = (argsOf z).get → Consts E' → E' ⊨ [%%773 := w, %%1169 := sqrN2 n x] →
        runP E' 6 S = K) →
      runP E 5 S = K := by
  loop_proof

/-- `^bb7`: `n + 1` pairs of squarings of `x`, then `^bb8` with the result in `%1319`. -/
theorem loop7 (w : Wwl) :
    ∀ n (x : Wwl) (E : ⟪Γ⟫), E.args = (argsOf z).get → Consts E → 2 * n + 2 < 2 ^ 63 →
      E ⊨ [%%1223 := w, %%1224 := x, %%1225 := .value (BitVec.ofNat 64 (2 * n + 2))] →
      (∀ E' : ⟪Γ⟫, E'.args = (argsOf z).get → Consts E' → E' ⊨ [%%1223 := w, %%1319 := sqrN2 n x] →
        runP E' 8 S = K) →
      runP E 7 S = K := by
  loop_proof

/-- `^bb9`: `n + 1` pairs of squarings of `x`, then `^bb10` with the result in `%1469`. -/
theorem loop9 (w u : Wwl) :
    ∀ n (x : Wwl) (E : ⟪Γ⟫), E.args = (argsOf z).get → Consts E → 2 * n + 2 < 2 ^ 63 →
      E ⊨ [%%1223 := w, %%1373 := u, %%1374 := x, %%1375 :=
        .value (BitVec.ofNat 64 (2 * n + 2))] →
      (∀ E' : ⟪Γ⟫, E'.args = (argsOf z).get → Consts E' →
        E' ⊨ [%%1223 := w, %%1373 := u, %%1469 := sqrN2 n x] → runP E' 10 S = K) →
      runP E 9 S = K := by
  loop_proof

/-- `^bb11`: `n + 1` pairs of squarings of `x`, then `^bb12` with the result in `%1619`. -/
theorem loop11 (w : Wwl) :
    ∀ n (x : Wwl) (E : ⟪Γ⟫), E.args = (argsOf z).get → Consts E → 2 * n + 2 < 2 ^ 63 →
      E ⊨ [%%1223 := w, %%1524 := x, %%1525 := .value (BitVec.ofNat 64 (2 * n + 2))] →
      (∀ E' : ⟪Γ⟫, E'.args = (argsOf z).get → Consts E' → E' ⊨ [%%1223 := w, %%1619 := sqrN2 n x] →
        runP E' 12 S = K) →
      runP E 11 S = K := by
  loop_proof

/-- `^bb2`: `z2e20m1 = x z2e10m1`, into `^bb3`. -/
theorem bb2 (w x : Wwl) (E : ⟪Γ⟫) (hA : E.args = (argsOf z).get) (hC : Consts E)
    (hR : E ⊨ [%%773 := w, %%869 := x])
    (hK :
      ∀ E' : ⟪Γ⟫, E'.args = (argsOf z).get → Consts E' →
        E' ⊨ [%%773 := w, %%923 := fd_r43x6_mul x w, %%924 := fd_r43x6_mul x w, %%925 :=
          .value (BitVec.ofNat 64 (2 * 9 + 2))] →
        runP E' 3 S = K) :
    runP E 2 S = K := by
  mid_proof

/-- `^bb4`: `z2e40m1 = x z2e20m1`, into `^bb5`. -/
theorem bb4 (w u x : Wwl) (E : ⟪Γ⟫) (hA : E.args = (argsOf z).get) (hC : Consts E)
    (hR : E ⊨ [%%773 := w, %%923 := u, %%1019 := x])
    (hK :
      ∀ E' : ⟪Γ⟫, E'.args = (argsOf z).get → Consts E' →
        E' ⊨ [%%773 := w, %%1074 := fd_r43x6_mul x u, %%1075 :=
          .value (BitVec.ofNat 64 (2 * 4 + 2))] →
        runP E' 5 S = K) :
    runP E 4 S = K := by
  mid_proof

/-- `^bb6`: `z2e50m1 = x z2e10m1`, into `^bb7`. -/
theorem bb6 (w x : Wwl) (E : ⟪Γ⟫) (hA : E.args = (argsOf z).get) (hC : Consts E)
    (hR : E ⊨ [%%773 := w, %%1169 := x])
    (hK :
      ∀ E' : ⟪Γ⟫, E'.args = (argsOf z).get → Consts E' →
        E' ⊨ [%%1223 := fd_r43x6_mul x w, %%1224 := fd_r43x6_mul x w, %%1225 :=
          .value (BitVec.ofNat 64 (2 * 24 + 2))] →
        runP E' 7 S = K) :
    runP E 6 S = K := by
  mid_proof

/-- `^bb8`: `z2e100m1 = x z2e50m1`, into `^bb9`. -/
theorem bb8 (w x : Wwl) (E : ⟪Γ⟫) (hA : E.args = (argsOf z).get) (hC : Consts E)
    (hR : E ⊨ [%%1223 := w, %%1319 := x])
    (hK :
      ∀ E' : ⟪Γ⟫, E'.args = (argsOf z).get → Consts E' →
        E' ⊨ [%%1223 := w, %%1373 := fd_r43x6_mul x w, %%1374 := fd_r43x6_mul x w, %%1375 :=
          .value (BitVec.ofNat 64 (2 * 49 + 2))] →
        runP E' 9 S = K) :
    runP E 8 S = K := by
  mid_proof

/-- `^bb10`: `z2e200m1 = x z2e100m1`, into `^bb11`. -/
theorem bb10 (w u x : Wwl) (E : ⟪Γ⟫) (hA : E.args = (argsOf z).get) (hC : Consts E)
    (hR : E ⊨ [%%1223 := w, %%1373 := u, %%1469 := x])
    (hK :
      ∀ E' : ⟪Γ⟫, E'.args = (argsOf z).get → Consts E' →
        E' ⊨ [%%1223 := w, %%1524 := fd_r43x6_mul x u, %%1525 :=
          .value (BitVec.ofNat 64 (2 * 24 + 2))] →
        runP E' 11 S = K) :
    runP E 10 S = K := by
  mid_proof

/-- `^bb12`: `z2e250m1 = x z2e50m1`, then `fd_r43x6_repsqr_mul( z2e250m1, z, 2UL )` returned. -/
theorem bb12 (w x : Wwl) (E : ⟪Γ⟫) (hA : E.args = (argsOf z).get) (hC : Consts E)
    (hR : E ⊨ [%%1223 := w, %%1619 := x]) :
    runP E 12 S =
      .value
        (.cons (Ty.wrap (fd_r43x6_mul (fd_r43x6_sqr (fd_r43x6_sqr (fd_r43x6_mul x w))) z)) .nil,
          S) := by
  dsimp only [Consts] at hC
  casesm* _ ∧ _
  block_init
  step_pattern using runBodyFrom_mulRun with u
  step_pattern using runBodyFrom_r43SqrRun with u1
  step_pattern using runBodyFrom_r43SqrRun with u2
  step_pattern using runBodyFrom_mulRunA with r
  finish_block
  subst r u2 u1 u
  rfl

end

-- the entry block: some 80 steps and patterns in one walk, over 200000 heartbeats
set_option maxHeartbeats 1000000 in
/-- `fd_r43x6_pow22523( z )` returns `z^(2^252 - 3)`, as `fd_r43x6_pow22523_2` computes it. -/
public theorem call_eq (z : Wwl) (s : GlobalState) (hwf : s.WF) :
    _root_.Firedancer.Lane.Mlir.fd_r43x6_pow22523.call (argsOf z) s =
      .value (.cons (Ty.wrap (Avx512.fd_r43x6_pow22523_2.spec z)) .nil, s) := by
  func_init
  block_init
  iterate 31 step_pure
  step_pattern using runBodyFrom_padRunAs (lanesBelow 6 sqrMask1)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 6 sqrMask2)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 sqrMask1)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 sqrMask2)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 7 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 5 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 6 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 5 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 3 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 4 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 2 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 3 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesBelow 1 wwl_zero)
  step_pattern using runBodyFrom_padRunAs (lanesFrom 2 wwl_zero)
  -- `z2 = fd_r43x6_sqr( z )`
  step_pattern using runBodyFrom_sqrRunA with z2
  -- `z9 = fd_r43x6_repsqr_mul( z2, z, 2UL )`
  step_pattern using runBodyFrom_r43SqrRun with z2s1
  step_pattern using runBodyFrom_r43SqrRun with z2s2
  step_pattern using runBodyFrom_mulRunA with z9
  -- `z11 = fd_r43x6_repsqr_mul( z9, z2, 0UL )`
  step_pattern using runBodyFrom_mulRun with z11
  -- `z2e5m1 = fd_r43x6_repsqr_mul( z11, z9, 1UL )`
  step_pattern using runBodyFrom_r43SqrRun with z11s1
  step_pattern using runBodyFrom_mulRun with z2e5m1
  -- `z2e10m1 = fd_r43x6_repsqr_mul( z2e5m1, z2e5m1, 5UL )`
  step_pattern using runBodyFrom_r43SqrRun with t1
  step_pattern using runBodyFrom_r43SqrRun with t2
  step_pattern using runBodyFrom_r43SqrRun with t3
  step_pattern using runBodyFrom_r43SqrRun with t4
  step_pattern using runBodyFrom_r43SqrRun with t5
  step_pattern using runBodyFrom_mulRun with z2e10m1
  finish_block
  step_loop using loop1 z S _ z2e10m1 4 z2e10m1
  intro hC2 hR2
  refine bb2 z S _ _ _ E₀ hArgs₀ hC2 hR2 fun E3 hA3 hC3 hR3 => ?_
  refine loop3 z S _ _ _ 9 _ E3 hA3 hC3 (by decide) hR3 fun E4 hA4 hC4 hR4 => ?_
  refine bb4 z S _ _ _ _ E4 hA4 hC4 hR4 fun E5 hA5 hC5 hR5 => ?_
  refine loop5 z S _ _ 4 _ E5 hA5 hC5 (by decide) hR5 fun E6 hA6 hC6 hR6 => ?_
  refine bb6 z S _ _ _ E6 hA6 hC6 hR6 fun E7 hA7 hC7 hR7 => ?_
  refine loop7 z S _ _ 24 _ E7 hA7 hC7 (by decide) hR7 fun E8 hA8 hC8 hR8 => ?_
  refine bb8 z S _ _ _ E8 hA8 hC8 hR8 fun E9 hA9 hC9 hR9 => ?_
  refine loop9 z S _ _ _ 49 _ E9 hA9 hC9 (by decide) hR9 fun E10 hA10 hC10 hR10 => ?_
  refine bb10 z S _ _ _ _ E10 hA10 hC10 hR10 fun E11 hA11 hC11 hR11 => ?_
  refine loop11 z S _ _ 24 _ E11 hA11 hC11 (by decide) hR11 fun E12 hA12 hC12 hR12 => ?_
  rw [bb12 z S _ _ E12 hA12 hC12 hR12, hS]
  simp only [sqrN2_eq]
  subst z2 z2s1 z2s2 z9 z11 z11s1 z2e5m1 t1 t2 t3 t4 t5 z2e10m1
  delta Avx512.fd_r43x6_pow22523_2.spec
  rfl

end MLIR.Firedancer.Lane.fd_r43x6_pow22523
