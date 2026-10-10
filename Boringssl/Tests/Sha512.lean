module

public import Boringssl.Math.Sha512

meta import Boringssl.Math.Sha512

/-! `update`'s and `final`'s lifts call the assembly cores and cannot be evaluated; these test their
specs: after `init`, updates with pieces and `final`, the digest is SHA-512 of the pieces' bytes. -/

namespace MLIR.Boringssl

open _root_.Ed25519

/-- The bytes `l`, the first least significant. -/
private def bitsOf (l : List (BitVec 8)) : BitVec (8 * l.length) :=
  BitVec.ofNat _ (l.foldr (fun b acc => b.toNat + 256 * acc) 0)

/-- `l` as an update's length and data. -/
private def piece (l : List (BitVec 8)) : (len : BitVec 64) × BitVec (8 * len.toNat) :=
  ⟨BitVec.ofNat 64 l.length, (bitsOf l).setWidth _⟩

/-- A struct of leftovers: what `init` overwrites, and a `p` it keeps. -/
private def junk : Sha512Ctx :=
  ⟨#v[1, 2, 3, 4, 5, 6, 7, 8], 77#16, 48#16, 9#32, 10#64, BitVec.allOnes 1024, 0#1024⟩

/-- The digest the specs compute for `pieces` of the given lengths, `i`-th byte `i % 251`. -/
private def digest (lens : List Nat) : List (BitVec 8) :=
  let ps :=
    (lens.foldl
        (fun (acc : List (List (BitVec 8)) × Nat) n =>
          (acc.1 ++ [(List.range n).map fun i => BitVec.ofNat 8 ((acc.2 + i) % 251)], acc.2 + n))
        ([], 0)).1
  bytesLE
    (Firedancer.Words8.bits
      ((sha512_final_impl.spec
            (BCM_sha512_update.specs (BCM_sha512_init.spec junk) (ps.map piece))).h.map
        Firedancer.Ref.fd_ulong_bswap.spec))

/-- SHA-512 of the same bytes, by the specification. -/
private def expected (lens : List Nat) : List (BitVec 8) :=
  Sha512.digest ((List.range (lens.foldl (· + ·) 0)).map fun i => BitVec.ofNat 8 (i % 251))

/-- Hex digits as bytes. -/
private def hex : List Char → List (BitVec 8)
  | a :: b :: t =>
    let d (c : Char) := if c.isDigit then c.toNat - 48 else c.toNat - 87
    BitVec.ofNat 8 (16 * d a + d b) :: hex t
  | _ => []

-- SHA-512 of "" and of "abc" (FIPS 180-4 examples)
#guard
  digest [] ==
    hex
      ("cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce" ++
          "47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e").toList

#guard
  bytesLE
      (Firedancer.Words8.bits
        ((sha512_final_impl.spec
              (BCM_sha512_update.specs (BCM_sha512_init.spec junk)
                [piece [0x61, 0x62, 0x63]])).h.map
          Firedancer.Ref.fd_ulong_bswap.spec)) ==
    hex
      ("ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a" ++
          "2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f").toList

-- `ED25519_verify`'s pieces: 32, 32, then a message
#guard [0, 1, 63, 64, 100, 128, 200].all fun n => digest [32, 32, n] == expected [32, 32, n]

-- a buffer filled exactly, padding into a second block, whole blocks with and without a tail
#guard
  [[128], [111], [112], [127], [64, 64], [100, 200, 300], [1, 127, 128, 129], [256, 0, 5]].all
    fun lens => digest lens == expected lens

end MLIR.Boringssl
