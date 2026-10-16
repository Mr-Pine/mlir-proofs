module

public import Firedancer.Ref.fd_zksdk_common

namespace MLIR.Firedancer.Ref

open fd_zksdk

/-! ## Specification

`ballet/zksdk/instructions/fd_zksdk_percentage_with_cap.{h,c}`. -/

@[expose] public section

/-- `percentage_max_proof_t` (`zksdk/instructions/fd_zksdk_percentage_with_cap.h:6`), packed,
96 bytes. -/
structure percentage_max_proof_t where
  y_max : BitVec 256
  z_max : BitVec 256
  c_max : BitVec 256

/-- `percentage_equality_proof_t` (`zksdk/instructions/fd_zksdk_percentage_with_cap.h:13`), packed,
160 bytes. -/
structure percentage_equality_proof_t where
  y_delta : BitVec 256
  y_claimed : BitVec 256
  z_x : BitVec 256
  z_delta : BitVec 256
  z_claimed : BitVec 256

/-- `fd_zksdk_percentage_with_cap_proof_t`
(`zksdk/instructions/fd_zksdk_percentage_with_cap.h:22`), packed, 256 bytes. -/
structure fd_zksdk_percentage_with_cap_proof_t where
  percentage_max_proof : percentage_max_proof_t
  percentage_equality_proof : percentage_equality_proof_t

/-- `fd_zksdk_percentage_with_cap_context_t`
(`zksdk/instructions/fd_zksdk_percentage_with_cap.h:28`), packed, 104 bytes. -/
structure fd_zksdk_percentage_with_cap_context_t where
  percentage_commitment : BitVec 256
  delta_commitment : BitVec 256
  claimed_commitment : BitVec 256
  max_value : BitVec 64

/-- The proof struct over the bytes `b` at its address. -/
def fd_zksdk_percentage_with_cap_proof_t.ofBytes (b : List (BitVec 8)) :
    fd_zksdk_percentage_with_cap_proof_t :=
  ⟨⟨field b 0 256, field b 32 256, field b 64 256⟩,
    ⟨field b 96 256, field b 128 256, field b 160 256, field b 192 256, field b 224 256⟩⟩

/-- The context struct over the bytes `b` at its address; `max_value` at offset 96. -/
def fd_zksdk_percentage_with_cap_context_t.ofBytes (b : List (BitVec 8)) :
    fd_zksdk_percentage_with_cap_context_t :=
  ⟨field b 0 256, field b 32 256, field b 64 256, field b 96 64⟩

/-- `percentage_with_cap_hash_context` (`zksdk/instructions/fd_zksdk_percentage_with_cap.c:5`). -/
def percentage_with_cap_hash_context (transcript : fd_merlin_transcript_t)
    (percentage_commitment delta_commitment claimed_commitment : BitVec 256)
    (max_value : BitVec 64) : fd_merlin_transcript_t :=
  let transcript := fd_zksdk_transcript_append_commitment transcript
    (FD_TRANSCRIPT_LITERAL "percentage-commitment") percentage_commitment
  let transcript := fd_zksdk_transcript_append_commitment transcript
    (FD_TRANSCRIPT_LITERAL "delta-commitment") delta_commitment
  let transcript := fd_zksdk_transcript_append_commitment transcript
    (FD_TRANSCRIPT_LITERAL "claimed-commitment") claimed_commitment
  let transcript :=
    fd_merlin_transcript_append_u64 transcript (FD_TRANSCRIPT_LITERAL "max-value") max_value
  transcript

