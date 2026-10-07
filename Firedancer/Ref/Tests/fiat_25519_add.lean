module

public import Firedancer.Ref.fiat_25519_add

meta import Firedancer.Ref.fiat_25519_add

namespace LeanMLIR.RIR.Firedancer.Ref

private def out : Pointer :=
  ⟨⟨0⟩, 0⟩

private def x : Pointer :=
  ⟨⟨1⟩, 0⟩

private def y : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Three 40-byte blocks: `out` zeroed, `x` and `y` holding `xb` and `yb`. -/
private def state (xb yb : BitVec 320) : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨40, 0⟩), (⟨1⟩, ⟨40, xb⟩), (⟨2⟩, ⟨40, yb⟩)]⟩⟩

/-- The limbs `1, 2, 3, 4, 5` and `10, 20, 30, 40, 50`. -/
private def xBytes : BitVec 320 :=
  0x00000000000000050000000000000004000000000000000300000000000000020000000000000001#320

private def yBytes : BitVec 320 :=
  0x00000000000000320000000000000028000000000000001e0000000000000014000000000000000a#320

/-- The output limbs, or `none` for UB. -/
private def outLimbs (o i j : ⟦Ty.ptr⟧) : Option (Fin 5 → BitVec 64) :=
  match fiat_25519_add.call (fiat_25519_add.args o i j) (state xBytes yBytes) with
  | .value (.nil, s') => some (s'.mem.readLimbs out)
  | _ => none

-- every limb is `spec`'s
#guard
  match outLimbs (.value out) (.value x) (.value y) with
  | some r =>
    (List.finRange 5).all fun k =>
      r k ==
        fiat_25519_add.spec ((state xBytes yBytes).mem.readLimbs x)
          ((state xBytes yBytes).mem.readLimbs y) k
  | none => false

-- a poison pointer is UB
#guard (outLimbs (.value out) .poison (.value y)).isNone

end LeanMLIR.RIR.Firedancer.Ref
