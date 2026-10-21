module

public import Firedancer.Avx512.Common.WwlRun
public import Firedancer.R52x5.Common.Fe
import Mathlib.Tactic.FinCases
import Mathlib.Data.Fintype.Basic

/-! The intrinsics of `fd_f25519_mul`, `fd_r52x5_mul` and `fd_r52x5_sqr` from their lanes, as the
steps give them: the broadcasts, the slides of `zh` with lanes `5 … 7` poison, and the fold. Tagged
`mlir_operation`, so `step_pure` folds them; import this privately to keep them to the proofs that
want them. -/

namespace MLIR.Firedancer.R52x5

open Firedancer.Avx512

/-- A vector equation lane by lane. -/
local macro "vec_lanes" : tactic =>
  `(tactic|
    (apply vec_ext_fin; intro i;
      fin_cases i <;> simp [wwl_permute, wwl_bcast, wwl_slide, wwl_if, wwl_madd52lo, madd52lo,
        lanesBelow, wwl, foldPerm, foldScale]))

@[expose] public section

/-! ### The broadcasts -/

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

/-! ### `zl` and `zh` -/

/-- `wwl_if(0x1f, x, zero)`: lanes `0 … 4` of `x`. -/
@[mlir_operation]
theorem if_lanes5 (x : Wwl) :
    #v[x[0], x[1], x[2], x[3], x[4], 0#64, 0#64, 0#64] = wwl_if 0x1f x wwl_zero := by
  vec_lanes

/-- `wwl_slide(v, zero, 3)` with its lanes `5 … 7` poison. -/
@[mlir_operation]
theorem lanes5_slide_3_zero (v : Wwl) :
    #v[.value v[3], .value v[4], .value v[5], .value v[6], .value v[7], .poison, .poison, .poison] =
      lanesBelow 5 (wwl_slide v wwl_zero 3) := by
  vec_lanes

/-- `wwl_slide(v, zero, 4)` with its lanes `5 … 7` poison. -/
@[mlir_operation]
theorem lanes5_slide_4_zero (v : Wwl) :
    #v[.value v[4], .value v[5], .value v[6], .value v[7], .value 0#64, .poison, .poison, .poison] =
      lanesBelow 5 (wwl_slide v wwl_zero 4) := by
  vec_lanes

/-- `wwl_slide(v, zero, 5)` with its lanes `5 … 7` poison. -/
@[mlir_operation]
theorem lanes5_slide_5_zero (v : Wwl) :
    #v[.value v[5], .value v[6], .value v[7], .value 0#64, .value 0#64, .poison, .poison, .poison] =
      lanesBelow 5 (wwl_slide v wwl_zero 5) := by
  vec_lanes

/-! ### The fold -/

/-- `wwl_and(x, wwl_bcast(c))` as a step gives it. -/
@[mlir_operation]
theorem ofFn_and_bcast (x : Wwl) (c : BitVec 64) :
    (Vector.ofFn fun i : Fin 8 => x[i.1] &&& c) = wwl_and x (wwl_bcast c) := by
  simp [wwl_and, wwl_bcast]

/-- `wwl_shru(x, n)` as a step gives it. -/
@[mlir_operation]
theorem ofFn_shru (x : Wwl) (n : Nat) :
    (Vector.ofFn fun i : Fin 8 => x[i.1] >>> n) = wwl_shru x n := by
  simp [wwl_shru]

/-- The fold's rotation of the carries. -/
@[mlir_operation]
theorem permute_fold (v : Wwl) :
    #v[v[4], v[0], v[1], v[2], v[3], v[5], v[6], v[7]] = wwl_permute foldPerm v := by
  vec_lanes

/-- The fold's `wwl_madd52lo(a, x, wwl(19, 1, 1, 1, 1, 0, 0, 0))` as a step gives it. -/
@[mlir_operation]
theorem ofFn_madd52lo_scale (a x : Wwl) :
    (Vector.ofFn fun i : Fin 8 =>
        a[i.1] +
          ((x[i.1] &&& 4503599627370495#64) *
              ([19#64, 1#64, 1#64, 1#64, 1#64, 0#64, 0#64, 0#64][i.1] &&& 4503599627370495#64) &&&
            4503599627370495#64)) =
      wwl_madd52lo a x foldScale := by
  vec_lanes

end

end MLIR.Firedancer.R52x5
