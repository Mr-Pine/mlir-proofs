module

public import MLIR.Run.Tactic
public import Sodium.Mlir._sodium_dummy_symbol_to_prevent_memcmp_lto

namespace MLIR.Sodium

/-! ## Proof -/

section Proof

/-- `_sodium_dummy_symbol_to_prevent_memcmp_lto` does nothing. -/
public theorem _sodium_dummy_symbol_to_prevent_memcmp_lto.call_eq (b1 b2 : Pointer)
    (len : BitVec 64) (s : GlobalState) (hwf : s.WF) :
    _sodium_dummy_symbol_to_prevent_memcmp_lto.call
        (_sodium_dummy_symbol_to_prevent_memcmp_lto.args (.value b1) (.value b2) (.value len)) s =
      .value (.nil, s) := by
  func_init
  block_init
  finish_block
  rw [hS]

end Proof

end MLIR.Sodium