/-- `fd_zksdk_verify_proof_percentage_with_cap`
(`zksdk/instructions/fd_zksdk_percentage_with_cap.c:18`); `c_eq` aliases `c`, `m` is reused. -/
def fd_zksdk_verify_proof_percentage_with_cap (proof : fd_zksdk_percentage_with_cap_proof_t)
    (percentage_commitment delta_commitment claimed_commitment : BitVec 256)
    (max_value : BitVec 64) (transcript : fd_merlin_transcript_t) : fd_zksdk_verify_result :=
    Id.run do
  let scalars := uninitScalars
  let points := uninitPoints
  if percentage_commitment = fd_ristretto255_compressed_zero
      ∨ delta_commitment = fd_ristretto255_compressed_zero
      ∨ claimed_commitment = fd_ristretto255_compressed_zero then
    return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  if !fd_curve25519_scalar_validate.spec proof.percentage_max_proof.z_max then
    return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  if !fd_curve25519_scalar_validate.spec proof.percentage_max_proof.c_max then
    return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  if !fd_curve25519_scalar_validate.spec proof.percentage_equality_proof.z_x then
    return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  if !fd_curve25519_scalar_validate.spec proof.percentage_equality_proof.z_delta then
    return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  if !fd_curve25519_scalar_validate.spec proof.percentage_equality_proof.z_claimed then
    return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  let points := store points 0 (fd_ristretto255_point_set fd_zksdk_basepoint_G)
  let points := store points 1 (fd_ristretto255_point_set fd_zksdk_basepoint_H)
  let some p := fd_ristretto255_point_decompress percentage_commitment
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  let points := store points 2 p
  let some p := fd_ristretto255_point_decompress proof.percentage_equality_proof.y_delta
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  let points := store points 3 p
  let some p := fd_ristretto255_point_decompress delta_commitment
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  let points := store points 4 p
  let some p := fd_ristretto255_point_decompress proof.percentage_equality_proof.y_claimed
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  let points := store points 5 p
  let some p := fd_ristretto255_point_decompress claimed_commitment
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  let points := store points 6 p
  let some y := fd_ristretto255_point_decompress proof.percentage_max_proof.y_max
    | return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  -- Finalize transcript and extract challenges
  let transcript := percentage_with_cap_hash_context transcript percentage_commitment
    delta_commitment claimed_commitment max_value
  let transcript := fd_zksdk_transcript_domsep_percentage_with_cap_proof transcript
  let m := fd_curve25519_scalar_from_u64.spec max_value
  let val := FD_TRANSCRIPT_SUCCESS
  let (transcript, r) := fd_zksdk_transcript_validate_and_append_point transcript
    (FD_TRANSCRIPT_LITERAL "Y_max_proof") proof.percentage_max_proof.y_max
  let val := val ||| r
  let (transcript, r) := fd_zksdk_transcript_validate_and_append_point transcript
    (FD_TRANSCRIPT_LITERAL "Y_delta") proof.percentage_equality_proof.y_delta
  let val := val ||| r
  let (transcript, r) := fd_zksdk_transcript_validate_and_append_point transcript
    (FD_TRANSCRIPT_LITERAL "Y_claimed") proof.percentage_equality_proof.y_claimed
  let val := val ||| r
  if val ≠ FD_TRANSCRIPT_SUCCESS then
    return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩
  let (transcript, c) := fd_zksdk_transcript_challenge_scalar transcript (FD_TRANSCRIPT_LITERAL "c")
  let transcript := fd_zksdk_transcript_append_scalar transcript
    (FD_TRANSCRIPT_LITERAL "z_max") proof.percentage_max_proof.z_max
  let transcript := fd_zksdk_transcript_append_scalar transcript
    (FD_TRANSCRIPT_LITERAL "c_max_proof") proof.percentage_max_proof.c_max
  let transcript := fd_zksdk_transcript_append_scalar transcript
    (FD_TRANSCRIPT_LITERAL "z_x") proof.percentage_equality_proof.z_x
  let transcript := fd_zksdk_transcript_append_scalar transcript
    (FD_TRANSCRIPT_LITERAL "z_delta_real") proof.percentage_equality_proof.z_delta
  let transcript := fd_zksdk_transcript_append_scalar transcript
    (FD_TRANSCRIPT_LITERAL "z_claimed") proof.percentage_equality_proof.z_claimed
  let (transcript, w) := fd_zksdk_transcript_challenge_scalar transcript (FD_TRANSCRIPT_LITERAL "w")
  let ww := fd_curve25519_scalar_mul.spec w w
  let c_max := proof.percentage_max_proof.c_max
  -- `uchar * c_eq = c;` then `fd_curve25519_scalar_sub( c_eq, c, c_max )`
  let c := fd_curve25519_scalar_sub.spec c c_max
  let c_eq := c
  -- Compute scalars
  -- G: c_max * m - (w + ww) z_x
  let m := fd_curve25519_scalar_mul.spec m c_max
  let scalars := store scalars 0 (fd_curve25519_scalar_add.spec w ww)
  let scalars := store scalars 0
    (fd_curve25519_scalar_mul.spec (scalars 0) proof.percentage_equality_proof.z_x)
  let scalars := store scalars 0 (fd_curve25519_scalar_sub.spec m (scalars 0))
  -- H: z_max - (w z_delta + ww z_claimed)
  let m := fd_curve25519_scalar_mul.spec w proof.percentage_equality_proof.z_delta
  let scalars := store scalars 1
    (fd_curve25519_scalar_muladd.spec ww proof.percentage_equality_proof.z_claimed m)
  let scalars := store scalars 1
    (fd_curve25519_scalar_sub.spec proof.percentage_max_proof.z_max (scalars 1))
  -- remaining scalars
  let scalars := store scalars 2 (fd_curve25519_scalar_neg.spec c_max)
  let scalars := store scalars 3 (fd_curve25519_scalar_set.spec w)
  let scalars := store scalars 4 (fd_curve25519_scalar_mul.spec (scalars 3) c_eq)
  let scalars := store scalars 5 (fd_curve25519_scalar_set.spec ww)
  let scalars := store scalars 6 (fd_curve25519_scalar_mul.spec (scalars 5) c_eq)
  -- Compute the final MSM
  let res := fd_ristretto255_multi_scalar_mul scalars points 7#64
  if fd_ristretto255_point_eq.spec res y ≠ 0#32 then
    return ⟨FD_ZKSDK_VERIFY_PROOF_SUCCESS, transcript⟩
  return ⟨FD_ZKSDK_VERIFY_PROOF_ERROR, transcript⟩

/-- `fd_zksdk_instr_verify_proof_percentage_with_cap`
(`zksdk/instructions/fd_zksdk_percentage_with_cap.c:161`): `_context`, `_proof` the bytes at those
pointers (104 and 256 of them). -/
def fd_zksdk_instr_verify_proof_percentage_with_cap (_context _proof : List (BitVec 8)) :
    BitVec 32 :=
  let transcript :=
    fd_zksdk_transcript_init (FD_TRANSCRIPT_LITERAL "percentage-with-cap-instruction")
  let context := fd_zksdk_percentage_with_cap_context_t.ofBytes _context
  let proof := fd_zksdk_percentage_with_cap_proof_t.ofBytes _proof
  (fd_zksdk_verify_proof_percentage_with_cap proof context.percentage_commitment
    context.delta_commitment context.claimed_commitment context.max_value transcript).ret

end

end MLIR.Firedancer.Ref
