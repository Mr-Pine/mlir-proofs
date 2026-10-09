module

public import Firedancer.Ref.fd_ed25519_point_frombytes_2x

meta import Firedancer.Ref.fd_ed25519_point_frombytes_2x

namespace MLIR.Firedancer.Ref

private def ptr (k : Nat) : Pointer :=
  ⟨⟨k⟩, 0⟩

/-- Zeroed 160-byte blocks for `r1` (block 1) and `r2` (block 3), 32-byte blocks holding `b1`
(block 2) and `b2` (block 4); block 0 is null's. -/
private def state (b1 b2 : BitVec 256) : GlobalState :=
  ⟨⟨5⟩,
    ⟨Std.ExtHashMap.ofList [(⟨1⟩, ⟨160, 0⟩), (⟨2⟩, ⟨32, b1⟩), (⟨3⟩, ⟨160, 0⟩), (⟨4⟩, ⟨32, b2⟩)]⟩⟩

/-- A point's coordinates `X, Y, Z, T` at `p`, canonically encoded. -/
private def enc (m : MemoryState) (p : Pointer) : List (BitVec 256) :=
  [0#64, 40#64, 120#64, 80#64].map fun k => fd_f25519_tobytes.spec (m.readLimbs (p.add k))

/-- The returned flag, the counter's advance and the two points after
`frombytes_2x r1 buf1 r2 q` (`q` is `buf2`, or `buf1` itself). `spec` itself is not evaluated: its
`pow22523` chain re-evaluates its closures exponentially often. -/
private def out (b1 b2 : BitVec 256) (q : Pointer := ptr 4) :
    Option (BitVec 32 × Nat × List (BitVec 256) × List (BitVec 256)) :=
  match
    fd_ed25519_point_frombytes_2x.call
      (fd_ed25519_point_frombytes_2x.args (.value (ptr 1)) (.value (ptr 2)) (.value (ptr 3))
        (.value q))
      (state b1 b2) with
  | .value (.cons (.value ret) .nil, s') =>
    some (ret, s'.alloc.nextFreeBlock - 5, enc s'.mem (ptr 1), enc s'.mem (ptr 3))
  | _ => none

/-- The base point's and the neutral point's coordinates, and an untouched (zero) point's. -/
private def base : List (BitVec 256) :=
  [0x216936d3cd6e53fec0a4e231fdd6dc5c692cc7609525a7b2c9562d608f25d51a#256,
    0x6666666666666666666666666666666666666666666666666666666666666658#256, 1#256,
    0x67875f0fd78b766566ea4e8e64abe37d20f09f80775152f56dde8ab3a5b7dda3#256]

private def neutral : List (BitVec 256) :=
  [0#256, 1#256, 1#256, 0#256]

private def zero : List (BitVec 256) :=
  [0#256, 0#256, 0#256, 0#256]

/-- The encodings of the base point, of `y = 1`, of `y = 2` (no point) and of `y = 1` with the
sign bit set. -/
private def baseBytes : BitVec 256 :=
  0x6666666666666666666666666666666666666666666666666666666666666658#256

private def oneBytes : BitVec 256 :=
  1#256

private def twoBytes : BitVec 256 :=
  2#256

private def oneSignBytes : BitVec 256 :=
  0x8000000000000000000000000000000000000000000000000000000000000001#256

-- two valid points
#guard out baseBytes oneBytes == some (0#32, 158, base, neutral)

-- the first invalid: `-1`, nothing stored, the second not decoded
#guard out twoBytes oneBytes == some (-1#32, 57, zero, zero)

-- the second invalid: `-2`, only the first stored
#guard out oneBytes twoBytes == some (-2#32, 136, neutral, zero)

-- `x = 0` with the sign bit set, in either slot
#guard out oneSignBytes baseBytes == some (0#32, 158, neutral, base)

#guard out baseBytes oneSignBytes == some (0#32, 158, base, neutral)

-- both from one buffer
#guard out baseBytes 0 (q := ptr 2) == some (0#32, 158, base, base)

end MLIR.Firedancer.Ref
