module

public import Firedancer.Avx512.fd_ed25519_point_neg

meta import Firedancer.Avx512.fd_ed25519_point_neg

namespace MLIR.Firedancer.Avx512

private def ptr (k : Nat) : Pointer :=
  ⟨⟨k⟩, 0⟩

/-- 192 bytes, lane `i` of the 24 holding a 43-bit pattern. -/
private def aBytes : BitVec 1536 :=
  BitVec.ofNat 1536
    ((List.range 24).foldl (fun acc i => acc + (5000000000000 + 77777777777 * i) * 2 ^ (64 * i)) 0)

/-- `r` (zeroed) and `a`. -/
private def state : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 192 0), (⟨2⟩, .ofBytes 192 aBytes)]⟩⟩

/-- Whether `r` holds `spec` of `a`'s point after `fd_ed25519_point_neg(r, a)`. -/
private def check (r a : Pointer) : Bool :=
  match fd_ed25519_point_neg.eval 1 (fd_ed25519_point_neg.args (.value r) (.value a)) state with
  | .value (some (.cons ret .nil), s') =>
    let P := s'.mem.readQuad r
    let Q := fd_ed25519_point_neg.spec (state.mem.readQuad a)
    ret == .value r && P.P03 == Q.P03 && P.P14 == Q.P14 && P.P25 == Q.P25
  | _ => false

-- into another block, and in place
#guard check (ptr 1) (ptr 2)

#guard check (ptr 2) (ptr 2)

end MLIR.Firedancer.Avx512
