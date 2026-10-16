module

public import Firedancer.Leaders.Chacha

/-! `ballet/chacha/fd_chacha_rng.{h,c}`: the ChaCha RNG, portable build (`refill_seq`,
`FD_CHACHA_RNG_BUFSZ = 256`). The x86 builds use other refills; see `TRANSLATION.md`. -/

namespace Firedancer.Leaders

@[expose] public section

/-- `FD_CHACHA_RNG_MODE_MOD` (`ballet/chacha/fd_chacha_rng.h:21`). -/
def FD_CHACHA_RNG_MODE_MOD : BitVec 32 := 1#32
/-- `FD_CHACHA_RNG_MODE_SHIFT` (`ballet/chacha/fd_chacha_rng.h:22`). -/
def FD_CHACHA_RNG_MODE_SHIFT : BitVec 32 := 2#32
/-- `FD_CHACHA_RNG_ALGO_CHACHA20` (`ballet/chacha/fd_chacha_rng.h:26`). -/
def FD_CHACHA_RNG_ALGO_CHACHA20 : BitVec 32 := 1#32
/-- `FD_CHACHA_RNG_ALGO_CHACHA8` (`ballet/chacha/fd_chacha_rng.h:27`). -/
def FD_CHACHA_RNG_ALGO_CHACHA8 : BitVec 32 := 2#32

/-- `FD_CHACHA_RNG_BUFSZ` (`ballet/chacha/fd_chacha_rng.h:32-40`), the `#else` (portable)
branch: `256UL`. -/
def FD_CHACHA_RNG_BUFSZ : Nat := 256

/-- `struct fd_chacha_rng_private` (`ballet/chacha/fd_chacha_rng.h:42`). -/
structure fd_chacha_rng_t where
  key : Vector (BitVec 8) 32
  buf : Vector (BitVec 8) FD_CHACHA_RNG_BUFSZ
  buf_off : BitVec 64
  buf_fill : BitVec 64
  mode : BitVec 32
  algo : BitVec 32
deriving Repr, DecidableEq, Inhabited

/-- `fd_chacha_rng_new` (`ballet/chacha/fd_chacha_rng.c:14`) on a non-`NULL`, aligned `shmem`
(a stack `fd_chacha_rng_t` at every call reached): `none` = `NULL` on a bad `mode`. The region
is zeroed before the mode check. -/
def fd_chacha_rng_new.spec (mode : BitVec 32) : Option fd_chacha_rng_t :=
  let rng : fd_chacha_rng_t :=
    ⟨Vector.replicate 32 0#8, Vector.replicate FD_CHACHA_RNG_BUFSZ 0#8, 0#64, 0#64, 0#32, 0#32⟩
  if mode ≠ FD_CHACHA_RNG_MODE_MOD ∧ mode ≠ FD_CHACHA_RNG_MODE_SHIFT then none
  else some { rng with mode := mode, algo := FD_CHACHA_RNG_ALGO_CHACHA20 }

