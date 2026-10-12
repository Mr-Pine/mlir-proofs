module

public import Agave.Avx2.Sha512VarCore_VariableOutputCore_finalize_variable_core
public import Agave.Serial.BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0

meta import Agave.Avx2.Sha512VarCore_VariableOutputCore_finalize_variable_core
meta import Agave.Serial.BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0

/-! The lift on sha2's `Sha512` having absorbed messages whose last block is short, long
(`pos ≥ 112`) and empty: against SHA-512's digest, `call_eq`'s memory and the frame count. -/

namespace MLIR.Agave.Avx2.Sha512VarCore_VariableOutputCore_finalize_variable_core

open _root_.Ed25519
open
  Serial.BlockBuffer_UInt_UTerm_B1_B0_Eager_digest_blocks_Sha512_Update_update_closure_0 (updateMem)
open Serial.Sha512VarCore_VariableOutputCore_finalize_variable_core (outBits state)

private def d : Pointer :=
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

/-- sha2's `Sha512` at `d` having absorbed `msg n` (by `update`'s memory), room at `out`. -/
private def state' (n : Nat) : GlobalState :=
  let m : MemoryState :=
    ⟨Std.ExtHashMap.ofList
        [(⟨1⟩, .ofBytes 208 0), (⟨2⟩, .ofBytes n ((bits (msg n)).cast (by simp [msg]))),
          (⟨3⟩, .ofBytes 64 0)]⟩
  ⟨⟨4⟩, updateMem (m.storeSha512 (d.add 128#64) Sha512.IV) d data (BitVec.ofNat 64 n)⟩

/-- The lift's output bytes, state words and position agree with SHA-512 and `call_eq`. -/
private def agrees (n : Nat) : Bool :=
  let s := state' n
  match
    Sha512VarCore_VariableOutputCore_finalize_variable_core.eval 10
      (args (.value (d.add 128#64)) (.value d) (.value out)) s with
  | .value (some .nil, s') =>
    bytesLE (s'.mem.readAt out 512) == Sha512.digest (msg n) &&
      s'.mem.readAt out 512 == outBits (state s.mem d) &&
      s'.mem.readSha512 (d.add 128#64) == state s.mem d &&
      s'.mem.readAt (d.add 127#64) 8 == 0#8 &&
      s'.alloc.nextFreeBlock == s.alloc.nextFreeBlock + framesOf (msg n)
  | _ => false

#guard [0, 1, 3, 111, 112, 127, 128, 200, 239, 240, 300].all agrees

end MLIR.Agave.Avx2.Sha512VarCore_VariableOutputCore_finalize_variable_core
