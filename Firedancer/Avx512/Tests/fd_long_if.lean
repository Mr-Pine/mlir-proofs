module

public import Firedancer.Avx512.fd_long_if

meta import Firedancer.Avx512.fd_long_if

namespace MLIR.Firedancer.Avx512

private def state : GlobalState :=
  ⟨⟨1⟩, ⟨∅⟩⟩

/-- The returned value if it is `spec c`, else `none`. -/
private def out (c : BitVec 32) : Option (BitVec 64) :=
  match fd_long_if.eval 1 (fd_long_if.args (.value c)) state with
  | .value (some (.cons (.value v) .nil), _) => if v == fd_long_if.spec c then some v else none
  | _ => none

#guard out 0 == some 0

#guard out 1 == some 19

#guard out (-1) == some 19

end MLIR.Firedancer.Avx512
