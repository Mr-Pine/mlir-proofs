module

public import Firedancer.Leaders.Math.Tree
public import Firedancer.Leaders.Math.Uniform
public import Firedancer.Leaders.Leaders

/-! The radix-9 tree built by `fd_wsample_new_init/add` holds the prefix sums of the weights, and
`fd_wsample_map_sample` returns the leaf whose prefix interval contains the query. -/

namespace Firedancer.Leaders.Math

open Firedancer.Leaders Agave

@[expose] public section

/-! ## Helpers -/

/-- The number of `c < n` with `f c ≤ x`. -/
def cntLE (f : Nat → Nat) (x : Nat) : Nat → Nat
  | 0 => 0
  | n + 1 => cntLE f x n + if f n ≤ x then 1 else 0

theorem cntLE_spec (f : Nat → Nat) (x N : Nat) (hmono : ∀ a b, a ≤ b → b < N → f a ≤ f b) :
    ∀ n, n ≤ N → cntLE f x n ≤ n ∧ ∀ c, c < n → (f c ≤ x ↔ c < cntLE f x n) := by
  intro n
  induction n with
  | zero =>
    intro _; simp [cntLE]
  | succ n ih =>
    intro hn
    obtain ⟨h1, h2⟩ := ih (by omega)
    simp only [cntLE]
    by_cases hf : f n ≤ x
    · have hall : cntLE f x n = n := by
        have : ∀ c, c < n → c < cntLE f x n := fun c hc =>
          (h2 c hc).1 (Nat.le_trans (hmono c n (by omega) (by omega)) hf)
        rcases Nat.eq_zero_or_pos n with h | h
        · omega
        · have := this (n - 1) (by omega); omega
      rw [ite_eq_left hf]
      refine ⟨by omega, fun c hc => ?_⟩
      rcases Nat.lt_or_ge c n with h | h
      · exact ⟨fun _ => by omega, fun _ => Nat.le_trans (hmono c n (by omega) (by omega)) hf⟩
      · have : c = n := by omega
        subst this; simp [hf]; omega
    · rw [ite_eq_right hf]
      refine ⟨by omega, fun c hc => ?_⟩
      rcases Nat.lt_or_ge c n with h | h
      · simp only [Nat.add_zero]; exact h2 c h
      · have : c = n := by omega
        subst this; simp [hf]; omega

/-- The child count of `fd_wsample_map_sample_i` as `cntLE`. -/
theorem child_idx_eq (e : tree_ele_t) (x : BitVec 64) :
    (fd_wsample_map_sample_i.child_idx e x).toNat =
      cntLE (fun c => if h : c < 8 then e[c].toNat else 0) x.toNat 8 := by
  simp only [fd_wsample_map_sample_i.child_idx, List.finRange, List.ofFn_succ, List.ofFn_zero,
    List.foldl, cntLE, Fin.getElem_fin, Fin.val_succ, Fin.val_zero, BitVec.le_def, Nat.reduceAdd,
    Nat.reduceLT, dite_true]
  split <;> split <;> split <;> split <;> split <;> split <;> split <;> split <;> simp_all

theorem getElem!_modify {α : Type} [Inhabited α] (a : Array α) (i x : Nat) (f : α → α) :
    (a.modify i f)[x]! = if i = x ∧ x < a.size then f a[x]! else a[x]! := by
  by_cases hx : x < a.size
  · rw [getElem!_pos (a.modify i f) x (by simpa using hx), getElem!_pos a x hx,
      Array.getElem_modify]
    by_cases hi : i = x <;> simp [hi, hx]
  · rw [getElem!_neg (a.modify i f) x (by simpa using hx), getElem!_neg a x hx]; simp [hx]

theorem new_add_inner_get (w : BitVec 64) (c : Nat) (hc : c < 8) :
    ∀ n k (e : tree_ele_t),
      8 - k = n → (fd_wsample_new_add.inner w e k)[c] = if k ≤ c then e[c] + w else e[c] := by
  intro n
  induction n with
  | zero =>
    intro k e hk
    rw [fd_wsample_new_add.inner, dite_eq_right_of_eq_false (eq_false (by omega))]
    simp only [show ¬k ≤ c by omega, ite_false]
  | succ n ih =>
    intro k e hk
    rw [fd_wsample_new_add.inner, dite_eq_left_of_eq_true (eq_true (by omega)),
      ih (k + 1) _ (by omega)]
    simp only [Vector.getElem_set]
    by_cases h1 : k = c
    · subst h1; simp only [ite_true, Nat.le_refl, show ¬k + 1 ≤ k by omega, ite_false]
    · by_cases h2 : k ≤ c
      · simp [h1, h2, show k + 1 ≤ c by omega]
      · simp [h1, h2, show ¬k + 1 ≤ c by omega]

theorem parent_eq (N : Nat) (h1 : 1 ≤ N) (h2 : N < 2 ^ 62) :
    (BitVec.ofNat 64 N - 1#64) / R = BitVec.ofNat 64 ((N - 1) / 9) := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_udiv,
    BitVec.toNat_sub_of_le
      (by
        simp [BitVec.le_def]; omega)]
  simp [R]; omega

