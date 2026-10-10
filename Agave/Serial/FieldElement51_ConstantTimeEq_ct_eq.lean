module

public import MLIR.Run.Tactic
public import Agave.Serial.FieldElement51_to_bytes
public import Agave.Serial.slice_u8_ConstantTimeEq_ct_eq
public import Agave.Serial.Mlir.FieldElement51_ConstantTimeEq_ct_eq

namespace MLIR.Agave.Serial

/-! ## Specification -/

@[expose] public section

/-- `self.to_bytes().ct_eq(&other.to_bytes())`. -/
abbrev FieldElement51_ConstantTimeEq_ct_eq.spec (a b : Fin 5 → BitVec 64) : BitVec 8 :=
  slice_u8_ConstantTimeEq_ct_eq.spec (FieldElement51_to_bytes.spec a)
    (FieldElement51_to_bytes.spec b)

end

/-! ## Proof -/

section Proof

/-- `a.ct_eq(&b)` returns `spec a b`, `1` iff the canonical encodings agree. Its slots for the
bytes and the comparison's are freed again: only the counter moves on, by 35 blocks. -/
public theorem FieldElement51_ConstantTimeEq_ct_eq.call_eq (a b : Pointer) (s : GlobalState)
    (hwf : s.WF) (ha : s.mem.LimbsFit a) (hb : s.mem.LimbsFit b) :
    FieldElement51_ConstantTimeEq_ct_eq.call
        (FieldElement51_ConstantTimeEq_ct_eq.args (.value a) (.value b)) s =
      .value
        (.cons
            (.value
              (FieldElement51_ConstantTimeEq_ct_eq.spec (s.mem.readLimbs a) (s.mem.readLimbs b)))
            .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 35⟩, mem := s.mem }) := by
  func_init
  have ha₀ : S₀.mem.LimbsFit a := hS ▸ ha
  have hb₀ : S₀.mem.LimbsFit b := hS ▸ hb
  block_init
  step_pure
  step_alloca with bytes_b
  step_alloca with bytes_a
  -- self.to_bytes()
  step_pure
  step_call using FieldElement51_to_bytes.call_eq
  -- other.to_bytes()
  step_pure
  step_call using FieldElement51_to_bytes.call_eq
  -- .ct_eq(…)
  step_call using slice_u8_ConstantTimeEq_ct_eq.call_eq
  step_pure
  step_pure
  finish_block
  subst hS
  erase_frame
  congr 3

end Proof

end MLIR.Agave.Serial
