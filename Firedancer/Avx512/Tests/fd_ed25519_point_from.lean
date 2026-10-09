module

public import Firedancer.Avx512.fd_ed25519_point_from

meta import Firedancer.Avx512.fd_ed25519_point_from

namespace MLIR.Firedancer.Avx512

private def ptr (k : Nat) : Pointer :=
  ⟨⟨k⟩, 0⟩

/-- 64 bytes with lane `i` distinct per seed `k`. -/
private def vec (k : Nat) : BitVec 512 :=
  BitVec.ofNat 512 ((List.range 8).foldl (fun acc i => acc + (100 * k + i + 1) * 2 ^ (64 * i)) 0)

/-- `r` (192 bytes, zeroed) and `x, y, z, t` (64 bytes each). -/
private def state : GlobalState :=
  ⟨⟨6⟩,
    ⟨Std.ExtHashMap.ofList
        [(⟨1⟩, ⟨192, 0⟩), (⟨2⟩, ⟨64, vec 1⟩), (⟨3⟩, ⟨64, vec 2⟩), (⟨4⟩, ⟨64, vec 3⟩),
          (⟨5⟩, ⟨64, vec 4⟩)]⟩⟩

-- `r` is returned and holds `spec` of the four elements
#guard
  match
    fd_ed25519_point_from.eval 1
      (fd_ed25519_point_from.args (.value (ptr 1)) (.value (ptr 2)) (.value (ptr 3))
        (.value (ptr 4)) (.value (ptr 5)))
      state with
  | .value (some (.cons ret .nil), s') =>
    let m := state.mem
    let P := s'.mem.readQuad (ptr 1)
    let Q :=
      fd_ed25519_point_from.spec (m.readVec (ptr 2)) (m.readVec (ptr 3)) (m.readVec (ptr 4))
        (m.readVec (ptr 5))
    ret == .value (ptr 1) && P.P03 == Q.P03 && P.P14 == Q.P14 && P.P25 == Q.P25
  | _ => false

end MLIR.Firedancer.Avx512
