module

public import Firedancer.Ref.Globals
public import Firedancer.Ref.fd_f25519_tobytes
public import Firedancer.Ref.fd_f25519_sqrt_ratio
public import Firedancer.Ref.fd_f25519_jacobi_var

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

open fd_f25519_update_fg_62_var in
/-- `fd_f25519_is_square_var` (`ballet/ed25519/fd_f25519.c:269`); `fd_ulong_load_8_fast` is a
little-endian load. -/
def fd_f25519_is_square_var.spec (a : Fin 5 → BitVec 64) : BitVec 32 :=
  let buf := fd_f25519_tobytes.spec a
  let a0 := buf.extractLsb' 0 64
  let a1 := buf.extractLsb' 64 64
  let a2 := buf.extractLsb' 128 64
  let a3 := buf.extractLsb' 192 64
  if (a0 ||| a1 ||| a2 ||| a3) = 0#64 then 1#32
  else
    let x : Vector (BitVec 64) 5 :=
      #v[a0 &&& M62, ((a0 >>> 62) ||| (a1 <<< 2)) &&& M62, ((a1 >>> 60) ||| (a2 <<< 4)) &&& M62,
        ((a2 >>> 58) ||| (a3 <<< 6)) &&& M62, a3 >>> 56]
    let jac := fd_f25519_jacobi_var.spec x
    if jac = 0#32 then (fd_f25519_sqrt_ratio.spec a fd_f25519_one.limbs).ret
    else if (0#32).slt jac then 1#32 else 0#32

end

end MLIR.Firedancer.Ref
