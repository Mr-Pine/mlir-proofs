module

public import Agave.Serial.Sha512VarCore_VariableOutputCore_finalize_variable_core

meta import Agave.Serial.Sha512VarCore_VariableOutputCore_finalize_variable_core

/-! The lift is `noncomputable` (`compress512`'s table): its spec is tested against SHA-512 on
messages whose last block is short, long (`pos ≥ 112`) and empty. -/

namespace MLIR.Agave.Serial.Sha512VarCore_VariableOutputCore_finalize_variable_core

open _root_.Ed25519

/-- The message `M`'s output bytes by `spec`, from what sha2's `Sha512` holds after it. -/
private def out (M : List (BitVec 8)) : List (BitVec 8) :=
  let P := BitVec.ofNat 8 (M.length % 128)
  let T := M.drop (M.length / 128 * 128)
  let D : BitVec (8 * P.toNat) := BitVec.ofNat _ (T.foldr (fun b acc => b.toNat + 256 * acc) 0)
  bytesLE
    (outBits (spec (Sha512.compressBlocks Sha512.IV M) (BitVec.ofNat 128 (M.length / 128)) P D))

/-- `n` bytes `0, 1, 2, …`. -/
private def msg (n : Nat) : List (BitVec 8) :=
  (List.range n).map (BitVec.ofNat 8)

/-- SHA-512("abc") (FIPS 180-2, appendix C.1). -/
private def abcDigest : List (BitVec 8) :=
  (#v[0xddaf35a193617aba#64, 0xcc417349ae204131#64, 0x12e6fa4e89a97ea2#64, 0x0a9eeee64b55d39a#64,
          0x2192992a274fc1a8#64, 0x36ba3c23a3feebbd#64, 0x454d4423643ce80e#64,
          0x2a9ac94fa54ca49f#64] :
        Vector (BitVec 64) 8).toList.flatMap
    Sha512.bytesBE

#guard out [0x61, 0x62, 0x63] == abcDigest

#guard
  [0, 1, 111, 112, 127, 128, 200, 239, 240, 300].all fun n => out (msg n) == Sha512.digest (msg n)

end MLIR.Agave.Serial.Sha512VarCore_VariableOutputCore_finalize_variable_core
