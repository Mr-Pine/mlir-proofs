module

public import Firedancer.Bn254.G1

/-! `fd_bn254.c`: G1 compress/decompress and the G1 add and scalar-multiplication syscalls, and
their two builds (`.s2n`, `.ref`, by `fd_bn254_fp_inv`). Each takes the output buffer before the
call and returns it after, with the C return value. Uninitialized locals start as `default`. -/

namespace Firedancer.Bn254

@[expose] public section

/-- `dst` after `memcpy( dst, src, sz )` (`sz` at most both sizes at every call site). -/
def memcpyBytes {n m : Nat} (dst : Vector (BitVec 8) n) (src : Vector (BitVec 8) m) (sz : Nat) :
    Vector (BitVec 8) n :=
  Vector.ofFn fun j => if h : j.val < sz ∧ j.val < m then src[j.val] else dst[j]

/-! ## Compression -/

/-- What `fd_bn254_g1_compress` does: the 32 bytes at `out` after the call, and its return, `some
out` or `none` for `NULL`. -/
structure fd_bn254_g1_compress.Result where
  out : Vector (BitVec 8) 32
  ret : Option (Vector (BitVec 8) 32)
deriving Repr

/-- `fd_bn254_g1_compress` (`fd_bn254.c:6`): no curve check; the input's `y`-sign flag is
ignored. `out` is stored only on success, after the last read of `in`. -/
def fd_bn254_g1_compress.spec (out : Vector (BitVec 8) 32) (in_ : Vector (BitVec 8) 64)
    (big_endian : BitVec 32) : fd_bn254_g1_compress.Result :=
  let p : fd_bn254_g1_t := ⟨#v[0, 0, 0, 0], #v[0, 0, 0, 0], #v[0, 0, 0, 0]⟩
  let res := fd_bn254_g1_frombytes_internal.spec p in_ big_endian
  match res.ret with
  | none => ⟨out, none⟩
  | some _ =>
  let p := res.p
  let is_inf := fd_bn254_g1_is_zero.spec p
  let flag_inf : BitVec 32 :=
    (if big_endian ≠ 0 then in_[32] else in_[63]).setWidth 32 &&& FLAG_INF.setWidth 32
  if is_inf ≠ 0 then
    let out : Vector (BitVec 8) 32 := Vector.replicate 32 0
    let out :=
      if big_endian ≠ 0 then out.set 0 (out[0] ||| flag_inf.setWidth 8)
      else out.set 31 (out[31] ||| flag_inf.setWidth 8)
    ⟨out, some out⟩
  else
  let is_neg := fd_bn254_fp_is_neg_nm.spec p.Y
  let out := (fd_bn254_fp_tobytes_nm.spec p.X big_endian).buf
  let out :=
    if is_neg ≠ 0 then
      if big_endian ≠ 0 then out.set 0 (out[0] ||| FLAG_NEG) else out.set 31 (out[31] ||| FLAG_NEG)
    else out
  ⟨out, some out⟩

/-- What `fd_bn254_g1_decompress` does: the 64 bytes at `out` after the call, and its return. -/
structure fd_bn254_g1_decompress.Result where
  out : Vector (BitVec 8) 64
  ret : Option (Vector (BitVec 8) 64)
deriving Repr

/-- `fd_bn254_g1_decompress` (`fd_bn254.c:38`): `y` the square root of `x^3 + 3` whose sign
(`> (p-1)/2`) is the flag; the infinity flag skips every check but `x < p` and "not both flags".
`out` is stored only on success, after the last read of `in`. -/
def fd_bn254_g1_decompress.spec (out : Vector (BitVec 8) 64) (in_ : Vector (BitVec 8) 32)
    (big_endian : BitVec 32) : fd_bn254_g1_decompress.Result :=
  let zero : Vector (BitVec 8) 32 := Vector.replicate 32 0
  if fd_memeq in_ zero ≠ 0 then
    let out : Vector (BitVec 8) 64 := Vector.replicate 64 0
    ⟨out, some out⟩
  else
  -- `int is_inf, is_neg;` uninitialized, always stored by the call.
  let x_nm := fd_bn254_fp_frombytes_nm.spec default in_ big_endian (some (0, 0))
  match x_nm.ret with
  | none => ⟨out, none⟩
  | some _ =>
  let (is_inf, is_neg) := x_nm.flags.getD (0, 0)
  let x_nm := x_nm.r
  if is_inf ≠ 0 then
    let out : Vector (BitVec 8) 64 := Vector.replicate 64 0
    ⟨out, some out⟩
  else
  let x := fd_bn254_fp_to_mont.spec x_nm
  let x2 := fd_bn254_fp_sqr.spec x
  let x3_plus_b := fd_bn254_fp_mul.spec x2 x
  let x3_plus_b := fd_bn254_fp_add.spec x3_plus_b fd_bn254_const_b_mont
  let y := fd_bn254_fp_sqrt.spec default x3_plus_b
  match y.ret with
  | none => ⟨out, none⟩
  | some _ =>
  let y := y.r
  let y := fd_bn254_fp_from_mont.spec y
  let y := if is_neg ≠ fd_bn254_fp_is_neg_nm.spec y then fd_bn254_fp_neg_nm.spec y else y
  let out := storeBytes out 0 (fd_bn254_fp_tobytes_nm.spec x_nm big_endian).buf
  let out := storeBytes out 32 (fd_bn254_fp_tobytes_nm.spec y big_endian).buf
  ⟨out, some out⟩

