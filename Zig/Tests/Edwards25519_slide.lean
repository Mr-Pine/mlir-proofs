module

public import Zig.Edwards25519_slide

meta import Zig.Edwards25519_slide

namespace MLIR.Zig

/-- `out` undefined, the scalar's 32 bytes at `sp`. -/
private def state (x : BitVec 256) : GlobalState :=
  ⟨⟨3⟩,
    ⟨Std.ExtHashMap.ofList [(⟨1⟩, ⟨64, 0, 0, true, fun _ => none, true⟩), (⟨2⟩, .ofBytes 32 x)]⟩⟩

/-- The 64 bytes at `out` after the call, or `none` for UB / out of fuel. -/
private def out (x : BitVec 256) : Option (BitVec 512) :=
  match
    Edwards25519_slide.eval 10000 (Edwards25519_slide.args (.value ⟨⟨1⟩, 0⟩) (.value ⟨⟨2⟩, 0⟩))
      ((state x).withGlobals Edwards25519_slide.globals) with
  | .value (some .nil, s') => some (s'.mem.readAt ⟨⟨1⟩, 0⟩ 512)
  | _ => none

private def inputs : List (BitVec 256) :=
  [0, 1, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff,
    0x123456789abcdef0fedcba98765432100f1e2d3c4b5a69788796a5b4c3d2e1f0]

-- `spec`'s digits, for scalars below `2^255`.
#guard inputs.all fun x => out x == some (BitVec.packLanes (Edwards25519.slide.spec x))

end MLIR.Zig
