module

public import Firedancer.Ref.fd_f25519_update_fg_62_var
public import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Zify

/-! `fd_f25519_update_fg_62_var` on 62-bit limbs: with a nonnegative matrix whose rows sum to at
most `2^62`, the new limbs are exactly `(u F + v G) / 2^62` and `(q F + r G) / 2^62`. -/

namespace MLIR.Firedancer.Ref

namespace fd_f25519_update_fg_62_var

/-! ## Limbs -/

@[expose] public section

/-- Limb `k` of `v` as a natural, `0` past the end. -/
def limb (v : Vector (BitVec 64) 5) (k : ℕ) : ℕ :=
  (v[k]?.getD 0).toNat

/-- `v`'s value, 62 bits per limb. -/
def val (v : Vector (BitVec 64) 5) : ℕ :=
  ∑ k ∈ Finset.range 5, limb v k * 2 ^ (62 * k)

/-- Limbs below `2^62`, zero from `L` on. -/
def Limbs62 (v : Vector (BitVec 64) 5) (L : ℕ) : Prop :=
  (∀ k, limb v k < 2 ^ 62) ∧ ∀ k, L ≤ k → limb v k = 0

end

/-- Past the end a limb is `0`. -/
public theorem limb_of_ge {v : Vector (BitVec 64) 5} {k : ℕ} (h : 5 ≤ k) : limb v k = 0 := by
  simp [limb, Vector.getElem?_eq_none (by omega : 5 ≤ k)]

/-- The value from the limbs below `L`. -/
public theorem val_eq_sum {v : Vector (BitVec 64) 5} {L : ℕ} (hL : L ≤ 5)
    (h : ∀ k, L ≤ k → limb v k = 0) : val v = ∑ k ∈ Finset.range L, limb v k * 2 ^ (62 * k) := by
  unfold val
  rw [← Finset.sum_range_add_sum_Ico _ hL]
  rw [Finset.sum_eq_zero (s := Finset.Ico L 5) fun k hk => by
      rw [h k (Finset.mem_Ico.1 hk).1, zero_mul],
    add_zero]

/-- A `setIfInBounds` limb. -/
theorem limb_set (v : Vector (BitVec 64) 5) (i k : ℕ) (x : BitVec 64) :
    limb (v.setIfInBounds i x) k = if i = k ∧ k < 5 then x.toNat else limb v k := by
  unfold limb
  by_cases hk : k < 5
  · rw [Vector.getElem?_eq_getElem hk, Vector.getElem?_eq_getElem hk, Option.getD_some,
      Option.getD_some, Vector.getElem_setIfInBounds hk]
    by_cases hi : i = k <;> simp [hi, hk]
  · rw [Vector.getElem?_eq_none (by omega), Vector.getElem?_eq_none (by omega)]
    simp [hk]

/-! ## Arithmetic -/

/-- A nonnegative `long`'s sign extension. -/
theorem toNat_signExtend_of_lt {x : BitVec 64} (h : x.toNat < 2 ^ 63) :
    (x.signExtend 128).toNat = x.toNat := by
  rw [BitVec.signExtend_eq_setWidth_of_msb_false (BitVec.msb_eq_false_iff_two_mul_lt.2 (by omega)),
    BitVec.toNat_setWidth, Nat.mod_eq_of_lt (by omega)]

/-- An arithmetic shift of a nonnegative `int128`. -/
theorem toNat_sshiftRight_of_lt {x : BitVec 128} (h : x.toNat < 2 ^ 127) (n : ℕ) :
    (x.sshiftRight n).toNat = x.toNat / 2 ^ n := by
  rw [BitVec.sshiftRight_eq_of_msb_false (BitVec.msb_eq_false_iff_two_mul_lt.2 (by omega)),
    BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]

