module

public import Firedancer.R52x5.fd_f25519_canonical_limbs

meta import Firedancer.R52x5.fd_f25519_canonical_limbs

namespace MLIR.Firedancer.R52x5

private def h : Pointer :=
  ⟨⟨0⟩, 0⟩

private def a : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- Pack eight 64-bit lanes, lane 0 lowest. -/
private def pack (l : List Nat) : BitVec 512 :=
  l.foldr (fun x acc => acc <<< 64 ||| BitVec.ofNat 512 x) 0

/-- The limbs at `h` if they are `spec` of the element at `a`, `a` is unchanged and the counter
moved on by one block. -/
private def out (ab : BitVec 512) : Option (List Nat) :=
  let s : GlobalState := ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨40, 0⟩), (⟨1⟩, ⟨64, ab⟩)]⟩⟩
  match
    fd_f25519_canonical_limbs.eval 1 (fd_f25519_canonical_limbs.args (.value h) (.value a)) s with
  | .value (some .nil, s') =>
    let l := (List.range 5).map fun i => s'.mem.readLimbs h (Fin.ofNat 5 i)
    if
        l ==
            (List.range 5).map
              (fun i => fd_f25519_canonical_limbs.spec (s.mem.readVec a) (Fin.ofNat 5 i)) &&
          s'.mem.readAt a 512 == ab &&
          s'.alloc.nextFreeBlock == 3 then
      some (l.map (·.toNat))
    else none
  | _ => none

/-- The output limbs are canonical, of `a`'s value mod `p`. -/
private def check (l : List Nat) : Bool :=
  match out (pack l) with
  | some o =>
    let n := (List.range 5).foldl (fun acc i => acc + l[i]! * 2 ^ (51 * i)) 0
    let m := (List.range 5).foldl (fun acc i => acc + o[i]! * 2 ^ (51 * i)) 0
    o.all (· < 2 ^ 51) && m < 2 ^ 255 - 19 && m == n % (2 ^ 255 - 19)
  | none => false

-- `p` and `2p`
#guard
  out (pack [2 ^ 51 - 19, 2 ^ 51 - 1, 2 ^ 51 - 1, 2 ^ 51 - 1, 2 ^ 51 - 1]) == some [0, 0, 0, 0, 0]

#guard
  out (pack [2 ^ 52 - 38, 2 ^ 52 - 2, 2 ^ 52 - 2, 2 ^ 52 - 2, 2 ^ 52 - 2]) == some [0, 0, 0, 0, 0]

#guard check [1, 2, 3, 4, 5]

#guard check [2 ^ 52 - 1, 2 ^ 52 - 1, 2 ^ 52 - 1, 2 ^ 52 - 1, 2 ^ 52 - 1]

#guard check [2 ^ 51 - 18, 2 ^ 51 - 1, 2 ^ 51 - 1, 2 ^ 51 - 1, 2 ^ 51 - 1]

end MLIR.Firedancer.R52x5
