module

public import Firedancer.Avx512.fd_ed25519_point_set_zero

meta import Firedancer.Avx512.fd_ed25519_point_set_zero

namespace MLIR.Firedancer.Avx512

private def r : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- One 192-byte block for `r`, holding junk. -/
private def state : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 192 (BitVec.ofNat 1536 (2 ^ 1530 - 12345)))]⟩⟩

-- `r` is returned and holds `spec`
#guard
  match fd_ed25519_point_set_zero.eval 1 (fd_ed25519_point_set_zero.args (.value r)) state with
  | .value (some (.cons ret .nil), s') =>
    let P := s'.mem.readQuad r
    let Q := fd_ed25519_point_set_zero.spec
    ret == .value r && P.P03 == Q.P03 && P.P14 == Q.P14 && P.P25 == Q.P25
  | _ => false

end MLIR.Firedancer.Avx512
