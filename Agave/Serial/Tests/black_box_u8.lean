module

public import Agave.Serial.black_box_u8

meta import Agave.Serial.black_box_u8

namespace MLIR.Agave.Serial

/-- The returned byte for `x` from an empty state, or `none` for UB / out of fuel. -/
private def ret (x : BitVec 8) : Option (BitVec 8) :=
  match black_box_u8.eval 1 (black_box_u8.args (.value x)) ⟨⟨1⟩, ⟨Std.ExtHashMap.ofList []⟩⟩ with
  | .value (some (.cons (.value r) .nil), _) => some r
  | _ => none

#guard ret 0 == some 0

#guard ret 0xa5 == some 0xa5

end MLIR.Agave.Serial
