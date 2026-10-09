module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.fd_r52x5_quad_mul_fast
public import Firedancer.R52x5.Mlir.fd_r52x5_quad_sqr_fast

namespace MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_quad_sqr_fast( _z0 … _z4, x0 … x4 )`: the four squares of the QUAD `x`, lane by
lane, unreduced. The high halves first, `q{k}_{2,4}` by their scale after the 52-to-51 bit split;
then the low halves, limbs 5-9 folded into 0-4 by 19, and `rk = zk_1 + 2 zk_2`. -/
def fd_r52x5_quad_sqr_fast.spec (X : Quad5) : Quad5 :=
  let x0 := X.P0
  let x1 := X.P1
  let x2 := X.P2
  let x3 := X.P3
  let x4 := X.P4
  let _zz := wl_zero
  let q1_2 := wl_madd52hi _zz x0 x0
  let q2_4 := wl_madd52hi _zz x0 x1
  let q3_2 := wl_madd52hi _zz x1 x1
  let q3_4 := wl_madd52hi _zz x0 x2
  let q5_2 := wl_madd52hi _zz x2 x2
  let q4_4 := wl_madd52hi (wl_madd52hi _zz x1 x2) x0 x3
  let q7_2 := wl_madd52hi _zz x3 x3
  let q5_4 := wl_madd52hi (wl_madd52hi _zz x1 x3) x0 x4
  let q9_2 := wl_madd52hi _zz x4 x4
  let q6_4 := wl_madd52hi (wl_madd52hi _zz x2 x3) x1 x4
  let q7_4 := wl_madd52hi _zz x2 x4
  let q8_4 := wl_madd52hi _zz x3 x4
  let z0_1 := wl_madd52lo _zz x0 x0
  let z0_2 := _zz
  let z1_1 := _zz
  let z1_2 := wl_madd52lo q1_2 x0 x1
  let z2_1 := wl_madd52lo (wl_shl q2_4 2) x1 x1
  let z2_2 := wl_madd52lo _zz x0 x2
  let z3_1 := wl_shl q3_4 2
  let z3_2 := wl_madd52lo (wl_madd52lo q3_2 x1 x2) x0 x3
  let z4_1 := wl_madd52lo (wl_shl q4_4 2) x2 x2
  let z4_2 := wl_madd52lo (wl_madd52lo _zz x1 x3) x0 x4
  let z5_1 := wl_shl q5_4 2
  let z5_2 := wl_madd52lo (wl_madd52lo q5_2 x2 x3) x1 x4
  let z6_1 := wl_madd52lo (wl_shl q6_4 2) x3 x3
  let z6_2 := wl_madd52lo _zz x2 x4
  let z7_1 := wl_shl q7_4 2
  let z7_2 := wl_madd52lo q7_2 x3 x4
  let z8_1 := wl_madd52lo (wl_shl q8_4 2) x4 x4
  let z9_1 := wl_shl q9_2 1
  let z5_1 := wl_add z5_1 (wl_shl z5_2 1)
  let z6_1 := wl_add z6_1 (wl_shl z6_2 1)
  let z7_1 := wl_add z7_1 (wl_shl z7_2 1)
  let t0 := _zz
  let t1 := _zz
  let r19 := wl_bcast 19
  let t0 := wl_madd52hi t0 r19 z9_1
  let t1 := wl_madd52lo t1 r19 (wl_shru z9_1 52)
  let z4_2 := wl_madd52lo z4_2 r19 (wl_shru z8_1 52)
  let z3_2 := wl_madd52lo z3_2 r19 (wl_shru z7_1 52)
  let z2_2 := wl_madd52lo z2_2 r19 (wl_shru z6_1 52)
  let z1_2 := wl_madd52lo z1_2 r19 (wl_shru z5_1 52)
  let z0_2 := wl_madd52lo z0_2 r19 (wl_add t0 t1)
  let z1_2 := wl_madd52hi z1_2 r19 z5_1
  let z2_2 := wl_madd52hi z2_2 r19 z6_1
  let z3_2 := wl_madd52hi z3_2 r19 z7_1
  let z4_2 := wl_madd52hi z4_2 r19 z8_1
  let z0_1 := wl_madd52lo z0_1 r19 z5_1
  let z1_1 := wl_madd52lo z1_1 r19 z6_1
  let z2_1 := wl_madd52lo z2_1 r19 z7_1
  let z3_1 := wl_madd52lo z3_1 r19 z8_1
  let z4_1 := wl_madd52lo z4_1 r19 z9_1
  let r0 := wl_add (wl_add z0_1 z0_2) z0_2
  let r1 := wl_add (wl_add z1_1 z1_2) z1_2
  let r2 := wl_add (wl_add z2_1 z2_2) z2_2
  let r3 := wl_add (wl_add z3_1 z3_2) z3_2
  let r4 := wl_add (wl_add z4_1 z4_2) z4_2
  ⟨r0, r1, r2, r3, r4⟩

end

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h

attribute [local mlir_operation] vpmadd52l_wl vpmadd52h_wl zipWith_add_wl zipWith_shl_wl
  zipWith_lshr_wl

/-- `fd_r52x5_quad_sqr_fast` stores `spec`'s `wl_t`s at `_z0 … _z4`, in that order. -/
public theorem fd_r52x5_quad_sqr_fast.call_eq (_z0 _z1 _z2 _z3 _z4 : Pointer) (X : Quad5)
    (s : GlobalState) (hwf : s.WF) (h0 : Fits s.mem _z0 256) (h1 : Fits s.mem _z1 256)
    (h2 : Fits s.mem _z2 256) (h3 : Fits s.mem _z3 256) (h4 : Fits s.mem _z4 256) :
    fd_r52x5_quad_sqr_fast.call
        (fd_r52x5_quad_sqr_fast.args (.value _z0) (.value _z1) (.value _z2) (.value _z3)
          (.value _z4) (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4))
        s =
      .value
        (.nil,
          { s with
            mem := s.mem.storeTmp5 _z0 _z1 _z2 _z3 _z4 (fd_r52x5_quad_sqr_fast.spec X) }) := by
  func_init
  block_init
  iterate 5 step_pure
  -- the high halves
  step_pure with q1_2
  step_pure with q2_4
  step_pure with q3_2
  step_pure with q3_4
  step_pure with q5_2
  step_pure
  step_pure with q4_4
  step_pure with q7_2
  step_pure
  step_pure with q5_4
  step_pure with q9_2
  step_pure
  step_pure with q6_4
  step_pure with q7_4
  step_pure with q8_4
  -- the low halves
  step_pure with z0_1
  step_pure with z1_2
  step_pure
  step_pure with z2_1
  step_pure with z2_2
  step_pure with z3_1
  step_pure
  step_pure with z3_2
  step_pure
  step_pure with z4_1
  step_pure
  step_pure with z4_2
  step_pure with z5_1
  step_pure
  step_pure with z5_2
  step_pure
  step_pure with z6_1
  step_pure with z6_2
  step_pure with z7_1
  step_pure with z7_2
  step_pure
  step_pure with z8_1
  step_pure with z9_1
  step_pure
  step_pure with z5_1'
  step_pure
  step_pure with z6_1'
  step_pure
  step_pure with z7_1'
  -- the fold by 19
  step_pure
  step_pure with t1
  step_pure
  step_pure with z4_2'
  step_pure
  step_pure with z3_2'
  step_pure
  step_pure with z2_2'
  step_pure
  step_pure with z1_2'
  step_pure with t01
  step_pure with z0_2
  step_pure with z1_2''
  step_pure with z2_2''
  step_pure with z3_2''
  step_pure with z4_2''
  step_pure with z0_1'
  step_pure with z2_1'
  step_pure with z3_1'
  step_pure with z4_1'
  -- r0 … r4
  step_pure
  step_pure with r0
  step_pure
  step_pure with r1
  step_pure
  step_pure with r2
  step_pure
  step_pure with r3
  step_pure
  step_pure with r4
  iterate 5 step_store
  finish_block
  -- the compiled sums as the C writes them
  rw [wl_add_comm] at hz5_1' hz6_1' hz7_1'
  rw [wl_add_shl_one'] at hr0 hr2 hr3 hr4
  rw [wl_add_madd52lo] at hr1
  rw [wl_madd52hi_eq_add] at ht01
  clear hArgs hE
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.R52x5
