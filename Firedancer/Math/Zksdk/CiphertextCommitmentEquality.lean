module

public import Firedancer.Math.Zksdk.Common
public import Firedancer.Ref.fd_zksdk_ciphertext_commitment_equality
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Module

/-! `fd_zksdk_verify_proof_ciphertext_commitment_equality` against zk-sdk's ciphertext-commitment
equality proof (`sigma_proofs/ciphertext_commitment_equality.rs`). The C batches the three equations
with weights `w², w, 1`, zk-sdk with `1, w, w²`. -/

namespace MLIR.Firedancer.Ref

open _root_.Ed25519 _root_.Ed25519.Ristretto fd_zksdk

@[expose] public section

/-- The challenges `(c, w)` the transcript derives on the accepting path. -/
def fd_zksdk_verify_proof_ciphertext_commitment_equality.challenges
    (proof : fd_zksdk_ciph_comm_eq_proof_t) (pubkey : BitVec 256) (ciphertext : BitVec 512)
    (commitment : BitVec 256) (transcript : fd_merlin_transcript_t) : BitVec 256 × BitVec 256 :=
  let transcript := ciph_comm_eq_hash_context transcript pubkey ciphertext commitment
  let transcript := fd_zksdk_transcript_domsep_ciph_comm_eq_proof transcript
  let transcript :=
    fd_zksdk_transcript_append_point transcript (FD_TRANSCRIPT_LITERAL "Y_0") proof.y0
  let transcript :=
    fd_zksdk_transcript_append_point transcript (FD_TRANSCRIPT_LITERAL "Y_1") proof.y1
  let transcript :=
    fd_zksdk_transcript_append_point transcript (FD_TRANSCRIPT_LITERAL "Y_2") proof.y2
  let c := fd_zksdk_transcript_challenge_scalar transcript (FD_TRANSCRIPT_LITERAL "c")
  let transcript := fd_zksdk_transcript_append_scalar c.1 (FD_TRANSCRIPT_LITERAL "z_s") proof.zs
  let transcript :=
    fd_zksdk_transcript_append_scalar transcript (FD_TRANSCRIPT_LITERAL "z_x") proof.zx
  let transcript :=
    fd_zksdk_transcript_append_scalar transcript (FD_TRANSCRIPT_LITERAL "z_r") proof.zr
  let w := fd_zksdk_transcript_challenge_scalar transcript (FD_TRANSCRIPT_LITERAL "w")
  (c.2, w.2)

namespace CiphCommEq

