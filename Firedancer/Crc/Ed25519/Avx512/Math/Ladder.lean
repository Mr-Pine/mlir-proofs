module

public import Firedancer.Crc.Ed25519.Avx512.Math.Point
public import Firedancer.Crc.Ed25519.Avx512.Math.Wnaf
public import Firedancer.Crc.Ed25519.Avx512.VerifyCore.SmallOrder
import Std.Tactic.BVDecide
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Module

/-! crc's double scalar multiplication on the group: the digit adds over odd tables, the ladder as
a signed-digit sum, and `fd_r52x5_ge_eq_z1` as point equality. -/

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

open MLIR.Firedancer.R52x5
open _root_.Ed25519 (p d Point)
open fd_r52x5_double_scalar_mul_base

/-! ## The table indices -/

theorem idxP_bv (y : BitVec 16) (h : y.msb = false) (h0 : y ≠ 0#16) :
    (y.signExtend 32 + 4294967295#32).setWidth 64 >>> 1 = (y.setWidth 64 - 1#64) >>> 1 := by
  bv_decide

theorem idxN_bv (y : BitVec 16) (h : y.msb = true) :
    ((y.signExtend 32).setWidth 64 ^^^ 4294967295#64) >>> 1 = (~~~y).setWidth 64 >>> 1 := by
  bv_decide

public theorem idxP_eq {y : BitVec 16} (hy : 0 < y.toInt) (hyh : y.toInt < 2 ^ 15) :
    (idxP y : Int) = (y.toInt - 1) / 2 := by
  have hI := BitVec.toInt_eq_toNat_cond y
  have hlt := y.isLt
  split at hI
  · have hm : y.msb = false := by rw [BitVec.msb_eq_decide]; simp; omega
    have h0 : y ≠ 0#16 := by rintro rfl; simp at hy
    unfold idxP
    rw [idxP_bv y hm h0, BitVec.toNat_ushiftRight, BitVec.toNat_sub, BitVec.toNat_setWidth, hI]
    simp only [BitVec.toNat_ofNat, Nat.reducePow]
    omega
  · omega

public theorem idxN_eq {y : BitVec 16} (hy : y.toInt < 0) (hyl : -(2 ^ 15) < y.toInt) :
    (idxN y : Int) = (-y.toInt - 1) / 2 := by
  have hI := BitVec.toInt_eq_toNat_cond y
  have hlt := y.isLt
  split at hI
  · omega
  · have hm : y.msb = true := by rw [BitVec.msb_eq_decide]; simp; omega
    unfold idxN
    rw [idxN_bv y hm, BitVec.toNat_ushiftRight, BitVec.toNat_setWidth, BitVec.toNat_not, hI]
    simp only [Nat.reducePow]
    omega

/-! ## Negated entries -/

/-- `negEntry` of `P` precomputed: `-P` precomputed. -/
public theorem negEntry_preF {T : Quad5} {P : Point} (hT : PreF T P) : PreF (negEntry T) (-P) := by
  unfold negEntry
  obtain ⟨X, Y, T', Z, hE, e0, e1, e2, e3⟩ := hT.1
  have hp := Quad5.permute_is 1 0 2 3 hT.2.is
  have hn := fd_r52x5_quad_neg.spec_is hp fun _ => by norm_num
  have h := Quad5.laneIf_is 1 1 1 0 hp hn
  refine ⟨⟨-X, Y, -T', Z, ?_, ?_, ?_, ?_, ?_⟩, h.below fun j => by fin_cases j <;> simp⟩
  · simpa using hE.neg
  · rw [h.val 0]; simp [Quad5.sel, e1]
  · rw [h.val 1]; simp [Quad5.sel, e0]; ring
  · rw [h.val 2]; simp [Quad5.sel, e2]
  · rw [h.val 3]; simp [Quad5.sel, e3]

/-! ## Digit adds -/

/-- A table of `n` precomputed odd multiples of `P`. -/
@[expose] public def OddTab (T : Nat → Quad5) (n : Nat) (P : Point) : Prop :=
  ∀ k < n, PreF (T k) ((2 * k + 1) • P)

public theorem odd_table_oddTab {A : Quad5} {P : Point} (hA : ExtF A P) (n : Nat) :
    OddTab (fd_r52x5_odd_table.spec A) n P := fun k _ => odd_table_preF hA k

public theorem Int.zsmul_of_odd_pos {P : Point} {z : Int} (hz : 0 < z) (hodd : z % 2 = 1) :
    z • P = (2 * ((z - 1) / 2).toNat + 1) • P := by
  have h : ((2 * ((z - 1) / 2).toNat + 1 : Nat) : Int) = z := by
    push_cast
    rw [Int.toNat_of_nonneg (by omega)]
    omega
  rw [← natCast_zsmul, h]

/-- `addDigit` over a table of `n` odd multiples of `P`, digit `y` odd or `0` with
`|y| < 2 n + 1`: `Q + y P`. -/
public theorem addDigit_extF {T : Nat → Quad5} {n : Nat} {P Q : Point} {R : Quad5} {y : BitVec 16}
    (hT : OddTab T n P) (hR : ExtF R Q)
    (hodd : y = 0#16 ∨ y.toNat % 2 = 1) (hl : -(2 * (n : Int) + 1) < y.toInt)
    (hh : y.toInt < 2 * n + 1) (hn : n ≤ 2 ^ 14) :
    ExtF (addDigit T y R) (Q + y.toInt • P) := by
  have hI := BitVec.toInt_eq_toNat_cond y
  have hlt := y.isLt
  unfold addDigit
  split
  · rename_i hpos
    have hpos' := BitVec.slt_iff_toInt_lt.1 hpos
    rw [BitVec.toInt_zero] at hpos'
    have hodd' : y.toInt % 2 = 1 := by
      rcases hodd with rfl | h
      · simp at hpos'
      · split at hI <;> omega
    have hk : ((y.toInt - 1) / 2).toNat < n := by omega
    have e := idxP_eq hpos' (by omega)
    have e' : idxP y = ((y.toInt - 1) / 2).toNat := by
      have := Int.toNat_of_nonneg (show 0 ≤ (y.toInt - 1) / 2 by omega)
      omega
    rw [e']
    refine (ge_add_table_extF hR (hT _ hk)).congr ?_
    rw [Int.zsmul_of_odd_pos hpos' hodd']
  · split
    · rename_i hnp hneg
      have hneg' := BitVec.slt_iff_toInt_lt.1 hneg
      rw [BitVec.toInt_zero] at hneg'
      have hodd' : y.toInt % 2 = 1 := by
        rcases hodd with rfl | h
        · simp at hneg'
        · split at hI <;> omega
      have hk : ((-y.toInt - 1) / 2).toNat < n := by omega
      have e := idxN_eq hneg' (by omega)
      have e' : idxN y = ((-y.toInt - 1) / 2).toNat := by
        have := Int.toNat_of_nonneg (show 0 ≤ (-y.toInt - 1) / 2 by omega)
        omega
      rw [e']
      refine (ge_add_table_extF hR (negEntry_preF (hT _ hk))).congr ?_
      have e3 := Int.zsmul_of_odd_pos (P := P) (z := -y.toInt) (by omega) (by omega)
      rw [neg_zsmul] at e3
      rw [← e3, neg_neg]
    · rename_i hnp hnn
      have h1 := BitVec.slt_iff_toInt_lt.not.1 (by simpa using hnp)
      have h2 := BitVec.slt_iff_toInt_lt.not.1 (by simpa using hnn)
      rw [BitVec.toInt_zero] at h1 h2
      have : y.toInt = 0 := by omega
      rw [this, zero_zsmul, add_zero]
      exact hR

/-! ## The ladder -/

open fd_r52x5_wnaf (dsum)

/-- The ladder's invariant at `i`: the accumulator is the digits from `i + 1` up to `n`. -/
public theorem iter_extF {TA TB : Nat → Quad5} {DK DS : Nat → BitVec 16} {PA PB Q : Point} {R : Quad5}
    (hTA : OddTab TA 8 PA) (hTB : OddTab TB 128 PB)
    (hK : ∀ i, (DK i = 0#16 ∨ (DK i).toNat % 2 = 1) ∧ -(2 ^ 4 : Int) < (DK i).toInt ∧
      (DK i).toInt < 2 ^ 4)
    (hS : ∀ i, (DS i = 0#16 ∨ (DS i).toNat % 2 = 1) ∧ -(2 ^ 8 : Int) < (DS i).toInt ∧
      (DS i).toInt < 2 ^ 8)
    (i : Nat) (hR : ExtF R Q) :
    ExtF (iter TA TB DK DS i R) ((2 : Int) • Q + (DK i).toInt • PA + (DS i).toInt • PB) := by
  unfold iter
  obtain ⟨k1, k2, k3⟩ := hK i
  obtain ⟨s1, s2, s3⟩ := hS i
  have h1 := ge_dbl_extF hR
  have h2 := addDigit_extF hTA h1 k1 (by push_cast; linarith) (by push_cast; linarith)
    (by norm_num)
  have h3 := addDigit_extF hTB h2 s1 (by push_cast; linarith) (by push_cast; linarith)
    (by norm_num)
  exact h3.congr (by rw [two_zsmul])

/-- The point the ladder from `i` down to `0` adds to `2^(i + 1)` times its start: the digits
`0 … i` weighted by `2^j`. -/
public theorem ladder_extF {TA TB : Nat → Quad5} {DK DS : Nat → BitVec 16} {PA PB : Point}
    (hTA : OddTab TA 8 PA) (hTB : OddTab TB 128 PB)
    (hK : ∀ i, (DK i = 0#16 ∨ (DK i).toNat % 2 = 1) ∧ -(2 ^ 4 : Int) < (DK i).toInt ∧
      (DK i).toInt < 2 ^ 4)
    (hS : ∀ i, (DS i = 0#16 ∨ (DS i).toNat % 2 = 1) ∧ -(2 ^ 8 : Int) < (DS i).toInt ∧
      (DS i).toInt < 2 ^ 8) :
    ∀ (i : Nat) {R : Point} {Rq : Quad5}, ExtF Rq R →
      ExtF (ladder TA TB DK DS i Rq)
        ((2 : Int) ^ (i + 1) • R + dsum DK (i + 1) • PA + dsum DS (i + 1) • PB)
  | 0, R, Rq, hR => by
    have h := iter_extF hTA hTB hK hS 0 hR
    rw [ladder]
    exact h.congr (by simp [dsum])
  | i + 1, R, Rq, hR => by
    rw [ladder]
    have h := ladder_extF hTA hTB hK hS i (iter_extF hTA hTB hK hS (i + 1) hR)
    refine h.congr ?_
    simp only [fd_r52x5_wnaf.dsum, pow_succ]
    module

end MLIR.Firedancer.Crc.Ed25519.Avx512
