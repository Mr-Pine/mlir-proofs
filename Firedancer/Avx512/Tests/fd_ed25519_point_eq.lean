module

public import Firedancer.Avx512.fd_ed25519_point_eq

meta import Firedancer.Avx512.fd_ed25519_point_eq

namespace MLIR.Firedancer.Avx512

private def a : Pointer :=
  ⟨⟨1⟩, 0⟩

private def b : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- 192 bytes, lane `i` of the 24 holding a 43-bit pattern from `seed`. -/
private def bytes (seed : Nat) : BitVec 1536 :=
  BitVec.ofNat 1536
    ((List.range 24).foldl (fun acc i => acc + (seed + 99999999989 * i) * 2 ^ (64 * i)) 0)

/-- `a` and `b` holding the patterns from `sa` and `sb`. -/
private def state (sa sb : Nat) : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨1⟩, ⟨192, bytes sa⟩), (⟨2⟩, ⟨192, bytes sb⟩)]⟩⟩

/-- The return value, or `none` for UB / out of fuel. -/
private def run (sa sb : Nat) : Option (BitVec 32) :=
  match fd_ed25519_point_eq.eval 5 (fd_ed25519_point_eq.args (.value a) (.value b))
      (state sa sb) with
  | .value (some (.cons (.value r) .nil), _) => some r
  | _ => none

private def specOf (sa sb : Nat) : BitVec 32 :=
  fd_ed25519_point_eq.spec ((state sa sb).mem.readQuad a) ((state sa sb).mem.readQuad b)

-- a point equals itself
#guard run 4000000000000 4000000000000 == some 1

#guard specOf 4000000000000 4000000000000 == 1

-- two unrelated patterns are different points
#guard run 4000000000000 1234567890123 == some 0

#guard specOf 4000000000000 1234567890123 == 0

end MLIR.Firedancer.Avx512
