module

public import Firedancer.Ref.fd_f25519_is_zero

meta import Firedancer.Ref.fd_f25519_is_zero

namespace LeanMLIR.RIR.Firedancer.Ref

private def x : Pointer :=
  ⟨⟨0⟩, 0⟩

/-- One 40-byte block holding `bytes`. -/
private def state (bytes : BitVec 320) : GlobalState :=
  ⟨⟨1⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨40, bytes⟩)]⟩⟩

/-- The returned value, or `none` for UB / out of fuel. -/
private def out (bytes : BitVec 320) (p : ⟦Ty.ptr⟧ := .value x) : Option (PoisonOr (BitVec 32)) :=
  match fd_f25519_is_zero.eval 11 (fd_f25519_is_zero.args p) (state bytes) with
  | .value (some (.cons v .nil), _) => some v
  | _ => none

-- zero, and `p`
#guard out 0#320 == some (.value 1#32)

#guard
  out 0x0007ffffffffffff0007ffffffffffff0007ffffffffffff0007ffffffffffff0007ffffffffffed#320 ==
    some (.value 1#32)

-- `1`, and `p` with its top limb changed
#guard out 1#320 == some (.value 0#32)

#guard
  out 0x0007fffffffffffe0007ffffffffffff0007ffffffffffff0007ffffffffffff0007ffffffffffed#320 ==
    some (.value 0#32)

-- A poison pointer is UB.
#guard (out 0#320 .poison).isNone

end LeanMLIR.RIR.Firedancer.Ref
