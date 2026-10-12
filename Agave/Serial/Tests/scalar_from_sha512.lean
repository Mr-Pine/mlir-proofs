module

public import Agave.Serial.scalar_from_sha512

meta import Agave.Serial.scalar_from_sha512

/-! The lift is `noncomputable` (`compress512`'s table): its spec is tested against SHA-512's digest
as a number mod `ℓ`. -/

namespace MLIR.Agave.Serial

open _root_.Ed25519

/-- `n` bytes `0, 1, 2, …`. -/
private def msg (n : Nat) : List (BitVec 8) :=
  (List.range n).map (BitVec.ofNat 8)

#guard
  [0, 3, 64, 112, 200].all fun n =>
    (scalar_from_sha512.spec (msg n)).toNat == natLE (Sha512.digest (msg n)) % ell

end MLIR.Agave.Serial
