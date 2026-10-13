module

public import Agave.Avx2.CachedPoint_From_ExtendedPoint_from_impl_from

meta import Agave.Avx2.CachedPoint_From_ExtendedPoint_from_impl_from

namespace MLIR.Agave.Avx2

private def out : Pointer :=
  ⟨⟨1⟩, 0⟩

private def x : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Block 0 free (the null pointer's); `out` a 160-byte zeroed block, `x` holding `xBytes`. -/
private def state (xBytes : BitVec 1280) : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 160 0), (⟨2⟩, .ofBytes 160 xBytes)]⟩⟩

/-- Every lane `2^26 - 1`, a reduced limb's bound. -/
private def limbs : BitVec 1280 :=
  BitVec.ofNat 1280 (∑ i ∈ Finset.range 40, (2 ^ 26 - 1) * 2 ^ (32 * i))

/-- Lane `j` of register `i` is `7 j + 1000 i + 3`. -/
private def mixed : BitVec 1280 :=
  BitVec.ofNat 1280
    (∑ i ∈ Finset.range 5, ∑ j ∈ Finset.range 8, (7 * j + 1000 * i + 3) * 2 ^ (32 * (8 * i + j)))

/-- The run agrees with `spec` on `s`. -/
private def agrees (s : GlobalState) : Bool :=
  match
    CachedPoint_From_ExtendedPoint_from_impl_from.eval 1
      (CachedPoint_From_ExtendedPoint_from_impl_from.args (.value out) (.value x)) s with
  | .value (some .nil, s') =>
    (List.finRange 5).all fun k =>
      s'.mem.readFe4x out k ==
        CachedPoint_From_ExtendedPoint_from_impl_from.spec (s.mem.readFe4x x) k
  | _ => false

#guard agrees (state limbs)

#guard agrees (state mixed)

#guard agrees (state (BitVec.allOnes 1280))

end MLIR.Agave.Avx2
