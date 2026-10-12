module

public import Agave.Serial.Scalar52_from_bytes_wide

meta import Agave.Serial.Scalar52_from_bytes_wide

namespace MLIR.Agave.Serial

private def out : Pointer :=
  ⟨⟨1⟩, 0⟩

private def bytes : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Two blocks after the null block: `out` (40 bytes) zeroed, `bytes` holding `b`. -/
private def state (b : BitVec 512) : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 40 0), (⟨2⟩, .ofBytes 64 b)]⟩⟩

/-- The run stores `spec`'s limbs, the bytes' number mod `ℓ`. -/
private def agrees (b : BitVec 512) : Bool :=
  match
    Scalar52_from_bytes_wide.eval 1 (Scalar52_from_bytes_wide.args (.value out) (.value bytes))
      (state b) with
  | .value (some .nil, s') =>
    let r := Vector.ofFn (Scalar52_from_bytes_wide.spec b)
    (List.finRange 5).all (fun i => s'.mem.readLimbs out i == r.get i) &&
      Scalar52.nat r.get == b.toNat % _root_.Ed25519.ell
  | _ => false

#guard agrees (BitVec.allOnes 512)

#guard agrees 0#512

#guard
  agrees
    0x0123456789abcdeffedcba98765432100f1e2d3c4b5a69788796a5b4c3d2e1f0deadbeefcafebabe0011223344556677#512

end MLIR.Agave.Serial
