module

public import MLIR.Run.Tactic
public import Boringssl.fiat_25519_opp
public import Boringssl.Mlir.fe_neg

namespace MLIR.Boringssl

/-! ## Proof -/

section Proof

/-- `fe_neg` stores `-f`, not carried (`fiat_25519_opp.spec`), at `h`; `h` may alias `f`. -/
public theorem fe_neg.call_eq (h f : Pointer) (s : GlobalState) (hwf : s.WF)
    (hh : s.mem.LimbsRoom h) (hf : s.mem.LimbsFit f) :
    fe_neg.call (fe_neg.args (.value h) (.value f)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs h (Firedancer.Ref.fiat_25519_opp.spec (s.mem.readLimbs f)) }) := by
  func_init
  block_init
  step_call using fiat_25519_opp.call_eq
  finish_block
  rw [hS]

end Proof

end MLIR.Boringssl
