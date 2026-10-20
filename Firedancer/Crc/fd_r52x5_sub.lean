module

public import MLIR.Run.Tactic
public import Firedancer.Crc.Common.Fe
public import Firedancer.Crc.Mlir.fd_r52x5_sub

namespace MLIR.Firedancer.Crc

open Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_sub`: `crcFold ((a - b) + 16 p)`, the compiled operand order. -/
def fd_r52x5_sub.spec (a b : Wwl) : Wwl :=
  crcFold (wwl_add (wwl_sub a b) R52x5.bias16p)

end

/-! ## Proof -/

section Proof

/-- `fd_r52x5_sub( a, b )` returns `spec a b`. -/
public theorem fd_r52x5_sub.call_eq (a b : Wwl) (s : GlobalState) (hwf : s.WF) :
    fd_r52x5_sub.call (fd_r52x5_sub.args (Ty.wrap a) (Ty.wrap b)) s =
      .value (.cons (Ty.wrap (fd_r52x5_sub.spec a b)) .nil, s) := by
  func_init
  block_init
  iterate 5 step_pure
  step_pure [expandOfFn] with diff
  step_pure [expandOfFn] with sum
  step_pure [expandOfFn] with lo
  step_pure [expandOfFn] with carry
  step_pure [expandOfFn] with rotated
  step_pure [expandOfFn]
  finish_block
  clear hArgs hE
  subst_vars
  congr 3
  simp only [fd_r52x5_sub.spec, crcFold, wwl_madd52lo, wwl_and, wwl_add, wwl_sub, wwl_permute,
    wwl_shru, wwl_bcast, R52x5.bias16p, R52x5.foldPerm, R52x5.foldScale, R52x5.mask51, wwl,
    madd52lo, expandOfFn]
  congr 1
  simp [mlir_operation]

end Proof

end MLIR.Firedancer.Crc
