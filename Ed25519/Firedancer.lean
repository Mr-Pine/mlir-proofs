module

public import Ed25519.Verify

/-! Firedancer's `fd_ed25519_verify` as mathematics: its checks in its order, its error codes,
`Variant.firedancer` accepts what it accepts, and how that relates to RFC 8032. -/

namespace Ed25519.Firedancer

/-! ## Definitions -/

@[expose] public section

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

end

/-- `verify` accepts exactly what the library's Firedancer variant of RFC 8032 accepts. -/
public theorem verify_eq_zero_iff (msg : List (BitVec 8)) (r S A : BitVec 256) :
    verify msg r S A = 0#32 ↔ Variant.firedancer.Accepts msg r S A := by
  unfold verify
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

/-- Given the group's order, for `A` and `R` with `y` below `p`, RFC 8032 (cofactored) accepts what
`verify` accepts. -/
public theorem rfc8032_of_verify (ho : CurveOrder) {msg : List (BitVec 8)} {r S A : BitVec 256}
    (hA : A.toNat % 2 ^ 255 < p) (hr : r.toNat % 2 ^ 255 < p) (h : verify msg r S A = 0#32) :
    Variant.rfc8032.Accepts msg r S A :=
  Variant.rfc8032_of_firedancer ho hA hr ((verify_eq_zero_iff msg r S A).1 h)

/-- For `A` and `R` with `y` below `p` and `A` of order `ℓ`, `verify` accepts what cofactorless
RFC 8032 accepts, less the points of small order. -/
public theorem verify_eq_zero_iff_rfc8032 {msg : List (BitVec 8)} {r S A : BitVec 256}
    (hA : A.toNat % 2 ^ 255 < p) (hr : r.toNat % 2 ^ 255 < p)
    (hℓ : ∀ A', decode A = some A' → ell • A' = 0) :
    verify msg r S A = 0#32 ↔
      (Variant.rfc8032 false).Accepts msg r S A ∧
        ∀ R A', decode r = some R → decode A = some A' → ¬Variant.firedancer.reject A' R := by
  rw [verify_eq_zero_iff, Variant.firedancer_iff_rfc8032 hA hr hℓ]

end Ed25519.Firedancer
