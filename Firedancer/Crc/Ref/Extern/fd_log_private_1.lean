module

public import MLIR.Run.Tactic

/-!
`fd_log_private_1( level, now, file, line, func, msg )` (`fd_log.c`, not lifted) writes a log
line. A `Func` of its signature whose registers, blocks and body are axioms; its `call_eq`, an
axiom, says it returns, the state unchanged: the logger's buffers and output are outside the model.
-/

namespace MLIR.Firedancer.Crc.Ref

@[expose] public section

namespace fd_log_private_1

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

end fd_log_private_1

open fd_log_private_1 in
@[reducible] noncomputable def fd_log_private_1 : Func :=
  { Γ, tRets := [], n, blockTys, blockParams, hhasBlock := hn, hentry, blocks }

noncomputable def fd_log_private_1.args (level : ⟦.bv 32⟧) (now : ⟦.bv 64⟧) (file : ⟦.ptr⟧)
    (line : ⟦.bv 32⟧) (func : ⟦.ptr⟧) (msg : ⟦.ptr⟧) :
    Vals fd_log_private_1.Γ.args :=
  .cons level (.cons now (.cons file (.cons line (.cons func (.cons msg .nil)))))

/-- It returns, the state unchanged. -/
axiom fd_log_private_1.call_eq (level : BitVec 32) (now : BitVec 64) (file : Pointer)
    (line : BitVec 32) (func msg : Pointer) (s : GlobalState) (hwf : s.WF) :
    fd_log_private_1.call
        (fd_log_private_1.args (.value level) (.value now) (.value file) (.value line) (.value func)
          (.value msg)) s =
      .value (.nil, s)

end

end MLIR.Firedancer.Crc.Ref
