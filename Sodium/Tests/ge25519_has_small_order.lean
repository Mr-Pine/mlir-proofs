module

public import Sodium.ge25519_has_small_order

meta import Sodium.ge25519_has_small_order

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

/-- `s` in block 1; the result, or `none` for UB. -/
private def run (s : BitVec 256) : Option (BitVec 32) :=
  let st : GlobalState := ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, blk 32 s)]⟩⟩
  match ge25519_has_small_order.call (ge25519_has_small_order.args (.value ⟨⟨1⟩, 0⟩)) st with
  | .value (.cons (.value r) .nil, _) => some r
  | _ => none

/-- The table's entries, with the sign bit too, and their neighbours. -/
private def bufs : List Nat :=
  (ge25519_has_small_order.blacklist.map BitVec.toNat).flatMap fun n =>
    [n, n + 2 ^ 255, n + 2, (n + 2 ^ 254) % 2 ^ 256]

-- `spec`, and the expected result
#guard
  bufs.all fun s =>
    let b := BitVec.ofNat 256 s
    run b == some (ge25519_has_small_order.spec b) &&
      run b ==
        some
          (if (ge25519_has_small_order.blacklist.map BitVec.toNat).contains (s % 2 ^ 255) then 1#32
          else 0#32)

end MLIR.Sodium
