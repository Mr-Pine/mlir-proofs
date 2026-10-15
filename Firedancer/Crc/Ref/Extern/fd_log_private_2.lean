module

public import MLIR.Run.Tactic

/-!
`fd_log_private_2( level, now, file, line, func, msg )` (`fd_log.c`, not lifted) writes a log
line and exits the process (`FD_LOG_ERR` and worse): it never returns. A `Func` of its signature
whose registers, blocks and body are axioms, with no `call_eq`: a path through it proves nothing.
-/

namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

namespace fd_log_private_2

/-- The value registers' types. -/
axiom vals : List Ty

/-- The registers: the arguments, then `vals`. -/
noncomputable abbrev Γ : Ctx :=
  ⟨vals.length, [.bv 32, .bv 64, .ptr, .bv 32, .ptr, .ptr], vals, rfl, 0, 0⟩

/-- The block count. -/
axiom n : Nat

axiom hn : 0 < n

axiom blockTys : Fin n → List Ty

axiom hentry : blockTys ⟨0, hn⟩ = []

axiom blockParams : (k : Fin n) → Dsts Γ (blockTys k)

axiom blocks : Fin n → BasicBlock Γ [] blockTys

end fd_log_private_2

open fd_log_private_2 in
@[reducible] noncomputable def fd_log_private_2 : Func :=
  { Γ, tRets := [], n, blockTys, blockParams, hhasBlock := hn, hentry, blocks }

noncomputable def fd_log_private_2.args (level : ⟦.bv 32⟧) (now : ⟦.bv 64⟧) (file : ⟦.ptr⟧)
    (line : ⟦.bv 32⟧) (func : ⟦.ptr⟧) (msg : ⟦.ptr⟧) :
    Vals fd_log_private_2.Γ.args :=
  .cons level (.cons now (.cons file (.cons line (.cons func (.cons msg .nil)))))

end

end MLIR.Firedancer.Crc.Ref
