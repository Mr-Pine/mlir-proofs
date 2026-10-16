module

/-! Shared pieces of the `fd_bmtree` translation: `Outcome` (a value or C undefined
behaviour), the `util/bits` helpers bmtree uses, and bounds-checked byte-region accesses. -/

namespace Firedancer.Bmtree

@[expose] public section

/-! ## Outcomes -/

/-- A C computation's result: a value, or undefined behaviour at the named site. -/
inductive Outcome (α : Type) where
  | ok (a : α)
  | ub (site : String)
deriving Repr, DecidableEq, Inhabited

instance : Monad Outcome where
  pure := .ok
  bind x f := match x with
    | .ok a => f a
    | .ub s => .ub s

/-- The value, or `d` on `ub`. -/
def Outcome.getD {α : Type} (x : Outcome α) (d : α) : α :=
  match x with
  | .ok a => a
  | .ub _ => d

/-! ## `util/bits/fd_bits.h` -/

/-- `x<<s` on `ulong`; UB when `s ≥ 64`. -/
def shl (x s : BitVec 64) (site : String) : Outcome (BitVec 64) :=
  if s < 64#64 then .ok (x <<< s.toNat) else .ub site

/-- `x>>s` on `ulong`; UB when `s ≥ 64`. -/
def shr (x s : BitVec 64) (site : String) : Outcome (BitVec 64) :=
  if s < 64#64 then .ok (x >>> s.toNat) else .ub site

/-- `fd_ulong_min` (`fd_bits.h:205`). -/
def fd_ulong_min (x y : BitVec 64) : BitVec 64 := if x < y then x else y

/-- `fd_ulong_if` (`fd_bits.h:202`): `c ? t : f`, both arms evaluated. -/
def fd_ulong_if (c : Bool) (t f : BitVec 64) : BitVec 64 := if c then t else f

