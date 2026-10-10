module

public import MLIR.Run.Tactic
public import Boringssl.Mlir.FIPS_service_indicator_update_state

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

/-- `FIPS_service_indicator_update_state` (not a FIPS build) does nothing. -/
public theorem FIPS_service_indicator_update_state.call_eq (s : GlobalState) (hwf : s.WF) :
    FIPS_service_indicator_update_state.call FIPS_service_indicator_update_state.args s =
      .value (.nil, s) := by
  func_init
  block_init
  finish_block
  rw [hS]

end Proof

end MLIR.Boringssl
