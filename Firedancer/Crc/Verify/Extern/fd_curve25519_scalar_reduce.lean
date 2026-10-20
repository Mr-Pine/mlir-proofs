module

public import Firedancer.Ref.Mlir.fd_curve25519_scalar_reduce

/-! `fd_curve25519_scalar_reduce` is linked from Firedancer's tree, not from crc's unit: mlir-proofs' lift of the
reference C (`Firedancer.Ref.Mlir.fd_curve25519_scalar_reduce`), as their avx512 `fd_ed25519_verify` binds it. -/

namespace MLIR.Firedancer.Crc.Verify

@[expose] public section

abbrev fd_curve25519_scalar_reduce := MLIR.Firedancer.Ref.fd_curve25519_scalar_reduce

end

end MLIR.Firedancer.Crc.Verify
