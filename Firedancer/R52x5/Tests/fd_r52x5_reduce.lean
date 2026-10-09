module

public import Firedancer.R52x5.fd_r52x5_reduce

meta import Firedancer.R52x5.fd_r52x5_reduce

namespace MLIR.Firedancer.R52x5

private def x : Pointer :=
  ⟨⟨0⟩, 0⟩

/-- Pack five 64-bit limbs, limb 0 lowest. -/
private def pack (l : List Nat) : BitVec 320 :=
  l.foldr (fun v acc => acc <<< 64 ||| BitVec.ofNat 320 v) 0

/-- The limbs at `x` if they are `spec` of those before, else `none`. -/
private def out (bytes : BitVec 320) : Option (List Nat) :=
  let s : GlobalState := ⟨⟨1⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨40, bytes⟩)]⟩⟩
  match fd_r52x5_reduce.eval 1 (fd_r52x5_reduce.args (.value x)) s with
  | .value (some .nil, s') =>
    let l := s'.mem.readLimbs x
    if
        (List.range 5).all fun i =>
          l (Fin.ofNat 5 i) == fd_r52x5_reduce.spec (s.mem.readLimbs x) (Fin.ofNat 5 i) then
      some ((List.range 5).map fun i => (l (Fin.ofNat 5 i)).toNat)
    else none
  | _ => none

/-- The output limbs are canonical and of the input's value mod `p`. -/
private def check (l : List Nat) : Bool :=
  match out (pack l) with
  | some o =>
    let n := (List.range 5).foldl (fun acc i => acc + l[i]! * 2 ^ (51 * i)) 0
    let m := (List.range 5).foldl (fun acc i => acc + o[i]! * 2 ^ (51 * i)) 0
    o.all (· < 2 ^ 51) && m < 2 ^ 255 - 19 && m == n % (2 ^ 255 - 19)
  | none => false

-- `p`, `p + 1`, `2^255 - 1`
#guard
  out (pack [2 ^ 51 - 19, 2 ^ 51 - 1, 2 ^ 51 - 1, 2 ^ 51 - 1, 2 ^ 51 - 1]) == some [0, 0, 0, 0, 0]

#guard
  out (pack [2 ^ 51 - 18, 2 ^ 51 - 1, 2 ^ 51 - 1, 2 ^ 51 - 1, 2 ^ 51 - 1]) == some [1, 0, 0, 0, 0]

#guard
  out (pack [2 ^ 51 - 1, 2 ^ 51 - 1, 2 ^ 51 - 1, 2 ^ 51 - 1, 2 ^ 51 - 1]) == some [18, 0, 0, 0, 0]

#guard check [5, 4, 3, 2, 1]

#guard check [2 ^ 51 - 20, 2 ^ 51 - 1, 2 ^ 51 - 1, 2 ^ 51 - 1, 2 ^ 51 - 1]

end MLIR.Firedancer.R52x5
