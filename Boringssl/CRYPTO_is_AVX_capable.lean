module

public import MLIR.Run.Tactic
public import Boringssl.Mlir.CRYPTO_is_AVX_capable

namespace MLIR.Boringssl

/-! ## Specification -/

@[expose] public section

/-- `(OPENSSL_get_ia32cap(1) & (1u << 28)) != 0`: bit 28 of capability word 1. -/
noncomputable def CRYPTO_is_AVX_capable.spec : BitVec 32 :=
  OPENSSL_get_ia32cap.cap 1#32 >>> 28#32 &&& 1#32

end

/-! ## Proof -/

section Proof

/-- `CRYPTO_is_AVX_capable` returns `spec`. -/
public theorem CRYPTO_is_AVX_capable.call_eq (s : GlobalState) (hwf : s.WF) :
    CRYPTO_is_AVX_capable.call CRYPTO_is_AVX_capable.args s =
      .value (.cons (.value CRYPTO_is_AVX_capable.spec) .nil, s) := by
  func_init
  block_init
  iterate 2 step_pure
  step_call using OPENSSL_get_ia32cap.call_eq
  step_pure
  step_pure
  finish_block
  rw [hS]
  rfl

end Proof

end MLIR.Boringssl