/-- `fd_ulong_is_pow2` (`fd_bits.h:175`): `(!!x) & (!(x & (x-1)))`. -/
def fd_ulong_is_pow2 (x : BitVec 64) : Bool := (x != 0#64) && (x &&& (x - 1#64) == 0#64)

/-- `fd_ulong_mask_lsb` (`fd_bits.h:183`): `(((ulong)(n<64))<<(n&63))-1`, `n` an `int`. -/
def fd_ulong_mask_lsb (n : BitVec 32) : BitVec 64 :=
  ((if n.slt 64#32 then 1#64 else 0#64) <<< (n &&& 63#32).toNat) - 1#64

/-- `fd_ulong_insert_lsb` (`fd_bits.h:188`): `(x & ~mask_lsb(n)) | y`. -/
def fd_ulong_insert_lsb (x : BitVec 64) (n : BitVec 32) (y : BitVec 64) : BitVec 64 :=
  (x &&& ~~~(fd_ulong_mask_lsb n)) ||| y

/-- `fd_ulong_align_up` (`fd_bits.h:200`): `a--; (x+a) & ~a`. -/
def fd_ulong_align_up (x a : BitVec 64) : BitVec 64 :=
  let a := a - 1#64
  (x + a) &&& ~~~a

/-- `fd_ulong_pow2_up` (`fd_bits.h:327`), literally (wraps to 0 above `2^63`). -/
def fd_ulong_pow2_up (x : BitVec 64) : BitVec 64 :=
  let x := x - 1#64
  let x := x ||| (x >>> 1)
  let x := x ||| (x >>> 2)
  let x := x ||| (x >>> 4)
  let x := x ||| (x >>> 8)
  let x := x ||| (x >>> 16)
  let x := x ||| (x >>> 32)
  x + 1#64

/-- Index of the lowest set bit of a nonzero `x`. -/
def ctz (x : BitVec 64) : Nat := ((List.range 64).find? (fun i => x.getLsbD i)).getD 64

/-- Index of the highest set bit of a nonzero `x`. -/
def msb (x : BitVec 64) : Nat := ((List.range 64).reverse.find? (fun i => x.getLsbD i)).getD 0

/-- `fd_ulong_find_lsb` (`fd_bits_find_lsb.h:17`): `__builtin_ctzl`, UB at 0. -/
def fd_ulong_find_lsb (x : BitVec 64) : Outcome (BitVec 32) :=
  if x = 0#64 then .ub "fd_ulong_find_lsb(0)" else .ok (BitVec.ofNat 32 (ctz x))

/-- `fd_ulong_find_msb_w_default` (`fd_bits_find_msb.h:116,141`): `d` at 0. -/
def fd_ulong_find_msb_w_default (x : BitVec 64) (d : BitVec 32) : BitVec 32 :=
  if x = 0#64 then d else BitVec.ofNat 32 (msb x)

/-- `fd_uint_bswap` (`fd_bits.h:240`). -/
def fd_uint_bswap (x : BitVec 32) : BitVec 32 :=
  x.extractLsb' 0 8 ++ x.extractLsb' 8 8 ++ x.extractLsb' 16 8 ++ x.extractLsb' 24 8

/-- `fd_ulong_bswap` (`fd_bits.h:241`). -/
def fd_ulong_bswap (x : BitVec 64) : BitVec 64 :=
  x.extractLsb' 0 8 ++ x.extractLsb' 8 8 ++ x.extractLsb' 16 8 ++ x.extractLsb' 24 8 ++
    x.extractLsb' 32 8 ++ x.extractLsb' 40 8 ++ x.extractLsb' 48 8 ++ x.extractLsb' 56 8

/-- `fd_uint_rotate_left` (`fd_bits.h:209`) for `n` in `[0,32)`. -/
def fd_uint_rotate_left (x : BitVec 32) (n : Nat) : BitVec 32 := x.rotateLeft n

/-! ## Byte regions

A pointer is modelled as an `Array (BitVec 8)` (the bytes from the pointer to the end of its
object) plus a byte offset. Accesses past the end are `ub`. -/

/-- The `n` bytes at `mem+off`. -/
def readBytes (mem : Array (BitVec 8)) (off n : Nat) (site : String) :
    Outcome (Array (BitVec 8)) :=
  if off + n ≤ mem.size then .ok (mem.extract off (off + n)) else .ub site

/-- `mem` after `memcpy( mem+off, src, src.size )`. -/
def writeBytes (mem : Array (BitVec 8)) (off : Nat) (src : Array (BitVec 8)) (site : String) :
    Outcome (Array (BitVec 8)) :=
  if off + src.size ≤ mem.size then
    .ok (Id.run do
      let mut m := mem
      for i in [0:src.size] do
        m := m.set! (off + i) src[i]!
      return m)
  else .ub site

/-- `mem` after `memset( mem+off, 0, n )`. -/
def zeroBytes (mem : Array (BitVec 8)) (off n : Nat) (site : String) :
    Outcome (Array (BitVec 8)) :=
  if off + n ≤ mem.size then writeBytes mem off (Array.replicate n 0#8) site else .ub site

/-- `FD_LOAD( ulong, mem+off )`, little-endian. -/
def loadULong (mem : Array (BitVec 8)) (off : Nat) (site : String) : Outcome (BitVec 64) := do
  let b ← readBytes mem off 8 site
  pure (b[7]! ++ b[6]! ++ b[5]! ++ b[4]! ++ b[3]! ++ b[2]! ++ b[1]! ++ b[0]!)

/-- The 8 little-endian bytes of `x`. -/
def bytesOfULong (x : BitVec 64) : Array (BitVec 8) :=
  #[x.extractLsb' 0 8, x.extractLsb' 8 8, x.extractLsb' 16 8, x.extractLsb' 24 8,
    x.extractLsb' 32 8, x.extractLsb' 40 8, x.extractLsb' 48 8, x.extractLsb' 56 8]

/-- `mem` after `FD_STORE( ulong, mem+off, x )`, little-endian. -/
def storeULong (mem : Array (BitVec 8)) (off : Nat) (x : BitVec 64) (site : String) :
    Outcome (Array (BitVec 8)) :=
  writeBytes mem off (bytesOfULong x) site

/-- `a[i]` for a caller array indexed `[0,a.size)`. -/
def arrGet {α : Type} [Inhabited α] (a : Array α) (i : Nat) (site : String) : Outcome α :=
  if h : i < a.size then .ok a[i] else .ub site

/-- `fd_memeq( a, b, n )` (`util/fd_util_base.h:1224`) on already-read bytes. -/
def fd_memeq (a b : Array (BitVec 8)) : Bool := a == b

end

end Firedancer.Bmtree
