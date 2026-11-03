module

public import MLIR.Run.Tactic
public import Firedancer.Avx512.Common.WwlRun
public import Firedancer.Crc.Ed25519.Common.Fe
public import Firedancer.Crc.Ed25519.Avx512.Mlir.fd_r52x5_add
import Firedancer.R52x5.Common.FeLanes

namespace MLIR.Firedancer.Crc.Ed25519.Avx512

open Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

/-- `fd_r52x5_add`: `crcFold (b + a)`, the compiled operand order. -/
def fd_r52x5_add.spec (a b : Wwl) : Wwl :=
  crcFold (wwl_add b a)

end

/-! ## Proof -/

section Proof

/-- `fd_r52x5_add( a, b )` returns `spec a b`. -/
public theorem fd_r52x5_add.call_eq (a b : Wwl) (s : GlobalState) (hwf : s.WF) :
    fd_r52x5_add.call (fd_r52x5_add.args (Ty.wrap a) (Ty.wrap b)) s =
      .value (.cons (Ty.wrap (fd_r52x5_add.spec a b)) .nil, s) := by
  func_init
  block_init
  iterate 4 step_pure
  step_pure with sum
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
