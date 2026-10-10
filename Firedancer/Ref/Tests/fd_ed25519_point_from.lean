module

public import Firedancer.Ref.fd_ed25519_point_from

meta import Firedancer.Ref.fd_ed25519_point_from

namespace MLIR.Firedancer.Ref

private def ptr (k : Nat) : Pointer :=
  ⟨⟨k⟩, 0⟩

/-- A 160-byte block for `r`, and four 40-byte blocks holding `1 …`, `2 …`, `3 …`, `4 …`. -/
private def state : GlobalState :=
  ⟨⟨5⟩,
    ⟨Std.ExtHashMap.ofList
        [(⟨0⟩, .ofBytes 160 0), (⟨1⟩, .ofBytes 40 1), (⟨2⟩, .ofBytes 40 2), (⟨3⟩, .ofBytes 40 3),
          (⟨4⟩, .ofBytes 40 4)]⟩⟩

-- `r` is returned, and its fields X, Y, Z, T hold `x, y, z, t`
#guard
  match
    fd_ed25519_point_from.eval 1
      (fd_ed25519_point_from.args (.value (ptr 0)) (.value (ptr 1)) (.value (ptr 2))
        (.value (ptr 3)) (.value (ptr 4)))
      state with
  | .value (some (.cons ret .nil), s') =>
    ret == .value (ptr 0) && s'.mem.readAt (ptr 0) 320 == 1 &&
      s'.mem.readAt ((ptr 0).add 40#64) 320 == 2 &&
      s'.mem.readAt ((ptr 0).add 120#64) 320 == 3 &&
      s'.mem.readAt ((ptr 0).add 80#64) 320 == 4
  | _ => false

end MLIR.Firedancer.Ref
