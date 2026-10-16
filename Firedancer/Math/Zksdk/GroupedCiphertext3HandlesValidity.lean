module

public import Firedancer.Math.Zksdk.Common
public import Firedancer.Ref.fd_zksdk_grouped_ciphertext_3_handles_validity
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Module

/-! The 3-handle grouped-ciphertext validity verifier (`fd_zksdk_verify_proof_direct_…`, direct and
batched, and the non-batched wrapper) against zk-sdk's `grouped_ciphertext_validity/handles_3.rs`;
both batch the four equations as `E₀ + w E₁ + w² E₂ + w³ E₃`. `pubkey3` and `Y₃` are never
zero-checked. -/

namespace MLIR.Firedancer.Ref

open _root_.Ed25519 _root_.Ed25519.Ristretto fd_zksdk

@[expose] public section

/-- The challenges `(c, w)` the direct verifier's transcript derives on the accepting path. -/
def fd_zksdk_verify_proof_direct_grouped_ciphertext_3_handles_validity.challenges
    (proof : fd_zksdk_grp_ciph_3h_val_proof_t) (transcript : fd_merlin_transcript_t) :
    BitVec 256 × BitVec 256 :=
  let transcript := fd_zksdk_transcript_domsep_grp_ciph_val_proof transcript 3#64
  let transcript :=
    fd_zksdk_transcript_append_point transcript (FD_TRANSCRIPT_LITERAL "Y_0") proof.y0
  let transcript :=
    fd_zksdk_transcript_append_point transcript (FD_TRANSCRIPT_LITERAL "Y_1") proof.y1
  let transcript :=
    fd_zksdk_transcript_append_point transcript (FD_TRANSCRIPT_LITERAL "Y_2") proof.y2
  let transcript :=
    fd_zksdk_transcript_append_point transcript (FD_TRANSCRIPT_LITERAL "Y_3") proof.y3
  let c := fd_zksdk_transcript_challenge_scalar transcript (FD_TRANSCRIPT_LITERAL "c")
  let transcript := fd_zksdk_transcript_append_scalar c.1 (FD_TRANSCRIPT_LITERAL "z_r") proof.zr
  let transcript :=
    fd_zksdk_transcript_append_scalar transcript (FD_TRANSCRIPT_LITERAL "z_x") proof.zx
  let w := fd_zksdk_transcript_challenge_scalar transcript (FD_TRANSCRIPT_LITERAL "w")
  (c.2, w.2)

/-- zk-sdk's equations, each as `lhs - rhs`: `z_r H + z_x G = c C + Y₀` and `z_r Pᵢ = c Dᵢ + Yᵢ`
for `i = 1, 2, 3`. -/
noncomputable def Grouped3.eqns [PrimeOrder] (zr zx c : ZMod ell)
    (P₁ P₂ P₃ C D₁ D₂ D₃ Y₀ Y₁ Y₂ Y₃ : RGroup) : Fin 4 → RGroup :=
  ![zr • H + zx • G - c • C - Y₀, zr • P₁ - c • D₁ - Y₁, zr • P₂ - c • D₂ - Y₂,
    zr • P₃ - c • D₃ - Y₃]

end

