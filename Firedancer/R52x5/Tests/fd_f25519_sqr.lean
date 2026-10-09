module

public import Firedancer.R52x5.fd_f25519_sqr
public import Firedancer.Ref.fd_f25519_sqr

meta import Firedancer.R52x5.fd_f25519_sqr
meta import Firedancer.Ref.fd_f25519_sqr

namespace MLIR.Firedancer.R52x5

open Firedancer.Avx512 (Wwl)

private def r : Pointer :=
  ⟨⟨0⟩, 0⟩

private def a : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- Pack eight 64-bit lanes, lane 0 lowest. -/
private def pack (l : List Nat) : BitVec 512 :=
  l.foldr (fun x acc => acc <<< 64 ||| BitVec.ofNat 512 x) 0

/-- The lanes of `pack l`. -/
private def lanes (l : List Nat) : Wwl :=
  Vector.ofFn fun i => (pack l).extractLsb' (64 * i) 64

/-- The element `Σ l_i * 2^(51 i)` of five limbs, mod `p`. -/
private def value (l : Fin 5 → BitVec 64) : Nat :=
  (List.finRange 5).foldl (fun acc i => acc + (l i).toNat * 2 ^ (51 * i.val)) 0 % (2 ^ 255 - 19)

/-- Two 64-byte blocks: `r` zeroed, `a` holding `ab`. -/
private def state (ab : BitVec 512) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨64, 0⟩), (⟨1⟩, ⟨64, ab⟩)]⟩⟩

/-- `r` is returned and holds `spec a`. -/
private def runs (ab : BitVec 512) (q : Pointer := a) : Bool :=
  let s := state ab
  match fd_f25519_sqr.eval 1 (fd_f25519_sqr.args (.value r) (.value q)) s with
  | .value (some (.cons ret .nil), s') =>
    ret == .value r && s'.mem.readVec r == fd_f25519_sqr.spec (s.mem.readVec q)
  | _ => false

/-- `spec x` has Ref's `fd_f25519_sqr`'s field value, the square mod `p`, lanes 0-4 below `2^52`
and 5-7 zero. -/
private def agrees (x : Wwl) : Bool :=
  let z := fd_f25519_sqr.spec x
  value (limbs z) == value (Ref.fd_f25519_sqr.spec (limbs x)) &&
    value (limbs z) == value (limbs x) * value (limbs x) % (2 ^ 255 - 19) &&
    (List.finRange 5).all (fun i => (limbs z i).toNat < 2 ^ 52) &&
    z[5] == 0 &&
    z[6] == 0 &&
    z[7] == 0

private def max52 : List Nat :=
  [2 ^ 52 - 1, 2 ^ 52 - 1, 2 ^ 52 - 1, 2 ^ 52 - 1, 2 ^ 52 - 1]

private def mixed : List Nat :=
  [0x8d3a6f0c21b45, 0x1f00ab3c9e271, 0xfffffffffffff, 0x0000000000013, 0x7a5c3e9b1d2f4]

#guard runs (pack [1, 2, 3, 4, 5])

#guard runs (pack max52)

-- lanes 5-7 of the input are not assumed zero
#guard runs (pack (mixed ++ [1, 2, 3]))

-- `r` aliasing `a`
#guard runs (pack mixed) (q := r)

#guard agrees (lanes [1, 2, 3, 4, 5])

#guard agrees (lanes max52)

#guard agrees (lanes mixed)

-- a poison pointer is UB
#guard
  match fd_f25519_sqr.eval 1 (fd_f25519_sqr.args (.value r) .poison) (state 0) with
  | .value _ => false
  | _ => true

end MLIR.Firedancer.R52x5
