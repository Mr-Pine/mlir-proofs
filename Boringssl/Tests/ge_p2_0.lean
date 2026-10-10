module

public import Boringssl.ge_p2_0

meta import Boringssl.ge_p2_0

namespace MLIR.Boringssl

/-- A block holding the `n` bytes `b`. -/
private def blk (n : Nat) (b : BitVec (8 * n)) : MemoryBlock :=
  .ofBytes n b

/-- Limbs as the 40 bytes of a field element. -/
private def bytesOf (l : Fin 5 → BitVec 64) : BitVec 320 :=
  l 4 ++ l 3 ++ l 2 ++ l 1 ++ l 0

/-- Limbs agree. -/
private def limbsEq (a b : Fin 5 → BitVec 64) : Bool :=
  (List.finRange 5).all fun k => a k == b k

/-- Test field element `k`: tight limbs, pseudo-random. -/
private def fe (k : Nat) : Fin 5 → BitVec 64 := fun i =>
  BitVec.ofNat 64 ((k * 0x9e3779b97f4a7c15 + (i.val + 1) * 0x51ed27e2b7f3a91) % 2 ^ 51)

/-- `ge_p2`s agree. -/
private def eqP2 (a b : GeP2) : Bool :=
  limbsEq a.X b.X && limbsEq a.Y b.Y && limbsEq a.Z b.Z

/-- The output in block 1; the output after the call, or
`none` for UB. -/
private def run : Option GeP2 :=
  let s : GlobalState := ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, blk 120 0)]⟩⟩
  match ge_p2_0.call (ge_p2_0.args (.value ⟨⟨1⟩, 0⟩)) s with
  | .value (_, s') => some (s'.mem.readP2 ⟨⟨1⟩, 0⟩)
  | _ => none

-- the spec's
#guard
  match run with
  | some R => eqP2 R ge_p2_0.spec
  | none => false

end MLIR.Boringssl
