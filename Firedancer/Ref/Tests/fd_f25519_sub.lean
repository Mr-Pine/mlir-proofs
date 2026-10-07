module

public import Firedancer.Ref.fd_f25519_sub

meta import Firedancer.Ref.fd_f25519_sub

namespace LeanMLIR.RIR.Firedancer.Ref

private def r : Pointer :=
  ⟨⟨0⟩, 0⟩

private def a : Pointer :=
  ⟨⟨1⟩, 0⟩

private def b : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Three 40-byte blocks: `r` zeroed, `a` and `b` holding `ab` and `bb`. -/
private def state (ab bb : BitVec 320) : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨40, 0⟩), (⟨1⟩, ⟨40, ab⟩), (⟨2⟩, ⟨40, bb⟩)]⟩⟩

/-- Every limb `2^52 - 1`, so every limb carries, and the limbs `1, 2, 3, 4, 5`. -/
private def aBytes : BitVec 320 :=
  0x000fffffffffffff000fffffffffffff000fffffffffffff000fffffffffffff000fffffffffffff#320

private def bBytes : BitVec 320 :=
  0x00000000000000050000000000000004000000000000000300000000000000020000000000000001#320

-- `r` is returned, and holds `carry (sub a b)`
#guard
  match
    fd_f25519_sub.eval 1 (fd_f25519_sub.args (.value r) (.value a) (.value b))
      (state aBytes bBytes) with
  | .value (some (.cons ret .nil), s') =>
    let s := state aBytes bBytes
    ret == .value r &&
      (List.finRange 5).all fun k =>
        s'.mem.readLimbs r k == fd_f25519_sub.spec (s.mem.readLimbs a) (s.mem.readLimbs b) k
  | _ => false

end LeanMLIR.RIR.Firedancer.Ref
