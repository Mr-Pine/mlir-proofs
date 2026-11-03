module

public import Firedancer.Ref.Mlir.fd_sha512_append

/-! `fd_sha512_append` is linked from Firedancer's tree, not from crc's unit: mlir-proofs' lift of the
reference C (`Firedancer.Ref.Mlir.fd_sha512_append`), as their avx512 `fd_ed25519_verify` binds it. -/

namespace MLIR.Firedancer.Crc.Ed25519

@[expose] public section

abbrev fd_sha512_append := MLIR.Firedancer.Ref.fd_sha512_append

end

end MLIR.Firedancer.Crc.Ed25519
