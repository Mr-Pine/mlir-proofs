module

public import Firedancer.R52x5.fd_mlir_ed25519_point_from

meta import Firedancer.R52x5.fd_mlir_ed25519_point_from

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

-- as `fd_ed25519_point_from`: limb `i` of `x, y, z, t` in `Qi`
#guard
  match
    fd_mlir_ed25519_point_from.eval 1
      (fd_mlir_ed25519_point_from.args (.value (ptr 0)) (.value (ptr 1)) (.value (ptr 2))
        (.value (ptr 3)) (.value (ptr 4)))
      state with
  | .value (some (.cons (.value r) .nil), s') =>
    let R := s'.mem.readQuad5 (ptr 0)
    r == ptr 0 && R.P0 == wl 1000 2000 3000 4000 && R.P4 == wl 1004 2004 3004 4004
  | _ => false

end MLIR.Firedancer.R52x5
