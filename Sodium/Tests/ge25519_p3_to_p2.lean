module

public import Sodium.ge25519_p3_to_p2

meta import Sodium.ge25519_p3_to_p2

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

/-- The `GeP2`s agree. -/
private def eqP2 (a b : GeP2) : Bool :=
  limbsEq a.X b.X && limbsEq a.Y b.Y && limbsEq a.Z b.Z

/-- The output in block 1, `P` in block 2; the output after the call, or `none` for UB. -/
private def run (P : GeP3) : Option GeP2 :=
  let s : GlobalState :=
    ⟨⟨3⟩,
      ⟨Std.ExtHashMap.ofList
          [(⟨1⟩, blk 120 0),
            (⟨2⟩, blk 160 (bytesOf P.T ++ bytesOf P.Z ++ bytesOf P.Y ++ bytesOf P.X))]⟩⟩
  match ge25519_p3_to_p2.call (ge25519_p3_to_p2.args (.value ⟨⟨1⟩, 0⟩) (.value ⟨⟨2⟩, 0⟩)) s with
  | .value (_, s') => some (s'.mem.readP2 ⟨⟨1⟩, 0⟩)
  | _ => none

-- the spec's, on three inputs
#guard
  ([⟨fe 0, fe 1, fe 2, fe 3⟩, ⟨fe 7, fe 8, fe 9, fe 10⟩, ⟨fe 14, fe 15, fe 16, fe 17⟩] :
        List GeP3).all
    fun P =>
    match run P with
    | some R => eqP2 R (Boringssl.ge_p3_to_p2.spec P)
    | none => false

end MLIR.Sodium
