module

public import Firedancer.Common.Point
public import Firedancer.Ref.Globals
public import Firedancer.Ref.fd_f25519_frombytes
public import Firedancer.Ref.fd_f25519_tobytes
public import Firedancer.Ref.fd_f25519_sqr
public import Firedancer.Ref.fd_f25519_mul
public import Firedancer.Ref.fd_f25519_add
public import Firedancer.Ref.fd_f25519_sub
public import Firedancer.Ref.fd_f25519_neg
public import Firedancer.Ref.fd_f25519_abs
public import Firedancer.Ref.fd_f25519_sgn
public import Firedancer.Ref.fd_f25519_is_zero
public import Firedancer.Ref.fd_f25519_inv_sqrt

namespace MLIR.Firedancer.Ref

/-! ## Specification

`buf` as a little-endian 256-bit value, `buf[k]` at bits `8k`. `fd_memeq` is `0==memcmp`;
`fd_f25519_set` and `fd_ed25519_point_from` copy. -/

@[expose] public section

/-- The limbs of `fd_f25519_two` (`ballet/ed25519/table/fd_f25519_table_ref.c:23`), 2. -/
def fd_f25519_two.limbs : Fin 5 → BitVec 64 := fun i =>
  #v[0x0000000000000002#64, 0x0000000000000000#64, 0x0000000000000000#64, 0x0000000000000000#64,
      0x0000000000000000#64][i]

/-- `fd_ristretto255_point_frombytes` (`ballet/ed25519/fd_ristretto255.c:4`): the point stored at
`h` and returned, `none` for `NULL` (`h` not written). -/
def fd_ristretto255_point_frombytes.spec (buf : BitVec 256) : Option PointLimbs :=
  let s := fd_f25519_frombytes.spec buf
  let s_check := fd_f25519_tobytes.spec s
  let ne : BitVec 32 := if buf = s_check then 0#32 else 1#32
  if (ne ||| ((buf.setWidth 8).setWidth 32 &&& 1#32)) ≠ 0#32 then none
  else
    let ss := fd_f25519_sqr.spec s
    let u1 := fd_f25519_sub.spec fd_f25519_one.limbs ss
    let u2 := fd_f25519_add.spec fd_f25519_one.limbs ss
    let u2sq := fd_f25519_sqr.spec u2
    let v := fd_f25519_sqr.spec u1
    let v := fd_f25519_mul.spec v fd_f25519_d.limbs
    let v := fd_f25519_neg.spec v
    let v := fd_f25519_sub.spec v u2sq
    let tmp1 := fd_f25519_mul.spec v u2sq
    let inv_sq := (fd_f25519_inv_sqrt.spec tmp1).r
    let was_square := (fd_f25519_inv_sqrt.spec tmp1).ret
    let den_x := fd_f25519_mul.spec inv_sq u2
    let den_y := fd_f25519_mul.spec inv_sq den_x
    let den_y := fd_f25519_mul.spec den_y v
    let tmp0 := fd_f25519_two.limbs
    let tmp0 := fd_f25519_mul.spec tmp0 s
    let tmp0 := fd_f25519_mul.spec tmp0 den_x
    let x := fd_f25519_abs.spec tmp0
    let y := fd_f25519_mul.spec u1 den_y
    let t := fd_f25519_mul.spec x y
    let not_was_square : BitVec 32 := if was_square = 0#32 then 1#32 else 0#32
    if (not_was_square ||| fd_f25519_sgn.spec t ||| fd_f25519_is_zero.spec y) ≠ 0#32 then none
    else some ⟨x, y, t, fd_f25519_one.limbs⟩

end

end MLIR.Firedancer.Ref
