module

public import Mathlib.Data.Int.GCD

/-! Memory views (little-endian: x86-64 and aarch64), the `fd_bits.h` helper the G1 code reaches,
and `ballet/bigint/fd_uint256.h`, `fd_uint256_mul.h` (`FD_HAS_INT128`, portable `#else` of every
`FD_HAS_X86` intrinsic and of the ADX inline-asm CIOS). -/

namespace Firedancer.Bn254

@[expose] public section

/-! ## Memory views

A C array `T a[n]` is a `Vector T n`; `ulong` = `BitVec 64`, `uchar` = `BitVec 8`, `int` =
`BitVec 32`, `uint128` = `BitVec 128`. -/

/-- `union fd_uint256` (`ballet/bigint/fd_uint256.h:23`), by its `ulong limbs[4]` member. -/
abbrev fd_uint256_t := Vector (BitVec 64) 4

/-- The `uchar buf[32]` member of a `fd_uint256_t`: the limbs' bytes, little-endian. -/
def fd_uint256_t.buf (a : fd_uint256_t) : Vector (BitVec 8) 32 :=
  Vector.ofFn fun j => a[j.val / 8].extractLsb' (8 * (j.val % 8)) 8

/-- The limbs of a `fd_uint256_t` whose `buf` is `b` (`memcpy( r, b, 32 )`), little-endian. -/
def fd_uint256_t.ofBuf (b : Vector (BitVec 8) 32) : fd_uint256_t :=
  Vector.ofFn fun i =>
    (b[8 * i.val + 7] ++ b[8 * i.val + 6] ++ b[8 * i.val + 5] ++ b[8 * i.val + 4] ++
      b[8 * i.val + 3] ++ b[8 * i.val + 2] ++ b[8 * i.val + 1] ++ b[8 * i.val] : BitVec 64)

/-- `dst` after `memcpy( dst + off, src, m )`. -/
def storeBytes {n m : Nat} (dst : Vector (BitVec 8) n) (off : Nat) (src : Vector (BitVec 8) m) :
    Vector (BitVec 8) n :=
  Vector.ofFn fun j => if h : off ≤ j.val ∧ j.val - off < m then src[j.val - off] else dst[j]

/-- The `m` bytes at `src + off`. -/
def loadBytes {n : Nat} (src : Vector (BitVec 8) n) (off m : Nat) (h : off + m ≤ n := by omega) :
    Vector (BitVec 8) m :=
  Vector.ofFn fun j => src[off + j.val]

/-- `fd_memeq( a, b, n )` (`util/fd_util_base.h:1224`, portable `memcmp`): `1` iff equal. -/
def fd_memeq {n : Nat} (a b : Vector (BitVec 8) n) : BitVec 32 :=
  if a = b then 1 else 0

/-- The value of `k` little-endian 64-bit limbs (s2n-bignum's `bignum_from_memory`, fiat's
`eval`). -/
def limbsEval {k : Nat} (a : Vector (BitVec 64) k) : Nat :=
  Nat.fold k (fun i h acc => acc + a[i].toNat * 2 ^ (64 * i)) 0

/-- The `k` little-endian 64-bit limbs of `v mod 2^(64k)`. -/
def limbsOfNat (k : Nat) (v : Nat) : Vector (BitVec 64) k :=
  Vector.ofFn fun i => BitVec.ofNat 64 (v >>> (64 * i.val))

/-- The canonical inverse of `a` modulo `m` (meaningful when `gcd a m = 1`). -/
def invMod (a m : Nat) : Nat :=
  (Nat.gcdA a m % (m : Int)).toNat

/-! ## `fd_bits.h` -/

/-- `fd_ulong_bswap` (`util/bits/fd_bits.h:241`): `__builtin_bswap64`. -/
def fd_ulong_bswap.spec (x : BitVec 64) : BitVec 64 :=
  (x.extractLsb' 0 8 ++ x.extractLsb' 8 8 ++ x.extractLsb' 16 8 ++ x.extractLsb' 24 8 ++
    x.extractLsb' 32 8 ++ x.extractLsb' 40 8 ++ x.extractLsb' 48 8 ++ x.extractLsb' 56 8 :
    BitVec 64)

