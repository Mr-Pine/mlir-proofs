module

public import Firedancer.Ref.fiat_25519_to_bytes

meta import Firedancer.Ref.fiat_25519_to_bytes

namespace MLIR.Firedancer.Ref

private def out1 : Pointer :=
  ⟨⟨0⟩, 0⟩

private def arg1 : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- A zeroed 32-byte block for `out1` and a 40-byte block holding the limbs `l`. -/
private def state (l : BitVec 320) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨32, 0⟩), (⟨1⟩, ⟨40, l⟩)]⟩⟩

/-- The five limbs, lowest first. -/
private def limbs (l0 l1 l2 l3 l4 : BitVec 64) : BitVec 320 :=
  l4 ++ l3 ++ l2 ++ l1 ++ l0

/-- The 32 bytes at `out1` after the run, or `none` for UB / out of fuel. -/
private def out (o : ⟦Ty.ptr⟧) (l : BitVec 320) : Option (BitVec 256) :=
  match fiat_25519_to_bytes.eval 2 (fiat_25519_to_bytes.args o (.value arg1)) (state l) with
  | .value (some .nil, s) => some (s.mem.readAt out1 256)
  | _ => none

/-- The run stores the spec of the limbs. -/
private def agrees (l : BitVec 320) : Bool :=
  out (.value out1) l == some (fiat_25519_to_bytes.spec ((state l).mem.readLimbs arg1))

private def m51 : BitVec 64 :=
  0x7ffffffffffff

-- `p` itself: `0`
#guard agrees (limbs 0x7ffffffffffed m51 m51 m51 m51)

#guard out (.value out1) (limbs 0x7ffffffffffed m51 m51 m51 m51) == some 0

-- `p + 5`: `5`
#guard out (.value out1) (limbs 0x7fffffffffff2 m51 m51 m51 m51) == some 5

-- `2^255 - 1`: `18`
#guard agrees (limbs m51 m51 m51 m51 m51)

#guard out (.value out1) (limbs m51 m51 m51 m51 m51) == some 18

-- below `p`: the value's bytes
#guard agrees (limbs 1 2 3 4 5)

#guard
  out (.value out1) (limbs 1 2 3 4 5) ==
    some (BitVec.ofNat 256 (1 + 2 * 2 ^ 51 + 3 * 2 ^ 102 + 4 * 2 ^ 153 + 5 * 2 ^ 204))

-- a poison pointer is UB
#guard (out .poison (limbs 1 2 3 4 5)).isNone

end MLIR.Firedancer.Ref
