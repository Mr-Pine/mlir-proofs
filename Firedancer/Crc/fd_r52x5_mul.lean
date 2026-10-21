module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.WwlRun
public import Firedancer.R52x5.fd_f25519_mul
public import Firedancer.Crc.Common.Fe
public import Firedancer.Crc.Mlir.fd_r52x5_mul
import Mathlib.Tactic.FinCases
import Mathlib.Data.Fintype.Basic

namespace MLIR.Firedancer.Crc

open Firedancer.Avx512
open R52x5 (foldPerm foldScale mask51 ofFn_madd52hi ofFn_madd52lo ofFn_mul18 wrap_slide_5)

/-- A vector equation lane by lane. -/
local macro "vec_lanes" : tactic =>
  `(tactic|
    (apply vec_ext_fin; intro i;
      fin_cases i <;> simp [wwl_permute, wwl_bcast, wwl_slide, wwl_if, wwl_shru, wwl_madd52lo,
        madd52lo, lanesBelow, wwl, R52x5.foldPerm, R52x5.foldScale]))

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_mul`'s `t43`, in the generated source's order: the rows `t7, t17, t23, t27` (low
halves on the doubled high halves of the previous row) and `t10`, slid into the column sums
`t31` (low) and `t37` (high), folded by `za + 19 zb`. -/
@[irreducible]
def fd_r52x5_mul.z (a b : Wwl) : Wwl :=
  let t1 := wwl_zero
  let t2 := wwl_permute (wwl_bcast 3) a
  let t3 := wwl_madd52hi t1 b t2
  let t5 := wwl_shl t3 1
  let t6 := wwl_permute (wwl_bcast 4) a
  let t7 := wwl_madd52lo t5 b t6
  let t8 := wwl_slide t1 t7 4
  let t9 := wwl_madd52hi t1 b t6
  let t10 := wwl_shl t9 1
  let t11 := wwl_slide t1 t10 3
  let t12 := wwl_add t8 t11
  let t13 := wwl_permute (wwl_bcast 0) a
  let t14 := wwl_madd52hi t1 b t13
  let t15 := wwl_shl t14 1
  let t16 := wwl_permute (wwl_bcast 1) a
  let t17 := wwl_madd52lo t15 b t16
  let t18 := wwl_slide t1 t17 7
  let t19 := wwl_madd52lo t18 b t13
  let t20 := wwl_madd52hi t1 b t16
  let t21 := wwl_shl t20 1
  let t22 := wwl_permute (wwl_bcast 2) a
  let t23 := wwl_madd52lo t21 b t22
  let t24 := wwl_slide t1 t23 6
  let t25 := wwl_madd52hi t1 b t22
  let t26 := wwl_shl t25 1
  let t27 := wwl_madd52lo t26 b t2
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

/-- `fd_r52x5_mul( a, b )`: `z` folded. -/
@[irreducible]
def fd_r52x5_mul.spec (a b : Wwl) : Wwl :=
  crcFold (fd_r52x5_mul.z a b)

end

/-! ## Lanes as the steps give them -/

namespace fd_r52x5_mul

@[mlir_operation]
theorem permute_bcast_0 (v : Wwl) :
    #v[v[0], v[0], v[0], v[0], v[0], v[0], v[0], v[0]] = wwl_permute (wwl_bcast 0) v := by
  vec_lanes

@[mlir_operation]
theorem permute_bcast_1 (v : Wwl) :
    #v[v[1], v[1], v[1], v[1], v[1], v[1], v[1], v[1]] = wwl_permute (wwl_bcast 1) v := by
  vec_lanes

@[mlir_operation]
theorem permute_bcast_2 (v : Wwl) :
    #v[v[2], v[2], v[2], v[2], v[2], v[2], v[2], v[2]] = wwl_permute (wwl_bcast 2) v := by
  vec_lanes

@[mlir_operation]
theorem permute_bcast_3 (v : Wwl) :
    #v[v[3], v[3], v[3], v[3], v[3], v[3], v[3], v[3]] = wwl_permute (wwl_bcast 3) v := by
  vec_lanes

@[mlir_operation]
theorem permute_bcast_4 (v : Wwl) :
    #v[v[4], v[4], v[4], v[4], v[4], v[4], v[4], v[4]] = wwl_permute (wwl_bcast 4) v := by
  vec_lanes

/-- `wwl_if(0x1f, x, zero)`: lanes `0 … 4` of `x`. -/
theorem if_lanes5 (x : Wwl) :
    #v[x[0], x[1], x[2], x[3], x[4], 0#64, 0#64, 0#64] = wwl_if 0x1f x wwl_zero := by
  vec_lanes

