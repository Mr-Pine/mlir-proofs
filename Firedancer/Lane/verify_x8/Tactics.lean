module

public import MLIR.Run.Tactic
public import Firedancer.Lane.Common.Mem
meta import MLIR.Run.Tactic.Util
meta import Lean.Elab.Tactic

/-! Tactics for `verify_x8`'s stages. -/

namespace MLIR.Firedancer.Lane.VerifyX8

set_option hygiene false in
/-- `frame_ops`: `FrameOps n m m'` for `m'` built from `m` by stores and lifetime markers into
slots. -/
macro "frame_ops" : tactic =>
  `(tactic|
    repeat
      first
      | refine FrameOps.storePtr ?_ (by simp [GlobalState.slot])
      | refine FrameOps.storeLanePoint ?_ (by simp [GlobalState.slot])
      | refine FrameOps.lifetimeStart ?_ (by simp [GlobalState.slot])
      | refine FrameOps.lifetimeEnd ?_ (by simp [GlobalState.slot])
      | exact FrameOps.refl _ _)

meta section

open Lean Meta in
/-- The conjuncts of `pf : ty` (through reducible abbreviations), with their proofs. -/
partial def readConjuncts (pf ty : Expr) (acc : Array (Expr × Expr)) :
    MetaM (Array (Expr × Expr)) := do
  match_expr ← whnfR ty with
  | And a b =>
    readConjuncts (mkApp3 (mkConst ``And.right) a b pf) b
        (← readConjuncts (mkApp3 (mkConst ``And.left) a b pf) a acc)
  | _ =>
    return acc.push (pf, ty)

open Lean Elab Tactic Meta in
/-- `split_reads h…`: each conjunction `h` (an `E ⊨ […]`, also behind an abbreviation) as one fact
per read, so the steps seal the env past them. -/
elab "split_reads" hs:(ppSpace colGt ident)+ : tactic =>
  for h in hs do
    withMainContext do
        let d ← getLocalDeclFromUserName h.getId
        let parts ← readConjuncts d.toExpr (← instantiateMVars d.type) #[]
        let (_, g) ←
          (← getMainGoal).assertHypotheses
              (parts.mapIdx fun i (pf, ty) =>
                { userName := h.getId.appendIndexAfter i, type := ty, value := pf })
        replaceMainGoal [← g.clear d.fvarId]

open Lean Elab Tactic Meta in
/-- `name_point x`: the point the latest `storeLanePoint` of the current state writes becomes `x`,
with `hx : x = …`, in the state and the facts; `hx` stays folded, as a `with x`'s. -/
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
    let some st :=
      rhs.find? fun e => e.isAppOfArity ``MemoryState.storeLanePoint 3 && !(e.getArg! 2).isFVar
      | throwError "`name_point`: no `storeLanePoint` of an unnamed value in{indentExpr rhs}"
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

open Lean Elab Tactic Meta in
/-- `grab_ptr h : p`: the latest fact `m.loadPtr p = _` (`p` up to reducible unfolding) becomes
`h`. -/
elab "grab_ptr " h:ident " : " p:term : tactic =>
  withMainContext do
    let pe ← instantiateMVars (← elabTerm p (some (mkConst ``Pointer)))
    let mut found : Option FVarId := none
    for d in ← getLCtx do
      if d.isImplementationDetail then
        continue
      let some (_, l, _) := (← instantiateMVars d.type).eq? | continue
      if l.isAppOfArity ``MemoryState.loadPtr 2 then
        if ← withReducible (isDefEq l.appArg! pe) then
          found := some d.fvarId
    let some fv := found | throwError "`grab_ptr`: no `loadPtr` fact at{indentExpr pe}"
    replaceMainGoal [(← (← getMainGoal).rename fv h.getId)]

open Lean Elab Tactic Meta in
/-- `grab h : t`: the latest hypothesis whose type is `t` up to reducible unfolding (`t` may have
holes) becomes `h`. -/
elab "grab " h:ident " : " t:term : tactic =>
  withMainContext do
    let te ← instantiateMVars (← elabTerm t (some (.sort .zero)) (mayPostpone := true))
    let mut found : Option FVarId := none
    for d in ← getLCtx do
      if d.isImplementationDetail then
        continue
      let ty ← instantiateMVars d.type
      let st ← saveState
      let ok ← withReducible (isDefEq ty te)
      st.restore
      if ok then
        found := some d.fvarId
    let some fv := found | throwError "`grab`: no hypothesis{indentExpr te}"
    replaceMainGoal [(← (← getMainGoal).rename fv h.getId)]

end

end MLIR.Firedancer.Lane.VerifyX8
