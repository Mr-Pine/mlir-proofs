module

public import Firedancer.Lane.Common.FieldPow
public import Firedancer.Lane.Common.R43x6
public import Firedancer.Lane.Mlir.fd_r43x6_invert
public import Firedancer.Lane.verify_x8.Tactics
public import MLIR.Run.Tactic
import Mathlib.Tactic.NormNum

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512 FieldPow

/-! ## Specification -/

@[expose] public section

/-- `fd_r43x6_invert( z )`'s `z^(p - 2)`: the addition chain, `fd_r43x6_repsqr_mul( x, y, n )` the
`n` folded squarings of `x`, then the product with `y`. -/
@[irreducible]
def fd_r43x6_invert.spec (z : Wwl) : Wwl :=
  let repsqr_mul := fd_r43x6_repsqr_mul2.spec
  let z2 := fd_r43x6_sqr z
  let z9 := repsqr_mul z2 z 2
  let z11 := repsqr_mul z9 z2 0
  let z2e5m1 := repsqr_mul z11 z9 1
  let z2e10m1 := repsqr_mul z2e5m1 z2e5m1 5
  let z2e20m1 := repsqr_mul z2e10m1 z2e10m1 10
  let z2e40m1 := repsqr_mul z2e20m1 z2e20m1 20
  let z2e50m1 := repsqr_mul z2e40m1 z2e10m1 10
  let z2e100m1 := repsqr_mul z2e50m1 z2e50m1 50
  let z2e200m1 := repsqr_mul z2e100m1 z2e100m1 100
  let z2e250m1 := repsqr_mul z2e200m1 z2e50m1 50
  repsqr_mul z2e250m1 z11 5

end

/-! ## Value -/

/-- `fd_r43x6_invert.spec` inverts an unreduced `fd_r43x6_t`, folded (`0⁻¹ = 0`). -/
public theorem fd_r43x6_invert.spec_val {z : Wwl} (hz : R43x6.Unreduced z) :
    R43x6.val (fd_r43x6_invert.spec z) = (R43x6.val z)⁻¹ ∧
      R43x6.Folded (fd_r43x6_invert.spec z) := by
  have h1 := Pw.self hz
  have z2 := h1.sqr
  have z9 := z2.repsqr_mul h1 2
  have z11 := z9.repsqr_mul z2 0
  have z2e5m1 := z11.repsqr_mul z9 1
  have z2e10m1 := z2e5m1.repsqr_mul z2e5m1 5
  have z2e20m1 := z2e10m1.repsqr_mul z2e10m1 10
  have z2e40m1 := z2e20m1.repsqr_mul z2e20m1 20
  have z2e50m1 := z2e40m1.repsqr_mul z2e10m1 10
  have z2e100m1 := z2e50m1.repsqr_mul z2e50m1 50
  have z2e200m1 := z2e100m1.repsqr_mul z2e100m1 100
  have z2e250m1 := z2e200m1.repsqr_mul z2e50m1 50
  obtain ⟨hv, hf⟩ := (z2e250m1.sqrN 5).mul_folded z11
  delta fd_r43x6_invert.spec
  refine ⟨hv.trans ?_, hf⟩
  rw [← pow_p_sub_two]
  norm_num

/-! ## Proof -/

section Proof

namespace fd_r43x6_invert

open Firedancer.Lane.Mlir Firedancer.Lane.Mlir.fd_r43x6_invert

