module

public import MLIR.Run.Tactic
public meta import MLIR.Run.Tactic.Util
public meta import Lean.Elab.Tactic

/-! Proof tactics of the lane proofs. -/

namespace MLIR

public meta section

open Lean Elab Tactic Meta in
/-- `clear_stored`: drop the facts vector stores leave (`m.readAt p w = x`, `m.readVec p = x`,
`Fits m p 512`), once no later step reads the stored vectors. -/
elab "clear_stored" : tactic =>
  withMainContext do
    let mut g ← getMainGoal
    for d in ← getLCtx do
      if d.isImplementationDetail then
        continue
      let ty ← instantiateMVars d.type
      if let some (_, l, _) := ty.eq? then
        if l.isAppOf ``MemoryState.readAt || l.isAppOf `MLIR.MemoryState.readVec then
          g ← g.tryClear d.fvarId
      else if ty.isAppOfArity ``Fits 3 && ty.appArg! == mkNatLit 512 then
        g ← g.tryClear d.fvarId
    replaceMainGoal [g]

open Lean Elab Tactic Meta in
/-- `clear_cells x`: drop the read facts and the 64-bit `Fits` facts of the object at `x` (or at
`x.add k`): the cells a loop stored, once the object is read as a whole. -/
elab "clear_cells " x:ident : tactic =>
  withMainContext do
    let xe ← elabTerm x none
    let base (p : Expr) : Expr := (p.app2? ``Pointer.add).elim p (·.1)
    let mut g ← getMainGoal
    for d in ← getLCtx do
      if d.isImplementationDetail then
        continue
      let ty ← instantiateMVars d.type
      if let some (_, l, _) := ty.eq? then
        if l.isAppOfArity ``MemoryState.readAt 3 && base (l.getArg! 1) == xe then
          g ← g.tryClear d.fvarId
      else if ty.isAppOfArity ``Fits 3 && ty.appArg! == mkNatLit 64 && base (ty.getArg! 1) == xe then
        g ← g.tryClear d.fvarId
    replaceMainGoal [g]

end

end MLIR
