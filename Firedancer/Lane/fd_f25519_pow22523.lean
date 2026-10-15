module

public import Firedancer.Lane.Common.FieldPow
public import Firedancer.Lane.Common.R43x6
public import Firedancer.Lane.Mlir.fd_f25519_pow22523
public import Firedancer.Lane.verify_x8.Tactics
public import MLIR.Run.Tactic
import Mathlib.Tactic.NormNum

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512 FieldPow

/-! ## Specification -/

@[expose] public section

/-- `fd_f25519_pow22523( r, a )`'s `a^(2^252 - 3)`: the addition chain, `FD_R43X6_SQR1_INL` and
`FD_R43X6_MUL1_INL` on `fd_r43x6_t`s, a loop of `n` squarings `sqrN n`. -/
@[irreducible]
def fd_f25519_pow22523.spec (a : Wwl) : Wwl :=
  let sqr := fd_r43x6_sqr
  let mul := fd_r43x6_mul
  let sqrN := fd_r43x6_repsqr_mul2.sqrN
  let t0 := sqr a
  let t1 := sqrN 2 t0
  let t1 := mul a t1
  let t0 := mul t0 t1
  let t0 := sqr t0
  let t0 := mul t1 t0
  let t1 := sqrN 5 t0
  let t0 := mul t1 t0
  let t1 := sqrN 10 t0
  let t1 := mul t1 t0
  let t2 := sqrN 20 t1
  let t1 := mul t2 t1
  let t1 := sqrN 10 t1
  let t0 := mul t1 t0
  let t1 := sqrN 50 t0
  let t1 := mul t1 t0
  let t2 := sqrN 100 t1
  let t1 := mul t2 t1
  let t1 := sqrN 50 t1
  let t0 := mul t1 t0
  let t0 := sqrN 2 t0
  mul t0 a

end

/-! ## Value -/

/-- `fd_f25519_pow22523.spec` raises an unreduced `fd_r43x6_t` to `(p - 5) / 8`, folded. -/
public theorem fd_f25519_pow22523.spec_val {a : Wwl} (ha : R43x6.Unreduced a) :
    R43x6.val (fd_f25519_pow22523.spec a) = R43x6.val a ^ ((_root_.Ed25519.p - 5) / 8) ∧
      R43x6.Folded (fd_f25519_pow22523.spec a) := by
  have h1 := Pw.self ha
  have t0 := h1.sqr
  have t1 := t0.sqrN 2
  have t1 := h1.mul t1
  have t0 := t0.mul t1
  have t0 := t0.sqr
  have t0 := t1.mul t0
  have t1 := t0.sqrN 5
  have t0 := t1.mul t0
  have t1 := t0.sqrN 10
  have t1 := t1.mul t0
  have t2 := t1.sqrN 20
  have t1 := t2.mul t1
  have t1 := t1.sqrN 10
  have t0 := t1.mul t0
  have t1 := t0.sqrN 50
  have t1 := t1.mul t0
  have t2 := t1.sqrN 100
  have t1 := t2.mul t1
  have t1 := t1.sqrN 50
  have t0 := t1.mul t0
  have t0 := t0.sqrN 2
  obtain ⟨hv, hf⟩ := t0.mul_folded h1
  delta fd_f25519_pow22523.spec
  exact ⟨hv.trans (by norm_num), hf⟩

/-! ## Proof -/

section Proof

namespace fd_f25519_pow22523

open Firedancer.Lane.Mlir Firedancer.Lane.Mlir.fd_f25519_pow22523

