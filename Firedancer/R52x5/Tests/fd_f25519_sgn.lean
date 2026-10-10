module

public import Firedancer.R52x5.fd_f25519_sgn

meta import Firedancer.R52x5.fd_f25519_sgn

namespace MLIR.Firedancer.R52x5

private def a : Pointer :=
  ⟨⟨0⟩, 0⟩

/-- Pack eight 64-bit lanes, lane 0 lowest. -/
private def pack (l : List Nat) : BitVec 512 :=
  l.foldr (fun x acc => acc <<< 64 ||| BitVec.ofNat 512 x) 0

/-- The result if it is `spec` of the element at `a`, `a` is unchanged and the counter
moved on by two blocks; else `none`. -/
private def out (ab : BitVec 512) : Option (BitVec 32) :=
  let s : GlobalState := ⟨⟨1⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, .ofBytes 64 ab)]⟩⟩
  match fd_f25519_sgn.eval 1 (fd_f25519_sgn.args (.value a)) s with
  | .value (some (.cons (.value v) .nil), s') =>
    if
        v == fd_f25519_sgn.spec (s.mem.readVec a) && s'.mem.readAt a 512 == ab &&
          s'.alloc.nextFreeBlock == 3 then
      some v
    else none
  | _ => none

-- zero, `p`, `2p`: even
#guard out 0 == some 0

#guard out (pack [2 ^ 51 - 19, 2 ^ 51 - 1, 2 ^ 51 - 1, 2 ^ 51 - 1, 2 ^ 51 - 1]) == some 0

#guard out (pack [2 ^ 52 - 38, 2 ^ 52 - 2, 2 ^ 52 - 2, 2 ^ 52 - 2, 2 ^ 52 - 2]) == some 0

-- `1`, `p + 1`: odd; `p - 1`, `2^255 - 1` (`18`): even; `p + 3` from limbs above `2^51`: odd
#guard out (pack [1]) == some 1

#guard out (pack [2 ^ 51 - 18, 2 ^ 51 - 1, 2 ^ 51 - 1, 2 ^ 51 - 1, 2 ^ 51 - 1]) == some 1

#guard out (pack [2 ^ 51 - 20, 2 ^ 51 - 1, 2 ^ 51 - 1, 2 ^ 51 - 1, 2 ^ 51 - 1]) == some 0

#guard out (pack [2 ^ 51 - 1, 2 ^ 51 - 1, 2 ^ 51 - 1, 2 ^ 51 - 1, 2 ^ 51 - 1]) == some 0

#guard out (pack [2 ^ 52 - 16, 2 ^ 51 - 2, 2 ^ 51 - 1, 2 ^ 51 - 1, 2 ^ 51 - 1]) == some 1

end MLIR.Firedancer.R52x5
