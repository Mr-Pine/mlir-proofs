module

public import Boringssl.CRYPTO_store_u64_be

meta import Boringssl.CRYPTO_store_u64_be

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

-- the word big-endian at bytes 4 … 11
#guard
  after
      (CRYPTO_store_u64_be.eval 1
        (CRYPTO_store_u64_be.args (.value d) (.value 0x0102030405060708#64)) state) ==
    some 0xaaaaaaaa0807060504030201aaaaaaaa#128

end MLIR.Boringssl
