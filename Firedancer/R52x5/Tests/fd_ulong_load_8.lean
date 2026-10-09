module

public import Firedancer.R52x5.fd_ulong_load_8

meta import Firedancer.R52x5.fd_ulong_load_8

namespace MLIR.Firedancer.R52x5

private def p0 : Pointer :=
  ⟨⟨0⟩, 0⟩

private def p1 : Pointer :=
  ⟨⟨0⟩, 1⟩

/-- One 8-byte block holding `bytes`. -/
private def state (bytes : BitVec 64) : GlobalState :=
  ⟨⟨1⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨8, bytes⟩)]⟩⟩

/-- The returned value, or `none` for UB / out of fuel. -/
private def out (ptr : ⟦Ty.ptr⟧) (bytes : BitVec 64) : Option (PoisonOr (BitVec 64)) :=
  match fd_ulong_load_8.eval 1 (fd_ulong_load_8.args ptr) (state bytes) with
  | .value (some (.cons v .nil), _) => some v
  | _ => none

-- The block's 64 bits come back unchanged.
#guard out (.value p0) 0x0123456789abcdef#64 == some (.value 0x0123456789abcdef#64)

-- Eight bytes from offset 1 run past the block: UB.
#guard out (.value p1) 0#64 == none

-- A poison pointer is UB.
#guard out .poison 0#64 == none

end MLIR.Firedancer.R52x5
