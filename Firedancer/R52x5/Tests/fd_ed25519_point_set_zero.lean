module

public import Firedancer.R52x5.fd_ed25519_point_set_zero

meta import Firedancer.R52x5.fd_ed25519_point_set_zero

namespace MLIR.Firedancer.R52x5

private def r : Pointer :=
  ⟨⟨1⟩, 0⟩

private def junk : BitVec 1536 :=
  BitVec.ofNat 1536 (2 ^ 1530 - 12345)

/-- One 192-byte block for `r`, holding junk. -/
private def state : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 192 junk)]⟩⟩

-- `r` is returned and holds `quadZero`; the 32 padding bytes stay
#guard
  match fd_ed25519_point_set_zero.eval 1 (fd_ed25519_point_set_zero.args (.value r)) state with
  | .value (some (.cons ret .nil), s') =>
    let P := s'.mem.readQuad5 r
    ret == .value r && P.P0 == wl 0 1 1 0 && P.P1 == wl_zero && P.P2 == wl_zero &&
      P.P3 == wl_zero &&
      P.P4 == wl_zero &&
      s'.mem.readAt (r.add 160#64) 256 == junk.extractLsb' 1280 256
  | _ => false

end MLIR.Firedancer.R52x5
