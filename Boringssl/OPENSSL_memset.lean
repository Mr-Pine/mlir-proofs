module

public import MLIR.Run.Tactic
public import Boringssl.Common.Memory
public import Boringssl.Mlir.OPENSSL_memset

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

/-- `OPENSSL_memset` stores `n` copies of `c`'s low byte at `dst` (nothing for `n = 0`) and
returns `dst`. -/
public theorem OPENSSL_memset.call_eq (dst : Pointer) (c : BitVec 32) (n : BitVec 64)
    (s : GlobalState) (hwf : s.WF) (hdst : Room s.mem dst (8 * n.toNat)) :
    OPENSSL_memset.call (OPENSSL_memset.args (.value dst) (.value c) (.value n)) s =
      .value
        (.cons (.value dst) .nil,
          { s with mem := s.mem.storeAt dst ((c.setWidth 8).replicate n.toNat) }) := by
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
    step_pure
    step_memset
    finish_block
    block_init
    finish_block
    rw [hS]

end Proof

end MLIR.Boringssl