/-- `c + u x + v y` with `c ≤ 2^62`, `u + v ≤ 2^62` and limbs `< 2^62`, in `int128`. -/
theorem carry_toNat {c : BitVec 128} {u v x y : BitVec 64} (hc : c.toNat ≤ 2 ^ 62)
    (huv : u.toNat + v.toNat ≤ 2 ^ 62) (hx : x.toNat < 2 ^ 62) (hy : y.toNat < 2 ^ 62) :
    (c + (u.signExtend 128 * x.signExtend 128 + v.signExtend 128 * y.signExtend 128)).toNat =
        c.toNat + (u.toNat * x.toNat + v.toNat * y.toNat) ∧
      c.toNat + (u.toNat * x.toNat + v.toNat * y.toNat) ≤ 2 ^ 62 + 2 ^ 62 * (2 ^ 62 - 1) := by
  have hb : u.toNat * x.toNat + v.toNat * y.toNat ≤ 2 ^ 62 * (2 ^ 62 - 1) := by
    calc
      u.toNat * x.toNat + v.toNat * y.toNat ≤ u.toNat * (2 ^ 62 - 1) + v.toNat * (2 ^ 62 - 1) :=
        Nat.add_le_add (Nat.mul_le_mul_left _ (by omega)) (Nat.mul_le_mul_left _ (by omega))
      _ = (u.toNat + v.toNat) * (2 ^ 62 - 1) := by ring
      _ ≤ 2 ^ 62 * (2 ^ 62 - 1) := Nat.mul_le_mul_right _ huv
  have hux : u.toNat * x.toNat ≤ 2 ^ 62 * (2 ^ 62 - 1) := by omega
  have hvy : v.toNat * y.toNat ≤ 2 ^ 62 * (2 ^ 62 - 1) := by omega
  refine ⟨?_, by omega⟩
  rw [BitVec.toNat_add, BitVec.toNat_add, BitVec.toNat_mul, BitVec.toNat_mul,
    toNat_signExtend_of_lt (by omega), toNat_signExtend_of_lt (by omega),
    toNat_signExtend_of_lt (by omega), toNat_signExtend_of_lt (by omega)]
  have h128 : 2 ^ 62 + 2 ^ 62 * (2 ^ 62 - 1) < 2 ^ 128 := by decide
  rw [Nat.mod_eq_of_lt (a := u.toNat * x.toNat) (by omega),
    Nat.mod_eq_of_lt (a := v.toNat * y.toNat) (by omega), Nat.mod_eq_of_lt (by omega),
    Nat.mod_eq_of_lt (by omega)]

/-- One carry step of the chain: `c + P = m + 2^62 d` adds limb `m` and carries `d`. -/
theorem chain_step {S A c P m d r : ℕ} (j : ℕ) (hS : S = 2 ^ 62 * (A + c * 2 ^ (62 * j)) + r)
    (hT : m + 2 ^ 62 * d = c + P) :
    S + P * 2 ^ (62 * (j + 1)) = 2 ^ 62 * (A + m * 2 ^ (62 * j) + d * 2 ^ (62 * (j + 1))) + r := by
  subst hS
  rw [show 62 * (j + 1) = 62 + 62 * j by ring, pow_add]
  zify at hT ⊢
  linear_combination (-(2 ^ 62 * 2 ^ (62 * j)) : ℤ) * hT

/-- The masked low limb `cf & M62`. -/
theorem toNat_low (c : BitVec 128) : (c.setWidth 64 &&& M62).toNat = c.toNat % 2 ^ 62 := by
  have hM : M62.toNat = 2 ^ 62 - 1 := by decide
  rw [BitVec.toNat_and, hM, Nat.and_two_pow_sub_one_eq_mod, BitVec.toNat_setWidth,
    Nat.mod_mod_of_dvd _ (by decide)]

/-! ## The carry loop -/

