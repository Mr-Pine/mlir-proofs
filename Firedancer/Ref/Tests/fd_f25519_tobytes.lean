module

public import Firedancer.Ref.fd_f25519_tobytes

meta import Firedancer.Ref.fd_f25519_tobytes

namespace LeanMLIR.RIR.Firedancer.Ref

private def out : Pointer :=
  ⟨⟨0⟩, 0⟩

private def a : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- A zeroed 32-byte block for `out` and a 40-byte block holding the limbs `l`. -/
private def state (l : BitVec 320) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨32, 0⟩), (⟨1⟩, ⟨40, l⟩)]⟩⟩

/-- The limbs `2^51 - 1, 2, 3, 4, 2^51 - 1`. -/
private def aBytes : BitVec 320 :=
  0x0007ffffffffffff000000000000000400000000000000030000000000000002#256 ++ 0x7ffffffffffff#64

-- `out` is returned, and holds the spec's bytes
#guard
  match
    fd_f25519_tobytes.eval 3 (fd_f25519_tobytes.args (.value out) (.value a)) (state aBytes) with
  | .value (some (.cons ret .nil), s') =>
    ret == .value out &&
      s'.mem.readAt out 256 == fd_f25519_tobytes.spec ((state aBytes).mem.readLimbs a)
  | _ => false

end LeanMLIR.RIR.Firedancer.Ref
