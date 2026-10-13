module

public import Agave.Avx2.NafLookupTable5_CachedPoint_select

meta import Agave.Avx2.NafLookupTable5_CachedPoint_select

namespace MLIR.Agave.Avx2

private def out : Pointer :=
  ⟨⟨1⟩, 0⟩

private def tbl : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Byte `k` of the test table: `k % 251`. -/
private def tblBytes : BitVec 10240 :=
  BitVec.ofNat 10240 (∑ k ∈ Finset.range 1280, (k % 251) * 2 ^ (8 * k))

/-- Block 0 free (the null pointer's); `out` a 160-byte zeroed block, `tbl` the test table. -/
private def state : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 160 0), (⟨2⟩, .ofBytes 1280 tblBytes)]⟩⟩

/-- The run stores entry `x / 2` at `out`. -/
private def agrees (x : Nat) (hx : x / 2 < 8) : Bool :=
  match
    NafLookupTable5_CachedPoint_select.eval 2
      (NafLookupTable5_CachedPoint_select.args (.value out) (.value tbl)
        (.value (BitVec.ofNat 64 x)))
      state with
  | .value (some .nil, s') =>
    (List.finRange 5).all fun k => s'.mem.readFe4x out k == state.mem.readNaf5 tbl ⟨x / 2, hx⟩ k
  | _ => false

#guard agrees 1 (by decide)

#guard agrees 7 (by decide)

#guard agrees 15 (by decide)

end MLIR.Agave.Avx2
