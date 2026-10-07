module

public import Firedancer.Ref.fd_f25519_eq

meta import Firedancer.Ref.fd_f25519_eq

namespace LeanMLIR.RIR.Firedancer.Ref

private def a : Pointer :=
  ⟨⟨0⟩, 0⟩

private def b : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- Two 40-byte blocks, `a` and `b` holding `ab` and `bb`. -/
private def state (ab bb : BitVec 320) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨40, ab⟩), (⟨1⟩, ⟨40, bb⟩)]⟩⟩

/-- `eq a q`'s result if it is `spec` of the inputs' limbs, the inputs are unchanged and the
counter moved on by one block; else `none`. -/
private def out (ab bb : BitVec 320) (q : Pointer := b) : Option (BitVec 32) :=
  let s := state ab bb
  match fd_f25519_eq.eval 1 (fd_f25519_eq.args (.value a) (.value q)) s with
  | .value (some (.cons (.value v) .nil), s') =>
    if
        v == fd_f25519_eq.spec (s.mem.readLimbs a) (s.mem.readLimbs q) &&
          s'.mem.readAt a 320 == ab &&
          s'.mem.readAt b 320 == bb &&
          s'.alloc.nextFreeBlock == 3 then
      some v
    else none
  | _ => none

/-- Limbs `2^52 - 1` (not reduced), and the limbs of `p`. -/
private def xBytes : BitVec 320 :=
  0x000fffffffffffff000fffffffffffff000fffffffffffff000fffffffffffff000fffffffffffff#320

private def pBytes : BitVec 320 :=
  0x0007ffffffffffff0007ffffffffffff0007ffffffffffff0007ffffffffffff0007ffffffffffed#320

-- equal limbs, also through one pointer
#guard out xBytes xBytes == some 1#32

#guard out xBytes 0#320 (q := a) == some 1#32

-- `p` and `0` are the same element
#guard out pBytes 0#320 == some 1#32

-- different elements
#guard out 1#320 0#320 == some 0#32

#guard out xBytes pBytes == some 0#32

end LeanMLIR.RIR.Firedancer.Ref
