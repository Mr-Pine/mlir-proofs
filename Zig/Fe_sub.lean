module

public import SSA.Projects.RIR.Run.Tactic
public import Zig.Fe
public import Zig.Mlir.Fe_sub
import Mathlib.Tactic.Ring

namespace LeanMLIR.RIR.Zig

/-! ## Specification -/

@[expose] public section

/-- `a - b`: `b` carried once, then subtracted from `a + 2p`; in the program's operand order. -/
def Fe.sub.spec (a b : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  let b1 := b 1 + (b 0 >>> 51)
  let b0 := b 0 &&& Fe.mask
  let b2 := (b1 >>> 51) + b 2
  let b1 := b1 &&& Fe.mask
  let b3 := (b2 >>> 51) + b 3
  let b2 := b2 &&& Fe.mask
  let b4 := (b3 >>> 51) + b 4
  let b3 := b3 &&& Fe.mask
  let b0 := b0 + 19#64 * (b4 >>> 51)
  let b4 := b4 &&& Fe.mask
  fun
  | ⟨0, _⟩ => a 0 + 4503599627370458#64 - b0
  | ⟨1, _⟩ => a 1 + 4503599627370494#64 - b1
  | ⟨2, _⟩ => a 2 + 4503599627370494#64 - b2
  | ⟨3, _⟩ => a 3 + 4503599627370494#64 - b3
  | ⟨4, _⟩ => a 4 + 4503599627370494#64 - b4

end

/-! ## Proof -/

section Proof

/-- `Fe.sub` stores `spec a b` at `out`, for limbs below `2^63`. -/
public theorem Fe_sub.call_eq (out a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsFit out) (ha : s.mem.LimbsFit a) (hb : s.mem.LimbsFit b)
    (ha' : Fe.Lt (s.mem.readLimbs a) (2 ^ 63)) (hb' : Fe.Lt (s.mem.readLimbs b) (2 ^ 63)) :
    Fe_sub.call (Fe_sub.args (.value out) (.value a) (.value b)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs out (Fe.sub.spec (s.mem.readLimbs a) (s.mem.readLimbs b)) }) := by
  func_init
  have hb1 := hS ▸ hb' 1
  have hb2 := hS ▸ hb' 2
  have hb3 := hS ▸ hb' 3
  have hb4 := hS ▸ hb' 4
  have ha4 := hS ▸ ha' 4
  simp only [MemoryState.readLimbs] at hb1 hb2 hb3 hb4 ha4
  clear ha' hb'
  block_init
  iterate 5 step_pure
  step_load
  iterate 4 
    step_pure
    step_load
  step_pure
  step_pure [uaddOverflow_shr51, hb1] with c1
  step_pure
  step_pure
  step_pure [shr51_uaddOverflow, hb2] with c2
  step_pure
  step_pure
  step_pure [shr51_uaddOverflow, hb3] with c3
  step_pure
  step_pure
  step_pure [shr51_uaddOverflow, hb4] with c4
  step_pure
  step_pure
  step_pure
  step_load
  step_pure [shr51_smulOverflow]
  iterate 3 step_pure
  iterate 3 
    step_pure
    step_load
    step_pure
    step_pure
  step_pure
  step_load
  step_pure [uaddOverflow_twoP, ha4]
  step_pure [usubOverflow_twoP, ha4]
  step_store
  iterate 4 
    step_pure
    step_store
  finish_block
  rw [hS, storeLimbs_of_eq ?_ ?_ ?_ ?_ ?_] <;>
    simp only [Fe.sub.spec, MemoryState.readLimbs, Fe.mask, hc1, hc2, hc3, hc4, neg19_eq] <;>
    ring

end Proof

end LeanMLIR.RIR.Zig
