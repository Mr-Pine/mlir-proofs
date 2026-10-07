module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Ref.Mlir.fd_memset

namespace LeanMLIR.RIR.Firedancer.Ref

/-! ## Proof -/

section Proof

/-- `fd_memset( d, 0, sz )`, the only call the lift keeps: `sz` zero bytes at `d`; returns `d`. -/
public theorem fd_memset.call_eq (d : Pointer) (sz : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (hd : Fits s.mem d (8 * sz.toNat)) :
    fd_memset.call (fd_memset.args (.value d) (.value sz)) s =
      .value
        (.cons (.value d) .nil, { s with mem := s.mem.storeAt d ((0#8).replicate sz.toNat) }) := by
  func_init
  block_init
  step_pure
  step_memset
  finish_block
  rw [hS]

end Proof

end LeanMLIR.RIR.Firedancer.Ref
