module

public import Agave.Math.Compress
public import Agave.Math.Decompress
public import Agave.Math.Ladder
public import Agave.Serial.FieldElement51_Neg_neg

/-! `verify_dalek_prehashed` in `ZMod p`: on `minus_A`, extended coordinates of `-PA`, and the
challenge `k`, it accepts exactly when `verify`'s checks after `A` decodes (`verifyBody`) pass. -/

namespace MLIR.Agave

open _root_.Ed25519

/-! ## Definitions -/

@[expose] public section

/-- `verify`'s checks once `A` decodes to `PA`, for the challenge `k` mod `ℓ`: `-PA` and the `R`
decoded from `r` not of small order, `S` canonical, and `encode (k (-PA) + S B) = r`. -/
noncomputable def verifyBody (PA : Point) (r S : BitVec 256) (k : ℕ) : Bool :=
  if 8 • -PA = 0 then false
  else
    match decode r with
    | none => false
    | some PR =>
      if 8 • PR = 0 then false
      else if CanonicalS S then encode (k • -PA + S.toNat • basePoint) == r else false

end

/-- `verify` is `A`'s decoding, then `verifyBody` with the challenge mod `ℓ`. -/
public theorem verify_eq_verifyBody (msg : List (BitVec 8)) (r S A : BitVec 256) :
    verify msg r S A =
      match decode A with
      | none => false
      | some PA => verifyBody PA r S (challenge msg r A % ell) :=
  rfl

namespace Serial

/-- `-A` as `verify_dalek` computes it from the decompressed `A` below `2^52`: `X` and `T` negated,
extended coordinates of `-PA` below `2^53`. -/
public theorem negA_ext {A : EdwardsPoint} {PA : Point} (hb : A.Lt (2 ^ 52)) (h : A.Ext PA.x PA.y) :
    (⟨FieldElement51_Neg_neg.spec A.X, A.Y, A.Z, FieldElement51_Neg_neg.spec A.T⟩ : EdwardsPoint).Lt
        (2 ^ 53) ∧
      (⟨FieldElement51_Neg_neg.spec A.X, A.Y, A.Z, FieldElement51_Neg_neg.spec A.T⟩ :
            EdwardsPoint).Ext
        (-PA).x (-PA).y := by
  obtain ⟨hX, hY, hZ, hT⟩ := hb
  obtain ⟨hz, hx, hy, ht⟩ := h
  obtain ⟨vX, lX⟩ := FieldElement51_Neg_neg.spec_val (hX.mono (by decide))
  obtain ⟨vT, lT⟩ := FieldElement51_Neg_neg.spec_val (hT.mono (by decide))
  refine
    ⟨⟨lX.mono (by decide), hY.mono (by decide), hZ.mono (by decide), lT.mono (by decide)⟩, hz, ?_,
      ?_, ?_⟩
  · rw [vX, hx, Point.neg_x, neg_mul]
  · rw [hy, Point.neg_y]
  · rw [vX, vT, neg_mul, neg_mul, ht]

/-- `verify_dalek_prehashed(r ‖ S, k)` on extended coordinates `mA` of `-PA` below `2^53`, for
`k < 2^255`: `Ok` (`-1`) exactly when `verifyBody` accepts with the challenge `k`. -/
public theorem VerificationKey_verify_dalek_prehashed.spec_eq {mA : EdwardsPoint} {PA : Point}
    (hb : mA.Lt (2 ^ 53)) (h : mA.Ext (-PA).x (-PA).y) (r S hk : BitVec 256)
    (hk' : hk.toNat < 2 ^ 255) :
    VerificationKey_verify_dalek_prehashed.spec mA r S hk =
      if verifyBody PA r S hk.toNat then -1#8 else 2#8 := by
  unfold VerificationKey_verify_dalek_prehashed.spec verifyBody
  rw [EdwardsPoint_is_small_order.spec_point hb h]
  by_cases hA : 8 • -PA = 0
  · simp [hA]
  have h01 : (0#1 = 1#1) = False := by decide
  have h08 : (0#8 = 1#8) = False := by decide
  simp only [hA, h01, ↓reduceIte]
  have hd := CompressedEdwardsY_decompress.spec_val r
  rcases hR : CompressedEdwardsY_decompress.spec r with _ | R
  · rw [hR] at hd
    simp only [DecodesExt] at hd
    simp [hd]
  rw [hR] at hd
  obtain ⟨Q, hQ, hext, hlt⟩ := hd
  have hlt' : R.Lt (2 ^ 53) :=
    ⟨hlt.1.mono (by decide), hlt.2.1.mono (by decide), hlt.2.2.1.mono (by decide),
      hlt.2.2.2.mono (by decide)⟩
  simp only [hQ, EdwardsPoint_is_small_order.spec_point hlt' hext]
  by_cases hQ8 : 8 • Q = 0
  · simp [hQ8]
  simp only [hQ8, h01, ↓reduceIte, Scalar_from_canonical_bytes.spec_eq]
  by_cases hc : CanonicalS S
  · have hS : S.toNat < 2 ^ 255 := Nat.div_eq_zero_iff_lt (by decide) |>.mp hc.1
    obtain ⟨hm, hml⟩ := mul.spec_val hb h hk' hS
    have hml' : (mul.spec hk mA S).Lt (2 ^ 54) :=
      ⟨hml.1.mono (by decide), hml.2.1.mono (by decide), hml.2.2.1.mono (by decide),
        hml.2.2.2.mono (by decide)⟩
    simp only [hc, ↓reduceIte, EdwardsPoint_compress.spec_eq hml' hm, beq_iff_eq]
  · simp [hc, h08]

end Serial

end MLIR.Agave
