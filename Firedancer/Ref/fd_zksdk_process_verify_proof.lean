module

public import Firedancer.Ref.fd_zksdk_zero_ciphertext
public import Firedancer.Ref.fd_zksdk_ciphertext_ciphertext_equality
public import Firedancer.Ref.fd_zksdk_ciphertext_commitment_equality
public import Firedancer.Ref.fd_zksdk_pubkey_validity
public import Firedancer.Ref.fd_zksdk_percentage_with_cap
public import Firedancer.Ref.fd_zksdk_batched_grouped_ciphertext_2_handles_validity
public import Firedancer.Ref.fd_zksdk_batched_grouped_ciphertext_3_handles_validity

namespace MLIR.Firedancer.Ref

/-! ## Specification

The instruction-data part of `fd_zksdk_process_verify_proof`
(`flamenco/runtime/program/fd_zk_elgamal_proof_program.c:13`): dispatch on `instr_data[0]`, the size
check, the slicing into context and proof, and the verifier call. What touches accounts, the log
collector or the executor context is not modelled; `Result` says where it would take over. -/

@[expose] public section

/-- `FD_EXECUTOR_INSTR_ERR_INVALID_INSTR_DATA` (`flamenco/runtime/fd_executor_err.h:16`). -/
def FD_EXECUTOR_INSTR_ERR_INVALID_INSTR_DATA : BitVec 32 := -3#32

/-- `FD_ZKSDK_INSTR_DATA_LENGTH_WITH_PROOF_ACCOUNT`
(`flamenco/runtime/program/fd_zk_elgamal_proof_program.h:27`). -/
def FD_ZKSDK_INSTR_DATA_LENGTH_WITH_PROOF_ACCOUNT : BitVec 64 := 5#64

/-- `fd_zksdk_context_sz` (`ballet/zksdk/fd_zksdk.h:34`), the `sizeof`s of the packed context
structs (checked against `gcc`). -/
def fd_zksdk_context_sz : List (BitVec 64) :=
  [0, 96, 192, 128, 32, 104, 264, 264, 264, 160, 256, 224, 352]

/-- `fd_zksdk_proof_sz` (`ballet/zksdk/fd_zksdk.h:51`), the `sizeof`s of the packed proof structs
(checked against `gcc`). -/
def fd_zksdk_proof_sz : List (BitVec 64) :=
  [0, 96, 224, 192, 64, 256, 672, 736, 800, 160, 160, 192, 192]

namespace fd_zksdk_process_verify_proof

/-- Where `fd_zksdk_process_verify_proof` goes after the modelled part. -/
inductive Result where
  /-- Returns `code`. -/
  | err (code : BitVec 32)
  /-- `instr_data_sz == 5`: the proof is read from account 0 (not modelled). -/
  | proofAccount
  /-- A range-proof verifier (out of scope) is called on these context and proof bytes. -/
  | rangeProof (instr_id : BitVec 8) (context proof : List (BitVec 8))
  /-- The verifier returned 0; the context-state account code follows (not modelled). -/
  | verified

/-- The `switch( instr_id )` (`fd_zk_elgamal_proof_program.c:29`): `none` for `default`,
`some none` for a range proof, `some (some f)` for the sigma verifier `f`. -/
def dispatch (instr_id : BitVec 8) :
    Option (Option (List (BitVec 8) → List (BitVec 8) → BitVec 32)) :=
  match instr_id.toNat with
  | 1 => some (some fd_zksdk_instr_verify_proof_zero_ciphertext)
  | 2 => some (some fd_zksdk_instr_verify_proof_ciphertext_ciphertext_equality)
  | 3 => some (some fd_zksdk_instr_verify_proof_ciphertext_commitment_equality)
  | 4 => some (some fd_zksdk_instr_verify_proof_pubkey_validity)
  | 5 => some (some fd_zksdk_instr_verify_proof_percentage_with_cap)
  | 6 | 7 | 8 => some none
  | 9 => some (some fd_zksdk_instr_verify_proof_grouped_ciphertext_2_handles_validity)
  | 10 => some (some fd_zksdk_instr_verify_proof_batched_grouped_ciphertext_2_handles_validity)
  | 11 => some (some fd_zksdk_instr_verify_proof_grouped_ciphertext_3_handles_validity)
  | 12 => some (some fd_zksdk_instr_verify_proof_batched_grouped_ciphertext_3_handles_validity)
  | _ => none

end fd_zksdk_process_verify_proof

open fd_zksdk_process_verify_proof in
/-- `fd_zksdk_process_verify_proof` (`flamenco/runtime/program/fd_zk_elgamal_proof_program.c:13`) on
`instr_data` (non-empty, checked by the caller), logs omitted. -/
def fd_zksdk_process_verify_proof (instr_data : List (BitVec 8)) : Result :=
  let instr_id := instr_data.getD 0 0#8
  match dispatch instr_id with
  | none => .err FD_EXECUTOR_INSTR_ERR_INVALID_INSTR_DATA
  | some fd_zksdk_instr_verify_proof =>
    let context_sz := fd_zksdk_context_sz.getD instr_id.toNat 0
    let proof_data_sz := context_sz + fd_zksdk_proof_sz.getD instr_id.toNat 0
    if instr_data.length = FD_ZKSDK_INSTR_DATA_LENGTH_WITH_PROOF_ACCOUNT.toNat then .proofAccount
    else if instr_data.length ≠ (1#64 + proof_data_sz).toNat then
      -- fd_log_collector_msg_literal( ctx, "invalid proof data" )
      .err FD_EXECUTOR_INSTR_ERR_INVALID_INSTR_DATA
    else
      let context := instr_data.drop 1
      let proof := context.drop context_sz.toNat
      match fd_zksdk_instr_verify_proof with
      | none => .rangeProof instr_id context proof
      | some f =>
        let err := f context proof
        if err ≠ 0#32 then
          -- fd_log_collector_msg_literal( ctx, "proof verification failed" )
          .err FD_EXECUTOR_INSTR_ERR_INVALID_INSTR_DATA
        else .verified

end

end MLIR.Firedancer.Ref
