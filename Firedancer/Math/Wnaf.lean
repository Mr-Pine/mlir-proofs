module

public import Firedancer.Ref.fd_curve25519_scalar_wnaf
public import Mathlib.Algebra.BigOperators.Group.Finset.Defs
public import Mathlib.Algebra.Ring.Int.Parity
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

/-! The arithmetic of `fd_curve25519_scalar_wnaf.wnaf`: for `x < 2^255` and `bits ≤ 13` its digits
`d_i` sum to `x` as `Σ d_i 2^i`, each `0` or odd in `[-(2^bits - 1), 2^bits - 1]`. -/

namespace MLIR.Firedancer.Ref

namespace fd_curve25519_scalar_wnaf

/-! ## Value -/

section Value

/-- The integer `t` represents: `Σ t[k] 2^k`. -/
def val (t : Vector Int 256) : Int := ∑ k : Fin 256, t[k] * 2 ^ (k : Nat)

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

/-- Bits `0 … n-1` of `x`, weighted, sum to `x % 2^n`. -/
theorem sum_testBit (x : Nat) : ∀ n,
    ∑ k ∈ Finset.range n, (if x.testBit k then (1 : Int) else 0) * 2 ^ k = (x % 2 ^ n : Nat)
  | 0 => by simp [Nat.mod_one]
  | n + 1 => by
    rw [Finset.sum_range_succ, sum_testBit x n, Nat.mod_pow_succ, ← Nat.toNat_testBit]
    cases x.testBit n <;> simp [mul_comm]

/-- The unpacked bits represent `x % 2^255`: `_t[255]` is `0`. -/
theorem val_unpackT (x : BitVec 256) : val (unpackT x) = (x.toNat % 2 ^ 255 : Nat) := by
  unfold val unpackT
  simp only [Fin.getElem_fin, Vector.getElem_ofFn]
  rw [Fin.sum_univ_eq_sum_range
    (fun k => (if k < 255 ∧ x.getLsbD k = true then (1 : Int) else 0) * 2 ^ k) 256,
    Finset.sum_range_succ, ← sum_testBit]
  simp only [lt_irrefl, false_and, ite_false, zero_mul, add_zero]
  refine Finset.sum_congr rfl fun k hk => ?_
  simp [Finset.mem_range.mp hk, BitVec.getLsbD]

end Value

/-! ## The sum -/

section Sum

/-- Entries from `i` on are `0` or `1`. -/
def BitsFrom (i : Nat) (t : Vector Int 256) : Prop :=
  ∀ k (hk : k < 256), i ≤ k → t[k] = 0 ∨ t[k] = 1

/-- The carry from `j < 255`, with `t[255] = 0`, adds `2^(j+1)`, sets a `1` at the index it
returns, keeps entries `≤ j`, and keeps bits after `j`. -/
theorem carryT_spec {t : Vector Int 256} (hj : j < 255) (hn : 255 ≤ j + n) (h255 : t[255] = 0)
    (hb : BitsFrom (j + 1) t) :
    val (carryT n t j).1 = val t + 2 ^ (j + 1) ∧ j < (carryT n t j).2 ∧
      ∃ h : (carryT n t j).2 < 256, (carryT n t j).1[(carryT n t j).2] = 1 ∧
      (∀ k (hk : k < 256), k ≤ j → (carryT n t j).1[k] = t[k]) ∧
      BitsFrom (j + 1) (carryT n t j).1 ∧
      ((carryT n t j).2 < 255 → (carryT n t j).1[255] = 0) := by
  induction n generalizing t j with
  | zero => omega
  | succ n ih =>
    simp only [carryT, show j + 1 < 256 by omega, dite_true]
    split
    next h0 =>
      refine ⟨by rw [val_set, h0]; ring, by omega, by omega, by simp, fun k hk hkj => ?_,
        fun k hk hkj => ?_, fun h => ?_⟩
      · exact Vector.getElem_set_ne (by omega) _ (by omega)
      · rw [Vector.getElem_set]; split
        · exact .inr rfl
        · exact hb k hk hkj
      · rw [Vector.getElem_set_ne _ _ (by omega)]; exact h255
    next h1 =>
      have h1 : t[j + 1] = 1 := (hb (j + 1) (by omega) le_rfl).resolve_left h1
      have hj1 : j + 1 < 255 := by
        by_contra h
        have h1' : t[255] = 1 := by simpa [show j + 1 = 255 by omega] using h1
        omega
      obtain ⟨hv, hlt, hc, hc1, hpre, hbits, h255'⟩ := ih (t := t.set (j + 1) 0) hj1 (by omega)
        (by rw [Vector.getElem_set_ne _ _ (by omega)]; exact h255)
        (fun k hk hkj => by rw [Vector.getElem_set_ne _ _ (by omega)]; exact hb k hk (by omega))
      refine ⟨by rw [hv, val_set, h1]; ring, by omega, hc, hc1, fun k hk hkj => ?_,
        fun k hk hkj => ?_, h255'⟩
      · rw [hpre k hk (by omega), Vector.getElem_set_ne _ _ (by omega)]
      · by_cases hk' : k = j + 1
        · subst hk'; rw [hpre _ hk le_rfl]; simp
        · exact hbits k hk (by omega)

