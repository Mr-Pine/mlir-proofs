module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.Point
public import Firedancer.Avx512.Mlir.fd_ed25519_point_neg_precomputed
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `-A` of a precomputed point `(Y-X, Y+X, 2Z, 2dT)`: `T` replaced by `p + (p - T)`, then `Y-X` and
`Y+X` swapped. -/
def fd_ed25519_point_neg_precomputed.spec (A : Quad) : Quad :=
  (A.laneSubFast 0 0 0 1 quadP A).permute 1 0 2 3

end

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn

/-- `PERMUTE( r, 1,0,2,3, r )` on one vector: lanes `0, 1` and `4, 5` swapped. -/
def swapXY (n : Wwl) : Wwl :=
  #v[n[1], n[0], n[2], n[3], n[5], n[4], n[6], n[7]]

/-- `LANE_SUB_FAST( r, a, 0,0,0,1, _p, a )` then `PERMUTE( r, 1,0,2,3, r )` as compiled. -/
def negPrecomputedC (A : Quad) : Quad :=
  ⟨swapXY #v[A.P03[0], A.P03[1], A.P03[2], 17592186044378#64 - A.P03[3], A.P03[4], A.P03[5],
      A.P03[6], 17592186044414#64 - A.P03[7]],
    swapXY #v[A.P14[0], A.P14[1], A.P14[2], 17592186044414#64 - A.P14[3], A.P14[4], A.P14[5],
      A.P14[6], 17592186044414#64 - A.P14[7]],
    swapXY #v[A.P25[0], A.P25[1], A.P25[2], 17592186044414#64 - A.P25[3], A.P25[4], A.P25[5],
      A.P25[6], 2199023255550#64 - A.P25[7]]⟩

theorem p_add_p_sub' (c x : BitVec 64) : c + (c - x) = (c + c) - x := by
  bv_decide

theorem fd_ed25519_point_neg_precomputed.spec_eq (A : Quad) :
    fd_ed25519_point_neg_precomputed.spec A = negPrecomputedC A := by
  rcases A with ⟨a, b, c⟩
  simp only [fd_ed25519_point_neg_precomputed.spec, Quad.permute, Quad.laneSubFast,
    Quad.laneAddFast, negPrecomputedC, swapXY, quadP, Quad.mk.injEq]
  refine ⟨?_, ?_, ?_⟩ <;> ext i hi : 1 <;> obtain _|_|_|_|_|_|_|_|i := i
  all_goals
    first
    | omega
    | wwl_lanes
      first
      | done
      | simp only [p_add_p_sub', BitVec.reduceAdd]

/-- `fd_ed25519_point_neg_precomputed` stores `spec` of the point at `a` at `r`, in another block,
and returns `r`. -/
public theorem fd_ed25519_point_neg_precomputed.call_eq (r a : Pointer) (s : GlobalState)
    (hwf : s.WF) (hr : s.mem.QuadFit r) (ha : s.mem.QuadFit a) (hsep : r.id ≠ a.id) :
    fd_ed25519_point_neg_precomputed.call
        (fd_ed25519_point_neg_precomputed.args (.value r) (.value a)) s =
      .value (.cons (.value r) .nil,
        { s with
          mem :=
            s.mem.storeQuad r (fd_ed25519_point_neg_precomputed.spec (s.mem.readQuad a)) }) := by
  func_init
  block_init
  iterate 40 step_pure
  step_load with transparent a03
  step_pure
  step_load with transparent a14
  step_pure
  step_load with transparent a25
  -- FD_R43X6_QUAD_LANE_SUB_FAST( r->P, a->P, 0,0,0,1, _p, a->P )
  step_pure [expandOfFn]
  step_pure with n03
  step_store
  step_load
  step_pure [expandOfFn]
  step_pure with n14
  step_pure
  step_store
  step_load
  step_pure [expandOfFn]
  step_pure with n25
  step_pure
  -- FD_R43X6_QUAD_PERMUTE( r->P, 1,0,2,3, r->P )
  step_pure with f03
  step_store
  step_pure with f14
  step_store
  step_pure with f25
  step_store
  finish_block
  rw [hS, MemoryState.storeAt_03_14_twice hr.1, fd_ed25519_point_neg_precomputed.spec_eq]
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.Avx512
