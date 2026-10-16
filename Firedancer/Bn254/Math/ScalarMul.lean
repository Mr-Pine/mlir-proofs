module

public import Firedancer.Bn254.Math.Endo
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.ReduceModChar
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Abel

/-! `fd_bn254_g1_scalar_mul` on an on-curve affine point `P` and any 256-bit scalar `s` computes
`s • P` (with `s` unreduced), given that every point is killed by `r`. -/

namespace Firedancer.Bn254

set_option linter.auxLemma false
open Jac WeierstrassCurve WeierstrassCurve.Affine
variable {B : Backend}

/-! ## The spec's matchers as functions

Comparing two applications of a matcher makes the kernel evaluate the discriminant, so the spec's
pattern matches are rewritten (propositionally) into projections and `optElim` first. -/

@[expose] public section

/-- `Option` elimination as an ordinary definition. -/
def optElim {α β : Type} (x : Option β) (n : α) (f : β → α) : α :=
  match x with
  | none => n
  | some b => f b

end

theorem m5 {α : Type} (x : Vector (BitVec 64) 4 × BitVec 64)
    (f : Vector (BitVec 64) 4 → BitVec 64 → α) :
    fd_bn254_g1_scalar_mul.spec.match_5 (fun _ => α) x f = f x.1 x.2 := by
  cases x; rfl

theorem m3 {α : Type} (x : BitVec 32 × Vector (BitVec 64) 4)
    (f : BitVec 32 → Vector (BitVec 64) 4 → α) :
    fd_bn254_g1_scalar_mul.spec.match_3 (fun _ => α) x f = f x.1 x.2 := by
  cases x; rfl

theorem tm1 {α : Type} (x : BitVec 32 × BitVec 32) (f : BitVec 32 → BitVec 32 → α) :
    fd_bn254_g1_scalar_mul.top.match_1 (fun _ => α) x f = f x.1 x.2 := by
  cases x; rfl

theorem m1 {α : Type} (x : Option (Fin 256)) (n : Unit → α) (f : Fin 256 → α) :
    fd_bn254_g1_scalar_mul.spec.match_1 (fun _ => α) x n f = optElim x (n ()) f := by
  cases x <;> rfl

/-! ## The scan and the Shamir loop -/

theorem bits_fst (k1 k2 : fd_uint256_t) (i : ℕ) (h : i < 256) :
    (fd_bn254_g1_scalar_mul.bits k1 k2 i h).1 ≠ 0 ↔ limbsEval k1 / 2 ^ i % 2 = 1 := by
  simp only [fd_bn254_g1_scalar_mul.bits]
  rw [← testBit_iff, ← fd_uint256_bit.spec_ne_zero k1 i h]
  by_cases hb : fd_uint256_bit.spec k1 i h ≠ 0
  · rw [ite_eq_left hb]; exact ⟨fun _ => hb, fun _ => by decide⟩
  · rw [ite_eq_right hb]; exact ⟨fun h0 => absurd rfl h0, fun h1 => absurd h1 hb⟩

theorem bits_snd (k1 k2 : fd_uint256_t) (i : ℕ) (h : i < 256) :
    (fd_bn254_g1_scalar_mul.bits k1 k2 i h).2 ≠ 0 ↔ limbsEval k2 / 2 ^ i % 2 = 1 := by
  simp only [fd_bn254_g1_scalar_mul.bits]
  rw [← testBit_iff, ← fd_uint256_bit.spec_ne_zero k2 i h]
  by_cases hb : fd_uint256_bit.spec k2 i h ≠ 0
  · rw [ite_eq_left hb]; exact ⟨fun _ => hb, fun _ => by decide⟩
  · rw [ite_eq_right hb]; exact ⟨fun h0 => absurd rfl h0, fun h1 => absurd h1 hb⟩

