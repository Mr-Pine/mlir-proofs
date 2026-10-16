module

public import Firedancer.Math.Zksdk.GroupedCiphertext2HandlesValidity
public import Firedancer.Ref.fd_zksdk_batched_grouped_ciphertext_2_handles_validity

/-! `fd_zksdk_verify_proof_batched_grouped_ciphertext_2_handles_validity` against zk-sdk's
`batched_grouped_ciphertext_validity/handles_2.rs`: the 2-handle equations on the ciphertext
`lo + t hi`. -/

namespace MLIR.Firedancer.Ref

open _root_.Ed25519 _root_.Ed25519.Ristretto fd_zksdk

/-- The challenges `(t, c, w)` the transcript derives on the accepting path. -/
@[expose]
public def fd_zksdk_verify_proof_batched_grouped_ciphertext_2_handles_validity.challenges
    (proof : fd_zksdk_grp_ciph_2h_val_proof_t) (pubkey1 pubkey2 : BitVec 256)
    (grouped_ciphertext_lo grouped_ciphertext_hi : grp_ciph_2h_t)
    (transcript : fd_merlin_transcript_t) : BitVec 256 × BitVec 256 × BitVec 256 :=
  let transcript :=
    batched_grouped_ciphertext_2_handles_validity.batched_grouped_ciphertext_validity_hash_context
      transcript pubkey1 pubkey2 grouped_ciphertext_lo grouped_ciphertext_hi
  let transcript := fd_zksdk_transcript_domsep_batched_grp_ciph_val_proof transcript 2#64
  let t := fd_zksdk_transcript_challenge_scalar transcript (FD_TRANSCRIPT_LITERAL "t")
  (t.2, fd_zksdk_verify_proof_direct_grouped_ciphertext_2_handles_validity.challenges proof t.1)

/-- The batched verifier accepts exactly when `pubkey1`, both commitments, `Y₀`, `Y₁` are not the
zero encoding, `z_r`, `z_x` are canonical, everything decodes, and `Σₖ wᵏ Eₖ = 0` for zk-sdk's
equations on `lo + t hi` and the transcript's `t`, `c`, `w`. -/
public theorem
  fd_zksdk_verify_proof_batched_grouped_ciphertext_2_handles_validity.ret_eq_success_iff
    [PrimeOrder] (proof : fd_zksdk_grp_ciph_2h_val_proof_t) (pubkey1 pubkey2 : BitVec 256)
    (lo hi : grp_ciph_2h_t) (transcript : fd_merlin_transcript_t) :
    (fd_zksdk_verify_proof_batched_grouped_ciphertext_2_handles_validity proof pubkey1 pubkey2 lo hi
            transcript).ret =
        FD_ZKSDK_VERIFY_PROOF_SUCCESS ↔
      pubkey1 ≠ fd_ristretto255_compressed_zero ∧
        lo.commitment ≠ fd_ristretto255_compressed_zero ∧
          hi.commitment ≠ fd_ristretto255_compressed_zero ∧
            proof.y0 ≠ fd_ristretto255_compressed_zero ∧
              proof.y1 ≠ fd_ristretto255_compressed_zero ∧
                proof.zr.toNat < ell ∧
                  proof.zx.toNat < ell ∧
                    ∃ P₁ P₂ C D₁ D₂ C_hi D₁_hi D₂_hi Y₀ Y₁ Y₂,
                      DecodesTo pubkey1 P₁ ∧
                        DecodesTo pubkey2 P₂ ∧
                          DecodesTo lo.commitment C ∧
                            DecodesTo lo.handles[0].handle D₁ ∧
                              DecodesTo lo.handles[1].handle D₂ ∧
                                DecodesTo hi.commitment C_hi ∧
                                  DecodesTo hi.handles[0].handle D₁_hi ∧
                                    DecodesTo hi.handles[1].handle D₂_hi ∧
                                      DecodesTo proof.y0 Y₀ ∧
                                        DecodesTo proof.y1 Y₁ ∧
                                          DecodesTo proof.y2 Y₂ ∧
                                            let tcw :=
                                              fd_zksdk_verify_proof_batched_grouped_ciphertext_2_handles_validity.challenges
                                                proof pubkey1 pubkey2 lo hi transcript
                                            let t := sc tcw.1
                                            comb (sc tcw.2.2)
                                                (Grouped2.eqns (sc proof.zr) (sc proof.zx)
                                                  (sc tcw.2.1) P₁ P₂ (C + t • C_hi) (D₁ + t • D₁_hi)
                                                  (D₂ + t • D₂_hi) Y₀ Y₁ Y₂) =
                                              0 := by
  unfold fd_zksdk_verify_proof_batched_grouped_ciphertext_2_handles_validity
  by_cases hz :
    pubkey1 = fd_ristretto255_compressed_zero ∨
      lo.commitment = fd_ristretto255_compressed_zero ∨
      hi.commitment = fd_ristretto255_compressed_zero
  · refine iff_of_false (by simp [hz]) ?_
    rintro ⟨h1, h2, h3, -⟩
    rcases hz with h | h | h <;> contradiction
  simp only [hz, ↓reduceIte]
  simp only [not_or] at hz
  rw [fd_zksdk_verify_proof_direct_grouped_ciphertext_2_handles_validity.ret_eq_success_iff_batched
      _ _ _ _ _ _ _ _ _ _ (by decide)]
  simp only [ne_eq, hz.1, hz.2.1, hz.2.2, not_false_eq_true, true_and]
  rfl

