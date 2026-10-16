module

public import Firedancer.Ref.fd_zksdk_grouped_ciphertext_3_handles_validity

namespace MLIR.Firedancer.Ref

open fd_zksdk

/-! ## Specification

`ballet/zksdk/instructions/fd_zksdk_batched_grouped_ciphertext_3_handles_validity.c`. -/

@[expose] public section

/-- `fd_zksdk_batched_grp_ciph_3h_val_context_t`
(`zksdk/instructions/fd_zksdk_batched_grouped_ciphertext_validity.h:77`), packed, 352 bytes. -/
structure fd_zksdk_batched_grp_ciph_3h_val_context_t where
  pubkey1 : BitVec 256
  pubkey2 : BitVec 256
  pubkey3 : BitVec 256
  grouped_ciphertext_lo : grp_ciph_3h_t
  grouped_ciphertext_hi : grp_ciph_3h_t

/-- The context struct over the bytes `b` at its address. -/
def fd_zksdk_batched_grp_ciph_3h_val_context_t.ofBytes (b : List (BitVec 8)) :
    fd_zksdk_batched_grp_ciph_3h_val_context_t :=
  ⟨field b 0 256, field b 32 256, field b 64 256, grp_ciph_3h_t.ofBytes (b.drop 96),
    grp_ciph_3h_t.ofBytes (b.drop 224)⟩

/-- `batched_grouped_ciphertext_validity_hash_context`
(`zksdk/instructions/fd_zksdk_batched_grouped_ciphertext_3_handles_validity.c:5`), static. -/
def batched_grouped_ciphertext_3_handles_validity.batched_grouped_ciphertext_validity_hash_context
    (transcript : fd_merlin_transcript_t) (pubkey1 pubkey2 pubkey3 : BitVec 256)
    (grouped_ciphertext_lo grouped_ciphertext_hi : grp_ciph_3h_t) : fd_merlin_transcript_t :=
  let transcript :=
    fd_zksdk_transcript_append_pubkey transcript (FD_TRANSCRIPT_LITERAL "first-pubkey") pubkey1
  let transcript :=
    fd_zksdk_transcript_append_pubkey transcript (FD_TRANSCRIPT_LITERAL "second-pubkey") pubkey2
  let transcript :=
    fd_zksdk_transcript_append_pubkey transcript (FD_TRANSCRIPT_LITERAL "third-pubkey") pubkey3
  let transcript := fd_zksdk_transcript_append_message transcript
    (FD_TRANSCRIPT_LITERAL "grouped-ciphertext-lo") grouped_ciphertext_lo.toBytes 128#32
  let transcript := fd_zksdk_transcript_append_message transcript
    (FD_TRANSCRIPT_LITERAL "grouped-ciphertext-hi") grouped_ciphertext_hi.toBytes 128#32
  transcript

/-- `fd_zksdk_verify_proof_batched_grouped_ciphertext_3_handles_validity`
(`zksdk/instructions/fd_zksdk_batched_grouped_ciphertext_3_handles_validity.c:21`); `pubkey3` is not
checked against zero. -/
def fd_zksdk_verify_proof_batched_grouped_ciphertext_3_handles_validity
    (proof : fd_zksdk_grp_ciph_3h_val_proof_t) (pubkey1 pubkey2 pubkey3 : BitVec 256)
    (grouped_ciphertext_lo grouped_ciphertext_hi : grp_ciph_3h_t)
    (transcript : fd_merlin_transcript_t) : fd_zksdk_verify_result :=
  if pubkey1 = fd_ristretto255_compressed_zero
      ∨ pubkey2 = fd_ristretto255_compressed_zero
      ∨ grouped_ciphertext_lo.commitment = fd_ristretto255_compressed_zero
      ∨ grouped_ciphertext_hi.commitment = fd_ristretto255_compressed_zero then
    ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  else
    let transcript :=
      batched_grouped_ciphertext_3_handles_validity.batched_grouped_ciphertext_validity_hash_context
        transcript pubkey1 pubkey2 pubkey3 grouped_ciphertext_lo grouped_ciphertext_hi
    let transcript := fd_zksdk_transcript_domsep_batched_grp_ciph_val_proof transcript 3#64
    let (transcript, t) :=
      fd_zksdk_transcript_challenge_scalar transcript (FD_TRANSCRIPT_LITERAL "t")
    fd_zksdk_verify_proof_direct_grouped_ciphertext_3_handles_validity proof pubkey1 pubkey2
      pubkey3 grouped_ciphertext_lo.commitment grouped_ciphertext_lo.handles[0].handle
      grouped_ciphertext_lo.handles[1].handle grouped_ciphertext_lo.handles[2].handle
      grouped_ciphertext_hi.commitment grouped_ciphertext_hi.handles[0].handle
      grouped_ciphertext_hi.handles[1].handle grouped_ciphertext_hi.handles[2].handle t 1#32
      transcript

/-- `fd_zksdk_instr_verify_proof_batched_grouped_ciphertext_3_handles_validity`
(`zksdk/instructions/fd_zksdk_batched_grouped_ciphertext_3_handles_validity.c:69`): `_context`,
`_proof` the bytes at those pointers (352 and 192 of them). -/
def fd_zksdk_instr_verify_proof_batched_grouped_ciphertext_3_handles_validity
    (_context _proof : List (BitVec 8)) : BitVec 32 :=
  let transcript := fd_zksdk_transcript_init
    (FD_TRANSCRIPT_LITERAL "batched-grouped-ciphertext-validity-3-handles-instruction")
  let context := fd_zksdk_batched_grp_ciph_3h_val_context_t.ofBytes _context
  let proof := fd_zksdk_grp_ciph_3h_val_proof_t.ofBytes _proof
  (fd_zksdk_verify_proof_batched_grouped_ciphertext_3_handles_validity proof context.pubkey1
    context.pubkey2 context.pubkey3 context.grouped_ciphertext_lo context.grouped_ciphertext_hi
    transcript).ret

end

end MLIR.Firedancer.Ref
