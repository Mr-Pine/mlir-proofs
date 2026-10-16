module

public import Firedancer.Ref.fd_zksdk_process_verify_proof
import Mathlib.Tactic.IntervalCases
import Mathlib.Data.List.GetD

/-! The instruction-data part of `fd_zksdk_process_verify_proof`: it reaches the context-state code
exactly when the instruction id selects a sigma verifier, the data has the size that verifier needs
(and is not the 5-byte account form), and the verifier returns 0 on the sliced context and proof. -/

namespace MLIR.Firedancer.Ref

open fd_zksdk_process_verify_proof

/-- The size tables' entries are small. -/
theorem sz_le (i : ℕ) :
    (fd_zksdk_context_sz.getD i 0).toNat ≤ 352 ∧ (fd_zksdk_proof_sz.getD i 0).toNat ≤ 800 := by
  by_cases h : i < 13
  · interval_cases i <;> decide
  · rw [List.getD_eq_default _ _
        (by
          simp [fd_zksdk_context_sz]; omega),
      List.getD_eq_default _ _
        (by
          simp [fd_zksdk_proof_sz]; omega)]
    decide

/-- `fd_zksdk_process_verify_proof` returns `verified` exactly when the id selects a sigma verifier
`f`, the data is `1 + context + proof` bytes for that id (and not 5), and `f` returns 0 on the
context bytes and the proof bytes after them. -/
public theorem fd_zksdk_process_verify_proof.eq_verified_iff (instr_data : List (BitVec 8)) :
    fd_zksdk_process_verify_proof instr_data = .verified ↔
      let id := instr_data.getD 0 0#8
      let context_sz := (fd_zksdk_context_sz.getD id.toNat 0).toNat
      let proof_sz := (fd_zksdk_proof_sz.getD id.toNat 0).toNat
      ∃ f,
        dispatch id = some (some f) ∧
          instr_data.length ≠ 5 ∧
          instr_data.length = 1 + context_sz + proof_sz ∧
          f (instr_data.drop 1) ((instr_data.drop 1).drop context_sz) = 0#32 := by
  have hsz := sz_le (instr_data.getD 0 0#8).toNat
  have e :
    (1#64 +
          (fd_zksdk_context_sz.getD (instr_data.getD 0 0#8).toNat 0 +
            fd_zksdk_proof_sz.getD (instr_data.getD 0 0#8).toNat 0)).toNat =
      1 + (fd_zksdk_context_sz.getD (instr_data.getD 0 0#8).toNat 0).toNat +
        (fd_zksdk_proof_sz.getD (instr_data.getD 0 0#8).toNat 0).toNat := by
    simp only [BitVec.toNat_add, BitVec.toNat_ofNat]
    omega
  unfold fd_zksdk_process_verify_proof
  simp only [FD_ZKSDK_INSTR_DATA_LENGTH_WITH_PROOF_ACCOUNT, e]
  rcases hd : dispatch (instr_data.getD 0 0#8) with _ | _ | f
  · simp
  · simp only []
    split_ifs <;> simp
  · simp only []
    split_ifs with h1 h2 h3 <;> simp_all

end MLIR.Firedancer.Ref
