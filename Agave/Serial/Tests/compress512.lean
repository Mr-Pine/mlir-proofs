module

public import Agave.Serial.compress512

meta import Agave.Serial.compress512

/-! The lift is `noncomputable` (its table): its spec is tested against FIPS 180-4's example. -/

namespace MLIR.Agave.Serial

open _root_.Ed25519

/-- `"abc"` padded to one 128-byte block. -/
private def abc : List (BitVec 8) :=
  Sha512.pad [0x61, 0x62, 0x63]

/-- SHA-512("abc"), as eight big-endian words (FIPS 180-2, appendix C.1). -/
private def abcDigest : Vector (BitVec 64) 8 :=
  #v[0xddaf35a193617aba#64, 0xcc417349ae204131#64, 0x12e6fa4e89a97ea2#64, 0x0a9eeee64b55d39a#64,
    0x2192992a274fc1a8#64, 0x36ba3c23a3feebbd#64, 0x454d4423643ce80e#64, 0x2a9ac94fa54ca49f#64]

#guard compress512.spec Sha512.IV abc == abcDigest

-- two blocks: the second compressed from the first's words; a short tail is left
#guard compress512.spec Sha512.IV (abc ++ abc ++ [1, 2, 3]) == Sha512.compress abcDigest abc

end MLIR.Agave.Serial
