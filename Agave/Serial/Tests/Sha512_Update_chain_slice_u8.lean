module

public import Agave.Serial.Sha512_Update_chain_slice_u8

meta import Agave.Serial.Sha512_Update_chain_slice_u8

/-! The lift is `noncomputable` (through `compress512`'s table): `updateMem`, the memory its
`call_eq` gives, is tested on sha2's `Sha512` from `new()`, against FIPS 180-4's compression. -/

namespace MLIR.Agave.Serial.Sha512_Update_chain_slice_u8

open _root_.Ed25519

private def self : Pointer :=
  ⟨⟨1⟩, 0⟩

private def data : Pointer :=
  ⟨⟨2⟩, 0⟩

private def out : Pointer :=
  ⟨⟨3⟩, 0⟩

/-- `n` input bytes `0, 1, 2, …`. -/
private def input (n : Nat) : List (BitVec 8) :=
  (List.range n).map (BitVec.ofNat 8)

/-- The bytes `l` as one bit vector, the first lowest. -/
private def bits (l : List (BitVec 8)) : BitVec (8 * l.length) :=
  (BitVec.ofNat (8 * l.length) (l.foldr (fun b acc => b.toNat + 256 * acc) 0))

/-- sha2's `Sha512::new()` at `self`, the `n` input bytes at `data`, room at `out`. -/
private def mem (n : Nat) : MemoryState :=
  let m : MemoryState :=
    ⟨Std.ExtHashMap.ofList
        [(⟨1⟩, .ofBytes 208 0), (⟨2⟩, .ofBytes n ((bits (input n)).cast (by simp [input]))),
          (⟨3⟩, .ofBytes 208 0)]⟩
  m.storeSha512 (self.add 128#64) Sha512.IV

/-- The object at `out` after `update` on `n` bytes: state words, buffered bytes, their count,
blocks counted. -/
private def after (n : Nat) : Vector (BitVec 64) 8 × List (BitVec 8) × Nat × Nat :=
  let m := copyObj (updateMem (mem n) self data (BitVec.ofNat 64 n)) out self
  let p := (m.readAt (out.add 127#64) 8).toNat
  (m.readSha512 (out.add 128#64), bytesLE (m.readAt out (8 * p)), p,
    (m.readAt (out.add 192#64) 128).toNat)

/-- What the object should have absorbed from `new()` after `n` bytes. -/
private def expected (n : Nat) : Vector (BitVec 64) 8 × List (BitVec 8) × Nat × Nat :=
  (Sha512.compressBlocks Sha512.IV (input n), (input n).drop (n / 128 * 128), n % 128, n / 128)

/-- Two `update`s of `a` then `b` bytes, the input's first ones each time, read at `self`. -/
private def after2 (a b : Nat) : Vector (BitVec 64) 8 × List (BitVec 8) × Nat × Nat :=
  let m :=
    updateMem (updateMem (mem (max a b)) self data (BitVec.ofNat 64 a)) self data
      (BitVec.ofNat 64 b)
  let p := (m.readAt (self.add 127#64) 8).toNat
  (m.readSha512 (self.add 128#64), bytesLE (m.readAt self (8 * p)), p,
    (m.readAt (self.add 192#64) 128).toNat)

/-- What the object should have absorbed after `a` then `b` input bytes. -/
private def expected2 (a b : Nat) : Vector (BitVec 64) 8 × List (BitVec 8) × Nat × Nat :=
  let M := input a ++ input b
  (Sha512.compressBlocks Sha512.IV M, M.drop (M.length / 128 * 128), M.length % 128, M.length / 128)

#guard after 3 == expected 3

#guard after 128 == expected 128

#guard after 200 == expected 200

#guard after 300 == expected 300

#guard after2 3 100 == expected2 3 100

#guard after2 3 200 == expected2 3 200

#guard after2 100 300 == expected2 100 300

end MLIR.Agave.Serial.Sha512_Update_chain_slice_u8
