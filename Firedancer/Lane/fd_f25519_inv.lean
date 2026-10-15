module

public import Firedancer.Lane.Common.FieldPow
public import Firedancer.Lane.Common.R43x6
public import Firedancer.Lane.Mlir.fd_f25519_inv
public import Firedancer.Lane.verify_x8.Tactics
public import MLIR.Run.Tactic
import Mathlib.Tactic.NormNum

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512 FieldPow

/-! ## Specification -/

@[expose] public section

/-- `fd_f25519_inv( r, a )`'s `a^(p - 2) = a^(2^5 (2^250 - 1) + 11)`: the addition chain,
`FD_R43X6_SQR1_INL` and `FD_R43X6_MUL1_INL` on `fd_r43x6_t`s, a loop of `n` squarings `sqrN n`. -/
@[irreducible]
def fd_f25519_inv.spec (a : Wwl) : Wwl :=
  let sqr := fd_r43x6_sqr
  let mul := fd_r43x6_mul
  let sqrN := fd_r43x6_repsqr_mul2.sqrN
  let t0 := sqr a
  let t1 := sqrN 2 t0
  let t1 := mul a t1
  let t0 := mul t0 t1
  let t2 := sqr t0
  let t1 := mul t1 t2
  let t2 := sqrN 5 t1
  let t1 := mul t2 t1
  let t2 := sqrN 10 t1
  let t2 := mul t2 t1
  let t3 := sqrN 20 t2
  let t2 := mul t3 t2
  let t2 := sqrN 10 t2
  let t1 := mul t2 t1
  let t2 := sqrN 50 t1
  let t2 := mul t2 t1
  let t3 := sqrN 100 t2
  let t2 := mul t3 t2
  let t2 := sqrN 50 t2
  let t1 := mul t2 t1
  let t1 := sqrN 5 t1
  mul t1 t0

end

/-! ## Value -/

/-- `fd_f25519_inv.spec` inverts an unreduced `fd_r43x6_t`, folded (`0⁻¹ = 0`). -/
public theorem fd_f25519_inv.spec_val {a : Wwl} (ha : R43x6.Unreduced a) :
    R43x6.val (fd_f25519_inv.spec a) = (R43x6.val a)⁻¹ ∧ R43x6.Folded (fd_f25519_inv.spec a) := by
  have h1 := Pw.self ha
  have t0 := h1.sqr
  have t1 := t0.sqrN 2
  have t1 := h1.mul t1
  have t0 := t0.mul t1
  have t2 := t0.sqr
  have t1 := t1.mul t2
  have t2 := t1.sqrN 5
  have t1 := t2.mul t1
  have t2 := t1.sqrN 10
  have t2 := t2.mul t1
  have t3 := t2.sqrN 20
  have t2 := t3.mul t2
  have t2 := t2.sqrN 10
  have t1 := t2.mul t1
  have t2 := t1.sqrN 50
  have t2 := t2.mul t1
  have t3 := t2.sqrN 100
  have t2 := t3.mul t2
  have t2 := t2.sqrN 50
  have t1 := t2.mul t1
  have t1 := t1.sqrN 5
  obtain ⟨hv, hf⟩ := t1.mul_folded t0
  delta fd_f25519_inv.spec
  refine ⟨hv.trans ?_, hf⟩
  rw [← pow_p_sub_two]
  norm_num

/-! ## Proof -/

section Proof

namespace fd_f25519_inv

open Firedancer.Lane.Mlir Firedancer.Lane.Mlir.fd_f25519_inv

