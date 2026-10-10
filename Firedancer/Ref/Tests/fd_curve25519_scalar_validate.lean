module

public import Firedancer.Ref.fd_curve25519_scalar_validate

meta import Firedancer.Ref.fd_curve25519_scalar_validate

namespace MLIR.Firedancer.Ref

private def p : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- One 32-byte block holding `bytes`. -/
private def state (bytes : BitVec 256) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 32 bytes)]⟩⟩

/-- The returned pointer, or `none` for UB / out of fuel. -/
private def out (bytes : BitVec 256) (q : ⟦Ty.ptr⟧ := .value p) : Option (PoisonOr Pointer) :=
  match
    fd_curve25519_scalar_validate.eval 10 (fd_curve25519_scalar_validate.args q) (state bytes) with
  | .value (some (.cons v .nil), _) => some v
  | _ => none

/-- The run returns what the spec says. -/
private def agrees (bytes : BitVec 256) : Bool :=
  out bytes == some (.value (if fd_curve25519_scalar_validate.spec bytes then p else Pointer.null))

-- below `2^252`: the fast path
#guard out 0#256 == some (.value p)

#guard out (2 ^ 252 - 1) == some (.value p)

-- `[2^252, ℓ)`: the word compares
#guard out (2 ^ 252) == some (.value p)

#guard out (scalarL - 1) == some (.value p)

#guard out scalarL == some (.value Pointer.null)

#guard out (scalarL + 1) == some (.value Pointer.null)

#guard out (2 ^ 253 - 1) == some (.value Pointer.null)

-- a top byte at or above `0x20`
#guard out (2 ^ 253) == some (.value Pointer.null)

#guard out (-1) == some (.value Pointer.null)

#guard [0#256, 2 ^ 252 - 1, 2 ^ 252, scalarL - 1, scalarL, scalarL + 1, 2 ^ 253, -1].all agrees

-- A poison pointer is UB.
#guard (out 0#256 .poison).isNone

end MLIR.Firedancer.Ref
