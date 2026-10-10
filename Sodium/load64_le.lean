module

public import MLIR.Run.Tactic
public import Sodium.Mlir.load64_le

namespace MLIR.Sodium

/-! ## Proof -/

section Proof

/-- `load64_le` returns the little-endian word at `src`: memory's own 64-bit read. -/
public theorem load64_le.call_eq (src : Pointer) (s : GlobalState) (hwf : s.WF)
    (hsrc : Fits s.mem src 64) :
    load64_le.call (load64_le.args (.value src)) s =
      .value (.cons (.value (s.mem.readAt src 64)) .nil, s) := by
  func_init
  block_init
  step_load
  finish_block
  rw [hS, hv0]

end Proof

end MLIR.Sodium
