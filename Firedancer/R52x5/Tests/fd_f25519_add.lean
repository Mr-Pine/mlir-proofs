module

public import Firedancer.R52x5.fd_f25519_add

meta import Firedancer.R52x5.fd_f25519_add

namespace MLIR.Firedancer.R52x5

open Firedancer.Avx512 (Wwl)

private def r : Pointer :=
  ⟨⟨0⟩, 0⟩

private def a : Pointer :=
  ⟨⟨1⟩, 0⟩

private def b : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Pack eight 64-bit lanes, lane 0 lowest. -/
private def pack (l : List Nat) : BitVec 512 :=
  l.foldr (fun x acc => acc <<< 64 ||| BitVec.ofNat 512 x) 0

/-- The element `Σ lane_i * 2^(51 i)` over lanes `0 … 4`, mod `p`. -/
private def value (x : Wwl) : Nat :=
  (List.range 5).foldl (fun acc i => acc + x[i]!.toNat * 2 ^ (51 * i)) 0 % (2 ^ 255 - 19)

/-- Three 64-byte blocks: `r` zeroed, `a` and `b` holding `ab` and `bb`. -/
private def state (ab bb : BitVec 512) : GlobalState :=
  ⟨⟨3⟩,
    ⟨Std.ExtHashMap.ofList [(⟨0⟩, .ofBytes 64 0), (⟨1⟩, .ofBytes 64 ab), (⟨2⟩, .ofBytes 64 bb)]⟩⟩

/-- `r` is returned and holds `spec a b`: `a + b` mod `p`, lanes 0-4 below `2^52`, 5-7 zero. -/
private def check (ab bb : BitVec 512) (q : Pointer := b) : Bool :=
  let s := state ab bb
  match fd_f25519_add.eval 1 (fd_f25519_add.args (.value r) (.value a) (.value q)) s with
  | .value (some (.cons ret .nil), s') =>
    let z := s'.mem.readVec r
    let (x, y) := (s.mem.readVec a, s.mem.readVec q)
    ret == .value r && z == fd_f25519_add.spec x y &&
      value z == (value x + value y) % (2 ^ 255 - 19) &&
      (List.range 5).all (fun i => z[i]!.toNat < 2 ^ 52) &&
      z[5] == 0 &&
      z[6] == 0 &&
      z[7] == 0
  | _ => false

#guard check (pack [1, 2, 3, 4, 5]) (pack [6, 7, 8, 9, 10])

#guard check (pack [1, 2, 3, 4, 5]) 0 (q := a)

-- full 52-bit limbs: every limb carries
#guard
  check (pack [2 ^ 52 - 1, 2 ^ 52 - 1, 2 ^ 52 - 1, 2 ^ 52 - 1, 2 ^ 52 - 1])
    (pack [2 ^ 52 - 1, 2 ^ 52 - 1, 2 ^ 52 - 1, 2 ^ 52 - 1, 2 ^ 52 - 1])

-- a poison pointer is UB
#guard
  match fd_f25519_add.eval 1 (fd_f25519_add.args (.value r) .poison (.value b)) (state 0 0) with
  | .value _ => false
  | _ => true

end MLIR.Firedancer.R52x5