/-- `fd_chacha_rng_refill_seq` (`ballet/chacha/fd_chacha_rng.c:81`): appends blocks at
`buf_fill % BUFSZ` while fewer than `BUFSZ - 64 = 192` bytes are buffered. `block_fn` maps
`(key, idx_nonce)` to the block's bytes. -/
def fd_chacha_rng_refill_seq.spec (rng : fd_chacha_rng_t)
    (block_fn : Vector (BitVec 8) 32 → Vector (BitVec 32) 4 → Vector (BitVec 8) 64) :
    fd_chacha_rng_t :=
  let fill_target : BitVec 64 := BitVec.ofNat 64 FD_CHACHA_RNG_BUFSZ - FD_CHACHA_BLOCK_SZ
  let buf_avail := rng.buf_fill - rng.buf_off
  if _h : buf_avail < fill_target then
    let idx := rng.buf_fill >>> 6
    let idx_nonce : Vector (BitVec 32) 4 :=
      #v[idx.setWidth 32, (idx >>> 32).setWidth 32, 0#32, 0#32]
    let blk := block_fn rng.key idx_nonce
    let buf := storeBytes rng.buf (rng.buf_fill % BitVec.ofNat 64 FD_CHACHA_RNG_BUFSZ).toNat blk
    fd_chacha_rng_refill_seq.spec
      { rng with buf := buf, buf_fill := rng.buf_fill + (64#32).zeroExtend 64 } block_fn
  else rng
termination_by 256 - (rng.buf_fill - rng.buf_off).toNat
decreasing_by
  simp only [fill_target, buf_avail, FD_CHACHA_RNG_BUFSZ, FD_CHACHA_BLOCK_SZ] at _h ⊢
  bv_omega

/-- `fd_chacha8_rng_refill_seq` (`ballet/chacha/fd_chacha_rng.c:98`). -/
def fd_chacha8_rng_refill_seq.spec (rng : fd_chacha_rng_t) : fd_chacha_rng_t :=
  fd_chacha_rng_refill_seq.spec rng fd_chacha8_block.spec

/-- `fd_chacha20_rng_refill_seq` (`ballet/chacha/fd_chacha_rng.c:103`). -/
def fd_chacha20_rng_refill_seq.spec (rng : fd_chacha_rng_t) : fd_chacha_rng_t :=
  fd_chacha_rng_refill_seq.spec rng fd_chacha20_block.spec

/-- `fd_chacha8_rng_private_refill` (`ballet/chacha/fd_chacha_rng.h:152-164`), portable
branch. -/
abbrev fd_chacha8_rng_private_refill.spec := fd_chacha8_rng_refill_seq.spec

/-- `fd_chacha20_rng_private_refill` (`ballet/chacha/fd_chacha_rng.h:152-164`), portable
branch. -/
abbrev fd_chacha20_rng_private_refill.spec := fd_chacha20_rng_refill_seq.spec

/-- `fd_chacha_rng_init` (`ballet/chacha/fd_chacha_rng.c:62`): `buf` keeps its old bytes; an
`algo` other than ChaCha8 refills with ChaCha20 but is stored as given. -/
def fd_chacha_rng_init.spec (rng : fd_chacha_rng_t) (key : Vector (BitVec 8) 32)
    (algo : BitVec 32) : fd_chacha_rng_t :=
  let rng := { rng with key := key, buf_off := 0#64, buf_fill := 0#64, algo := algo }
  if algo = FD_CHACHA_RNG_ALGO_CHACHA8 then fd_chacha8_rng_private_refill.spec rng
  else fd_chacha20_rng_private_refill.spec rng

/-- `fd_chacha_rng_avail` (`ballet/chacha/fd_chacha_rng.h:169`). -/
def fd_chacha_rng_avail.spec (rng : fd_chacha_rng_t) : BitVec 64 :=
  rng.buf_fill - rng.buf_off

/-- `fd_chacha_rng_ulong` (`ballet/chacha/fd_chacha_rng.h:177`): the value and the RNG after.
`buf_off` stays a multiple of 8 below `buf_fill`, so the load is inside `buf`. -/
def fd_chacha_rng_ulong.spec (rng : fd_chacha_rng_t) : BitVec 64 × fd_chacha_rng_t :=
  let rng :=
    if fd_chacha_rng_avail.spec rng < 8#64 then
      if rng.algo = FD_CHACHA_RNG_ALGO_CHACHA8 then fd_chacha8_rng_private_refill.spec rng
      else fd_chacha20_rng_private_refill.spec rng
    else rng
  let x := loadULong rng.buf (rng.buf_off % BitVec.ofNat 64 FD_CHACHA_RNG_BUFSZ).toNat
  let rng := { rng with buf_off := rng.buf_off + (8#32).zeroExtend 64 }
  (x, rng)

/-- `fd_chacha_rng_read32` (`ballet/chacha/fd_chacha_rng.h:194`): the 32 bytes and the RNG
after. Not reached by the leader schedule. -/
def fd_chacha_rng_read32.spec (rng : fd_chacha_rng_t) : Vector (BitVec 8) 32 × fd_chacha_rng_t :=
  let rng := { rng with buf_off := fd_ulong_align_up.spec rng.buf_off 32#64 }
  let rng :=
    if fd_chacha_rng_avail.spec rng < 32#64 then
      if rng.algo = FD_CHACHA_RNG_ALGO_CHACHA8 then fd_chacha8_rng_private_refill.spec rng
      else fd_chacha20_rng_private_refill.spec rng
    else rng
  let buf := loadBytes rng.buf (rng.buf_off % BitVec.ofNat 64 FD_CHACHA_RNG_BUFSZ).toNat 32
  (buf, { rng with buf_off := rng.buf_off + 32#64 })

/-- The `zone` of `fd_chacha_rng_ulong_roll` (`ballet/chacha/fd_chacha_rng.h:259`). Both arms
of `fd_ulong_if` are evaluated; for `n = 0` the C divides by zero and calls
`fd_ulong_find_msb( 0 )` (UB), which never happens in the leader schedule (`n` ≥ 1). -/
def fd_chacha_rng_ulong_roll.zone (rng : fd_chacha_rng_t) (n : BitVec 64) : BitVec 64 :=
  fd_ulong_if.spec (if rng.mode = FD_CHACHA_RNG_MODE_MOD then 1#32 else 0#32)
    (BitVec.allOnes 64 - (BitVec.allOnes 64 - n + 1#64) % n)
    ((n <<< (63#32 - fd_ulong_find_msb.spec n).toNat) - 1#64)

/-- The `for( int i=0; 1; i++ )` loop of `fd_chacha_rng_ulong_roll`
(`ballet/chacha/fd_chacha_rng.h:263`) with `fuel` iterations left. -/
def fd_chacha_rng_ulong_roll.loop (n zone : BitVec 64) :
    Nat → fd_chacha_rng_t → Fueled (BitVec 64 × fd_chacha_rng_t)
  | 0, _ => .outOfFuel
  | fuel + 1, rng =>
    let (v, rng) := fd_chacha_rng_ulong.spec rng
    let (hi, lo) := fd_uwide_mul.spec v n
    if lo ≤ zone then .done (hi, rng) else fd_chacha_rng_ulong_roll.loop n zone fuel rng

/-- `fd_chacha_rng_ulong_roll` (`ballet/chacha/fd_chacha_rng.h:219`): the value and the RNG
after, given `fuel` loop iterations. -/
def fd_chacha_rng_ulong_roll.spec (fuel : Nat) (rng : fd_chacha_rng_t) (n : BitVec 64) :
    Fueled (BitVec 64 × fd_chacha_rng_t) :=
  let zone := fd_chacha_rng_ulong_roll.zone rng n
  fd_chacha_rng_ulong_roll.loop n zone fuel rng

end

end Firedancer.Leaders
