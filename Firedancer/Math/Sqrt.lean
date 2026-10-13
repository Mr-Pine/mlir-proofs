module

public import Firedancer.Math.Field
public import Mathlib.Algebra.Field.ZMod
public import Firedancer.Ref.fd_f25519_sqrt_ratio
import Mathlib.FieldTheory.Finite.Basic
import Mathlib.NumberTheory.LegendreSymbol.Basic
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.ReduceModChar

/-! The Ref square roots in `ZMod p`: `if`, `abs`, and `sqrt_ratio`'s root of `u / v`. -/

namespace MLIR.Firedancer.Ref

open _root_.Ed25519

/-! ## Flags -/

section Flags

public theorem ite_or_ite {a b : Prop} [Decidable a] [Decidable b] :
    ((if a then 1#32 else 0#32) ||| if b then 1#32 else 0#32) = if a ∨ b then 1#32 else 0#32 := by
  by_cases a <;> by_cases b <;> simp [*]

public theorem ite_and_ite {a b : Prop} [Decidable a] [Decidable b] :
    ((if a then 1#32 else 0#32) &&& if b then 1#32 else 0#32) = if a ∧ b then 1#32 else 0#32 := by
  by_cases a <;> by_cases b <;> simp [*]

/-- `if` on a `0`/`1` flag. -/
public theorem fd_f25519_if.spec_ite {c : Prop} [Decidable c] (a0 a1 : Fin 5 → BitVec 64) :
    fd_f25519_if.spec (if c then 1#32 else 0#32) a0 a1 = if c then a0 else a1 := by
  funext i
  by_cases hc : c <;> fin_cases i <;>
    simp [hc, fd_f25519_if.spec, fiat_25519_selectznz.spec, fiat_25519_cmovznz_u64.spec]

/-- `if` picks one of its inputs, whatever the flag. -/
theorem fd_f25519_if.spec_or (c : BitVec 32) (a0 a1 : Fin 5 → BitVec 64) :
    fd_f25519_if.spec c a0 a1 = a0 ∨ fd_f25519_if.spec c a0 a1 = a1 := by
  by_cases h : c.setWidth 8 = 0#8
  · right
    funext i
    fin_cases i <;>
      simp [h, fd_f25519_if.spec, fiat_25519_selectznz.spec, fiat_25519_cmovznz_u64.spec]
  · left
    funext i
    fin_cases i <;>
      simp [h, fd_f25519_if.spec, fiat_25519_selectznz.spec, fiat_25519_cmovznz_u64.spec]

end Flags

/-! ## Square roots -/

section Sqrt

/-- `fd_f25519_sqrtm1` is `√-1`, tight. -/
public theorem fd_f25519_sqrtm1.val :
    Limbs.val fd_f25519_sqrtm1.limbs = sqrtM1 ∧ Limbs.Tight fd_f25519_sqrtm1.limbs := by
  refine ⟨?_, by rw [Limbs.tight_iff]; decide⟩
  rw [Limbs.val_eq]
  unfold sqrtM1
  simp [fd_f25519_sqrtm1.limbs]
  reduce_mod_char

/-- `abs` on a tight value: `±a`, even, within `2p`'s limbs and below `2p`, of a positive number
if `a`'s is. -/
public theorem fd_f25519_abs.spec_val {a : Fin 5 → BitVec 64} (ha : Limbs.Tight a) :
    (Limbs.val (fd_f25519_abs.spec a) = Limbs.val a ∨
        Limbs.val (fd_f25519_abs.spec a) = -Limbs.val a) ∧
      (Limbs.val (fd_f25519_abs.spec a)).val % 2 = 0 ∧ Limbs.Under2p (fd_f25519_abs.spec a) ∧
        Limbs.nat (fd_f25519_abs.spec a) < 2 * p ∧
          (0 < Limbs.nat a → 0 < Limbs.nat (fd_f25519_abs.spec a)) := by
  obtain ⟨vn, bn, nn⟩ := fd_f25519_neg.spec_wide ha.under2p
  have hs := fd_f25519_sgn.spec_val ha.under2p ha.nat_lt
  rcases Nat.mod_two_eq_zero_or_one (Limbs.val a).val with h | h
  · have : fd_f25519_abs.spec a = a := by
      simp only [fd_f25519_abs.spec, hs, h]
      exact fd_f25519_if.spec_ite (c := False) _ _
    rw [this]
    exact ⟨.inl rfl, h, ha.under2p, ha.nat_lt, id⟩
  · have : fd_f25519_abs.spec a = fd_f25519_neg.spec a := by
      simp only [fd_f25519_abs.spec, hs, h]
      exact fd_f25519_if.spec_ite (c := True) _ _
    rw [this, vn]
    have h0 : Limbs.val a ≠ 0 := by rintro h0; simp [h0] at h
    have hpos : 0 < Limbs.nat a := Nat.pos_of_ne_zero fun h' => h0 (by rw [Limbs.val_nat, h']; simp)
    have := ha.nat_lt
    refine ⟨.inr rfl, ?_, bn, by omega, fun _ => by omega⟩
    rw [ZMod.neg_val, ite_eq_right h0]
    have := ZMod.val_lt (Limbs.val a)
    have hp : p % 2 = 1 := by norm_num
    omega

/-- `(u / v)` is a square exactly when `u v⁷` is. -/
public theorem isSquare_div_iff {u v : ZMod p} (hv : v ≠ 0) :
    IsSquare (u / v) ↔ IsSquare (u * v ^ 7) := by
  have h4 : v ^ 4 ≠ 0 := pow_ne_zero _ hv
  constructor
  · rintro ⟨r, hr⟩
    refine ⟨r * v ^ 4, ?_⟩
    rw [div_eq_iff hv] at hr
    rw [hr]
    ring
  · rintro ⟨s, hs⟩
    refine ⟨s / v ^ 4, ?_⟩
    rw [div_mul_div_comm, eq_div_iff (mul_ne_zero h4 h4), div_mul_eq_mul_div, div_eq_iff hv, ← hs]
    ring

/-- `sqrt_ratio`'s algebra: `β = u v³ (u v⁷)^((p-5)/8)` has `v β² = u c` with `c² = 1` exactly when
`u / v` is a square; the flags then pick `β` or `β √-1` as a root. -/
theorem sqrt_ratio_alg {u v β : ZMod p} (hv : v ≠ 0)
    (hβ : β = u * v ^ 3 * (u * v ^ 7) ^ ((p - 5) / 8)) :
    let fc := β ^ 2 * v = u
    let ff := β ^ 2 * v = -u
    let fi := β ^ 2 * v = -u * sqrtM1
    let r := if fi ∨ ff then β * sqrtM1 else β
    (IsSquare (u / v) → (ff ∨ fc) ∧ v * r ^ 2 = u) ∧ (¬IsSquare (u / v) → ¬(ff ∨ fc)) := by
  intro fc ff fi r
  by_cases hu : u = 0
  · subst hu
    have hβ0 : β = 0 := by simp [hβ]
    have hff : ff := by simp [ff, hβ0]
    refine ⟨fun _ => ⟨.inl hff, ?_⟩, fun h => absurd ⟨0, by simp⟩ h⟩
    simp only [r, ite_eq_left (Or.inr hff), hβ0]
    ring
  have hw : u * v ^ 7 ≠ 0 := mul_ne_zero hu (pow_ne_zero _ hv)
  set c := (u * v ^ 7) ^ ((p - 1) / 4) with hc
  have hcheck : β ^ 2 * v = u * c := by
    rw [hc, show (p - 1) / 4 = 2 * ((p - 5) / 8) + 1 by norm_num, pow_succ (u * v ^ 7),
      pow_mul (u * v ^ 7), hβ]
    ring
  have hc2 : c ^ 2 = (u * v ^ 7) ^ (p / 2) := by
    rw [hc, ← pow_mul]
    norm_num
  have hFermat : ((u * v ^ 7) ^ (p / 2)) ^ 2 = 1 := by
    rw [← pow_mul, show p / 2 * 2 = p - 1 by norm_num]
    exact ZMod.pow_card_sub_one_eq_one hw
  have hsq := (isSquare_div_iff (u := u) hv).trans (ZMod.euler_criterion p hw)
  have hne : (1 : ZMod p) ≠ -1 := by decide
  constructor
  · intro h
    have h1 : c ^ 2 = 1 := hc2.trans (hsq.1 h)
    rcases sq_eq_one_iff'.1 h1 with h1 | h1
    · -- `v β² = u`: no flip
      have hfc : fc := by simp [fc, hcheck, h1]
      have hfi : ¬fi := by
        intro hfi
        have : u * (1 + sqrtM1) = 0 := by linear_combination hfc.symm.trans hfi
        rcases mul_eq_zero.1 this with h | h
        · exact hu h
        · have := sqrtM1_sq
          rw [show sqrtM1 = -1 by linear_combination h] at this
          exact hne (by linear_combination this)
      have hff : ¬ff := by
        intro hff
        have : 2 * u = 0 := by linear_combination hfc.symm.trans hff
        exact hu ((mul_eq_zero.1 this).resolve_left (by decide))
      refine ⟨.inr hfc, ?_⟩
      simp only [r, ite_eq_right (not_or.2 ⟨hfi, hff⟩)]
      linear_combination hfc
    · -- `v β² = -u`: times `√-1`
      have hff : ff := by simp [ff, hcheck, h1]
      refine ⟨.inl hff, ?_⟩
      simp only [r, ite_eq_left (Or.inr hff)]
      linear_combination sqrtM1 ^ 2 * hff - u * sqrtM1_sq
  · intro h hf
    have hm : (u * v ^ 7) ^ (p / 2) = -1 := by
      have : ((u * v ^ 7) ^ (p / 2) - 1) * ((u * v ^ 7) ^ (p / 2) + 1) = 0 := by
        linear_combination hFermat
      rcases mul_eq_zero.1 this with h' | h'
      · exact absurd (hsq.2 (by linear_combination h')) h
      · linear_combination h'
    have hc' : c ^ 2 = -1 := hc2.trans hm
    rcases hf with hf | hf
    · have : u * (c + 1) = 0 := by linear_combination hcheck.symm.trans hf
      have hc1 : c = -1 := by linear_combination (mul_eq_zero.1 this).resolve_left hu
      rw [hc1] at hc'
      exact hne (by linear_combination hc')
    · have : u * (c - 1) = 0 := by linear_combination hcheck.symm.trans hf
      have hc1 : c = 1 := by linear_combination (mul_eq_zero.1 this).resolve_left hu
      rw [hc1] at hc'
      exact hne (by linear_combination hc')

/-- `sqrt_ratio` on tight `u` and `v ≠ 0`: when `u / v` is a square, the flag is `1` and `r` a root
of it, `v r² = u`; else the flag is `0`. `r` is even either way, within `2p`'s limbs and below
`2p`. -/
public theorem fd_f25519_sqrt_ratio.spec_val {u v : Fin 5 → BitVec 64} (hu : Limbs.Tight u)
    (hv : Limbs.Tight v) (hv0 : Limbs.val v ≠ 0) :
    let R := fd_f25519_sqrt_ratio.spec u v
    (IsSquare (Limbs.val u / Limbs.val v) →
        R.ret = 1#32 ∧ Limbs.val v * Limbs.val R.r ^ 2 = Limbs.val u) ∧
      (¬IsSquare (Limbs.val u / Limbs.val v) → R.ret = 0#32) ∧
      (Limbs.val R.r).val % 2 = 0 ∧ Limbs.Under2p R.r ∧ Limbs.nat R.r < 2 * p := by
  obtain ⟨v2v, v2b⟩ := fd_f25519_sqr.spec_val hv.loose
  obtain ⟨v3v, v3b⟩ := fd_f25519_mul.spec_val v2b.loose hv.loose
  obtain ⟨uv3v, uv3b⟩ := fd_f25519_mul.spec_val hu.loose v3b.loose
  obtain ⟨v6v, v6b⟩ := fd_f25519_sqr.spec_val v3b.loose
  obtain ⟨v7v, v7b⟩ := fd_f25519_mul.spec_val v6b.loose hv.loose
  obtain ⟨uv7v, uv7b⟩ := fd_f25519_mul.spec_val hu.loose v7b.loose
  obtain ⟨pv, pb⟩ := fd_f25519_pow22523.spec_val uv7b.loose
  obtain ⟨rv, rb⟩ := fd_f25519_mul.spec_val pb.loose uv3b.loose
  obtain ⟨c1v, c1b⟩ := fd_f25519_sqr.spec_val rb.loose
  obtain ⟨ckv, ckb⟩ := fd_f25519_mul.spec_val c1b.loose hv.loose
  obtain ⟨unv, unb⟩ := fd_f25519_neg.spec_val hu
  obtain ⟨sv, sb⟩ := fd_f25519_sqrtm1.val
  obtain ⟨univ, unib⟩ := fd_f25519_mul.spec_val unb sb.loose
  obtain ⟨rpv, rpb⟩ := fd_f25519_mul.spec_val rb.loose sb.loose
  simp only [fd_f25519_sqrt_ratio.spec]
  set v3 := fd_f25519_mul.spec (fd_f25519_sqr.spec v) v
  set uv7 := fd_f25519_mul.spec u (fd_f25519_mul.spec (fd_f25519_sqr.spec v3) v)
  set r₀ := fd_f25519_mul.spec (fd_f25519_pow22523.spec uv7) (fd_f25519_mul.spec u v3)
  have alg := sqrt_ratio_alg hv0 (u := Limbs.val u) (β := Limbs.val r₀)
    (by rw [rv, pv, uv7v, v7v, v6v, uv3v, v3v, v2v]; ring)
  clear_value v3 uv7 r₀
  simp only [fd_f25519_eq.spec_val ckb hu.under2p,
    fd_f25519_eq.spec_val ckb (fd_f25519_neg.spec_under2p hu),
    fd_f25519_eq.spec_val ckb unib.under2p, ite_or_ite, fd_f25519_if.spec_ite, ckv, c1v, unv, univ,
    sv]
  have hrr : Limbs.Tight (if Limbs.val r₀ ^ 2 * Limbs.val v = -Limbs.val u * sqrtM1 ∨
        Limbs.val r₀ ^ 2 * Limbs.val v = -Limbs.val u then
          fd_f25519_mul.spec r₀ fd_f25519_sqrtm1.limbs else r₀) ∧
      Limbs.val (if Limbs.val r₀ ^ 2 * Limbs.val v = -Limbs.val u * sqrtM1 ∨
        Limbs.val r₀ ^ 2 * Limbs.val v = -Limbs.val u then
          fd_f25519_mul.spec r₀ fd_f25519_sqrtm1.limbs else r₀) =
        if Limbs.val r₀ ^ 2 * Limbs.val v = -Limbs.val u * sqrtM1 ∨
          Limbs.val r₀ ^ 2 * Limbs.val v = -Limbs.val u then Limbs.val r₀ * sqrtM1
        else Limbs.val r₀ := by
    split
    · exact ⟨rpb, by rw [rpv, sv]⟩
    · exact ⟨rb, rfl⟩
  obtain ⟨habs, hpar, hb2, hn, -⟩ := fd_f25519_abs.spec_val hrr.1
  obtain ⟨hsq, hnsq⟩ := alg
  refine ⟨fun h => ?_, fun h => ?_, hpar, hb2, hn⟩
  · obtain ⟨hf, hr⟩ := hsq h
    refine ⟨by simp [hf], ?_⟩
    rcases habs with e | e <;> rw [e, hrr.2] <;> linear_combination hr
  · simp [hnsq h]

/-- `abs` of `if`'s pick of tight values of positive numbers has a positive number. -/
theorem fd_f25519_abs_if_pos {r r' : Fin 5 → BitVec 64} (c : BitVec 32) (hr : Limbs.Tight r)
    (pr : 0 < Limbs.nat r) (hr' : Limbs.Tight r') (pr' : 0 < Limbs.nat r') :
    0 < Limbs.nat (fd_f25519_abs.spec (fd_f25519_if.spec c r' r)) := by
  rcases fd_f25519_if.spec_or c r' r with h | h <;> rw [h]
  exacts [(fd_f25519_abs.spec_val hr').2.2.2.2 pr', (fd_f25519_abs.spec_val hr).2.2.2.2 pr]

/-- `sqrt_ratio` on tight `u` and `v` of positive numbers: `r`'s number is positive too, so a zero
`r` has `p`'s limbs, never all zeros. -/
public theorem fd_f25519_sqrt_ratio.spec_pos {u v : Fin 5 → BitVec 64} (hu : Limbs.Tight u)
    (hv : Limbs.Tight v) (pu : 0 < Limbs.nat u) (pv : 0 < Limbs.nat v) :
    0 < Limbs.nat (fd_f25519_sqrt_ratio.spec u v).r := by
  obtain ⟨-, v2b⟩ := fd_f25519_sqr.spec_val hv.loose
  have v2p := fd_f25519_sqr.spec_pos hv.loose pv
  obtain ⟨-, v3b⟩ := fd_f25519_mul.spec_val v2b.loose hv.loose
  have v3p := fd_f25519_mul.spec_pos v2b.loose hv.loose v2p pv
  obtain ⟨-, uv3b⟩ := fd_f25519_mul.spec_val hu.loose v3b.loose
  have uv3p := fd_f25519_mul.spec_pos hu.loose v3b.loose pu v3p
  obtain ⟨-, v6b⟩ := fd_f25519_sqr.spec_val v3b.loose
  have v6p := fd_f25519_sqr.spec_pos v3b.loose v3p
  obtain ⟨-, v7b⟩ := fd_f25519_mul.spec_val v6b.loose hv.loose
  have v7p := fd_f25519_mul.spec_pos v6b.loose hv.loose v6p pv
  obtain ⟨-, uv7b⟩ := fd_f25519_mul.spec_val hu.loose v7b.loose
  have uv7p := fd_f25519_mul.spec_pos hu.loose v7b.loose pu v7p
  obtain ⟨-, pb⟩ := fd_f25519_pow22523.spec_val uv7b.loose
  have pp := fd_f25519_pow22523.spec_pos uv7b.loose uv7p
  obtain ⟨-, rb⟩ := fd_f25519_mul.spec_val pb.loose uv3b.loose
  have rp := fd_f25519_mul.spec_pos pb.loose uv3b.loose pp uv3p
  obtain ⟨-, sb⟩ := fd_f25519_sqrtm1.val
  obtain ⟨-, rpb⟩ := fd_f25519_mul.spec_val rb.loose sb.loose
  have rpp := fd_f25519_mul.spec_pos rb.loose sb.loose rp (by decide)
  exact fd_f25519_abs_if_pos _ rb rp rpb rpp

end Sqrt

end MLIR.Firedancer.Ref
