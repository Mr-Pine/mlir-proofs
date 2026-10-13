module

public import Agave.Avx2.BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0

meta import Agave.Avx2.BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0

/-! The lift on sha2's `Sha512` from `new()`, against `updateMem` (the memory its `call_eq` gives),
FIPS 180-4's compression and the frame count. -/

namespace
  MLIR.Agave.Avx2.BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0

open _root_.Ed25519
open
  Serial.BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0 (updateMem
  updateCalls)

private def self : Pointer :=
  ⟨⟨1⟩, 0⟩

private def data : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- `n` input bytes `0, 1, 2, …`. -/
private def input (n : Nat) : List (BitVec 8) :=
  (List.range n).map (BitVec.ofNat 8)

/-- The bytes `l` as one bit vector, the first lowest. -/
private def bits (l : List (BitVec 8)) : BitVec (8 * l.length) :=
  (BitVec.ofNat (8 * l.length) (l.foldr (fun b acc => b.toNat + 256 * acc) 0))

/-- sha2's `Sha512::new()` at `self`, the `n` input bytes at `data`; then the globals'. -/
private def state (n : Nat) : GlobalState :=
  let m : MemoryState :=
    ⟨Std.ExtHashMap.ofList
        [(⟨1⟩, .ofBytes 208 0), (⟨2⟩, .ofBytes n ((bits (input n)).cast (by simp [input])))]⟩
  GlobalState.withGlobals
    BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0.globals
    ⟨⟨3⟩, m.storeSha512 (self.add 128#64) Sha512.IV⟩

/-- The lift's `update` of `len` bytes at `data`. -/
private def run (s : GlobalState) (len : Nat) : Option GlobalState :=
  match
    BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0.eval 10
      (args (.value self) (.value data) (.value (BitVec.ofNat 64 len)) (.value (self.add 128#64)))
      s with
  | .value (some .nil, s') => some s'
  | _ => none

/-- The object at `self`: state words, buffered bytes, their count, blocks counted. -/
private def obj (m : MemoryState) : Vector (BitVec 64) 8 × List (BitVec 8) × Nat × Nat :=
  let p := (m.readAt (self.add 127#64) 8).toNat
  (m.readSha512 (self.add 128#64), bytesLE (m.readAt self (8 * p)), p,
    (m.readAt (self.add 192#64) 128).toNat)

/-- `run` agrees with `updateMem` and `3 * updateCalls` frames. -/
private def agrees (s : GlobalState) (len : Nat) : Bool :=
  match run s len with
  | some s' =>
    obj s'.mem == obj (updateMem s.mem self data (BitVec.ofNat 64 len)) &&
      s'.alloc.nextFreeBlock ==
        s.alloc.nextFreeBlock + 3 * updateCalls s.mem self (BitVec.ofNat 64 len)
  | none => false

/-- What the object should have absorbed from `new()` after `M`. -/
private def expected (M : List (BitVec 8)) : Vector (BitVec 64) 8 × List (BitVec 8) × Nat × Nat :=
  (Sha512.compressBlocks Sha512.IV M, M.drop (M.length / 128 * 128), M.length % 128, M.length / 128)

#guard [3, 128, 300].all fun n => agrees (state n) n

#guard (run (state 300) 300).map (obj ·.mem) == some (expected (input 300))

#guard
  ((run (state 100) 3).bind (run · 100)).map (obj ·.mem) == some (expected (input 3 ++ input 100))

#guard
  ((run (state 300) 100).bind (run · 300)).map (obj ·.mem) ==
    some (expected (input 100 ++ input 300))

end MLIR.Agave.Avx2.BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0
