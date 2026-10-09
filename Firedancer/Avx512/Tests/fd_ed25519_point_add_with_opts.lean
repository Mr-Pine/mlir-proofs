module

public import Firedancer.Avx512.fd_ed25519_point_add_with_opts

meta import Firedancer.Avx512.fd_ed25519_point_add_with_opts

namespace MLIR.Firedancer.Avx512

private def r : Pointer :=
  ⟨⟨1⟩, 0⟩

private def a : Pointer :=
  ⟨⟨2⟩, 0⟩

private def b : Pointer :=
  ⟨⟨3⟩, 0⟩

/-- 192 bytes, lane `i` of the 24 holding a 43-bit pattern from `seed`. -/
private def bytes (seed : Nat) : BitVec 1536 :=
  BitVec.ofNat 1536
    ((List.range 24).foldl (fun acc i => acc + (seed + 99999999989 * i) * 2 ^ (64 * i)) 0)

/-- `a` and `b` holding two patterns, `r` zero. -/
private def state : GlobalState :=
  ⟨⟨4⟩, ⟨Std.ExtHashMap.ofList
    [(⟨1⟩, ⟨192, 0⟩), (⟨2⟩, ⟨192, bytes 4000000000000⟩), (⟨3⟩, ⟨192, bytes 1234567890123⟩)]⟩⟩

/-- `r` holds `spec` of the points at `a` and `b`, and `r` is returned. -/
private def check (pre : BitVec 32) : Bool :=
  match fd_ed25519_point_add_with_opts.eval 5
      (fd_ed25519_point_add_with_opts.args (.value r) (.value a) (.value b) (.value pre)) state with
  | .value (some (.cons (.value p) .nil), s') =>
    let P := s'.mem.readQuad r
    let Q := fd_ed25519_point_add_with_opts.spec (state.mem.readQuad a) (state.mem.readQuad b) pre
    p == r && P.P03 == Q.P03 && P.P14 == Q.P14 && P.P25 == Q.P25
  | _ => false

#guard check 0

#guard check 1

end MLIR.Firedancer.Avx512
