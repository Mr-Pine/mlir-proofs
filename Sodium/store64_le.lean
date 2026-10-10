module

public import MLIR.Run.Tactic
public import Sodium.Mlir.store64_le

namespace MLIR.Sodium

/-! ## Proof -/

section Proof

/-- `store64_le` stores `w` little-endian at `dst`: memory's own 64-bit store. -/
public theorem store64_le.call_eq (dst : Pointer) (w : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (hdst : Room s.mem dst 64) :
    store64_le.call (store64_le.args (.value dst) (.value w)) s =
      .value (.nil, { s with mem := s.mem.storeAt dst w }) := by
  func_init
  block_init
  step_store
  finish_block
  rw [hS]

end Proof

end MLIR.Sodium
