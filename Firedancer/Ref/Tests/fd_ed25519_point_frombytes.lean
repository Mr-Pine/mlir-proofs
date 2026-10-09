module

public import Firedancer.Ref.fd_ed25519_point_frombytes

meta import Firedancer.Ref.fd_ed25519_point_frombytes

namespace MLIR.Firedancer.Ref

private def r : Pointer :=
  ⟨⟨1⟩, 0⟩

private def buf : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- A zeroed 160-byte block for `r` and a 32-byte block holding `b`; block 0 is null's. -/
private def state (b : BitVec 256) : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, ⟨160, 0⟩), (⟨2⟩, ⟨32, b⟩)]⟩⟩

/-- The stored point's coordinates `X, Y, Z, T`, canonically encoded, if `frombytes r buf` returns
`r`, leaves `buf` unchanged and moves the counter on by 79 blocks; `none` if it returns null,
stores nothing and moves the counter on by 57; else `some none`. `spec` itself is not evaluated:
its `pow22523` chain re-evaluates its closures exponentially often. -/
private def out (b : BitVec 256) :
    Option (Option (BitVec 256 × BitVec 256 × BitVec 256 × BitVec 256)) :=
  match
    fd_ed25519_point_frombytes.call (fd_ed25519_point_frombytes.args (.value r) (.value buf))
      (state b) with
  | .value (.cons (.value ret) .nil, s') =>
    let enc (k : BitVec 64) := fd_f25519_tobytes.spec (s'.mem.readLimbs (r.add k))
    if ret == r && s'.mem.readAt buf 256 == b && s'.alloc.nextFreeBlock == 82 then
      some (some (enc 0, enc 40, enc 120, enc 80))
    else
      if ret == Pointer.null && s'.mem.readAt r 1280 == 0 && s'.alloc.nextFreeBlock == 60 then
        some none
      else none
  | _ => none

-- the base point
#guard
  out 0x6666666666666666666666666666666666666666666666666666666666666658#256 ==
    some
      (some
        (0x216936d3cd6e53fec0a4e231fdd6dc5c692cc7609525a7b2c9562d608f25d51a#256,
          0x6666666666666666666666666666666666666666666666666666666666666658#256, 1#256,
          0x67875f0fd78b766566ea4e8e64abe37d20f09f80775152f56dde8ab3a5b7dda3#256))

-- a point with the sign bit set
#guard
  out 0x85fc536d880238b13933c6d305acdfd5f098eff289f4c345b027b2c28f95e826#256 ==
    some
      (some
        (0x602a465ff9c6b5d716cc66cdc721b544a3e6c38fec1a1dc7215eb9b93aba2ea3#256,
          0x05fc536d880238b13933c6d305acdfd5f098eff289f4c345b027b2c28f95e826#256, 1#256,
          0x6ce244c360a26beb303276d192f8af0aba993d74cdfa85962d0d253ede7e8781#256))

-- `y = 2` has no `x`
#guard out 2#256 == some none

-- `x = 0` with the sign bit set is accepted, also with the non-canonical `y = p + 1`
#guard
  out 0x8000000000000000000000000000000000000000000000000000000000000001#256 ==
    some (some (0#256, 1#256, 1#256, 0#256))

#guard
  out 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffee#256 ==
    some (some (0#256, 1#256, 1#256, 0#256))

end MLIR.Firedancer.Ref
