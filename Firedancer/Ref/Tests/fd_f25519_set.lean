module

public import Firedancer.Ref.fd_f25519_set

meta import Firedancer.Ref.fd_f25519_set

namespace LeanMLIR.RIR.Firedancer.Ref

private def dst : Pointer :=
  ⟨⟨0⟩, 0⟩

private def src : Pointer :=
  ⟨⟨1⟩, 0⟩

/-- Two 40-byte blocks: `dst` zeroed, `src` holding `bytes`. -/
private def state (bytes : BitVec 320) : GlobalState :=
  ⟨⟨2⟩, ⟨Std.ExtHashMap.ofList [(⟨0⟩, ⟨40, 0⟩), (⟨1⟩, ⟨40, bytes⟩)]⟩⟩

private def srcBytes : BitVec 320 :=
  0x05050505050505050404040404040404030303030303030302020202020202020101010101010101#320

/-- The returned pointer and the final memory, or `none` for UB / out of fuel. -/
private def out (d s : ⟦Ty.ptr⟧) : Option (PoisonOr Pointer × MemoryState) :=
  match fd_f25519_set.eval 1 (fd_f25519_set.args d s) (state srcBytes) with
  | .value (some (.cons p .nil), s') => some (p, s'.mem)
  | _ => none

-- The five limbs are copied, and `dst` comes back.
#guard
  match out (.value dst) (.value src) with
  | some (p, m) =>
    p == .value dst &&
      (List.finRange 5).all fun k => m.readLimbs dst k == (state srcBytes).mem.readLimbs src k
  | none => false

-- A poison pointer is UB.
#guard (out .poison (.value src)).isNone

end LeanMLIR.RIR.Firedancer.Ref