/-- The entry block's constants the blocks after it read. -/
abbrev Consts (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%0 := .value 100#64, %1 := .value 50#64, %2 := .value 20#64,
    %3 := .value 18446744073709551614#64, %4 := .value 10#64, %5 := Ty.wrap foldK,
    %6 := Ty.wrap foldShifts, %7 := Ty.wrap foldMask, %8 := Ty.wrap (Vector.replicate 8 24),
    %9 := Ty.wrap (Vector.replicate 8 7), %10 := Ty.wrap #v[-1, -1, -1, -1, -1, -1, 0, 0],
    %18 := (Ty.vec 8 64).poisoned, %19 := Ty.wrap sqrDbl0, %20 := Ty.wrap sqrDbl2,
    %21 := Ty.wrap sqrDbl4, %22 := .value 0#64, %23 := Ty.wrap (Vector.replicate 8 0),
    %24 := Ty.wrap (Vector.replicate 8 9), %25 := Ty.wrap sqrMaskN1, %26 := Ty.wrap sqrMaskN2,
    %38 := lanesBelow 6 sqrMask1, %46 := lanesBelow 6 sqrMask2, %54 := lanesBelow 5 sqrMask1,
    %62 := lanesBelow 5 sqrMask2, %70 := lanesFrom 7 wwl_zero, %78 := lanesBelow 5 wwl_zero,
    %86 := lanesFrom 6 wwl_zero, %94 := lanesFrom 5 wwl_zero, %102 := lanesBelow 3 wwl_zero,
    %110 := lanesFrom 4 wwl_zero, %118 := lanesBelow 2 wwl_zero, %126 := lanesFrom 3 wwl_zero,
    %134 := lanesBelow 1 wwl_zero, %142 := lanesFrom 2 wwl_zero]

section Loops

variable (z : Wwl) (k ex : Fin 13) (hdr : ⟪Γ⟫ → Wwl → Nat → ⟪Γ⟫) (Live : ⟪Γ⟫ → Prop)
  (Out : ⟪Γ⟫ → Wwl → Prop) (S : GlobalState) (K : PoisonOr (Vals [.vec 8 64] × GlobalState))

