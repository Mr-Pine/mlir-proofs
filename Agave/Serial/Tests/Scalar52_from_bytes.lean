module

public import Agave.Serial.Scalar52_from_bytes
public import Agave.Math.Scalar
public import Firedancer.Common.Limbs

meta import Agave.Serial.Scalar52_from_bytes
meta import Agave.Math.Scalar
meta import Firedancer.Common.Limbs

namespace MLIR.Agave.Serial

private def out : Pointer :=
  ⟨⟨1⟩, 0⟩

private def bytes : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Two blocks after the null block: `out` (40 bytes) zeroed, `bytes` holding `b`. -/
private def state (b : BitVec 256) : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 40 0), (⟨2⟩, .ofBytes 32 b)]⟩⟩

/-- The run stores `spec`'s limbs, whose number is the bytes'. -/
private def agrees (b : BitVec 256) : Bool :=
  match
    Scalar52_from_bytes.eval 1 (Scalar52_from_bytes.args (.value out) (.value bytes)) (state b) with
  | .value (some .nil, s') =>
    (List.finRange 5).all (fun i => s'.mem.readLimbs out i == Scalar52_from_bytes.spec b i) &&
      Scalar52.nat (Scalar52_from_bytes.spec b) == b.toNat
  | _ => false

#guard agrees 0x0123456789abcdeffedcba98765432100f1e2d3c4b5a69788796a5b4c3d2e1f0#256

#guard agrees (BitVec.allOnes 256)

#guard agrees 0#256

end MLIR.Agave.Serial
