module

public import MLIR.Run.Tactic
public import Agave.Common.Point
public import Agave.Serial.FieldElement51_Mul_mul
public import Agave.Serial.Mlir.CompletedPoint_as_projective

namespace MLIR.Agave.Serial

/-! ## Specification -/

@[expose] public section

/-- `CompletedPoint::as_projective`: `(X T, Y Z, Z T)`. -/
def CompletedPoint_as_projective.spec (P : CompletedPoint) : ProjectivePoint :=
  ⟨FieldElement51_Mul_mul.spec P.X P.T, FieldElement51_Mul_mul.spec P.Y P.Z,
    FieldElement51_Mul_mul.spec P.Z P.T⟩

end

/-! ## Proof -/

section Proof

/-- `P.as_projective()` stores `spec P` at `out`, the `sret` slot, apart from `P`. -/
public theorem CompletedPoint_as_projective.call_eq (out p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.ProjectiveRoom out) (hp : s.mem.PointFit p) (hsep : out.id ≠ p.id) :
    CompletedPoint_as_projective.call (CompletedPoint_as_projective.args (.value out) (.value p))
        s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeProjective out
                (CompletedPoint_as_projective.spec (s.mem.readCompleted p)) }) := by
  func_init
  block_init
  step_pure
  step_call using FieldElement51_Mul_mul.call_eq
  iterate 3 step_pure
  step_call using FieldElement51_Mul_mul.call_eq
  step_pure
  step_call using FieldElement51_Mul_mul.call_eq
  finish_block
  rw [hS]
  rfl

end Proof

end MLIR.Agave.Serial
