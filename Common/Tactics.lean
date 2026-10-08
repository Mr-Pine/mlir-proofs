module

public import SSA.Projects.RIR.Run.Tactic
public meta import Common.Limbs
public meta import SSA.Projects.RIR.Run.Tactic.Util
public meta import Lean.Elab.Tactic

/-! Proof tactics over limb objects. -/

namespace LeanMLIR.RIR

public meta section

open Lean Elab Tactic Meta in
/-- `clear_reads`: drop the read facts (`m.readLimbs p = x`, `m.readAt p w = x`), so `subst_vars`
unfolds named values by their own equations, not by a read of them. -/
elab "clear_reads" : tactic =>
  withMainContext do
    let mut g ← getMainGoal
    for d in ← getLCtx do
      let some (_, l, _) := (← instantiateMVars d.type).eq? | continue
      if l.isAppOf ``MemoryState.readLimbs || l.isAppOf ``MemoryState.readAt then
        g ← g.tryClear d.fvarId
    replaceMainGoal [g]

/-- `limbs_fit x`: the slot `x`'s limbs fit (`hx_limbs`), from its block's `Fits` and offset, which
are dropped. -/
macro "limbs_fit " x:ident : tactic => do
  let n := x.getId.toString
  let fits := Lean.mkIdent (.mkSimple s!"h{n}_fits")
  let off := Lean.mkIdent (.mkSimple s!"h{n}_off")
  let limbs := Lean.mkIdent (.mkSimple s!"h{n}_limbs")
  `(tactic| (have $limbs := MemoryState.LimbsFit.of_fits $fits $off; clear $fits $off))

open Lean Elab Tactic Meta in
/-- `name_limbs x`: the limbs the latest `storeLimbs` of the current state writes become `x`, with
`hx : x = …`, in the state and the facts, so later states and reads mention `x` instead of the whole
computation. -/
elab "name_limbs " x:ident : tactic =>
  withMainContext do
    let (g, goal) ← Tactic.getGoalType
    -- inside a block, or at a block's start (after a loop)
    let S ←
      try
        pure (← Tactic.getRunBodyFrom goal).state
      catch _ =>
        pure (← Tactic.getFuncRunFromGoal goal).state
    -- the state's definition: `hS : S = …`, or the state term itself (after a loop)
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
      rhs.find? fun e => e.isAppOfArity ``MemoryState.storeLimbs 3 && !(e.getArg! 2).isFVar
      | throwError "`name_limbs`: no `storeLimbs` of an unnamed value in{indentExpr rhs}"
    let v := st.getArg! 2
    -- everywhere it occurs: the read facts too, so later values are built from `x`
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

end LeanMLIR.RIR