/-- `wwl_slide(v, zero, 3)` with its lanes `5 … 7` poison. -/
theorem lanes5_slide_3_zero (v : Wwl) :
    #v[.value v[3], .value v[4], .value v[5], .value v[6], .value v[7], .poison, .poison, .poison] =
      lanesBelow 5 (wwl_slide v wwl_zero 3) := by
  vec_lanes

/-- `wwl_slide(v, zero, 4)` with its lanes `5 … 7` poison. -/
theorem lanes5_slide_4_zero (v : Wwl) :
    #v[.value v[4], .value v[5], .value v[6], .value v[7], .value 0#64, .poison, .poison, .poison] =
      lanesBelow 5 (wwl_slide v wwl_zero 4) := by
  vec_lanes

/-- `wwl_slide(v, zero, 5)` with its lanes `5 … 7` poison. -/
theorem lanes5_slide_5_zero (v : Wwl) :
    #v[.value v[5], .value v[6], .value v[7], .value 0#64, .value 0#64, .poison, .poison, .poison] =
      lanesBelow 5 (wwl_slide v wwl_zero 5) := by
  vec_lanes

/-- `wwl_and(x, wwl_bcast(c))` as a step gives it. -/
theorem ofFn_and_bcast (x : Wwl) (c : BitVec 64) :
    (Vector.ofFn fun i : Fin 8 => x[i.1] &&& c) = wwl_and x (wwl_bcast c) := by
  simp [wwl_and, wwl_bcast]

/-- `wwl_shru(x, n)` as a step gives it. -/
theorem ofFn_shru (x : Wwl) (n : Nat) :
    (Vector.ofFn fun i : Fin 8 => x[i.1] >>> n) = wwl_shru x n := by
  simp [wwl_shru]

/-- The fold's rotation of the carries. -/
theorem permute_fold (v : Wwl) :
    #v[v[4], v[0], v[1], v[2], v[3], v[5], v[6], v[7]] = wwl_permute foldPerm v := by
  vec_lanes

/-- The fold's `wwl_madd52lo(a, x, wwl(19, 1, 1, 1, 1, 0, 0, 0))` as a step gives it. -/
theorem ofFn_madd52lo_scale (a x : Wwl) :
    (Vector.ofFn fun i : Fin 8 =>
        a[i.1] +
          ((x[i.1] &&& 4503599627370495#64) *
              ([19#64, 1#64, 1#64, 1#64, 1#64, 0#64, 0#64, 0#64][i.1] &&& 4503599627370495#64) &&&
            4503599627370495#64)) =
      wwl_madd52lo a x foldScale := by
  vec_lanes

end fd_r52x5_mul

/-! ## Proof -/

section Proof

-- folded, so the steps' terms and the spec compare without unfolding the lanes
attribute [local irreducible] wwl_add wwl_and wwl_shl wwl_shru wwl_slide wwl_if wwl_permute
  wwl_madd52lo wwl_madd52hi

open fd_r52x5_mul in
/-- `fd_r52x5_mul( a, b )` returns `spec a b`. -/
public theorem fd_r52x5_mul.call_eq (a b : Wwl) (s : GlobalState) (hwf : s.WF) :
    fd_r52x5_mul.call (fd_r52x5_mul.args (Ty.wrap a) (Ty.wrap b)) s =
      .value (.cons (Ty.wrap (fd_r52x5_mul.spec a b)) .nil, s) := by
  rw [fd_r52x5_mul.spec]
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
  rw [if_lanes5] at ht32
  -- `t37`, the high column sums, with lanes `5 … 7` poison
  step_pure with t33
  rw [lanes5_slide_3_zero] at ht33
  step_pure with t34
  rw [lanes5_slide_5_zero] at ht34
  step_pure with t35
  rw [lanes5_slide_4_zero] at ht35
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
  rw [ofFn_mul18] at ht42
  -- the fold
  step_pure with t44
  rw [ofFn_and_bcast] at ht44
  step_pure with t45
  rw [ofFn_shru] at ht45
  step_pure with t46
  rw [permute_fold] at ht46
  step_pure with t48
  rw [ofFn_madd52lo_scale] at ht48
  finish_block
  rw [hS]
  suffices e : t43 = fd_r52x5_mul.z a b by rw [ht48, ht46, ht45, ht44, e, crcFold]; rfl
  simp only [fd_r52x5_mul.z, BitVec.ofNat_eq_ofNat]
  rw [← ht2, ← ht3, ← ht5, ← ht6, ← ht7, ← ht8, ← ht9, ← ht10, ← ht11, ← ht13, ← ht14, ← ht15,
    ← ht16, ← ht17, ← ht18, ← ht19, ← ht20, ← ht21, ← ht22, ← ht23, ← ht24, ← ht25, ← ht26, ← ht27,
    ← ht28]
  rw [ht43, ht42, ht39, ht38, ht32, ht31, hs2, hs1, ht12]
  ac_rfl

end Proof

end MLIR.Firedancer.Crc
