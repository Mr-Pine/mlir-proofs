module

public import Firedancer.Avx512.wv_ld

meta import Firedancer.Avx512.wv_ld

namespace MLIR.Firedancer.Avx512

private def p : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- One 32-byte block holding the lanes `1, 2, 3, 4`. -/
private def state : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList
    [(⟨1⟩, ⟨32, 0x0000000000000004000000000000000300000000000000020000000000000001#256⟩)]⟩⟩

-- the lanes, lowest first, and `readWv` agrees
#guard match wv_ld.eval 1 (wv_ld.args (.value p)) state with
  | .value (some (.cons v .nil), _) =>
    v == Ty.wrap (t := .vec 4 64) #v[1, 2, 3, 4] && v == Ty.wrap (state.mem.readWv p)
  | _ => false

-- a poison pointer is UB
#guard match wv_ld.eval 1 (wv_ld.args .poison) state with
  | .value _ => false
  | _ => true

end MLIR.Firedancer.Avx512
