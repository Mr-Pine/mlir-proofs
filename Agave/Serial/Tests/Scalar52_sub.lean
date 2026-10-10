module

public import Agave.Serial.Scalar52_sub

meta import Agave.Serial.Scalar52_sub

namespace MLIR.Agave.Serial

private def out : Pointer :=
  ⟨⟨1⟩, 0⟩

private def a : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Two 40-byte blocks after the null block: `out` zeroed, `a` holding `ab`. -/
private def state (ab : BitVec 320) : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 40 0), (⟨2⟩, .ofBytes 40 ab)]⟩⟩

/-- `ℓ + 5`: limbs `L + (5, 0, 0, 0, 0)`. -/
private def aBig : BitVec 320 :=
  0x00001000000000000000000000000000000000000014def9000dea2f79cd65810002631a5cf5d3f2#320

/-- `3`. -/
private def aSmall : BitVec 320 :=
  3#320

/-- The output limbs, or `none` for UB / out of fuel. -/
private def outLimbs (ab : BitVec 320) : Option (Fin 5 → BitVec 64) :=
  match Scalar52_sub.eval 1 (Scalar52_sub.args (.value out) (.value a)) (state ab) with
  | .value (some .nil, s') => some (s'.mem.readLimbs out)
  | _ => none

-- Every limb is `spec`'s; `ℓ + 5` reduces to `5`, `3` stays.
#guard
  [aBig, aSmall].all fun ab =>
    match outLimbs ab with
    | some r =>
      (List.finRange 5).all fun k => r k == Scalar52_sub.spec ((state ab).mem.readLimbs a) k
    | none => false

#guard
  (outLimbs aBig).map (fun r => (List.finRange 5).map (r ·)) == some [5#64, 0#64, 0#64, 0#64, 0#64]

#guard
  (outLimbs aSmall).map (fun r => (List.finRange 5).map (r ·)) ==
    some [3#64, 0#64, 0#64, 0#64, 0#64]

end MLIR.Agave.Serial
