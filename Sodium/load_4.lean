module

public import MLIR.Run.Tactic
public import Sodium.Mlir.load_4

namespace MLIR.Sodium

/-! ## Proof -/

section Proof

/-- `load_4` returns the 4 bytes at `p` as a little-endian number and leaves the state alone. -/
public theorem load_4.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF) (hp : Fits s.mem p 32) :
    load_4.call (load_4.args (.value p)) s =
      .value (.cons (.value ((s.mem.readAt p 32).setWidth 64)) .nil, s) := by
  func_init
  block_init
  step_load
  step_pure
  finish_block
  rw [hS, hv0]

end Proof

end MLIR.Sodium
