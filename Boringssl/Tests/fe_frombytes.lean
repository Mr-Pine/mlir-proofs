module

public import Boringssl.fe_frombytes

meta import Boringssl.fe_frombytes

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

/-- Test elements: small, near `2^52`, mixed, and `p`'s limbs. -/
private def xs : List (Fin 5 → BitVec 64) :=
  [fun i => #v[1, 2, 3, 4, 5][i], fun i =>
    #v[0xfffffffffffff, 0x8000000000000, 0x7ffffffffffff, 0xfffffffffffed, 0x1][i], fun i =>
    #v[0x123456789abcd, 0x7edcba9876543, 0x1111111111111, 0x0, 0x7ffffffffffff][i], fun i =>
    #v[0x7ffffffffffed, 0x7ffffffffffff, 0x7ffffffffffff, 0x7ffffffffffff, 0x7ffffffffffff][i]]

/-- `h` in block 1, the bytes `b` in block 2; `h`'s limbs, or `none` for UB. -/
private def run (b : BitVec 256) : Option (Fin 5 → BitVec 64) :=
  let s : GlobalState := ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, blk 40 0), (⟨2⟩, blk 32 b)]⟩⟩
  match fe_frombytes.call (fe_frombytes.args (.value ⟨⟨1⟩, 0⟩) (.value ⟨⟨2⟩, 0⟩)) s with
  | .value (_, s') => some (s'.mem.readLimbs ⟨⟨1⟩, 0⟩)
  | _ => none

/-- Bytes with and without bit 255. -/
private def bs : List (BitVec 256) :=
  [0, 1, BitVec.allOnes 256, 0x8000000000000000000000000000000000000000000000000000000000000001#256,
    0x0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef#256]

-- the low 255 bits, as `spec`'s limbs
#guard
  bs.all fun b =>
    match run b with
    | some r =>
      (List.finRange 5).all fun k =>
        r k == Firedancer.Ref.fiat_25519_from_bytes.spec b k && natOf r == b.toNat % 2 ^ 255
    | none => false

end MLIR.Boringssl
