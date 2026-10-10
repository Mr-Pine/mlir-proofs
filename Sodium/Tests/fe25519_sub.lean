module

public import Sodium.fe25519_sub

meta import Sodium.fe25519_sub

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

/-- `h` in block 1, `f` and `g` in blocks 2 and 3; `h`'s limbs after the call, or `none` for UB. -/
private def run (a b : Fin 5 → BitVec 64) : Option (Fin 5 → BitVec 64) :=
  let s : GlobalState :=
    ⟨⟨4⟩,
      ⟨Std.ExtHashMap.ofList
          [(⟨1⟩, blk 40 0), (⟨2⟩, blk 40 (bytesOf a)), (⟨3⟩, blk 40 (bytesOf b))]⟩⟩
  match
    fe25519_sub.call (fe25519_sub.args (.value ⟨⟨1⟩, 0⟩) (.value ⟨⟨2⟩, 0⟩) (.value ⟨⟨3⟩, 0⟩)) s with
  | .value (_, s') => some (s'.mem.readLimbs ⟨⟨1⟩, 0⟩)
  | _ => none

-- every limb is the spec's
#guard
  xs.all fun a =>
    xs.all fun b =>
      match run a b with
      | some r => (List.finRange 5).all fun k => r k == fe25519_sub.spec a b k
      | none => false

end MLIR.Sodium