/-- The entry block's constants the blocks after it read, `a`'s value `A` in `%142`. -/
abbrev Consts (A : Wwl) (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := .value 99#32, %1 := .value 49#32, %2 := .value 19#32, %3 := .value 9#32, %4 :=
    Ty.wrap foldK, %5 := Ty.wrap foldShifts, %6 := Ty.wrap foldMask, %7 :=
    Ty.wrap (Vector.replicate 8 24), %8 := Ty.wrap (Vector.replicate 8 7), %9 :=
    Ty.wrap #v[-1, -1, -1, -1, -1, -1, 0, 0], %15 := .value 2#32, %16 := .value 1#32, %17 :=
    (Ty.vec 8 64).poisoned, %18 :=
    Ty.wrap sqrDbl0, %19 := Ty.wrap sqrDbl2, %20 := Ty.wrap sqrDbl4, %22 :=
    Ty.wrap (Vector.replicate 8 0), %23 := Ty.wrap (Vector.replicate 8 9), %24 :=
    Ty.wrap sqrMaskN1, %25 := Ty.wrap sqrMaskN2, %37 := lanesBelow 6 sqrMask1, %45 :=
    lanesBelow 6 sqrMask2, %53 := lanesBelow 5 sqrMask1, %61 := lanesBelow 5 sqrMask2, %69 :=
    lanesFrom 7 wwl_zero, %77 := lanesBelow 5 wwl_zero, %85 := lanesFrom 6 wwl_zero, %93 :=
    lanesFrom 5 wwl_zero, %101 := lanesBelow 3 wwl_zero, %109 := lanesFrom 4 wwl_zero, %117 :=
    lanesBelow 2 wwl_zero, %125 := lanesFrom 3 wwl_zero, %133 := lanesBelow 1 wwl_zero, %141 :=
    lanesFrom 2 wwl_zero, %142 := Ty.wrap A]

section Loops

variable (r a : Pointer) (k ex : Fin 19) (N : Nat) (hdr : ⟪Γ⟫ → Wwl → Nat → ⟪Γ⟫)
  (Live : ⟪Γ⟫ → Prop) (Out : ⟪Γ⟫ → Wwl → Prop) (X : Wwl) (S : GlobalState)
  (K : PoisonOr (Vals [.ptr] × GlobalState))

/-- One pass through the loop at header `k` (env `hdr E x i` at counter `i`; `Live` what it and
the blocks after it read): a squaring and the test `i == N`, then on to `ex` with the square in
`Out`, or a second squaring and around with `i + 2`. -/
abbrev LoopIter : Prop :=
  ∀ i (E : ⟪Γ⟫),
    E.args = (args (.value r) (.value a)).get →
      Live E →
      i ≤ N →
      (i = N →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value a)).get →
            Live E' →
            Out E' (fd_r43x6_repsqr_mul2.sqrN (i + 1) X) → fd_f25519_pow22523.runFrom E' ex S = K) →
      (i < N →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value a)).get →
            Live E' →
            fd_f25519_pow22523.runFrom (hdr E' (fd_r43x6_repsqr_mul2.sqrN (i + 2) X) (i + 2)) k S =
              K) →
      fd_f25519_pow22523.runFrom (hdr E (fd_r43x6_repsqr_mul2.sqrN i X) i) k S = K

/-- The loop at header `k` from counter `i`, `n` passes after this one: `X` squared `N + 1` times
in all. -/
abbrev Loop : Prop :=
  ∀ n i (E : ⟪Γ⟫),
    E.args = (args (.value r) (.value a)).get →
      Live E →
      i + 2 * n = N →
      (∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value a)).get →
          Live E' →
          Out E' (fd_r43x6_repsqr_mul2.sqrN (N + 1) X) → fd_f25519_pow22523.runFrom E' ex S = K) →
      fd_f25519_pow22523.runFrom (hdr E (fd_r43x6_repsqr_mul2.sqrN i X) i) k S = K

variable {r a k ex N hdr Live Out X S K} in
/-- The loop from one pass, by induction on the passes left. -/
theorem loop_of_iter (h : LoopIter r a k ex N hdr Live Out X S K) :
    Loop r a k ex N hdr Live Out X S K := by
  intro n
  induction n with
  | zero =>
    intro i E hA hL hi hK
    obtain rfl : i = N := by omega
    exact h i E hA hL le_rfl (fun _ => hK) (by omega)
  | succ n ih =>
    intro i E hA hL hi hK
    exact
      h i E hA hL (by omega) (by omega) fun _ E' hA' hL' => ih (i + 2) E' hA' hL' (by omega) hK

end Loops