/-! ## `fd_uint256.h` -/

/-- `fd_uint256_bswap` (`ballet/bigint/fd_uint256.h:32`); reads all of `a` before writing `r`, so
`r` may alias `a`. -/
def fd_uint256_bswap.spec (a : fd_uint256_t) : fd_uint256_t :=
  let r3 := fd_ulong_bswap.spec a[0]
  let r2 := fd_ulong_bswap.spec a[1]
  let r1 := fd_ulong_bswap.spec a[2]
  let r0 := fd_ulong_bswap.spec a[3]
  #v[r0, r1, r2, r3]

/-- `fd_uint256_eq` (`ballet/bigint/fd_uint256.h:62`): the `int` value of the `&&` chain. -/
def fd_uint256_eq.spec (a b : fd_uint256_t) : BitVec 32 :=
  if a[0] = b[0] ∧ a[1] = b[1] ∧ a[2] = b[2] ∧ a[3] = b[3] then 1 else 0

/-- `fd_uint256_is_zero` (`ballet/bigint/fd_uint256.h:72`). -/
def fd_uint256_is_zero.spec (a : fd_uint256_t) : BitVec 32 :=
  if (a[0] ||| a[1] ||| a[2] ||| a[3]) = 0 then 1 else 0

/-- `fd_uint256_cmp` (`ballet/bigint/fd_uint256.h:78`): `0`, `-1` or `1`; the loop
`for( int i=3; i>=0; i-- )` unrolled. -/
def fd_uint256_cmp.spec (a b : fd_uint256_t) : BitVec 32 :=
  if a[3] ≠ b[3] then (if a[3] > b[3] then 1 else -1) else
  if a[2] ≠ b[2] then (if a[2] > b[2] then 1 else -1) else
  if a[1] ≠ b[1] then (if a[1] > b[1] then 1 else -1) else
  if a[0] ≠ b[0] then (if a[0] > b[0] then 1 else -1) else
  0

/-- `fd_uint256_bit` (`ballet/bigint/fd_uint256.h:91`) for `0 ≤ i < 256` (every call site):
`a->limbs[i / 64] & (1UL << (i % 64))`, zero or non-zero. -/
def fd_uint256_bit.spec (a : fd_uint256_t) (i : Nat) (h : i < 256) : BitVec 64 :=
  a[i / 64] &&& (1#64 <<< (i % 64))

/-! ## `fd_uint256_mul.h` -/

/-- `fd_ulong_sub_borrow` (`ballet/bigint/fd_uint256_mul.h:36`), the `#else` (non-`FD_HAS_X86`)
branch as fixed in 8e5473de39: `(*r, *b)`. -/
def fd_ulong_sub_borrow.spec (a0 a1 : BitVec 64) (bi : BitVec 32) : BitVec 64 × BitVec 32 :=
  let r0 := a0 - a1
  let r1 := r0 - (if bi ≠ 0 then 1 else 0)
  let b : BitVec 32 := (if a0 < a1 then 1 else 0) ||| (if r0 < r1 then 1 else 0)
  (r1, b)

/-- `fd_ulong_vec_mul` (`ballet/bigint/fd_uint256_mul.h:74`, `FD_HAS_INT128`): `(l, h)`, the low
and high halves of the four `uint128` products `a[j] * b`. -/
def fd_ulong_vec_mul.spec (a : Vector (BitVec 64) 4) (b : BitVec 64) :
    Vector (BitVec 64) 4 × Vector (BitVec 64) 4 :=
  let r0 : BitVec 128 := a[0].setWidth 128 * b.setWidth 128
  let r1 : BitVec 128 := a[1].setWidth 128 * b.setWidth 128
  let r2 : BitVec 128 := a[2].setWidth 128 * b.setWidth 128
  let r3 : BitVec 128 := a[3].setWidth 128 * b.setWidth 128
  (#v[r0.setWidth 64, r1.setWidth 64, r2.setWidth 64, r3.setWidth 64],
    #v[(r0 >>> 64).setWidth 64, (r1 >>> 64).setWidth 64, (r2 >>> 64).setWidth 64,
      (r3 >>> 64).setWidth 64])

