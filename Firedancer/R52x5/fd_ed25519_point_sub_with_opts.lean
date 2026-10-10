module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.fd_ed25519_point_neg
public import Firedancer.R52x5.fd_ed25519_point_neg_precomputed
public import Firedancer.R52x5.fd_ed25519_point_add_with_opts
public import Firedancer.R52x5.Mlir.fd_ed25519_point_sub_with_opts
import Firedancer.Common.Tactics

namespace MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `A - B`: `B` negated as a precomputed point when `b_is_precomputed`, else as a point, then
added with the same option. -/
def fd_ed25519_point_sub_with_opts.spec (A B : Quad5) (b_is_precomputed : BitVec 32) : Quad5 :=
  let neg :=
    if b_is_precomputed = 0 then fd_ed25519_point_neg.spec B
    else fd_ed25519_point_neg_precomputed.spec B
  fd_ed25519_point_add_with_opts.spec A neg b_is_precomputed

end

/-! ## Proof -/

/-- `fd_ed25519_point_sub_with_opts` stores `spec` of the points at `a` and `b` at `r` and returns
`r`; `r` may be `a` or `b`. -/
public theorem fd_ed25519_point_sub_with_opts.call_eq (r a b : Pointer) (pre : BitVec 32)
    (s : GlobalState) (hwf : s.WF) (hr : s.mem.Quad5Room r) (ha : s.mem.Quad5Fit a)
    (hb : s.mem.Quad5Fit b) :
    fd_ed25519_point_sub_with_opts.call
        (fd_ed25519_point_sub_with_opts.args (.value r) (.value a) (.value b) (.value pre)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 51⟩,
            mem :=
              s.mem.storeQuad5 r
                (fd_ed25519_point_sub_with_opts.spec (s.mem.readQuad5 a) (s.mem.readQuad5 b)
                  pre) }) := by
  func_init
  block_init
  iterate 2 step_pure
  -- fd_ed25519_point_t neg[1]
  step_alloca with neg
  step_pure
  step_pure
  have hneg : S.mem.Quad5Room neg :=
    MemoryState.Quad5Room.of_room (Room.mono (by decide) hroom_neg) hneg_off
  have hnegb : neg = b ∨ neg.id ≠ b.id := .inr (Ne.symm hb_ne_neg)
  finish_block
  · -- `!b_is_precomputed`: fd_ed25519_point_neg( neg, b )
    block_init
    step_call using fd_ed25519_point_neg.call_eq
    finish_block
    block_init
    step_call using fd_ed25519_point_add_with_opts.call_eq
    step_pure
    finish_block
    clear_reads
    subst hS hbr
    erase_frame
    simp only [fd_ed25519_point_sub_with_opts.spec, fd_ed25519_point_add_with_opts.spec]
    rfl
  · -- `b_is_precomputed`: fd_ed25519_point_neg_precomputed( neg, b )
    block_init
    step_call using fd_ed25519_point_neg_precomputed.call_eq
    finish_block
    block_init
    step_call using fd_ed25519_point_add_with_opts.call_eq
    step_pure
    finish_block
    clear_reads
    subst hS
    erase_frame
    have hpre : pre ≠ 0 := hbr
    simp only [fd_ed25519_point_sub_with_opts.spec, fd_ed25519_point_add_with_opts.spec, hpre,
      show (1#32 : BitVec 32) ≠ 0 by decide, ↓reduceIte]
    rfl

end MLIR.Firedancer.R52x5
