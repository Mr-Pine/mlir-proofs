module

public import Firedancer.Ref.fd_f25519_pow22523

meta import Firedancer.Ref.fd_f25519_pow22523

namespace MLIR.Firedancer.Ref

private def r : Pointer :=
  ⟨⟨0⟩, 0⟩

private def z : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- Two 40-byte blocks: `r` zeroed, `z` holding `bytes`. -/
private def state (bytes : BitVec 320) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨40, 0⟩), (⟨1⟩, ⟨40, bytes⟩)]⟩⟩

/-- The limbs `1, 2, 3, 4, 5`. -/
private def zBytes : BitVec 320 :=
  0x00000000000000050000000000000004000000000000000300000000000000020000000000000001#320

/-- The returned pointer, `p`'s limbs and the block count, or `none` for UB / out of fuel. -/
private def result (p q : ⟦Ty.ptr⟧) (at_ : Pointer) :
    Option (⟦Ty.ptr⟧ × (Fin 5 → BitVec 64) × Nat) :=
  match fd_f25519_pow22523.call (fd_f25519_pow22523.args p q) (state zBytes) with
  | .value (.cons ret .nil, s') => some (ret, s'.mem.readLimbs at_, s'.mem.mem.size)
  | _ => none

-- `r` is returned, and the temporaries are gone. The limbs are not compared with `spec` here:
-- its steps are closures, and evaluating the chain re-evaluates them exponentially often.
#guard
  match result (.value r) (.value z) r with
  | some (ret, _, n) => ret == .value r && n == 2
  | none => false

-- `r` may be `z`: the same limbs.
#guard
  match result (.value r) (.value z) r, result (.value z) (.value z) z with
  | some (_, l, _), some (ret, l', _) =>
    ret == .value z && (List.finRange 5).all fun k => l k == l' k
  | _, _ => false

-- A poison pointer is UB.
#guard (result (.value r) .poison r).isNone

end MLIR.Firedancer.Ref
