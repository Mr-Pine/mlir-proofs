module

public import Firedancer.Common.Point
public import Firedancer.Ref.Globals
public import Firedancer.Ref.fd_f25519_tobytes
public import Firedancer.Ref.fd_f25519_sqr
public import Firedancer.Ref.fd_f25519_mul
public import Firedancer.Ref.fd_f25519_add
public import Firedancer.Ref.fd_f25519_sub
public import Firedancer.Ref.fd_f25519_neg
public import Firedancer.Ref.fd_f25519_abs
public import Firedancer.Ref.fd_f25519_if
public import Firedancer.Ref.fd_f25519_sgn
public import Firedancer.Ref.fd_f25519_inv_sqrt

namespace MLIR.Firedancer.Ref

/-! ## Specification

`buf` as a little-endian 256-bit value. `fd_ed25519_point_to` copies the coordinates. -/

@[expose] public section

/-- The limbs of `fd_f25519_invsqrt_a_minus_d`
(`ballet/ed25519/table/fd_f25519_table_ref.c:48`), `1/√(a-d)`. -/
def fd_f25519_invsqrt_a_minus_d.limbs : Fin 5 → BitVec 64 := fun i =>
  #v[0x0000fdaa805d40ea#64, 0x0002eb482e57d339#64, 0x000007610274bc58#64, 0x0006510b613dc8ff#64,
      0x000786c8905cfaff#64][i]

/-- `fd_ristretto255_point_tobytes` (`ballet/ed25519/fd_ristretto255.c:74`): the bytes stored at
`buf`. -/
def fd_ristretto255_point_tobytes.spec (h : PointLimbs) : BitVec 256 :=
  let x := h.X
  let y := h.Y
  let z := h.Z
  let t := h.T
  let tmp0 := fd_f25519_add.spec z y
  let tmp1 := fd_f25519_sub.spec z y
  let u1 := fd_f25519_mul.spec tmp0 tmp1
  let u2 := fd_f25519_mul.spec x y
  let u2_sq := fd_f25519_sqr.spec u2
  let tmp1 := fd_f25519_mul.spec u1 u2_sq
  let inv_sqrt := (fd_f25519_inv_sqrt.spec tmp1).r
  let den1 := fd_f25519_mul.spec inv_sqrt u1
  let den2 := fd_f25519_mul.spec inv_sqrt u2
  let z_inv := fd_f25519_mul.spec den1 den2
  let z_inv := fd_f25519_mul.spec z_inv t
  let ix0 := fd_f25519_mul.spec x fd_f25519_sqrtm1.limbs
  let iy0 := fd_f25519_mul.spec y fd_f25519_sqrtm1.limbs
  let enchanted_denominator := fd_f25519_mul.spec den1 fd_f25519_invsqrt_a_minus_d.limbs
  let rotate_ := fd_f25519_mul.spec t z_inv
  let rotate := fd_f25519_sgn.spec rotate_
  let x := fd_f25519_if.spec rotate iy0 x
  let y := fd_f25519_if.spec rotate ix0 y
  let den_inv := fd_f25519_if.spec rotate enchanted_denominator den2
  let _isneg := fd_f25519_mul.spec x z_inv
  let isneg := fd_f25519_sgn.spec _isneg
  let y_neg := fd_f25519_neg.spec y
  let y := fd_f25519_if.spec isneg y_neg y
  let s := fd_f25519_sub.spec z y
  let s := fd_f25519_mul.spec s den_inv
  let s := fd_f25519_abs.spec s
  fd_f25519_tobytes.spec s

end

end MLIR.Firedancer.Ref
