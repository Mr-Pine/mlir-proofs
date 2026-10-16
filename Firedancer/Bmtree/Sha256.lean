module

public import Firedancer.Bmtree.Basic

/-! The SHA-256 interface bmtree is translated over (`Sha256`, with the batch API modelled
by its `fd_sha256.h` contract), and a literal translation of the portable SHA-256
(`FD_SHA256_CORE_IMPL==0`, `FD_SHA256_BATCH_IMPL==0`) that instantiates it. -/

namespace Firedancer.Bmtree

@[expose] public section

/-- The SHA-256 bmtree uses: `hash` is `fd_sha256_hash` (`ballet/sha256/fd_sha256.h:146`), also
any `init/append/fini` chain over the same bytes (`:106-111`); `batch_max` is
`FD_SHA256_BATCH_MAX`. -/
structure Sha256 where
  hash : Array (BitVec 8) → Vector (BitVec 8) 32
  batch_max : Nat
  batch_max_pos : 0 < batch_max

/-- An in-progress `fd_sha256_batch_t` (`fd_sha256.h:227-296`): the queued messages, each with
the slot its digest goes to. -/
abbrev fd_sha256_batch_t := Array (Array (BitVec 8) × Nat)

/-- `fd_sha256_batch_init` (`fd_sha256.h:250`): an empty batch. -/
def fd_sha256_batch_init : fd_sha256_batch_t := #[]

/-- `fd_sha256_batch_add` (`fd_sha256.h:283`): queue the message bytes (unchanged until fini, by
contract) and the digest slot. -/
def fd_sha256_batch_add (batch : fd_sha256_batch_t) (data : Array (BitVec 8)) (hash : Nat) :
    fd_sha256_batch_t :=
  batch.push (data, hash)

/-- `fd_sha256_batch_fini` (`fd_sha256.h:296`): every queued slot of `dst` gets its message's
digest; slots past `dst` are `ub`. -/
def fd_sha256_batch_fini {n : Nat} (sha : Sha256) (batch : fd_sha256_batch_t)
    (dst : Vector (Vector (BitVec 8) 32) n) : Outcome (Vector (Vector (BitVec 8) 32) n) :=
  batch.foldlM (init := dst) fun d (m, slot) =>
    if h : slot < n then .ok (d.set slot (sha.hash m)) else .ub "fd_sha256_batch_fini: hash slot"

/-! ## Portable SHA-256 (`ballet/sha256/fd_sha256.c`) -/

/-- `fd_sha256_K` (`ballet/sha256/fd_sha256_constants.h:7`). -/
def fd_sha256_K : Vector (BitVec 32) 64 := #v[
  0x428a2f98#32, 0x71374491#32, 0xb5c0fbcf#32, 0xe9b5dba5#32, 0x3956c25b#32, 0x59f111f1#32,
  0x923f82a4#32, 0xab1c5ed5#32, 0xd807aa98#32, 0x12835b01#32, 0x243185be#32, 0x550c7dc3#32,
  0x72be5d74#32, 0x80deb1fe#32, 0x9bdc06a7#32, 0xc19bf174#32, 0xe49b69c1#32, 0xefbe4786#32,
  0x0fc19dc6#32, 0x240ca1cc#32, 0x2de92c6f#32, 0x4a7484aa#32, 0x5cb0a9dc#32, 0x76f988da#32,
  0x983e5152#32, 0xa831c66d#32, 0xb00327c8#32, 0xbf597fc7#32, 0xc6e00bf3#32, 0xd5a79147#32,
  0x06ca6351#32, 0x14292967#32, 0x27b70a85#32, 0x2e1b2138#32, 0x4d2c6dfc#32, 0x53380d13#32,
  0x650a7354#32, 0x766a0abb#32, 0x81c2c92e#32, 0x92722c85#32, 0xa2bfe8a1#32, 0xa81a664b#32,
  0xc24b8b70#32, 0xc76c51a3#32, 0xd192e819#32, 0xd6990624#32, 0xf40e3585#32, 0x106aa070#32,
  0x19a4c116#32, 0x1e376c08#32, 0x2748774c#32, 0x34b0bcb5#32, 0x391c0cb3#32, 0x4ed8aa4a#32,
  0x5b9cca4f#32, 0x682e6ff3#32, 0x748f82ee#32, 0x78a5636f#32, 0x84c87814#32, 0x8cc70208#32,
  0x90befffa#32, 0xa4506ceb#32, 0xbef9a3f7#32, 0xc67178f2#32]

