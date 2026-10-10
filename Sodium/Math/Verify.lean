module

public import Boringssl.Math.Verify
import Mathlib.Tactic.Abel
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

/-! libsodium's `crypto_sign_ed25519_verify_detached` (`ED25519_COMPAT` unset) as mathematics: its
checks in its order, and the variant of RFC 8032 it accepts. -/

namespace Ed25519

/-! ## Definitions -/

@[expose] public section

namespace Sodium

/-- `ge25519_has_small_order`'s table, each entry's low 255 bits: the `y` of the points of small
order (`0`, `1`, `y8`, `-y8`, `-1`), and `p`, `p + 1` (`0`, `1` unreduced). -/
def blacklist : List ℕ :=
  [0, 1, 2707385501144840649318225287225658788936804267575313519463743609750303402022,
    55188659117513257062467267217118295137698188065244968500265048394206261417927, 2 ^ 255 - 20,
    2 ^ 255 - 19, 2 ^ 255 - 18]

/-- `ge25519_has_small_order s`: the low 255 bits of `s` (all but the sign) are in `blacklist`. -/
def HasSmallOrder (s : BitVec 256) : Prop :=
  s.toNat % 2 ^ 255 ∈ blacklist

instance : DecidablePred HasSmallOrder := fun s =>
  inferInstanceAs (Decidable (s.toNat % 2 ^ 255 ∈ blacklist))

/-- `ge25519_is_canonical s`: the low 255 bits of `s` are below `p`. -/
def IsCanonical (s : BitVec 256) : Prop :=
  s.toNat % 2 ^ 255 < p

instance : DecidablePred IsCanonical := fun s => inferInstanceAs (Decidable (s.toNat % 2 ^ 255 < p))

/-- `crypto_sign_ed25519_verify_detached`'s result (0 accepts) on the signature `r ‖ S`, in its
order: `S < ℓ` (`sc25519_is_canonical`) and `r` not of small order, `A` canonical and not of
small order (both on the bytes), `A` decodes; then the encoding of `[k](-A) + [S]B`, `k` the
SHA-512 digest of `r ‖ A ‖ msg` mod `ℓ`, is `r` (`crypto_verify_32`). -/
noncomputable def verify (msg : List (BitVec 8)) (r S A : BitVec 256) : BitVec 32 :=
  if ¬S.toNat < ell ∨ HasSmallOrder r then -1#32
  else
    if ¬IsCanonical A ∨ HasSmallOrder A then -1#32
    else
      match decode A with
      | none => -1#32
      | some PA =>
        let k := natLE (Sha512.digest (bytesLE r ++ bytesLE A ++ msg)) % ell
        if encode (k • -PA + S.toNat • basePoint) = r then 0#32 else -1#32

end Sodium

/-- libsodium's `crypto_sign_ed25519_verify_detached`: both strict; `k` mod `ℓ`; cofactorless;
`A` or `R` of small order rejected. -/
def Variant.sodium : Variant :=
  ⟨true, true, true, false, fun A R => 8 • A = 0 ∨ 8 • R = 0⟩

end

namespace Sodium

/-! ## The byte checks -/

/-- A point's `x` is `0` exactly when its `y` is `± 1`. -/
theorem x_eq_zero_iff (P : Point) : P.x = 0 ↔ P.y = 1 ∨ P.y = -1 := by
  have h := onCurve_iff.1 P.on
  constructor
  · intro hx
    rw [hx] at h
    have : (P.y - 1) * (P.y + 1) = 0 := by linear_combination -h
    rcases mul_eq_zero.1 this with h1 | h1
    · exact .inl (by linear_combination h1)
    · exact .inr (by linear_combination h1)
  · intro hy
    have hy2 : P.y ^ 2 = 1 := by rcases hy with h1 | h1 <;> rw [h1] <;> ring
    rw [hy2] at h
    have hd : d * 1 ^ 2 + 1 ≠ 0 := v_ne 1
    have h0 : (d * 1 ^ 2 + 1) * P.x ^ 2 = 0 := by linear_combination h
    exact pow_eq_zero_iff (two_ne_zero) |>.1 ((mul_eq_zero.1 h0).resolve_left hd)

