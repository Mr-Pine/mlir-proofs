module

public import Firedancer.Avx512.fd_f25519_is_zero

meta import Firedancer.Avx512.fd_f25519_is_zero

namespace MLIR.Firedancer.Avx512

private def a : Pointer :=
  ⟨⟨0⟩, 0⟩

/-- Pack eight 64-bit lanes, lane 0 lowest. -/
private def pack (l : List Nat) : BitVec 512 :=
  l.foldr (fun x acc => acc <<< 64 ||| BitVec.ofNat 512 x) 0

/-- The result if it is `spec` of the lanes, else `none`. -/
private def out (bytes : BitVec 512) : Option (BitVec 32) :=
  let s : GlobalState := ⟨⟨1⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨64, bytes⟩)]⟩⟩
  match fd_f25519_is_zero.eval 1 (fd_f25519_is_zero.args (.value a)) s with
  | .value (some (.cons (.value v) .nil), _) =>
    if v == fd_f25519_is_zero.spec (s.mem.readVec a) then some v else none
  | _ => none

-- zero, and `p`
#guard out 0 == some 1

#guard
  out (pack [8796093022189, 8796093022207, 8796093022207, 8796093022207, 8796093022207,
    1099511627775]) == some 1

-- `1`, `p + 1`, and zero with lane 7 set
#guard out (pack [1]) == some 0

#guard
  out (pack [8796093022190, 8796093022207, 8796093022207, 8796093022207, 8796093022207,
    1099511627775]) == some 0

#guard out (pack [0, 0, 0, 0, 0, 0, 0, 1]) == some 0

end MLIR.Firedancer.Avx512
