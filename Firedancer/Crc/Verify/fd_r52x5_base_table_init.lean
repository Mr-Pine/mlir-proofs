module

public import MLIR.Run.Tactic
public import Firedancer.Crc.Verify.fd_r52x5_base_table_build
public import Firedancer.Crc.Verify.Mlir.fd_r52x5_base_table_init

namespace MLIR.Firedancer.Crc.Verify

open MLIR.Firedancer.R52x5

/-! ## Proof -/

section Proof

/-- `FD_ONCE` with the flag set: nothing to do. -/
public theorem fd_r52x5_base_table_init.call_eq_done (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals fd_r52x5_base_table_init.globals) (flB : BlockId)
    (hgf : s.mem.globals "fd_r52x5_base_table_init._fd_once_block_state" =
      some (flB, fd_r52x5_base_table_init__fd_once_block_state.image))
    (hf : Fits s.mem ⟨flB, 0⟩ 1) (hset : s.mem.readAt ⟨flB, 0⟩ 1 = 1) :
    fd_r52x5_base_table_init.call fd_r52x5_base_table_init.args s = .value (.nil, s) := by
  func_init
  block_init
  step_addressof with fl
  have hfl : fl = ⟨flB, 0⟩ := by
    have := hglobal_fl.symm.trans hgf
    simp only [Option.some.injEq, Prod.mk.injEq] at this
    cases fl; simp_all
  subst hfl
  step_pure
  step_load
  finish_block
  block_init
  finish_block
  subst hS
  rfl

set_option maxRecDepth 8192 in
/-- `FD_ONCE` with the flag clear: the tables built, the flag set. -/
public theorem fd_r52x5_base_table_init.call_eq_build (s : GlobalState) (hwf : s.WF)
    (hg : s.mem.Globals fd_r52x5_base_table_init.globals) (flB tbB tsB : BlockId)
    (hgf : s.mem.globals "fd_r52x5_base_table_init._fd_once_block_state" =
      some (flB, fd_r52x5_base_table_init__fd_once_block_state.image))
    (hgb : s.mem.globals "fd_r52x5_base_table" = some (tbB, fd_r52x5_base_table.image))
    (hgs : s.mem.globals "fd_r52x5_base_split_table" = some (tsB, fd_r52x5_base_split_table.image))
    (hl0 : Room s.mem ⟨tbB, 0⟩ 196608) (hl1 : Room s.mem ⟨tsB, 0⟩ 1376256)
    (hf : Fits s.mem ⟨flB, 0⟩ 1) (hr : Room s.mem ⟨flB, 0⟩ 1) (hclr : s.mem.readAt ⟨flB, 0⟩ 1 = 0) :
    fd_r52x5_base_table_init.call fd_r52x5_base_table_init.args s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 1 + 8 * 14730 + 7 * 2645⟩,
            mem := (fd_r52x5_base_table_build.built s.mem ⟨tbB, 0⟩ ⟨tsB, 0⟩).storeAt ⟨flB, 0⟩
              (1 : BitVec 1) }) := by
  have hgb' : s.mem.Globals fd_r52x5_base_table_build.globals :=
    MemoryState.Globals.mono hg rfl (by
      intro g hgm
      have e : fd_r52x5_base_table_init.globals = _ :: fd_r52x5_base_table_build.globals := rfl
      rw [e]; exact List.mem_cons_of_mem _ hgm)
  revert hgb'
  func_init
  block_init
  step_addressof with fl
  have hfl : fl = ⟨flB, 0⟩ := by
    have := hglobal_fl.symm.trans hgf
    simp only [Option.some.injEq, Prod.mk.injEq] at this
    cases fl; simp_all
  subst hfl
  step_pure
  step_load
  finish_block
  block_init
  intro hgb'
  rw [← hS] at hgb'
  have hrS : Room S.mem ⟨flB, 0⟩ 1 := by subst hS; exact hr
  clear hwritable_fl hr
  step_call using (fd_r52x5_base_table_build.call_eq S hwf hgb' tbB tsB hgb hgs hl0 hl1)
  have hrS' := Room.built (tb := ⟨tbB, 0⟩) (ts := ⟨tsB, 0⟩) hrS
  step_store
  finish_block
  block_init
  finish_block
  subst_vars
  simp only [MemoryState.eraseFrom_storeAt, MemoryState.eraseFrom_built]
  have he := congrArg GlobalState.mem (GlobalState.eraseFrom_self hwf₀)
  simp only at he
  rw [he]
  simp only [Nat.reduceMul]
  rfl

end Proof

end MLIR.Firedancer.Crc.Verify
