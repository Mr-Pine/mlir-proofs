module

public import Firedancer.R52x5.fd_ed25519_point_to

meta import Firedancer.R52x5.fd_ed25519_point_to

namespace MLIR.Firedancer.R52x5

private def ptr (k : Nat) : Pointer :=
  ⟨⟨k⟩, 0⟩

/-- 192 bytes, lane `i` of the 24 holding `1000 + i`. -/
private def aBytes : BitVec 1536 :=
  BitVec.ofNat 1536 ((List.range 24).foldl (fun acc i => acc + (1000 + i) * 2 ^ (64 * i)) 0)

/-- `x, y, z, t` (64 bytes each, junk) and `a`. -/
private def state : GlobalState :=
  ⟨⟨6⟩,
    ⟨Std.ExtHashMap.ofList
        [(⟨1⟩, ⟨64, 7⟩), (⟨2⟩, ⟨64, 7⟩), (⟨3⟩, ⟨64, 7⟩), (⟨4⟩, ⟨64, 7⟩), (⟨5⟩, ⟨192, aBytes⟩)]⟩⟩

-- `x, y, z, t` hold `a`'s coordinates: lane `j` of `Q0 … Q4`, then three zeros
#guard
  match
    fd_ed25519_point_to.eval 1
      (fd_ed25519_point_to.args (.value (ptr 1)) (.value (ptr 2)) (.value (ptr 3)) (.value (ptr 4))
        (.value (ptr 5)))
      state with
  | .value (some .nil, s') =>
    let (x, y, z, t) := (state.mem.readQuad5 (ptr 5)).unpack
    s'.mem.readVec (ptr 1) == x && s'.mem.readVec (ptr 2) == y && s'.mem.readVec (ptr 3) == z &&
      s'.mem.readVec (ptr 4) == t &&
      s'.mem.readVec (ptr 3) == #v[1002, 1006, 1010, 1014, 1018, 0, 0, 0]
  | _ => false

end MLIR.Firedancer.R52x5
