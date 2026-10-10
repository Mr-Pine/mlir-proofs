module

public import Boringssl.OPENSSL_memcpy

meta import Boringssl.OPENSSL_memcpy

namespace MLIR.Boringssl

private def d : Pointer :=
  ⟨⟨1⟩, 4⟩

private def src : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- A 16-byte destination of `0xaa` bytes and a 16-byte source holding `bytes`. -/
private def state : GlobalState :=
  ⟨⟨3⟩,
    ⟨Std.ExtHashMap.ofList
        [(⟨1⟩, .ofBytes 16 ((0xaa#8).replicate 16)),
          (⟨2⟩, .ofBytes 16 0x00112233445566778899aabbccddeeff#128)]⟩⟩

/-- The destination block's bytes after a call, or `none` for UB / out of fuel. -/
private def after {ts : List Ty} (r : PoisonOr (Option (Vals ts) × GlobalState)) :
    Option (BitVec 128) :=
  match r with
  | .value (some _, s) => some (s.mem.readAt ⟨⟨1⟩, 0⟩ 128)
  | _ => none

-- 5 bytes, and none
#guard
  after (OPENSSL_memcpy.eval 4 (OPENSSL_memcpy.args (.value d) (.value src) (.value 5#64)) state) ==
    some 0xaaaaaaaaaaaaaabbccddeeffaaaaaaaa#128

#guard
  after (OPENSSL_memcpy.eval 4 (OPENSSL_memcpy.args (.value d) (.value src) (.value 0#64)) state) ==
    some ((0xaa#8).replicate 16)

-- past the block's end: UB
#guard
  after
      (OPENSSL_memcpy.eval 4 (OPENSSL_memcpy.args (.value d) (.value src) (.value 13#64)) state) ==
    none

end MLIR.Boringssl
