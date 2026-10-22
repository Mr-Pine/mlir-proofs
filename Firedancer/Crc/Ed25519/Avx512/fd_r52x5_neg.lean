module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.WwlRun
public import Firedancer.Crc.Ed25519.Common.Fe
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_neg
import Firedancer.R52x5.Common.FeLanes

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

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
  step_pure with diff
  step_pure with lo
  step_pure with carry
  step_pure with rotated
  step_pure with folded
  finish_block
  rw [hS]
  subst_vars
  rfl

end Proof

end MLIR.Firedancer.Crc.Ed25519.Avx512
