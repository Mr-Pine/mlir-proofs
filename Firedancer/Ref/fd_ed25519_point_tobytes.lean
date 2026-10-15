module

public import Firedancer.Common.Point
public import Firedancer.Ref.fd_f25519_inv
public import Firedancer.Ref.fd_f25519_mul
public import Firedancer.Ref.fd_f25519_tobytes
public import Firedancer.Ref.fd_f25519_sgn

namespace MLIR.Firedancer.Ref

/-! ## Specification

`out` as a little-endian 256-bit value, `out[k]` at bits `8k`. `fd_ed25519_point_to` copies the
coordinates, `fd_f25519_mul2` is two `fd_f25519_mul` in order (`ref/fd_f25519.h:274`). -/

@[expose] public section

/-- `fd_ed25519_point_tobytes` (`ballet/ed25519/fd_curve25519.c:123`), with `fd_f25519_inv` as
`inv`. -/
def fd_ed25519_point_tobytes.withInv (inv : (Fin 5 → BitVec 64) → Fin 5 → BitVec 64)
    (A : PointLimbs) : BitVec 256 :=
  let x := A.X
  let y := A.Y
  let z := A.Z
  let t := inv z
  let x := fd_f25519_mul.spec x t
  let y := fd_f25519_mul.spec y t
  let out := fd_f25519_tobytes.spec y
  let b : BitVec 8 := (fd_f25519_sgn.spec x <<< 7).setWidth 8
  out ^^^ (b.setWidth 256 <<< 248)

/-- `fd_ed25519_point_tobytes`, `FD_HAS_S2NBIGNUM` unset. -/
abbrev fd_ed25519_point_tobytes.spec (A : PointLimbs) : BitVec 256 :=
  fd_ed25519_point_tobytes.withInv fd_f25519_inv.spec A

/-- `fd_ed25519_point_tobytes`, `FD_HAS_S2NBIGNUM` set. -/
abbrev fd_ed25519_point_tobytes.s2n (A : PointLimbs) : BitVec 256 :=
  fd_ed25519_point_tobytes.withInv fd_f25519_inv.s2n A

end

end MLIR.Firedancer.Ref
