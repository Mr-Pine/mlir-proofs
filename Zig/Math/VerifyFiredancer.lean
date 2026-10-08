module

public import Zig.Math.Verify
public import Firedancer.Math.Verify
import Mathlib.Tactic.LinearCombination

/-! Zig's cofactored `verify` accepts what Firedancer's cofactorless one accepts, for canonical
`R`. -/

namespace LeanMLIR.RIR.Zig

open _root_.Ed25519

/-- A point with `x = 0`, `(0, ±1)`, has order at most 2. -/
public theorem Point.two_nsmul_of_x_eq_zero {P : Point} (hx : P.x = 0) : 2 • P = 0 := by
  have hy : P.y ^ 2 = 1 := by
    have h := P.on
    unfold OnCurve at h
    rw [hx] at h
    linear_combination h
  rw [two_nsmul, Point.ext_iff]
  refine ⟨?_, ?_⟩
  · rw [Point.add_x]; simp [Ed25519.add, hx]
  · rw [Point.add_y]; simp [Ed25519.add, hx, ← sq, hy]

/-- Firedancer accepting a signature with canonical `r`, Zig accepts it, given no point of order
16. -/
public theorem verify_of_firedancer (h16 : ∀ P : Point, (32 • P).x = 0 → 8 • P = 0)
    {msg : List (BitVec 8)} {r S A : BitVec 256} (hr : r.toNat % 2 ^ 255 < p)
    (h : Firedancer.Ref.Ed25519.verify msg r S A = 0#32) : verify msg r S A = 0#32 := by
  unfold Firedancer.Ref.Ed25519.verify at h
  unfold verify
  by_cases hS : ell ≤ S.toNat
  · simp only [hS, ↓reduceIte] at h; exact absurd h (by decide)
  simp only [hS, ↓reduceIte] at h ⊢
  rcases hA : decode A with _ | PA <;> rcases hR : decode r with _ | PR <;>
    simp only [hA, hR] at h ⊢ <;>
    try exact absurd h (by decide)
  have h8 {P : Point} (hP : ¬8 • P = 0) : P.x ≠ 0 := fun hx =>
    hP
      (by
        rw [show (8 : ℕ) = 2 * 4 from rfl, mul_nsmul, Point.two_nsmul_of_x_eq_zero hx, nsmul_zero])
  split_ifs at h with hA8 hR8 heq
  · exact absurd h (by decide)
  · exact absurd h (by decide)
  · have h32 : (32 • PA).x ≠ 0 := fun h32 => hA8 (h16 PA h32)
    simp only [h8 hA8, not_le.mpr hr, h8 hR8, h32, heq, smul_add, ↓reduceIte]
  · exact absurd h (by decide)

end LeanMLIR.RIR.Zig
