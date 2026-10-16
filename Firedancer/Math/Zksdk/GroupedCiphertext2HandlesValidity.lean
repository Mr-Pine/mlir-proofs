module

public import Firedancer.Math.Zksdk.Common
public import Firedancer.Ref.fd_zksdk_grouped_ciphertext_2_handles_validity
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Module

/-! The 2-handle grouped-ciphertext validity verifier (`fd_zksdk_verify_proof_direct_…`, direct and
batched, and the non-batched wrapper) against zk-sdk's `grouped_ciphertext_validity/handles_2.rs`;
both batch the three equations as `E₀ + w E₁ + w² E₂`. `pubkey2`, `Y₂` and the second handle are
never zero-checked, and the second handle's equation is always checked (the 8f92ee371 fix). -/

namespace MLIR.Firedancer.Ref

open _root_.Ed25519 _root_.Ed25519.Ristretto fd_zksdk

@[expose] public section

/-- The challenges `(c, w)` the direct verifier's transcript derives on the accepting path. -/
def fd_zksdk_verify_proof_direct_grouped_ciphertext_2_handles_validity.challenges
    (proof : fd_zksdk_grp_ciph_2h_val_proof_t) (transcript : fd_merlin_transcript_t) :
    BitVec 256 × BitVec 256 :=
  let transcript := fd_zksdk_transcript_domsep_grp_ciph_val_proof transcript 2#64
  let transcript :=
    fd_zksdk_transcript_append_point transcript (FD_TRANSCRIPT_LITERAL "Y_0") proof.y0
  let transcript :=
    fd_zksdk_transcript_append_point transcript (FD_TRANSCRIPT_LITERAL "Y_1") proof.y1
  let transcript :=
    fd_zksdk_transcript_append_point transcript (FD_TRANSCRIPT_LITERAL "Y_2") proof.y2
  let c := fd_zksdk_transcript_challenge_scalar transcript (FD_TRANSCRIPT_LITERAL "c")
  let transcript := fd_zksdk_transcript_append_scalar c.1 (FD_TRANSCRIPT_LITERAL "z_r") proof.zr
  let transcript :=
    fd_zksdk_transcript_append_scalar transcript (FD_TRANSCRIPT_LITERAL "z_x") proof.zx
  let w := fd_zksdk_transcript_challenge_scalar transcript (FD_TRANSCRIPT_LITERAL "w")
  (c.2, w.2)

/-- zk-sdk's equations, each as `lhs - rhs`: `z_r H + z_x G = c C + Y₀`, `z_r P₁ = c D₁ + Y₁`,
`z_r P₂ = c D₂ + Y₂`. -/
noncomputable def Grouped2.eqns [PrimeOrder] (zr zx c : ZMod ell)
    (P₁ P₂ C D₁ D₂ Y₀ Y₁ Y₂ : RGroup) : Fin 3 → RGroup :=
  ![zr • H + zx • G - c • C - Y₀, zr • P₁ - c • D₁ - Y₁, zr • P₂ - c • D₂ - Y₂]

end

