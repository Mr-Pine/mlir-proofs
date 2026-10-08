module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.Avx512.fd_r43x6_sqr_fast
public import Firedancer.Avx512.fd_r43x6_mul_fast
public import Firedancer.Avx512.Mlir.fd_r43x6_repsqr_mul2

namespace LeanMLIR.RIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `for( ; n; n-- ) FD_R43X6_SQR1_INL( x, x )`: `n` folded squarings. -/
def fd_r43x6_repsqr_mul2.sqrN : Nat → Wwl → Wwl
  | 0, x => x
  | n + 1, x => fd_r43x6_repsqr_mul2.sqrN n (fd_r43x6_sqr x)

/-- `fd_r43x6_repsqr_mul(x, y, n)`, each side of `fd_r43x6_repsqr_mul2`: `x` squared `n` times,
then `FD_R43X6_MUL1_INL( x, x, y )`. -/
def fd_r43x6_repsqr_mul2.spec (x y : Wwl) (n : Nat) : Wwl :=
  let x := fd_r43x6_repsqr_mul2.sqrN n x
  fd_r43x6_mul x y

end

/-! ## Proof -/

section Proof

/-- `^bb1`'s env: the constants, the loop's `xa xb` and its counter `k`. -/
abbrev fd_r43x6_repsqr_mul2.hdr (E : ⟪fd_r43x6_repsqr_mul2.Γ⟫) (k : Nat)
    (xa xb : Vector (BitVec 64) 8) : ⟪fd_r43x6_repsqr_mul2.Γ⟫ :=
  E[%0 := 18446744073709551615#64, %1 := foldK, %2 := 0#64, %3 := foldMask, %4 := foldShifts, %5 :=
    (Ty.vec 8 64).poisoned, %7 := xa, %8 := xb, %9 := BitVec.ofNat 64 k]

/-- `^bb2`'s env on leaving the loop: the constants, and the squarings `xa xb` in `%23 %22`. -/
abbrev fd_r43x6_repsqr_mul2.exit (E : ⟪fd_r43x6_repsqr_mul2.Γ⟫) (xa xb : Vector (BitVec 64) 8) :
    ⟪fd_r43x6_repsqr_mul2.Γ⟫ :=
  E[%1 := foldK, %3 := foldMask, %4 := foldShifts, %5 := (Ty.vec 8 64).poisoned, %22 := xb, %23 :=
    xa]

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

/-- The loop from `^bb1` with counter `k`, in continuation form: after `k` iterations, `^bb2` runs
with `%23`, `%22` holding `k` folded squarings of `xa`, `xb`. -/
theorem fd_r43x6_repsqr_mul2.loop (S : GlobalState) (hwf : S.WF)
    (K : PoisonOr (Vals [] × GlobalState)) :
    ∀ k (xa xb : Vector (BitVec 64) 8) E,
      0 < k →
        k < 2 ^ 63 →
        (fd_r43x6_repsqr_mul2.ContAt ^bb2 E
          (fd_r43x6_repsqr_mul2.exit · (fd_r43x6_repsqr_mul2.sqrN k xa)
            (fd_r43x6_repsqr_mul2.sqrN k xb))
          S K) →
        fd_r43x6_repsqr_mul2.runFrom (fd_r43x6_repsqr_mul2.hdr E k xa xb) ^bb1 S = K := by
  intro k
  induction k with
  | zero =>
    intros
    omega
  | succ k ih =>
    intro xa xb E h0 h hK
    block_init
    step_call using fd_r43x6_sqr_fast.call_eq
    step_pattern using runBodyFrom_foldRun with xa'
    step_call using fd_r43x6_sqr_fast.call_eq
    step_pattern using runBodyFrom_foldRun with xb'
    step_pure [dec_nsw (k + 1) h0 h, dec_eq (k + 1) h0 h]
    step_pure
    finish_block
    · -- exit, after the last iteration
      obtain rfl : k = 0 := by
        simp [BitVec.toNat_eq] at hbr
        omega
      step_loop using hK
      all_goals rfl
    · -- back to the header, one iteration fewer
      step_loop using ih xa' xb'
      · simp [BitVec.toNat_eq] at hbr
        omega
      step_loop using hK
      all_goals subst_vars; rfl

/-- `repsqr_mul2` stores `spec xa ya n` at `_za`, then `spec xb yb n` at `_zb`. -/
public theorem fd_r43x6_repsqr_mul2.call_eq (za zb : Pointer) (xa ya xb yb : Wwl) (n : BitVec 64)
    (s : GlobalState) (hn : n.toNat < 2 ^ 63) (hwf : s.WF) (hza : Fits s.mem za 512)
    (hzb : Fits s.mem zb 512) :
    fd_r43x6_repsqr_mul2.call
        (fd_r43x6_repsqr_mul2.args (.value za) (Ty.wrap xa) (Ty.wrap ya) (.value zb) (Ty.wrap xb)
          (Ty.wrap yb) (.value n))
        s =
      .value
        (.nil,
          { s with
            mem :=
              (s.mem.storeVec za (fd_r43x6_repsqr_mul2.spec xa ya n.toNat)).storeVec zb
                (fd_r43x6_repsqr_mul2.spec xb yb n.toNat) }) := by
  func_init
  block_init
  step_pure with m1
  step_pure with k19
  step_pure with zero
  step_pure with m
  step_pure with sh
  step_pure
  step_pure
  finish_block
  case isTrue =>
    -- `n = 0`: `^bb2`, `FD_R43X6_MUL2_INL`
    block_init
    step_call using fd_r43x6_mul_fast.call_eq
    step_pattern using runBodyFrom_foldRun with za'
    step_call using fd_r43x6_mul_fast.call_eq
    step_pattern using runBodyFrom_foldRun with zb'
    step_store
    step_store
    finish_block
    subst_vars
    simp [fd_r43x6_repsqr_mul2.spec, fd_r43x6_repsqr_mul2.sqrN, fd_r43x6_mul,
      MemoryState.storeVec]
  case isFalse =>
    -- `^bb1`: the squaring loop, `n` times
    step_loop using fd_r43x6_repsqr_mul2.loop _ _ _ n.toNat xa xb
    · simp [BitVec.toNat_eq, hzero] at hbr
      omega
    -- `^bb2`, `FD_R43X6_MUL2_INL` on the squarings
    block_init
    step_call using fd_r43x6_mul_fast.call_eq
    step_pattern using runBodyFrom_foldRun with za'
    step_call using fd_r43x6_mul_fast.call_eq
    step_pattern using runBodyFrom_foldRun with zb'
    step_store
    step_store
    finish_block
    subst_vars
    simp [fd_r43x6_repsqr_mul2.spec, fd_r43x6_mul, MemoryState.storeVec]

end Proof

end LeanMLIR.RIR.Firedancer.Avx512
