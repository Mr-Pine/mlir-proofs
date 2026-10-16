module

public import Firedancer.Math.Zksdk.GroupedCiphertext3HandlesValidity
public import Firedancer.Ref.fd_zksdk_batched_grouped_ciphertext_3_handles_validity

/-! `fd_zksdk_verify_proof_batched_grouped_ciphertext_3_handles_validity` against zk-sdk's
`batched_grouped_ciphertext_validity/handles_3.rs`: the 3-handle equations on the ciphertext
`lo + t hi`. -/

namespace MLIR.Firedancer.Ref

open _root_.Ed25519 _root_.Ed25519.Ristretto fd_zksdk

/-- The challenges `(t, c, w)` the transcript derives on the accepting path. -/
@[expose]
public def fd_zksdk_verify_proof_batched_grouped_ciphertext_3_handles_validity.challenges
    (proof : fd_zksdk_grp_ciph_3h_val_proof_t) (pubkey1 pubkey2 pubkey3 : BitVec 256)
    (grouped_ciphertext_lo grouped_ciphertext_hi : grp_ciph_3h_t)
    (transcript : fd_merlin_transcript_t) : BitVec 256 × BitVec 256 × BitVec 256 :=
  let transcript :=
    batched_grouped_ciphertext_3_handles_validity.batched_grouped_ciphertext_validity_hash_context
      transcript pubkey1 pubkey2 pubkey3 grouped_ciphertext_lo grouped_ciphertext_hi
  let transcript := fd_zksdk_transcript_domsep_batched_grp_ciph_val_proof transcript 3#64
  let t := fd_zksdk_transcript_challenge_scalar transcript (FD_TRANSCRIPT_LITERAL "t")
  (t.2, fd_zksdk_verify_proof_direct_grouped_ciphertext_3_handles_validity.challenges proof t.1)

/-- The batched verifier accepts exactly when `pubkey1`, `pubkey2`, both commitments, `Y₀`, `Y₁`,
`Y₂` are not the zero encoding, `z_r`, `z_x` are canonical, everything decodes, and `Σₖ wᵏ Eₖ = 0`
for zk-sdk's equations on `lo + t hi` and the transcript's `t`, `c`, `w`. -/
public theorem
  fd_zksdk_verify_proof_batched_grouped_ciphertext_3_handles_validity.ret_eq_success_iff
    [PrimeOrder] (proof : fd_zksdk_grp_ciph_3h_val_proof_t) (pubkey1 pubkey2 pubkey3 : BitVec 256)
    (lo hi : grp_ciph_3h_t) (transcript : fd_merlin_transcript_t) :
    (fd_zksdk_verify_proof_batched_grouped_ciphertext_3_handles_validity proof pubkey1 pubkey2
            pubkey3 lo hi transcript).ret =
        FD_ZKSDK_VERIFY_PROOF_SUCCESS ↔
      pubkey1 ≠ fd_ristretto255_compressed_zero ∧
        pubkey2 ≠ fd_ristretto255_compressed_zero ∧
          lo.commitment ≠ fd_ristretto255_compressed_zero ∧
            hi.commitment ≠ fd_ristretto255_compressed_zero ∧
              proof.y0 ≠ fd_ristretto255_compressed_zero ∧
                proof.y1 ≠ fd_ristretto255_compressed_zero ∧
                  proof.y2 ≠ fd_ristretto255_compressed_zero ∧
                    proof.zr.toNat < ell ∧
                      proof.zx.toNat < ell ∧
                        ∃ P₁ P₂ P₃ C D₁ D₂ D₃ C_hi D₁_hi D₂_hi D₃_hi Y₀ Y₁ Y₂ Y₃,
                          DecodesTo pubkey1 P₁ ∧
                            DecodesTo pubkey2 P₂ ∧
                              DecodesTo pubkey3 P₃ ∧
                                DecodesTo lo.commitment C ∧
                                  DecodesTo lo.handles[0].handle D₁ ∧
                                    DecodesTo lo.handles[1].handle D₂ ∧
                                      DecodesTo lo.handles[2].handle D₃ ∧
                                        DecodesTo hi.commitment C_hi ∧
                                          DecodesTo hi.handles[0].handle D₁_hi ∧
                                            DecodesTo hi.handles[1].handle D₂_hi ∧
                                              DecodesTo hi.handles[2].handle D₃_hi ∧
                                                DecodesTo proof.y0 Y₀ ∧
                                                  DecodesTo proof.y1 Y₁ ∧
                                                    DecodesTo proof.y2 Y₂ ∧
                                                      DecodesTo proof.y3 Y₃ ∧
                                                        let tcw :=
                                                          fd_zksdk_verify_proof_batched_grouped_ciphertext_3_handles_validity.challenges
                                                            proof pubkey1 pubkey2 pubkey3 lo hi
                                                            transcript
                                                        let t := sc tcw.1
                                                        comb (sc tcw.2.2)
                                                            (Grouped3.eqns (sc proof.zr)
                                                              (sc proof.zx) (sc tcw.2.1) P₁ P₂ P₃
                                                              (C + t • C_hi) (D₁ + t • D₁_hi)
                                                              (D₂ + t • D₂_hi) (D₃ + t • D₃_hi) Y₀
                                                              Y₁ Y₂ Y₃) =
                                                          0 := by
  unfold fd_zksdk_verify_proof_batched_grouped_ciphertext_3_handles_validity
  by_cases hz :
    pubkey1 = fd_ristretto255_compressed_zero ∨
      pubkey2 = fd_ristretto255_compressed_zero ∨
      lo.commitment = fd_ristretto255_compressed_zero ∨
      hi.commitment = fd_ristretto255_compressed_zero
  · refine iff_of_false (by simp [hz]) ?_
    rintro ⟨h1, h2, h3, h4, -⟩
    rcases hz with h | h | h | h <;> contradiction
  simp only [hz, ↓reduceIte]
  simp only [not_or] at hz
  rw [fd_zksdk_verify_proof_direct_grouped_ciphertext_3_handles_validity.ret_eq_success_iff_batched
      _ _ _ _ _ _ _ _ _ _ _ _ _ (by decide)]
  simp only [ne_eq, hz.1, hz.2.1, hz.2.2.1, hz.2.2.2, not_false_eq_true, true_and]
  rfl

