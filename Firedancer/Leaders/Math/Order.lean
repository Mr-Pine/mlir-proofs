module

public import Firedancer.Leaders.Math.Sort
public import Firedancer.Leaders.Math.Agave

/-! Firedancer's `sort_vote_weights_by_stake_vote` and Agave's `sort_stakes` order by the same key:
stake descending, then vote address descending (big-endian bytes). -/

namespace Firedancer.Leaders.Math

open Firedancer.Leaders Agave

@[expose] public section

/-! ## Keys as numbers -/

/-- Bytes `i..32` of a key as a big-endian number. -/
def valFrom (a : Vector (BitVec 8) 32) (i : Nat) : Nat :=
  if h : i < 32 then a[i].toNat * 256 ^ (31 - i) + valFrom a (i + 1) else 0
termination_by 32 - i

theorem valFrom_lt (a : Vector (BitVec 8) 32) :
    ∀ n i, 32 - i = n → valFrom a i < 256 ^ (32 - i) := by
  intro n
  induction n with
  | zero =>
    intro i hi; rw [valFrom, dite_eq_right_of_eq_false (eq_false (by omega))];
    exact Nat.pow_pos (by omega)
  | succ n ih =>
    intro i hi
    rw [valFrom, dite_eq_left_of_eq_true (eq_true (by omega))]
    have h1 := ih (i + 1) (by omega)
    have h2 := a[i].isLt
    rw [show 32 - (i + 1) = 31 - i by omega] at h1
    rw [show 32 - i = (31 - i) + 1 by omega, Nat.pow_succ]
    have : a[i].toNat * 256 ^ (31 - i) + 256 ^ (31 - i) ≤ 256 ^ (31 - i) * 256 := by
      rw [← Nat.succ_mul, Nat.mul_comm]; exact Nat.mul_le_mul_left _ (by omega)
    omega

theorem valFrom_cmp (a b : Vector (BitVec 8) 32) (i : Nat) (hi : i < 32) :
    (a[i].toNat < b[i].toNat → valFrom a i < valFrom b i) ∧
      (a[i] = b[i] →
        (valFrom a i < valFrom b i ↔ valFrom a (i + 1) < valFrom b (i + 1)) ∧
          (valFrom a i = valFrom b i ↔ valFrom a (i + 1) = valFrom b (i + 1))) := by
  have ha := valFrom_lt a _ (i + 1) rfl
  have hb := valFrom_lt b _ (i + 1) rfl
  rw [show 32 - (i + 1) = 31 - i by omega] at ha hb
  rw [valFrom.eq_1 a i, valFrom.eq_1 b i, dite_eq_left_of_eq_true (eq_true hi),
    dite_eq_left_of_eq_true (eq_true hi)]
  refine
    ⟨fun h => ?_, fun h => by
      rw [h]; omega⟩
  have : (a[i].toNat + 1) * 256 ^ (31 - i) ≤ b[i].toNat * 256 ^ (31 - i) :=
    Nat.mul_le_mul_right _ (by omega)
  rw [Nat.succ_mul] at this
  omega

