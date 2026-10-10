module

public import Boringssl.fe_sq2_tt

meta import Boringssl.fe_sq2_tt

namespace MLIR.Boringssl

/-- A 40-byte block holding `b`. -/
private def blk (b : BitVec 320) : MemoryBlock :=
  .ofBytes 40 b

/-- Limbs as the 40 bytes of a field element. -/
private def bytesOf (l : Fin 5 → BitVec 64) : BitVec 320 :=
  l 4 ++ l 3 ++ l 2 ++ l 1 ++ l 0

/-- Three test elements: small, near `2^52`, and mixed. -/
private def xs : List (Fin 5 → BitVec 64) :=
  [fun i => #v[1, 2, 3, 4, 5][i], fun i =>
    #v[0xfffffffffffff, 0x8000000000000, 0x7ffffffffffff, 0xfffffffffffed, 0x1][i], fun i =>
    #v[0x123456789abcd, 0x7edcba9876543, 0x1111111111111, 0x0, 0x7ffffffffffff][i]]

/-- `out` in block 1, the input in block 2; `out`'s limbs after the call, or `none` for UB. -/
private def run (a : Fin 5 → BitVec 64) : Option (Fin 5 → BitVec 64) :=
  let s : GlobalState := ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, blk 0), (⟨2⟩, blk (bytesOf a))]⟩⟩
  match fe_sq2_tt.call (fe_sq2_tt.args (.value ⟨⟨1⟩, 0⟩) (.value ⟨⟨2⟩, 0⟩)) s with
  | .value (_, s') => some (s'.mem.readLimbs ⟨⟨1⟩, 0⟩)
  | _ => none

-- every limb is the spec's
#guard
  xs.all fun a =>
    match run a with
    | some r => (List.finRange 5).all fun k => r k == fe_sq2_tt.spec a k
    | none => false

end MLIR.Boringssl
