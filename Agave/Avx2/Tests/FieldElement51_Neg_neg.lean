module

public import Agave.Avx2.FieldElement51_Neg_neg

meta import Agave.Avx2.FieldElement51_Neg_neg

namespace MLIR.Agave.Avx2

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

/-- The run agrees with `spec` on `s`. -/
private def agrees (s : GlobalState) : Bool :=
  match FieldElement51_Neg_neg.eval 10 (FieldElement51_Neg_neg.args (.value out) (.value a)) s with
  | .value (some .nil, s') =>
    (List.finRange 5).all fun k =>
      s'.mem.readLimbs out k == Serial.FieldElement51_Neg_neg.spec (s.mem.readLimbs a) k
  | _ => false

#guard agrees (state ones 0)

#guard agrees (state mixed 0)

#guard agrees (state wide 0)

/-- The run with `out = a` agrees with `spec` on `s`. -/
private def agreesAliased (s : GlobalState) : Bool :=
  match FieldElement51_Neg_neg.eval 1 (FieldElement51_Neg_neg.args (.value a) (.value a)) s with
  | .value (some .nil, s') =>
    (List.finRange 5).all fun k =>
      s'.mem.readLimbs a k == Serial.FieldElement51_Neg_neg.spec (s.mem.readLimbs a) k
  | _ => false

#guard agreesAliased (state mixed 0)

#guard agreesAliased (state wide 0)

end MLIR.Agave.Avx2