theorem top_some (k1 k2 : fd_uint256_t) :
    ∀ (i : ℕ) (h : i < 256) (j : Fin 256),
      fd_bn254_g1_scalar_mul.top k1 k2 i h = some j →
        limbsEval k1 % 2 ^ (i + 1) = limbsEval k1 % 2 ^ (j.val + 1) ∧
          limbsEval k2 % 2 ^ (i + 1) = limbsEval k2 % 2 ^ (j.val + 1) ∧
          (limbsEval k1 / 2 ^ j.val % 2 = 1 ∨ limbsEval k2 / 2 ^ j.val % 2 = 1)
  | 0, h, j, hj => by
    simp only [fd_bn254_g1_scalar_mul.top] at hj
    split_ifs at hj with hb
    cases hj
    rw [bits_fst, bits_snd] at hb
    exact ⟨rfl, rfl, hb⟩
  | i + 1, h, j, hj => by
    simp only [fd_bn254_g1_scalar_mul.top] at hj
    split_ifs at hj with hb
    · cases hj
      rw [bits_fst, bits_snd] at hb
      exact ⟨rfl, rfl, hb⟩
    · rw [bits_fst, bits_snd, not_or] at hb
      obtain ⟨e1, e2, e3⟩ := top_some k1 k2 i (by omega) j hj
      refine ⟨?_, ?_, e3⟩
      · rw [bit_val, show limbsEval k1 / 2 ^ (i + 1) % 2 = 0 by omega, mul_zero, add_zero, e1]
      · rw [bit_val, show limbsEval k2 / 2 ^ (i + 1) % 2 = 0 by omega, mul_zero, add_zero, e2]

theorem top_none (k1 k2 : fd_uint256_t) :
    ∀ (i : ℕ) (h : i < 256),
      fd_bn254_g1_scalar_mul.top k1 k2 i h = none →
        limbsEval k1 % 2 ^ (i + 1) = 0 ∧ limbsEval k2 % 2 ^ (i + 1) = 0
  | 0, h, hj => by
    simp only [fd_bn254_g1_scalar_mul.top] at hj
    split_ifs at hj with hb
    rw [bits_fst, bits_snd, not_or] at hb
    rw [bit_val, bit_val]
    simp only [pow_zero, Nat.mod_one, Nat.div_one, one_mul, zero_add]
    omega
  | i + 1, h, hj => by
    simp only [fd_bn254_g1_scalar_mul.top] at hj
    split_ifs at hj with hb
    rw [bits_fst, bits_snd, not_or] at hb
    obtain ⟨e1, e2⟩ := top_none k1 k2 i (by omega) hj
    rw [bit_val (limbsEval k1) (i + 1), bit_val (limbsEval k2) (i + 1), e1, e2,
      show limbsEval k1 / 2 ^ (i + 1) % 2 = 0 by omega,
      show limbsEval k2 / 2 ^ (i + 1) % 2 = 0 by omega]
    simp

/-- The points a Shamir loop step can add. -/
structure Summands (p q pq : fd_bn254_g1_t) (P Q : ECPoint) : Prop where
  hp : ARep p P
  hq : ARep q Q
  hpq : ARep pq (P + Q)
  hP : P ≠ 0
  hQ : Q ≠ 0
  hPQ : P + Q ≠ 0

theorem bit01 (K i : ℕ) : K / 2 ^ i % 2 = 0 ∨ K / 2 ^ i % 2 = 1 := by omega

theorem step_rep {p q pq : fd_bn254_g1_t} {P Q : ECPoint} (hs : Summands p q pq P Q)
    (k1 k2 : fd_uint256_t) {r : fd_bn254_g1_t} {R : ECPoint} (hr : PRep r R) (i : ℕ) (h : i < 256) :
    PRep (fd_bn254_g1_scalar_mul.step p q pq k1 k2 r i h)
      (2 • R + (limbsEval k1 / 2 ^ i % 2) • P + (limbsEval k2 / 2 ^ i % 2) • Q) := by
  have hd := fd_bn254_g1_dbl.rep r hr
  simp only [fd_bn254_g1_scalar_mul.step]
  have b1 := bits_fst k1 k2 i h
  have b2 := bits_snd k1 k2 i h
  rcases bit01 (limbsEval k1) i with e1 | e1 <;> rcases bit01 (limbsEval k2) i with e2 | e2 <;>
    simp only [b1, b2, e1, e2, zero_nsmul, one_nsmul, add_zero, Nat.reduceEqDiff, and_false,
      and_true, ↓reduceIte]
  · exact hd
  · exact fd_bn254_g1_add_mixed.rep _ hd hs.hq hs.hQ
  · exact fd_bn254_g1_add_mixed.rep _ hd hs.hp hs.hP
  · rw [add_assoc]; exact fd_bn254_g1_add_mixed.rep _ hd hs.hpq hs.hPQ

