module

public import Firedancer.Ref.fiat_25519_carry_square

meta import Firedancer.Ref.fiat_25519_carry_square

namespace MLIR.Firedancer.Ref

private def out : Pointer :=
  ⟨⟨0⟩, 0⟩

private def a : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- Two 40-byte blocks: `out` zeroed, `a` holding `bytes`. -/
private def state (bytes : BitVec 320) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨40, 0⟩), (⟨1⟩, ⟨40, bytes⟩)]⟩⟩

/-- Every limb `2^52 - 1`, so every column carries. -/
private def aBytes : BitVec 320 :=
  0x000fffffffffffff000fffffffffffff000fffffffffffff000fffffffffffff000fffffffffffff#320

/-- The output limbs, or `none` for UB / out of fuel. -/
private def outLimbs (o i : ⟦Ty.ptr⟧) : Option (Fin 5 → BitVec 64) :=
  match fiat_25519_carry_square.eval 1 (fiat_25519_carry_square.args o i) (state aBytes) with
  | .value (some .nil, s') => some (s'.mem.readLimbs out)
  | _ => none

#guard
  match outLimbs (.value out) (.value a) with
  | some r =>
    (List.finRange 5).all fun k =>
      r k == fiat_25519_carry_square.spec ((state aBytes).mem.readLimbs a) k
  | none => false

-- A poison pointer is UB.
#guard (outLimbs .poison (.value a)).isNone

end MLIR.Firedancer.Ref
