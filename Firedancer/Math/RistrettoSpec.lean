module

public import Firedancer.Math.Ristretto
public import Firedancer.Math.GroupOps
public import Firedancer.Math.Sqrt
import all Firedancer.Math.Curve
import all Firedancer.Math.Field
public import Firedancer.Ref.fd_ristretto255_point_frombytes
public import Firedancer.Ref.fd_ristretto255_point_tobytes
public import Firedancer.Ref.fd_ristretto255_point_validate
public import Firedancer.Ref.fd_ristretto255_point_eq
public import Firedancer.Ref.fd_ristretto255_point_eq_neg
public import Firedancer.Ref.fd_f25519_inv_sqrt
import Mathlib.FieldTheory.Finite.Basic
import Mathlib.NumberTheory.LegendreSymbol.Basic
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.ReduceModChar

/-! The ristretto255 translations against RFC 9496 (`Ed25519.Ristretto`): `inv_sqrt` is
`SQRT_RATIO_M1(1, ·)`, `frombytes` decodes, `tobytes` encodes any representative, `validate` is
decoding's success, `eq`/`eq_neg` test `E[4]`-cosets. -/

namespace MLIR.Firedancer.Ref

open _root_.Ed25519 _root_.Ed25519.Ristretto

/-! ## Signs, `abs`, `sqrt_ratio` -/

section Sqrt

/-- A parity flag as `if`. -/
public theorem ofNat_mod_two (n : ℕ) :
    BitVec.ofNat 32 (n % 2) = if n % 2 = 1 then 1#32 else 0#32 := by
  rcases Nat.mod_two_eq_zero_or_one n with h | h <;> rw [h] <;> rfl

/-- `sgn` on tight limbs as `IS_NEGATIVE`. -/
public theorem fd_f25519_sgn.spec_isNeg {a : Fin 5 → BitVec 64} (ha : Limbs.Under2p a)
    (hN : Limbs.nat a < 2 * p) :
    fd_f25519_sgn.spec a = if IsNeg (Limbs.val a) then 1#32 else 0#32 := by
  rw [fd_f25519_sgn.spec_val ha hN]
  unfold IsNeg
  rcases Nat.mod_two_eq_zero_or_one (Limbs.val a).val with h | h <;> simp [h]

/-- `fd_f25519_abs` on tight limbs is `CT_ABS`. -/
public theorem fd_f25519_abs.spec_ctAbs {a : Fin 5 → BitVec 64} (ha : Limbs.Tight a) :
    Limbs.val (fd_f25519_abs.spec a) = ctAbs (Limbs.val a) := by
  unfold fd_f25519_abs.spec
  dsimp only
  rw [fd_f25519_sgn.spec_isNeg ha.under2p ha.nat_lt, fd_f25519_if.spec_ite]
  unfold ctAbs
  split
  · exact (fd_f25519_neg.spec_val ha).1
  · rfl

