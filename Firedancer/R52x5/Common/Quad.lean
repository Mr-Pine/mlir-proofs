module

public import Firedancer.Common.Point
public import Firedancer.R52x5.Common.Wl

/-! `FD_R52X5_QUAD`: four field elements `X, Y, Z, T` lane-wise in five `wl_t`s, and the macros of
`fd_r52x5_inl.h` on it, as functions. -/

namespace MLIR.Firedancer.R52x5

@[expose] public section

open Firedancer.Avx512 (Wwl wwl)

/-- An `FD_R52X5_QUAD` `Q0 … Q4`: lane `j` of `Qi` is limb `i` of coordinate `j` (`X, Y, Z, T`). -/
structure Quad5 where
  P0 : Wl
  P1 : Wl
  P2 : Wl
  P3 : Wl
  P4 : Wl

namespace Quad5

/-- `Qi`. -/
def limb (Q : Quad5) (i : Fin 5) : Wl :=
  #v[Q.P0, Q.P1, Q.P2, Q.P3, Q.P4][i]

/-- The limbs of coordinate `j` (`0 1 2 3` for `X Y Z T`). -/
def elem (Q : Quad5) (j : Fin 4) : Fin 5 → BitVec 64 := fun i => (Q.limb i)[j]

/-- The point in the limb layout of `fd_ed25519_point_t` elsewhere: `X, Y, T, Z`. -/
def toPoint (Q : Quad5) : PointLimbs :=
  ⟨Q.elem 0, Q.elem 1, Q.elem 3, Q.elem 2⟩

/-- `FD_R52X5_QUAD_PERMUTE( D, imm0,imm1,imm2,imm3, S )`: coordinate `k` of `D` is `S`'s `immk`. -/
def permute (i0 i1 i2 i3 : Nat) (S : Quad5) : Quad5 :=
  ⟨wlPermute S.P0 i0 i1 i2 i3, wlPermute S.P1 i0 i1 i2 i3, wlPermute S.P2 i0 i1 i2 i3,
    wlPermute S.P3 i0 i1 i2 i3, wlPermute S.P4 i0 i1 i2 i3⟩

/-- `FD_R52X5_QUAD_LANE_IF( D, imm0,imm1,imm2,imm3, S, T )`: coordinate `k` from `S` where `immk`,
else from `T`. -/
def laneIf (i0 i1 i2 i3 : Nat) (S T : Quad5) : Quad5 :=
  let b0 := i0 != 0
  let b1 := i1 != 0
  let b2 := i2 != 0
  let b3 := i3 != 0
  ⟨wlBlend b0 b1 b2 b3 S.P0 T.P0, wlBlend b0 b1 b2 b3 S.P1 T.P1, wlBlend b0 b1 b2 b3 S.P2 T.P2,
    wlBlend b0 b1 b2 b3 S.P3 T.P3, wlBlend b0 b1 b2 b3 S.P4 T.P4⟩

/-- `FD_R52X5_QUAD_ADD_FAST( R, P, Q )`. -/
def addFast (P Q : Quad5) : Quad5 :=
  ⟨wl_add P.P0 Q.P0, wl_add P.P1 Q.P1, wl_add P.P2 Q.P2, wl_add P.P3 Q.P3, wl_add P.P4 Q.P4⟩

/-- `FD_R52X5_QUAD_NEGATE_LAZY( D, S )`: `32 p - S`. -/
def negateLazy (S : Quad5) : Quad5 :=
  let _lo := wl_bcast 0xFFFFFFFFFFFDA0
  let _hi := wl_bcast 0xFFFFFFFFFFFFE0
  ⟨wl_sub _lo S.P0, wl_sub _hi S.P1, wl_sub _hi S.P2, wl_sub _hi S.P3, wl_sub _hi S.P4⟩

/-- `FD_R52X5_QUAD_DIFF_SUM( D, S )`: `[Y-X, X+Y, T-Z, Z+T]`. -/
def diffSum (S : Quad5) : Quad5 :=
  let _tmp1 := S.permute 1 0 3 2
  let _tmp2 := S.negateLazy
  let _tmp2 := laneIf 1 0 1 0 _tmp2 S
  addFast _tmp1 _tmp2