/-- The sign of `memcmp` from byte `i` is the order of the big-endian numbers. -/
theorem memcmp_go_pos (a b : Vector (BitVec 8) 32) :
    ∀ n i, 32 - i = n → (memcmp.go a b i > 0 ↔ valFrom b i < valFrom a i) := by
  intro n
  induction n with
  | zero =>
    intro i hi
    rw [memcmp.go, dite_eq_right_of_eq_false (eq_false (by omega)), valFrom,
      dite_eq_right_of_eq_false (eq_false (by omega)), valFrom,
      dite_eq_right_of_eq_false (eq_false (by omega))]
    simp
  | succ n ih =>
    intro i hi
    have hi' : i < 32 := by omega
    rw [memcmp.go, dite_eq_left_of_eq_true (eq_true hi')]
    by_cases e : a[i] = b[i]
    · rw [ite_eq_left e, ih (i + 1) (by omega), ((valFrom_cmp b a i hi').2 e.symm).1]
    · rw [ite_eq_right e]
      by_cases hlt : a[i] < b[i]
      · rw [ite_eq_left hlt]
        have := (valFrom_cmp a b i hi').1 (BitVec.lt_def.mp hlt)
        constructor
        · intro h; simp at h
        · intro h; omega
      · rw [ite_eq_right hlt]
        have : b[i].toNat < a[i].toNat := by
          have h3 : ¬a[i].toNat < b[i].toNat := fun h' => hlt (BitVec.lt_def.mpr h')
          have h2 : a[i].toNat ≠ b[i].toNat := fun h' => e (BitVec.eq_of_toNat_eq h')
          omega
        have := (valFrom_cmp b a i hi').1 this
        constructor
        · intro _; omega
        · intro _; decide

/-- Agave's key comparison from byte `i` is the order of the big-endian numbers. -/
theorem pubkeyCmpFrom_eq (a b : Vector (BitVec 8) 32) :
    ∀ n i, 32 - i = n → pubkeyCmpFrom a b i = compare (valFrom a i) (valFrom b i) := by
  intro n
  induction n with
  | zero =>
    intro i hi
    rw [pubkeyCmpFrom, dite_eq_right_of_eq_false (eq_false (by omega)), valFrom,
      dite_eq_right_of_eq_false (eq_false (by omega)), valFrom,
      dite_eq_right_of_eq_false (eq_false (by omega))]
    rfl
  | succ n ih =>
    intro i hi
    have hi' : i < 32 := by omega
    rw [pubkeyCmpFrom, dite_eq_left_of_eq_true (eq_true hi')]
    simp only [u8Cmp]
    rcases Nat.lt_trichotomy a[i].toNat b[i].toNat with h | h | h
    · rw [show compare a[i].toNat b[i].toNat = .lt from Nat.compare_eq_lt.mpr h]
      exact (Nat.compare_eq_lt.mpr ((valFrom_cmp a b i hi').1 h)).symm
    · have e : a[i] = b[i] := BitVec.eq_of_toNat_eq h
      rw [show compare a[i].toNat b[i].toNat = .eq from Nat.compare_eq_eq.mpr h]
      simp only
      rw [ih (i + 1) (by omega)]
      obtain ⟨h1, h2⟩ := (valFrom_cmp a b i hi').2 e
      have h3 := ((valFrom_cmp b a i hi').2 e.symm).1
      rcases Nat.lt_trichotomy (valFrom a (i + 1)) (valFrom b (i + 1)) with h' | h' | h'
      · rw [Nat.compare_eq_lt.mpr h', Nat.compare_eq_lt.mpr (h1.mpr h')]
      · rw [Nat.compare_eq_eq.mpr h', Nat.compare_eq_eq.mpr (h2.mpr h')]
      · rw [Nat.compare_eq_gt.mpr h', Nat.compare_eq_gt.mpr (h3.mpr h')]
    · rw [show compare a[i].toNat b[i].toNat = .gt from Nat.compare_eq_gt.mpr h]
      exact (Nat.compare_eq_gt.mpr ((valFrom_cmp b a i hi').1 h)).symm

theorem valFrom_inj (a b : Vector (BitVec 8) 32) :
    ∀ n i, 32 - i = n → valFrom a i = valFrom b i → ∀ j, i ≤ j → j < 32 → a[j]! = b[j]! := by
  intro n
  induction n with
  | zero =>
    intro i hi _ j h1 h2; omega
  | succ n ih =>
    intro i hi heq j h1 h2
    have hi' : i < 32 := by omega
    have hai : a[i] = b[i] := by
      rcases Nat.lt_trichotomy a[i].toNat b[i].toNat with h | h | h
      · have := (valFrom_cmp a b i hi').1 h; omega
      · exact BitVec.eq_of_toNat_eq h
      · have := (valFrom_cmp b a i hi').1 h; omega
    rcases Nat.lt_or_eq_of_le h1 with h | h
    · exact ih (i + 1) (by omega) (((valFrom_cmp a b i hi').2 hai).2.mp heq) j h h2
    · rw [← h, getElem!_pos a i hi', getElem!_pos b i hi', hai]

/-- A key as a big-endian number. -/
def val (a : Vector (BitVec 8) 32) : Nat :=
  valFrom a 0

theorem val_lt (a : Vector (BitVec 8) 32) : val a < 2 ^ 256 := by
  have := valFrom_lt a 32 0 rfl; simpa [val] using this

theorem val_inj {a b : Vector (BitVec 8) 32} (h : val a = val b) : a = b := by
  refine Vector.ext (fun j hj => ?_)
  have := valFrom_inj a b 32 0 rfl h j (Nat.zero_le _) hj
  rwa [getElem!_pos a j hj, getElem!_pos b j hj] at this

/-! ## The sort key -/

/-- Firedancer's sort key: stake, then vote key. -/
def fdKey (r : fd_vote_stake_weight_t) : Nat :=
  r.stake.toNat * 2 ^ 256 + val r.vote_key

/-- Agave's sort key: stake, then vote address. -/
def agKey (r : SlotLeader × BitVec 64) : Nat :=
  r.2.toNat * 2 ^ 256 + val r.1.vote_address

/-- A Firedancer stake record as Agave's `(SlotLeader, u64)`. -/
def toAgave (r : fd_vote_stake_weight_t) : SlotLeader × BitVec 64 :=
  ({ id := r.id_key, vote_address := r.vote_key }, r.stake)

theorem agKey_toAgave (r : fd_vote_stake_weight_t) : agKey (toAgave r) = fdKey r :=
  rfl

theorem key_lt_iff {s1 s2 v1 v2 : Nat} (h1 : v1 < 2 ^ 256) (h2 : v2 < 2 ^ 256) :
    s1 * 2 ^ 256 + v1 < s2 * 2 ^ 256 + v2 ↔ s1 < s2 ∨ (s1 = s2 ∧ v1 < v2) := by
  constructor
  · intro h
    rcases Nat.lt_trichotomy s1 s2 with hs | hs | hs
    · exact Or.inl hs
    · subst hs; right; omega
    · have : (s2 + 1) * 2 ^ 256 ≤ s1 * 2 ^ 256 := Nat.mul_le_mul_right _ hs
      rw [Nat.succ_mul] at this; omega
  · rintro (hs | ⟨rfl, hv⟩)
    · have : (s1 + 1) * 2 ^ 256 ≤ s2 * 2 ^ 256 := Nat.mul_le_mul_right _ hs
      rw [Nat.succ_mul] at this; omega
    · omega

/-- Firedancer's comparator is "greater key". -/
theorem before_iff (a b : fd_vote_stake_weight_t) :
    sort_vote_weights_by_stake_vote.before a b = true ↔ fdKey b < fdKey a := by
  unfold sort_vote_weights_by_stake_vote.before fdKey
  rw [key_lt_iff (val_lt _) (val_lt _)]
  have hm : memcmp a.vote_key b.vote_key > 0 ↔ val b.vote_key < val a.vote_key :=
    memcmp_go_pos a.vote_key b.vote_key 32 0 rfl
  by_cases h1 : a.stake > b.stake
  · rw [ite_eq_left h1]; simp only [gt_iff_lt, BitVec.lt_def] at h1; simp; omega
  · rw [ite_eq_right h1]
    by_cases h2 : a.stake < b.stake
    · rw [ite_eq_left h2]; simp only [BitVec.lt_def] at h2; simp; omega
    · rw [ite_eq_right h2]
      simp only [gt_iff_lt, BitVec.lt_def] at h1 h2
      rw [decide_eq_true_iff, hm]
      omega

theorem stakeCmp_eq (l r : SlotLeader × BitVec 64) :
    stakeCmp l r = compare (agKey r) (agKey l) := by
  unfold stakeCmp agKey pubkeyCmp
  rw [pubkeyCmpFrom_eq _ _ 32 0 rfl]
  have hl := val_lt l.1.vote_address; have hr := val_lt r.1.vote_address
  unfold val at hl hr
  by_cases h : r.2 = l.2
  · rw [ite_eq_left h, h]
    rcases Nat.lt_trichotomy (valFrom r.1.vote_address 0) (valFrom l.1.vote_address 0) with h' |
      h' | h'
    · rw [Nat.compare_eq_lt.mpr h',
        Nat.compare_eq_lt.mpr
          (by
            unfold val; omega)]
    · rw [Nat.compare_eq_eq.mpr h',
        Nat.compare_eq_eq.mpr
          (by
            unfold val; omega)]
    · rw [Nat.compare_eq_gt.mpr h',
        Nat.compare_eq_gt.mpr
          (by
            unfold val; omega)]
  · rw [ite_eq_right h]
    unfold u64Cmp
    have h' : r.2.toNat ≠ l.2.toNat := fun e => h (BitVec.eq_of_toNat_eq e)
    rcases Nat.lt_trichotomy r.2.toNat l.2.toNat with hs | hs | hs
    · rw [Nat.compare_eq_lt.mpr hs,
        Nat.compare_eq_lt.mpr ((key_lt_iff (val_lt _) (val_lt _)).mpr (Or.inl hs))]
    · omega
    · rw [Nat.compare_eq_gt.mpr hs,
        Nat.compare_eq_gt.mpr ((key_lt_iff (val_lt _) (val_lt _)).mpr (Or.inl hs))]

theorem before_strictWeak : StrictWeak sort_vote_weights_by_stake_vote.before := by
  refine ⟨fun a => ?_, fun a b c h1 h2 => ?_, fun a b c h => ?_⟩
  · cases h : sort_vote_weights_by_stake_vote.before a a
    · rfl
    · have := (before_iff a a).mp h; omega
  · simp only [before_iff] at *; omega
  · simp only [before_iff] at *
    omega

/-! ## Firedancer's sort is Agave's `sort_stakes` -/

theorem pairwise_eq_of_not {β : Type} {R : β → β → Prop} (hsym : ∀ x y, R x y → R y x) :
    ∀ {l : List β}, l.Pairwise R → ∀ {x y}, x ∈ l → y ∈ l → ¬R x y → x = y
  | [], _, _, _, hx, _, _ => by simp at hx
  | a :: l, hp, x, y, hx, hy, hn => by
    rw [List.pairwise_cons] at hp
    rcases List.mem_cons.mp hx with h1 | hx' <;> rcases List.mem_cons.mp hy with h2 | hy'
    · rw [h1, h2]
    · rw [h1] at hn; exact absurd (hp.1 y hy') hn
    · rw [h2] at hn; exact absurd (hsym _ _ (hp.1 x hx')) hn
    · exact pairwise_eq_of_not hsym hp.2 hx' hy' hn

theorem dedupBy_go_id {β : Type} (same : β → β → Bool) :
    ∀ (prev : β) (l : List β),
      (∀ b ∈ l, same b prev = false) →
        l.Pairwise (fun a b => same b a = false) → dedupBy.go same prev l = l
  | _, [], _, _ => rfl
  | prev, b :: l, h1, h2 => by
    rw [List.pairwise_cons] at h2
    simp only [dedupBy.go, h1 b (List.mem_cons_self ..), Bool.false_eq_true, ite_false]
    rw [dedupBy_go_id same b l h2.1 h2.2]

theorem dedupBy_id {β : Type} (same : β → β → Bool) (l : List β)
    (h : l.Pairwise (fun a b => same b a = false)) : dedupBy same l = l := by
  cases l with
  | nil => rfl
  | cons a l =>
    rw [List.pairwise_cons] at h
    simp only [dedupBy]; rw [dedupBy_go_id same a l h.1 h.2]

theorem agKey_eq {a b : SlotLeader × BitVec 64} (h : agKey a = agKey b) :
    a.2 = b.2 ∧ a.1.vote_address = b.1.vote_address := by
  unfold agKey at h
  have h1 := val_lt a.1.vote_address; have h2 := val_lt b.1.vote_address
  have hs : a.2.toNat = b.2.toNat := by omega
  exact ⟨BitVec.eq_of_toNat_eq hs, val_inj (by omega)⟩

/-- With pairwise-distinct vote keys, `fd_stake_weights_by_node` sorts exactly like Agave's
`sort_stakes`, which then drops nothing. -/
theorem stake_weights_eq_sort_stakes (elems : Array fd_vote_stake_weight_t)
    (hsz : elems.size ≤ 2000) (hdist : elems.toList.Pairwise fun a b => a.vote_key ≠ b.vote_key) :
    ∃ weights,
      fd_stake_weights_by_node.spec elems = .ok weights (BitVec.ofNat 64 elems.size) ∧
        weights.size = elems.size ∧
        weights.toList.Perm elems.toList ∧
        sort_stakes (elems.toList.map toAgave) = weights.toList.map toAgave := by
  obtain ⟨key', hk, hperm, hks, hsorted⟩ :=
    sort_inplace_spec before_strictWeak elems (BitVec.ofNat 64 elems.size)
      (by
        simp; omega)
      (by omega)
  refine ⟨key', ?_, hks, hperm, ?_⟩
  · unfold fd_stake_weights_by_node.spec
    rw [ite_eq_right
        (by
          simp [MAX_STAKE_WEIGHTS]; omega)]
    dsimp only
    rw [hk]
  · let le : SlotLeader × BitVec 64 → SlotLeader × BitVec 64 → Bool := fun a b =>
      stakeCmp a b != .gt
    have hle : ∀ a b, le a b = true ↔ agKey b ≤ agKey a := by
      intro a b
      simp only [le, stakeCmp_eq, bne_iff_ne, ne_eq, Nat.compare_eq_gt]
      omega
    have hdist' :
      (elems.toList.map toAgave).Pairwise fun a b => a.1.vote_address ≠ b.1.vote_address := by
      rw [List.pairwise_map]; exact hdist
    have hp1 : (sortBy stakeCmp (elems.toList.map toAgave)).Perm (elems.toList.map toAgave) :=
      List.mergeSort_perm _ _
    have hp2 : (key'.toList.map toAgave).Perm (elems.toList.map toAgave) := hperm.map _
    have hs1 :
      (sortBy stakeCmp (elems.toList.map toAgave)).Pairwise fun a b => agKey b ≤ agKey a := by
      have :=
        List.pairwise_mergeSort (le := le)
          (fun a b c h1 h2 => by
            rw [hle] at *; omega)
          (fun a b => by
            have h1 := hle a b; have h2 := hle b a
            cases h3 : le a b <;> cases h4 : le b a <;> simp_all <;> omega)
          (elems.toList.map toAgave)
      exact this.imp (fun h => (hle _ _).mp h)
    have hs2 : (key'.toList.map toAgave).Pairwise fun a b => agKey b ≤ agKey a := by
      rw [List.pairwise_map, List.pairwise_iff_getElem]
      intro i j hi hj hij
      have := hsorted i j (Nat.zero_le _) hij (by simpa [hks] using hj)
      rw [getElem!_pos key' i (by simpa using hi), getElem!_pos key' j (by simpa using hj)] at this
      have h' : ¬fdKey key'[i] < fdKey key'[j] := fun hc => by
        rw [(before_iff _ _).mpr hc] at this; exact absurd this (by simp)
      simp only [agKey_toAgave, Array.getElem_toList]
      omega
    have heq : sortBy stakeCmp (elems.toList.map toAgave) = key'.toList.map toAgave := by
      apply List.Perm.eq_of_pairwise _ hs1 hs2 (hp1.trans hp2.symm)
      intro a b ha hb h1 h2
      obtain ⟨-, hv⟩ := agKey_eq (show agKey a = agKey b by omega)
      exact
        pairwise_eq_of_not (fun x y h => Ne.symm h) hdist' (hp1.subset ha) (hp2.subset hb)
          (fun h => h hv)
    unfold sort_stakes
    rw [heq]
    apply dedupBy_id
    have := (hp2.pairwise_iff (fun h => Ne.symm h)).mpr hdist'
    exact
      this.imp
        (fun h => by
          simp only [stakeSame, Bool.and_eq_false_iff, beq_eq_false_iff_ne]; exact Or.inr h)

end

end Firedancer.Leaders.Math
