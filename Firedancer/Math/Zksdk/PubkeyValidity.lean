module

public import Firedancer.Math.Zksdk.Common
public import Firedancer.Ref.fd_zksdk_pubkey_validity

/-! `fd_zksdk_verify_proof_pubkey_validity` against zk-sdk's pubkey-validity proof
(`sigma_proofs/pubkey_validity.rs`): it accepts exactly when the encodings decode, `z` is canonical,
`P` and `Y` are not the zero encoding, and `z H = c P + Y`. -/

namespace MLIR.Firedancer.Ref

open _root_.Ed25519 _root_.Ed25519.Ristretto fd_zksdk

@[expose] public section

/-- The challenge `c` the transcript derives on the accepting path. -/
def fd_zksdk_verify_proof_pubkey_validity.challenge (proof : fd_zksdk_pubkey_validity_proof_t)
    (pubkey : BitVec 256) (transcript : fd_merlin_transcript_t) : BitVec 256 :=
  let transcript := pubkey_validity_hash_context transcript pubkey
  let transcript := fd_zksdk_transcript_domsep_pubkey_proof transcript
  let transcript := fd_zksdk_transcript_append_point transcript (FD_TRANSCRIPT_LITERAL "Y") proof.y
  (fd_zksdk_transcript_challenge_scalar transcript (FD_TRANSCRIPT_LITERAL "c")).2

/-- zk-sdk's pubkey-validity equation `z H = c P + Y`, as `z H - c P - Y`. -/
noncomputable def PubkeyValidity.eqn [PrimeOrder] (z c : ZMod ell) (P Y : RGroup) : RGroup :=
  z • H - c • P - Y

end

/-- The equation as the C checks it: `z H + (-c) P = Y`. -/
theorem PubkeyValidity.eqn_iff [PrimeOrder] (z c : ZMod ell) (P Y : RGroup) :
    PubkeyValidity.eqn z c P Y = 0 ↔ z • H + (-c) • P = Y := by
  rw [PubkeyValidity.eqn, sub_eq_zero, neg_smul, ← sub_eq_add_neg]

/-- The verifier accepts exactly when `P`, `Y` decode and are not the zero encoding, `z` is
canonical, and `z H = c P + Y` for the transcript's `c`. -/
public theorem fd_zksdk_verify_proof_pubkey_validity.ret_eq_success_iff [PrimeOrder]
    (proof : fd_zksdk_pubkey_validity_proof_t) (pubkey : BitVec 256)
    (transcript : fd_merlin_transcript_t) :
    (fd_zksdk_verify_proof_pubkey_validity proof pubkey transcript).ret =
        FD_ZKSDK_VERIFY_PROOF_SUCCESS ↔
      pubkey ≠ fd_ristretto255_compressed_zero ∧
        proof.y ≠ fd_ristretto255_compressed_zero ∧
        proof.z.toNat < ell ∧
        ∃ P Y,
          DecodesTo pubkey P ∧
            DecodesTo proof.y Y ∧
            PubkeyValidity.eqn (sc proof.z)
                (sc (fd_zksdk_verify_proof_pubkey_validity.challenge proof pubkey transcript)) P Y =
              0 := by
  unfold fd_zksdk_verify_proof_pubkey_validity
  simp only [Id.run]
  by_cases h0 : pubkey = fd_ristretto255_compressed_zero
  · simp [h0]
  by_cases hz : proof.z.toNat < ell
  swap
  · simp [h0, fd_curve25519_scalar_validate.eq_false hz, hz]
  simp only [h0, ↓reduceIte, fd_curve25519_scalar_validate.eq_true hz, Bool.not_true,
    Bool.false_eq_true]
  decompress_cases pubkey with A P hA hP
  decompress_cases proof.y with B Y hB hY
  simp only [fd_rangeproofs_transcript_validate_and_append_point.snd]
  by_cases hy0 : proof.y = fd_ristretto255_compressed_zero
  · simp [hy0]
  simp only [hy0, ↓reduceIte, FD_TRANSCRIPT_SUCCESS_or, ne_self_iff_false,
    fd_rangeproofs_transcript_validate_and_append_point.fst _ _ hy0]
  generalize hcd : (fd_rangeproofs_transcript_challenge_scalar _ (FD_TRANSCRIPT_LITERAL "c")).2 = c
  have hc : fd_zksdk_verify_proof_pubkey_validity.challenge proof pubkey transcript = c := by
    rw [← hcd]; rfl
  simp only [hc]
  rw [ret_ite_msm (ptsOf [⟨Hpt, Hpt_mem_Dom⟩, P]) ?_ ?_ hB.1]
  rotate_left
  msm_sides 2
  msm_sum_simp
  simp only [ne_eq, h0, hy0, not_false_eq_true, hz, true_and, hP, hY, exists_and_left,
    exists_eq_left, PubkeyValidity.eqn_iff, neg_smul]

end MLIR.Firedancer.Ref

namespace MLIR.Firedancer.Ref

open _root_.Ed25519 _root_.Ed25519.Ristretto

/-- Completeness: if `z H = c P + Y` for the transcript's `c` (and the encodings decode and are not
zero, `z` canonical), the verifier accepts. -/
public theorem fd_zksdk_verify_proof_pubkey_validity.complete [PrimeOrder]
    {proof : fd_zksdk_pubkey_validity_proof_t} {pubkey : BitVec 256}
    {transcript : fd_merlin_transcript_t} {P Y : RGroup}
    (hz : pubkey ≠ fd_ristretto255_compressed_zero ∧ proof.y ≠ fd_ristretto255_compressed_zero)
    (hs : proof.z.toNat < ell) (hd : DecodesTo pubkey P ∧ DecodesTo proof.y Y)
    (hE :
      PubkeyValidity.eqn (sc proof.z)
          (sc (fd_zksdk_verify_proof_pubkey_validity.challenge proof pubkey transcript)) P Y =
        0) :
    (fd_zksdk_verify_proof_pubkey_validity proof pubkey transcript).ret =
      FD_ZKSDK_VERIFY_PROOF_SUCCESS :=
  (fd_zksdk_verify_proof_pubkey_validity.ret_eq_success_iff ..).2
    ⟨hz.1, hz.2, hs, P, Y, hd.1, hd.2, hE⟩

/-- Soundness: if the verifier accepts, `z H = c P + Y` for the transcript's `c`. -/
public theorem fd_zksdk_verify_proof_pubkey_validity.sound [PrimeOrder]
    {proof : fd_zksdk_pubkey_validity_proof_t} {pubkey : BitVec 256}
    {transcript : fd_merlin_transcript_t} {P Y : RGroup}
    (hd : DecodesTo pubkey P ∧ DecodesTo proof.y Y)
    (h :
      (fd_zksdk_verify_proof_pubkey_validity proof pubkey transcript).ret =
        FD_ZKSDK_VERIFY_PROOF_SUCCESS) :
    PubkeyValidity.eqn (sc proof.z)
        (sc (fd_zksdk_verify_proof_pubkey_validity.challenge proof pubkey transcript)) P Y =
      0 := by
  obtain ⟨-, -, -, P', Y', e1, e2, hc⟩ :=
    (fd_zksdk_verify_proof_pubkey_validity.ret_eq_success_iff ..).1 h
  rwa [e1.unique hd.1, e2.unique hd.2] at hc

end MLIR.Firedancer.Ref
