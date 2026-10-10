module

public import MLIR.Run.Tactic
public import Firedancer.R52x5.Mlir.fd_memcpy

namespace MLIR.Firedancer.R52x5

/-! ## Proof -/

section Proof

/-- `fd_memcpy` copies the `sz` bytes at `src` to `d`; the two ranges must not overlap
(`FD_RESTRICT`). -/
public theorem fd_memcpy.call_eq (d src : Pointer) (sz : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (hd : Room s.mem d (8 * sz.toNat)) (hsrc : Fits s.mem src (8 * sz.toNat))
    (hsep : (Range.of d (8 * sz.toNat)).Disjoint (Range.of src (8 * sz.toNat))) :
    fd_memcpy.call (fd_memcpy.args (.value d) (.value src) (.value sz)) s =
      .value (.nil, { s with mem := s.mem.storeAt d (s.mem.readAt src (8 * sz.toNat)) }) := by
  func_init
  block_init
  step_memcpy
  finish_block
  rw [hS]

end Proof

end MLIR.Firedancer.R52x5
