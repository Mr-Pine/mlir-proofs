module

public import Firedancer.R52x5.fd_r52x5_ge_is_eq

meta import Firedancer.R52x5.fd_r52x5_ge_is_eq

namespace MLIR.Firedancer.R52x5

/-- No memory: the temporaries are all the blocks. -/
private def state : GlobalState :=
  ⟨⟨0⟩, ⟨∅⟩⟩

/-- The QUAD of `X, Y, Z, T`, each limb `i` of coordinate `j` given by `f j i`. -/
private def quad (f : Nat → Nat → Nat) : Quad5 :=
  let l (i : Nat) : Wl :=
    wl (.ofNat 64 (f 0 i)) (.ofNat 64 (f 1 i)) (.ofNat 64 (f 2 i)) (.ofNat 64 (f 3 i))
  ⟨l 0, l 1, l 2, l 3, l 4⟩

/-- Whether `fd_r52x5_ge_is_eq(A, B)` returns `spec`, and that is `r`. -/
private def check (A B : Quad5) (r : BitVec 32) : Bool :=
  match
    fd_r52x5_ge_is_eq.eval 1
      (fd_r52x5_ge_is_eq.args (Ty.wrap A.P0) (Ty.wrap A.P1) (Ty.wrap A.P2) (Ty.wrap A.P3)
        (Ty.wrap A.P4) (Ty.wrap B.P0) (Ty.wrap B.P1) (Ty.wrap B.P2) (Ty.wrap B.P3) (Ty.wrap B.P4))
      state with
  | .value (some (.cons ret .nil), s') =>
    ret == .value (fd_r52x5_ge_is_eq.spec A B) && fd_r52x5_ge_is_eq.spec A B == r &&
      s'.alloc.nextFreeBlock == 22
  | _ => false

private def P : Quad5 :=
  quad fun j i => 1000003 * (j + 1) + 7919 * i

-- a point against itself, against itself scaled by 3 (each limb tripled: `3 X, 3 Y, 3 Z, 3 T`),
-- and against one with another `X`
#guard check P P 1

#guard check P (quad fun j i => 3 * (1000003 * (j + 1) + 7919 * i)) 1

#guard check P (quad fun j i => if j = 0 ∧ i = 0 then 5 else 1000003 * (j + 1) + 7919 * i) 0

end MLIR.Firedancer.R52x5
