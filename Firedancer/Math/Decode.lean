module

public import Firedancer.Math.Verify
import Mathlib.NumberTheory.LegendreSymbol.Basic
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

/-! Point decompression's algebra: the candidate square root, the curve's `x` for a `y`, and the
`is_nonzero`/sign flags a decoder combines. -/

namespace MLIR.Firedancer.Ref

public section

/-- The candidate root `x = u v³ (u v⁷)^((p-5)/8)` has `v x² = ±u` exactly when `u / v` is a
square. -/
theorem sqrt_ratio_iff {u v x : ZMod p} (hv : v ≠ 0)
    (hx : x = u * v ^ 3 * (u * v ^ 7) ^ ((p - 5) / 8)) :
    (v * x ^ 2 = u ∨ v * x ^ 2 = -u) ↔ IsSquare (u / v) := by
  by_cases hu : u = 0
  · subst hu
    simp only [hx, zero_mul, ne_eq, OfNat.ofNat_ne_zero, not_false_eq_true, zero_pow,
      mul_zero, true_or, zero_div, true_iff]
    exact ⟨0, by ring⟩
  have hw : u * v ^ 7 ≠ 0 := mul_ne_zero hu (pow_ne_zero _ hv)
  set c := (u * v ^ 7) ^ ((p - 1) / 4) with hc
  have hcheck : v * x ^ 2 = u * c := by
    rw [hc, show (p - 1) / 4 = 2 * ((p - 5) / 8) + 1 by norm_num, pow_succ (u * v ^ 7),
      pow_mul (u * v ^ 7), hx]
    ring
  have hc2 : c ^ 2 = (u * v ^ 7) ^ (p / 2) := by
    rw [hc, ← pow_mul]
    norm_num
  have hsq := (isSquare_div_iff (u := u) hv).trans (ZMod.euler_criterion p hw)
  rw [hcheck, hsq, ← hc2, sq_eq_one_iff']
  constructor
  · rintro (h | h)
    · exact .inl (mul_left_cancel₀ hu (by rw [h, mul_one]))
    · exact .inr (mul_left_cancel₀ hu (by rw [h]; ring))
  · rintro (h | h)
    · exact .inl (by rw [h, mul_one])
    · exact .inr (by rw [h]; ring)

/-- Two `is_nonzero` flags' `&` is zero exactly when one of them is. -/
theorem flags_and_eq_zero {A B : Prop} [Decidable A] [Decidable B] :
    ((if A then (0 : BitVec 32) else 1) &&& if B then 0 else 1) = 0#32 ↔ A ∨ B := by
  by_cases A <;> by_cases B <;> simp [*]

/-- `BitVec.ofNat 32` is injective on bits. -/
theorem ofNat_bit_inj {a b : ℕ} (ha : a < 2) (hb : b < 2) :
    BitVec.ofNat 32 a = BitVec.ofNat 32 b ↔ a = b := by
  constructor
  · intro h
    have := congrArg BitVec.toNat h
    simp only [BitVec.toNat_ofNat] at this
    omega
  · rintro rfl; rfl

/-- `-1` is no bit. -/
theorem neg_one_ne_bit {b : ℕ} (hb : b < 2) : (-1 : BitVec 32) ≠ BitVec.ofNat 32 b := by
  match b, hb with
  | 0, _ | 1, _ => decide

namespace Ed25519

/-- `v = d y² + 1` is never zero. -/
theorem v_ne (y : ZMod p) : Ref.Ed25519.d * y ^ 2 + 1 ≠ 0 := by
  intro h
  exact Ref.Ed25519.one_add_ne 1 y (by linear_combination h)

/-- A point with `y` exists exactly when `(y² - 1) / (d y² + 1)` is a square. -/
theorem exists_onCurve_iff (y : ZMod p) :
    (∃ x, OnCurve x y) ↔ IsSquare ((y ^ 2 - 1) / (Ref.Ed25519.d * y ^ 2 + 1)) := by
  simp only [Ref.Ed25519.onCurve_iff, IsSquare, div_eq_iff (v_ne y)]
  constructor <;> rintro ⟨r, hr⟩ <;> exact ⟨r, by linear_combination -hr⟩

/-- `decode` finds a point that decodes. -/
theorem decodes_of_decode {buf : BitVec 256} {P : Ref.Ed25519.Point}
    (h : decode buf = some P) : Decodes buf P := by
  by_cases hex : ∃ P, Decodes buf P
  · obtain ⟨Q, hQ⟩ := hex
    rw [Ref.Ed25519.decode_eq_some hQ, Option.some.injEq] at h
    exact h ▸ hQ
  · rw [Ref.Ed25519.decode_eq_none.2 fun P hP => hex ⟨P, hP⟩] at h
    exact absurd h (by simp)

end Ed25519

end

end MLIR.Firedancer.Ref
