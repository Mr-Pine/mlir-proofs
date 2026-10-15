module

public import Firedancer.Ref.Globals
public import Firedancer.Ref.fd_f25519_frombytes
public import Firedancer.Ref.fd_f25519_sqr
public import Firedancer.Ref.fd_f25519_mul
public import Firedancer.Ref.fd_f25519_sub
public import Firedancer.Ref.fd_f25519_add
public import Firedancer.Ref.fd_f25519_is_square_var

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `fd_ed25519_point_validate` (`ballet/ed25519/fd_curve25519.c:75`). -/
def fd_ed25519_point_validate.spec (buf : BitVec 256) : BitVec 32 :=
  let y := fd_f25519_frombytes.spec buf
  let u := fd_f25519_sqr.spec y
  let v := fd_f25519_mul.spec u fd_f25519_d.limbs
  let u := fd_f25519_sub.spec u fd_f25519_one.limbs
  let v := fd_f25519_add.spec v fd_f25519_one.limbs
  let u := fd_f25519_mul.spec u v
  fd_f25519_is_square_var.spec u

end

end MLIR.Firedancer.Ref
