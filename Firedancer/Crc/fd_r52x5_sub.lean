module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.WwlRun
public import Firedancer.Crc.Common.Fe
public import Firedancer.Crc.Mlir.fd_r52x5_sub
import Mathlib.Tactic.FinCases
import Mathlib.Data.Fintype.Basic

namespace MLIR.Firedancer.Crc

open Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_sub`: `crcFold ((a - b) + 16 p)`, the compiled operand order. -/
def fd_r52x5_sub.spec (a b : Wwl) : Wwl :=
  crcFold (wwl_add (wwl_sub a b) R52x5.bias16p)

end

@[mlir_const]
def bias16pV : Wwl :=
  #v[0x7ffffffffffed0, 0x7ffffffffffff0, 0x7ffffffffffff0, 0x7ffffffffffff0, 0x7ffffffffffff0, 0, 0, 0]

@[mlir_const]
def lo_mask : Wwl := Vector.replicate 8 2251799813685247#64

@[mlir_const]
def shift_51 : Wwl := Vector.replicate 8 51#64

@[mlir_const]
def t7 : Wwl := #v[19#64, 1#64, 1#64, 1#64, 1#64, 0#64, 0#64, 0#64]

@[mlir_operation]
theorem permute_rot_front_5 (v : Wwl) :
    #v[v[4], v[0], v[1], v[2], v[3], v[5], v[6], v[7]] = wwl_permute #v[4#64, 0#64, 1#64, 2#64, 3#64, 5#64, 6#64, 7#64] v := by
  apply vec_ext_fin
  intro i
  fin_cases i <;> simp [wwl_permute]


/-- `wwl_madd52lo(a, x, y)` as a step gives it. -/
@[mlir_operation]
theorem ofFn_madd52lo (a x y : Wwl) :
    (Vector.ofFn fun i : Fin 8 =>
        a[i.1] +
          ((x[i.1] &&& 4503599627370495#64) * (y[i.1] &&& 4503599627370495#64) &&&
            4503599627370495#64)) =
      wwl_madd52lo a x y := by
  ext i hi : 1; simp [wwl_madd52lo, madd52lo]

/-! ## Proof -/

section Proof

/-- `fd_r52x5_sub( a, b )` returns `spec a b`. -/
public theorem fd_r52x5_sub.call_eq (a b : Wwl) (s : GlobalState) (hwf : s.WF) :
    fd_r52x5_sub.call (fd_r52x5_sub.args (Ty.wrap a) (Ty.wrap b)) s =
      .value (.cons (Ty.wrap (fd_r52x5_sub.spec a b)) .nil, s) := by
  func_init
  block_init
  -- Constants
  iterate 5 step_pure
  step_pure
  step_pure with sum
  step_pure with lo
  step_pure [shift_51] with carry
  step_pure with rotated
  step_pure with t8
  finish_block
  clear hArgs hE
  subst_vars
  congr 3

end Proof

end MLIR.Firedancer.Crc
