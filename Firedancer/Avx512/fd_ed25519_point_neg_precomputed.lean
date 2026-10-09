module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.QuadOps
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

/-- Setting all eight lanes forgets the base vector. -/
theorem set_eight {α : Type} (w : Vector α 8) (x0 x1 x2 x3 x4 x5 x6 x7 : α) :
    (((((((w.set 0 x0).set 1 x1).set 2 x2).set 3 x3).set 4 x4).set 5 x5).set 6 x6).set 7 x7 =
      #v[x0, x1, x2, x3, x4, x5, x6, x7] := by
  ext i hi
  obtain _|_|_|_|_|_|_|_|i := i <;> simp <;> omega

/-- A vector constant built on the undef `u`: lanes `x0 … x7` inserted at `k0 … k7` through
`v0 … v7`. -/
def insertRun (u : Reg Γ (.vec 8 64)) (v0 v1 v2 v3 v4 v5 v6 v7 : Dst Γ (.vec 8 64))
    (x0 x1 x2 x3 x4 x5 x6 x7 : Reg Γ (.bv 64)) (k0 k1 k2 k3 k4 k5 k6 k7 : Reg Γ (.bv 32)) :
    List (Instr Γ) :=
  [.ternop .insertelement v0 u x0 k0,
    .ternop .insertelement v1 (.val v0.i v0.h) x1 k1,
    .ternop .insertelement v2 (.val v1.i v1.h) x2 k2,
    .ternop .insertelement v3 (.val v2.i v2.h) x3 k3,
    .ternop .insertelement v4 (.val v3.i v3.h) x4 k4,
    .ternop .insertelement v5 (.val v4.i v4.h) x5 k5,
    .ternop .insertelement v6 (.val v5.i v5.h) x6 k6,
    .ternop .insertelement v7 (.val v6.i v6.h) x7 k7]

/-- Where the body at `pos` is `insertRun`, `kj` holds `j` and `xj` the lane `Xj`: running on from
`pos` then `g` gives `K` if it does from `pos + 8` with `#v[X0, …, X7]` in `v7`. -/
theorem runBodyFrom_insertRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {u : Reg Γ (.vec 8 64)} {v0 v1 v2 v3 v4 v5 v6 v7 : Dst Γ (.vec 8 64)}
    {x0 x1 x2 x3 x4 x5 x6 x7 : Reg Γ (.bv 64)} {k0 k1 k2 k3 k4 k5 k6 k7 : Reg Γ (.bv 32)}
    {rest : List (Instr Γ)} {X0 X1 X2 X3 X4 X5 X6 X7 : ⟦.bv 64⟧} {S : GlobalState}
    {g : ⟪Γ⟫ × GlobalState → PoisonOr β} {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        insertRun u v0 v1 v2 v3 v4 v5 v6 v7 x0 x1 x2 x3 x4 x5 x6 x7 k0 k1 k2 k3 k4 k5 k6 k7 ++ rest)
    (hk :
      E ⊨ [k0 := 0#32, k1 := 1#32, k2 := 2#32, k3 := 3#32, k4 := 4#32, k5 := 5#32, k6 := 6#32,
        k7 := 7#32])
    (hx :
      E.read x0 = X0 ∧ E.read x1 = X1 ∧ E.read x2 = X2 ∧ E.read x3 = X3 ∧ E.read x4 = X4 ∧
        E.read x5 = X5 ∧ E.read x6 = X6 ∧ E.read x7 = X7)
    (hK :
      ∀ vv0 vv1 vv2 vv3 vv4 vv5 vv6 : ⟦.vec 8 64⟧,
        (blk.runBodyFrom
              E[v0 := vv0, v1 := vv1, v2 := vv2, v3 := vv3, v4 := vv4, v5 := vv5, v6 := vv6,
                v7 := #v[X0, X1, X2, X3, X4, X5, X6, X7]] (pos + 8) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  iterate 8 step_pure
  rw [hE, set_eight]
  exact hK _ _ _ _ _ _ _

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
  iterate 13 step_pure
  iterate 3 step_pattern using runBodyFrom_insertRun
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
  step_pure
  -- FD_R43X6_QUAD_PERMUTE( r->P, 1,0,2,3, r->P ), fused with the subtraction's shuffle
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
