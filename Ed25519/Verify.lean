module

public import Ed25519.Decode
public import Ed25519.BasePoint
public import Ed25519.Count
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

/-! Ed25519 verification after RFC 8032 §5.1.7, as a family: how `R` and `A` decode, whether the
challenge `k` is reduced mod `ℓ`, which group equation is checked, and which points are rejected
besides. RFC 8032 and the implementations' checks are members. -/

namespace Ed25519

/-! ## Definitions -/

@[expose] public section

/-- RFC 8032 §5.1.3 decoding: `decode`, with `y < p` and no sign bit on `x = 0`. -/
noncomputable def decodeStrict (buf : BitVec 256) : Option Point :=
  match decode buf with
  | some P =>
    if buf.toNat % 2 ^ 255 < p ∧ ¬(P.x = 0 ∧ buf.toNat / 2 ^ 255 = 1) then some P else none
  | none => none

/-- `k`: the SHA-512 digest of `R ‖ A ‖ M` as a little-endian number. -/
noncomputable def challenge (msg : List (BitVec 8)) (r A : BitVec 256) : ℕ :=
  natLE (Sha512.digest (bytesLE r ++ bytesLE A ++ msg))

/-- A verification: `R`'s and `A`'s decoding strict (§5.1.3) or not, `k` reduced mod `ℓ` or not, the
cofactored equation or the cofactorless one, and the decoded points it rejects besides. -/
structure Variant where
  strictR : Bool
  strictA : Bool
  reduceK : Bool
  cofactored : Bool
  reject : Point → Point → Prop

namespace Variant

/-- Decoding, strict or not. -/
noncomputable def dec (strict : Bool) (b : BitVec 256) : Option Point :=
  if strict then decodeStrict b else decode b

