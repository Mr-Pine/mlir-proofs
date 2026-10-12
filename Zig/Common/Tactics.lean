module

public import MLIR.Run.Tactic
public meta import MLIR.Run.Tactic.Util
public meta import Lean.Elab.Tactic

/-! Proof tactics the Zig point proofs share. -/

namespace MLIR.Zig

public meta section

open Lean Elab Tactic Meta in
/-- `clear_limb_reads`: drop the 64-bit read facts (`m.readAt p 64 = x`), the limbs a call's result
records one by one; its `readLimbs` fact stays. Every later step carries each of them. -/
elab "clear_limb_reads" : tactic =>
  withMainContext do
    let mut g ← getMainGoal
    for d in ← getLCtx do
      if d.isImplementationDetail then
        continue
      let some (_, l, _) := (← instantiateMVars d.type).eq? | continue
      if l.isAppOfArity ``MemoryState.readAt 3 then
        if let some 64 := (l.getArg! 2).nat? then
          g ← g.tryClear d.fvarId
    replaceMainGoal [g]

end

end MLIR.Zig
