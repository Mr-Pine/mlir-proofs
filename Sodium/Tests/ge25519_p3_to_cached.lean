module

public import Sodium.ge25519_p3_to_cached

meta import Sodium.ge25519_p3_to_cached

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

/-- The `GeCached`s agree. -/
private def eqCached (a b : GeCached) : Bool :=
  limbsEq a.YplusX b.YplusX && limbsEq a.YminusX b.YminusX && limbsEq a.Z b.Z && limbsEq a.T2d b.T2d

/-- The output in block 1, `P` in block 2; the output after the call, or `none` for UB. -/
private def run (P : GeP3) : Option GeCached :=
  let s : GlobalState :=
    ⟨⟨3⟩,
      ⟨Std.ExtHashMap.ofList
          [(⟨1⟩, blk 160 0),
            (⟨2⟩, blk 160 (bytesOf P.T ++ bytesOf P.Z ++ bytesOf P.Y ++ bytesOf P.X))]⟩⟩
  match
    ge25519_p3_to_cached.call (ge25519_p3_to_cached.args (.value ⟨⟨1⟩, 0⟩) (.value ⟨⟨2⟩, 0⟩)) s with
  | .value (_, s') => some (s'.mem.readCached ⟨⟨1⟩, 0⟩)
  | _ => none

-- the spec's, on three inputs
#guard
  ([⟨fe 0, fe 1, fe 2, fe 3⟩, ⟨fe 7, fe 8, fe 9, fe 10⟩, ⟨fe 14, fe 15, fe 16, fe 17⟩] :
        List GeP3).all
    fun P =>
    match run P with
    | some R => eqCached R (ge25519_p3_to_cached.spec P)
    | none => false

end MLIR.Sodium
