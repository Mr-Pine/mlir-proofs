module

public import Firedancer.R52x5.fd_ed25519_point_frombytes_2x

meta import MLIR.Semantics.Func
meta import Firedancer.R52x5.fd_ed25519_point_frombytes_2x

/-! `fd_ed25519_point_frombytes_2x` run on encodings that decode and that do not, its points against
`spec`'s. -/

namespace MLIR.Firedancer.R52x5

section Tests

/-- Block `k`, at offset 0. -/
private def ptr (k : Nat) : Pointer :=
  ⟨⟨k⟩, 0⟩

/-- The points `r1`, `r2` in blocks `0`, `2` (192 bytes, zeroed), the encodings in `1`, `3`. -/
private def state (e1 e2 : Nat) : GlobalState :=
  ⟨⟨4⟩,
    ⟨Std.ExtHashMap.ofList
        [(⟨0⟩, .ofBytes 192 0), (⟨1⟩, .ofBytes 32 (BitVec.ofNat 256 e1)), (⟨2⟩, .ofBytes 192 0),
          (⟨3⟩, .ofBytes 32 (BitVec.ofNat 256 e2))]⟩⟩

private def eqQ (P Q : Quad5) : Bool :=
  P.P0 == Q.P0 && P.P1 == Q.P1 && P.P2 == Q.P2 && P.P3 == Q.P3 && P.P4 == Q.P4

/-- The return value and the points as `spec` gives them: `r1` untouched on a failure. -/
private def check (e1 e2 : Nat) : Bool :=
  match
    fd_ed25519_point_frombytes_2x.eval 2
      (fd_ed25519_point_frombytes_2x.args (.value (ptr 0)) (.value (ptr 1)) (.value (ptr 2))
        (.value (ptr 3)))
      (state e1 e2),
    fd_ed25519_point_frombytes_2x.spec (BitVec.ofNat 256 e1) (BitVec.ofNat 256 e2) with
  | .value (some (.cons (.value r) .nil), s), (r', P, Q) =>
    r == r' && eqQ (s.mem.readQuad5 (ptr 2)) Q &&
      match P with
      | some P => eqQ (s.mem.readQuad5 (ptr 0)) P
      | none => s.mem.readAt (ptr 0) 1536 == 0
  | _, _ => false

#guard check 0x6666666666666666666666666666666666666666666666666666666666666658 1

#guard check 2 1

#guard check 1 2

end Tests

end MLIR.Firedancer.R52x5
