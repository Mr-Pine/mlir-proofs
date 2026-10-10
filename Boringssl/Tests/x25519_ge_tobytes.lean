module

public import Boringssl.x25519_ge_tobytes

meta import Boringssl.x25519_ge_tobytes

namespace MLIR.Boringssl

/-- A block holding the `n` bytes `b`. -/
private def blk (n : Nat) (b : BitVec (8 * n)) : MemoryBlock :=
  .ofBytes n b

/-- Limbs as the 40 bytes of a field element. -/
private def bytesOf (l : Fin 5 → BitVec 64) : BitVec 320 :=
  l 4 ++ l 3 ++ l 2 ++ l 1 ++ l 0

/-- Limbs' number. -/
private def natOf (l : Fin 5 → BitVec 64) : Nat :=
  (l 0).toNat + (l 1).toNat * 2 ^ 51 + (l 2).toNat * 2 ^ 102 + (l 3).toNat * 2 ^ 153 +
    (l 4).toNat * 2 ^ 204

private def p : Nat :=
  2 ^ 255 - 19

/-- `b ^ e % m` by squaring. -/
private def powMod (b e m : Nat) : Nat :=
  if e = 0 then 1 % m
  else
    let h := powMod (b * b % m) (e / 2) m
    if e % 2 = 0 then h else h * b % m
termination_by e
decreasing_by omega

/-- Test field element `k`: tight limbs, pseudo-random. -/
private def fe (k : Nat) : Fin 5 → BitVec 64 := fun i =>
  BitVec.ofNat 64 ((k * 0x9e3779b97f4a7c15 + (i.val + 1) * 0x51ed27e2b7f3a91) % 2 ^ 51)

/-- `s` (32 bytes) in block 1, `h` in block 2; `s` after the call, or `none` for UB. -/
private def run (P : GeP2) : Option (BitVec 256) :=
  let s : GlobalState :=
    ⟨⟨3⟩,
      ⟨Std.ExtHashMap.ofList
          [(⟨1⟩, blk 32 0), (⟨2⟩, blk 120 (bytesOf P.Z ++ bytesOf P.Y ++ bytesOf P.X))]⟩⟩
  match x25519_ge_tobytes.call (x25519_ge_tobytes.args (.value ⟨⟨1⟩, 0⟩) (.value ⟨⟨2⟩, 0⟩)) s with
  | .value (_, s') => some (s'.mem.readAt ⟨⟨1⟩, 0⟩ 256)
  | _ => none

/-- The encoding of `(X / Z, Y / Z)`: `y` below `p`, the parity of `x` on top. -/
private def encodeNat (P : GeP2) : Nat :=
  let r := powMod (natOf P.Z) (p - 2) p
  let x := natOf P.X * r % p
  let y := natOf P.Y * r % p
  y + 2 ^ 255 * (x % 2)

-- the encoding, on three points (`spec`'s inversion chain is not evaluated: its closures recompute
-- exponentially)
#guard
  ([⟨fe 0, fe 1, fe 2⟩, ⟨fe 7, fe 8, fe 9⟩, ⟨fe 14, fe 15, fe 16⟩] : List GeP2).all fun P =>
    (run P).map BitVec.toNat == some (encodeNat P)

end MLIR.Boringssl
