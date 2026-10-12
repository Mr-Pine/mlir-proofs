module

public import Agave.Serial.Scalar_reduce

meta import Agave.Serial.Scalar_reduce

namespace MLIR.Agave.Serial

private def out : Pointer :=
  ⟨⟨1⟩, 0⟩

private def self : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Two blocks after the null block: `out` (32 bytes) zeroed, `self` holding `b`. -/
private def state (b : BitVec 256) : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 32 0), (⟨2⟩, .ofBytes 32 b)]⟩⟩

/-- The run stores `spec`'s bytes, the input's number mod `ℓ`. -/
private def agrees (b : BitVec 256) : Bool :=
  match Scalar_reduce.eval 1 (Scalar_reduce.args (.value out) (.value self)) (state b) with
  | .value (some .nil, s') =>
    let r := Scalar_reduce.spec b
    s'.mem.readAt out 256 == r && r.toNat == b.toNat % _root_.Ed25519.ell
  | _ => false

#guard agrees (BitVec.allOnes 256)

#guard agrees 0#256

-- `ℓ` reduces to `0`, `ℓ - 1` stays
#guard agrees 0x1000000000000000000000000000000014def9dea2f79cd65812631a5cf5d3ed#256

#guard agrees 0x1000000000000000000000000000000014def9dea2f79cd65812631a5cf5d3ec#256

end MLIR.Agave.Serial