/-- One pass of the loop at `k` (env `hdr E x c` at counter `c = 2 (m + 1)`; `Live` what it and
the blocks after it read): two squarings, `c - 2`, the test `c - 2 == 0`; on to `ex` with the
squares in `Out`, else around. -/
abbrev LoopIter : Prop :=
  ∀ m (x : Wwl) (E : ⟪Γ⟫),
    E.args = (args (Ty.wrap z)).get →
      Live E →
      m < 2 ^ 61 →
      (m = 0 →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (Ty.wrap z)).get →
            Live E' →
            Out E' (fd_r43x6_sqr (fd_r43x6_sqr x)) → fd_r43x6_invert.runFrom E' ex S = K) →
      (0 < m →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (Ty.wrap z)).get →
            Live E' →
            fd_r43x6_invert.runFrom (hdr E' (fd_r43x6_sqr (fd_r43x6_sqr x)) (2 * m)) k S = K) →
      fd_r43x6_invert.runFrom (hdr E x (2 * (m + 1))) k S = K

/-- The loop at `k` from counter `2 (m + 1)`: `x` squared `2 (m + 1)` times. -/
abbrev Loop : Prop :=
  ∀ m (x : Wwl) (E : ⟪Γ⟫),
    E.args = (args (Ty.wrap z)).get →
      Live E →
      m < 2 ^ 61 →
      (∀ E' : ⟪Γ⟫,
        E'.args = (args (Ty.wrap z)).get →
          Live E' →
          Out E' (fd_r43x6_repsqr_mul2.sqrN (2 * (m + 1)) x) →
            fd_r43x6_invert.runFrom E' ex S = K) →
      fd_r43x6_invert.runFrom (hdr E x (2 * (m + 1))) k S = K

variable {z k ex hdr Live Out S K} in
/-- The loop from one pass, by induction on the passes left. -/
theorem loop_of_iter (h : LoopIter z k ex hdr Live Out S K) : Loop z k ex hdr Live Out S K := by
  intro m
  induction m with
  | zero =>
    intro x E hA hL hm hK
    exact h 0 x E hA hL hm (fun _ => hK) (by omega)
  | succ m ih =>
    intro x E hA hL hm hK
    refine h (m + 1) x E hA hL hm (by omega) fun _ E' hA' hL' => ih _ E' hA' hL' (by omega) ?_
    intro E'' hA'' hL'' hO
    rw [show 2 * (m + 1 + 1) = 2 * (m + 1) + 2 by omega, sqrN_add_two'] at hK
    exact hK E'' hA'' hL'' hO

end Loops

set_option hygiene false in
/-- A pass of a squaring loop (`LoopIter`): two squarings, count down, test; out or around. -/
local macro "iter_proof" : tactic =>
  `(tactic|
    ( intro m x E hA hL hm hexit hback
      split_reads hL
      block_init
      step_pattern using runBodyFrom_r43SqrRun with y
      step_pattern using runBodyFrom_r43SqrRun with y'
      step_pure [dec2_nsw hm, dec2_eq]
      step_pure
      finish_block
      · step_loop using hexit (dec2_zero hm hbr)
      · step_loop using hback (dec2_pos hbr)))

/-- `^bb1`'s env: `x` and the counter `c`. -/
abbrev hdr1 (E : ⟪Γ⟫) (x : Wwl) (c : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 774 := Ty.wrap x, rir_dst% hty 775 := PoisonOr.value (BitVec.ofNat 64 c)]

/-- What `^bb1` and the blocks after it read: the constants, `%387` `%773`. -/
abbrev live1 (Z11 T : Wwl) (E : ⟪Γ⟫) : Prop :=
  Consts E ∧ E ⊨ [rir_reg% hty 387 := Ty.wrap Z11, rir_reg% hty 773 := Ty.wrap T]

/-- `^bb1`'s squares, as `^bb2` reads them. -/
abbrev out1 (E : ⟪Γ⟫) (y : Wwl) : Prop :=
  E ⊨ [rir_reg% hty 869 := Ty.wrap y]

/-- `^bb1`: a pass of `z2e20m1`'s 10 squarings of `z2e10m1`. -/
theorem iter1 (z Z11 T : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.vec 8 64] × GlobalState)) :
    LoopIter z 1 2 hdr1 (live1 Z11 T) out1 S K := by
  iter_proof

/-- `^bb3`'s env: `x` and the counter `c`. -/
abbrev hdr3 (E : ⟪Γ⟫) (x : Wwl) (c : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 924 := Ty.wrap x, rir_dst% hty 925 := PoisonOr.value (BitVec.ofNat 64 c)]

/-- What `^bb3` and the blocks after it read: the constants, `%387` `%773` `%923`. -/
abbrev live3 (Z11 T U : Wwl) (E : ⟪Γ⟫) : Prop :=
  Consts E ∧ E ⊨ [rir_reg% hty 387 := Ty.wrap Z11, rir_reg% hty 773 := Ty.wrap T,
    rir_reg% hty 923 := Ty.wrap U]

/-- `^bb3`'s squares, as `^bb4` reads them. -/
abbrev out3 (E : ⟪Γ⟫) (y : Wwl) : Prop :=
  E ⊨ [rir_reg% hty 1019 := Ty.wrap y]

/-- `^bb3`: a pass of `z2e40m1`'s 20 squarings of `z2e20m1`. -/
theorem iter3 (z Z11 T U : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.vec 8 64] × GlobalState)) :
    LoopIter z 3 4 hdr3 (live3 Z11 T U) out3 S K := by
  iter_proof

/-- `^bb5`'s env: `x` and the counter `c`. -/
abbrev hdr5 (E : ⟪Γ⟫) (x : Wwl) (c : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 1074 := Ty.wrap x, rir_dst% hty 1075 := PoisonOr.value (BitVec.ofNat 64 c)]

/-- What `^bb5` and the blocks after it read: the constants, `%387` `%773`. -/
abbrev live5 (Z11 T : Wwl) (E : ⟪Γ⟫) : Prop :=
  Consts E ∧ E ⊨ [rir_reg% hty 387 := Ty.wrap Z11, rir_reg% hty 773 := Ty.wrap T]

/-- `^bb5`'s squares, as `^bb6` reads them. -/
abbrev out5 (E : ⟪Γ⟫) (y : Wwl) : Prop :=
  E ⊨ [rir_reg% hty 1169 := Ty.wrap y]

/-- `^bb5`: a pass of `z2e50m1`'s 10 squarings of `z2e40m1`. -/
theorem iter5 (z Z11 T : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.vec 8 64] × GlobalState)) :
    LoopIter z 5 6 hdr5 (live5 Z11 T) out5 S K := by
  iter_proof

/-- `^bb7`'s env: `x` and the counter `c`. -/
abbrev hdr7 (E : ⟪Γ⟫) (x : Wwl) (c : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 1224 := Ty.wrap x, rir_dst% hty 1225 := PoisonOr.value (BitVec.ofNat 64 c)]

/-- What `^bb7` and the blocks after it read: the constants, `%387` `%1223`. -/
abbrev live7 (Z11 T : Wwl) (E : ⟪Γ⟫) : Prop :=
  Consts E ∧ E ⊨ [rir_reg% hty 387 := Ty.wrap Z11, rir_reg% hty 1223 := Ty.wrap T]

/-- `^bb7`'s squares, as `^bb8` reads them. -/
abbrev out7 (E : ⟪Γ⟫) (y : Wwl) : Prop :=
  E ⊨ [rir_reg% hty 1319 := Ty.wrap y]

/-- `^bb7`: a pass of `z2e100m1`'s 50 squarings of `z2e50m1`. -/
theorem iter7 (z Z11 T : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.vec 8 64] × GlobalState)) :
    LoopIter z 7 8 hdr7 (live7 Z11 T) out7 S K := by
  iter_proof

/-- `^bb9`'s env: `x` and the counter `c`. -/
abbrev hdr9 (E : ⟪Γ⟫) (x : Wwl) (c : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 1374 := Ty.wrap x, rir_dst% hty 1375 := PoisonOr.value (BitVec.ofNat 64 c)]

/-- What `^bb9` and the blocks after it read: the constants, `%387` `%1223` `%1373`. -/
abbrev live9 (Z11 T U : Wwl) (E : ⟪Γ⟫) : Prop :=
  Consts E ∧ E ⊨ [rir_reg% hty 387 := Ty.wrap Z11, rir_reg% hty 1223 := Ty.wrap T,
    rir_reg% hty 1373 := Ty.wrap U]

/-- `^bb9`'s squares, as `^bb10` reads them. -/
abbrev out9 (E : ⟪Γ⟫) (y : Wwl) : Prop :=
  E ⊨ [rir_reg% hty 1469 := Ty.wrap y]

/-- `^bb9`: a pass of `z2e200m1`'s 100 squarings of `z2e100m1`. -/
theorem iter9 (z Z11 T U : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.vec 8 64] × GlobalState)) :
    LoopIter z 9 10 hdr9 (live9 Z11 T U) out9 S K := by
  iter_proof

/-- `^bb11`'s env: `x` and the counter `c`. -/
abbrev hdr11 (E : ⟪Γ⟫) (x : Wwl) (c : Nat) : ⟪Γ⟫ :=
  E[rir_dst% hty 1524 := Ty.wrap x, rir_dst% hty 1525 := PoisonOr.value (BitVec.ofNat 64 c)]

/-- What `^bb11` and the blocks after it read: the constants, `%387` `%1223`. -/
abbrev live11 (Z11 T : Wwl) (E : ⟪Γ⟫) : Prop :=
  Consts E ∧ E ⊨ [rir_reg% hty 387 := Ty.wrap Z11, rir_reg% hty 1223 := Ty.wrap T]

/-- `^bb11`'s squares, as `^bb12` reads them. -/
abbrev out11 (E : ⟪Γ⟫) (y : Wwl) : Prop :=
  E ⊨ [rir_reg% hty 1619 := Ty.wrap y]

/-- `^bb11`: a pass of `z2e250m1`'s 50 squarings of `z2e200m1`. -/
theorem iter11 (z Z11 T : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.vec 8 64] × GlobalState)) :
    LoopIter z 11 12 hdr11 (live11 Z11 T) out11 S K := by
  iter_proof

/-- `z^11`. -/
def z11 (z : Wwl) : Wwl :=
  let z2 := fd_r43x6_sqr z
  let z9 := fd_r43x6_repsqr_mul2.spec z2 z 2
  fd_r43x6_repsqr_mul2.spec z9 z2 0

/-- `z^(2^5 - 1)`. -/
def z2e5m1 (z : Wwl) : Wwl :=
  let z2 := fd_r43x6_sqr z
  let z9 := fd_r43x6_repsqr_mul2.spec z2 z 2
  let z11 := fd_r43x6_repsqr_mul2.spec z9 z2 0
  fd_r43x6_repsqr_mul2.spec z11 z9 1

/-- `^bb0` past its constants: `z2` up to `z2e5m1`, `z11 z` in `%387`, `z2e5m1 z` in `%486`. -/
theorem bb0_head (z : Wwl) (S : GlobalState)
    {g : ⟪Γ⟫ × GlobalState → PoisonOr (Vals [.vec 8 64] × GlobalState)}
    {K : PoisonOr (Vals [.vec 8 64] × GlobalState)} (E : ⟪Γ⟫)
    (hg :
      g = fun x =>
        @bind PoisonOr _ ((⟪Γ⟫ × ExitResult [.vec 8 64] 13) × GlobalState)
          (Vals [.vec 8 64] × GlobalState) (Exit.run blockParams x.1 bb0.exit x.2) fun y =>
          Func.continue (func := fd_r43x6_invert) y.1.1 y.1.2 y.2)
    (hA : E.args = (args (Ty.wrap z)).get) (hL : Consts E)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (Ty.wrap z)).get →
          Consts E' →
          E'.read (rir_reg% hty 387) = Ty.wrap (z11 z) →
          E'.read (rir_reg% hty 486) = Ty.wrap (z2e5m1 z) →
          (bb0.runBodyFrom E' 487 S >>= g) = K) :
    (bb0.runBodyFrom E 143 S >>= g) = K := by
  subst hg
  split_reads hL
  -- `z2 = fd_r43x6_sqr( z )`, `z9 = fd_r43x6_repsqr_mul( z2, z, 2UL )`
  step_pattern using runBodyFrom_sqrRunA with z2
  step_pattern using runBodyFrom_r43SqrRun with u1
  step_pattern using runBodyFrom_r43SqrRun with u2
  step_pattern using runBodyFrom_mulRunA with z9
  -- `z11 = fd_r43x6_repsqr_mul( z9, z2, 0UL )`, `z2e5m1 = fd_r43x6_repsqr_mul( z11, z9, 1UL )`
  step_pattern using runBodyFrom_mulRun with v11
  step_pattern using runBodyFrom_r43SqrRun with u3
  step_pattern using runBodyFrom_mulRun with v31
  have e : v11 = z11 z := by
    subst z2 u1 u2 z9 v11
    rfl
  have e' : v31 = z2e5m1 z := by
    subst z2 u1 u2 z9 v11 u3 v31
    rfl
  subst e e' hS
  exact hK E hArgs (by env_reads) (by env_reads) (by env_reads)

/-- `^bb0` to its end: `z2e10m1 = fd_r43x6_repsqr_mul( z2e5m1, z2e5m1, 5UL )` in `%773`. -/
theorem bb0_tail (z Z11 U : Wwl) (S : GlobalState)
    {g : ⟪Γ⟫ × GlobalState → PoisonOr (Vals [.vec 8 64] × GlobalState)}
    {K : PoisonOr (Vals [.vec 8 64] × GlobalState)} (E : ⟪Γ⟫)
    (hg :
      g = fun x =>
        @bind PoisonOr _ ((⟪Γ⟫ × ExitResult [.vec 8 64] 13) × GlobalState)
          (Vals [.vec 8 64] × GlobalState) (Exit.run blockParams x.1 bb0.exit x.2) fun y =>
          Func.continue (func := fd_r43x6_invert) y.1.1 y.1.2 y.2)
    (hA : E.args = (args (Ty.wrap z)).get) (hL : Consts E)
    (h387 : E.read (rir_reg% hty 387) = Ty.wrap Z11) (hU : E.read (rir_reg% hty 486) = Ty.wrap U)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (Ty.wrap z)).get →
          Consts E' →
          E'.read (rir_reg% hty 387) = Ty.wrap Z11 →
          E'.read (rir_reg% hty 773) =
              Ty.wrap (fd_r43x6_mul (fd_r43x6_repsqr_mul2.sqrN 5 U) U) →
          (bb0.runBodyFrom E' 774 S >>= g) = K) :
    (bb0.runBodyFrom E 487 S >>= g) = K := by
  subst hg
  split_reads hL
  step_pattern using runBodyFrom_r43SqrRun with u1
  step_pattern using runBodyFrom_r43SqrRun with u2
  step_pattern using runBodyFrom_r43SqrRun with u3
  step_pattern using runBodyFrom_r43SqrRun with u4
  step_pattern using runBodyFrom_r43SqrRun with u5
  step_pattern using runBodyFrom_mulRun with v
  have e : v = fd_r43x6_mul (fd_r43x6_repsqr_mul2.sqrN 5 U) U := by
    subst u1 u2 u3 u4 u5 v
    rfl
  subst e hS
  exact hK E hArgs (by env_reads) (by env_reads) (by env_reads)

/-- `^bb2`: `z2e20m1`'s product by `z2e10m1`, then `z2e40m1`'s loop. -/
theorem bb2 (z Z11 T Y : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.vec 8 64] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (Ty.wrap z)).get) (hL : live1 Z11 T E) (hO : out1 E Y)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (Ty.wrap z)).get →
          live3 Z11 T (fd_r43x6_mul Y T) E' →
          out3 E' (fd_r43x6_repsqr_mul2.sqrN 20 (fd_r43x6_mul Y T)) →
          fd_r43x6_invert.runFrom E' 4 S = K) :
    fd_r43x6_invert.runFrom E 2 S = K := by
  dsimp only [out1] at hO
  split_reads hL
  block_init
  step_pattern using runBodyFrom_mulRun with w
  finish_block
  subst w
  step_loop using loop_of_iter (iter3 z Z11 T (fd_r43x6_mul Y T) S K) 9 _
  subst hS
  exact hK _ hArgs₀

/-- `^bb4`: `z2e40m1`'s product by `z2e20m1`, then `z2e50m1`'s loop. -/
theorem bb4 (z Z11 T U Y : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.vec 8 64] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (Ty.wrap z)).get) (hL : live3 Z11 T U E) (hO : out3 E Y)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (Ty.wrap z)).get →
          live5 Z11 T E' →
          out5 E' (fd_r43x6_repsqr_mul2.sqrN 10 (fd_r43x6_mul Y U)) →
          fd_r43x6_invert.runFrom E' 6 S = K) :
    fd_r43x6_invert.runFrom E 4 S = K := by
  dsimp only [out3] at hO
  split_reads hL
  block_init
  step_pattern using runBodyFrom_mulRun with w
  finish_block
  subst w
  step_loop using loop_of_iter (iter5 z Z11 T S K) 4 _
  subst hS
  exact hK _ hArgs₀

/-- `^bb6`: `z2e50m1`'s product by `z2e10m1`, then `z2e100m1`'s loop. -/
theorem bb6 (z Z11 T Y : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.vec 8 64] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (Ty.wrap z)).get) (hL : live5 Z11 T E) (hO : out5 E Y)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (Ty.wrap z)).get →
          live7 Z11 (fd_r43x6_mul Y T) E' →
          out7 E' (fd_r43x6_repsqr_mul2.sqrN 50 (fd_r43x6_mul Y T)) →
          fd_r43x6_invert.runFrom E' 8 S = K) :
    fd_r43x6_invert.runFrom E 6 S = K := by
  dsimp only [out5] at hO
  split_reads hL
  block_init
  step_pattern using runBodyFrom_mulRun with w
  finish_block
  subst w
  step_loop using loop_of_iter (iter7 z Z11 (fd_r43x6_mul Y T) S K) 24 _
  subst hS
  exact hK _ hArgs₀

/-- `^bb8`: `z2e100m1`'s product by `z2e50m1`, then `z2e200m1`'s loop. -/
theorem bb8 (z Z11 T Y : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.vec 8 64] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (Ty.wrap z)).get) (hL : live7 Z11 T E) (hO : out7 E Y)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (Ty.wrap z)).get →
          live9 Z11 T (fd_r43x6_mul Y T) E' →
          out9 E' (fd_r43x6_repsqr_mul2.sqrN 100 (fd_r43x6_mul Y T)) →
          fd_r43x6_invert.runFrom E' 10 S = K) :
    fd_r43x6_invert.runFrom E 8 S = K := by
  dsimp only [out7] at hO
  split_reads hL
  block_init
  step_pattern using runBodyFrom_mulRun with w
  finish_block
  subst w
  step_loop using loop_of_iter (iter9 z Z11 T (fd_r43x6_mul Y T) S K) 49 _
  subst hS
  exact hK _ hArgs₀

/-- `^bb10`: `z2e200m1`'s product by `z2e100m1`, then `z2e250m1`'s loop. -/
theorem bb10 (z Z11 T U Y : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.vec 8 64] × GlobalState)) (E : ⟪Γ⟫)
    (hA : E.args = (args (Ty.wrap z)).get) (hL : live9 Z11 T U E) (hO : out9 E Y)
    (hK :
      ∀ E' : ⟪Γ⟫,
        E'.args = (args (Ty.wrap z)).get →
          live11 Z11 T E' →
          out11 E' (fd_r43x6_repsqr_mul2.sqrN 50 (fd_r43x6_mul Y U)) →
          fd_r43x6_invert.runFrom E' 12 S = K) :
    fd_r43x6_invert.runFrom E 10 S = K := by
  dsimp only [out9] at hO
  split_reads hL
  block_init
  step_pattern using runBodyFrom_mulRun with w
  finish_block
  subst w
  step_loop using loop_of_iter (iter11 z Z11 T S K) 24 _
  subst hS
  exact hK _ hArgs₀

/-- `^bb12`: `z2e250m1`'s product by `z2e50m1`, then `fd_r43x6_repsqr_mul( z2e250m1, z11, 5UL )`
returned. -/
theorem bb12 (z Z11 T Y : Wwl) (S : GlobalState)
    (K : PoisonOr (Vals [.vec 8 64] × GlobalState)) (E : ⟪Γ⟫) (hwf : S.WF)
    (hA : E.args = (args (Ty.wrap z)).get) (hL : live11 Z11 T E) (hO : out11 E Y)
    (hK :
      .value
          (.cons
              (Ty.wrap
                (fd_r43x6_mul (fd_r43x6_repsqr_mul2.sqrN 5 (fd_r43x6_mul Y T)) Z11))
              .nil,
            S) =
        K) :
    fd_r43x6_invert.runFrom E 12 S = K := by
  dsimp only [out11] at hO
  split_reads hL
  block_init
  step_pattern using runBodyFrom_mulRun with w
  step_pattern using runBodyFrom_r43SqrRun with u1
  step_pattern using runBodyFrom_r43SqrRun with u2
  step_pattern using runBodyFrom_r43SqrRun with u3
  step_pattern using runBodyFrom_r43SqrRun with u4
  step_pattern using runBodyFrom_r43SqrRun with u5
  step_pattern using runBodyFrom_mulRun with v
  finish_block
  rw [← hK, hS]
  subst w u1 u2 u3 u4 u5 v
  rfl

/-- `fd_r43x6_invert( z )` returns `spec z` and leaves the state as it is. -/
public theorem _root_.Firedancer.Lane.Mlir.fd_r43x6_invert.call_eq (z : Wwl) (s : GlobalState)
    (hwf : s.WF) :
    Firedancer.Lane.Mlir.fd_r43x6_invert.call
        (Firedancer.Lane.Mlir.fd_r43x6_invert.args (Ty.wrap z)) s =
      .value (.cons (Ty.wrap (fd_r43x6_invert.spec z)) .nil, s) := by
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
  subst hv38 hv46 hv54 hv62 hv70 hv78 hv86 hv94 hv102 hv110 hv118 hv126 hv134 hv142
  refine bb0_head z S E rfl hArgs (by env_reads) fun E hA hL h387 h486 => ?_
  refine bb0_tail z _ _ S E rfl hA hL h387 h486 fun E hA hL h387 h773 => ?_
  finish_block
  step_loop using loop_of_iter (iter1 z _ _ S _) 4 _
  intro hL hO
  refine bb2 z _ _ _ S _ E₀ hArgs₀ hL hO fun E hA hL hO => ?_
  refine bb4 z _ _ _ _ S _ E hA hL hO fun E hA hL hO => ?_
  refine bb6 z _ _ _ S _ E hA hL hO fun E hA hL hO => ?_
  refine bb8 z _ _ _ S _ E hA hL hO fun E hA hL hO => ?_
  refine bb10 z _ _ _ _ S _ E hA hL hO fun E hA hL hO => ?_
  refine bb12 z _ _ _ S _ E hwf hA hL hO ?_
  subst hS
  delta fd_r43x6_invert.spec z11 z2e5m1
  rfl

end fd_r43x6_invert

end Proof

end MLIR.Firedancer.Lane
