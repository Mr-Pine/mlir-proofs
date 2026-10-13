module

public import Sodium.SHA512_Transform
public import Firedancer.Ref.fd_sha512_init

meta import Sodium.SHA512_Transform
meta import Firedancer.Ref.fd_sha512_init

namespace MLIR.Sodium

/-- `"abc"` padded to one 128-byte block, byte `k` at bits `8 * k`. -/
private def abc : BitVec 1024 :=
  0x61#1024 ||| 0x62#1024 <<< 8 ||| 0x63#1024 <<< 16 ||| 0x80#1024 <<< 24 ||| 0x18#1024 <<< 1016

/-- SHA-512("abc"), as eight words (FIPS 180-2, appendix C.1). -/
private def abcDigest : Vector (BitVec 64) 8 :=
  #v[0xddaf35a193617aba#64, 0xcc417349ae204131#64, 0x12e6fa4e89a97ea2#64, 0x0a9eeee64b55d39a#64,
    0x2192992a274fc1a8#64, 0x36ba3c23a3feebbd#64, 0x454d4423643ce80e#64, 0x2a9ac94fa54ca49f#64]

-- the spec compresses the padded block into SHA-512's initial state
#guard SHA512_Transform.spec Firedancer.Ref.sha512IV abc == abcDigest

private def st : Pointer :=
  ⟨⟨1⟩, 0⟩

private def blk : Pointer :=
  ⟨⟨2⟩, 0⟩

private def tmp : Pointer :=
  ⟨⟨3⟩, 0⟩

/-- The state words `h`, the block `bytes`, an undefined `tmp64`. -/
private def state (h : Vector (BitVec 64) 8) (bytes : BitVec 1024) : GlobalState :=
  let s : GlobalState :=
    ⟨⟨4⟩,
      ⟨Std.ExtHashMap.ofList
          [(⟨1⟩, .ofBytes 64 0), (⟨2⟩, .ofBytes 128 bytes),
            (⟨3⟩, { MemoryBlock.ofBytes 704 0 with defined := 0 })]⟩⟩
  { s with mem := s.mem.storeWords8 st h }

/-- The state words after the run, or `none` for UB / out of fuel. -/
private def out (h : Vector (BitVec 64) 8) (bytes : BitVec 1024) : Option (Vector (BitVec 64) 8) :=
  match
    SHA512_Transform.eval 20
      (SHA512_Transform.args (.value st) (.value blk) (.value tmp) (.value (tmp.add 640#64)))
      ((state h bytes).withGlobals SHA512_Transform.globals) with
  | .value (some .nil, s) => some (s.mem.readWords8 st)
  | _ => none

-- the lift compresses "abc"
#guard out Firedancer.Ref.sha512IV abc == some abcDigest

-- another state and block: the spec's result
private def blk2 : BitVec 1024 :=
  0x0123456789abcdef#1024 <<< 300 ||| 0xfedcba9876543210#1024

#guard out abcDigest blk2 == some (SHA512_Transform.spec abcDigest blk2)

end MLIR.Sodium
