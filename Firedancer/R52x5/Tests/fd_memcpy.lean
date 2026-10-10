module

public import Firedancer.R52x5.fd_memcpy

meta import Firedancer.R52x5.fd_memcpy

namespace MLIR.Firedancer.R52x5

private def d : Pointer :=
  ⟨⟨0⟩, 0⟩

private def src : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- A 16-byte destination of `0xaa` bytes and a 16-byte source holding `bytes`. -/
private def state (bytes : BitVec 128) : GlobalState :=
  ⟨⟨2⟩,
    ⟨Std.ExtHashMap.ofList [(⟨0⟩, .ofBytes 16 ((0xaa#8).replicate 16)), (⟨1⟩, .ofBytes 16 bytes)]⟩⟩

/-- The destination's bytes, or `none` for UB / out of fuel. -/
private def out (dst source : Pointer) (sz : BitVec 64) (bytes : BitVec 128) :
    Option (BitVec 128) :=
  match
    fd_memcpy.eval 1 (fd_memcpy.args (.value dst) (.value source) (.value sz)) (state bytes) with
  | .value (some .nil, s) => some (s.mem.readAt d 128)
  | _ => none

private def bytes : BitVec 128 :=
  0x00112233445566778899aabbccddeeff#128

-- all 16 bytes, and the low 5 (the rest keep `0xaa`)
#guard out d src 16#64 bytes == some bytes

#guard out d src 5#64 bytes == some 0xaaaaaaaaaaaaaaaaaaaaaabbccddeeff#128

-- the spec's state
#guard
  match fd_memcpy.eval 1 (fd_memcpy.args (.value d) (.value src) (.value 5#64)) (state bytes) with
  | .value (some _, s) =>
    s.mem.readAt d 128 ==
      ((state bytes).mem.storeAt d ((state bytes).mem.readAt src (8 * 5))).readAt d 128
  | _ => false

-- too long for the blocks, or overlapping ranges: UB
#guard out d src 17#64 bytes == none

#guard out d ⟨⟨0⟩, 4⟩ 8#64 bytes == none

end MLIR.Firedancer.R52x5