/-- `FD_SHA256_INITIAL_{A..H}` (`fd_sha256_constants.h:18-25`). -/
def FD_SHA256_INITIAL : Vector (BitVec 32) 8 := #v[
  0x6a09e667#32, 0xbb67ae85#32, 0x3c6ef372#32, 0xa54ff53a#32,
  0x510e527f#32, 0x9b05688c#32, 0x1f83d9ab#32, 0x5be0cd19#32]

/-- `FD_SHA256_PRIVATE_BUF_MAX` (`fd_sha256.h:41`). -/
def FD_SHA256_PRIVATE_BUF_MAX : BitVec 64 := 64#64

/-- `FD_SHA256_PRIVATE_LG_BUF_MAX` (`fd_sha256.h:40`). -/
def FD_SHA256_PRIVATE_LG_BUF_MAX : Nat := 6

/-- `Sigma0` (`fd_sha256.c:145`). -/
def Sigma0 (x : BitVec 32) : BitVec 32 :=
  fd_uint_rotate_left x 30 ^^^ fd_uint_rotate_left x 19 ^^^ fd_uint_rotate_left x 10
/-- `Sigma1` (`fd_sha256.c:146`). -/
def Sigma1 (x : BitVec 32) : BitVec 32 :=
  fd_uint_rotate_left x 26 ^^^ fd_uint_rotate_left x 21 ^^^ fd_uint_rotate_left x 7
/-- `sigma0` (`fd_sha256.c:147`). -/
def sigma0 (x : BitVec 32) : BitVec 32 :=
  fd_uint_rotate_left x 25 ^^^ fd_uint_rotate_left x 14 ^^^ (x >>> 3)
/-- `sigma1` (`fd_sha256.c:148`). -/
def sigma1 (x : BitVec 32) : BitVec 32 :=
  fd_uint_rotate_left x 15 ^^^ fd_uint_rotate_left x 13 ^^^ (x >>> 10)
/-- `Ch` (`fd_sha256.c:149`). -/
def Ch (x y z : BitVec 32) : BitVec 32 := (x &&& y) ^^^ (~~~x &&& z)
/-- `Maj` (`fd_sha256.c:150`). -/
def Maj (x y z : BitVec 32) : BitVec 32 := (x &&& y) ^^^ (x &&& z) ^^^ (y &&& z)

/-- `FD_LOAD( uint, b+off )`, little-endian; `b` holds at least `off+4` bytes. -/
def loadUInt (b : Array (BitVec 8)) (off : Nat) : BitVec 32 :=
  b[off + 3]! ++ b[off + 2]! ++ b[off + 1]! ++ b[off]!

/-- One block of `fd_sha256_core_ref`'s `do` body (`fd_sha256.c:153-206`); `W` holds 64
bytes. -/
def fd_sha256_core_ref.block (state : Vector (BitVec 32) 8) (W : Array (BitVec 8)) :
    Vector (BitVec 32) 8 := Id.run do
  let mut a := state[0]
  let mut b := state[1]
  let mut c := state[2]
  let mut d := state[3]
  let mut e := state[4]
  let mut f := state[5]
  let mut g := state[6]
  let mut h := state[7]
  let mut X : Vector (BitVec 32) 16 := Vector.replicate 16 0#32
  for i in [0:16] do
    X := X.set! i (fd_uint_bswap (loadUInt W (i * 4)))
    let T1 := X[i]! + h + Sigma1 e + Ch e f g + fd_sha256_K[i]!
    let T2 := Sigma0 a + Maj a b c
    h := g; g := f; f := e; e := d + T1; d := c; c := b; b := a; a := T1 + T2
  for i in [16:64] do
    let s0 := X[(i + 1) % 16]!
    let s1 := X[(i + 14) % 16]!
    let s0 := sigma0 s0
    let s1 := sigma1 s1
    X := X.set! (i % 16) (X[i % 16]! + (s0 + s1 + X[(i + 9) % 16]!))
    let T1 := X[i % 16]! + h + Sigma1 e + Ch e f g + fd_sha256_K[i]!
    let T2 := Sigma0 a + Maj a b c
    h := g; g := f; f := e; e := d + T1; d := c; c := b; b := a; a := T1 + T2
  return #v[state[0] + a, state[1] + b, state[2] + c, state[3] + d,
    state[4] + e, state[5] + f, state[6] + g, state[7] + h]

