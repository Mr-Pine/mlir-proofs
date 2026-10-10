module

public import Firedancer.Ref.fiat_25519_carry_mul

meta import Firedancer.Ref.fiat_25519_carry_mul

namespace MLIR.Firedancer.Ref

private def out : Pointer :=
  ⟨⟨0⟩, 0⟩

private def a : Pointer :=
  ⟨⟨1⟩, 0⟩

private def b : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Three 40-byte blocks: `out` zeroed, `a` and `b` holding `aBytes` and `bBytes`. -/
private def state (aBytes bBytes : BitVec 320) : GlobalState :=
  ⟨⟨3⟩,
    ⟨Std.ExtHashMap.ofList
        [(⟨0⟩, .ofBytes 40 0), (⟨1⟩, .ofBytes 40 aBytes), (⟨2⟩, .ofBytes 40 bBytes)]⟩⟩

/-- Every limb `2^64 - 1`: the largest products and carries. -/
private def ones : BitVec 320 :=
  BitVec.allOnes 320

/-- Limbs `2^52 - 1, 1, 2^51, 3, 2^63`. -/
private def mixed : BitVec 320 :=
  0x8000000000000000000000000000000300080000000000000000000000000001000fffffffffffff#320

/-- The output limbs, or `none` for UB / out of fuel. -/
private def outLimbs (o x y : ⟦Ty.ptr⟧) (s : GlobalState) : Option (Fin 5 → BitVec 64) :=
  match fiat_25519_carry_mul.eval 1 (fiat_25519_carry_mul.args o x y) s with
  | .value (some .nil, s') => some (s'.mem.readLimbs out)
  | _ => none

/-- The run agrees with `spec` on `s`. -/
private def agrees (s : GlobalState) : Bool :=
  match outLimbs (.value out) (.value a) (.value b) s with
  | some r =>
    (List.finRange 5).all fun k =>
      r k == fiat_25519_carry_mul.spec (s.mem.readLimbs a) (s.mem.readLimbs b) k
  | none => false

#guard agrees (state ones ones)

#guard agrees (state mixed ones)

#guard agrees (state mixed mixed)

-- A poison pointer is UB.
#guard (outLimbs .poison (.value a) (.value b) (state mixed mixed)).isNone

end MLIR.Firedancer.Ref
