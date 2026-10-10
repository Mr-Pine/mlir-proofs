module

public import Agave.Serial.Scalar_non_adjacent_form

meta import Agave.Serial.Scalar_non_adjacent_form

namespace MLIR.Agave.Serial

private def naf : Pointer :=
  ⟨⟨1⟩, 0⟩

private def scalar : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Two blocks after the null block: `naf` (256 bytes) zeroed, `scalar` holding `xb`. -/
private def state (xb : BitVec 256) : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 256 0), (⟨2⟩, .ofBytes 32 xb)]⟩⟩

/-- A scalar below `2^255` with long runs of ones. -/
private def xBytes : BitVec 256 :=
  0x7fffffff00000000ffffffffffffffff123456789abcdef0fedcba9876543210#256

/-- The digits' bytes stored at `naf`, or `none` for UB / out of fuel. -/
private def nafBytes (xb : BitVec 256) (w : BitVec 64) : Option (BitVec 2048) :=
  match
    Scalar_non_adjacent_form.eval 2000
      (Scalar_non_adjacent_form.args (.value naf) (.value scalar) (.value w)) (state xb) with
  | .value (some .nil, s') => some (s'.mem.readAt naf 2048)
  | _ => none

-- The bytes are `spec`'s, for widths 2, 5 and 8.
#guard
  [2, 5, 8].all fun w =>
    match nafBytes xBytes (BitVec.ofNat 64 w) with
    | some r => r == Scalar_non_adjacent_form.spec xBytes w
    | none => false

-- The digits sum to the scalar.
#guard Naf.val (Naf.naf 5 xBytes.toNat) == xBytes.toNat

end MLIR.Agave.Serial
