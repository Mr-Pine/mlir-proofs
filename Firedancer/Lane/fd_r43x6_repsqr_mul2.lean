module

public import Firedancer.Avx512.fd_r43x6_repsqr_mul2
public import Firedancer.Lane.Common.R43x6
public import Firedancer.Lane.Mlir.fd_r43x6_repsqr_mul2
public import MLIR.Run.Tactic

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Proof -/

section Proof

namespace fd_r43x6_repsqr_mul2

/-- The entry block's constants the loop and the exit read: the fold's, `fd_r43x6_sqr_fast`'s and
`fd_r43x6_mul_fast`'s, the counter's `0` and `-1`. -/
abbrev Consts (E : ⟪Firedancer.Lane.Mlir.fd_r43x6_repsqr_mul2.Γ⟫) : Prop :=
  E ⊨ [%0 := Ty.wrap foldK, %1 := Ty.wrap foldShifts, %2 := Ty.wrap foldMask, %3 :=
    Ty.wrap (Vector.replicate 8 24), %4 := Ty.wrap (Vector.replicate 8 7), %5 :=
    Ty.wrap #v[-1, -1, -1, -1, -1, -1, 0, 0], %13 := .value 0#64, %15 := Ty.wrap sqrDbl0, %16 :=
    Ty.wrap sqrDbl2, %17 := Ty.wrap sqrDbl4, %18 := Ty.wrap (Vector.replicate 8 0), %19 :=
    Ty.wrap (Vector.replicate 8 9), %20 := Ty.wrap sqrMaskN1, %21 := Ty.wrap sqrMaskN2, %23 :=
    .value 18446744073709551615#64, %33 := lanesBelow 6 sqrMask1, %41 := lanesBelow 6 sqrMask2,
    %49 := lanesBelow 5 sqrMask1, %57 := lanesBelow 5 sqrMask2, %65 := lanesFrom 7 wwl_zero, %73 :=
    lanesBelow 5 wwl_zero, %81 := lanesFrom 6 wwl_zero, %89 := lanesFrom 5 wwl_zero, %97 :=
    lanesBelow 3 wwl_zero, %105 := lanesFrom 4 wwl_zero, %113 := lanesBelow 2 wwl_zero, %121 :=
    lanesFrom 3 wwl_zero, %129 := lanesBelow 1 wwl_zero, %137 := lanesFrom 2 wwl_zero]

/-- `^bb1`'s env: the loop's `xa xb` and its counter `k`. -/
abbrev hdr (E : ⟪Firedancer.Lane.Mlir.fd_r43x6_repsqr_mul2.Γ⟫) (k : Nat) (xa xb : Wwl) :
    ⟪Firedancer.Lane.Mlir.fd_r43x6_repsqr_mul2.Γ⟫ :=
  E[%139 := xa, %140 := xb, %141 := BitVec.ofNat 64 k]

/-- `^bb2`'s env: the squarings `xa xb` in `%239 %238`. -/
abbrev exit (E : ⟪Firedancer.Lane.Mlir.fd_r43x6_repsqr_mul2.Γ⟫) (xa xb : Wwl) :
    ⟪Firedancer.Lane.Mlir.fd_r43x6_repsqr_mul2.Γ⟫ :=
  E[%238 := xb, %239 := xa]

/-- `^bb2`, `FD_R43X6_MUL2_INL` on `xa xb`: stores `fd_r43x6_mul xa ya` at `za`, then
`fd_r43x6_mul xb yb` at `zb`. -/
theorem bb2 (za zb : Pointer) (xa0 ya xb0 yb : Wwl) (n : BitVec 64) (xa xb : Wwl) (S : GlobalState)
    (hwf : S.WF) (hza : Room S.mem za 512) (hzb : Room S.mem zb 512)
    (K : PoisonOr (Vals [] × GlobalState)) (E : ⟪Firedancer.Lane.Mlir.fd_r43x6_repsqr_mul2.Γ⟫)
    (hArgs :
      E.args =
        (Firedancer.Lane.Mlir.fd_r43x6_repsqr_mul2.args (.value za) (Ty.wrap xa0) (Ty.wrap ya)
            (.value zb) (Ty.wrap xb0) (Ty.wrap yb) (.value n)).get)
    (hC : Consts E)
    (hK :
      .value
          (.nil,
            { S with
              mem := (S.mem.storeVec za (fd_r43x6_mul xa ya)).storeVec zb (fd_r43x6_mul xb yb) }) =
        K) :
    Firedancer.Lane.Mlir.fd_r43x6_repsqr_mul2.runFrom (exit E xa xb) 2 S = K := by
  obtain
    ⟨hc0, hc1, hc2, hc3, hc4, hc5, hc13, hc15, hc16, hc17, hc18, hc19, hc20, hc21, hc23, hc33, hc41,
      hc49, hc57, hc65, hc73, hc81, hc89, hc97, hc105, hc113, hc121, hc129, hc137⟩ :=
    hC
  block_init
  step_pattern using runBodyFrom_mulRunA with za'
  step_pattern using runBodyFrom_mulRunA with zb'
  step_store
  step_store
  finish_block
  subst_vars
  rfl

