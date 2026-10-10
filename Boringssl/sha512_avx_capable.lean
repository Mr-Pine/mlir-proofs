module

public import MLIR.Run.Tactic
public import Boringssl.CRYPTO_is_intel_cpu
public import Boringssl.CRYPTO_is_AVX_capable
public import Boringssl.Mlir.sha512_avx_capable

namespace MLIR.Boringssl

/-! ## Specification -/

@[expose] public section

/-- `CRYPTO_is_AVX_capable() && CRYPTO_is_intel_cpu()`. -/
noncomputable def sha512_avx_capable.spec : BitVec 32 :=
  if CRYPTO_is_AVX_capable.spec = 0#32 then 0#32
  else (BitVec.ofBool (CRYPTO_is_intel_cpu.spec ≠ 0#32)).setWidth 32

end

/-! ## Proof -/

section Proof

/-- `sha512_avx_capable` returns `spec`. -/
public theorem sha512_avx_capable.call_eq (s : GlobalState) (hwf : s.WF) :
    sha512_avx_capable.call sha512_avx_capable.args s =
      .value (.cons (.value sha512_avx_capable.spec) .nil, s) := by
  func_init
  block_init
  step_pure
  step_call using CRYPTO_is_AVX_capable.call_eq
  step_pure
  finish_block
  · block_init
    finish_block
    rw [hS, sha512_avx_capable.spec, ite_eq_left hbr]
  · block_init
    step_call using CRYPTO_is_intel_cpu.call_eq
    step_pure
    step_pure
    finish_block
    block_init
    finish_block
    rw [hS, sha512_avx_capable.spec, ite_eq_right hbr]
    rfl

end Proof

end MLIR.Boringssl
