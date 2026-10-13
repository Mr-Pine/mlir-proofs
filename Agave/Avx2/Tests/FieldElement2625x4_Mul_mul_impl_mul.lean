module

public import Agave.Avx2.FieldElement2625x4_Mul_mul_impl_mul

meta import Agave.Avx2.FieldElement2625x4_Mul_mul_impl_mul

namespace MLIR.Agave.Avx2

private def out : Pointer :=
  ⟨⟨1⟩, 0⟩

private def x : Pointer :=
  ⟨⟨2⟩, 0⟩

private def y : Pointer :=
  ⟨⟨3⟩, 0⟩

/-- Block 0 free (the null pointer's); `out` a 160-byte zeroed block, `x` and `y` holding `xBytes`
and `yBytes`. -/
private def state (xBytes yBytes : BitVec 1280) : GlobalState :=
  ⟨⟨4⟩,
    ⟨Std.ExtHashMap.ofList
        [(⟨1⟩, .ofBytes 160 0), (⟨2⟩, .ofBytes 160 xBytes), (⟨3⟩, .ofBytes 160 yBytes)]⟩⟩

/-- Every lane `2^32 - 1`. -/
private def ones : BitVec 1280 :=
  BitVec.allOnes 1280

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
    FieldElement2625x4_Mul_mul_impl_mul.eval 1
      (FieldElement2625x4_Mul_mul_impl_mul.args (.value out) (.value x) (.value y)) s with
  | .value (some .nil, s') =>
    (List.finRange 5).all fun k =>
      s'.mem.readFe4x out k ==
        FieldElement2625x4_Mul_mul_impl_mul.spec (s.mem.readFe4x x) (s.mem.readFe4x y) k
  | _ => false

#guard agrees (state ones ones)

#guard agrees (state limbs limbs)

#guard agrees (state mixed limbs)

#guard agrees (state limbs mixed)

end MLIR.Agave.Avx2
