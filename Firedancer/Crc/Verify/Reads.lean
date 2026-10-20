module

public import MLIR.Run.Tactic
public meta import MLIR.Run.Tactic.Loop
public meta import MLIR.Run.Tactic.Env
public meta import MLIR.Run.Tactic.Util
public meta import MLIR.Run.Tactic.Step.Pattern
public meta import Lean.Elab.Tactic

/-! Register reads through write chains, proved by `Env`'s read/write lemmas: the kernel checks
one lemma application per write passed, not an evaluation of the chain. -/

namespace MLIR

open Lean Elab Tactic Meta

public meta section

/-- `i ≠ j` for `Fin n` literals, by `decide` with the instance given: no instance search. -/
def finNeProof (n i j : Expr) : Expr :=
  let eq := mkApp3 (mkConst ``Eq [1]) (mkApp (mkConst ``Fin) n) i j
  let inst := mkApp2 (mkConst ``instDecidableNot) eq (mkApp3 (mkConst ``instDecidableEqFin) n i j)
  mkApp3 (mkConst ``of_decide_eq_true) (mkNot eq) inst
    (mkApp2 (mkConst ``Eq.refl [1]) (mkConst ``Bool) (mkConst ``Bool.true))

/-- An argument read `E.read (.arg i h)` through `E`'s writes (they leave the arguments) from the
fact `hA : root.args = A`, the root's or its `hE`'s: `A`'s value, by `congrArg` on `hA`. -/
partial def argRead (lhs : Expr) : MetaM (Option (Expr × Expr)) := do
  let_expr Env.read Γ t env reg := lhs | return none
  let mut root := env
  while root.isAppOfArity ``Env.write 5 do
    root := root.getArg! 2
  let argsOf (e : Expr) := mkApp2 (mkConst ``Env.args) Γ e
  if let some hA ← Tactic.findLocalEq? (argsOf root) then
    let vals := mkApp2 (mkConst ``Env.vals) Γ root
    let motive ←
      withLocalDeclD `a (← inferType (argsOf root)) fun a => do
          mkLambdaFVars #[a] (mkApp4 (mkConst ``Env.read) Γ t (mkApp3 (mkConst ``Env.mk) Γ a vals) reg)
    let v ← whnfD (motive.beta #[hA.rhs])
    let pf ← mkCongrArg motive hA.decl.toExpr
    return some (v, mkExpectedPropHint pf (← mkEq lhs v))
  unless root.isFVar do
    return none
  let some hE ← Tactic.findLocalEq? root | return none
  let some (v, pf) ← argRead (mkApp4 (mkConst ``Env.read) Γ t hE.rhs reg) | return none
  let readOf ←
    withLocalDeclD `x (← inferType root) fun x => do
        mkLambdaFVars #[x] (mkApp4 (mkConst ``Env.read) Γ t x reg)
  let lhsRoot := mkApp4 (mkConst ``Env.read) Γ t root reg
  let skip := mkExpectedPropHint (← mkEqRefl lhsRoot) (← mkEq lhs lhsRoot)
  return some (v, ← mkEqTrans skip (← mkEqTrans (← mkCongrArg readOf hE.decl.toExpr) pf))

/-- `E.read r = v` through `E`'s write chain by lemmas: `Env.read_write_ne'` past each write to
another register (its `≠` by `decide`) and `Env.read_write_same` at `r`'s own; a local base
through its `hE : base = chain`, else a read fact. The value and the proof. -/
partial def lemmaRead (lhs : Expr) : MetaM (Option (Expr × Expr)) := do
  let_expr Env.read Γ t' env reg := lhs | return none
  if reg.isAppOfArity ``Reg.arg 4 then
    return ← argRead lhs
  let_expr Reg.val _ _ j _ := reg | return none
  let some jn ← Tactic.finNLit? j | return none
  if env.isAppOfArity ``Env.write 5 then
    let a := env.getArg! 1
    let env' := env.getArg! 2
    let v := env.getArg! 4
    let_expr Dst.mk _ _ i h := env.getArg! 3 | return none
    let some i_n ← Tactic.finNLit? i | return none
    if i_n == jn then
      unless ← withReducible (isDefEq a t') do
        return none
      return some (v, mkApp7 (mkConst ``Env.read_write_same) Γ a env' i h (reg.getArg! 3) v)
    let hij := finNeProof (mkApp (mkConst ``Ctx.n) Γ) i j
    let step := mkApp10 (mkConst ``Env.read_write_ne') Γ i j a h v t' (reg.getArg! 3) env' hij
    let some (val, pf) ← lemmaRead (mkApp4 (mkConst ``Env.read) Γ t' env' reg) | return none
    return some (val, ← mkEqTrans step pf)
  unless env.isFVar do
    return none
  let some hE ← Tactic.findLocalEq? env |
    -- a root without a definition: its own read, else a read fact about it
    return (← Tactic.readFact? env jn lhs).getD (lhs, ← mkEqRefl lhs)
  let some (val, pf) ← lemmaRead (mkApp4 (mkConst ``Env.read) Γ t' hE.rhs reg) | return none
  let readOf ←
    withLocalDeclD `x (← inferType env) fun x => do
        mkLambdaFVars #[x] (mkApp4 (mkConst ``Env.read) Γ t' x reg)
  return some (val, ← mkEqTrans (← mkCongrArg readOf hE.decl.toExpr) pf)

