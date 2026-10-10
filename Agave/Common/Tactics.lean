module

public import MLIR.Run.Tactic
public meta import Agave.Common.Point
public meta import MLIR.Run.Tactic.Util
public meta import Lean.Elab.Tactic

/-! Proof tactics shared by the Agave proofs. -/

namespace MLIR

public meta section

/-- The point stores `name_point` looks for. -/
def Agave.pointStores : List Lean.Name :=
  [``MemoryState.storeEdwards, ``MemoryState.storeProjective, ``MemoryState.storeCompleted,
    ``MemoryState.storeNiels]

open Lean Elab Tactic Meta in
/-- `name_point x`: the point the latest `storeEdwards`, `storeProjective`, `storeCompleted` or
`storeNiels` of the current state writes becomes `x`, with `hx : x = …`, in the state and the facts,
so later states and reads mention `x` instead of the whole computation. -/
elab "name_point " x:ident : tactic =>
  withMainContext do
    let (g, goal) ← Tactic.getGoalType
    let S ←
      try
        pure (← Tactic.getRunBodyFrom goal).state
      catch _ =>
        pure (← Tactic.getFuncRunFromGoal goal).state
    let hS? ←
      if S.isFVar then
        Tactic.findEqWithLhs? S m!"`{S} = _`"
      else
        pure none
    let rhs ←
      match hS? with
      | some hS =>
        do
          let some (_, _, rhs) := (← instantiateMVars (← hS.getType)).eq? | throwError "no equation"
          pure rhs
      | none =>
        pure S
    -- `find?` is pre-order: the outermost, i.e. latest, store
    let some st :=
      rhs.find? fun e => Agave.pointStores.any (e.isAppOfArity · 3) && !(e.getArg! 2).isFVar
      | throwError "`name_point`: no point store of an unnamed value in{indentExpr rhs}"
    let v := st.getArg! 2
    let (_, g) ←
      g.withContext do
          let hyps ←
            (← getLCtx).foldlM (init := #[]) fun hs d => do
                if d.isImplementationDetail then
                  return hs
                return if ((← instantiateMVars d.type).find? (· == v)).isSome then hs.push d.fvarId
                  else hs
          Tactic.generalizeOpaque g (hyps := hyps) v x.getId
              #[⟨x.getId.appendBefore "h", (mkEq · v), ← mkEqRefl v⟩]
    replaceMainGoal [g]

end

end MLIR
