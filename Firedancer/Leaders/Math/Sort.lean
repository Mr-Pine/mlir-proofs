module

public import Firedancer.Leaders.Sort

/-! `fd_sort_inplace` (`fd_sort.c`) sorts: for a strict weak order `before`, with its fuel it returns
a permutation of the input in which no element is `before` an earlier one. -/

namespace Firedancer.Leaders.Math

open Firedancer.Leaders

@[expose] public section

set_option linter.unusedSectionVars false
variable {α : Type} [Inhabited α] [DecidableEq α]

/-! ## Segments -/

/-- The elements `key[l, h)`. -/
def seg (key : Array α) (l h : Nat) : List α :=
  (key.toList.take h).drop l

/-- `key` is `key0` permuted inside `[l, h)`. -/
def Seg (key key0 : Array α) (l h : Nat) : Prop :=
  key.size = key0.size ∧
    (∀ t, (t < l ∨ h ≤ t) → key[t]! = key0[t]!) ∧ (seg key l h).Perm (seg key0 l h)

theorem seg_length (key : Array α) (l h : Nat) (hh : h ≤ key.size) :
    (seg key l h).length = h - l := by
  simp [seg]; omega

theorem seg_getElem (key : Array α) (l h t : Nat) (hh : h ≤ key.size)
    (ht : t < (seg key l h).length) : (seg key l h)[t] = key[l + t]! := by
  rw [seg_length key l h hh] at ht
  rw [getElem!_pos key (l + t) (by omega)]
  simp [seg]

theorem mem_seg (key : Array α) (l h : Nat) (hh : h ≤ key.size) (x : α) :
    x ∈ seg key l h ↔ ∃ t, l ≤ t ∧ t < h ∧ key[t]! = x := by
  rw [List.mem_iff_getElem]
  constructor
  · rintro ⟨t, ht, rfl⟩
    have := seg_length key l h hh
    exact ⟨l + t, by omega, by omega, (seg_getElem key l h t hh ht).symm⟩
  · rintro ⟨t, ht1, ht2, rfl⟩
    have := seg_length key l h hh
    exact
      ⟨t - l, by omega, by
        rw [seg_getElem key l h _ hh]; congr 1; omega⟩

