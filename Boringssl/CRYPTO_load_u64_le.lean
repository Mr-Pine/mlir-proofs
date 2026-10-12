module

public import MLIR.Run.Tactic
public import Boringssl.OPENSSL_memcpy
public import Boringssl.Mlir.CRYPTO_load_u64_le

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

/-- `CRYPTO_load_u64_le` returns the 64 bits at `p`, copied through a temporary whose block
counts. -/
public theorem CRYPTO_load_u64_le.call_eq (p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hp : Fits s.mem p 64) :
    CRYPTO_load_u64_le.call (CRYPTO_load_u64_le.args (.value p)) s =
      .value
        (.cons (.value (s.mem.readAt p 64)) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩, mem := s.mem }) := by
  func_init
  block_init
  step_pure
  step_pure
  step_alloca with v
  step_pure
  step_call using OPENSSL_memcpy.call_eq
  step_load
  step_pure
  finish_block
  subst hS hv4
  erase_frame
  rfl

end Proof

end MLIR.Boringssl
