module

public import Firedancer.Ref.fd_ed25519_point_add_with_opts

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `fd_ed25519_point_add` (`ballet/ed25519/ref/fd_curve25519.c:96`). -/
def fd_ed25519_point_add.spec (A B : PointLimbs) : PointLimbs :=
  fd_ed25519_point_add_with_opts.spec A B 0#32 0#32 0#32

end

end MLIR.Firedancer.Ref
