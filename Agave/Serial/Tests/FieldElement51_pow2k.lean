module

public import Agave.Serial.FieldElement51_pow2k

meta import Agave.Serial.FieldElement51_pow2k

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

/-- `sqrN` with each pass computed once (`spec`'s own evaluation recomputes each pass's limbs at
every use: exponential in `k`). -/
private def sqrN : Nat → (Fin 5 → BitVec 64) → Fin 5 → BitVec 64
  | 0, x => x
  | n + 1, x => sqrN n (Vector.ofFn (FieldElement51_pow2k.square x)).get

/-- The run with counter `k` agrees with `sqrN` on `s`. -/
private def agreesMemo (s : GlobalState) (k : BitVec 32) : Bool :=
  match
    FieldElement51_pow2k.eval 200 (FieldElement51_pow2k.args (.value out) (.value a) (.value k))
      s with
  | .value (some .nil, s') =>
    (List.finRange 5).all fun i => s'.mem.readLimbs out i == sqrN k.toNat (s.mem.readLimbs a) i
  | _ => false

/-- The run with counter `k` agrees with `spec` on `s`. -/
private def agrees (s : GlobalState) (k : BitVec 32) : Bool :=
  match
    FieldElement51_pow2k.eval 200 (FieldElement51_pow2k.args (.value out) (.value a) (.value k))
      s with
  | .value (some .nil, s') =>
    (List.finRange 5).all fun i =>
      s'.mem.readLimbs out i == FieldElement51_pow2k.spec (s.mem.readLimbs a) k.toNat i
  | _ => false

#guard agrees (state mixed 0) 1

#guard agrees (state wide 0) 5

#guard agrees (state ones 0) 3

#guard agreesMemo (state ones 0) 100

#guard agreesMemo (state wide 0) 50

end MLIR.Agave.Serial
