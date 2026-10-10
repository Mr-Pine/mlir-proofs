module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fd_ulong_bswap
public import Boringssl.OPENSSL_memcpy
public import Boringssl.Mlir.CRYPTO_store_u64_be

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

/-- `CRYPTO_store_u64_be` stores `v` big-endian (`fd_ulong_bswap.spec v`) in the 8 bytes at
`out`, through a stack copy; its slot leaves one block counted. -/
public theorem CRYPTO_store_u64_be.call_eq (out : Pointer) (v : BitVec 64) (s : GlobalState)
    (hwf : s.WF) (hout : Room s.mem out 64) :
    CRYPTO_store_u64_be.call (CRYPTO_store_u64_be.args (.value out) (.value v)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1⟩,
            mem := s.mem.storeAt out (Firedancer.Ref.fd_ulong_bswap.spec v) }) := by
  func_init
  block_init
  step_pure
  step_pure
  step_alloca with t
  step_call using Firedancer.Ref.fd_ulong_bswap.call_eq
  step_store
  step_call using OPENSSL_memcpy.call_eq
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Boringssl
