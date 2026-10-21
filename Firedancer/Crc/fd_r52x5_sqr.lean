module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.WwlRun
public import Firedancer.R52x5.fd_f25519_mul
public import Firedancer.Crc.Common.Fe
public import Firedancer.Crc.Mlir.fd_r52x5_sqr
import Firedancer.R52x5.Common.FeLanes

namespace MLIR.Firedancer.Crc

open Firedancer.Avx512
open R52x5 (wrap_slide_5)

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_sqr`'s `t43`: `fd_r52x5_mul`'s schedule with `b = a`, the rows `t7, t17, t23, t27`
and `t10` slid into the column sums `t31` (low) and `t37` (high), folded by `za + 19 zb`. -/
@[irreducible]
def fd_r52x5_sqr.z (a : Wwl) : Wwl :=
  let t1 := wwl_zero
  let t2 := wwl_permute (wwl_bcast 3) a
  let t3 := wwl_madd52hi t1 a t2
  let t5 := wwl_shl t3 1
  let t6 := wwl_permute (wwl_bcast 4) a
  let t7 := wwl_madd52lo t5 a t6
  let t8 := wwl_slide t1 t7 4
  let t9 := wwl_madd52hi t1 a t6
  let t10 := wwl_shl t9 1
  let t11 := wwl_slide t1 t10 3
  let t12 := wwl_add t8 t11
  let t13 := wwl_permute (wwl_bcast 0) a
  let t14 := wwl_madd52hi t1 a t13
  let t15 := wwl_shl t14 1
  let t16 := wwl_permute (wwl_bcast 1) a
  let t17 := wwl_madd52lo t15 a t16
  let t18 := wwl_slide t1 t17 7
  let t19 := wwl_madd52lo t18 a t13
  let t20 := wwl_madd52hi t1 a t16
  let t21 := wwl_shl t20 1
  let t22 := wwl_permute (wwl_bcast 2) a
  let t23 := wwl_madd52lo t21 a t22
  let t24 := wwl_slide t1 t23 6
  let t25 := wwl_madd52hi t1 a t22
  let t26 := wwl_shl t25 1
  let t27 := wwl_madd52lo t26 a t2
  let t28 := wwl_slide t1 t27 5
  let t29 := wwl_add t24 t28
  let t30 := wwl_add t19 t29
  let t31 := wwl_add t12 t30
  let t32 := wwl_if 0x1f t31 t1
  let t33 := wwl_slide t10 t1 3
  let t34 := wwl_slide t27 t1 5
  let t35 := wwl_slide t7 t1 4
  let t36 := wwl_add t34 t35
  let t37 := wwl_add t33 t36
  let t38 := wwl_slide t31 t37 5
  let t39 := wwl_add t32 t38
  let t40 := wwl_shl t38 1
  let t41 := wwl_shl t38 4
  let t42 := wwl_add t40 t41
  wwl_add t39 t42

/-- `fd_r52x5_sqr( a )`: `z` folded. -/
@[irreducible]
def fd_r52x5_sqr.spec (a : Wwl) : Wwl :=
  crcFold (fd_r52x5_sqr.z a)

end

/-! ## Proof -/

section Proof

-- folded, so the steps' terms and the spec compare without unfolding the lanes
attribute [local irreducible] wwl_add wwl_and wwl_shl wwl_shru wwl_slide wwl_if wwl_permute
  wwl_madd52lo wwl_madd52hi

/-- `fd_r52x5_sqr( a )` returns `spec a`. -/
public theorem fd_r52x5_sqr.call_eq (a : Wwl) (s : GlobalState) (hwf : s.WF) :
    fd_r52x5_sqr.call (fd_r52x5_sqr.args (Ty.wrap a)) s =
      .value (.cons (Ty.wrap (fd_r52x5_sqr.spec a)) .nil, s) := by
  rw [fd_r52x5_sqr.spec]
  func_init
  block_init
  -- the constants and the `insertelement` chains of the slides' `wwl_zero()` operands
  iterate 74 step_pure
  step_pure with t2
  step_pure with t3
  step_pure with t5
  step_pure with t6
  step_pure with t7
  step_pure with t8
  step_pure with t9
  step_pure with t10
  step_pure with t11
  step_pure with t13
  step_pure with t14
  step_pure with t15
  step_pure with t16
  step_pure with t17
  step_pure with t18
  step_pure with t19
  step_pure with t20
  step_pure with t21
  step_pure with t22
  step_pure with t23
  step_pure with t24
  step_pure with t25
  step_pure with t26
  step_pure with t27
  step_pure with t28
  -- `t31`, the low column sums, in the compiled order
  step_pure with t12
  step_pure with s1
  step_pure with s2
  step_pure with t31
  step_pure with t32
  -- `t37`, the high column sums, with lanes `5 … 7` poison
  step_pure with t33
  step_pure with t34
  step_pure with t35
  step_pure with s3
  subst ht33 ht34 ht35
  rw [ofFn_add_lanesBelow] at hs3
  step_pure with t37
  subst hs3
  rw [ofFn_add_lanesBelow] at ht37
  step_pure [ht37, lanesBelow_getElem, wrap_slide_5] with t38
  step_pure with t39
  step_pure with t42
  step_pure with t43
  -- the fold
  step_pure with t44
  step_pure with t45
  step_pure with t46
  step_pure with t48
  finish_block
  rw [hS]
  suffices e : t43 = fd_r52x5_sqr.z a by rw [ht48, ht46, ht45, ht44, e, crcFold]; rfl
  simp only [fd_r52x5_sqr.z, BitVec.ofNat_eq_ofNat]
  rw [← ht2, ← ht3, ← ht5, ← ht6, ← ht7, ← ht8, ← ht9, ← ht10, ← ht11, ← ht13, ← ht14, ← ht15,
    ← ht16, ← ht17, ← ht18, ← ht19, ← ht20, ← ht21, ← ht22, ← ht23, ← ht24, ← ht25, ← ht26, ← ht27,
    ← ht28]
  rw [ht43, ht42, ht39, ht38, ht32, ht31, hs2, hs1, ht12]
  ac_rfl

end Proof

end MLIR.Firedancer.Crc
