module

public import Zig.scalar_mul8

meta import Zig.scalar_mul8

namespace MLIR.Zig

private def outp : Pointer :=
  ⟨⟨1⟩, 0⟩

private def inp : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- `out` undefined, the scalar's 32 bytes `b` at `inp`. -/
private def state (b : BitVec 256) : GlobalState :=
  ⟨⟨3⟩,
    ⟨Std.ExtHashMap.ofList [(⟨1⟩, ⟨32, 0, 0, true, fun _ => none, true⟩), (⟨2⟩, .ofBytes 32 b)]⟩⟩

/-- `out` after the call, or `none` for UB / out of fuel. -/
private def out (b : BitVec 256) : Option (BitVec 256) :=
  match
    scalar_mul8.eval 100000 (scalar_mul8.args (.value outp) (.value inp))
      ((state b).withGlobals scalar_mul8.globals) with
  | .value (some .nil, s') => some (s'.mem.readAt outp 256)
  | _ => none

private def inputs : List (BitVec 256) :=
  [0, 1, 2, 0x1000000000000000000000000000000014def9dea2f79cd65812631a5cf5d3ec#256,
    0x1000000000000000000000000000000014def9dea2f79cd65812631a5cf5d3ed#256,
    0x0123456789abcdeffedcba98765432100f1e2d3c4b5a69788796a5b4c3d2e1f0#256, -1]

-- The call stores the spec's bytes.
#guard inputs.all fun b => out b == some (scalar.mul8.spec b)

-- The spec is `8 b mod ℓ`.
#guard inputs.all fun b => (scalar.mul8.spec b).toNat == 8 * b.toNat % Ed25519.ell

end MLIR.Zig
