module

public import Agave.Serial.FieldElement51_ConditionallySelectable_conditional_assign

meta import Agave.Serial.FieldElement51_ConditionallySelectable_conditional_assign

namespace MLIR.Agave.Serial

private def out : Pointer :=
  ⟨⟨1⟩, 0⟩

private def a : Pointer :=
  ⟨⟨2⟩, 0⟩

private def b : Pointer :=
  ⟨⟨3⟩, 0⟩

/-- Block 0 free (the null pointer's); `out` an 80-byte zeroed block, `a` and `b` holding
`aBytes` and `bBytes`. -/
private def state (aBytes bBytes : BitVec 320) : GlobalState :=
  ⟨⟨4⟩,
    ⟨Std.ExtHashMap.ofList
        [(⟨1⟩, .ofBytes 80 0), (⟨2⟩, .ofBytes 40 aBytes), (⟨3⟩, .ofBytes 40 bBytes)]⟩⟩

/-- Every limb `2^64 - 1`. -/
private def ones : BitVec 320 :=
  BitVec.allOnes 320

/-- Limbs `2^52 - 1, 1, 2^51, 3, 2^63`. -/
private def mixed : BitVec 320 :=
  0x8000000000000000000000000000000300080000000000000000000000000001000fffffffffffff#320

/-- Limbs `2^54 - 1, 2^53 + 5, 0, 2^54 - 19, 12345`. -/
private def wide : BitVec 320 :=
  0x0000000000003039003fffffffffffed00000000000000000020000000000005003fffffffffffff#320

/-- The run with `choice` agrees with `spec` on `s`. -/
private def agrees (s : GlobalState) (choice : BitVec 8) : Bool :=
  match
    FieldElement51_ConditionallySelectable_conditional_assign.eval 1
      (FieldElement51_ConditionallySelectable_conditional_assign.args (.value a) (.value b)
        (.value choice))
      s with
  | .value (some .nil, s') =>
    (List.finRange 5).all fun k =>
      s'.mem.readLimbs a k ==
        FieldElement51_ConditionallySelectable_conditional_assign.spec (s.mem.readLimbs a)
          (s.mem.readLimbs b) choice k
  | _ => false

#guard agrees (state mixed wide) 0

#guard agrees (state mixed wide) 1

#guard agrees (state ones mixed) 1

end MLIR.Agave.Serial
