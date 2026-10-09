module

public import Firedancer.R52x5.fd_f25519_neg

meta import Firedancer.R52x5.fd_f25519_neg

namespace MLIR.Firedancer.R52x5

open Firedancer.Avx512 (Wwl)

private def r : Pointer :=
  ⟨⟨0⟩, 0⟩

private def a : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- Pack eight 64-bit lanes, lane 0 lowest. -/
private def pack (l : List Nat) : BitVec 512 :=
  l.foldr (fun x acc => acc <<< 64 ||| BitVec.ofNat 512 x) 0

/-- The element `Σ lane_i * 2^(51 i)` over lanes `0 … 4`, mod `p`. -/
private def value (x : Wwl) : Nat :=
  (List.range 5).foldl (fun acc i => acc + x[i]!.toNat * 2 ^ (51 * i)) 0 % (2 ^ 255 - 19)

/-- Two 64-byte blocks: `r` zeroed, `a` holding `ab`. -/
private def state (ab : BitVec 512) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨64, 0⟩), (⟨1⟩, ⟨64, ab⟩)]⟩⟩

/-- `q` is returned and holds `spec a`: `-a` mod `p`, lanes 0-4 below `2^52`, 5-7 zero. -/
private def check (ab : BitVec 512) (q : Pointer := r) : Bool :=
  let s := state ab
  match fd_f25519_neg.eval 1 (fd_f25519_neg.args (.value q) (.value a)) s with
  | .value (some (.cons ret .nil), s') =>
    let z := s'.mem.readVec q
    let x := s.mem.readVec a
    ret == .value q && z == fd_f25519_neg.spec x &&
      value z == ((2 ^ 255 - 19) - value x) % (2 ^ 255 - 19) &&
      (List.range 5).all (fun i => z[i]!.toNat < 2 ^ 52) &&
      z[5] == 0 &&
      z[6] == 0 &&
      z[7] == 0
  | _ => false

#guard check 0

#guard check (pack [1, 2, 3, 4, 5])

-- in place
#guard check (pack [1, 2, 3, 4, 5]) (q := a)

#guard check (pack [2 ^ 52 - 1, 2 ^ 52 - 1, 2 ^ 52 - 1, 2 ^ 52 - 1, 2 ^ 52 - 1])

-- a poison pointer is UB
#guard
  match fd_f25519_neg.eval 1 (fd_f25519_neg.args (.value r) .poison) (state 0) with
  | .value _ => false
  | _ => true

end MLIR.Firedancer.R52x5
