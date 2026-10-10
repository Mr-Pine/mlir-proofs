module

public import Firedancer.Ref.fd_f25519_frombytes

meta import Firedancer.Ref.fd_f25519_frombytes

namespace MLIR.Firedancer.Ref

private def r : Pointer :=
  ⟨⟨0⟩, 0⟩

private def buf : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- A 40-byte block for `r`, zeroed, and a 32-byte block holding `bytes`. -/
private def state (bytes : BitVec 256) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, .ofBytes 40 0), (⟨1⟩, .ofBytes 32 bytes)]⟩⟩

/-- Distinct bytes `0x01 … 0x1f`, then `0xff`: the top bit set. -/
private def bytes : BitVec 256 :=
  0xff1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a090807060504030201#256

-- `r` is returned, and holds `spec` of the bytes
#guard
  match
    fd_f25519_frombytes.eval 1 (fd_f25519_frombytes.args (.value r) (.value buf)) (state bytes) with
  | .value (some (.cons ret .nil), s') =>
    ret == .value r &&
      (List.finRange 5).all fun k => s'.mem.readLimbs r k == fd_f25519_frombytes.spec bytes k
  | _ => false

end MLIR.Firedancer.Ref
