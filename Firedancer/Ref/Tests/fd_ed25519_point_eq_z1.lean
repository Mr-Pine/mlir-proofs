module

public import Firedancer.Ref.fd_ed25519_point_eq_z1

meta import Firedancer.Ref.fd_ed25519_point_eq_z1

namespace LeanMLIR.RIR.Firedancer.Ref

private def a : Pointer :=
  ⟨⟨0⟩, 0⟩

private def b : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- Two 160-byte blocks, `a` and `b` holding `ab` and `bb`. -/
private def state (ab bb : BitVec 1280) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨160, ab⟩), (⟨1⟩, ⟨160, bb⟩)]⟩⟩

/-- `eq_z1 a q`'s result if it is `spec` of the points, the points are unchanged and the counter
moved on by four blocks; else `none`. -/
private def out (ab bb : BitVec 1280) (q : Pointer := b) : Option (BitVec 32) :=
  let s := state ab bb
  match fd_ed25519_point_eq_z1.eval 1 (fd_ed25519_point_eq_z1.args (.value a) (.value q)) s with
  | .value (some (.cons (.value v) .nil), s') =>
    if
        v == fd_ed25519_point_eq_z1.spec (s.mem.readPoint a) (s.mem.readPoint q) &&
          s'.mem.readAt a 1280 == ab &&
          s'.mem.readAt b 1280 == bb &&
          s'.alloc.nextFreeBlock == 6 then
      some v
    else none
  | _ => none

/-- The point with limbs `x, y, 0, z` in `X, Y, T, Z`. -/
private def point (x y z : Nat) : BitVec 1280 :=
  BitVec.ofNat 1280 (x + y * 2 ^ 320 + z * 2 ^ 960)

-- `(10 : 14 : 2)` is `(5 : 7 : 1)`, also as one point with `Z = 1`
#guard out (point 10 14 2) (point 5 7 1) == some 1#32

#guard out (point 5 7 1) 0#1280 (q := a) == some 1#32

-- `X` or `Y` differs
#guard out (point 11 14 2) (point 5 7 1) == some 0#32

#guard out (point 10 15 2) (point 5 7 1) == some 0#32

end LeanMLIR.RIR.Firedancer.Ref
