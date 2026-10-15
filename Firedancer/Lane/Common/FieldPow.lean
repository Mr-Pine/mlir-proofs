module

public import Firedancer.Avx512.fd_r43x6_repsqr_mul2
public import Firedancer.Math.Avx512.Pow
import Mathlib.FieldTheory.Finite.Basic
import Mathlib.Tactic.NormNum

/-! The addition chains' squaring loops: `sqrN` one step at a time, the counters of the loops the
compiler unrolls by two, and the chains' values (`Pw`). -/

namespace MLIR.Firedancer.Lane.FieldPow

open Firedancer.Avx512 R43x6
open _root_.Ed25519 (p)

@[expose] public section

/-- `sqrN` peeled at the end: the last squaring outermost. -/
theorem sqrN_succ' (n : Nat) (x : Wwl) :
    fd_r43x6_repsqr_mul2.sqrN (n + 1) x = fd_r43x6_sqr (fd_r43x6_repsqr_mul2.sqrN n x) := by
  induction n generalizing x with
  | zero => rfl
  | succ n ih => exact ih (fd_r43x6_sqr x)

/-- Two squarings more. -/
theorem sqrN_add_two (n : Nat) (x : Wwl) :
    fd_r43x6_repsqr_mul2.sqrN (n + 2) x =
      fd_r43x6_sqr (fd_r43x6_sqr (fd_r43x6_repsqr_mul2.sqrN n x)) := by
  rw [sqrN_succ', sqrN_succ']

/-- The counter's `i + 2`, `nsw`: no signed overflow. -/
theorem saddOverflow_two32 {i : Nat} (h : i + 2 < 2 ^ 31) :
    (BitVec.ofNat 32 i).saddOverflow 2#32 = false := by
  have : (BitVec.ofNat 32 i).toInt = i := by rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp [BitVec.saddOverflow, this]
  omega

/-- The counter's `i + 2`, `nuw`: no unsigned overflow. -/
theorem uaddOverflow_two32 {i : Nat} (h : i + 2 < 2 ^ 31) :
    (BitVec.ofNat 32 i).uaddOverflow 2#32 = false := by
  simp [BitVec.uaddOverflow]
  omega

/-- The counter's `i + 2`. -/
theorem ofNat_add_two32 (i : Nat) : BitVec.ofNat 32 i + 2#32 = BitVec.ofNat 32 (i + 2) :=
  (BitVec.ofNat_add i 2).symm

/-- The exit test `i == N` on a small counter, in `ℕ`. -/
theorem counter_eq {i N : Nat} (hi : i < 2 ^ 32) (hN : N < 2 ^ 32)
    (h : BitVec.ofNat 32 i = BitVec.ofNat 32 N) : i = N := by
  have := congrArg BitVec.toNat h
  simp only [BitVec.toNat_ofNat] at this
  omega

/-- The exit test failing: `i ≠ N`. -/
theorem counter_ne {i N : Nat} (h : ¬BitVec.ofNat 32 i = BitVec.ofNat 32 N) : i ≠ N := by
  rintro rfl
  exact h rfl

/-- `sqrN` peeled two at the front. -/
theorem sqrN_add_two' (n : Nat) (x : Wwl) :
    fd_r43x6_repsqr_mul2.sqrN (n + 2) x =
      fd_r43x6_repsqr_mul2.sqrN n (fd_r43x6_sqr (fd_r43x6_sqr x)) :=
  rfl

