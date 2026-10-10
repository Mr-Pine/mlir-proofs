module

public import MLIR.Run.Tactic
public import Agave.Serial.FieldElement51_to_bytes
public import Agave.Serial.black_box_u8
public import Agave.Serial.Mlir.FieldElement51_is_negative

namespace MLIR.Agave.Serial

/-! ## Specification -/

@[expose] public section

/-- `(bytes[0] & 1).into()` for `bytes = self.to_bytes()`. -/
abbrev FieldElement51_is_negative.spec (a : Fin 5 → BitVec 64) : BitVec 8 :=
  (FieldElement51_to_bytes.spec a).setWidth 8 &&& 1#8

end

/-! ## Proof -/

section Proof

/-- `a.is_negative()` returns `spec a`, the canonical encoding's low bit. Its slot for the bytes
and `black_box`'s are freed again: only the counter moves on, by two blocks. -/
public theorem FieldElement51_is_negative.call_eq (a : Pointer) (s : GlobalState) (hwf : s.WF)
    (ha : s.mem.LimbsFit a) :
    FieldElement51_is_negative.call (FieldElement51_is_negative.args (.value a)) s =
      .value
        (.cons (.value (FieldElement51_is_negative.spec (s.mem.readLimbs a))) .nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩, mem := s.mem }) := by
  func_init
  have ha₀ : S₀.mem.LimbsFit a := hS ▸ ha
  block_init
  step_pure
  step_pure
  step_alloca with bytes
  -- let bytes = self.to_bytes();
  step_pure
  step_call using FieldElement51_to_bytes.call_eq
  -- (bytes[0] & 1).into()
  step_load
  step_pure
  step_call using black_box_u8.call_eq
  step_pure
  finish_block
  subst hS
  erase_frame
  rfl

end Proof

end MLIR.Agave.Serial
