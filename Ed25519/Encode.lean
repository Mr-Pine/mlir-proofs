module

public import Ed25519.Verify

/-! The canonical encoding of a point (RFC 8032 §5.1.2): `y` (below `p`) in the low 255 bits, the
parity of `x` on top. The strict decodings are exactly its inverses. -/

namespace Ed25519

/-! ## Definitions -/

@[expose] public section

/-- `P`'s encoding: `y` (below `p`) in the low 255 bits, the parity of `x` on top. -/
def encode (P : Point) : BitVec 256 :=
  BitVec.ofNat 256 (P.y.val + 2 ^ 255 * (P.x.val % 2))

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

/-! ## Encoding inverts decoding -/

public theorem decodes_encode (P : Point) : Decodes (encode P) P :=
  ⟨by rw [encode_mod, ZMod.natCast_zmod_val], .inr (encode_div P).symm⟩

public theorem decode_encode (P : Point) : decode (encode P) = some P :=
  decode_eq_some (decodes_encode P)

/-- `P` strictly decodes from its encoding. -/
public theorem decodeStrict_encode (P : Point) : decodeStrict (encode P) = some P := by
  rw [decodeStrict_eq_some_iff, encode_mod, encode_div]
  refine ⟨decode_encode P, ZMod.val_lt P.y, ?_⟩
  rintro ⟨h0, h1⟩
  rw [h0, ZMod.val_zero] at h1
  exact absurd h1 (by decide)

/-- A bit vector is `P`'s encoding exactly when it strictly decodes to `P`. -/
public theorem encode_eq_iff {P : Point} {b : BitVec 256} :
    encode P = b ↔ decodeStrict b = some P := by
  refine ⟨fun h => h ▸ decodeStrict_encode P, fun h => ?_⟩
  obtain ⟨hd, hc, hs⟩ := decodeStrict_eq_some_iff.1 h
  obtain ⟨hy, hpar⟩ := decodes_of_decode hd
  have hb := b.isLt
  have hval : P.y.val = b.toNat % 2 ^ 255 := by rw [hy, ZMod.val_natCast, Nat.mod_eq_of_lt hc]
  have htop : P.x.val % 2 = b.toNat / 2 ^ 255 := by
    rcases hpar with h0 | h0
    · rw [h0, ZMod.val_zero]
      have : b.toNat / 2 ^ 255 < 2 := by omega
      have : b.toNat / 2 ^ 255 ≠ 1 := fun h1 => hs ⟨h0, h1⟩
      omega
    · exact h0
  apply BitVec.eq_of_toNat_eq
  rw [toNat_encode, hval, htop]
  omega

/-- Distinct points have distinct encodings. -/
public theorem encode_injective : Function.Injective encode := fun P Q h =>
  Option.some.inj ((decode_encode P).symm.trans (h ▸ decode_encode Q))

end Ed25519
