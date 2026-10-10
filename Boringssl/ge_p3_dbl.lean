module

public import MLIR.Run.Tactic
public import Boringssl.Common.Point
public import Boringssl.ge_p3_to_p2
public import Boringssl.ge_p2_dbl
public import Boringssl.Mlir.ge_p3_dbl

namespace MLIR.Boringssl

/-! ## Specification -/

@[expose] public section

/-- `2 P` as a `ge_p1p1`: `ge_p2_dbl` of `P` as a `ge_p2`. -/
def ge_p3_dbl.spec (P : GeP3) : GeP1p1 :=
  ge_p2_dbl.spec (ge_p3_to_p2.spec P)

end

/-! ## Proof -/

section Proof

/-- `ge_p3_dbl` stores `spec` of the `ge_p3` at `p` at `r`; `p` is read first, so `r` may alias it.
The temporary `ge_p2` and `ge_p2_dbl`'s blocks count six. -/
public theorem ge_p3_dbl.call_eq (r p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.PointRoom r) (hp : s.mem.PointFit p) :
    ge_p3_dbl.call (ge_p3_dbl.args (.value r) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 6⟩,
            mem := s.mem.storeP1p1 r (ge_p3_dbl.spec (s.mem.readP3 p)) }) := by
  func_init
  have hp₀ : S₀.mem.PointFit p := hS ▸ hp
  block_init
  step_pure
  -- ge_p2 q;
  step_alloca with q
  step_pure
  have hq_fe3 := MemoryState.Fe3Room.of_room hroom_q hq_off
  clear hroom_q hq_bounds
  -- ge_p3_to_p2(&q, p); ge_p2_dbl(r, &q);
  step_call using ge_p3_to_p2.call_eq
  step_call using ge_p2_dbl.call_eq
  step_pure
  finish_block
  rw [hS]
  erase_frame
  rfl

end Proof

end MLIR.Boringssl
