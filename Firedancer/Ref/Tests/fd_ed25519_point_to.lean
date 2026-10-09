module

public import Firedancer.Ref.fd_ed25519_point_to

meta import Firedancer.Ref.fd_ed25519_point_to

namespace MLIR.Firedancer.Ref

private def ptr (k : Nat) : Pointer :=
  ⟨⟨k⟩, 0⟩

/-- Four 40-byte blocks for `x, y, z, t`, and a 160-byte block for `p` holding `bytes`. -/
private def state (bytes : BitVec 1280) : GlobalState :=
  ⟨⟨5⟩,
    ⟨Std.ExtHashMap.ofList
        [(⟨0⟩, ⟨40, 0⟩), (⟨1⟩, ⟨40, 0⟩), (⟨2⟩, ⟨40, 0⟩), (⟨3⟩, ⟨40, 0⟩), (⟨4⟩, ⟨160, bytes⟩)]⟩⟩

private def pBytes : BitVec 1280 :=
  BitVec.ofNat 1280 (2 ^ 1100 + 3 * 2 ^ 700 + 5 * 2 ^ 400 + 7)

-- x, y, z, t hold p's X, Y, Z, T
#guard
  match
    fd_ed25519_point_to.eval 1
      (fd_ed25519_point_to.args (.value (ptr 0)) (.value (ptr 1)) (.value (ptr 2)) (.value (ptr 3))
        (.value (ptr 4)))
      (state pBytes) with
  | .value (some .nil, s') =>
    s'.mem.readAt (ptr 0) 320 == pBytes.extractLsb' 0 320 &&
      s'.mem.readAt (ptr 1) 320 == pBytes.extractLsb' 320 320 &&
      s'.mem.readAt (ptr 2) 320 == pBytes.extractLsb' 960 320 &&
      s'.mem.readAt (ptr 3) 320 == pBytes.extractLsb' 640 320
  | _ => false

end MLIR.Firedancer.Ref
