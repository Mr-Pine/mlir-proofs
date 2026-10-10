module

/-! The order `ℓ` of the base point. -/

namespace Ed25519

@[expose] public section

/-- `ℓ = 2^252 + 27742317777372353535851937790883648493`, the order of edwards25519's prime-order
subgroup. -/
def ell : Nat :=
  2 ^ 252 + 27742317777372353535851937790883648493

end

/-- `ℓ` fits in 253 bits. -/
public theorem ell_lt : ell < 2 ^ 253 := by
  unfold ell; omega

end Ed25519