/-- The entry block's constants the blocks after it read. -/
abbrev Consts (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := .value 99#32, %1 := .value 49#32, %2 := .value 10#32, %3 := .value 19#32,
    %4 := .value 9#32, %5 := Ty.wrap foldK, %6 := Ty.wrap foldShifts, %7 := Ty.wrap foldMask,
    %8 := Ty.wrap (Vector.replicate 8 24), %9 := Ty.wrap (Vector.replicate 8 7),
    %10 := Ty.wrap #v[-1, -1, -1, -1, -1, -1, 0, 0], %16 := .value 2#32, %17 := .value 1#32,
    %18 := (Ty.vec 8 64).poisoned, %19 := Ty.wrap sqrDbl0, %20 := Ty.wrap sqrDbl2,
    %21 := Ty.wrap sqrDbl4, %23 := Ty.wrap (Vector.replicate 8 0),
    %24 := Ty.wrap (Vector.replicate 8 9), %25 := Ty.wrap sqrMaskN1, %26 := Ty.wrap sqrMaskN2,
    %30 := .value 0#32, %38 := lanesBelow 6 sqrMask1, %46 := lanesBelow 6 sqrMask2,
    %54 := lanesBelow 5 sqrMask1, %62 := lanesBelow 5 sqrMask2, %70 := lanesFrom 7 wwl_zero,
    %78 := lanesBelow 5 wwl_zero, %86 := lanesFrom 6 wwl_zero, %94 := lanesFrom 5 wwl_zero,
    %102 := lanesBelow 3 wwl_zero, %110 := lanesFrom 4 wwl_zero, %118 := lanesBelow 2 wwl_zero,
    %126 := lanesFrom 3 wwl_zero, %134 := lanesBelow 1 wwl_zero, %142 := lanesFrom 2 wwl_zero]

section Loops

variable (r a : Pointer) (k ex : Fin 18) (N : Nat) (hdr : ⟪Γ⟫ → Wwl → Nat → ⟪Γ⟫)
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
            Out E' (fd_r43x6_repsqr_mul2.sqrN (i + 1) X) → fd_f25519_inv.runFrom E' ex S = K) →
      (i < N →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value a)).get →
            Live E' →
            fd_f25519_inv.runFrom (hdr E' (fd_r43x6_repsqr_mul2.sqrN (i + 2) X) (i + 2)) k S = K) →
      fd_f25519_inv.runFrom (hdr E (fd_r43x6_repsqr_mul2.sqrN i X) i) k S = K

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
          Out E' (fd_r43x6_repsqr_mul2.sqrN (N + 1) X) → fd_f25519_inv.runFrom E' ex S = K) →
      fd_f25519_inv.runFrom (hdr E (fd_r43x6_repsqr_mul2.sqrN i X) i) k S = K

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

/-- One pass of the loop at `k` that counts up by `2` (env `hdr E x (2 j)` at pass `j`): two
squarings, `c + 2`, the test `c + 2 == 2 N`; on to `ex` with the squares in `Out`, else around. -/
abbrev UpIter : Prop :=
  ∀ j (x : Wwl) (E : ⟪Γ⟫),
    E.args = (args (.value r) (.value a)).get →
      Live E →
      j < N →
      (j + 1 = N →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value a)).get →
            Live E' → Out E' (fd_r43x6_sqr (fd_r43x6_sqr x)) → fd_f25519_inv.runFrom E' ex S = K) →
      (j + 1 < N →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value a)).get →
            Live E' →
            fd_f25519_inv.runFrom (hdr E' (fd_r43x6_sqr (fd_r43x6_sqr x)) (2 * (j + 1))) k S = K) →
      fd_f25519_inv.runFrom (hdr E x (2 * j)) k S = K

/-- The counting-up loop at `k` from pass `j`, `n` passes after this one: `x` squared
`2 (n + 1)` times. -/
abbrev UpLoop : Prop :=
  ∀ n j (x : Wwl) (E : ⟪Γ⟫),
    E.args = (args (.value r) (.value a)).get →
      Live E →
      j + n + 1 = N →
      (∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value a)).get →
          Live E' →
          Out E' (fd_r43x6_repsqr_mul2.sqrN (2 * (n + 1)) x) → fd_f25519_inv.runFrom E' ex S = K) →
      fd_f25519_inv.runFrom (hdr E x (2 * j)) k S = K

