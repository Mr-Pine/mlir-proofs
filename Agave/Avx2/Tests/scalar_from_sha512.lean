module

public import Agave.Avx2.scalar_from_sha512
public import Agave.Serial.BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0
public import Ed25519.Decode

meta import Agave.Avx2.scalar_from_sha512
meta import Agave.Serial.BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0

/-! The lift on sha2's `Sha512` having absorbed messages of several lengths: against `call_eq`'s
scalar, SHA-512's digest as a number mod `ℓ`, and the frame count. -/

namespace MLIR.Agave.Avx2

open _root_.Ed25519
open
  Serial.BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0 (updateMem)

private def hash : Pointer :=
  ⟨⟨1⟩, 0⟩

private def data : Pointer :=
  ⟨⟨2⟩, 0⟩

private def out : Pointer :=
  ⟨⟨3⟩, 0⟩

/-- `n` bytes `0, 1, 2, …`. -/
private def msg (n : Nat) : List (BitVec 8) :=
  (List.range n).map (BitVec.ofNat 8)

/-- The bytes `l` as one bit vector, the first lowest. -/
private def bits (l : List (BitVec 8)) : BitVec (8 * l.length) :=
  (BitVec.ofNat (8 * l.length) (l.foldr (fun b acc => b.toNat + 256 * acc) 0))

/-- sha2's `Sha512` at `hash` having absorbed `msg n` (by `update`'s memory), room at `out`. -/
private def state (n : Nat) : GlobalState :=
  let m : MemoryState :=
    ⟨Std.ExtHashMap.ofList
        [(⟨1⟩, .ofBytes 208 0), (⟨2⟩, .ofBytes n ((bits (msg n)).cast (by simp [msg]))),
          (⟨3⟩, .ofBytes 32 0)]⟩
  ⟨⟨4⟩, updateMem (m.storeSha512 (hash.add 128#64) Sha512.IV) hash data (BitVec.ofNat 64 n)⟩

/-- The lift's scalar at `out` agrees with `spec`, SHA-512 mod `ℓ`, and the frames. -/
private def agrees (n : Nat) : Bool :=
  let s := state n
  match scalar_from_sha512.eval 10 (scalar_from_sha512.args (.value out) (.value hash)) s with
  | .value (some .nil, s') =>
    s'.mem.readAt out 256 == Serial.scalar_from_sha512.spec (msg n) &&
      (s'.mem.readAt out 256).toNat == natLE (Sha512.digest (msg n)) % ell &&
      s'.alloc.nextFreeBlock == s.alloc.nextFreeBlock + scalar_from_sha512.frames (msg n)
  | _ => false

#guard [0, 3, 64, 112, 200].all agrees

end MLIR.Agave.Avx2