theorem loop_rep {p q pq : fd_bn254_g1_t} {P Q : ECPoint} (hs : Summands p q pq P Q)
    (k1 k2 : fd_uint256_t) :
    ∀ (n : ℕ) (hn : n ≤ 256) (r : fd_bn254_g1_t),
      PRep r ((limbsEval k1 / 2 ^ n) • P + (limbsEval k2 / 2 ^ n) • Q) →
        PRep (fd_bn254_g1_scalar_mul.loop p q pq k1 k2 r n hn)
          ((limbsEval k1) • P + (limbsEval k2) • Q)
  | 0, hn, r, hr => by simpa [fd_bn254_g1_scalar_mul.loop] using hr
  | n + 1, hn, r, hr => by
    rw [fd_bn254_g1_scalar_mul.loop]
    apply loop_rep hs k1 k2 n (by omega)
    have := step_rep hs k1 k2 hr n (by omega)
    convert this using 1
    have d1 :
      limbsEval k1 / 2 ^ n = 2 * (limbsEval k1 / 2 ^ (n + 1)) + limbsEval k1 / 2 ^ n % 2 := by
      rw [pow_succ, ← Nat.div_div_eq_div_mul]; omega
    have d2 :
      limbsEval k2 / 2 ^ n = 2 * (limbsEval k2 / 2 ^ (n + 1)) + limbsEval k2 / 2 ^ n % 2 := by
      rw [pow_succ, ← Nat.div_div_eq_div_mul]; omega
    generalize limbsEval k1 / 2 ^ n % 2 = c1 at d1 ⊢
    generalize limbsEval k2 / 2 ^ n % 2 = c2 at d2 ⊢
    rw [d1, d2, add_nsmul, add_nsmul, mul_smul, mul_smul]
    abel

/-! ## Group-order arithmetic -/

