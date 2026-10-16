module

public import Firedancer.Leaders.Bits

/-! `ballet/chacha/fd_chacha.c`: the ChaCha block function (portable file; `fd_chacha_sse.c`
replaces it on `FD_HAS_SSE` builds, see `TRANSLATION.md`). -/

namespace Firedancer.Leaders

@[expose] public section

/-- `FD_CHACHA_BLOCK_SZ` (`ballet/chacha/fd_chacha.h:8`). -/
def FD_CHACHA_BLOCK_SZ : BitVec 64 := 64#64

/-- `FD_CHACHA_KEY_SZ` (`ballet/chacha/fd_chacha.h:12`). -/
def FD_CHACHA_KEY_SZ : Nat := 32

/-- `fd_chacha_quarter_round` (`ballet/chacha/fd_chacha.c:9`): `(*a, *b, *c, *d)` after the
call. -/
def fd_chacha_quarter_round.spec (a b c d : BitVec 32) :
    BitVec 32 × BitVec 32 × BitVec 32 × BitVec 32 :=
  let a := a + b; let d := d ^^^ a; let d := fd_uint_rotate_left.spec d 16#32
  let c := c + d; let b := b ^^^ c; let b := fd_uint_rotate_left.spec b 12#32
  let a := a + b; let d := d ^^^ a; let d := fd_uint_rotate_left.spec d 8#32
  let c := c + d; let b := b ^^^ c; let b := fd_uint_rotate_left.spec b 7#32
  (a, b, c, d)

/-- `block` after `fd_chacha_quarter_round( &block[ia], &block[ib], &block[ic], &block[id] )`
(the four indices are distinct at every call). -/
def fd_chacha_quarter_round.at (block : Vector (BitVec 32) 16) (ia ib ic id : Fin 16) :
    Vector (BitVec 32) 16 :=
  let (a, b, c, d) := fd_chacha_quarter_round.spec block[ia] block[ib] block[ic] block[id]
  ((block.set ia a).set ib b |>.set ic c).set id d

/-- One iteration of the round loop of `fd_chacha_block` (`fd_chacha.c:59-68`): a column round
and a diagonal round. -/
def fd_chacha_block.double_round (block : Vector (BitVec 32) 16) : Vector (BitVec 32) 16 :=
  let block := fd_chacha_quarter_round.at block 0 4  8 12
  let block := fd_chacha_quarter_round.at block 1 5  9 13
  let block := fd_chacha_quarter_round.at block 2 6 10 14
  let block := fd_chacha_quarter_round.at block 3 7 11 15
  let block := fd_chacha_quarter_round.at block 0 5 10 15
  let block := fd_chacha_quarter_round.at block 1 6 11 12
  let block := fd_chacha_quarter_round.at block 2 7  8 13
  let block := fd_chacha_quarter_round.at block 3 4  9 14
  block

/-- `for( ulong i=0UL; i<rnd2_cnt; i++ )` of `fd_chacha_block` (`fd_chacha.c:59`), with
`rem = rnd2_cnt - i`. -/
def fd_chacha_block.loop : Nat → Vector (BitVec 32) 16 → Vector (BitVec 32) 16
  | 0, block => block
  | rem + 1, block => fd_chacha_block.loop rem (fd_chacha_block.double_round block)

/-- `fd_chacha_block` (`ballet/chacha/fd_chacha.c:20`): the 64 bytes written at `block`, from
the key bytes and the `uint idx_nonce[4]`. -/
def fd_chacha_block.spec (key : Vector (BitVec 8) 32) (idx_nonce : Vector (BitVec 32) 4)
    (rnd2_cnt : BitVec 64) : Vector (BitVec 8) 64 :=
  let k : Vector (BitVec 32) 8 := uintsOfBytes (k := 8) key
  let block : Vector (BitVec 32) 16 :=
    #v[0x61707865#32, 0x3320646e#32, 0x79622d32#32, 0x6b206574#32,
       k[0], k[1], k[2], k[3], k[4], k[5], k[6], k[7],
       idx_nonce[0], idx_nonce[1], idx_nonce[2], idx_nonce[3]]
  let block_pre := block
  let block := fd_chacha_block.loop rnd2_cnt.toNat block
  let block := Vector.ofFn fun i => block[i] + block_pre[i]
  bytesOfUints (k := 16) block

/-- `fd_chacha8_block` (`ballet/chacha/fd_chacha.c:79`): `rnd2_cnt = 4`. -/
def fd_chacha8_block.spec (key : Vector (BitVec 8) 32) (idx_nonce : Vector (BitVec 32) 4) :
    Vector (BitVec 8) 64 :=
  fd_chacha_block.spec key idx_nonce 4#64

/-- `fd_chacha20_block` (`ballet/chacha/fd_chacha.c:86`): `rnd2_cnt = 10`. -/
def fd_chacha20_block.spec (key : Vector (BitVec 8) 32) (idx_nonce : Vector (BitVec 32) 4) :
    Vector (BitVec 8) 64 :=
  fd_chacha_block.spec key idx_nonce 10#64

end

end Firedancer.Leaders
