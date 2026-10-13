module

public import Agave.Avx2.FieldElement2625x4_reduce64_impl_reduce64

meta import Agave.Avx2.FieldElement2625x4_reduce64_impl_reduce64

namespace MLIR.Agave.Avx2

private def out : Pointer :=
  ⟨⟨1⟩, 0⟩

private def z : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Block 0 free (the null pointer's); `out` a 160-byte zeroed block, `z` holding `zBytes`. -/
private def state (zBytes : BitVec 2560) : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 160 0), (⟨2⟩, .ofBytes 320 zBytes)]⟩⟩

/-- Every lane `2^64 - 1`. -/
private def ones : BitVec 2560 :=
  BitVec.allOnes 2560

/-- Every lane `0x0123456789abcdef`. -/
private def pattern : BitVec 2560 :=
  BitVec.ofNat 2560 (∑ i ∈ Finset.range 40, 0x0123456789abcdef * 2 ^ (64 * i))

/-- Lane `k` of `u64x4` `i` is `2^(26 + i + k)`: carries out of every limb. -/
private def carries : BitVec 2560 :=
  BitVec.ofNat 2560
    (∑ i ∈ Finset.range 10, ∑ k ∈ Finset.range 4, 2 ^ (26 + i + k) * 2 ^ (64 * (4 * i + k)))

/-- The run agrees with `spec` on `s`. -/
private def agrees (s : GlobalState) : Bool :=
  match
    FieldElement2625x4_reduce64_impl_reduce64.eval 1
      (FieldElement2625x4_reduce64_impl_reduce64.args (.value out) (.value z)) s with
  | .value (some .nil, s') =>
    (List.finRange 5).all fun k =>
      s'.mem.readFe4x out k == FieldElement2625x4_reduce64_impl_reduce64.spec (s.mem.readZ10 z) k
  | _ => false

#guard agrees (state ones)

#guard agrees (state pattern)

#guard agrees (state carries)

end MLIR.Agave.Avx2
