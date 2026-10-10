module

public import Firedancer.Avx512.fd_r43x6_pow22523_2

meta import Firedancer.Avx512.fd_r43x6_pow22523_2

namespace MLIR.Firedancer.Avx512

private def p : Nat :=
  2 ^ 255 - 19

/-- The field element of lanes `0 … 5`, radix `2^43`, mod `p`. -/
private def value (v : Wwl) : Nat :=
  (List.range 6).foldl (fun acc i => acc + v[i]!.toNat * 2 ^ (43 * i)) 0 % p

/-- `b ^ e` mod `p`, by squaring and multiplying over `e`'s 256 bits. -/
private def powMod (b e : Nat) : Nat :=
  (List.range 256).reverse.foldl
    (fun acc i =>
      let a := acc * acc % p
      if e.testBit i then a * b % p else a)
    1

/-- `N`'s 43-bit limbs. -/
private def limbs (N : Nat) : Wwl :=
  Vector.ofFn fun i =>
    if i.val < 5 then BitVec.ofNat 64 (N / 2 ^ (43 * i.val) % 2 ^ 43)
    else if i.val = 5 then BitVec.ofNat 64 (N / 2 ^ 215) else 0

private def _za : Pointer :=
  ⟨⟨0⟩, 0⟩

private def _zb : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- Two zeroed 64-byte blocks. -/
private def state : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, .ofBytes 64 0), (⟨1⟩, .ofBytes 64 0)]⟩⟩

/-- `*_za` and `*_zb` hold `za^(2^252 - 3)` and `zb^(2^252 - 3)` mod `p`; the temporaries are
gone. -/
private def check (za zb : Nat) : Bool :=
  match
    fd_r43x6_pow22523_2.call
      (fd_r43x6_pow22523_2.args (.value _za) (Ty.wrap (limbs za)) (.value _zb) (Ty.wrap (limbs zb)))
      state with
  | .value (.nil, s') =>
    value (s'.mem.readVec _za) == powMod za (2 ^ 252 - 3) &&
      value (s'.mem.readVec _zb) == powMod zb (2 ^ 252 - 3) &&
      s'.mem.mem.size == 2
  | _ => false

#guard check 2 3

#guard check (2 ^ 254 + 12345) (p - 1)

end MLIR.Firedancer.Avx512
