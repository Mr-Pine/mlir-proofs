module

public import Firedancer.R52x5.wwl_st

meta import Firedancer.R52x5.wwl_st

namespace MLIR.Firedancer.R52x5

private def p : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- One 64-byte block of `0xaa` bytes. -/
private def state : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, .ofBytes 64 ((0xaa#8).replicate 64))]⟩⟩

private def x : Firedancer.Avx512.Wwl :=
  #v[1, 2, 3, 4, 5, 6, 7, 0x8000000000000000]

-- the lanes stored lowest first, as `storeVec`
#guard
  match wwl_st.eval 1 (wwl_st.args (.value p) (Ty.wrap x)) state with
  | .value (some .nil, s) =>
    s.mem.readVec p == x && s.mem.readAt p 512 == (state.mem.storeVec p x).readAt p 512 &&
      s.mem.readAt p 64 == 1#64
  | _ => false

-- past the block's end: UB
#guard
  match wwl_st.eval 1 (wwl_st.args (.value ⟨⟨1⟩, 8⟩) (Ty.wrap x)) state with
  | .value _ => false
  | _ => true

end MLIR.Firedancer.R52x5
