module

public import Firedancer.R52x5.fd_f25519_reduce

meta import Firedancer.R52x5.fd_f25519_reduce

namespace MLIR.Firedancer.R52x5

open Firedancer.Avx512 (Wwl)

private def out : Pointer :=
  ⟨⟨0⟩, 0⟩

/-- The limbs at `out` if they are those of `fold x` and the counter moved on by one block. -/
private def limbsOut (x : Wwl) : Option (List (BitVec 64)) :=
  let s : GlobalState := ⟨⟨1⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨40, 0⟩)]⟩⟩
  match fd_f25519_reduce.eval 1 (fd_f25519_reduce.args (.value out) (Ty.wrap x)) s with
  | .value (some .nil, s') =>
    let l := (List.range 5).map fun i => s'.mem.readLimbs out (Fin.ofNat 5 i)
    if
        l == (List.range 5).map (fun i => limbs (fold x) (Fin.ofNat 5 i)) &&
          s'.alloc.nextFreeBlock == 2 then
      some l
    else none
  | _ => none

#guard limbsOut #v[1, 2, 3, 4, 5, 6, 7, 8] == some [1, 2, 3, 4, 5]

#guard limbsOut #v[2 ^ 51, 2 ^ 52, 0, 0, 2 ^ 51 + 1, 0, 0, 0] == some [19, 1, 2, 0, 1]

#guard (limbsOut #v[-1, -1, -1, -1, -1, -1, -1, -1]).isSome

end MLIR.Firedancer.R52x5
