module

public import MLIR.Run.Tactic
public import Firedancer.Common.Limbs
public import Firedancer.Ref.Mlir.fiat_25519_opp

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `2p - x` limbwise, without carrying: `2p`'s limbs are `2^52 - 38` and `2^52 - 2`. -/
def fiat_25519_opp.spec (x : Fin 5 → BitVec 64) : Fin 5 → BitVec 64
  | ⟨0, _⟩ => 4503599627370458#64 - x 0
  | k => 4503599627370494#64 - x k

end

/-! ## Proof -/

section Proof

/-- `opp` stores `2p - x` limbwise at `out`. The loads all come before the stores, so `out` may
alias `x`. -/
public theorem fiat_25519_opp.call_eq (out x : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsFit out) (hx : s.mem.LimbsFit x) :
    fiat_25519_opp.call (fiat_25519_opp.args (.value out) (.value x)) s =
      .value
        (.nil,
          { s with mem := s.mem.storeLimbs out (fiat_25519_opp.spec (s.mem.readLimbs x)) }) := by
  func_init
  block_init
  iterate 2 step_pure
  step_load
  step_pure
  iterate 4 
    step_pure
    step_load
    step_pure
  step_store
  iterate 4 
    step_pure
    step_store
  finish_block
  rw [hS, MemoryState.storeLimbs]
  congr

end Proof

end MLIR.Firedancer.Ref
