module

public import Firedancer.R52x5.fd_ed25519_point_neg_precomputed

meta import Firedancer.R52x5.fd_ed25519_point_neg_precomputed

namespace MLIR.Firedancer.R52x5

private def p : Nat :=
  2 ^ 255 - 19

/-- Limb `i` (51 bits) of `n`. -/
private def limb (n i : Nat) : BitVec 64 :=
  BitVec.ofNat 64 (n / 2 ^ (51 * i) % 2 ^ 51)

/-- The table point `(Y-X, Y+X, 2Z, 2dT)` = `(u, v, w, d)` in the QUAD layout. -/
private def quad (u v w d : Nat) : Quad5 :=
  ⟨wl (limb u 0) (limb v 0) (limb w 0) (limb d 0), wl (limb u 1) (limb v 1) (limb w 1) (limb d 1),
    wl (limb u 2) (limb v 2) (limb w 2) (limb d 2), wl (limb u 3) (limb v 3) (limb w 3) (limb d 3),
    wl (limb u 4) (limb v 4) (limb w 4) (limb d 4)⟩

/-- Coordinate `j` of `Q` mod `p`. -/
private def val (Q : Quad5) (j : Nat) : Nat :=
  (Q.P0[j]!.toNat + 2 ^ 51 * Q.P1[j]!.toNat + 2 ^ 102 * Q.P2[j]!.toNat + 2 ^ 153 * Q.P3[j]!.toNat +
      2 ^ 204 * Q.P4[j]!.toNat) %
    p

private def A : Quad5 :=
  quad 0x1234567890ABCDEF1234567890ABCDEF (2 ^ 255 - 20) 2 (2 ^ 200 + 12345)

/-- Points `a` (block 0) and `r` (block 1), 192 bytes each, `A` at `a`. -/
private def state : GlobalState :=
  let m : MemoryState := ⟨Std.ExtHashMap.ofList [(⟨0⟩, .ofBytes 192 0), (⟨1⟩, .ofBytes 192 0)]⟩
  ⟨⟨2⟩, m.storeQuad5 ⟨⟨0⟩, 0⟩ A⟩

/-- `-A` stored at `r`, `r` returned, five blocks used: `Y-X` and `Y+X` swapped, `-2dT` mod
`p`. -/
private def check (r a : Pointer) : Bool :=
  match
    fd_ed25519_point_neg_precomputed.eval 1
      (fd_ed25519_point_neg_precomputed.args (.value r) (.value a)) state with
  | .value (some (.cons (.value r') .nil), s') =>
    let R := s'.mem.readQuad5 r
    let S := fd_ed25519_point_neg_precomputed.spec A
    r' == r && s'.alloc.nextFreeBlock == 7 && R.P0 == S.P0 && R.P1 == S.P1 && R.P2 == S.P2 &&
      R.P3 == S.P3 &&
      R.P4 == S.P4 &&
      val R 0 == val A 1 &&
      val R 1 == val A 0 &&
      val R 2 == val A 2 &&
      val R 3 == (p - val A 3) % p
  | _ => false

-- into another point, and in place
#guard check ⟨⟨1⟩, 0⟩ ⟨⟨0⟩, 0⟩ && check ⟨⟨0⟩, 0⟩ ⟨⟨0⟩, 0⟩

end MLIR.Firedancer.R52x5
