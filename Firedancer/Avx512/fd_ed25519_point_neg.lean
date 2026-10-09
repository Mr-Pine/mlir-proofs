module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.QuadOps
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

/-- Setting all eight lanes forgets the vector. -/
theorem Vector.set_all {α : Type} (w : Vector α 8) (x0 x1 x2 x3 x4 x5 x6 x7 : α) :
    ((((((((w.set 0 x0).set 1 x1).set 2 x2).set 3 x3).set 4 x4).set 5 x5).set 6 x6).set 7 x7) =
      #v[x0, x1, x2, x3, x4, x5, x6, x7] := by
  ext i hi
  obtain _|_|_|_|_|_|_|_|i := i <;> simp
  omega

/-- `vecRun` without its poison: the lanes inserted into a shared `u`. -/
def insRun (u : Reg Γ (.vec 8 64)) (v0 v1 v2 v3 v4 v5 v6 v7 : Dst Γ (.vec 8 64))
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

/-- `runBodyFrom_vecRun` for `insRun`. -/
theorem runBodyFrom_insRun {blk : BasicBlock Γ tRets bp} {E : ⟪Γ⟫} {pos : Nat}
    {u : Reg Γ (.vec 8 64)} {v0 v1 v2 v3 v4 v5 v6 v7 : Dst Γ (.vec 8 64)}
    {x0 x1 x2 x3 x4 x5 x6 x7 : Reg Γ (.bv 64)}
    {k0 k1 k2 k3 k4 k5 k6 k7 : Reg Γ (.bv 32)} {rest : List (Instr Γ)}
    {X0 X1 X2 X3 X4 X5 X6 X7 : ⟦.bv 64⟧} {S : GlobalState} {g : ⟪Γ⟫ × GlobalState → PoisonOr β}
    {K : PoisonOr β}
    (hbody :
      blk.body.drop pos =
        insRun u v0 v1 v2 v3 v4 v5 v6 v7 x0 x1 x2 x3 x4 x5 x6 x7 k0 k1 k2 k3 k4 k5 k6 k7 ++ rest)
    (hk :
      E ⊨ [k0 := 0#32, k1 := 1#32, k2 := 2#32, k3 := 3#32, k4 := 4#32, k5 := 5#32, k6 := 6#32,
        k7 := 7#32])
    (hx :
      E.read x0 = X0 ∧ E.read x1 = X1 ∧ E.read x2 = X2 ∧ E.read x3 = X3 ∧ E.read x4 = X4 ∧
        E.read x5 = X5 ∧ E.read x6 = X6 ∧ E.read x7 = X7)
    (hK :
      ∀ vv0 vv1 vv2 vv3 vv4 vv5 vv6 : ⟦.vec 8 64⟧,
        (blk.runBodyFrom
              E[v0 := vv0, v1 := vv1, v2 := vv2, v3 := vv3, v4 := vv4, v5 := vv5,
                v6 := vv6, v7 := #v[X0, X1, X2, X3, X4, X5, X6, X7]] (pos + 8) S >>= g) = K) :
    (blk.runBodyFrom E pos S >>= g) = K := by
  iterate 8 step_pure
  rw [hE]
  rw [Vector.set_all]
  exact hK _ _ _ _ _ _ _

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
    iterate 18 step_pure
    iterate 4 step_pattern using runBodyFrom_insRun
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
