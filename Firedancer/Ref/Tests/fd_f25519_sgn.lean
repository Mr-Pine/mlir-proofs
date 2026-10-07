module

public import Firedancer.Ref.fd_f25519_sgn

meta import Firedancer.Ref.fd_f25519_sgn

namespace LeanMLIR.RIR.Firedancer.Ref

private def a : Pointer :=
  ⟨⟨0⟩, 0⟩

/-- A 40-byte block holding the limbs `l`. -/
private def state (l : BitVec 320) : GlobalState :=
  ⟨⟨1⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨40, l⟩)]⟩⟩

/-- `sgn a`'s result if it is `spec` of `a`'s limbs, `a` is unchanged and the counter moved on by
22 blocks; else `none`. -/
private def out (l : BitVec 320) : Option (BitVec 32) :=
  let s := state l
  match fd_f25519_sgn.eval 1 (fd_f25519_sgn.args (.value a)) s with
  | .value (some (.cons (.value v) .nil), s') =>
    if
        v == fd_f25519_sgn.spec (s.mem.readLimbs a) && s'.mem.readAt a 320 == l &&
          s'.alloc.nextFreeBlock == 23 then
      some v
    else none
  | _ => none

/-- The limbs of `p` and of `p + 1`: odd low limbs, encoding `0` and `1`. -/
private def pBytes : BitVec 320 :=
  0x0007ffffffffffff0007ffffffffffff0007ffffffffffff0007ffffffffffff0007ffffffffffed#320

private def p1Bytes : BitVec 320 :=
  0x0007ffffffffffff0007ffffffffffff0007ffffffffffff0007ffffffffffff0007ffffffffffee#320

#guard out 1#320 == some 1#32

#guard out 2#320 == some 0#32

-- the sign of the canonical encoding, not of the low limb
#guard out pBytes == some 0#32

#guard out p1Bytes == some 1#32

end LeanMLIR.RIR.Firedancer.Ref
