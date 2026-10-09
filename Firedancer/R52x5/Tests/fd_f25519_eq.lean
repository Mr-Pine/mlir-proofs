module

public import Firedancer.R52x5.fd_f25519_eq

meta import Firedancer.R52x5.fd_f25519_eq

namespace MLIR.Firedancer.R52x5

private def a : Pointer :=
  ⟨⟨0⟩, 0⟩

private def b : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- Pack eight 64-bit lanes, lane 0 lowest. -/
private def pack (l : List Nat) : BitVec 512 :=
  l.foldr (fun x acc => acc <<< 64 ||| BitVec.ofNat 512 x) 0

/-- Two 64-byte blocks, `a` and `b` holding `ab` and `bb`. -/
private def state (ab bb : BitVec 512) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨64, ab⟩), (⟨1⟩, ⟨64, bb⟩)]⟩⟩

/-- `eq a q`'s result if it is `spec` of the inputs, the inputs are unchanged and the counter
moved on by three blocks; else `none`. -/
private def out (ab bb : BitVec 512) (q : Pointer := b) : Option (BitVec 32) :=
  let s := state ab bb
  match fd_f25519_eq.eval 1 (fd_f25519_eq.args (.value a) (.value q)) s with
  | .value (some (.cons (.value v) .nil), s') =>
    if
        v == fd_f25519_eq.spec (s.mem.readVec a) (s.mem.readVec q) && s'.mem.readAt a 512 == ab &&
          s'.mem.readAt b 512 == bb &&
          s'.alloc.nextFreeBlock == 5 then
      some v
    else none
  | _ => none

-- equal limbs, also through one pointer
#guard out (pack [1, 2, 3, 4, 5]) (pack [1, 2, 3, 4, 5]) == some 1

#guard out (pack [1, 2, 3, 4, 5]) 0 (q := a) == some 1

-- `p` and `0` are one element; `2^51` and `0, 1` too
#guard out (pack [2 ^ 51 - 19, 2 ^ 51 - 1, 2 ^ 51 - 1, 2 ^ 51 - 1, 2 ^ 51 - 1]) 0 == some 1

#guard out (pack [2 ^ 51]) (pack [0, 1]) == some 1

-- different elements
#guard out (pack [1]) 0 == some 0

#guard out (pack [1, 2, 3]) (pack [1, 2, 4]) == some 0

end MLIR.Firedancer.R52x5
