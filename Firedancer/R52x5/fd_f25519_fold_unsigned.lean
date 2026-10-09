module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Common.Fe
public import Firedancer.R52x5.Mlir.fd_f25519_fold_unsigned

namespace MLIR.Firedancer.R52x5

open Firedancer.Avx512

/-! ## Proof -/

section Proof

/-- `fd_f25519_fold_unsigned( x )` returns `fold x`. -/
public theorem fd_f25519_fold_unsigned.call_eq (x : Wwl) (s : GlobalState) (hwf : s.WF) :
    fd_f25519_fold_unsigned.call (fd_f25519_fold_unsigned.args (Ty.wrap x)) s =
      .value (.cons (Ty.wrap (fold x)) .nil, s) := by
  func_init
  block_init
  iterate 4 step_pure
  -- the lanes split (`expandOfFn`), so the constant shifts resolve lane by lane
  step_pure [expandOfFn] with carry
  step_pure [expandOfFn] with rotated
  step_pure [expandOfFn]
  step_pure [expandOfFn]
  finish_block
  clear hArgs hE
  subst_vars
  congr 3
  simp only [fold, wwl_madd52lo, wwl_and, wwl_permute, wwl_shru_vector, foldMask, foldShift,
    foldPerm, foldScale, wwl, madd52lo, expandOfFn]
  congr 1
  simp [mlir_operation]

end Proof

end MLIR.Firedancer.R52x5
