module

public import Zig.scalar_reduce64

meta import Zig.scalar_reduce64

namespace MLIR.Zig

private def outp : Pointer :=
  ⟨⟨1⟩, 0⟩

private def inp : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- `out` undefined, the 64 bytes `b` at `inp`. -/
private def state (b : BitVec 512) : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, ⟨32, 0, 0, true, fun _ => none⟩), (⟨2⟩, .ofBytes 64 b)]⟩⟩

/-- `out` after the call, or `none` for UB / out of fuel. -/
private def out (b : BitVec 512) : Option (BitVec 256) :=
  match scalar_reduce64.eval 100000 (scalar_reduce64.args (.value outp) (.value inp)) (state b) with
  | .value (some .nil, s') => some (s'.mem.readAt outp 256)
  | _ => none

private def inputs : List (BitVec 512) :=
  [0, 1, 0x1000000000000000000000000000000014def9dea2f79cd65812631a5cf5d3ec#512,
    0x1000000000000000000000000000000014def9dea2f79cd65812631a5cf5d3ed#512,
    0x0123456789abcdeffedcba98765432100f1e2d3c4b5a69788796a5b4c3d2e1f0#512 <<< 200,
    -1 >>> 8, -1]

-- The call stores the spec's bytes.
#guard inputs.all fun b => out b == some (scalar.reduce64.spec b)

-- The spec is `b mod ℓ`.
#guard inputs.all fun b => (scalar.reduce64.spec b).toNat == b.toNat % Ed25519.ell

end MLIR.Zig
