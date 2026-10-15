module

public import Firedancer.Common.Point
public import Firedancer.Ref.fd_f25519_mul
public import Firedancer.Ref.fd_f25519_neg
public import Firedancer.Ref.fd_f25519_eq

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `fd_ristretto255_point_eq_neg` (`ballet/ed25519/fd_ristretto255.h:93`); `x[0], y[0]` from `p`,
`x[1], y[1]` from `q`. -/
def fd_ristretto255_point_eq_neg.spec (p q : PointLimbs) : BitVec 32 :=
  let neg := fd_f25519_neg.spec p.X
  let cmp0 := fd_f25519_mul.spec neg q.Y
  let cmp1 := fd_f25519_mul.spec q.X p.Y
  let xx := fd_f25519_eq.spec cmp0 cmp1
  let cmp0 := fd_f25519_mul.spec neg q.X
  let cmp1 := fd_f25519_mul.spec p.Y q.Y
  let yy := fd_f25519_eq.spec cmp0 cmp1
  xx ||| yy

end

end MLIR.Firedancer.Ref
