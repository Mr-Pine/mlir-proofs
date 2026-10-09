module

public import Ed25519.Verify

/-! Ed25519 verification as mathematics, in `fd_ed25519_verify`'s order and error codes, and the
library's Firedancer variant of RFC 8032 accepts what it accepts. -/

namespace MLIR.Firedancer.Ref

open _root_.Ed25519

/-! ## Definitions -/

@[expose] public section

namespace Ed25519

/-- Ed25519 verification of `S`, `r` against the key `A` and message `msg`, in
`fd_ed25519_verify`'s order and error codes: `S < ℓ`; `A`, `R` decode and are not of small order;
then `[S]B = R + [k]A` for `k` the SHA-512 digest of `r ‖ A ‖ msg`, mod `ℓ`. -/
noncomputable def verify (msg : List (BitVec 8)) (r S A : BitVec 256) : BitVec 32 :=
  if ell ≤ S.toNat then -1#32
  else
    match decode A, decode r with
    | some PA, some PR =>
      if 8 • PA = 0 then -2#32
      else
        if 8 • PR = 0 then -1#32
        else
          let k := natLE (Sha512.digest (bytesLE r ++ bytesLE A ++ msg)) % ell
          if S.toNat • basePoint = PR + k • PA then 0#32 else -3#32
    | none, _ => -2#32
    | some _, none => -1#32

end Ed25519

end

/-- `verify` accepts exactly what the library's Firedancer variant of RFC 8032 accepts. -/
public theorem Ed25519.verify_eq_zero_iff (msg : List (BitVec 8)) (r S A : BitVec 256) :
    Ed25519.verify msg r S A = 0#32 ↔ Variant.firedancer.Accepts msg r S A := by
  unfold Ed25519.verify
  rcases hA : decode A with _ | PA
  · refine ⟨fun h => ?_, fun ⟨_, R, A', _, hA', _⟩ => ?_⟩
    · simp only at h; split_ifs at h <;> exact absurd h (by decide)
    · simp [Variant.firedancer, Variant.dec, hA] at hA'
  rcases hR : decode r with _ | PR
  · refine ⟨fun h => ?_, fun ⟨_, R, A', hR', _⟩ => ?_⟩
    · simp only at h; split_ifs at h <;> exact absurd h (by decide)
    · simp [Variant.firedancer, Variant.dec, hR] at hR'
  simp only [Variant.Accepts, Variant.firedancer, Variant.dec, Bool.false_eq_true, ↓reduceIte, hA,
    hR, Option.some.injEq, challenge]
  constructor
  · intro h
    split_ifs at h with hS hA8 hR8 heq
    all_goals
      first
      | exact absurd h (by decide)
      | skip
    exact
      ⟨by omega, PR, PA, rfl, rfl, by
        simp only [not_or]; exact ⟨hA8, hR8⟩, heq⟩
  · rintro ⟨hS, R, A', rfl, rfl, hrej, heq⟩
    simp only [not_or] at hrej
    simp only [show ¬ell ≤ S.toNat by omega, hrej.1, hrej.2, heq, ↓reduceIte]

end MLIR.Firedancer.Ref