/-- Completeness: if zk-sdk's three equations on `lo + t hi` hold for the transcript's `t`, `c` (and
the encodings decode and pass the zero checks, `z_r`, `z_x` canonical), the verifier accepts. -/
public theorem fd_zksdk_verify_proof_batched_grouped_ciphertext_2_handles_validity.complete
    [PrimeOrder] {proof : fd_zksdk_grp_ciph_2h_val_proof_t} {pubkey1 pubkey2 : BitVec 256}
    {lo hi : grp_ciph_2h_t} {transcript : fd_merlin_transcript_t}
    {P₁ P₂ C D₁ D₂ C_hi D₁_hi D₂_hi Y₀ Y₁ Y₂ : RGroup}
    (hz :
      pubkey1 ≠ fd_ristretto255_compressed_zero ∧
        lo.commitment ≠ fd_ristretto255_compressed_zero ∧
        hi.commitment ≠ fd_ristretto255_compressed_zero ∧
        proof.y0 ≠ fd_ristretto255_compressed_zero ∧ proof.y1 ≠ fd_ristretto255_compressed_zero)
    (hs : proof.zr.toNat < ell ∧ proof.zx.toNat < ell)
    (hd :
      DecodesTo pubkey1 P₁ ∧
        DecodesTo pubkey2 P₂ ∧
        DecodesTo lo.commitment C ∧
        DecodesTo lo.handles[0].handle D₁ ∧
        DecodesTo lo.handles[1].handle D₂ ∧
        DecodesTo hi.commitment C_hi ∧
        DecodesTo hi.handles[0].handle D₁_hi ∧
        DecodesTo hi.handles[1].handle D₂_hi ∧
        DecodesTo proof.y0 Y₀ ∧ DecodesTo proof.y1 Y₁ ∧ DecodesTo proof.y2 Y₂)
    {tcw : BitVec 256 × BitVec 256 × BitVec 256}
    (htcw :
      fd_zksdk_verify_proof_batched_grouped_ciphertext_2_handles_validity.challenges proof pubkey1
          pubkey2 lo hi transcript =
        tcw)
    (hE :
      let t := sc tcw.1
      ∀ k,
        Grouped2.eqns (sc proof.zr) (sc proof.zx) (sc tcw.2.1) P₁ P₂ (C + t • C_hi) (D₁ + t • D₁_hi)
            (D₂ + t • D₂_hi) Y₀ Y₁ Y₂ k =
          0) :
    (fd_zksdk_verify_proof_batched_grouped_ciphertext_2_handles_validity proof pubkey1 pubkey2 lo hi
          transcript).ret =
      FD_ZKSDK_VERIFY_PROOF_SUCCESS := by
  subst htcw
  obtain ⟨z1, z2, z3, z4, z5⟩ := hz
  obtain ⟨d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11⟩ := hd
  exact
    (fd_zksdk_verify_proof_batched_grouped_ciphertext_2_handles_validity.ret_eq_success_iff ..).2
      ⟨z1, z2, z3, z4, z5, hs.1, hs.2, P₁, P₂, C, D₁, D₂, C_hi, D₁_hi, D₂_hi, Y₀, Y₁, Y₂, d1, d2,
        d3, d4, d5, d6, d7, d8, d9, d10, d11, comb_eq_zero _ hE⟩

