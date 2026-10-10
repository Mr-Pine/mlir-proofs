module

public import MLIR.Run.Tactic
public import Firedancer.Common.Limbs
public import Firedancer.Ref.Mlir.fiat_25519_add

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `x + y` limbwise, without carrying, in the program's operand order. -/
def fiat_25519_add.spec (x y : Fin 5 → BitVec 64) : Fin 5 → BitVec 64
  | k => y k + x k

end

/-! ## Proof -/

section Proof

/-- `fiat_25519_add` stores `spec x y` at `out`. The loads all come before the stores, so `out` may
alias `x` or `y`. -/
public theorem fiat_25519_add.call_eq (out x y : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (hx : s.mem.LimbsFit x) (hy : s.mem.LimbsFit y) :
    fiat_25519_add.call (fiat_25519_add.args (.value out) (.value x) (.value y)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs out
                (fiat_25519_add.spec (s.mem.readLimbs x) (s.mem.readLimbs y)) }) := by
  func_init
  block_init
  step_load
  step_load
  step_pure
  iterate 4 
    step_pure
    step_load
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