/-- The counter's `n - 1` (`add nsw n, -1`) does not overflow. -/
theorem dec_nsw (k : Nat) (h0 : 0 < k) (h : k < 2 ^ 63) :
    ¬(BitVec.ofNat 64 k).saddOverflow (18446744073709551615#64) := by
  have hx : (BitVec.ofNat 64 k).toInt = k := by
    rw [BitVec.toInt_eq_toNat_of_lt] <;> simp [BitVec.toNat_ofNat] <;> omega
  have hm : (18446744073709551615#64).toInt = -1 := by decide
  simp only [BitVec.saddOverflow, hx, hm]
  simp
  omega

/-- The counter's `n - 1`. -/
theorem dec_eq (k : Nat) (h0 : 0 < k) (h : k < 2 ^ 63) :
    BitVec.ofNat 64 k + 18446744073709551615#64 = BitVec.ofNat 64 (k - 1) := by
  apply BitVec.eq_of_toNat_eq
  rw [show (18446744073709551615#64) = -1#64 from rfl, BitVec.toNat_add, BitVec.toNat_ofNat,
    BitVec.toNat_ofNat, BitVec.toNat_neg, BitVec.toNat_ofNat]
  omega

/-- The loop from `^bb1` with counter `k`: `k` squarings of `xa xb`, then `^bb2`. -/
theorem loop (za zb : Pointer) (xa0 ya xb0 yb : Wwl) (n : BitVec 64) (S : GlobalState) (hwf : S.WF)
    (hza : Room S.mem za 512) (hzb : Room S.mem zb 512) (K : PoisonOr (Vals [] × GlobalState)) :
    ∀ k (xa xb : Wwl) (E : ⟪Firedancer.Lane.Mlir.fd_r43x6_repsqr_mul2.Γ⟫),
      E.args =
          (Firedancer.Lane.Mlir.fd_r43x6_repsqr_mul2.args (.value za) (Ty.wrap xa0) (Ty.wrap ya)
              (.value zb) (Ty.wrap xb0) (Ty.wrap yb) (.value n)).get →
        Consts E →
        0 < k →
        k < 2 ^ 63 →
        .value
            (.nil,
              { S with
                mem :=
                  (S.mem.storeVec za
                        (fd_r43x6_mul (Avx512.fd_r43x6_repsqr_mul2.sqrN k xa) ya)).storeVec
                    zb (fd_r43x6_mul (Avx512.fd_r43x6_repsqr_mul2.sqrN k xb) yb) }) =
          K →
        Firedancer.Lane.Mlir.fd_r43x6_repsqr_mul2.runFrom (hdr E k xa xb) 1 S = K := by
  intro k
  induction k with
  | zero =>
    intros
    omega
  | succ k ih =>
    intro xa xb E hArgs hC h0 h hK
    obtain
      ⟨hc0, hc1, hc2, hc3, hc4, hc5, hc13, hc15, hc16, hc17, hc18, hc19, hc20, hc21, hc23, hc33,
        hc41, hc49, hc57, hc65, hc73, hc81, hc89, hc97, hc105, hc113, hc121, hc129, hc137⟩ :=
      hC
    block_init
    step_pattern using runBodyFrom_sqrRun with xa'
    step_pattern using runBodyFrom_sqrRun with xb'
    step_pure [dec_nsw (k + 1) h0 h, dec_eq (k + 1) h0 h]
    step_pure
    finish_block
    · -- exit, after the last iteration
      obtain rfl : k = 0 := by
        simp [BitVec.toNat_eq] at hbr
        omega
      step_loop using bb2 za zb xa0 ya xb0 yb n xa' xb'
      subst_vars
      rfl
    · -- back to the header, one iteration fewer
      step_loop using ih xa' xb'
      · simp [BitVec.toNat_eq] at hbr
        omega
      subst_vars
      rfl

/-- `repsqr_mul2` stores `spec xa ya n` at `za`, then `spec xb yb n` at `zb`. -/
public theorem call_eq (za zb : Pointer) (xa ya xb yb : Wwl) (n : BitVec 64) (s : GlobalState)
    (hn : n.toNat < 2 ^ 63) (hwf : s.WF) (hza : Room s.mem za 512) (hzb : Room s.mem zb 512) :
    Firedancer.Lane.Mlir.fd_r43x6_repsqr_mul2.call
        (Firedancer.Lane.Mlir.fd_r43x6_repsqr_mul2.args (.value za) (Ty.wrap xa) (Ty.wrap ya)
          (.value zb) (Ty.wrap xb) (Ty.wrap yb) (.value n))
        s =
      .value
        (.nil,
          { s with
            mem :=
              (s.mem.storeVec za (Avx512.fd_r43x6_repsqr_mul2.spec xa ya n.toNat)).storeVec zb
                (Avx512.fd_r43x6_repsqr_mul2.spec xb yb n.toNat) }) := by
  func_init
  block_init
  iterate 26 step_pure
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
  step_pure
  finish_block
  case isTrue =>
    -- `n = 0`: `^bb2`, `FD_R43X6_MUL2_INL`
    step_loop using bb2 za zb xa ya xb yb n xa xb
    subst hbr
    rfl
  case isFalse =>
    -- `^bb1`: the squaring loop, `n` times
    step_loop using loop za zb xa ya xb yb n _ _ _ _ _ n.toNat xa xb
    · simp [BitVec.toNat_eq] at hbr
      omega
    rfl

end fd_r43x6_repsqr_mul2

end Proof

end MLIR.Firedancer.Lane
