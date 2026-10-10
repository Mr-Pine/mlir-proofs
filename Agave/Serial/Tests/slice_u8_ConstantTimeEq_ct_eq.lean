module

public import Agave.Serial.slice_u8_ConstantTimeEq_ct_eq

meta import Agave.Serial.slice_u8_ConstantTimeEq_ct_eq

namespace MLIR.Agave.Serial

private def a : Pointer :=
  ⟨⟨1⟩, 0⟩

private def b : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Block 0 free; `a` and `b` 32-byte blocks holding `x` and `y`. -/
private def state (x y : BitVec 256) : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 32 x), (⟨2⟩, .ofBytes 32 y)]⟩⟩

/-- The returned byte, or `none` for UB / out of fuel. -/
private def ret (s : GlobalState) : Option (BitVec 8) :=
  match
    slice_u8_ConstantTimeEq_ct_eq.eval 1 (slice_u8_ConstantTimeEq_ct_eq.args (.value a) (.value b))
      s with
  | .value (some (.cons (.value r) .nil), _) => some r
  | _ => none

private def x : BitVec 256 :=
  0x0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef#256

#guard ret (state x x) == some (slice_u8_ConstantTimeEq_ct_eq.spec x x)

#guard ret (state x x) == some 1

#guard ret (state x (x ^^^ 1 <<< 255)) == some 0

#guard
  ret (state x (x ^^^ 1 <<< 255)) == some (slice_u8_ConstantTimeEq_ct_eq.spec x (x ^^^ 1 <<< 255))

#guard ret (state x 0) == some 0

end MLIR.Agave.Serial
