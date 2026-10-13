module

public import MLIR.Run.Tactic
public import Zig.Common.Fe
public import Zig.Mlir.Fe_cMov
import Std.Tactic.BVDecide

namespace MLIR.Zig

/-! ## Specification -/

@[expose] public section

/-- `fe` with `a`'s limbs where `c` is `1`: `fe ^ ((a ^ fe) & -c)`, in the program's operand
order. -/
def Fe.cMov.spec (fe a : Fin 5 → BitVec 64) (c : BitVec 64) : Fin 5 → BitVec 64
  | i => (a i ^^^ fe i) &&& (0#64 - c) ^^^ fe i

end

/-- `cMov` picks `a` or keeps `fe`. -/
public theorem Fe.cMov.spec_eq (fe a : Fin 5 → BitVec 64) (c : BitVec 64) (hc : c.toNat < 2) :
    Fe.cMov.spec fe a c = if c = 1#64 then a else fe := by
  funext i
  have : c = 0#64 ∨ c = 1#64 := by
    rcases (by omega : c.toNat = 0 ∨ c.toNat = 1) with h | h
    · exact .inl (BitVec.eq_of_toNat_eq h)
    · exact .inr (BitVec.eq_of_toNat_eq h)
  rcases this with rfl | rfl
  · simp [Fe.cMov.spec]
  · simp only [Fe.cMov.spec, ite_true]
    bv_decide

/-! ## Proof -/

section Proof

/-- `Fe.cMov` stores `spec fe a c` at `fe`, for `c` below `2`. The loads all come before the
stores, so `a` may alias `fe`. -/
public theorem Fe_cMov.call_eq (fe a : Pointer) (c : BitVec 64) (s : GlobalState) (hwf : s.WF)
    (hfe : s.mem.LimbsFit fe) (hfew : Writable s.mem fe) (ha : s.mem.LimbsFit a)
    (hc : c.toNat < 2) :
    Fe_cMov.call (Fe_cMov.args (.value fe) (.value a) (.value c)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs fe (Fe.cMov.spec (s.mem.readLimbs fe) (s.mem.readLimbs a) c) }) := by
  func_init
  have hfe_room := hfe.room hfew
  have hc' : (0#64).ssubOverflow c = false := by
    simp only [BitVec.ssubOverflow, Bool.or_eq_false_iff, decide_eq_false_iff_not]
    have : c.toInt = c.toNat := BitVec.toInt_eq_toNat_of_lt (by omega)
    simp [this]
    omega
  block_init
  step_pure
  step_pure [hc']
  step_load
  iterate 4
    step_pure
    step_load
  step_load
  step_pure
  iterate 4
    step_pure
    step_load
    step_pure
  iterate 5 step_pure
  step_pure
  step_store
  iterate 4
    step_pure
    step_store
  finish_block
  rw [hS, storeLimbs_of_eq ?_ ?_ ?_ ?_ ?_] <;> rfl

end Proof

end MLIR.Zig
