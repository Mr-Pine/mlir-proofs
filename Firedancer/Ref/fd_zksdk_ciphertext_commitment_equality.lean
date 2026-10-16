module

public import Firedancer.Ref.fd_zksdk_common

namespace MLIR.Firedancer.Ref

open fd_zksdk

/-! ## Specification

`ballet/zksdk/instructions/fd_zksdk_ciphertext_commitment_equality.{h,c}`. A ciphertext's
commitment is its bytes `[0, 32)` (`ciphertext.extractLsb' 0 256`), its handle `[32, 64)`. -/

@[expose] public section

/-- `fd_zksdk_ciph_comm_eq_proof_t`
(`zksdk/instructions/fd_zksdk_ciphertext_commitment_equality.h:6`), packed, 192 bytes. -/
structure fd_zksdk_ciph_comm_eq_proof_t where
  y0 : BitVec 256
  y1 : BitVec 256
  y2 : BitVec 256
  zs : BitVec 256
  zx : BitVec 256
  zr : BitVec 256

/-- `fd_zksdk_ciph_comm_eq_context_t`
(`zksdk/instructions/fd_zksdk_ciphertext_commitment_equality.h:16`), packed, 128 bytes. -/
structure fd_zksdk_ciph_comm_eq_context_t where
  pubkey : BitVec 256
  ciphertext : BitVec 512
  commitment : BitVec 256

/-- The proof struct over the bytes `b` at its address. -/
def fd_zksdk_ciph_comm_eq_proof_t.ofBytes (b : List (BitVec 8)) : fd_zksdk_ciph_comm_eq_proof_t :=
  ⟨field b 0 256, field b 32 256, field b 64 256, field b 96 256, field b 128 256,
    field b 160 256⟩

/-- The context struct over the bytes `b` at its address. -/
def fd_zksdk_ciph_comm_eq_context_t.ofBytes (b : List (BitVec 8)) :
    fd_zksdk_ciph_comm_eq_context_t :=
  ⟨field b 0 256, field b 32 512, field b 96 256⟩

/-- `ciph_comm_eq_hash_context`
(`zksdk/instructions/fd_zksdk_ciphertext_commitment_equality.c:5`). -/
def ciph_comm_eq_hash_context (transcript : fd_merlin_transcript_t) (pubkey : BitVec 256)
    (ciphertext : BitVec 512) (commitment : BitVec 256) : fd_merlin_transcript_t :=
  let transcript :=
    fd_zksdk_transcript_append_pubkey transcript (FD_TRANSCRIPT_LITERAL "pubkey") pubkey
  let transcript :=
    fd_zksdk_transcript_append_ciphertext transcript (FD_TRANSCRIPT_LITERAL "ciphertext") ciphertext
  let transcript :=
    fd_zksdk_transcript_append_commitment transcript (FD_TRANSCRIPT_LITERAL "commitment") commitment
  transcript

