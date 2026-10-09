module

public import Firedancer.Avx512.fd_int_if

meta import Firedancer.Avx512.fd_int_if

namespace MLIR.Firedancer.Avx512

private def state : GlobalState :=
  ⟨⟨1⟩, ⟨∅⟩⟩

/-- The returned value if it is `spec c f`, else `none`. -/
private def out (c f : BitVec 32) : Option (BitVec 32) :=
  match fd_int_if.eval 1 (fd_int_if.args (.value c) (.value f)) state with
  | .value (some (.cons (.value v) .nil), _) => if v == fd_int_if.spec c f then some v else none
  | _ => none

#guard out 0 1 == some 1

#guard out 0 0 == some 0

#guard out 5 1 == some (-1)

#guard out (-1) 0 == some (-1)

end MLIR.Firedancer.Avx512
