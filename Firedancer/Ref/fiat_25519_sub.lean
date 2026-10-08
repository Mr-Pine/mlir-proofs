module

public import SSA.Projects.RIR.Run.Tactic
public import Common.Limbs
public import Firedancer.Ref.Mlir.fiat_25519_sub

namespace LeanMLIR.RIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `x + 2p - y` limbwise, without carrying: `2p`'s limbs are `2^52 - 38` and `2^52 - 2`. -/
def fiat_25519_sub.spec (x y : Fin 5 → BitVec 64) : Fin 5 → BitVec 64
  | ⟨0, _⟩ => (x 0 + 4503599627370458#64) - y 0
  | k => (x k + 4503599627370494#64) - y k

end

/-! ## Proof -/

section Proof

/-- `fiat_25519_sub` stores `spec x y` limbwise at `out`. The loads all come before the stores, so `out`
may alias `x` or `y`. -/
public theorem fiat_25519_sub.call_eq (out x y : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsFit out) (hx : s.mem.LimbsFit x) (hy : s.mem.LimbsFit y) :
    fiat_25519_sub.call (fiat_25519_sub.args (.value out) (.value x) (.value y)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs out
                (fiat_25519_sub.spec (s.mem.readLimbs x) (s.mem.readLimbs y)) }) := by
  func_init
  block_init
  iterate 2 step_pure
  step_load
  step_pure
  step_load
  step_pure
  iterate 4 
    step_pure
    step_load
    step_pure
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

end LeanMLIR.RIR.Firedancer.Ref