variable {r a k ex N hdr Live Out S K} in
/-- The counting-up loop from one pass, by induction on the passes left. -/
theorem upLoop_of_iter (h : UpIter r a k ex N hdr Live Out S K) :
    UpLoop r a k ex N hdr Live Out S K := by
  intro n
  induction n with
  | zero =>
    intro j x E hA hL hj hK
    exact h j x E hA hL (by omega) (fun _ => hK) (by omega)
  | succ n ih =>
    intro j x E hA hL hj hK
    refine
      h j x E hA hL (by omega) (by omega) fun _ E' hA' hL' => ih (j + 1) _ E' hA' hL' (by omega) ?_
    intro E'' hA'' hL'' hO
    rw [show 2 * (n + 1 + 1) = 2 * (n + 1) + 2 by omega, sqrN_add_two'] at hK
    exact hK E'' hA'' hL'' hO

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
  E[rir_dst% hty 921 := PoisonOr.value (BitVec.ofNat 32 i), rir_dst% hty 922 := Ty.wrap x]

/-- What `^bb2` and the blocks after it read: the constants, `%388` `%774`. -/
abbrev live2 (T0 T1 : Wwl) (E : ⟪Γ⟫) : Prop :=
  Consts E ∧ E ⊨ [rir_reg% hty 388 := Ty.wrap T0, rir_reg% hty 774 := Ty.wrap T1]

/-- `^bb2`'s square, as `^bb1` reads it. -/
abbrev out2 (E : ⟪Γ⟫) (y : Wwl) : Prop :=
  E ⊨ [rir_reg% hty 969 := Ty.wrap y]

/-- `^bb2`: a pass of `sqr t2, t1; for( i=1; i<10; i++ ) sqr t2, t2`. -/
theorem iter2 (r a : Pointer) (T0 T1 X : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.ptr] × GlobalState)) :
    LoopIter r a 2 1 9 hdr2 (live2 T0 T1) out2 X S K := by
  iter_proof

/-- `^bb5`'s env: the counter `i` and `x`. -/
abbrev hdr5 (E : ⟪Γ⟫) (x : Wwl) (i : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 1071 := PoisonOr.value (BitVec.ofNat 32 i), rir_dst% hty 1072 := Ty.wrap x]

/-- What `^bb5` and the blocks after it read: the constants, `%388` `%774` `%873`. -/
abbrev live5 (T0 T1 T2 : Wwl) (E : ⟪Γ⟫) : Prop :=
  Consts E ∧ E ⊨ [rir_reg% hty 388 := Ty.wrap T0, rir_reg% hty 774 := Ty.wrap T1,
    rir_reg% hty 873 := Ty.wrap T2]

/-- `^bb5`'s square, as `^bb4` reads it. -/
abbrev out5 (E : ⟪Γ⟫) (y : Wwl) : Prop :=
  E ⊨ [rir_reg% hty 1119 := Ty.wrap y]

/-- `^bb5`: a pass of `sqr t3, t2; for( i=1; i<20; i++ ) sqr t3, t3`. -/
theorem iter5 (r a : Pointer) (T0 T1 T2 X : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.ptr] × GlobalState)) :
    LoopIter r a 5 4 19 hdr5 (live5 T0 T1 T2) out5 X S K := by
  iter_proof

/-- `^bb10`'s env: the counter `i` and `x`. -/
abbrev hdr10 (E : ⟪Γ⟫) (x : Wwl) (i : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 1465 := PoisonOr.value (BitVec.ofNat 32 i), rir_dst% hty 1466 := Ty.wrap x]

/-- What `^bb10` and the blocks after it read: the constants, `%388` `%1220`. -/
abbrev live10 (T0 T1 : Wwl) (E : ⟪Γ⟫) : Prop :=
  Consts E ∧ E ⊨ [rir_reg% hty 388 := Ty.wrap T0, rir_reg% hty 1220 := Ty.wrap T1]

/-- `^bb10`'s square, as `^bb9` reads it. -/
abbrev out10 (E : ⟪Γ⟫) (y : Wwl) : Prop :=
  E ⊨ [rir_reg% hty 1513 := Ty.wrap y]

/-- `^bb10`: a pass of `sqr t2, t1; for( i=1; i<50; i++ ) sqr t2, t2`. -/
theorem iter10 (r a : Pointer) (T0 T1 X : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.ptr] × GlobalState)) :
    LoopIter r a 10 9 49 hdr10 (live10 T0 T1) out10 X S K := by
  iter_proof

/-- `^bb13`'s env: the counter `i` and `x`. -/
abbrev hdr13 (E : ⟪Γ⟫) (x : Wwl) (i : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 1662 := PoisonOr.value (BitVec.ofNat 32 i), rir_dst% hty 1663 := Ty.wrap x]

/-- What `^bb13` and the blocks after it read: the constants, `%388` `%1220` `%1417`. -/
abbrev live13 (T0 T1 T2 : Wwl) (E : ⟪Γ⟫) : Prop :=
  Consts E ∧ E ⊨ [rir_reg% hty 388 := Ty.wrap T0, rir_reg% hty 1220 := Ty.wrap T1,
    rir_reg% hty 1417 := Ty.wrap T2]

