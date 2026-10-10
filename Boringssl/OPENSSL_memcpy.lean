module

public import MLIR.Run.Tactic
public import Boringssl.Common.Memory
public import Boringssl.Mlir.OPENSSL_memcpy

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

/-- `OPENSSL_memcpy` copies the `n` bytes at `src` to `dst` (nothing for `n = 0`) and returns
`dst`; the two ranges must not overlap. -/
public theorem OPENSSL_memcpy.call_eq (dst src : Pointer) (n : BitVec 64) (s : GlobalState)
    (hwf : s.WF) (hdst : Room s.mem dst (8 * n.toNat)) (hsrc : Fits s.mem src (8 * n.toNat))
    (hsep : (Range.of dst (8 * n.toNat)).Disjoint (Range.of src (8 * n.toNat))) :
    OPENSSL_memcpy.call (OPENSSL_memcpy.args (.value dst) (.value src) (.value n)) s =
      .value
        (.cons (.value dst) .nil,
          { s with mem := s.mem.storeAt dst (s.mem.readAt src (8 * n.toNat)) }) := by
  func_init
  block_init
  step_pure
  step_pure
  finish_block
  · subst hbr
    block_init
    finish_block
    rw [hS, MemoryState.storeAt_of_width_zero rfl]
  · block_init
    step_memcpy
    finish_block
    block_init
    finish_block
    rw [hS]

end Proof

end MLIR.Boringssl
