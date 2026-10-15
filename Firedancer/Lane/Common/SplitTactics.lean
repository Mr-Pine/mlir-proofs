module

public import MLIR.Run.Tactic
meta import MLIR.Run.Tactic.Util
meta import Lean.Elab.Tactic

/-! Tactics of `double_scalar_mul_base_split`'s proof. -/

namespace MLIR.Firedancer.Lane.Split

meta section

open Lean Meta in
/-- The conjuncts of `pf : ty` (through reducible abbreviations), with their proofs. -/
partial def readParts (pf ty : Expr) (acc : Array (Expr × Expr)) :
    MetaM (Array (Expr × Expr)) := do
  match_expr ← whnfR ty with
  | And a b =>
    readParts (mkApp3 (mkConst ``And.right) a b pf) b
        (← readParts (mkApp3 (mkConst ``And.left) a b pf) a acc)
  | _ =>
    return acc.push (pf, ty)

open Lean Elab Tactic Meta in
/-- `split_env h…`: each conjunction `h` (an `E ⊨ […]`, also behind an abbreviation) as one fact
per read, so `seal` and the steps carry them past the env's writes. -/
elab "split_env" hs:(ppSpace colGt ident)+ : tactic =>
  for h in hs do
    withMainContext do
        let d ← getLocalDeclFromUserName h.getId
        let parts ← readParts d.toExpr (← instantiateMVars d.type) #[]
        let (_, g) ←
          (← getMainGoal).assertHypotheses
              (parts.mapIdx fun i (pf, ty) =>
                { userName := h.getId.appendIndexAfter i, type := ty, value := pf })
        replaceMainGoal [← g.clear d.fvarId]

end

end MLIR.Firedancer.Lane.Split
