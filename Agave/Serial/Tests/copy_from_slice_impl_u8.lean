module

public import Agave.Serial.copy_from_slice_impl_u8

meta import Agave.Serial.copy_from_slice_impl_u8

namespace MLIR.Agave.Serial

private def dst : Pointer :=
  ⟨⟨1⟩, 0⟩

private def src : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Room for 4 bytes at `dst`, the bytes `x` at `src`. -/
private def mem (x : BitVec 32) : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 4 0), (⟨2⟩, .ofBytes 4 x)]⟩⟩

/-- The 4 bytes at `dst` after copying `a` bytes into a `b`-byte slice, or `none` for UB. -/
private def run (x : BitVec 32) (a b : BitVec 64) : Option (BitVec 32) :=
  match
    copy_from_slice_impl_u8.eval 2
      (copy_from_slice_impl_u8.args (.value dst) (.value b) (.value src) (.value a)
        (.value ⟨⟨2⟩, 0⟩))
      (mem x) with
  | .value (some .nil, s') => some (s'.mem.readAt dst 32)
  | _ => none

#guard run 0xdeadbeef 4 4 == some 0xdeadbeef

#guard run 0xdeadbeef 2 2 == some 0xbeef

-- unequal lengths panic
#guard run 0xdeadbeef 2 4 == none

end MLIR.Agave.Serial
