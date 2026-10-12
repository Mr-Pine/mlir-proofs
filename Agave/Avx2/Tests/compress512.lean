module

public import Agave.Avx2.compress512

meta import Agave.Avx2.compress512

namespace MLIR.Agave.Avx2

open _root_.Ed25519

private def st : Pointer :=
  ⟨⟨1⟩, 0⟩

private def blocks : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Block 0 free (the null pointer's); the state words `H` at `st`, `n` blocks of bytes `data` at
`blocks`. -/
private def state (H : Vector (BitVec 64) 8) (n : Nat) (data : BitVec (1024 * n)) : GlobalState :=
  ⟨⟨3⟩,
    ⟨Std.ExtHashMap.ofList
        [(⟨1⟩, .ofBytes 64 (H[7] ++ H[6] ++ H[5] ++ H[4] ++ H[3] ++ H[2] ++ H[1] ++ H[0])),
          (⟨2⟩, .ofBytes (128 * n) (data.cast (by omega)))]⟩⟩

/-- The run stores `Serial.compress512.spec` of the state words and the blocks at `st`. -/
private def agrees (H : Vector (BitVec 64) 8) (n : Nat) (data : BitVec (1024 * n)) : Bool :=
  let s := state H n data
  match compress512.eval 2000 (compress512.args (.value st) (.value blocks) (.value n)) s with
  | .value (some .nil, s') =>
    s'.mem.readSha512 st ==
      Serial.compress512.spec (s.mem.readSha512 st) (bytesLE (s.mem.readAt blocks (1024 * n)))
  | _ => false

/-- Distinct bytes, `n` blocks of them. -/
private def bytes (n : Nat) : BitVec (1024 * n) :=
  BitVec.ofNat _ ((List.range (128 * n)).foldl (fun acc i => acc * 256 + (i * 37 + 11) % 256) 0)

#guard agrees Sha512.IV 0 (bytes 0)

#guard agrees Sha512.IV 1 (bytes 1)

#guard agrees Sha512.IV 2 (bytes 2)

#guard agrees Sha512.IV 3 (bytes 3)

#guard agrees #v[1, 2, 3, 4, 5, 6, 7, 8] 4 (bytes 4)

end MLIR.Agave.Avx2
