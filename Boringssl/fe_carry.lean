module

public import MLIR.Run.Tactic
public import Firedancer.Ref.fiat_25519_carry
public import Boringssl.Mlir.fe_carry

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

/-- `fe_carry` stores `f`, carried (`fiat_25519_carry.spec`), at `h`; `h` may alias `f`. -/
public theorem fe_carry.call_eq (h f : Pointer) (s : GlobalState) (hwf : s.WF)
    (hh : s.mem.LimbsRoom h) (hf : s.mem.LimbsFit f) :
    fe_carry.call (fe_carry.args (.value h) (.value f)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs h (Firedancer.Ref.fiat_25519_carry.spec (s.mem.readLimbs f)) }) := by
  func_init
  block_init
  step_call using Firedancer.Ref.fiat_25519_carry.call_eq
  finish_block
  rw [hS]

end Proof

end MLIR.Boringssl
