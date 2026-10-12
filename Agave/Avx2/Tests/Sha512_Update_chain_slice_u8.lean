module

public import Agave.Avx2.Sha512_Update_chain_slice_u8

meta import Agave.Avx2.Sha512_Update_chain_slice_u8

/-! The lift on sha2's `Sha512` from `new()`, against the memory its `call_eq` gives and FIPS
180-4's compression. -/

namespace MLIR.Agave.Avx2.Sha512_Update_chain_slice_u8

open _root_.Ed25519
open
  Serial.BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0 (updateMem
  updateCalls)
open Serial.Sha512_Update_chain_slice_u8 (copyObj)

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
private def state (n : Nat) : GlobalState :=
  let m : MemoryState :=
    ⟨Std.ExtHashMap.ofList
        [(⟨1⟩, .ofBytes 208 0), (⟨2⟩, .ofBytes n ((bits (input n)).cast (by simp [input]))),
          (⟨3⟩, .ofBytes 208 0)]⟩
  ⟨⟨4⟩, m.storeSha512 (self.add 128#64) Sha512.IV⟩

/-- The object at `out`: state words, buffered bytes, their count, blocks counted. -/
private def obj (m : MemoryState) : Vector (BitVec 64) 8 × List (BitVec 8) × Nat × Nat :=
  let p := (m.readAt (out.add 127#64) 8).toNat
  (m.readSha512 (out.add 128#64), bytesLE (m.readAt out (8 * p)), p,
    (m.readAt (out.add 192#64) 128).toNat)

/-- The lift's `chain` of `n` bytes agrees with `call_eq`'s memory and frames, and with what the
object should have absorbed from `new()`. -/
private def agrees (n : Nat) : Bool :=
  let s := state n
  let len := BitVec.ofNat 64 n
  match
    Sha512_Update_chain_slice_u8.eval 10
      (args (.value out) (.value self) (.value data) (.value len)) s with
  | .value (some .nil, s') =>
    obj s'.mem == obj (copyObj (updateMem s.mem self data len) out self) &&
      obj s'.mem ==
        (Sha512.compressBlocks Sha512.IV (input n), (input n).drop (n / 128 * 128), n % 128,
          n / 128) &&
      s'.alloc.nextFreeBlock == s.alloc.nextFreeBlock + 4 * updateCalls s.mem self len
  | _ => false

#guard [3, 128, 200, 300].all agrees

end MLIR.Agave.Avx2.Sha512_Update_chain_slice_u8
