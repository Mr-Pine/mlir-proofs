module

public import Agave.Avx2.VerificationKey_verify_dalek_prehashed
public import Agave.Math.LadderAvx2
public import Agave.Math.Prehashed

/-! The AVX2 `verify_dalek_prehashed` in `ZMod p`: on `minus_A`, extended coordinates of `-PA`, and
the challenge `k`, it accepts exactly when `verifyBody` passes, as the serial one does. -/

namespace MLIR.Agave.Avx2

open _root_.Ed25519 Serial

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
    obtain ⟨hm, hml⟩ := impl_mul.spec_val hb h hk' hS
    have hml' : (impl_mul.spec hk mA S).Lt (2 ^ 54) :=
      ⟨hml.1.mono (by decide), hml.2.1.mono (by decide), hml.2.2.1.mono (by decide),
        hml.2.2.2.mono (by decide)⟩
    simp only [hc, ↓reduceIte, EdwardsPoint_compress.spec_eq hml' hm, beq_iff_eq]
  · simp [hc, h08]

end MLIR.Agave.Avx2
