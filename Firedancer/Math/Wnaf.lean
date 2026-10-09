module

public import Firedancer.Ref.fd_curve25519_scalar_wnaf
public import Mathlib.Algebra.BigOperators.Group.Finset.Defs
public import Mathlib.Algebra.Ring.Int.Parity
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-! The arithmetic of `fd_curve25519_scalar_wnaf.wnaf`: for `x < 2^255` and `1 ≤ bits ≤ 13` its
digits `d_i` sum to `x` as `Σ d_i 2^i`, each `0` or odd in `[-(2^bits - 1), 2^bits - 1]`. -/

namespace MLIR.Firedancer.Ref

namespace fd_curve25519_scalar_wnaf

/-! ## Value -/

section Value

/-- The integer `t` represents: `Σ t[k] 2^k`. -/
def val (t : Vector Int 256) : Int :=
  ∑ k : Fin 256, t[k] * 2 ^ (k : Nat)

/-- Setting entry `j` to `v` adds `(v - t[j]) 2^j`. -/
theorem val_set (t : Vector Int 256) (hj : j < 256) (v : Int) :
    val (t.set j v hj) = val t + (v - t[j]) * 2 ^ j := by
  unfold val
  rw [← sub_eq_iff_eq_add', ← Finset.sum_sub_distrib, Finset.sum_eq_single ⟨j, hj⟩]
  · simp only [Fin.getElem_fin, Vector.getElem_set_self]
    ring
  · intro b _ hb
    have : j ≠ b.val := fun h => hb (Fin.ext h.symm)
    simp [Fin.getElem_fin, Vector.getElem_set_ne _ _ this]
  · simp

/-- The zero digits represent `0`. -/
theorem val_replicate_zero : val (Vector.replicate 256 0) = 0 := by simp [val]

end Value

/-! ## The sum -/

section Sum

/-- `x % 2^k = 0`: the low `k` bits are clear. -/
theorem mod_two_pow_eq_zero_iff {x k : Nat} : x % 2 ^ k = 0 ↔ ∀ i < k, x.testBit i = false := by
  constructor
  · intro h i hi
    have := Nat.testBit_mod_two_pow x k i
    rw [h, Nat.zero_testBit] at this
    simpa [hi] using this.symm
  · intro h
    apply Nat.eq_of_testBit_eq
    intro i
    rw [Nat.testBit_mod_two_pow, Nat.zero_testBit]
    by_cases hi : i < k
    · simp [hi, h i hi]
    · simp [hi]

/-- No bit is set from `k` up to `nextBit`, with enough fuel. -/
theorem getLsbD_lt_nextBit {n : BitVec 320} (hf : 256 ≤ k + fuel) (hk : k ≤ i)
    (hi : i < nextBit n fuel k) (h256 : i < 256) : n.getLsbD i = false := by
  induction fuel generalizing k with
  | zero => omega
  | succ fuel ih =>
    simp only [nextBit, show k < 256 by omega, ite_true] at hi
    split at hi
    · omega
    next hb =>
      rcases Nat.eq_or_lt_of_le hk with rfl | h
      · simpa using hb
      · exact ih (by omega) (by omega) hi

/-- `nextBit` from `256` on is `256`. -/
theorem nextBit_ge {n : BitVec 320} (hk : 256 ≤ k) : nextBit n fuel k = 256 := by
  cases fuel <;> simp [nextBit, show ¬k < 256 by omega]

/-- The loop invariant at `pos`: the digits so far and `n` stand for `x`; `n ≤ 2^255` with no bit
below `pos`; no digit from `pos` on. -/
structure Inv (x : BitVec 256) (n : BitVec 320) (t : Vector Int 256) (pos : Nat) : Prop where
  sum : val t + n.toNat = x.toNat
  le : n.toNat ≤ 2 ^ 255
  low : n.toNat % 2 ^ pos = 0
  zero : ∀ k (hk : k < 256), pos ≤ k → t[k] = 0

/-- A negative digit's carry stays within `2^255`: `R h + d P ≤ 2^255` with `R = 2 P Q`, `d` odd
and at least `Q` even, gives `R (h + 1) ≤ 2^255`. -/
theorem carry_le {P Q d h : Nat} (hP : 0 < P) (hQ : Q % 2 = 0) (hd : d % 2 = 1) (hdQ : Q ≤ d)
    (hn : P * (2 * Q) * h + d * P ≤ 2 ^ 255) (hpow : P * (2 * Q) ∣ 2 ^ 255 ∨ 2 ^ 255 ≤ P * Q) :
    P * (2 * Q) * (h + 1) ≤ 2 ^ 255 := by
  rcases hpow with ⟨T, hT⟩ | hge
  · have hdP : 0 < d * P := Nat.mul_pos (by omega) hP
    have hlt : P * (2 * Q) * h < P * (2 * Q) * T := by omega
    rw [hT]
    exact Nat.mul_le_mul_left _ (Nat.lt_of_mul_lt_mul_left hlt)
  · exfalso
    have h1 : Q * P ≤ d * P := Nat.mul_le_mul_right _ hdQ
    have h2 : P * Q = Q * P := Nat.mul_comm _ _
    have h3 : d * P = Q * P := by omega
    have := Nat.eq_of_mul_eq_mul_right hP h3
    omega

/-- One iteration of `loop` at the next set bit `p` keeps the invariant at `p + bits + 1`. -/
theorem Inv.step {x : BitVec 256} {n : BitVec 320} {t : Vector Int 256} (hB : 1 ≤ B ∧ B ≤ 13)
    (hI : Inv x n t pos) (hnp : nextBit n 256 pos = p) (hp : p < 256) :
    Inv x (fd_curve25519_scalar_wnaf.digit B n t p hp).1
      (fd_curve25519_scalar_wnaf.digit B n t p hp).2 (p + (B + 1)) := by
  have h256 : pos ≤ 256 := by
    by_contra hc
    rw [nextBit_ge (by omega)] at hnp
    omega
  have hpp : pos ≤ p := hnp ▸ le_nextBit h256
  have hbit : n.getLsbD p = true := hnp ▸ getLsbD_nextBit (hnp ▸ hp)
  -- no bit below `p`: `n = 2^p q`, `q` odd
  have hlowp : n.toNat % 2 ^ p = 0 := by
    rw [mod_two_pow_eq_zero_iff]
    intro i hi
    by_cases hip : i < pos
    · exact mod_two_pow_eq_zero_iff.1 hI.low i hip
    · have :=
        getLsbD_lt_nextBit (n := n) (fuel := 256) (k := pos) (i := i) (by omega) (by omega)
          (by omega) (by omega)
      rwa [BitVec.testBit_toNat]
  obtain ⟨q, hq⟩ : ∃ q, n.toNat = 2 ^ p * q :=
    ⟨n.toNat / 2 ^ p, (Nat.mul_div_cancel' (Nat.dvd_of_mod_eq_zero hlowp)).symm⟩
  have hdiv : n.toNat / 2 ^ p = q := by rw [hq, Nat.mul_div_cancel_left _ (by positivity)]
  have hqodd : q % 2 = 1 := by
    rw [BitVec.getLsbD, Nat.testBit_eq_decide_div_mod_eq, decide_eq_true_eq, hdiv] at hbit
    exact hbit
  have hsplit := toNat_clear n hp hB.2
  rw [hdiv] at hsplit
  -- `q = 2^(bits+1) h + d`
  obtain ⟨h, hh⟩ : ∃ h, q = 2 ^ (B + 1) * h + q % 2 ^ (B + 1) :=
    ⟨q / 2 ^ (B + 1), (Nat.div_add_mod q _).symm⟩
  have hdodd : q % 2 ^ (B + 1) % 2 = 1 := by
    rw [Nat.mod_mod_of_dvd _ (by simp)]
    exact hqodd
  have hQ : 2 ^ B % 2 = 0 := by
    obtain ⟨k, hk⟩ : ∃ k, B = k + 1 := ⟨B - 1, by omega⟩
    rw [hk, Nat.pow_succ, Nat.mul_mod_left]
  have h2 : 2 ^ (B + 1) = 2 * 2 ^ B := by rw [Nat.pow_succ, Nat.mul_comm]
  have hpow : 2 ^ (p + (B + 1)) = 2 ^ p * (2 * 2 ^ B) := by rw [Nat.pow_add, h2]
  have hzp : t[p] = 0 := hI.zero p hp hpp
  have hn1 : (n &&& ~~~((mask B).setWidth 320 <<< p)).toNat = 2 ^ p * (2 * 2 ^ B) * h := by
    have : 2 ^ p * q = 2 ^ p * (2 * 2 ^ B) * h + q % 2 ^ (B + 1) * 2 ^ p := by
      conv_lhs => rw [hh]
      rw [h2]
      ring
    omega
  have hsplitZ :
    ((2 ^ p * (2 * 2 ^ B) * h : Nat) : Int) + ((q % 2 ^ (B + 1) : Nat) : Int) * 2 ^ p =
      n.toNat := by
    rw [← hn1]
    exact_mod_cast hsplit
  have hval := hI.sum
  simp only [fd_curve25519_scalar_wnaf.digit]
  rw [toNat_window n hB.2, hdiv]
  split
  next hpos =>
    dsimp only
    refine ⟨?_, ?_, ?_, fun k hk hpk => ?_⟩
    · rw [val_set, hzp, hn1]
      linear_combination hval + hsplitZ
    · have := hI.le
      omega
    · rw [hn1, hpow]
      exact Nat.mul_mod_right _ _
    · rw [Vector.getElem_set_ne _ _ (by omega)]
      exact hI.zero k hk (by omega)
  next
    hneg =>
    have hle : 2 ^ p * (2 * 2 ^ B) * (h + 1) ≤ 2 ^ 255 := by
      refine
        carry_le (Nat.two_pow_pos p) hQ hdodd (by omega)
          (by
            rw [← hn1, hsplit]; exact hI.le)
          ?_
      rcases Nat.lt_or_ge (p + (B + 1)) 256 with hs | hs
      · refine .inl ⟨2 ^ (255 - (p + (B + 1))), ?_⟩
        rw [← hpow, ← Nat.pow_add, show p + (B + 1) + (255 - (p + (B + 1))) = 255 by omega]
      · refine .inr ?_
        rw [← Nat.pow_add]
        exact Nat.pow_le_pow_right (by decide) (by omega)
    have hsum :
      ((n &&& ~~~((mask B).setWidth 320 <<< p)) + 1#320 <<< (p + (B + 1))).toNat =
        2 ^ p * (2 * 2 ^ B) * (h + 1) := by
      rw [toNat_add_shiftLeft (by omega)
          (by
            rw [hn1, hpow]; linarith),
        hn1, hpow]
      ring
    dsimp only
    refine ⟨?_, ?_, ?_, fun k hk hpk => ?_⟩
    · rw [val_set, hzp, hsum]
      push_cast at hsplitZ ⊢
      linear_combination hval + hsplitZ
    · rw [hsum]
      exact hle
    · rw [hsum, hpow]
      exact Nat.mul_mod_right _ _
    · rw [Vector.getElem_set_ne _ _ (by omega)]
      exact hI.zero k hk (by omega)

/-- With no set bit from `pos` on, the digits alone stand for `x`. -/
theorem Inv.done {x : BitVec 256} {n : BitVec 320} {t : Vector Int 256} (hI : Inv x n t pos)
    (hz : ∀ i, pos ≤ i → i < 256 → n.getLsbD i = false) :
    fd_curve25519_scalar_wnaf.val t = x.toNat := by
  have h256 : n.toNat % 2 ^ 256 = 0 := by
    rw [mod_two_pow_eq_zero_iff]
    intro i hi
    by_cases hip : i < pos
    · exact mod_two_pow_eq_zero_iff.1 hI.low i hip
    · rw [BitVec.testBit_toNat]
      exact hz i (by omega) hi
  have h0 : n.toNat = 0 := by
    have : n.toNat < 2 ^ 256 := lt_of_le_of_lt hI.le (by norm_num)
    rwa [Nat.mod_eq_of_lt this] at h256
  have := hI.sum
  rw [h0] at this
  simpa using this

/-- `loop` from the invariant, with enough fuel, ends with digits standing for `x`. -/
theorem Inv.run {x : BitVec 256} (hB : 1 ≤ B ∧ B ≤ 13) :
    ∀ f pos (n : BitVec 320) (t : Vector Int 256),
      Inv x n t pos →
        256 ≤ pos + f →
        fd_curve25519_scalar_wnaf.val (fd_curve25519_scalar_wnaf.loop B f n t pos) = x.toNat := by
  intro f
  induction f with
  | zero =>
    intro pos n t hI hf
    exact hI.done fun i h1 h2 => by omega
  | succ f ih =>
    intro pos n t hI hf
    simp only [fd_curve25519_scalar_wnaf.loop]
    split
    next
      hp =>
      have h256 : pos ≤ 256 := by
        by_contra hc
        rw [nextBit_ge (by omega)] at hp
        omega
      have hpp : pos ≤ nextBit n 256 pos := le_nextBit h256
      exact ih _ _ _ (hI.step hB rfl hp) (by omega)
    next hp =>
      by_cases hpos : 256 ≤ pos
      · exact hI.done fun i h1 h2 => by omega
      · exact hI.done fun i h1 h2 => getLsbD_lt_nextBit (fuel := 256) (by omega) h1 (by omega) h2

/-- The digits of `wnaf x bits` sum to `x`: `Σ d_i 2^i = x`. -/
public theorem wnaf_sum (x : BitVec 256) (hb : 1 ≤ bits ∧ bits ≤ 13) (hx : x.toNat < 2 ^ 255) :
    ∑ i : Fin 256, (wnaf x bits)[i] * 2 ^ (i : Nat) = x.toNat := by
  change val (wnaf x bits) = _
  have hn0 : (n0 x).toNat = x.toNat := by
    rw [n0, BitVec.toNat_setWidth, BitVec.toNat_setWidth, Nat.mod_eq_of_lt hx,
      Nat.mod_eq_of_lt
        (lt_trans hx (Nat.pow_lt_pow_right (a := 2) (by decide) (show 255 < 320 by decide)))]
  refine Inv.run hb 256 0 _ _ ⟨?_, ?_, ?_, fun k hk _ => ?_⟩ (by omega)
  · rw [val_replicate_zero, hn0]
    simp
  · rw [hn0]
    exact hx.le
  · exact Nat.mod_one _
  · simp

end Sum

/-! ## Digits -/

section Digits

/-- Each digit of `wnaf x bits` is `0` or odd, with `|d| ≤ 2^bits - 1`. -/
public theorem wnaf_digit (x : BitVec 256) (hb : 1 ≤ bits) (hk : k < 256) :
    ((wnaf x bits)[k] = 0 ∨ Odd (wnaf x bits)[k]) ∧ (wnaf x bits)[k].natAbs ≤ 2 ^ bits - 1 := by
  have hc : (2 : Int) ^ bits = ((2 ^ bits : Nat) : Int) := by
    push_cast; rfl
  obtain ⟨hd, h1, h2⟩ := wnaf_digits x hb k hk
  rw [hc] at h1 h2
  generalize 2 ^ bits = M at h1 h2 ⊢
  exact ⟨hd.imp_right Int.odd_iff.2, by omega⟩

/-- `n ≤ 2^m - 1` halves below `2^(m-1)`. -/
theorem div_two_lt (h : n ≤ 2 ^ m - 1) (hm : 1 ≤ m) : n / 2 < 2 ^ (m - 1) := by
  obtain ⟨b, rfl⟩ : ∃ b, m = b + 1 := ⟨m - 1, by omega⟩
  rw [Nat.add_sub_cancel]
  rw [Nat.pow_succ] at h
  have := Nat.two_pow_pos b
  generalize 2 ^ b = M at h this ⊢
  omega

/-- `|d| / 2`, the table index of a digit `d` of `wnaf x bits`, is below `2^(bits-1)`. -/
public theorem wnaf_index (x : BitVec 256) (hb : 1 ≤ bits) (hk : k < 256) :
    (wnaf x bits)[k].natAbs / 2 < 2 ^ (bits - 1) :=
  div_two_lt (wnaf_digit x hb hk).2 hb

/-- `n1slide`'s digits: `0` or odd, `|d| ≤ 15`, an index into the 8-entry `ai` table. -/
public theorem wnaf4_digit (x : BitVec 256) (hk : k < 256) :
    ((wnaf x 4)[k] = 0 ∨ Odd (wnaf x 4)[k]) ∧
      (wnaf x 4)[k].natAbs ≤ 15 ∧ (wnaf x 4)[k].natAbs / 2 < 8 :=
  ⟨(wnaf_digit x (by decide) hk).1, (wnaf_digit x (by decide) hk).2, wnaf_index x (by decide) hk⟩

/-- `n2slide`'s digits: `0` or odd, `|d| ≤ 255`, an index into the 128-entry base table. -/
public theorem wnaf8_digit (x : BitVec 256) (hk : k < 256) :
    ((wnaf x 8)[k] = 0 ∨ Odd (wnaf x 8)[k]) ∧
      (wnaf x 8)[k].natAbs ≤ 255 ∧ (wnaf x 8)[k].natAbs / 2 < 128 :=
  ⟨(wnaf_digit x (by decide) hk).1, (wnaf_digit x (by decide) hk).2, wnaf_index x (by decide) hk⟩

end Digits

end fd_curve25519_scalar_wnaf

end MLIR.Firedancer.Ref
