module

public import Boringssl.load_4

meta import Boringssl.load_4

namespace MLIR.Boringssl

private def p0 : Pointer :=
  ⟨⟨1⟩, 0⟩

private def p1 : Pointer :=
  ⟨⟨1⟩, 1⟩

/-- One 4-byte block holding `bytes`. -/
private def state (bytes : BitVec 32) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 4 bytes)]⟩⟩

/-- The returned value, or `none` for UB / out of fuel. -/
private def out (ptr : ⟦Ty.ptr⟧) (bytes : BitVec 32) : Option (PoisonOr (BitVec 64)) :=
  match load_4.eval 1 (load_4.args ptr) (state bytes) with
  | .value (some (.cons v .nil), _) => some v
  | _ => none

-- The low 4 bytes, little-endian.
#guard out (.value p0) 0x89abcdef#32 == some (.value 0x89abcdef#64)

-- Past the block's end: UB.
#guard out (.value p1) 0#32 == none

-- A poison pointer is UB.
#guard out .poison 0#32 == none

end MLIR.Boringssl
