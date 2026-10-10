module

public import Sodium.rotr64

meta import Sodium.rotr64

namespace MLIR.Sodium

private def s0 : GlobalState :=
  ⟨⟨1⟩, ⟨∅⟩⟩

#guard
  [1, 8, 14, 19, 28, 61, 63].all fun b =>
    let x := 0x0123456789abcdef#64
    match rotr64.eval 1 (rotr64.args (.value x) (.value (BitVec.ofNat 32 b))) s0 with
    | .value (some (.cons r .nil), _) =>
      r == .value (rotr64.spec x (BitVec.ofNat 32 b)) &&
        rotr64.spec x (BitVec.ofNat 32 b) == x.rotateRight b
    | _ => false

end MLIR.Sodium
