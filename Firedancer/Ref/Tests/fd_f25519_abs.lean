module

public import Firedancer.Ref.fd_f25519_abs

meta import Firedancer.Ref.fd_f25519_abs

namespace MLIR.Firedancer.Ref

private def r : Pointer :=
  ⟨⟨0⟩, 0⟩

private def a : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- Two 40-byte blocks: `r` zeroed, `a` holding the limbs `l`. -/
private def state (l : BitVec 320) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨40, 0⟩), (⟨1⟩, ⟨40, l⟩)]⟩⟩

/-- The limbs at `q` after `abs q a`, if `q` is returned, they are `spec` of `a`'s limbs, `a` is
unchanged unless it is `q`, and the counter moved on by 28 blocks; else `none`. -/
private def out (l : BitVec 320) (q : Pointer := r) : Option (Fin 5 → BitVec 64) :=
  let s := state l
  match fd_f25519_abs.eval 1 (fd_f25519_abs.args (.value q) (.value a)) s with
  | .value (some (.cons ret .nil), s') =>
    let v := s'.mem.readLimbs q
    if
        ret == .value q &&
          ((List.finRange 5).all fun i => v i == fd_f25519_abs.spec (s.mem.readLimbs a) i) &&
          (q == a || s'.mem.readAt a 320 == l) &&
          s'.alloc.nextFreeBlock == 30 then
      some v
    else none
  | _ => none

/-- The limbs `1, 0, 0, 0, 0` and `2^51 - 20, 2^51 - 1, …`: `1` and `p - 1 = -1`. -/
private def oneBytes : BitVec 320 :=
  1#320

private def mOneBytes : BitVec 320 :=
  0x0007ffffffffffff0007ffffffffffff0007ffffffffffff0007ffffffffffff0007ffffffffffec#320

/-- Equal limbs, as a `Bool`. -/
private def same (x y : Option (Fin 5 → BitVec 64)) : Bool :=
  match x, y with
  | some x, some y => (List.finRange 5).all fun i => x i == y i
  | _, _ => false

-- `1` has sign `1`: `|1| = -1`, the limbs of `2p - 1`, not carried
#guard
  same (out oneBytes)
    (some fun i =>
      #v[0xfffffffffffd9#64, 0xffffffffffffe#64, 0xffffffffffffe#64, 0xffffffffffffe#64,
          0xffffffffffffe#64][i])

-- `-1 = p - 1` is even: kept
#guard
  same (out mOneBytes)
    (some fun i =>
      #v[0x7ffffffffffec#64, 0x7ffffffffffff#64, 0x7ffffffffffff#64, 0x7ffffffffffff#64,
          0x7ffffffffffff#64][i])

-- `2` is even: kept
#guard same (out 2#320) (some fun i => #v[2#64, 0#64, 0#64, 0#64, 0#64][i])

-- in place, `abs(a, a)`: the same limbs
#guard same (out oneBytes (q := a)) (out oneBytes)

#guard same (out 2#320 (q := a)) (out 2#320)

end MLIR.Firedancer.Ref
