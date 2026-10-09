module

public import Firedancer.Ref.fd_ed25519_point_set

meta import Firedancer.Ref.fd_ed25519_point_set

namespace MLIR.Firedancer.Ref

private def r : Pointer :=
  ⟨⟨0⟩, 0⟩

private def a : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- Two 160-byte blocks: `r` zeroed, `a` holding `bytes`. -/
private def state (bytes : BitVec 1280) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨160, 0⟩), (⟨1⟩, ⟨160, bytes⟩)]⟩⟩

private def aBytes : BitVec 1280 :=
  BitVec.ofNat 1280 (2 ^ 1000 + 12345678901234567890)

-- `r` is returned and holds all of `a`'s 160 bytes
#guard
  match
    fd_ed25519_point_set.eval 1 (fd_ed25519_point_set.args (.value r) (.value a))
      (state aBytes) with
  | .value (some (.cons ret .nil), s') => ret == .value r && s'.mem.readAt r 1280 == aBytes
  | _ => false

end MLIR.Firedancer.Ref
