module

public import Firedancer.Avx512.fd_f25519_eq

meta import Firedancer.Avx512.fd_f25519_eq

namespace MLIR.Firedancer.Avx512

private def a : Pointer :=
  ⟨⟨0⟩, 0⟩

private def b : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- Pack eight 64-bit lanes, lane 0 lowest. -/
private def pack (l : List Nat) : BitVec 512 :=
  l.foldr (fun x acc => acc <<< 64 ||| BitVec.ofNat 512 x) 0

/-- Two 64-byte blocks, `a` and `b` holding `ab` and `bb`. -/
private def state (ab bb : BitVec 512) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, .ofBytes 64 ab), (⟨1⟩, .ofBytes 64 bb)]⟩⟩

/-- `eq a q`'s result if it is `spec` of the inputs, the inputs are unchanged and the counter
moved on by one block; else `none`. -/
private def out (ab bb : BitVec 512) (q : Pointer := b) : Option (BitVec 32) :=
  let s := state ab bb
  match fd_f25519_eq.call (fd_f25519_eq.args (.value a) (.value q)) s with
  | .value (.cons (.value v) .nil, s') =>
    if
        v == fd_f25519_eq.spec (s.mem.readVec a) (s.mem.readVec q) && s'.mem.readAt a 512 == ab &&
          s'.mem.readAt b 512 == bb &&
          s'.alloc.nextFreeBlock == 3 then
      some v
    else none
  | _ => none

-- equal lanes, also through one pointer
#guard out (pack [1, 2, 3, 4, 5, 6]) (pack [1, 2, 3, 4, 5, 6]) == some 1

#guard out (pack [1, 2, 3, 4, 5, 6]) 0 (q := a) == some 1

-- `p` and `0` are the same element; `2^43` and `0, 1` too
#guard
  out
      (pack
        [8796093022189, 8796093022207, 8796093022207, 8796093022207, 8796093022207, 1099511627775])
      0 ==
    some 1

#guard out (pack [8796093022208]) (pack [0, 1]) == some 1

-- different elements
#guard out (pack [1]) 0 == some 0

#guard out (pack [1, 2, 3]) (pack [1, 2, 4]) == some 0

end MLIR.Firedancer.Avx512
