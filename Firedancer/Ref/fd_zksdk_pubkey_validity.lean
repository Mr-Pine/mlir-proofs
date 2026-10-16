module

public import Firedancer.Ref.fd_zksdk_common

namespace MLIR.Firedancer.Ref

open fd_zksdk

/-! ## Specification

`ballet/zksdk/instructions/fd_zksdk_pubkey_validity.{h,c}`. -/

@[expose] public section

/-- `fd_zksdk_pubkey_validity_proof_t` (`zksdk/instructions/fd_zksdk_pubkey_validity.h:6`), packed,
64 bytes. -/
structure fd_zksdk_pubkey_validity_proof_t where
  y : BitVec 256
  z : BitVec 256

/-- `fd_zksdk_pubkey_validity_context_t` (`zksdk/instructions/fd_zksdk_pubkey_validity.h:12`),
packed, 32 bytes. -/
structure fd_zksdk_pubkey_validity_context_t where
  pubkey : BitVec 256

/-- The proof struct over the bytes `b` at its address. -/
def fd_zksdk_pubkey_validity_proof_t.ofBytes (b : List (BitVec 8)) :
    fd_zksdk_pubkey_validity_proof_t :=
  ⟨field b 0 256, field b 32 256⟩

/-- The context struct over the bytes `b` at its address. -/
def fd_zksdk_pubkey_validity_context_t.ofBytes (b : List (BitVec 8)) :
    fd_zksdk_pubkey_validity_context_t :=
  ⟨field b 0 256⟩

/-- `pubkey_validity_hash_context` (`zksdk/instructions/fd_zksdk_pubkey_validity.c:5`). -/
def pubkey_validity_hash_context (transcript : fd_merlin_transcript_t) (pubkey : BitVec 256) :
    fd_merlin_transcript_t :=
  fd_zksdk_transcript_append_pubkey transcript (FD_TRANSCRIPT_LITERAL "pubkey") pubkey

/-- `fd_zksdk_verify_proof_pubkey_validity` (`zksdk/instructions/fd_zksdk_pubkey_validity.c:12`);
the context is hashed before the zero check. -/
def fd_zksdk_verify_proof_pubkey_validity (proof : fd_zksdk_pubkey_validity_proof_t)
    (pubkey : BitVec 256) (transcript : fd_merlin_transcript_t) : fd_zksdk_verify_result :=
    Id.run do
  let scalars := uninitScalars
  let points := uninitPoints
  let transcript := pubkey_validity_hash_context transcript pubkey
  let transcript := fd_zksdk_transcript_domsep_pubkey_proof transcript
  if pubkey = fd_ristretto255_compressed_zero then
    return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  if !fd_curve25519_scalar_validate.spec proof.z then
    return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  let points := store points 0 (fd_ristretto255_point_set fd_zksdk_basepoint_H)
  let some p := fd_ristretto255_point_decompress pubkey
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  let points := store points 1 p
  let some y := fd_ristretto255_point_decompress proof.y
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  -- Finalize transcript and extract challenges
  let val := FD_TRANSCRIPT_SUCCESS
  let (transcript, r) := fd_zksdk_transcript_validate_and_append_point transcript
    (FD_TRANSCRIPT_LITERAL "Y") proof.y
  let val := val ||| r
  if val ≠ FD_TRANSCRIPT_SUCCESS then
    return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  let (transcript, c) := fd_zksdk_transcript_challenge_scalar transcript (FD_TRANSCRIPT_LITERAL "c")
  -- Compute scalars
  let scalars := store scalars 0 (fd_curve25519_scalar_set.spec proof.z)
  let scalars := store scalars 1 (fd_curve25519_scalar_neg.spec c)
  -- Compute the final MSM
  let res := fd_ristretto255_multi_scalar_mul scalars points 2#64
  if fd_ristretto255_point_eq.spec res y ≠ 0#32 then
    return ⟨FD_ZKSDK_VERIFY_PROOF_SUCCESS, transcript⟩
  return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩

/-- `fd_zksdk_instr_verify_proof_pubkey_validity`
(`zksdk/instructions/fd_zksdk_pubkey_validity.c:82`): `_context`, `_proof` the bytes at those
pointers (32 and 64 of them). -/
def fd_zksdk_instr_verify_proof_pubkey_validity (_context _proof : List (BitVec 8)) : BitVec 32 :=
  let transcript := fd_zksdk_transcript_init (FD_TRANSCRIPT_LITERAL "pubkey-validity-instruction")
  let context := fd_zksdk_pubkey_validity_context_t.ofBytes _context
  let proof := fd_zksdk_pubkey_validity_proof_t.ofBytes _proof
  (fd_zksdk_verify_proof_pubkey_validity proof context.pubkey transcript).ret

end

end MLIR.Firedancer.Ref
