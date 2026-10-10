module

public import Sodium.ge25519_p2_dbl

meta import Sodium.ge25519_p2_dbl

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

/-- The `GeP1p1`s agree. -/
private def eqP1p1 (a b : GeP1p1) : Bool :=
  limbsEq a.X b.X && limbsEq a.Y b.Y && limbsEq a.Z b.Z && limbsEq a.T b.T

/-- The output in block 1, `P` in block 2; the output after the call, or `none` for UB. -/
private def run (P : GeP2) : Option GeP1p1 :=
  let s : GlobalState :=
    ⟨⟨3⟩,
      ⟨Std.ExtHashMap.ofList
          [(⟨1⟩, blk 160 0), (⟨2⟩, blk 120 (bytesOf P.Z ++ bytesOf P.Y ++ bytesOf P.X))]⟩⟩
  match ge25519_p2_dbl.call (ge25519_p2_dbl.args (.value ⟨⟨1⟩, 0⟩) (.value ⟨⟨2⟩, 0⟩)) s with
  | .value (_, s') => some (s'.mem.readP1p1 ⟨⟨1⟩, 0⟩)
  | _ => none

-- the spec's, on three inputs
#guard
  ([⟨fe 0, fe 1, fe 2⟩, ⟨fe 7, fe 8, fe 9⟩, ⟨fe 14, fe 15, fe 16⟩] : List GeP2).all fun P =>
    match run P with
    | some R => eqP1p1 R (ge25519_p2_dbl.spec P)
    | none => false

end MLIR.Sodium