/-- Soundness: if the verifier accepts, zk-sdk's three equations on `lo + t hi` hold for the
transcript's `t`, `c`, or the transcript's `w` is one of the at most two roots of `Σₖ Eₖ Xᵏ`. -/
public theorem fd_zksdk_verify_proof_batched_grouped_ciphertext_2_handles_validity.sound
    [PrimeOrder] {proof : fd_zksdk_grp_ciph_2h_val_proof_t} {pubkey1 pubkey2 : BitVec 256}
    {lo hi : grp_ciph_2h_t} {transcript : fd_merlin_transcript_t}
    {P₁ P₂ C D₁ D₂ C_hi D₁_hi D₂_hi Y₀ Y₁ Y₂ : RGroup}
    (hd :
      DecodesTo pubkey1 P₁ ∧
        DecodesTo pubkey2 P₂ ∧
        DecodesTo lo.commitment C ∧
        DecodesTo lo.handles[0].handle D₁ ∧
        DecodesTo lo.handles[1].handle D₂ ∧
        DecodesTo hi.commitment C_hi ∧
        DecodesTo hi.handles[0].handle D₁_hi ∧
        DecodesTo hi.handles[1].handle D₂_hi ∧
        DecodesTo proof.y0 Y₀ ∧ DecodesTo proof.y1 Y₁ ∧ DecodesTo proof.y2 Y₂)
    (h :
      (fd_zksdk_verify_proof_batched_grouped_ciphertext_2_handles_validity proof pubkey1 pubkey2 lo
            hi transcript).ret =
        FD_ZKSDK_VERIFY_PROOF_SUCCESS) :
    let tcw :=
      fd_zksdk_verify_proof_batched_grouped_ciphertext_2_handles_validity.challenges proof pubkey1
        pubkey2 lo hi transcript
    let t := sc tcw.1
    let E :=
      Grouped2.eqns (sc proof.zr) (sc proof.zx) (sc tcw.2.1) P₁ P₂ (C + t • C_hi) (D₁ + t • D₁_hi)
        (D₂ + t • D₂_hi) Y₀ Y₁ Y₂
    (∀ k, E k = 0) ∨ sc tcw.2.2 ∈ badW E := by
  obtain ⟨d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11⟩ := hd
  obtain
    ⟨-, -, -, -, -, -, -, P₁', P₂', C', D₁', D₂', C_hi', D₁_hi', D₂_hi', Y₀', Y₁', Y₂', e1, e2, e3,
      e4, e5, e6, e7, e8, e9, e10, e11, hc⟩ :=
    (fd_zksdk_verify_proof_batched_grouped_ciphertext_2_handles_validity.ret_eq_success_iff ..).1 h
  rw [e1.unique d1, e2.unique d2, e3.unique d3, e4.unique d4, e5.unique d5, e6.unique d6,
    e7.unique d7, e8.unique d8, e9.unique d9, e10.unique d10, e11.unique d11] at hc
  exact eq_zero_or_mem_badW hc

end MLIR.Firedancer.Ref