/-- `sqrt_ratio`'s algebra against RFC 9496: the flag `ff ∨ fc` is `SQRT_RATIO_M1`'s, and
`CT_ABS` of the chosen root its root, for all `u`, `v`. -/
theorem sqrt_ratio_rfc {u v β : ZMod p} (hβ : β = u * v ^ 3 * (u * v ^ 7) ^ ((p - 5) / 8)) :
    ((sqrtRatioM1 u v).1 = true ↔ β ^ 2 * v = -u ∨ β ^ 2 * v = u) ∧
      (sqrtRatioM1 u v).2 =
        ctAbs (if β ^ 2 * v = -u * sqrtM1 ∨ β ^ 2 * v = -u then β * sqrtM1 else β) := by
  have hi := sqrtM1_sq
  have hi0 : sqrtM1 ≠ 0 := fun h0 => by
    rw [h0] at hi; exact absurd hi (by decide)
  have hne : (1 : ZMod p) ≠ -1 := by decide
  unfold sqrtRatioM1
  by_cases hv : v = 0
  · subst hv
    have hβ0 : β = 0 := by simp [hβ]
    subst hβ0
    by_cases hu : u = 0
    · subst hu
      simp [nnSqrt_zero, ctAbs_of_even]
    · have hu' : -u ≠ 0 := neg_ne_zero.2 hu
      simp only [hu, ne_eq, not_true_eq_false, false_and, or_self, ↓reduceIte, div_zero,
        nnSqrt_zero, Bool.false_eq_true, false_iff, not_or]
      refine ⟨⟨by simpa using hu'.symm, by simpa using (Ne.symm hu)⟩, ?_⟩
      rw [ite_eq_right_of_eq_false _ _ (eq_false (by simp [hu, hi0])), ctAbs_of_even (by simp)]
  by_cases hu : u = 0
  · subst hu
    have hβ0 : β = 0 := by simp [hβ]
    subst hβ0
    simp [nnSqrt_zero, ctAbs_of_even]
  have hw : u * v ^ 7 ≠ 0 := mul_ne_zero hu (pow_ne_zero _ hv)
  set c := (u * v ^ 7) ^ ((p - 1) / 4) with hc
  have hcheck : β ^ 2 * v = u * c := by
    rw [hc, show (p - 1) / 4 = 2 * ((p - 5) / 8) + 1 by norm_num, pow_succ (u * v ^ 7),
      pow_mul (u * v ^ 7), hβ]
    ring
  have hc2 : c ^ 2 = (u * v ^ 7) ^ (p / 2) := by
    rw [hc, ← pow_mul]; norm_num
  have hFermat : ((u * v ^ 7) ^ (p / 2)) ^ 2 = 1 := by
    rw [← pow_mul, show p / 2 * 2 = p - 1 by norm_num]
    exact ZMod.pow_card_sub_one_eq_one hw
  have hsq := (isSquare_div_iff (u := u) hv).trans (ZMod.euler_criterion p hw)
  have hcond : (u = 0 ∨ (v ≠ 0 ∧ IsSquare (u / v))) ↔ IsSquare (u / v) := by simp [hu, hv]
  by_cases hs : IsSquare (u / v)
  · rw [ite_eq_left_of_eq_true _ _ (eq_true (hcond.2 hs))]
    have h1 : c ^ 2 = 1 := hc2.trans (hsq.1 hs)
    rcases sq_eq_one_iff'.1 h1 with h1 | h1
    · have hfc : β ^ 2 * v = u := by rw [hcheck, h1, mul_one]
      have hff : ¬β ^ 2 * v = -u := fun h =>
        hu
          (by
            have : 2 * u = 0 := by linear_combination hfc.symm.trans h
            exact (mul_eq_zero.1 this).resolve_left (by decide))
      have hfi : ¬β ^ 2 * v = -u * sqrtM1 := fun h => by
        have : u * (1 + sqrtM1) = 0 := by linear_combination hfc.symm.trans h
        rcases mul_eq_zero.1 this with h | h
        · exact hu h
        · rw [show sqrtM1 = -1 by linear_combination h] at hi
          exact hne (by linear_combination hi)
      refine ⟨by simp [hfc], ?_⟩
      rw [ite_eq_right_of_eq_false _ _ (eq_false (not_or.2 ⟨hfi, hff⟩))]
      exact
        nnSqrt_eq
          (by
            rw [ctAbs_sq]; field_simp; linear_combination hfc)
          (ctAbs_even _)
    · have hff : β ^ 2 * v = -u := by
        rw [hcheck, h1]; ring
      simp only [hff, true_or, or_true, ↓reduceIte, true_and]
      exact
        nnSqrt_eq
          (by
            rw [ctAbs_sq]; field_simp; linear_combination -hi * u + sqrtM1 ^ 2 * hff)
          (ctAbs_even _)
  · rw [ite_eq_right_of_eq_false _ _ (eq_false (mt hcond.1 hs))]
    have hm : (u * v ^ 7) ^ (p / 2) = -1 := by
      have : ((u * v ^ 7) ^ (p / 2) - 1) * ((u * v ^ 7) ^ (p / 2) + 1) = 0 := by
        linear_combination hFermat
      rcases mul_eq_zero.1 this with h' | h'
      · exact absurd (hsq.2 (by linear_combination h')) hs
      · linear_combination h'
    have hc' : c ^ 2 = -1 := hc2.trans hm
    have hfc : ¬β ^ 2 * v = u := fun h => by
      have : u * (c - 1) = 0 := by linear_combination hcheck.symm.trans h
      rw [show c = 1 by linear_combination (mul_eq_zero.1 this).resolve_left hu] at hc'
      exact hne (by linear_combination hc')
    have hff : ¬β ^ 2 * v = -u := fun h => by
      have : u * (c + 1) = 0 := by linear_combination hcheck.symm.trans h
      rw [show c = -1 by linear_combination (mul_eq_zero.1 this).resolve_left hu] at hc'
      exact hne (by linear_combination hc')
    simp only [hfc, hff, or_false, Bool.false_eq_true, true_and]
    have : (c - sqrtM1) * (c + sqrtM1) = 0 := by linear_combination hc' - hi
    rcases mul_eq_zero.1 this with h | h
    · have hfi : ¬β ^ 2 * v = -u * sqrtM1 := fun h' => by
        have : u * (c + sqrtM1) = 0 := by linear_combination hcheck.symm.trans h'
        have h2 : 2 * sqrtM1 = 0 := by linear_combination (mul_eq_zero.1 this).resolve_left hu - h
        exact hi0 ((mul_eq_zero.1 h2).resolve_left (by decide))
      rw [ite_eq_right_of_eq_false _ _ (eq_false hfi)]
      refine nnSqrt_eq ?_ (ctAbs_even _)
      rw [ctAbs_sq]; field_simp
      linear_combination hcheck + u * h
    · have hfi : β ^ 2 * v = -u * sqrtM1 := by
        rw [hcheck]; linear_combination u * h
      rw [ite_eq_left_of_eq_true _ _ (eq_true hfi)]
      refine nnSqrt_eq ?_ (ctAbs_even _)
      rw [ctAbs_sq]; field_simp
      linear_combination sqrtM1 * hfi - u * hi

/-- `sqrt_ratio` on tight `u`, `v` is RFC 9496's `SQRT_RATIO_M1`: its flag as `1`/`0`, its root
in limbs within `2p`'s, below `2p`. -/
public theorem fd_f25519_sqrt_ratio.spec_rfc {u v : Fin 5 → BitVec 64} (hu : Limbs.Tight u)
    (hv : Limbs.Tight v) :
    let R := fd_f25519_sqrt_ratio.spec u v
    R.ret = (if (sqrtRatioM1 (Limbs.val u) (Limbs.val v)).1 then 1#32 else 0#32) ∧
      Limbs.val R.r = (sqrtRatioM1 (Limbs.val u) (Limbs.val v)).2 ∧
      Limbs.Under2p R.r ∧ Limbs.nat R.r < 2 * p := by
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
  have alg :=
    sqrt_ratio_rfc (u := Limbs.val u) (v := Limbs.val v) (β := Limbs.val r₀)
      (by
        rw [rv, pv, uv7v, v7v, v6v, uv3v, v3v, v2v]; ring)
  clear_value v3 uv7 r₀
  simp only [fd_f25519_eq.spec_val ckb hu.under2p,
    fd_f25519_eq.spec_val ckb (fd_f25519_neg.spec_under2p hu),
    fd_f25519_eq.spec_val ckb unib.under2p, ite_or_ite, fd_f25519_if.spec_ite, ckv, c1v, unv, univ,
    sv]
  have hrr :
    Limbs.Tight
        (if
            Limbs.val r₀ ^ 2 * Limbs.val v = -Limbs.val u * sqrtM1 ∨
              Limbs.val r₀ ^ 2 * Limbs.val v = -Limbs.val u then
          fd_f25519_mul.spec r₀ fd_f25519_sqrtm1.limbs
        else r₀) ∧
      Limbs.val
          (if
              Limbs.val r₀ ^ 2 * Limbs.val v = -Limbs.val u * sqrtM1 ∨
                Limbs.val r₀ ^ 2 * Limbs.val v = -Limbs.val u then
            fd_f25519_mul.spec r₀ fd_f25519_sqrtm1.limbs
          else r₀) =
        if
            Limbs.val r₀ ^ 2 * Limbs.val v = -Limbs.val u * sqrtM1 ∨
              Limbs.val r₀ ^ 2 * Limbs.val v = -Limbs.val u then
          Limbs.val r₀ * sqrtM1
        else Limbs.val r₀ := by
    split
    · exact ⟨rpb, by rw [rpv, sv]⟩
    · exact ⟨rb, rfl⟩
  obtain ⟨-, -, hb2, hn, -⟩ := fd_f25519_abs.spec_val hrr.1
  refine ⟨?_, by rw [fd_f25519_abs.spec_ctAbs hrr.1, hrr.2, alg.2], hb2, hn⟩
  simp only [alg.1]

/-- `inv_sqrt` on tight `v` is `SQRT_RATIO_M1(1, v)`. -/
public theorem fd_f25519_inv_sqrt.spec_rfc {v : Fin 5 → BitVec 64} (hv : Limbs.Tight v) :
    let R := fd_f25519_inv_sqrt.spec v
    R.ret = (if (sqrtRatioM1 1 (Limbs.val v)).1 then 1#32 else 0#32) ∧
      Limbs.val R.r = (sqrtRatioM1 1 (Limbs.val v)).2 ∧
      Limbs.Under2p R.r ∧ Limbs.nat R.r < 2 * p := by
  have h := fd_f25519_sqrt_ratio.spec_rfc fd_f25519_one.val.2 hv
  rw [fd_f25519_one.val.1] at h
  exact h

/-- `inv_sqrt`'s root: `1/√v` for `v` a nonzero square (flag `1`), else flag `0`. -/
public theorem fd_f25519_inv_sqrt.spec_val {v : Fin 5 → BitVec 64} (hv : Limbs.Tight v) :
    let R := fd_f25519_inv_sqrt.spec v
    (Limbs.val v ≠ 0 ∧ IsSquare (Limbs.val v) →
        R.ret = 1#32 ∧ Limbs.val R.r ^ 2 * Limbs.val v = 1) ∧
      (¬(Limbs.val v ≠ 0 ∧ IsSquare (Limbs.val v)) → R.ret = 0#32) ∧
      (Limbs.val R.r).val % 2 = 0 := by
  obtain ⟨hret, hr, -, -⟩ := fd_f25519_inv_sqrt.spec_rfc hv
  obtain ⟨hok, hI⟩ := sqrtRatioM1_one (w := Limbs.val v)
  refine
    ⟨fun h =>
      ⟨by
        rw [hret, hok.2 h]; rfl, by
        rw [hr]; exact hI (hok.2 h)⟩,
      fun h => ?_, by
      rw [hr]; exact sqrtRatioM1_even _ _⟩
  rw [hret]
  cases e : (sqrtRatioM1 1 (Limbs.val v)).1
  · rfl
  · exact absurd (hok.1 e) h

end Sqrt

/-! ## `fd_f25519_sub` on a loose first operand

`frombytes` subtracts from `fd_f25519_neg`'s output, whose limbs exceed fiat's tight input bound for
`fiat_25519_sub`; the 64-bit limbs still hold the sum, and the carry still tightens it. -/

section SubWide

/-- A limb of `x + 2p - y` for `x` within `2p`'s limb: no wrap, below `2^53`. -/
theorem sub_limb_wide {s x y : BitVec 64} (c : ℕ) (hs : s = x + BitVec.ofNat 64 c - y)
    (hx : x.toNat ≤ 0x10000000000000) (hy : y.toNat ≤ c) (hc : c ≤ 0x10000000000000) :
    s.toNat + y.toNat = x.toNat + c ∧ s.toNat ≤ 0x20000000000000 := by
  rw [hs, BitVec.toNat_sub, BitVec.toNat_add, BitVec.toNat_ofNat]
  omega

/-- `fiat_25519_sub` of limbs within `2p`'s: the difference, limbs below `2^53`. -/
theorem fiat_25519_sub.spec_wide {x y : Fin 5 → BitVec 64} (hx : Limbs.Under2p x)
    (hy : Limbs.Under2p y) :
    Limbs.val (fiat_25519_sub.spec x y) = Limbs.val x - Limbs.val y ∧
      ∀ i, (fiat_25519_sub.spec x y i).toNat ≤ 0x20000000000000 := by
  obtain ⟨f0, f1, f2, f3, f4⟩ := hx.bounds
  obtain ⟨g0, g1, g2, g3, g4⟩ := hy.bounds
  obtain ⟨e0, b0⟩ :=
    sub_limb_wide (s := fiat_25519_sub.spec x y 0) (x := x 0) (y := y 0) 4503599627370458 rfl
      (by omega) g0 (by decide)
  obtain ⟨e1, b1⟩ :=
    sub_limb_wide (s := fiat_25519_sub.spec x y 1) (x := x 1) (y := y 1) 4503599627370494 rfl
      (by omega) g1 (by decide)
  obtain ⟨e2, b2⟩ :=
    sub_limb_wide (s := fiat_25519_sub.spec x y 2) (x := x 2) (y := y 2) 4503599627370494 rfl
      (by omega) g2 (by decide)
  obtain ⟨e3, b3⟩ :=
    sub_limb_wide (s := fiat_25519_sub.spec x y 3) (x := x 3) (y := y 3) 4503599627370494 rfl
      (by omega) g3 (by decide)
  obtain ⟨e4, b4⟩ :=
    sub_limb_wide (s := fiat_25519_sub.spec x y 4) (x := x 4) (y := y 4) 4503599627370494 rfl
      (by omega) g4 (by decide)
  refine
    ⟨?_, fun i =>
      match i with
      | ⟨0, _⟩ => b0
      | ⟨1, _⟩ => b1
      | ⟨2, _⟩ => b2
      | ⟨3, _⟩ => b3
      | ⟨4, _⟩ => b4⟩
  rw [Limbs.val_eq, Limbs.val_eq x, Limbs.val_eq y]
  replace e0 := congrArg (Nat.cast (R := ZMod p)) e0
  replace e1 := congrArg (Nat.cast (R := ZMod p)) e1
  replace e2 := congrArg (Nat.cast (R := ZMod p)) e2
  replace e3 := congrArg (Nat.cast (R := ZMod p)) e3
  replace e4 := congrArg (Nat.cast (R := ZMod p)) e4
  push_cast at e0 e1 e2 e3 e4
  linear_combination e0 + 2 ^ 51 * e1 + 2 ^ 102 * e2 + 2 ^ 153 * e3 + 2 ^ 204 * e4 + 2 * two_pow_255

/-- `fiat_25519_carry` on limbs below `2^53`: the value, tight. -/
theorem fiat_25519_carry.spec_wide {l : Fin 5 → BitVec 64}
    (hl : ∀ i, (l i).toNat ≤ 0x20000000000000) :
    Limbs.val (fiat_25519_carry.spec l) = Limbs.val l ∧ Limbs.Tight (fiat_25519_carry.spec l) := by
  have h0 := hl 0
  have h1 := hl 1
  have h2 := hl 2
  have h3 := hl 3
  have h4 := hl 4
  rw [Limbs.val_eq, Limbs.val_eq l, Limbs.tight_iff]
  dsimp only [fiat_25519_carry.spec]
  generalize hx2 : l 0 >>> 51 + l 1 = x2
  generalize hx3 : x2 >>> 51 + l 2 = x3
  generalize hx4 : x3 >>> 51 + l 3 = x4
  generalize hx5 : x4 >>> 51 + l 4 = x5
  generalize hx6 : x5 >>> 51 * 19 + (l 0 &&& 2251799813685247#64) = x6
  generalize hx7 : x6 >>> 51 + (x2 &&& 2251799813685247#64) = x7
  have k2 : x2.toNat = (l 1).toNat + (l 0).toNat / 2 ^ 51 := by
    rw [← hx2, BitVec.toNat_add, toNat_shift]; omega
  have k3 : x3.toNat = (l 2).toNat + x2.toNat / 2 ^ 51 := by
    rw [← hx3, BitVec.toNat_add, toNat_shift]; omega
  have k4 : x4.toNat = (l 3).toNat + x3.toNat / 2 ^ 51 := by
    rw [← hx4, BitVec.toNat_add, toNat_shift]; omega
  have k5 : x5.toNat = (l 4).toNat + x4.toNat / 2 ^ 51 := by
    rw [← hx5, BitVec.toNat_add, toNat_shift]; omega
  have k6 : x6.toNat = x5.toNat / 2 ^ 51 * 19 + (l 0).toNat % 2 ^ 51 := by
    rw [← hx6, BitVec.toNat_add, BitVec.toNat_mul, toNat_shift, toNat_and_mask,
      show (19 : BitVec 64).toNat = 19 from rfl]
    omega
  have k7 : x7.toNat = x6.toNat / 2 ^ 51 + x2.toNat % 2 ^ 51 := by
    rw [← hx7, BitVec.toNat_add, toNat_shift, toNat_and_mask]; omega
  have ko2 :
    (x7 >>> 51 + (x3 &&& 2251799813685247#64)).toNat = x7.toNat / 2 ^ 51 + x3.toNat % 2 ^ 51 := by
    rw [BitVec.toNat_add, toNat_shift, toNat_and_mask]; omega
  simp only [toNat_and_mask, ko2]
  refine ⟨carry_val k2 k3 k4 k5 k6 k7, ?_, ?_, ?_, ?_, ?_⟩ <;> omega

/-- `fd_f25519_sub` of limbs within `2p`'s: the difference, tight. -/
public theorem fd_f25519_sub.spec_wide {a b : Fin 5 → BitVec 64} (ha : Limbs.Under2p a)
    (hb : Limbs.Under2p b) :
    Limbs.val (fd_f25519_sub.spec a b) = Limbs.val a - Limbs.val b ∧
      Limbs.Tight (fd_f25519_sub.spec a b) := by
  obtain ⟨v, w⟩ := fiat_25519_sub.spec_wide ha hb
  obtain ⟨v', t⟩ := fiat_25519_carry.spec_wide w
  exact ⟨v'.trans v, t⟩

end SubWide

/-! ## `frombytes` -/

section Frombytes

/-- `2`, tight. -/
theorem fd_f25519_two.val : Limbs.val fd_f25519_two.limbs = 2 ∧ Limbs.Tight fd_f25519_two.limbs :=
  ⟨by simp [Limbs.val_eq, fd_f25519_two.limbs], by
    rw [Limbs.tight_iff]; decide⟩

/-- `buf[0] & 1` is `buf`'s parity. -/
theorem low_bit (buf : BitVec 256) :
    ((buf.setWidth 8).setWidth 32 &&& 1#32) = if buf.toNat % 2 = 1 then 1#32 else 0#32 := by
  rw [← ofNat_mod_two]
  apply BitVec.eq_of_toNat_eq
  simp only [BitVec.toNat_and, BitVec.toNat_setWidth, BitVec.toNat_ofNat]
  rw [show (1 : ℕ) % 2 ^ 32 = 1 from rfl, Nat.and_one_is_mod]
  omega

/-- `frombytes`'s canonicity test rejects exactly `s ≥ p` and odd `s`. -/
theorem fd_ristretto255_point_frombytes.check (buf : BitVec 256) :
    ((if buf = fd_f25519_tobytes.spec (fd_f25519_frombytes.spec buf) then 0#32 else 1#32) |||
          ((buf.setWidth 8).setWidth 32 &&& 1#32)) =
        0#32 ↔
      buf.toNat < p ∧ buf.toNat % 2 = 0 := by
  obtain ⟨sv, sb⟩ := fd_f25519_frombytes.spec_val buf
  have ht := fd_f25519_tobytes.spec_val sb.under2p sb.nat_lt
  rw [sv, ZMod.val_natCast] at ht
  have e1 : buf = fd_f25519_tobytes.spec (fd_f25519_frombytes.spec buf) ↔ buf.toNat < p := by
    constructor
    · intro h
      have := congrArg BitVec.toNat h
      rw [ht] at this
      rw [this]; exact Nat.mod_lt _ (by decide)
    · intro h
      apply BitVec.eq_of_toNat_eq
      rw [ht, Nat.mod_eq_of_lt (h.trans (by decide)), Nat.mod_eq_of_lt h]
  rw [low_bit,
    show
      (buf.toNat < p ∧ buf.toNat % 2 = 0) ↔
        (buf = fd_f25519_tobytes.spec (fd_f25519_frombytes.spec buf) ∧ ¬buf.toNat % 2 = 1)
      from ⟨fun h => ⟨e1.2 h.1, by omega⟩, fun h => ⟨e1.1 h.1, by omega⟩⟩]
  by_cases h1 : buf = fd_f25519_tobytes.spec (fd_f25519_frombytes.spec buf)
  · rw [ite_eq_left_of_eq_true _ _ (eq_true h1)]
    by_cases h2 : buf.toNat % 2 = 1
    · rw [ite_eq_left_of_eq_true _ _ (eq_true h2)]
      exact iff_of_false (by decide) (fun h => h.2 h2)
    · rw [ite_eq_right_of_eq_false _ _ (eq_false h2)]
      exact iff_of_true (by decide) ⟨h1, h2⟩
  · rw [ite_eq_right_of_eq_false _ _ (eq_false h1)]
    refine iff_of_false ?_ (fun h => h1 h.1)
    split <;> decide

/-- `frombytes` against RFC 9496 decoding: `NULL` exactly when it rejects, else the decoded
`(x, y)` with `Z = 1`, `T = x y`, `X` within `2p`'s limbs, `Y`, `T`, `Z` tight. -/
theorem fd_ristretto255_point_frombytes.core (buf : BitVec 256) :
    (fd_ristretto255_point_frombytes.spec buf = none ∧ decodeXY buf = none) ∨
      ∃ A,
        fd_ristretto255_point_frombytes.spec buf = some A ∧
          decodeXY buf = some (Limbs.val A.X, Limbs.val A.Y) ∧
          Limbs.val A.Z = 1 ∧
          Limbs.val A.T = Limbs.val A.X * Limbs.val A.Y ∧
          Limbs.Under2p A.X ∧ Limbs.Tight A.Y ∧ Limbs.Tight A.T ∧ Limbs.Tight A.Z := by
  have hchk := fd_ristretto255_point_frombytes.check buf
  unfold decodeXY
  by_cases hc : buf.toNat < p ∧ buf.toNat % 2 = 0
  swap
  · left
    refine ⟨?_, by rw [ite_eq_left_of_eq_true _ _ (eq_true (by omega))]⟩
    simp only [fd_ristretto255_point_frombytes.spec]
    rw [ite_eq_left_of_eq_true _ _ (eq_true (mt hchk.1 hc))]
  rw [ite_eq_right_of_eq_false _ _ (eq_false (by omega))]
  unfold decodeS
  dsimp only
  simp only [fd_ristretto255_point_frombytes.spec]
  rw [ite_eq_right_of_eq_false _ _ (eq_false (not_not.2 (hchk.2 hc)))]
  clear hchk
  obtain ⟨sv, sb⟩ := fd_f25519_frombytes.spec_val buf
  rw [Nat.mod_eq_of_lt (hc.1.trans (by decide))] at sv
  generalize fd_f25519_frombytes.spec buf = s at sv sb ⊢
  generalize (buf.toNat : ZMod p) = S at sv ⊢
  obtain ⟨v1, b1⟩ := fd_f25519_one.val
  obtain ⟨vd, bd⟩ := fd_f25519_d.val
  obtain ⟨v2, b2⟩ := fd_f25519_two.val
  obtain ⟨ssv, ssb⟩ := fd_f25519_sqr.spec_val sb.loose
  generalize fd_f25519_sqr.spec s = ss at ssv ssb ⊢
  obtain ⟨u1v, u1b⟩ := fd_f25519_sub.spec_val b1 ssb.under2p
  generalize fd_f25519_sub.spec fd_f25519_one.limbs ss = u1 at u1v u1b ⊢
  obtain ⟨u2v, u2b⟩ := fd_f25519_add.spec_val b1 ssb
  generalize fd_f25519_add.spec fd_f25519_one.limbs ss = u2 at u2v u2b ⊢
  obtain ⟨u2sv, u2sb⟩ := fd_f25519_sqr.spec_val u2b.loose
  generalize fd_f25519_sqr.spec u2 = u2sq at u2sv u2sb ⊢
  obtain ⟨w1v, w1b⟩ := fd_f25519_sqr.spec_val u1b.loose
  generalize fd_f25519_sqr.spec u1 = w1 at w1v w1b ⊢
  obtain ⟨w2v, w2b⟩ := fd_f25519_mul.spec_val w1b.loose bd.loose
  generalize fd_f25519_mul.spec w1 fd_f25519_d.limbs = w2 at w2v w2b ⊢
  obtain ⟨w3v, w3b, -⟩ := fd_f25519_neg.spec_wide w2b.under2p
  generalize fd_f25519_neg.spec w2 = w3 at w3v w3b ⊢
  obtain ⟨vv, vb⟩ := fd_f25519_sub.spec_wide w3b u2sb.under2p
  generalize fd_f25519_sub.spec w3 u2sq = v at vv vb ⊢
  have hv : Limbs.val v = -(d * (1 - S ^ 2) ^ 2) - (1 + S ^ 2) ^ 2 := by
    rw [vv, w3v, w2v, w1v, u2sv, u1v, u2v, ssv, sv, v1, vd]; ring
  obtain ⟨tv, tb⟩ := fd_f25519_mul.spec_val vb.loose u2sb.loose
  generalize fd_f25519_mul.spec v u2sq = tmp1 at tv tb ⊢
  have htmp : Limbs.val tmp1 = (-(d * (1 - S ^ 2) ^ 2) - (1 + S ^ 2) ^ 2) * (1 + S ^ 2) ^ 2 := by
    rw [tv, hv, u2sv, u2v, ssv, sv, v1]
  obtain ⟨hret, hr, rb, -⟩ := fd_f25519_inv_sqrt.spec_rfc tb
  rw [htmp] at hret hr
  generalize fd_f25519_inv_sqrt.spec tmp1 = R at hret hr rb ⊢
  generalize sqrtRatioM1 1 ((-(d * (1 - S ^ 2) ^ 2) - (1 + S ^ 2) ^ 2) * (1 + S ^ 2) ^ 2) =
    Q at hret hr ⊢
  have hu1 : Limbs.val u1 = 1 - S ^ 2 := by rw [u1v, ssv, sv, v1]
  have hu2 : Limbs.val u2 = 1 + S ^ 2 := by rw [u2v, ssv, sv, v1]
  obtain ⟨dxv, dxb⟩ := fd_f25519_mul.spec_val rb.loose u2b.loose
  generalize fd_f25519_mul.spec R.r u2 = den_x at dxv dxb ⊢
  obtain ⟨dyv, dyb⟩ := fd_f25519_mul.spec_val rb.loose dxb.loose
  generalize fd_f25519_mul.spec R.r den_x = den_y at dyv dyb ⊢
  obtain ⟨dy'v, dy'b⟩ := fd_f25519_mul.spec_val dyb.loose vb.loose
  generalize fd_f25519_mul.spec den_y v = den_y' at dy'v dy'b ⊢
  obtain ⟨t0v, t0b⟩ := fd_f25519_mul.spec_val b2.loose sb.loose
  generalize fd_f25519_mul.spec fd_f25519_two.limbs s = t0 at t0v t0b ⊢
  obtain ⟨t0'v, t0'b⟩ := fd_f25519_mul.spec_val t0b.loose dxb.loose
  generalize fd_f25519_mul.spec t0 den_x = t0' at t0'v t0'b ⊢
  have xv := fd_f25519_abs.spec_ctAbs t0'b
  obtain ⟨-, -, xb, xn, -⟩ := fd_f25519_abs.spec_val t0'b
  generalize fd_f25519_abs.spec t0' = x at xv xb xn ⊢
  obtain ⟨yv, yb⟩ := fd_f25519_mul.spec_val u1b.loose dy'b.loose
  generalize fd_f25519_mul.spec u1 den_y' = y at yv yb ⊢
  obtain ⟨ttv, ttb⟩ := fd_f25519_mul.spec_val xb.loose yb.loose
  generalize fd_f25519_mul.spec x y = t at ttv ttb ⊢
  have hX : Limbs.val x = ctAbs (2 * S * (Q.2 * (1 + S ^ 2))) := by
    rw [xv, t0'v, t0v, dxv, v2, sv, hr, hu2]
  have hY : Limbs.val y = (1 - S ^ 2) * (Q.2 * (Q.2 * (1 + S ^ 2)) * Limbs.val v) := by
    rw [yv, dy'v, dyv, dxv, hr, hu1, hu2]
  rw [fd_f25519_sgn.spec_isNeg ttb.under2p ttb.nat_lt,
    fd_f25519_is_zero.spec_val yb.under2p yb.nat_lt, hret, ttv]
  have hnw :
    (if (if Q.1 = true then 1#32 else 0#32) = 0#32 then 1#32 else 0#32) =
      if Q.1 = false then 1#32 else 0#32 := by
    cases Q.1 <;> rfl
  rw [hnw, ite_or_ite, ite_or_ite, ← hX, ← hv, ← hY]
  by_cases hcond : (Q.1 = false ∨ IsNeg (Limbs.val x * Limbs.val y)) ∨ Limbs.val y = 0
  · left
    rw [ite_eq_left_of_eq_true _ _ (eq_true hcond)]
    exact
      ⟨ite_eq_left_of_eq_true _ _ (eq_true (by decide)),
        ite_eq_left_of_eq_true _ _ (eq_true (by tauto))⟩
  · right
    rw [ite_eq_right_of_eq_false _ _ (eq_false hcond)]
    refine ⟨_, ite_eq_right_of_eq_false _ _ (eq_false (by decide)), ?_, v1, ttv, xb, yb, ttb, b1⟩
    rw [ite_eq_right_of_eq_false _ _ (eq_false (by tauto))]

/-- `frombytes` fails exactly when RFC 9496 decoding rejects. -/
public theorem fd_ristretto255_point_frombytes.spec_eq_none_iff (buf : BitVec 256) :
    fd_ristretto255_point_frombytes.spec buf = none ↔ Ristretto.decode buf = none := by
  rw [Ristretto.decode_eq_none]
  rcases fd_ristretto255_point_frombytes.core buf with ⟨h1, h2⟩ | ⟨A, h1, h2, -⟩
  · simp [h1, h2]
  · simp [h1, h2]

/-- A point `frombytes` returns represents RFC 9496's decoding of `buf`, with `Z = 1`. -/
public theorem fd_ristretto255_point_frombytes.spec_rep {buf : BitVec 256} {A : PointLimbs}
    (h : fd_ristretto255_point_frombytes.spec buf = some A) :
    ∃ P, Ristretto.decode buf = some P ∧ A.Rep P ∧ Limbs.val A.Z = 1 := by
  rcases fd_ristretto255_point_frombytes.core buf with ⟨h1, -⟩ |
    ⟨A', h1, h2, hZ, hT, bX, bY, bT, bZ⟩
  · rw [h1] at h; cases h
  rw [h1, Option.some.injEq] at h
  subst h
  obtain ⟨hb, he, hc, hcan⟩ := decodeXY_eq_some.1 h2
  refine
    ⟨⟨_, _, hc⟩, Ristretto.decode_eq_some.2 ⟨hb, he, hcan⟩, ⟨⟨?_, ?_, ?_, ?_⟩, bX, bY, bT, bZ⟩, hZ⟩
  · rw [hZ]; exact one_ne_zero
  · rw [hZ, mul_one]
  · rw [hZ, mul_one]
  · rw [hZ, mul_one, hT]

/-- `validate` is `1` exactly when RFC 9496 decoding accepts. -/
public theorem fd_ristretto255_point_validate.spec_decode (buf : BitVec 256) :
    fd_ristretto255_point_validate.spec buf =
      if (Ristretto.decode buf).isSome then 1#32 else 0#32 := by
  unfold fd_ristretto255_point_validate.spec
  by_cases h : Ristretto.decode buf = none
  · rw [(fd_ristretto255_point_frombytes.spec_eq_none_iff buf).2 h, h]; rfl
  · have h' := mt (fd_ristretto255_point_frombytes.spec_eq_none_iff buf).1 h
    rw [Option.isSome_iff_ne_none.2 h, Option.isSome_iff_ne_none.2 h']

end Frombytes

/-! ## `tobytes` -/

section Tobytes

/-- `fd_f25519_invsqrt_a_minus_d` is `1/√(a - d)`, tight. -/
theorem fd_f25519_invsqrt_a_minus_d.val :
    Limbs.val fd_f25519_invsqrt_a_minus_d.limbs = invsqrtAMinusD ∧
      Limbs.Tight fd_f25519_invsqrt_a_minus_d.limbs := by
  refine
    ⟨?_, by
      rw [Limbs.tight_iff]; decide⟩
  rw [Limbs.val_eq]
  unfold invsqrtAMinusD
  simp [fd_f25519_invsqrt_a_minus_d.limbs]
  reduce_mod_char

/-- `tobytes` of `abs` on tight limbs: `CT_ABS` of the value, as bytes. -/
theorem tobytes_abs {a : Fin 5 → BitVec 64} (ha : Limbs.Tight a) :
    fd_f25519_tobytes.spec (fd_f25519_abs.spec a) = BitVec.ofNat 256 (ctAbs (Limbs.val a)).val := by
  obtain ⟨-, -, b, n, -⟩ := fd_f25519_abs.spec_val ha
  apply BitVec.eq_of_toNat_eq
  rw [fd_f25519_tobytes.spec_val b n, fd_f25519_abs.spec_ctAbs ha, BitVec.toNat_ofNat,
    Nat.mod_eq_of_lt ((ZMod.val_lt _).trans (by decide))]

/-- `tobytes` computes RFC 9496's encoding of the extended coordinates' values, for `X` within
`2p`'s limbs and `Y`, `T`, `Z` tight. -/
public theorem fd_ristretto255_point_tobytes.spec_eq {A : PointLimbs} (hX : Limbs.Under2p A.X)
    (hY : Limbs.Tight A.Y) (hT : Limbs.Tight A.T) (hZ : Limbs.Tight A.Z) :
    fd_ristretto255_point_tobytes.spec A =
      encodeExt (Limbs.val A.X) (Limbs.val A.Y) (Limbs.val A.Z) (Limbs.val A.T) := by
  unfold fd_ristretto255_point_tobytes.spec encodeExt encodeExtS
  dsimp only
  generalize A.X = x at hX ⊢
  generalize A.Y = y at hY ⊢
  generalize A.Z = z at hZ ⊢
  generalize A.T = t at hT ⊢
  obtain ⟨sv, sb⟩ := fd_f25519_sqrtm1.val
  obtain ⟨cv, cb⟩ := fd_f25519_invsqrt_a_minus_d.val
  obtain ⟨t0v, t0b⟩ := fd_f25519_add.spec_val hZ hY
  generalize fd_f25519_add.spec z y = tmp0 at t0v t0b ⊢
  obtain ⟨t1v, t1b⟩ := fd_f25519_sub.spec_val hZ hY.under2p
  generalize fd_f25519_sub.spec z y = tmp1 at t1v t1b ⊢
  obtain ⟨u1v, u1b⟩ := fd_f25519_mul.spec_val t0b.loose t1b.loose
  generalize fd_f25519_mul.spec tmp0 tmp1 = u1 at u1v u1b ⊢
  obtain ⟨u2v, u2b⟩ := fd_f25519_mul.spec_val hX.loose hY.loose
  generalize fd_f25519_mul.spec x y = u2 at u2v u2b ⊢
  obtain ⟨u2sv, u2sb⟩ := fd_f25519_sqr.spec_val u2b.loose
  generalize fd_f25519_sqr.spec u2 = u2sq at u2sv u2sb ⊢
  obtain ⟨wv, wb⟩ := fd_f25519_mul.spec_val u1b.loose u2sb.loose
  generalize fd_f25519_mul.spec u1 u2sq = w at wv wb ⊢
  obtain ⟨-, hr, rb, -⟩ := fd_f25519_inv_sqrt.spec_rfc wb
  generalize (fd_f25519_inv_sqrt.spec w).r = r at hr rb ⊢
  rw [wv, u2sv] at hr
  rw [← t0v, ← t1v, ← u1v, ← u2v, ← hr]
  obtain ⟨d1v, d1b⟩ := fd_f25519_mul.spec_val rb.loose u1b.loose
  generalize fd_f25519_mul.spec r u1 = den1 at d1v d1b ⊢
  obtain ⟨d2v, d2b⟩ := fd_f25519_mul.spec_val rb.loose u2b.loose
  generalize fd_f25519_mul.spec r u2 = den2 at d2v d2b ⊢
  obtain ⟨z0v, z0b⟩ := fd_f25519_mul.spec_val d1b.loose d2b.loose
  generalize fd_f25519_mul.spec den1 den2 = zi0 at z0v z0b ⊢
  obtain ⟨ziv, zib⟩ := fd_f25519_mul.spec_val z0b.loose hT.loose
  generalize fd_f25519_mul.spec zi0 t = zi at ziv zib ⊢
  obtain ⟨ixv, ixb⟩ := fd_f25519_mul.spec_val hX.loose sb.loose
  generalize fd_f25519_mul.spec x fd_f25519_sqrtm1.limbs = ix0 at ixv ixb ⊢
  obtain ⟨iyv, iyb⟩ := fd_f25519_mul.spec_val hY.loose sb.loose
  generalize fd_f25519_mul.spec y fd_f25519_sqrtm1.limbs = iy0 at iyv iyb ⊢
  obtain ⟨env, enb⟩ := fd_f25519_mul.spec_val d1b.loose cb.loose
  generalize fd_f25519_mul.spec den1 fd_f25519_invsqrt_a_minus_d.limbs = en at env enb ⊢
  obtain ⟨rov, rob⟩ := fd_f25519_mul.spec_val hT.loose zib.loose
  generalize fd_f25519_mul.spec t zi = ro at rov rob ⊢
  rw [← d1v, ← d2v, ← z0v, ← ziv, ← rov, fd_f25519_sgn.spec_isNeg rob.under2p rob.nat_lt]
  simp only [fd_f25519_if.spec_ite]
  rw [← sv, ← ixv, ← iyv, ← cv, ← env]
  by_cases hro : IsNeg (Limbs.val ro)
  · simp only [hro, ↓reduceIte]
    obtain ⟨nv, nb⟩ := fd_f25519_mul.spec_val iyb.loose zib.loose
    rw [← nv, fd_f25519_sgn.spec_isNeg nb.under2p nb.nat_lt]
    generalize fd_f25519_mul.spec iy0 zi = ng at nv nb ⊢
    simp only [fd_f25519_if.spec_ite]
    by_cases hn : IsNeg (Limbs.val ng)
    · simp only [hn, ↓reduceIte]
      obtain ⟨yv, yb⟩ := fd_f25519_neg.spec_val ixb
      have yb' := fd_f25519_neg.spec_under2p ixb
      obtain ⟨sv', sb'⟩ := fd_f25519_sub.spec_val hZ yb'
      obtain ⟨mv, mb⟩ := fd_f25519_mul.spec_val sb'.loose enb.loose
      rw [tobytes_abs mb, mv, sv', yv, mul_comm]
    · simp only [hn, ↓reduceIte]
      obtain ⟨sv', sb'⟩ := fd_f25519_sub.spec_val hZ ixb.under2p
      obtain ⟨mv, mb⟩ := fd_f25519_mul.spec_val sb'.loose enb.loose
      rw [tobytes_abs mb, mv, sv', mul_comm]
  · simp only [hro, ↓reduceIte]
    obtain ⟨nv, nb⟩ := fd_f25519_mul.spec_val hX.loose zib.loose
    rw [← nv, fd_f25519_sgn.spec_isNeg nb.under2p nb.nat_lt]
    generalize fd_f25519_mul.spec x zi = ng at nv nb ⊢
    simp only [fd_f25519_if.spec_ite]
    by_cases hn : IsNeg (Limbs.val ng)
    · simp only [hn, ↓reduceIte]
      obtain ⟨yv, yb⟩ := fd_f25519_neg.spec_val hY
      have yb' := fd_f25519_neg.spec_under2p hY
      obtain ⟨sv', sb'⟩ := fd_f25519_sub.spec_val hZ yb'
      obtain ⟨mv, mb⟩ := fd_f25519_mul.spec_val sb'.loose d2b.loose
      rw [tobytes_abs mb, mv, sv', yv, mul_comm]
    · simp only [hn, ↓reduceIte]
      obtain ⟨sv', sb'⟩ := fd_f25519_sub.spec_val hZ hY.under2p
      obtain ⟨mv, mb⟩ := fd_f25519_mul.spec_val sb'.loose d2b.loose
      rw [tobytes_abs mb, mv, sv', mul_comm]

/-- `tobytes` on a representative of `P` is RFC 9496's encoding of `P`. -/
public theorem fd_ristretto255_point_tobytes.spec_rep {A : PointLimbs} {P : Ed25519.Point}
    (hA : A.Rep P) : fd_ristretto255_point_tobytes.spec A = Ristretto.encode P := by
  obtain ⟨⟨hZ, eX, eY, eT⟩, bX, bY, bT, bZ⟩ := hA
  have eT' : Limbs.val A.T = P.x * P.y * Limbs.val A.Z :=
    mul_right_cancel₀ hZ
      (by
        rw [eT, eX, eY]; ring)
  rw [fd_ristretto255_point_tobytes.spec_eq bX bY bT bZ, eX, eY, eT']
  unfold Ristretto.encode encodeExt
  rw [encodeExtS_scale hZ]

end Tobytes

/-! ## `eq`, `eq_neg` -/

section Eq

/-- The cross products `eq` compares, on representatives, are RFC 9496's equality. -/
theorem cross_iff {A B : PointLimbs} {P Q : Ed25519.Point} (hA : A.Rep P) (hB : B.Rep Q)
    (sx : ZMod p) :
    ((sx * Limbs.val A.Z) * Limbs.val B.Y = Limbs.val B.X * Limbs.val A.Y ∨
        (sx * Limbs.val A.Z) * Limbs.val B.X = Limbs.val A.Y * Limbs.val B.Y) ↔
      sx * Q.y = P.y * Q.x ∨ P.y * Q.y = sx * Q.x := by
  obtain ⟨⟨hZ, -, eY, -⟩, -⟩ := hA
  obtain ⟨⟨hZ', eX', eY', -⟩, -⟩ := hB
  rw [eY, eX', eY']
  have h := mul_ne_zero hZ hZ'
  constructor
  · rintro (e | e)
    · exact .inl (mul_right_cancel₀ h (by linear_combination e))
    · exact .inr (mul_right_cancel₀ h (by linear_combination -e))
  · rintro (e | e)
    · exact .inl (by linear_combination (Limbs.val A.Z * Limbs.val B.Z) * e)
    · exact .inr (by linear_combination -(Limbs.val A.Z * Limbs.val B.Z) * e)

open Classical in
/-- `eq` on representatives of `P`, `Q`: `1` exactly when `P - Q ∈ E[4]`. -/
public theorem fd_ristretto255_point_eq.spec_rep {A B : PointLimbs} {P Q : Ed25519.Point}
    (hA : A.Rep P) (hB : B.Rep Q) :
    fd_ristretto255_point_eq.spec A B = if P - Q ∈ E4 then 1#32 else 0#32 := by
  obtain ⟨v1, b1⟩ := fd_f25519_mul.spec_val hA.2.1.loose hB.2.2.1.loose
  obtain ⟨v2, b2⟩ := fd_f25519_mul.spec_val hB.2.1.loose hA.2.2.1.loose
  obtain ⟨v3, b3⟩ := fd_f25519_mul.spec_val hA.2.1.loose hB.2.1.loose
  obtain ⟨v4, b4⟩ := fd_f25519_mul.spec_val hA.2.2.1.loose hB.2.2.1.loose
  unfold fd_ristretto255_point_eq.spec
  dsimp only
  rw [fd_f25519_eq.spec_val b1 b2.under2p, fd_f25519_eq.spec_val b3 b4.under2p, ite_or_ite, v1, v2,
    v3, v4]
  have h := cross_iff hA hB P.x
  rw [← hA.1.2.1] at h
  simp only [h, rfcEq_iff]

open Classical in
/-- `eq_neg` on representatives of `P`, `Q`: `1` exactly when `-P - Q ∈ E[4]`. -/
public theorem fd_ristretto255_point_eq_neg.spec_rep {A B : PointLimbs} {P Q : Ed25519.Point}
    (hA : A.Rep P) (hB : B.Rep Q) :
    fd_ristretto255_point_eq_neg.spec A B = if -P - Q ∈ E4 then 1#32 else 0#32 := by
  obtain ⟨nv, nb, -⟩ := fd_f25519_neg.spec_wide hA.2.1
  obtain ⟨v1, b1⟩ := fd_f25519_mul.spec_val nb.loose hB.2.2.1.loose
  obtain ⟨v2, b2⟩ := fd_f25519_mul.spec_val hB.2.1.loose hA.2.2.1.loose
  obtain ⟨v3, b3⟩ := fd_f25519_mul.spec_val nb.loose hB.2.1.loose
  obtain ⟨v4, b4⟩ := fd_f25519_mul.spec_val hA.2.2.1.loose hB.2.2.1.loose
  unfold fd_ristretto255_point_eq_neg.spec
  dsimp only
  rw [fd_f25519_eq.spec_val b1 b2.under2p, fd_f25519_eq.spec_val b3 b4.under2p, ite_or_ite, v1, v2,
    v3, v4, nv]
  have h := cross_iff hA hB (-P.x)
  rw [show -P.x * Limbs.val A.Z = -Limbs.val A.X by
      rw [hA.1.2.1]; ring] at h
  have e := rfcEq_iff (-P) Q
  simp only [Point.neg_x, Point.neg_y] at e
  simp only [h, e]

end Eq

end MLIR.Firedancer.Ref
