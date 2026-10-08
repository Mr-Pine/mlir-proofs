module

public import Firedancer.Avx512.fd_f25519_sub

meta import Firedancer.Avx512.fd_f25519_sub

namespace LeanMLIR.RIR.Firedancer.Avx512

private def r : Pointer :=
  ⟨⟨0⟩, 0⟩

private def a : Pointer :=
  ⟨⟨1⟩, 0⟩

private def b : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Pack eight 64-bit lanes, lane 0 lowest. -/
private def pack (l : List Nat) : BitVec 512 :=
  l.foldr (fun x acc => acc <<< 64 ||| BitVec.ofNat 512 x) 0

/-- The field element of r43x6 lanes: `Σ lane_i * 2^(43 i)` over lanes `0 … 5`, mod `p`. -/
private def value (x : Wwl) : Nat :=
  (List.range 6).foldl (fun acc i => acc + x[i]!.toNat * 2 ^ (43 * i)) 0 % (2 ^ 255 - 19)

/-- Three 64-byte blocks: `r` zeroed, `a` and `b` holding `ab` and `bb`. -/
private def state (ab bb : BitVec 512) : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨64, 0⟩), (⟨1⟩, ⟨64, ab⟩), (⟨2⟩, ⟨64, bb⟩)]⟩⟩

/-- `r` is returned and holds `spec a b`, `a - b` mod `p`, with lanes 6 and 7 zero. -/
private def check (ab bb : BitVec 512) : Bool :=
  let s := state ab bb
  match fd_f25519_sub.eval 1 (fd_f25519_sub.args (.value r) (.value a) (.value b)) s with
  | .value (some (.cons ret .nil), s') =>
    let out := s'.mem.readVec r
    let (x, y) := (s.mem.readVec a, s.mem.readVec b)
    ret == .value r && out == fd_f25519_sub.spec x y && out[6] == 0 && out[7] == 0 &&
      value out == (value x + (2 ^ 255 - 19) - value y) % (2 ^ 255 - 19)
  | _ => false

-- small limbs, `a > b` and `a < b`
#guard check (pack [7, 6, 5, 4, 3, 2]) (pack [1, 2, 3, 4, 5, 6])

#guard check (pack [1, 0, 0, 0, 0, 0]) (pack [2, 0, 0, 0, 0, 0])

-- full 43-bit limbs (40 bits on top) on both sides
#guard
  check (pack [2 ^ 43 - 1, 2 ^ 43 - 1, 2 ^ 43 - 1, 2 ^ 43 - 1, 2 ^ 43 - 1, 2 ^ 40 - 1])
    (pack [2 ^ 43 - 1, 2 ^ 43 - 1, 2 ^ 43 - 1, 2 ^ 43 - 1, 2 ^ 43 - 1, 2 ^ 40 - 1])

#guard
  check (pack [0, 0, 0, 0, 0, 0])
    (pack [2 ^ 43 - 1, 2 ^ 43 - 1, 2 ^ 43 - 1, 2 ^ 43 - 1, 2 ^ 43 - 1, 2 ^ 40 - 1])

-- a poison pointer is UB
#guard
  match fd_f25519_sub.eval 1 (fd_f25519_sub.args (.value r) .poison (.value b)) (state 0 0) with
  | .value _ => false
  | _ => true

end LeanMLIR.RIR.Firedancer.Avx512
