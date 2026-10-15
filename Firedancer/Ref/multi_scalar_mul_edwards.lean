module

public import Firedancer.Ref.fd_curve25519_scalar_validate
public import Firedancer.Ref.fd_ed25519_point_frombytes
public import Firedancer.Ref.fd_ed25519_point_set_zero
public import Firedancer.Ref.fd_ed25519_point_add
public import Firedancer.Ref.fd_ed25519_multi_scalar_mul

namespace MLIR.Firedancer.Ref

/-! ## Specification

The static helper of `flamenco/vm/syscall/fd_vm_syscall_curve.c`, no VM memory or compute
units. `scalars j` and `points j` are the 32 bytes at `scalars + 32*j` and `points + 32*j`
(little-endian 256-bit values); `r₀` is what `*r` holds on entry. -/

@[expose] public section

/-- What `*r` holds on return, and the returned pointer's point (`none` for `NULL`). -/
structure multi_scalar_mul_edwards.Result where
  r : PointLimbs
  ret : Option PointLimbs

namespace multi_scalar_mul_edwards

/-- `for( ulong j=0UL; j<batch_cnt; j++ )`: the points decoded into `A[0..batch_cnt)`, or `none`
at the first that fails. Entries past `batch_cnt` are never read. -/
def decode (points : Nat → BitVec 256) (batch_cnt : Nat) : Option (Nat → PointLimbs) :=
  (List.range batch_cnt).foldlM
    (fun A j =>
      (fd_ed25519_point_frombytes.spec (points j)).map fun P k => if k = j then P else A k)
    (fun _ => fd_ed25519_point_set_zero.spec)

/-- The batch loop (`fd_vm_syscall_curve.c:471-486`) from `i` on `r`, `k` batches left;
`points`, `scalars` advanced past the done batches. -/
def loop (cnt : Nat) :
    (k : Nat) → (i : Nat) → (scalars points : Nat → BitVec 256) → PointLimbs → Result
  | 0, _, _, _, r => ⟨r, some r⟩
  | k + 1, i, scalars, points, r =>
    if i < cnt then
      let batch_cnt := min (cnt - i) fd_ed25519_multi_scalar_mul.BATCH_SZ
      match decode points batch_cnt with
      | none => ⟨r, none⟩
      | some A =>
        let tmp := fd_ed25519_multi_scalar_mul.spec scalars A (BitVec.ofNat 64 batch_cnt)
        let r := fd_ed25519_point_add.spec r tmp
        loop cnt k (i + fd_ed25519_multi_scalar_mul.BATCH_SZ) (fun j => scalars (batch_cnt + j))
          (fun j => points (batch_cnt + j)) r
    else ⟨r, some r⟩

end multi_scalar_mul_edwards

open multi_scalar_mul_edwards in
/-- `multi_scalar_mul_edwards` (`flamenco/vm/syscall/fd_vm_syscall_curve.c:455`). -/
def multi_scalar_mul_edwards.spec (r₀ : PointLimbs) (scalars points : Nat → BitVec 256)
    (cnt : BitVec 64) : Result :=
  if (List.range cnt.toNat).all fun i => fd_curve25519_scalar_validate.spec (scalars i) then
    let r := fd_ed25519_point_set_zero.spec
    loop cnt.toNat (cnt.toNat / fd_ed25519_multi_scalar_mul.BATCH_SZ + 1) 0 scalars points r
  else ⟨r₀, none⟩

end

end MLIR.Firedancer.Ref
