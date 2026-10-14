module

public import MLIR.Run.Tactic
public import Firedancer.Lane.Common.Mem
public import Firedancer.Lane.Common.Runs
public import Firedancer.Lane.Common.Tactics
public import Firedancer.Lane.Mlir.fd_ed25519_lane_point_add
import Mathlib.Data.BitVec
import Mathlib.Tactic.Ring

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h

attribute [local mlir_operation] vpmadd52l_wwl vpmadd52h_wwl zipWith_add_wwl zipWith_sub_wwl
  zipWith_and_wwl zipWith_mul_wwl zipWith_shl_wwl zipWith_lshr_wwl

/-- `fd_ed25519_lane_sub`'s `4p`, as the compiled constants. -/
theorem fourP : Fe.bcast2 (2 * (2 ^ 52 - 38)) (2 * (2 ^ 52 - 2)) =
    Fe.bcast2 9007199254740916#64 9007199254740988#64 := by
  simp only [Fe.bcast2, Fe.mk.injEq]
  decide

/-- `b + 2^11 p - a` as compiled: limb 0 as `(b - a) + 2^11 p`. -/
theorem subBig_11_compiled (A B : Fe) :
    subBig B A 11 =
      ⟨wwl_add (wwl_sub B.l0 A.l0) (Vector.replicate 8 4611686018427348992#64), wwl_sub (wwl_add B.l1 (Vector.replicate 8 4611686018427385856#64)) A.l1,
        wwl_sub (wwl_add B.l2 (Vector.replicate 8 4611686018427385856#64)) A.l2, wwl_sub (wwl_add B.l3 (Vector.replicate 8 4611686018427385856#64)) A.l3,
        wwl_sub (wwl_add B.l4 (Vector.replicate 8 4611686018427385856#64)) A.l4⟩ := by
  simp only [subBig, subOff, bigP_11, Fe.bcast2, wwl_bcast, Fe.zipWith, Fe.mk.injEq, and_true]
  wwl_ring

/-- `a + b` as compiled: `b + a`. -/
theorem addRaw_compiled (A B : Fe) :
    addRaw A B = ⟨wwl_add B.l0 A.l0, wwl_add B.l1 A.l1, wwl_add B.l2 A.l2, wwl_add B.l3 A.l3,
      wwl_add B.l4 A.l4⟩ := by
  simp only [addRaw, Fe.zipWith, wwl_add_comm A.l0, wwl_add_comm A.l1, wwl_add_comm A.l2,
    wwl_add_comm A.l3, wwl_add_comm A.l4]

/-- `d + d` as compiled: `d << 1`. -/
theorem addRaw_self_compiled (D : Fe) :
    addRaw D D = ⟨wwl_shl D.l0 1, wwl_shl D.l1 1, wwl_shl D.l2 1, wwl_shl D.l3 1, wwl_shl D.l4 1⟩ := by
  simp only [addRaw, Fe.zipWith, Fe.mk.injEq]
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> wwl_ring

/-- `Point.add` with an affine table entry and `t`, as compiled: the sums commuted, the
differences with `2^11 p` as `subBig_11_compiled`, `2 d` as a shift, the products' operands as the
patterns read them. -/
theorem add_compiled (x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 z0 z1 z2 z3 z4 t0 t1 t2 t3 t4 qp0 qp1 qp2 qp3
    qp4 qm0 qm1 qm2 qm3 qm4 qk0 qk1 qk2 qk3 qk4 : Wwl) (QNK QZ T0 : Fe) :
    Point.add ⟨⟨x0, x1, x2, x3, x4⟩, ⟨y0, y1, y2, y3, y4⟩, ⟨z0, z1, z2, z3, z4⟩, ⟨t0, t1, t2, t3, t4⟩⟩ ⟨⟨qp0, qp1, qp2, qp3, qp4⟩, ⟨qm0, qm1, qm2, qm3, qm4⟩, ⟨qk0, qk1, qk2, qk3, qk4⟩, QNK, QZ⟩ true true T0 =
      let A := carry ⟨wwl_sub (wwl_add y0 (Vector.replicate 8 9007199254740916#64)) x0, wwl_sub (wwl_add y1 (Vector.replicate 8 9007199254740988#64)) x1,
        wwl_sub (wwl_add y2 (Vector.replicate 8 9007199254740988#64)) x2, wwl_sub (wwl_add y3 (Vector.replicate 8 9007199254740988#64)) x3, wwl_sub (wwl_add y4 (Vector.replicate 8 9007199254740988#64)) x4⟩
      let B := carry ⟨wwl_add x0 y0, wwl_add x1 y1, wwl_add x2 y2, wwl_add x3 y3, wwl_add x4 y4⟩
      let A := mul ⟨A.l0, A.l1, A.l2, A.l3, A.l4⟩ ⟨qm0, qm1, qm2, qm3, qm4⟩ false
      let B := mul ⟨B.l0, B.l1, B.l2, B.l3, B.l4⟩ ⟨qp0, qp1, qp2, qp3, qp4⟩ false
      let C := mul ⟨t0, t1, t2, t3, t4⟩ ⟨qk0, qk1, qk2, qk3, qk4⟩ false
      let D : Fe := ⟨wwl_shl z0 1, wwl_shl z1 1, wwl_shl z2 1, wwl_shl z3 1, wwl_shl z4 1⟩
      let E := carry ⟨wwl_add (wwl_sub B.l0 A.l0) (Vector.replicate 8 4611686018427348992#64), wwl_sub (wwl_add B.l1 (Vector.replicate 8 4611686018427385856#64)) A.l1,
        wwl_sub (wwl_add B.l2 (Vector.replicate 8 4611686018427385856#64)) A.l2, wwl_sub (wwl_add B.l3 (Vector.replicate 8 4611686018427385856#64)) A.l3,
        wwl_sub (wwl_add B.l4 (Vector.replicate 8 4611686018427385856#64)) A.l4⟩
      let F := carry ⟨wwl_add (wwl_sub D.l0 C.l0) (Vector.replicate 8 4611686018427348992#64), wwl_sub (wwl_add D.l1 (Vector.replicate 8 4611686018427385856#64)) C.l1,
        wwl_sub (wwl_add D.l2 (Vector.replicate 8 4611686018427385856#64)) C.l2, wwl_sub (wwl_add D.l3 (Vector.replicate 8 4611686018427385856#64)) C.l3,
        wwl_sub (wwl_add D.l4 (Vector.replicate 8 4611686018427385856#64)) C.l4⟩
      let G := carry ⟨wwl_add C.l0 D.l0, wwl_add C.l1 D.l1, wwl_add C.l2 D.l2, wwl_add C.l3 D.l3,
        wwl_add C.l4 D.l4⟩
      let H := carry ⟨wwl_add A.l0 B.l0, wwl_add A.l1 B.l1, wwl_add A.l2 B.l2, wwl_add A.l3 B.l3,
        wwl_add A.l4 B.l4⟩
      ⟨mul ⟨E.l0, E.l1, E.l2, E.l3, E.l4⟩ ⟨F.l0, F.l1, F.l2, F.l3, F.l4⟩, mul ⟨G.l0, G.l1, G.l2, G.l3, G.l4⟩ ⟨H.l0, H.l1, H.l2, H.l3, H.l4⟩,
        mul ⟨F.l0, F.l1, F.l2, F.l3, F.l4⟩ ⟨G.l0, G.l1, G.l2, G.l3, G.l4⟩, mul ⟨E.l0, E.l1, E.l2, E.l3, E.l4⟩ ⟨H.l0, H.l1, H.l2, H.l3, H.l4⟩⟩ := by
  simp only [Point.add, Point.addQ, Point.addFin, ↓reduceIte, addRaw_self_compiled]
  simp only [Lane.add, sub, fourP, subBig_11_compiled, addRaw_compiled]
  simp only [subOff, Fe.bcast2, wwl_bcast, Fe.zipWith]

-- 789 instructions, four inlined carried products and three loose ones, in one declaration
set_option maxHeartbeats 4000000 in
/-- `fd_ed25519_lane_point_add( r, p, q, 1, 1 )` stores `Point.add` of the point at `p` and the
affine table entry at `q` at `r`: `x`, `z`, `y`, `t`. All loads come before the stores, so `r` may
be `p`. -/
public theorem _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_point_add.call_eq (r p q : Pointer)
    (s : GlobalState) (hwf : s.WF) (hp : s.mem.LanePointFit p) (hq : s.mem.NielsFit q)
    (hr : s.mem.LanePointRoom r) :
    Firedancer.Lane.Mlir.fd_ed25519_lane_point_add.call
        (Firedancer.Lane.Mlir.fd_ed25519_lane_point_add.args (.value r) (.value p) (.value q)) s =
      .value (.nil,
        { s with
          mem :=
            s.mem.storeLanePoint r
              (Point.add (s.mem.readLanePoint p) (s.mem.readNiels q) true true Fe.zero) }) := by
  func_init
  block_init
  iterate 11 step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with y0
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with x0
  iterate 2 step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with y1
  iterate 2 step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with x1
  iterate 2 step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with y2
  iterate 2 step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with x2
  iterate 2 step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with y3
  iterate 2 step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with x3
  iterate 2 step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with y4
  iterate 2 step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with x4
  step_pure
  step_pattern using runBodyFrom_carryRun
  iterate 5 step_pure
  step_pattern using runBodyFrom_carryRun
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with qm0
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with qm1
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with qm2
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with qm3
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with qm4
  step_pattern using runBodyFrom_mulLooseRun
  step_load [MemoryState.ofFn_extractVecElem_readAt] with qp0
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with qp1
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with qp2
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with qp3
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with qp4
  step_pattern using runBodyFrom_mulLooseRun
  iterate 2 step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with t0
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with t1
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with t2
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with t3
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with t4
  step_load [MemoryState.ofFn_extractVecElem_readAt] with qk0
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with qk1
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with qk2
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with qk3
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with qk4
  step_pattern using runBodyFrom_mulLooseRun
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with z0
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with z1
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with z2
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with z3
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with z4
  iterate 35 step_pure
  step_pattern using runBodyFrom_carryRun
  step_pattern using runBodyFrom_carryRun
  step_pattern using runBodyFrom_carryRun
  step_pattern using runBodyFrom_carryRun
  -- `fd_ed25519_lane_mul( &r->x, &e, &f )`
  step_pattern using runBodyFrom_mulStoreRun 64 128 192 256 (hov := hr.1)
  clear_stored
  step_pure
  -- `fd_ed25519_lane_mul( &r->z, &f, &g )`
  step_pattern using runBodyFrom_mulStoreRun 704 768 832 896 (hov := hr.1)
  clear_stored
  step_pure
  -- `fd_ed25519_lane_mul( &r->y, &g, &h )`
  step_pattern using runBodyFrom_mulStoreRun 384 448 512 576 (hov := hr.1)
  clear_stored
  step_pure
  -- `fd_ed25519_lane_mul( &r->t, &e, &h )`
  step_pattern using runBodyFrom_mulStoreRun 1024 1088 1152 1216 (hov := hr.1)
  clear_stored
  finish_block
  rw [hS, MemoryState.readLanePoint_eq, MemoryState.readNiels_eq, add_compiled,
    MemoryState.storeLanePoint_eq]
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.Lane