/-- The carry loop after limb `j`: limbs from `j` on still the inputs', limbs below `j` written
and below `2^62`, carries at most `2^62`, and the chains `Σ_{k≤j} (u fₖ + v gₖ) 2^(62k)` split into
the written limbs, the carry at `2^(62j)`, and the dropped low bits `rf`, `rg`. -/
structure FoldInv (t : Vector (BitVec 64) 4) (f g : Vector (BitVec 64) 5) (rf rg j : ℕ)
    (s : State) : Prop where
  hf : ∀ k, j ≤ k → limb s.f k = limb f k
  hg : ∀ k, j ≤ k → limb s.g k = limb g k
  lf : ∀ k < j, limb s.f k < 2 ^ 62
  lg : ∀ k < j, limb s.g k < 2 ^ 62
  cf : s.cf.toNat ≤ 2 ^ 62
  cg : s.cg.toNat ≤ 2 ^ 62
  sf :
    ∑ k ∈ Finset.range (j + 1), (t[0].toNat * limb f k + t[1].toNat * limb g k) * 2 ^ (62 * k) =
      2 ^ 62 * (∑ k ∈ Finset.range j, limb s.f k * 2 ^ (62 * k) + s.cf.toNat * 2 ^ (62 * j)) + rf
  sg :
    ∑ k ∈ Finset.range (j + 1), (t[2].toNat * limb f k + t[3].toNat * limb g k) * 2 ^ (62 * k) =
      2 ^ 62 * (∑ k ∈ Finset.range j, limb s.g k * 2 ^ (62 * k) + s.cg.toNat * 2 ^ (62 * j)) + rg

/-- A written limb's sum: the old limbs below `j`, the new one at `j`. -/
theorem sum_set (v : Vector (BitVec 64) 5) (j : ℕ) (hj : j < 5) (x : BitVec 64) :
    ∑ k ∈ Finset.range (j + 1), limb (v.setIfInBounds j x) k * 2 ^ (62 * k) =
      ∑ k ∈ Finset.range j, limb v k * 2 ^ (62 * k) + x.toNat * 2 ^ (62 * j) := by
  rw [Finset.sum_range_succ, limb_set, ite_eq_left ⟨rfl, hj⟩]
  congr 1
  refine Finset.sum_congr rfl fun k hk => ?_
  rw [limb_set,
    ite_eq_right fun h => by
      have := Finset.mem_range.1 hk; omega]

/-- One iteration `i = j + 1 < 5` keeps the invariant. -/
theorem body_inv {t : Vector (BitVec 64) 4} {f g : Vector (BitVec 64) 5} {rf rg j : ℕ} {s : State}
    (P : FoldInv t f g rf rg j s) (hj : j + 1 < 5) (hlf : ∀ k, limb f k < 2 ^ 62)
    (hlg : ∀ k, limb g k < 2 ^ 62) (huv : t[0].toNat + t[1].toNat ≤ 2 ^ 62)
    (hqr : t[2].toNat + t[3].toNat ≤ 2 ^ 62) : FoldInv t f g rf rg (j + 1) (body t s (j + 1)) := by
  have ex : (s.f[j + 1]?.getD 0).toNat = limb f (j + 1) := P.hf (j + 1) (by omega)
  have ey : (s.g[j + 1]?.getD 0).toNat = limb g (j + 1) := P.hg (j + 1) (by omega)
  obtain ⟨cfv, cfb⟩ :=
    carry_toNat (c := s.cf) (u := t[0]) (v := t[1]) (x := s.f[j + 1]?.getD 0) (y :=
      s.g[j + 1]?.getD 0) P.cf huv (ex ▸ hlf _) (ey ▸ hlg _)
  obtain ⟨cgv, cgb⟩ :=
    carry_toNat (c := s.cg) (u := t[2]) (v := t[3]) (x := s.f[j + 1]?.getD 0) (y :=
      s.g[j + 1]?.getD 0) P.cg hqr (ex ▸ hlf _) (ey ▸ hlg _)
  rw [ex, ey] at cfv cfb cgv cgb
  unfold body
  dsimp only
  generalize s.cf + _ = cf' at cfv
  generalize s.cg + _ = cg' at cgv
  have hdiv (T : ℕ) (hT : T ≤ 2 ^ 62 + 2 ^ 62 * (2 ^ 62 - 1)) : T / 2 ^ 62 ≤ 2 ^ 62 :=
    Nat.div_le_of_le_mul (by omega)
  have h127 : 2 ^ 62 + 2 ^ 62 * (2 ^ 62 - 1) < 2 ^ 127 := by decide
  refine ⟨fun k hk => ?_, fun k hk => ?_, fun k hk => ?_, fun k hk => ?_, ?_, ?_, ?_, ?_⟩
  · rw [show j + 1 - 1 = j from rfl, limb_set, ite_eq_right (by omega)]; exact P.hf k (by omega)
  · rw [show j + 1 - 1 = j from rfl, limb_set, ite_eq_right (by omega)]; exact P.hg k (by omega)
  · rw [show j + 1 - 1 = j from rfl, limb_set]
    split_ifs with h
    · rw [toNat_low]; exact Nat.mod_lt _ (by decide)
    · exact P.lf k (by omega)
  · rw [show j + 1 - 1 = j from rfl, limb_set]
    split_ifs with h
    · rw [toNat_low]; exact Nat.mod_lt _ (by decide)
    · exact P.lg k (by omega)
  · rw [toNat_sshiftRight_of_lt (by omega), cfv]; exact hdiv _ cfb
  · rw [toNat_sshiftRight_of_lt (by omega), cgv]; exact hdiv _ cgb
  · rw [show j + 1 - 1 = j from rfl, Finset.sum_range_succ, sum_set _ _ (by omega), toNat_low,
      toNat_sshiftRight_of_lt (by omega), cfv]
    exact chain_step j P.sf (Nat.mod_add_div _ _)
  · rw [show j + 1 - 1 = j from rfl, Finset.sum_range_succ, sum_set _ _ (by omega), toNat_low,
      toNat_sshiftRight_of_lt (by omega), cgv]
    exact chain_step j P.sg (Nat.mod_add_div _ _)

