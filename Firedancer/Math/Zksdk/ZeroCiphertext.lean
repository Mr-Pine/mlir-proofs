module

public import Firedancer.Math.Zksdk.Common
public import Firedancer.Ref.fd_zksdk_zero_ciphertext
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Module

/-! `fd_zksdk_verify_proof_zero_ciphertext` against zk-sdk's zero-ciphertext proof
(`sigma_proofs/zero_ciphertext.rs`); both batch the two equations as `E₀ + w E₁`. -/

namespace MLIR.Firedancer.Ref

open _root_.Ed25519 _root_.Ed25519.Ristretto fd_zksdk

@[expose] public section

/-- The challenges `(c, w)` the transcript derives on the accepting path. -/
def fd_zksdk_verify_proof_zero_ciphertext.challenges (proof : fd_zksdk_zero_ciphertext_proof_t)
    (pubkey : BitVec 256) (ciphertext : BitVec 512) (transcript : fd_merlin_transcript_t) :
    BitVec 256 × BitVec 256 :=
  let transcript := zero_ciphertext_hash_context transcript pubkey ciphertext
  let transcript := fd_zksdk_transcript_domsep_zero_ciphertext_proof transcript
  let transcript :=
    fd_zksdk_transcript_append_point transcript (FD_TRANSCRIPT_LITERAL "Y_P") proof.yp
  let transcript :=
    fd_zksdk_transcript_append_point transcript (FD_TRANSCRIPT_LITERAL "Y_D") proof.yd
  let c := fd_zksdk_transcript_challenge_scalar transcript (FD_TRANSCRIPT_LITERAL "c")
  let transcript := fd_zksdk_transcript_append_scalar c.1 (FD_TRANSCRIPT_LITERAL "z") proof.z
  let w := fd_zksdk_transcript_challenge_scalar transcript (FD_TRANSCRIPT_LITERAL "w")
  (c.2, w.2)

/-- zk-sdk's equations, each as `lhs - rhs`: `z P = c H + Y_P`, `z D = c C + Y_D` (`C`, `D` the
ciphertext). -/
noncomputable def ZeroCiphertext.eqns [PrimeOrder] (z c : ZMod ell) (P C D Y_P Y_D : RGroup) :
    Fin 2 → RGroup :=
  ![z • P - c • H - Y_P, z • D - c • C - Y_D]

end

