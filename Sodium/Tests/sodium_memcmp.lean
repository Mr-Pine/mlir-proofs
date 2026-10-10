module

public import Sodium.sodium_memcmp

meta import Sodium.sodium_memcmp

namespace MLIR.Sodium

/-- `a` in block 1 and `b` in block 2, 80 bytes each; the result on their first `n` bytes, or
`none` for UB. -/
private def run (a b : BitVec 640) (n : Nat) (alias : Bool := false) : Option (BitVec 32) :=
  let s : GlobalState := ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 80 a), (⟨2⟩, .ofBytes 80 b)]⟩⟩
  match
    sodium_memcmp.call
      (sodium_memcmp.args (.value ⟨⟨1⟩, 0⟩) (.value ⟨⟨if alias then 1 else 2⟩, 0⟩)
        (.value (BitVec.ofNat 64 n)))
      s with
  | .value (.cons (.value r) .nil, _) => some r
  | _ => none

private def a : BitVec 640 :=
  (0x0123456789abcdef#64).replicate 10

/-- `a` with byte `k` changed. -/
private def b (k : Nat) : BitVec 640 :=
  a ^^^ (0x5a#640 <<< (8 * k))

-- `spec`'s on every length up to 80: the 32-byte, 4-byte and byte loops, each alone and combined
#guard
  (List.range 81).all fun n =>
    run a (b 45) n == some (sodium_memcmp.spec n a (b 45)) && run a a n == some 0 &&
      run a a n true == some 0

-- a difference anywhere in the range is found, by each loop
#guard
  [0, 2, 5, 17, 31, 33, 50, 63, 64, 70, 79].all fun k =>
    (List.range 81).all fun n => (run a (b k) n == some 0) == decide (n ≤ k)

#guard run a (b 3) 10 == some 0xffffffff#32

end MLIR.Sodium