/-- Completeness: if zk-sdk's four equations on `lo + t hi` hold for the transcript's `t`, `c` (and
the encodings decode and pass the zero checks, `z_r`, `z_x` canonical), the verifier accepts. -/
public theorem fd_zksdk_verify_proof_batched_grouped_ciphertext_3_handles_validity.complete
    [PrimeOrder] {proof : fd_zksdk_grp_ciph_3h_val_proof_t} {pubkey1 pubkey2 pubkey3 : BitVec 256}
    {lo hi : grp_ciph_3h_t} {transcript : fd_merlin_transcript_t}
    {P₁ P₂ P₃ C D₁ D₂ D₃ C_hi D₁_hi D₂_hi D₃_hi Y₀ Y₁ Y₂ Y₃ : RGroup}
    (hz :
      pubkey1 ≠ fd_ristretto255_compressed_zero ∧
        pubkey2 ≠ fd_ristretto255_compressed_zero ∧
        lo.commitment ≠ fd_ristretto255_compressed_zero ∧
        hi.commitment ≠ fd_ristretto255_compressed_zero ∧
        proof.y0 ≠ fd_ristretto255_compressed_zero ∧
        proof.y1 ≠ fd_ristretto255_compressed_zero ∧ proof.y2 ≠ fd_ristretto255_compressed_zero)
    (hs : proof.zr.toNat < ell ∧ proof.zx.toNat < ell)
    (hd :
      DecodesTo pubkey1 P₁ ∧
        DecodesTo pubkey2 P₂ ∧
        DecodesTo pubkey3 P₃ ∧
        DecodesTo lo.commitment C ∧
        DecodesTo lo.handles[0].handle D₁ ∧
        DecodesTo lo.handles[1].handle D₂ ∧
        DecodesTo lo.handles[2].handle D₃ ∧
        DecodesTo hi.commitment C_hi ∧
        DecodesTo hi.handles[0].handle D₁_hi ∧
        DecodesTo hi.handles[1].handle D₂_hi ∧
        DecodesTo hi.handles[2].handle D₃_hi ∧
        DecodesTo proof.y0 Y₀ ∧
        DecodesTo proof.y1 Y₁ ∧ DecodesTo proof.y2 Y₂ ∧ DecodesTo proof.y3 Y₃)
    {tcw : BitVec 256 × BitVec 256 × BitVec 256}
    (htcw :
      fd_zksdk_verify_proof_batched_grouped_ciphertext_3_handles_validity.challenges proof pubkey1
          pubkey2 pubkey3 lo hi transcript =
        tcw)
    (hE :
      let t := sc tcw.1
      ∀ k,
        Grouped3.eqns (sc proof.zr) (sc proof.zx) (sc tcw.2.1) P₁ P₂ P₃ (C + t • C_hi)
            (D₁ + t • D₁_hi) (D₂ + t • D₂_hi) (D₃ + t • D₃_hi) Y₀ Y₁ Y₂ Y₃ k =
          0) :
    (fd_zksdk_verify_proof_batched_grouped_ciphertext_3_handles_validity proof pubkey1 pubkey2
          pubkey3 lo hi transcript).ret =
      FD_ZKSDK_VERIFY_PROOF_SUCCESS := by
  subst htcw
  obtain ⟨z1, z2, z3, z4, z5, z6, z7⟩ := hz
  obtain ⟨d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15⟩ := hd
  exact
    (fd_zksdk_verify_proof_batched_grouped_ciphertext_3_handles_validity.ret_eq_success_iff ..).2
      ⟨z1, z2, z3, z4, z5, z6, z7, hs.1, hs.2, P₁, P₂, P₃, C, D₁, D₂, D₃, C_hi, D₁_hi, D₂_hi, D₃_hi,
        Y₀, Y₁, Y₂, Y₃, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15,
        comb_eq_zero _ hE⟩

