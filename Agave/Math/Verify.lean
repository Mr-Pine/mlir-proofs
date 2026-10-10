module

public import Agave.Math.Encoding
public import Ed25519.Firedancer
import Mathlib.Tactic.Abel

/-! Agave's signature check as mathematics: `Signature::verify` (solana-signature 3.6.0), that is
solana-ed25519 0.2.4's `VerificationKey::try_from` and `verify_dalek`, in their order; the
`Variant` it is; and Firedancer's `verify` accepting with `R`'s `y` below `p` is Agave accepting. -/

namespace MLIR.Agave

open _root_.Ed25519

/-! ## Definitions -/

@[expose] public section

/-- `Scalar::from_canonical_bytes`'s test: bit 255 clear and `S` reduced mod `ℓ`. -/
def CanonicalS (S : BitVec 256) : Prop :=
  S.toNat / 2 ^ 255 = 0 ∧ S.toNat % ell = S.toNat

instance : DecidablePred CanonicalS := fun _ => inferInstanceAs (Decidable (_ ∧ _))

/-- Agave's check of the signature `r ‖ S` on `msg` with key `A`, in `verify_dalek`'s order: `A`
decodes; `-A` and the `R` decoded from `r` are not of small order; `S` is canonical; the
encoding (`compress`) of `[k](-A) + [S]B`, for `k` the challenge mod `ℓ`, is `r`. -/
noncomputable def verify (msg : List (BitVec 8)) (r S A : BitVec 256) : Bool :=
  match decode A with
  | none => false
  | some PA =>
    if 8 • -PA = 0 then false
    else
      match decode r with
      | none => false
      | some PR =>
        if 8 • PR = 0 then false
        else
          if CanonicalS S then encode ((challenge msg r A % ell) • -PA + S.toNat • basePoint) == r
          else false

/-- Agave as a variant of RFC 8032: `R` strict, `A` not; `k` mod `ℓ`; cofactorless; `A` or `R` of
small order rejected. -/
def _root_.Ed25519.Variant.agave : Variant :=
  ⟨true, false, true, false, fun A R => 8 • A = 0 ∨ 8 • R = 0⟩

end

/-! ## The canonical scalar -/

/-- `S` is canonical exactly when `S < ℓ`. -/
public theorem canonicalS_iff (S : BitVec 256) : CanonicalS S ↔ S.toNat < ell := by
  have hl : ell < 2 ^ 255 := by
    unfold ell; omega
  have h0 : 0 < ell := by
    unfold ell; omega
  constructor
  · rintro ⟨-, h⟩
    rw [← h]
    exact Nat.mod_lt _ h0
  · intro h
    exact ⟨Nat.div_eq_of_lt (h.trans hl), Nat.mod_eq_of_lt h⟩

/-! ## The variant -/

/-- A point not of small order has `x ≠ 0`. -/
theorem x_ne_zero {P : Point} (h : ¬8 • P = 0) : P.x ≠ 0 := fun hx =>
  h (Point.eight_smul_of_x_eq_zero' hx)

/-- `verify` accepts exactly what `Variant.agave` accepts. -/
public theorem verify_eq_true_iff (msg : List (BitVec 8)) (r S A : BitVec 256) :
    verify msg r S A = true ↔ Variant.agave.Accepts msg r S A := by
  simp only [Variant.Accepts, Variant.agave, Variant.dec, Bool.false_eq_true, ↓reduceIte,
    ← canonicalS_iff]
  unfold verify
  rcases hA : decode A with _ | PA
  · simp
  simp only [smul_neg, neg_eq_zero, Option.some.injEq]
  by_cases hA8 : 8 • PA = 0
  · simp only [hA8, ↓reduceIte, Bool.false_eq_true, false_iff, not_and, not_exists]
    rintro _ R _ _ rfl hrej
    exact absurd (.inl hA8) hrej
  simp only [hA8, ↓reduceIte]
  rcases hR : decode r with _ | PR
  · simp only [Bool.false_eq_true, false_iff, not_and, not_exists]
    intro _ R _ h
    rw [decode_of_decodeStrict h] at hR
    cases hR
  have hR' := decodes_of_decode hR
  by_cases hR8 : 8 • PR = 0
  · simp only [hR8, ↓reduceIte, Bool.false_eq_true, false_iff, not_and, not_exists]
    intro _ R _ h _ hrej
    rw [decode_of_decodeStrict h, Option.some.injEq] at hR
    exact absurd (.inr (hR ▸ hR8)) hrej
  have hRx := x_ne_zero hR8
  by_cases hS : CanonicalS S
  · simp only [hR8, hS, ↓reduceIte, beq_iff_eq, true_and]
    constructor
    · generalize hE : -((challenge msg r A % ell) • PA) + S.toNat • basePoint = E
      intro h
      have hd : Decodes r E := by
        rw [← h]; exact decodes_encode E
      obtain rfl := hR'.unique hd
      refine ⟨PR, PA, ?_, rfl, ?_, ?_⟩
      · have hc : CanonicalY r := h ▸ canonicalY_encode _
        exact decodeStrict_of_decode hR hc hRx
      · rintro (h' | h')
        · exact hA8 h'
        · exact hR8 h'
      · rw [← hE]; abel
    · rintro ⟨R, A', h, rfl, -, heq⟩
      rw [decode_of_decodeStrict h, Option.some.injEq] at hR
      subst hR
      rw [heq, neg_add_cancel_comm_assoc]
      exact encode_eq_of_decodes hR' (decodeStrict_canonical h) hRx
  · simp only [hR8, hS, ↓reduceIte, Bool.false_eq_true, false_and]

/-! ## Firedancer -/

/-- Agave's variant accepts what Firedancer's accepts with `R`'s `y` below `p`. -/
public theorem Variant.agave_iff_firedancer (msg : List (BitVec 8)) (r S A : BitVec 256) :
    Variant.agave.Accepts msg r S A ↔ Variant.firedancer.Accepts msg r S A ∧ CanonicalY r := by
  simp only [Variant.Accepts, Variant.agave, Variant.firedancer, Variant.dec, Bool.false_eq_true,
    ↓reduceIte]
  constructor
  · rintro ⟨hS, R, A', hR, hA, hrej, heq⟩
    exact ⟨⟨hS, R, A', decode_of_decodeStrict hR, hA, hrej, heq⟩, decodeStrict_canonical hR⟩
  · rintro ⟨⟨hS, R, A', hR, hA, hrej, heq⟩, hr⟩
    exact
      ⟨hS, R, A', decodeStrict_of_decode hR hr (x_ne_zero fun h => hrej (.inr h)), hA, hrej, heq⟩

/-- Agave accepts exactly when Firedancer's `verify` returns success and `R`'s `y` is below `p`. -/
public theorem verify_eq_true_iff_firedancer (msg : List (BitVec 8)) (r S A : BitVec 256) :
    verify msg r S A = true ↔ Firedancer.verify msg r S A = 0#32 ∧ CanonicalY r := by
  rw [verify_eq_true_iff, Variant.agave_iff_firedancer, Firedancer.verify_eq_zero_iff]

/-- `verify` as Firedancer's result and `R`'s canonicity. -/
public theorem verify_eq_firedancer (msg : List (BitVec 8)) (r S A : BitVec 256) :
    verify msg r S A = (Firedancer.verify msg r S A == 0#32 && decide (CanonicalY r)) := by
  rw [Bool.eq_iff_iff, verify_eq_true_iff_firedancer]
  simp

end MLIR.Agave
