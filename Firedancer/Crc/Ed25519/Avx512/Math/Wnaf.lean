module

public import Firedancer.Crc.Ed25519.Avx512.fd_r52x5_double_scalar_mul_base
import Std.Tactic.BVDecide
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith

/-! crc's wNAF digits (`fd_r52x5_wnaf`, windows `4` and `8`) as a signed-digit expansion: every
digit is `0` or odd and below `2^B` in size, and the digits of `x ≤ 2^253` sum to `x`. -/

namespace MLIR.Firedancer.Crc.Ed25519.Avx512.fd_r52x5_wnaf

/-- The digit as the 16-bit value `fd_r52x5_wnaf` stores. -/
@[expose] public def dig (B : Nat) (w : BitVec 256) : BitVec 16 := (digit B w).setWidth 16

/-- `Σ_{i < n} D i · 2^i` over 16-bit signed digits. -/
@[expose] public def dsum (D : Nat → BitVec 16) : Nat → Int
  | 0 => 0
  | n + 1 => dsum D n + (D n).toInt * 2 ^ n

/-! ## One step, as bit vectors -/

theorem step_bv4 (w : BitVec 256) :
    next 4 w <<< 1 + (digit 4 w).signExtend 256 = w ∧
      (digit 4 w).signExtend 256 = (dig 4 w).signExtend 256 ∧
      (dig 4 w = 0#16 ∨ dig 4 w &&& 1#16 = 1#16) ∧
      (65520#16).slt (dig 4 w) = true ∧ (dig 4 w).slt 16#16 = true := by
  simp only [next, digit, lo, sel, dig, Nat.reduceAdd]
  bv_decide

theorem step_bv8 (w : BitVec 256) :
    next 8 w <<< 1 + (digit 8 w).signExtend 256 = w ∧
      (digit 8 w).signExtend 256 = (dig 8 w).signExtend 256 ∧
      (dig 8 w = 0#16 ∨ dig 8 w &&& 1#16 = 1#16) ∧
      (65280#16).slt (dig 8 w) = true ∧ (dig 8 w).slt 256#16 = true := by
  simp only [next, digit, lo, sel, dig, Nat.reduceAdd]
  bv_decide

-- an 8-bit shift amount keeps the solver fast
theorem next_le_bv4 (w : BitVec 256) (k : BitVec 8) (hk1 : 1#8 ≤ k) (hk : k ≤ 253#8)
    (hw : w ≤ 1#256 <<< k) : next 4 w ≤ 1#256 <<< (k - 1#8) := by
  simp only [next, digit, lo, sel, Nat.reduceAdd]
  bv_decide

theorem next_le_bv8 (w : BitVec 256) (k : BitVec 8) (hk1 : 1#8 ≤ k) (hk : k ≤ 253#8)
    (hw : w ≤ 1#256 <<< k) : next 8 w ≤ 1#256 <<< (k - 1#8) := by
  simp only [next, digit, lo, sel, Nat.reduceAdd]
  bv_decide

theorem next_one_bv4 (w : BitVec 256) (hw : w ≤ 1#256) : next 4 w = 0#256 := by
  simp only [next, digit, lo, sel, Nat.reduceAdd]
  bv_decide

theorem next_one_bv8 (w : BitVec 256) (hw : w ≤ 1#256) : next 8 w = 0#256 := by
  simp only [next, digit, lo, sel, Nat.reduceAdd]
  bv_decide

/-! ## One step, in `ℤ` -/

/-- The digit is `0` or odd. -/
public theorem dig_odd (hB : B = 4 ∨ B = 8) (w : BitVec 256) :
    dig B w = 0#16 ∨ (dig B w).toNat % 2 = 1 := by
  have h : dig B w = 0#16 ∨ dig B w &&& 1#16 = 1#16 := by
    rcases hB with rfl | rfl
    · exact (step_bv4 w).2.2.1
    · exact (step_bv8 w).2.2.1
  rcases h with h | h
  · exact Or.inl h
  · right
    have := congrArg BitVec.toNat h
    simpa [BitVec.toNat_and] using this

/-- The digit is below `2^B` in size. -/
public theorem dig_bounds (hB : B = 4 ∨ B = 8) (w : BitVec 256) :
    -(2 ^ B : Int) < (dig B w).toInt ∧ (dig B w).toInt < 2 ^ B := by
  rcases hB with rfl | rfl
  · obtain ⟨-, -, -, h1, h2⟩ := step_bv4 w
    exact ⟨BitVec.slt_iff_toInt_lt.1 h1, BitVec.slt_iff_toInt_lt.1 h2⟩
  · obtain ⟨-, -, -, h1, h2⟩ := step_bv8 w
    exact ⟨BitVec.slt_iff_toInt_lt.1 h1, BitVec.slt_iff_toInt_lt.1 h2⟩

theorem le_shl_iff (w : BitVec 256) (k : Nat) (hk : k < 256) :
    w ≤ 1#256 <<< BitVec.ofNat 8 k ↔ w.toNat ≤ 2 ^ k := by
  have h2 : 2 ^ k < 2 ^ 256 := Nat.pow_lt_pow_right (by norm_num) hk
  rw [BitVec.le_def, BitVec.shiftLeft_eq', BitVec.toNat_shiftLeft]
  simp only [BitVec.toNat_ofNat]
  rw [Nat.mod_eq_of_lt (show k < 2 ^ 8 by omega), Nat.shiftLeft_eq,
    Nat.mod_eq_of_lt (show 1 < 2 ^ 256 by norm_num), one_mul, Nat.mod_eq_of_lt h2]

/-- `w ≤ 2^k` gives `next w ≤ 2^(k - 1)`. -/
public theorem next_le (hB : B = 4 ∨ B = 8) (w : BitVec 256) (hk1 : 1 ≤ k) (hk : k ≤ 253)
    (hw : w.toNat ≤ 2 ^ k) : (next B w).toNat ≤ 2 ^ (k - 1) := by
  have hw' := (le_shl_iff w k (by omega)).2 hw
  have e : BitVec.ofNat 8 k - 1#8 = BitVec.ofNat 8 (k - 1) := by
    apply BitVec.eq_of_toNat_eq
    simp only [BitVec.toNat_sub, BitVec.toNat_ofNat]
    omega
  have hk1' : 1#8 ≤ BitVec.ofNat 8 k := by simp only [BitVec.le_def, BitVec.toNat_ofNat]; omega
  have hk' : BitVec.ofNat 8 k ≤ 253#8 := by simp only [BitVec.le_def, BitVec.toNat_ofNat]; omega
  refine (le_shl_iff _ (k - 1) (by omega)).1 ?_
  rw [← e]
  rcases hB with rfl | rfl
  · exact next_le_bv4 w _ hk1' hk' hw'
  · exact next_le_bv8 w _ hk1' hk' hw'

/-- `w ≤ 1` gives `next w = 0`. -/
public theorem next_eq_zero (hB : B = 4 ∨ B = 8) (w : BitVec 256) (hw : w.toNat ≤ 1) :
    next B w = 0#256 := by
  have hw' : w ≤ 1#256 := by simp only [BitVec.le_def]; simpa using hw
  rcases hB with rfl | rfl
  · exact next_one_bv4 w hw'
  · exact next_one_bv8 w hw'

/-- `w = 2 · next w + digit w` for `w ≤ 2^253`. -/
public theorem step_int (hB : B = 4 ∨ B = 8) (w : BitVec 256) (hw : w.toNat ≤ 2 ^ 253) :
    (w.toNat : Int) = 2 * (next B w).toNat + (dig B w).toInt := by
  have hn : (next B w).toNat ≤ 2 ^ 252 := next_le hB w (k := 253) (by omega) le_rfl hw
  have hbd := dig_bounds hB w
  have h : next B w <<< 1 + (dig B w).signExtend 256 = w := by
    rcases hB with rfl | rfl
    · obtain ⟨h1, h2, -⟩ := step_bv4 w; rwa [h2] at h1
    · obtain ⟨h1, h2, -⟩ := step_bv8 w; rwa [h2] at h1
  have hI := BitVec.toInt_eq_toNat_cond (dig B w)
  have hd := (dig B w).isLt
  have ht := congrArg BitVec.toNat h
  rw [BitVec.toNat_add, BitVec.toNat_shiftLeft, BitVec.toNat_signExtend, BitVec.toNat_setWidth,
    BitVec.msb_eq_decide, Nat.shiftLeft_eq] at ht
  have hd16 : (dig B w).toNat % 2 ^ 256 = (dig B w).toNat := Nat.mod_eq_of_lt (by omega)
  rw [hd16] at ht
  split at hI <;> split at ht <;> simp only [decide_eq_true_eq] at * <;> omega

/-! ## Iterates -/

theorem iter_succ (B i : Nat) (w : BitVec 256) : iter B (i + 1) w = next B (iter B i w) := by
  induction i generalizing w with
  | zero => rfl
  | succ i ih => exact ih (next B w)

/-- The iterates of `w ≤ 2^253` stay below `2^(253 - i)`. -/
theorem iter_le (hB : B = 4 ∨ B = 8) (w : BitVec 256) (hw : w.toNat ≤ 2 ^ 253) :
    ∀ i, i ≤ 253 → (iter B i w).toNat ≤ 2 ^ (253 - i)
  | 0, _ => hw
  | i + 1, hi => by
    rw [iter_succ]
    have := iter_le hB w hw i (by omega)
    have h := next_le hB (iter B i w) (k := 253 - i) (by omega) (by omega) this
    rwa [show 253 - i - 1 = 253 - (i + 1) by omega] at h

/-- `w ≤ 2^253` keeps `next w ≤ 2^253`. -/
theorem next_le_253 (hB : B = 4 ∨ B = 8) (w : BitVec 256) (hw : w.toNat ≤ 2 ^ 253) :
    (next B w).toNat ≤ 2 ^ 253 := by
  have := next_le hB w (k := 253) (by omega) le_rfl hw
  omega

/-- The iterates of `w ≤ 2^253` reach `0` after `254` steps. -/
theorem iter_254 (hB : B = 4 ∨ B = 8) (w : BitVec 256) (hw : w.toNat ≤ 2 ^ 253) :
    iter B 254 w = 0#256 := by
  rw [iter_succ]
  exact next_eq_zero hB _ (by simpa using iter_le hB w hw 253 le_rfl)

theorem dsum_succ (D : Nat → BitVec 16) (n : Nat) :
    dsum D (n + 1) = dsum D n + (D n).toInt * 2 ^ n := rfl

theorem dsum_shift (D : Nat → BitVec 16) :
    ∀ n, dsum D (n + 1) = (D 0).toInt + 2 * dsum (fun i => D (i + 1)) n
  | 0 => by simp [dsum]
  | n + 1 => by
    rw [dsum_succ, dsum_shift D n, dsum_succ]
    ring

/-- `w ≤ 2^253` is its first `m` digits plus `2^m` times its `m`-th iterate. -/
theorem iter_sum (hB : B = 4 ∨ B = 8) :
    ∀ (m : Nat) (w : BitVec 256), w.toNat ≤ 2 ^ 253 →
      (w.toNat : Int) = dsum (fun i => dig B (iter B i w)) m + 2 ^ m * (iter B m w).toNat
  | 0, w, _ => by simp [dsum, iter]
  | m + 1, w, hw => by
    have ih := iter_sum hB m (next B w) (next_le_253 hB w hw)
    rw [dsum_shift, step_int hB w hw]
    simp only [iter] at ih ⊢
    rw [ih]
    ring

/-! ## The count -/

theorem countF_iter (B : Nat) :
    ∀ f n (w : BitVec 256), iter B (f + 1) w = 0#256 →
      iter B (countF B (f + 1) n w - n) w = 0#256
  | 0, n, w, h => by
    have e : countF B 1 n w = n + 1 := by
      simp only [countF]; split <;> rfl
    rw [e, Nat.add_sub_cancel_left]
    exact h
  | f + 1, n, w, h => by
    rw [countF]
    split
    · rw [Nat.add_sub_cancel_left]
      simpa [iter] using ‹next B w = 0#256›
    · have ih := countF_iter B f (n + 1) (next B w) h
      have hlt := lt_countF B f (n + 1) (next B w)
      have e : countF B (f + 1) (n + 1) (next B w) - n =
          (countF B (f + 1) (n + 1) (next B w) - (n + 1)) + 1 := by omega
      rw [e, iter]
      exact ih

/-- The iterate at the count is `0`. -/
public theorem iter_count (hB : B = 4 ∨ B = 8) (x : BitVec 256) (hx : x.toNat ≤ 2 ^ 253) :
    iter B (count B x) x = 0#256 := by
  unfold count
  split
  · simpa [iter] using ‹x = 0#256›
  · exact countF_iter B 253 0 x (iter_254 hB x hx)

/-- The count is `0` only for `x = 0`. -/
public theorem count_eq_zero (B : Nat) (x : BitVec 256) (h : count B x = 0) : x = 0#256 := by
  unfold count at h
  split at h
  · assumption
  · exact absurd h (Nat.pos_iff_ne_zero.1 (lt_countF B 253 0 x))

/-- `x ≤ 2^253` is the sum of its `count` digits. -/
public theorem sum_digits (hB : B = 4 ∨ B = 8) (x : BitVec 256) (hx : x.toNat ≤ 2 ^ 253) :
    (x.toNat : Int) = dsum (fun i => dig B (iter B i x)) (count B x) := by
  rw [iter_sum hB (count B x) x hx, iter_count hB x hx]
  simp

/-! ## `dsum` over tables -/

public theorem dsum_congr {D D' : Nat → BitVec 16} :
    ∀ n, (∀ i < n, D i = D' i) → dsum D n = dsum D' n
  | 0, _ => rfl
  | n + 1, h => by
    rw [dsum_succ, dsum_succ, dsum_congr n fun i hi => h i (by omega), h n (by omega)]

/-- Digits `0` from `c` on do not change the sum. -/
public theorem dsum_of_zero_from {D : Nat → BitVec 16} (c : Nat) (hz : ∀ i, c ≤ i → D i = 0#16) :
    ∀ n, c ≤ n → dsum D n = dsum D c
  | 0, h => by rw [Nat.eq_zero_of_le_zero h]
  | n + 1, h => by
    rcases Nat.eq_or_lt_of_le h with e | lt
    · rw [e]
    · rw [dsum_succ, dsum_of_zero_from c hz n (by omega), hz n (by omega)]
      simp

end MLIR.Firedancer.Crc.Ed25519.Avx512.fd_r52x5_wnaf

namespace MLIR.Firedancer.Crc.Ed25519.Avx512.fd_r52x5_double_scalar_mul_base

open fd_r52x5_wnaf

/-- The `dk` digits of `x ≤ 2^253` sum to `x` over any `n ≥ count 4 x`. -/
public theorem dsum_DK (x : BitVec 256) (hx : x.toNat ≤ 2 ^ 253) (n : Nat) (hn : count 4 x ≤ n) :
    dsum (DK x) n = x.toNat := by
  rw [dsum_of_zero_from (count 4 x) (fun i hi => by simp [DK, Nat.not_lt.2 hi]) n hn,
    sum_digits (Or.inl rfl) x hx]
  exact dsum_congr _ fun i hi => by simp [DK, hi, dig]

/-- The `ds` digits of `x ≤ 2^253` sum to `x` over any `n ≥ count 8 x`. -/
public theorem dsum_DS (x : BitVec 256) (hx : x.toNat ≤ 2 ^ 253) (n : Nat) (hn : count 8 x ≤ n) :
    dsum (DS x) n = x.toNat := by
  rw [dsum_of_zero_from (count 8 x) (fun i hi => by simp [DS, Nat.not_lt.2 hi]) n hn,
    sum_digits (Or.inr rfl) x hx]
  exact dsum_congr _ fun i hi => by simp [DS, hi, dig]

/-- Every `dk` digit is `0` or odd, of size below `16`. -/
public theorem DK_digit (x : BitVec 256) (i : Nat) :
    (DK x i = 0#16 ∨ (DK x i).toNat % 2 = 1) ∧ -(2 ^ 4 : Int) < (DK x i).toInt ∧ (DK x i).toInt < 2 ^ 4 := by
  unfold DK
  split
  · exact ⟨dig_odd (Or.inl rfl) _, dig_bounds (Or.inl rfl) _⟩
  · simp

/-- Every `ds` digit is `0` or odd, of size below `256`. -/
public theorem DS_digit (x : BitVec 256) (i : Nat) :
    (DS x i = 0#16 ∨ (DS x i).toNat % 2 = 1) ∧ -(2 ^ 8 : Int) < (DS x i).toInt ∧ (DS x i).toInt < 2 ^ 8 := by
  unfold DS
  split
  · exact ⟨dig_odd (Or.inr rfl) _, dig_bounds (Or.inr rfl) _⟩
  · simp

end MLIR.Firedancer.Crc.Ed25519.Avx512.fd_r52x5_double_scalar_mul_base