/-! ## Syscalls -/

/-- What a G1 syscall does: the 64 bytes at `out` after the call (stored only on success), and
its `int` return, `0` or `-1`. -/
structure fd_bn254_g1_syscall.Result where
  out : Vector (BitVec 8) 64
  ret : BitVec 32
deriving Repr

/-- `fd_bn254_g1_add_syscall` (`fd_bn254.c:161`): `in` is the `in_sz` bytes at `in`, zero-padded
to 128 (big endian only). -/
def fd_bn254_g1_add_syscall.spec (B : Backend) (out : Vector (BitVec 8) 64) (in_sz : BitVec 64)
    (in_ : Vector (BitVec 8) in_sz.toNat) (big_endian : BitVec 32) : fd_bn254_g1_syscall.Result :=
  if in_sz > 128 then ⟨out, -1⟩ else
  if big_endian = 0 ∧ in_sz ≠ 128 then ⟨out, -1⟩ else
  let buf : Vector (BitVec 8) 128 := Vector.replicate 128 0
  let buf := memcpyBytes buf in_ in_sz.toNat
  let a := fd_bn254_g1_frombytes_check_subgroup.spec default (loadBytes buf 0 64) big_endian
  match a.ret with
  | none => ⟨out, -1⟩
  | some _ =>
  let a := a.p
  let b := fd_bn254_g1_frombytes_check_subgroup.spec default (loadBytes buf 64 64) big_endian
  match b.ret with
  | none => ⟨out, -1⟩
  | some _ =>
  let b := b.p
  let r := fd_bn254_g1_affine_add.spec B default a b
  let out := fd_bn254_g1_tobytes.spec B r big_endian
  ⟨out, 0⟩

/-- `fd_ulong_min` (`util/bits/fd_bits.h:205`): `(x<y) ? x : y`. -/
def fd_ulong_min (a b : BitVec 64) : BitVec 64 := if a < b then a else b

/-- `fd_bn254_g1_scalar_mul_syscall` (`fd_bn254.c:220`): point then 32-byte scalar, zero-padded to
96 (big endian only); the scalar is not reduced or validated. `fd_type_pun_const` (a comment-only
`asm` barrier) is the identity. -/
def fd_bn254_g1_scalar_mul_syscall.spec (B : Backend) (out : Vector (BitVec 8) 64)
    (in_sz : BitVec 64) (in_ : Vector (BitVec 8) in_sz.toNat) (big_endian : BitVec 32) :
    fd_bn254_g1_syscall.Result :=
  if in_sz > 96 then ⟨out, -1⟩ else
  if big_endian = 0 ∧ in_sz ≠ 96 then ⟨out, -1⟩ else
  let buf : Vector (BitVec 8) 96 := Vector.replicate 96 0
  let buf := memcpyBytes buf in_ (fd_ulong_min in_sz 96).toNat
  let a := fd_bn254_g1_frombytes_check_subgroup.spec default (loadBytes buf 0 64) big_endian
  match a.ret with
  | none => ⟨out, -1⟩
  | some _ =>
  let a := a.p
  let s : fd_bn254_scalar_t :=
    if big_endian ≠ 0 then fd_uint256_bswap.spec (fd_uint256_t.ofBuf (loadBytes buf 64 32))
    else fd_uint256_t.ofBuf (loadBytes buf 64 32)
  let r := fd_bn254_g1_scalar_mul.spec B default a s
  let out := fd_bn254_g1_tobytes.spec B r big_endian
  ⟨out, 0⟩

/-! ## Builds -/

/-- `fd_bn254_g1_add_syscall` with `FD_HAS_S2NBIGNUM`. -/
def fd_bn254_g1_add_syscall.s2n := fd_bn254_g1_add_syscall.spec Backend.s2n

/-- `fd_bn254_g1_add_syscall` without `FD_HAS_S2NBIGNUM`. -/
def fd_bn254_g1_add_syscall.ref := fd_bn254_g1_add_syscall.spec Backend.ref

/-- `fd_bn254_g1_scalar_mul_syscall` with `FD_HAS_S2NBIGNUM`. -/
def fd_bn254_g1_scalar_mul_syscall.s2n := fd_bn254_g1_scalar_mul_syscall.spec Backend.s2n

/-- `fd_bn254_g1_scalar_mul_syscall` without `FD_HAS_S2NBIGNUM`. -/
def fd_bn254_g1_scalar_mul_syscall.ref := fd_bn254_g1_scalar_mul_syscall.spec Backend.ref

end

end Firedancer.Bn254
