module

public import Ed25519.Encode
import Mathlib.Tactic.Abel

/-! BoringSSL's `ED25519_verify` as mathematics: its checks in its order, and the variant of
RFC 8032 it accepts. -/

namespace Ed25519

/-! ## Definitions -/

@[expose] public section

namespace Boringssl

/-- `ED25519_verify`'s result (1 accepts) on the signature `r ‖ S`, in its order: `S < 2²⁵³` (the
top three bits clear), `A` decodes (any encoding of `y`, any sign of `x = 0`), `S < ℓ`; then the
encoding of `[k](-A) + [S]B`, `k` the SHA-512 digest of `r ‖ A ‖ msg` mod `ℓ`, is `r`. -/
noncomputable def verify (msg : List (BitVec 8)) (r S A : BitVec 256) : BitVec 32 :=
  if 2 ^ 253 ≤ S.toNat then 0#32
  else
    match decode A with
    | none => 0#32
    | some PA =>
      if ell ≤ S.toNat then 0#32
      else
        let k := natLE (Sha512.digest (bytesLE r ++ bytesLE A ++ msg)) % ell
        if encode (k • -PA + S.toNat • basePoint) = r then 1#32 else 0#32

end Boringssl

/-- BoringSSL's `ED25519_verify`: `R` strict (its encoding is compared, never decoded), `A` not;
`k` mod `ℓ`; cofactorless; nothing rejected besides. -/
def Variant.boringssl : Variant :=
  ⟨true, false, true, false, fun _ _ => False⟩

end

namespace Boringssl

/-- `verify` accepts exactly what `Variant.boringssl` accepts. -/
public theorem verify_eq_one_iff (msg : List (BitVec 8)) (r S A : BitVec 256) :
    verify msg r S A = 1#32 ↔ Variant.boringssl.Accepts msg r S A := by
  simp only [Variant.Accepts, Variant.boringssl, Variant.dec, Bool.false_eq_true, ↓reduceIte,
    not_false_eq_true, true_and, challenge]
  unfold verify
  have hl := ell_lt
  rcases hA : decode A with _ | PA
  · simp only [reduceCtorEq, false_and, exists_false, and_false, iff_false]
    split_ifs <;> decide
  · simp only [Option.some.injEq, exists_and_left, exists_eq_left', ← encode_eq_iff]
    by_cases hS : ell ≤ S.toNat
    · simp only [show ¬S.toNat < ell by omega, false_and, iff_false]
      split_ifs <;> decide
    · simp only [show ¬2 ^ 253 ≤ S.toNat by omega, hS, ↓reduceIte, show S.toNat < ell by omega,
        true_and]
      generalize natLE (Sha512.digest (bytesLE r ++ bytesLE A ++ msg)) % ell = k
      constructor
      · intro h
        split_ifs at h with he
        · refine ⟨_, he, ?_⟩
          rw [smul_neg, neg_add_cancel_comm]
        · exact absurd h (by decide)
      · rintro ⟨R, rfl, he⟩
        rw [smul_neg, he, show -(k • PA) + (R + k • PA) = R by abel]
        simp only [↓reduceIte]

end Boringssl

/-! ## The variants compared -/

namespace Variant

/-- Firedancer accepting, with `R`'s `y` below `p`, BoringSSL accepts. -/
public theorem boringssl_of_firedancer {msg : List (BitVec 8)} {r S A : BitVec 256}
    (h : firedancer.Accepts msg r S A) (hr : r.toNat % 2 ^ 255 < p) :
    boringssl.Accepts msg r S A := by
  obtain ⟨hS, R, A', hR, hA, hrej, heq⟩ := h
  simp only [firedancer, dec, Bool.false_eq_true, ↓reduceIte] at hR hA hrej heq
  have hRx : R.x ≠ 0 := fun hx => hrej (.inr (Point.eight_smul_of_x_eq_zero' hx))
  refine ⟨hS, R, A', ?_, hA, fun h => h, heq⟩
  simp only [boringssl, dec, ↓reduceIte]
  exact decodeStrict_of_decode hR hr hRx

/-- For an `R` with `y` below `p`, Firedancer accepts what BoringSSL accepts, less the points of
small order. -/
public theorem firedancer_iff_boringssl {msg : List (BitVec 8)} {r S A : BitVec 256}
    (hr : r.toNat % 2 ^ 255 < p) :
    firedancer.Accepts msg r S A ↔
      boringssl.Accepts msg r S A ∧
        ∀ R A', decode r = some R → decode A = some A' → ¬firedancer.reject A' R := by
  refine ⟨fun h => ⟨boringssl_of_firedancer h hr, fun R₂ A₂ hR₂ hA₂ => ?_⟩, ?_⟩
  · obtain ⟨-, R, A', hR, hA, hrej, -⟩ := h
    simp only [firedancer, dec, Bool.false_eq_true, ↓reduceIte] at hR hA
    rw [hR, Option.some.injEq] at hR₂
    rw [hA, Option.some.injEq] at hA₂
    subst hR₂ hA₂
    exact hrej
  · rintro ⟨⟨hS, R, A', hR, hA, -, heq⟩, hrej⟩
    simp only [boringssl, dec, Bool.false_eq_true, ↓reduceIte] at hR hA heq
    have hR' := decode_of_decodeStrict hR
    exact ⟨hS, R, A', hR', hA, hrej R A' hR' hA, heq⟩

/-- Given the group's order, for an `A` whose encoding is canonical, RFC 8032 (cofactored) accepts
what BoringSSL accepts. -/
public theorem rfc8032_of_boringssl (ho : CurveOrder) {msg : List (BitVec 8)} {r S A : BitVec 256}
    (hA : decodeStrict A = decode A) (h : boringssl.Accepts msg r S A) :
    rfc8032.Accepts msg r S A := by
  obtain ⟨hS, R, A', hR, hA', -, heq⟩ := h
  simp only [boringssl, dec, Bool.false_eq_true, ↓reduceIte] at hR hA' heq
  refine ⟨hS, R, A', ?_, ?_, fun h => h, ?_⟩
  · simp only [rfc8032, dec, ↓reduceIte]; exact hR
  · simp only [rfc8032, dec, ↓reduceIte]; rw [hA]; exact hA'
  · simp only [rfc8032, Bool.false_eq_true, ↓reduceIte]
    rw [heq, smul_add, CurveOrder.eight_smul_mod ho]

/-- For an `A` of order `ℓ` whose encoding is canonical, cofactorless RFC 8032 accepts exactly what
BoringSSL accepts: `[k]A = [k mod ℓ]A`. -/
public theorem rfc8032_iff_boringssl {msg : List (BitVec 8)} {r S A : BitVec 256}
    (hA : decodeStrict A = decode A) (hℓ : ∀ A', decode A = some A' → ell • A' = 0) :
    (rfc8032 false).Accepts msg r S A ↔ boringssl.Accepts msg r S A := by
  have hk (A' : Point) (h : ell • A' = 0) (k : ℕ) : (k % ell) • A' = k • A' := by
    conv_rhs => rw [← Nat.mod_add_div k ell, add_nsmul, mul_nsmul, h, nsmul_zero, add_zero]
  simp only [Accepts, rfc8032, boringssl, dec, Bool.false_eq_true, ↓reduceIte, hA,
    not_false_eq_true, true_and]
  refine and_congr_right fun _ => exists_congr fun R => exists_congr fun A' => ?_
  refine and_congr_right fun _ => and_congr_right fun hA' => ?_
  rw [hk A' (hℓ A' hA')]

end Variant

end Ed25519