/-- `V` accepts the signature `r ‖ S` on `msg` with key `A`: `S < ℓ`; `R` and `A'` decode and are
not rejected; the group equation holds. -/
def Accepts (V : Variant) (msg : List (BitVec 8)) (r S A : BitVec 256) : Prop :=
  S.toNat < ell ∧
    ∃ R A',
      dec V.strictR r = some R ∧
        dec V.strictA A = some A' ∧
          ¬V.reject A' R ∧
            let k := if V.reduceK then challenge msg r A % ell else challenge msg r A
            if V.cofactored then 8 • (S.toNat • basePoint) = 8 • R + 8 • (k • A')
            else S.toNat • basePoint = R + k • A'

/-- RFC 8032 §5.1.7: strict decoding, `k` the whole digest, `[8][S]B = [8]R + [8][k]A'`; with
`cofactored := false`, the sufficient check `[S]B = R + [k]A'`. -/
def rfc8032 (cofactored : Bool := true) : Variant :=
  ⟨true, true, false, cofactored, fun _ _ => False⟩

/-- Zig's `Signature.verify`: `R` strict, `A` not; `k` mod `ℓ`; cofactored; `A` or `R` with `x = 0`,
and `A` with `x(32 A) = 0`, rejected. -/
def zig : Variant :=
  ⟨true, false, true, true, fun A R => A.x = 0 ∨ R.x = 0 ∨ (32 • A).x = 0⟩

/-- Firedancer's `fd_ed25519_verify`: neither strict; `k` mod `ℓ`; cofactorless; `A` or `R` of small
order rejected. -/
def firedancer : Variant :=
  ⟨false, false, true, false, fun A R => 8 • A = 0 ∨ 8 • R = 0⟩

end Variant

/-- `8 ℓ` kills every point (`curveOrder`): it relates `k` mod `ℓ` to the RFC's whole `k`. -/
def CurveOrder : Prop :=
  ∀ P : Point, (8 * ell) • P = 0

end

/-! ## Decoding -/

/-- A strictly decoded point decodes. -/
public theorem decode_of_decodeStrict {b : BitVec 256} {P : Point} (h : decodeStrict b = some P) :
    decode b = some P := by
  unfold decodeStrict at h
  split at h
  · rename_i Q hQ; split at h
    · cases h; exact hQ
    · cases h
  · cases h

/-- A decoded point with `x ≠ 0` and `y < p` decodes strictly. -/
public theorem decodeStrict_of_decode {b : BitVec 256} {P : Point} (h : decode b = some P)
    (hy : b.toNat % 2 ^ 255 < p) (hx : P.x ≠ 0) : decodeStrict b = some P := by
  simp only [decodeStrict, h, hy, hx, false_and, not_false_eq_true, and_self, ↓reduceIte]

/-- Strict decoding: decoding, `y < p`, and no sign bit on `x = 0`. -/
public theorem decodeStrict_eq_some_iff {b : BitVec 256} {P : Point} :
    decodeStrict b = some P ↔
      decode b = some P ∧ b.toNat % 2 ^ 255 < p ∧ ¬(P.x = 0 ∧ b.toNat / 2 ^ 255 = 1) := by
  unfold decodeStrict
  split
  · rename_i Q hQ
    rw [hQ, Option.some.injEq]
    split
    · rename_i hc; rw [Option.some.injEq]; constructor
      · rintro rfl; exact ⟨rfl, hc⟩
      · rintro ⟨rfl, -⟩; rfl
    · rename_i hc; simp only [reduceCtorEq, false_iff, not_and]
      rintro rfl h1 h2; exact hc ⟨h1, fun h => h2 h.1 h.2⟩
  · rename_i hQ; rw [hQ]; simp

/-- A strictly decoded point's encoding has `y < p`. -/
public theorem decodeStrict_canonical {b : BitVec 256} {P : Point} (h : decodeStrict b = some P) :
    b.toNat % 2 ^ 255 < p := by
  unfold decodeStrict at h
  split at h
  · split at h
    · rename_i hc; exact hc.1
    · cases h
  · cases h

/-! ## Points -/

/-- A point with `x = 0`, `(0, ±1)`, has order at most 2. -/
public theorem Point.two_nsmul_of_x_eq_zero {P : Point} (hx : P.x = 0) : 2 • P = 0 := by
  have hy : P.y ^ 2 = 1 := by
    have h := P.on
    unfold OnCurve at h
    rw [hx] at h
    linear_combination h
  rw [two_nsmul, Point.ext_iff]
  refine ⟨?_, ?_⟩
  · rw [Point.add_x]; simp [add, hx]
  · rw [Point.add_y]; simp [add, hx, ← sq, hy]

/-- A point with `x = 0` has small order. -/
public theorem Point.eight_smul_of_x_eq_zero' {P : Point} (hx : P.x = 0) : 8 • P = 0 := by
  rw [show (8 : ℕ) = 4 * 2 from rfl, mul_nsmul', Point.two_nsmul_of_x_eq_zero hx, nsmul_zero]

/-- `8 ℓ`, the group's order, kills every point. -/
public theorem curveOrder : CurveOrder := fun _ => Point.card ▸ card_nsmul_eq_zero'

/-- `8 [k mod ℓ]A = 8 [k]A`. -/
public theorem Point.eight_mod_ell_smul (k : ℕ) (A : Point) :
    8 • ((k % ell) • A) = 8 • (k • A) := by
  conv_rhs => rw [← Nat.mod_add_div k ell]
  rw [add_nsmul, smul_add]
  have h0 : 8 • ((ell * (k / ell)) • A) = 0 := by
    rw [smul_smul, show 8 * (ell * (k / ell)) = k / ell * (8 * ell) by ring, ← smul_smul,
      curveOrder, smul_zero]
  rw [h0, add_zero]

/-- For a point of order `ℓ`, `[k mod ℓ]A = [k]A`. -/
public theorem Point.mod_ell_smul {A : Point} (h : ell • A = 0) (k : ℕ) :
    (k % ell) • A = k • A := by
  conv_rhs => rw [← Nat.mod_add_div k ell, add_nsmul, mul_nsmul, h, nsmul_zero, add_zero]

/-! ## The variants compared -/

namespace Variant

/-- Firedancer accepting, with `R`'s `y` below `p`, Zig accepts. -/
public theorem zig_of_firedancer {msg : List (BitVec 8)} {r S A : BitVec 256}
    (h : firedancer.Accepts msg r S A) (hr : r.toNat % 2 ^ 255 < p) : zig.Accepts msg r S A := by
  obtain ⟨hS, R, A', hR, hA, hrej, heq⟩ := h
  simp only [firedancer, dec, Bool.false_eq_true, ↓reduceIte] at hR hA hrej heq
  have hRx : R.x ≠ 0 := fun hx => hrej (.inr (Point.eight_smul_of_x_eq_zero' hx))
  have hAx : A'.x ≠ 0 := fun hx => hrej (.inl (Point.eight_smul_of_x_eq_zero' hx))
  have h32 : (32 • A').x ≠ 0 := fun hx => hrej (.inl (Point.eight_smul_of_x_eq_zero hx))
  refine ⟨hS, R, A', ?_, ?_, ?_, ?_⟩
  · simp only [zig, dec, ↓reduceIte]; exact decodeStrict_of_decode hR hr hRx
  · simp only [zig, dec, Bool.false_eq_true, ↓reduceIte]; exact hA
  · rintro (h | h | h)
    · exact hAx h
    · exact hRx h
    · exact h32 h
  · simp only [zig, ↓reduceIte]
    rw [heq, smul_add]

/-- For an `A` with `y < p`, Zig accepts what RFC 8032 accepts, less the points it rejects
besides. -/
public theorem zig_iff_rfc8032 {msg : List (BitVec 8)} {r S A : BitVec 256}
    (hA : A.toNat % 2 ^ 255 < p) :
    zig.Accepts msg r S A ↔
      rfc8032.Accepts msg r S A ∧
        ∀ R A', decode r = some R → decode A = some A' → ¬zig.reject A' R := by
  constructor
  · rintro ⟨hS, R, A', hR, hA', hrej, heq⟩
    simp only [zig, dec, Bool.false_eq_true, ↓reduceIte] at hR hA' hrej heq
    have hAx : A'.x ≠ 0 := fun hx => hrej (.inl hx)
    refine ⟨⟨hS, R, A', ?_, ?_, ?_, ?_⟩, ?_⟩
    · simp only [rfc8032, dec, ↓reduceIte]; exact hR
    · simp only [rfc8032, dec, ↓reduceIte]; exact decodeStrict_of_decode hA' hA hAx
    · simp [rfc8032]
    · simp only [rfc8032, Bool.false_eq_true, ↓reduceIte]
      rw [← Point.eight_mod_ell_smul (challenge msg r A) A']; exact heq
    · intro R₂ A₂ hR₂ hA₂
      rw [decode_of_decodeStrict hR, Option.some.injEq] at hR₂
      rw [hA', Option.some.injEq] at hA₂
      subst hR₂ hA₂
      simpa [zig] using hrej
  · rintro ⟨⟨hS, R, A', hR, hA', -, heq⟩, hrej⟩
    simp only [rfc8032, dec, Bool.false_eq_true, ↓reduceIte] at hR hA' heq
    have hA'' := decode_of_decodeStrict hA'
    refine ⟨hS, R, A', ?_, ?_, hrej R A' (decode_of_decodeStrict hR) hA'', ?_⟩
    · simp only [zig, dec, ↓reduceIte]; exact hR
    · simp only [zig, dec, Bool.false_eq_true, ↓reduceIte]; exact hA''
    · simp only [zig, ↓reduceIte]
      rw [Point.eight_mod_ell_smul (challenge msg r A) A']; exact heq

/-- For `A` and `R` with `y` below `p`, RFC 8032 (cofactored) accepts what Firedancer accepts. -/
public theorem rfc8032_of_firedancer {msg : List (BitVec 8)} {r S A : BitVec 256}
    (hA : A.toNat % 2 ^ 255 < p) (hr : r.toNat % 2 ^ 255 < p) (h : firedancer.Accepts msg r S A) :
    rfc8032.Accepts msg r S A :=
  ((zig_iff_rfc8032 hA).1 (zig_of_firedancer h hr)).1

/-- For `A` and `R` with `y` below `p` and `A` of order `ℓ`, Firedancer accepts what cofactorless
RFC 8032 accepts, less the points of small order. -/
public theorem firedancer_iff_rfc8032 {msg : List (BitVec 8)} {r S A : BitVec 256}
    (hA : A.toNat % 2 ^ 255 < p) (hr : r.toNat % 2 ^ 255 < p)
    (hℓ : ∀ A', decode A = some A' → ell • A' = 0) :
    firedancer.Accepts msg r S A ↔
      (rfc8032 false).Accepts msg r S A ∧
        ∀ R A', decode r = some R → decode A = some A' → ¬firedancer.reject A' R := by
  constructor
  · rintro ⟨hS, R, A', hR, hA', hrej, heq⟩
    simp only [firedancer, dec, Bool.false_eq_true, ↓reduceIte] at hR hA' hrej heq
    have hRx : R.x ≠ 0 := fun hx => hrej (.inr (Point.eight_smul_of_x_eq_zero' hx))
    have hAx : A'.x ≠ 0 := fun hx => hrej (.inl (Point.eight_smul_of_x_eq_zero' hx))
    refine ⟨⟨hS, R, A', ?_, ?_, fun h => h, ?_⟩, fun R₂ A₂ hR₂ hA₂ => ?_⟩
    · simp only [rfc8032, dec, ↓reduceIte]; exact decodeStrict_of_decode hR hr hRx
    · simp only [rfc8032, dec, ↓reduceIte]; exact decodeStrict_of_decode hA' hA hAx
    · simp only [rfc8032, Bool.false_eq_true, ↓reduceIte]
      rw [← Point.mod_ell_smul (hℓ A' hA')]; exact heq
    · rw [hR, Option.some.injEq] at hR₂
      rw [hA', Option.some.injEq] at hA₂
      subst hR₂ hA₂
      exact hrej
  · rintro ⟨⟨hS, R, A', hR, hA', -, heq⟩, hrej⟩
    simp only [rfc8032, dec, Bool.false_eq_true, ↓reduceIte] at hR hA' heq
    have hR' := decode_of_decodeStrict hR
    have hA'' := decode_of_decodeStrict hA'
    refine ⟨hS, R, A', hR', hA'', hrej R A' hR' hA'', ?_⟩
    simp only [firedancer, Bool.false_eq_true, ↓reduceIte]
    rw [Point.mod_ell_smul (hℓ A' hA'')]; exact heq

end Variant

end Ed25519
