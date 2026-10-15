module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.fd_ed25519_point_sub_with_opts
public import Firedancer.Lane.fd_ed25519_point_add_with_opts
public import Firedancer.Lane.Common.PointUtil
public import Firedancer.Lane.Mlir.fd_ed25519_point_sub
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn

namespace fd_ed25519_point_sub

/-- `LANE_SUB_FAST( neg, b, 1,0,0,1, _p, b )` as compiled: `2p - b` in `X` and `T`. -/
def negSub (A : Quad) : Quad :=
  ⟨#v[17592186044378#64 - A.P03[0], A.P03[1], A.P03[2], 17592186044378#64 - A.P03[3],
      17592186044414#64 - A.P03[4], A.P03[5], A.P03[6], 17592186044414#64 - A.P03[7]],
    #v[17592186044414#64 - A.P14[0], A.P14[1], A.P14[2], 17592186044414#64 - A.P14[3],
      17592186044414#64 - A.P14[4], A.P14[5], A.P14[6], 17592186044414#64 - A.P14[7]],
    #v[17592186044414#64 - A.P25[0], A.P25[1], A.P25[2], 17592186044414#64 - A.P25[3],
      2199023255550#64 - A.P25[4], A.P25[5], A.P25[6], 2199023255550#64 - A.P25[7]]⟩

theorem p_add_p_sub (c x : BitVec 64) : c + (c - x) = (c + c) - x := by bv_decide

theorem laneSubFast_neg (A : Quad) : A.laneSubFast 1 0 0 1 quadP A = negSub A := by
  rcases A with ⟨a, b, c⟩
  simp only [Quad.laneSubFast, Quad.laneAddFast, negSub, quadP, Quad.mk.injEq]
  refine ⟨?_, ?_, ?_⟩ <;> ext i hi : 1 <;> obtain _ | _ | _ | _ | _ | _ | _ | _ | i := i
  all_goals
    first
    | omega
    | wwl_lanes
      first
      | done
      | simp only [p_add_p_sub, BitVec.reduceAdd]

theorem neg_spec_eq (A : Quad) :
    fd_ed25519_point_neg.spec A = (negSub A).foldUnsignedC := by
  rw [fd_ed25519_point_neg.spec, laneSubFast_neg, Quad.foldUnsigned_eq]

end fd_ed25519_point_sub

open fd_ed25519_point_sub in
/-- `fd_ed25519_point_sub` stores `A - B` of the points at `a` and `b` at `r` and returns `r`; `r`
may be `a` or `b`. -/
public theorem fd_ed25519_point_sub.call_eq (r a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.QuadRoom r) (ha : s.mem.QuadFit a) (hb : s.mem.QuadFit b) :
    _root_.Firedancer.Lane.Mlir.fd_ed25519_point_sub.call
        (_root_.Firedancer.Lane.Mlir.fd_ed25519_point_sub.args (.value r) (.value a) (.value b))
        s =
      .value
        (.cons (.value r) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem :=
              s.mem.storeQuad r
                (fd_ed25519_point_sub_with_opts.spec (s.mem.readQuad a) (s.mem.readQuad b)
                  0) }) := by
  func_init
  block_init
  iterate 18 step_pure
  iterate 4 step_pattern using runBodyFrom_insertRun
  -- fd_ed25519_point_t neg[1]; fd_ed25519_point_neg( neg, b ) inlined
  step_alloca with t
  step_pure
  have htq : S.mem.QuadRoom t := MemoryState.QuadRoom.of_room hroom_t ht_off
  step_load with transparent b03
  step_pure
  step_load with transparent b14
  step_pure
  step_load with transparent b25
  step_pure
  -- FD_R43X6_QUAD_LANE_SUB_FAST( neg->P, b->P, 1,0,0,1, _p, b->P )
  step_pure [expandOfFn] with transparent d03
  step_pure with n03
  step_pure [expandOfFn] with transparent d14
  step_pure with n14
  step_pure [expandOfFn] with transparent d25
  step_pure with n25
  -- FD_R43X6_QUAD_FOLD_UNSIGNED( neg->P, neg->P )
  step_pattern using runBodyFrom_foldUnsignedStoreRunG2 inline
  -- fd_ed25519_point_add_with_opts( r, a, neg, 0, 0, 0 )
  step_call using fd_ed25519_point_add_with_opts.call_eq
  step_pure
  finish_block
  subst hS
  erase_frame
  have e : negSub (S₀.mem.readQuad b) = ⟨n03, n14, n25⟩ := by
    rw [hn03, hn14, hn25]
    rfl
  simp only [GlobalState.alloca, fd_ed25519_point_sub_with_opts.spec, ne_eq, not_true_eq_false,
    ↓reduceIte, neg_spec_eq, e, _hu]
  rfl

end Proof

end MLIR.Firedancer.Lane
