module

public import Firedancer.Avx512.fd_ed25519_point_dbln

meta import Firedancer.Avx512.fd_ed25519_point_dbln

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

/-- `r` holds `spec` of the point at `a` and `n`, and `r` is returned. -/
private def check (n : Nat) : Bool :=
  match
    fd_ed25519_point_dbln.eval 10
      (fd_ed25519_point_dbln.args (.value r) (.value a) (.value (BitVec.ofNat 32 n))) state with
  | .value (some (.cons (.value p) .nil), s') =>
    let P := s'.mem.readQuad r
    let Q := fd_ed25519_point_dbln.spec (state.mem.readQuad a) n
    p == r && P.P03 == Q.P03 && P.P14 == Q.P14 && P.P25 == Q.P25
  | _ => false

#guard check 1

#guard check 3

end MLIR.Firedancer.Avx512
