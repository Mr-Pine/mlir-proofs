module

public import Firedancer.Ref.fiat_25519_selectznz

meta import Firedancer.Ref.fiat_25519_selectznz

namespace MLIR.Firedancer.Ref

private def out : Pointer :=
  ⟨⟨0⟩, 0⟩

private def x : Pointer :=
  ⟨⟨1⟩, 0⟩

private def y : Pointer :=
  ⟨⟨2⟩, 0⟩

/-- Three 40-byte blocks: `out` zeroed, `x` and `y` holding `xb` and `yb`. -/
private def state (xb yb : BitVec 320) : GlobalState :=
  ⟨⟨3⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨40, 0⟩), (⟨1⟩, ⟨40, xb⟩), (⟨2⟩, ⟨40, yb⟩)]⟩⟩

/-- The limbs `1, 2, 3, 4, 5` and `10, 20, 30, 40, 50`. -/
private def xBytes : BitVec 320 :=
  0x00000000000000050000000000000004000000000000000300000000000000020000000000000001#320

private def yBytes : BitVec 320 :=
  0x00000000000000320000000000000028000000000000001e0000000000000014000000000000000a#320

/-- The limbs at `at_`, the block counter and the number of blocks after the run, or `none` for
UB. -/
private def result (o : ⟦Ty.ptr⟧) (c : ⟦Ty.bv 8⟧) (i j : ⟦Ty.ptr⟧) (at_ : Pointer) :
    Option ((Fin 5 → BitVec 64) × Nat × Nat) :=
  match fiat_25519_selectznz.call (fiat_25519_selectznz.args o c i j) (state xBytes yBytes) with
  | .value (.nil, s') => some (s'.mem.readLimbs at_, s'.alloc.nextFreeBlock, s'.mem.mem.size)
  | _ => none

/-- `out` holds `spec c x y`, and the five temporaries are gone, counted. -/
private def selects (c : BitVec 8) : Bool :=
  let s := state xBytes yBytes
  match result (.value out) (.value c) (.value x) (.value y) out with
  | some (l, n, k) =>
    n == 8 && k == 3 &&
      (List.finRange 5).all fun i =>
        l i == fiat_25519_selectznz.spec c (s.mem.readLimbs x) (s.mem.readLimbs y) i
  | none => false

#guard selects 0#8

#guard selects 1#8

#guard selects 7#8

-- `c = 0` selects `x`, else `y`
#guard
  match result (.value out) (.value 0#8) (.value x) (.value y) out,
    result (.value out) (.value 1#8) (.value x) (.value y) out with
  | some (l, _), some (l', _) =>
    let s := state xBytes yBytes
    (List.finRange 5).all fun i => l i == s.mem.readLimbs x i && l' i == s.mem.readLimbs y i
  | _, _ => false

-- `out` may be `x`: the same limbs.
#guard
  match result (.value out) (.value 1#8) (.value x) (.value y) out,
    result (.value x) (.value 1#8) (.value x) (.value y) x with
  | some (l, _), some (l', _) => (List.finRange 5).all fun i => l i == l' i
  | _, _ => false

-- A poison pointer, or a poison condition, is UB.
#guard (result (.value out) (.value 0#8) .poison (.value y) out).isNone

#guard (result (.value out) .poison (.value x) (.value y) out).isNone

end MLIR.Firedancer.Ref
