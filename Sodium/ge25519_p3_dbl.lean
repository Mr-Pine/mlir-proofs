module

public import MLIR.Run.Tactic
public import Boringssl.Common.Point
public import Boringssl.ge_p3_to_p2
public import Sodium.ge25519_p3_to_p2
public import Sodium.ge25519_p2_dbl
public import Sodium.Mlir.ge25519_p3_dbl

namespace MLIR.Sodium

/-! ## Specification -/

@[expose] public section

/-- `2 P` as a `ge25519_p1p1`: `ge25519_p2_dbl` of `P` as a `ge25519_p2`. -/
def ge25519_p3_dbl.spec (P : GeP3) : GeP1p1 :=
  ge25519_p2_dbl.spec (Boringssl.ge_p3_to_p2.spec P)

end

/-! ## Proof -/

section Proof

/-- `ge25519_p3_dbl` stores `spec` of the `ge25519_p3` at `p` at `r`; `p` is read first, so `r` may
alias it. Its temporary `ge25519_p2` and `ge25519_p2_dbl`'s are freed again: only the counter moves
on, by two blocks. -/
public theorem ge25519_p3_dbl.call_eq (r p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.PointRoom r) (hp : s.mem.PointFit p) :
    ge25519_p3_dbl.call (ge25519_p3_dbl.args (.value r) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩,
            mem := s.mem.storeP1p1 r (ge25519_p3_dbl.spec (s.mem.readP3 p)) }) := by
  func_init
  have hp₀ : S₀.mem.PointFit p := hS ▸ hp
  block_init
  step_pure
  -- ge25519_p2 q;
  step_alloca with q
  step_pure
  have hq_fe3 := MemoryState.Fe3Room.of_room hroom_q hq_off
  clear hroom_q hq_bounds
  -- ge25519_p3_to_p2(&q, p); ge25519_p2_dbl(r, &q);
  step_call using ge25519_p3_to_p2.call_eq
  step_call using ge25519_p2_dbl.call_eq
  step_pure
  finish_block
  rw [hS]
  erase_frame
  rfl

end Proof

end MLIR.Sodium