/-- `fd_ulong_add_carry4` (`ballet/bigint/fd_uint256_mul.h:86`, `FD_HAS_INT128`): `(*l, *h)` of
the `uint128` sum `a0 + a1 + a2 + a3`. -/
def fd_ulong_add_carry4.spec (a0 a1 a2 : BitVec 64) (a3 : BitVec 8) : BitVec 64 × BitVec 8 :=
  let r : BitVec 128 := a0.setWidth 128 + a1.setWidth 128 + a2.setWidth 128 + a3.setWidth 128
  (r.setWidth 64, (r >>> 64).setWidth 8)

/-- One iteration `i` of the CIOS loop of `fd_uint256_mul_mod_p` (`fd_uint256_mul.h:192-207`):
`t` after the body, for `b->limbs[i] = bi`. -/
def fd_uint256_mul_mod_p.iter (a p : fd_uint256_t) (p_inv : BitVec 64) (t : Vector (BitVec 64) 4)
    (bi : BitVec 64) : Vector (BitVec 64) 4 :=
  let (l, u) := fd_ulong_vec_mul.spec a bi
  let (t0, c0) := fd_ulong_add_carry4.spec t[0] l[0] 0 0
  let t := t.set 0 t0
  let (t1, c0) := fd_ulong_add_carry4.spec t[1] l[1] u[0] c0
  let t := t.set 1 t1
  let (t2, c0) := fd_ulong_add_carry4.spec t[2] l[2] u[1] c0
  let t := t.set 2 t2
  let (t3, c0) := fd_ulong_add_carry4.spec t[3] l[3] u[2] c0
  let t := t.set 3 t3
  let m := t[0] * p_inv
  let (l, h) := fd_ulong_vec_mul.spec p m
  let (_tmp, c1) := fd_ulong_add_carry4.spec t[0] l[0] 0 0
  let (t0, c1) := fd_ulong_add_carry4.spec t[1] l[1] h[0] c1
  let t := t.set 0 t0
  let (t1, c1) := fd_ulong_add_carry4.spec t[2] l[2] h[1] c1
  let t := t.set 1 t1
  let (t2, c1) := fd_ulong_add_carry4.spec t[3] l[3] h[2] c1
  let t := t.set 2 t2
  -- `u[3] + h[3] + c0 + c1`: the `uchar`s promote to `int`, then convert to `ulong`.
  let t := t.set 3 (u[3] + h[3] + c0.setWidth 64 + c1.setWidth 64)
  t

/-- `fd_uint256_mul_mod_p` (`ballet/bigint/fd_uint256_mul.h:165`), the portable `#else` branch
(not the BMI2/ADX inline asm of `fd_uint256_mul.inc`): CIOS, then one conditional subtraction
of `p`. `r` is stored only after the loop, from the local `t`, so `r` may alias `a` or `b`. -/
def fd_uint256_mul_mod_p.spec (a b p : fd_uint256_t) (p_inv : BitVec 64) : fd_uint256_t :=
  let t : Vector (BitVec 64) 4 := #v[0, 0, 0, 0]
  let t := fd_uint256_mul_mod_p.iter a p p_inv t b[0]
  let t := fd_uint256_mul_mod_p.iter a p p_inv t b[1]
  let t := fd_uint256_mul_mod_p.iter a p p_inv t b[2]
  let t := fd_uint256_mul_mod_p.iter a p p_inv t b[3]
  let r : fd_uint256_t := #v[t[0], t[1], t[2], t[3]]
  if (0#32).sle (fd_uint256_cmp.spec r p) then
    let b : BitVec 32 := 0
    let (r0, b) := fd_ulong_sub_borrow.spec r[0] p[0] b
    let r := r.set 0 r0
    let (r1, b) := fd_ulong_sub_borrow.spec r[1] p[1] b
    let r := r.set 1 r1
    let (r2, b) := fd_ulong_sub_borrow.spec r[2] p[2] b
    let r := r.set 2 r2
    let (r3, _b) := fd_ulong_sub_borrow.spec r[3] p[3] b
    let r := r.set 3 r3
    r
  else r

end

end Firedancer.Bn254
