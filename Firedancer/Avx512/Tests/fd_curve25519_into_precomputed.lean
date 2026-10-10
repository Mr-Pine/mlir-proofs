module

public import Firedancer.Avx512.fd_curve25519_into_precomputed

meta import Firedancer.Avx512.fd_curve25519_into_precomputed

namespace MLIR.Firedancer.Avx512

private def r : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- 192 bytes, lane `i` of the 24 holding a 43-bit pattern. -/
private def rBytes : BitVec 1536 :=
  BitVec.ofNat 1536
    ((List.range 24).foldl (fun acc i => acc + (4000000000000 + 99999999989 * i) * 2 ^ (64 * i)) 0)

/-- `r` holding `rBytes`. -/
private def state : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 192 rBytes)]⟩⟩

-- `r` holds `spec` of its point
#guard
  match
    fd_curve25519_into_precomputed.eval 1 (fd_curve25519_into_precomputed.args (.value r))
      state with
  | .value (some .nil, s') =>
    let P := s'.mem.readQuad r
    let Q := fd_curve25519_into_precomputed.spec (state.mem.readQuad r)
    P.P03 == Q.P03 && P.P14 == Q.P14 && P.P25 == Q.P25
  | _ => false

end MLIR.Firedancer.Avx512
