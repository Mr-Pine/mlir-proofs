module

public import Firedancer.Leaders.Wsample
public import Firedancer.Leaders.Math.Agave

/-! Arithmetic for the radix-9 tree and Rust's `partition_point`: node numbering, prefix sums,
`compute_height`, and the binary search on a monotone predicate. -/

namespace Firedancer.Leaders.Math

open Firedancer.Leaders Agave

@[expose] public section

/-! ## Node numbering -/

/-- The number of nodes above depth `d`: `Σ_{i<d} 9^i`. -/
def first (d : Nat) : Nat :=
  (9 ^ d - 1) / 8

theorem pow9_mod8 (d : Nat) : 9 ^ d % 8 = 1 := by
  induction d with
  | zero => rfl
  | succ d ih => rw [Nat.pow_succ, Nat.mul_mod, ih]

theorem pow9_pos (d : Nat) : 0 < 9 ^ d :=
  Nat.pow_pos (by decide)

theorem first_succ (d : Nat) : first (d + 1) = first d + 9 ^ d := by
  have h1 := pow9_mod8 d; have h2 := pow9_pos d
  unfold first; rw [Nat.pow_succ]; omega

theorem first_succ' (d : Nat) : first (d + 1) = 9 * first d + 1 := by
  have h1 := pow9_mod8 d; have h2 := pow9_pos d
  unfold first; rw [Nat.pow_succ]; omega

theorem first_mono {d d' : Nat} (h : d ≤ d') : first d ≤ first d' := by
  induction h with
  | refl => exact Nat.le_refl _
  | @step m _ ih =>
    have := pow9_pos m; rw [first_succ]; omega

