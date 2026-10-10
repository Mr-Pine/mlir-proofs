module

public import Firedancer.Ref.fd_f25519_neg

meta import Firedancer.Ref.fd_f25519_neg

namespace MLIR.Firedancer.Ref

private def r : Pointer :=
  ⟨⟨0⟩, 0⟩

private def a : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- Two 40-byte blocks: `r` zeroed, `a` holding `bytes`. -/
private def state (bytes : BitVec 320) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, .ofBytes 40 0), (⟨1⟩, .ofBytes 40 bytes)]⟩⟩

/-- The limbs `1, 2, 3, 4, 5`. -/
private def aBytes : BitVec 320 :=
  0x00000000000000050000000000000004000000000000000300000000000000020000000000000001#320

/-- The returned pointer and `r`'s limbs, or `none` for UB / out of fuel. -/
private def result (p q : ⟦Ty.ptr⟧) : Option (⟦Ty.ptr⟧ × (Fin 5 → BitVec 64)) :=
  match fd_f25519_neg.eval 1 (fd_f25519_neg.args p q) (state aBytes) with
  | .value (some (.cons ret .nil), s') => some (ret, s'.mem.readLimbs r)
  | _ => none

-- `r` is returned, and holds `opp`'s limbs of `a`.
#guard
  match result (.value r) (.value a) with
  | some (ret, l) =>
    ret == .value r &&
      (List.finRange 5).all fun k => l k == fd_f25519_neg.spec ((state aBytes).mem.readLimbs a) k
  | none => false

-- A poison pointer is UB, inside the callee.
#guard (result (.value r) .poison).isNone

end MLIR.Firedancer.Ref
