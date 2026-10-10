module

public import Ed25519.Verify

/-! The canonical encoding of a point (RFC 8032 §5.1.2), as `x25519_ge_tobytes` and
`ge25519_tobytes` compute it: the strict decodings are exactly its inverses. -/

namespace Ed25519

/-! ## Definitions -/

@[expose] public section

/-- `P`'s encoding: `y` (below `p`) in the low 255 bits, the parity of `x` on top. -/
def encode (P : Point) : BitVec 256 :=
  BitVec.ofNat 256 (P.y.val + 2 ^ 255 * (P.x.val % 2))

end

/-! ## Encoding inverts strict decoding -/

theorem toNat_encode (P : Point) : (encode P).toNat = P.y.val + 2 ^ 255 * (P.x.val % 2) := by
  have hy : P.y.val < 2 ^ 255 - 19 := ZMod.val_lt P.y
  have hx : P.x.val % 2 < 2 := Nat.mod_lt _ (by decide)
  rw [encode, BitVec.toNat_ofNat]
  exact Nat.mod_eq_of_lt (by omega)

/-- `P` strictly decodes from its encoding. -/
public theorem decodeStrict_encode (P : Point) : decodeStrict (encode P) = some P := by
  have hy : P.y.val < 2 ^ 255 - 19 := ZMod.val_lt P.y
  have hx : P.x.val % 2 < 2 := Nat.mod_lt _ (by decide)
  have hlo : (encode P).toNat % 2 ^ 255 = P.y.val := by
    rw [toNat_encode]; omega
  have hhi : (encode P).toNat / 2 ^ 255 = P.x.val % 2 := by
    rw [toNat_encode]; omega
  rw [decodeStrict_eq_some_iff, hlo, hhi]
  refine ⟨decode_eq_some ⟨by rw [hlo, ZMod.natCast_zmod_val], .inr hhi.symm⟩, ZMod.val_lt P.y, ?_⟩
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

end Ed25519
