module

public import Firedancer.Ref.fd_f25519_if

meta import Firedancer.Ref.fd_f25519_if

namespace LeanMLIR.RIR.Firedancer.Ref

private def r : Pointer :=
  ⟨⟨0⟩, 0⟩

private def a0 : Pointer :=
  ⟨⟨1⟩, 0⟩

private def a1 : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Three 40-byte blocks: `r` zeroed, `a0` and `a1` holding `b0` and `b1`. -/
private def state (b0 b1 : BitVec 320) : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨40, 0⟩), (⟨1⟩, ⟨40, b0⟩), (⟨2⟩, ⟨40, b1⟩)]⟩⟩

/-- The limbs `1, 2, 3, 4, 5` and `10, 20, 30, 40, 50`. -/
private def bytes0 : BitVec 320 :=
  0x00000000000000050000000000000004000000000000000300000000000000020000000000000001#320

private def bytes1 : BitVec 320 :=
  0x00000000000000320000000000000028000000000000001e0000000000000014000000000000000a#320

/-- The returned pointer, the limbs at `at_`, the block counter and the number of blocks after the
run, or `none` for UB. -/
private def result (p : ⟦Ty.ptr⟧) (cond : ⟦Ty.bv 32⟧) (q q' : ⟦Ty.ptr⟧) (at_ : Pointer) :
    Option (⟦Ty.ptr⟧ × (Fin 5 → BitVec 64) × Nat × Nat) :=
  match fd_f25519_if.call (fd_f25519_if.args p cond q q') (state bytes0 bytes1) with
  | .value (.cons ret .nil, s') =>
    some (ret, s'.mem.readLimbs at_, s'.alloc.nextFreeBlock, s'.mem.mem.size)
  | _ => none

/-- `r` is returned and holds `spec cond a0 a1`; `selectznz`'s temporaries are gone, counted. -/
private def selects (cond : BitVec 32) : Bool :=
  let s := state bytes0 bytes1
  match result (.value r) (.value cond) (.value a0) (.value a1) r with
  | some (ret, l, n, k) =>
    ret == .value r && n == 8 && k == 3 &&
      (List.finRange 5).all fun i =>
        l i == fd_f25519_if.spec cond (s.mem.readLimbs a0) (s.mem.readLimbs a1) i
  | none => false

#guard selects 0#32

#guard selects 1#32

#guard selects 256#32

-- `cond = 1` selects `a0`; `cond = 0` and `cond = 256` (low byte `0`) select `a1`
#guard
  match result (.value r) (.value 1#32) (.value a0) (.value a1) r,
    result (.value r) (.value 0#32) (.value a0) (.value a1) r,
    result (.value r) (.value 256#32) (.value a0) (.value a1) r with
  | some (_, l, _), some (_, l', _), some (_, l'', _) =>
    let s := state bytes0 bytes1
    (List.finRange 5).all fun i =>
      l i == s.mem.readLimbs a0 i && l' i == s.mem.readLimbs a1 i && l'' i == s.mem.readLimbs a1 i
  | _, _, _ => false

-- `r` may be `a0`: the same limbs.
#guard
  match result (.value r) (.value 0#32) (.value a0) (.value a1) r,
    result (.value a0) (.value 0#32) (.value a0) (.value a1) a0 with
  | some (_, l, _), some (ret, l', _) =>
    ret == .value a0 && (List.finRange 5).all fun i => l i == l' i
  | _, _ => false

-- A poison pointer, or a poison condition, is UB.
#guard (result (.value r) (.value 1#32) (.value a0) .poison r).isNone

#guard (result (.value r) .poison (.value a0) (.value a1) r).isNone

end LeanMLIR.RIR.Firedancer.Ref
