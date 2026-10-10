module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Mlir.fd_memset

namespace MLIR.Firedancer.R52x5

/-! ## Proof -/

section Proof

/-- `fd_memset( d, 0, sz )`, the only call the lift keeps: `sz` zero bytes at `d`. -/
public theorem fd_memset.call_eq (d : Pointer) (sz : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (hd : Room s.mem d (8 * sz.toNat)) :
    fd_memset.call (fd_memset.args (.value d) (.value sz)) s =
      .value (.nil, { s with mem := s.mem.storeAt d ((0#8).replicate sz.toNat) }) := by
  func_init
  block_init
  step_pure
  step_memset
  finish_block
  rw [hS]

end Proof

end MLIR.Firedancer.R52x5
