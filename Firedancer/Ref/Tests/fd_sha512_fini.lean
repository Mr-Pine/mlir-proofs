module

public import Firedancer.Ref.fd_sha512_fini
public import Firedancer.Ref.fd_sha512_init

meta import Firedancer.Ref.fd_sha512_fini
meta import Firedancer.Ref.fd_sha512_init

namespace MLIR.Firedancer.Ref

/-- Bytes, byte `k` at bits `8 * k`. -/
private def bytes (l : List UInt8) : BitVec (8 * l.length) :=
  BitVec.ofNat _ (l.foldr (fun b acc => b.toNat + 256 * acc) 0)

/-- Bytes from hex digits. -/
private def hex (s : String) : List UInt8 :=
  let d (c : Char) : Nat := if c.isDigit then c.toNat - '0'.toNat else c.toNat - 'a'.toNat + 10
  let rec go : List Char → List UInt8
    | a :: b :: cs => (16 * d a + d b).toUInt8 :: go cs
    | _ => []
  go s.toList

private def sha : Pointer :=
  ⟨⟨0⟩, 0⟩

private def msg : Pointer :=
  ⟨⟨1⟩, 0⟩

private def hash : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- The struct's block, the message's block holding `m`, the hash's block; all else zero. -/
private def state (m : List UInt8) : GlobalState :=
  GlobalState.withGlobals fd_sha512_fini.globals
    ⟨⟨3⟩,
      ⟨Std.ExtHashMap.ofList
          [(⟨0⟩, .ofBytes 256 0), (⟨1⟩, .ofBytes m.length (bytes m)), (⟨2⟩, .ofBytes 64 0)]⟩⟩

/-- `init`, an `append` per `(offset, size)` piece of `m`, then `fini`, run through the lifts: the
64 bytes at `hash`, or `none` for UB / out of fuel. -/
private def digest (m : List UInt8) (pieces : List (Nat × Nat)) : Option Nat := do
  let .value (some _, s) := fd_sha512_init.eval 1000 (fd_sha512_init.args (.value sha)) (state m)
    | none
  let s ←
    pieces.foldlM (init := s) fun s (off, sz) =>
        match
          fd_sha512_append.eval 1000
            (fd_sha512_append.args (.value sha) (.value (msg.add (BitVec.ofNat 64 off)))
              (.value (BitVec.ofNat 64 sz)))
            s with
        | .value (some _, s) => some s
        | _ => none
  let .value (some _, s) :=
    fd_sha512_fini.eval 1000 (fd_sha512_fini.args (.value sha) (.value hash)) s
    | none
  some (s.mem.readAt hash 512).toNat

/-- The digest by the specs, from the struct `init` leaves. -/
private def specDigest (m : List UInt8) (pieces : List (Nat × Nat)) : Nat :=
  let sha : ShaState := ⟨0, sha512IV, 0, 0, 0⟩
  let sha :=
    pieces.foldl (init := sha) fun sha (off, sz) =>
      fd_sha512_append.spec sha (BitVec.ofNat 64 sz) ((bytes m).extractLsb' (8 * off) _)
  -- `hash`'s bytes: each word little-endian
  (bytes
      ((fd_sha512_fini.spec sha).2.toList.flatMap fun w =>
        (List.range 8).map fun k => (w.toNat / 256 ^ k).toUInt8)).toNat

private def abc : List UInt8 :=
  "abc".toUTF8.toList

private def abcDigest : Nat :=
  (bytes
      (hex
        ("ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a" ++
          "2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f"))).toNat

-- "abc", in one append and in three (one empty)
#guard digest abc [(0, 3)] == some abcDigest

#guard digest abc [(0, 1), (1, 0), (1, 2)] == some abcDigest

#guard specDigest abc [(0, 1), (1, 0), (1, 2)] == abcDigest

-- the empty string
#guard
  digest [] [] ==
    some
      (bytes
          (hex
            ("cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921" ++
              "d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e"))).toNat

/-- 112 bytes (FIPS 180-2, C.2): `buf_used = 112` at `fini`, so the padding takes a second block. -/
private def fips : List UInt8 :=
  ("abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmno" ++
      "ijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu").toUTF8.toList

private def fipsDigest : Nat :=
  (bytes
      (hex
        ("8e959b75dae313da8cf4f72814fc143f8f7779c6eb9f7fa17299aeadb6889018" ++
          "501d289e4900f7e4331b99dec4b5433ac7d329eeb6dd26545e96e55b874be909"))).toNat

#guard digest fips [(0, 112)] == some fipsDigest

#guard specDigest fips [(0, 112)] == fipsDigest

/-- Bytes `0, 1, …, 199`: over a block, across two appends (the second fills the buffer, compresses
it and a whole block, and buffers the rest). -/
private def long : List UInt8 :=
  (List.range 200).map Nat.toUInt8

private def longDigest : Nat :=
  (bytes
      (hex
        ("986058e9895e2c2ab8f9e8cbdf801db12a44842a56a91d5a4e87b1fc98b29372" ++
          "2c4664142e42c3c551ff898646268cd92b84ed230b8c94bed7798d4f27cd7465"))).toNat

#guard digest long [(0, 50), (50, 150)] == some longDigest

#guard digest long [(0, 32), (32, 32), (64, 136)] == some longDigest

#guard specDigest long [(0, 50), (50, 150)] == longDigest

end MLIR.Firedancer.Ref
