module

public import SSA.Projects.RIR.Run.Tactic
public meta import SSA.Projects.RIR.Run.Tactic.Step.Call

/-! Staged framework change: `step_call` resolves the returned value's reads before the new state
is sealed, while the old state's read facts still hold. -/

namespace LeanMLIR.RIR

open Lean Elab Tactic Meta

public meta section

/-- The value the step writes, its reads resolved against the current state's facts. -/
def resolveWrittenValue (args : StepArgs) : TacticM Unit :=
  withMainContext do
    evalTactic
        (←
          `(tactic|
              try
                dsimp only [$(mkIdent ``Env.writeMany_nil):ident,
                  $(mkIdent ``Env.writeMany_cons):ident]))
    let (g, goal) ← getGoalType
    let_expr Env.write _ _ base _ value := (← getRunBodyFrom goal).env | return
    let r ← simpValue args.only args.simpArgs value base args.expand
    replaceMainGoal [← replaceBySimp g value r]

/-- `runStep`, with the written value resolved before the state is sealed. -/
def runStep' (args : StepArgs) (runTactics : Syntax) : TacticM Unit :=
  focus do
    Tactic.ensureStateEq
    withMainContext do
        let (g, goal) ← getGoalType
        let inState := (← getRunBodyFrom goal).state
        let ⟨runGoal, main⟩ ← rewriteStep g ``BasicBlock.runBodyFrom_step_of_run
        let some runGoal ← dsimpMlirInstr? runGoal | throwError "Could not `dsimp` runGoal"
        let_expr Eq _ op_run _ :=
          ←
            instantiateMVars
                (← runGoal.getType) | throwError m!"{← runGoal.getType} not an equality"
        unless op_run.getAppNumArgs >= 2 do
          throwError m!"Run goal lhs {op_run} not application with env and state"
        let operation := op_run.appFn!.appFn!
        setGoals [runGoal]
        let resultValue ←
          simpValue args.only args.simpArgs operation (← getRunBodyFrom goal).env args.expand
        let runGoal ← replaceBySimp runGoal operation resultValue
        setGoals [runGoal]
        evalTactic runTactics
        unless (← getUnsolvedGoals).isEmpty do
          throwError "`step_impure =>` left `insn` unsolved"
        setGoals [main]
        resolveWrittenValue args
        let goals ← sealStep inState
        finishStep args
        withMainContext do
            let mut g ← getMainGoal
            for h in args.consumed do
              g ← g.clear (← getFVarId h)
            replaceMainGoal [g]
        setGoals (goals.toList ++ (← getGoals))

@[tactic stepCall]
def evalStepCall' : Tactic := fun stx => do
  let thm : Term := ⟨stx[2]⟩
  let args := StepArgs.parse stx[3] stx[4] stx[5] mkNullNode
  let innerDischarge ←
    `(tacticSeq| exact run_call (by
        apply $thm <;> first | mem_fact | simp [$(mkIdent `mlir_mem):ident, *]))
  runStep' args innerDischarge

end

end LeanMLIR.RIR
