module

public import Firedancer.Math.Zksdk.Common
public import Firedancer.Ref.fd_zksdk_ciphertext_ciphertext_equality
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Module

/-! `fd_zksdk_verify_proof_ciphertext_ciphertext_equality` against zk-sdk's ciphertext-ciphertext
equality proof (`sigma_proofs/ciphertext_ciphertext_equality.rs`); both batch the four equations as
`E₀ + w E₁ + w² E₂ + w³ E₃`. The second ciphertext is not zero-checked (as in zk-sdk). -/

namespace MLIR.Firedancer.Ref

open _root_.Ed25519 _root_.Ed25519.Ristretto fd_zksdk

@[expose] public section

/-- The challenges `(c, w)` the transcript derives on the accepting path. -/
def fd_zksdk_verify_proof_ciphertext_ciphertext_equality.challenges
    (proof : fd_zksdk_ciph_ciph_eq_proof_t) (pubkey1 pubkey2 : BitVec 256)
    (ciphertext1 ciphertext2 : BitVec 512) (transcript : fd_merlin_transcript_t) :
    BitVec 256 × BitVec 256 :=
  let transcript :=
    ciphertext_ciphertext_equality_hash_context transcript pubkey1 pubkey2 ciphertext1 ciphertext2
  let transcript := fd_zksdk_transcript_domsep_ciph_ciph_eq_proof transcript
  let transcript :=
    fd_zksdk_transcript_append_point transcript (FD_TRANSCRIPT_LITERAL "Y_0") proof.y0
  let transcript :=
    fd_zksdk_transcript_append_point transcript (FD_TRANSCRIPT_LITERAL "Y_1") proof.y1
  let transcript :=
    fd_zksdk_transcript_append_point transcript (FD_TRANSCRIPT_LITERAL "Y_2") proof.y2
  let transcript :=
    fd_zksdk_transcript_append_point transcript (FD_TRANSCRIPT_LITERAL "Y_3") proof.y3
  let c := fd_zksdk_transcript_challenge_scalar transcript (FD_TRANSCRIPT_LITERAL "c")
  let transcript := fd_zksdk_transcript_append_scalar c.1 (FD_TRANSCRIPT_LITERAL "z_s") proof.zs
  let transcript :=
    fd_zksdk_transcript_append_scalar transcript (FD_TRANSCRIPT_LITERAL "z_x") proof.zx
  let transcript :=
    fd_zksdk_transcript_append_scalar transcript (FD_TRANSCRIPT_LITERAL "z_r") proof.zr
  let w := fd_zksdk_transcript_challenge_scalar transcript (FD_TRANSCRIPT_LITERAL "w")
  (c.2, w.2)

/-- zk-sdk's equations, each as `lhs - rhs`: `z_s P₁ = c H + Y₀`, `z_x G + z_s D₁ = c C₁ + Y₁`,
`z_x G + z_r H = c C₂ + Y₂`, `z_r P₂ = c D₂ + Y₃`. -/
noncomputable def CiphCiphEq.eqns [PrimeOrder] (zs zx zr c : ZMod ell)
    (P₁ C₁ D₁ P₂ C₂ D₂ Y₀ Y₁ Y₂ Y₃ : RGroup) : Fin 4 → RGroup :=
  ![zs • P₁ - c • H - Y₀, zx • G + zs • D₁ - c • C₁ - Y₁, zx • G + zr • H - c • C₂ - Y₂,
    zr • P₂ - c • D₂ - Y₃]

end

