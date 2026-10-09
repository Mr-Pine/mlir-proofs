module

public import Firedancer.Avx512.fd_r43x6_is_nonzero

meta import Firedancer.Avx512.fd_r43x6_is_nonzero

namespace MLIR.Firedancer.Avx512

/-- The result if it is `spec x`, else `none`. -/
private def out (x : Wwl) : Option (BitVec 32) :=
  match fd_r43x6_is_nonzero.eval 1 (fd_r43x6_is_nonzero.args (Ty.wrap x)) ⟨⟨1⟩, ⟨∅⟩⟩ with
  | .value (some (.cons (.value r) .nil), _) =>
    if r == fd_r43x6_is_nonzero.spec x then some r else none
  | _ => none

-- zero, as `0` and as `p`
#guard out #v[0, 0, 0, 0, 0, 0, 0, 0] == some 0

#guard out #v[8796093022189, 8796093022207, 8796093022207, 8796093022207, 8796093022207,
    1099511627775, 0, 0] == some 0

-- signed limbs: `-1 + 2^43`, `-1`, `1`
#guard out #v[-1, 1, 0, 0, 0, 0, 0, 0] == some 1

#guard out #v[-1, 0, 0, 0, 0, 0, 0, 0] == some 1

#guard out #v[1, 0, 0, 0, 0, 0, 0, 0] == some 1

-- `2^43 - 2^43`: zero
#guard out #v[8796093022208, -1, 0, 0, 0, 0, 0, 0] == some 0

end MLIR.Firedancer.Avx512
