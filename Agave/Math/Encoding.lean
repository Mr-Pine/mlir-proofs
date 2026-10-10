module

public import Boringssl.Math.Encode

/-! Compressed points: Dalek's `compress` writes `Ed25519.encode` (`y < p`, then `x`'s parity in
bit 255); its fields, and its uniqueness: a decoding with `y < p` and `x ≠ 0` is the encoding. -/

namespace MLIR.Agave

open _root_.Ed25519

/-! ## Definitions -/

@[expose] public section

/-- `b`'s `y` field, its low 255 bits, is below `p`. -/
def CanonicalY (b : BitVec 256) : Prop :=
  b.toNat % 2 ^ 255 < p

instance : DecidablePred CanonicalY := fun _ => inferInstanceAs (Decidable (_ < _))

end

/-! ## The encoding's fields -/

theorem val_lt_two_pow (x : ZMod p) : x.val < 2 ^ 255 :=
  (ZMod.val_lt x).trans (by decide)

public theorem toNat_encode (P : Point) : (encode P).toNat = P.y.val + 2 ^ 255 * (P.x.val % 2) := by
  have := val_lt_two_pow P.y
  have := Nat.mod_lt P.x.val (by decide : 0 < 2)
  rw [encode, BitVec.toNat_ofNat, Nat.mod_eq_of_lt (by omega)]

/-- The low 255 bits are `y`. -/
public theorem encode_mod (P : Point) : (encode P).toNat % 2 ^ 255 = P.y.val := by
  rw [toNat_encode, Nat.add_mul_mod_self_left, Nat.mod_eq_of_lt (val_lt_two_pow _)]

/-- Bit 255 is `x`'s parity. -/
public theorem encode_div (P : Point) : (encode P).toNat / 2 ^ 255 = P.x.val % 2 := by
  rw [toNat_encode, Nat.add_mul_div_left _ _ (by decide), Nat.div_eq_of_lt (val_lt_two_pow _),
    zero_add]

public theorem canonicalY_encode (P : Point) : CanonicalY (encode P) := by
  rw [CanonicalY, encode_mod]
  exact ZMod.val_lt _

public theorem decodes_encode (P : Point) : Decodes (encode P) P :=
  ⟨by rw [encode_mod, ZMod.natCast_zmod_val], .inr (encode_div P).symm⟩

public theorem decode_encode (P : Point) : decode (encode P) = some P :=
  decode_eq_some (decodes_encode P)

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

/-- Distinct points have distinct encodings. -/
public theorem encode_injective : Function.Injective encode := fun P Q h =>
  Option.some.inj ((decode_encode P).symm.trans (h ▸ decode_encode Q))

end MLIR.Agave
