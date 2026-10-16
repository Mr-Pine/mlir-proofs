module

public import Firedancer.Ref.fd_zksdk_common

namespace MLIR.Firedancer.Ref

open fd_zksdk

/-! ## Specification

`ballet/zksdk/instructions/fd_zksdk_zero_ciphertext.{h,c}`. A ciphertext's commitment is its bytes
`[0, 32)` (`ciphertext.extractLsb' 0 256`), its handle `[32, 64)`. -/

@[expose] public section

/-- `fd_zksdk_zero_ciphertext_proof_t` (`zksdk/instructions/fd_zksdk_zero_ciphertext.h:6`), packed,
96 bytes. -/
structure fd_zksdk_zero_ciphertext_proof_t where
  yp : BitVec 256
  yd : BitVec 256
  z : BitVec 256

/-- `fd_zksdk_zero_ciphertext_context_t` (`zksdk/instructions/fd_zksdk_zero_ciphertext.h:13`),
packed, 96 bytes. -/
structure fd_zksdk_zero_ciphertext_context_t where
  pubkey : BitVec 256
  ciphertext : BitVec 512

/-- The proof struct over the bytes `b` at its address. -/
def fd_zksdk_zero_ciphertext_proof_t.ofBytes (b : List (BitVec 8)) :
    fd_zksdk_zero_ciphertext_proof_t :=
  ⟨field b 0 256, field b 32 256, field b 64 256⟩

/-- The context struct over the bytes `b` at its address. -/
def fd_zksdk_zero_ciphertext_context_t.ofBytes (b : List (BitVec 8)) :
    fd_zksdk_zero_ciphertext_context_t :=
  ⟨field b 0 256, field b 32 512⟩

/-- `zero_ciphertext_hash_context` (`zksdk/instructions/fd_zksdk_zero_ciphertext.c:5`). -/
def zero_ciphertext_hash_context (transcript : fd_merlin_transcript_t) (pubkey : BitVec 256)
    (ciphertext : BitVec 512) : fd_merlin_transcript_t :=
  let transcript :=
    fd_zksdk_transcript_append_pubkey transcript (FD_TRANSCRIPT_LITERAL "pubkey") pubkey
  let transcript :=
    fd_zksdk_transcript_append_ciphertext transcript (FD_TRANSCRIPT_LITERAL "ciphertext") ciphertext
  transcript

/-- `fd_zksdk_verify_proof_zero_ciphertext` (`zksdk/instructions/fd_zksdk_zero_ciphertext.c:14`). -/
def fd_zksdk_verify_proof_zero_ciphertext (proof : fd_zksdk_zero_ciphertext_proof_t)
    (pubkey : BitVec 256) (ciphertext : BitVec 512) (transcript : fd_merlin_transcript_t) :
    fd_zksdk_verify_result := Id.run do
  let scalars := uninitScalars
  let points := uninitPoints
  if pubkey = fd_ristretto255_compressed_zero
      ∨ ciphertext.extractLsb' 0 256 = fd_ristretto255_compressed_zero
      ∨ ciphertext.extractLsb' 256 256 = fd_ristretto255_compressed_zero then
    return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  if !fd_curve25519_scalar_validate.spec proof.z then
    return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  let points := store points 0 (fd_ristretto255_point_set fd_zksdk_basepoint_H)
  let some p := fd_ristretto255_point_decompress pubkey
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  let points := store points 1 p
  let some p := fd_ristretto255_point_decompress (ciphertext.extractLsb' 0 256)
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  let points := store points 2 p
  let some p := fd_ristretto255_point_decompress (ciphertext.extractLsb' 256 256)
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  let points := store points 3 p
  let some p := fd_ristretto255_point_decompress proof.yd
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  let points := store points 4 p
  let some y := fd_ristretto255_point_decompress proof.yp
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  -- Finalize transcript and extract challenges
  let transcript := zero_ciphertext_hash_context transcript pubkey ciphertext
  let transcript := fd_zksdk_transcript_domsep_zero_ciphertext_proof transcript
  let val := FD_TRANSCRIPT_SUCCESS
  let (transcript, r) := fd_zksdk_transcript_validate_and_append_point transcript
    (FD_TRANSCRIPT_LITERAL "Y_P") proof.yp
  let val := val ||| r
  if val ≠ FD_TRANSCRIPT_SUCCESS then
    return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  let transcript :=
    fd_zksdk_transcript_append_point transcript (FD_TRANSCRIPT_LITERAL "Y_D") proof.yd
  let (transcript, c) := fd_zksdk_transcript_challenge_scalar transcript (FD_TRANSCRIPT_LITERAL "c")
  let transcript := fd_zksdk_transcript_append_scalar transcript (FD_TRANSCRIPT_LITERAL "z") proof.z
  let (transcript, w) := fd_zksdk_transcript_challenge_scalar transcript (FD_TRANSCRIPT_LITERAL "w")
  -- Compute scalars
  let scalars := store scalars 0 (fd_curve25519_scalar_neg.spec c)
  let scalars := store scalars 1 (fd_curve25519_scalar_set.spec proof.z)
  let scalars := store scalars 2 (fd_curve25519_scalar_mul.spec (scalars 0) w)
  let scalars := store scalars 3 (fd_curve25519_scalar_mul.spec w proof.z)
  let scalars := store scalars 4 (fd_curve25519_scalar_neg.spec w)
  -- Compute the final MSM
  let res := fd_ristretto255_multi_scalar_mul scalars points 5#64
  if fd_ristretto255_point_eq.spec res y ≠ 0#32 then
    return ⟨FD_ZKSDK_VERIFY_PROOF_SUCCESS, transcript⟩
  return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩

/-- `fd_zksdk_instr_verify_proof_zero_ciphertext`
(`zksdk/instructions/fd_zksdk_zero_ciphertext.c:120`): `_context`, `_proof` the bytes at those
pointers (96 and 96 of them). -/
def fd_zksdk_instr_verify_proof_zero_ciphertext (_context _proof : List (BitVec 8)) : BitVec 32 :=
  let transcript := fd_zksdk_transcript_init (FD_TRANSCRIPT_LITERAL "zero-ciphertext-instruction")
  let context := fd_zksdk_zero_ciphertext_context_t.ofBytes _context
  let proof := fd_zksdk_zero_ciphertext_proof_t.ofBytes _proof
  (fd_zksdk_verify_proof_zero_ciphertext proof context.pubkey context.ciphertext transcript).ret

end

end MLIR.Firedancer.Ref
