module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.Avx512.Mlir.fd_ed25519_point_neg
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `-A`: `X` and `T` replaced by `p + (p - X)` and `p + (p - T)`, then folded. -/
def fd_ed25519_point_neg.spec (A : Quad) : Quad :=
  (A.laneSubFast 1 0 0 1 quadP A).foldUnsigned

end

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn

/-- `LANE_SUB_FAST( r, a, 1,0,0,1, _p, a )` as compiled: `2p - a` in `X` and `T`. -/
def negSub (A : Quad) : Quad :=
  ⟨#v[17592186044378#64 - A.P03[0], A.P03[1], A.P03[2], 17592186044378#64 - A.P03[3],
      17592186044414#64 - A.P03[4], A.P03[5], A.P03[6], 17592186044414#64 - A.P03[7]],
    #v[17592186044414#64 - A.P14[0], A.P14[1], A.P14[2], 17592186044414#64 - A.P14[3],
      17592186044414#64 - A.P14[4], A.P14[5], A.P14[6], 17592186044414#64 - A.P14[7]],
    #v[17592186044414#64 - A.P25[0], A.P25[1], A.P25[2], 17592186044414#64 - A.P25[3],
      2199023255550#64 - A.P25[4], A.P25[5], A.P25[6], 2199023255550#64 - A.P25[7]]⟩

theorem p_add_p_sub (c x : BitVec 64) : c + (c - x) = (c + c) - x := by
  bv_decide

theorem laneSubFast_neg (A : Quad) : A.laneSubFast 1 0 0 1 quadP A = negSub A := by
  rcases A with ⟨a, b, c⟩
  simp only [Quad.laneSubFast, Quad.laneAddFast, negSub, quadP, Quad.mk.injEq]
  refine ⟨?_, ?_, ?_⟩ <;> ext i hi : 1 <;> obtain _|_|_|_|_|_|_|_|i := i
  all_goals
    first
    | omega
    | wwl_lanes
      first
      | done
      | simp only [p_add_p_sub, BitVec.reduceAdd]

theorem fd_ed25519_point_neg.spec_eq (A : Quad) :
    fd_ed25519_point_neg.spec A = (negSub A).foldUnsignedC := by
  rw [fd_ed25519_point_neg.spec, laneSubFast_neg, Quad.foldUnsigned_eq]

/-- `fd_ed25519_point_neg` stores `spec` of the point at `a` at `r`, which is `a` itself or in
another block, and returns `r`. -/
public theorem fd_ed25519_point_neg.call_eq (r a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hr : s.mem.QuadFit r) (ha : s.mem.QuadFit a) (hsep : r = a ∨ r.id ≠ a.id) :
    fd_ed25519_point_neg.call (fd_ed25519_point_neg.args (.value r) (.value a)) s =
      .value (.cons (.value r) .nil,
        { s with mem := s.mem.storeQuad r (fd_ed25519_point_neg.spec (s.mem.readQuad a)) }) := by
  rcases hsep with rfl | hsep
  all_goals
    func_init
    block_init
    iterate 53 step_pure
    step_load with transparent a03
    step_pure
    step_load with transparent a14
    step_pure
    step_load with transparent a25
    -- FD_R43X6_QUAD_LANE_SUB_FAST( r->P, a->P, 1,0,0,1, _p, a->P )
    step_pure [expandOfFn] with transparent d03
    step_pure with n03
    step_store
    step_load with transparent b14
    step_pure [expandOfFn] with transparent d14
    step_pure with n14
    step_pure
    step_store
    step_load with transparent b25
    step_pure [expandOfFn] with transparent d25
    step_pure with n25
    step_pure
    -- FD_R43X6_QUAD_FOLD_UNSIGNED( r->P, r->P )
    step_pattern using runBodyFrom_foldUnsignedStoreRun'
    finish_block
    rw [hS, MemoryState.storeAt_03_14_twice hr.1, fd_ed25519_point_neg.spec_eq]
  · have e : negSub (S₀.mem.readQuad r) = ⟨n03, n14, n25⟩ := by rw [hn03, hn14, hn25]; rfl
    rw [e, _hu]
    rfl
  · have e : negSub (S₀.mem.readQuad a) = ⟨n03, n14, n25⟩ := by rw [hn03, hn14, hn25]; rfl
    rw [e, _hu]
    rfl

end Proof

end MLIR.Firedancer.Avx512
