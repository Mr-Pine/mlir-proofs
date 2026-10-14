module

public import MLIR.Run.Tactic
public import Firedancer.Lane.Common.Mem
public import Firedancer.Lane.Common.Runs
public import Firedancer.Lane.Common.Tactics
public import Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl
import Mathlib.Data.BitVec
import Mathlib.Tactic.Ring

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h

attribute [local mlir_operation] vpmadd52l_wwl vpmadd52h_wwl zipWith_add_wwl zipWith_sub_wwl
  zipWith_and_wwl zipWith_mul_wwl zipWith_shl_wwl zipWith_lshr_wwl

/-- `2 c`, `c = sqr z false`, as compiled: limbs 1 and 3 fold their `19 r6`, `19 r8` doubled into
`38`. -/
theorem twoC_compiled (z0 z1 z2 z3 z4 : Wwl) :
    addRaw (sqr ⟨z0, z1, z2, z3, z4⟩ false) (sqr ⟨z0, z1, z2, z3, z4⟩ false) =
      ⟨(wwl_shl (wwl_madd52lo (wwl_mul (wwl_madd52lo (wwl_madd52lo (wwl_madd52hi (wwl_shl (wwl_madd52hi (wwl_madd52hi (Vector.replicate 8 0#64) z0 z4) z1 z3) 1) z2 z2) z1 z4) z2 z3) (Vector.replicate 8 38#64)) z0 z0) 1),
        (wwl_add (wwl_shl (wwl_madd52lo (wwl_madd52hi (Vector.replicate 8 0#64) z0 z0) z0 z1) 2) (wwl_mul (wwl_madd52lo (wwl_shl (wwl_madd52lo (wwl_shl (wwl_madd52hi (wwl_madd52hi (Vector.replicate 8 0#64) z1 z4) z2 z3) 1) z2 z4) 1) z3 z3) (Vector.replicate 8 38#64))),
        (wwl_shl (wwl_add (wwl_mul (wwl_madd52lo (wwl_madd52hi (wwl_shl (wwl_madd52hi (Vector.replicate 8 0#64) z2 z4) 1) z3 z3) z3 z4) (Vector.replicate 8 38#64)) (wwl_madd52lo (wwl_shl (wwl_madd52lo (wwl_shl (wwl_madd52hi (Vector.replicate 8 0#64) z0 z1) 1) z0 z2) 1) z1 z1)) 1),
        (wwl_add (wwl_shl (wwl_madd52lo (wwl_madd52lo (wwl_madd52hi (wwl_shl (wwl_madd52hi (Vector.replicate 8 0#64) z0 z2) 1) z1 z1) z0 z3) z1 z2) 2) (wwl_mul (wwl_madd52lo (wwl_shl (wwl_madd52hi (Vector.replicate 8 0#64) z3 z4) 2) z4 z4) (Vector.replicate 8 38#64))),
        (wwl_shl (wwl_add (wwl_mul (wwl_madd52hi (Vector.replicate 8 0#64) z4 z4) (Vector.replicate 8 38#64)) (wwl_madd52lo (wwl_shl (wwl_madd52lo (wwl_madd52lo (wwl_shl (wwl_madd52hi (wwl_madd52hi (Vector.replicate 8 0#64) z0 z3) z1 z2) 1) z0 z4) z1 z3) 1) z2 z2)) 1)⟩ := by
  rw [sqr_compiled]
  simp only [addRaw, Fe.zipWith, Fe.mk.injEq]
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> wwl_ring

/-- `Point.dbl` as compiled: `x + y` and `b + a` commuted, `b + 2^11 p - a`'s limb 0 as
`(b - a) + 2^11 p`, the products' operands as the patterns read them. -/
theorem dbl_compiled (x0 x1 x2 x3 x4 y0 y1 y2 y3 y4 z0 z1 z2 z3 z4 : Wwl) (T t0 : Fe)
    (w : Bool) :
    Point.dbl ⟨⟨x0, x1, x2, x3, x4⟩, ⟨y0, y1, y2, y3, y4⟩, ⟨z0, z1, z2, z3, z4⟩, T⟩ w t0 =
      let A := sqr ⟨x0, x1, x2, x3, x4⟩ false
      let B := sqr ⟨y0, y1, y2, y3, y4⟩ false
      let S := carry ⟨wwl_add y0 x0, wwl_add y1 x1, wwl_add y2 x2, wwl_add y3 x3, wwl_add y4 x4⟩
      let S2 := sqr ⟨S.l0, S.l1, S.l2, S.l3, S.l4⟩ false
      let G := carry ⟨wwl_add (wwl_sub B.l0 A.l0) (Vector.replicate 8 4611686018427348992#64), wwl_sub (wwl_add B.l1 (Vector.replicate 8 4611686018427385856#64)) A.l1,
        wwl_sub (wwl_add B.l2 (Vector.replicate 8 4611686018427385856#64)) A.l2, wwl_sub (wwl_add B.l3 (Vector.replicate 8 4611686018427385856#64)) A.l3,
        wwl_sub (wwl_add B.l4 (Vector.replicate 8 4611686018427385856#64)) A.l4⟩
      let H : Fe := ⟨wwl_add B.l0 A.l0, wwl_add B.l1 A.l1, wwl_add B.l2 A.l2, wwl_add B.l3 A.l3,
        wwl_add B.l4 A.l4⟩
      let E := carry ⟨wwl_sub (wwl_add S2.l0 (Vector.replicate 8 9223372036854697984#64)) H.l0, wwl_sub (wwl_add S2.l1 (Vector.replicate 8 9223372036854771712#64)) H.l1,
        wwl_sub (wwl_add S2.l2 (Vector.replicate 8 9223372036854771712#64)) H.l2, wwl_sub (wwl_add S2.l3 (Vector.replicate 8 9223372036854771712#64)) H.l3,
        wwl_sub (wwl_add S2.l4 (Vector.replicate 8 9223372036854771712#64)) H.l4⟩
      let H := carry ⟨wwl_sub (Vector.replicate 8 9223372036854697984#64) H.l0, wwl_sub (Vector.replicate 8 9223372036854771712#64) H.l1, wwl_sub (Vector.replicate 8 9223372036854771712#64) H.l2,
        wwl_sub (Vector.replicate 8 9223372036854771712#64) H.l3, wwl_sub (Vector.replicate 8 9223372036854771712#64) H.l4⟩
      let C := addRaw (sqr ⟨z0, z1, z2, z3, z4⟩ false) (sqr ⟨z0, z1, z2, z3, z4⟩ false)
      let F := carry ⟨wwl_sub (wwl_add G.l0 (Vector.replicate 8 4611686018427348992#64)) C.l0, wwl_sub (wwl_add G.l1 (Vector.replicate 8 4611686018427385856#64)) C.l1,
        wwl_sub (wwl_add G.l2 (Vector.replicate 8 4611686018427385856#64)) C.l2, wwl_sub (wwl_add G.l3 (Vector.replicate 8 4611686018427385856#64)) C.l3,
        wwl_sub (wwl_add G.l4 (Vector.replicate 8 4611686018427385856#64)) C.l4⟩
      ⟨mul ⟨E.l0, E.l1, E.l2, E.l3, E.l4⟩ ⟨F.l0, F.l1, F.l2, F.l3, F.l4⟩, mul ⟨G.l0, G.l1, G.l2, G.l3, G.l4⟩ ⟨H.l0, H.l1, H.l2, H.l3, H.l4⟩,
        mul ⟨F.l0, F.l1, F.l2, F.l3, F.l4⟩ ⟨G.l0, G.l1, G.l2, G.l3, G.l4⟩,
        if w then mul ⟨E.l0, E.l1, E.l2, E.l3, E.l4⟩ ⟨H.l0, H.l1, H.l2, H.l3, H.l4⟩ else t0⟩ := by
  have hs : Lane.add ⟨x0, x1, x2, x3, x4⟩ ⟨y0, y1, y2, y3, y4⟩ =
      carry ⟨wwl_add y0 x0, wwl_add y1 x1, wwl_add y2 x2, wwl_add y3 x3, wwl_add y4 x4⟩ := by
    simp only [Lane.add, addRaw, Fe.zipWith, wwl_add_comm x0, wwl_add_comm x1, wwl_add_comm x2,
      wwl_add_comm x3, wwl_add_comm x4]
  have hg : subBig (sqr ⟨y0, y1, y2, y3, y4⟩ false) (sqr ⟨x0, x1, x2, x3, x4⟩ false) 11 =
      let A := sqr ⟨x0, x1, x2, x3, x4⟩ false
      let B := sqr ⟨y0, y1, y2, y3, y4⟩ false
      ⟨wwl_add (wwl_sub B.l0 A.l0) (Vector.replicate 8 4611686018427348992#64), wwl_sub (wwl_add B.l1 (Vector.replicate 8 4611686018427385856#64)) A.l1,
        wwl_sub (wwl_add B.l2 (Vector.replicate 8 4611686018427385856#64)) A.l2, wwl_sub (wwl_add B.l3 (Vector.replicate 8 4611686018427385856#64)) A.l3,
        wwl_sub (wwl_add B.l4 (Vector.replicate 8 4611686018427385856#64)) A.l4⟩ := by
    simp only [subBig, subOff, bigP_11, Fe.bcast2, wwl_bcast, Fe.zipWith, Fe.mk.injEq, and_true]
    wwl_ring
  have hh : addRaw (sqr ⟨x0, x1, x2, x3, x4⟩ false) (sqr ⟨y0, y1, y2, y3, y4⟩ false) =
      let A := sqr ⟨x0, x1, x2, x3, x4⟩ false
      let B := sqr ⟨y0, y1, y2, y3, y4⟩ false
      ⟨wwl_add B.l0 A.l0, wwl_add B.l1 A.l1, wwl_add B.l2 A.l2, wwl_add B.l3 A.l3,
        wwl_add B.l4 A.l4⟩ := by
    simp only [addRaw, Fe.zipWith, wwl_add_comm (sqr ⟨x0, x1, x2, x3, x4⟩ false).l0,
      wwl_add_comm (sqr ⟨x0, x1, x2, x3, x4⟩ false).l1,
      wwl_add_comm (sqr ⟨x0, x1, x2, x3, x4⟩ false).l2,
      wwl_add_comm (sqr ⟨x0, x1, x2, x3, x4⟩ false).l3,
      wwl_add_comm (sqr ⟨x0, x1, x2, x3, x4⟩ false).l4]
  simp only [Point.dbl, hs, hg, hh]
  simp only [subBig, subOff, bigP_11, bigP_12, Fe.bcast2, wwl_bcast, Fe.zipWith]

-- 716 instructions, four of them inlined products, in one declaration
set_option maxHeartbeats 4000000 in
/-- `fd_ed25519_lane_point_dbl( r, p, with_t )` stores `Point.dbl` of the point at `p` at `r`:
`x`, `z`, `y`, then `t` if `with_t`; else `r`'s `t` stays, and must be known. All loads come before
the stores, so `r` may be `p`. -/
public theorem _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl.call_eq (r p : Pointer)
    (withT : BitVec 32) (s : GlobalState) (hwf : s.WF) (hp : s.mem.LanePointFit p)
    (hr : s.mem.LanePointRoom r) (ht : withT = 0 → s.mem.FeFit (r.add 960#64)) :
    Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl.call
        (Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl.args (.value r) (.value p) (.value withT)) s =
      .value (.nil,
        { s with
          mem :=
            s.mem.storeLanePoint r
              (Point.dbl (s.mem.readLanePoint p) (withT ≠ 0) (s.mem.readFe (r.add 960#64))) }) := by
  func_init
  have ht₀ : withT = 0 → S₀.mem.FeFit (r.add 960#64) := hS ▸ ht
  clear ht
  block_init
  -- the constants
  iterate 12 step_pure
  -- `fd_ed25519_lane_add( &s, &p->x, &p->y )`: the raw sums with the loads of `x`, `y`
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with x0
  step_load [MemoryState.ofFn_extractVecElem_readAt] with y0
  step_pure
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with x1
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with y1
  step_pure
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with x2
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with y2
  step_pure
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with x3
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with y3
  step_pure
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with x4
  step_pure
  step_load [MemoryState.ofFn_extractVecElem_readAt] with y4
  step_pure
  -- its carry
  step_pattern using runBodyFrom_carryRun
  -- `fd_ed25519_lane_sqr_loose( &a, &p->x )`, `( &b, &p->y )`
  step_pattern using runBodyFrom_sqrRun
  step_pattern using runBodyFrom_sqrRun
  -- `fd_ed25519_lane_sqr_loose( &c, &p->z )`, with the loads of `z`; its odd limbs' folds wait
  -- for `fd_ed25519_lane_add_raw( &c, &c, &c )`
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
  iterate 45 step_pure
  -- `fd_ed25519_lane_sqr_loose( &s, &s )`
  step_pattern using runBodyFrom_sqrRun
  -- `g = b + 2^11 p - a`, `h = a + b`, `e = s + 2^12 p - h`, `h = 2^12 p - h`
  iterate 30 step_pure
  -- `fd_ed25519_lane_carry( &g )`
  step_pattern using runBodyFrom_carryRun
  -- `c = c + c`, `f = g + 2^11 p - c`
  iterate 19 step_pure
  -- `fd_ed25519_lane_carry( &e )`, `( &f )`, `( &h )`
  step_pattern using runBodyFrom_carryRun
  step_pattern using runBodyFrom_carryRun
  step_pattern using runBodyFrom_carryRun
  -- `fd_ed25519_lane_mul( &r->x, &e, &f )`
  step_pattern using runBodyFrom_mulStoreRun 64 128 192 256 (hov := hr.1)
  clear_stored
  -- `fd_ed25519_lane_mul( &r->z, &f, &g )`
  step_pure
  step_pattern using runBodyFrom_mulStoreRun 704 768 832 896 (hov := hr.1)
  clear_stored
  -- `fd_ed25519_lane_mul( &r->y, &g, &h )`
  step_pure
  step_pattern using runBodyFrom_mulStoreRun 384 448 512 576 (hov := hr.1)
  clear_stored
  -- `if( with_t )`
  step_pure
  finish_block
  case isTrue =>
    block_init
    finish_block
    rw [hS, MemoryState.storeLanePoint_eq_of_t hr.1 (ht₀ hbr) (by simp [Point.dbl, hbr]),
      MemoryState.readLanePoint_eq, dbl_compiled, twoC_compiled]
    subst_vars
    rfl
  case isFalse =>
    -- `fd_ed25519_lane_mul( &r->t, &e, &h )`
    block_init
    step_pure
    step_pattern using runBodyFrom_mulStoreRun 1024 1088 1152 1216 (hov := hr.1)
    clear_stored
    finish_block
    block_init
    finish_block
    rw [hS, MemoryState.readLanePoint_eq, dbl_compiled, twoC_compiled,
      MemoryState.storeLanePoint_eq]
    have hT : withT ≠ 0 := hbr
    simp only [hT, decide_true, ne_eq, not_false_eq_true, ite_true]
    subst_vars
    rfl

end Proof

end MLIR.Firedancer.Lane