/-- `^bb13`'s square, as `^bb12` reads it. -/
abbrev out13 (E : ⟪Γ⟫) (y : Wwl) : Prop :=
  E ⊨ [rir_reg% hty 1710 := Ty.wrap y]

/-- `^bb13`: a pass of `sqr t3, t2; for( i=1; i<100; i++ ) sqr t3, t3`. -/
theorem iter13 (r a : Pointer) (T0 T1 T2 X : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.ptr] × GlobalState)) :
    LoopIter r a 13 12 99 hdr13 (live13 T0 T1 T2) out13 X S K := by
  iter_proof

/-- `^bb16`'s env: the counter `i` and `x`. -/
abbrev hdr16 (E : ⟪Γ⟫) (x : Wwl) (i : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 2099 := PoisonOr.value (BitVec.ofNat 32 i), rir_dst% hty 2100 := Ty.wrap x]

/-- What `^bb16` and the blocks after it read: the constants, `%388` `%1220`. -/
abbrev live16 (T0 T1 : Wwl) (E : ⟪Γ⟫) : Prop :=
  Consts E ∧ E ⊨ [rir_reg% hty 388 := Ty.wrap T0, rir_reg% hty 1220 := Ty.wrap T1]

/-- `^bb16`'s square, as `^bb15` reads it. -/
abbrev out16 (E : ⟪Γ⟫) (y : Wwl) : Prop :=
  E ⊨ [rir_reg% hty 2147 := Ty.wrap y]

/-- `^bb16`: a pass of `sqr t2, t2; for( i=1; i<50; i++ ) sqr t2, t2`. -/
theorem iter16 (r a : Pointer) (T0 T1 X : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.ptr] × GlobalState)) :
    LoopIter r a 16 15 49 hdr16 (live16 T0 T1) out16 X S K := by
  iter_proof

/-- `^bb8`'s env: the counter `c` and `x`. -/
abbrev hdr8 (E : ⟪Γ⟫) (x : Wwl) (c : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 1268 := PoisonOr.value (BitVec.ofNat 32 c), rir_dst% hty 1269 := Ty.wrap x]

/-- What `^bb8` and the blocks after it read: the constants, `%388 %774`. -/
abbrev live8 (T0 T1 : Wwl) (E : ⟪Γ⟫) : Prop :=
  Consts E ∧ E ⊨ [rir_reg% hty 388 := Ty.wrap T0, rir_reg% hty 774 := Ty.wrap T1]

/-- `^bb8`'s squares, as `^bb7` reads them. -/
abbrev out8 (E : ⟪Γ⟫) (y : Wwl) : Prop :=
  E ⊨ [rir_reg% hty 1363 := Ty.wrap y]

/-- `^bb8`: a pass of `for( i=0; i<10; i++ ) sqr t2, t2`, unrolled by two. -/
theorem iter8 (r a : Pointer) (T0 T1 : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.ptr] × GlobalState)) :
    UpIter r a 8 7 5 hdr8 (live8 T0 T1) out8 S K := by
  intro j x E hA hL hj hexit hback
  split_reads hL
  block_init
  step_pattern using runBodyFrom_r43SqrRun with y
  step_pattern using runBodyFrom_r43SqrRun with y'
  step_pure [saddOverflow_two32 (i := 2 * j) (by omega), uaddOverflow_two32 (i := 2 * j) (by omega),
    ofNat_add_two32, show 2 * j + 2 = 2 * (j + 1) by omega]
  step_pure
  finish_block
  · step_loop using hexit (by have := counter_eq (by omega) (by omega) hbr; omega)
  · step_loop using hback (by have := counter_ne hbr; omega)

/-- `^bb1`, then the loop at `^bb5`: `mul t2, t2, t1`, then `sqr t3, t2` and its loop. -/
theorem bb1 (r a : Pointer) (T0 T1 Y : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.ptr] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r) (.value a)).get) (hL : live2 T0 T1 E) (hO : out2 E Y)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value a)).get →
          live5 T0 T1 (fd_r43x6_mul Y T1) E' →
          out5 E' (fd_r43x6_repsqr_mul2.sqrN 20 (fd_r43x6_mul Y T1)) →
          fd_f25519_inv.runFrom E' 4 S = K) :
    fd_f25519_inv.runFrom E 1 S = K := by
  dsimp only [out2] at hO
  split_reads hL
  block_init
  step_pattern using runBodyFrom_mulRun with w
  step_pattern using runBodyFrom_r43SqrRun with v
  finish_block
  subst w v
  step_loop using loop_of_iter (iter5 r a T0 T1 (fd_r43x6_mul Y T1) (fd_r43x6_mul Y T1) S K) 9 1
  subst hS
  exact hK _ hArgs₀

