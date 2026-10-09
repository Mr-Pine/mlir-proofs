module

public import Firedancer.R52x5.fd_ed25519_point_from

meta import Firedancer.R52x5.fd_ed25519_point_from

namespace MLIR.Firedancer.R52x5

private def ptr (k : Nat) : Pointer :=
  ⟨⟨k⟩, 0⟩

/-- 64 bytes, lane `i` of the 8 holding `b + i`. -/
private def fe (b : Nat) : BitVec 512 :=
  BitVec.ofNat 512 ((List.range 8).foldl (fun acc i => acc + (b + i) * 2 ^ (64 * i)) 0)

/-- `r` (192 bytes, junk) and `x, y, z, t`, lanes from `1000, 2000, 3000, 4000`. -/
private def state : GlobalState :=
  ⟨⟨5⟩,
    ⟨Std.ExtHashMap.ofList
        [(⟨0⟩, ⟨192, 7⟩), (⟨1⟩, ⟨64, fe 1000⟩), (⟨2⟩, ⟨64, fe 2000⟩), (⟨3⟩, ⟨64, fe 3000⟩),
          (⟨4⟩, ⟨64, fe 4000⟩)]⟩⟩

-- `r` holds limb `i` of `x, y, z, t` in `Qi`, `r` is returned, four blocks used
#guard
  match
    fd_ed25519_point_from.eval 1
      (fd_ed25519_point_from.args (.value (ptr 0)) (.value (ptr 1)) (.value (ptr 2))
        (.value (ptr 3)) (.value (ptr 4)))
      state with
  | .value (some (.cons (.value r) .nil), s') =>
    let R := s'.mem.readQuad5 (ptr 0)
    let Q :=
      Quad5.pack (state.mem.readVec (ptr 1)) (state.mem.readVec (ptr 2)) (state.mem.readVec (ptr 3))
        (state.mem.readVec (ptr 4))
    r == ptr 0 && s'.alloc.nextFreeBlock == 9 && R.P0 == Q.P0 && R.P1 == Q.P1 && R.P2 == Q.P2 &&
      R.P3 == Q.P3 &&
      R.P4 == Q.P4 &&
      R.P3 == wl 1003 2003 3003 4003
  | _ => false

end MLIR.Firedancer.R52x5
