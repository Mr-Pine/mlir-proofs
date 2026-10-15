module

public import Firedancer.Secp256k1.Math.Mont
public import Firedancer.Secp256k1.Point
public import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring
import Std.Tactic.BVDecide

/-! `fd_secp256k1_slide`: signed base-16 digits of the 32 input bytes, read little-endian. -/

namespace Firedancer.Secp256k1

open Finset

@[expose] public section

/-- The little-endian value of 32 bytes. -/
def leNat (b : Vector (BitVec 8) 32) : ℕ :=
  ∑ j : Fin 32, b[j].toNat * 256 ^ (j : ℕ)

end

/-- The little-endian bytes of a `fd_uint256_t` (its `buf`) have its value. -/
public theorem leNat_buf (a : fd_uint256_t) : leNat a.buf = limbsEval a := by
  have h (x : BitVec 64) :
    x.toNat =
      x.toNat % 256 + (x.toNat >>> 8 % 256) * 256 + (x.toNat >>> 16 % 256) * 256 ^ 2 +
        (x.toNat >>> 24 % 256) * 256 ^ 3 +
        (x.toNat >>> 32 % 256) * 256 ^ 4 +
        (x.toNat >>> 40 % 256) * 256 ^ 5 +
        (x.toNat >>> 48 % 256) * 256 ^ 6 +
        (x.toNat >>> 56 % 256) * 256 ^ 7 := by
    have := x.isLt
    simp only [Nat.shiftRight_eq_div_pow]
    omega
  have e : leNat a.buf = ∑ j ∈ range 32, (if h : j < 32 then a.buf[j].toNat * 256 ^ j else 0) := by
    rw [leNat, ← Fin.sum_univ_eq_sum_range]
    exact
      Fintype.sum_congr _ _ fun j => by
        rw [dite_eq_left j.isLt]; rfl
  rw [e, limbsEval_four]
  conv_rhs => rw [h a[0], h a[1], h a[2], h a[3]]
  simp only [sum_range_succ, sum_range_zero]
  simp [fd_uint256_t.buf, Nat.shiftRight_eq_div_pow]
  ring

/-! ## Nibbles -/

/-- Nibble `k` of the little-endian value (`0` past the end). -/
def nib (s : Vector (BitVec 8) 32) (k : ℕ) : ℕ :=
  if h : k / 2 < 32 then s[k / 2].toNat / 16 ^ (k % 2) % 16 else 0

theorem nib_lt (s : Vector (BitVec 8) 32) (k : ℕ) : nib s k < 16 := by
  unfold nib; split <;> omega

theorem nib_even (s : Vector (BitVec 8) 32) {i : ℕ} (hi : i < 32) :
    nib s (i * 2 + 0) = s[i].toNat % 16 := by simp [nib, hi]

theorem nib_odd (s : Vector (BitVec 8) 32) {i : ℕ} (hi : i < 32) :
    nib s (i * 2 + 1) = s[i].toNat / 16 % 16 := by
  simp [nib, show (i * 2 + 1) / 2 = i by omega, show (i * 2 + 1) % 2 = 1 by omega, hi]

