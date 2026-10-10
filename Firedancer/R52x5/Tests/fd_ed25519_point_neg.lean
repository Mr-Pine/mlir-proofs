module

public import Firedancer.R52x5.fd_ed25519_point_neg

meta import Firedancer.R52x5.fd_ed25519_point_neg

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

/-- Points `a` (block 0) and `r` (block 1), 192 bytes each, `A` at `a`. -/
private def state : GlobalState :=
  let m : MemoryState := ⟨Std.ExtHashMap.ofList [(⟨0⟩, .ofBytes 192 0), (⟨1⟩, .ofBytes 192 0)]⟩
  ⟨⟨2⟩, m.storeQuad5 ⟨⟨0⟩, 0⟩ A⟩

/-- `-A` stored at `r`, `r` returned; each coordinate `-X, Y, Z, -T` mod `p`. -/
private def check (r a : Pointer) : Bool :=
  match fd_ed25519_point_neg.eval 1 (fd_ed25519_point_neg.args (.value r) (.value a)) state with
  | .value (some (.cons (.value r') .nil), s') =>
    let R := s'.mem.readQuad5 r
    let S := fd_ed25519_point_neg.spec A
    r' == r && R.P0 == S.P0 && R.P1 == S.P1 && R.P2 == S.P2 && R.P3 == S.P3 && R.P4 == S.P4 &&
      val R 0 == (p - val A 0) % p &&
      val R 1 == val A 1 &&
      val R 2 == val A 2 &&
      val R 3 == (p - val A 3) % p
  | _ => false

-- into another point, and in place
#guard check ⟨⟨1⟩, 0⟩ ⟨⟨0⟩, 0⟩ && check ⟨⟨0⟩, 0⟩ ⟨⟨0⟩, 0⟩

end MLIR.Firedancer.R52x5