/-- `delta = 2^min (j-i) 14` scales `2^i` to `2^j`, or exceeds `2 max`. -/
theorem delta_cases {max : Int} (hij : i < j) (hm : 2 * max < 2 ^ 14) :
    (2 : Int) ^ min (j - i) 14 * 2 ^ i = 2 ^ j ∨ 2 * max < (2 : Int) ^ min (j - i) 14 := by
  by_cases h : j - i ≤ 14
  · left; rw [min_eq_left h, ← pow_add, Nat.sub_add_cancel hij.le]
  · right; rwa [min_eq_right (by omega)]

/-- What `absorbT` from `(t, ti, j)` guarantees of its result `a`. -/
def AbsorbPost (i : Nat) (hi : i < 256) (t : Vector Int 256) (ti : Int) (j : Nat)
    (a : Vector Int 256 × Int × Nat) : Prop :=
  val (a.1.set i a.2.1 hi) = val (t.set i ti hi) ∧ j ≤ a.2.2 ∧
    (∀ h : a.2.2 < 256, a.1[a.2.2] = 1) ∧ BitsFrom (i + 1) a.1 ∧ (a.2.2 < 255 → a.1[255] = 0)

/-- `absorbT` with `t`'s entries after `i` bits, and `2 max < 2^14`, keeps the value with `ti` at
`i`; see `AbsorbPost`. -/
theorem absorbT_spec {max ti : Int} {t : Vector Int 256} (hm : 2 * max < 2 ^ 14) (hi : i < 256)
    (hij : i < j) (hn : 256 ≤ j + n) (h255 : j < 256 → t[255] = 0) (hb : BitsFrom (i + 1) t) :
    AbsorbPost i hi t ti j (absorbT max i n t ti j) := by
  induction n generalizing t ti j with
  | zero => exact ⟨rfl, le_rfl, fun (h : j < 256) => by omega, hb, fun (h : j < 255) => by omega⟩
  | succ n ih =>
    simp only [absorbT]
    split
    next hj =>
      split
      next h0 =>
        obtain ⟨hv, hle, h1, hb', h255'⟩ :=
          ih (t := t) (ti := ti) (j := j + 1) (by omega) (by omega) (fun _ => h255 hj) hb
        exact ⟨hv, by omega, h1, hb', h255'⟩
      next h0 =>
        have htj : t[j] = 1 := (hb j hj (by omega)).resolve_left h0
        have h255j := h255 hj
        have hj255 : j < 255 := by
          by_contra h
          have : t[255] = 1 := by simpa [show j = 255 by omega] using htj
          omega
        have stop : AbsorbPost i hi t ti j (t, ti, j) :=
          ⟨rfl, le_rfl, fun _ => htj, hb, fun _ => h255j⟩
        have hbs : BitsFrom (i + 1) (t.set j 0) := fun k hk hik => by
          rw [Vector.getElem_set]; split
          · exact .inl rfl
          · exact hb k hk hik
        have hd := delta_cases (max := max) hij hm
        split
        · exact stop
        next hfar =>
          have hd : (2 : Int) ^ min (j - i) 14 * 2 ^ i = 2 ^ j := hd.resolve_right hfar
          split
          · obtain ⟨hv, hle, h1, hb', h255'⟩ := ih (t := t.set j 0) (j := j + 1) (by omega)
              (by omega) (fun _ => by rw [Vector.getElem_set_ne _ _ (by omega)]; exact h255j) hbs
            refine ⟨?_, by omega, h1, hb', h255'⟩
            rw [hv, val_set, val_set, val_set, Vector.getElem_set_ne _ _ (by omega), htj]
            linear_combination hd
          · split
            · obtain ⟨hv, hlt, hc, hc1, hpre, hbits, h255'⟩ := carryT_spec (t := t.set j 0)
                (n := 256) hj255 (by omega)
                (by rw [Vector.getElem_set_ne _ _ (by omega)]; exact h255j)
                fun k hk hjk => hbs k hk (by omega)
              refine ⟨?_, hlt.le, fun _ => hc1, fun k hk hik => ?_, h255'⟩
              · rw [val_set, hv, val_set, val_set, hpre i hi (by omega),
                  Vector.getElem_set_ne _ _ (by omega), htj]
                linear_combination (-1 : Int) * hd
              · by_cases hjk : j < k
                · exact hbits k hk (by omega)
                · rw [hpre k hk (by omega)]; exact hbs k hk hik
            · exact stop
    next hj =>
      exact ⟨rfl, le_rfl, fun (h : j < 256) => by omega, hb, fun (h : j < 255) => by omega⟩

