module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fd_sha512_append
public import Boringssl.sha512_avx_capable
public import Boringssl.Mlir.sha512_block_data_order

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

/-- `sha512_block_data_order` compresses the `n` 128-byte blocks at `data` into the eight words at
`st`, by the AVX or the generic assembly core: both have this effect, so the CPU capabilities do
not matter. -/
public theorem sha512_block_data_order.call_eq (st data : Pointer) (n : BitVec 64) (s : GlobalState)
    (hwf : s.WF) (hst : s.mem.Words8Fit st) (hn : n ≠ 0) (hdata : Fits s.mem data (1024 * n.toNat))
    (hdo : data.offset.toNat + 128 * n.toNat < 2 ^ 64)
    (hsep : (Range.of st 512).Disjoint (Range.of data (1024 * n.toNat))) :
    sha512_block_data_order.call (sha512_block_data_order.args (.value st) (.value data) (.value n))
        s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩,
            mem :=
              s.mem.storeWords8 st
                (Firedancer.Ref.fd_sha512_core_ref.spec (s.mem.readWords8 st)
                  (s.mem.readAt data (1024 * n.toNat))) }) := by
  func_init
  block_init
  step_pure
  step_call using sha512_avx_capable.call_eq
  step_pure
  finish_block
  · block_init
    step_call using sha512_block_data_order_nohw.call_eq
    finish_block
    block_init
    finish_block
    rw [hS, MemoryState.eraseFrom_storeWords8, hwf₀.eraseFrom]
  · block_init
    step_call using sha512_block_data_order_avx.call_eq
    finish_block
    block_init
    finish_block
    rw [hS, MemoryState.eraseFrom_storeWords8, hwf₀.eraseFrom]

end Proof

end MLIR.Boringssl
