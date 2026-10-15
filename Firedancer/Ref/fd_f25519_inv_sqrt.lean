module

public import Firedancer.Ref.Globals
public import Firedancer.Ref.fd_f25519_sqrt_ratio

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `fd_f25519_inv_sqrt` (`ballet/ed25519/fd_f25519.h:210`). -/
def fd_f25519_inv_sqrt.spec (v : Fin 5 → BitVec 64) : fd_f25519_sqrt_ratio.Result :=
  fd_f25519_sqrt_ratio.spec fd_f25519_one.limbs v

end

end MLIR.Firedancer.Ref
