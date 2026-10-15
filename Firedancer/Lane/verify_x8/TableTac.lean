module

public import MLIR.Run.Tactic
public import Firedancer.Lane.verify_x8.TableOps
public meta import MLIR.Run.Tactic.Util
public meta import Lean.Elab.Tactic

/-! Tactics of `verify_x8`'s table proof: the env's reads as writes, body facts hidden again, and
the steps that hide them. -/

namespace MLIR.Firedancer.Lane.VerifyX8

public meta section

open Lean Meta in
/-- The conjuncts of `pf : ty` (through reducible abbreviations), with their proofs. -/
partial def tableConjuncts (pf ty : Expr) (acc : Array (Expr × Expr)) :
    MetaM (Array (Expr × Expr)) := do
  match_expr ← whnfR ty with
  | And a b =>
    tableConjuncts (mkApp3 (mkConst ``And.right) a b pf) b
        (← tableConjuncts (mkApp3 (mkConst ``And.left) a b pf) a acc)
  | _ =>
    return acc.push (pf, ty)

open Lean Elab Tactic Meta in
/-- `env_writes h`: the reads `h : E ⊨ […]` (also behind an abbreviation) as those writes over `E`
in the goal, so no fact is about the env's root, whose writes the kernel would otherwise unfold
step after step. -/
elab "env_writes " h:ident : tactic =>
  withMainContext do
    let d ← getLocalDeclFromUserName h.getId
    let parts ← tableConjuncts d.toExpr (← instantiateMVars d.type) #[]
    let some (_, ty) := parts[0]? | throwError "env_writes: no reads"
    let some (_, l, _) := ty.eq? | throwError "env_writes: not a read"
    let_expr Env.read _ _ E _ := l | throwError "env_writes: not a read"
    let mut pf ← mkEqRefl E
    for (p, _) in parts do
      pf ← mkAppM ``Env.write_eq_of #[pf, p]
    let g ← getMainGoal
    let r ← g.rewrite (← g.getType) (← mkEqSymm pf)
    let g ← g.replaceTargetEq r.eNew r.eqProof
    replaceMainGoal [← g.clear d.fvarId]

open Lean Elab Tactic Meta in
/-- `hide_body`: hide the body facts again, which some steps leave visible (`omega` in a later
step's side condition would otherwise read the whole body). -/
elab "hide_body" : tactic =>
  withMainContext do
    let g ← getMainGoal
    let mut lctx ← getLCtx
    for d in lctx do
      if d.userName.toString.startsWith "hbody" then
        lctx := lctx.setKind d.fvarId .implDetail
    let g' ← mkFreshExprMVarAt lctx (← getLocalInstances) (← g.getType) .syntheticOpaque
      (← g.getTag)
    g.assign g'
    replaceMainGoal [g'.mvarId!]

open Lean Elab Tactic Meta in
/-- `subst_vals`: substitute the steps' default-named values `vN = e`. -/
elab "subst_vals" : tactic => do
  let vs ←
    withMainContext do
        let mut vs := #[]
        for d in ← getLCtx do
          if d.isImplementationDetail then
            continue
          let some (_, .fvar v, _) := (← instantiateMVars d.type).consumeMData.eq? | continue
          let n := (← v.getUserName).toString
          if n.startsWith "v" && (n.drop 1).all Char.isDigit && n.length > 1 then
            vs := vs.push v
        pure vs
  for v in vs do
    liftMetaTactic fun g => return [← substVar g v]

end

/-- A pure step. -/
macro "sp" : tactic => `(tactic| (step_pure; hide_body))

/-- A vector load of an input: its lanes as `readVec`. -/
macro "sl" : tactic =>
  `(tactic| (step_load [MemoryState.ofFn_extractVecElem_readAt]; hide_body))

/-- A vector load of stored lanes. -/
macro "slv" : tactic => `(tactic| (step_load; hide_body))

/-- A store. -/
macro "ss" : tactic => `(tactic| (step_store; hide_body))

/-- A `memset`. -/
macro "sms" : tactic => `(tactic| (step_memset; hide_body))

/-- A pure step on `2p - k`'s flagged subtractions. -/
macro "spn" : tactic =>
  `(tactic| (step_pure [zipWith_sub_2p_mul_l1, zipWith_sub_2p_mul_l2, zipWith_sub_2p_mul_l3,
    zipWith_sub_2p_mul_l4, zipWith_sub_2p_carry_l1, zipWith_sub_2p_carry_l2,
    zipWith_sub_2p_carry_l3, zipWith_sub_2p_carry_l4]; hide_body))

/-- A `memcpy`. -/
macro "smc" : tactic => `(tactic| (step_memcpy; hide_body))

end MLIR.Firedancer.Lane.VerifyX8
