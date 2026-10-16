module

/-! `util/bits` helpers reached by the leader schedule, little-endian byte views of C memory
(x86-64 and aarch64), `memcmp`, and `Fueled`, the result of a C loop run under fuel. -/

namespace Firedancer.Leaders

@[expose] public section

/-! ## Fuel -/

/-- A C loop run under fuel: finished (`done`) or out of fuel (`outOfFuel`, no C
counterpart). -/
inductive Fueled (α : Type) where
  | done (a : α)
  | outOfFuel
deriving Repr, DecidableEq, Inhabited

instance : Monad Fueled where
  pure := .done
  bind x f := match x with
    | .done a => f a
    | .outOfFuel => .outOfFuel

/-! ## Memory views -/

/-- `fd_pubkey_t` (`flamenco/fd_flamenco_base.h:35`), by its `uchar uc[32]` member. -/
abbrev fd_pubkey_t := Vector (BitVec 8) 32

/-- `FD_LOAD( ulong, buf+off )`, little-endian; reads past `buf` give `0` (never reached). -/
def loadULong {n : Nat} (buf : Vector (BitVec 8) n) (off : Nat) : BitVec 64 :=
  (buf[off + 7]! ++ buf[off + 6]! ++ buf[off + 5]! ++ buf[off + 4]! ++
    buf[off + 3]! ++ buf[off + 2]! ++ buf[off + 1]! ++ buf[off]! : BitVec 64)

/-- The `uint` view of 4·`k` bytes (a `memcpy` of bytes into a `uint` array). -/
def uintsOfBytes {k : Nat} (b : Vector (BitVec 8) (4 * k)) : Vector (BitVec 32) k :=
  Vector.ofFn fun i =>
    (b[4 * i.val + 3]'(by omega) ++ b[4 * i.val + 2]'(by omega) ++
      b[4 * i.val + 1]'(by omega) ++ b[4 * i.val]'(by omega) : BitVec 32)

/-- The byte view of `k` `uint`s. -/
def bytesOfUints {k : Nat} (w : Vector (BitVec 32) k) : Vector (BitVec 8) (4 * k) :=
  Vector.ofFn fun j => (w[j.val / 4]'(by omega)).extractLsb' (8 * (j.val % 4)) 8

/-- `dst` after `memcpy( dst+off, src, m )`; bytes past `dst` are dropped (never reached). -/
def storeBytes {n m : Nat} (dst : Vector (BitVec 8) n) (off : Nat) (src : Vector (BitVec 8) m) :
    Vector (BitVec 8) n :=
  Vector.ofFn fun j => if h : off ≤ j.val ∧ j.val - off < m then src[j.val - off] else dst[j]

/-- The `m` bytes at `src+off` (`memcpy( dst, src+off, m )`); reads past `src` give `0`
(never reached). -/
def loadBytes {n : Nat} (src : Vector (BitVec 8) n) (off m : Nat) : Vector (BitVec 8) m :=
  Vector.ofFn fun j => src[off + j.val]!

/-- The sign of `memcmp( a, b, n )` (all C fixes, all callers use): first differing
`unsigned char`. -/
def memcmp {n : Nat} (a b : Vector (BitVec 8) n) : Int :=
  go 0
where
  go (i : Nat) : Int :=
    if h : i < n then
      if a[i] = b[i] then go (i + 1) else if a[i] < b[i] then -1 else 1
    else 0
  termination_by n - i

/-! ## `fd_bits.h` -/

/-- `fd_ulong_if` (`util/bits/fd_bits.h:202`): `c ? t : f`. Both arms are evaluated. -/
def fd_ulong_if.spec (c : BitVec 32) (t f : BitVec 64) : BitVec 64 :=
  if c ≠ 0#32 then t else f

/-- `fd_ulong_is_aligned` (`util/bits/fd_bits.h:197`): `a--; !(x & a)`. -/
def fd_ulong_is_aligned.spec (x a : BitVec 64) : BitVec 32 :=
  let a := a - 1#64
  if x &&& a = 0#64 then 1#32 else 0#32

/-- `fd_ulong_align_up` (`util/bits/fd_bits.h:200`): `a--; (x+a) & ~a`. -/
def fd_ulong_align_up.spec (x a : BitVec 64) : BitVec 64 :=
  let a := a - 1#64
  (x + a) &&& ~~~a

/-- `FD_ULONG_ALIGN_UP` (`util/bits/fd_bits.h:609`): `((x)+((a)-1UL)) & (~((a)-1UL))`. -/
def FD_ULONG_ALIGN_UP (x a : BitVec 64) : BitVec 64 :=
  (x + (a - 1#64)) &&& ~~~(a - 1#64)

/-- `fd_ulong_min` (`util/bits/fd_bits.h:205`): `(x<y) ? x : y`. -/
def fd_ulong_min.spec (x y : BitVec 64) : BitVec 64 := if x < y then x else y

/-- `fd_ulong_max` (`util/bits/fd_bits.h:206`): `(x>y) ? x : y`. -/
def fd_ulong_max.spec (x y : BitVec 64) : BitVec 64 := if x > y then x else y

/-- `fd_uint_rotate_left` (`util/bits/fd_bits.h:209`):
`(x << (n&31)) | (x >> ((-n)&31))`, `n` an `int`. -/
def fd_uint_rotate_left.spec (x : BitVec 32) (n : BitVec 32) : BitVec 32 :=
  (x <<< (n &&& 31#32).toNat) ||| (x >>> ((-n) &&& 31#32).toNat)

/-- `__builtin_clzl`; undefined for `0` in C, `64` here (never reached, see
`fd_chacha_rng_ulong_roll.spec`). -/
def builtin_clzl (x : BitVec 64) : BitVec 32 :=
  if x = 0#64 then 64#32 else BitVec.ofNat 32 (63 - Nat.log2 x.toNat)

/-- `fd_ulong_find_msb` (`util/bits/fd_bits_find_msb.h:7`): `63 - __builtin_clzl( x )`, an
`int`. -/
def fd_ulong_find_msb.spec (x : BitVec 64) : BitVec 32 :=
  63#32 - builtin_clzl x

/-! ## `fd_uwide.h` -/

/-- `fd_uwide_mul` (`util/bits/fd_uwide.h:88`), the `FD_HAS_INT128` branch (x86-64 and aarch64
builds): `(hi, lo)` of the 128-bit product. -/
def fd_uwide_mul.spec (x y : BitVec 64) : BitVec 64 × BitVec 64 :=
  let res : BitVec 128 := x.zeroExtend 128 * y.zeroExtend 128
  (res.extractLsb' 64 64, res.extractLsb' 0 64)

end

end Firedancer.Leaders
