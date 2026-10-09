module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Mlir.fd_ulong_load_8

namespace MLIR.Firedancer.R52x5

/-! ## Proof -/

section Proof

/-- With room at `ptr`, the function returns the 64 bits stored there and leaves the state alone. -/
public theorem fd_ulong_load_8.call_eq (ptr : Pointer) (s : GlobalState) (hwf : s.WF)
    (hfits : Fits s.mem ptr 64) :
    fd_ulong_load_8.call (fd_ulong_load_8.args (.value ptr)) s =
      .value (.cons (.value (s.mem.readAt ptr 64)) .nil, s) := by
  func_init
  block_init
  step_load
  finish_block
  rw [hv0, hS]

end Proof

end MLIR.Firedancer.R52x5