/-- With every point killed by `r`, `a • P` only depends on `a mod r`. -/
theorem smul_eq_of_cast (hr : ∀ P : ECPoint, r_bn254 • P = 0) {a b : ℕ} (h : (a : ZMod r_bn254) = b)
    (P : ECPoint) : a • P = b • P := by
  rw [ZMod.natCast_eq_natCast_iff'] at h
  rw [← Nat.mod_add_div a r_bn254, ← Nat.mod_add_div b r_bn254, add_nsmul, add_nsmul, mul_nsmul',
    mul_nsmul', hr, hr, add_zero, add_zero, h]

theorem neg_eq_smul (hr : ∀ P : ECPoint, r_bn254 • P = 0) (P : ECPoint) :
    -P = (r_bn254 - 1) • P := by
  have h1 : 1 ≤ r_bn254 := (Fact.out : r_bn254.Prime).one_le
  rw [eq_comm, ← add_eq_zero_iff_eq_neg, ← succ_nsmul, Nat.sub_add_cancel h1, hr]

theorem NA_eq :
    ((147946756881789319000765030803803410728 : ℕ) : ZMod r_bn254) =
      (lam : ZMod r_bn254) * (9931322734385697763 : ℕ) := by
  unfold lam r_bn254; push_cast; reduce_mod_char

theorem NB_eq :
    ((9931322734385697763 : ℕ) : ZMod r_bn254) =
      -((lam : ZMod r_bn254) * (147946756881789319010696353538189108491 : ℕ)) := by
  unfold lam r_bn254; push_cast; reduce_mod_char

/-! ## `fd_bn254_g1_scalar_mul` -/

@[expose] public section

/-- `pt2` of `fd_bn254_g1_scalar_mul`: `φ(p)`, negated when `k2 < 0`. -/
def smPt2 (p : fd_bn254_g1_t) (neg : BitVec 32) : fd_bn254_g1_t :=
  { X := fd_bn254_fp_mul.spec p.X fd_bn254_const_beta_mont,
    Y :=
      if neg ≠ 0 then fd_bn254_fp_neg.spec (fd_bn254_fp_set.spec p.Y) else fd_bn254_fp_set.spec p.Y,
    Z := fd_bn254_fp_set_one.spec }

/-- `fd_bn254_g1_scalar_mul.spec` after the decomposition, on `(k1, |k2|, k2 < 0)`. -/
def smBody (B : Backend) (r p : fd_bn254_g1_t) (k1 k2 : fd_uint256_t) (neg : BitVec 32) :
    fd_bn254_g1_t :=
  optElim (fd_bn254_g1_scalar_mul.top k1 k2 255 (by omega)) (fd_bn254_g1_set_zero.spec r) fun i =>
    fd_bn254_g1_scalar_mul.loop p (smPt2 p neg)
      (fd_bn254_g1_affine_add.spec B default p (smPt2 p neg)) k1 k2
      (fd_bn254_g1_set.spec
        (if
            (fd_bn254_g1_scalar_mul.bits k1 k2 i.val i.isLt).1 ≠ 0 ∧
              (fd_bn254_g1_scalar_mul.bits k1 k2 i.val i.isLt).2 ≠ 0 then
          fd_bn254_g1_affine_add.spec B default p (smPt2 p neg)
        else if (fd_bn254_g1_scalar_mul.bits k1 k2 i.val i.isLt).1 ≠ 0 then p else smPt2 p neg))
      i.val (by omega)

end

theorem smPt2_rep {p : fd_bn254_g1_t} {x y : ZMod p_bn254}
    {h : (curve (ZMod p_bn254)).toAffine.Nonsingular x y} (hp : ARep p (.some x y h))
    (neg : BitVec 32) :
    ARep (smPt2 p neg) (if neg ≠ 0 then -phi (.some x y h) else phi (.some x y h)) := by
  obtain ⟨hx, hy, -⟩ := hp.coords
  have gX := fd_bn254_fp_mul.tr hx fd_bn254_const_beta_mont.tr
  rw [mul_comm] at gX
  unfold smPt2
  rw [fd_bn254_fp_set.spec_eq]
  split_ifs with hn
  · rw [phi_some, Point.neg_some]
    have hY := fd_bn254_fp_neg.tr hy
    rw [← negY_eq] at hY
    exact ARep.of_xyz _ gX hY fd_bn254_fp_set_one.spec_eq
  · rw [phi_some]
    exact ARep.of_xyz _ gX hy fd_bn254_fp_set_one.spec_eq

/-- `smBody` computes `s • P` from a decomposition `s = k1 + b₁ N_A + b₂ N_B`,
`±k2 = b₁ N_B - b₂ N_C`. -/
theorem smBody_rep (hB : B.Spec) (hr : ∀ P : ECPoint, r_bn254 • P = 0) {p : fd_bn254_g1_t}
    {x y : ZMod p_bn254} {h : (curve (ZMod p_bn254)).toAffine.Nonsingular x y}
    (hp : ARep p (.some x y h)) (r : fd_bn254_g1_t) (S : ℕ) (k1 k2 : fd_uint256_t) (neg : BitVec 32)
    (hk :
      limbsEval k1 < 2 ^ 128 ∧
        limbsEval k2 < 2 ^ 128 ∧
        (neg = 0 ∨ neg = 1) ∧
        ∃ b₁ b₂ : ℕ,
          S =
              limbsEval k1 + b₁ * 147946756881789319000765030803803410728 +
                b₂ * 9931322734385697763 ∧
            (neg = 0 →
              limbsEval k2 + b₂ * 147946756881789319010696353538189108491 =
                b₁ * 9931322734385697763) ∧
            (neg = 1 →
              limbsEval k2 + b₁ * 9931322734385697763 =
                b₂ * 147946756881789319010696353538189108491)) :
    PRep (smBody B r p k1 k2 neg) (S • .some x y h) := by
  obtain ⟨-, -, hneg, b₁, b₂, hS, h0, h1⟩ := hk
  set P : ECPoint := .some x y h with hPdef
  set Q : ECPoint := if neg ≠ 0 then -phi P else phi P with hQdef
  have hq := smPt2_rep hp neg
  have hpq := fd_bn254_g1_affine_add.rep hB default hp hq
  have hP0 : P ≠ 0 := Point.some_ne_zero h
  have hx0 : x ≠ 0 := by
    rintro rfl
    exact
      sq_ne_three y
        (by
          have := eqn h; rw [this]; ring)
  have hxb : x ≠ beta * x := by
    intro hc
    have : (beta - 1) * x = 0 := by linear_combination -hc
    rcases mul_eq_zero.mp this with h' | h'
    · exact beta_ne_one (by linear_combination h')
    · exact hx0 h'
  have hQs : ∃ y' h', Q = Point.some (beta * x) y' h' := by
    by_cases hn : neg ≠ 0
    · rw [hQdef, ite_eq_left hn, hPdef, phi_some, Point.neg_some]; exact ⟨_, _, rfl⟩
    · rw [hQdef, ite_eq_right hn, hPdef, phi_some]; exact ⟨_, _, rfl⟩
  obtain ⟨y', h', hQ⟩ := hQs
  have hQ0 : Q ≠ 0 := by
    rw [hQ]; exact Point.some_ne_zero h'
  have hPQ0 : P + Q ≠ 0 := by
    rw [hQ, hPdef, Point.add_of_X_ne hxb]; exact Point.some_ne_zero _
  have hs : Summands p (smPt2 p neg) (fd_bn254_g1_affine_add.spec B default p (smPt2 p neg)) P Q :=
    ⟨hp, hq, hpq, hP0, hQ0, hPQ0⟩
  -- the sum the ladder computes is `s • P`
  have hsum : (limbsEval k1) • P + (limbsEval k2) • Q = S • P := by
    have hphi := phi_eq_lam_smul hr P
    rcases hneg with rfl | rfl
    · rw [hQdef, ite_eq_right (by decide), hphi, ← mul_nsmul', ← add_nsmul]
      apply smul_eq_of_cast hr
      have e := congrArg (Nat.cast : ℕ → ZMod r_bn254) (h0 rfl)
      push_cast at e ⊢
      rw [hS]; push_cast
      linear_combination
        (lam : ZMod r_bn254) * e - (b₁ : ZMod r_bn254) * NA_eq - (b₂ : ZMod r_bn254) * NB_eq
    · rw [hQdef, ite_eq_left (by decide), hphi, neg_eq_smul hr, ← mul_nsmul', ← mul_nsmul', ←
        add_nsmul]
      apply smul_eq_of_cast hr
      have e := congrArg (Nat.cast : ℕ → ZMod r_bn254) (h1 rfl)
      have hr1 : ((r_bn254 - 1 : ℕ) : ZMod r_bn254) = -1 := by
        rw [Nat.cast_sub (Fact.out : r_bn254.Prime).one_le, ZMod.natCast_self]; ring
      push_cast at e ⊢
      rw [hS, hr1]; push_cast
      linear_combination
        (-(lam : ZMod r_bn254)) * e - (b₁ : ZMod r_bn254) * NA_eq - (b₂ : ZMod r_bn254) * NB_eq
  have hK1 := limbsEval_lt k1
  have hK2 := limbsEval_lt k2
  unfold smBody
  rcases ht : fd_bn254_g1_scalar_mul.top k1 k2 255 (by omega) with _ | j
  · obtain ⟨e1, e2⟩ := top_none k1 k2 255 (by omega) ht
    rw [Nat.mod_eq_of_lt hK1] at e1
    rw [Nat.mod_eq_of_lt hK2] at e2
    rw [e1, e2, zero_nsmul, zero_nsmul, add_zero] at hsum
    rw [← hsum]
    exact PRep.set_zero r
  · obtain ⟨e1, e2, e3⟩ := top_some k1 k2 255 (by omega) j ht
    rw [Nat.mod_eq_of_lt hK1] at e1
    rw [Nat.mod_eq_of_lt hK2] at e2
    have d1 : limbsEval k1 / 2 ^ j.val = limbsEval k1 / 2 ^ j.val % 2 := by
      have : limbsEval k1 < 2 ^ (j.val + 1) := by
        rw [e1]; exact Nat.mod_lt _ (by positivity)
      rw [Nat.mod_eq_of_lt]; rw [Nat.div_lt_iff_lt_mul (by positivity)]; rw [pow_succ] at this;
      omega
    have d2 : limbsEval k2 / 2 ^ j.val = limbsEval k2 / 2 ^ j.val % 2 := by
      have : limbsEval k2 < 2 ^ (j.val + 1) := by
        rw [e2]; exact Nat.mod_lt _ (by positivity)
      rw [Nat.mod_eq_of_lt]; rw [Nat.div_lt_iff_lt_mul (by positivity)]; rw [pow_succ] at this;
      omega
    rw [← hsum]
    simp only [optElim]
    apply loop_rep hs k1 k2 j.val (by omega)
    have b1 := bits_fst k1 k2 j.val j.isLt
    have b2 := bits_snd k1 k2 j.val j.isLt
    rw [fd_bn254_g1_set.spec_eq, d1, d2]
    rcases bit01 (limbsEval k1) j.val with f1 | f1 <;>
      rcases bit01 (limbsEval k2) j.val with f2 | f2 <;>
      simp only [b1, b2, f1, f2, zero_nsmul, one_nsmul, add_zero, zero_add, Nat.reduceEqDiff,
        and_false, and_true, ↓reduceIte]
    · omega
    · exact hq.prep
    · exact hp.prep
    · exact hpq.prep

/-- `fd_bn254_g1_scalar_mul` on an affine representative of `P` and any 256-bit `s` represents
`s • P` (`s` unreduced), if every point is killed by `r`. -/
public theorem fd_bn254_g1_scalar_mul.rep (hB : B.Spec) (hr : ∀ P : ECPoint, r_bn254 • P = 0)
    {p : fd_bn254_g1_t} {P : ECPoint} (hp : ARep p P) (r : fd_bn254_g1_t) (s : fd_bn254_scalar_t) :
    PRep (fd_bn254_g1_scalar_mul.spec B r p s) (limbsEval s • P) := by
  by_cases hz : fd_uint256_is_zero.spec s ≠ 0 ∨ fd_bn254_g1_is_zero.spec p ≠ 0
  · rw [fd_bn254_g1_scalar_mul.spec, ite_eq_left hz]
    rcases hz with hs | hp0
    · rw [(fd_uint256_is_zero.spec_ne_zero s).mp hs, zero_nsmul]; exact PRep.set_zero r
    · rw [hp.prep.is_zero_iff.mp hp0, nsmul_zero]; exact PRep.set_zero r
  · have hp0 : P ≠ 0 := fun h => hz (.inr (hp.prep.is_zero_iff.mpr h))
    cases P with
    | zero => exact absurd rfl hp0
    | some x y h =>
      rw [fd_bn254_g1_scalar_mul.spec, ite_eq_right hz]
      simp (config := { iota := false, etaStruct := .none, proj := false, zeta := true }) only [m5,
        m3, tm1, m1]
      exact smBody_rep hB hr hp r (limbsEval s) _ _ _ (glv_spec s)

end Firedancer.Bn254
