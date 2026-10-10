module

public import Boringssl.x25519_ge_sub

meta import Boringssl.x25519_ge_sub

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

/-- `ge_p1p1`s agree. -/
private def eqP1p1 (a b : GeP1p1) : Bool :=
  limbsEq a.X b.X && limbsEq a.Y b.Y && limbsEq a.Z b.Z && limbsEq a.T b.T

/-- The output in block 1, `P` in block 2, `Q` in block 3; the output after the call, or
`none` for UB. -/
private def run (P : GeP3) (Q : GeCached) : Option GeP1p1 :=
  let s : GlobalState :=
    ⟨⟨4⟩,
      ⟨Std.ExtHashMap.ofList
          [(⟨1⟩, blk 160 0),
            (⟨2⟩, blk 160 (bytesOf P.T ++ bytesOf P.Z ++ bytesOf P.Y ++ bytesOf P.X)),
            (⟨3⟩,
              blk 160 (bytesOf Q.T2d ++ bytesOf Q.Z ++ bytesOf Q.YminusX ++ bytesOf Q.YplusX))]⟩⟩
  match
    x25519_ge_sub.call (x25519_ge_sub.args (.value ⟨⟨1⟩, 0⟩) (.value ⟨⟨2⟩, 0⟩) (.value ⟨⟨3⟩, 0⟩))
      s with
  | .value (_, s') => some (s'.mem.readP1p1 ⟨⟨1⟩, 0⟩)
  | _ => none

-- the spec's, on three inputs
#guard
  ([(⟨fe 0, fe 1, fe 2, fe 3⟩, ⟨fe 21, fe 22, fe 23, fe 24⟩),
          (⟨fe 7, fe 8, fe 9, fe 10⟩, ⟨fe 28, fe 29, fe 30, fe 31⟩),
          (⟨fe 14, fe 15, fe 16, fe 17⟩, ⟨fe 35, fe 36, fe 37, fe 38⟩)] :
        List (GeP3 × GeCached)).all
    fun (P, Q) =>
    match run P Q with
    | some R => eqP1p1 R (x25519_ge_sub.spec P Q)
    | none => false

end MLIR.Boringssl