/-- The count-down `k - 2` (`add nsw k, -2`) on `k = 2 (m + 1)`: no signed overflow. -/
theorem dec2_nsw {m : Nat} (h : m < 2 ^ 61) :
    (BitVec.ofNat 64 (2 * (m + 1))).saddOverflow 18446744073709551614#64 = false := by
  have hx : (BitVec.ofNat 64 (2 * (m + 1))).toInt = 2 * (m + 1) := by
    rw [BitVec.toInt_eq_toNat_of_lt] <;> simp [BitVec.toNat_ofNat] <;> omega
  have hm : (18446744073709551614#64).toInt = -2 := by decide
  simp only [BitVec.saddOverflow, hx, hm]
  simp
  omega

/-- The count-down's `k - 2`. -/
theorem dec2_eq (m : Nat) :
    BitVec.ofNat 64 (2 * (m + 1)) + 18446744073709551614#64 = BitVec.ofNat 64 (2 * m) := by
  rw [show 2 * (m + 1) = 2 * m + 2 by omega, BitVec.ofNat_add, BitVec.add_assoc,
    show BitVec.ofNat 64 2 + 18446744073709551614#64 = 0#64 by decide, BitVec.add_zero]

/-- The count-down's exit test `k - 2 == 0`: the last pass. -/
theorem dec2_zero {m : Nat} (h : m < 2 ^ 61) (h' : BitVec.ofNat 64 (2 * m) = 0#64) : m = 0 := by
  have := congrArg BitVec.toNat h'
  simp only [BitVec.toNat_ofNat] at this
  omega

/-- The exit test failing: passes left. -/
theorem dec2_pos {m : Nat} (h' : ¬BitVec.ofNat 64 (2 * m) = 0#64) : 0 < m := by
  rcases m with _ | m
  · exact absurd rfl h'
  · omega

/-- `l` is unreduced, with value `z ^ e`. -/
def Pw (l z : Wwl) (e : ℕ) : Prop :=
  val l = val z ^ e ∧ Unreduced l

/-- `z` is `z ^ 1`. -/
theorem Pw.self {z : Wwl} (h : Unreduced z) : Pw z z 1 :=
  ⟨(pow_one _).symm, h⟩

/-- A squaring doubles the exponent. -/
theorem Pw.sqr {l z : Wwl} {e : ℕ} (h : Pw l z e) : Pw (fd_r43x6_sqr l) z (e * 2) := by
  obtain ⟨v, f⟩ := fd_r43x6_sqr_spec h.2
  exact ⟨by rw [v, h.1, pow_mul], f.unreduced⟩

/-- `n` squarings multiply it by `2 ^ n`. -/
theorem Pw.sqrN {l z : Wwl} {e : ℕ} (h : Pw l z e) (n : ℕ) :
    Pw (fd_r43x6_repsqr_mul2.sqrN n l) z (e * 2 ^ n) := by
  obtain ⟨v, u⟩ := sqrN_spec h.2 n
  exact ⟨by rw [v, h.1, pow_mul], u⟩

/-- A product adds the exponents. -/
theorem Pw.mul {l m z : Wwl} {e f : ℕ} (h : Pw l z e) (h' : Pw m z f) :
    Pw (fd_r43x6_mul l m) z (e + f) := by
  obtain ⟨v, g⟩ := fd_r43x6_mul_spec h.2.1 h'.2
  exact ⟨by rw [v, h.1, h'.1, pow_add], g.unreduced⟩

/-- `fd_r43x6_repsqr_mul( l, m, n )`: `l ^ (2 ^ n) m`. -/
theorem Pw.repsqr_mul {l m z : Wwl} {e f : ℕ} (h : Pw l z e) (h' : Pw m z f) (n : ℕ) :
    Pw (fd_r43x6_repsqr_mul2.spec l m n) z (e * 2 ^ n + f) :=
  (h.sqrN n).mul h'

/-- Fermat: `x ^ (p - 2)` inverts (`0⁻¹ = 0`). -/
theorem pow_p_sub_two (x : ZMod p) : x ^ (p - 2) = x⁻¹ := by
  rcases eq_or_ne x 0 with rfl | hx
  · rw [ZMod.inv_zero, zero_pow (by norm_num)]
  · have h := ZMod.pow_card_sub_one_eq_one hx
    rw [show p - 1 = p - 2 + 1 by norm_num, pow_succ] at h
    exact eq_inv_of_mul_eq_one_left h

/-- The chains' last product: folded. -/
theorem Pw.mul_folded {l m z : Wwl} {e f : ℕ} (h : Pw l z e) (h' : Pw m z f) :
    val (fd_r43x6_mul l m) = val z ^ (e + f) ∧ Folded (fd_r43x6_mul l m) := by
  obtain ⟨v, g⟩ := fd_r43x6_mul_spec h.2.1 h'.2
  exact ⟨by rw [v, h.1, h'.1, pow_add], g⟩

end

end MLIR.Firedancer.Lane.FieldPow