set_option hygiene false in
/-- A pass of an unrolled squaring loop (`LoopIter`): square, test; out, or square, count and
around. -/
local macro "iter_proof" : tactic =>
  `(tactic|
    ( intro i E hA hL hi hexit hback
      split_reads hL
      block_init
      step_pattern using runBodyFrom_r43SqrRun with y
      step_pure
      finish_block
      · step_loop using hexit (counter_eq (by omega) (by omega) hbr)
        rw [sqrN_succ']
      · block_init
        step_pattern using runBodyFrom_r43SqrRun with z
        step_pure [saddOverflow_two32 (i := i) (by omega), uaddOverflow_two32 (i := i) (by omega),
          ofNat_add_two32]
        finish_block
        step_loop using hback (by have := counter_ne hbr; omega)
        rw [sqrN_add_two]))

/-- `^bb2`'s env: the counter `i` and `x`. -/
abbrev hdr2 (E : ⟪Γ⟫) (x : Wwl) (i : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 920 := PoisonOr.value (BitVec.ofNat 32 i), rir_dst% hty 921 := Ty.wrap x]

/-- What `^bb2` and the blocks after it read: the constants, `t0` in `%773`. -/
abbrev live2 (A T0 : Wwl) (E : ⟪Γ⟫) : Prop :=
  Consts A E ∧ E ⊨ [rir_reg% hty 773 := Ty.wrap T0]

/-- `^bb2`'s square, as `^bb1` reads it. -/
abbrev out2 (E : ⟪Γ⟫) (y : Wwl) : Prop :=
  E ⊨ [rir_reg% hty 968 := Ty.wrap y]

/-- `^bb2`: a pass of `sqr t1, t0; for( i=1; i<10; i++ ) sqr t1, t1`. -/
theorem iter2 (r a : Pointer) (A T0 X : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.ptr] × GlobalState)) :
    LoopIter r a 2 1 9 hdr2 (live2 A T0) out2 X S K := by
  iter_proof

/-- `^bb5`'s env: the counter `i` and `x`. -/
abbrev hdr5 (E : ⟪Γ⟫) (x : Wwl) (i : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 1117 := PoisonOr.value (BitVec.ofNat 32 i), rir_dst% hty 1118 := Ty.wrap x]

/-- What `^bb5` and the blocks after it read: the constants, `t0 t1` in `%773 %872`. -/
abbrev live5 (A T0 T1 : Wwl) (E : ⟪Γ⟫) : Prop :=
  Consts A E ∧ E ⊨ [rir_reg% hty 773 := Ty.wrap T0, rir_reg% hty 872 := Ty.wrap T1]

/-- `^bb5`'s square, as `^bb4` reads it. -/
abbrev out5 (E : ⟪Γ⟫) (y : Wwl) : Prop :=
  E ⊨ [rir_reg% hty 1165 := Ty.wrap y]

/-- `^bb5`: a pass of `sqr t2, t1; for( i=1; i<20; i++ ) sqr t2, t2`. -/
theorem iter5 (r a : Pointer) (A T0 T1 X : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.ptr] × GlobalState)) :
    LoopIter r a 5 4 19 hdr5 (live5 A T0 T1) out5 X S K := by
  iter_proof

/-- `^bb8`'s env: the counter `i` and `x`. -/
abbrev hdr8 (E : ⟪Γ⟫) (x : Wwl) (i : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 1314 := PoisonOr.value (BitVec.ofNat 32 i), rir_dst% hty 1315 := Ty.wrap x]

/-- What `^bb8` and the blocks after it read: the constants, `t0` in `%773`. -/
abbrev live8 (A T0 : Wwl) (E : ⟪Γ⟫) : Prop :=
  Consts A E ∧ E ⊨ [rir_reg% hty 773 := Ty.wrap T0]

/-- `^bb8`'s square, as `^bb7` reads it. -/
abbrev out8 (E : ⟪Γ⟫) (y : Wwl) : Prop :=
  E ⊨ [rir_reg% hty 1362 := Ty.wrap y]

/-- `^bb8`: a pass of `sqr t1, t1; for( i=1; i<10; i++ ) sqr t1, t1`. -/
theorem iter8 (r a : Pointer) (A T0 X : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.ptr] × GlobalState)) :
    LoopIter r a 8 7 9 hdr8 (live8 A T0) out8 X S K := by
  iter_proof

/-- `^bb11`'s env: the counter `i` and `x`. -/
abbrev hdr11 (E : ⟪Γ⟫) (x : Wwl) (i : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 1511 := PoisonOr.value (BitVec.ofNat 32 i), rir_dst% hty 1512 := Ty.wrap x]

/-- What `^bb11` and the blocks after it read: the constants, `t0` in `%1266`. -/
abbrev live11 (A T0 : Wwl) (E : ⟪Γ⟫) : Prop :=
  Consts A E ∧ E ⊨ [rir_reg% hty 1266 := Ty.wrap T0]

/-- `^bb11`'s square, as `^bb10` reads it. -/
abbrev out11 (E : ⟪Γ⟫) (y : Wwl) : Prop :=
  E ⊨ [rir_reg% hty 1559 := Ty.wrap y]

/-- `^bb11`: a pass of `sqr t1, t0; for( i=1; i<50; i++ ) sqr t1, t1`. -/
theorem iter11 (r a : Pointer) (A T0 X : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.ptr] × GlobalState)) :
    LoopIter r a 11 10 49 hdr11 (live11 A T0) out11 X S K := by
  iter_proof

/-- `^bb14`'s env: the counter `i` and `x`. -/
abbrev hdr14 (E : ⟪Γ⟫) (x : Wwl) (i : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 1708 := PoisonOr.value (BitVec.ofNat 32 i), rir_dst% hty 1709 := Ty.wrap x]

/-- What `^bb14` and the blocks after it read: the constants, `t0 t1` in `%1266 %1463`. -/
abbrev live14 (A T0 T1 : Wwl) (E : ⟪Γ⟫) : Prop :=
  Consts A E ∧ E ⊨ [rir_reg% hty 1266 := Ty.wrap T0, rir_reg% hty 1463 := Ty.wrap T1]

/-- `^bb14`'s square, as `^bb13` reads it. -/
abbrev out14 (E : ⟪Γ⟫) (y : Wwl) : Prop :=
  E ⊨ [rir_reg% hty 1756 := Ty.wrap y]

/-- `^bb14`: a pass of `sqr t2, t1; for( i=1; i<100; i++ ) sqr t2, t2`. -/
theorem iter14 (r a : Pointer) (A T0 T1 X : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.ptr] × GlobalState)) :
    LoopIter r a 14 13 99 hdr14 (live14 A T0 T1) out14 X S K := by
  iter_proof

/-- `^bb17`'s env: the counter `i` and `x`. -/
abbrev hdr17 (E : ⟪Γ⟫) (x : Wwl) (i : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 2004 := PoisonOr.value (BitVec.ofNat 32 i), rir_dst% hty 2005 := Ty.wrap x]

/-- What `^bb17` and the blocks after it read: the constants, `t0` in `%1266`. -/
abbrev live17 (A T0 : Wwl) (E : ⟪Γ⟫) : Prop :=
  Consts A E ∧ E ⊨ [rir_reg% hty 1266 := Ty.wrap T0]

/-- `^bb17`'s square, as `^bb16` reads it. -/
abbrev out17 (E : ⟪Γ⟫) (y : Wwl) : Prop :=
  E ⊨ [rir_reg% hty 2052 := Ty.wrap y]

/-- `^bb17`: a pass of `sqr t1, t1; for( i=1; i<50; i++ ) sqr t1, t1`. -/
theorem iter17 (r a : Pointer) (A T0 X : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.ptr] × GlobalState)) :
    LoopIter r a 17 16 49 hdr17 (live17 A T0) out17 X S K := by
  iter_proof

/-- `^bb1`, then the loop at `^bb5`: `mul t1, t1, t0`, then `sqr t2, t1` and its loop. -/
theorem bb1 (r a : Pointer) (A T0 Y : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.ptr] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r) (.value a)).get) (hL : live2 A T0 E) (hO : out2 E Y)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value a)).get →
          live5 A T0 (fd_r43x6_mul Y T0) E' →
          out5 E' (fd_r43x6_repsqr_mul2.sqrN 20 (fd_r43x6_mul Y T0)) →
          fd_f25519_pow22523.runFrom E' 4 S = K) :
    fd_f25519_pow22523.runFrom E 1 S = K := by
  dsimp only [out2] at hO
  split_reads hL
  block_init
  step_pattern using runBodyFrom_mulRun with t1
  step_pattern using runBodyFrom_r43SqrRun with t2
  finish_block
  subst t1 t2
  step_loop using loop_of_iter (iter5 r a A T0 (fd_r43x6_mul Y T0) _ S K) 9 1
  subst hS
  exact hK _ hArgs₀

/-- `^bb4`, then the loop at `^bb8`: `mul t1, t2, t1`, then `sqr t1, t1` and its loop. -/
theorem bb4 (r a : Pointer) (A T0 T1 Y : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.ptr] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r) (.value a)).get) (hL : live5 A T0 T1 E) (hO : out5 E Y)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value a)).get →
          live8 A T0 E' →
          out8 E' (fd_r43x6_repsqr_mul2.sqrN 10 (fd_r43x6_mul Y T1)) →
          fd_f25519_pow22523.runFrom E' 7 S = K) :
    fd_f25519_pow22523.runFrom E 4 S = K := by
  dsimp only [out5] at hO
  split_reads hL
  block_init
  step_pattern using runBodyFrom_mulRun with t1
  step_pattern using runBodyFrom_r43SqrRun with t2
  finish_block
  subst t1 t2
  step_loop using loop_of_iter (iter8 r a A T0 (fd_r43x6_mul Y T1) S K) 4 1
  subst hS
  exact hK _ hArgs₀

/-- `^bb7`, then the loop at `^bb11`: `mul t0, t1, t0`, then `sqr t1, t0` and its loop. -/
theorem bb7 (r a : Pointer) (A T0 Y : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.ptr] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r) (.value a)).get) (hL : live8 A T0 E) (hO : out8 E Y)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value a)).get →
          live11 A (fd_r43x6_mul Y T0) E' →
          out11 E' (fd_r43x6_repsqr_mul2.sqrN 50 (fd_r43x6_mul Y T0)) →
          fd_f25519_pow22523.runFrom E' 10 S = K) :
    fd_f25519_pow22523.runFrom E 7 S = K := by
  dsimp only [out8] at hO
  split_reads hL
  block_init
  step_pattern using runBodyFrom_mulRun with t0
  step_pattern using runBodyFrom_r43SqrRun with t1
  finish_block
  subst t0 t1
  step_loop using loop_of_iter (iter11 r a A (fd_r43x6_mul Y T0) _ S K) 24 1
  subst hS
  exact hK _ hArgs₀

/-- `^bb10`, then the loop at `^bb14`: `mul t1, t1, t0`, then `sqr t2, t1` and its loop. -/
theorem bb10 (r a : Pointer) (A T0 Y : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.ptr] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r) (.value a)).get) (hL : live11 A T0 E) (hO : out11 E Y)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value a)).get →
          live14 A T0 (fd_r43x6_mul Y T0) E' →
          out14 E' (fd_r43x6_repsqr_mul2.sqrN 100 (fd_r43x6_mul Y T0)) →
          fd_f25519_pow22523.runFrom E' 13 S = K) :
    fd_f25519_pow22523.runFrom E 10 S = K := by
  dsimp only [out11] at hO
  split_reads hL
  block_init
  step_pattern using runBodyFrom_mulRun with t1
  step_pattern using runBodyFrom_r43SqrRun with t2
  finish_block
  subst t1 t2
  step_loop using loop_of_iter (iter14 r a A T0 (fd_r43x6_mul Y T0) _ S K) 49 1
  subst hS
  exact hK _ hArgs₀

/-- `^bb13`, then the loop at `^bb17`: `mul t1, t2, t1`, then `sqr t1, t1` and its loop. -/
theorem bb13 (r a : Pointer) (A T0 T1 Y : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.ptr] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r) (.value a)).get) (hL : live14 A T0 T1 E) (hO : out14 E Y)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value a)).get →
          live17 A T0 E' →
          out17 E' (fd_r43x6_repsqr_mul2.sqrN 50 (fd_r43x6_mul Y T1)) →
          fd_f25519_pow22523.runFrom E' 16 S = K) :
    fd_f25519_pow22523.runFrom E 13 S = K := by
  dsimp only [out14] at hO
  split_reads hL
  block_init
  step_pattern using runBodyFrom_mulRun with t1
  step_pattern using runBodyFrom_r43SqrRun with t2
  finish_block
  subst t1 t2
  step_loop using loop_of_iter (iter17 r a A T0 (fd_r43x6_mul Y T1) S K) 24 1
  subst hS
  exact hK _ hArgs₀

/-- `^bb16`: `mul t0, t1, t0`, `sqr t0, t0` twice, `mul r, t0, a`; stores at `r`, returns `r`. -/
theorem bb16 (r a : Pointer) (A T0 Y : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.ptr] × GlobalState)) (E : ⟪Γ⟫) (hwf : S.WF) (hr : Room S.mem r 512)
    (hA : E.args = (args (.value r) (.value a)).get) (hL : live17 A T0 E) (hO : out17 E Y)
    (hK :
      .value
          (.cons (.value r) .nil,
            { S with
              mem :=
                S.mem.storeVec r
                  (fd_r43x6_mul (fd_r43x6_repsqr_mul2.sqrN 2 (fd_r43x6_mul Y T0)) A) }) =
        K) :
    fd_f25519_pow22523.runFrom E 16 S = K := by
  dsimp only [out17] at hO
  split_reads hL
  block_init
  step_pattern using runBodyFrom_mulRun with t0
  step_pattern using runBodyFrom_r43SqrRun with t0'
  step_pattern using runBodyFrom_r43SqrRun with t0''
  step_pattern using runBodyFrom_mulRun with t
  step_store
  finish_block
  rw [← hK, hS, MemoryState.storeVec]
  subst t0 t0' t0'' t
  rfl

/-- The chain up to its first loop: `a^(2^5 - 1)`. -/
def chain5 (a : Wwl) : Wwl :=
  let t0 := fd_r43x6_sqr a
  let t1 := fd_r43x6_repsqr_mul2.sqrN 2 t0
  let t1 := fd_r43x6_mul a t1
  let t0 := fd_r43x6_mul t0 t1
  let t0 := fd_r43x6_sqr t0
  fd_r43x6_mul t1 t0

/-- `^bb0` past its load: `sqr t0, a` up to `mul t0, t1, t0`, `chain5 A` in `%486`. -/
theorem bb0_head (r a : Pointer) (A : Wwl) (S : GlobalState)
    {g : ⟪Γ⟫ × GlobalState → PoisonOr (Vals [.ptr] × GlobalState)}
    {K : PoisonOr (Vals [.ptr] × GlobalState)} (E : ⟪Γ⟫)
    (hg :
      g = fun x =>
        @bind PoisonOr _ ((⟪Γ⟫ × ExitResult [.ptr] 19) × GlobalState) (Vals [.ptr] × GlobalState)
          (Exit.run blockParams x.1 bb0.exit x.2) fun y =>
          Func.continue (func := fd_f25519_pow22523) y.1.1 y.1.2 y.2)
    (hA : E.args = (args (.value r) (.value a)).get) (hL : Consts A E)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value a)).get →
          Consts A E' →
          E'.read (rir_reg% hty 486) = Ty.wrap (chain5 A) →
          (bb0.runBodyFrom E' 487 S >>= g) = K) :
    (bb0.runBodyFrom E 143 S >>= g) = K := by
  subst hg
  split_reads hL
  -- `sqr t0, a`, `sqr t1, t0`, `sqr t1, t1`
  step_pattern using runBodyFrom_r43SqrRun with t0
  step_pattern using runBodyFrom_r43SqrRun with t1
  step_pattern using runBodyFrom_r43SqrRun with t1'
  -- `mul t1, a, t1`, `mul t0, t0, t1`, `sqr t0, t0`, `mul t0, t1, t0`
  step_pattern using runBodyFrom_mulRun with t1''
  step_pattern using runBodyFrom_mulRun with t0'
  step_pattern using runBodyFrom_r43SqrRun with t0''
  step_pattern using runBodyFrom_mulRun with u
  have e : u = chain5 A := by
    subst t0 t1 t1' t1'' t0' t0'' u
    rfl
  subst e hS
  exact hK E hArgs (by env_reads) (by env_reads)

/-- `^bb0` to its end: `sqr t1, t0; for( i=1; i<5; i++ ) sqr t1, t1` unrolled, `mul t0, t1, t0`
in `%773`, and the first `sqr t1, t0` of the next loop in `%820`. -/
theorem bb0_tail (r a : Pointer) (A U : Wwl) (S : GlobalState)
    {g : ⟪Γ⟫ × GlobalState → PoisonOr (Vals [.ptr] × GlobalState)}
    {K : PoisonOr (Vals [.ptr] × GlobalState)} (E : ⟪Γ⟫)
    (hg :
      g = fun x =>
        @bind PoisonOr _ ((⟪Γ⟫ × ExitResult [.ptr] 19) × GlobalState) (Vals [.ptr] × GlobalState)
          (Exit.run blockParams x.1 bb0.exit x.2) fun y =>
          Func.continue (func := fd_f25519_pow22523) y.1.1 y.1.2 y.2)
    (hA : E.args = (args (.value r) (.value a)).get) (hL : Consts A E)
    (hU : E.read (rir_reg% hty 486) = Ty.wrap U)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value a)).get →
          Consts A E' →
          E'.read (rir_reg% hty 773) =
              Ty.wrap (fd_r43x6_mul (fd_r43x6_repsqr_mul2.sqrN 5 U) U) →
          E'.read (rir_reg% hty 820) =
              Ty.wrap (fd_r43x6_sqr (fd_r43x6_mul (fd_r43x6_repsqr_mul2.sqrN 5 U) U)) →
          (bb0.runBodyFrom E' 821 S >>= g) = K) :
    (bb0.runBodyFrom E 487 S >>= g) = K := by
  subst hg
  split_reads hL
  step_pattern using runBodyFrom_r43SqrRun with u1
  step_pattern using runBodyFrom_r43SqrRun with u2
  step_pattern using runBodyFrom_r43SqrRun with u3
  step_pattern using runBodyFrom_r43SqrRun with u4
  step_pattern using runBodyFrom_r43SqrRun with u5
  step_pattern using runBodyFrom_mulRun with v0
  step_pattern using runBodyFrom_r43SqrRun with v1
  have e : v0 = fd_r43x6_mul (fd_r43x6_repsqr_mul2.sqrN 5 U) U := by
    subst u1 u2 u3 u4 u5 v0
    rfl
  subst e v1 hS
  exact hK E hArgs (by env_reads) (by env_reads) (by env_reads)

/-- `fd_f25519_pow22523( r, a )` stores `spec` of the element at `a` at `r` and returns `r`; it
loads `a` before it stores, so `r` may be `a`. -/
public theorem _root_.Firedancer.Lane.Mlir.fd_f25519_pow22523.call_eq (r a : Pointer)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) (ha : Fits s.mem a 512) :
    Firedancer.Lane.Mlir.fd_f25519_pow22523.call
        (Firedancer.Lane.Mlir.fd_f25519_pow22523.args (.value r) (.value a)) s =
      .value
        (.cons (.value r) .nil,
          { s with mem := s.mem.storeVec r (fd_f25519_pow22523.spec (s.mem.readVec a)) }) := by
  func_init
  block_init
  -- the constants, left inline: the runs read them as literals
  iterate 30 step_pure
  -- the masks and the slides' zero operands, by `insertelement`s
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
  step_load with A
  subst hv37 hv45 hv53 hv61 hv69 hv77 hv85 hv93 hv101 hv109 hv117 hv125 hv133 hv141
  refine bb0_head r a A S E rfl hArgs (by env_reads) fun E hA hL hU => ?_
  refine bb0_tail r a A _ S E rfl hA hL hU fun E hA hL h773 h820 => ?_
  finish_block
  step_loop using loop_of_iter (iter2 r a A _ _ S _) 4 1
  intro hL hO
  refine bb1 r a _ _ _ S _ E₀ hArgs₀ hL hO fun E hA hL hO => ?_
  refine bb4 r a _ _ _ _ S _ E hA hL hO fun E hA hL hO => ?_
  refine bb7 r a _ _ _ S _ E hA hL hO fun E hA hL hO => ?_
  refine bb10 r a _ _ _ S _ E hA hL hO fun E hA hL hO => ?_
  refine bb13 r a _ _ _ _ S _ E hA hL hO fun E hA hL hO => ?_
  refine bb16 r a _ _ _ S _ E hwf hr hA hL hO ?_
  subst hS hA
  delta fd_f25519_pow22523.spec
  rfl

end fd_f25519_pow22523

end Proof

end MLIR.Firedancer.Lane