/-- The verifier accepts exactly when the pubkeys, the first ciphertext and the `Yᵢ` are not the
zero encoding, the `z`s are canonical, everything decodes, and `Σₖ wᵏ Eₖ = 0` for zk-sdk's equations
and the transcript's `c`, `w`. -/
public theorem fd_zksdk_verify_proof_ciphertext_ciphertext_equality.ret_eq_success_iff [PrimeOrder]
    (proof : fd_zksdk_ciph_ciph_eq_proof_t) (pubkey1 pubkey2 : BitVec 256)
    (ciphertext1 ciphertext2 : BitVec 512) (transcript : fd_merlin_transcript_t) :
    (fd_zksdk_verify_proof_ciphertext_ciphertext_equality proof pubkey1 pubkey2 ciphertext1
            ciphertext2 transcript).ret =
        FD_ZKSDK_VERIFY_PROOF_SUCCESS ↔
      pubkey1 ≠ fd_ristretto255_compressed_zero ∧
        pubkey2 ≠ fd_ristretto255_compressed_zero ∧
          ciphertext1.extractLsb' 0 256 ≠ fd_ristretto255_compressed_zero ∧
            ciphertext1.extractLsb' 256 256 ≠ fd_ristretto255_compressed_zero ∧
              proof.y0 ≠ fd_ristretto255_compressed_zero ∧
                proof.y1 ≠ fd_ristretto255_compressed_zero ∧
                  proof.y2 ≠ fd_ristretto255_compressed_zero ∧
                    proof.y3 ≠ fd_ristretto255_compressed_zero ∧
                      proof.zs.toNat < ell ∧
                        proof.zx.toNat < ell ∧
                          proof.zr.toNat < ell ∧
                            ∃ P₁ C₁ D₁ P₂ C₂ D₂ Y₀ Y₁ Y₂ Y₃,
                              DecodesTo pubkey1 P₁ ∧
                                DecodesTo (ciphertext1.extractLsb' 0 256) C₁ ∧
                                  DecodesTo (ciphertext1.extractLsb' 256 256) D₁ ∧
                                    DecodesTo pubkey2 P₂ ∧
                                      DecodesTo (ciphertext2.extractLsb' 0 256) C₂ ∧
                                        DecodesTo (ciphertext2.extractLsb' 256 256) D₂ ∧
                                          DecodesTo proof.y0 Y₀ ∧
                                            DecodesTo proof.y1 Y₁ ∧
                                              DecodesTo proof.y2 Y₂ ∧
                                                DecodesTo proof.y3 Y₃ ∧
                                                  let cw :=
                                                    fd_zksdk_verify_proof_ciphertext_ciphertext_equality.challenges
                                                      proof pubkey1 pubkey2 ciphertext1 ciphertext2
                                                      transcript
                                                  comb (sc cw.2)
                                                      (CiphCiphEq.eqns (sc proof.zs) (sc proof.zx)
                                                        (sc proof.zr) (sc cw.1) P₁ C₁ D₁ P₂ C₂ D₂ Y₀
                                                        Y₁ Y₂ Y₃) =
                                                    0 := by
  unfold fd_zksdk_verify_proof_ciphertext_ciphertext_equality
  simp only [Id.run]
  by_cases hz :
    pubkey1 = fd_ristretto255_compressed_zero ∨
      pubkey2 = fd_ristretto255_compressed_zero ∨
      ciphertext1.extractLsb' 0 256 = fd_ristretto255_compressed_zero ∨
      ciphertext1.extractLsb' 256 256 = fd_ristretto255_compressed_zero
  · refine iff_of_false (by simp [hz]) ?_
    rintro ⟨h1, h2, h3, h4, -⟩
    rcases hz with h | h | h | h <;> contradiction
  simp only [hz, ↓reduceIte]
  simp only [not_or] at hz
  obtain ⟨hz1, hz2, hz3, hz4⟩ := hz
  by_cases hs : proof.zs.toNat < ell
  swap
  · simp [fd_curve25519_scalar_validate.eq_false hs, hs]
  by_cases hx : proof.zx.toNat < ell
  swap
  · simp [fd_curve25519_scalar_validate.eq_true hs, fd_curve25519_scalar_validate.eq_false hx, hx]
  by_cases hr : proof.zr.toNat < ell
  swap
  · simp [fd_curve25519_scalar_validate.eq_true hs, fd_curve25519_scalar_validate.eq_true hx,
      fd_curve25519_scalar_validate.eq_false hr, hr]
  simp only [fd_curve25519_scalar_validate.eq_true hs, fd_curve25519_scalar_validate.eq_true hx,
    fd_curve25519_scalar_validate.eq_true hr, Bool.not_true, Bool.false_eq_true, ↓reduceIte]
  decompress_cases proof.y0 with A₀ Y₀ hA₀ hY₀
  decompress_cases pubkey1 with A₁ P₁ hA₁ hP₁
  decompress_cases ciphertext1.extractLsb' 256 256 with A₂ D₁ hA₂ hD₁
  decompress_cases proof.y1 with A₃ Y₁ hA₃ hY₁
  decompress_cases ciphertext1.extractLsb' 0 256 with A₄ C₁ hA₄ hC₁
  decompress_cases proof.y2 with A₅ Y₂ hA₅ hY₂
  decompress_cases ciphertext2.extractLsb' 0 256 with A₆ C₂ hA₆ hC₂
  decompress_cases proof.y3 with A₇ Y₃ hA₇ hY₃
  decompress_cases ciphertext2.extractLsb' 256 256 with A₈ D₂ hA₈ hD₂
  decompress_cases pubkey2 with A₉ P₂ hA₉ hP₂
  simp only [fd_rangeproofs_transcript_validate_and_append_point.snd]
  by_cases hy0 : proof.y0 = fd_ristretto255_compressed_zero
  · simp [hy0]
  by_cases hy1 : proof.y1 = fd_ristretto255_compressed_zero
  · simp [hy0, hy1]
  by_cases hy2 : proof.y2 = fd_ristretto255_compressed_zero
  · simp [hy0, hy1, hy2]
  by_cases hy3 : proof.y3 = fd_ristretto255_compressed_zero
  · simp [hy0, hy1, hy2, hy3]
  simp only [hy0, hy1, hy2, hy3, ↓reduceIte, FD_TRANSCRIPT_SUCCESS_or, ne_self_iff_false,
    fd_rangeproofs_transcript_validate_and_append_point.fst _ _ hy0,
    fd_rangeproofs_transcript_validate_and_append_point.fst _ _ hy1,
    fd_rangeproofs_transcript_validate_and_append_point.fst _ _ hy2,
    fd_rangeproofs_transcript_validate_and_append_point.fst _ _ hy3]
  generalize hwd : (fd_rangeproofs_transcript_challenge_scalar _ (FD_TRANSCRIPT_LITERAL "w")).2 = w
  generalize hcd : (fd_rangeproofs_transcript_challenge_scalar _ (FD_TRANSCRIPT_LITERAL "c")).2 = c
  have hcw :
    fd_zksdk_verify_proof_ciphertext_ciphertext_equality.challenges proof pubkey1 pubkey2
        ciphertext1 ciphertext2 transcript =
      (c, w) := by
    rw [← hcd, ← hwd]; rfl
  simp only [hcw]
  rw [ret_ite_msm
      (ptsOf
        [⟨basePoint, basePoint_mem_Dom⟩, ⟨Hpt, Hpt_mem_Dom⟩, P₁, D₁, Y₁, C₁, Y₂, C₂, Y₃, D₂, P₂])
      ?_ ?_ hA₀.1]
  rotate_left
  msm_sides 11
  msm_sum_simp
  simp only [ne_eq, hz1, hz2, hz3, hz4, hy0, hy1, hy2, hy3, not_false_eq_true, hs, hx, hr, true_and,
    hP₁, hC₁, hD₁, hP₂, hC₂, hD₂, hY₀, hY₁, hY₂, hY₃, exists_and_left, exists_eq_left]
  simp only [comb, Fin.sum_univ_four, CiphCiphEq.eqns]
  simp
  constructor <;> intro h <;> linear_combination (norm := module) h

/-- Completeness: if zk-sdk's four equations hold for the transcript's `c` (and the encodings decode
and pass the zero checks, the `z`s canonical), the verifier accepts. -/
public theorem fd_zksdk_verify_proof_ciphertext_ciphertext_equality.complete [PrimeOrder]
    {proof : fd_zksdk_ciph_ciph_eq_proof_t} {pubkey1 pubkey2 : BitVec 256}
    {ciphertext1 ciphertext2 : BitVec 512} {transcript : fd_merlin_transcript_t}
    {P₁ C₁ D₁ P₂ C₂ D₂ Y₀ Y₁ Y₂ Y₃ : RGroup}
    (hz :
      pubkey1 ≠ fd_ristretto255_compressed_zero ∧
        pubkey2 ≠ fd_ristretto255_compressed_zero ∧
        ciphertext1.extractLsb' 0 256 ≠ fd_ristretto255_compressed_zero ∧
        ciphertext1.extractLsb' 256 256 ≠ fd_ristretto255_compressed_zero ∧
        proof.y0 ≠ fd_ristretto255_compressed_zero ∧
        proof.y1 ≠ fd_ristretto255_compressed_zero ∧
        proof.y2 ≠ fd_ristretto255_compressed_zero ∧ proof.y3 ≠ fd_ristretto255_compressed_zero)
    (hs : proof.zs.toNat < ell ∧ proof.zx.toNat < ell ∧ proof.zr.toNat < ell)
    (hd :
      DecodesTo pubkey1 P₁ ∧
        DecodesTo (ciphertext1.extractLsb' 0 256) C₁ ∧
        DecodesTo (ciphertext1.extractLsb' 256 256) D₁ ∧
        DecodesTo pubkey2 P₂ ∧
        DecodesTo (ciphertext2.extractLsb' 0 256) C₂ ∧
        DecodesTo (ciphertext2.extractLsb' 256 256) D₂ ∧
        DecodesTo proof.y0 Y₀ ∧
        DecodesTo proof.y1 Y₁ ∧ DecodesTo proof.y2 Y₂ ∧ DecodesTo proof.y3 Y₃)
    (hE :
      ∀ k,
        CiphCiphEq.eqns (sc proof.zs) (sc proof.zx) (sc proof.zr)
            (sc
              (fd_zksdk_verify_proof_ciphertext_ciphertext_equality.challenges proof pubkey1 pubkey2
                  ciphertext1 ciphertext2 transcript).1)
            P₁ C₁ D₁ P₂ C₂ D₂ Y₀ Y₁ Y₂ Y₃ k =
          0) :
    (fd_zksdk_verify_proof_ciphertext_ciphertext_equality proof pubkey1 pubkey2 ciphertext1
          ciphertext2 transcript).ret =
      FD_ZKSDK_VERIFY_PROOF_SUCCESS := by
  obtain ⟨z1, z2, z3, z4, z5, z6, z7, z8⟩ := hz
  obtain ⟨d1, d2, d3, d4, d5, d6, d7, d8, d9, d10⟩ := hd
  exact
    (fd_zksdk_verify_proof_ciphertext_ciphertext_equality.ret_eq_success_iff ..).2
      ⟨z1, z2, z3, z4, z5, z6, z7, z8, hs.1, hs.2.1, hs.2.2, P₁, C₁, D₁, P₂, C₂, D₂, Y₀, Y₁, Y₂, Y₃,
        d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, comb_eq_zero _ hE⟩

/-- Soundness: if the verifier accepts, zk-sdk's four equations hold for the transcript's `c`, or
the transcript's `w` is one of the at most three roots of `Σₖ Eₖ Xᵏ` (`card_badW_le`). -/
public theorem fd_zksdk_verify_proof_ciphertext_ciphertext_equality.sound [PrimeOrder]
    {proof : fd_zksdk_ciph_ciph_eq_proof_t} {pubkey1 pubkey2 : BitVec 256}
    {ciphertext1 ciphertext2 : BitVec 512} {transcript : fd_merlin_transcript_t}
    {P₁ C₁ D₁ P₂ C₂ D₂ Y₀ Y₁ Y₂ Y₃ : RGroup}
    (hd :
      DecodesTo pubkey1 P₁ ∧
        DecodesTo (ciphertext1.extractLsb' 0 256) C₁ ∧
        DecodesTo (ciphertext1.extractLsb' 256 256) D₁ ∧
        DecodesTo pubkey2 P₂ ∧
        DecodesTo (ciphertext2.extractLsb' 0 256) C₂ ∧
        DecodesTo (ciphertext2.extractLsb' 256 256) D₂ ∧
        DecodesTo proof.y0 Y₀ ∧
        DecodesTo proof.y1 Y₁ ∧ DecodesTo proof.y2 Y₂ ∧ DecodesTo proof.y3 Y₃)
    (h :
      (fd_zksdk_verify_proof_ciphertext_ciphertext_equality proof pubkey1 pubkey2 ciphertext1
            ciphertext2 transcript).ret =
        FD_ZKSDK_VERIFY_PROOF_SUCCESS) :
    let cw :=
      fd_zksdk_verify_proof_ciphertext_ciphertext_equality.challenges proof pubkey1 pubkey2
        ciphertext1 ciphertext2 transcript
    let E :=
      CiphCiphEq.eqns (sc proof.zs) (sc proof.zx) (sc proof.zr) (sc cw.1) P₁ C₁ D₁ P₂ C₂ D₂ Y₀ Y₁ Y₂
        Y₃
    (∀ k, E k = 0) ∨ sc cw.2 ∈ badW E := by
  obtain ⟨d1, d2, d3, d4, d5, d6, d7, d8, d9, d10⟩ := hd
  obtain
    ⟨-, -, -, -, -, -, -, -, -, -, -, P₁', C₁', D₁', P₂', C₂', D₂', Y₀', Y₁', Y₂', Y₃', e1, e2, e3,
      e4, e5, e6, e7, e8, e9, e10, hc⟩ :=
    (fd_zksdk_verify_proof_ciphertext_ciphertext_equality.ret_eq_success_iff ..).1 h
  rw [e1.unique d1, e2.unique d2, e3.unique d3, e4.unique d4, e5.unique d5, e6.unique d6,
    e7.unique d7, e8.unique d8, e9.unique d9, e10.unique d10] at hc
  exact eq_zero_or_mem_badW hc

end MLIR.Firedancer.Ref
