module

public import Firedancer.Ref.fiat_25519_opp

meta import Firedancer.Ref.fiat_25519_opp

namespace MLIR.Firedancer.Ref

private def out : Pointer :=
  ⟨⟨0⟩, 0⟩

private def x : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- Two 40-byte blocks: `out` zeroed, `x` holding `bytes`. -/
private def state (bytes : BitVec 320) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, .ofBytes 40 0), (⟨1⟩, .ofBytes 40 bytes)]⟩⟩

/-- The limbs `1, 2, 3, 4, 5`. -/
private def xBytes : BitVec 320 :=
  0x00000000000000050000000000000004000000000000000300000000000000020000000000000001#320

/-- The output limbs, or `none` for UB / out of fuel. -/
private def outLimbs (o i : ⟦Ty.ptr⟧) : Option (Fin 5 → BitVec 64) :=
  match fiat_25519_opp.eval 1 (fiat_25519_opp.args o i) (state xBytes) with
  | .value (some .nil, s') => some (s'.mem.readLimbs out)
  | _ => none

-- Every limb is `2p`'s limb minus the input limb.
#guard
  match outLimbs (.value out) (.value x) with
  | some r =>
    (List.finRange 5).all fun k => r k == fiat_25519_opp.spec ((state xBytes).mem.readLimbs x) k
  | none => false

-- A poison pointer is UB.
#guard (outLimbs .poison (.value x)).isNone

end MLIR.Firedancer.Ref