/-- Soundness: if the verifier accepts, zk-sdk's four equations on `lo + t hi` hold for the
transcript's `t`, `c`, or the transcript's `w` is one of the at most three roots of `Σₖ Eₖ Xᵏ`. -/
public theorem fd_zksdk_verify_proof_batched_grouped_ciphertext_3_handles_validity.sound
    [PrimeOrder] {proof : fd_zksdk_grp_ciph_3h_val_proof_t} {pubkey1 pubkey2 pubkey3 : BitVec 256}
    {lo hi : grp_ciph_3h_t} {transcript : fd_merlin_transcript_t}
    {P₁ P₂ P₃ C D₁ D₂ D₃ C_hi D₁_hi D₂_hi D₃_hi Y₀ Y₁ Y₂ Y₃ : RGroup}
    (hd :
      DecodesTo pubkey1 P₁ ∧
        DecodesTo pubkey2 P₂ ∧
        DecodesTo pubkey3 P₃ ∧
        DecodesTo lo.commitment C ∧
        DecodesTo lo.handles[0].handle D₁ ∧
        DecodesTo lo.handles[1].handle D₂ ∧
        DecodesTo lo.handles[2].handle D₃ ∧
        DecodesTo hi.commitment C_hi ∧
        DecodesTo hi.handles[0].handle D₁_hi ∧
        DecodesTo hi.handles[1].handle D₂_hi ∧
        DecodesTo hi.handles[2].handle D₃_hi ∧
        DecodesTo proof.y0 Y₀ ∧
        DecodesTo proof.y1 Y₁ ∧ DecodesTo proof.y2 Y₂ ∧ DecodesTo proof.y3 Y₃)
    (h :
      (fd_zksdk_verify_proof_batched_grouped_ciphertext_3_handles_validity proof pubkey1 pubkey2
            pubkey3 lo hi transcript).ret =
        FD_ZKSDK_VERIFY_PROOF_SUCCESS) :
    let tcw :=
      fd_zksdk_verify_proof_batched_grouped_ciphertext_3_handles_validity.challenges proof pubkey1
        pubkey2 pubkey3 lo hi transcript
    let t := sc tcw.1
    let E :=
      Grouped3.eqns (sc proof.zr) (sc proof.zx) (sc tcw.2.1) P₁ P₂ P₃ (C + t • C_hi)
        (D₁ + t • D₁_hi) (D₂ + t • D₂_hi) (D₃ + t • D₃_hi) Y₀ Y₁ Y₂ Y₃
    (∀ k, E k = 0) ∨ sc tcw.2.2 ∈ badW E := by
  obtain ⟨d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15⟩ := hd
  obtain
    ⟨-, -, -, -, -, -, -, -, -, P₁', P₂', P₃', C', D₁', D₂', D₃', C_hi', D₁_hi', D₂_hi', D₃_hi',
      Y₀', Y₁', Y₂', Y₃', e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13, e14, e15, hc⟩ :=
    (fd_zksdk_verify_proof_batched_grouped_ciphertext_3_handles_validity.ret_eq_success_iff ..).1 h
  rw [e1.unique d1, e2.unique d2, e3.unique d3, e4.unique d4, e5.unique d5, e6.unique d6,
    e7.unique d7, e8.unique d8, e9.unique d9, e10.unique d10, e11.unique d11, e12.unique d12,
    e13.unique d13, e14.unique d14, e15.unique d15] at hc
  exact eq_zero_or_mem_badW hc

end MLIR.Firedancer.Ref
