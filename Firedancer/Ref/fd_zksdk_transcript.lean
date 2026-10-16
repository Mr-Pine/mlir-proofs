module

public import Firedancer.Ref.fd_merlin
public import Firedancer.Ref.fd_curve25519_scalar_reduce

namespace MLIR.Firedancer.Ref

open _root_.Ed25519 (bytesLE)

/-! ## Specification

`ballet/zksdk/transcript/fd_zksdk_transcript.h` and the transcript half of
`ballet/zksdk/rangeproofs/fd_rangeproofs_transcript.h`. A point, scalar, pubkey, commitment or
handle is the 32 bytes at its pointer as a little-endian 256-bit value, a ciphertext the 64 bytes
as a 512-bit one; `bytesLE` gives those bytes back in memory order. A function that updates
`*transcript` returns the new transcript first. -/

@[expose] public section

/-- `FD_TRANSCRIPT_LITERAL` (`zksdk/transcript/fd_zksdk_transcript.h:12`), `FD_MERLIN_LITERAL`. -/
abbrev FD_TRANSCRIPT_LITERAL := FD_MERLIN_LITERAL

/-- `FD_TRANSCRIPT_SUCCESS` (`zksdk/rangeproofs/fd_rangeproofs_transcript.h:9`), an `int`. -/
def FD_TRANSCRIPT_SUCCESS : BitVec 32 := 0#32

/-- `FD_TRANSCRIPT_ERROR` (`zksdk/rangeproofs/fd_rangeproofs_transcript.h:10`), an `int`. -/
def FD_TRANSCRIPT_ERROR : BitVec 32 := -1#32

/-- `fd_ristretto255_compressed_zero` (`ballet/ed25519/fd_ristretto255.h:19`). -/
def fd_ristretto255_compressed_zero : BitVec 256 :=
  ofBytesLE 256 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

/-! ### `fd_rangeproofs_transcript.h` -/

/-- `fd_rangeproofs_transcript_append_point` (`zksdk/rangeproofs/fd_rangeproofs_transcript.h:42`). -/
def fd_rangeproofs_transcript_append_point (transcript : fd_merlin_transcript_t)
    (label : List (BitVec 8)) (point : BitVec 256) : fd_merlin_transcript_t :=
  fd_merlin_transcript_append_message transcript label (bytesLE point) 32#32

/-- `fd_rangeproofs_transcript_validate_and_append_point`
(`zksdk/rangeproofs/fd_rangeproofs_transcript.h:50`): `fd_memeq` against the zero encoding. -/
def fd_rangeproofs_transcript_validate_and_append_point (transcript : fd_merlin_transcript_t)
    (label : List (BitVec 8)) (point : BitVec 256) : fd_merlin_transcript_t × BitVec 32 :=
  if point = fd_ristretto255_compressed_zero then (transcript, FD_TRANSCRIPT_ERROR)
  else
    let transcript := fd_rangeproofs_transcript_append_point transcript label point
    (transcript, FD_TRANSCRIPT_SUCCESS)

/-- `fd_rangeproofs_transcript_append_scalar` (`zksdk/rangeproofs/fd_rangeproofs_transcript.h:62`). -/
def fd_rangeproofs_transcript_append_scalar (transcript : fd_merlin_transcript_t)
    (label : List (BitVec 8)) (scalar : BitVec 256) : fd_merlin_transcript_t :=
  fd_merlin_transcript_append_message transcript label (bytesLE scalar) 32#32

/-- `fd_rangeproofs_transcript_challenge_scalar`
(`zksdk/rangeproofs/fd_rangeproofs_transcript.h:74`): the transcript and the scalar stored. -/
def fd_rangeproofs_transcript_challenge_scalar (transcript : fd_merlin_transcript_t)
    (label : List (BitVec 8)) : fd_merlin_transcript_t × BitVec 256 :=
  let (transcript, unreduced) := fd_merlin_transcript_challenge_bytes transcript label 64#32
  (transcript, fd_curve25519_scalar_reduce.spec (ofBytesLE 512 unreduced))

/-! ### `fd_zksdk_transcript.h` -/

/-- `fd_zksdk_transcript_append_message` (`zksdk/transcript/fd_zksdk_transcript.h:14`). -/
abbrev fd_zksdk_transcript_append_message := fd_merlin_transcript_append_message
/-- `fd_zksdk_transcript_append_point` (`zksdk/transcript/fd_zksdk_transcript.h:15`). -/
abbrev fd_zksdk_transcript_append_point := fd_rangeproofs_transcript_append_point
/-- `fd_zksdk_transcript_validate_and_append_point`
(`zksdk/transcript/fd_zksdk_transcript.h:16`). -/
abbrev fd_zksdk_transcript_validate_and_append_point :=
  fd_rangeproofs_transcript_validate_and_append_point
/-- `fd_zksdk_transcript_append_scalar` (`zksdk/transcript/fd_zksdk_transcript.h:17`). -/
abbrev fd_zksdk_transcript_append_scalar := fd_rangeproofs_transcript_append_scalar
/-- `fd_zksdk_transcript_challenge_scalar` (`zksdk/transcript/fd_zksdk_transcript.h:18`). -/
abbrev fd_zksdk_transcript_challenge_scalar := fd_rangeproofs_transcript_challenge_scalar

