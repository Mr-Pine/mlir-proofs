module

public import MLIR.Run.Tactic
public import Agave.Serial.Mlir.black_box_u8

namespace MLIR.Agave.Serial

/-! ## Proof -/

section Proof

/-- `subtle::black_box(x)` returns `x`, through a volatile read of a one-byte slot it frees again:
only the counter moves on, by one block. -/
public theorem black_box_u8.call_eq (x : BitVec 8) (s : GlobalState) (hwf : s.WF) :
    black_box_u8.call (black_box_u8.args (.value x)) s =
      .value (.cons (.value x) .nil, { alloc := ⟨s.alloc.nextFreeBlock + 1⟩, mem := s.mem }) := by
  func_init
  block_init
  step_pure
  step_alloca
  step_store
  step_load
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Agave.Serial