/-- The loop over `i = 1 .. m`. -/
theorem fold_inv {t : Vector (BitVec 64) 4} {f g : Vector (BitVec 64) 5} {rf rg : ℕ} {s₀ : State}
    (P₀ : FoldInv t f g rf rg 0 s₀) (hlf : ∀ k, limb f k < 2 ^ 62) (hlg : ∀ k, limb g k < 2 ^ 62)
    (huv : t[0].toNat + t[1].toNat ≤ 2 ^ 62) (hqr : t[2].toNat + t[3].toNat ≤ 2 ^ 62) :
    ∀ m, m < 5 → FoldInv t f g rf rg m ((List.range' 1 m).foldl (body t) s₀)
  | 0, _ => P₀
  | m + 1, hm => by
    rw [List.range'_concat, List.foldl_append, List.foldl_cons, List.foldl_nil,
      show 1 + 1 * m = m + 1 by omega]
    exact body_inv (fold_inv P₀ hlf hlg huv hqr m (by omega)) hm hlf hlg huv hqr

/-- Limbs below `2^62`, zero from `L`, give a value below `2^(62 L)` and the low 64 bits. -/
public theorem val_lt {v : Vector (BitVec 64) 5} {L : ℕ} (hL : L ≤ 5) (h : Limbs62 v L) :
    val v < 2 ^ (62 * L) := by
  rw [val_eq_sum hL h.2]
  have key : ∀ L, ∑ k ∈ Finset.range L, limb v k * 2 ^ (62 * k) < 2 ^ (62 * L) := by
    intro L
    induction L with
    | zero => simp
    | succ L ih =>
      rw [Finset.sum_range_succ, show 62 * (L + 1) = 62 * L + 62 by ring, pow_add]
      have := h.1 L
      calc
        _ < 2 ^ (62 * L) + limb v L * 2 ^ (62 * L) := by omega
        _ = (limb v L + 1) * 2 ^ (62 * L) := by ring
        _ ≤ 2 ^ 62 * 2 ^ (62 * L) := Nat.mul_le_mul_right _ (by omega)
        _ = _ := by ring
  exact key L

end fd_f25519_update_fg_62_var

open fd_f25519_update_fg_62_var in
/-- `update_fg` on limbs below `2^62` (zero from `len`), with `t`'s rows nonnegative of sum at
most `2^62` taking `(F, G)` to `2^62 (F₁, G₁)`, `F₁, G₁ < 2^(62 len)`: the limbs of `F₁`, `G₁`. -/
public theorem fd_f25519_update_fg_62_var.spec_val {len : BitVec 32} {L : ℕ} (hL : len.toNat = L)
    (h1 : 1 ≤ L) (h5 : L ≤ 5) {f g : Vector (BitVec 64) 5} {t : Vector (BitVec 64) 4}
    (hf : Limbs62 f L) (hg : Limbs62 g L) {F₁ G₁ : ℕ}
    (e1 : t[0].toNat * val f + t[1].toNat * val g = 2 ^ 62 * F₁)
    (e2 : t[2].toNat * val f + t[3].toNat * val g = 2 ^ 62 * G₁)
    (b1 : t[0].toNat + t[1].toNat ≤ 2 ^ 62) (b2 : t[2].toNat + t[3].toNat ≤ 2 ^ 62)
    (hF₁ : F₁ < 2 ^ (62 * L)) (hG₁ : G₁ < 2 ^ (62 * L)) :
    let R := fd_f25519_update_fg_62_var.spec len f g t
    (Limbs62 R.1 L ∧ val R.1 = F₁) ∧ (Limbs62 R.2 L ∧ val R.2 = G₁) := by
  obtain ⟨j, rfl⟩ : ∃ j, L = j + 1 := ⟨L - 1, by omega⟩
  have hlen : (len.toInt - 1).toNat = j := by
    rw [BitVec.toInt_eq_toNat_of_lt (by omega), hL]; omega
  have e0f : (f[0]?.getD 0).toNat = f[0].toNat := by simp
  have e0g : (g[0]?.getD 0).toNat = g[0].toNat := by simp
  -- the first limb
  obtain ⟨cfv, cfb⟩ :=
    carry_toNat (c := 0#128) (u := t[0]) (v := t[1]) (x := f[0]) (y := g[0]) (by simp) b1
      (by
        have := hf.1 0; simpa [limb] using this)
      (by
        have := hg.1 0; simpa [limb] using this)
  obtain ⟨cgv, cgb⟩ :=
    carry_toNat (c := 0#128) (u := t[2]) (v := t[3]) (x := f[0]) (y := g[0]) (by simp) b2
      (by
        have := hf.1 0; simpa [limb] using this)
      (by
        have := hg.1 0; simpa [limb] using this)
  simp only [BitVec.zero_add, BitVec.toNat_ofNat, Nat.zero_mod, zero_add] at cfv cfb cgv cgb
  set Tf := t[0].toNat * f[0].toNat + t[1].toNat * g[0].toNat
  set Tg := t[2].toNat * f[0].toNat + t[3].toNat * g[0].toNat
  have h127 : 2 ^ 62 + 2 ^ 62 * (2 ^ 62 - 1) < 2 ^ 127 := by decide
  have P₀ :
    FoldInv t f g (Tf % 2 ^ 62) (Tg % 2 ^ 62) 0
      ⟨(t[0].signExtend 128 * f[0].signExtend 128 +
              t[1].signExtend 128 * g[0].signExtend 128).sshiftRight
          62,
        (t[2].signExtend 128 * f[0].signExtend 128 +
              t[3].signExtend 128 * g[0].signExtend 128).sshiftRight
          62,
        f, g⟩ := by
    refine
      ⟨fun _ _ => rfl, fun _ _ => rfl, fun _ h => absurd h (by omega), fun _ h =>
        absurd h (by omega), ?_, ?_, ?_, ?_⟩
    · dsimp only; rw [toNat_sshiftRight_of_lt (by omega), cfv]
      exact Nat.div_le_of_le_mul (by omega)
    · dsimp only; rw [toNat_sshiftRight_of_lt (by omega), cgv]
      exact Nat.div_le_of_le_mul (by omega)
    · dsimp only
      rw [toNat_sshiftRight_of_lt (by omega), cfv]
      simp only [zero_add, Finset.sum_range_one, Finset.range_zero, Finset.sum_empty, mul_zero,
        pow_zero, mul_one, limb, e0f, e0g]
      have := Nat.mod_add_div Tf (2 ^ 62)
      omega
    · dsimp only
      rw [toNat_sshiftRight_of_lt (by omega), cgv]
      simp only [zero_add, Finset.sum_range_one, Finset.range_zero, Finset.sum_empty, mul_zero,
        pow_zero, mul_one, limb, e0f, e0g]
      have := Nat.mod_add_div Tg (2 ^ 62)
      omega
  have P := fold_inv P₀ hf.1 hg.1 b1 b2 j (by omega)
  unfold fd_f25519_update_fg_62_var.spec
  dsimp only
  rw [hlen]
  generalize List.foldl (body t) _ (List.range' 1 j) = st at P
  -- the chains' totals
  have hsum (a b : BitVec 64) :
    ∑ k ∈ Finset.range (j + 1), (a.toNat * limb f k + b.toNat * limb g k) * 2 ^ (62 * k) =
      a.toNat * val f + b.toNat * val g := by
    rw [val_eq_sum h5 hf.2, val_eq_sum h5 hg.2, Finset.mul_sum, Finset.mul_sum, ←
      Finset.sum_add_distrib]
    exact Finset.sum_congr rfl fun k _ => by ring
  have fin (F : ℕ) (A c r : ℕ) (hr : r < 2 ^ 62) (h : 2 ^ 62 * F = 2 ^ 62 * (A + c) + r) :
    F = A + c := by omega
  have hsF := P.sf
  have sG := P.sg
  rw [hsum, e1] at hsF
  rw [hsum, e2] at sG
  have vF := fin _ _ _ _ (Nat.mod_lt _ (by decide)) hsF
  have vG := fin _ _ _ _ (Nat.mod_lt _ (by decide)) sG
  have tw : (st.cf.setWidth 64).toNat = st.cf.toNat := by
    rw [BitVec.toNat_setWidth,
      Nat.mod_eq_of_lt
        (by
          have := P.cf; omega)]
  have tw' : (st.cg.setWidth 64).toNat = st.cg.toNat := by
    rw [BitVec.toNat_setWidth,
      Nat.mod_eq_of_lt
        (by
          have := P.cg; omega)]
  have hp : 2 ^ (62 * (j + 1)) = 2 ^ 62 * 2 ^ (62 * j) := by
    rw [show 62 * (j + 1) = 62 + 62 * j by ring, pow_add]
  have cF : st.cf.toNat < 2 ^ 62 := by
    have : st.cf.toNat * 2 ^ (62 * j) < 2 ^ 62 * 2 ^ (62 * j) := by
      rw [← hp]; omega
    exact Nat.lt_of_mul_lt_mul_right this
  have cG : st.cg.toNat < 2 ^ 62 := by
    have : st.cg.toNat * 2 ^ (62 * j) < 2 ^ 62 * 2 ^ (62 * j) := by
      rw [← hp]; omega
    exact Nat.lt_of_mul_lt_mul_right this
  have lim (v w : Vector (BitVec 64) 5) (x : BitVec 64) (hx : x.toNat < 2 ^ 62)
    (hv : ∀ k < j, limb v k < 2 ^ 62) (hw : ∀ k, j ≤ k → limb v k = limb w k)
    (hw0 : ∀ k, j + 1 ≤ k → limb w k = 0) : Limbs62 (v.setIfInBounds j x) (j + 1) := by
    refine ⟨fun k => ?_, fun k hk => ?_⟩
    · rw [limb_set]
      split_ifs with h
      · exact hx
      · rcases Nat.lt_or_ge k j with hk | hk
        · exact hv k hk
        · rcases Nat.lt_or_ge k 5 with h5' | h5'
          · rw [hw k hk, hw0 k (by omega)]; exact Nat.two_pow_pos _
          · rw [limb_of_ge h5']; exact Nat.two_pow_pos _
    · rw [limb_set, ite_eq_right (by omega), hw k (by omega), hw0 k hk]
  have L1 := lim st.f f _ (tw ▸ cF) P.lf P.hf hf.2
  have L2 := lim st.g g _ (tw' ▸ cG) P.lg P.hg hg.2
  refine ⟨⟨L1, ?_⟩, ⟨L2, ?_⟩⟩
  · rw [val_eq_sum h5 L1.2, sum_set _ _ (by omega), tw, vF]
  · rw [val_eq_sum h5 L2.2, sum_set _ _ (by omega), tw', vG]

end MLIR.Firedancer.Ref