/-- The verifier accepts exactly when `P`, `C`, `D`, `Y_P` are not the zero encoding, `z` is
canonical, everything decodes, and `E₀ + w E₁ = 0` for zk-sdk's equations and the transcript's `c`,
`w`. -/
public theorem fd_zksdk_verify_proof_zero_ciphertext.ret_eq_success_iff [PrimeOrder]
    (proof : fd_zksdk_zero_ciphertext_proof_t) (pubkey : BitVec 256) (ciphertext : BitVec 512)
    (transcript : fd_merlin_transcript_t) :
    (fd_zksdk_verify_proof_zero_ciphertext proof pubkey ciphertext transcript).ret =
        FD_ZKSDK_VERIFY_PROOF_SUCCESS ↔
      pubkey ≠ fd_ristretto255_compressed_zero ∧
        ciphertext.extractLsb' 0 256 ≠ fd_ristretto255_compressed_zero ∧
          ciphertext.extractLsb' 256 256 ≠ fd_ristretto255_compressed_zero ∧
            proof.yp ≠ fd_ristretto255_compressed_zero ∧
              proof.z.toNat < ell ∧
                ∃ P C D Y_P Y_D,
                  DecodesTo pubkey P ∧
                    DecodesTo (ciphertext.extractLsb' 0 256) C ∧
                      DecodesTo (ciphertext.extractLsb' 256 256) D ∧
                        DecodesTo proof.yp Y_P ∧
                          DecodesTo proof.yd Y_D ∧
                            let cw :=
                              fd_zksdk_verify_proof_zero_ciphertext.challenges proof pubkey
                                ciphertext transcript
                            comb (sc cw.2)
                                (ZeroCiphertext.eqns (sc proof.z) (sc cw.1) P C D Y_P Y_D) =
                              0 := by
  unfold fd_zksdk_verify_proof_zero_ciphertext
  simp only [Id.run]
  by_cases hz :
    pubkey = fd_ristretto255_compressed_zero ∨
      ciphertext.extractLsb' 0 256 = fd_ristretto255_compressed_zero ∨
      ciphertext.extractLsb' 256 256 = fd_ristretto255_compressed_zero
  · refine iff_of_false (by simp [hz]) ?_
    rintro ⟨h1, h2, h3, -⟩
    rcases hz with h | h | h <;> contradiction
  simp only [hz, ↓reduceIte]
  simp only [not_or] at hz
  obtain ⟨hz1, hz2, hz3⟩ := hz
  by_cases hs : proof.z.toNat < ell
  swap
  · simp [fd_curve25519_scalar_validate.eq_false hs, hs]
  simp only [fd_curve25519_scalar_validate.eq_true hs, Bool.not_true, Bool.false_eq_true,
    ↓reduceIte]
  decompress_cases pubkey with A₀ P hA₀ hP
  decompress_cases ciphertext.extractLsb' 0 256 with A₁ C hA₁ hC
  decompress_cases ciphertext.extractLsb' 256 256 with A₂ D hA₂ hD
  decompress_cases proof.yd with A₃ Y_D hA₃ hY_D
  decompress_cases proof.yp with A₄ Y_P hA₄ hY_P
  simp only [fd_rangeproofs_transcript_validate_and_append_point.snd]
  by_cases hy : proof.yp = fd_ristretto255_compressed_zero
  · simp [hy]
  simp only [hy, ↓reduceIte, FD_TRANSCRIPT_SUCCESS_or, ne_self_iff_false,
    fd_rangeproofs_transcript_validate_and_append_point.fst _ _ hy]
  generalize hwd : (fd_rangeproofs_transcript_challenge_scalar _ (FD_TRANSCRIPT_LITERAL "w")).2 = w
  generalize hcd : (fd_rangeproofs_transcript_challenge_scalar _ (FD_TRANSCRIPT_LITERAL "c")).2 = c
  have hcw :
    fd_zksdk_verify_proof_zero_ciphertext.challenges proof pubkey ciphertext transcript =
      (c, w) := by
    rw [← hcd, ← hwd]; rfl
  simp only [hcw]
  rw [ret_ite_msm (ptsOf [⟨Hpt, Hpt_mem_Dom⟩, P, C, D, Y_D]) ?_ ?_ hA₄.1]
  rotate_left
  msm_sides 5
  msm_sum_simp
  simp only [ne_eq, hz1, hz2, hz3, hy, not_false_eq_true, hs, true_and, hP, hC, hD, hY_P, hY_D,
    exists_and_left, exists_eq_left]
  simp only [comb, Fin.sum_univ_two, ZeroCiphertext.eqns]
  simp
  constructor <;> intro h <;> linear_combination (norm := module) h

/-- Completeness: if zk-sdk's two equations hold for the transcript's `c` (and the encodings decode
and pass the zero checks, `z` canonical), the verifier accepts. -/
public theorem fd_zksdk_verify_proof_zero_ciphertext.complete [PrimeOrder]
    {proof : fd_zksdk_zero_ciphertext_proof_t} {pubkey : BitVec 256} {ciphertext : BitVec 512}
    {transcript : fd_merlin_transcript_t} {P C D Y_P Y_D : RGroup}
    (hz :
      pubkey ≠ fd_ristretto255_compressed_zero ∧
        ciphertext.extractLsb' 0 256 ≠ fd_ristretto255_compressed_zero ∧
        ciphertext.extractLsb' 256 256 ≠ fd_ristretto255_compressed_zero ∧
        proof.yp ≠ fd_ristretto255_compressed_zero)
    (hs : proof.z.toNat < ell)
    (hd :
      DecodesTo pubkey P ∧
        DecodesTo (ciphertext.extractLsb' 0 256) C ∧
        DecodesTo (ciphertext.extractLsb' 256 256) D ∧
        DecodesTo proof.yp Y_P ∧ DecodesTo proof.yd Y_D)
    (hE :
      ∀ k,
        ZeroCiphertext.eqns (sc proof.z)
            (sc
              (fd_zksdk_verify_proof_zero_ciphertext.challenges proof pubkey ciphertext
                  transcript).1)
            P C D Y_P Y_D k =
          0) :
    (fd_zksdk_verify_proof_zero_ciphertext proof pubkey ciphertext transcript).ret =
      FD_ZKSDK_VERIFY_PROOF_SUCCESS := by
  obtain ⟨z1, z2, z3, z4⟩ := hz
  obtain ⟨d1, d2, d3, d4, d5⟩ := hd
  exact
    (fd_zksdk_verify_proof_zero_ciphertext.ret_eq_success_iff ..).2
      ⟨z1, z2, z3, z4, hs, P, C, D, Y_P, Y_D, d1, d2, d3, d4, d5, comb_eq_zero _ hE⟩

/-- Soundness: if the verifier accepts, zk-sdk's two equations hold for the transcript's `c`, or
the transcript's `w` is the root of `E₀ + E₁ X` (`card_badW_le`). -/
public theorem fd_zksdk_verify_proof_zero_ciphertext.sound [PrimeOrder]
    {proof : fd_zksdk_zero_ciphertext_proof_t} {pubkey : BitVec 256} {ciphertext : BitVec 512}
    {transcript : fd_merlin_transcript_t} {P C D Y_P Y_D : RGroup}
    (hd :
      DecodesTo pubkey P ∧
        DecodesTo (ciphertext.extractLsb' 0 256) C ∧
        DecodesTo (ciphertext.extractLsb' 256 256) D ∧
        DecodesTo proof.yp Y_P ∧ DecodesTo proof.yd Y_D)
    (h :
      (fd_zksdk_verify_proof_zero_ciphertext proof pubkey ciphertext transcript).ret =
        FD_ZKSDK_VERIFY_PROOF_SUCCESS) :
    let cw := fd_zksdk_verify_proof_zero_ciphertext.challenges proof pubkey ciphertext transcript
    let E := ZeroCiphertext.eqns (sc proof.z) (sc cw.1) P C D Y_P Y_D
    (∀ k, E k = 0) ∨ sc cw.2 ∈ badW E := by
  obtain ⟨d1, d2, d3, d4, d5⟩ := hd
  obtain ⟨-, -, -, -, -, P', C', D', Y_P', Y_D', e1, e2, e3, e4, e5, hc⟩ :=
    (fd_zksdk_verify_proof_zero_ciphertext.ret_eq_success_iff ..).1 h
  rw [e1.unique d1, e2.unique d2, e3.unique d3, e4.unique d4, e5.unique d5] at hc
  exact eq_zero_or_mem_badW hc

end MLIR.Firedancer.Ref