/-- The outer loop from `i`, where `t[i] = 1`, keeps the value. -/
theorem outerT_val {max : Int} {t : Vector Int 256} (hm : 2 * max < 2 ^ 14)
    (h255 : i < 255 → t[255] = 0) (hb : BitsFrom i t) (h1 : ∀ h : i < 256, t[i] = 1) :
    val (outerT max n t i) = val t := by
  induction n generalizing t i with
  | zero => rfl
  | succ n ih =>
    simp only [outerT]
    split
    next hi =>
      obtain ⟨hv, hle, h1', hb', h255'⟩ := absorbT_spec (max := max) (ti := 1) (n := 256) hm hi
        (j := i + 1) (by omega) (by omega) (fun h => h255 (by omega))
        (fun k hk hik => hb k hk (by omega))
      generalize absorbT max i 256 t 1 (i + 1) = a at hv hle h1' hb' h255' ⊢
      obtain ⟨t', ti', j'⟩ := a
      dsimp only at hv hle h1' hb' h255' ⊢
      rw [ih (fun h => ?_) (fun k hk hik => ?_) (fun h => ?_), hv, val_set, h1 hi]
      · ring
      · rw [Vector.getElem_set_ne _ _ (show i ≠ 255 by omega)]; exact h255' h
      · rw [Vector.getElem_set_ne _ _ (show i ≠ k by omega)]; exact hb' k hk (by omega)
      · rw [Vector.getElem_set_ne _ _ (show i ≠ _ by omega)]; exact h1' h
    · rfl

/-- `firstNonzero` with enough fuel stops at a non-zero entry or at `256`. -/
theorem firstNonzero_spec {t : Vector Int 256} (hn : 256 ≤ k + n) :
    ∀ h : firstNonzero t n k < 256, t[firstNonzero t n k] ≠ 0 := by
  induction n generalizing k with
  | zero => intro h; simp only [firstNonzero] at h; omega
  | succ n ih =>
    simp only [firstNonzero]
    split
    next hk =>
      split
      next h0 => exact fun _ => h0
      · exact ih (by omega)
    · intro h; omega

/-- The digits of `wnaf x bits` sum to `x`: `Σ d_i 2^i = x`; no carry leaves `_t`. -/
public theorem wnaf_sum (x : BitVec 256) (hb : bits ≤ 13) (hx : x.toNat < 2 ^ 255) :
    ∑ i : Fin 256, (wnaf x bits)[i] * 2 ^ (i : Nat) = x.toNat := by
  have hm : 2 * ((2 : Int) ^ bits - 1) < 2 ^ 14 := by
    have : (2 : Int) ^ bits ≤ 2 ^ 13 := pow_le_pow_right₀ (by decide) hb
    omega
  change val (wnaf x bits) = _
  have hu : ∀ k (hk : k < 256), (unpackT x)[k] = 0 ∨ (unpackT x)[k] = 1 := fun k hk => by
    simp only [unpackT, Vector.getElem_ofFn]; split <;> simp
  rw [wnaf, outerT_val hm (fun _ => by simp [unpackT]) (fun k hk _ => hu k hk)
    (fun h => (hu _ h).resolve_left (firstNonzero_spec (by omega) h)), val_unpackT,
    Nat.mod_eq_of_lt hx]

end Sum

/-! ## Digits -/

section Digits

/-- Each digit of `wnaf x bits` is `0` or odd, with `|d| ≤ 2^bits - 1`. -/
public theorem wnaf_digit (x : BitVec 256) (hb : 1 ≤ bits) (hk : k < 256) :
    ((wnaf x bits)[k] = 0 ∨ Odd (wnaf x bits)[k]) ∧ (wnaf x bits)[k].natAbs ≤ 2 ^ bits - 1 := by
  have hc : (2 : Int) ^ bits = ((2 ^ bits : Nat) : Int) := by push_cast; rfl
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
    ((wnaf x 4)[k] = 0 ∨ Odd (wnaf x 4)[k]) ∧ (wnaf x 4)[k].natAbs ≤ 15 ∧
      (wnaf x 4)[k].natAbs / 2 < 8 :=
  ⟨(wnaf_digit x (by decide) hk).1, (wnaf_digit x (by decide) hk).2,
    wnaf_index x (by decide) hk⟩

/-- `n2slide`'s digits: `0` or odd, `|d| ≤ 255`, an index into the 128-entry base table. -/
public theorem wnaf8_digit (x : BitVec 256) (hk : k < 256) :
    ((wnaf x 8)[k] = 0 ∨ Odd (wnaf x 8)[k]) ∧ (wnaf x 8)[k].natAbs ≤ 255 ∧
      (wnaf x 8)[k].natAbs / 2 < 128 :=
  ⟨(wnaf_digit x (by decide) hk).1, (wnaf_digit x (by decide) hk).2,
    wnaf_index x (by decide) hk⟩

end Digits

end fd_curve25519_scalar_wnaf

end MLIR.Firedancer.Ref
