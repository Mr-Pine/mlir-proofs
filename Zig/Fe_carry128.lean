module

public import MLIR.Run.Tactic
public import Zig.Fe
public import Zig.Mlir.Fe_carry128
import Mathlib.Tactic.NormNum

namespace MLIR.Zig

/-! ## Specification -/

@[expose] public section

/-- The columns carried in place: `r[i + 1] += r[i] >> 51`. -/
def Fe.carry128.wide (r : Fin 5 → BitVec 128) : Fin 5 → BitVec 128 :=
  let r1 := r 1 + (r 0 >>> 51)
  let r2 := r 2 + (r1 >>> 51)
  let r3 := r 3 + (r2 >>> 51)
  let r4 := r 4 + (r3 >>> 51)
  fun
  | ⟨0, _⟩ => r 0
  | ⟨1, _⟩ => r1
  | ⟨2, _⟩ => r2
  | ⟨3, _⟩ => r3
  | ⟨4, _⟩ => r4

/-- The carried columns' low 51 bits, the top carry folded into limb 0 times 19 and carried
twice more; in the program's operand order. -/
def Fe.carry128.spec (r : Fin 5 → BitVec 128) : Fin 5 → BitVec 64 :=
  let w := Fe.carry128.wide r
  let c := (w 4 >>> 51).setWidth 64
  let rs0 := c * 19#64 + ((r 0).setWidth 64 &&& Fe.mask)
  let rs1 := (rs0 >>> 51) + ((w 1).setWidth 64 &&& Fe.mask)
  let rs2 := (rs1 >>> 51) + ((w 2).setWidth 64 &&& Fe.mask)
  fun
  | ⟨0, _⟩ => rs0 &&& Fe.mask
  | ⟨1, _⟩ => rs1 &&& Fe.mask
  | ⟨2, _⟩ => rs2
  | ⟨3, _⟩ => (w 3).setWidth 64 &&& Fe.mask
  | ⟨4, _⟩ => (w 4).setWidth 64 &&& Fe.mask

/-- Columns `_carry128` takes without overflow: below `2^115 - 2^64`, the last below
`3 · 2^109`. -/
abbrev Fe.carry128.Pre (r : Fin 5 → BitVec 128) : Prop :=
  (r 0).toNat < 2 ^ 115 - 2 ^ 64 ∧
    (r 1).toNat < 2 ^ 115 - 2 ^ 64 ∧
    (r 2).toNat < 2 ^ 115 - 2 ^ 64 ∧ (r 3).toNat < 2 ^ 115 - 2 ^ 64 ∧ (r 4).toNat < 3 * 2 ^ 109

end

/-- `_carry128`'s limbs are below `2^52`, whatever its columns. -/
public theorem Fe.carry128.spec_lt (r : Fin 5 → BitVec 128) :
    Fe.Lt (Fe.carry128.spec r) (2 ^ 52) := by
  intro i
  fin_cases i <;> simp only [Fe.carry128.spec]
  all_goals
    first
    | exact (mask_lt _).trans (by norm_num)
    | exact shr_add_mask_lt _ _

/-! ## Proof -/

section Proof

/-- `_carry128` writes the carried columns back to `r` and stores `spec` at `out`. -/
public theorem Fe_carry128.call_eq (out r : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsFit out) (hr : s.mem.WideFit r) (hpre : Fe.carry128.Pre (s.mem.readWide r)) :
    Fe_carry128.call (Fe_carry128.args (.value out) (.value r)) s =
      .value
        (.nil,
          { s with
            mem :=
              (s.mem.storeWideTail r (Fe.carry128.wide (s.mem.readWide r))).storeLimbs out
                (Fe.carry128.spec (s.mem.readWide r)) }) := by
  func_init
  obtain ⟨h0, h1, h2, h3, h4⟩ := hS ▸ hpre
  simp only [MemoryState.readWide] at h0 h1 h2 h3 h4
  clear hpre
  -- the carried columns, each below `2^115`
  have b0 : (S₀.mem.readAt r 128).toNat < 2 ^ 115 := by omega
  have b1 := add_shr51_lt h1 b0
  have b2 := add_shr51_lt h2 b1
  have b3 := add_shr51_lt h3 b2
  have o1 := add_shr51_overflow h1 b0
  have o2 := add_shr51_overflow h2 b1
  have o3 := add_shr51_overflow h3 b2
  have h4' : (S₀.mem.readAt (r.add 64#64) 128).toNat < 2 ^ 115 - 2 ^ 64 := by omega
  have b4 := add_shr51_lt h4' b3
  have o4 := add_shr51_overflow h4' b3
  have b4' : _ < 3 * 2 ^ 109 + 2 ^ 64 := (add_shr51_lt_add h4' b3).trans_le (by omega)
  block_init
  iterate 5 step_pure
  step_load
  step_pure
  step_pure
  step_pure
  step_load
  step_pure
  step_pure [ult_two115 b0]
  iterate 3 step_pure
  finish_block
  iterate 3 
    block_init
    step_pure [o1.1, o1.2, o2.1, o2.2, o3.1, o3.2]
    step_store
    iterate 3 step_pure
    step_load
    step_pure
    step_pure [ult_two115 b1, ult_two115 b2, ult_two115 b3]
    iterate 3 step_pure
    finish_block
  block_init
  step_pure [o4.1, o4.2]
  step_store
  iterate 3 step_pure
  step_pure [ult_two115 b4]
  iterate 3 step_pure
  finish_block
  block_init
  step_pure [setWidth_shr51 b4]
  step_pure [top_umulOverflow b4']
  step_pure [top_uaddOverflow b4']
  step_pure
  step_pure
  step_pure [shr51_mask_overflow]
  step_pure
  step_pure
  step_pure [shr51_mask_overflow]
  step_store
  iterate 4 
    step_pure
    step_store
  finish_block
  rw [hS, storeLimbs_of_eq ?_ ?_ ?_ ?_ ?_] <;> rfl

end Proof

end MLIR.Zig
