module

public import Firedancer.Ref.fd_ristretto255_point_frombytes

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `fd_ristretto255_point_validate` (`ballet/ed25519/fd_ristretto255.h:59`). -/
def fd_ristretto255_point_validate.spec (buf : BitVec 256) : BitVec 32 :=
  if (fd_ristretto255_point_frombytes.spec buf).isSome then 1#32 else 0#32

end

end MLIR.Firedancer.Ref