/-- `fd_sha256_core_ref( state, block+off, block_cnt )` (`fd_sha256.c:139`): a `do`/`while(
--block_cnt )`, so `block_cnt==0` runs 2^64 blocks (reads past `block`: `ub`). -/
def fd_sha256_core_ref (state : Vector (BitVec 32) 8) (block : Array (BitVec 8)) (off : Nat)
    (block_cnt : BitVec 64) : Outcome (Vector (BitVec 32) 8) :=
  if h : off + 64 ≤ block.size then
    let state := fd_sha256_core_ref.block state (block.extract off (off + 64))
    let block_cnt := block_cnt - 1#64
    if block_cnt ≠ 0#64 then fd_sha256_core_ref state block (off + 64) block_cnt else .ok state
  else .ub "fd_sha256_core_ref: block past the data"
termination_by block.size - off

/-- `fd_sha256_t` (`fd_sha256.h:43`). -/
structure fd_sha256_t where
  buf : Array (BitVec 8)
  state : Vector (BitVec 32) 8
  magic : BitVec 64
  buf_used : BitVec 64
  bit_cnt : BitVec 64
deriving Repr, DecidableEq, Inhabited

/-- `fd_sha256_init` (`fd_sha256.c:384`): `buf` and `magic` keep their bytes. -/
def fd_sha256_init (sha : fd_sha256_t) : fd_sha256_t :=
  { sha with state := FD_SHA256_INITIAL, buf_used := 0#64, bit_cnt := 0#64 }

/-- `fd_sha256_append( sha, mem+_data, sz )` (`fd_sha256.c:399`). -/
def fd_sha256_append (sha : fd_sha256_t) (mem : Array (BitVec 8)) (_data : Nat)
    (sz : BitVec 64) : Outcome fd_sha256_t := do
  if sz = 0#64 then return sha
  let buf_used := sha.buf_used
  let bit_cnt := sha.bit_cnt
  let mut sha := { sha with bit_cnt := bit_cnt + (sz <<< 3) }
  let mut data := _data
  let mut sz := sz
  if buf_used ≠ 0#64 then
    let buf_rem := FD_SHA256_PRIVATE_BUF_MAX - buf_used
    if sz < buf_rem then
      let src ← readBytes mem data sz.toNat "fd_sha256_append: data"
      let buf ← writeBytes sha.buf buf_used.toNat src "fd_sha256_append: buf"
      return { sha with buf, buf_used := buf_used + sz }
    let src ← readBytes mem data buf_rem.toNat "fd_sha256_append: data"
    let buf ← writeBytes sha.buf buf_used.toNat src "fd_sha256_append: buf"
    data := data + buf_rem.toNat
    sz := sz - buf_rem
    let state ← fd_sha256_core_ref sha.state buf 0 1#64
    sha := { sha with buf, state, buf_used := 0#64 }
  let block_cnt := sz >>> FD_SHA256_PRIVATE_LG_BUF_MAX
  if block_cnt ≠ 0#64 then
    let state ← fd_sha256_core_ref sha.state mem data block_cnt
    sha := { sha with state }
  let buf_used := sz &&& (FD_SHA256_PRIVATE_BUF_MAX - 1#64)
  if buf_used ≠ 0#64 then
    let src ← readBytes mem (data + (block_cnt <<< FD_SHA256_PRIVATE_LG_BUF_MAX).toNat)
      buf_used.toNat "fd_sha256_append: data"
    let buf ← writeBytes sha.buf 0 src "fd_sha256_append: buf"
    sha := { sha with buf, buf_used }
  return sha

/-- The 32 digest bytes `memcpy( hash, state, 32 )` copies after the in-place bswaps. -/
def digestBytes (state : Vector (BitVec 32) 8) : Vector (BitVec 8) 32 :=
  Vector.ofFn fun j => (state[j.val / 4]'(by omega)).extractLsb' (8 * (j.val % 4)) 8

/-- `fd_sha256_fini` (`fd_sha256.c:465`): the new `sha` (state bswapped, `buf` padded) and
the 32 bytes written to `hash`. -/
def fd_sha256_fini (sha : fd_sha256_t) : Outcome (fd_sha256_t × Vector (BitVec 8) 32) := do
  let mut state := sha.state
  let mut buf := sha.buf
  let mut buf_used := sha.buf_used
  let bit_cnt := sha.bit_cnt
  buf ← writeBytes buf buf_used.toNat #[0x80#8] "fd_sha256_fini: buf"
  buf_used := buf_used + 1#64
  if buf_used > FD_SHA256_PRIVATE_BUF_MAX - 8#64 then
    buf ← zeroBytes buf buf_used.toNat (FD_SHA256_PRIVATE_BUF_MAX - buf_used).toNat
      "fd_sha256_fini: buf"
    state ← fd_sha256_core_ref state buf 0 1#64
    buf_used := 0#64
  buf ← zeroBytes buf buf_used.toNat (FD_SHA256_PRIVATE_BUF_MAX - 8#64 - buf_used).toNat
    "fd_sha256_fini: buf"
  buf ← storeULong buf (FD_SHA256_PRIVATE_BUF_MAX - 8#64).toNat (fd_ulong_bswap bit_cnt)
    "fd_sha256_fini: buf"
  state ← fd_sha256_core_ref state buf 0 1#64
  state := state.map fd_uint_bswap
  return ({ sha with state, buf }, digestBytes state)

/-- `fd_sha256_hash( data+off, sz, hash )` (`fd_sha256.c:512`): the 32 bytes written. -/
def fd_sha256_hash (data : Array (BitVec 8)) (off : Nat) (sz : BitVec 64) :
    Outcome (Vector (BitVec 8) 32) := do
  let mut buf : Array (BitVec 8) := Array.replicate 64 0#8  -- indeterminate; never read unwritten
  let mut state := FD_SHA256_INITIAL
  let block_cnt := sz >>> FD_SHA256_PRIVATE_LG_BUF_MAX
  if block_cnt ≠ 0#64 then state ← fd_sha256_core_ref state data off block_cnt
  let mut buf_used := sz &&& (FD_SHA256_PRIVATE_BUF_MAX - 1#64)
  if buf_used ≠ 0#64 then
    let src ← readBytes data (off + (block_cnt <<< FD_SHA256_PRIVATE_LG_BUF_MAX).toNat)
      buf_used.toNat "fd_sha256_hash: data"
    buf ← writeBytes buf 0 src "fd_sha256_hash: buf"
  buf ← writeBytes buf buf_used.toNat #[0x80#8] "fd_sha256_hash: buf"
  buf_used := buf_used + 1#64
  if buf_used > FD_SHA256_PRIVATE_BUF_MAX - 8#64 then
    buf ← zeroBytes buf buf_used.toNat (FD_SHA256_PRIVATE_BUF_MAX - buf_used).toNat
      "fd_sha256_hash: buf"
    state ← fd_sha256_core_ref state buf 0 1#64
    buf_used := 0#64
  let bit_cnt := sz <<< 3
  buf ← zeroBytes buf buf_used.toNat (FD_SHA256_PRIVATE_BUF_MAX - 8#64 - buf_used).toNat
    "fd_sha256_hash: buf"
  buf ← storeULong buf (FD_SHA256_PRIVATE_BUF_MAX - 8#64).toNat (fd_ulong_bswap bit_cnt)
    "fd_sha256_hash: buf"
  state ← fd_sha256_core_ref state buf 0 1#64
  return digestBytes (state.map fd_uint_bswap)

/-- The portable build's interface: `fd_sha256_hash` over the whole message, and
`FD_SHA256_BATCH_MAX = 1` (`fd_sha256.h:325`, whose `batch_add` hashes at once). -/
def Sha256.portable : Sha256 where
  hash m := (fd_sha256_hash m 0 (BitVec.ofNat 64 m.size)).getD (Vector.replicate 32 0#8)
  batch_max := 1
  batch_max_pos := by decide

end

end Firedancer.Bmtree
