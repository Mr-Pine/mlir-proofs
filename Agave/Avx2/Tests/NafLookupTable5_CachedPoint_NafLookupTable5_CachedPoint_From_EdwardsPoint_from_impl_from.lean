module

public import Agave.Avx2.NafLookupTable5_CachedPoint_NafLookupTable5_CachedPoint_From_EdwardsPoint_from_impl_from

meta import Agave.Avx2.NafLookupTable5_CachedPoint_NafLookupTable5_CachedPoint_From_EdwardsPoint_from_impl_from

namespace MLIR.Agave.Avx2

open NafLookupTable5_CachedPoint_NafLookupTable5_CachedPoint_From_EdwardsPoint_from_impl_from

private def out : Pointer :=
  ⟨⟨1⟩, 0⟩

private def a : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Block 0 free (the null pointer's); `out` a 1280-byte zeroed block, `a` holding `pBytes`. -/
private def state (pBytes : BitVec 1280) : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 1280 0), (⟨2⟩, .ofBytes 160 pBytes)]⟩⟩

/-- Limb `i` is `7 i + 3` times a large odd constant, below `2^52`. -/
private def mixed : BitVec 1280 :=
  BitVec.ofNat 1280
    (∑ i ∈ Finset.range 20, ((7 * i + 3) * 123456789012345 % 2 ^ 52) * 2 ^ (64 * i))

/-- `spec P`'s entries by `Ai`'s recursion, each computed once: the spec's registers are functions,
which compiled code recomputes at every read. -/
private def entries (P : EdwardsPoint) : Array (Vector (Vector (BitVec 32) 8) 5) :=
  let A := Vector.ofFn (Fe2625x4.new P.X P.Y P.Z P.T)
  let A2 := Vector.ofFn (ExtendedPoint_double_impl_double.spec A.get)
  let e0 := Vector.ofFn (CachedPoint_From_ExtendedPoint_from_impl_from.spec A.get)
  (List.range 7).foldl
    (fun acc _ =>
      acc.push
        (Vector.ofFn
          (CachedPoint_From_ExtendedPoint_from_impl_from.spec
            (ExtendedPoint_Add_CachedPoint_add_impl_add.spec A2.get (acc.back!).get))))
    #[e0]

/-- The run agrees with `spec` on `s`. -/
private def agrees (s : GlobalState) : Bool :=
  match
    NafLookupTable5_CachedPoint_NafLookupTable5_CachedPoint_From_EdwardsPoint_from_impl_from.eval 1
      (NafLookupTable5_CachedPoint_NafLookupTable5_CachedPoint_From_EdwardsPoint_from_impl_from.args
        (.value out) (.value a)) s with
  | .value (some .nil, s') =>
    let T := entries (s.mem.readEdwards a)
    s'.mem.readAt out 10240 == naf5Bits fun i => T[i]!.get
  | _ => false

-- one state: the run takes about two minutes
#guard agrees (state mixed)

end MLIR.Agave.Avx2
