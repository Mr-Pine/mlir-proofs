module

public import MLIR.Run.Tactic

/-!
`fd_log_wallclock()` (`fd_log.c`, not lifted) reads the wall clock. A `Func` of its signature
whose registers, blocks and body are axioms; its `call_eq`, an axiom, says it returns some time,
the state unchanged.
-/

namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

namespace fd_log_wallclock

/-- The value registers' types. -/
axiom vals : List Ty

/-- The registers: the arguments, then `vals`. -/
noncomputable abbrev Γ : Ctx :=
  ⟨vals.length, [], vals, rfl, 0, 0⟩

/-- The block count. -/
axiom n : Nat

axiom hn : 0 < n

axiom blockTys : Fin n → List Ty

axiom hentry : blockTys ⟨0, hn⟩ = []

axiom blockParams : (k : Fin n) → Dsts Γ (blockTys k)

axiom blocks : Fin n → BasicBlock Γ [.bv 64] blockTys

end fd_log_wallclock

open fd_log_wallclock in
@[reducible] noncomputable def fd_log_wallclock : Func :=
  { Γ, tRets := [.bv 64], n, blockTys, blockParams, hhasBlock := hn, hentry, blocks }

/-- It returns some time, the state unchanged. -/
axiom fd_log_wallclock.call_eq (s : GlobalState) (hwf : s.WF) :
    ∃ t : BitVec 64, fd_log_wallclock.call .nil s = .value (.cons (.value t) .nil, s)

end

end MLIR.Firedancer.Crc.Ref
