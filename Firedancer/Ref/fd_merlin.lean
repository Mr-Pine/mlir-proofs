module

public import Ed25519.Sha512
public import Firedancer.Ref.fd_keccak256_core

namespace MLIR.Firedancer.Ref

open _root_.Ed25519 (bytesLE)

/-! ## Specification

`ballet/merlin/fd_merlin.c` (STROBE-128 and Merlin). Byte buffers are lists, `buf[k]` at index
`k`; a `(ptr, len)` argument is the list of the `len` bytes at `ptr`. Multi-byte integers are
stored little-endian (x86-64, aarch64). `fd_keccak256_core` is the `FD_HAS_S2NBIGNUM` build's,
`fd_keccak256_core.s2n`. -/

@[expose] public section

/-- The bytes `b` as a little-endian `w`-bit value: `b[k]` at bits `8k … 8k+7`. -/
def ofBytesLE (w : Nat) (b : List (BitVec 8)) : BitVec w :=
  b.foldr (fun byte acc => (acc <<< 8) ||| byte.setWidth w) 0#w

/-- `FD_MERLIN_LITERAL(STR)` (`fd_merlin.h:6`): the bytes of the literal, `sizeof(STR)-1` of them
(every literal here is ASCII without a NUL). -/
def FD_MERLIN_LITERAL (s : String) : List (BitVec 8) :=
  s.toList.map fun c => BitVec.ofNat 8 c.toNat

/-- `fd_merlin_strobe128_t` (`fd_merlin.h:8`): the 200 bytes `state_bytes` of the
`state`/`state_bytes` union, then `pos`, `pos_begin`, `cur_flags`. -/
structure fd_merlin_strobe128_t where
  state_bytes : List (BitVec 8)
  pos : BitVec 8
  pos_begin : BitVec 8
  cur_flags : BitVec 8

/-- `fd_merlin_transcript_t` (`fd_merlin.h:19`). -/
structure fd_merlin_transcript_t where
  sctx : fd_merlin_strobe128_t

namespace fd_merlin_strobe128_t

/-- The union's `ulong state[25]` view of `state_bytes`. -/
def state (state_bytes : List (BitVec 8)) : List (BitVec 64) :=
  (List.range 25).map fun i => ofBytesLE 64 ((state_bytes.drop (8 * i)).take 8)

/-- The union's `state_bytes` view of `ulong state[25]`. -/
def ofState (state : List (BitVec 64)) : List (BitVec 8) :=
  state.flatMap bytesLE

/-- `state_bytes[i] ^= v`. -/
def xorAt (state_bytes : List (BitVec 8)) (i : Nat) (v : BitVec 8) : List (BitVec 8) :=
  state_bytes.set i (state_bytes.getD i 0 ^^^ v)

end fd_merlin_strobe128_t

open fd_merlin_strobe128_t

namespace fd_merlin

/-- `STROBE_R` (`fd_merlin.c:8`). -/
def STROBE_R : Nat := 166

/-- `FLAG_I` (`fd_merlin.c:9`). -/
def FLAG_I : BitVec 8 := 1
/-- `FLAG_A` (`fd_merlin.c:10`). -/
def FLAG_A : BitVec 8 := 1 <<< 1
/-- `FLAG_C` (`fd_merlin.c:11`). -/
def FLAG_C : BitVec 8 := 1 <<< 2
/-- `FLAG_T` (`fd_merlin.c:12`). -/
def FLAG_T : BitVec 8 := 1 <<< 3
/-- `FLAG_M` (`fd_merlin.c:13`). -/
def FLAG_M : BitVec 8 := 1 <<< 4
/-- `FLAG_K` (`fd_merlin.c:14`). -/
def FLAG_K : BitVec 8 := 1 <<< 5

end fd_merlin

open fd_merlin

