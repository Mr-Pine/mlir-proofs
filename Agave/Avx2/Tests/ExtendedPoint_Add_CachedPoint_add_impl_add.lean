module

public import Agave.Avx2.ExtendedPoint_Add_CachedPoint_add_impl_add

meta import Agave.Avx2.ExtendedPoint_Add_CachedPoint_add_impl_add

namespace MLIR.Agave.Avx2

private def out : Pointer :=
  ⟨⟨1⟩, 0⟩

private def p : Pointer :=
  ⟨⟨2⟩, 0⟩

private def q : Pointer :=
  ⟨⟨3⟩, 0⟩

/-- Block 0 free (the null pointer's); `out` a 160-byte zeroed block, `p` and `q` holding `pBytes`
and `qBytes`. -/
private def state (pBytes qBytes : BitVec 1280) : GlobalState :=
  ⟨⟨4⟩,
    ⟨Std.ExtHashMap.ofList
        [(⟨1⟩, .ofBytes 160 0), (⟨2⟩, .ofBytes 160 pBytes), (⟨3⟩, .ofBytes 160 qBytes)]⟩⟩

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
    ExtendedPoint_Add_CachedPoint_add_impl_add.eval 1
      (ExtendedPoint_Add_CachedPoint_add_impl_add.args (.value out) (.value p) (.value q)) s with
  | .value (some .nil, s') =>
    (List.finRange 5).all fun k =>
      s'.mem.readFe4x out k ==
        ExtendedPoint_Add_CachedPoint_add_impl_add.spec (s.mem.readFe4x p) (s.mem.readFe4x q) k
  | _ => false

#guard agrees (state limbs limbs)

#guard agrees (state mixed limbs)

#guard agrees (state limbs mixed)

end MLIR.Agave.Avx2