/-- `FD_R52X5_QUAD_REDUCE( D, S )`: each limb's carry above bit 51 into the next, limb 4's times
19 into limb 0. -/
def reduce (S : Quad5) : Quad5 :=
  let _mask := wl_bcast 2251799813685247
  let _r19 := wl_bcast 19
  let _c0 := wl_shru S.P0 51
  let _c1 := wl_shru S.P1 51
  let _c2 := wl_shru S.P2 51
  let _c3 := wl_shru S.P3 51
  let _c4 := wl_shru S.P4 51
  ⟨wl_madd52lo (wl_and S.P0 _mask) _c4 _r19, wl_add (wl_and S.P1 _mask) _c0,
    wl_add (wl_and S.P2 _mask) _c1, wl_add (wl_and S.P3 _mask) _c2, wl_add (wl_and S.P4 _mask) _c3⟩

/-- `FD_R52X5_QUAD_MUL_CONSTANT( D, S, y )`: coordinate `k` times `y[k]`, unreduced. -/
def mulConstant (S : Quad5) (y : Wl) : Quad5 :=
  let _r19 := wl_bcast 19
  let _z0_1 := wl_madd52lo wl_zero y S.P0
  let _z1_2 := wl_madd52hi wl_zero y S.P0
  let _z1_1 := wl_madd52lo wl_zero y S.P1
  let _z2_2 := wl_madd52hi wl_zero y S.P1
  let _z2_1 := wl_madd52lo wl_zero y S.P2
  let _z3_2 := wl_madd52hi wl_zero y S.P2
  let _z3_1 := wl_madd52lo wl_zero y S.P3
  let _z4_2 := wl_madd52hi wl_zero y S.P3
  let _z4_1 := wl_madd52lo wl_zero y S.P4
  let _z5_2 := wl_madd52hi wl_zero y S.P4
  let _z0_1 := wl_madd52lo _z0_1 (wl_add _z5_2 _z5_2) _r19
  ⟨_z0_1, wl_add (wl_add _z1_1 _z1_2) _z1_2, wl_add (wl_add _z2_1 _z2_2) _z2_2,
    wl_add (wl_add _z3_1 _z3_2) _z3_2, wl_add (wl_add _z4_1 _z4_2) _z4_2⟩

/-- `FD_R52X5_QUAD_PACK( Q, x, y, z, t )`: limb `i` of `x, y, z, t` into `Qi`. -/
def pack (x y z t : Wwl) : Quad5 :=
  ⟨wl x[0] y[0] z[0] t[0], wl x[1] y[1] z[1] t[1], wl x[2] y[2] z[2] t[2], wl x[3] y[3] z[3] t[3],
    wl x[4] y[4] z[4] t[4]⟩

/-- `FD_R52X5_QUAD_UNPACK( x, y, z, t, Q )`: coordinate `j` as a field element, lanes 5-7 zero. -/
def unpack (Q : Quad5) : Wwl × Wwl × Wwl × Wwl :=
  (wwl Q.P0[0] Q.P1[0] Q.P2[0] Q.P3[0] Q.P4[0] 0 0 0,
    wwl Q.P0[1] Q.P1[1] Q.P2[1] Q.P3[1] Q.P4[1] 0 0 0,
    wwl Q.P0[2] Q.P1[2] Q.P2[2] Q.P3[2] Q.P4[2] 0 0 0,
    wwl Q.P0[3] Q.P1[3] Q.P2[3] Q.P3[3] Q.P4[3] 0 0 0)

end Quad5

/-- `FD_R52X5_GE_ZERO( P )`: the neutral point `(0, 1, 1, 0)`. -/
def quadZero : Quad5 :=
  ⟨wl 0 1 1 0, wl_zero, wl_zero, wl_zero, wl_zero⟩

/-- The point at bit `o` of `b`: `Q0 … Q4` 256 bits apart. -/
def quad5At (b : BitVec n) (o : Nat) : Quad5 :=
  ⟨Vector.ofFn fun i => b.extractLsb' (o + 64 * i.val) 64,
    Vector.ofFn fun i => b.extractLsb' (o + 256 + 64 * i.val) 64,
    Vector.ofFn fun i => b.extractLsb' (o + 512 + 64 * i.val) 64,
    Vector.ofFn fun i => b.extractLsb' (o + 768 + 64 * i.val) 64,
    Vector.ofFn fun i => b.extractLsb' (o + 1024 + 64 * i.val) 64⟩

end

end MLIR.Firedancer.R52x5
