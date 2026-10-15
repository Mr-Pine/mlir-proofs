module

public import Firedancer.Lane.Common.Decode
public import Firedancer.Lane.Mlir.fd_f25519_rng_unsafe
public import MLIR.Run.Tactic

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Specification -/

@[expose] public section

namespace fd_f25519_rng_unsafe

/-- `fd_ulong_hash( x )`. -/
def hash (x : BitVec 64) : BitVec 64 :=
  let x := x >>> 33 ^^^ x
  let x := x * 0xff51afd7ed558ccd#64
  let x := x >>> 33 ^^^ x
  let x := x * 0xc4ceb9fe1a85ec53#64
  x >>> 33 ^^^ x

/-- `buf[j] = fd_rng_uchar( rng )`: the hash of `seq ^ idx++`, truncated. -/
def byte (seq idx : BitVec 64) (j : Nat) : BitVec 8 :=
  (hash (idx + BitVec.ofNat 64 j ^^^ seq)).setWidth 8

/-- `fd_ulong_load_8_fast( buf + 8 k )`: bytes `8 k … 8 k + 7`, little endian. -/
def word (seq idx : BitVec 64) (k : Nat) : BitVec 64 :=
  byte seq idx (8 * k + 7) ++ byte seq idx (8 * k + 6) ++ byte seq idx (8 * k + 5) ++
    byte seq idx (8 * k + 4) ++ byte seq idx (8 * k + 3) ++ byte seq idx (8 * k + 2) ++
    byte seq idx (8 * k + 1) ++ byte seq idx (8 * k)

/-- `fd_f25519_frombytes` of the `32` bytes drawn from `seq` and `idx`. -/
def spec (seq idx : BitVec 64) : Wwl :=
  fd_r43x6_unpack.spec
    #v[word seq idx 0, word seq idx 1, word seq idx 2, word seq idx 3 &&& 0x7fffffffffffffff#64]

end fd_f25519_rng_unsafe

end

/-! ## Proof -/

section Proof

/-- The all-ones mask of the low words. -/
private theorem and_ones (x : BitVec 64) : x &&& 18446744073709551615#64 = x :=
  BitVec.and_allOnes

/-- `fd_f25519_rng_unsafe` draws `32` bytes from the rng at `rng` (`seq` at byte `0`, `idx` at
byte `8`), stores `idx + 32` and `spec seq idx` at `r`, and returns `r`. -/
public theorem _root_.Firedancer.Lane.Mlir.fd_f25519_rng_unsafe.call_eq (r rng : Pointer)
    (s : GlobalState) (hwf : s.WF) (hr : Room s.mem r 512) (hrng0 : Fits s.mem rng 64)
    (hrng8 : Fits s.mem (rng.add 8#64) 64) (hrng8r : Room s.mem (rng.add 8#64) 64)
    (hoff : ¬rng.offset.uaddOverflow 8#64) :
    Firedancer.Lane.Mlir.fd_f25519_rng_unsafe.call
        (Firedancer.Lane.Mlir.fd_f25519_rng_unsafe.args (.value r) (.value rng)) s =
      .value
        (.cons (.value r) .nil,
          { s with
            mem :=
              (s.mem.storeAt (rng.add 8#64) (s.mem.readAt (rng.add 8#64) 64 + 32#64)).storeVec r
                (fd_f25519_rng_unsafe.spec (s.mem.readAt rng 64)
                  (s.mem.readAt (rng.add 8#64) 64)) }) := by
  func_init
  block_init
  -- the constants, `&rng->idx`
  iterate 14 step_pure
  -- `buf[j] = fd_rng_uchar( rng )` for the 32 `j`, as one vector of hashes; `rng->idx += 32`
  step_load with idx
  iterate 3 step_pure
  step_load with seq
  iterate 13 step_pure
  step_store
  -- `fd_f25519_frombytes( r, buf )`: the words, the top bit cleared, unpacked
  step_pure with bytes
  step_pure with u
  step_pattern using runBodyFrom_unpackRun with y
  step_store
  finish_block
  have e :
      u =
        #v[fd_f25519_rng_unsafe.word seq idx 0, fd_f25519_rng_unsafe.word seq idx 1,
          fd_f25519_rng_unsafe.word seq idx 2,
          fd_f25519_rng_unsafe.word seq idx 3 &&& 0x7fffffffffffffff#64] := by
    rw [hu, hbytes]
    ext i hi : 1
    obtain _ | _ | _ | _ | i := i
    all_goals
      first
      | omega
      | simp [fd_f25519_rng_unsafe.word, fd_f25519_rng_unsafe.byte, fd_f25519_rng_unsafe.hash,
          BitVec.setWidth_xor, and_ones]
  rw [hS, hy, e]
  rfl

end Proof

end MLIR.Firedancer.Lane
