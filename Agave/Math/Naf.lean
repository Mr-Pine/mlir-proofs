module

public import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

/-! `Scalar::non_adjacent_form(w)`, `2 ≤ w ≤ 8`, as its loop computes it: 256 digits of `x < 2^255`
that sum to `x` (`Σ naf[i] 2^i`), each zero or odd with `|naf[i]| < 2^(w-1)`. -/

namespace MLIR.Agave

/-! ## Definitions -/

@[expose] public section

namespace Naf

/-- `Σ t[i] 2^i`. -/
def val (t : Vector ℤ 256) : ℤ :=
  ∑ i : Fin 256, t[i] * 2 ^ (i : ℕ)

/-- The window at `pos` with carry `c`: `c` plus the `w` bits of `x` at `pos`. -/
def window (w x pos c : ℕ) : ℕ :=
  c + x / 2 ^ pos % 2 ^ w

/-- The loop from position `pos` with carry `c`, digits `t` so far, at most `fuel` iterations: an
even window moves on a bit; an odd one is written as is if below `2^w / 2` (carry 0), else less
`2^w` (carry 1), and moves on `w` bits. -/
def loop (w x : ℕ) : ℕ → ℕ → ℕ → Vector ℤ 256 → Vector ℤ 256
  | 0, _, _, t => t
  | fuel + 1, pos, c, t =>
    if h : pos < 256 then
      if window w x pos c % 2 = 0 then loop w x fuel (pos + 1) c t
      else
        if window w x pos c < 2 ^ w / 2 then
          loop w x fuel (pos + w) 0 (t.set pos (window w x pos c) h)
        else loop w x fuel (pos + w) 1 (t.set pos (window w x pos c - 2 ^ w) h)
    else t

/-- The width-`w` non-adjacent form of `x`. -/
def naf (w x : ℕ) : Vector ℤ 256 :=
  loop w x 256 0 0 (Vector.replicate 256 0)

/-- `n` is a width-`w` digit: zero, or odd with `|n| < 2^(w-1)`. -/
def Digit (w : ℕ) (n : ℤ) : Prop :=
  n = 0 ∨ n % 2 = 1 ∧ -2 ^ (w - 1) < n ∧ n < 2 ^ (w - 1)

end Naf

end

namespace Naf

/-! ## The value -/

