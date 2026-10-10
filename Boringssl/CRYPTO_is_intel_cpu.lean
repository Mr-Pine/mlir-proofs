module

public import MLIR.Run.Tactic
public import Boringssl.Mlir.CRYPTO_is_intel_cpu

namespace MLIR.Boringssl

/-! ## Specification -/

@[expose] public section

/-- `(OPENSSL_get_ia32cap(0) & (1u << 30)) != 0`: bit 30 of capability word 0. -/
noncomputable def CRYPTO_is_intel_cpu.spec : BitVec 32 :=
  OPENSSL_get_ia32cap.cap 0#32 >>> 30#32 &&& 1#32

end

/-! ## Proof -/

section Proof

/-- `CRYPTO_is_intel_cpu` returns `spec`. -/
public theorem CRYPTO_is_intel_cpu.call_eq (s : GlobalState) (hwf : s.WF) :
    CRYPTO_is_intel_cpu.call CRYPTO_is_intel_cpu.args s =
      .value (.cons (.value CRYPTO_is_intel_cpu.spec) .nil, s) := by
  func_init
  block_init
  iterate 3 step_pure
  step_call using OPENSSL_get_ia32cap.call_eq
  step_pure
  step_pure
  finish_block
  rw [hS]
  rfl

end Proof

end MLIR.Boringssl