/-- Close `E.read r = v`, or `E ⊨ [r := v, …]`, by `lemmaRead`; a read it cannot, as
`env_reads` does. -/
partial def closeLemmaReads (g : MVarId) : TacticM (List MVarId) := do
  let ty ← g.withContext do whnfR (← instantiateMVars (← g.getType))
  if let some (ga, gb) ← Tactic.splitAnd? g ty then
    return (← closeLemmaReads ga) ++ (← closeLemmaReads gb)
  g.withContext do
    if let some (_, lhs, rhs) := ty.eq? then
      if let some (val, pf) ← lemmaRead lhs then
        if ← withReducible (isDefEq val rhs) then
          g.assign (mkExpectedPropHint pf ty)
          return []
    closeReads g

/-- `lemma_reads` closes `E.read r = v`, or `E ⊨ [r := v, …]`, as `env_reads` does, with each read
through the writes proved by `Env.read_write_ne'` / `Env.read_write_same`. -/
elab "lemma_reads" : tactic => do
  replaceMainGoal (← closeLemmaReads (← getMainGoal))

/-- `closePatternRead` with the read through the writes proved by `lemmaRead` when it can. -/
def closePatternReadL (g : MVarId) : TacticM Unit :=
  g.withContext do
    let ty ← instantiateMVars (← g.getType)
    let some (_, lhs, rhs) := ty.eq? | throwError "not a read"
    let reg ←
      Meta.transform (lhs.getArg! 3) (post := fun e => do
          match_expr e with
          | Dst.i _ _ d =>
            let_expr Dst.mk _ _ i _ := d | return .continue
            return .done i
          | Dst.h _ _ d =>
            let_expr Dst.mk _ _ _ h := d | return .continue
            return .done h
          | _ =>
            return .continue)
    let lhs' := mkApp4 (mkConst ``Env.read) (lhs.getArg! 0) (lhs.getArg! 1) (lhs.getArg! 2) reg
    if let some (v, pf) ← lemmaRead lhs' then
      if ← withReducible (isDefEq v rhs) then
        g.assign (mkExpectedPropHint pf ty)
        return
      -- a value through locals' definitions (`v = t.P4`), unfolded
      let (v', pf') ← unfoldLocals v pf
      if ← withReducible (isDefEq v' rhs) then
        g.assign (mkExpectedPropHint pf' ty)
        return
      -- an argument's value, reduced past its `Ty.wrap`
      if reg.isAppOf ``Reg.arg then
        if ← withDefault (isDefEq v rhs) then
          g.assign (mkExpectedPropHint pf ty)
          return
    closePatternRead g

/-- `closePremise` with `closePatternReadL`. -/
partial def closePremiseL (g : MVarId) : TacticM Unit := do
  let ty ← instantiateMVars (← g.getType)
  let ty' ← whnfR ty
  let (g, ty) ←
    if ty' != ty && (ty'.find? (·.isAppOfArity ``Env.read 4)).isSome then
      pure (← g.replaceTargetDefEq ty', ty')
    else
      pure (g, ty)
  if let some (ga, gb)← Tactic.splitAnd? g ty then
    closePremiseL ga
    closePremiseL gb
  else if Tactic.isEnvReadEq ty then
    closePatternReadL g
  else
    closeSide g

def stepPatternLAt (stx : Syntax) : TacticM Unit := do
  -- a concrete block's body fact, as a step's: the pattern's instructions read off it
  withMainContext do
      let (g, goal) ← getGoalType
      replaceMainGoal [(← withBodyFact g (← getRunBodyFrom goal)).1]
  -- the state as `S` with `hS`, to seal what the pattern stores
  Tactic.ensureStateEq
  withMainContext do
      let (args, names) := StepArgs.parsePattern stx[3]
      let g ← getMainGoal
      let inState := (← getRunBodyFrom (← getGoalType).2).state
      -- a constant with all its arguments open, so its implicit registers are ours to split
      let thm := stepLemmaTerm stx[2]
      let lem ←
        if thm.raw.isIdent then
          mkConstWithFreshMVarLevels (← realizeGlobalConstNoOverloadWithInfo thm)
        else
          instantiateMVars (← Term.elabTerm thm none)
      let (ms, _, concl) ← forallMetaTelescopeReducing (← inferType lem)
      -- registers as `⟨?i, ?h⟩`, so the body's `.val k _` fixes them
      -- (assigned, not unified: structure eta would solve `?x =?= ⟨?i, ?h⟩` by `?i := ?x.i`);
      -- with explicit arguments, the elaborator's open implicits too
      let mut typeProofs := #[]
      for m in (← getMVars lem).map mkMVar ++ ms do
        let ty ← instantiateMVars (← inferType m)
        if ty.isAppOfArity ``Dst 2 && !(← m.mvarId!.isAssigned) then
          let dst := mkApp2 (mkConst ``Dst.mk) (ty.getArg! 0) (ty.getArg! 1)
          let .forallE _ iTy _ _ ← whnf (← inferType dst) | throwError "`Dst.mk`: no index"
          let i ← mkFreshExprMVar iTy
          let .forallE _ hTy _ _ ←
            whnf (← inferType (mkApp dst i)) | throwError "`Dst.mk`: no proof"
          let h ← mkFreshExprMVar hTy
          typeProofs := typeProofs.push h.mvarId!
          m.mvarId!.assign (mkApp2 dst i h)
      unless ← isDefEq concl (← instantiateMVars (← g.getType)) do
        throwError "step_pattern: the conclusion of{indentExpr lem}\ndoes not match the goal"
      -- the body first: it fixes the registers and arguments the other premises mention
      let mut bodyFact? := none
      let mut instrs := #[]
      for m in ms do
        let some (_, lhs, rhs) := (← instantiateMVars (← m.mvarId!.getType)).eq? | continue
        if lhs.isAppOf ``List.drop then
          if let some (h, xs)← literalPatternFact? lhs rhs then
            m.mvarId!.assign h
            instrs := xs
            bodyFact? := some (h, true)
          else if let some (h, xs)← concreteBodyFact? lhs rhs then
            m.mvarId!.assign h
            instrs := xs
          else if ← withDefault (isDefEq lhs rhs) then
            m.mvarId!.assign (← mkEqRefl lhs)
          else if let some h← bodyFactAs? lhs rhs then
            -- an abstract block (a pattern lemma's proof): through its body fact
            m.mvarId!.assign h
            bodyFact? := some (h, false)
          else
            throwError "step_pattern: the body at the position is not the pattern of{indentExpr lem}"
      let mut cont? := none
      for m in ms do
        let mv := m.mvarId!
        if ← mv.isAssigned then
          continue
        let ty ← instantiateMVars (← mv.getType)
        unless ← isProp ty do
          continue
        if ← isContinuation ty then
          cont? := some mv
          continue
        closePremiseL mv
      -- a register's type proof: unification skips proofs, so none got assigned; the body's own
      -- when known (deciding `Γ.ty i` unfolds `Γ` to register `i`, too deep for a long function)
      let proofs ← regTypeProofs instrs
      for h in typeProofs do
        unless ← h.isAssigned do
          let hTy ← instantiateMVars (← h.getType)
          let some (_, l, r) := hTy.eq? | continue
          if let some k← Tactic.finNLit? l.appArg! then
            if let some pf := proofs[k]? then
              if ← withReducible (isDefEq (← inferType pf) hTy) then
                h.assign pf
                continue
          unless ← withDefault (isDefEq l r) do
            throwError "step_pattern: register type mismatch{indentExpr (← h.getType)}"
          h.assign (← mkEqRefl l)
      let some cont := cont? | throwError "step_pattern: no continuation premise"
      g.assign (← instantiateMVars (mkAppN lem ms))
      -- the lemma's names: a kept fact is referred to by them
      let (bound, main) ← cont.introNP (getIntrosSize (← instantiateMVars (← cont.getType)))
      let main ← Tactic.reduceIndex main
      -- the values the continuation binds (`∀ A' E', …`): named by `with`, in order
      let (args, main) ← main.withContext do
          let results ← bound.filterM fun x => do
              let ty ← instantiateMVars (← x.getType)
              if ← isProp ty then
                return false
              let heads := [``Ty.denote, ``PoisonOr, ``GlobalState, ``Env, ``MemoryState]
              return !heads.any (ty.isAppOf ·)
          if names.isEmpty || results.isEmpty || stx[3][0][0][1].getNumArgs > 0 then
            return (args, main)
          unless names.size ≤ results.size do
            throwError "step_pattern: {names.size} names for the {results.size} values the \
              continuation binds ({← results.mapM (·.getUserName)})"
          let mut main := main
          for x in results, n in names do
            main ← main.rename x n.getId
          -- named, so folded: their equations among the binders (`a = …`) tagged as `with`'s
          for h in bound do
            let ty ← instantiateMVars (← h.getType)
            let some (_, .fvar y, _) := ty.eq? | continue
            if (results.extract 0 names.size).contains y then
              main ← main.replaceLocalDeclDefEq h (Tactic.tagNamed ty)
          return ({ args with value := .auto, hyp := .auto, tag := false }, main)
      -- its facts: an anonymous one named after the value it equates (`ha` for `a = …`), else
      -- after its predicate (`htablePhase`)
      let main ← main.withContext do
          let mut main := main
          for x in bound do
            let ty := (← instantiateMVars (← x.getType)).consumeMData
            unless (← x.getUserName).hasMacroScopes && (← isProp ty) do
              continue
            main ← main.rename x (← Tactic.factName ty)
          return main
      replaceMainGoal [main]
      -- an abstract block's body fact, carried past the pattern
      if let some (h, hidden) := bodyFact? then
        withMainContext do
            let h ← instantiateMVars h
            let h' ← mkAppM ``List.drop_add_of_drop_eq_append #[h]
            let some (_, l, rest) := (← inferType h').eq? | throwError "body fact: not an equation"
            let run ← getRunBodyFrom (← getMainTarget)
            let ty ← mkEq (← mkAppM ``List.drop #[run.idx, l.appArg!]) rest
            replaceMainGoal [← assertBodyFact (← getMainGoal) ty (mkExpectedPropHint h' ty) hidden]
      -- a state the continuation binds: by its equation among the binders (`S' = t`), substituted
      let bare ← bindStateEq bound
      finishStep args
      -- the pattern's intermediates: sealed away, so unused; its facts about them kept
      let mut main ← getMainGoal
      for x in bound.reverse do
        let some d := (← main.getDecl).lctx.find? x | continue
        unless ← main.withContext (isProp d.type) do
          main ← main.tryClear x
      replaceMainGoal [main]
      -- a pattern that stores: its new state sealed, as an impure step's (last: `substCore`
      -- reintroduces the locals after the state); a bound state without an equation is a fresh
      -- one: the old state's facts dropped, the continuation's about it kept
      let outState ←
        withMainContext do
            return (← getRunBodyFrom (← getGoalType).2).state
      if bare then
        withMainContext do
            replaceMainGoal [← dropStateFacts (← getMainGoal) inState]
        Tactic.ensureStateEq
      else if outState != inState then
        let (goals, _) ← sealStep inState
        replaceMainGoal ((← getMainGoal) :: goals.toList)
        -- the body fact, reintroduced by the sealing, hidden again
        clearStaleBodyFacts


/-- `step_pattern` with its reads through the writes proved by `lemmaRead`. -/
syntax (name := stepPatternL) "step_pattern'" " using " stepLemma (stepPatternNames)? : tactic

@[tactic stepPatternL]
def evalStepPatternL : Tactic := fun stx => Tactic.atStepDepth (stepPatternLAt stx)

end

end MLIR
