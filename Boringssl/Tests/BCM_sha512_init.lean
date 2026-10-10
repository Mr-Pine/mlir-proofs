module

public import Boringssl.SHA512_Init

meta import Boringssl.SHA512_Init

namespace MLIR.Boringssl

private def c : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- A 208-byte struct of `0xaa` bytes, `p`'s upper half undefined. -/
private def state : GlobalState :=
  ⟨⟨2⟩,
    ⟨Std.ExtHashMap.ofList
        [(⟨1⟩, ⟨208, (0xaa#8).replicate 208, (BitVec.allOnes 1152).setWidth 1664, true⟩)]⟩⟩

/-- The struct's bytes and their definedness after `SHA512_Init`, with its return value. -/
private def run : Option (PoisonOr (BitVec 32) × BitVec 1664 × BitVec 1664) :=
  match SHA512_Init.eval 1 (SHA512_Init.args (.value c)) state with
  | .value (some (.cons r .nil), s) => some (r, s.mem.readAt c 1664, s.mem.definedAt c 1664)
  | _ => none

/-- The spec's memory, read the same way. -/
private def expected : BitVec 1664 × BitVec 1664 :=
  let m := state.mem.storeShaCtx c (BCM_sha512_init.spec (state.mem.readShaCtx c))
  (m.readAt c 1664, m.definedAt c 1664)

#guard run == some (.value 1#32, expected)

-- `h` holds SHA-512's initial hash value, `md_len = 64`, `p` as it was
#guard (BCM_sha512_init.spec (state.mem.readShaCtx c)).h == Firedancer.Ref.sha512IV

#guard
  (state.mem.storeShaCtx c (BCM_sha512_init.spec (state.mem.readShaCtx c))).readAt (c.add 80#64)
      1024 ==
    (0xaa#8).replicate 128

end MLIR.Boringssl
