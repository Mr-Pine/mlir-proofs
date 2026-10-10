module

public import MLIR.Run.Tactic
public import Firedancer.Common.Limbs
public import Firedancer.Common.Tactics
public import Firedancer.Ref.fiat_25519_cmovznz_u64
public import Firedancer.Ref.Mlir.fiat_25519_selectznz

namespace MLIR.Firedancer.Ref

/-! ## Specification -/

@[expose] public section

/-- `x` when `c = 0`, else `y`, limb by limb: `x1 … x5` are `cmovznz`'s results. -/
def fiat_25519_selectznz.spec (c : BitVec 8) (x y : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let x1 := fiat_25519_cmovznz_u64.spec c (x 0) (y 0)
  let x2 := fiat_25519_cmovznz_u64.spec c (x 1) (y 1)
  let x3 := fiat_25519_cmovznz_u64.spec c (x 2) (y 2)
  let x4 := fiat_25519_cmovznz_u64.spec c (x 3) (y 3)
  let x5 := fiat_25519_cmovznz_u64.spec c (x 4) (y 4)
  fun
  | ⟨0, _⟩ => x1
  | ⟨1, _⟩ => x2
  | ⟨2, _⟩ => x3
  | ⟨3, _⟩ => x4
  | ⟨4, _⟩ => x5

end

/-! ## Staged for Common -/

section Staged

/-- A read in another block passes an `alloca`. Unlike `readAt_alloca`, the premise is the block
ids' distinctness, which the step tactics find for a named slot through any number of `alloca`s. -/
theorem MemoryState.readAt_alloca_of_ne {s : GlobalState} (hne : q.id ≠ s.allocaPtr.id) :
    (s.alloca n).mem.readAt q w = s.mem.readAt q w := by
  simp only [MemoryState.readAt, GlobalState.getElem?_alloca hne]

end Staged

/-! ## Proof -/

section Proof

-- the loads of `x` and `y` read past the five `alloca`s
attribute [local mlir_read] MemoryState.readAt_alloca_of_ne

/-- `selectznz` stores `spec c x y` at `out`. All loads of `x` and `y` come before the stores, so
`out` may alias either. The five temporaries are freed again: only the counter moves on. -/
public theorem fiat_25519_selectznz.call_eq (out : Pointer) (c : BitVec 8) (x y : Pointer)
    (s : GlobalState) (hwf : s.WF) (hout : s.mem.LimbsRoom out) (hx : s.mem.LimbsFit x)
    (hy : s.mem.LimbsFit y) :
    fiat_25519_selectznz.call
        (fiat_25519_selectznz.args (.value out) (.value c) (.value x) (.value y)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 5⟩,
            mem :=
              s.mem.storeLimbs out
                (fiat_25519_selectznz.spec c (s.mem.readLimbs x) (s.mem.readLimbs y)) }) := by
  func_init
  block_init
  step_pure
  iterate 5 step_alloca
  iterate 5 step_pure
  -- fiat_25519_cmovznz_u64(&x1, arg1, (arg2[0]), (arg3[0]));
  step_load
  step_load
  step_call using fiat_25519_cmovznz_u64.call_eq
  -- … `x2` to `x5`
  iterate 4 
    step_pure
    step_load
    step_pure
    step_load
    step_call using fiat_25519_cmovznz_u64.call_eq
  -- out1[0] = x1;
  step_load with x1 consuming hread_v1
  step_store
  -- out1[1] = x2; … out1[4] = x5;
  step_load with x2 consuming hread_v2
  step_pure
  step_store
  step_load with x3 consuming hread_v3
  step_pure
  step_store
  step_load with x4 consuming hread_v4
  step_pure
  step_store
  step_load with x5 consuming hread_v5
  step_pure
  step_store
  -- the lifetimes' ends
  iterate 5 step_pure
  finish_block
  clear_reads
  subst_vars
  erase_frame
  rfl

end Proof

end MLIR.Firedancer.Ref
