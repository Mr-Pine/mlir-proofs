module

public import Boringssl.int64_lshift21

meta import Boringssl.int64_lshift21

namespace MLIR.Boringssl

/-- The returned value, or `none` for UB / out of fuel. -/
private def out (a : BitVec 64) : Option (PoisonOr (BitVec 64)) :=
  match int64_lshift21.eval 1 (int64_lshift21.args (.value a)) ⟨⟨1⟩, ⟨∅⟩⟩ with
  | .value (some (.cons v .nil), _) => some v
  | _ => none

-- `a << 21` in range, signed.
#guard out 5#64 == some (.value (5#64 <<< 21))

#guard out (-3#64) == some (.value (-3#64 <<< 21))

-- Past `2^42` the compiled `shl nsw` is poison.
#guard out (BitVec.ofNat 64 (2 ^ 42)) == some .poison

end MLIR.Boringssl
