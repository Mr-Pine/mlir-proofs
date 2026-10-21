module

public import MLIR.Run.Tactic
public meta import MLIR.Run.Tactic.Util
public meta import Lean.Elab.Tactic
public meta import Firedancer.Crc.Verify.Reads

/-! Proof tactics of `fd_r52x5_ge_decode2`'s blocks. -/

namespace MLIR

public meta section


open Lean Elab Tactic Meta

/-- `clear_readAts`: drop the facts `m.readAt p w = x`. -/
elab "clear_readAts" : tactic =>
  withMainContext do
    let mut g ← getMainGoal
    for d in ← getLCtx do
      let some (_, l, _) := (← instantiateMVars d.type).eq? | continue
      if l.isAppOf ``MemoryState.readAt then
        g ← g.tryClear d.fvarId
    replaceMainGoal [g]

/-- `clear_facts_at p…`: drop the memory facts about the objects at the pointers `p…` (`P m p …`
or `P m (p.add k) …` for a memory `m`). -/
elab "clear_facts_at" ps:(ppSpace colGt term:max)+ : tactic =>
  withMainContext do
    let mut g ← getMainGoal
    for p in ps do
      let pe ← instantiateMVars (← Term.elabTerm p none)
      let base (q : Expr) : Expr := (q.app2? ``Pointer.add).elim q (·.1)
      for d in ← getLCtx do
        if d.isImplementationDetail then
          continue
        let ty ← instantiateMVars d.type
        let args := ty.getAppArgs
        unless ty.getAppFn.isConst && args.size ≥ 2 do
          continue
        unless (← inferType args[0]!).isConstOf ``MemoryState do
          continue
        if ← isDefEq (base args[1]!) pe then
          g ← g.tryClear d.fvarId
    replaceMainGoal [g]

