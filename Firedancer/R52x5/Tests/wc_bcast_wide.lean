module

public import Firedancer.R52x5.wc_bcast_wide

meta import Firedancer.R52x5.wc_bcast_wide

namespace MLIR.Firedancer.R52x5

/-- The returned vector, or `none` if there is none. -/
private def out (c0 c1 c2 c3 : BitVec 32) : Option ⟦Ty.vec 4 64⟧ :=
  match
    wc_bcast_wide.eval 1 (wc_bcast_wide.args (.value c0) (.value c1) (.value c2) (.value c3))
      ⟨default, default⟩ with
  | .value (some (.cons v .nil), _) => some v
  | _ => none

-- `1` is all ones, `0` zero
#guard out 1#32 0#32 1#32 0#32 == some (Ty.wrap #v[-1, 0, -1, 0])

#guard out 0#32 0#32 0#32 1#32 == some (Ty.wrap (wcBcast 0 0 0 1))

-- `INT_MIN` overflows the negation: its lane is poison
#guard out (BitVec.intMin 32) 0#32 0#32 0#32 == some #v[.poison, .value 0, .value 0, .value 0]

end MLIR.Firedancer.R52x5
