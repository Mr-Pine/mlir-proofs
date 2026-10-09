module

public import Ed25519.Decode
public import Ed25519.BasePoint
public import Ed25519.Group
public import Ed25519.Scalar
public import Ed25519.Sha512
public import Ed25519.Verify

/-! Zig's `Ed25519.Signature.verify` as mathematics: its checks in order, its error codes, and its
cofactored equation. -/

namespace MLIR.Zig

open _root_.Ed25519

/-! ## Definitions -/

@[expose] public section

/-- Zig's verification of `S`, `r` against the key `A` and message `msg`, in Zig's order, with
`zig_ed25519_verify`'s codes (`-1` NonCanonical, `-2` InvalidEncoding, `-3` IdentityElement, `-4`
WeakPublicKey, `-5` SignatureVerificationFailed): `S < ℓ`; `A` decodes with `x ≠ 0`; `r`'s `y` is
below `p`, `R` decodes with `x ≠ 0`; `32 A` has `x ≠ 0`; then `8 [S]B = 8 R + 8 [k]A` for `k` the
SHA-512 digest of `r ‖ A ‖ msg`, mod `ℓ`. -/
noncomputable def verify (msg : List (BitVec 8)) (r S A : BitVec 256) : BitVec 32 :=
  if ell ≤ S.toNat then -1#32
  else
    match decode A with
    | none => -2#32
    | some PA =>
      if PA.x = 0 then -3#32
      else
        if p ≤ r.toNat % 2 ^ 255 then -1#32
        else
          match decode r with
          | none => -2#32
          | some PR =>
            if PR.x = 0 then -3#32
            else
              if (32 • PA).x = 0 then -4#32
              else
                let k := natLE (Sha512.digest (bytesLE r ++ bytesLE A ++ msg)) % ell
                if 8 • (S.toNat • basePoint) = 8 • PR + 8 • (k • PA) then 0#32 else -5#32

end

/-- `verify` accepts exactly what the library's Zig variant of RFC 8032 accepts. -/
public theorem verify_eq_zero_iff (msg : List (BitVec 8)) (r S A : BitVec 256) :
    verify msg r S A = 0#32 ↔ Variant.zig.Accepts msg r S A := by
  unfold verify
  rcases hA : decode A with _ | PA
  · refine ⟨fun h => ?_, fun ⟨_, R, A', _, hA', _⟩ => ?_⟩
    · simp only at h; split_ifs at h <;> exact absurd h (by decide)
    · simp [Variant.zig, Variant.dec, hA] at hA'
  rcases hR : decode r with _ | PR
  · refine ⟨fun h => ?_, fun ⟨_, R, A', hR', _⟩ => ?_⟩
    · simp only at h; split_ifs at h <;> exact absurd h (by decide)
    · simp [Variant.zig, Variant.dec, decodeStrict_eq_some_iff, hR] at hR'
  simp only [Variant.Accepts, Variant.zig, Variant.dec, ↓reduceIte, Bool.false_eq_true,
    decodeStrict_eq_some_iff, hA, hR, Option.some.injEq, challenge]
  constructor
  · intro h
    split_ifs at h with hS hAx hr hRx h32 heq
    all_goals
      first
      | exact absurd h (by decide)
      | skip
    refine ⟨by omega, PR, PA, ⟨rfl, by omega, fun h' => hRx h'.1⟩, rfl, ?_, heq⟩
    simp only [not_or]; exact ⟨hAx, hRx, h32⟩
  · rintro ⟨hS, R, A', ⟨rfl, hc, -⟩, rfl, hrej, heq⟩
    simp only [not_or] at hrej
    obtain ⟨hAx, hRx, h32⟩ := hrej
    simp only [show ¬ell ≤ S.toNat by omega, hAx, show ¬p ≤ r.toNat % 2 ^ 255 by omega, hRx, h32,
      heq, ↓reduceIte]

end MLIR.Zig
