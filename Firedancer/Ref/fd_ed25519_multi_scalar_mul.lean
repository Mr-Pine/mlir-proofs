module

public import Firedancer.Ref.fd_ed25519_point_add
public import Firedancer.Ref.fd_ed25519_multi_scalar_mul_with_opts

namespace MLIR.Firedancer.Ref

/-! ## Specification

`n j` is the scalar at `&n[32*j]`, `a j` the point `a[j]`. -/

@[expose] public section

namespace fd_ed25519_multi_scalar_mul

/-- `FD_BALLET_CURVE25519_MSM_BATCH_SZ` (`ballet/ed25519/fd_curve25519.h:19`). -/
def BATCH_SZ : Nat :=
  32

/-- The batch loop (`fd_curve25519.c:395-400`) from `i` on `r`, `k` batches left: `h` the batch's
MSM (base table unread, `base_sz = 0`), `r = r + h`. -/
def loop (n : Nat → BitVec 256) (a : Nat → PointLimbs) (sz : Nat) :
    (k : Nat) → (i : Nat) → PointLimbs → PointLimbs
  | 0, _, r => r
  | k + 1, i, r =>
    if i < sz then
      let batch_sz := min (sz - i) BATCH_SZ
      let h :=
        fd_ed25519_multi_scalar_mul_with_opts.spec (fun _ => fd_ed25519_point_set_zero.spec)
          (fun j => n (i + j)) (fun j => a (i + j)) (BitVec.ofNat 64 batch_sz) 0#64
      loop n a sz k (i + BATCH_SZ) (fd_ed25519_point_add.spec r h)
    else r

end fd_ed25519_multi_scalar_mul

/-- `fd_ed25519_multi_scalar_mul` (`ballet/ed25519/fd_curve25519.c:387`). -/
def fd_ed25519_multi_scalar_mul.spec (n : Nat → BitVec 256) (a : Nat → PointLimbs)
    (sz : BitVec 64) : PointLimbs :=
  let r := fd_ed25519_point_set_zero.spec
  fd_ed25519_multi_scalar_mul.loop n a sz.toNat
    (sz.toNat / fd_ed25519_multi_scalar_mul.BATCH_SZ + 1) 0 r

end

end MLIR.Firedancer.Ref