/-- `^bb4`, then the loop at `^bb8`: `mul t2, t3, t2`, then `for( i=0; i<10; i++ ) sqr t2, t2`. -/
theorem bb4 (r a : Pointer) (T0 T1 T2 Y : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.ptr] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r) (.value a)).get) (hL : live5 T0 T1 T2 E) (hO : out5 E Y)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value a)).get →
          live8 T0 T1 E' →
          out8 E' (fd_r43x6_repsqr_mul2.sqrN 10 (fd_r43x6_mul Y T2)) →
          fd_f25519_inv.runFrom E' 7 S = K) :
    fd_f25519_inv.runFrom E 4 S = K := by
  dsimp only [out5] at hO
  split_reads hL
  block_init
  step_pattern using runBodyFrom_mulRun with w
  finish_block
  subst w
  step_loop using upLoop_of_iter (iter8 r a T0 T1 S K) 4 0 _
  subst hS
  exact hK _ hArgs₀

/-- `^bb7`, then the loop at `^bb10`: `mul t1, t2, t1`, then `sqr t2, t1` and its loop. -/
theorem bb7 (r a : Pointer) (T0 T1 Y : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.ptr] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r) (.value a)).get) (hL : live8 T0 T1 E) (hO : out8 E Y)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value a)).get →
          live10 T0 (fd_r43x6_mul Y T1) E' →
          out10 E' (fd_r43x6_repsqr_mul2.sqrN 50 (fd_r43x6_mul Y T1)) →
          fd_f25519_inv.runFrom E' 9 S = K) :
    fd_f25519_inv.runFrom E 7 S = K := by
  dsimp only [out8] at hO
  split_reads hL
  block_init
  step_pattern using runBodyFrom_mulRun with w
  step_pattern using runBodyFrom_r43SqrRun with v
  finish_block
  subst w v
  step_loop using loop_of_iter (iter10 r a T0 (fd_r43x6_mul Y T1) (fd_r43x6_mul Y T1) S K) 24 1
  subst hS
  exact hK _ hArgs₀

/-- `^bb9`, then the loop at `^bb13`: `mul t2, t2, t1`, then `sqr t3, t2` and its loop. -/
theorem bb9 (r a : Pointer) (T0 T1 Y : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.ptr] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r) (.value a)).get) (hL : live10 T0 T1 E) (hO : out10 E Y)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value a)).get →
          live13 T0 T1 (fd_r43x6_mul Y T1) E' →
          out13 E' (fd_r43x6_repsqr_mul2.sqrN 100 (fd_r43x6_mul Y T1)) →
          fd_f25519_inv.runFrom E' 12 S = K) :
    fd_f25519_inv.runFrom E 9 S = K := by
  dsimp only [out10] at hO
  split_reads hL
  block_init
  step_pattern using runBodyFrom_mulRun with w
  step_pattern using runBodyFrom_r43SqrRun with v
  finish_block
  subst w v
  step_loop using loop_of_iter (iter13 r a T0 T1 (fd_r43x6_mul Y T1) (fd_r43x6_mul Y T1) S K) 49 1
  subst hS
  exact hK _ hArgs₀

/-- `^bb12`, then the loop at `^bb16`: `mul t2, t3, t2`, then `sqr t2, t2` and its loop. -/
theorem bb12 (r a : Pointer) (T0 T1 T2 Y : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.ptr] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (.value r) (.value a)).get) (hL : live13 T0 T1 T2 E) (hO : out13 E Y)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value a)).get →
          live16 T0 T1 E' →
          out16 E' (fd_r43x6_repsqr_mul2.sqrN 50 (fd_r43x6_mul Y T2)) →
          fd_f25519_inv.runFrom E' 15 S = K) :
    fd_f25519_inv.runFrom E 12 S = K := by
  dsimp only [out13] at hO
  split_reads hL
  block_init
  step_pattern using runBodyFrom_mulRun with w
  step_pattern using runBodyFrom_r43SqrRun with v
  finish_block
  subst w v
  step_loop using loop_of_iter (iter16 r a T0 T1 (fd_r43x6_mul Y T2) S K) 24 1
  subst hS
  exact hK _ hArgs₀

