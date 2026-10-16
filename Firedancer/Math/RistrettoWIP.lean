module

public import Firedancer.Math.Ristretto

/-! Unproved: `Dom` is exactly `2E`.

The ristretto results are proved on `Dom` (points with `1 - y²` a square), which contains `2E`
(`two_nsmul_mem_Dom`), `E[4]` and every decoded point, and is closed under the group law. RFC 9496
works on `2E`; equality needs halving a point of `Dom`, i.e. the 2-descent for `E(F_p) ≅ Z/8 × Z/ℓ`
(explicit halves need a square root chosen by a non-square discriminant), not done here. Nothing
else depends on this statement. -/

namespace Ed25519.Ristretto

/-- Every point of `Dom` is a double. -/
public theorem mem_Dom_iff_two_nsmul {P : Point} : P ∈ Dom ↔ ∃ Q, P = 2 • Q := by
  constructor
  · intro _
    sorry
  · rintro ⟨Q, rfl⟩
    exact two_nsmul_mem_Dom Q

end Ed25519.Ristretto
