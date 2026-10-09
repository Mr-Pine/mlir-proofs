module

public import Firedancer.R52x5.Globals
public import Firedancer.R52x5.fd_f25519_add
public import Firedancer.R52x5.fd_f25519_sub
public import Firedancer.R52x5.fd_f25519_neg
public import Firedancer.R52x5.fd_f25519_if
public import Firedancer.R52x5.fd_f25519_mul
public import Firedancer.R52x5.fd_f25519_sqr
public import Firedancer.R52x5.fd_f25519_frombytes
public import Firedancer.R52x5.fd_f25519_is_nonzero
public import Firedancer.R52x5.fd_f25519_sgn
public import Firedancer.R52x5.fd_r52x5_quad_mul_fast
public import Firedancer.R52x5.fd_r52x5_quad_sqr_fast

/-! `fd_r52x5_ge_decode2`'s specification: each encoding up to its power (`Pre`), the power
`FD_R52X5_POW22523_QUAD` of both at once, then each encoding's checks (`Dec`) and point. -/

namespace MLIR.Firedancer.R52x5

open Firedancer.Avx512 (Wwl wwl)

@[expose] public section

namespace fd_r52x5_ge_decode2

/-- `QP_SQR( D, S )`. -/
def sqrQ (S : Quad5) : Quad5 :=
  (fd_r52x5_quad_sqr_fast.spec S).reduce

/-- `QP_MUL( D, A, B )`. -/
def mulQ (A B : Quad5) : Quad5 :=
  (fd_r52x5_quad_mul_fast.spec A B).reduce

/-- `n` in-place `QP_SQR`s, as a loop does them. -/
def sqrNQ : Nat → Quad5 → Quad5
  | 0, S => S
  | n + 1, S => sqrNQ n (sqrQ S)

/-- `FD_R52X5_POW22523_QUAD( D, A )`: each lane to the power `2^252 - 3`. -/
def pow22523Q (A : Quad5) : Quad5 :=
  let t0 := sqrQ A
  let t1 := sqrQ t0
  let t1 := sqrNQ 1 t1
  let t1 := mulQ A t1
  let t0 := mulQ t0 t1
  let t0 := sqrQ t0
  let t0 := mulQ t1 t0
  let t1 := sqrQ t0
  let t1 := sqrNQ 4 t1
  let t0 := mulQ t1 t0
  let t1 := sqrQ t0
  let t1 := sqrNQ 9 t1
  let t1 := mulQ t1 t0
  let t2 := sqrQ t1
  let t2 := sqrNQ 19 t2
  let t1 := mulQ t2 t1
  let t1 := sqrQ t1
  let t1 := sqrNQ 9 t1
  let t0 := mulQ t1 t0
  let t1 := sqrQ t0
  let t1 := sqrNQ 49 t1
  let t1 := mulQ t1 t0
  let t2 := sqrQ t1
  let t2 := sqrNQ 99 t2
  let t1 := mulQ t2 t1
  let t1 := sqrQ t1
  let t1 := sqrNQ 49 t1
  let t0 := mulQ t1 t0
  let t0 := sqrQ t0
  let t0 := sqrNQ 1 t0
  mulQ t0 A

/-- One encoding up to the power: the sign `x_0`, `y`, `u = y² - 1`, `v = d y² + 1`, `u v³` and
`u v⁷`. -/
structure Pre where
  x0 : BitVec 32
  y : Wwl
  u : Wwl
  v : Wwl
  uv3 : Wwl
  uv7 : Wwl

