module

public import MLIR.Run.Tactic
public import Zig.Common.Fe
public import Zig.Mlir.Fe_add

namespace MLIR.Zig

/-! ## Specification -/

@[expose] public section

/-- `a + b` limbwise, without carrying, in the program's operand order. -/
def Fe.add.spec (a b : Fin 5 → BitVec 64) : Fin 5 → BitVec 64
  | k => b k + a k

end

/-- A sum of limbs below `A` and `B`, `A + B ≤ 2^64`, is below `A + B`. -/
public theorem Fe.add.spec_lt {a b : Fin 5 → BitVec 64} {A B : ℕ} (ha : Fe.Lt a A) (hb : Fe.Lt b B)
    (h : A + B ≤ 2 ^ 64) : Fe.Lt (Fe.add.spec a b) (A + B) := by
  intro i
  have := ha i
  have := hb i
  simp only [Fe.add.spec, BitVec.toNat_add]
  rw [Nat.mod_eq_of_lt (by omega)]
  omega

/-! ## Proof -/

section Proof

/-- `Fe.add` stores `spec a b` at `out`, for limbs below `2^63`. -/
public theorem Fe_add.call_eq (out a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (ha : s.mem.LimbsFit a) (hb : s.mem.LimbsFit b)
    (ha' : Fe.Lt (s.mem.readLimbs a) (2 ^ 63)) (hb' : Fe.Lt (s.mem.readLimbs b) (2 ^ 63)) :
    Fe_add.call (Fe_add.args (.value out) (.value a) (.value b)) s =
      .value
        (.nil,
          { s with
            mem :=
              s.mem.storeLimbs out (Fe.add.spec (s.mem.readLimbs a) (s.mem.readLimbs b)) }) := by
  func_init
  have hov (k : Fin 5) :=
    uaddOverflow_eq_false (x := S₀.mem.readLimbs b k) (y := S₀.mem.readLimbs a k)
      (by
        have := hS ▸ ha' k; have := hS ▸ hb' k; omega)
  have h0 := hov 0
  have h1 := hov 1
  have h2 := hov 2
  have h3 := hov 3
  have h4 := hov 4
  simp only [MemoryState.readLimbs] at h0 h1 h2 h3 h4
  clear hov ha' hb'
  block_init
  step_load
  step_load
  step_pure [h0]
  step_pure
  step_load
  step_pure
  step_load
  step_pure [h1]
  step_pure
  step_load
  step_pure
  step_load
  step_pure [h2]
  step_pure
  step_load
  step_pure
  step_load
  step_pure [h3]
  step_pure
  step_load
  step_pure
  step_load
  step_pure [h4]
  step_store
  iterate 4
    step_pure
    step_store
  finish_block
  rw [hS, MemoryState.storeLimbs]
  rfl

/-- `call_eq` on the limbs `A`, `B` read at `a`, `b`. -/
public theorem Fe_add.call_eq_of (out a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (ha : s.mem.LimbsFit a) (hb : s.mem.LimbsFit b)
    (hA : s.mem.readLimbs a = A) (hB : s.mem.readLimbs b = B) (hA' : Fe.Lt A (2 ^ 63))
    (hB' : Fe.Lt B (2 ^ 63)) :
    Fe_add.call (Fe_add.args (.value out) (.value a) (.value b)) s =
      .value (.nil, { s with mem := s.mem.storeLimbs out (Fe.add.spec A B) }) := by
  subst hA hB
  exact Fe_add.call_eq out a b s hwf hout ha hb hA' hB'

end Proof

end MLIR.Zig
