module

public import Firedancer.Ref.fd_zksdk_common

namespace MLIR.Firedancer.Ref

open _root_.Ed25519 (bytesLE)
open fd_zksdk

/-! ## Specification

`ballet/zksdk/instructions/fd_zksdk_grouped_ciphertext_2_handles_validity.c` and the 2-handle
structs of `fd_zksdk_batched_grouped_ciphertext_validity.h`. Static helpers whose names recur in
other translation units live in a namespace named after their file. -/

@[expose] public section

/-- `fd_zksdk_grp_ciph_2h_val_proof_t`
(`zksdk/instructions/fd_zksdk_batched_grouped_ciphertext_validity.h:11`), packed, 160 bytes; also
`fd_zksdk_batched_grp_ciph_2h_val_proof_t` (`:19`). -/
structure fd_zksdk_grp_ciph_2h_val_proof_t where
  y0 : BitVec 256
  y1 : BitVec 256
  y2 : BitVec 256
  zr : BitVec 256
  zx : BitVec 256

/-- `grp_ciph_handle_t` (`zksdk/instructions/fd_zksdk_batched_grouped_ciphertext_validity.h:37`),
packed, 32 bytes. -/
structure grp_ciph_handle_t where
  handle : BitVec 256

/-- `grp_ciph_2h_t` (`zksdk/instructions/fd_zksdk_batched_grouped_ciphertext_validity.h:42`),
packed, 96 bytes. -/
structure grp_ciph_2h_t where
  commitment : BitVec 256
  handles : Vector grp_ciph_handle_t 2

/-- `fd_zksdk_grp_ciph_2h_val_context_t`
(`zksdk/instructions/fd_zksdk_batched_grouped_ciphertext_validity.h:54`), packed, 160 bytes. -/
structure fd_zksdk_grp_ciph_2h_val_context_t where
  pubkey1 : BitVec 256
  pubkey2 : BitVec 256
  grouped_ciphertext : grp_ciph_2h_t

/-- The proof struct over the bytes `b` at its address. -/
def fd_zksdk_grp_ciph_2h_val_proof_t.ofBytes (b : List (BitVec 8)) :
    fd_zksdk_grp_ciph_2h_val_proof_t :=
  ⟨field b 0 256, field b 32 256, field b 64 256, field b 96 256, field b 128 256⟩

/-- A `grp_ciph_2h_t` over the bytes `b` at its address. -/
def grp_ciph_2h_t.ofBytes (b : List (BitVec 8)) : grp_ciph_2h_t :=
  ⟨field b 0 256, #v[⟨field b 32 256⟩, ⟨field b 64 256⟩]⟩

/-- The 96 bytes of a `grp_ciph_2h_t` in memory order. -/
def grp_ciph_2h_t.toBytes (g : grp_ciph_2h_t) : List (BitVec 8) :=
  bytesLE g.commitment ++ bytesLE g.handles[0].handle ++ bytesLE g.handles[1].handle

/-- The context struct over the bytes `b` at its address. -/
def fd_zksdk_grp_ciph_2h_val_context_t.ofBytes (b : List (BitVec 8)) :
    fd_zksdk_grp_ciph_2h_val_context_t :=
  ⟨field b 0 256, field b 32 256, grp_ciph_2h_t.ofBytes (b.drop 64)⟩

/-- `grouped_ciphertext_validity_hash_context`
(`zksdk/instructions/fd_zksdk_grouped_ciphertext_2_handles_validity.c:5`), static. -/
def grouped_ciphertext_2_handles_validity.grouped_ciphertext_validity_hash_context
    (transcript : fd_merlin_transcript_t) (pubkey1 pubkey2 : BitVec 256)
    (grouped_ciphertext : grp_ciph_2h_t) : fd_merlin_transcript_t :=
  let transcript :=
    fd_zksdk_transcript_append_pubkey transcript (FD_TRANSCRIPT_LITERAL "first-pubkey") pubkey1
  let transcript :=
    fd_zksdk_transcript_append_pubkey transcript (FD_TRANSCRIPT_LITERAL "second-pubkey") pubkey2
  let transcript := fd_zksdk_transcript_append_message transcript
    (FD_TRANSCRIPT_LITERAL "grouped-ciphertext") grouped_ciphertext.toBytes 96#32
  transcript