/-- Nodes `first d + r` (`r < 9^d`) at different depths are different. -/
theorem node_inj {d d' r r' : Nat} (hr : r < 9 ^ d) (hr' : r' < 9 ^ d')
    (h : first d + r = first d' + r') : d = d' ∧ r = r' := by
  rcases Nat.lt_trichotomy d d' with hd | hd | hd
  · have := first_mono (Nat.succ_le_of_lt hd); rw [first_succ] at this; omega
  · subst hd; omega
  · have := first_mono (Nat.succ_le_of_lt hd); rw [first_succ] at this; omega

/-! ## Prefix sums -/

/-- `pre l j`: the sum of the first `j` entries of `l`. -/
def pre : List Nat → Nat → Nat
  | [], _ => 0
  | _ :: _, 0 => 0
  | a :: l, j + 1 => a + pre l j

@[simp]
theorem pre_zero (l : List Nat) : pre l 0 = 0 := by cases l <;> rfl

theorem pre_succ (l : List Nat) (j : Nat) : pre l (j + 1) = pre l j + l.getD j 0 := by
  induction l generalizing j with
  | nil => rfl
  | cons a l ih =>
    cases j with
    | zero => simp [pre]
    | succ j =>
      simp only [pre, ih, List.getD_cons_succ]; omega

theorem pre_mono (l : List Nat) {j j' : Nat} (h : j ≤ j') : pre l j ≤ pre l j' := by
  induction h with
  | refl => exact Nat.le_refl _
  | step _ ih =>
    rw [pre_succ]; omega

theorem pre_of_le (l : List Nat) {j : Nat} (h : l.length ≤ j) : pre l j = pre l l.length := by
  induction l generalizing j with
  | nil => rfl
  | cons a l ih =>
    cases j with
    | zero => simp at h
    | succ j =>
      simp only [pre, List.length_cons];
      rw [ih
          (by
            simp at h; omega)]

theorem pre_append (l : List Nat) (a j : Nat) :
    pre (l ++ [a]) j = pre l j + if l.length < j then a else 0 := by
  induction l generalizing j with
  | nil => cases j <;> simp [pre]
  | cons b l ih =>
    cases j with
    | zero => simp [pre]
    | succ j =>
      simp only [List.cons_append, pre, ih, List.length_cons]; split <;> split <;> omega

theorem pre_length_eq_sum (l : List Nat) : pre l l.length = l.sum := by
  induction l with
  | nil => rfl
  | cons a l ih => simp [pre, ih]

/-! ## `compute_height` -/

theorem compute_height_loop (leaf : BitVec 64) (hleaf : leaf < INT_MAX) :
    ∀ (height internal powRh : BitVec 64) (hpos : 0#64 < powRh) (k : Nat),
      height.toNat = k →
        internal.toNat = first k →
        powRh.toNat = 9 ^ k →
        (k = 0 ∨ 9 ^ (k - 1) < leaf.toNat) →
        ∃ h,
          compute_height.loop leaf hleaf height internal powRh hpos =
              (BitVec.ofNat 64 h, BitVec.ofNat 64 (first h)) ∧
            leaf.toNat ≤ 9 ^ h ∧ (h = 0 ∨ 9 ^ (h - 1) < leaf.toNat) ∧ h < 11 := by
  intro height internal powRh hpos
  induction height, internal, powRh, hpos using compute_height.loop.induct leaf hleaf with
  | case1 height internal powRh hpos hlt ih =>
    intro k hk hi hp _
    have hlt' := BitVec.lt_def.mp hlt
    have hINT : leaf.toNat < 2147483647 := BitVec.lt_def.mp hleaf
    have hk10 : k < 10 := by
      false_or_by_contra
      have : 9 ^ 10 ≤ 9 ^ k := Nat.pow_le_pow_right (by omega) (by omega)
      have : 9 ^ 10 = 3486784401 := by decide
      omega
    have hfk : first k < 2 ^ 40 := by
      have := first_mono (show k ≤ 10 by omega); have : first 10 = 435848050 := by decide
      omega
    obtain ⟨h, heq, hle, hmin, h11⟩ :=
      ih (k + 1)
        (by
          rw [BitVec.toNat_add]; simp; omega)
        (by
          rw [BitVec.toNat_add, first_succ]; simp; omega)
        (by
          rw [compute_height.mul_R hleaf hlt, Nat.pow_succ]; omega)
        (by
          right; rw [hp] at hlt'; simpa using hlt')
    refine ⟨h, ?_, hle, hmin, h11⟩
    rw [compute_height.loop, dite_eq_left_of_eq_true (eq_true hlt)]; exact heq
  | case2 height internal powRh hpos hnlt =>
    intro k hk hi hp hmin
    have hle : leaf.toNat ≤ powRh.toNat := by
      have := hnlt; rw [gt_iff_lt, BitVec.lt_def] at this; omega
    have hINT : leaf.toNat < 2147483647 := BitVec.lt_def.mp hleaf
    have hk11 : k < 11 := by
      rcases hmin with h0 | h0
      · omega
      · false_or_by_contra
        have : 9 ^ 10 ≤ 9 ^ (k - 1) := Nat.pow_le_pow_right (by omega) (by omega)
        have : 9 ^ 10 = 3486784401 := by decide
        omega
    refine ⟨k, ?_, by omega, hmin, hk11⟩
    rw [compute_height.loop, dite_eq_right_of_eq_false (eq_false hnlt)]
    congr 1
    · apply BitVec.eq_of_toNat_eq; simp; omega
    · apply BitVec.eq_of_toNat_eq; rw [hi]; simp
      have := first_mono (show k ≤ 10 by omega); have : first 10 = 435848050 := by decide
      omega

/-- `compute_height` for `1 ≤ leaf < INT_MAX`: height `h` with `9^(h-1) < leaf ≤ 9^h` and
`first h` internal nodes. -/
theorem compute_height_eq (leaf : BitVec 64) (h1 : leaf.toNat < 2147483647) :
    ∃ h,
      compute_height.spec leaf = some (BitVec.ofNat 64 h, BitVec.ofNat 64 (first h)) ∧
        leaf.toNat ≤ 9 ^ h ∧ (h = 0 ∨ 9 ^ (h - 1) < leaf.toNat) ∧ h < 11 := by
  have hl : ¬leaf ≥ INT_MAX := by
    simp [INT_MAX, BitVec.le_def]; omega
  obtain ⟨h, heq, hle, hmin, h11⟩ :=
    compute_height_loop leaf (by bv_omega) 0#64 0#64 1#64 (by decide) 0 rfl rfl rfl (Or.inl rfl)
  exact
    ⟨h, by rw [compute_height.spec, dite_eq_right_of_eq_false (eq_false hl), heq], hle, hmin, h11⟩

/-! ## `partition_point` -/

theorem binarySearchLoop_spec {α : Type} [Inhabited α] (a : Array α) (pred : α → Bool) (P : Nat)
    (htrue : ∀ i, i < P → pred a[i]! = true) :
    ∀ size base,
      1 ≤ size →
        base + size ≤ a.size →
        (base = 0 ∨ pred a[base]! = true) →
        P ≤ base + size →
        binarySearchLoop a (fun x => if pred x then .lt else .gt) base size < a.size ∧
          (binarySearchLoop a (fun x => if pred x then .lt else .gt) base size = 0 ∨
            pred a[binarySearchLoop a (fun x => if pred x then .lt else .gt) base size]! = true) ∧
          P ≤ binarySearchLoop a (fun x => if pred x then .lt else .gt) base size + 1 := by
  intro size
  induction size using Nat.strongRecOn with
  | _ size ih =>
    intro base h1 h2 h3 h4
    rw [binarySearchLoop]
    by_cases hs : size > 1
    · rw [dite_eq_left_of_eq_true (eq_true hs)]
      simp only
      by_cases hp : pred a[base + size / 2]! = true
      · rw [ite_eq_right (by simp [hp])]
        exact ih (size - size / 2) (by omega) _ (by omega) (by omega) (Or.inr hp) (by omega)
      · rw [ite_eq_left (by simp [hp])]
        have : P ≤ base + size / 2 := by
          false_or_by_contra
          exact hp (htrue _ (by omega))
        exact ih (size - size / 2) (by omega) _ (by omega) (by omega) h3 (by omega)
    · rw [dite_eq_right_of_eq_false (eq_false hs)]
      exact ⟨by omega, h3, by omega⟩

/-- On a predicate true exactly below `P`, `partition_point` returns `P`. -/
theorem partition_point_eq {α : Type} [Inhabited α] (a : Array α) (pred : α → Bool) (P : Nat)
    (hP : P ≤ a.size) (htrue : ∀ i, i < P → pred a[i]! = true)
    (hfalse : ∀ i, P ≤ i → i < a.size → pred a[i]! = false) : partition_point a pred = P := by
  unfold partition_point binary_search_by
  by_cases h0 : a.size = 0
  · simp only [h0, ite_true]; omega
  · rw [ite_eq_right h0]
    obtain ⟨hlt, hb, hP'⟩ :=
      binarySearchLoop_spec a pred P htrue a.size 0 (by omega) (by omega) (Or.inl rfl) (by omega)
    generalize binarySearchLoop a (fun x => if pred x then .lt else .gt) 0 a.size = b at hlt hb hP'
    by_cases hpb : pred a[b]! = true
    · simp only [hpb, ite_true, reduceCtorEq, ite_false]
      have := htrue
      false_or_by_contra <;> rename_i hne
      · rcases Nat.lt_or_ge (b + 1) P with h | h
        · omega
        · have := hfalse b (by omega) hlt; simp_all
    · have hf : pred a[b]! = false := by simpa using hpb
      simp only [hf, Bool.false_eq_true, ite_false, reduceCtorEq]
      rcases hb with hb | hb
      · subst hb
        rcases Nat.eq_zero_or_pos P with h | h
        · simp [h]
        · have := htrue 0 h; simp_all
      · simp_all

end

end Firedancer.Leaders.Math
