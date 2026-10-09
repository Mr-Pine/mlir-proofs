module

public import MLIR.Run.Tactic
import Std.Tactic.BVDecide
public import Firedancer.R52x5.Common.VecRun
public import Firedancer.R52x5.Mlir.fd_r52x5_quad_mul_fast

namespace MLIR.Firedancer.R52x5

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_quad_mul_fast( _z0 … _z4, x0 … x4, y0 … y4 )`: the four products of the QUADs `x`
and `y`, lane by lane, unreduced. Each partial's low half is summed into `zk_1`, its high half into
`z(k+1)_2`; limbs 5-9 are folded into 0-4 by 19, and `rk = zk_1 + 2 zk_2`. -/
def fd_r52x5_quad_mul_fast.spec (X Y : Quad5) : Quad5 :=
  let x0 := X.P0
  let x1 := X.P1
  let x2 := X.P2
  let x3 := X.P3
  let x4 := X.P4
  let y0 := Y.P0
  let y1 := Y.P1
  let y2 := Y.P2
  let y3 := Y.P3
  let y4 := Y.P4
  let _zz := wl_zero
  let z0_1 := wl_madd52lo _zz x0 y0
  let z1_1 := wl_madd52lo (wl_madd52lo _zz x1 y0) x0 y1
  let z2_1 := wl_madd52lo (wl_madd52lo (wl_madd52lo _zz x2 y0) x1 y1) x0 y2
  let z3_1 := wl_madd52lo (wl_madd52lo (wl_madd52lo _zz x3 y0) x2 y1) x1 y2
  let z3_1 := wl_madd52lo z3_1 x0 y3
  let z4_1 := wl_madd52lo (wl_madd52lo (wl_madd52lo _zz x4 y0) x3 y1) x2 y2
  let z4_1 := wl_madd52lo (wl_madd52lo z4_1 x1 y3) x0 y4
  let z5_1 := wl_madd52lo (wl_madd52lo (wl_madd52lo _zz x4 y1) x3 y2) x2 y3
  let z5_1 := wl_madd52lo z5_1 x1 y4
  let z6_1 := wl_madd52lo (wl_madd52lo (wl_madd52lo _zz x4 y2) x3 y3) x2 y4
  let z7_1 := wl_madd52lo (wl_madd52lo _zz x4 y3) x3 y4
  let z8_1 := wl_madd52lo _zz x4 y4
  let z0_2 := _zz
  let z1_2 := wl_madd52hi _zz x0 y0
  let z2_2 := wl_madd52hi (wl_madd52hi _zz x1 y0) x0 y1
  let z3_2 := wl_madd52hi (wl_madd52hi (wl_madd52hi _zz x2 y0) x1 y1) x0 y2
  let z4_2 := wl_madd52hi (wl_madd52hi (wl_madd52hi _zz x3 y0) x2 y1) x1 y2
  let z4_2 := wl_madd52hi z4_2 x0 y3
  let z5_2 := wl_madd52hi (wl_madd52hi (wl_madd52hi _zz x4 y0) x3 y1) x2 y2
  let z5_2 := wl_madd52hi (wl_madd52hi z5_2 x1 y3) x0 y4
  let z6_2 := wl_madd52hi (wl_madd52hi (wl_madd52hi _zz x4 y1) x3 y2) x2 y3
  let z6_2 := wl_madd52hi z6_2 x1 y4
  let z7_2 := wl_madd52hi (wl_madd52hi (wl_madd52hi _zz x4 y2) x3 y3) x2 y4
  let z8_2 := wl_madd52hi (wl_madd52hi _zz x4 y3) x3 y4
  let z9_2 := wl_madd52hi _zz x4 y4
  let z5 := wl_add (wl_add z5_1 z5_2) z5_2
  let z6 := wl_add (wl_add z6_1 z6_2) z6_2
  let z7 := wl_add (wl_add z7_1 z7_2) z7_2
  let z8 := wl_add (wl_add z8_1 z8_2) z8_2
  let z9 := wl_add z9_2 z9_2
  let t0 := wl_zero
  let t1 := wl_zero
  let r19 := wl_bcast 19
  let t1 := wl_madd52lo t1 r19 (wl_shru z9 52)
  let z1_2 := wl_madd52lo z1_2 r19 (wl_shru z5 52)
  let z2_2 := wl_madd52lo z2_2 r19 (wl_shru z6 52)
  let z3_2 := wl_madd52lo z3_2 r19 (wl_shru z7 52)
  let z0_1 := wl_madd52lo z0_1 r19 z5
  let z1_1 := wl_madd52lo z1_1 r19 z6
  let z1_2 := wl_madd52hi z1_2 r19 z5
  let z2_1 := wl_madd52lo z2_1 r19 z7
  let z2_2 := wl_madd52hi z2_2 r19 z6
  let z3_1 := wl_madd52lo z3_1 r19 z8
  let z3_2 := wl_madd52hi z3_2 r19 z7
  let z4_1 := wl_madd52lo z4_1 r19 z9
  let z4_2 := wl_madd52hi z4_2 r19 z8
  let t0 := wl_madd52hi t0 r19 z9
  let z0_2 := wl_madd52lo z0_2 r19 (wl_add t0 t1)
  let z4_2 := wl_madd52lo z4_2 r19 (wl_shru z8 52)
  let r0 := wl_add (wl_add z0_1 z0_2) z0_2
  let r1 := wl_add (wl_add z1_1 z1_2) z1_2
  let r2 := wl_add (wl_add z2_1 z2_2) z2_2
  let r3 := wl_add (wl_add z3_1 z3_2) z3_2
  let r4 := wl_add (wl_add z4_1 z4_2) z4_2
  ⟨r0, r1, r2, r3, r4⟩

end

/-! ## Lanes

The sums as compiled against the C's: `wl_add( wl_add( a, b ), b )` becomes `(b << 1) + a`, and
`wl_madd52lo`'s accumulator is moved. Shared with `fd_r52x5_quad_sqr_fast`. -/

section Lanes

theorem shl_one_eq_add (b : BitVec 64) : b <<< 1 = b + b := by bv_decide

/-- `wl_add( b, b )` as compiled. -/
public theorem wl_shl_one (b : Wl) : wl_shl b 1 = wl_add b b := by
  ext i hi : 1
  simp only [wl_add, wl_shl, Fin.getElem_fin, Vector.getElem_ofFn, shl_one_eq_add]

/-- `wl_add( wl_add( a, b ), b )` as compiled. -/
public theorem wl_add_shl_one (a b : Wl) : wl_add (wl_shl b 1) a = wl_add (wl_add a b) b := by
  ext i hi : 1
  simp only [wl_add, wl_shl, Fin.getElem_fin, Vector.getElem_ofFn, shl_one_eq_add]
  ac_rfl

/-- `wl_add( wl_add( a, b ), b )` as compiled, the operands the other way round. -/
public theorem wl_add_shl_one' (a b : Wl) : wl_add a (wl_shl b 1) = wl_add (wl_add a b) b := by
  ext i hi : 1
  simp only [wl_add, wl_shl, Fin.getElem_fin, Vector.getElem_ofFn, shl_one_eq_add]
  ac_rfl

public theorem wl_add_comm (a b : Wl) : wl_add a b = wl_add b a := by
  ext i hi : 1
  simp only [wl_add, Fin.getElem_fin, Vector.getElem_ofFn]
  ac_rfl

/-- `wl_add( wl_add( wl_madd52lo( 0, x, y ), a ), a )` as compiled. -/
public theorem wl_add_madd52lo (a x y : Wl) :
    wl_add (wl_madd52lo a x y) a = wl_add (wl_add (wl_madd52lo wl_zero x y) a) a := by
  ext i hi : 1
  simp [wl_add, wl_madd52lo]
  ac_rfl

/-- `wl_add( a, wl_madd52lo( 0, x, y ) )` as compiled. -/
public theorem wl_madd52lo_eq_add (a x y : Wl) :
    wl_madd52lo a x y = wl_add a (wl_madd52lo wl_zero x y) := by
  ext i hi : 1
  simp [wl_add, wl_madd52lo]

/-- `wl_add( wl_madd52hi( 0, x, y ), a )` as compiled. -/
public theorem wl_madd52hi_eq_add (a x y : Wl) :
    wl_madd52hi a x y = wl_add (wl_madd52hi wl_zero x y) a := by
  ext i hi : 1
  simp [wl_add, wl_madd52hi]
  ac_rfl

end Lanes

/-! ## Proof -/

section Proof

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h

attribute [local mlir_operation] vpmadd52l_wl vpmadd52h_wl zipWith_add_wl zipWith_shl_wl
  zipWith_lshr_wl

/-- `fd_r52x5_quad_mul_fast` stores `spec`'s `wl_t`s at `_z0 … _z4`, in that order. -/
public theorem fd_r52x5_quad_mul_fast.call_eq (_z0 _z1 _z2 _z3 _z4 : Pointer) (X Y : Quad5)
    (s : GlobalState) (hwf : s.WF) (h0 : Fits s.mem _z0 256) (h1 : Fits s.mem _z1 256)
    (h2 : Fits s.mem _z2 256) (h3 : Fits s.mem _z3 256) (h4 : Fits s.mem _z4 256) :
    fd_r52x5_quad_mul_fast.call
        (fd_r52x5_quad_mul_fast.args (.value _z0) (.value _z1) (.value _z2) (.value _z3)
          (.value _z4) (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4)
          (Ty.wrap Y.P0) (Ty.wrap Y.P1) (Ty.wrap Y.P2) (Ty.wrap Y.P3) (Ty.wrap Y.P4))
        s =
      .value
        (.nil,
          { s with
            mem := s.mem.storeTmp5 _z0 _z1 _z2 _z3 _z4 (fd_r52x5_quad_mul_fast.spec X Y) }) := by
  func_init
  block_init
  iterate 4 step_pure
  -- the low halves
  step_pure with z0_1
  step_pure
  step_pure with z1_1
  iterate 2 step_pure
  step_pure with z2_1
  iterate 3 step_pure
  step_pure with z3_1
  iterate 4 step_pure
  step_pure with z4_1
  iterate 3 step_pure
  step_pure with z5_1
  iterate 2 step_pure
  step_pure with z6_1
  step_pure
  step_pure with z7_1
  -- the high halves
  step_pure with z1_2
  step_pure
  step_pure with z2_2
  iterate 2 step_pure
  step_pure with z3_2
  iterate 3 step_pure
  step_pure with z4_2
  iterate 4 step_pure
  step_pure with z5_2
  iterate 3 step_pure
  step_pure with z6_2
  iterate 2 step_pure
  step_pure with z7_2
  step_pure
  step_pure with z8_2
  step_pure with z9_2
  -- z5 … z9
  step_pure
  step_pure with z5
  step_pure
  step_pure with z6
  step_pure
  step_pure with z7
  step_pure
  step_pure with z8
  step_pure with z9
  -- the fold by 19
  step_pure
  step_pure
  step_pure with z1_2'
  step_pure
  step_pure with z2_2'
  step_pure
  step_pure with z3_2'
  step_pure with z0_1'
  step_pure with z1_1'
  step_pure with z1_2''
  step_pure with z2_1'
  step_pure with z2_2''
  step_pure with z3_1'
  step_pure with z3_2''
  step_pure with z4_1'
  step_pure with z4_2'
  step_pure with t0
  step_pure with t01
  step_pure with z0_2
  step_pure
  step_pure with z4_2''
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
  rw [wl_add_shl_one] at hz5 hz6 hz7 hr0 hr1 hr2 hr3 hr4
  rw [wl_add_madd52lo] at hz8
  rw [wl_shl_one] at hz9
  rw [wl_madd52lo_eq_add] at ht01
  clear hArgs hE
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.R52x5