/-- Setting entry `j` to `v` adds `(v - t[j]) 2^j`. -/
public theorem val_set (t : Vector ℤ 256) {j : ℕ} (hj : j < 256) (v : ℤ) :
    val (t.set j v hj) = val t + (v - t[j]) * 2 ^ j := by
  unfold val
  rw [← sub_eq_iff_eq_add', ← Finset.sum_sub_distrib, Finset.sum_eq_single ⟨j, hj⟩]
  · simp only [Fin.getElem_fin, Vector.getElem_set_self]
    ring
  · intro b _ hb
    have : j ≠ b.val := fun h => hb (Fin.ext h.symm)
    simp [Fin.getElem_fin, Vector.getElem_set_ne _ _ this]
  · simp

/-! ## The loop invariant -/

/-- The loop's invariant at `pos`, carry `c`, digits `t`: the digits so far and the rest of `x`
with the carry sum to `x`; no digit at or past `pos`; every digit a digit; a carry only
before 256. -/
structure Inv (w x pos c : ℕ) (t : Vector ℤ 256) : Prop where
  sum : val t + 2 ^ pos * ((x / 2 ^ pos + c : ℕ) : ℤ) = x
  zero : ∀ i (h : i < 256), pos ≤ i → t[i] = 0
  digit : ∀ i (h : i < 256), Digit w t[i]
  carry : c ≤ 1
  carry_lt : c = 1 → pos < 256

/-- One iteration keeps the invariant, for `x < 2^255`. -/
theorem Inv.step {w x pos c : ℕ} {t : Vector ℤ 256} (hw : 2 ≤ w) (hx : x < 2 ^ 255)
    (hI : Inv w x pos c t) (hp : pos < 256) :
    (window w x pos c % 2 = 0 → Inv w x (pos + 1) c t) ∧
      (window w x pos c % 2 ≠ 0 →
        window w x pos c < 2 ^ w / 2 → Inv w x (pos + w) 0 (t.set pos (window w x pos c) hp)) ∧
      (window w x pos c % 2 ≠ 0 →
        ¬window w x pos c < 2 ^ w / 2 →
        Inv w x (pos + w) 1 (t.set pos (window w x pos c - 2 ^ w) hp)) := by
  obtain ⟨hsum, hzero, hdig, hc, hclt⟩ := hI
  obtain ⟨H, hH⟩ : ∃ H, 2 ^ (w - 1) = H := ⟨_, rfl⟩
  have hW : 2 ^ w = 2 * H := by
    rw [← hH, ← pow_succ']; congr 1; omega
  have hH2 : 2 ≤ H := by
    rw [← hH]
    calc
      2 = 2 ^ 1 := rfl
      _ ≤ 2 ^ (w - 1) := Nat.pow_le_pow_right (by decide) (by omega)
  have hq1 : x / 2 ^ (pos + 1) = x / 2 ^ pos / 2 := by rw [pow_succ, ← Nat.div_div_eq_div_mul]
  have hqw : x / 2 ^ (pos + w) = x / 2 ^ pos / 2 ^ w := by rw [pow_add, ← Nat.div_div_eq_div_mul]
  -- past `255 - w` the bits at `pos` are below `H`; at 255 they are zero
  have hqH : 256 ≤ pos + w → x / 2 ^ pos < H := by
    intro h
    rw [Nat.div_lt_iff_lt_mul (Nat.two_pow_pos pos), ← hH, ← pow_add]
    exact hx.trans_le (Nat.pow_le_pow_right (by decide) (by omega))
  have hq0 : pos = 255 → x / 2 ^ pos = 0 := fun h => by
    rw [h]; exact Nat.div_eq_of_lt hx
  have hmod2 : x / 2 ^ pos % 2 ^ w % 2 = x / 2 ^ pos % 2 :=
    Nat.mod_mod_of_dvd _
      (by
        rw [hW]; exact dvd_mul_right 2 H)
  have hset (v : ℤ) (hv : Digit w v) :
    (∀ i (h : i < 256), pos + w ≤ i → (t.set pos v hp)[i] = 0) ∧
      ∀ i (h : i < 256), Digit w (t.set pos v hp)[i] := by
    refine ⟨fun i h hi => ?_, fun i h => ?_⟩
    · rw [Vector.getElem_set_ne _ _ (by omega)]; exact hzero i h (by omega)
    · by_cases hi : pos = i
      · subst hi; rw [Vector.getElem_set_self]; exact hv
      · rw [Vector.getElem_set_ne _ _ hi]; exact hdig i h
  have hval (v : ℤ) : val (t.set pos v hp) = val t + v * 2 ^ pos := by
    rw [val_set, hzero pos hp le_rfl, sub_zero]
  have hHe : H % 2 = 0 := by
    rw [← hH, show w - 1 = w - 2 + 1 by omega, pow_succ]; exact Nat.mul_mod_left _ _
  have hH' : (2 : ℤ) ^ (w - 1) = H := by exact_mod_cast hH
  have hWz : (2 : ℤ) ^ w = 2 * H := by exact_mod_cast hW
  obtain ⟨q, hq⟩ : ∃ q, x / 2 ^ pos = q := ⟨_, rfl⟩
  have hwin : window w x pos c = c + q % (2 * H) := by rw [window, hq, hW]
  rw [hq] at hsum hqH hq0 hmod2 hq1 hqw
  rw [hW] at hmod2 hqw
  rw [hwin, hW, hWz]
  have hqW := Nat.mod_add_div q (2 * H)
  have hlt := Nat.mod_lt q (show 0 < 2 * H by omega)
  have hWH : 2 * H / 2 = H := by omega
  rw [hWH]
  obtain ⟨r, hr⟩ : ∃ r, q % (2 * H) = r := ⟨_, rfl⟩
  obtain ⟨k, hk⟩ : ∃ k, q / (2 * H) = k := ⟨_, rfl⟩
  rw [hr] at hqW hlt hmod2 ⊢
  rw [hk] at hqW hqw
  refine
    ⟨fun he => ⟨?_, fun i h hi => hzero i h (by omega), hdig, hc, fun h1 => ?_⟩, fun ho hlo => ?_,
      fun ho hhi => ?_⟩
  · -- even: `q + c` is even
    have e : q + c = 2 * (q / 2 + c) := by omega
    rw [hq1, pow_succ, ← hsum, e]
    push_cast
    ring
  · -- a carry at 255 would make the window odd
    by_contra hp'
    have := hq0 (by omega)
    subst this
    omega
  · obtain ⟨hz, hd⟩ :=
      hset (c + r : ℕ)
        (.inr
          ⟨by omega, by
            rw [hH']; omega, by
            rw [hH']; omega⟩)
    refine ⟨?_, hz, hd, by omega, fun h => absurd h (by omega)⟩
    rw [hval, hqw, pow_add, hWz, ← hsum]
    have e : ((c + r : ℕ) : ℤ) + 2 * H * ((k + 0 : ℕ) : ℤ) = (q + c : ℕ) := by
      have := congrArg (Nat.cast (R := ℤ)) hqW
      push_cast at this ⊢
      linear_combination this
    linear_combination (2 : ℤ) ^ pos * e
  · obtain ⟨hz, hd⟩ :=
      hset (((c + r : ℕ) : ℤ) - 2 * H)
        (.inr
          ⟨by omega, by
            rw [hH']; omega, by
            rw [hH']; omega⟩)
    refine ⟨?_, hz, hd, le_rfl, fun _ => ?_⟩
    · rw [hval, hqw, pow_add, hWz, ← hsum]
      have e : ((c + r : ℕ) : ℤ) - 2 * H + 2 * H * ((k + 1 : ℕ) : ℤ) = (q + c : ℕ) := by
        have := congrArg (Nat.cast (R := ℤ)) hqW
        push_cast at this ⊢
        linear_combination this
      linear_combination (2 : ℤ) ^ pos * e
    · -- the window is at least `H`, so then is `q`: `pos + w` is below 256
      by_contra h
      have := hqH (by omega)
      have : r = q := by
        rw [← hr]; exact Nat.mod_eq_of_lt (by omega)
      omega

/-- The loop, run long enough, ends with the invariant at a position past 255. -/
theorem Inv.run {w x : ℕ} (hw : 2 ≤ w) (hx : x < 2 ^ 255) (fuel : ℕ) :
    ∀ pos c t,
      Inv w x pos c t →
        256 ≤ pos + fuel → ∃ pos' c', 256 ≤ pos' ∧ Inv w x pos' c' (loop w x fuel pos c t) := by
  induction fuel with
  | zero => exact fun pos c t hI h => ⟨pos, c, by omega, hI⟩
  | succ fuel ih =>
    intro pos c t hI hf
    by_cases hp : pos < 256
    · obtain ⟨he, hlo, hhi⟩ := hI.step hw hx hp
      simp only [loop, hp, dite_true]
      split_ifs with h1 h2
      · exact ih _ _ _ (he h1) (by omega)
      · exact ih _ _ _ (hlo h1 h2) (by omega)
      · exact ih _ _ _ (hhi h1 h2) (by omega)
    · simp only [loop, hp, dite_false]
      exact ⟨pos, c, by omega, hI⟩

/-- The invariant at the start. -/
theorem Inv.init (w x : ℕ) : Inv w x 0 0 (Vector.replicate 256 0) := by
  refine ⟨?_, fun i h _ => by simp, fun i h => .inl (by simp), by omega, fun h => by omega⟩
  simp [val]

/-! ## The digits -/

/-- The digits sum to `x`. -/
public theorem val_naf {w x : ℕ} (hw : 2 ≤ w) (hx : x < 2 ^ 255) : val (naf w x) = x := by
  obtain ⟨pos, c, hp, hI⟩ := Inv.run hw hx 256 0 0 _ (Inv.init w x) (by omega)
  have hq : x / 2 ^ pos = 0 :=
    Nat.div_eq_of_lt (hx.trans_le (Nat.pow_le_pow_right (by decide) (by omega)))
  have hc : c = 0 := by
    have := hI.carry; have := hI.carry_lt; omega
  have := hI.sum
  rw [hq, hc] at this
  simpa [naf] using this

/-- Every digit is a width-`w` digit. -/
public theorem digit_naf {w x : ℕ} (hw : 2 ≤ w) (hx : x < 2 ^ 255) (i : ℕ) (h : i < 256) :
    Digit w (naf w x)[i] := by
  obtain ⟨pos, c, -, hI⟩ := Inv.run hw hx 256 0 0 _ (Inv.init w x) (by omega)
  exact hI.digit i h

/-- A digit of width at most 8 fits an `i8`, and is not `-128`. -/
public theorem Digit.lt_128 {w : ℕ} {n : ℤ} (hw : w ≤ 8) (h : Digit w n) : -128 < n ∧ n < 128 := by
  have : (2 : ℤ) ^ (w - 1) ≤ 128 := by
    calc
      (2 : ℤ) ^ (w - 1) ≤ 2 ^ 7 := pow_le_pow_right₀ (by norm_num) (by omega)
      _ = 128 := by norm_num
  rcases h with rfl | ⟨-, h1, h2⟩
  · omega
  · omega

end Naf

end MLIR.Agave
