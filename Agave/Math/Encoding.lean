module

public import Ed25519.Encode

/-! Compressed points: Dalek's `compress` writes `Ed25519.encode`; a decoding with `y < p` and
`x ≠ 0` is the encoding. -/

namespace MLIR.Agave

open _root_.Ed25519

/-! ## Definitions -/

@[expose] public section

/-- `b`'s `y` field, its low 255 bits, is below `p`. -/
def CanonicalY (b : BitVec 256) : Prop :=
  b.toNat % 2 ^ 255 < p

instance : DecidablePred CanonicalY := fun _ => inferInstanceAs (Decidable (_ < _))

end

public theorem canonicalY_encode (P : Point) : CanonicalY (encode P) := by
  rw [CanonicalY, encode_mod]
  exact ZMod.val_lt _

/-! ## Uniqueness -/

/-- An encoding with `y < p` that decodes to a point with `x ≠ 0` is that point's encoding. -/
public theorem encode_eq_of_decodes {b : BitVec 256} {P : Point} (h : Decodes b P)
    (hb : CanonicalY b) (hx : P.x ≠ 0) : encode P = b := by
  apply BitVec.eq_of_toNat_eq
  have hy : P.y.val = b.toNat % 2 ^ 255 := by rw [h.1, ZMod.val_natCast, Nat.mod_eq_of_lt hb]
  have hs : P.x.val % 2 = b.toNat / 2 ^ 255 := h.2.resolve_left hx
  rw [toNat_encode, hy, hs, Nat.mod_add_div]

/-- For `x ≠ 0`, `encode P` is the one encoding of `P` with `y < p`. -/
public theorem encode_eq_iff_decodes {b : BitVec 256} {P : Point} (hx : P.x ≠ 0) :
    encode P = b ↔ Decodes b P ∧ CanonicalY b := by
  constructor
  · rintro rfl
    exact ⟨decodes_encode P, canonicalY_encode P⟩
  · rintro ⟨h, hb⟩
    exact encode_eq_of_decodes h hb hx

end MLIR.Agave
