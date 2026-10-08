module

public import Zig.Edwards25519_fromBytes
public import Zig.Math.Decode

/-! `fromBytes`' program spec is the source's decoding `Decode.fromBytes`. -/

namespace LeanMLIR.RIR.Zig

/-- The program's spec is `Decode.fromBytes`: the same computation. -/
public theorem Edwards25519.fromBytes.spec_eq (b : BitVec 256) :
    Edwards25519.fromBytes.spec b = Decode.fromBytes b :=
  rfl

end LeanMLIR.RIR.Zig
