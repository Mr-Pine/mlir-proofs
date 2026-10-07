module

public import SSA.Projects.RIR.Run.Tactic
public import Firedancer.Ref.Mlir.fd_memcpy

namespace LeanMLIR.RIR.Firedancer.Ref

/-! ## Proof -/

section Proof

/-- `fd_memcpy` copies the `sz` bytes at `src` to `d` and returns `d`; the two ranges must not
overlap (`FD_RESTRICT`). -/
public theorem fd_memcpy.call_eq (d src : Pointer) (sz : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (hd : Fits s.mem d (8 * sz.toNat)) (hsrc : Fits s.mem src (8 * sz.toNat))
    (hsep : (Range.of d (8 * sz.toNat)).Disjoint (Range.of src (8 * sz.toNat))) :
    fd_memcpy.call (fd_memcpy.args (.value d) (.value src) (.value sz)) s =
      .value
        (.cons (.value d) .nil,
          { s with mem := s.mem.storeAt d (s.mem.readAt src (8 * sz.toNat)) }) := by
  func_init
  block_init
  step_memcpy
  finish_block
  rw [hS]

end Proof

end LeanMLIR.RIR.Firedancer.Ref
