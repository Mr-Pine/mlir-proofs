module

public import Firedancer.Ref.fd_memset

meta import Firedancer.Ref.fd_memset

namespace MLIR.Firedancer.Ref

private def d : Pointer :=
  ⟨⟨0⟩, 0⟩

/-- One 16-byte block holding `bytes`. -/
private def state (bytes : BitVec 128) : GlobalState :=
  ⟨⟨1⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨16, bytes⟩)]⟩⟩

/-- The returned pointer and the block's bytes, or `none` for UB / out of fuel. -/
private def out (dst : Pointer) (sz : BitVec 64) (bytes : BitVec 128) :
    Option (PoisonOr Pointer × BitVec 128) :=
  match fd_memset.eval 1 (fd_memset.args (.value dst) (.value sz)) (state bytes) with
  | .value (some (.cons p .nil), s) => some (p, s.mem.readAt d 128)
  | _ => none

private def bytes : BitVec 128 :=
  0x00112233445566778899aabbccddeeff#128

-- bytes 4 … 9 cleared
#guard out ⟨⟨0⟩, 4⟩ 6#64 bytes == some (.value ⟨⟨0⟩, 4⟩, 0x001122334455000000000000ccddeeff#128)

#guard out d 16#64 bytes == some (.value d, 0#128)

#guard out d 0#64 bytes == some (.value d, bytes)

-- past the block's end: UB
#guard out ⟨⟨0⟩, 4⟩ 13#64 bytes == none

end MLIR.Firedancer.Ref