theorem seg_ext (key key' : Array α) (l h : Nat) (hh : h ≤ key.size) (hh' : h ≤ key'.size)
    (heq : ∀ t, l ≤ t → t < h → key[t]! = key'[t]!) : seg key l h = seg key' l h := by
  apply List.ext_getElem
  · rw [seg_length _ _ _ hh, seg_length _ _ _ hh']
  · intro t h1 h2
    rw [seg_getElem _ _ _ _ hh, seg_getElem _ _ _ _ hh']
    have := seg_length key l h hh
    exact heq _ (by omega) (by omega)

theorem seg_split (key : Array α) {l m h : Nat} (h1 : l ≤ m) (h2 : m ≤ h) (hh : h ≤ key.size) :
    seg key l h = seg key l m ++ seg key m h := by
  apply List.ext_getElem
  · simp only [List.length_append, seg_length _ _ _ hh, seg_length _ _ _ (Nat.le_trans h2 hh)];
    omega
  · intro t ht1 ht2
    have e1 := seg_length key l m (Nat.le_trans h2 hh)
    rw [List.getElem_append]
    split
    · rw [seg_getElem _ _ _ _ hh, seg_getElem _ _ _ _ (Nat.le_trans h2 hh)]
    · rw [seg_getElem _ _ _ _ hh, seg_getElem _ _ _ _ hh]; congr 1; omega

theorem Seg.refl (key : Array α) (l h : Nat) : Seg key key l h :=
  ⟨rfl, fun _ _ => rfl, List.Perm.refl _⟩

theorem Seg.trans {k1 k2 k3 : Array α} {l h : Nat} (h12 : Seg k1 k2 l h) (h23 : Seg k2 k3 l h) :
    Seg k1 k3 l h :=
  ⟨h12.1.trans h23.1, fun t ht => (h12.2.1 t ht).trans (h23.2.1 t ht), h12.2.2.trans h23.2.2⟩

/-- Widening the interval keeps `Seg`. -/
theorem Seg.widen {k k0 : Array α} {l h l' h' : Nat} (hs : Seg k k0 l h) (hl : l' ≤ l) (hlh : l ≤ h)
    (hh : h ≤ h') (hh' : h' ≤ k0.size) : Seg k k0 l' h' := by
  obtain ⟨hsz, hout, hp⟩ := hs
  refine ⟨hsz, fun t ht => hout t (by omega), ?_⟩
  have hk : h' ≤ k.size := by
    rw [hsz]; exact hh'
  rw [seg_split k hl (Nat.le_trans hlh hh) hk, seg_split k hlh hh hk,
    seg_split k0 hl (Nat.le_trans hlh hh) hh', seg_split k0 hlh hh hh']
  rw [seg_ext k k0 l' l (by omega) (by omega) (fun t _ ht => hout t (Or.inl ht)),
    seg_ext k k0 h h' hk hh' (fun t ht _ => hout t (Or.inr ht))]
  exact List.Perm.append_left _ (List.Perm.append_right _ hp)

theorem Seg.perm {k k0 : Array α} {l h : Nat} (hs : Seg k k0 l h) (hl : l = 0) (hh : h = k0.size) :
    k.toList.Perm k0.toList := by
  have := hs.2.2
  subst hl hh
  simp only [seg, List.drop_zero] at this
  rwa [List.take_of_length_le (by simp [hs.1]), List.take_of_length_le (by simp)] at this

theorem Seg.mem {k k0 : Array α} {l h : Nat} (hs : Seg k k0 l h) (hh : h ≤ k0.size) {t : Nat}
    (ht1 : l ≤ t) (ht2 : t < h) : ∃ t', l ≤ t' ∧ t' < h ∧ k0[t']! = k[t]! := by
  have : k[t]! ∈ seg k l h :=
    (mem_seg k l h
          (by
            rw [hs.1]; exact hh)
          _).mpr
      ⟨t, ht1, ht2, rfl⟩
  exact (mem_seg k0 l h hh _).mp (hs.2.2.subset this)

theorem Seg.mem' {k k0 : Array α} {l h : Nat} (hs : Seg k k0 l h) (hh : h ≤ k0.size) {t : Nat}
    (ht1 : l ≤ t) (ht2 : t < h) : ∃ t', l ≤ t' ∧ t' < h ∧ k[t']! = k0[t]! := by
  have : k0[t]! ∈ seg k0 l h := (mem_seg k0 l h hh _).mpr ⟨t, ht1, ht2, rfl⟩
  exact
    (mem_seg k l h
          (by
            rw [hs.1]; exact hh)
          _).mp
      (hs.2.2.symm.subset this)

/-! ## Swaps -/

/-- Swapping positions `a` and `b` (`key[a] := key[b]; key[b] := old key[a]`). -/
def swap (key : Array α) (a b : Nat) : Array α :=
  (key.set! a key[b]!).set! b key[a]!

theorem swap_size (key : Array α) (a b : Nat) : (swap key a b).size = key.size := by simp [swap]

theorem swap_get (key : Array α) (a b t : Nat) (ha : a < key.size) (hb : b < key.size) :
    (swap key a b)[t]! = if t = b then key[a]! else if t = a then key[b]! else key[t]! := by
  by_cases ht : t < key.size
  · simp only [swap, Array.set!_eq_setIfInBounds]
    rw [getElem!_pos _ t
        (by
          simp; omega),
      Array.getElem_setIfInBounds
        (by
          simp; omega),
      Array.getElem_setIfInBounds ht]
    by_cases h1 : t = b
    · subst h1; simp
    · by_cases h2 : t = a
      · subst h2; simp [h1, Ne.symm h1]
      · simp [h1, h2, Ne.symm h1, Ne.symm h2, getElem!_pos key t ht]
  · rw [getElem!_neg _ t
        (by
          rw [swap_size]; exact ht),
      getElem!_neg key t ht]
    simp [show t ≠ b by omega, show t ≠ a by omega]

/-- A swap inside `[l, h)` permutes `[l, h)`. -/
theorem Seg.swap (key : Array α) (l h a b : Nat) (hh : h ≤ key.size) (ha1 : l ≤ a) (ha2 : a < h)
    (hb1 : l ≤ b) (hb2 : b < h) : Seg (Math.swap key a b) key l h := by
  refine ⟨swap_size key a b, fun t ht => ?_, ?_⟩
  · rw [swap_get key a b t (by omega) (by omega)]
    simp [show t ≠ b by omega, show t ≠ a by omega]
  · rw [List.perm_iff_count]
    intro x
    have hseg :
      seg (Math.swap key a b) l h = ((seg key l h).set (a - l) key[b]!).set (b - l) key[a]! := by
      apply List.ext_getElem
      · simp [seg_length _ _ _
              (show h ≤ (Math.swap key a b).size by
                rw [swap_size]; exact hh),
          seg_length _ _ _ hh]
      · intro t h1 h2
        have hl := seg_length key l h hh
        rw [seg_getElem _ _ _ _
            (by
              rw [swap_size]; exact hh),
          swap_get key a b _ (by omega) (by omega)]
        simp only [List.getElem_set]
        rw [seg_getElem _ _ _ _ hh]
        by_cases e1 : l + t = b
        · simp [e1, show b - l = t by omega]
        · by_cases e2 : l + t = a
          · simp [e2, show a - l = t by omega, show b - l ≠ t by omega]; intro; omega
          · simp [e1, e2, show a - l ≠ t by omega, show b - l ≠ t by omega]
    have hl := seg_length key l h hh
    rw [hseg,
      List.count_set
        (by
          simp only [List.length_set]; omega),
      List.count_set (by omega)]
    simp only [List.getElem_set]
    rw [seg_getElem _ _ _ _ hh, seg_getElem _ _ _ _ hh]
    simp only [show l + (b - l) = b by omega, show l + (a - l) = a by omega]
    have := List.count_pos_iff (a := key[a]!) (l := seg key l h)
    have := List.count_pos_iff (a := key[b]!) (l := seg key l h)
    have m1 : key[a]! ∈ seg key l h := (mem_seg key l h hh _).mpr ⟨a, ha1, ha2, rfl⟩
    have m2 : key[b]! ∈ seg key l h := (mem_seg key l h hh _).mpr ⟨b, hb1, hb2, rfl⟩
    by_cases e : a - l = b - l
    · have : a = b := by omega
      subst this
      by_cases x1 : key[a]! = x <;> simp_all <;> omega
    · simp only [e, ite_false]
      by_cases x1 : key[a]! = x <;> by_cases x2 : key[b]! = x <;> simp_all <;> omega

theorem ext_getElem! (a b : Array α) (hs : a.size = b.size) (h : ∀ t, t < a.size → a[t]! = b[t]!) :
    a = b := by
  apply Array.ext hs
  intro t h1 h2
  have := h t h1
  rwa [getElem!_pos a t h1, getElem!_pos b t h2] at this

theorem set!_get (a : Array α) (i t : Nat) (v : α) (hi : i < a.size) :
    (a.set! i v)[t]! = if t = i then v else a[t]! := by
  by_cases ht : t < a.size
  · rw [getElem!_pos _ t
        (by
          simp; omega),
      getElem!_pos a t ht]
    simp only [Array.set!_eq_setIfInBounds, Array.getElem_setIfInBounds ht]
    by_cases e : t = i
    · subst e; simp
    · simp [e, Ne.symm e]
  · rw [getElem!_neg _ t
        (by
          simp; omega),
      getElem!_neg a t ht];
    simp [show t ≠ i by omega]

theorem set!_size (a : Array α) (i : Nat) (v : α) : (a.set! i v).size = a.size := by simp

/-! ## Strict weak orders -/

/-- `before` is a strict weak order. -/
structure StrictWeak (before : α → α → Bool) : Prop where
  irrefl : ∀ a, before a a = false
  trans : ∀ a b c, before a b = true → before b c = true → before a c = true
  split : ∀ a b c, before a c = true → before a b = true ∨ before b c = true

variable {before : α → α → Bool}

theorem StrictWeak.asymm (hw : StrictWeak before) {a b : α} (h : before a b = true) :
    before b a = false := by
  cases hb : before b a
  · rfl
  · have := hw.trans _ _ _ h hb; rw [hw.irrefl] at this; exact absurd this (by simp)

theorem StrictWeak.le_trans (hw : StrictWeak before) {a b c : α} (h1 : before b a = false)
    (h2 : before c b = false) : before c a = false := by
  cases h : before c a
  · rfl
  · rcases hw.split c b a h with h' | h' <;> simp_all

/-- `key[l, h)` is sorted: no element is `before` an earlier one. -/
def SortedOn (before : α → α → Bool) (key : Array α) (l h : Nat) : Prop :=
  ∀ p q, l ≤ p → p < q → q < h → before key[q]! key[p]! = false

theorem SortedOn.le (hw : StrictWeak before) {key : Array α} {l h : Nat}
    (hs : SortedOn before key l h) {p q : Nat} (h1 : l ≤ p) (h2 : p ≤ q) (h3 : q < h) :
    before key[q]! key[p]! = false := by
  rcases Nat.lt_or_eq_of_le h2 with h | h
  · exact hs p q h1 h h3
  · subst h; exact hw.irrefl _

/-! ## Insertion sort -/

/-- The inner loop state at hole `J`: `A` is `B` with `B[off+J, off+i)` shifted up by one, except
at the hole; the shifted elements are all after `key_i`. -/
def InnerInv (before : α → α → Bool) (B : Array α) (off i : Nat) (key_i : α) (A : Array α)
    (J : Nat) : Prop :=
  J ≤ i ∧
    A.size = B.size ∧
    (∀ t, t ≠ off + J → A[t]! = if off + J < t ∧ t ≤ off + i then B[t - 1]! else B[t]!) ∧
    Seg (A.set! (off + J) key_i) B off (off + i + 1) ∧
    ∀ t, J < t → t ≤ i → before key_i B[off + t - 1]! = true

theorem inner_spec (B : Array α) (off i : Nat) (key_i : α) (hB : off + i < B.size) :
    ∀ J A,
      InnerInv before B off i key_i A J →
        InnerInv before B off i key_i (fd_sort_insert.inner before off key_i A J).1
            (fd_sort_insert.inner before off key_i A J).2 ∧
          ((fd_sort_insert.inner before off key_i A J).2 = 0 ∨
            before key_i B[off + (fd_sort_insert.inner before off key_i A J).2 - 1]! = false) := by
  intro J
  induction J with
  | zero =>
    intro A hA; exact ⟨hA, Or.inl rfl⟩
  | succ J ih =>
    intro A hA
    obtain ⟨hJi, hsz, hval, hseg, hshift⟩ := hA
    have hkj : A[off + J]! = B[off + J]! := by
      rw [hval _ (by omega)]; simp [show ¬off + (J + 1) < off + J by omega]
    simp only [fd_sort_insert.inner, hkj]
    by_cases hb : before key_i B[off + J]! = true
    · simp only [hb, Bool.not_true, Bool.false_eq_true, ite_false]
      apply ih
      refine ⟨by omega, by simp [hsz], fun t ht => ?_, ?_, fun t ht1 ht2 => ?_⟩
      · rw [set!_get _ _ _ _
            (by
              rw [hsz]; omega)]
        by_cases e : t = off + (J + 1)
        · subst e; simp [show off + J < off + (J + 1) by omega]; omega
        · rw [ite_eq_right e, hval t (by omega)]
          by_cases e2 : off + (J + 1) < t ∧ t ≤ off + i
          · simp [e2, show off + J < t by omega]
          · rw [ite_eq_right e2]
            rw [ite_eq_right (by omega)]
      · have heq :
          (A.set! (off + (J + 1)) B[off + J]!).set! (off + J) key_i =
            swap (A.set! (off + (J + 1)) key_i) (off + J) (off + (J + 1)) := by
          apply ext_getElem! _ _ (by simp [swap_size])
          intro t _
          rw [swap_get _ _ _ _
              (by
                simp; omega)
              (by
                simp; omega),
            set!_get _ _ _ _
              (by
                simp; omega),
            set!_get _ _ _ _ (by omega), set!_get _ _ _ _ (by omega), set!_get _ _ _ _ (by omega)]
          by_cases e1 : t = off + (J + 1)
          · simp [e1, hkj]
          · by_cases e2 : t = off + J
            · simp [e2]
            · simp only [e1, e2, ite_false]
              rw [set!_get _ _ _ _ (by omega), ite_eq_right e1]
        rw [heq]
        exact
          (Seg.swap _ off (off + i + 1) _ _
                (by
                  simp; omega)
                (by omega) (by omega) (by omega) (by omega)).trans
            hseg
      · rcases Nat.lt_or_eq_of_le (show J + 1 ≤ t by omega) with h | h
        · exact hshift t h ht2
        · subst h; simpa using hb
    · simp only [Bool.not_eq_true] at hb
      simp only [hb, Bool.not_false, ite_true]
      exact ⟨⟨hJi, hsz, hval, hseg, hshift⟩, Or.inr (by simpa using hb)⟩

/-- One insertion step: inserting `key[off+i]` into the sorted `key[off, off+i)`. -/
theorem insert_step (hw : StrictWeak before) (key : Array α) (off i : Nat) (hB : off + i < key.size)
    (hs : SortedOn before key off (off + i)) :
    let r := fd_sort_insert.inner before off key[off + i]! key i
    Seg (r.1.set! (off + r.2) key[off + i]!) key off (off + i + 1) ∧
      SortedOn before (r.1.set! (off + r.2) key[off + i]!) off (off + i + 1) := by
  intro r
  have h0 : InnerInv before key off i key[off + i]! key i := by
    refine ⟨Nat.le_refl _, rfl, fun t ht => ?_, ?_, fun t h1 h2 => by omega⟩
    · rw [ite_eq_right (by omega)]
    · have : key.set! (off + i) key[off + i]! = key := by
        apply ext_getElem! _ _ (by simp)
        intro t _; rw [set!_get _ _ _ _ hB]; split <;> simp_all
      rw [this]; exact Seg.refl _ _ _
  obtain ⟨⟨hJi, hsz, hval, hseg, hshift⟩, hfit⟩ := inner_spec key off i key[off + i]! hB i key h0
  refine ⟨hseg, ?_⟩
  generalize r.2 = J at *
  generalize r.1 = A at *
  -- values of the result
  have hV :
    ∀ t,
      (A.set! (off + J) key[off + i]!)[t]! =
        if t = off + J then key[off + i]!
        else if off + J < t ∧ t ≤ off + i then key[t - 1]! else key[t]! := by
    intro t
    rw [set!_get _ _ _ _ (by omega)]
    split
    · rfl
    · exact hval t (by assumption)
  intro p q hp hpq hq
  rw [hV p, hV q]
  by_cases hqJ : q = off + J
  · have hpJ : p ≠ off + J := by omega
    rw [ite_eq_left hqJ, ite_eq_right hpJ, ite_eq_right (by omega)]
    rcases hfit with h0 | h0
    · omega
    · exact hw.le_trans (hs.le hw hp (by omega) (by omega)) h0
  · rw [ite_eq_right hqJ]
    by_cases hq2 : off + J < q ∧ q ≤ off + i
    · rw [ite_eq_left hq2]
      by_cases hpJ : p = off + J
      · rw [ite_eq_left hpJ]
        exact
          hw.asymm
            (by
              have := hshift (q - off) (by omega) (by omega);
              rwa [show off + (q - off) - 1 = q - 1 by omega] at this)
      · rw [ite_eq_right hpJ]
        split <;> rename_i hsp
        · exact hs (p - 1) (q - 1) (by omega) (by omega) (by omega)
        · exact hs p (q - 1) hp (by omega) (by omega)
    · rw [ite_eq_right hq2]
      have hpJ : p ≠ off + J := by omega
      rw [ite_eq_right hpJ, ite_eq_right (by omega)]
      exact hs p q hp hpq (by omega)

theorem outer_spec (hw : StrictWeak before) (key0 : Array α) (off cnt : Nat)
    (hc : off + cnt ≤ key0.size) :
    ∀ n i key,
      cnt - i = n →
        1 ≤ i →
        Seg key key0 off (off + cnt) →
        SortedOn before key off (off + min i cnt) →
        Seg (fd_sort_insert.outer before off cnt key i) key0 off (off + cnt) ∧
          SortedOn before (fd_sort_insert.outer before off cnt key i) off (off + cnt) := by
  intro n
  induction n with
  | zero =>
    intro i key hn hi hseg hs
    rw [fd_sort_insert.outer, ite_eq_right (by omega)]
    exact ⟨hseg, by rwa [show min i cnt = cnt by omega] at hs⟩
  | succ n ih =>
    intro i key hn hi hseg hs
    rw [fd_sort_insert.outer, ite_eq_left (by omega)]
    have hsz := hseg.1
    obtain ⟨h1, h2⟩ :=
      insert_step hw key off i (by omega) (by rwa [show min i cnt = i by omega] at hs)
    exact
      ih (i + 1) _ (by omega) (by omega)
        ((h1.widen (Nat.le_refl _) (by omega) (by omega) (by omega)).trans hseg)
        (by rwa [show min (i + 1) cnt = i + 1 by omega])

/-- `SORT_(insert)( key+l, n )` sorts `key[l, l+n)` in place. -/
theorem insert_spec (hw : StrictWeak before) (key : Array α) (l n : BitVec 64)
    (hc : l.toNat + n.toNat ≤ key.size) :
    Seg (fd_sort_insert.spec before key l n) key l.toNat (l.toNat + n.toNat) ∧
      SortedOn before (fd_sort_insert.spec before key l n) l.toNat (l.toNat + n.toNat) := by
  unfold fd_sort_insert.spec
  rcases Nat.eq_zero_or_pos n.toNat with h0 | h0
  · rw [h0, fd_sort_insert.outer, ite_eq_right (by omega)]
    exact ⟨Seg.refl _ _ _, fun p q _ _ _ => by omega⟩
  · exact
      outer_spec hw key l.toNat n.toNat hc _ 1 key rfl (Nat.le_refl _) (Seg.refl _ _ _)
        (fun p q _ _ _ => by omega)

/-! ## Three-way partition -/

/-- `x` lies between the pivots: not before `p1`, and `p2` not before it. -/
def Mid (before : α → α → Bool) (p1 p2 x : α) : Prop :=
  before x p1 = false ∧ before p2 x = false

/-- `key[l, h)` is `key0[l, h)` permuted into `[l, I)` before `p1`, `[I, J)` between the pivots
and `[J, h)` after `p2`. -/
def Parted (before : α → α → Bool) (key0 : Array α) (l h : Nat) (p1 p2 : α) (key : Array α)
    (I J : Nat) : Prop :=
  Seg key key0 l h ∧
    l ≤ I ∧
    I ≤ J ∧
    J ≤ h ∧
    (∀ t, l ≤ t → t < I → before key[t]! p1 = true) ∧
    (∀ t, I ≤ t → t < J → Mid before p1 p2 key[t]!) ∧
    (∀ t, J ≤ t → t < h → before p2 key[t]! = true)

/-- An element between the pivots makes the middle part non-empty. -/
theorem Parted.mid_pos {key0 key : Array α} {l h I J : Nat} {p1 p2 e0 : α}
    (hp : Parted before key0 l h p1 p2 key I J) (hh : h ≤ key0.size) (he0 : e0 ∈ seg key0 l h)
    (hm : Mid before p1 p2 e0) : I < J := by
  obtain ⟨hseg, hl, hIJ, hJ, hleft, -, hright⟩ := hp
  have : e0 ∈ seg key l h := hseg.2.2.symm.subset he0
  obtain ⟨t, ht1, ht2, hte⟩ :=
    (mem_seg key l h
          (by
            rw [hseg.1]; exact hh)
          e0).mp
      this
  false_or_by_contra
  rcases Nat.lt_or_ge t I with h1 | h1
  · have := hleft t ht1 h1; rw [hte, hm.1] at this; exact absurd this (by simp)
  · have := hright t (by omega) ht2; rw [hte, hm.2] at this; exact absurd this (by simp)

theorem swap_self (key : Array α) (a : Nat) (ha : a < key.size) : swap key a a = key := by
  apply ext_getElem! _ _ (swap_size _ _ _)
  intro t _
  rw [swap_get _ _ _ _ ha ha]; split <;> simp_all

theorem partition_spec (hw : StrictWeak before) (p1 p2 e0 : α) (hp : before p2 p1 = false)
    (key0 : Array α) (l h : Nat) (hh : h ≤ key0.size) (hsz : key0.size < 2 ^ 62)
    (he0 : e0 ∈ seg key0 l h) (hm : Mid before p1 p2 e0) :
    ∀ fuel key (i j k : BitVec 64),
      Seg key key0 l h →
        l ≤ i.toNat →
        i.toNat ≤ j.toNat →
        j.toNat ≤ k.toNat →
        k.toNat < h →
        (∀ t, l ≤ t → t < i.toNat → before key[t]! p1 = true) →
        (∀ t, i.toNat ≤ t → t < j.toNat → Mid before p1 p2 key[t]!) →
        (∀ t, k.toNat < t → t < h → before p2 key[t]! = true) →
        k.toNat + 1 - j.toNat < fuel →
        ∃ key' I' J' kk,
          fd_sort_private_quick.partition before p1 p2 fuel key i j k =
              .done (key', BitVec.ofNat 64 I', BitVec.ofNat 64 J', kk) ∧
            Parted before key0 l h p1 p2 key' I' J' := by
  intro fuel
  induction fuel with
  | zero =>
    intro key i j k _ _ _ _ _ _ _ _ hf; omega
  | succ fuel ih =>
    intro key i j k hseg hl hij hjk hkh hleft hmid hright hf
    have hks : key.size = key0.size := hseg.1
    have hbound : ∀ x : BitVec 64, x.toNat < 2 ^ 62 → BitVec.ofNat 64 x.toNat = x := by
      intro x _; simp
    simp only [fd_sort_private_quick.partition]
    -- the element under `j`
    by_cases hr : before p2 key[j.toNat]! = true
    · have hnl : before key[j.toNat]! p1 = false := by
        cases hc : before key[j.toNat]! p1
        · rfl
        · have := hw.trans _ _ _ hr hc; rw [hp] at this; exact absurd this (by simp)
      simp only [hr, hnl, ite_true, Bool.false_eq_true, ite_false]
      have hswap :
        (key.set! j.toNat key[k.toNat]!).set! k.toNat key[j.toNat]! = swap key j.toNat k.toNat :=
        rfl
      rw [hswap]
      have hseg' :=
        (Seg.swap key l h j.toNat k.toNat (by omega) (by omega) (by omega) (by omega)
              (by omega)).trans
          hseg
      have hval :
        ∀ t,
          (swap key j.toNat k.toNat)[t]! =
            if t = k.toNat then key[j.toNat]! else if t = j.toNat then key[k.toNat]! else key[t]! :=
        fun t => swap_get _ _ _ t (by omega) (by omega)
      have hleft' : ∀ t, l ≤ t → t < i.toNat → before (swap key j.toNat k.toNat)[t]! p1 = true :=
        fun t h1 h2 => by
        rw [hval, ite_eq_right (by omega), ite_eq_right (by omega)]; exact hleft t h1 h2
      have hmid' :
        ∀ t, i.toNat ≤ t → t < j.toNat → Mid before p1 p2 (swap key j.toNat k.toNat)[t]! :=
        fun t h1 h2 => by
        rw [hval, ite_eq_right (by omega), ite_eq_right (by omega)]; exact hmid t h1 h2
      have hright' :
        ∀ t, k.toNat ≤ t → t < h → before p2 (swap key j.toNat k.toNat)[t]! = true := by
        intro t h1 h2
        rw [hval]
        by_cases e : t = k.toNat
        · rw [ite_eq_left e]; exact hr
        · rw [ite_eq_right e, ite_eq_right (by omega)]; exact hright t (by omega) h2
      by_cases hjk' : j.toNat < k.toNat
      · have hk1 : (k - 1#64).toNat = k.toNat - 1 := by
          rw [BitVec.toNat_sub_of_le
              (by
                rw [BitVec.le_def]; simp; omega)];
          simp
        rw [ite_eq_left
            (show j + 0#64 ≤ k - 1#64 by
              rw [BitVec.le_def, hk1]; simp; omega)]
        simp only [BitVec.add_zero]
        exact
          ih _ i j (k - 1#64) hseg' hl hij (by omega) (by omega) hleft' hmid'
            (fun t h1 h2 => hright' t (by omega) h2) (by omega)
      · -- `j = k`: the partition is complete
        have hjk_eq : j.toNat = k.toNat := by omega
        have hpart : Parted before key0 l h p1 p2 (swap key j.toNat k.toNat) i.toNat j.toNat :=
          ⟨hseg', hl, hij, by omega, hleft', hmid', fun t h1 h2 => hright' t (by omega) h2⟩
        have hpos := hpart.mid_pos hh he0 hm
        have hk1 : (k - 1#64).toNat = k.toNat - 1 := by
          rw [BitVec.toNat_sub_of_le
              (by
                rw [BitVec.le_def]; simp; omega)];
          simp
        rw [ite_eq_right
            (show ¬j + 0#64 ≤ k - 1#64 by
              rw [BitVec.le_def, hk1]; simp; omega)]
        refine ⟨_, i.toNat, j.toNat, k - 1#64, ?_, hpart⟩
        simp only [BitVec.add_zero, hbound i (by omega), hbound j (by omega)]
    · simp only [Bool.not_eq_true] at hr
      by_cases hlft : before key[j.toNat]! p1 = true
      · simp only [hr, hlft, ite_true, Bool.false_eq_true, ite_false]
        have hswap :
          (key.set! j.toNat key[i.toNat]!).set! i.toNat key[j.toNat]! = swap key j.toNat i.toNat :=
          rfl
        rw [hswap]
        have hseg' :=
          (Seg.swap key l h j.toNat i.toNat (by omega) (by omega) (by omega) (by omega)
                (by omega)).trans
            hseg
        have hval :
          ∀ t,
            (swap key j.toNat i.toNat)[t]! =
              if t = i.toNat then key[j.toNat]!
              else if t = j.toNat then key[i.toNat]! else key[t]! :=
          fun t => swap_get _ _ _ t (by omega) (by omega)
        have hi1 : (i + 1#64).toNat = i.toNat + 1 := by
          simp; omega
        have hj1 : (j + 1#64).toNat = j.toNat + 1 := by
          simp; omega
        have hleft' :
          ∀ t, l ≤ t → t < i.toNat + 1 → before (swap key j.toNat i.toNat)[t]! p1 = true := by
          intro t h1 h2
          rw [hval]
          by_cases e : t = i.toNat
          · rw [ite_eq_left e]; exact hlft
          · rw [ite_eq_right e, ite_eq_right (by omega)]; exact hleft t h1 (by omega)
        have hmid' :
          ∀ t,
            i.toNat + 1 ≤ t →
              t < j.toNat + 1 → Mid before p1 p2 (swap key j.toNat i.toNat)[t]! := by
          intro t h1 h2
          rw [hval, ite_eq_right (by omega)]
          by_cases e : t = j.toNat
          · rw [ite_eq_left e]; exact hmid _ (Nat.le_refl _) (by omega)
          · rw [ite_eq_right e]; exact hmid t (by omega) (by omega)
        have hright' : ∀ t, k.toNat < t → t < h → before p2 (swap key j.toNat i.toNat)[t]! = true :=
          fun t h1 h2 => by
          rw [hval, ite_eq_right (by omega), ite_eq_right (by omega)]; exact hright t h1 h2
        by_cases hjk' : j.toNat < k.toNat
        · rw [ite_eq_left
              (show j + 1#64 ≤ k - 0#64 by
                rw [BitVec.le_def, hj1]; simp; omega)]
          simp only [BitVec.sub_zero]
          exact
            ih _ (i + 1#64) (j + 1#64) k hseg' (by omega) (by omega) (by omega) hkh
              (by
                rw [hi1]; exact hleft')
              (by
                rw [hi1, hj1]; exact hmid')
              hright' (by omega)
        · rw [ite_eq_right
              (show ¬j + 1#64 ≤ k - 0#64 by
                rw [BitVec.le_def, hj1]; simp; omega)]
          refine
            ⟨_, i.toNat + 1, j.toNat + 1, k - 0#64, ?_, hseg', by omega, by omega, by omega, hleft',
              hmid', fun t h1 h2 => hright' t (by omega) h2⟩
          rw [← hi1, ← hj1, hbound _ (by omega), hbound _ (by omega)]
      · simp only [Bool.not_eq_true] at hlft
        simp only [hr, hlft, Bool.false_eq_true, ite_false]
        have hswap : (key.set! j.toNat key[j.toNat]!).set! j.toNat key[j.toNat]! = key := by
          rw [show
              (key.set! j.toNat key[j.toNat]!).set! j.toNat key[j.toNat]! = swap key j.toNat j.toNat
              from rfl,
            swap_self _ _ (by omega)]
        rw [hswap]
        have hj1 : (j + 1#64).toNat = j.toNat + 1 := by
          simp; omega
        have hmid' : ∀ t, i.toNat ≤ t → t < j.toNat + 1 → Mid before p1 p2 key[t]! := by
          intro t h1 h2
          by_cases e : t = j.toNat
          · subst e; exact ⟨hlft, hr⟩
          · exact hmid t h1 (by omega)
        by_cases hjk' : j.toNat < k.toNat
        · rw [ite_eq_left
              (show j + 1#64 ≤ k - 0#64 by
                rw [BitVec.le_def, hj1]; simp; omega)]
          simp only [BitVec.add_zero, BitVec.sub_zero]
          exact
            ih _ i (j + 1#64) k hseg hl (by omega) (by omega) hkh hleft
              (by
                rw [hj1]; exact hmid')
              hright (by omega)
        · rw [ite_eq_right
              (show ¬j + 1#64 ≤ k - 0#64 by
                rw [BitVec.le_def, hj1]; simp; omega)]
          refine
            ⟨_, i.toNat, j.toNat + 1, k - 0#64, ?_, hseg, hl, by omega, by omega, hleft, hmid',
              fun t h1 h2 => hright t (by omega) h2⟩
          rw [← hj1, BitVec.add_zero, hbound _ (by omega), hbound _ (by omega)]

/-! ## Pivot facts -/

theorem parted_cross (hw : StrictWeak before) {key0 key : Array α} {L H I J : Nat} {p1 p2 : α}
    (hp : before p2 p1 = false) (hpt : Parted before key0 L H p1 p2 key I J) {p q : Nat}
    (h1 : L ≤ p) (h3 : q < H) (hreg : (p < I ∧ I ≤ q) ∨ (p < J ∧ J ≤ q)) :
    before key[q]! key[p]! = false := by
  obtain ⟨-, hl, hIJ, hJ, hleft, hmid, hright⟩ := hpt
  cases hc : before key[q]! key[p]!
  · rfl
  · exfalso
    rcases hreg with ⟨hp1, hq1⟩ | ⟨hp1, hq1⟩
    · have hpl := hleft p h1 hp1
      by_cases hq : q < J
      · have := hw.trans _ _ _ hc hpl; rw [(hmid q hq1 hq).1] at this; exact absurd this (by simp)
      · have := hw.trans _ _ _ (hw.trans _ _ _ (hright q (by omega) h3) hc) hpl
        rw [hp] at this; exact absurd this (by simp)
    · have hqr := hright q hq1 h3
      by_cases hpI : p < I
      · have := hw.trans _ _ _ (hw.trans _ _ _ hqr hc) (hleft p h1 hpI)
        rw [hp] at this; exact absurd this (by simp)
      · have := hw.trans _ _ _ hqr hc; rw [(hmid p (by omega) hp1).2] at this
        exact absurd this (by simp)

theorem mid_equiv (hw : StrictWeak before) {p1 p2 x y : α} (hp : before p1 p2 = false)
    (hx : Mid before p1 p2 x) (hy : Mid before p1 p2 y) : before y x = false := by
  cases hc : before y x
  · rfl
  · exfalso
    rcases hw.split y p1 x hc with h | h
    · rw [hy.1] at h; exact absurd h (by simp)
    · rcases hw.split p1 p2 x h with h' | h'
      · rw [hp] at h'; exact absurd h' (by simp)
      · rw [hx.2] at h'; exact absurd h' (by simp)

/-! ## Stack -/

/-- `stack` with the pairs `ps` pushed (each as `l` then `h`). -/
def pushPairs (stack : Array (BitVec 64)) (ps : List (BitVec 64 × BitVec 64)) : Array (BitVec 64) :=
  ps.foldl (fun s p => (s.push p.1).push p.2) stack

theorem pushPairs_append (stack : Array (BitVec 64)) (ps qs : List (BitVec 64 × BitVec 64)) :
    pushPairs stack (ps ++ qs) = pushPairs (pushPairs stack ps) qs := by
  simp [pushPairs, List.foldl_append]

/-- The fuel measure of a pushed interval list: `Σ (2 (h - l) - 1)`. -/
def mu (ps : List (BitVec 64 × BitVec 64)) : Nat :=
  (ps.map fun p => 2 * (p.2.toNat - p.1.toNat) - 1).sum

/-- Two intervals are disjoint. -/
def Disj (a b : BitVec 64 × BitVec 64) : Prop :=
  a.2.toNat ≤ b.1.toNat ∨ b.2.toNat ≤ a.1.toNat

/-- What a `retry:` pass leaves for `key[L, H)`: a permutation, the pushed non-empty disjoint
sub-intervals (with measure at most `2 (H - L) - 2`), sorted outside any single one of them. -/
def RetryOut (before : α → α → Bool) (key key' : Array α) (L H : Nat)
    (ps : List (BitVec 64 × BitVec 64)) : Prop :=
  Seg key' key L H ∧
    (∀ p ∈ ps, L ≤ p.1.toNat ∧ p.1.toNat < p.2.toNat ∧ p.2.toNat ≤ H) ∧
    ps.Pairwise Disj ∧
    mu ps + 2 ≤ 2 * (H - L) ∧
    ∀ p q,
      L ≤ p →
        p < q →
        q < H → (∀ ab ∈ ps, ¬(ab.1.toNat ≤ p ∧ q < ab.2.toNat)) → before key'[q]! key'[p]! = false

/-- Sorted outside the pushed intervals, when every non-empty outer part and (if `p1` is before
`p2`) the middle are pushed. -/
theorem sorted_of_cover (hw : StrictWeak before) {key0 key : Array α} {L H I J : Nat} {p1 p2 : α}
    (hp : before p2 p1 = false) (hpt : Parted before key0 L H p1 p2 key I J)
    (ps : List (BitVec 64 × BitVec 64)) (hA : L < I → ∃ ab ∈ ps, ab.1.toNat = L ∧ ab.2.toNat = I)
    (hR : J < H → ∃ ab ∈ ps, ab.1.toNat = J ∧ ab.2.toNat = H)
    (hM : before p1 p2 = true → ∃ ab ∈ ps, ab.1.toNat = I ∧ ab.2.toNat = J) :
    ∀ p q,
      L ≤ p →
        p < q →
        q < H →
        (∀ ab ∈ ps, ¬(ab.1.toNat ≤ p ∧ q < ab.2.toNat)) → before key[q]! key[p]! = false := by
  intro p q h1 h2 h3 hnot
  have hl := hpt.2.1; have hIJ := hpt.2.2.1; have hJ := hpt.2.2.2.1
  by_cases hc : (p < I ∧ I ≤ q) ∨ (p < J ∧ J ≤ q)
  · exact parted_cross hw hp hpt h1 h3 hc
  · by_cases hqI : q < I
    · obtain ⟨ab, hab, e1, e2⟩ := hA (by omega)
      exact absurd ⟨by omega, by omega⟩ (hnot ab hab)
    · by_cases hpJ : J ≤ p
      · obtain ⟨ab, hab, e1, e2⟩ := hR (by omega)
        exact absurd ⟨by omega, by omega⟩ (hnot ab hab)
      · have hmp := hpt.2.2.2.2.2.1 p (by omega) (by omega)
        have hmq := hpt.2.2.2.2.2.1 q (by omega) (by omega)
        cases hb : before p1 p2
        · exact mid_equiv hw hb hmp hmq
        · obtain ⟨ab, hab, e1, e2⟩ := hM hb
          exact absurd ⟨by omega, by omega⟩ (hnot ab hab)

theorem Fueled.bind_done {β γ : Type} (a : β) (f : β → Fueled γ) : (Fueled.done a >>= f) = f a :=
  rfl

theorem Fueled.bind_oof {β γ : Type} (f : β → Fueled γ) : (Fueled.outOfFuel >>= f) = .outOfFuel :=
  rfl

theorem bv_ofNat_toNat (x : BitVec 64) : BitVec.ofNat 64 x.toNat = x := by simp

/-- A `retry:` pass on `key[l, h)` (`h - l > 32`) with ordered pivots, `p2` from the interval. -/
theorem retry_spec (hw : StrictWeak before) (l h n : BitVec 64) (hn : n = h - l)
    (hlh : l.toNat + 32 < h.toNat) (stack : Array (BitVec 64)) :
    ∀ fuel (p1 p2 : α) (key : Array α),
      h.toNat ≤ key.size →
        key.size < 2 ^ 62 →
        1 ≤ fuel →
        (before p1 p2 = true → 2 ≤ fuel) →
        before p2 p1 = false →
        p2 ∈ seg key l.toNat h.toNat →
        ∃ key' ps,
          fd_sort_private_quick.retry before l h n fuel p1 p2 key stack =
              .done (key', pushPairs stack ps) ∧
            RetryOut before key key' l.toNat h.toNat ps := by
  intro fuel
  induction fuel with
  | zero =>
    intro _ _ _ _ _ h1; omega
  | succ fuel ih =>
    intro p1 p2 key hh hsz hf1 hf2 hp he0
    have hnN : n.toNat = h.toNat - l.toNat := by
      rw [hn,
        BitVec.toNat_sub_of_le
          (by
            rw [BitVec.le_def]; omega)]
    have hh1 : (h - 1#64).toNat = h.toNat - 1 := by
      rw [BitVec.toNat_sub_of_le
          (by
            rw [BitVec.le_def]; simp; omega)];
      simp
    have hm2 : Mid before p1 p2 p2 := ⟨hp, hw.irrefl p2⟩
    obtain ⟨key1, I, J, kk, hpart, hpt⟩ :=
      partition_spec hw p1 p2 p2 hp key l.toNat h.toNat hh hsz he0 hm2 (n.toNat + 1) key l l
        (h - 1#64) (Seg.refl _ _ _) (Nat.le_refl _) (Nat.le_refl _) (by omega) (by omega)
        (fun t h1 h2 => by omega) (fun t h1 h2 => by omega) (fun t h1 h2 => by omega) (by omega)
    have hIJ := hpt.mid_pos hh he0 hm2
    have hpt0 := hpt
    obtain ⟨hseg1, hLI, -, hJH, -, -, -⟩ := hpt0
    have hI : (BitVec.ofNat 64 I).toNat = I := by
      simp; omega
    have hJ : (BitVec.ofNat 64 J).toNat = J := by
      simp; omega
    simp only [fd_sort_private_quick.retry, hpart, Fueled.bind_done]
    have hji : (BitVec.ofNat 64 J - BitVec.ofNat 64 I).toNat = J - I := by
      rw [BitVec.toNat_sub_of_le
          (by
            rw [BitVec.le_def, hI, hJ]; omega),
        hI, hJ]
    have hil : (BitVec.ofNat 64 I - l).toNat = I - l.toNat := by
      rw [BitVec.toNat_sub_of_le
          (by
            rw [BitVec.le_def, hI]; omega),
        hI]
    have hhj : (h - BitVec.ofNat 64 J).toNat = h.toNat - J := by
      rw [BitVec.toNat_sub_of_le
          (by
            rw [BitVec.le_def, hJ]; omega),
        hJ]
    by_cases hall : J - I = h.toNat - l.toNat
    · rw [ite_eq_left
          (show BitVec.ofNat 64 J - BitVec.ofNat 64 I = n from
            BitVec.eq_of_toNat_eq
              (by
                rw [hji, hnN]; exact hall))]
      by_cases hpc : before p1 p2 = true
      · rw [ite_eq_left hpc]
        have he1 : p2 ∈ seg key1 l.toNat h.toNat := hseg1.2.2.symm.subset he0
        obtain ⟨key', ps, hr, hout⟩ :=
          ih p2 p2 key1
            (by
              rw [hseg1.1]; exact hh)
            (by
              rw [hseg1.1]; exact hsz)
            (by
              have := hf2 hpc; omega)
            (fun h' => by
              rw [hw.irrefl] at h'; exact absurd h' (by simp))
            (hw.irrefl _) he1
        exact ⟨key', ps, hr, hout.1.trans hseg1, hout.2.1, hout.2.2.1, hout.2.2.2.1, hout.2.2.2.2⟩
      · rw [ite_eq_right hpc]
        refine
          ⟨key1, [], rfl, hseg1, by simp, by simp, by
            simp [mu]; omega, ?_⟩
        exact
          sorted_of_cover hw hp hpt [] (fun h' => by omega) (fun h' => by omega)
            (fun h' => absurd h' hpc)
    · rw [ite_eq_right
          (show ¬BitVec.ofNat 64 J - BitVec.ofNat 64 I = n from fun e =>
            hall
              (by
                have := congrArg BitVec.toNat e; rw [hji, hnN] at this; exact this))]
      have hlt : ∀ a b : BitVec 64, a < b ↔ a.toNat < b.toNat := fun a b => BitVec.lt_def
      by_cases hll : I - l.toNat > h.toNat - J
      · have hllb : BitVec.ofNat 64 I - l > h - BitVec.ofNat 64 J := by
          rw [gt_iff_lt, hlt, hil, hhj]; exact hll
        simp only [hllb, ite_true]
        have hsm : (BitVec.ofNat 64 J < h) ↔ J < h.toNat := by rw [hlt, hJ]
        by_cases hpc : before p1 p2 = true <;> by_cases hs : J < h.toNat
        · simp only [hpc, ite_true, hsm.mpr hs]
          refine
            ⟨key1,
              [(l, BitVec.ofNat 64 I), (BitVec.ofNat 64 I, BitVec.ofNat 64 J),
                (BitVec.ofNat 64 J, h)],
              by simp [pushPairs], hseg1, ?_, ?_, ?_, ?_⟩
          · simp only [List.mem_cons, List.not_mem_nil, or_false]
            rintro p (rfl | rfl | rfl) <;> simp only [hI, hJ] <;> omega
          · simp [Disj, hI, hJ]; omega
          · simp [mu, hI, hJ]; omega
          · exact
              sorted_of_cover hw hp hpt _ (fun _ => ⟨(l, BitVec.ofNat 64 I), by simp, rfl, hI⟩)
                (fun _ => ⟨(BitVec.ofNat 64 J, h), by simp, hJ, rfl⟩)
                (fun _ => ⟨(BitVec.ofNat 64 I, BitVec.ofNat 64 J), by simp, hI, hJ⟩)
        · simp only [hpc, ite_true, show ¬BitVec.ofNat 64 J < h from fun e => hs (hsm.mp e),
            ite_false]
          refine
            ⟨key1, [(l, BitVec.ofNat 64 I), (BitVec.ofNat 64 I, BitVec.ofNat 64 J)], by
              simp [pushPairs], hseg1, ?_, ?_, ?_, ?_⟩
          · simp only [List.mem_cons, List.not_mem_nil, or_false]
            rintro p (rfl | rfl) <;> simp only [hI, hJ] <;> omega
          · simp [Disj, hI, hJ]
          · simp [mu, hI, hJ]; omega
          · exact
              sorted_of_cover hw hp hpt _ (fun _ => ⟨(l, BitVec.ofNat 64 I), by simp, rfl, hI⟩)
                (fun h' => by omega)
                (fun _ => ⟨(BitVec.ofNat 64 I, BitVec.ofNat 64 J), by simp, hI, hJ⟩)
        · simp only [hpc, Bool.false_eq_true, ite_false, hsm.mpr hs, ite_true]
          refine
            ⟨key1, [(l, BitVec.ofNat 64 I), (BitVec.ofNat 64 J, h)], by simp [pushPairs], hseg1, ?_,
              ?_, ?_, ?_⟩
          · simp only [List.mem_cons, List.not_mem_nil, or_false]
            rintro p (rfl | rfl) <;> simp only [hI, hJ] <;> omega
          · simp [Disj, hI, hJ]; omega
          · simp [mu, hI, hJ]; omega
          · exact
              sorted_of_cover hw hp hpt _ (fun _ => ⟨(l, BitVec.ofNat 64 I), by simp, rfl, hI⟩)
                (fun _ => ⟨(BitVec.ofNat 64 J, h), by simp, hJ, rfl⟩) (fun h' => absurd h' hpc)
        · simp only [hpc, Bool.false_eq_true, ite_false,
            show ¬BitVec.ofNat 64 J < h from fun e => hs (hsm.mp e)]
          refine ⟨key1, [(l, BitVec.ofNat 64 I)], by simp [pushPairs], hseg1, ?_, ?_, ?_, ?_⟩
          · simp only [List.mem_cons, List.not_mem_nil, or_false]
            rintro p rfl; simp only [hI]; omega
          · simp
          · simp [mu, hI]; omega
          · exact
              sorted_of_cover hw hp hpt _ (fun _ => ⟨(l, BitVec.ofNat 64 I), by simp, rfl, hI⟩)
                (fun h' => by omega) (fun h' => absurd h' hpc)
      · have hllb : ¬(BitVec.ofNat 64 I - l > h - BitVec.ofNat 64 J) := by
          rw [gt_iff_lt, hlt, hil, hhj]; exact hll
        simp only [hllb, ite_false]
        have hsm : (l < BitVec.ofNat 64 I) ↔ l.toNat < I := by rw [hlt, hI]
        by_cases hpc : before p1 p2 = true <;> by_cases hs : l.toNat < I
        · simp only [hpc, ite_true, hsm.mpr hs]
          refine
            ⟨key1,
              [(BitVec.ofNat 64 J, h), (BitVec.ofNat 64 I, BitVec.ofNat 64 J),
                (l, BitVec.ofNat 64 I)],
              by simp [pushPairs], hseg1, ?_, ?_, ?_, ?_⟩
          · simp only [List.mem_cons, List.not_mem_nil, or_false]
            rintro p (rfl | rfl | rfl) <;> simp only [hI, hJ] <;> omega
          · simp [Disj, hI, hJ]; omega
          · simp [mu, hI, hJ]; omega
          · exact
              sorted_of_cover hw hp hpt _ (fun _ => ⟨(l, BitVec.ofNat 64 I), by simp, rfl, hI⟩)
                (fun _ => ⟨(BitVec.ofNat 64 J, h), by simp, hJ, rfl⟩)
                (fun _ => ⟨(BitVec.ofNat 64 I, BitVec.ofNat 64 J), by simp, hI, hJ⟩)
        · simp only [hpc, ite_true, show ¬l < BitVec.ofNat 64 I from fun e => hs (hsm.mp e),
            ite_false]
          refine
            ⟨key1, [(BitVec.ofNat 64 J, h), (BitVec.ofNat 64 I, BitVec.ofNat 64 J)], by
              simp [pushPairs], hseg1, ?_, ?_, ?_, ?_⟩
          · simp only [List.mem_cons, List.not_mem_nil, or_false]
            rintro p (rfl | rfl) <;> simp only [hI, hJ] <;> omega
          · simp [Disj, hI, hJ]
          · simp [mu, hI, hJ]; omega
          · exact
              sorted_of_cover hw hp hpt _ (fun h' => by omega)
                (fun _ => ⟨(BitVec.ofNat 64 J, h), by simp, hJ, rfl⟩)
                (fun _ => ⟨(BitVec.ofNat 64 I, BitVec.ofNat 64 J), by simp, hI, hJ⟩)
        · simp only [hpc, Bool.false_eq_true, ite_false, hsm.mpr hs, ite_true]
          refine
            ⟨key1, [(BitVec.ofNat 64 J, h), (l, BitVec.ofNat 64 I)], by simp [pushPairs], hseg1, ?_,
              ?_, ?_, ?_⟩
          · simp only [List.mem_cons, List.not_mem_nil, or_false]
            rintro p (rfl | rfl) <;> simp only [hI, hJ] <;> omega
          · simp [Disj, hI, hJ]; omega
          · simp [mu, hI, hJ]; omega
          · exact
              sorted_of_cover hw hp hpt _ (fun _ => ⟨(l, BitVec.ofNat 64 I), by simp, rfl, hI⟩)
                (fun _ => ⟨(BitVec.ofNat 64 J, h), by simp, hJ, rfl⟩) (fun h' => absurd h' hpc)
        · simp only [hpc, Bool.false_eq_true, ite_false,
            show ¬l < BitVec.ofNat 64 I from fun e => hs (hsm.mp e)]
          refine ⟨key1, [(BitVec.ofNat 64 J, h)], by simp [pushPairs], hseg1, ?_, ?_, ?_, ?_⟩
          · simp only [List.mem_cons, List.not_mem_nil, or_false]
            rintro p rfl; simp only [hJ]; omega
          · simp
          · simp [mu, hJ]; omega
          · exact
              sorted_of_cover hw hp hpt _ (fun h' => by omega)
                (fun _ => ⟨(BitVec.ofNat 64 J, h), by simp, hJ, rfl⟩) (fun h' => absurd h' hpc)

/-! ## The quicksort loop -/

/-- The loop's fuel measure: `Σ max (2 (h - l) - 1) 1`. -/
def muM (ps : List (BitVec 64 × BitVec 64)) : Nat :=
  (ps.map fun p => max (2 * (p.2.toNat - p.1.toNat) - 1) 1).sum

theorem muM_append (ps qs : List (BitVec 64 × BitVec 64)) : muM (ps ++ qs) = muM ps + muM qs := by
  simp [muM]

theorem muM_le_mu (qs : List (BitVec 64 × BitVec 64)) (h : ∀ p ∈ qs, p.1.toNat < p.2.toNat) :
    muM qs = mu qs := by
  induction qs with
  | nil => rfl
  | cons a qs ih =>
    simp only [muM, mu, List.map_cons, List.sum_cons] at ih ⊢
    rw [ih (fun p hp => h p (List.mem_cons_of_mem _ hp))]
    have := h a (List.mem_cons_self ..)
    congr 1; omega

/-- The loop invariant: a permutation of `key0`, the stacked intervals disjoint and in range,
sorted outside any single stacked interval. -/
def LoopInv (before : α → α → Bool) (key0 key : Array α) (ps : List (BitVec 64 × BitVec 64)) :
    Prop :=
  Seg key key0 0 key0.size ∧
    (∀ p ∈ ps, p.1.toNat ≤ p.2.toNat ∧ p.2.toNat ≤ key0.size) ∧
    ps.Pairwise Disj ∧
    ∀ p q,
      p < q →
        q < key0.size →
        (∀ ab ∈ ps, ¬(ab.1.toNat ≤ p ∧ q < ab.2.toNat)) → before key[q]! key[p]! = false

/-- Permuting the top interval `[L, H)` into a state sorted outside the pushed `qs` keeps the
invariant. -/
theorem LoopInv.step {key0 key key1 : Array α} {ps qs : List (BitVec 64 × BitVec 64)}
    {l h : BitVec 64} (hinv : LoopInv before key0 key (ps ++ [(l, h)]))
    (hseg : Seg key1 key l.toNat h.toNat)
    (hqs : ∀ p ∈ qs, l.toNat ≤ p.1.toNat ∧ p.1.toNat < p.2.toNat ∧ p.2.toNat ≤ h.toNat)
    (hqd : qs.Pairwise Disj)
    (hsort :
      ∀ p q,
        l.toNat ≤ p →
          p < q →
          q < h.toNat →
          (∀ ab ∈ qs, ¬(ab.1.toNat ≤ p ∧ q < ab.2.toNat)) → before key1[q]! key1[p]! = false) :
    LoopInv before key0 key1 (ps ++ qs) := by
  obtain ⟨hs0, hb, hd, hsrt⟩ := hinv
  have hlh := hb (l, h) (by simp)
  simp only at hlh
  have hdl : ∀ a ∈ ps, Disj a (l, h) := by
    intro a ha
    have := (List.pairwise_append.mp hd).2.2 a ha (l, h) (by simp)
    exact this
  refine
    ⟨(hseg.widen (Nat.zero_le _) hlh.1 hlh.2
            (by
              rw [hs0.1]; exact Nat.le_refl _)).trans
        hs0,
      ?_, ?_, ?_⟩
  · intro p hp
    rcases List.mem_append.mp hp with hp | hp
    · exact hb p (by simp [hp])
    · have := hqs p hp; omega
  · refine List.pairwise_append.mpr ⟨(List.pairwise_append.mp hd).1, hqd, fun a ha b hb' => ?_⟩
    have h1 := hdl a ha; have h2 := hqs b hb'
    simp only [Disj] at h1 ⊢; omega
  · intro p q hpq hq hnot
    have hnot1 : ∀ ab ∈ ps, ¬(ab.1.toNat ≤ p ∧ q < ab.2.toNat) := fun ab hab =>
      hnot ab (List.mem_append_left _ hab)
    have hsz : key.size = key0.size := hs0.1
    -- no stacked interval of `ps` meets `[L, H)`
    have hout : ∀ t, l.toNat ≤ t → t < h.toNat → ∀ ab ∈ ps, ¬(ab.1.toNat ≤ t ∧ t < ab.2.toNat) := by
      intro t ht1 ht2 ab hab hc
      have := hdl ab hab; simp only [Disj] at this; omega
    by_cases hpi : l.toNat ≤ p ∧ p < h.toNat <;> by_cases hqi : l.toNat ≤ q ∧ q < h.toNat
    · exact hsort p q hpi.1 hpq hqi.2 (fun ab hab => hnot ab (List.mem_append_right _ hab))
    · obtain ⟨p', hp1, hp2, hp'⟩ := hseg.mem (by omega) hpi.1 hpi.2
      rw [← hp', hseg.2.1 q (by omega)]
      apply hsrt p' q (by omega) hq
      intro ab hab hc
      rcases List.mem_append.mp hab with hab | hab
      · exact hout p' hp1 hp2 ab hab ⟨hc.1, by omega⟩
      · simp at hab; subst hab; simp at hc; omega
    · obtain ⟨q', hq1, hq2, hq'⟩ := hseg.mem (by omega) hqi.1 hqi.2
      rw [← hq', hseg.2.1 p (by omega)]
      apply hsrt p q' (by omega) (by omega)
      intro ab hab hc
      rcases List.mem_append.mp hab with hab | hab
      · exact hout q' hq1 hq2 ab hab ⟨by omega, hc.2⟩
      · simp at hab; subst hab; simp at hc; omega
    · rw [hseg.2.1 p (by omega), hseg.2.1 q (by omega)]
      apply hsrt p q hpq hq
      intro ab hab hc
      rcases List.mem_append.mp hab with hab | hab
      · exact hnot1 ab hab hc
      · simp at hab; subst hab; simp at hc; omega

theorem pushPairs_concat (s : Array (BitVec 64)) (ps : List (BitVec 64 × BitVec 64))
    (a b : BitVec 64) : pushPairs s (ps ++ [(a, b)]) = ((pushPairs s ps).push a).push b := by
  simp [pushPairs, List.foldl_append]

theorem pushPairs_size (s : Array (BitVec 64)) (ps : List (BitVec 64 × BitVec 64)) :
    (pushPairs s ps).size = s.size + 2 * ps.length := by
  induction ps generalizing s with
  | nil => simp [pushPairs]
  | cons a ps ih =>
    simp only [pushPairs, List.foldl_cons] at ih ⊢
    rw [ih]; simp; omega

theorem order_mem (x y : α) :
    ((fd_sort_order before x y).1 = x ∨ (fd_sort_order before x y).1 = y) ∧
      ((fd_sort_order before x y).2 = x ∨ (fd_sort_order before x y).2 = y) := by
  unfold fd_sort_order; split <;> simp

theorem order_le (hw : StrictWeak before) (x y : α) :
    before (fd_sort_order before x y).2 (fd_sort_order before x y).1 = false := by
  unfold fd_sort_order
  split
  · exact hw.asymm (by assumption)
  · simpa using (by assumption : ¬before y x = true)

theorem order_pres (S : α → Prop) {x y a b : α} (hx : S x) (hy : S y)
    (h : fd_sort_order before x y = (a, b)) : S a ∧ S b := by
  have := order_mem (before := before) x y
  rw [h] at this
  simp only at this
  obtain ⟨h1 | h1, h2 | h2⟩ := this <;> rw [h1, h2] <;> exact ⟨by assumption, by assumption⟩

/-- The quicksort loop with fuel at least the measure plus one sorts. -/
theorem loop_spec (hw : StrictWeak before) (key0 : Array α) (hsz : key0.size < 2 ^ 62) :
    ∀ fuel key ps,
      LoopInv before key0 key ps →
        muM ps + 1 ≤ fuel →
        ∃ key',
          fd_sort_private_quick.loop before fuel key (pushPairs #[] ps) = .done key' ∧
            Seg key' key0 0 key0.size ∧ SortedOn before key' 0 key0.size := by
  intro fuel
  induction fuel with
  | zero =>
    intro _ _ _ h; omega
  | succ fuel ih =>
    intro key ps hinv hf
    rcases List.eq_nil_or_concat ps with rfl | ⟨ps', ⟨l, h⟩, rfl⟩
    · refine
        ⟨key, by simp [fd_sort_private_quick.loop, pushPairs], hinv.1, fun p q h1 h2 h3 =>
          hinv.2.2.2 p q h2 h3 (by simp)⟩
    · rw [List.concat_eq_append] at hinv hf ⊢
      have hsz0 := hinv.1.1
      have hlh := hinv.2.1 (l, h) (by simp)
      simp only at hlh
      rw [fd_sort_private_quick.loop, pushPairs_concat]
      rw [ite_eq_right (by simp)]
      simp only [Array.back!_push, Array.pop_push]
      have hn : (h - l).toNat = h.toNat - l.toNat := by
        rw [BitVec.toNat_sub_of_le
            (by
              rw [BitVec.le_def]; omega)]
      have hmu : muM (ps' ++ [(l, h)]) = muM ps' + max (2 * (h.toNat - l.toNat) - 1) 1 := by
        simp [muM]
      by_cases hsmall : h.toNat - l.toNat ≤ 32
      · rw [ite_eq_left
            (show h - l ≤ SORT_QUICK_THRESH by
              rw [BitVec.le_def, hn]; simp [SORT_QUICK_THRESH]; omega)]
        obtain ⟨hs1, hs2⟩ :=
          insert_spec hw key l (h - l)
            (by
              rw [hn, hsz0]; omega)
        rw [hn, show l.toNat + (h.toNat - l.toNat) = h.toNat by omega] at hs1 hs2
        have hstep :=
          LoopInv.step (qs := []) hinv hs1 (by simp) (by simp)
            (fun p q h1 h2 h3 _ => hs2 p q h1 h2 h3)
        rw [List.append_nil] at hstep
        exact ih _ ps' hstep (by omega)
      · rw [ite_eq_right
            (show ¬h - l ≤ SORT_QUICK_THRESH by
              rw [BitVec.le_def, hn]; simp [SORT_QUICK_THRESH]; omega)]
        have hn3 : ((h - l) / 3#64).toNat = (h.toNat - l.toNat) / 3 := by
          rw [BitVec.toNat_udiv, hn]; simp
        have hh1 : (h - 1#64).toNat = h.toNat - 1 := by
          rw [BitVec.toNat_sub_of_le
              (by
                rw [BitVec.le_def]; simp; omega)];
          simp
        have hln3 : (l + (h - l) / 3#64).toNat = l.toNat + (h.toNat - l.toNat) / 3 := by
          rw [BitVec.toNat_add, hn3]; omega
        have hh1n3 : (h - 1#64 - (h - l) / 3#64).toNat = h.toNat - 1 - (h.toNat - l.toNat) / 3 := by
          rw [BitVec.toNat_sub_of_le
              (by
                rw [BitVec.le_def, hh1, hn3]; omega),
            hh1, hn3]
        have hS : ∀ t, l.toNat ≤ t → t < h.toNat → key[t]! ∈ seg key l.toNat h.toNat :=
          fun t h1 h2 => (mem_seg key _ _ (by omega) _).mpr ⟨t, h1, h2, rfl⟩
        have hq0 := hS l.toNat (Nat.le_refl _) (by omega)
        have hq1 := hS (l + (h - l) / 3#64).toNat (by omega) (by omega)
        have hq2 := hS (h - 1#64 - (h - l) / 3#64).toNat (by omega) (by omega)
        have hq3 := hS (h - 1#64).toNat (by omega) (by omega)
        generalize key[l.toNat]! = q0 at hq0 ⊢
        generalize key[(l + (h - l) / 3#64).toNat]! = q1 at hq1 ⊢
        generalize key[(h - 1#64 - (h - l) / 3#64).toNat]! = q2 at hq2 ⊢
        generalize key[(h - 1#64).toNat]! = q3 at hq3 ⊢
        let S : α → Prop := fun x => x ∈ seg key l.toNat h.toNat
        obtain ⟨a0, a2, e1⟩ : ∃ a b, fd_sort_order before q0 q2 = (a, b) := ⟨_, _, rfl⟩
        obtain ⟨s0, s2⟩ := order_pres S hq0 hq2 e1
        rw [e1]; simp only
        obtain ⟨b1, b3, e2⟩ : ∃ a b, fd_sort_order before q1 q3 = (a, b) := ⟨_, _, rfl⟩
        obtain ⟨t1, t3⟩ := order_pres S hq1 hq3 e2
        rw [e2]; simp only
        obtain ⟨c0, c1, e3⟩ : ∃ a b, fd_sort_order before a0 b1 = (a, b) := ⟨_, _, rfl⟩
        obtain ⟨-, u1⟩ := order_pres S s0 t1 e3
        rw [e3]; simp only
        obtain ⟨d2, d3, e4⟩ : ∃ a b, fd_sort_order before a2 b3 = (a, b) := ⟨_, _, rfl⟩
        obtain ⟨v2, -⟩ := order_pres S s2 t3 e4
        rw [e4]; simp only
        obtain ⟨f1, f2, e5⟩ : ∃ a b, fd_sort_order before c1 d2 = (a, b) := ⟨_, _, rfl⟩
        obtain ⟨-, w2⟩ := order_pres S u1 v2 e5
        have hord : before f2 f1 = false := by
          have := order_le hw (before := before) c1 d2; rwa [e5] at this
        rw [e5]; simp only
        have hfmu : 2 * (h.toNat - l.toNat) - 1 ≤ fuel := by
          have : max (2 * (h.toNat - l.toNat) - 1) 1 = 2 * (h.toNat - l.toNat) - 1 := by omega
          omega
        obtain ⟨key1, qs, hr, hout⟩ :=
          retry_spec hw l h (h - l) rfl (by omega) (pushPairs #[] ps') fuel f1 f2 key (by omega)
            (by omega) (by omega) (fun _ => by omega) hord w2
        rw [hr, ← pushPairs_append]
        obtain ⟨hs1, hqb, hqd, hqmu, hqs⟩ := hout
        apply ih _ _ (LoopInv.step hinv hs1 hqb hqd hqs)
        rw [muM_append, muM_le_mu qs (fun p hp => (hqb p hp).2.1)]
        omega

/-- `fd_sort_inplace` on a strict weak order returns a sorted permutation of its input. -/
theorem sort_inplace_spec (hw : StrictWeak before) (key : Array α) (cnt : BitVec 64)
    (hc : cnt.toNat = key.size) (hsz : key.size < 2 ^ 62) :
    ∃ key',
      fd_sort_inplace.spec before key cnt = .done key' ∧
        key'.toList.Perm key.toList ∧ key'.size = key.size ∧ SortedOn before key' 0 key.size := by
  unfold fd_sort_inplace.spec
  have h0 : LoopInv before key key [(0#64, cnt)] := by
    refine ⟨Seg.refl _ _ _, by simp [hc], by simp, fun p q _ hq hnot => ?_⟩
    exact
      absurd
        ⟨by simp, by
          simp only; omega⟩
        (hnot (0#64, cnt) (by simp))
  obtain ⟨key', hl, hseg, hs⟩ :=
    loop_spec hw key hsz (8 * cnt.toNat + 8) key _ h0
      (by
        simp [muM]; omega)
  refine ⟨key', by simpa [pushPairs] using hl, hseg.perm rfl rfl, hseg.1, hs⟩

end

end Firedancer.Leaders.Math
