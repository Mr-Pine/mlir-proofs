module

public import MLIR.Run.Tactic
public import Agave.Serial.FieldElement51_pow2k
public import Agave.Serial.Mlir.FieldElement51_square

namespace MLIR.Agave.Serial

/-! ## Specification -/

@[expose] public section

/-- `self.pow2k(1)`. -/
abbrev FieldElement51_square.spec (a : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  FieldElement51_pow2k.spec a 1

end

/-! ## Proof -/

section Proof

/-- `a.square()` stores `spec a` at `out`; `out` may alias `a`. -/
public theorem FieldElement51_square.call_eq (out a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (ha : s.mem.LimbsFit a) :
    FieldElement51_square.call (FieldElement51_square.args (.value out) (.value a)) s =
      .value
        (.nil,
          { s with
            mem := s.mem.storeLimbs out (FieldElement51_square.spec (s.mem.readLimbs a)) }) := by
  func_init
  block_init
  step_pure
  step_call using FieldElement51_pow2k.call_eq
  finish_block
  rw [hS]

end Proof

end MLIR.Agave.Serial
