module

public import Sodium.fe25519_isnegative

meta import Sodium.fe25519_isnegative

namespace MLIR.Sodium

/-- A block holding the `n` bytes `b`. -/
private def blk (n : Nat) (b : BitVec (8 * n)) : MemoryBlock :=
  .ofBytes n b

/-- Limbs as the 40 bytes of a field element. -/
private def bytesOf (l : Fin 5 → BitVec 64) : BitVec 320 :=
  l 4 ++ l 3 ++ l 2 ++ l 1 ++ l 0

/-- Test elements: small, near `2^52`, mixed, `p`'s limbs, and limbs near `2^54`. -/
private def xs : List (Fin 5 → BitVec 64) :=
  [fun i => #v[1, 2, 3, 4, 5][i], fun i =>
    #v[0xfffffffffffff, 0x8000000000000, 0x7ffffffffffff, 0xfffffffffffed, 0x1][i], fun i =>
    #v[0x123456789abcd, 0x7edcba9876543, 0x1111111111111, 0x0, 0x7ffffffffffff][i], fun i =>
    #v[0x7ffffffffffed, 0x7ffffffffffff, 0x7ffffffffffff, 0x7ffffffffffff, 0x7ffffffffffff][i],
    fun i => #v[0x3fffffffffffff, 0x3ffffffffffff0, 0x2fffffffffffff, 0x3fffffffffffff, 0x1][i]]

/-- `f` in block 1; the returned value, or `none` for UB. -/
private def run (a : Fin 5 → BitVec 64) : Option (BitVec 32) :=
  let s : GlobalState := ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, blk 40 (bytesOf a))]⟩⟩
  match fe25519_isnegative.call (fe25519_isnegative.args (.value ⟨⟨1⟩, 0⟩)) s with
  | .value (.cons (.value r) .nil, _) => some r
  | _ => none

-- the spec's value, also at `0` and `p` (zero, unreduced)
#guard (xs ++ [fun _ => 0]).all fun a => run a == some (fe25519_isnegative.spec a)

end MLIR.Sodium
