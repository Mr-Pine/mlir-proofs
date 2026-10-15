module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.Avx512.fd_ed25519_point_neg
public import Firedancer.LaneNI.fd_ed25519_point_neg
public import Firedancer.Avx512.fd_ed25519_point_neg_precomputed
public import Firedancer.LaneNI.fd_ed25519_point_neg_precomputed
public import Firedancer.Avx512.fd_ed25519_point_add_with_opts
public import Firedancer.LaneNI.fd_ed25519_point_add_with_opts
public import Firedancer.LaneNI.Mlir.fd_ed25519_point_sub_with_opts
public import Firedancer.Avx512.fd_ed25519_point_sub_with_opts

namespace MLIR.Firedancer.LaneNI

open Firedancer.Avx512

/-! ## Proof -/

/-- `fd_ed25519_point_sub_with_opts` stores `spec` of the points at `a` and `b` at `r` and returns
`r`; `r` may be `a` or `b`. -/
public theorem _root_.Firedancer.LaneNI.Mlir.fd_ed25519_point_sub_with_opts.call_eq
    (r a b : Pointer) (pre : BitVec 32)
    (s : GlobalState) (hwf : s.WF) (hr : s.mem.QuadRoom r) (ha : s.mem.QuadFit a)
    (hb : s.mem.QuadFit b) :
    Firedancer.LaneNI.Mlir.fd_ed25519_point_sub_with_opts.call
        (Firedancer.LaneNI.Mlir.fd_ed25519_point_sub_with_opts.args (.value r) (.value a)
            (.value b) (.value pre)) s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 16⟩,
            mem :=
              s.mem.storeQuad r
                (fd_ed25519_point_sub_with_opts.spec (s.mem.readQuad a) (s.mem.readQuad b)
                  pre) }) := by
  func_init
  block_init
  iterate 2 step_pure
  step_alloca with t
  step_pure
  step_pure
  have htq : S.mem.QuadRoom t := MemoryState.QuadRoom.of_room hroom_t ht_off
  have htb : t.id ≠ b.id := Ne.symm hb_ne_t
  have htb' : t = b ∨ t.id ≠ b.id := .inr htb
  finish_block
  all_goals
    block_init
    first
    | step_call using Firedancer.LaneNI.Mlir.fd_ed25519_point_neg.call_eq
    | step_call using Firedancer.LaneNI.Mlir.fd_ed25519_point_neg_precomputed.call_eq
    finish_block
    block_init
    step_call using Firedancer.LaneNI.Mlir.fd_ed25519_point_add_with_opts.call_eq
    step_pure
    finish_block
    subst hS
    erase_frame
    simp [fd_ed25519_point_sub_with_opts.spec, fd_ed25519_point_add_with_opts.spec, hbr]

end MLIR.Firedancer.LaneNI
