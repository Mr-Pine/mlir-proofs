module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Vec
public import Firedancer.R52x5.Mlir.wwl_st

namespace MLIR.Firedancer.R52x5

open Firedancer.Avx512 (Wwl)

/-! ## Proof -/

section Proof

/-- `wwl_st( p, x )` stores the eight lanes of `x` at `p`. -/
public theorem wwl_st.call_eq (p : Pointer) (x : Wwl) (s : GlobalState) (hwf : s.WF)
    (hp : Fits s.mem p 512) :
    wwl_st.call (wwl_st.args (.value p) (Ty.wrap x)) s =
      .value (.nil, { s with mem := s.mem.storeVec p x }) := by
  func_init
  block_init
  step_store
  finish_block
  rw [hS]
  rfl

end Proof

end MLIR.Firedancer.R52x5