/-- `^bb15`: `mul t1, t2, t1`, `sqr t1, t1` five times, `mul r, t1, t0`; stores at `r`, returns
`r`. -/
theorem bb15 (r a : Pointer) (T0 T1 Y : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.ptr] × GlobalState)) (E : ⟪Γ⟫) (hwf : S.WF) (hr : Room S.mem r 512)
    (hA : E.args = (args (.value r) (.value a)).get) (hL : live16 T0 T1 E) (hO : out16 E Y)
    (hK :
      .value
          (.cons (.value r) .nil,
            { S with
              mem :=
                S.mem.storeVec r
                  (fd_r43x6_mul (fd_r43x6_repsqr_mul2.sqrN 5 (fd_r43x6_mul Y T1)) T0) }) =
        K) :
    fd_f25519_inv.runFrom E 15 S = K := by
  dsimp only [out16] at hO
  split_reads hL
  block_init
  step_pattern using runBodyFrom_mulRun with w
  step_pattern using runBodyFrom_r43SqrRun with u1
  step_pattern using runBodyFrom_r43SqrRun with u2
  step_pattern using runBodyFrom_r43SqrRun with u3
  step_pattern using runBodyFrom_r43SqrRun with u4
  step_pattern using runBodyFrom_r43SqrRun with u5
  step_pattern using runBodyFrom_mulRun with v
  step_store
  finish_block
  rw [← hK, hS, MemoryState.storeVec]
  subst w u1 u2 u3 u4 u5 v
  rfl

/-- The chain's `t0 = a^11`. -/
def z11 (a : Wwl) : Wwl :=
  let t0 := fd_r43x6_sqr a
  let t1 := fd_r43x6_repsqr_mul2.sqrN 2 t0
  let t1 := fd_r43x6_mul a t1
  fd_r43x6_mul t0 t1

/-- The chain up to its first loop: `a^(2^5 - 1)`. -/
def chain5 (a : Wwl) : Wwl :=
  let t0 := fd_r43x6_sqr a
  let t1 := fd_r43x6_repsqr_mul2.sqrN 2 t0
  let t1 := fd_r43x6_mul a t1
  let t0 := fd_r43x6_mul t0 t1
  let t2 := fd_r43x6_sqr t0
  fd_r43x6_mul t1 t2