/-- The direct verifier, not batched: accepts exactly when `Y₀`, `Y₁` are not the zero encoding,
`z_r`, `z_x` are canonical, everything decodes, and `Σₖ wᵏ Eₖ = 0` for the transcript's `c`, `w`. -/
public theorem fd_zksdk_verify_proof_direct_grouped_ciphertext_2_handles_validity.ret_eq_success_iff
    [PrimeOrder] (proof : fd_zksdk_grp_ciph_2h_val_proof_t)
    (pubkey1 pubkey2 comm handle1 handle2 comm_hi handle1_hi handle2_hi challenge_t : BitVec 256)
    (transcript : fd_merlin_transcript_t) :
    (fd_zksdk_verify_proof_direct_grouped_ciphertext_2_handles_validity proof pubkey1 pubkey2 comm
            handle1 handle2 comm_hi handle1_hi handle2_hi challenge_t 0#32 transcript).ret =
        FD_ZKSDK_VERIFY_PROOF_SUCCESS ↔
      proof.y0 ≠ fd_ristretto255_compressed_zero ∧
        proof.y1 ≠ fd_ristretto255_compressed_zero ∧
          proof.zr.toNat < ell ∧
            proof.zx.toNat < ell ∧
              ∃ P₁ P₂ C D₁ D₂ Y₀ Y₁ Y₂,
                DecodesTo pubkey1 P₁ ∧
                  DecodesTo pubkey2 P₂ ∧
                    DecodesTo comm C ∧
                      DecodesTo handle1 D₁ ∧
                        DecodesTo handle2 D₂ ∧
                          DecodesTo proof.y0 Y₀ ∧
                            DecodesTo proof.y1 Y₁ ∧
                              DecodesTo proof.y2 Y₂ ∧
                                let cw :=
                                  fd_zksdk_verify_proof_direct_grouped_ciphertext_2_handles_validity.challenges
                                    proof transcript
                                comb (sc cw.2)
                                    (Grouped2.eqns (sc proof.zr) (sc proof.zx) (sc cw.1) P₁ P₂ C D₁
                                      D₂ Y₀ Y₁ Y₂) =
                                  0 := by
  unfold fd_zksdk_verify_proof_direct_grouped_ciphertext_2_handles_validity
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
  decompress_cases proof.y1 with A₁ Y₁ hA₁ hY₁
  decompress_cases proof.y2 with A₂ Y₂ hA₂ hY₂
  decompress_cases pubkey1 with A₃ P₁ hA₃ hP₁
  decompress_cases comm with A₄ C hA₄ hC
  decompress_cases handle1 with A₅ D₁ hA₅ hD₁
  decompress_cases pubkey2 with A₆ P₂ hA₆ hP₂
  decompress_cases handle2 with A₇ D₂ hA₇ hD₂
  simp only [fd_rangeproofs_transcript_validate_and_append_point.snd]
  by_cases hy0 : proof.y0 = fd_ristretto255_compressed_zero
  · simp [hy0]
  by_cases hy1 : proof.y1 = fd_ristretto255_compressed_zero
  · simp [hy0, hy1]
  simp only [hy0, hy1, ↓reduceIte, FD_TRANSCRIPT_SUCCESS_or, ne_self_iff_false,
    fd_rangeproofs_transcript_validate_and_append_point.fst _ _ hy0,
    fd_rangeproofs_transcript_validate_and_append_point.fst _ _ hy1]
  generalize hwd : (fd_rangeproofs_transcript_challenge_scalar _ (FD_TRANSCRIPT_LITERAL "w")).2 = w
  generalize hcd : (fd_rangeproofs_transcript_challenge_scalar _ (FD_TRANSCRIPT_LITERAL "c")).2 = c
  have hcw :
    fd_zksdk_verify_proof_direct_grouped_ciphertext_2_handles_validity.challenges proof transcript =
      (c, w) := by
    rw [← hcd, ← hwd]; rfl
  simp only [hcw]
  rw [ret_ite_msm
      (ptsOf [⟨basePoint, basePoint_mem_Dom⟩, ⟨Hpt, Hpt_mem_Dom⟩, Y₁, Y₂, P₁, C, D₁, P₂, D₂]) ?_ ?_
      hA₀.1]
  rotate_left
  msm_sides 9
  rw [show (7#64 + 1#64 + 1#64 : BitVec 64).toNat = 9 from rfl]
  msm_sum_simp
  simp only [ne_eq, hy0, hy1, not_false_eq_true, hr, hx, true_and, hP₁, hP₂, hC, hD₁, hD₂, hY₀, hY₁,
    hY₂, exists_and_left, exists_eq_left]
  simp only [comb, Fin.sum_univ_three, Grouped2.eqns]
  simp
  constructor <;> intro h <;> linear_combination (norm := module) h

/-- The direct verifier, batched with `t`: as unbatched, on the batched ciphertext
`(C + t C_hi, D₁ + t D₁_hi, D₂ + t D₂_hi)`, all six decoding. -/
public theorem
  fd_zksdk_verify_proof_direct_grouped_ciphertext_2_handles_validity.ret_eq_success_iff_batched
    [PrimeOrder] (proof : fd_zksdk_grp_ciph_2h_val_proof_t)
    (pubkey1 pubkey2 comm handle1 handle2 comm_hi handle1_hi handle2_hi challenge_t : BitVec 256)
    {batched : BitVec 32} (hb : batched ≠ 0#32) (transcript : fd_merlin_transcript_t) :
    (fd_zksdk_verify_proof_direct_grouped_ciphertext_2_handles_validity proof pubkey1 pubkey2 comm
            handle1 handle2 comm_hi handle1_hi handle2_hi challenge_t batched transcript).ret =
        FD_ZKSDK_VERIFY_PROOF_SUCCESS ↔
      proof.y0 ≠ fd_ristretto255_compressed_zero ∧
        proof.y1 ≠ fd_ristretto255_compressed_zero ∧
          proof.zr.toNat < ell ∧
            proof.zx.toNat < ell ∧
              ∃ P₁ P₂ C D₁ D₂ C_hi D₁_hi D₂_hi Y₀ Y₁ Y₂,
                DecodesTo pubkey1 P₁ ∧
                  DecodesTo pubkey2 P₂ ∧
                    DecodesTo comm C ∧
                      DecodesTo handle1 D₁ ∧
                        DecodesTo handle2 D₂ ∧
                          DecodesTo comm_hi C_hi ∧
                            DecodesTo handle1_hi D₁_hi ∧
                              DecodesTo handle2_hi D₂_hi ∧
                                DecodesTo proof.y0 Y₀ ∧
                                  DecodesTo proof.y1 Y₁ ∧
                                    DecodesTo proof.y2 Y₂ ∧
                                      let cw :=
                                        fd_zksdk_verify_proof_direct_grouped_ciphertext_2_handles_validity.challenges
                                          proof transcript
                                      let t := sc challenge_t
                                      comb (sc cw.2)
                                          (Grouped2.eqns (sc proof.zr) (sc proof.zx) (sc cw.1) P₁ P₂
                                            (C + t • C_hi) (D₁ + t • D₁_hi) (D₂ + t • D₂_hi) Y₀ Y₁
                                            Y₂) =
                                        0 := by
  unfold fd_zksdk_verify_proof_direct_grouped_ciphertext_2_handles_validity
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
  decompress_cases proof.y1 with A₁ Y₁ hA₁ hY₁
  decompress_cases proof.y2 with A₂ Y₂ hA₂ hY₂
  decompress_cases pubkey1 with A₃ P₁ hA₃ hP₁
  decompress_cases comm with A₄ C hA₄ hC
  decompress_cases handle1 with A₅ D₁ hA₅ hD₁
  decompress_cases comm_hi with A₆ C_hi hA₆ hC_hi
  decompress_cases handle1_hi with A₇ D₁_hi hA₇ hD₁_hi
  decompress_cases pubkey2 with A₈ P₂ hA₈ hP₂
  decompress_cases handle2 with A₉ D₂ hA₉ hD₂
  decompress_cases handle2_hi with A₁₀ D₂_hi hA₁₀ hD₂_hi
  simp only [fd_rangeproofs_transcript_validate_and_append_point.snd]
  by_cases hy0 : proof.y0 = fd_ristretto255_compressed_zero
  · simp [hy0]
  by_cases hy1 : proof.y1 = fd_ristretto255_compressed_zero
  · simp [hy0, hy1]
  simp only [hy0, hy1, ↓reduceIte, FD_TRANSCRIPT_SUCCESS_or, ne_self_iff_false,
    fd_rangeproofs_transcript_validate_and_append_point.fst _ _ hy0,
    fd_rangeproofs_transcript_validate_and_append_point.fst _ _ hy1]
  generalize hwd : (fd_rangeproofs_transcript_challenge_scalar _ (FD_TRANSCRIPT_LITERAL "w")).2 = w
  generalize hcd : (fd_rangeproofs_transcript_challenge_scalar _ (FD_TRANSCRIPT_LITERAL "c")).2 = c
  have hcw :
    fd_zksdk_verify_proof_direct_grouped_ciphertext_2_handles_validity.challenges proof transcript =
      (c, w) := by
    rw [← hcd, ← hwd]; rfl
  simp only [hcw]
  rw [ret_ite_msm
      (ptsOf
        [⟨basePoint, basePoint_mem_Dom⟩, ⟨Hpt, Hpt_mem_Dom⟩, Y₁, Y₂, P₁, C, D₁, C_hi, D₁_hi, P₂, D₂,
          D₂_hi])
      ?_ ?_ hA₀.1]
  rotate_left
  msm_sides 12
  rw [show (7#64 + 1#64 + 1#64 + 1#64 + 1#64 + 1#64 : BitVec 64).toNat = 12 from rfl]
  msm_sum_simp
  simp only [ne_eq, hy0, hy1, not_false_eq_true, hr, hx, true_and, hP₁, hP₂, hC, hD₁, hD₂, hC_hi,
    hD₁_hi, hD₂_hi, hY₀, hY₁, hY₂, exists_and_left, exists_eq_left]
  simp only [comb, Fin.sum_univ_three, Grouped2.eqns]
  simp
  constructor <;> intro h <;> linear_combination (norm := module) h

/-- The challenges `(c, w)` of the non-batched verifier: the direct ones after the context hash. -/
@[expose]
public def fd_zksdk_verify_proof_grouped_ciphertext_2_handles_validity.challenges
    (proof : fd_zksdk_grp_ciph_2h_val_proof_t) (pubkey1 pubkey2 : BitVec 256)
    (grouped_ciphertext : grp_ciph_2h_t) (transcript : fd_merlin_transcript_t) :
    BitVec 256 × BitVec 256 :=
  fd_zksdk_verify_proof_direct_grouped_ciphertext_2_handles_validity.challenges proof
    (grouped_ciphertext_2_handles_validity.grouped_ciphertext_validity_hash_context transcript
      pubkey1 pubkey2 grouped_ciphertext)

/-- The non-batched verifier accepts exactly when `pubkey1`, the commitment, `Y₀`, `Y₁` are not the
zero encoding, `z_r`, `z_x` are canonical, everything decodes, and `Σₖ wᵏ Eₖ = 0` for zk-sdk's
equations and the transcript's `c`, `w`. -/
public theorem fd_zksdk_verify_proof_grouped_ciphertext_2_handles_validity.ret_eq_success_iff
    [PrimeOrder] (proof : fd_zksdk_grp_ciph_2h_val_proof_t) (pubkey1 pubkey2 : BitVec 256)
    (grouped_ciphertext : grp_ciph_2h_t) (transcript : fd_merlin_transcript_t) :
    (fd_zksdk_verify_proof_grouped_ciphertext_2_handles_validity proof pubkey1 pubkey2
            grouped_ciphertext transcript).ret =
        FD_ZKSDK_VERIFY_PROOF_SUCCESS ↔
      pubkey1 ≠ fd_ristretto255_compressed_zero ∧
        grouped_ciphertext.commitment ≠ fd_ristretto255_compressed_zero ∧
          proof.y0 ≠ fd_ristretto255_compressed_zero ∧
            proof.y1 ≠ fd_ristretto255_compressed_zero ∧
              proof.zr.toNat < ell ∧
                proof.zx.toNat < ell ∧
                  ∃ P₁ P₂ C D₁ D₂ Y₀ Y₁ Y₂,
                    DecodesTo pubkey1 P₁ ∧
                      DecodesTo pubkey2 P₂ ∧
                        DecodesTo grouped_ciphertext.commitment C ∧
                          DecodesTo grouped_ciphertext.handles[0].handle D₁ ∧
                            DecodesTo grouped_ciphertext.handles[1].handle D₂ ∧
                              DecodesTo proof.y0 Y₀ ∧
                                DecodesTo proof.y1 Y₁ ∧
                                  DecodesTo proof.y2 Y₂ ∧
                                    let cw :=
                                      fd_zksdk_verify_proof_grouped_ciphertext_2_handles_validity.challenges
                                        proof pubkey1 pubkey2 grouped_ciphertext transcript
                                    comb (sc cw.2)
                                        (Grouped2.eqns (sc proof.zr) (sc proof.zx) (sc cw.1) P₁ P₂ C
                                          D₁ D₂ Y₀ Y₁ Y₂) =
                                      0 := by
  unfold fd_zksdk_verify_proof_grouped_ciphertext_2_handles_validity
  by_cases hz :
    pubkey1 = fd_ristretto255_compressed_zero ∨
      grouped_ciphertext.commitment = fd_ristretto255_compressed_zero
  · refine iff_of_false (by simp [hz]) ?_
    rintro ⟨h1, h2, -⟩
    rcases hz with h | h <;> contradiction
  simp only [hz, ↓reduceIte]
  simp only [not_or] at hz
  rw [fd_zksdk_verify_proof_direct_grouped_ciphertext_2_handles_validity.ret_eq_success_iff]
  simp only [ne_eq, hz.1, hz.2, not_false_eq_true, true_and]
  rfl

/-- The 8f92ee371 regression: with `pubkey2` the zero encoding (the identity, allowed), the verifier
still checks the second handle's equation, now `0 = c D₂ + Y₂`. -/
public theorem
  fd_zksdk_verify_proof_grouped_ciphertext_2_handles_validity.ret_eq_success_iff_of_pubkey2_zero
    [PrimeOrder] (proof : fd_zksdk_grp_ciph_2h_val_proof_t) (pubkey1 : BitVec 256)
    (grouped_ciphertext : grp_ciph_2h_t) (transcript : fd_merlin_transcript_t) :
    (fd_zksdk_verify_proof_grouped_ciphertext_2_handles_validity proof pubkey1
            fd_ristretto255_compressed_zero grouped_ciphertext transcript).ret =
        FD_ZKSDK_VERIFY_PROOF_SUCCESS ↔
      pubkey1 ≠ fd_ristretto255_compressed_zero ∧
        grouped_ciphertext.commitment ≠ fd_ristretto255_compressed_zero ∧
          proof.y0 ≠ fd_ristretto255_compressed_zero ∧
            proof.y1 ≠ fd_ristretto255_compressed_zero ∧
              proof.zr.toNat < ell ∧
                proof.zx.toNat < ell ∧
                  ∃ P₁ C D₁ D₂ Y₀ Y₁ Y₂,
                    DecodesTo pubkey1 P₁ ∧
                      DecodesTo grouped_ciphertext.commitment C ∧
                        DecodesTo grouped_ciphertext.handles[0].handle D₁ ∧
                          DecodesTo grouped_ciphertext.handles[1].handle D₂ ∧
                            DecodesTo proof.y0 Y₀ ∧
                              DecodesTo proof.y1 Y₁ ∧
                                DecodesTo proof.y2 Y₂ ∧
                                  let cw :=
                                    fd_zksdk_verify_proof_grouped_ciphertext_2_handles_validity.challenges
                                      proof pubkey1 fd_ristretto255_compressed_zero
                                      grouped_ciphertext transcript
                                  let c := sc cw.1
                                  comb (sc cw.2)
                                      ![sc proof.zr • H + sc proof.zx • G - c • C - Y₀,
                                        sc proof.zr • P₁ - c • D₁ - Y₁, -(c • D₂) - Y₂] =
                                    0 := by
  rw [fd_zksdk_verify_proof_grouped_ciphertext_2_handles_validity.ret_eq_success_iff]
  simp only [decodesTo_compressed_zero, exists_and_left, exists_eq_left, Grouped2.eqns, smul_zero,
    zero_sub]

/-- With `pubkey2` the zero encoding, an accepting proof forces `c D₂ + Y₂ = 0` (with the other two
equations) unless the transcript's `w` is one of the at most two bad challenges. -/
public theorem fd_zksdk_verify_proof_grouped_ciphertext_2_handles_validity.handle2_of_pubkey2_zero
    [PrimeOrder] {proof : fd_zksdk_grp_ciph_2h_val_proof_t} {pubkey1 : BitVec 256}
    {grouped_ciphertext : grp_ciph_2h_t} {transcript : fd_merlin_transcript_t}
    {P₁ C D₁ D₂ Y₀ Y₁ Y₂ : RGroup}
    (hd :
      DecodesTo pubkey1 P₁ ∧
        DecodesTo grouped_ciphertext.commitment C ∧
        DecodesTo grouped_ciphertext.handles[0].handle D₁ ∧
        DecodesTo grouped_ciphertext.handles[1].handle D₂ ∧
        DecodesTo proof.y0 Y₀ ∧ DecodesTo proof.y1 Y₁ ∧ DecodesTo proof.y2 Y₂)
    (h :
      (fd_zksdk_verify_proof_grouped_ciphertext_2_handles_validity proof pubkey1
            fd_ristretto255_compressed_zero grouped_ciphertext transcript).ret =
        FD_ZKSDK_VERIFY_PROOF_SUCCESS) :
    let cw :=
      fd_zksdk_verify_proof_grouped_ciphertext_2_handles_validity.challenges proof pubkey1
        fd_ristretto255_compressed_zero grouped_ciphertext transcript
    let E := Grouped2.eqns (sc proof.zr) (sc proof.zx) (sc cw.1) P₁ 0 C D₁ D₂ Y₀ Y₁ Y₂
    (sc cw.1 • D₂ + Y₂ = 0 ∧ ∀ k, E k = 0) ∨ sc cw.2 ∈ badW E := by
  obtain ⟨d1, d2, d3, d4, d5, d6, d7⟩ := hd
  obtain
    ⟨-, -, -, -, -, -, P₁', P₂', C', D₁', D₂', Y₀', Y₁', Y₂', e1, e2, e3, e4, e5, e6, e7, e8, hc⟩ :=
    (fd_zksdk_verify_proof_grouped_ciphertext_2_handles_validity.ret_eq_success_iff ..).1 h
  rw [e1.unique d1, (decodesTo_compressed_zero _).1 e2, e3.unique d2, e4.unique d3, e5.unique d4,
    e6.unique d5, e7.unique d6, e8.unique d7] at hc
  rcases eq_zero_or_mem_badW hc with h0 | h0
  · refine .inl ⟨?_, h0⟩
    have := h0 2
    simp only [Grouped2.eqns] at this
    simp at this
    linear_combination (norm := module) -this
  · exact .inr h0

/-- Completeness: if zk-sdk's three equations hold for the transcript's `c` (and the encodings decode
and pass the zero checks, `z_r`, `z_x` canonical), the non-batched verifier accepts. -/
public theorem fd_zksdk_verify_proof_grouped_ciphertext_2_handles_validity.complete [PrimeOrder]
    {proof : fd_zksdk_grp_ciph_2h_val_proof_t} {pubkey1 pubkey2 : BitVec 256}
    {grouped_ciphertext : grp_ciph_2h_t} {transcript : fd_merlin_transcript_t}
    {P₁ P₂ C D₁ D₂ Y₀ Y₁ Y₂ : RGroup}
    (hz :
      pubkey1 ≠ fd_ristretto255_compressed_zero ∧
        grouped_ciphertext.commitment ≠ fd_ristretto255_compressed_zero ∧
        proof.y0 ≠ fd_ristretto255_compressed_zero ∧ proof.y1 ≠ fd_ristretto255_compressed_zero)
    (hs : proof.zr.toNat < ell ∧ proof.zx.toNat < ell)
    (hd :
      DecodesTo pubkey1 P₁ ∧
        DecodesTo pubkey2 P₂ ∧
        DecodesTo grouped_ciphertext.commitment C ∧
        DecodesTo grouped_ciphertext.handles[0].handle D₁ ∧
        DecodesTo grouped_ciphertext.handles[1].handle D₂ ∧
        DecodesTo proof.y0 Y₀ ∧ DecodesTo proof.y1 Y₁ ∧ DecodesTo proof.y2 Y₂)
    (hE :
      ∀ k,
        Grouped2.eqns (sc proof.zr) (sc proof.zx)
            (sc
              (fd_zksdk_verify_proof_grouped_ciphertext_2_handles_validity.challenges proof pubkey1
                  pubkey2 grouped_ciphertext transcript).1)
            P₁ P₂ C D₁ D₂ Y₀ Y₁ Y₂ k =
          0) :
    (fd_zksdk_verify_proof_grouped_ciphertext_2_handles_validity proof pubkey1 pubkey2
          grouped_ciphertext transcript).ret =
      FD_ZKSDK_VERIFY_PROOF_SUCCESS := by
  obtain ⟨z1, z2, z3, z4⟩ := hz
  obtain ⟨d1, d2, d3, d4, d5, d6, d7, d8⟩ := hd
  exact
    (fd_zksdk_verify_proof_grouped_ciphertext_2_handles_validity.ret_eq_success_iff ..).2
      ⟨z1, z2, z3, z4, hs.1, hs.2, P₁, P₂, C, D₁, D₂, Y₀, Y₁, Y₂, d1, d2, d3, d4, d5, d6, d7, d8,
        comb_eq_zero _ hE⟩

/-- Soundness: if the non-batched verifier accepts, zk-sdk's three equations hold for the
transcript's `c`, or the transcript's `w` is one of the at most two roots of `Σₖ Eₖ Xᵏ`. -/
public theorem fd_zksdk_verify_proof_grouped_ciphertext_2_handles_validity.sound [PrimeOrder]
    {proof : fd_zksdk_grp_ciph_2h_val_proof_t} {pubkey1 pubkey2 : BitVec 256}
    {grouped_ciphertext : grp_ciph_2h_t} {transcript : fd_merlin_transcript_t}
    {P₁ P₂ C D₁ D₂ Y₀ Y₁ Y₂ : RGroup}
    (hd :
      DecodesTo pubkey1 P₁ ∧
        DecodesTo pubkey2 P₂ ∧
        DecodesTo grouped_ciphertext.commitment C ∧
        DecodesTo grouped_ciphertext.handles[0].handle D₁ ∧
        DecodesTo grouped_ciphertext.handles[1].handle D₂ ∧
        DecodesTo proof.y0 Y₀ ∧ DecodesTo proof.y1 Y₁ ∧ DecodesTo proof.y2 Y₂)
    (h :
      (fd_zksdk_verify_proof_grouped_ciphertext_2_handles_validity proof pubkey1 pubkey2
            grouped_ciphertext transcript).ret =
        FD_ZKSDK_VERIFY_PROOF_SUCCESS) :
    let cw :=
      fd_zksdk_verify_proof_grouped_ciphertext_2_handles_validity.challenges proof pubkey1 pubkey2
        grouped_ciphertext transcript
    let E := Grouped2.eqns (sc proof.zr) (sc proof.zx) (sc cw.1) P₁ P₂ C D₁ D₂ Y₀ Y₁ Y₂
    (∀ k, E k = 0) ∨ sc cw.2 ∈ badW E := by
  obtain ⟨d1, d2, d3, d4, d5, d6, d7, d8⟩ := hd
  obtain
    ⟨-, -, -, -, -, -, P₁', P₂', C', D₁', D₂', Y₀', Y₁', Y₂', e1, e2, e3, e4, e5, e6, e7, e8, hc⟩ :=
    (fd_zksdk_verify_proof_grouped_ciphertext_2_handles_validity.ret_eq_success_iff ..).1 h
  rw [e1.unique d1, e2.unique d2, e3.unique d3, e4.unique d4, e5.unique d5, e6.unique d6,
    e7.unique d7, e8.unique d8] at hc
  exact eq_zero_or_mem_badW hc

end MLIR.Firedancer.Ref
