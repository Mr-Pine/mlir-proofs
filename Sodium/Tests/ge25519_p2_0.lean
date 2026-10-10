module

public import Sodium.ge25519_p2_0

meta import Sodium.ge25519_p2_0

namespace MLIR.Sodium

/-- A block holding the `n` bytes `b`. -/
private def blk (n : Nat) (b : BitVec (8 * n)) : MemoryBlock :=
  .ofBytes n b

/-- Limbs as the 40 bytes of a field element. -/
private def bytesOf (l : Fin 5 → BitVec 64) : BitVec 320 :=
  l 4 ++ l 3 ++ l 2 ++ l 1 ++ l 0

/-- Limbs agree. -/
private def limbsEq (a b : Fin 5 → BitVec 64) : Bool :=
  (List.finRange 5).all fun k => a k == b k

/-- Test field element `k`: limbs below `2^51`, pseudo-random. -/
private def fe (k : Nat) : Fin 5 → BitVec 64 := fun i =>
  BitVec.ofNat 64 ((k * 0x9e3779b97f4a7c15 + (i.val + 1) * 0x51ed27e2b7f3a91) % 2 ^ 51)

/-- `h` in block 1; it after the call, or `none` for UB. -/
private def run : Option GeP2 :=
  let s : GlobalState := ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, blk 120 0)]⟩⟩
  match ge25519_p2_0.call (ge25519_p2_0.args (.value ⟨⟨1⟩, 0⟩)) s with
  | .value (_, s') => some (s'.mem.readP2 ⟨⟨1⟩, 0⟩)
  | _ => none

-- `(0 : 1 : 1)`
#guard
  match run with
  | some R =>
    limbsEq R.X Boringssl.ge_p2_0.spec.X && limbsEq R.Y Boringssl.ge_p2_0.spec.Y &&
      limbsEq R.Z Boringssl.ge_p2_0.spec.Z
  | none => false

end MLIR.Sodium
