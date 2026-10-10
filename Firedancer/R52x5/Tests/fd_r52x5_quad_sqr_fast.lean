module

public import Firedancer.R52x5.fd_r52x5_quad_sqr_fast

meta import Firedancer.R52x5.fd_r52x5_quad_sqr_fast

namespace MLIR.Firedancer.R52x5

/-- Five 32-byte blocks `0 … 4` for the out-pointers. -/
private def state : GlobalState :=
  ⟨⟨5⟩, ⟨Std.ExtHashMap.ofList ((List.range 5).map fun i => (⟨i⟩, .ofBytes 32 0))⟩⟩

private def z (i : Nat) : Pointer :=
  ⟨⟨i⟩, 0⟩

private def p : Nat :=
  2 ^ 255 - 19

/-- Coordinate `j` of `Q` as a number mod `p`. -/
private def val (Q : Quad5) (j : Nat) : Nat :=
  (Q.P0[j]!.toNat + 2 ^ 51 * Q.P1[j]!.toNat + 2 ^ 102 * Q.P2[j]!.toNat + 2 ^ 153 * Q.P3[j]!.toNat +
      2 ^ 204 * Q.P4[j]!.toNat) %
    p

/-- The stores are `spec`'s, and each coordinate is the square mod `p`. -/
private def check (X : Quad5) : Bool :=
  match
    fd_r52x5_quad_sqr_fast.eval 1
      (fd_r52x5_quad_sqr_fast.args (.value (z 0)) (.value (z 1)) (.value (z 2)) (.value (z 3))
        (.value (z 4)) (Ty.wrap X.P0) (Ty.wrap X.P1) (Ty.wrap X.P2) (Ty.wrap X.P3) (Ty.wrap X.P4))
      state with
  | .value (some .nil, s') =>
    let R : Quad5 :=
      ⟨s'.mem.readWv (z 0), s'.mem.readWv (z 1), s'.mem.readWv (z 2), s'.mem.readWv (z 3),
        s'.mem.readWv (z 4)⟩
    let S := fd_r52x5_quad_sqr_fast.spec X
    R.P0 == S.P0 && R.P1 == S.P1 && R.P2 == S.P2 && R.P3 == S.P3 && R.P4 == S.P4 &&
      (List.range 4).all fun j => val R j == val X j * val X j % p
  | _ => false

private def m52 : BitVec 64 :=
  2 ^ 52 - 1

#guard
  check
    ⟨wl 1 2 m52 0x123456789AB, wl 0 3 m52 0xFEDCBA98765, wl 0 4 m52 7, wl 0 5 m52 0,
      wl 0 6 m52 0x8000000000000⟩

end MLIR.Firedancer.R52x5
