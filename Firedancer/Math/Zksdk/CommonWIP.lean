module

public import Firedancer.Math.Zksdk.Common

/-! Unproved: `Dom / E[4]` has exponent `ℓ` (`PrimeOrder`).

Every verifier theorem in `Zksdk/` takes `[PrimeOrder]`: it is what makes `ZMod ℓ` act on the
ristretto group, so that the MSM's `(a b + c) mod ℓ` scalars can be read as the textbook equations'
`a b + c`. It follows from `#E(F_p) = 8ℓ` (with `Dom = 2E`, `RistrettoWIP.lean`): `2E ≅ Z/4 × Z/ℓ`
and `ℓ • 2E = E[4]`. What is proved is only `ℓ • B = 0` for the base point
(`Ed25519.ell_smul_basePoint`); bounding `#E` needs Hasse's theorem or a point count, neither
available here. `ScalarOps`, `EllPrime` and `Zksdk/Process` do not use it; in the verifier proofs it
enters only through the `Module` instance and `nsmul_eq_smul` (in `msm_eq_iff`). -/

namespace Ed25519.Ristretto

/-- `ℓ` kills `Dom` modulo `E[4]`. -/
public theorem primeOrder : PrimeOrder := by
  constructor
  intro P _
  sorry

end Ed25519.Ristretto
