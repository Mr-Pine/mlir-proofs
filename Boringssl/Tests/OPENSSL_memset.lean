module

public import Boringssl.OPENSSL_memset

meta import Boringssl.OPENSSL_memset

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

-- 3 bytes of `0x1ff`'s low byte, and none
#guard
  after
      (OPENSSL_memset.eval 4 (OPENSSL_memset.args (.value d) (.value 0x1ff#32) (.value 3#64))
        state) ==
    some 0xaaaaaaaaaaaaaaaaaaffffffaaaaaaaa#128

#guard
  after
      (OPENSSL_memset.eval 4 (OPENSSL_memset.args (.value d) (.value 0x1ff#32) (.value 0#64))
        state) ==
    some ((0xaa#8).replicate 16)

end MLIR.Boringssl