/-- `fd_zksdk_verify_proof_ciphertext_commitment_equality`
(`zksdk/instructions/fd_zksdk_ciphertext_commitment_equality.c:16`). -/
def fd_zksdk_verify_proof_ciphertext_commitment_equality (proof : fd_zksdk_ciph_comm_eq_proof_t)
    (pubkey : BitVec 256) (ciphertext : BitVec 512) (commitment : BitVec 256)
    (transcript : fd_merlin_transcript_t) : fd_zksdk_verify_result := Id.run do
  let scalars := uninitScalars
  let points := uninitPoints
  if pubkey = fd_ristretto255_compressed_zero
      ∨ ciphertext.extractLsb' 0 256 = fd_ristretto255_compressed_zero
      ∨ ciphertext.extractLsb' 256 256 = fd_ristretto255_compressed_zero
      ∨ commitment = fd_ristretto255_compressed_zero then
    return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  if !fd_curve25519_scalar_validate.spec proof.zs then
    return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  if !fd_curve25519_scalar_validate.spec proof.zx then
    return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  if !fd_curve25519_scalar_validate.spec proof.zr then
    return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  let points := store points 0 (fd_ristretto255_point_set fd_zksdk_basepoint_G)
  let points := store points 1 (fd_ristretto255_point_set fd_zksdk_basepoint_H)
  let some p := fd_ristretto255_point_decompress proof.y0
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  let points := store points 2 p
  let some p := fd_ristretto255_point_decompress proof.y1
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  let points := store points 3 p
  let some y2 := fd_ristretto255_point_decompress proof.y2
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  let some p := fd_ristretto255_point_decompress pubkey
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  let points := store points 4 p
  let some p := fd_ristretto255_point_decompress (ciphertext.extractLsb' 0 256)
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  let points := store points 5 p
  let some p := fd_ristretto255_point_decompress (ciphertext.extractLsb' 256 256)
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  let points := store points 6 p
  let some p := fd_ristretto255_point_decompress commitment
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  let points := store points 7 p
  -- Finalize transcript and extract challenges
  let transcript := ciph_comm_eq_hash_context transcript pubkey ciphertext commitment
  let transcript := fd_zksdk_transcript_domsep_ciph_comm_eq_proof transcript
  let val := FD_TRANSCRIPT_SUCCESS
  let (transcript, r) := fd_zksdk_transcript_validate_and_append_point transcript
    (FD_TRANSCRIPT_LITERAL "Y_0") proof.y0
  let val := val ||| r
  let (transcript, r) := fd_zksdk_transcript_validate_and_append_point transcript
    (FD_TRANSCRIPT_LITERAL "Y_1") proof.y1
  let val := val ||| r
  let (transcript, r) := fd_zksdk_transcript_validate_and_append_point transcript
    (FD_TRANSCRIPT_LITERAL "Y_2") proof.y2
  let val := val ||| r
  if val ≠ FD_TRANSCRIPT_SUCCESS then
    return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  let (transcript, c) := fd_zksdk_transcript_challenge_scalar transcript (FD_TRANSCRIPT_LITERAL "c")
  let transcript :=
    fd_zksdk_transcript_append_scalar transcript (FD_TRANSCRIPT_LITERAL "z_s") proof.zs
  let transcript :=
    fd_zksdk_transcript_append_scalar transcript (FD_TRANSCRIPT_LITERAL "z_x") proof.zx
  let transcript :=
    fd_zksdk_transcript_append_scalar transcript (FD_TRANSCRIPT_LITERAL "z_r") proof.zr
  let (transcript, w) := fd_zksdk_transcript_challenge_scalar transcript (FD_TRANSCRIPT_LITERAL "w")
  -- Compute scalars
  let scalars := store scalars 7 (fd_curve25519_scalar_neg.spec c)
  let scalars := store scalars 6 (fd_curve25519_scalar_mul.spec proof.zs w)
  let scalars := store scalars 5 (fd_curve25519_scalar_mul.spec (scalars 7) w)
  let scalars := store scalars 4 (fd_curve25519_scalar_mul.spec (scalars 6) w)
  let scalars := store scalars 3 (fd_curve25519_scalar_neg.spec w)
  let scalars := store scalars 2 (fd_curve25519_scalar_mul.spec (scalars 3) w)
  let scalars := store scalars 1 (fd_curve25519_scalar_muladd.spec (scalars 5) w proof.zr)
  let scalars := store scalars 0 (fd_curve25519_scalar_muladd.spec proof.zx w proof.zx)
  -- Compute the final MSM
  let res := fd_ristretto255_multi_scalar_mul scalars points 8#64
  if fd_ristretto255_point_eq.spec res y2 ≠ 0#32 then
    return ⟨FD_ZKSDK_VERIFY_PROOF_SUCCESS, transcript⟩
  return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩

/-- `fd_zksdk_instr_verify_proof_ciphertext_commitment_equality`
(`zksdk/instructions/fd_zksdk_ciphertext_commitment_equality.c:143`): `_context`, `_proof` the
bytes at those pointers (128 and 192 of them). -/
def fd_zksdk_instr_verify_proof_ciphertext_commitment_equality
    (_context _proof : List (BitVec 8)) : BitVec 32 :=
  let transcript :=
    fd_zksdk_transcript_init (FD_TRANSCRIPT_LITERAL "ciphertext-commitment-equality-instruction")
  let context := fd_zksdk_ciph_comm_eq_context_t.ofBytes _context
  let proof := fd_zksdk_ciph_comm_eq_proof_t.ofBytes _proof
  (fd_zksdk_verify_proof_ciphertext_commitment_equality proof context.pubkey context.ciphertext
    context.commitment transcript).ret

end

end MLIR.Firedancer.Ref
