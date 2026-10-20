module

public import MLIR.Run.Tactic
public import Firedancer.Crc.Common.Fe
public import Firedancer.Crc.Mlir.fd_r52x5_neg

namespace MLIR.Firedancer.Crc

open Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_neg`: `crcFold (16 p - a)`, the compiled operand order. -/
def fd_r52x5_neg.spec (a : Wwl) : Wwl :=
  crcFold (wwl_sub R52x5.bias16p a)

end

/-! ## Proof -/

section Proof

/-- `fd_r52x5_neg( a )` returns `spec a`. -/
public theorem fd_r52x5_neg.call_eq (a : Wwl) (s : GlobalState) (hwf : s.WF) :
    fd_r52x5_neg.call (fd_r52x5_neg.args (Ty.wrap a)) s =
      .value (.cons (Ty.wrap (fd_r52x5_neg.spec a)) .nil, s) := by
  func_init
  block_init
  iterate 5 step_pure
  step_pure [expandOfFn] with diff
  step_pure [expandOfFn] with lo
  step_pure [expandOfFn] with carry
  step_pure [expandOfFn] with rotated
  step_pure [expandOfFn]
  finish_block
  clear hArgs hE
  subst_vars
  congr 3
  simp only [fd_r52x5_neg.spec, crcFold, wwl_madd52lo, wwl_and, wwl_sub, wwl_permute, wwl_shru,
    wwl_bcast, R52x5.bias16p, R52x5.foldPerm, R52x5.foldScale, R52x5.mask51, wwl, madd52lo,
    expandOfFn]
  congr 1
  simp [mlir_operation]

end Proof

end MLIR.Firedancer.Crc
