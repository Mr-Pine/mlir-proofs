module

public import MLIR.Run.Tactic

/-!
`fd_log_private_0( fmt, ... )` (`fd_log.c`, not lifted) formats a log message into a thread-local
buffer and returns it. Only its calls passing `fmt` alone are taken. A `Func` of its signature
whose registers, blocks and body are axioms; its `call_eq`, an axiom, says it returns some pointer
and leaves the state alone: the logger's buffers and output are outside the model.
-/

namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

namespace fd_log_private_0

/-- The value registers' types. -/
axiom vals : List Ty

/-- The registers: the arguments, then `vals`. -/
noncomputable abbrev Γ : Ctx :=
  ⟨vals.length, [.ptr], vals, rfl, 0, 0⟩

/-- The block count. -/
axiom n : Nat

axiom hn : 0 < n

axiom blockTys : Fin n → List Ty

axiom hentry : blockTys ⟨0, hn⟩ = []

axiom blockParams : (k : Fin n) → Dsts Γ (blockTys k)

axiom blocks : Fin n → BasicBlock Γ [.ptr] blockTys

end fd_log_private_0

open fd_log_private_0 in
@[reducible] noncomputable def fd_log_private_0 : Func :=
  { Γ, tRets := [.ptr], n, blockTys, blockParams, hhasBlock := hn, hentry, blocks }

noncomputable def fd_log_private_0.args (fmt : ⟦.ptr⟧) :
    Vals fd_log_private_0.Γ.args :=
  .cons fmt .nil

/-- It returns some pointer, the state unchanged. -/
axiom fd_log_private_0.call_eq (fmt : Pointer) (s : GlobalState) (hwf : s.WF) :
    ∃ p : Pointer,
      fd_log_private_0.call (fd_log_private_0.args (.value fmt)) s =
        .value (.cons (.value p) .nil, s)

end

end MLIR.Firedancer.Crc.Ref
