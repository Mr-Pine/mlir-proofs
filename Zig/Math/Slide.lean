module

public import Zig.Edwards25519_slide
public import Mathlib.Algebra.BigOperators.Group.Finset.Defs
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Tactic.Ring
import Std.Tactic.BVDecide

/-! The arithmetic of `Edwards25519.slide.spec`: for `x < 2^255` its digits `e_k` sum to `x` as
`Σ e_k 16^k`, each in `[-8, 8]`. -/

namespace LeanMLIR.RIR.Zig

namespace Edwards25519.slide

/-- One digit from a nibble `a` and a `0`/`1` carry: `a + c - 16 c'`, in `[-8, 7]`. -/
theorem step_int (a : BitVec 4) (b : Bool) :
    let A := a.setWidth 8 + (if b then 1#8 else 0#8)
    (A - ((A + 8#8) &&& 240#8)).toInt =
        a.toNat + (if b then 1#8 else 0#8).toInt - 16 * ((A + 8#8).sshiftRight 4).toInt ∧
      -8 ≤ (A - ((A + 8#8) &&& 240#8)).toInt ∧ (A - ((A + 8#8) &&& 240#8)).toInt ≤ 7 := by
  revert a b; decide

/-- The last digit from a nibble below `8` and a `0`/`1` carry: their sum, in `[0, 8]`. -/
theorem last_int (a : BitVec 4) (b : Bool) (ha : a.toNat < 8) :
    (a.setWidth 8 + (if b then 1#8 else 0#8)).toInt = a.toNat + (if b then 1#8 else 0#8).toInt ∧
      0 ≤ (a.setWidth 8 + (if b then 1#8 else 0#8)).toInt ∧
      (a.setWidth 8 + (if b then 1#8 else 0#8)).toInt ≤ 8 := by
  revert a b ha; decide

/-- A carry is `if b then 1 else 0`. -/
theorem carry_cond (x : BitVec 256) (k : Nat) : ∃ b : Bool, carry x k = if b then 1#8 else 0#8 := by
  rcases Edwards25519_slide.carry_01 x k with h | h
  · exact ⟨false, h⟩
  · exact ⟨true, h⟩

/-- Digit `k < 63`: `nib + c_k - 16 c_{k+1}`, in `[-8, 7]`. -/
theorem digit_int {x : BitVec 256} (hk : k < 63) :
    (digit x k).toInt = (nib x k).toNat + (carry x k).toInt - 16 * (carry x (k + 1)).toInt ∧
      -8 ≤ (digit x k).toInt ∧ (digit x k).toInt ≤ 7 := by
  obtain ⟨b, hb⟩ := carry_cond x k
  have h := step_int (x.extractLsb' (4 * k) 4) b
  simp only [digit, carry, nib, hk, ite_true, hb] at h ⊢
  rw [BitVec.toNat_setWidth, Nat.mod_eq_of_lt (by omega)]
  exact h

/-- The top nibble is below `8`. -/
theorem nib_63_lt {x : BitVec 256} (h : x.msb = false) : (x.extractLsb' 252 4).toNat < 8 := by
  have : x.extractLsb' 252 4 < 8#4 := by bv_decide
  exact this

/-- Digit `63`: `nib + c_63`, in `[0, 8]`. -/
theorem digit_63_int {x : BitVec 256} (h : x.msb = false) :
    (digit x 63).toInt = (nib x 63).toNat + (carry x 63).toInt ∧
      0 ≤ (digit x 63).toInt ∧ (digit x 63).toInt ≤ 8 := by
  obtain ⟨b, hb⟩ := carry_cond x 63
  have h := last_int (x.extractLsb' 252 4) b (nib_63_lt h)
  simp only [digit, nib, show ¬(63 < 63) by decide, ite_false, hb] at h ⊢
  rw [BitVec.toNat_setWidth, Nat.mod_eq_of_lt (by omega)]
  exact h

/-- Nibble `k`'s value: `x`'s base-16 digit `k`. -/
theorem nib_toNat (x : BitVec 256) (k : Nat) : (nib x k).toNat = x.toNat / 16 ^ k % 16 := by
  rw [nib, BitVec.toNat_setWidth, BitVec.extractLsb'_toNat, Nat.shiftRight_eq_div_pow,
    show 2 ^ (4 * k) = 16 ^ k by rw [Nat.pow_mul]]
  omega

/-- Nibbles `0 … m-1`, weighted, sum to `x % 16^m`. -/
theorem sum_nib (x : BitVec 256) :
    ∀ m, ∑ k ∈ Finset.range m, ((nib x k).toNat : Int) * 16 ^ k = (x.toNat % 16 ^ m : Nat)
  | 0 => by simp [Nat.mod_one]
  | m + 1 => by
    rw [Finset.sum_range_succ, sum_nib x m, nib_toNat, Nat.pow_succ, Nat.mod_mul]
    push_cast
    ring

/-- Digits `0 … m-1` and the carry into `m`, weighted, sum to the nibbles'. -/
theorem sum_digit (x : BitVec 256) :
    ∀ m ≤ 63,
      ∑ k ∈ Finset.range m, (digit x k).toInt * 16 ^ k + (carry x m).toInt * 16 ^ m =
        ∑ k ∈ Finset.range m, ((nib x k).toNat : Int) * 16 ^ k
  | 0, _ => by simp [carry]
  | m + 1, hm => by
    rw [Finset.sum_range_succ, Finset.sum_range_succ, ← sum_digit x m (by omega),
      (digit_int (x := x) (k := m) (by omega)).1]
    ring

/-- `slide`'s digits `e_k`, for `x < 2^255`: `Σ e_k 16^k = x`. -/
public theorem spec_sum (x : BitVec 256) (h : x.msb = false) :
    ∑ k : Fin 64, ((spec x)[k]).toInt * 16 ^ (k : Nat) = x.toNat := by
  have hx : x.toNat % 16 ^ 64 = x.toNat :=
    Nat.mod_eq_of_lt
      (by
        have := x.isLt; simpa using this)
  simp only [spec, Fin.getElem_fin, Vector.getElem_ofFn]
  rw [Fin.sum_univ_eq_sum_range (fun k => (digit x k).toInt * 16 ^ k) 64, Finset.sum_range_succ]
  have h63 := sum_digit x 63 (by omega)
  have hn := sum_nib x 64
  rw [Finset.sum_range_succ, hx] at hn
  rw [(digit_63_int h).1, ← hn, ← h63]
  ring

/-- `slide`'s digits, for `x < 2^255`: each in `[-8, 8]`, below `8` but the last. -/
public theorem spec_digit (x : BitVec 256) (h : x.msb = false) (k : Fin 64) :
    -8 ≤ ((spec x)[k]).toInt ∧
      ((spec x)[k]).toInt ≤ 8 ∧ (k.val < 63 → ((spec x)[k]).toInt ≤ 7) := by
  simp only [spec, Fin.getElem_fin, Vector.getElem_ofFn]
  by_cases hk : k.val < 63
  · have := digit_int (x := x) hk
    exact ⟨this.2.1, by omega, fun _ => this.2.2⟩
  · have hk' : k.val = 63 := by omega
    rw [hk']
    have := digit_63_int h
    exact ⟨by omega, this.2.2, fun h => absurd h (by decide)⟩

end Edwards25519.slide

end LeanMLIR.RIR.Zig
