module

public import MLIR.Run.Tactic
public meta import Firedancer.Avx512.Common.Vec
public meta import MLIR.Run.Tactic.Util
public meta import Lean.Elab.Tactic

/-! Proof tactics of `fd_r52x5_ge_decode2`'s blocks. -/

namespace MLIR

public meta section

open Lean Elab Tactic Meta

/-- `name_vec x`: the field element the latest `storeVec` of an unnamed value in the current state
writes becomes `x`, with `hx : x = …` tagged as a `with x` step's, in the state and the facts. -/
elab "name_vec " x:ident : tactic =>
  withMainContext do
    let (g, goal) ← Tactic.getGoalType
    let S := (← Tactic.getRunBodyFrom goal).state
    let some hS ← Tactic.findEqWithLhs? S m!"`{S} = _`" | throwError "`name_vec`: no `{S} = _`"
    let some (_, _, rhs) := (← instantiateMVars (← hS.getType)).eq? | throwError "no equation"
    let some st :=
      rhs.find? fun e => e.isAppOfArity ``MemoryState.storeVec 3 && !(e.getArg! 2).isFVar
      | throwError "`name_vec`: no `storeVec` of an unnamed value in{indentExpr rhs}"
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

/-- `clear_readAts`: drop the facts `m.readAt p w = x` (the field elements' read-backs keep their
`readVec` facts). -/
elab "clear_readAts" : tactic =>
  withMainContext do
    let mut g ← getMainGoal
    for d in ← getLCtx do
      let some (_, l, _) := (← instantiateMVars d.type).eq? | continue
      if l.isAppOf ``MemoryState.readAt then
        g ← g.tryClear d.fvarId
    replaceMainGoal [g]

set_option hygiene false in
/-- `QP_SQR`/`QP_MUL` after its call `c`, through the temporaries `B.slot k … B.slot (k + 4)`
(`hF` the frame's fit): the call, the loads, then `FD_R52X5_QUAD_REDUCE`, one step each (a pattern
reads the body by `List.drop`, too deep in `^bb0`). -/
syntax "qp_site " term:max num : tactic

set_option hygiene false in
macro_rules
  | `(tactic| qp_site $c $k) => do
    let n (i : Nat) := Lean.Syntax.mkNumLit (toString (k.getNat + i))
    `(tactic| (
      have hz0 := hF.tmp $(n 0)
      have hz1 := hF.tmp $(n 1)
      have hz2 := hF.tmp $(n 2)
      have hz3 := hF.tmp $(n 3)
      have hz4 := hF.tmp $(n 4)
      iterate 5 step_pure
      step_call using $c
      iterate 5 step_load [ofFn_extractVecElem_readAt] inline
      clear hz0 hz1 hz2 hz3 hz4
      iterate 5 step_pure
      iterate 5 step_pure with transparent vc
      iterate 5
        step_pure with transparent va
        step_pure [reduce_P0, reduce_P1, reduce_P2, reduce_P3, reduce_P4, reduce_sqr, reduce_mul]
      clear_readAts))

set_option hygiene false in
/-- `qp_sqr k`: `QP_SQR` through the temporaries `B.slot k … B.slot (k + 4)`. -/
macro "qp_sqr " k:num : tactic => `(tactic| qp_site fd_r52x5_quad_sqr_fast.call_eq $k)

set_option hygiene false in
/-- `qp_mul k`: `QP_MUL` through the temporaries `B.slot k … B.slot (k + 4)`. -/
macro "qp_mul " k:num : tactic => `(tactic| qp_site fd_r52x5_quad_mul_fast.call_eq $k)

