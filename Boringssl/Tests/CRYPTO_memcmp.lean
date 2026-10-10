module

public import Boringssl.CRYPTO_memcmp

meta import Boringssl.CRYPTO_memcmp

namespace MLIR.Boringssl

/-- `a` in block 1 and `b` in block 2, 40 bytes each; the result on their first `n` bytes, or
`none` for UB. -/
private def run (a b : BitVec 320) (n : Nat) : Option (BitVec 32) :=
  let s : GlobalState := ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 40 a), (⟨2⟩, .ofBytes 40 b)]⟩⟩
  match
    CRYPTO_memcmp.call
      (CRYPTO_memcmp.args (.value ⟨⟨1⟩, 0⟩) (.value ⟨⟨2⟩, 0⟩) (.value (BitVec.ofNat 64 n))) s with
  | .value (.cons (.value r) .nil, _) => some r
  | _ => none

private def a : BitVec 320 :=
  0x0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef#320

/-- `a` with byte 12 (bits 96 …) changed. -/
private def b : BitVec 320 :=
  a ^^^ (0x5a#320 <<< 96)

-- `spec`'s on every length up to 40: the vector loop, the tail, both, neither
#guard
  (List.range 41).all fun n => run a b n == some (CRYPTO_memcmp.spec a b n) && run a a n == some 0

-- the ranges differ from byte 12 on
#guard (List.range 41).all fun n => (run a b n == some 0) == decide (n ≤ 12)

end MLIR.Boringssl