/-- `^bb0` past its load: `sqr t0, a` up to `mul t1, t1, t2`; `z11 A` in `%388`, `chain5 A` in
`%487`. -/
theorem bb0_head (r a : Pointer) (A : Wwl) (S : GlobalState)
    {g : ⟪Γ⟫ × GlobalState → PoisonOr (Vals [.ptr] × GlobalState)}
    {K : PoisonOr (Vals [.ptr] × GlobalState)} (E : ⟪Γ⟫)
    (hg :
      g = fun x =>
        @bind PoisonOr _ ((⟪Γ⟫ × ExitResult [.ptr] 18) × GlobalState) (Vals [.ptr] × GlobalState)
          (Exit.run blockParams x.1 bb0.exit x.2) fun y =>
          Func.continue (func := fd_f25519_inv) y.1.1 y.1.2 y.2)
    (hA : E.args = (args (.value r) (.value a)).get) (hL : Consts E)
    (hA' : E.read (rir_reg% hty 143) = Ty.wrap A)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value a)).get →
          Consts E' →
          E'.read (rir_reg% hty 388) = Ty.wrap (z11 A) →
          E'.read (rir_reg% hty 487) = Ty.wrap (chain5 A) →
          (bb0.runBodyFrom E' 488 S >>= g) = K) :
    (bb0.runBodyFrom E 144 S >>= g) = K := by
  subst hg
  split_reads hL
  -- `sqr t0, a`, `sqr t1, t0`, `sqr t1, t1`
  step_pattern using runBodyFrom_r43SqrRun with t0
  step_pattern using runBodyFrom_r43SqrRun with t1
  step_pattern using runBodyFrom_r43SqrRun with t1'
  -- `mul t1, a, t1`, `mul t0, t0, t1`, `sqr t2, t0`, `mul t1, t1, t2`
  step_pattern using runBodyFrom_mulRun with t1''
  step_pattern using runBodyFrom_mulRun with t0'
  step_pattern using runBodyFrom_r43SqrRun with t2
  step_pattern using runBodyFrom_mulRun with u
  have e : t0' = z11 A := by
    subst t0 t1 t1' t1'' t0'
    rfl
  have e' : u = chain5 A := by
    subst t0 t1 t1' t1'' t0' t2 u
    rfl
  subst e e' hS
  exact hK E hArgs (by env_reads) (by env_reads) (by env_reads)

/-- `^bb0` to its end: `sqr t2, t1; for( i=1; i<5; i++ ) sqr t2, t2` unrolled, `mul t1, t2, t1`
in `%774`, and the first `sqr t2, t1` of the next loop in `%821`. -/
theorem bb0_tail (r a : Pointer) (T0 U : Wwl) (S : GlobalState)
    {g : ⟪Γ⟫ × GlobalState → PoisonOr (Vals [.ptr] × GlobalState)}
    {K : PoisonOr (Vals [.ptr] × GlobalState)} (E : ⟪Γ⟫)
    (hg :
      g = fun x =>
        @bind PoisonOr _ ((⟪Γ⟫ × ExitResult [.ptr] 18) × GlobalState) (Vals [.ptr] × GlobalState)
          (Exit.run blockParams x.1 bb0.exit x.2) fun y =>
          Func.continue (func := fd_f25519_inv) y.1.1 y.1.2 y.2)
    (hA : E.args = (args (.value r) (.value a)).get) (hL : Consts E)
    (h388 : E.read (rir_reg% hty 388) = Ty.wrap T0) (hU : E.read (rir_reg% hty 487) = Ty.wrap U)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (.value r) (.value a)).get →
          Consts E' →
          E'.read (rir_reg% hty 388) = Ty.wrap T0 →
          E'.read (rir_reg% hty 774) =
              Ty.wrap (fd_r43x6_mul (fd_r43x6_repsqr_mul2.sqrN 5 U) U) →
          E'.read (rir_reg% hty 821) =
              Ty.wrap (fd_r43x6_sqr (fd_r43x6_mul (fd_r43x6_repsqr_mul2.sqrN 5 U) U)) →
          (bb0.runBodyFrom E' 822 S >>= g) = K) :
    (bb0.runBodyFrom E 488 S >>= g) = K := by
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
  exact hK E hArgs (by env_reads) (by env_reads) (by env_reads) (by env_reads)

/-- `fd_f25519_inv( r, a )` stores `spec` of the element at `a` at `r` and returns `r`; it loads
`a` before it stores, so `r` may be `a`. -/
public theorem _root_.Firedancer.Lane.Mlir.fd_f25519_inv.call_eq (r a : Pointer) (s : GlobalState)
    (hwf : s.WF) (hr : Room s.mem r 512) (ha : Fits s.mem a 512) :
    Firedancer.Lane.Mlir.fd_f25519_inv.call
        (Firedancer.Lane.Mlir.fd_f25519_inv.args (.value r) (.value a)) s =
      .value
        (.cons (.value r) .nil,
          { s with mem := s.mem.storeVec r (fd_f25519_inv.spec (s.mem.readVec a)) }) := by
  func_init
  block_init
  -- the constants, left inline: the runs read them as literals
  iterate 31 step_pure
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
  subst hv38 hv46 hv54 hv62 hv70 hv78 hv86 hv94 hv102 hv110 hv118 hv126 hv134 hv142
  refine bb0_head r a A S E rfl hArgs (by env_reads) (by env_reads) fun E hA hL h388 h487 => ?_
  refine bb0_tail r a _ _ S E rfl hA hL h388 h487 fun E hA hL h388 h774 h821 => ?_
  finish_block
  step_loop using loop_of_iter (iter2 r a _ _ _ S _) 4 1
  intro hL hO
  refine bb1 r a _ _ _ S _ E₀ hArgs₀ hL hO fun E hA hL hO => ?_
  refine bb4 r a _ _ _ _ S _ E hA hL hO fun E hA hL hO => ?_
  refine bb7 r a _ _ _ S _ E hA hL hO fun E hA hL hO => ?_
  refine bb9 r a _ _ _ S _ E hA hL hO fun E hA hL hO => ?_
  refine bb12 r a _ _ _ _ S _ E hA hL hO fun E hA hL hO => ?_
  refine bb15 r a _ _ _ S _ E hwf hr hA hL hO ?_
  subst hS hA
  delta fd_f25519_inv.spec z11 chain5
  rfl

end fd_f25519_inv

end Proof

end MLIR.Firedancer.Lane
