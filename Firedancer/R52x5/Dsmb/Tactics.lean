module

public import MLIR.Run.Tactic
public meta import Firedancer.R52x5.Common.QuadMem
public meta import MLIR.Run.Tactic.Util
public meta import Lean.Elab.Tactic

/-! Proof tactics of `fd_ed25519_double_scalar_mul_base`. -/

namespace MLIR

public meta section

open Lean Elab Tactic Meta

/-- `name_quad x`: the point the latest `storeQuad5` of an unnamed value in the current state
writes becomes `x`, with `hx : x = …` tagged as a `with x` step's, in the state and the facts. -/
elab "name_quad " x:ident : tactic =>
  withMainContext do
    let (g, goal) ← Tactic.getGoalType
    let S := (← Tactic.getRunBodyFrom goal).state
    let some hS ← Tactic.findEqWithLhs? S m!"`{S} = _`" | throwError "`name_quad`: no `{S} = _`"
    let some (_, _, rhs) := (← instantiateMVars (← hS.getType)).eq? | throwError "no equation"
    let some st :=
      rhs.find? fun e => e.isAppOfArity ``MemoryState.storeQuad5 3 && !(e.getArg! 2).isFVar
      | throwError "`name_quad`: no `storeQuad5` of an unnamed value in{indentExpr rhs}"
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
              #[⟨x.getId.appendBefore "h", fun y => return Tactic.tagNamed (← mkEq y v),
                  ← mkEqRefl v⟩]
    replaceMainGoal [g]

end

end MLIR