/-- On a canonical encoding of `P`, `ge25519_has_small_order` decides `8 P = 0`. -/
public theorem hasSmallOrder_iff {b : BitVec 256} {P : Point} (hc : IsCanonical b)
    (hd : decode b = some P) : HasSmallOrder b ↔ 8 • P = 0 := by
  obtain ⟨hy, -⟩ := decodes_of_decode hd
  rw [← Point.smallOrder_iff_nsmul, smallOrder_iff P.on, x_eq_zero_iff, HasSmallOrder, hy]
  unfold IsCanonical at hc
  generalize b.toNat % 2 ^ 255 = n at hc ⊢
  have e (m : ℕ) (hm : m < p) : ((n : ZMod p) = m) ↔ n = m := by
    rw [ZMod.natCast_eq_natCast_iff', Nat.mod_eq_of_lt hc, Nat.mod_eq_of_lt hm]
  have e1 : (1 : ZMod p) = ((1 : ℕ) : ZMod p) := Nat.cast_one.symm
  have e0 : (0 : ZMod p) = ((0 : ℕ) : ZMod p) := Nat.cast_zero.symm
  have em1 : (-1 : ZMod p) = ((2 ^ 255 - 20 : ℕ) : ZMod p) := by
    rw [show 2 ^ 255 - 20 = p - 1 by decide, Nat.cast_sub (by decide), ZMod.natCast_self, zero_sub,
      Nat.cast_one]
  have e8 :
    y8 =
      ((2707385501144840649318225287225658788936804267575313519463743609750303402022 : ℕ) :
        ZMod p) :=
    (Nat.cast_ofNat).symm
  have em8 :
    -y8 =
      ((55188659117513257062467267217118295137698188065244968500265048394206261417927 : ℕ) :
        ZMod p) := by
    rw [show
        55188659117513257062467267217118295137698188065244968500265048394206261417927 =
          p - 2707385501144840649318225287225658788936804267575313519463743609750303402022
        by decide,
      Nat.cast_sub (by decide), ZMod.natCast_self, zero_sub, ← e8]
  rw [em1, em8, e8, e1, e0, e _ (by decide), e _ (by decide), e _ (by decide), e _ (by decide),
    e _ (by decide)]
  simp only [blacklist, List.mem_cons, List.not_mem_nil, or_false]
  have : n < 2 ^ 255 - 19 := hc
  omega

end Sodium

namespace Sodium

/-! ## Verification -/

/-- `verify` accepts exactly what `Variant.sodium` accepts. -/
public theorem verify_eq_zero_iff (msg : List (BitVec 8)) (r S A : BitVec 256) :
    verify msg r S A = 0#32 ↔ Variant.sodium.Accepts msg r S A := by
  simp only [Variant.Accepts, Variant.sodium, Variant.dec, ↓reduceIte, Bool.false_eq_true,
    challenge]
  unfold verify
  by_cases h1 : ¬S.toNat < ell ∨ HasSmallOrder r
  · rw [ite_eq_left h1]
    refine ⟨fun h => absurd h (by decide), ?_⟩
    rintro ⟨hS, R, A', hR, -, hrej, -⟩
    rcases h1 with h1 | h1
    · exact absurd hS h1
    · exact
        (hrej
            (.inr
              ((hasSmallOrder_iff (decodeStrict_canonical hR) (decode_of_decodeStrict hR)).1
                h1))).elim
  rw [ite_eq_right h1]
  obtain ⟨hS, hr⟩ := not_or.1 h1
  have hS := not_not.1 hS
  by_cases h2 : ¬IsCanonical A ∨ HasSmallOrder A
  · rw [ite_eq_left h2]
    refine ⟨fun h => absurd h (by decide), ?_⟩
    rintro ⟨-, R, A', -, hA', hrej, -⟩
    have hcA := decodeStrict_canonical hA'
    rcases h2 with h2 | h2
    · exact absurd hcA h2
    · exact (hrej (.inl ((hasSmallOrder_iff hcA (decode_of_decodeStrict hA')).1 h2))).elim
  rw [ite_eq_right h2]
  obtain ⟨hcA, hsA⟩ := not_or.1 h2
  rcases hA : decode A with _ | PA
  · dsimp only
    refine ⟨fun h => absurd h (by decide), ?_⟩
    rintro ⟨-, R, A', -, hA', -⟩
    rw [decode_of_decodeStrict hA'] at hA
    cases hA
  have hPA : ¬8 • PA = 0 := fun h => hsA ((hasSmallOrder_iff (not_not.1 hcA) hA).2 h)
  have hsPA : decodeStrict A = some PA :=
    decodeStrict_of_decode hA (not_not.1 hcA) fun hx => hPA (Point.eight_smul_of_x_eq_zero' hx)
  simp only [hsPA, Option.some.injEq, exists_and_left, exists_eq_left', hS, true_and, hPA, false_or]
  generalize natLE (Sha512.digest (bytesLE r ++ bytesLE A ++ msg)) % ell = k
  constructor
  · intro h
    split_ifs at h with he
    · have hR := encode_eq_iff.1 he
      refine
        ⟨_, hR, fun h8 =>
          hr ((hasSmallOrder_iff (decodeStrict_canonical hR) (decode_of_decodeStrict hR)).2 h8), ?_⟩
      rw [smul_neg, neg_add_cancel_comm]
    · exact absurd h (by decide)
  · rintro ⟨R, hR, -, he⟩
    rw [smul_neg, he, show -(k • PA) + (R + k • PA) = R by abel, encode_eq_iff.2 hR]
    simp only [↓reduceIte]

end Sodium

/-! ## The variants compared -/

namespace Variant

/-- libsodium accepts exactly what Firedancer accepts with `R`'s and `A`'s `y` below `p`. -/
public theorem sodium_iff_firedancer {msg : List (BitVec 8)} {r S A : BitVec 256} :
    sodium.Accepts msg r S A ↔
      firedancer.Accepts msg r S A ∧ r.toNat % 2 ^ 255 < p ∧ A.toNat % 2 ^ 255 < p := by
  constructor
  · rintro ⟨hS, R, A', hR, hA, hrej, heq⟩
    simp only [sodium, dec, ↓reduceIte] at hR hA hrej heq
    refine ⟨⟨hS, R, A', ?_, ?_, hrej, heq⟩, decodeStrict_canonical hR, decodeStrict_canonical hA⟩
    · simp only [firedancer, dec, Bool.false_eq_true, ↓reduceIte]; exact decode_of_decodeStrict hR
    · simp only [firedancer, dec, Bool.false_eq_true, ↓reduceIte]; exact decode_of_decodeStrict hA
  · rintro ⟨⟨hS, R, A', hR, hA, hrej, heq⟩, hr, hAc⟩
    simp only [firedancer, dec, Bool.false_eq_true, ↓reduceIte] at hR hA hrej heq
    have hRx : R.x ≠ 0 := fun hx => hrej (.inr (Point.eight_smul_of_x_eq_zero' hx))
    have hAx : A'.x ≠ 0 := fun hx => hrej (.inl (Point.eight_smul_of_x_eq_zero' hx))
    refine ⟨hS, R, A', ?_, ?_, hrej, heq⟩
    · simp only [sodium, dec, ↓reduceIte]; exact decodeStrict_of_decode hR hr hRx
    · simp only [sodium, dec, ↓reduceIte]; exact decodeStrict_of_decode hA hAc hAx

/-- BoringSSL accepts what libsodium accepts. -/
public theorem boringssl_of_sodium {msg : List (BitVec 8)} {r S A : BitVec 256}
    (h : sodium.Accepts msg r S A) : boringssl.Accepts msg r S A := by
  obtain ⟨hS, R, A', hR, hA, -, heq⟩ := h
  simp only [sodium, dec, ↓reduceIte] at hR hA heq
  refine ⟨hS, R, A', ?_, ?_, fun h => h, heq⟩
  · simp only [boringssl, dec, ↓reduceIte]; exact hR
  · simp only [boringssl, dec, Bool.false_eq_true, ↓reduceIte]; exact decode_of_decodeStrict hA

/-- Given the group's order, RFC 8032 (cofactored) accepts what libsodium accepts. -/
public theorem rfc8032_of_sodium (ho : CurveOrder) {msg : List (BitVec 8)} {r S A : BitVec 256}
    (h : sodium.Accepts msg r S A) : rfc8032.Accepts msg r S A := by
  have hb := boringssl_of_sodium h
  obtain ⟨-, -, A', -, hA, -⟩ := h
  simp only [sodium, dec, ↓reduceIte] at hA
  exact rfc8032_of_boringssl ho (by rw [hA, decode_of_decodeStrict hA]) hb

end Variant

end Ed25519
