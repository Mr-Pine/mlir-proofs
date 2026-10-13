module

public import Zig.scalar_rejectNonCanonical

meta import Zig.scalar_rejectNonCanonical

namespace MLIR.Zig

private def inp : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- The scalar's 32 bytes `b` at `inp`. -/
private def state (b : BitVec 256) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 32 b)]⟩⟩

/-- The returned code, or `none` for UB / out of fuel. -/
private def out (b : BitVec 256) : Option (BitVec 16) :=
  match
    scalar_rejectNonCanonical.eval 100000 (scalar_rejectNonCanonical.args (.value inp))
      ((state b).withGlobals scalar_rejectNonCanonical.globals) with
  | .value (some (.cons (.value r) .nil), _) => some r
  | _ => none

private def inputs : List (BitVec 256) :=
  [0, 1, 0x1000000000000000000000000000000014def9dea2f79cd65812631a5cf5d3ec#256,
    0x1000000000000000000000000000000014def9dea2f79cd65812631a5cf5d3ed#256,
    0x1000000000000000000000000000000014def9dea2f79cd65812631a5cf5d4ec#256,
    0x0fffffffffffffffffffffffffffffff14def9dea2f79cd65812631a5cf5d3ed#256,
    0x1000000000000000000000000000000114def9dea2f79cd65812631a5cf5d3ec#256, -1]

-- The call returns the spec's code.
#guard inputs.all fun b => out b == some (scalar.rejectNonCanonical.spec b)

-- `0` exactly below `ℓ`.
#guard
  inputs.all fun b => (scalar.rejectNonCanonical.spec b == 0#16) == decide (b.toNat < Ed25519.ell)

end MLIR.Zig
