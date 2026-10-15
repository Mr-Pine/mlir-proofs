module

public import Mathlib.Data.Int.GCD

/-! `fd_bits.h` and `fd_uint256.h` helpers reached by `fd_secp256k1_recover`, the byte and limb
views of C memory (little-endian: x86-64 and aarch64), and the naturals the library contracts
are stated in. -/

namespace Firedancer.Secp256k1

@[expose] public section

/-! ## Memory views

A C array `T a[n]` is a `Vector T n`. -/

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

/-- `fd_ulong_if` (`util/bits/fd_bits.h:202`): `c ? t : f`. -/
def fd_ulong_if.spec (c : BitVec 32) (t f : BitVec 64) : BitVec 64 :=
  if c ≠ 0#32 then t else f

/-! ## `fd_uint256.h` -/

/-- `fd_uint256_bswap` (`ballet/bigint/fd_uint256.h:31`); all of `a` is read before `r` is
written, so `r` may alias `a`. -/
def fd_uint256_bswap.spec (a : fd_uint256_t) : fd_uint256_t :=
  let r3 := fd_ulong_bswap.spec a[0]
  let r2 := fd_ulong_bswap.spec a[1]
  let r1 := fd_ulong_bswap.spec a[2]
  let r0 := fd_ulong_bswap.spec a[3]
  #v[r0, r1, r2, r3]

/-- `fd_uint256_eq` (`ballet/bigint/fd_uint256.h:61`): the `int` value of the `&&` chain. -/
def fd_uint256_eq.spec (a b : fd_uint256_t) : BitVec 32 :=
  if a[0] = b[0] ∧ a[1] = b[1] ∧ a[2] = b[2] ∧ a[3] = b[3] then 1#32 else 0#32

/-- `fd_uint256_cmp` (`ballet/bigint/fd_uint256.h:77`): `0`, `-1` or `1`; the loop
`for( int i=3; i>=0; i-- )` unrolled. -/
def fd_uint256_cmp.spec (a b : fd_uint256_t) : BitVec 32 :=
  if a[3] ≠ b[3] then (if a[3] > b[3] then 1#32 else -1#32) else
  if a[2] ≠ b[2] then (if a[2] > b[2] then 1#32 else -1#32) else
  if a[1] ≠ b[1] then (if a[1] > b[1] then 1#32 else -1#32) else
  if a[0] ≠ b[0] then (if a[0] > b[0] then 1#32 else -1#32) else
  0#32

end

end Firedancer.Secp256k1