/-- `fd_zksdk_transcript_init` (`zksdk/transcript/fd_zksdk_transcript.h:31`); `label_len` is the
length of `label`, as `FD_TRANSCRIPT_LITERAL` gives it at every call. -/
def fd_zksdk_transcript_init (label : List (BitVec 8)) : fd_merlin_transcript_t :=
  let lbl := FD_TRANSCRIPT_LITERAL "solana-zk-elgamal-proof-program-v1"
  let transcript := fd_merlin_transcript_init lbl (BitVec.ofNat 32 lbl.length)
  fd_merlin_transcript_append_message transcript (FD_TRANSCRIPT_LITERAL "dom-sep") label
    (BitVec.ofNat 32 label.length)

/-- `fd_zksdk_transcript_append_pubkey` (`zksdk/transcript/fd_zksdk_transcript.h:40`). -/
def fd_zksdk_transcript_append_pubkey (transcript : fd_merlin_transcript_t)
    (label : List (BitVec 8)) (pubkey : BitVec 256) : fd_merlin_transcript_t :=
  fd_merlin_transcript_append_message transcript label (bytesLE pubkey) 32#32

/-- `fd_zksdk_transcript_append_ciphertext` (`zksdk/transcript/fd_zksdk_transcript.h:48`). -/
def fd_zksdk_transcript_append_ciphertext (transcript : fd_merlin_transcript_t)
    (label : List (BitVec 8)) (ciphertext : BitVec 512) : fd_merlin_transcript_t :=
  fd_merlin_transcript_append_message transcript label (bytesLE ciphertext) 64#32

/-- `fd_zksdk_transcript_append_commitment` (`zksdk/transcript/fd_zksdk_transcript.h:56`). -/
def fd_zksdk_transcript_append_commitment (transcript : fd_merlin_transcript_t)
    (label : List (BitVec 8)) (commitment : BitVec 256) : fd_merlin_transcript_t :=
  fd_merlin_transcript_append_message transcript label (bytesLE commitment) 32#32

/-- `dom-sep` with the literal `s` as the message. -/
def fd_zksdk_transcript_domsep (transcript : fd_merlin_transcript_t) (s : String) :
    fd_merlin_transcript_t :=
  let msg := FD_TRANSCRIPT_LITERAL s
  fd_merlin_transcript_append_message transcript (FD_TRANSCRIPT_LITERAL "dom-sep") msg
    (BitVec.ofNat 32 msg.length)

/-- `fd_zksdk_transcript_domsep_ciph_ciph_eq_proof` (`zksdk/transcript/fd_zksdk_transcript.h:68`). -/
def fd_zksdk_transcript_domsep_ciph_ciph_eq_proof (transcript : fd_merlin_transcript_t) :
    fd_merlin_transcript_t :=
  fd_zksdk_transcript_domsep transcript "ciphertext-ciphertext-equality-proof"

/-- `fd_zksdk_transcript_domsep_ciph_comm_eq_proof` (`zksdk/transcript/fd_zksdk_transcript.h:73`). -/
def fd_zksdk_transcript_domsep_ciph_comm_eq_proof (transcript : fd_merlin_transcript_t) :
    fd_merlin_transcript_t :=
  fd_zksdk_transcript_domsep transcript "ciphertext-commitment-equality-proof"

/-- `fd_zksdk_transcript_domsep_zero_ciphertext_proof`
(`zksdk/transcript/fd_zksdk_transcript.h:78`). -/
def fd_zksdk_transcript_domsep_zero_ciphertext_proof (transcript : fd_merlin_transcript_t) :
    fd_merlin_transcript_t :=
  fd_zksdk_transcript_domsep transcript "zero-ciphertext-proof"

/-- `fd_zksdk_transcript_domsep_grp_ciph_val_proof` (`zksdk/transcript/fd_zksdk_transcript.h:83`). -/
def fd_zksdk_transcript_domsep_grp_ciph_val_proof (transcript : fd_merlin_transcript_t)
    (handles : BitVec 64) : fd_merlin_transcript_t :=
  let transcript := fd_zksdk_transcript_domsep transcript "validity-proof"
  fd_merlin_transcript_append_u64 transcript (FD_TRANSCRIPT_LITERAL "handles") handles

/-- `fd_zksdk_transcript_domsep_batched_grp_ciph_val_proof`
(`zksdk/transcript/fd_zksdk_transcript.h:89`). -/
def fd_zksdk_transcript_domsep_batched_grp_ciph_val_proof (transcript : fd_merlin_transcript_t)
    (handles : BitVec 64) : fd_merlin_transcript_t :=
  let transcript := fd_zksdk_transcript_domsep transcript "batched-validity-proof"
  fd_merlin_transcript_append_u64 transcript (FD_TRANSCRIPT_LITERAL "handles") handles

/-- `fd_zksdk_transcript_domsep_percentage_with_cap_proof`
(`zksdk/transcript/fd_zksdk_transcript.h:95`). -/
def fd_zksdk_transcript_domsep_percentage_with_cap_proof (transcript : fd_merlin_transcript_t) :
    fd_merlin_transcript_t :=
  fd_zksdk_transcript_domsep transcript "percentage-with-cap-proof"

/-- `fd_zksdk_transcript_domsep_pubkey_proof` (`zksdk/transcript/fd_zksdk_transcript.h:100`). -/
def fd_zksdk_transcript_domsep_pubkey_proof (transcript : fd_merlin_transcript_t) :
    fd_merlin_transcript_t :=
  fd_zksdk_transcript_domsep transcript "pubkey-proof"

end

end MLIR.Firedancer.Ref