theorem child_eq (N : Nat) (h1 : 1 ≤ N) (h2 : N < 2 ^ 62) :
    (BitVec.ofNat 64 N - 1#64 - R * BitVec.ofNat 64 ((N - 1) / 9)).toNat = (N - 1) % 9 := by
  have hs : (BitVec.ofNat 64 N - 1#64).toNat = N - 1 := by
    rw [BitVec.toNat_sub_of_le
        (by
          simp [BitVec.le_def]; omega)];
    simp; omega
  have hm : (R * BitVec.ofNat 64 ((N - 1) / 9)).toNat = 9 * ((N - 1) / 9) := by
    simp [R, BitVec.toNat_mul]; omega
  rw [BitVec.toNat_sub_of_le
      (by
        rw [BitVec.le_def, hs, hm]; omega),
    hs, hm];
  omega

theorem div_pow_succ (q a : Nat) : q / 9 / 9 ^ a = q / 9 ^ (a + 1) := by
  rw [Nat.div_div_eq_div_mul, Nat.pow_succ, Nat.mul_comm]

theorem div_pow_lt {q D a : Nat} (hq : q < 9 ^ D) (ha : a ≤ D) : q / 9 ^ (D - a) < 9 ^ a := by
  rw [Nat.div_lt_iff_lt_mul (pow9_pos _), ← Nat.pow_add]; rwa [show a + (D - a) = D by omega]

/-- The `new_add` loop from leaf `q` adds the weight to its ancestors `first d + q / 9^(D-d)` from
child `q / 9^(D-d-1) % 9` on, and leaves other nodes alone. -/
theorem add_loop_path (w : BitVec 64) :
    ∀ (D q : Nat) (tree : Array tree_ele_t),
      q < 9 ^ D →
        first D + q < 2 ^ 62 →
        (fd_wsample_new_add.loop w D tree (BitVec.ofNat 64 (first D + q))).size = tree.size ∧
          (∀ d,
            d < D →
              first d + q / 9 ^ (D - d) < tree.size →
              (fd_wsample_new_add.loop w D tree
                    (BitVec.ofNat 64 (first D + q)))[first d + q / 9 ^ (D - d)]! =
                fd_wsample_new_add.inner w tree[first d + q / 9 ^ (D - d)]!
                  (q / 9 ^ (D - d - 1) % 9)) ∧
          (∀ x,
            (∀ d, d < D → x ≠ first d + q / 9 ^ (D - d)) →
              (fd_wsample_new_add.loop w D tree (BitVec.ofNat 64 (first D + q)))[x]! =
                tree[x]!) := by
  intro D
  induction D with
  | zero =>
    intro q tree _ _
    exact ⟨rfl, fun d hd => absurd hd (Nat.not_lt_zero _), fun x _ => rfl⟩
  | succ D ih =>
    intro q tree hq hb
    have hN : first (D + 1) + q - 1 = 9 * first D + q := by
      rw [first_succ']; omega
    have hN1 : 1 ≤ first (D + 1) + q := by
      rw [first_succ']; omega
    have hpar : (first (D + 1) + q - 1) / 9 = first D + q / 9 := by
      rw [hN]; omega
    have hchild : (first (D + 1) + q - 1) % 9 = q % 9 := by
      rw [hN]; omega
    have hq9 : q / 9 < 9 ^ D := by
      rw [Nat.div_lt_iff_lt_mul (by omega), ← Nat.pow_succ]; exact hq
    simp only [fd_wsample_new_add.loop]
    rw [parent_eq _ hN1 hb, child_eq _ hN1 hb, hpar, hchild]
    have htn : (BitVec.ofNat 64 (first D + q / 9)).toNat = first D + q / 9 := by
      simp; omega
    rw [htn]
    obtain ⟨ihs, iha, iho⟩ :=
      ih (q / 9) (tree.modify (first D + q / 9) fun e => fd_wsample_new_add.inner w e (q % 9)) hq9
        (by omega)
    rw [Array.size_modify] at ihs iha
    -- the new node differs from every node of the remaining path
    have hne : ∀ d, d < D → first D + q / 9 ≠ first d + q / 9 / 9 ^ (D - d) := by
      intro d hd heq
      have := node_inj hq9 (div_pow_lt hq9 (Nat.le_of_lt hd)) heq
      omega
    refine ⟨ihs, fun d hd hlt => ?_, fun x hx => ?_⟩
    · rcases Nat.lt_or_ge d D with hdD | hdD
      · have e1 : q / 9 ^ (D + 1 - d) = q / 9 / 9 ^ (D - d) := by
          rw [div_pow_succ]; congr 2; omega
        have e2 : q / 9 ^ (D + 1 - d - 1) = q / 9 / 9 ^ (D - d - 1) := by
          rw [div_pow_succ]; congr 2; omega
        rw [e1] at hlt; rw [e1, e2]
        rw [iha d hdD hlt, getElem!_modify,
          ite_eq_right
            (by
              intro h; exact hne d hdD h.1)]
      · have hdD' : d = D := by omega
        subst hdD'
        simp only [show d + 1 - d = 1 by omega, Nat.pow_one] at hlt ⊢
        rw [iho _ hne, getElem!_modify, ite_eq_left ⟨rfl, hlt⟩]
        simp
    · have hx' : x ≠ first D + q / 9 := by
        have := hx D (by omega)
        simpa [show D + 1 - D = 1 by omega] using this
      rw [iho x
          (fun d hd => by
            have := hx d (by omega)
            rwa [show D + 1 - d = D - d + 1 by omega, ← div_pow_succ] at this),
        getElem!_modify,
        ite_eq_right
          (by
            intro h; exact hx' h.1.symm)]

/-! ## The tree invariant -/

/-- The tree of height `h` holds the prefix sums of the leaf weights `ws`: `left_sum[c]` of node
`first d + r` is the weight of the leaves under its first `c + 1` children. -/
def TreeInv (h : Nat) (ws : List Nat) (tree : Array tree_ele_t) : Prop :=
  tree.size = first h ∧
    ∀ d r c (_ : d < h) (_ : r < 9 ^ d) (hc : c < 8),
      (tree[first d + r]!)[c].toNat =
        pre ws (r * 9 ^ (h - d) + (c + 1) * 9 ^ (h - d - 1)) - pre ws (r * 9 ^ (h - d))

theorem node_lt {h d r : Nat} (hd : d < h) (hr : r < 9 ^ d) : first d + r < first h := by
  have := first_mono (Nat.succ_le_of_lt hd); rw [first_succ] at this; omega

theorem TreeInv_init (h : Nat) :
    TreeInv h [] (Array.replicate (first h) (Vector.replicate 8 0#64)) := by
  refine ⟨by simp, fun d r c hd hr hc => ?_⟩
  rw [getElem!_pos _ _ (by simpa using node_lt hd hr)]
  simp [pre]

theorem pre_le_sum (l : List Nat) (j : Nat) : pre l j ≤ l.sum := by
  rw [← pre_length_eq_sum]
  rcases Nat.lt_or_ge j l.length with h | h
  · exact pre_mono l (Nat.le_of_lt h)
  · rw [pre_of_le l h]; exact Nat.le_refl _

theorem pow_sub_succ {h d : Nat} (hd : d < h) : 9 ^ (h - d) = 9 * 9 ^ (h - d - 1) := by
  have e : h - d = (h - d - 1) + 1 := by omega
  rw [← Nat.pow_succ']; exact congrArg _ e

/-- Adding leaf `ws.length` with weight `w` keeps `TreeInv`. -/
theorem TreeInv_add (h : Nat) (ws : List Nat) (tree : Array tree_ele_t) (hinv : TreeInv h ws tree)
    (ht : ws.length < 9 ^ h) (w : BitVec 64) (hsum : ws.sum + w.toNat < 2 ^ 64)
    (hb : first h + 9 ^ h < 2 ^ 62) :
    TreeInv h (ws ++ [w.toNat])
      (fd_wsample_new_add.loop w h tree (BitVec.ofNat 64 (first h + ws.length))) := by
  obtain ⟨hsize, hval⟩ := hinv
  obtain ⟨psize, panc, poth⟩ := add_loop_path w h ws.length tree ht (by omega)
  refine ⟨by rw [psize, hsize], fun d r c hd hr hc => ?_⟩
  have hidx : first d + r < tree.size := by
    rw [hsize]; exact node_lt hd hr
  have hold := hval d r c hd hr hc
  have hS := pow_sub_succ hd
  have hanc_iff :
    ∀ d',
      d' < h → first d + r = first d' + ws.length / 9 ^ (h - d') → r = ws.length / 9 ^ (h - d) := by
    intro d' hd' heq
    have := node_inj hr (div_pow_lt ht (Nat.le_of_lt hd')) heq
    obtain ⟨rfl, rfl⟩ := this; rfl
  by_cases hanc : r = ws.length / 9 ^ (h - d)
  · have hp :=
      panc d hd
        (by
          rw [← hanc]; exact hidx)
    rw [← hanc] at hp
    rw [hp, new_add_inner_get w c hc _ _ _ rfl]
    rw [pre_append, pre_append]
    generalize ws.length = t at *
    generalize 9 ^ (h - d - 1) = s at *
    have hs : 0 < s := by
      rcases Nat.eq_zero_or_pos s with h0 | h0
      · subst h0; have := pow9_pos (h - d); omega
      · exact h0
    have hL : r * 9 ^ (h - d) + (c + 1) * s = (9 * r + c + 1) * s := by
      rw [hS]; grind
    have hL0 : r * 9 ^ (h - d) = (9 * r) * s := by
      rw [hS]; grind
    rw [hL, hL0] at hold ⊢
    have hmono :=
      pre_mono ws (show 9 * r * s ≤ (9 * r + c + 1) * s from Nat.mul_le_mul_right _ (by omega))
    have hle := pre_le_sum ws ((9 * r + c + 1) * s)
    have hts : t / s / 9 = r := by rw [Nat.div_div_eq_div_mul, hanc, hS, Nat.mul_comm]
    have htk : t / s = 9 * (t / s / 9) + t / s % 9 := (Nat.div_add_mod _ _).symm
    have hB : 9 * r * s ≤ t := by
      have := Nat.div_mul_le_self t s
      have : 9 * r * s ≤ t / s * s := Nat.mul_le_mul_right _ (by omega)
      omega
    have hA : t < (9 * r + c + 1) * s ↔ t / s % 9 ≤ c := by
      rw [← Nat.div_lt_iff_lt_mul hs]; omega
    by_cases hk : t / s % 9 ≤ c
    · rw [ite_eq_left hk, ite_eq_left (hA.mpr hk), ite_eq_right (by omega)]
      rw [BitVec.toNat_add, Nat.mod_eq_of_lt (by omega)]
      omega
    · rw [ite_eq_right hk, ite_eq_right (fun h => hk (hA.mp h)), ite_eq_right (by omega)]
      omega
  · rw [poth _ (fun d' hd' heq => hanc (hanc_iff d' hd' heq)), pre_append, pre_append]
    generalize ws.length = t at *
    generalize 9 ^ (h - d - 1) = s at *
    have hL : r * 9 ^ (h - d) + (c + 1) * s = (9 * r + c + 1) * s := by
      rw [hS]; grind
    have hL0 : r * 9 ^ (h - d) = (9 * r) * s := by
      rw [hS]; grind
    rw [hL, hL0] at hold ⊢
    have hmono :=
      pre_mono ws (show 9 * r * s ≤ (9 * r + c + 1) * s from Nat.mul_le_mul_right _ (by omega))
    rw [hS] at hanc
    rcases Nat.lt_or_gt_of_ne hanc with hlt | hgt
    · -- leaf `t` lies after the node's leaves
      have h1 : (r + 1) * (9 * s) ≤ t := by
        have := Nat.div_mul_le_self t (9 * s)
        have : (r + 1) * (9 * s) ≤ t / (9 * s) * (9 * s) := Nat.mul_le_mul_right _ (by omega)
        omega
      have h2 : (9 * r + c + 1) * s ≤ (r + 1) * (9 * s) := by
        have : (9 * r + c + 1) * s ≤ (9 * r + 9) * s := Nat.mul_le_mul_right _ (by omega)
        have : (9 * r + 9) * s = (r + 1) * (9 * s) := by grind
        omega
      rw [ite_eq_right (by omega), ite_eq_right (by omega)]; omega
    · -- leaf `t` lies before the node's leaves
      have h1 : t < 9 * r * s := by
        have :=
          (Nat.div_lt_iff_lt_mul (k := 9 * s)
                (by
                  rcases Nat.eq_zero_or_pos s with h0 | h0
                  · subst h0; have := pow9_pos (h - d); omega
                  · omega)).mp
            hgt
        have : r * (9 * s) = 9 * r * s := by grind
        omega
      rw [ite_eq_left (by omega), ite_eq_left (by omega)]; omega

/-! ## The descent -/

/-- The 10-word window `[0, left_sum…, S]` of `fd_wsample_map_sample_i`. -/
def window (e : tree_ele_t) (S : BitVec 64) : Vector (BitVec 64) 10 :=
  #v[0#64, e[0], e[1], e[2], e[3], e[4], e[5], e[6], e[7], S]

theorem step_eq (tree : Array tree_ele_t) (q S cur : BitVec 64) :
    fd_wsample_map_sample_i.step tree q S cur =
      (q -
          (window tree[cur.toNat]!
              S)[(fd_wsample_map_sample_i.child_idx tree[cur.toNat]! q).toNat]!,
        (window tree[cur.toNat]!
              S)[(fd_wsample_map_sample_i.child_idx tree[cur.toNat]! q + 1#64).toNat]! -
          (window tree[cur.toNat]!
              S)[(fd_wsample_map_sample_i.child_idx tree[cur.toNat]! q).toNat]!,
        R * cur + fd_wsample_map_sample_i.child_idx tree[cur.toNat]! q + 1#64) :=
  rfl

theorem window_lo (e : tree_ele_t) (S : BitVec 64) (ci : Nat) (hci : ci ≤ 8) :
    (window e S)[ci]! = if ci = 0 then 0#64 else e[ci - 1]'(by omega) := by
  match ci, hci with
  | 0, _ => rfl
  | 1, _ => rfl
  | 2, _ => rfl
  | 3, _ => rfl
  | 4, _ => rfl
  | 5, _ => rfl
  | 6, _ => rfl
  | 7, _ => rfl
  | 8, _ => rfl

theorem window_hi (e : tree_ele_t) (S : BitVec 64) (ci : Nat) (hci : ci ≤ 8) :
    (window e S)[ci + 1]! = if h : ci < 8 then e[ci] else S := by
  match ci, hci with
  | 0, _ => rfl
  | 1, _ => rfl
  | 2, _ => rfl
  | 3, _ => rfl
  | 4, _ => rfl
  | 5, _ => rfl
  | 6, _ => rfl
  | 7, _ => rfl
  | 8, _ => rfl

/-- The descent from node `first d + r`, `rem` levels above the leaves, ends at the leaf `r'`
whose prefix interval contains `u`. -/
theorem map_loop (h : Nat) (ws : List Nat) (tree : Array tree_ele_t) (hinv : TreeInv h ws tree)
    (htot : ws.sum < 2 ^ 64) (hh : first h + 9 ^ h < 2 ^ 60) (u : Nat) :
    ∀ rem d r,
      d + rem = h →
        r < 9 ^ d →
        pre ws (r * 9 ^ rem) ≤ u →
        u < pre ws ((r + 1) * 9 ^ rem) →
        ∃ r',
          r * 9 ^ rem ≤ r' ∧
            r' < (r + 1) * 9 ^ rem ∧
            pre ws r' ≤ u ∧
            u < pre ws (r' + 1) ∧
            fd_wsample_map_sample_i.loop tree rem (BitVec.ofNat 64 (u - pre ws (r * 9 ^ rem)))
                (BitVec.ofNat 64 (pre ws ((r + 1) * 9 ^ rem) - pre ws (r * 9 ^ rem)))
                (BitVec.ofNat 64 (first d + r)) =
              (BitVec.ofNat 64 (pre ws (r' + 1) - pre ws r'), BitVec.ofNat 64 (first h + r')) := by
  intro rem
  induction rem with
  | zero =>
    intro d r hd hr h1 h2
    simp only [Nat.pow_zero, Nat.mul_one, Nat.add_zero] at hd h1 h2 ⊢
    subst hd
    exact ⟨r, Nat.le_refl _, by omega, h1, h2, rfl⟩
  | succ rem ih =>
    intro d r hd hr h1 h2
    have hdh : d < h := by omega
    have hpow : 9 ^ (rem + 1) = 9 * 9 ^ rem := by rw [Nat.pow_succ, Nat.mul_comm]
    have hspos := pow9_pos rem
    generalize hs : 9 ^ rem = s at *
    have hL : r * 9 ^ (rem + 1) = 9 * r * s := by
      rw [hpow]; grind
    have hL1 : (r + 1) * 9 ^ (rem + 1) = 9 * r * s + 9 * s := by
      rw [hpow]; grind
    rw [hL] at h1; rw [hL1] at h2; rw [hL, hL1]
    have hsum_le : ∀ j, pre ws j < 2 ^ 64 := fun j => Nat.lt_of_le_of_lt (pre_le_sum ws j) htot
    have hcur_lt : first d + r < first h := node_lt hdh hr
    have hcur : (BitVec.ofNat 64 (first d + r)).toNat = first d + r := by
      have := pow9_pos h; simp; omega
    generalize he : tree[first d + r]! = e
    have hev :
      ∀ c (hc : c < 8), e[c].toNat = pre ws (9 * r * s + (c + 1) * s) - pre ws (9 * r * s) := by
      intro c hc
      have := hinv.2 d r c hdh hr hc
      rw [he, show h - d - 1 = rem by omega, show h - d = rem + 1 by omega, hs, hL] at this
      exact this
    have hmono :
      ∀ a b,
        a ≤ b →
          b < 8 →
          (fun c => if h : c < 8 then e[c].toNat else 0) a ≤
            (fun c => if h : c < 8 then e[c].toNat else 0) b := by
      intro a b hab hb
      simp only [show a < 8 by omega, hb, dite_true, hev]
      have :=
        pre_mono ws
          (show 9 * r * s + (a + 1) * s ≤ 9 * r * s + (b + 1) * s from
            Nat.add_le_add_left (Nat.mul_le_mul_right _ (by omega)) _)
      omega
    generalize hxN : u - pre ws (9 * r * s) = xN
    have hxlt : xN < 2 ^ 64 := by
      have := hsum_le (9 * r * s + 9 * s); omega
    obtain ⟨hci8, hciff⟩ := cntLE_spec _ xN 8 hmono 8 (Nat.le_refl _)
    have hci := child_idx_eq e (BitVec.ofNat 64 xN)
    rw [BitVec.toNat_ofNat, Nat.mod_eq_of_lt hxlt] at hci
    generalize cntLE (fun c => if h : c < 8 then e[c].toNat else 0) xN 8 = ci at hci hci8 hciff
    -- the window reads
    have hlo :
      ((window e (BitVec.ofNat 64 (pre ws (9 * r * s + 9 * s) - pre ws (9 * r * s))))[ci]!).toNat =
        pre ws (9 * r * s + ci * s) - pre ws (9 * r * s) := by
      rw [window_lo _ _ _ hci8]
      by_cases h0 : ci = 0
      · subst h0; simp
      · rw [ite_eq_right h0, hev _ (by omega), show ci - 1 + 1 = ci by omega]
    have hhi :
      ((window e
              (BitVec.ofNat 64 (pre ws (9 * r * s + 9 * s) - pre ws (9 * r * s))))[ci + 1]!).toNat =
        pre ws (9 * r * s + (ci + 1) * s) - pre ws (9 * r * s) := by
      rw [window_hi _ _ _ hci8]
      by_cases h8 : ci < 8
      · rw [dite_eq_left_of_eq_true (eq_true h8), hev _ h8]
      · rw [dite_eq_right_of_eq_false (eq_false h8), show ci = 8 by omega]
        simp only [BitVec.toNat_ofNat]
        rw [Nat.mod_eq_of_lt
            (by
              have := hsum_le (9 * r * s + 9 * s); omega)]
    have hm1 := pre_mono ws (show 9 * r * s ≤ 9 * r * s + ci * s by omega)
    have hm2 :=
      pre_mono ws
        (show 9 * r * s + ci * s ≤ 9 * r * s + (ci + 1) * s from
          Nat.add_le_add_left (Nat.mul_le_mul_right _ (by omega)) _)
    -- the query stays in the chosen child
    have hlo_le : pre ws (9 * r * s + ci * s) ≤ u := by
      by_cases h0 : ci = 0
      · subst h0; simpa using h1
      · have := (hciff (ci - 1) (by omega)).mpr (by omega)
        simp only [show ci - 1 < 8 by omega, dite_true, hev] at this
        rw [show ci - 1 + 1 = ci by omega] at this
        omega
    have hhi_lt : u < pre ws (9 * r * s + (ci + 1) * s) := by
      by_cases h8 : ci < 8
      · have := mt (hciff ci h8).mp (by omega)
        simp only [h8, dite_true, hev] at this
        omega
      · rw [show ci = 8 by omega]; exact h2
    have hciB :
      (fd_wsample_map_sample_i.child_idx e (BitVec.ofNat 64 xN)) = BitVec.ofNat 64 ci := by
      apply BitVec.eq_of_toNat_eq; rw [hci]; simp; omega
    have hci1 : (BitVec.ofNat 64 ci + 1#64).toNat = ci + 1 := by
      simp; omega
    rw [fd_wsample_map_sample_i.loop, step_eq, hcur, he, hciB, hci1]
    simp only [BitVec.toNat_ofNat, Nat.mod_eq_of_lt (show ci < 2 ^ 64 by omega)]
    have hq :
      BitVec.ofNat 64 xN -
          (window e (BitVec.ofNat 64 (pre ws (9 * r * s + 9 * s) - pre ws (9 * r * s))))[ci]! =
        BitVec.ofNat 64 (u - pre ws ((9 * r + ci) * s)) := by
      apply BitVec.eq_of_toNat_eq
      rw [BitVec.toNat_sub_of_le
          (by
            rw [BitVec.le_def, hlo]; simp; omega),
        hlo]
      simp only [BitVec.toNat_ofNat, Nat.mod_eq_of_lt hxlt]
      rw [show (9 * r + ci) * s = 9 * r * s + ci * s by grind]
      rw [Nat.mod_eq_of_lt (by omega)]; omega
    have hS :
      (window e (BitVec.ofNat 64 (pre ws (9 * r * s + 9 * s) - pre ws (9 * r * s))))[ci + 1]! -
          (window e (BitVec.ofNat 64 (pre ws (9 * r * s + 9 * s) - pre ws (9 * r * s))))[ci]! =
        BitVec.ofNat 64 (pre ws ((9 * r + ci + 1) * s) - pre ws ((9 * r + ci) * s)) := by
      apply BitVec.eq_of_toNat_eq
      rw [BitVec.toNat_sub_of_le
          (by
            rw [BitVec.le_def, hlo, hhi]; omega),
        hlo, hhi]
      rw [show (9 * r + ci + 1) * s = 9 * r * s + (ci + 1) * s by grind,
        show (9 * r + ci) * s = 9 * r * s + ci * s by grind]
      simp only [BitVec.toNat_ofNat]
      rw [Nat.mod_eq_of_lt
          (by
            have := hsum_le (9 * r * s + (ci + 1) * s); omega)];
      omega
    have hc :
      R * BitVec.ofNat 64 (first d + r) + BitVec.ofNat 64 ci + 1#64 =
        BitVec.ofNat 64 (first (d + 1) + (9 * r + ci)) := by
      apply BitVec.eq_of_toNat_eq
      rw [first_succ']
      simp [R, BitVec.toNat_add, BitVec.toNat_mul]
      omega
    rw [hq, hS, hc]
    have hr' : 9 * r + ci < 9 ^ (d + 1) := by
      rw [Nat.pow_succ]; omega
    obtain ⟨r', hr1, hr2, hr3, hr4, heq⟩ :=
      ih (d + 1) (9 * r + ci) (by omega) hr'
        (by
          rw [show (9 * r + ci) * s = 9 * r * s + ci * s by grind]; exact hlo_le)
        (by
          rw [show (9 * r + ci + 1) * s = 9 * r * s + (ci + 1) * s by grind]; exact hhi_lt)
    refine ⟨r', ?_, ?_, hr3, hr4, heq⟩
    · have : 9 * r * s ≤ (9 * r + ci) * s := Nat.mul_le_mul_right _ (by omega)
      omega
    · have : (9 * r + ci + 1) * s ≤ 9 * r * s + 9 * s := by
        have : (9 * r + ci + 1) * s ≤ (9 * r + 9) * s := Nat.mul_le_mul_right _ (by omega)
        have : (9 * r + 9) * s = 9 * r * s + 9 * s := by grind
        omega
      omega

/-! ## Building the sampler -/

theorem pre_eq_take_sum (l : List Nat) (j : Nat) : pre l j = (l.take j).sum := by
  induction l generalizing j with
  | nil => simp [pre]
  | cons a l ih => cases j <;> simp [pre, ih]

/-- The stakes as leaf weights. -/
def stakeList (stakes : Array fd_vote_stake_weight_t) : List Nat :=
  stakes.toList.map (·.stake.toNat)

/-- The sampler holds leaves `ws` in a tree of height `h`, not poisoned, without restore. -/
def SamplerInv (h : Nat) (ws : List Nat) (s : fd_wsample_t) : Prop :=
  s.internal_node_cnt = BitVec.ofNat 64 (first h) ∧
    s.height.toNat = h ∧
    s.unremoved_cnt = BitVec.ofNat 64 ws.length ∧
    s.unremoved_weight = BitVec.ofNat 64 ws.sum ∧
    s.total_weight = BitVec.ofNat 64 ws.sum ∧
    s.poisoned_weight = 0#64 ∧ s.poisoned_mode = 0#8 ∧ s.restore_enabled = 0#8 ∧ TreeInv h ws s.tree

theorem first_lt {h : Nat} (hh : h < 11) : first h + 9 ^ h < 2 ^ 40 := by
  have h1 := first_mono (show h ≤ 10 by omega)
  have h2 : 9 ^ h ≤ 9 ^ 10 := Nat.pow_le_pow_right (by omega) (by omega)
  have : first 10 = 435848050 := by decide
  have : 9 ^ 10 = 3486784401 := by decide
  omega

theorem stakeList_length (stakes : Array fd_vote_stake_weight_t) :
    (stakeList stakes).length = stakes.size := by simp [stakeList]

theorem stakeList_getElem (stakes : Array fd_vote_stake_weight_t) (i : Nat) (hi : i < stakes.size) :
    (stakeList stakes)[i]'(by
          rw [stakeList_length]; exact hi) =
      stakes[i].stake.toNat := by
  simp [stakeList]

/-- The `fd_wsample_new_add` loop of `fd_epoch_leaders_new` adds every stake. -/
theorem add_loop_inv (stakes : Array fd_vote_stake_weight_t) (h : Nat) (hm : stakes.size ≤ 9 ^ h)
    (hh : h < 11) (hnz : ∀ i (hi : i < stakes.size), stakes[i].stake ≠ 0#64)
    (htot : (stakeList stakes).sum < 2 ^ 64) :
    ∀ n i s,
      stakes.size - i = n →
        i ≤ stakes.size →
        SamplerInv h ((stakeList stakes).take i) s →
        ∃ s',
          fd_epoch_leaders_new.add_loop stakes stakes.size (some s) i = some (some s') ∧
            SamplerInv h (stakeList stakes) s' := by
  have hfl := first_lt hh
  intro n
  induction n with
  | zero =>
    intro i s hn hi hs
    have : i = stakes.size := by omega
    subst this
    refine ⟨s, ?_, ?_⟩
    · rw [fd_epoch_leaders_new.add_loop, ite_eq_right (Nat.lt_irrefl _)]
    · rwa [List.take_of_length_le (by simp [stakeList_length])] at hs
  | succ n ih =>
    intro i s hn hi hs
    have hi' : i < stakes.size := by omega
    obtain ⟨hint, hhgt, hcnt, huw, htw, hpw, hpm, hre, htree⟩ := hs
    have hlen : ((stakeList stakes).take i).length = i := by
      simp [List.length_take, stakeList_length]; omega
    have htake :
      (stakeList stakes).take (i + 1) = (stakeList stakes).take i ++ [stakes[i].stake.toNat] := by
      rw [List.take_succ_eq_append_getElem
          (by
            rw [stakeList_length]; exact hi'),
        stakeList_getElem]
    have hsum1 : ((stakeList stakes).take (i + 1)).sum < 2 ^ 64 := by
      rw [← pre_eq_take_sum]; exact Nat.lt_of_le_of_lt (pre_le_sum _ _) htot
    have hsum : ((stakeList stakes).take i).sum + stakes[i].stake.toNat < 2 ^ 64 := by
      rw [htake, List.sum_append] at hsum1; simpa using hsum1
    rw [fd_epoch_leaders_new.add_loop, ite_eq_left hi', Array.getElem?_eq_getElem hi']
    simp only
    have hw0 := hnz i hi'
    have hnov : ¬(s.total_weight + stakes[i].stake < stakes[i].stake) := by
      rw [htw, BitVec.lt_def, BitVec.toNat_add]; simp; try omega
    have hidx : s.internal_node_cnt + s.unremoved_cnt = BitVec.ofNat 64 (first h + i) := by
      rw [hint, hcnt, hlen]; apply BitVec.eq_of_toNat_eq; simp; try omega
    simp only [fd_wsample_new_add.spec, hw0, hnov, ite_false, hidx, hhgt]
    refine ih (i + 1) _ (by omega) (by omega) ⟨hint, hhgt, ?_, ?_, ?_, hpw, hpm, hre, ?_⟩
    · rw [hcnt, hlen]; simp only [htake, List.length_append, hlen, List.length_singleton]
      apply BitVec.eq_of_toNat_eq; simp; try omega
    · rw [huw, htake, List.sum_append]; apply BitVec.eq_of_toNat_eq; simp; try omega
    · rw [htw, htake, List.sum_append]; apply BitVec.eq_of_toNat_eq; simp; try omega
    · have := TreeInv_add h _ _ htree (by omega) _ hsum (by omega)
      rw [hlen] at this; rw [htake]; exact this

/-! ## Sampling -/

/-- `fd_wsample_map_sample` returns the leaf `r` with `pre r ≤ u < pre (r + 1)`. -/
theorem map_sample_eq (h : Nat) (ws : List Nat) (s : fd_wsample_t) (hs : SamplerInv h ws s)
    (hlen : ws.length ≤ 9 ^ h) (hh : h < 11) (htot : ws.sum < 2 ^ 64) (u : BitVec 64)
    (hu : u.toNat < ws.sum) :
    ∃ r,
      r < ws.length ∧
        pre ws r ≤ u.toNat ∧
        u.toNat < pre ws (r + 1) ∧ fd_wsample_map_sample.spec s u = BitVec.ofNat 64 r := by
  obtain ⟨hint, hhgt, _, huw, _, _, _, _, htree⟩ := hs
  have hfl := first_lt hh
  have hpre : pre ws (9 ^ h) = ws.sum := by rw [pre_of_le _ hlen, pre_length_eq_sum]
  obtain ⟨r, _, hr2, hr3, hr4, heq⟩ :=
    map_loop h ws s.tree htree htot (by omega) u.toNat h 0 0 (by omega) (by simp) (by simp)
      (by simpa [hpre] using hu)
  have hrl : r < ws.length := by
    false_or_by_contra
    have := pre_of_le ws (show ws.length ≤ r by omega)
    rw [pre_length_eq_sum] at this; omega
  refine ⟨r, hrl, hr3, hr4, ?_⟩
  simp only [Nat.zero_mul, pre_zero, Nat.sub_zero, Nat.zero_add, Nat.one_mul, hpre] at heq
  unfold fd_wsample_map_sample.spec fd_wsample_map_sample_i.spec
  rw [hhgt, huw, show (0#64 : BitVec 64) = BitVec.ofNat 64 (first 0 + 0) from rfl,
    show u = BitVec.ofNat 64 u.toNat by simp]
  dsimp only
  rw [heq, hint]
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_sub, BitVec.toNat_ofNat]
  omega

/-- `prefixSums` from `a` appends the running totals `a + pre l (j + 1)`. -/
theorem prefixSums_ok (l : List (BitVec 64)) :
    ∀ (a : Nat) (acc : Array (BitVec 64)),
      a + (l.map (·.toNat)).sum < 2 ^ 64 →
        ∃ arr,
          prefixSums (BitVec.ofNat 64 a) acc l =
              .ok (BitVec.ofNat 64 (a + (l.map (·.toNat)).sum), arr) ∧
            arr.size = acc.size + l.length ∧
            (∀ i, i < acc.size → arr[i]! = acc[i]!) ∧
            ∀ j,
              j < l.length →
                arr[acc.size + j]! = BitVec.ofNat 64 (a + pre (l.map (·.toNat)) (j + 1)) := by
  induction l with
  | nil =>
    intro a acc _;
    exact ⟨acc, by simp [prefixSums], by simp, fun _ _ => rfl, fun j hj => by simp at hj⟩
  | cons w l ih =>
    intro a acc hsum
    simp only [List.map_cons, List.sum_cons] at hsum
    have hca : checkedAdd (BitVec.ofNat 64 a) w = some (BitVec.ofNat 64 (a + w.toNat)) := by
      unfold checkedAdd
      rw [ite_eq_left
          (by
            simp; try omega)]
      congr 1; apply BitVec.eq_of_toNat_eq; simp; try omega
    obtain ⟨arr, harr, hsz, hacc, hnew⟩ :=
      ih (a + w.toNat) (acc.push (BitVec.ofNat 64 (a + w.toNat))) (by omega)
    refine ⟨arr, ?_, ?_, fun i hi => ?_, fun j hj => ?_⟩
    · simp only [prefixSums, hca, harr, List.map_cons, List.sum_cons]
      congr 3; omega
    · simp [hsz]; omega
    · rw [hacc i
          (by
            simp; omega)]
      rw [getElem!_pos (acc.push (BitVec.ofNat 64 (a + w.toNat))) i
          (by
            simp; omega),
        getElem!_pos acc i hi, Array.getElem_push_lt]
    · rcases j with _ | j
      · have := hacc acc.size (by simp)
        rw [Nat.add_zero, this,
          getElem!_pos (acc.push (BitVec.ofNat 64 (a + w.toNat))) acc.size (by simp),
          Array.getElem_push_eq]
        simp [pre]
      · have :=
          hnew j
            (by
              simp at hj; omega)
        rw [show (acc.push (BitVec.ofNat 64 (a + w.toNat))).size + j = acc.size + (j + 1) by
            simp; omega] at this
        rw [this]; simp only [List.map_cons, pre]; congr 1; omega

theorem weighted_new_ok (ws : List (BitVec 64)) (hlen : 1 ≤ ws.length)
    (htot : (ws.map (·.toNat)).sum < 2 ^ 64) (hpos : 0 < (ws.map (·.toNat)).sum) :
    ∃ arr : Array (BitVec 64),
      WeightedU64Index.new ws =
          .ok {
              weights := arr.pop
              total_weight_sampler :=
                UniformU64Sampler.new_like_instance_sample
                  (BitVec.ofNat 64 (ws.map (·.toNat)).sum) } ∧
        arr.size = ws.length ∧
        ∀ j, j < ws.length → arr[j]! = BitVec.ofNat 64 (pre (ws.map (·.toNat)) (j + 1)) := by
  obtain ⟨arr, harr, hsz, -, hnew⟩ := prefixSums_ok ws 0 #[] (by simpa using htot)
  simp only [Nat.zero_add, List.size_toArray, List.length_nil] at hsz hnew harr
  refine ⟨arr, ?_, hsz, fun j hj => by simpa using hnew j hj⟩
  unfold WeightedU64Index.new
  rw [show (0#64 : BitVec 64) = BitVec.ofNat 64 0 from rfl, harr]
  simp only [bind, Except.bind, pure, Except.pure]
  rw [ite_eq_right (by omega),
    ite_eq_right
      (by
        intro h; have := congrArg BitVec.toNat h; simp at this; omega)]

/-- With `pre r ≤ u < pre (r + 1)`, Agave's `partition_point` over the prefix sums returns `r`. -/
theorem partition_point_prefix (ws : List Nat) (arr : Array (BitVec 64))
    (hsz : arr.size = ws.length)
    (harr : ∀ j, j < ws.length → arr[j]! = BitVec.ofNat 64 (pre ws (j + 1)))
    (htot : ws.sum < 2 ^ 64) (u : BitVec 64) (r : Nat) (hr : r < ws.length)
    (h1 : pre ws r ≤ u.toNat) (h2 : u.toNat < pre ws (r + 1)) :
    partition_point arr.pop (fun w => decide (w ≤ u)) = r := by
  have hb : ∀ j, pre ws j < 2 ^ 64 := fun j => Nat.lt_of_le_of_lt (pre_le_sum ws j) htot
  have hget : ∀ j, j < ws.length - 1 → arr.pop[j]! = BitVec.ofNat 64 (pre ws (j + 1)) := by
    intro j hj
    rw [getElem!_pos arr.pop j
        (by
          simp; omega),
      Array.getElem_pop, ← getElem!_pos arr j (by omega)]
    exact harr j (by omega)
  apply partition_point_eq
  · simp; omega
  · intro i hi
    rw [hget i (by omega)]
    have := pre_mono ws (show i + 1 ≤ r by omega)
    simp [BitVec.le_def, Nat.mod_eq_of_lt (hb _)]; omega
  · intro i hi1 hi2
    simp at hi2
    rw [hget i (by omega)]
    have := pre_mono ws (show r + 1 ≤ i + 1 by omega)
    simp [BitVec.le_def, Nat.mod_eq_of_lt (hb _)]; omega

theorem fueledRel_done {α β : Type} {R : α → β → Prop} {x : Fueled α} {b : β}
    (h : FueledRel R x (.done b)) : ∃ a, x = .done a ∧ R a b := by
  cases x with
  | done a => exact ⟨a, rfl, h⟩
  | outOfFuel => exact h.elim

theorem fueledRel_oof {α β : Type} {R : α → β → Prop} {x : Fueled α}
    (h : FueledRel R x .outOfFuel) : x = .outOfFuel := by
  cases x with
  | done a => exact h.elim
  | outOfFuel => rfl

theorem rollAt_lt {k : Vector (BitVec 32) 8} {n zone : BitVec 64} (hn : 0 < n.toNat) :
    ∀ {fuel P v P'}, rollAt k n zone fuel P = .done (v, P') → v.toNat < n.toNat
  | 0, _, _, _, h => by simp [rollAt] at h
  | fuel + 1, P, v, P', h => by
    simp only [rollAt] at h
    split at h
    · cases h
      simp only [UniformU64Sampler.wmul, BitVec.truncate_eq_setWidth, BitVec.toNat_setWidth,
        BitVec.toNat_ushiftRight, BitVec.toNat_mul, Nat.shiftRight_eq_div_pow]
      have h1 := (ks64 k P).isLt
      have h2 := n.isLt
      simp only [Nat.mod_eq_of_lt (show (ks64 k P).toNat < 2 ^ 128 by omega),
        Nat.mod_eq_of_lt (show n.toNat < 2 ^ 128 by omega)]
      have h3 : (ks64 k P).toNat * n.toNat < 2 ^ 128 := by
        have := Nat.mul_lt_mul_of_lt_of_le h1 (Nat.le_of_lt h2) (by omega); omega
      rw [Nat.mod_eq_of_lt h3]
      have : (ks64 k P).toNat * n.toNat / 2 ^ 64 < n.toNat := by
        rw [Nat.div_lt_iff_lt_mul (by omega), Nat.mul_comm n.toNat]
        exact Nat.mul_lt_mul_of_pos_right h1 hn
      omega
    · exact rollAt_lt hn h

/-- One leader draw: `fd_wsample_sample` on the built tree and `WeightedU64Index::sample` agree,
both running out of fuel or both returning the same leaf from the same stream position. -/
theorem sample_eq (h : Nat) (ws : List (BitVec 64)) (s : fd_wsample_t)
    (hs : SamplerInv h (ws.map (·.toNat)) s) (hlen : ws.length ≤ 9 ^ h) (hh : h < 11)
    (htot : (ws.map (·.toNat)).sum < 2 ^ 64) (hpos : 0 < (ws.map (·.toNat)).sum)
    (arr : Array (BitVec 64)) (hsz : arr.size = ws.length)
    (harr : ∀ j, j < ws.length → arr[j]! = BitVec.ofNat 64 (pre (ws.map (·.toNat)) (j + 1)))
    {key : Vector (BitVec 8) 32} {rngF : fd_chacha_rng_t} {rngA : ChaCha20Rng} {P fuel : Nat}
    (hF : FdRel key rngF P) (hA : AgRel (uintsOfBytes (k := 8) key) rngA P)
    (hb : 4 * (P + 2 * fuel) + 1024 < 2 ^ 64) :
    FueledRel
      (fun a b =>
        a.1 = BitVec.ofNat 64 b.1 ∧
          b.1 < ws.length ∧
          ∃ P',
            P' ≤ P + 2 * fuel ∧
              P' % 2 = P % 2 ∧ FdRel key a.2 P' ∧ AgRel (uintsOfBytes (k := 8) key) b.2 P')
      (fd_wsample_sample.spec fuel s rngF)
      (WeightedU64Index.sample
        { weights := arr.pop,
          total_weight_sampler :=
            UniformU64Sampler.new_like_instance_sample (BitVec.ofNat 64 (ws.map (·.toNat)).sum) }
        ChaCha20Rng.next_u64 fuel rngA) := by
  have hs' := hs
  obtain ⟨hint, hhgt, hcnt, huw, htw, hpw, hpm, hre, htree⟩ := hs'
  have hlen' : (ws.map (·.toNat)).length ≤ 9 ^ h := by simpa using hlen
  generalize hN : (ws.map (·.toNat)).sum = N at *
  have hn : (BitVec.ofNat 64 N).toNat = N := by
    simp; omega
  have huw0 : s.unremoved_weight ≠ 0#64 := by
    rw [huw]; intro h0; have := congrArg BitVec.toNat h0; simp at this; omega
  have hn' : s.unremoved_weight + s.poisoned_weight = BitVec.ofNat 64 N := by
    rw [huw, hpw]; simp
  have hzone := fd_zone_eq rngF hF.2.2.1 (BitVec.ofNat 64 N)
  have h1 :=
    fd_roll_loop (key := key) (BitVec.ofNat 64 N)
      (fd_chacha_rng_ulong_roll.zone rngF (BitVec.ofNat 64 N)) fuel rngF P hF hb
  have h2 :=
    agave_sample_loop (k := uintsOfBytes (k := 8) key)
      (UniformU64Sampler.new_like_instance_sample (BitVec.ofNat 64 N)) fuel rngA P hA
  rw [← hzone] at h2
  simp only [UniformU64Sampler.new_like_instance_sample] at h2 ⊢
  unfold fd_wsample_sample.spec WeightedU64Index.sample UniformU64Sampler.sample
  rw [ite_eq_right huw0,
    ite_eq_right
      (by
        rw [hpm]; decide),
    hn']
  unfold fd_chacha_rng_ulong_roll.spec
  generalize hr :
    rollAt (uintsOfBytes (k := 8) key) (BitVec.ofNat 64 N)
      (fd_chacha_rng_ulong_roll.zone rngF (BitVec.ofNat 64 N)) fuel P =
    res at h1 h2
  cases res with
  | outOfFuel =>
    rw [fueledRel_oof h1, fueledRel_oof h2]; trivial
  | done vp =>
    obtain ⟨v, P'⟩ := vp
    obtain ⟨⟨vF, rF⟩, hF1, hF2, hF3⟩ := fueledRel_done h1
    obtain ⟨⟨vA, rA⟩, hA1, hA2, hA3⟩ := fueledRel_done h2
    simp only at hF2 hA2 hF3 hA3
    subst hF2 hA2
    rw [hF1, hA1]
    have hvlt := rollAt_lt (by omega) hr
    rw [hn] at hvlt
    obtain ⟨hP1, hP2⟩ := rollAt_pos hr
    obtain ⟨r, hrl, hr1, hr2, hmap⟩ := map_sample_eq h _ s hs hlen' hh (by omega) vA (by omega)
    simp only [bind, pure]
    rw [ite_eq_right
        (by
          rw [huw, ge_iff_le, BitVec.le_def]; simp; omega)]
    refine ⟨hmap.trans ?_, ?_, P', hP1, hP2, hF3, hA3⟩
    · rw [partition_point_prefix _ arr (by simpa using hsz) (by simpa using harr) (by omega) vA r
          (by simpa using hrl) hr1 hr2]
    · rw [partition_point_prefix _ arr (by simpa using hsz) (by simpa using harr) (by omega) vA r
          (by simpa using hrl) hr1 hr2]
      simpa using hrl

/-- `fd_wsample_new_init`, the `new_add` loop and `new_fini`/`join` build a sampler holding all the
stakes. -/
theorem build_sampler (stakes : Array fd_vote_stake_weight_t) (mem : BitVec 64) (hmem : mem ≠ 0#64)
    (hal : fd_ulong_is_aligned.spec mem 64#64 ≠ 0#32) (h1 : 1 ≤ stakes.size)
    (h2 : stakes.size < 2147483647) (hnz : ∀ i (hi : i < stakes.size), stakes[i].stake ≠ 0#64)
    (htot : (stakeList stakes).sum < 2 ^ 64) :
    ∃ h s,
      fd_epoch_leaders_new.add_loop stakes stakes.size
            (fd_wsample_new_init.spec mem (BitVec.ofNat 64 stakes.size) 0#32
              FD_WSAMPLE_HINT_POWERLAW_NOREMOVE)
            0 =
          some (some s) ∧
        fd_wsample_join.spec mem (fd_wsample_new_fini.spec (some s) 0#64) = some s ∧
        SamplerInv h (stakeList stakes) s ∧ stakes.size ≤ 9 ^ h ∧ h < 11 := by
  obtain ⟨h, hch, hle, -, hh⟩ :=
    compute_height_eq (BitVec.ofNat 64 stakes.size)
      (by
        simp; omega)
  have hsz : (BitVec.ofNat 64 stakes.size).toNat = stakes.size := by
    simp; omega
  rw [hsz] at hle
  have hfl := first_lt hh
  have hinit :
    fd_wsample_new_init.spec mem (BitVec.ofNat 64 stakes.size) 0#32
        FD_WSAMPLE_HINT_POWERLAW_NOREMOVE =
      some
        { total_cnt := 0#64, total_weight := 0#64, unremoved_cnt := 0#64, unremoved_weight := 0#64,
          internal_node_cnt := BitVec.ofNat 64 (first h), poisoned_weight := 0#64,
          height := (BitVec.ofNat 64 h).setWidth 32, restore_enabled := 0#8, poisoned_mode := 0#8,
          tree := Array.replicate (BitVec.ofNat 64 (first h)).toNat (Vector.replicate 8 0#64),
          tree_copy := #[] } := by
    unfold fd_wsample_new_init.spec
    rw [ite_eq_right hmem, ite_eq_right hal, hch]
    rfl
  have hs0 :
    SamplerInv h ((stakeList stakes).take 0)
      { total_cnt := 0#64, total_weight := 0#64, unremoved_cnt := 0#64, unremoved_weight := 0#64,
        internal_node_cnt := BitVec.ofNat 64 (first h), poisoned_weight := 0#64,
        height := (BitVec.ofNat 64 h).setWidth 32, restore_enabled := 0#8, poisoned_mode := 0#8,
        tree := Array.replicate (BitVec.ofNat 64 (first h)).toNat (Vector.replicate 8 0#64),
        tree_copy := #[] } := by
    refine ⟨rfl, ?_, rfl, rfl, rfl, rfl, rfl, rfl, ?_⟩
    · simp; omega
    · have : (BitVec.ofNat 64 (first h)).toNat = first h := by
        simp; omega
      simp only [List.take_zero, this]
      exact TreeInv_init h
  obtain ⟨s, hloop, hs⟩ := add_loop_inv stakes h hle hh hnz htot _ 0 _ rfl (by omega) hs0
  have hpw := hs.2.2.2.2.2.1
  have hre := hs.2.2.2.2.2.2.2.1
  have htw := hs.2.2.2.2.1
  refine ⟨h, s, by rw [hinit, hloop], ?_, hs, hle, hh⟩
  unfold fd_wsample_new_fini.spec fd_wsample_join.spec
  rw [ite_eq_right hmem, ite_eq_right hal]
  dsimp only
  rw [ite_eq_right
      (by
        rw [htw]; simp)]
  cases s; simp only at hpw hre ⊢; subst hpw hre
  rw [ite_eq_right (by decide)]

end

end Firedancer.Leaders.Math