/-- zk-sdk's equations, each as `lhs - rhs`: `z_s P = c H + Y₀`, `z_x G + z_s D = c C + Y₁`,
`z_x G + z_r H = c C' + Y₂` (`C`, `D` the ciphertext, `C'` the commitment). -/
noncomputable def eqns [PrimeOrder] (zs zx zr c : ZMod ell) (P C D C' Y₀ Y₁ Y₂ : RGroup) :
    Fin 3 → RGroup :=
  ![zs • P - c • H - Y₀, zx • G + zs • D - c • C - Y₁, zx • G + zr • H - c • C' - Y₂]

end CiphCommEq

end

/-- The verifier accepts exactly when no input or `Yᵢ` is the zero encoding, the `z`s are canonical,
everything decodes, and `w² E₀ + w E₁ + E₂ = 0` for zk-sdk's equations `Eₖ` and the transcript's
`c`, `w`. -/
public theorem fd_zksdk_verify_proof_ciphertext_commitment_equality.ret_eq_success_iff [PrimeOrder]
    (proof : fd_zksdk_ciph_comm_eq_proof_t) (pubkey : BitVec 256) (ciphertext : BitVec 512)
    (commitment : BitVec 256) (transcript : fd_merlin_transcript_t) :
    (fd_zksdk_verify_proof_ciphertext_commitment_equality proof pubkey ciphertext commitment
            transcript).ret =
        FD_ZKSDK_VERIFY_PROOF_SUCCESS ↔
      pubkey ≠ fd_ristretto255_compressed_zero ∧
        ciphertext.extractLsb' 0 256 ≠ fd_ristretto255_compressed_zero ∧
          ciphertext.extractLsb' 256 256 ≠ fd_ristretto255_compressed_zero ∧
            commitment ≠ fd_ristretto255_compressed_zero ∧
              proof.y0 ≠ fd_ristretto255_compressed_zero ∧
                proof.y1 ≠ fd_ristretto255_compressed_zero ∧
                  proof.y2 ≠ fd_ristretto255_compressed_zero ∧
                    proof.zs.toNat < ell ∧
                      proof.zx.toNat < ell ∧
                        proof.zr.toNat < ell ∧
                          ∃ P C D C' Y₀ Y₁ Y₂,
                            DecodesTo pubkey P ∧
                              DecodesTo (ciphertext.extractLsb' 0 256) C ∧
                                DecodesTo (ciphertext.extractLsb' 256 256) D ∧
                                  DecodesTo commitment C' ∧
                                    DecodesTo proof.y0 Y₀ ∧
                                      DecodesTo proof.y1 Y₁ ∧
                                        DecodesTo proof.y2 Y₂ ∧
                                          let cw :=
                                            fd_zksdk_verify_proof_ciphertext_commitment_equality.challenges
                                              proof pubkey ciphertext commitment transcript
                                          comb (sc cw.2)
                                              (fun k =>
                                                CiphCommEq.eqns (sc proof.zs) (sc proof.zx)
                                                  (sc proof.zr) (sc cw.1) P C D C' Y₀ Y₁ Y₂ k.rev) =
                                            0 := by
  unfold fd_zksdk_verify_proof_ciphertext_commitment_equality
  simp only [Id.run]
  by_cases hz :
    pubkey = fd_ristretto255_compressed_zero ∨
      ciphertext.extractLsb' 0 256 = fd_ristretto255_compressed_zero ∨
      ciphertext.extractLsb' 256 256 = fd_ristretto255_compressed_zero ∨
      commitment = fd_ristretto255_compressed_zero
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
  decompress_cases proof.y1 with A₁ Y₁ hA₁ hY₁
  decompress_cases proof.y2 with A₂ Y₂ hA₂ hY₂
  decompress_cases pubkey with A₃ P hA₃ hP
  decompress_cases ciphertext.extractLsb' 0 256 with A₄ C hA₄ hC
  decompress_cases ciphertext.extractLsb' 256 256 with A₅ D hA₅ hD
  decompress_cases commitment with A₆ C' hA₆ hC'
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
    fd_zksdk_verify_proof_ciphertext_commitment_equality.challenges proof pubkey ciphertext
        commitment transcript =
      (c, w) := by
    rw [← hcd, ← hwd]; rfl
  simp only [hcw]
  rw [ret_ite_msm (ptsOf [⟨basePoint, basePoint_mem_Dom⟩, ⟨Hpt, Hpt_mem_Dom⟩, Y₀, Y₁, P, C, D, C'])
      ?_ ?_ hA₂.1]
  rotate_left
  msm_sides 8
  msm_sum_simp
  simp only [ne_eq, hz1, hz2, hz3, hz4, hy0, hy1, hy2, not_false_eq_true, hs, hx, hr, true_and, hP,
    hC, hD, hC', hY₀, hY₁, hY₂, exists_and_left, exists_eq_left]
  simp only [comb, Fin.sum_univ_three, CiphCommEq.eqns]
  simp
  constructor <;> intro h <;> linear_combination (norm := module) h

end MLIR.Firedancer.Ref

namespace MLIR.Firedancer.Ref

open _root_.Ed25519 _root_.Ed25519.Ristretto fd_zksdk

namespace CiphCommEq

/-- The C's batching: `w² E₀ + w E₁ + E₂`. -/
public theorem comb_rev [PrimeOrder] (w : ZMod ell) (E : Fin 3 → RGroup) :
    comb w (fun k => E k.rev) = w ^ 2 • E 0 + w • E 1 + E 2 := by
  simp [comb, Fin.sum_univ_three]
  abel

/-- zk-sdk's batching: `E₀ + w E₁ + w² E₂`. -/
public theorem comb_rust [PrimeOrder] (w : ZMod ell) (E : Fin 3 → RGroup) :
    comb w E = E 0 + w • E 1 + w ^ 2 • E 2 := by simp [comb, Fin.sum_univ_three]

/-- The two batchings disagree only on bad challenges of one of them: at most `2 · 2` values of
`w` for fixed equations. -/
public theorem comb_rev_iff_comb [PrimeOrder] {w : ZMod ell} {E : Fin 3 → RGroup}
    (h : ¬(comb w (fun k => E k.rev) = 0 ↔ comb w E = 0)) :
    w ∈ badW (fun k => E k.rev) ∪ badW E ∧ (badW (fun k => E k.rev) ∪ badW E).card ≤ 2 * 2 := by
  have hE : ∃ k, E k ≠ 0 := by
    by_contra hc
    simp only [not_exists, not_not] at hc
    exact h (iff_of_true (comb_eq_zero _ fun k => hc _) (comb_eq_zero _ hc))
  refine ⟨?_, ?_⟩
  · rcases Classical.em (comb w (fun k => E k.rev) = 0) with h1 | h1
    · exact
        Finset.mem_union_left _
          ((eq_zero_or_mem_badW h1).resolve_left fun h0 =>
            hE.elim fun k hk => hk (by simpa using h0 k.rev))
    · have h2 : comb w E = 0 := by tauto
      exact
        Finset.mem_union_right _
          ((eq_zero_or_mem_badW h2).resolve_left fun h0 => hE.elim fun k hk => hk (h0 k))
  · refine (Finset.card_union_le _ _).trans ?_
    have h1 := card_badW_le (fun k => E k.rev) (hE.elim fun k hk => ⟨k.rev, by simpa using hk⟩)
    have h2 := card_badW_le E hE
    omega

end CiphCommEq

/-- Completeness: if zk-sdk's three equations hold for the transcript's `c` (and the encodings
decode, are nonzero, and the `z`s are canonical), the verifier accepts. -/
public theorem fd_zksdk_verify_proof_ciphertext_commitment_equality.complete [PrimeOrder]
    {proof : fd_zksdk_ciph_comm_eq_proof_t} {pubkey : BitVec 256} {ciphertext : BitVec 512}
    {commitment : BitVec 256} {transcript : fd_merlin_transcript_t} {P C D C' Y₀ Y₁ Y₂ : RGroup}
    (hz :
      pubkey ≠ fd_ristretto255_compressed_zero ∧
        ciphertext.extractLsb' 0 256 ≠ fd_ristretto255_compressed_zero ∧
        ciphertext.extractLsb' 256 256 ≠ fd_ristretto255_compressed_zero ∧
        commitment ≠ fd_ristretto255_compressed_zero ∧
        proof.y0 ≠ fd_ristretto255_compressed_zero ∧
        proof.y1 ≠ fd_ristretto255_compressed_zero ∧ proof.y2 ≠ fd_ristretto255_compressed_zero)
    (hs : proof.zs.toNat < ell ∧ proof.zx.toNat < ell ∧ proof.zr.toNat < ell)
    (hd :
      DecodesTo pubkey P ∧
        DecodesTo (ciphertext.extractLsb' 0 256) C ∧
        DecodesTo (ciphertext.extractLsb' 256 256) D ∧
        DecodesTo commitment C' ∧
        DecodesTo proof.y0 Y₀ ∧ DecodesTo proof.y1 Y₁ ∧ DecodesTo proof.y2 Y₂)
    (hE :
      ∀ k,
        CiphCommEq.eqns (sc proof.zs) (sc proof.zx) (sc proof.zr)
            (sc
              (fd_zksdk_verify_proof_ciphertext_commitment_equality.challenges proof pubkey
                  ciphertext commitment transcript).1)
            P C D C' Y₀ Y₁ Y₂ k =
          0) :
    (fd_zksdk_verify_proof_ciphertext_commitment_equality proof pubkey ciphertext commitment
          transcript).ret =
      FD_ZKSDK_VERIFY_PROOF_SUCCESS := by
  obtain ⟨z1, z2, z3, z4, z5, z6, z7⟩ := hz
  obtain ⟨d1, d2, d3, d4, d5, d6, d7⟩ := hd
  exact
    (fd_zksdk_verify_proof_ciphertext_commitment_equality.ret_eq_success_iff ..).2
      ⟨z1, z2, z3, z4, z5, z6, z7, hs.1, hs.2.1, hs.2.2, P, C, D, C', Y₀, Y₁, Y₂, d1, d2, d3, d4,
        d5, d6, d7, comb_eq_zero _ fun k => hE k.rev⟩

/-- Soundness: if the verifier accepts, zk-sdk's three equations hold for the transcript's `c`, or
the transcript's `w` is one of the at most two roots of `E₂ + E₁ X + E₀ X²` (`card_badW_le`). -/
public theorem fd_zksdk_verify_proof_ciphertext_commitment_equality.sound [PrimeOrder]
    {proof : fd_zksdk_ciph_comm_eq_proof_t} {pubkey : BitVec 256} {ciphertext : BitVec 512}
    {commitment : BitVec 256} {transcript : fd_merlin_transcript_t} {P C D C' Y₀ Y₁ Y₂ : RGroup}
    (hd :
      DecodesTo pubkey P ∧
        DecodesTo (ciphertext.extractLsb' 0 256) C ∧
        DecodesTo (ciphertext.extractLsb' 256 256) D ∧
        DecodesTo commitment C' ∧
        DecodesTo proof.y0 Y₀ ∧ DecodesTo proof.y1 Y₁ ∧ DecodesTo proof.y2 Y₂)
    (h :
      (fd_zksdk_verify_proof_ciphertext_commitment_equality proof pubkey ciphertext commitment
            transcript).ret =
        FD_ZKSDK_VERIFY_PROOF_SUCCESS) :
    let cw :=
      fd_zksdk_verify_proof_ciphertext_commitment_equality.challenges proof pubkey ciphertext
        commitment transcript
    let E := CiphCommEq.eqns (sc proof.zs) (sc proof.zx) (sc proof.zr) (sc cw.1) P C D C' Y₀ Y₁ Y₂
    (∀ k, E k = 0) ∨ sc cw.2 ∈ badW (fun k => E k.rev) := by
  obtain ⟨d1, d2, d3, d4, d5, d6, d7⟩ := hd
  obtain
    ⟨-, -, -, -, -, -, -, -, -, -, P', C₁, D', C'', Y₀', Y₁', Y₂', e1, e2, e3, e4, e5, e6, e7,
      hc⟩ :=
    (fd_zksdk_verify_proof_ciphertext_commitment_equality.ret_eq_success_iff ..).1 h
  rw [e1.unique d1, e2.unique d2, e3.unique d3, e4.unique d4, e5.unique d5, e6.unique d6,
    e7.unique d7] at hc
  rcases eq_zero_or_mem_badW hc with h0 | h0
  · exact .inl fun k => by simpa using h0 k.rev
  · exact .inr h0

end MLIR.Firedancer.Ref
