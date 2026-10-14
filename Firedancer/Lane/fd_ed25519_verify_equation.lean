module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.fd_ed25519_verify_equation
public import Firedancer.Lane.fd_ed25519_double_scalar_mul_base
public import Firedancer.Lane.fd_ed25519_point_eq_z1
public import Firedancer.Lane.Mlir.fd_ed25519_verify_equation
import Mathlib.Data.Fintype.Basic
import Mathlib.Tactic.FinCases
import Std.Tactic.BVDecide
meta import Std.Tactic.BVDecide.Reflect

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Proof -/

section Proof

set_option hygiene false in
/-- A shuffle of `<7 x i64>` loads, lane by lane. -/
local macro "lanes7" : tactic =>
  `(tactic|
    ( apply vec_ext_fin
      intro k
      fin_cases k <;>
        simp [Quad.perm4, wwl_perm4, wwl_pack_halves, MemoryState.readQuad, readAt448_lane,
          lane448]))

attribute [-mlir_operation] zipWith_eq_ofFn

/-- A `<7 x i64>` load from a known point vector: its first seven lanes. -/
theorem lane448 (v : Wwl) (i : Fin 7) :
    Ty.extractVecElem 7 64 i ((BitVec.packLanes v).setWidth 448) = v[i.val] := by
  rw [Ty.extractVecElem_eq]
  have h := BitVec.extractLsb'_packLanes v i.val (by omega)
  apply BitVec.eq_of_getLsbD_eq
  intro j hj
  have := i.isLt
  have hb := congrArg (fun y => y.getLsbD j) h
  simp only [BitVec.getLsbD_extractLsb', BitVec.getLsbD_setWidth, hj, decide_true,
    Bool.true_and] at hb ⊢
  have : i.val * 64 + j < 448 := by omega
  simp only [this, decide_true, Bool.true_and]
  exact hb

namespace fd_ed25519_verify_equation

/-- `LANE_SUB_FAST( r, a, 1,0,0,1, _p, a )` as compiled: `2p - a` in `X` and `T`. -/
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

theorem neg_spec_eq (A : Quad) : fd_ed25519_point_neg.spec A = (negSub A).foldUnsignedC := by
  rw [fd_ed25519_point_neg.spec, laneSubFast_neg, Quad.foldUnsigned_eq]

end fd_ed25519_verify_equation

set_option maxHeartbeats 1000000 in
-- one walk: 315 instructions, `fd_ed25519_point_neg` and `fd_ed25519_point_eq_z1` inlined
open fd_ed25519_verify_equation in
/-- `fd_ed25519_verify_equation` returns `spec` of the scalars at `k`, `Sp` and the points at `A`,
`R`, and leaves `A` negated; its frame is ten blocks: `Rcmp` and
`fd_ed25519_double_scalar_mul_base`'s nine. -/
public theorem fd_ed25519_verify_equation.call_eq (k A Sp R : Pointer) (s : GlobalState)
    (hwf : s.WF)
    (hg : s.mem.Globals _root_.Firedancer.Lane.Mlir.fd_ed25519_verify_equation.globals)
    (hk : Fits s.mem k (8 * 32)) (hA : s.mem.QuadFit A) (hAw : Writable s.mem A)
    (hSp : Fits s.mem Sp (8 * 32)) (hR : s.mem.QuadFit R) (hkA : k.id ≠ A.id) (hSA : Sp.id ≠ A.id)
    (hRA : R.id ≠ A.id) :
    _root_.Firedancer.Lane.Mlir.fd_ed25519_verify_equation.call
        (_root_.Firedancer.Lane.Mlir.fd_ed25519_verify_equation.args (.value k) (.value A)
          (.value Sp) (.value R)) s =
      .value
        (.cons
            (.value
              (Avx512.fd_ed25519_verify_equation.spec fd_ed25519_base_point_wnaf_table.point
                (s.mem.readAt k 256) (s.mem.readQuad A) (s.mem.readAt Sp 256) (s.mem.readQuad R)))
            .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 10⟩,
            mem := s.mem.storeQuad A (fd_ed25519_point_neg.spec (s.mem.readQuad A)) }) := by
  func_init
  block_init
  iterate 40 step_pure
  iterate 7 step_pattern using runBodyFrom_insertRun
  -- fd_ed25519_point_t Rcmp[1];
  step_alloca with Rc
  step_pure
  -- fd_ed25519_point_neg( A, A ), inlined
  step_load with transparent a03
  step_pure
  step_load with transparent a14
  step_pure
  step_load with transparent a25
  step_pure [expandOfFn] with transparent d03
  step_pure with n03
  step_pure [expandOfFn] with transparent d14
  step_pure with n14
  step_pure [expandOfFn] with transparent d25
  step_pure with n25
  step_pattern using runBodyFrom_foldUnsignedStoreRun'
  have en : negSub (S₀.mem.readQuad A) = ⟨n03, n14, n25⟩ := by
    rw [hn03, hn14, hn25]
    rfl
  have eN : fd_ed25519_point_neg.spec (S₀.mem.readQuad A) = ⟨u03, u14, u25⟩ := by
    rw [neg_spec_eq, en, _hu]
  have hAq : S.mem.readQuad A = ⟨u03, u14, u25⟩ := by
    rw [MemoryState.readQuad, MemoryState.readVec_packLanes hread_A,
      MemoryState.readVec_packLanes hread_A_64, MemoryState.readVec_packLanes hread_A_128]
  -- fd_ed25519_double_scalar_mul_base( Rcmp, k, A, S );
  have hRcq := MemoryState.QuadRoom.of_room hroom_Rc hRc_off
  step_call using fd_ed25519_double_scalar_mul_base.call_eq
  obtain ⟨X, hX⟩ : ∃ X, S.mem.readQuad Rc = X := ⟨_, rfl⟩
  have hXv := hX.symm.trans hread_Rc
  folded hXv
  have hr03 : S.mem.readAt Rc 512 = BitVec.packLanes X.P03 := by
    rw [← hX]
    simp only [MemoryState.readQuad, MemoryState.readVec, BitVec.packLanes_extractVecElem]
  have hr14 : S.mem.readAt (Rc.add 64#64) 512 = BitVec.packLanes X.P14 := by
    rw [← hX]
    simp only [MemoryState.readQuad, MemoryState.readVec, BitVec.packLanes_extractVecElem]
  have hr25 : S.mem.readAt (Rc.add 128#64) 512 = BitVec.packLanes X.P25 := by
    rw [← hX]
    simp only [MemoryState.readQuad, MemoryState.readVec, BitVec.packLanes_extractVecElem]
  clear hread_Rc hX
  -- return fd_ed25519_point_eq_z1( Rcmp, R ), inlined
  step_load with xa03
  step_pure
  step_load with xa14
  step_pure
  step_load with xa25
  step_load with ya03
  step_pure
  step_load with ya14
  step_pure
  step_load with ya25
  have h14 : S.mem.readAt (Rc.add 64#64) 448 = (BitVec.packLanes X.P14).setWidth 448 :=
    MemoryState.readAt_of_readAt_le (by decide) hr14
  have h25 : S.mem.readAt (Rc.add 128#64) 448 = (BitVec.packLanes X.P25).setWidth 448 :=
    MemoryState.readAt_of_readAt_le (by decide) hr25
  simp only [hS] at h14 h25
  rw [h14] at hxa14
  rw [h25] at hxa25
  clear h14 h25 hr03 hr14 hr25
  step_pure with y03
  step_pure with y14
  step_pure with y25
  step_pure with x00
  step_pure with x11
  step_pure with x22
  step_pure with x33
  step_pure with x44
  step_pure with x55
  have ey03 : y03 = (Quad.permute 0 2 1 2 (S₀.mem.readQuad R)).P03 := by
    rw [hy03, hya03, Quad.permute_eq_perm4 (by decide)]
    lanes7
  have ey14 : y14 = (Quad.permute 0 2 1 2 (S₀.mem.readQuad R)).P14 := by
    rw [hy14, hya14, Quad.permute_eq_perm4 (by decide)]
    lanes7
  have ey25 : y25 = (Quad.permute 0 2 1 2 (S₀.mem.readQuad R)).P25 := by
    rw [hy25, hya25, Quad.permute_eq_perm4 (by decide)]
    lanes7
  have ex00 :
      x00 =
        wwl_pack_halves (Quad.permute 2 0 2 1 X).P03 0
          (Quad.permute 2 0 2 1 X).P03 0 := by
    rw [hx00, hxa03, Quad.permute_eq_perm4 (by decide)]
    lanes7
  have ex11 :
      x11 =
        wwl_pack_halves (Quad.permute 2 0 2 1 X).P14 0
          (Quad.permute 2 0 2 1 X).P14 0 := by
    rw [hx11, hxa14, Quad.permute_eq_perm4 (by decide)]
    lanes7
  have ex22 :
      x22 =
        wwl_pack_halves (Quad.permute 2 0 2 1 X).P25 0
          (Quad.permute 2 0 2 1 X).P25 0 := by
    rw [hx22, hxa25, Quad.permute_eq_perm4 (by decide)]
    lanes7
  have ex33 :
      x33 =
        wwl_pack_halves (Quad.permute 2 0 2 1 X).P03 1
          (Quad.permute 2 0 2 1 X).P03 1 := by
    rw [hx33, hxa03, Quad.permute_eq_perm4 (by decide)]
    lanes7
  have ex44 :
      x44 =
        wwl_pack_halves (Quad.permute 2 0 2 1 X).P14 1
          (Quad.permute 2 0 2 1 X).P14 1 := by
    rw [hx44, hxa14, Quad.permute_eq_perm4 (by decide)]
    lanes7
  have ex55 :
      x55 =
        wwl_pack_halves (Quad.permute 2 0 2 1 X).P25 1
          (Quad.permute 2 0 2 1 X).P25 1 := by
    rw [hx55, hxa25, Quad.permute_eq_perm4 (by decide)]
    lanes7
  clear hy03 hy14 hy25 hx00 hx11 hx22 hx33 hx44 hx55 hxa03 hxa14 hxa25 hya03 hya14 hya25
  -- FD_R43X6_QUAD_MUL_FAST( X, X, Y ), the permutes fused into its operands
  step_pattern using runBodyFrom_quadMulCoreRun
  have e3 :
      quadMul (X.permute 2 0 2 1) ((S₀.mem.readQuad R).permute 0 2 1 2) =
        ⟨m03, m14, m25⟩ := by
    rw [quadMul_eq_core, ← ex00, ← ex11, ← ex22, ← ex33, ← ex44, ← ex55, ← ey03, ← ey14, ← ey25]
    exact _hm
  clear ex00 ex11 ex22 ex33 ex44 ex55 ey03 ey14 ey25 _hm
  -- FD_R43X6_QUAD_UNPACK( xn2, xn1, yn2, yn1, X ), the differences
  step_pattern using runBodyFrom_unpackSubRun
  -- !fd_r43x6_is_nonzero( … ) & !fd_r43x6_is_nonzero( … ), over two lanes
  step_pattern using runBodyFrom_zr2Run
  iterate 4 step_pure
  step_pure
  finish_block
  rw [Avx512.fd_ed25519_verify_equation.spec, eN, ← hXv]
  subst hS
  simp only [fd_ed25519_point_eq_z1.spec, fd_ed25519_point_eq.spec, fd_r43x6_ge_is_eq.spec, e3]
  rw [zero_test_and _ _ (fd_r43x6_is_nonzero.spec_01 _) (fd_r43x6_is_nonzero.spec_01 _)]
  erase_frame
  simp only [GlobalState.alloca, Nat.add_assoc, Nat.reduceAdd]
  rfl

end Proof

end MLIR.Firedancer.Lane
