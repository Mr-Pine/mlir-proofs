module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.Avx512.Mlir.wv_ld

namespace MLIR.Firedancer.Avx512

/-! ## Proof -/

section Proof

/-- `wv_ld` returns the four lanes at `p` and leaves the state as it is. -/
public theorem wv_ld.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hp : Fits s.mem p 256) :
    wv_ld.call (wv_ld.args (.value p)) s =
      .value (.cons (Ty.wrap (s.mem.readWv p)) .nil, s) := by
  func_init
  block_init
  step_load
  finish_block
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.Avx512
