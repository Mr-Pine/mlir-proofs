module

public import Firedancer.R52x5.fd_curve25519_into_precomputed

meta import Firedancer.R52x5.fd_curve25519_into_precomputed

namespace MLIR.Firedancer.R52x5

private def p : Nat :=
  2 ^ 255 - 19

/-- Limb `i` (51 bits) of `n`. -/
private def limb (n i : Nat) : BitVec 64 :=
  BitVec.ofNat 64 (n / 2 ^ (51 * i) % 2 ^ 51)

/-- The point `(x, y, z, t)` in the QUAD layout. -/
private def quad (x y z t : Nat) : Quad5 :=
  ⟨wl (limb x 0) (limb y 0) (limb z 0) (limb t 0), wl (limb x 1) (limb y 1) (limb z 1) (limb t 1),
    wl (limb x 2) (limb y 2) (limb z 2) (limb t 2), wl (limb x 3) (limb y 3) (limb z 3) (limb t 3),
    wl (limb x 4) (limb y 4) (limb z 4) (limb t 4)⟩

/-- Coordinate `j` of `Q` mod `p`. -/
private def val (Q : Quad5) (j : Nat) : Nat :=
  (Q.P0[j]!.toNat + 2 ^ 51 * Q.P1[j]!.toNat + 2 ^ 102 * Q.P2[j]!.toNat + 2 ^ 153 * Q.P3[j]!.toNat +
      2 ^ 204 * Q.P4[j]!.toNat) %
    p

private def A : Quad5 :=
  quad 0x1234567890ABCDEF1234567890ABCDEF (2 ^ 255 - 20) 1 (2 ^ 200 + 12345)

/-- The point `A` at block 0, 192 bytes. -/
private def state : GlobalState :=
  let m : MemoryState := ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨192, 0⟩)]⟩
  ⟨⟨1⟩, m.storeQuad5 ⟨⟨0⟩, 0⟩ A⟩

/-- `spec A` stored in place; each coordinate `121666 (Y - X)`, `121666 (X + Y)`, `2 · 121666 Z`,
`-2 · 121665 T` mod `p`. -/
private def check : Bool :=
  let r : Pointer := ⟨⟨0⟩, 0⟩
  match
    fd_curve25519_into_precomputed.eval 1 (fd_curve25519_into_precomputed.args (.value r))
      state with
  | .value (some .nil, s') =>
    let R := s'.mem.readQuad5 r
    let S := fd_curve25519_into_precomputed.spec A
    let x := val A 0
    let y := val A 1
    R.P0 == S.P0 && R.P1 == S.P1 && R.P2 == S.P2 && R.P3 == S.P3 && R.P4 == S.P4 &&
      val R 0 == 121666 * (y + p - x) % p &&
      val R 1 == 121666 * (x + y) % p &&
      val R 2 == 2 * 121666 * val A 2 % p &&
      val R 3 == (p - 2 * 121665 * val A 3 % p) % p
  | _ => false

#guard check

end MLIR.Firedancer.R52x5
