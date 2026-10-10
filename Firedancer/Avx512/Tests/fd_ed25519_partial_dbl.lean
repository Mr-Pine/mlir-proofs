module

public import Firedancer.Avx512.fd_ed25519_partial_dbl

meta import Firedancer.Avx512.fd_ed25519_partial_dbl

namespace MLIR.Firedancer.Avx512

private def r : Pointer :=
  ⟨⟨1⟩, 0⟩

private def a : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- 192 bytes, lane `i` of the 24 holding a 43-bit pattern. -/
private def aBytes : BitVec 1536 :=
  BitVec.ofNat 1536
    ((List.range 24).foldl (fun acc i => acc + (4000000000000 + 99999999989 * i) * 2 ^ (64 * i)) 0)

/-- `a` holding `aBytes`, `r` zero. -/
private def state : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 192 0), (⟨2⟩, .ofBytes 192 aBytes)]⟩⟩

-- `r` holds `spec` of the point at `a`, and `r` is returned
#guard
  match fd_ed25519_partial_dbl.eval 2 (fd_ed25519_partial_dbl.args (.value r) (.value a)) state with
  | .value (some (.cons (.value p) .nil), s') =>
    let P := s'.mem.readQuad r
    let Q := fd_ed25519_partial_dbl.spec (state.mem.readQuad a)
    p == r && P.P03 == Q.P03 && P.P14 == Q.P14 && P.P25 == Q.P25
  | _ => false

end MLIR.Firedancer.Avx512
