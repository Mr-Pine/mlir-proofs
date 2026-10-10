module

public import Firedancer.Ref.fd_sha512_core_ref
public import Firedancer.Ref.fd_sha512_init

meta import Firedancer.Ref.fd_sha512_core_ref
meta import Firedancer.Ref.fd_sha512_init

namespace MLIR.Firedancer.Ref

/-- `"abc"` padded to one 128-byte block, byte `k` at bits `8 * k`: `0x80` after the message, its
bit length `24` big-endian at the end. -/
private def abc : BitVec 1024 :=
  0x61#1024 ||| 0x62#1024 <<< 8 ||| 0x63#1024 <<< 16 ||| 0x80#1024 <<< 24 ||| 0x18#1024 <<< 1016

/-- SHA-512("abc"), as eight big-endian words (FIPS 180-2, appendix C.1). -/
private def abcDigest : Vector (BitVec 64) 8 :=
  #v[0xddaf35a193617aba#64, 0xcc417349ae204131#64, 0x12e6fa4e89a97ea2#64, 0x0a9eeee64b55d39a#64,
    0x2192992a274fc1a8#64, 0x36ba3c23a3feebbd#64, 0x454d4423643ce80e#64, 0x2a9ac94fa54ca49f#64]

-- the spec compresses the padded block into SHA-512's initial state
#guard fd_sha512_core_ref.spec (n := 1) sha512IV abc == abcDigest

private def st : Pointer :=
  ⟨⟨0⟩, 0⟩

private def data : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- The state block holding `h`, the data block holding `bytes` (`n` blocks of 128 bytes). -/
private def state (h : Vector (BitVec 64) 8) (n : Nat) (bytes : BitVec (1024 * n)) : GlobalState :=
  let s : GlobalState :=
    ⟨⟨2⟩,
      ⟨Std.ExtHashMap.ofList
          [(⟨0⟩, .ofBytes 64 0), (⟨1⟩, .ofBytes (128 * n) (bytes.cast (by omega)))]⟩⟩
  { s with mem := s.mem.storeWords8 st h }

/-- The state words after the run, or `none` for UB / out of fuel. -/
private def out (h : Vector (BitVec 64) 8) (n : Nat) (bytes : BitVec (1024 * n)) :
    Option (Vector (BitVec 64) 8) :=
  match
    fd_sha512_core_ref.eval 200
      (fd_sha512_core_ref.args (.value st) (.value data) (.value (BitVec.ofNat 64 n)))
      (state h n bytes) with
  | .value (some .nil, s) => some (s.mem.readWords8 st)
  | _ => none

-- the lift computes the digest of "abc"
#guard out sha512IV 1 abc == some abcDigest

-- two blocks: the spec's result
private def two : BitVec 2048 :=
  abc ++ (0x0123456789abcdef#1024 <<< 300 ||| 0xfedcba9876543210#1024)

#guard out abcDigest 2 two == some (fd_sha512_core_ref.spec (n := 2) abcDigest two)

end MLIR.Firedancer.Ref
