module

public import MLIR.Run.Tactic
public import Sodium.Mlir.sodium_memzero

namespace MLIR.Sodium

/-! ## Proof -/

section Proof

/-- `sodium_memzero(pnt, len)` stores `len` zero bytes at `pnt`. -/
public theorem sodium_memzero.call_eq (pnt : Pointer) (len : BitVec 64) (s : GlobalState)
    (hwf : s.WF) (hpnt : Room s.mem pnt (8 * len.toNat)) :
    sodium_memzero.call (sodium_memzero.args (.value pnt) (.value len)) s =
      .value (.nil, { s with mem := s.mem.storeAt pnt (0 : BitVec (8 * len.toNat)) }) := by
  func_init
  block_init
  step_pure
  step_call using (Operation.explicitBzeroChk_eq (hsize := .inl rfl))
  finish_block
  rw [hS]

end Proof

end MLIR.Sodium
