module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fiat_25519_cmovznz_u64
public import Boringssl.Mlir.fiat_25519_cmovznz_u64

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

/-- `fiat_25519_cmovznz_u64`, specialized by the compiler to `fiat_25519_to_bytes`'s one call
(`arg2 = 0`, `arg3 = 2^64 - 1`), stores Firedancer's `fiat_25519_cmovznz_u64.spec c 0 (2^64 - 1)`
at `out`. -/
public theorem fiat_25519_cmovznz_u64.call_eq (out : Pointer) (c : BitVec 8) (s : GlobalState)
    (hwf : s.WF) (hout : Room s.mem out 64) :
    fiat_25519_cmovznz_u64.call (fiat_25519_cmovznz_u64.args (.value out) (.value c)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeAt out
                (Firedancer.Ref.fiat_25519_cmovznz_u64.spec c 0 0xffffffffffffffff) }) := by
  func_init
  block_init
  step_pure
  step_pure
  step_pure
  step_store
  finish_block
  rw [hS, Firedancer.Ref.fiat_25519_cmovznz_u64.spec]
  by_cases hc : c = 0#8
  · simp [hc]
  · simp [hc, show (c != 0#8) = true from bne_iff_ne.mpr hc]

end Proof

end MLIR.Boringssl