/-- `fd_zksdk_verify_proof_direct_grouped_ciphertext_2_handles_validity`
(`zksdk/instructions/fd_zksdk_grouped_ciphertext_2_handles_validity.c:54`); with `batched = 0` the
`NULL` `_hi` and `challenge_t` arguments are unread. -/
def fd_zksdk_verify_proof_direct_grouped_ciphertext_2_handles_validity
    (proof : fd_zksdk_grp_ciph_2h_val_proof_t)
    (pubkey1 pubkey2 comm handle1 handle2 comm_hi handle1_hi handle2_hi challenge_t : BitVec 256)
    (batched : BitVec 32) (transcript : fd_merlin_transcript_t) : fd_zksdk_verify_result :=
    Id.run do
  let mut scalars := uninitScalars
  let mut points := uninitPoints
  if !fd_curve25519_scalar_validate.spec proof.zr then
    return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  if !fd_curve25519_scalar_validate.spec proof.zx then
    return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  points := store points 0 (fd_ristretto255_point_set fd_zksdk_basepoint_G)
  points := store points 1 (fd_ristretto255_point_set fd_zksdk_basepoint_H)
  let some y0 := fd_ristretto255_point_decompress proof.y0
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  let some p := fd_ristretto255_point_decompress proof.y1
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  points := store points 2 p
  let some p := fd_ristretto255_point_decompress proof.y2
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  points := store points 3 p
  let some p := fd_ristretto255_point_decompress pubkey1
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  points := store points 4 p
  let some p := fd_ristretto255_point_decompress comm
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  points := store points 5 p
  let some p := fd_ristretto255_point_decompress handle1
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  points := store points 6 p
  let mut idx : BitVec 64 := 7#64
  if batched ≠ 0#32 then
    let some p := fd_ristretto255_point_decompress comm_hi
      | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
    points := store points idx.toNat p
    idx := idx + 1#64
    let some p := fd_ristretto255_point_decompress handle1_hi
      | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
    points := store points idx.toNat p
    idx := idx + 1#64
  let some p := fd_ristretto255_point_decompress pubkey2
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  points := store points idx.toNat p
  idx := idx + 1#64
  let some p := fd_ristretto255_point_decompress handle2
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  points := store points idx.toNat p
  idx := idx + 1#64
  if batched ≠ 0#32 then
    let some p := fd_ristretto255_point_decompress handle2_hi
      | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
    points := store points idx.toNat p
    idx := idx + 1#64
  -- Finalize transcript and extract challenges
  let transcript := fd_zksdk_transcript_domsep_grp_ciph_val_proof transcript 2#64
  let val := FD_TRANSCRIPT_SUCCESS
  let (transcript, r) := fd_zksdk_transcript_validate_and_append_point transcript
    (FD_TRANSCRIPT_LITERAL "Y_0") proof.y0
  let val := val ||| r
  let (transcript, r) := fd_zksdk_transcript_validate_and_append_point transcript
    (FD_TRANSCRIPT_LITERAL "Y_1") proof.y1
  let val := val ||| r
  if val ≠ FD_TRANSCRIPT_SUCCESS then
    return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  -- Y_2 can be an all zero point if the pubkey2 is all zero
  let transcript :=
    fd_zksdk_transcript_append_point transcript (FD_TRANSCRIPT_LITERAL "Y_2") proof.y2
  let (transcript, c) := fd_zksdk_transcript_challenge_scalar transcript (FD_TRANSCRIPT_LITERAL "c")
  let transcript :=
    fd_zksdk_transcript_append_scalar transcript (FD_TRANSCRIPT_LITERAL "z_r") proof.zr
  let transcript :=
    fd_zksdk_transcript_append_scalar transcript (FD_TRANSCRIPT_LITERAL "z_x") proof.zx
  let (transcript, w) := fd_zksdk_transcript_challenge_scalar transcript (FD_TRANSCRIPT_LITERAL "w")
  -- Compute scalars
  scalars := store scalars 0 (fd_curve25519_scalar_set.spec proof.zx)
  scalars := store scalars 1 (fd_curve25519_scalar_set.spec proof.zr)
  scalars := store scalars 2 (fd_curve25519_scalar_neg.spec w)
  scalars := store scalars 3 (fd_curve25519_scalar_mul.spec (scalars 2) w)
  scalars := store scalars 4 (fd_curve25519_scalar_mul.spec proof.zr w)
  scalars := store scalars 5 (fd_curve25519_scalar_neg.spec c)
  scalars := store scalars 6 (fd_curve25519_scalar_mul.spec (scalars 5) w)
  idx := 7#64
  if batched ≠ 0#32 then
    scalars := store scalars idx.toNat (fd_curve25519_scalar_mul.spec (scalars 5) challenge_t)
    idx := idx + 1#64
    scalars := store scalars idx.toNat (fd_curve25519_scalar_mul.spec (scalars 6) challenge_t)
    idx := idx + 1#64
  scalars := store scalars idx.toNat (fd_curve25519_scalar_mul.spec (scalars 4) w)
  idx := idx + 1#64
  scalars := store scalars idx.toNat (fd_curve25519_scalar_mul.spec (scalars 6) w)
  idx := idx + 1#64
  if batched ≠ 0#32 then
    scalars := store scalars idx.toNat (fd_curve25519_scalar_mul.spec (scalars 8) w)
    idx := idx + 1#64
  -- Compute the final MSM
  let res := fd_ristretto255_multi_scalar_mul scalars points idx
  if fd_ristretto255_point_eq.spec res y0 ≠ 0#32 then
    return ⟨FD_ZKSDK_VERIFY_PROOF_SUCCESS, transcript⟩
  return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩

/-- `fd_zksdk_verify_proof_grouped_ciphertext_2_handles_validity`
(`zksdk/instructions/fd_zksdk_grouped_ciphertext_2_handles_validity.c:15`); `pubkey2` is not
checked against zero. -/
def fd_zksdk_verify_proof_grouped_ciphertext_2_handles_validity
    (proof : fd_zksdk_grp_ciph_2h_val_proof_t) (pubkey1 pubkey2 : BitVec 256)
    (grouped_ciphertext : grp_ciph_2h_t) (transcript : fd_merlin_transcript_t) :
    fd_zksdk_verify_result :=
  if pubkey1 = fd_ristretto255_compressed_zero
      ∨ grouped_ciphertext.commitment = fd_ristretto255_compressed_zero then
    ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  else
    let transcript :=
      grouped_ciphertext_2_handles_validity.grouped_ciphertext_validity_hash_context transcript
        pubkey1 pubkey2 grouped_ciphertext
    -- NULL, NULL, NULL, NULL, 0
    fd_zksdk_verify_proof_direct_grouped_ciphertext_2_handles_validity proof pubkey1 pubkey2
      grouped_ciphertext.commitment grouped_ciphertext.handles[0].handle
      grouped_ciphertext.handles[1].handle 0#256 0#256 0#256 0#256 0#32 transcript

/-- `fd_zksdk_instr_verify_proof_grouped_ciphertext_2_handles_validity`
(`zksdk/instructions/fd_zksdk_grouped_ciphertext_2_handles_validity.c:221`): `_context`, `_proof`
the bytes at those pointers (160 and 160 of them). -/
def fd_zksdk_instr_verify_proof_grouped_ciphertext_2_handles_validity
    (_context _proof : List (BitVec 8)) : BitVec 32 :=
  let transcript := fd_zksdk_transcript_init
    (FD_TRANSCRIPT_LITERAL "grouped-ciphertext-validity-2-handles-instruction")
  let context := fd_zksdk_grp_ciph_2h_val_context_t.ofBytes _context
  let proof := fd_zksdk_grp_ciph_2h_val_proof_t.ofBytes _proof
  (fd_zksdk_verify_proof_grouped_ciphertext_2_handles_validity proof context.pubkey1
    context.pubkey2 context.grouped_ciphertext transcript).ret

end

end MLIR.Firedancer.Ref
