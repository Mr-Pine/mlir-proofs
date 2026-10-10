module

public import Boringssl.slide
public import Mathlib.Algebra.BigOperators.Group.Finset.Defs
public import Mathlib.Algebra.Ring.Int.Parity
public import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

/-! The arithmetic of ref10's `slide` (`slide.spec`): for `a < 2^255` its digits `d_i` sum to `a` as
`Σ d_i 2^i`, each `0` or odd in `[-15, 15]`, and the four digits after a nonzero one are `0`.
libsodium's `slide_vartime` is the same C. -/

namespace MLIR.Boringssl

namespace slide

/-! ## Value -/

/-- The integer the digits stand for: `Σ r[k] 2^k`, `r[k]` signed. -/
@[expose]
public def val (v : Vector (BitVec 8) 256) : Int :=
  ∑ k : Fin 256, v[k].toInt * 2 ^ (k : Nat)

/-- Setting entry `j` to `x` adds `(x - r[j]) 2^j`. -/
theorem val_set (v : Vector (BitVec 8) 256) (hj : j < 256) (x : BitVec 8) :
    val (v.setIfInBounds j x) = val v + (x.toInt - (v[j]'hj).toInt) * 2 ^ j := by
  unfold val
  rw [← sub_eq_iff_eq_add', ← Finset.sum_sub_distrib, Finset.sum_eq_single ⟨j, hj⟩]
  · simp only [Fin.getElem_fin, Vector.getElem_setIfInBounds_self]
    ring
  · intro b _ hb
    have : j ≠ b.val := fun h => hb (Fin.ext h.symm)
    simp [Fin.getElem_fin, this]
  · simp

/-- `0` or `1`. -/
def Bit (x : BitVec 8) : Prop :=
  x = 0#8 ∨ x = 1#8

/-! ## The carry -/

/-- The carry from `k` over bits with a clear one from `k` on: `2^k` more, bits from `k` on,
nothing below `k` touched, a set `r[k]` cleared, and `r[255]` set only by clearing all from `k`. -/
theorem carry_spec :
    ∀ n k (v : Vector (BitVec 8) 256),
      k + n = 256 →
        (∀ j (hj : j < 256), k ≤ j → Bit v[j]) →
        (∃ j, ∃ hj : j < 256, k ≤ j ∧ v[j] = 0#8) →
        val (carry v k) = val v + 2 ^ k ∧
          (∀ j (hj : j < 256), k ≤ j → Bit (carry v k)[j]) ∧
          (∀ j (hj : j < 256), j < k → (carry v k)[j] = v[j]) ∧
          (∀ hk : k < 256, v[k] = 1#8 → (carry v k)[k] = 0#8) ∧
          (v[255] = 0#8 →
            (carry v k)[255] = 1#8 →
            ∀ j (hj : j < 256), k ≤ j → j < 255 → (carry v k)[j] = 0#8) := by
  intro n
  induction n with
  | zero =>
    intro k v hk _ hz
    obtain ⟨j, hj, hkj, _⟩ := hz
    omega
  | succ n ih =>
    intro k v hk hb hz
    have hk' : k < 256 := by omega
    rcases hb k hk' (Nat.le_refl k) with h0 | h1
    · -- a clear `r[k]`: set it
      have hc : carry v k = v.setIfInBounds k 1#8 := by
        rw [carry]
        simp [hk', h0]
      rw [hc]
      refine ⟨?_, ?_, ?_, ?_, ?_⟩
      · rw [val_set v hk', h0]
        simp
      · intro j hj hkj
        by_cases e : j = k
        · subst e
          simp [Bit]
        · simp only [Vector.getElem_setIfInBounds_ne (by omega) (Ne.symm e)]
          exact hb j hj hkj
      · intro j hj hjk
        rw [Vector.getElem_setIfInBounds_ne (by omega) (by omega)]
      · intro _ h
        rw [h0] at h
        exact absurd h (by decide)
      · intro h255 h1 j hj hkj hj255
        by_cases e : k = 255
        · omega
        · rw [Vector.getElem_setIfInBounds_ne (by omega) (by omega)] at h1
          rw [h255] at h1
          exact absurd h1 (by decide)
    · -- a set `r[k]`: clear it, carry on
      have hc : carry v k = carry (v.setIfInBounds k 0#8) (k + 1) := by
        rw [carry]
        simp [hk', h1]
      rw [hc]
      have hb' : ∀ j (hj : j < 256), k + 1 ≤ j → Bit (v.setIfInBounds k 0#8)[j] := by
        intro j hj hkj
        rw [Vector.getElem_setIfInBounds_ne (by omega) (by omega)]
        exact hb j hj (by omega)
      have hz' : ∃ j, ∃ hj : j < 256, k + 1 ≤ j ∧ (v.setIfInBounds k 0#8)[j] = 0#8 := by
        obtain ⟨j, hj, hkj, h⟩ := hz
        have : j ≠ k := fun e => by
          subst e; rw [h1] at h; exact absurd h (by decide)
        exact
          ⟨j, hj, by omega, by
            rw [Vector.getElem_setIfInBounds_ne (by omega) (Ne.symm this)]; exact h⟩
      obtain ⟨iv, ib, il, -, i255⟩ := ih (k + 1) _ (by omega) hb' hz'
      have hkk : (carry (v.setIfInBounds k 0#8) (k + 1))[k] = 0#8 := by
        rw [il k hk' (by omega)]
        simp
      refine ⟨?_, ?_, ?_, ?_, ?_⟩
      · rw [iv, val_set v hk', h1, pow_succ]
        simp
        ring
      · intro j hj hkj
        by_cases e : j = k
        · subst e
          rw [hkk]
          exact .inl rfl
        · exact ib j hj (by omega)
      · intro j hj hjk
        rw [il j hj (by omega), Vector.getElem_setIfInBounds_ne (by omega) (by omega)]
      · intro _ _
        exact hkk
      · intro h255 h255' j hj hkj hj255
        have hne : k ≠ 255 := fun e => by
          subst e; rw [h1] at h255; exact absurd h255 (by decide)
        by_cases e : j = k
        · subst e
          exact hkk
        · exact
            i255
              (by
                rw [Vector.getElem_setIfInBounds_ne (by omega) (by omega)]; exact h255)
              h255' j hj (by omega) hj255

/-! ## One step of the window -/

/-- A digit: `0`, or odd in `[-15, 15]`. -/
def Digit (x : BitVec 8) : Prop :=
  x = 0#8 ∨ (Odd x.toInt ∧ -15 ≤ x.toInt ∧ x.toInt ≤ 15)

/-- The window's tests and stores against a set `r[i + b]`, as 8-bit operations on `r[i]`. -/
theorem cmp_facts (x : BitVec 8) (hb : b = 1 ∨ b = 2 ∨ b = 3 ∨ b = 4 ∨ b = 5 ∨ b = 6) :
    (x.signExtend 32 + (1#8).signExtend 32 <<< b).sle 15#32 = x.sle (BitVec.ofInt 8 (15 - 2 ^ b)) ∧
      (-15#32).sle (x.signExtend 32 - (1#8).signExtend 32 <<< b) =
        (BitVec.ofInt 8 (2 ^ b - 15)).sle x ∧
      (x.signExtend 32 + (1#8).signExtend 32 <<< b).setWidth 8 = x + BitVec.ofInt 8 (2 ^ b) ∧
      (x.signExtend 32 - (1#8).signExtend 32 <<< b).setWidth 8 = x - BitVec.ofInt 8 (2 ^ b) := by
  rcases hb with rfl | rfl | rfl | rfl | rfl | rfl <;> simp only [Int.reducePow, Int.reduceSub] <;>
    bv_decide

/-- The tests and stores as integers, for `r[i]` in `[-15, 15]`. -/
theorem int_facts (x : BitVec 8) (hb : b = 1 ∨ b = 2 ∨ b = 3 ∨ b = 4 ∨ b = 5 ∨ b = 6)
    (h1 : -15 ≤ x.toInt) (h2 : x.toInt ≤ 15) :
    (x.sle (BitVec.ofInt 8 (15 - 2 ^ b)) = true ↔ x.toInt + 2 ^ b ≤ 15) ∧
      ((BitVec.ofInt 8 (2 ^ b - 15)).sle x = true ↔ -15 ≤ x.toInt - 2 ^ b) ∧
      (x.toInt + 2 ^ b ≤ 15 → (x + BitVec.ofInt 8 (2 ^ b)).toInt = x.toInt + 2 ^ b) ∧
      (-15 ≤ x.toInt - 2 ^ b → (x - BitVec.ofInt 8 (2 ^ b)).toInt = x.toInt - 2 ^ b) := by
  have hc : ∀ c : Int, -128 ≤ c → c < 128 → (BitVec.ofInt 8 c).toInt = c := by
    intro c h1 h2
    rw [BitVec.toInt_ofInt]
    simp only [Nat.reducePow]
    exact Int.bmod_eq_of_le (by omega) (by omega)
  have hp : 2 ≤ (2 : Int) ^ b ∧ (2 : Int) ^ b ≤ 64 := by
    rcases hb with rfl | rfl | rfl | rfl | rfl | rfl <;> norm_num
  have hcb := hc (2 ^ b) (by omega) (by omega)
  refine ⟨?_, ?_, fun h => ?_, fun h => ?_⟩
  · rw [BitVec.sle_iff_toInt_le, hc _ (by omega) (by omega)]
    omega
  · rw [BitVec.sle_iff_toInt_le, hc _ (by omega) (by omega)]
    omega
  · rw [BitVec.toInt_add_of_not_saddOverflow, hcb]
    simp only [BitVec.saddOverflow, hcb]
    simp
    omega
  · rw [BitVec.toInt_sub_of_not_ssubOverflow, hcb]
    simp only [BitVec.ssubOverflow, hcb]
    simp
    omega

/-- A set `r[i + b]` folded in as `+`. -/
theorem w_add {w : Vector (BitVec 8) 256} (hb : b = 1 ∨ b = 2 ∨ b = 3 ∨ b = 4 ∨ b = 5 ∨ b = 6)
    (hib : i + b < 256) (h1 : w[i + b] = 1#8)
    (hr : -15 ≤ (w[i]'(by omega)).toInt ∧ (w[i]'(by omega)).toInt ≤ 15)
    (hle : (w[i]'(by omega)).toInt + 2 ^ b ≤ 15) :
    window w i b =
      window
        ((w.setIfInBounds i ((w[i]'(by omega)) + BitVec.ofInt 8 (2 ^ b))).setIfInBounds (i + b) 0#8)
        i (b + 1) := by
  have hc := cmp_facts (w[i]'(by omega)) hb
  have hf := int_facts (w[i]'(by omega)) hb hr.1 hr.2
  rw [window, dite_eq_left ⟨by omega, hib⟩]
  simp only [h1, show ¬(1#8 : BitVec 8) = 0#8 by decide, ↓reduceIte, hc.1, hf.1.2 hle, hc.2.2.1]

/-- A set `r[i + b]` folded in as `-` with a carry. -/
theorem w_sub {w : Vector (BitVec 8) 256} (hb : b = 1 ∨ b = 2 ∨ b = 3 ∨ b = 4 ∨ b = 5 ∨ b = 6)
    (hib : i + b < 256) (h1 : w[i + b] = 1#8)
    (hr : -15 ≤ (w[i]'(by omega)).toInt ∧ (w[i]'(by omega)).toInt ≤ 15)
    (hgt : 15 < (w[i]'(by omega)).toInt + 2 ^ b) (hge : -15 ≤ (w[i]'(by omega)).toInt - 2 ^ b) :
    window w i b =
      window (carry (w.setIfInBounds i ((w[i]'(by omega)) - BitVec.ofInt 8 (2 ^ b))) (i + b)) i
        (b + 1) := by
  have hc := cmp_facts (w[i]'(by omega)) hb
  have hf := int_facts (w[i]'(by omega)) hb hr.1 hr.2
  have hn : ¬(w[i]'(by omega)).sle (BitVec.ofInt 8 (15 - 2 ^ b)) = true := fun h => by
    have := hf.1.1 h; omega
  rw [window, dite_eq_left ⟨by omega, hib⟩]
  simp only [h1, show ¬(1#8 : BitVec 8) = 0#8 by decide, ↓reduceIte, hc.1, hn, hc.2.1, hf.2.1.2 hge,
    hc.2.2.2, Bool.false_eq_true]

/-- Neither: the window ends. -/
theorem w_break {w : Vector (BitVec 8) 256} (hb : b = 1 ∨ b = 2 ∨ b = 3 ∨ b = 4 ∨ b = 5 ∨ b = 6)
    (hib : i + b < 256) (h1 : w[i + b] = 1#8)
    (hr : -15 ≤ (w[i]'(by omega)).toInt ∧ (w[i]'(by omega)).toInt ≤ 15)
    (hgt : 15 < (w[i]'(by omega)).toInt + 2 ^ b) (hlt : (w[i]'(by omega)).toInt - 2 ^ b < -15) :
    window w i b = w := by
  have hc := cmp_facts (w[i]'(by omega)) hb
  have hf := int_facts (w[i]'(by omega)) hb hr.1 hr.2
  have hn : ¬(w[i]'(by omega)).sle (BitVec.ofInt 8 (15 - 2 ^ b)) = true := fun h => by
    have := hf.1.1 h; omega
  have hn' : ¬(BitVec.ofInt 8 (2 ^ b - 15)).sle (w[i]'(by omega)) = true := fun h => by
    have := hf.2.1.1 h; omega
  rw [window, dite_eq_left ⟨by omega, hib⟩]
  simp only [h1, show ¬(1#8 : BitVec 8) = 0#8 by decide, ↓reduceIte, hc.1, hn, hc.2.1, hn',
    Bool.false_eq_true]

/-! ## The window -/

/-- After the window at `i` of `v`: the value kept, bits above `i`, nothing below `i` touched,
`r[i + 1 … i + 4]` clear, `r[i]` odd in `[-15, 15]`, and `r[255]` set only above clear ones. -/
def Final (v : Vector (BitVec 8) 256) (i : Nat) (hi : i < 256) (w : Vector (BitVec 8) 256) : Prop :=
  val w = val v ∧
    (∀ j (hj : j < 256), i < j → Bit w[j]) ∧
    (∀ j (hj : j < 256), j < i → w[j] = v[j]) ∧
    (∀ j (hj : j < 256), i < j → j ≤ i + 4 → w[j] = 0#8) ∧
    (Odd (w[i]'hi).toInt ∧ -15 ≤ (w[i]'hi).toInt ∧ (w[i]'hi).toInt ≤ 15) ∧
    (w[255] = 1#8 → ∀ k (hk : k < 256), i < k → k < 255 → w[k] = 0#8)

/-- The window at `i` of `v` before step `b`: as `Final` for the steps so far, and before the
carry (`b ≤ 4`) `r[i]` in `[1, 2^b)` with the rest from `i + b` on untouched. -/
def WI (v : Vector (BitVec 8) 256) (i : Nat) (hi : i < 256) (b : Nat) (w : Vector (BitVec 8) 256) :
    Prop :=
  val w = val v ∧
    (∀ j (hj : j < 256), i < j → Bit w[j]) ∧
    (∀ j (hj : j < 256), j < i → w[j] = v[j]) ∧
    (∀ j (hj : j < 256), i < j → j < i + b → j ≤ i + 4 → w[j] = 0#8) ∧
    (Odd (w[i]'hi).toInt ∧ -15 ≤ (w[i]'hi).toInt ∧ (w[i]'hi).toInt ≤ 15) ∧
    ((b ≤ 4 ∧
        1 ≤ (w[i]'hi).toInt ∧
        (w[i]'hi).toInt ≤ 2 ^ b - 1 ∧ ∀ j (hj : j < 256), i + b ≤ j → w[j] = v[j]) ∨
      5 ≤ b) ∧
    (w[255] = 1#8 → ∀ k (hk : k < 256), i < k → k < 255 → w[k] = 0#8)

/-- Done at step `b`: what holds is final. -/
theorem WI.final {v w : Vector (BitVec 8) 256} {hi : i < 256} (h : WI v i hi b w)
    (hb : 7 ≤ b ∨ 256 ≤ i + b) : Final v i hi w :=
  ⟨h.1, h.2.1, h.2.2.1, fun j hj h1 h2 => h.2.2.2.1 j hj h1 (by omega) h2, h.2.2.2.2.1,
    h.2.2.2.2.2.2⟩

/-- The window from step `b` on ends final. -/
theorem win_final (v : Vector (BitVec 8) 256) (i : Nat) (hi : i < 256) (h255 : v[255] = 0#8) :
    ∀ m b (w : Vector (BitVec 8) 256),
      b + m = 7 → 1 ≤ b → WI v i hi b w → Final v i hi (window w i b) := by
  intro m
  induction m with
  | zero =>
    intro b w hm _ h
    rw [window_stop (by omega)]
    exact h.final (by omega)
  | succ m ih =>
    intro b w hm hb1 h
    by_cases hib : i + b < 256
    swap
    · rw [window_stop (by omega)]
      exact h.final (by omega)
    have hbs : b = 1 ∨ b = 2 ∨ b = 3 ∨ b = 4 ∨ b = 5 ∨ b = 6 := by omega
    obtain ⟨hval, hbits, hlow, hz, hdig, hph, h55⟩ := h
    have ht := hdig.2
    rcases hbits (i + b) hib (by omega) with h0 | h1
    · -- skip
      rw [window_skip (by omega) hib h0]
      refine ih (b + 1) w (by omega) (by omega) ⟨hval, hbits, hlow, ?_, hdig, ?_, h55⟩
      · intro j hj h1 h2 h3
        by_cases e : j = i + b
        · subst e; exact h0
        · exact hz j hj h1 (by omega) h3
      · rcases hph with ⟨hb4, hl, hu, hr⟩ | h5
        · by_cases hb4' : b + 1 ≤ 4
          · refine .inl ⟨hb4', hl, ?_, fun j hj hj' => hr j hj (by omega)⟩
            have : (2 : Int) ^ (b + 1) = 2 * 2 ^ b := by
              rw [pow_succ]; ring
            omega
          · exact .inr (by omega)
        · exact .inr (by omega)
    · rcases hph with ⟨hb4, hl, hu, hr⟩ | h5
      · by_cases hb3 : b ≤ 3
        · -- a merge
          have hp : (2 : Int) ^ b ≤ 8 := by
            rcases (show b = 1 ∨ b = 2 ∨ b = 3 by omega) with rfl | rfl | rfl <;> norm_num
          have hf := int_facts (w[i]'hi) hbs ht.1 ht.2
          have hle : (w[i]'hi).toInt + 2 ^ b ≤ 15 := by omega
          rw [w_add hbs hib h1 ht hle]
          have hx := hf.2.2.1 hle
          have hp1 : (2 : Int) ^ b = 2 * 2 ^ (b - 1) := by
            rw [← pow_succ']; congr 1; omega
          have hp2 : (2 : Int) ^ (b + 1) = 2 * 2 ^ b := by
            rw [pow_succ]; ring
          have hii : i ≠ i + b := by omega
          refine ih (b + 1) _ (by omega) (by omega) ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
          · rw [val_set _ hib, val_set _ hi, Vector.getElem_setIfInBounds_ne (by omega) hii, h1, hx,
              hval, show (0#8).toInt = 0 from rfl, show (1#8).toInt = 1 from rfl, pow_add]
            ring
          · intro j hj hij
            by_cases e : j = i + b
            · subst e; simp [Bit]
            · rw [Vector.getElem_setIfInBounds_ne hj (Ne.symm e),
                Vector.getElem_setIfInBounds_ne hj (by omega)]
              exact hbits j hj hij
          · intro j hj hji
            rw [Vector.getElem_setIfInBounds_ne hj (by omega),
              Vector.getElem_setIfInBounds_ne hj (by omega)]
            exact hlow j hj hji
          · intro j hj h1' h2 h3
            by_cases e : j = i + b
            · subst e; simp
            · rw [Vector.getElem_setIfInBounds_ne hj (Ne.symm e),
                Vector.getElem_setIfInBounds_ne hj (by omega)]
              exact hz j hj h1' (by omega) h3
          · rw [Vector.getElem_setIfInBounds_ne hi (Ne.symm hii), Vector.getElem_setIfInBounds_self,
              hx]
            obtain ⟨⟨c, hc⟩, h2, h3⟩ := hdig
            exact
              ⟨⟨c + 2 ^ (b - 1), by
                  rw [hc, hp1]; ring⟩,
                by omega, by omega⟩
          · refine .inl ⟨by omega, ?_, ?_, fun j hj hj' => ?_⟩
            · rw [Vector.getElem_setIfInBounds_ne hi (Ne.symm hii),
                Vector.getElem_setIfInBounds_self, hx]
              omega
            · rw [Vector.getElem_setIfInBounds_ne hi (Ne.symm hii),
                Vector.getElem_setIfInBounds_self, hx]
              omega
            · rw [Vector.getElem_setIfInBounds_ne hj (by omega),
                Vector.getElem_setIfInBounds_ne hj (by omega)]
              exact hr j hj (by omega)
          · intro h1' k hk hik hk255
            have e255 : 255 ≠ i + b := by
              intro e
              rw [← e, Vector.getElem_setIfInBounds_self] at h1'
              exact absurd h1' (by decide)
            rw [Vector.getElem_setIfInBounds_ne (by omega) (Ne.symm e255),
              Vector.getElem_setIfInBounds_ne (by omega) (by omega)] at h1'
            by_cases e : k = i + b
            · subst e; simp
            · rw [Vector.getElem_setIfInBounds_ne hk (Ne.symm e),
                Vector.getElem_setIfInBounds_ne hk (by omega)]
              exact h55 h1' k hk hik hk255
        · -- the carry, at `b = 4`
          obtain rfl : b = 4 := by omega
          have hf := int_facts (w[i]'hi) hbs ht.1 ht.2
          have hgt : 15 < (w[i]'hi).toInt + 2 ^ 4 := by
            norm_num; omega
          have hge : -15 ≤ (w[i]'hi).toInt - 2 ^ 4 := by
            norm_num; omega
          rw [w_sub hbs hib h1 ht hgt hge]
          have hx := hf.2.2.2 hge
          obtain ⟨wm, hwm⟩ : ∃ wm, wm = w.setIfInBounds i ((w[i]'hi) - BitVec.ofInt 8 (2 ^ 4)) :=
            ⟨_, rfl⟩
          rw [← hwm]
          have hwj : ∀ j (hj : j < 256), j ≠ i → wm[j] = w[j] := fun j hj e => by
            rw [hwm]; exact Vector.getElem_setIfInBounds_ne hj (Ne.symm e)
          have hwi : (wm[i]'hi).toInt = (w[i]'hi).toInt - 2 ^ 4 := by
            rw [hwm, Vector.getElem_setIfInBounds_self, hx]
          have hw255 : wm[255] = 0#8 := by
            rw [hwj 255 (by omega) (by omega), hr 255 (by omega) (by omega)]
            exact h255
          obtain ⟨cv, cb, cl, cc, c255⟩ :=
            carry_spec (256 - (i + 4)) (i + 4) wm (by omega)
              (fun j hj hj' => by
                rw [hwj j hj (by omega)]; exact hbits j hj (by omega))
              ⟨255, by omega, by omega, hw255⟩
          refine ih 5 _ (by omega) (by omega) ⟨?_, ?_, ?_, ?_, ?_, .inr (by omega), ?_⟩
          · rw [cv, hwm, val_set _ hi, hx, hval]
            ring
          · intro j hj hij
            by_cases hj4 : i + 4 ≤ j
            · exact cb j hj hj4
            · rw [cl j hj (by omega), hwj j hj (by omega)]
              exact hbits j hj hij
          · intro j hj hji
            rw [cl j hj (by omega), hwj j hj (by omega)]
            exact hlow j hj hji
          · intro j hj h1' h2 h3
            by_cases e : j = i + 4
            · subst e
              exact
                cc (by omega)
                  (by
                    rw [hwj _ hib (by omega)]; exact h1)
            · rw [cl j hj (by omega), hwj j hj (by omega)]
              exact hz j hj h1' (by omega) h3
          · rw [cl i hi (by omega), hwi]
            obtain ⟨⟨c, hc⟩, h2, h3⟩ := hdig
            exact
              ⟨⟨c - 8, by
                  rw [hc]; norm_num; ring⟩,
                by
                norm_num; omega, by
                norm_num; omega⟩
          · intro h1' k hk hik hk255
            by_cases hk4 : i + 4 ≤ k
            · exact c255 hw255 h1' k hk hk4 hk255
            · rw [cl k hk (by omega), hwj k hk (by omega)]
              exact hz k hk hik (by omega) (by omega)
      · -- after the carry, or with none at `b = 4`: the window ends
        have hp : 32 ≤ (2 : Int) ^ b := by
          rcases (show b = 5 ∨ b = 6 by omega) with rfl | rfl <;> norm_num
        rw [w_break hbs hib h1 ht (by omega) (by omega)]
        exact ⟨hval, hbits, hlow, fun j hj h1' h2 => hz j hj h1' (by omega) h2, hdig, h55⟩

/-! ## The `i` loop -/

/-- The bits loop's byte `k`: bit `k` of `a`. -/
theorem bits_get (a : BitVec 256) (hk : k < 256) :
    (bits a)[k] = if a.getLsbD k then 1#8 else 0#8 := by
  simp only [bits, Vector.getElem_ofFn]
  apply BitVec.eq_of_getLsbD_eq
  intro m hm
  have hk8 : 8 * (k / 8) + k % 8 = k := Nat.div_add_mod k 8
  by_cases h0 : m = 0
  · subst h0
    simp only [BitVec.getLsbD_and, BitVec.getLsbD_ushiftRight, BitVec.getLsbD_extractLsb']
    split <;> simp_all [show k % 8 < 8 by omega]
  · simp only [BitVec.getLsbD_and]
    have : (1#8).getLsbD m = false := by simp [BitVec.getLsbD_one, h0]
    split <;> simp [this]

/-- `x mod 2^n`, as a sum of its bits. -/
theorem sum_bits (a : BitVec 256) :
    ∀ n,
      n ≤ 256 →
        ∑ k ∈ Finset.range n, (if a.getLsbD k then (2 : Int) ^ k else 0) =
          (a.toNat % 2 ^ n : Nat) := by
  intro n
  induction n with
  | zero => simp
  | succ n ih =>
    intro hn
    rw [Finset.sum_range_succ, ih (by omega), Nat.pow_succ, Nat.mod_mul]
    have hb : a.getLsbD n = decide (a.toNat / 2 ^ n % 2 = 1) := by
      rw [BitVec.getLsbD, Nat.testBit_eq_decide_div_mod_eq]
    rw [hb]
    have : a.toNat / 2 ^ n % 2 < 2 := Nat.mod_lt _ (by decide)
    split
    · next h =>
        simp only [decide_eq_true_eq] at h
        rw [h]
        push_cast
        ring
    · next h =>
        simp only [decide_eq_true_eq] at h
        have h0 : a.toNat / 2 ^ n % 2 = 0 := by omega
        rw [h0]
        push_cast
        ring

/-- The bits stand for `a`. -/
theorem val_bits (a : BitVec 256) : val (bits a) = a.toNat := by
  unfold val
  have e :
    ∀ k : Fin 256,
      (bits a)[k].toInt * 2 ^ (k : Nat) = (if a.getLsbD k then (2 : Int) ^ (k : Nat) else 0) := by
    intro k
    rw [Fin.getElem_fin, bits_get a k.isLt]
    split <;> simp
  rw [Finset.sum_congr rfl (fun k _ => e k),
    Fin.sum_univ_eq_sum_range (fun k => if a.getLsbD k then (2 : Int) ^ k else 0) 256,
    sum_bits a 256 (le_refl _), Nat.mod_eq_of_lt a.isLt]

/-- The `i` loop's invariant at `i`: the digits stand for `a`, digits below `i`, bits from `i` on,
four clear digits after a nonzero one, and `r[255]` set only above clear bits. -/
def LI (a : Nat) (i : Nat) (r : Vector (BitVec 8) 256) : Prop :=
  val r = a ∧
    (∀ j (hj : j < 256), j < i → Digit r[j]) ∧
    (∀ j (hj : j < 256), i ≤ j → Bit r[j]) ∧
    (∀ j (hj : j < 256), j < i → r[j] ≠ 0#8 → ∀ k (hk : k < 256), j < k → k ≤ j + 4 → r[k] = 0#8) ∧
    (r[255] = 1#8 → ∀ k (hk : k < 256), i ≤ k → k < 255 → r[k] = 0#8)

/-- One iteration keeps the invariant. -/
theorem LI.step {r : Vector (BitVec 8) 256} (h : LI a i r) (hi : i < 256) :
    LI a (i + 1) (if r[i] ≠ 0#8 then window r i 1 else r) := by
  obtain ⟨hval, hdig, hbits, hrun, h55⟩ := h
  split
  · next hne =>
      have h1 : r[i] = 1#8 := (hbits i hi (le_refl _)).resolve_left hne
      by_cases h255 : i = 255
      · subst h255
        rw [window_stop (by omega)]
        refine
          ⟨hval, fun j hj hji => ?_, fun j hj hj' => hbits j hj (by omega), fun j hj hji hne' => ?_,
            fun _ k hk h1' h2 => by omega⟩
        · by_cases e : j = 255
          · subst e; rw [h1]; exact .inr ⟨⟨0, by decide⟩, by decide, by decide⟩
          · exact hdig j hj (by omega)
        · by_cases e : j = 255
          · intro k hk h1' _; omega
          · exact hrun j hj (by omega) hne'
      · have hv255 : r[255] = 0#8 := by
          rcases hbits 255 (by omega) (by omega) with h0 | h1'
          · exact h0
          · rw [h55 h1' i hi (le_refl _) (by omega)] at h1; exact absurd h1 (by decide)
        have hw : WI r i hi 1 r := by
          refine
            ⟨rfl, fun j hj hij => hbits j hj (by omega), fun _ _ _ => rfl, fun j hj h1' h2 _ => by
              omega, ?_, .inl ⟨by omega, ?_, ?_, fun _ _ _ => rfl⟩, ?_⟩
          · rw [h1]; exact ⟨⟨0, by decide⟩, by decide, by decide⟩
          · rw [h1]; decide
          · rw [h1]; decide
          · intro h1'; rw [hv255] at h1'; exact absurd h1' (by decide)
        obtain ⟨fv, fb, fl, fz, fd, f55⟩ := win_final r i hi hv255 6 1 r rfl (le_refl _) hw
        refine
          ⟨fv.trans hval, fun j hj hji => ?_, fun j hj hj' => fb j hj (by omega),
            fun j hj hji hne' => ?_, fun h1' k hk hk1 hk2 => f55 h1' k hk (by omega) hk2⟩
        · by_cases e : j = i
          · subst e; exact .inr fd
          · rw [fl j hj (by omega)]; exact hdig j hj (by omega)
        · by_cases e : j = i
          · subst e
            intro k hk h1' h2
            exact fz k hk h1' h2
          · intro k hk h1' h2
            have hj' : j < i := by omega
            rw [fl j hj hj'] at hne'
            have hki : k < i := by
              apply Classical.byContradiction
              intro hc
              have := hrun j hj hj' hne' i hi (by omega) (by omega)
              rw [this] at h1
              exact absurd h1 (by decide)
            rw [fl k hk hki]
            exact hrun j hj hj' hne' k hk h1' h2
  · next h0 =>
      have h0 : r[i] = 0#8 := by simpa using h0
      refine
        ⟨hval, fun j hj hji => ?_, fun j hj hj' => hbits j hj (by omega), fun j hj hji hne => ?_,
          fun h1 k hk h1' h2 => h55 h1 k hk (by omega) h2⟩
      · by_cases e : j = i
        · subst e; exact .inl h0
        · exact hdig j hj (by omega)
      · by_cases e : j = i
        · subst e; exact absurd h0 hne
        · exact hrun j hj (by omega) hne

/-- The loop from `i` keeps the invariant to the end. -/
theorem LI.loop :
    ∀ m i (r : Vector (BitVec 8) 256), i + m = 256 → LI a i r → LI a 256 (loop r i) := by
  intro m
  induction m with
  | zero =>
    intro i r hm h
    obtain rfl : i = 256 := by omega
    rw [slide.loop, dite_eq_right (by omega)]
    exact h
  | succ m ih =>
    intro i r hm h
    rw [slide.loop, dite_eq_left (by omega)]
    exact ih (i + 1) _ (by omega) (h.step (by omega))

/-- The invariant at the start, for `a < 2^255`. -/
theorem LI.init (a : BitVec 256) (ha : a.toNat < 2 ^ 255) : LI a.toNat 0 (bits a) := by
  refine ⟨val_bits a, fun j _ h => by omega, fun j hj _ => ?_, fun j _ h => by omega, fun h => ?_⟩
  · rw [bits_get a hj]
    split
    · exact .inr rfl
    · exact .inl rfl
  · rw [bits_get a (by decide)] at h
    have : a.getLsbD 255 = false := by
      rw [BitVec.getLsbD, Nat.testBit_eq_decide_div_mod_eq]
      simp only [decide_eq_false_iff_not]
      rw [Nat.div_eq_of_lt ha]
      decide
    rw [this] at h
    exact absurd h (by decide)

/-! ## The digits -/

/-- For `a < 2^255` the digits of `slide.spec a` sum to `a`: `Σ d_i 2^i = a`. -/
public theorem spec_sum (a : BitVec 256) (ha : a.toNat < 2 ^ 255) :
    ∑ k : Fin 256, (slide.spec a)[k].toInt * 2 ^ (k : Nat) = a.toNat :=
  (LI.loop 256 0 _ rfl (LI.init a ha)).1

/-- Each digit is `0` or odd in `[-15, 15]`. -/
public theorem spec_digit (a : BitVec 256) (ha : a.toNat < 2 ^ 255) (hk : k < 256) :
    (slide.spec a)[k] = 0#8 ∨
      (Odd (slide.spec a)[k].toInt ∧
        -15 ≤ (slide.spec a)[k].toInt ∧ (slide.spec a)[k].toInt ≤ 15) :=
  (LI.loop 256 0 _ rfl (LI.init a ha)).2.1 k hk hk

/-- The four digits after a nonzero one are `0`. -/
public theorem spec_zero_run (a : BitVec 256) (ha : a.toNat < 2 ^ 255) (hi : i < 256)
    (hd : (slide.spec a)[i] ≠ 0#8) (hj : j < 256) (hij : i < j) (hji : j ≤ i + 4) :
    (slide.spec a)[j] = 0#8 :=
  (LI.loop 256 0 _ rfl (LI.init a ha)).2.2.2.1 i hi hi hd j hj hij hji

end slide

end MLIR.Boringssl