/-- `strobe128_run_f` (`ballet/merlin/fd_merlin.c:17`); `ctx->pos + 1` is an `int` index. -/
def strobe128_run_f (ctx : fd_merlin_strobe128_t) : fd_merlin_strobe128_t :=
  let state_bytes := xorAt ctx.state_bytes ctx.pos.toNat ctx.pos_begin
  let state_bytes := xorAt state_bytes (ctx.pos.toNat + 1) 0x04#8
  let state_bytes := xorAt state_bytes (STROBE_R + 1) 0x80#8
  let state_bytes := ofState (fd_keccak256_core.s2n (state state_bytes))
  { ctx with state_bytes, pos := 0#8, pos_begin := 0#8 }

/-- `strobe128_absorb` (`ballet/merlin/fd_merlin.c:27`): `data` the `data_len` bytes. -/
def strobe128_absorb (ctx : fd_merlin_strobe128_t) (data : List (BitVec 8)) :
    fd_merlin_strobe128_t :=
  data.foldl
    (fun ctx d =>
      let ctx := { ctx with state_bytes := xorAt ctx.state_bytes ctx.pos.toNat d }
      let ctx := { ctx with pos := ctx.pos + 1#8 }
      if ctx.pos.toNat = STROBE_R then strobe128_run_f ctx else ctx)
    ctx

/-- `strobe128_squeeze` (`ballet/merlin/fd_merlin.c:40`): the state and the `data_len` bytes written
to `data`. -/
def strobe128_squeeze (ctx : fd_merlin_strobe128_t) (data_len : Nat) :
    fd_merlin_strobe128_t × List (BitVec 8) :=
  (List.range data_len).foldl
    (fun (acc : fd_merlin_strobe128_t × List (BitVec 8)) _ =>
      let (ctx, data) := acc
      let data := data ++ [ctx.state_bytes.getD ctx.pos.toNat 0]
      let ctx := { ctx with state_bytes := ctx.state_bytes.set ctx.pos.toNat 0#8 }
      let ctx := { ctx with pos := ctx.pos + 1#8 }
      let ctx := if ctx.pos.toNat = STROBE_R then strobe128_run_f ctx else ctx
      (ctx, data))
    (ctx, [])

/-- `strobe128_begin_op` (`ballet/merlin/fd_merlin.c:54`); the commented-out `more`/`FLAG_T` checks
are not code. -/
def strobe128_begin_op (ctx : fd_merlin_strobe128_t) (flags : BitVec 8) : fd_merlin_strobe128_t :=
  let old_begin := ctx.pos_begin
  let ctx := { ctx with pos_begin := ctx.pos + 1#8 }
  let ctx := { ctx with cur_flags := flags }
  let data := [old_begin, flags]
  let ctx := strobe128_absorb ctx data
  let force_f : BitVec 8 := if (flags &&& (FLAG_C ||| FLAG_K)) ≠ 0#8 then 1#8 else 0#8
  if force_f ≠ 0#8 ∧ ctx.pos ≠ 0#8 then strobe128_run_f ctx else ctx

/-- `strobe128_meta_ad` (`ballet/merlin/fd_merlin.c:88`). -/
def strobe128_meta_ad (ctx : fd_merlin_strobe128_t) (data : List (BitVec 8)) (more : BitVec 8) :
    fd_merlin_strobe128_t :=
  let ctx := if more = 0#8 then strobe128_begin_op ctx (FLAG_M ||| FLAG_A) else ctx
  strobe128_absorb ctx data

/-- `strobe128_ad` (`ballet/merlin/fd_merlin.c:99`). -/
def strobe128_ad (ctx : fd_merlin_strobe128_t) (data : List (BitVec 8)) (more : BitVec 8) :
    fd_merlin_strobe128_t :=
  let ctx := if more = 0#8 then strobe128_begin_op ctx FLAG_A else ctx
  strobe128_absorb ctx data

/-- `strobe128_prf` (`ballet/merlin/fd_merlin.c:110`): the state and the `data_len` bytes. -/
def strobe128_prf (ctx : fd_merlin_strobe128_t) (data_len : Nat) (more : BitVec 8) :
    fd_merlin_strobe128_t × List (BitVec 8) :=
  let ctx := if more = 0#8 then strobe128_begin_op ctx (FLAG_I ||| FLAG_A ||| FLAG_C) else ctx
  strobe128_squeeze ctx data_len

/-- `strobe128_init` (`ballet/merlin/fd_merlin.c:121`): every field is set before it is read, so
the result does not depend on `*ctx`. -/
def strobe128_init (label : List (BitVec 8)) : fd_merlin_strobe128_t :=
  let init : List (BitVec 8) :=
    [1, 168, 1, 0, 1, 96, 83, 84, 82, 79, 66, 69, 118, 49, 46, 48, 46, 50]
  let state_bytes := List.replicate 200 0#8
  let state_bytes := init ++ state_bytes.drop 18
  let state_bytes := ofState (fd_keccak256_core.s2n (state state_bytes))
  let ctx : fd_merlin_strobe128_t :=
    { state_bytes, pos := 0#8, pos_begin := 0#8, cur_flags := 0#8 }
  strobe128_meta_ad ctx label 0#8

/-- `fd_merlin_transcript_append_message` (`ballet/merlin/fd_merlin.c:149`): `message` holds at
least `message_len` bytes, the first `message_len` absorbed. -/
def fd_merlin_transcript_append_message (mctx : fd_merlin_transcript_t) (label : List (BitVec 8))
    (message : List (BitVec 8)) (message_len : BitVec 32) : fd_merlin_transcript_t :=
  let sctx := strobe128_meta_ad mctx.sctx label 0#8
  let sctx := strobe128_meta_ad sctx (bytesLE message_len) 1#8
  let sctx := strobe128_ad sctx (message.take message_len.toNat) 0#8
  ⟨sctx⟩

/-- `fd_merlin_transcript_init` (`ballet/merlin/fd_merlin.c:141`); the result does not depend on
`*mctx`. -/
def fd_merlin_transcript_init (label : List (BitVec 8)) (label_len : BitVec 32) :
    fd_merlin_transcript_t :=
  let sctx := strobe128_init (FD_MERLIN_LITERAL "Merlin v1.0")
  fd_merlin_transcript_append_message ⟨sctx⟩ (FD_MERLIN_LITERAL "dom-sep") label label_len

/-- `fd_merlin_transcript_append_u64` (`ballet/merlin/fd_merlin.c:160`). -/
def fd_merlin_transcript_append_u64 (mctx : fd_merlin_transcript_t) (label : List (BitVec 8))
    (message_u64 : BitVec 64) : fd_merlin_transcript_t :=
  fd_merlin_transcript_append_message mctx label (bytesLE message_u64) 8#32

/-- `fd_merlin_transcript_challenge_bytes` (`ballet/merlin/fd_merlin.c:168`): the transcript and
the `buffer_len` bytes written to `buffer`. -/
def fd_merlin_transcript_challenge_bytes (mctx : fd_merlin_transcript_t)
    (label : List (BitVec 8)) (buffer_len : BitVec 32) :
    fd_merlin_transcript_t × List (BitVec 8) :=
  let sctx := strobe128_meta_ad mctx.sctx label 0#8
  let sctx := strobe128_meta_ad sctx (bytesLE buffer_len) 1#8
  let (sctx, buffer) := strobe128_prf sctx buffer_len.toNat 0#8
  (⟨sctx⟩, buffer)

end

end MLIR.Firedancer.Ref
