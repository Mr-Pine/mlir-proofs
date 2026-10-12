module

public import Boringssl.ed25519_verify

meta import Boringssl.ed25519_verify

namespace MLIR.Boringssl

open ed25519_verify

/-- `ℓ`. -/
private def ell : Nat :=
  0x1000000000000000000000000000000014def9dea2f79cd65812631a5cf5d3ed

private def inputs : List (BitVec 256) :=
  [0, 1, BitVec.ofNat 256 (ell - 1), BitVec.ofNat 256 ell, BitVec.ofNat 256 (ell + 1),
    0x1000000000000000000000000000000014def9dea2f79cd65812631a5cf5d3ec#256,
    0x1000000000000000000000000000000014def9dea2f79cd70000000000000000#256,
    0x1000000000000000000000000000000114def9dea2f79cd60000000000000000#256,
    0x0fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff#256, -1]

-- The word loop decides `S < ℓ`.
#guard inputs.all fun S => sOk S == decide (S.toNat < ell)

-- A load per word compared: one, then two, three, four as the top words tie.
#guard
  sBlocks 0 == 1 && sBlocks (BitVec.ofNat 256 (ell - 1)) == 4 &&
    sBlocks 0x1000000000000000000000000000000114def9dea2f79cd60000000000000000#256 == 2

end MLIR.Boringssl
