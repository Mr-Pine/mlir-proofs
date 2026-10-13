module

public import Firedancer.Ref.fd_sha512_append

meta import Firedancer.Ref.fd_sha512_append

namespace MLIR.Firedancer.Ref

private def sha : Pointer :=
  ⟨⟨0⟩, 0⟩

private def data : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- Bytes `0, 1, …, n - 1` (mod 256), byte `k` at bits `8 * k`. -/
private def ramp (n : Nat) : BitVec (8 * n) :=
  BitVec.ofNat _ ((List.range n).foldr (fun k acc => k % 256 + 256 * acc) 0)

/-- The struct's block holding `v`, the data block holding `ramp n`. -/
private def state (v : ShaState) (n : Nat) : GlobalState :=
  let s : GlobalState :=
    ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, .ofBytes 256 0), (⟨1⟩, .ofBytes n (ramp n))]⟩⟩
  GlobalState.withGlobals fd_sha512_append.globals { s with mem := s.mem.storeSha sha v }

/-- Whether the lift, appending the `n` bytes, leaves the struct the spec gives. -/
private def agrees (v : ShaState) (n : Nat) : Bool :=
  match
    fd_sha512_append.eval 1000
      (fd_sha512_append.args (.value sha) (.value data) (.value (BitVec.ofNat 64 n)))
      (state v n) with
  | .value (some _, s) =>
    let w := s.mem.readSha sha
    let w' := fd_sha512_append.spec v (BitVec.ofNat 64 n) ((ramp n).setWidth _)
    w.buf == w'.buf && w.state == w'.state && w.bufUsed == w'.bufUsed &&
      w.bitCntLo == w'.bitCntLo &&
      w.bitCntHi == w'.bitCntHi
  | _ => false

/-- A struct with `u` bytes buffered; the bit count's low word about to carry. -/
private def mid (u : BitVec 64) : ShaState :=
  ⟨0x0123456789abcdef#1024 <<< 100 ||| 0xfedcba#1024,
    #v[1#64, 2#64, 3#64, 4#64, 5#64, 6#64, 7#64, 0x8000000000000001#64], u, -8#64, 7#64⟩

-- sz = 0
#guard agrees (mid 5#64) 0

-- buffered, and the bytes fit the buffer
#guard agrees (mid 5#64) 10

-- buffered, then: the buffer filled and compressed, two whole blocks, 16 bytes buffered
#guard agrees (mid 100#64) 300

-- nothing buffered: two whole blocks, nothing left
#guard agrees (mid 0#64) 256

-- nothing buffered: one block, 72 bytes left
#guard agrees (mid 0#64) 200

end MLIR.Firedancer.Ref