/-- The direct verifier, not batched: accepts exactly when `Y₀`, `Y₁`, `Y₂` are not the zero
encoding, `z_r`, `z_x` are canonical, everything decodes, and `Σₖ wᵏ Eₖ = 0` for the transcript's
`c`, `w`. -/
public theorem fd_zksdk_verify_proof_direct_grouped_ciphertext_3_handles_validity.ret_eq_success_iff
    [PrimeOrder] (proof : fd_zksdk_grp_ciph_3h_val_proof_t)
    (pubkey1 pubkey2 pubkey3 comm handle1 handle2 handle3 comm_hi handle1_hi handle2_hi handle3_hi
      challenge_t : BitVec 256)
    (transcript : fd_merlin_transcript_t) :
    (fd_zksdk_verify_proof_direct_grouped_ciphertext_3_handles_validity proof pubkey1 pubkey2
            pubkey3 comm handle1 handle2 handle3 comm_hi handle1_hi handle2_hi handle3_hi
            challenge_t 0#32 transcript).ret =
        FD_ZKSDK_VERIFY_PROOF_SUCCESS ↔
      proof.y0 ≠ fd_ristretto255_compressed_zero ∧
        proof.y1 ≠ fd_ristretto255_compressed_zero ∧
          proof.y2 ≠ fd_ristretto255_compressed_zero ∧
            proof.zr.toNat < ell ∧
              proof.zx.toNat < ell ∧
                ∃ P₁ P₂ P₃ C D₁ D₂ D₃ Y₀ Y₁ Y₂ Y₃,
                  DecodesTo pubkey1 P₁ ∧
                    DecodesTo pubkey2 P₂ ∧
                      DecodesTo pubkey3 P₃ ∧
                        DecodesTo comm C ∧
                          DecodesTo handle1 D₁ ∧
                            DecodesTo handle2 D₂ ∧
                              DecodesTo handle3 D₃ ∧
                                DecodesTo proof.y0 Y₀ ∧
                                  DecodesTo proof.y1 Y₁ ∧
                                    DecodesTo proof.y2 Y₂ ∧
                                      DecodesTo proof.y3 Y₃ ∧
                                        let cw :=
                                          fd_zksdk_verify_proof_direct_grouped_ciphertext_3_handles_validity.challenges
                                            proof transcript
                                        comb (sc cw.2)
                                            (Grouped3.eqns (sc proof.zr) (sc proof.zx) (sc cw.1) P₁
                                              P₂ P₃ C D₁ D₂ D₃ Y₀ Y₁ Y₂ Y₃) =
                                          0 := by
  unfold fd_zksdk_verify_proof_direct_grouped_ciphertext_3_handles_validity
  simp only [Id.run, ne_self_iff_false, ↓reduceIte]
  by_cases hr : proof.zr.toNat < ell
  swap
  · simp [fd_curve25519_scalar_validate.eq_false hr, hr]
  by_cases hx : proof.zx.toNat < ell
  swap
  · simp [fd_curve25519_scalar_validate.eq_true hr, fd_curve25519_scalar_validate.eq_false hx, hx]
  simp only [fd_curve25519_scalar_validate.eq_true hr, fd_curve25519_scalar_validate.eq_true hx,
    Bool.not_true, Bool.false_eq_true, ↓reduceIte]
  decompress_cases proof.y0 with A₀ Y₀ hA₀ hY₀
  decompress_cases comm with A₁ C hA₁ hC
  decompress_cases pubkey1 with A₂ P₁ hA₂ hP₁
  decompress_cases proof.y1 with A₃ Y₁ hA₃ hY₁
  decompress_cases handle1 with A₄ D₁ hA₄ hD₁
  decompress_cases pubkey2 with A₅ P₂ hA₅ hP₂
  decompress_cases proof.y2 with A₆ Y₂ hA₆ hY₂
  decompress_cases handle2 with A₇ D₂ hA₇ hD₂
  decompress_cases pubkey3 with A₈ P₃ hA₈ hP₃
  decompress_cases proof.y3 with A₉ Y₃ hA₉ hY₃
  decompress_cases handle3 with A₁₀ D₃ hA₁₀ hD₃
  simp only [fd_rangeproofs_transcript_validate_and_append_point.snd]
  by_cases hy0 : proof.y0 = fd_ristretto255_compressed_zero
  · simp [hy0]
  by_cases hy1 : proof.y1 = fd_ristretto255_compressed_zero
  · simp [hy0, hy1]
  by_cases hy2 : proof.y2 = fd_ristretto255_compressed_zero
  · simp [hy0, hy1, hy2]
  simp only [hy0, hy1, hy2, ↓reduceIte, FD_TRANSCRIPT_SUCCESS_or, ne_self_iff_false,
    fd_rangeproofs_transcript_validate_and_append_point.fst _ _ hy0,
    fd_rangeproofs_transcript_validate_and_append_point.fst _ _ hy1,
    fd_rangeproofs_transcript_validate_and_append_point.fst _ _ hy2]
  generalize hwd : (fd_rangeproofs_transcript_challenge_scalar _ (FD_TRANSCRIPT_LITERAL "w")).2 = w
  generalize hcd : (fd_rangeproofs_transcript_challenge_scalar _ (FD_TRANSCRIPT_LITERAL "c")).2 = c
  have hcw :
    fd_zksdk_verify_proof_direct_grouped_ciphertext_3_handles_validity.challenges proof transcript =
      (c, w) := by
    rw [← hcd, ← hwd]; rfl
  simp only [hcw]
  rw [ret_ite_msm
      (ptsOf
        [⟨basePoint, basePoint_mem_Dom⟩, ⟨Hpt, Hpt_mem_Dom⟩, C, P₁, Y₁, D₁, P₂, Y₂, D₂, P₃, Y₃, D₃])
      ?_ ?_ hA₀.1]
  rotate_left
  msm_sides 12
  msm_sum_simp
  simp only [ne_eq, hy0, hy1, hy2, not_false_eq_true, hr, hx, true_and, hP₁, hP₂, hP₃, hC, hD₁, hD₂,
    hD₃, hY₀, hY₁, hY₂, hY₃, exists_and_left, exists_eq_left]
  simp only [comb, Fin.sum_univ_four, Grouped3.eqns]
  simp
  constructor <;> intro h <;> linear_combination (norm := module) h

set_option maxHeartbeats 800000 in
/-- The direct verifier, batched with `t`: as unbatched, on the batched ciphertext
`(C + t C_hi, Dᵢ + t Dᵢ_hi)`, all eight decoding. -/
public theorem
  fd_zksdk_verify_proof_direct_grouped_ciphertext_3_handles_validity.ret_eq_success_iff_batched
    [PrimeOrder] (proof : fd_zksdk_grp_ciph_3h_val_proof_t)
    (pubkey1 pubkey2 pubkey3 comm handle1 handle2 handle3 comm_hi handle1_hi handle2_hi handle3_hi
      challenge_t : BitVec 256)
    {batched : BitVec 32} (hb : batched ≠ 0#32) (transcript : fd_merlin_transcript_t) :
    (fd_zksdk_verify_proof_direct_grouped_ciphertext_3_handles_validity proof pubkey1 pubkey2
            pubkey3 comm handle1 handle2 handle3 comm_hi handle1_hi handle2_hi handle3_hi
            challenge_t batched transcript).ret =
        FD_ZKSDK_VERIFY_PROOF_SUCCESS ↔
      proof.y0 ≠ fd_ristretto255_compressed_zero ∧
        proof.y1 ≠ fd_ristretto255_compressed_zero ∧
          proof.y2 ≠ fd_ristretto255_compressed_zero ∧
            proof.zr.toNat < ell ∧
              proof.zx.toNat < ell ∧
                ∃ P₁ P₂ P₃ C D₁ D₂ D₃ C_hi D₁_hi D₂_hi D₃_hi Y₀ Y₁ Y₂ Y₃,
                  DecodesTo pubkey1 P₁ ∧
                    DecodesTo pubkey2 P₂ ∧
                      DecodesTo pubkey3 P₃ ∧
                        DecodesTo comm C ∧
                          DecodesTo handle1 D₁ ∧
                            DecodesTo handle2 D₂ ∧
                              DecodesTo handle3 D₃ ∧
                                DecodesTo comm_hi C_hi ∧
                                  DecodesTo handle1_hi D₁_hi ∧
                                    DecodesTo handle2_hi D₂_hi ∧
                                      DecodesTo handle3_hi D₃_hi ∧
                                        DecodesTo proof.y0 Y₀ ∧
                                          DecodesTo proof.y1 Y₁ ∧
                                            DecodesTo proof.y2 Y₂ ∧
                                              DecodesTo proof.y3 Y₃ ∧
                                                let cw :=
                                                  fd_zksdk_verify_proof_direct_grouped_ciphertext_3_handles_validity.challenges
                                                    proof transcript
                                                let t := sc challenge_t
                                                comb (sc cw.2)
                                                    (Grouped3.eqns (sc proof.zr) (sc proof.zx)
                                                      (sc cw.1) P₁ P₂ P₃ (C + t • C_hi)
                                                      (D₁ + t • D₁_hi) (D₂ + t • D₂_hi)
                                                      (D₃ + t • D₃_hi) Y₀ Y₁ Y₂ Y₃) =
                                                  0 := by
  unfold fd_zksdk_verify_proof_direct_grouped_ciphertext_3_handles_validity
  simp only [Id.run, eq_true hb, ↓reduceIte]
  by_cases hr : proof.zr.toNat < ell
  swap
  · simp [fd_curve25519_scalar_validate.eq_false hr, hr]
  by_cases hx : proof.zx.toNat < ell
  swap
  · simp [fd_curve25519_scalar_validate.eq_true hr, fd_curve25519_scalar_validate.eq_false hx, hx]
  simp only [fd_curve25519_scalar_validate.eq_true hr, fd_curve25519_scalar_validate.eq_true hx,
    Bool.not_true, Bool.false_eq_true, ↓reduceIte]
  decompress_cases proof.y0 with A₀ Y₀ hA₀ hY₀
  decompress_cases comm with A₁ C hA₁ hC
  decompress_cases pubkey1 with A₂ P₁ hA₂ hP₁
  decompress_cases proof.y1 with A₃ Y₁ hA₃ hY₁
  decompress_cases handle1 with A₄ D₁ hA₄ hD₁
  decompress_cases pubkey2 with A₅ P₂ hA₅ hP₂
  decompress_cases proof.y2 with A₆ Y₂ hA₆ hY₂
  decompress_cases handle2 with A₇ D₂ hA₇ hD₂
  decompress_cases pubkey3 with A₈ P₃ hA₈ hP₃
  decompress_cases proof.y3 with A₉ Y₃ hA₉ hY₃
  decompress_cases handle3 with A₁₀ D₃ hA₁₀ hD₃
  decompress_cases comm_hi with A₁₁ C_hi hA₁₁ hC_hi
  decompress_cases handle1_hi with A₁₂ D₁_hi hA₁₂ hD₁_hi
  decompress_cases handle2_hi with A₁₃ D₂_hi hA₁₃ hD₂_hi
  decompress_cases handle3_hi with A₁₄ D₃_hi hA₁₄ hD₃_hi
  simp only [fd_rangeproofs_transcript_validate_and_append_point.snd]
  by_cases hy0 : proof.y0 = fd_ristretto255_compressed_zero
  · simp [hy0]
  by_cases hy1 : proof.y1 = fd_ristretto255_compressed_zero
  · simp [hy0, hy1]
  by_cases hy2 : proof.y2 = fd_ristretto255_compressed_zero
  · simp [hy0, hy1, hy2]
  simp only [hy0, hy1, hy2, ↓reduceIte, FD_TRANSCRIPT_SUCCESS_or, ne_self_iff_false,
    fd_rangeproofs_transcript_validate_and_append_point.fst _ _ hy0,
    fd_rangeproofs_transcript_validate_and_append_point.fst _ _ hy1,
    fd_rangeproofs_transcript_validate_and_append_point.fst _ _ hy2]
  generalize hwd : (fd_rangeproofs_transcript_challenge_scalar _ (FD_TRANSCRIPT_LITERAL "w")).2 = w
  generalize hcd : (fd_rangeproofs_transcript_challenge_scalar _ (FD_TRANSCRIPT_LITERAL "c")).2 = c
  have hcw :
    fd_zksdk_verify_proof_direct_grouped_ciphertext_3_handles_validity.challenges proof transcript =
      (c, w) := by
    rw [← hcd, ← hwd]; rfl
  simp only [hcw]
  rw [ret_ite_msm
      (ptsOf
        [⟨basePoint, basePoint_mem_Dom⟩, ⟨Hpt, Hpt_mem_Dom⟩, C, P₁, Y₁, D₁, P₂, Y₂, D₂, P₃, Y₃, D₃,
          C_hi, D₁_hi, D₂_hi, D₃_hi])
      ?_ ?_ hA₀.1]
  rotate_left
  msm_sides 16
  msm_sum_simp
  simp only [ne_eq, hy0, hy1, hy2, not_false_eq_true, hr, hx, true_and, hP₁, hP₂, hP₃, hC, hD₁, hD₂,
    hD₃, hY₀, hY₁, hY₂, hY₃, hC_hi, hD₁_hi, hD₂_hi, hD₃_hi, exists_and_left, exists_eq_left]
  simp only [comb, Fin.sum_univ_four, Grouped3.eqns]
  simp
  constructor <;> intro h <;> linear_combination (norm := module) h

/-- The challenges `(c, w)` of the non-batched verifier: the direct ones after the context hash. -/
@[expose]
public def fd_zksdk_verify_proof_grouped_ciphertext_3_handles_validity.challenges
    (proof : fd_zksdk_grp_ciph_3h_val_proof_t) (pubkey1 pubkey2 pubkey3 : BitVec 256)
    (grouped_ciphertext : grp_ciph_3h_t) (transcript : fd_merlin_transcript_t) :
    BitVec 256 × BitVec 256 :=
  fd_zksdk_verify_proof_direct_grouped_ciphertext_3_handles_validity.challenges proof
    (grouped_ciphertext_3_handles_validity.grouped_ciphertext_validity_hash_context transcript
      pubkey1 pubkey2 pubkey3 grouped_ciphertext)

/-- The non-batched verifier accepts exactly when `pubkey1`, `pubkey2`, the commitment, `Y₀`, `Y₁`,
`Y₂` are not the zero encoding, `z_r`, `z_x` are canonical, everything decodes, and
`Σₖ wᵏ Eₖ = 0` for zk-sdk's equations and the transcript's `c`, `w`. -/
public theorem fd_zksdk_verify_proof_grouped_ciphertext_3_handles_validity.ret_eq_success_iff
    [PrimeOrder] (proof : fd_zksdk_grp_ciph_3h_val_proof_t) (pubkey1 pubkey2 pubkey3 : BitVec 256)
    (g : grp_ciph_3h_t) (transcript : fd_merlin_transcript_t) :
    (fd_zksdk_verify_proof_grouped_ciphertext_3_handles_validity proof pubkey1 pubkey2 pubkey3 g
            transcript).ret =
        FD_ZKSDK_VERIFY_PROOF_SUCCESS ↔
      pubkey1 ≠ fd_ristretto255_compressed_zero ∧
        pubkey2 ≠ fd_ristretto255_compressed_zero ∧
          g.commitment ≠ fd_ristretto255_compressed_zero ∧
            proof.y0 ≠ fd_ristretto255_compressed_zero ∧
              proof.y1 ≠ fd_ristretto255_compressed_zero ∧
                proof.y2 ≠ fd_ristretto255_compressed_zero ∧
                  proof.zr.toNat < ell ∧
                    proof.zx.toNat < ell ∧
                      ∃ P₁ P₂ P₃ C D₁ D₂ D₃ Y₀ Y₁ Y₂ Y₃,
                        DecodesTo pubkey1 P₁ ∧
                          DecodesTo pubkey2 P₂ ∧
                            DecodesTo pubkey3 P₃ ∧
                              DecodesTo g.commitment C ∧
                                DecodesTo g.handles[0].handle D₁ ∧
                                  DecodesTo g.handles[1].handle D₂ ∧
                                    DecodesTo g.handles[2].handle D₃ ∧
                                      DecodesTo proof.y0 Y₀ ∧
                                        DecodesTo proof.y1 Y₁ ∧
                                          DecodesTo proof.y2 Y₂ ∧
                                            DecodesTo proof.y3 Y₃ ∧
                                              let cw :=
                                                fd_zksdk_verify_proof_grouped_ciphertext_3_handles_validity.challenges
                                                  proof pubkey1 pubkey2 pubkey3 g transcript
                                              comb (sc cw.2)
                                                  (Grouped3.eqns (sc proof.zr) (sc proof.zx)
                                                    (sc cw.1) P₁ P₂ P₃ C D₁ D₂ D₃ Y₀ Y₁ Y₂ Y₃) =
                                                0 := by
  unfold fd_zksdk_verify_proof_grouped_ciphertext_3_handles_validity
  by_cases hz :
    pubkey1 = fd_ristretto255_compressed_zero ∨
      pubkey2 = fd_ristretto255_compressed_zero ∨ g.commitment = fd_ristretto255_compressed_zero
  · refine iff_of_false (by simp [hz]) ?_
    rintro ⟨h1, h2, h3, -⟩
    rcases hz with h | h | h <;> contradiction
  simp only [hz, ↓reduceIte]
  simp only [not_or] at hz
  rw [fd_zksdk_verify_proof_direct_grouped_ciphertext_3_handles_validity.ret_eq_success_iff]
  simp only [ne_eq, hz.1, hz.2.1, hz.2.2, not_false_eq_true, true_and]
  rfl

/-- Completeness: if zk-sdk's four equations hold for the transcript's `c` (and the encodings decode
and pass the zero checks, `z_r`, `z_x` canonical), the non-batched verifier accepts. -/
public theorem fd_zksdk_verify_proof_grouped_ciphertext_3_handles_validity.complete [PrimeOrder]
    {proof : fd_zksdk_grp_ciph_3h_val_proof_t} {pubkey1 pubkey2 pubkey3 : BitVec 256}
    {g : grp_ciph_3h_t} {transcript : fd_merlin_transcript_t}
    {P₁ P₂ P₃ C D₁ D₂ D₃ Y₀ Y₁ Y₂ Y₃ : RGroup}
    (hz :
      pubkey1 ≠ fd_ristretto255_compressed_zero ∧
        pubkey2 ≠ fd_ristretto255_compressed_zero ∧
        g.commitment ≠ fd_ristretto255_compressed_zero ∧
        proof.y0 ≠ fd_ristretto255_compressed_zero ∧
        proof.y1 ≠ fd_ristretto255_compressed_zero ∧ proof.y2 ≠ fd_ristretto255_compressed_zero)
    (hs : proof.zr.toNat < ell ∧ proof.zx.toNat < ell)
    (hd :
      DecodesTo pubkey1 P₁ ∧
        DecodesTo pubkey2 P₂ ∧
        DecodesTo pubkey3 P₃ ∧
        DecodesTo g.commitment C ∧
        DecodesTo g.handles[0].handle D₁ ∧
        DecodesTo g.handles[1].handle D₂ ∧
        DecodesTo g.handles[2].handle D₃ ∧
        DecodesTo proof.y0 Y₀ ∧
        DecodesTo proof.y1 Y₁ ∧ DecodesTo proof.y2 Y₂ ∧ DecodesTo proof.y3 Y₃)
    (hE :
      ∀ k,
        Grouped3.eqns (sc proof.zr) (sc proof.zx)
            (sc
              (fd_zksdk_verify_proof_grouped_ciphertext_3_handles_validity.challenges proof pubkey1
                  pubkey2 pubkey3 g transcript).1)
            P₁ P₂ P₃ C D₁ D₂ D₃ Y₀ Y₁ Y₂ Y₃ k =
          0) :
    (fd_zksdk_verify_proof_grouped_ciphertext_3_handles_validity proof pubkey1 pubkey2 pubkey3 g
          transcript).ret =
      FD_ZKSDK_VERIFY_PROOF_SUCCESS := by
  obtain ⟨z1, z2, z3, z4, z5, z6⟩ := hz
  obtain ⟨d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11⟩ := hd
  exact
    (fd_zksdk_verify_proof_grouped_ciphertext_3_handles_validity.ret_eq_success_iff ..).2
      ⟨z1, z2, z3, z4, z5, z6, hs.1, hs.2, P₁, P₂, P₃, C, D₁, D₂, D₃, Y₀, Y₁, Y₂, Y₃, d1, d2, d3,
        d4, d5, d6, d7, d8, d9, d10, d11, comb_eq_zero _ hE⟩

/-- Soundness: if the non-batched verifier accepts, zk-sdk's four equations hold for the
transcript's `c`, or the transcript's `w` is one of the at most three roots of `Σₖ Eₖ Xᵏ`. -/
public theorem fd_zksdk_verify_proof_grouped_ciphertext_3_handles_validity.sound [PrimeOrder]
    {proof : fd_zksdk_grp_ciph_3h_val_proof_t} {pubkey1 pubkey2 pubkey3 : BitVec 256}
    {g : grp_ciph_3h_t} {transcript : fd_merlin_transcript_t}
    {P₁ P₂ P₃ C D₁ D₂ D₃ Y₀ Y₁ Y₂ Y₃ : RGroup}
    (hd :
      DecodesTo pubkey1 P₁ ∧
        DecodesTo pubkey2 P₂ ∧
        DecodesTo pubkey3 P₃ ∧
        DecodesTo g.commitment C ∧
        DecodesTo g.handles[0].handle D₁ ∧
        DecodesTo g.handles[1].handle D₂ ∧
        DecodesTo g.handles[2].handle D₃ ∧
        DecodesTo proof.y0 Y₀ ∧
        DecodesTo proof.y1 Y₁ ∧ DecodesTo proof.y2 Y₂ ∧ DecodesTo proof.y3 Y₃)
    (h :
      (fd_zksdk_verify_proof_grouped_ciphertext_3_handles_validity proof pubkey1 pubkey2 pubkey3 g
            transcript).ret =
        FD_ZKSDK_VERIFY_PROOF_SUCCESS) :
    let cw :=
      fd_zksdk_verify_proof_grouped_ciphertext_3_handles_validity.challenges proof pubkey1 pubkey2
        pubkey3 g transcript
    let E := Grouped3.eqns (sc proof.zr) (sc proof.zx) (sc cw.1) P₁ P₂ P₃ C D₁ D₂ D₃ Y₀ Y₁ Y₂ Y₃
    (∀ k, E k = 0) ∨ sc cw.2 ∈ badW E := by
  obtain ⟨d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11⟩ := hd
  obtain
    ⟨-, -, -, -, -, -, -, -, P₁', P₂', P₃', C', D₁', D₂', D₃', Y₀', Y₁', Y₂', Y₃', e1, e2, e3, e4,
      e5, e6, e7, e8, e9, e10, e11, hc⟩ :=
    (fd_zksdk_verify_proof_grouped_ciphertext_3_handles_validity.ret_eq_success_iff ..).1 h
  rw [e1.unique d1, e2.unique d2, e3.unique d3, e4.unique d4, e5.unique d5, e6.unique d6,
    e7.unique d7, e8.unique d8, e9.unique d9, e10.unique d10, e11.unique d11] at hc
  exact eq_zero_or_mem_badW hc

end MLIR.Firedancer.Ref