theorem sum_nib (s : Vector (BitVec 8) 32) : ∑ k ∈ range 64, nib s k * 16 ^ k = leNat s := by
  have key :
    ∀ m ≤ 32,
      ∑ k ∈ range (2 * m), nib s k * 16 ^ k =
        ∑ j ∈ range m, (if h : j < 32 then s[j].toNat else 0) * 256 ^ j := by
    intro m
    induction m with
    | zero => simp
    | succ m ih =>
      intro hm
      rw [show 2 * (m + 1) = 2 * m + 1 + 1 by ring, sum_range_succ, sum_range_succ, ih (by omega),
        sum_range_succ]
      have hm' : m < 32 := by omega
      have e1 : nib s (2 * m) = s[m].toNat % 16 := by
        rw [← nib_even s hm']; congr 1; omega
      have e2 : nib s (2 * m + 1) = s[m].toNat / 16 % 16 := by
        rw [← nib_odd s hm']; congr 1; omega
      rw [e1, e2, dite_eq_left hm', add_assoc]
      congr 1
      have := s[m].isLt
      have hs : s[m].toNat = s[m].toNat % 16 + s[m].toNat / 16 % 16 * 16 := by omega
      rw [pow_succ, pow_mul]
      conv_rhs => rw [hs]
      norm_num
      ring
  rw [show 64 = 2 * 32 from rfl, key 32 le_rfl, leNat, ← Fin.sum_univ_eq_sum_range]
  exact
    Fintype.sum_congr _ _ fun j => by
      rw [dite_eq_left j.isLt]; rfl

theorem nibble_table :
    ∀ k : Fin 256,
      (((BitVec.ofNat 8 k).setWidth 32 &&& 0xF#32).setWidth 8).toNat = k % 16 ∧
        ((((BitVec.ofNat 8 k).setWidth 32).sshiftRight 4 &&& 0xF#32).setWidth 8).toNat =
          k / 16 % 16 := by
  decide +kernel

theorem nibble_lo (x : BitVec 8) :
    ((x.setWidth 32 &&& 0xF#32).setWidth 8).toNat = x.toNat % 16 := by
  simpa only [BitVec.ofNat_toNat, BitVec.setWidth_eq] using (nibble_table ⟨x.toNat, x.isLt⟩).1

theorem nibble_hi (x : BitVec 8) :
    (((x.setWidth 32).sshiftRight 4 &&& 0xF#32).setWidth 8).toNat = x.toNat / 16 % 16 := by
  simpa only [BitVec.ofNat_toNat, BitVec.setWidth_eq] using (nibble_table ⟨x.toNat, x.isLt⟩).2

/-! ## The carry step -/

/-- The second loop's body on digit `n` and carry `c`: the new digit and carry. -/
def slideStep (n c : BitVec 8) : BitVec 8 × BitVec 8 :=
  let t := (n.signExtend 32 + c.signExtend 32).setWidth 8
  let c' := (((t.signExtend 32 + 8#32).setWidth 8).signExtend 32).sshiftRight 4 |>.setWidth 8
  ((t.signExtend 32 - c'.signExtend 32 * 16#32).setWidth 8, c')

theorem slideStep_table :
    ∀ n : Fin 16,
      ∀ c : Fin 2,
        -8 ≤ (slideStep (BitVec.ofNat 8 n) (BitVec.ofNat 8 c)).1.toInt ∧
          (slideStep (BitVec.ofNat 8 n) (BitVec.ofNat 8 c)).1.toInt ≤ 7 ∧
          (slideStep (BitVec.ofNat 8 n) (BitVec.ofNat 8 c)).2.toNat ≤ 1 ∧
          (slideStep (BitVec.ofNat 8 n) (BitVec.ofNat 8 c)).1.toInt +
              16 * ((slideStep (BitVec.ofNat 8 n) (BitVec.ofNat 8 c)).2.toNat : ℤ) =
            n + c := by
  decide +kernel

/-- A step keeps the digit in `[-8, 7]` and the carry in `{0, 1}`, and preserves the value. -/
theorem slideStep_spec {n c : BitVec 8} (hn : n.toNat < 16) (hc : c.toNat ≤ 1) :
    -8 ≤ (slideStep n c).1.toInt ∧
      (slideStep n c).1.toInt ≤ 7 ∧
      (slideStep n c).2.toNat ≤ 1 ∧
      (slideStep n c).1.toInt + 16 * ((slideStep n c).2.toNat : ℤ) = n.toNat + c.toNat := by
  have := slideStep_table ⟨n.toNat, hn⟩ ⟨c.toNat, by omega⟩
  simpa only [BitVec.ofNat_toNat, BitVec.setWidth_eq] using this

theorem digit_table :
    ∀ k : Fin 256,
      -8 ≤ (BitVec.ofNat 8 k).toInt →
        (BitVec.ofNat 8 k).toInt ≤ 8 →
        ((0#32).slt ((BitVec.ofNat 8 k).signExtend 32) = true ↔ 0 < (BitVec.ofNat 8 k).toInt) ∧
          (((BitVec.ofNat 8 k).signExtend 32).slt 0#32 = true ↔ (BitVec.ofNat 8 k).toInt < 0) ∧
          (0 < (BitVec.ofNat 8 k).toInt →
            (((BitVec.ofNat 8 k).signExtend 64).toNat : ℤ) = (BitVec.ofNat 8 k).toInt) ∧
          ((BitVec.ofNat 8 k).toInt < 0 →
            (((-((BitVec.ofNat 8 k).signExtend 32)).signExtend 64).toNat : ℤ) =
              -(BitVec.ofNat 8 k).toInt) := by
  decide +kernel

/-- For a digit in `[-8, 8]`, the loop's sign tests and the table indices it reads. -/
public theorem digit_index {d : BitVec 8} (hl : -8 ≤ d.toInt) (hu : d.toInt ≤ 8) :
    ((0#32).slt (d.signExtend 32) = true ↔ 0 < d.toInt) ∧
      ((d.signExtend 32).slt 0#32 = true ↔ d.toInt < 0) ∧
      (0 < d.toInt → ((d.signExtend 64).toNat : ℤ) = d.toInt) ∧
      (d.toInt < 0 → (((-(d.signExtend 32)).signExtend 64).toNat : ℤ) = -d.toInt) := by
  have := digit_table ⟨d.toNat, d.isLt⟩
  simp only [BitVec.ofNat_toNat, BitVec.setWidth_eq] at this
  exact this hl hu

/-! ## The digits -/

/-- Digit `k` times `16^k` (`0` past the end). -/
@[expose]
public def digitTerm (r : Vector (BitVec 8) 65) (k : ℕ) : ℤ :=
  if h : k < 65 then r[k].toInt * 16 ^ k else 0

/-- `fd_secp256k1_slide` stores digits in `[-8, 7]`, a last digit in `{0, 1}`, and
`Σ dᵢ 16ⁱ` is the little-endian value of the input. -/
public theorem fd_secp256k1_slide.spec_digits (s : Vector (BitVec 8) 32) :
    (∀ (k : ℕ) (hk : k < 64),
        -8 ≤ (fd_secp256k1_slide.spec s)[k].toInt ∧ (fd_secp256k1_slide.spec s)[k].toInt ≤ 7) ∧
      ((fd_secp256k1_slide.spec s)[64].toInt = 0 ∨ (fd_secp256k1_slide.spec s)[64].toInt = 1) ∧
      ∑ k : Fin 65, (fd_secp256k1_slide.spec s)[k].toInt * 16 ^ (k : ℕ) = leNat s := by
  unfold fd_secp256k1_slide.spec
  extract_lets  r0 r1 c0 st r2 c2
  -- First loop: nibbles.
  have h1 : ∀ (k : ℕ) (hk : k < 65), r1[k].toNat = if k < 2 * 32 then nib s k else 0 := by
    refine
      fold_induct (P := fun i (r : Vector (BitVec 8) 65) =>
        ∀ (k : ℕ) (hk : k < 65), r[k].toNat = if k < 2 * i then nib s k else 0) 32 _ r0
        (fun k hk => by simp [r0]) ?_
    intro i hi r hr k hk
    dsimp only
    have hlo := nibble_lo s[i]
    have hhi := nibble_hi s[i]
    rw [Vector.getElem_set, Vector.getElem_set]
    split_ifs with e1 e2 e3 e4 e5
    · subst e1; rw [hhi, nib_odd s hi]
    · omega
    · subst e3; rw [hlo, nib_even s hi]
    · omega
    · rw [hr k hk];
      split_ifs <;>
        first
        | rfl
        | omega
    · rw [hr k hk];
      split_ifs <;>
        first
        | rfl
        | omega
  -- Second loop: carries.
  have h2 :
    (∀ (k : ℕ) (hk : k < 65), 64 ≤ k → k < 64 → st.1[k].toNat = nib s k) ∧
      st.2.toNat ≤ 1 ∧
      (∀ (k : ℕ) (hk : k < 65), k < 64 → -8 ≤ st.1[k].toInt ∧ st.1[k].toInt ≤ 7) ∧
      ∑ k ∈ range 64, digitTerm st.1 k + (st.2.toNat : ℤ) * 16 ^ 64 =
        ∑ k ∈ range 64, (nib s k : ℤ) * 16 ^ k := by
    refine
      fold_induct (P := fun i (st : Vector (BitVec 8) 65 × BitVec 8) =>
        (∀ (k : ℕ) (hk : k < 65), i ≤ k → k < 64 → st.1[k].toNat = nib s k) ∧
          st.2.toNat ≤ 1 ∧
          (∀ (k : ℕ) (hk : k < 65), k < i → -8 ≤ st.1[k].toInt ∧ st.1[k].toInt ≤ 7) ∧
          ∑ k ∈ range i, digitTerm st.1 k + (st.2.toNat : ℤ) * 16 ^ i =
            ∑ k ∈ range i, (nib s k : ℤ) * 16 ^ k)
        64 _ (r1, c0)
        ⟨fun k hk _ hk' => by rw [h1 k hk, ite_eq_left hk'], by simp [c0], fun _ _ h =>
          absurd h (by omega), by simp [c0]⟩
        ?_
    rintro i hi ⟨r, c⟩ ⟨hr, hc, hd, hs⟩
    dsimp only at hr hc hd hs ⊢
    have hri : r[i].toNat = nib s i := hr i (by omega) le_rfl hi
    obtain ⟨l, u, hc', hv⟩ :=
      slideStep_spec (n := r[i]) (c := c)
        (by
          rw [hri]; exact nib_lt s i)
        hc
    simp only [Vector.getElem_set_self, Vector.set_set]
    simp only [slideStep] at l u hc' hv
    refine ⟨fun k hk h1 h2 => ?_, hc', fun k hk h => ?_, ?_⟩
    · rw [Vector.getElem_set_ne _ _ (by omega)]; exact hr k hk (by omega) h2
    · rcases Nat.lt_succ_iff_lt_or_eq.1 h with h | h
      · rw [Vector.getElem_set_ne _ _ (by omega)]; exact hd k hk h
      · subst h; rw [Vector.getElem_set_self]; exact ⟨l, u⟩
    · rw [sum_range_succ, sum_range_succ, ← hs]
      have hsame :
        ∀ v : BitVec 8,
          ∑ k ∈ range i, digitTerm (r.set i v (by omega)) k = ∑ k ∈ range i, digitTerm r k := by
        refine fun v => sum_congr rfl fun k hk => ?_
        have := mem_range.1 hk
        simp only [digitTerm, dite_eq_left (show k < 65 by omega)]
        rw [Vector.getElem_set_ne _ _ (by omega)]
      rw [hsame]
      simp only [digitTerm, dite_eq_left (show i < 65 by omega), Vector.getElem_set_self]
      rw [← hri]
      linear_combination (16 : ℤ) ^ i * hv
  obtain ⟨-, hc, hd, hs⟩ := h2
  replace hc : c2.toNat ≤ 1 := hc
  refine ⟨fun k hk => ?_, ?_, ?_⟩
  · rw [Vector.getElem_set_ne _ _ (by omega)]; exact hd k (by omega) hk
  · rw [Vector.getElem_set_self]
    have : c2.toInt = c2.toNat := by
      rw [BitVec.toInt_eq_toNat_cond]; simp; omega
    omega
  · have hc2 : c2.toInt = c2.toNat := by
      rw [BitVec.toInt_eq_toNat_cond]; simp; omega
    have ht : ∀ k : Fin 65, (r2.set 64 c2)[k].toInt * 16 ^ (k : ℕ) = digitTerm (r2.set 64 c2) k :=
      fun k => by
      rw [digitTerm, dite_eq_left k.isLt]; rfl
    simp only [ht]
    rw [Fin.sum_univ_eq_sum_range (digitTerm (r2.set 64 c2)) 65, sum_range_succ]
    have hsame : ∑ k ∈ range 64, digitTerm (r2.set 64 c2) k = ∑ k ∈ range 64, digitTerm r2 k := by
      refine sum_congr rfl fun k hk => ?_
      have := mem_range.1 hk
      simp only [digitTerm, dite_eq_left (show k < 65 by omega)]
      rw [Vector.getElem_set_ne _ _ (by omega)]
    have hl : (leNat s : ℤ) = ∑ k ∈ range 64, (nib s k : ℤ) * 16 ^ k := by
      rw [← sum_nib]; push_cast; rfl
    rw [hsame, hl, ← hs]
    simp only [digitTerm, dite_eq_left (show 64 < 65 by omega), Vector.getElem_set_self, hc2]
    rfl

/-- Every `slide` digit is in `[-8, 8]`. -/
public theorem fd_secp256k1_slide.digit_bounds (s : Vector (BitVec 8) 32) {k : ℕ} (hk : k < 65) :
    -8 ≤ (fd_secp256k1_slide.spec s)[k].toInt ∧ (fd_secp256k1_slide.spec s)[k].toInt ≤ 8 := by
  obtain ⟨h1, h2, -⟩ := fd_secp256k1_slide.spec_digits s
  rcases Nat.lt_succ_iff_lt_or_eq.1 hk with h | rfl
  · have := h1 k h; omega
  · rcases h2 with h | h <;> omega

/-- `Σ dᵢ 16ⁱ` over `range 65`. -/
public theorem fd_secp256k1_slide.sum_digitTerm (s : Vector (BitVec 8) 32) :
    ∑ k ∈ range (64 + 1), digitTerm (fd_secp256k1_slide.spec s) k = leNat s := by
  rw [← (fd_secp256k1_slide.spec_digits s).2.2, ← Fin.sum_univ_eq_sum_range]
  exact
    Fintype.sum_congr _ _ fun k => by
      rw [digitTerm, dite_eq_left k.isLt]; rfl

end Firedancer.Secp256k1