/-- A read `E.read r = v` (or a conjunction of them) from the facts: a read fact (conjunctions
split), the entry's env `hEnt : X = entryEnv …` by the kernel's evaluation (registers below `247`),
or through `h : Writes X E lo hi` to a read of `X` (registers outside `lo … hi - 1`), `fuel` such
steps deep. -/
partial def chainRead (facts : Array (Expr × Expr))
    (chains : Array (Expr × Expr × Expr × Nat × Nat)) (ents : Array (Expr × Expr × Expr))
    (fuel : Nat) (g : MVarId) : MetaM Bool :=
  g.withContext do
    let ty ← instantiateMVars (← g.getType)
    if let some (ga, gb)← Tactic.splitAnd? g (← whnfR ty) then
      let a ← chainRead facts chains ents fuel ga
      let b ← chainRead facts chains ents fuel gb
      return a && b
    let some (_, lhs, rhs) := ty.eq? | return false
    let_expr Env.read _ _ E r := lhs | return false
    for (pf, fty) in facts do
      let some (_, fl, fr) := fty.eq? | continue
      unless ← withReducible (isDefEq fl lhs) do
        continue
      -- the same read: its value, unfolding definitions if needed
      let saved ← saveState
      if ← isDefEq fr rhs then
        g.assign pf
        return true
      saved.restore
    let some k ← Tactic.valRegIndex? r | return false
    let fail : MetaM Bool := do
      if fuel = 64 then
        logInfo m!"`chain_reads`: no read for{indentExpr ty}"
      return false
    for (h, X, Y) in ents do
      if E == X && k < 247 then
        let lhsY := lhs.replaceFVar X Y
        let pfY := mkExpectedPropHint (← mkEqRefl rhs) (← mkEq lhsY rhs)
        let rd ←
          withLocalDeclD `e (← inferType X) fun e => do
              mkLambdaFVars #[e] (lhs.replaceFVar X e)
        g.assign (← mkEqTrans (← mkCongrArg rd h) pfY)
        return true
    if fuel = 0 then
      return false
    for (h, _, E', lo, hi) in chains do
      unless E' == E && (k < lo || hi ≤ k) do
        continue
      let saved ← saveState
      let thm ← mkConstWithFreshMVarLevels `MLIR.Firedancer.R52x5.fd_r52x5_ge_decode2.Writes.read
      let (args, _, concl) ← forallMetaTelescopeReducing (← inferType thm)
      let some (_, l, rX) := concl.eq? | continue
      unless ← isDefEq l lhs do
        saved.restore
        continue
      -- the `Writes` premise and the index bound
      let mut ok := true
      for a in args do
        if ← a.mvarId!.isAssigned then
          continue
        let aty ← instantiateMVars (← inferType a)
        if aty.consumeTypeAnnotations.isAppOf `MLIR.Firedancer.R52x5.fd_r52x5_ge_decode2.Writes then
          unless ← isDefEq a h do
            ok := false
        else if ← isProp aty then
          a.mvarId!.assign (← mkDecideProof (aty.cleanupAnnotations))
      unless ok do
        saved.restore
        continue
      let g2 ← mkFreshExprSyntheticOpaqueMVar (← mkEq (← instantiateMVars rX) rhs)
      if ← chainRead facts chains ents (fuel - 1) g2.mvarId! then
        g.assign (← mkEqTrans (← instantiateMVars (mkAppN thm args)) g2)
        return true
      saved.restore
    fail

/-- `chain_reads`: close `E ⊨ [r := v, …]` (or one read) by `chainRead` from the context: reads back
through the chain of `Writes` facts to the env that holds them. -/
elab "chain_reads" : tactic =>
  withMainContext do
    let mut facts := #[]
    let mut chains := #[]
    let mut ents := #[]
    for d in ← getLCtx do
      if d.isImplementationDetail || !(← isProp d.type) then
        continue
      let ty ← instantiateMVars d.type
      if ty.isAppOfArity `MLIR.Firedancer.R52x5.fd_r52x5_ge_decode2.Writes 5 then
        let nat (e : Expr) : MetaM Nat := do
          return (e.nat? <|> (← whnf e).rawNatLit?).getD 0
        chains :=
          chains.push
            (d.toExpr, ty.getArg! 1, ty.getArg! 2, ← nat (ty.getArg! 3), ← nat (ty.getArg! 4))
        continue
      if let some (_, X, Y) := ty.eq? then
        if X.isFVar && Y.isAppOf `MLIR.Firedancer.R52x5.fd_r52x5_ge_decode2.entryEnv then
          ents := ents.push (d.toExpr, X, Y)
          continue
      for (pf, fty) in ← Tactic.conjuncts d.toExpr ty do
        if Tactic.isEnvReadEq fty then
          facts := facts.push (pf, fty)
    unless ← chainRead facts chains ents 64 (← getMainGoal) do
      throwError "`chain_reads`: a read is not known"
    replaceMainGoal []

end

end MLIR