/-- The encoding `s` with bit 255 cleared, as the copy `buf2` holds it. -/
def yBits (s : BitVec 256) : BitVec 256 :=
  Memory.spliceBits s 248 (s.extractLsb' 248 8 &&& 127#8)

/-- The encoding `s` up to the power. -/
def pre (s : BitVec 256) : Pre :=
  let x0 := (s.extractLsb' 248 8).setWidth 32 >>> 7
  let y := fd_f25519_frombytes.spec (yBits s)
  let ysq := fd_f25519_sqr.spec y
  let u := fd_f25519_sub.spec ysq fd_f25519_one.vec
  let v := fd_f25519_mul.spec fd_f25519_d.vec ysq
  let v := fd_f25519_add.spec v fd_f25519_one.vec
  let v2 := fd_f25519_sqr.spec v
  let v4 := fd_f25519_sqr.spec v2
  let v3 := fd_f25519_mul.spec v v2
  let uv3 := fd_f25519_mul.spec u v3
  let uv7 := fd_f25519_mul.spec uv3 v4
  ⟨x0, y, u, v, uv3, uv7⟩

/-- One encoding through its checks: `Pre`'s values, the candidate root `x`, and whether
`t1 = v x² - u` and `t2 = v x² + u` are nonzero. -/
structure Dec where
  x0 : BitVec 32
  y : Wwl
  u : Wwl
  v : Wwl
  x : Wwl
  t1nz : BitVec 32
  t2nz : BitVec 32

/-- The checks of `A`, its power `(u v⁷)^((p-5)/8)` being `xp`. -/
def dec (A : Pre) (xp : Wwl) : Dec :=
  let x := fd_f25519_mul.spec xp A.uv3
  let x2 := fd_f25519_sqr.spec x
  let vx2 := fd_f25519_mul.spec A.v x2
  let t1 := fd_f25519_sub.spec vx2 A.u
  let t2 := fd_f25519_add.spec vx2 A.u
  ⟨A.x0, A.y, A.u, A.v, x, fd_f25519_is_nonzero.spec t1, fd_f25519_is_nonzero.spec t2⟩

/-- No root: neither `t1` nor `t2` is zero. -/
def Dec.err (D : Dec) : Bool :=
  D.t2nz &&& D.t1nz != 0

/-- The decoded point `(x, y, 1, x y)`: `x` times `√-1` if `t1` is nonzero, negated unless its
sign is `x_0`. -/
def Dec.point (D : Dec) : Quad5 :=
  let t3 := fd_f25519_if.spec D.t1nz fd_f25519_sqrtm1.vec fd_f25519_one.vec
  let x := fd_f25519_mul.spec D.x t3
  let x_mod_2 := fd_f25519_sgn.spec x
  let neg_x := fd_f25519_neg.spec x
  let x := fd_f25519_if.spec ((BitVec.ofBool (x_mod_2 != D.x0)).setWidth 32) neg_x x
  let xy := fd_f25519_mul.spec x D.y
  Quad5.pack x D.y fd_f25519_one.vec xy

/-- `_Quv`: `u v⁷` of `A` in lanes 0 and 2, of `B` in lanes 1 and 3. -/
def quv (A B : Pre) : Quad5 :=
  Quad5.pack A.uv7 B.uv7 A.uv7 B.uv7

/-- Both encodings through their checks: the power's lane 0 is `A`'s, lane 1 `B`'s. -/
def decs (sa sb : BitVec 256) : Dec × Dec :=
  let A := pre sa
  let B := pre sb
  let Qx := (pow22523Q (quv A B)).unpack
  (dec A Qx.1, dec B Qx.2.1)

end fd_r52x5_ge_decode2

open fd_r52x5_ge_decode2 in
/-- `fd_r52x5_ge_decode2` of the encodings `sa` and `sb`: `0` and both points; else `-1` if `sa`
has no root, `-2` if `sb` has none, `Pa` untouched (`none`) and `Pb` the neutral point. -/
def fd_r52x5_ge_decode2.spec (sa sb : BitVec 256) : BitVec 32 × Option Quad5 × Quad5 :=
  let D := decs sa sb
  if D.1.err then (-1, none, quadZero)
  else if D.2.err then (-2, none, quadZero) else (0, some D.1.point, D.2.point)

end

end MLIR.Firedancer.R52x5