/-- A read `E.read r = v` (or a conjunction of them) from the facts: a read fact (conjunctions
split), a write chain by `lemmaRead`, a slot of the entry's env `hEnt : X = entryEnv …` by
`entry_slot`, or through `h : Writes X E lo hi` to a read of `X` (registers outside `lo … hi - 1`,
the entry's slot writes among them), `fuel` such steps deep; else the entry's env by the kernel's
evaluation (registers below `385`). -/
partial def chainRead (facts : Array (Expr × Expr × Expr × Nat))
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
    let some k ← Tactic.valRegIndex? r | return false
    for (pf, fty, E', k') in facts do
      unless k' == k && E' == E do
        continue
      let some (_, fl, fr) := fty.eq? | continue
      unless ← withReducible (isDefEq fl lhs) do
        continue
      let saved ← saveState
      if ← isDefEq fr rhs then
        g.assign pf
        return true
      saved.restore
    let fail : MetaM Bool := do
      if fuel = 64 then
        logInfo m!"`chain_reads`: no read for{indentExpr ty}"
      return false
    if E.isAppOfArity ``Env.write 5 then
      if let some (v, pf) ← lemmaRead lhs then
        if ← withReducible (isDefEq v rhs) then
          g.assign (mkExpectedPropHint pf ty)
          return true
    for (h, X, Y) in ents do
      if E == X && 139 ≤ k && k < 385 then
        let_expr Reg.val _ _ i ht := r | pure ()
        let some Yw ← unfoldDefinition? Y | pure ()
        let base := Yw.getArg! 1
        let B := Y.getArg! 1
        let j := k - 139
        let hj ← mkDecideProof (← mkLt (mkNatLit j) (mkNatLit 246))
        let hi ← mkDecideProof (← mkEq (← mkAppM ``Fin.val #[i]) (mkNatLit (139 + j)))
        let pfY := mkAppN (mkConst `MLIR.Firedancer.Crc.Verify.fd_r52x5_ge_decode2.entry_slot) #[base, B, mkNatLit j, hj, i, ht, hi]
        let lhsY := lhs.replaceFVar X Y
        let pfY := mkExpectedPropHint pfY (← mkEq lhsY rhs)
        let rd ←
          withLocalDeclD `e (← inferType X) fun e => do
              mkLambdaFVars #[e] (lhs.replaceFVar X e)
        g.assign (← mkEqTrans (← mkCongrArg rd h) pfY)
        return true
    if fuel = 0 then
      return false
    let_expr Env.read Γ t _ _ := lhs | return false
    let_expr Reg.val _ _ i ht := r | return false
    for (h, X, E', lo, hi) in chains do
      unless E' == E && (k < lo || hi ≤ k) do
        continue
      let saved ← saveState
      let hout ← mkDecideProof (← mkAppM ``Or #[← mkLt (← mkAppM ``Fin.val #[i]) (mkNatLit lo),
        ← mkLe (mkNatLit hi) (← mkAppM ``Fin.val #[i])])
      let step := mkAppN (mkConst `MLIR.Firedancer.Writes.read)
        #[Γ, mkNatLit lo, mkNatLit hi, t, X, E, h, i, hout, ht]
      let rX := mkApp4 (mkConst ``Env.read) Γ t X r
      let g2 ← mkFreshExprSyntheticOpaqueMVar (← mkEq rX rhs)
      if ← chainRead facts chains ents (fuel - 1) g2.mvarId! then
        g.assign (mkExpectedPropHint (← mkEqTrans step g2) ty)
        return true
      saved.restore
    -- else the entry's env by evaluation
    for (h, X, Y) in ents do
      if E == X && k < 385 then
        let lhsY := lhs.replaceFVar X Y
        let pfY := mkExpectedPropHint (← mkEqRefl rhs) (← mkEq lhsY rhs)
        let rd ←
          withLocalDeclD `e (← inferType X) fun e => do
              mkLambdaFVars #[e] (lhs.replaceFVar X e)
        g.assign (← mkEqTrans (← mkCongrArg rd h) pfY)
        return true
    fail

/-- `chain_reads`: close `E ⊨ [r := v, …]` (or one read) by `chainRead` from the context. -/
elab "chain_reads" : tactic =>
  withMainContext do
    let mut facts := #[]
    let mut chains := #[]
    let mut ents := #[]
    for d in ← getLCtx do
      if d.isImplementationDetail || !(← isProp d.type) then
        continue
      let ty ← instantiateMVars d.type
      if ty.isAppOfArity `MLIR.Firedancer.Writes 5 then
        let nat (e : Expr) : MetaM Nat := do
          return (e.nat? <|> (← whnf e).rawNatLit?).getD 0
        chains :=
          chains.push
            (d.toExpr, ty.getArg! 1, ty.getArg! 2, ← nat (ty.getArg! 3), ← nat (ty.getArg! 4))
        continue
      if let some (_, X, Y) := ty.eq? then
        if X.isFVar && Y.isAppOf `MLIR.Firedancer.Crc.Verify.fd_r52x5_ge_decode2.entryEnv then
          ents := ents.push (d.toExpr, X, Y)
          -- the constants below the slots: `Writes base X 139 385`
          if let some Yw ← unfoldDefinition? Y then
            let base := Yw.getArg! 1
            let ew := mkAppN (mkConst `MLIR.Firedancer.Crc.Verify.fd_r52x5_ge_decode2.entry_writes) #[base, Y.getArg! 1]
            let ewTy ← inferType ew
            let motive ← withLocalDeclD `x (← inferType X) fun x => do
              mkLambdaFVars #[x] (ewTy.replace fun e => if e == Yw then some x else none)
            let h' ← mkEqMPR (← mkCongrArg motive d.toExpr) (mkExpectedPropHint ew (motive.beta #[Y]))
            chains := chains.push (h', base, X, 139, 385)
          continue
      for (pf, fty) in ← Tactic.conjuncts d.toExpr ty do
        if Tactic.isEnvReadEq fty then
          let some (_, fl, _) := fty.eq? | continue
          let_expr Env.read _ _ E' r' := fl | continue
          let some k' ← Tactic.valRegIndex? r' | continue
          facts := facts.push (pf, fty, E', k')
    unless ← chainRead facts chains ents 64 (← getMainGoal) do
      throwError "`chain_reads`: a read is not known"
    replaceMainGoal []


/-- The term `writes_chain` builds: `Writes E₁ e lo hi` for `e` a write chain over `E₁`. -/
partial def writesChainTerm (Γ E₁ lo hi e : Expr) : MetaM Expr := do
  if e == E₁ then
    return mkApp4 (mkConst `MLIR.Firedancer.Writes.refl) Γ E₁ lo hi
  let_expr Env.write _ t base d v := e | throwError "`writes_chain`: not a write{indentExpr e}"
  let inner ← writesChainTerm Γ E₁ lo hi base
  let iv := mkApp2 (mkConst ``Fin.val) (mkApp (mkConst ``Ctx.n) Γ) (mkApp3 (mkConst ``Dst.i) Γ t d)
  let le := mkApp4 (mkConst ``LE.le [0]) (mkConst ``Nat) (mkConst ``instLENat) lo iv
  let lt := mkApp4 (mkConst ``LT.lt [0]) (mkConst ``Nat) (mkConst ``instLTNat) iv hi
  let p := mkApp2 (mkConst ``And) le lt
  let inst := mkApp4 (mkConst ``instDecidableAnd) le lt (mkApp2 (mkConst ``Nat.decLe) lo iv)
    (mkApp2 (mkConst ``Nat.decLt) iv hi)
  let hd := mkApp3 (mkConst ``of_decide_eq_true) p inst
    (mkApp2 (mkConst ``Eq.refl [1]) (mkConst ``Bool) (mkConst ``Bool.true))
  return mkAppN (mkConst `MLIR.Firedancer.Writes.write) #[Γ, t, lo, hi, E₁, base, d, v, inner, hd]

/-- `writes_chain` closes `Writes E₁ (E₁[d := v, …]) lo hi` (each `d` a literal register in
`lo … hi - 1`) by one term: `Writes.write` per write, its bound by `decide` with the instance
given, over `Writes.refl`. -/
elab "writes_chain" : tactic =>
  withMainContext do
    let g ← getMainGoal
    let ty ← whnfR (← instantiateMVars (← g.getType))
    unless ty.isAppOfArity `MLIR.Firedancer.Writes 5 do
      throwError "`writes_chain`: not a `Writes` goal"
    g.assign (← writesChainTerm (ty.getArg! 0) (ty.getArg! 1) (ty.getArg! 3) (ty.getArg! 4)
      (ty.getArg! 2))
    replaceMainGoal []

end

syntax "qp_site " term:max num : tactic

set_option hygiene false in
/-- A QUAD call site after its call `c`, through the temporaries `B.slot k … B.slot (k + 4)`
(`hF` the frame): their starts, the call, the loads, their ends (folded as `callTmp5`). -/
macro_rules
  | `(tactic| qp_site $c $k) => do
    let n (i : Nat) := Lean.Syntax.mkNumLit (toString (k.getNat + i))
    `(tactic| (
      obtain ⟨iz0, wz0⟩ := hF.tmp $(n 0)
      obtain ⟨iz1, wz1⟩ := hF.tmp $(n 1)
      obtain ⟨iz2, wz2⟩ := hF.tmp $(n 2)
      obtain ⟨iz3, wz3⟩ := hF.tmp $(n 3)
      obtain ⟨iz4, wz4⟩ := hF.tmp $(n 4)
      iterate 5 step_pure
      step_call using $c
      iterate 5 step_load [ofFn_extractVecElem_readAt] inline
      clear_facts_at (B.slot $(n 0)) (B.slot $(n 1)) (B.slot $(n 2)) (B.slot $(n 3))
        (B.slot $(n 4))
      iterate 5 step_pure
      rw [← MemoryState.callTmp5.eq_1] at hS
      clear_readAts))

set_option hygiene false in
/-- `qp_site` whose results are loaded as `<32 x i8>`: their bytes. -/
syntax "qp_site_b " term:max num : tactic

set_option hygiene false in
macro_rules
  | `(tactic| qp_site_b $c $k) => do
    let n (i : Nat) := Lean.Syntax.mkNumLit (toString (k.getNat + i))
    `(tactic| (
      obtain ⟨iz0, wz0⟩ := hF.tmp $(n 0)
      obtain ⟨iz1, wz1⟩ := hF.tmp $(n 1)
      obtain ⟨iz2, wz2⟩ := hF.tmp $(n 2)
      obtain ⟨iz3, wz3⟩ := hF.tmp $(n 3)
      obtain ⟨iz4, wz4⟩ := hF.tmp $(n 4)
      iterate 5 step_pure
      step_call using $c
      iterate 5 step_load [ofFn_extractVecElem_wlBytes] inline
      clear_facts_at (B.slot $(n 0)) (B.slot $(n 1)) (B.slot $(n 2)) (B.slot $(n 3))
        (B.slot $(n 4))
      iterate 5 step_pure
      rw [← MemoryState.callTmp5.eq_1] at hS
      clear_readAts))

set_option hygiene false in
macro "qp_sqr " k:num : tactic => `(tactic| qp_site fd_r52x5_quad_sqr.call_eq $k)
set_option hygiene false in
macro "qp_mul " k:num : tactic => `(tactic| qp_site fd_r52x5_quad_mul.call_eq $k)
set_option hygiene false in
macro "qp_add " k:num : tactic => `(tactic| qp_site fd_r52x5_quad_add.call_eq $k)
set_option hygiene false in
macro "qp_sub " k:num : tactic => `(tactic| qp_site fd_r52x5_quad_sub.call_eq $k)
set_option hygiene false in
macro "qp_neg " k:num : tactic => `(tactic| qp_site fd_r52x5_quad_neg.call_eq $k)

end MLIR
