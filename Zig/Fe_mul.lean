module

public import MLIR.Run.Tactic
public import Common.LimbsBits
public import Common.Tactics
import Mathlib.Tactic.Ring
public import Zig.Fe_carry128
public import Zig.Mlir.Fe_mul

namespace MLIR.Zig

/-! ## Specification -/

@[expose] public section

/-- The five columns of `a b`, `a`'s high limbs times 19 folded in; in the program's operand
order. -/
def Fe.mul.cols (a b : Fin 5 → BitVec 64) : Fin 5 → BitVec 128 :=
  let ax (i : Fin 5) := (a i).setWidth 128
  let bx (i : Fin 5) := (b i).setWidth 128
  let a19 (i : Fin 5) := ax i * 19#128
  fun
  | ⟨0, _⟩ => ax 0 * bx 0 + a19 1 * bx 4 + a19 2 * bx 3 + a19 3 * bx 2 + a19 4 * bx 1
  | ⟨1, _⟩ => ax 0 * bx 1 + ax 1 * bx 0 + a19 2 * bx 4 + a19 3 * bx 3 + a19 4 * bx 2
  | ⟨2, _⟩ => ax 0 * bx 2 + ax 1 * bx 1 + ax 2 * bx 0 + a19 3 * bx 4 + a19 4 * bx 3
  | ⟨3, _⟩ => ax 0 * bx 3 + ax 1 * bx 2 + ax 2 * bx 1 + ax 3 * bx 0 + a19 4 * bx 4
  | ⟨4, _⟩ => ax 0 * bx 4 + ax 1 * bx 3 + ax 2 * bx 2 + ax 3 * bx 1 + ax 4 * bx 0

/-- `a b`, carried. -/
def Fe.mul.spec (a b : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  Fe.carry128.spec (Fe.mul.cols a b)

end

/-- `mul`'s limbs are below `2^52`. -/
public theorem Fe.mul.spec_lt (a b : Fin 5 → BitVec 64) : Fe.Lt (Fe.mul.spec a b) (2 ^ 52) :=
  Fe.carry128.spec_lt _

/-! ## Proof -/

section Proof

/-- No flagged operation of `Fe.mul` overflows, for limbs below `2^54`: products below `19 · 2^108`,
columns below `5 · 19 · 2^108`. -/
theorem Fe.mul.noOverflow {a b : Fin 5 → BitVec 64} (ha : Fe.Lt a (2 ^ 54))
    (hb : Fe.Lt b (2 ^ 54)) :
    (BitVec.setWidth 128 (a 1)).smulOverflow (19#128) = false ∧
      (BitVec.setWidth 128 (a 1)).umulOverflow (19#128) = false ∧
      (BitVec.setWidth 128 (a 2)).smulOverflow (19#128) = false ∧
      (BitVec.setWidth 128 (a 2)).umulOverflow (19#128) = false ∧
      (BitVec.setWidth 128 (a 3)).smulOverflow (19#128) = false ∧
      (BitVec.setWidth 128 (a 3)).umulOverflow (19#128) = false ∧
      (BitVec.setWidth 128 (a 4)).smulOverflow (19#128) = false ∧
      (BitVec.setWidth 128 (a 4)).umulOverflow (19#128) = false ∧
      (BitVec.setWidth 128 (b 0)).umulOverflow (BitVec.setWidth 128 (a 0)) = false ∧
      ((BitVec.setWidth 128 (a 1)) * (19#128)).umulOverflow (BitVec.setWidth 128 (b 4)) = false ∧
      ((BitVec.setWidth 128 (a 2)) * (19#128)).umulOverflow (BitVec.setWidth 128 (b 3)) = false ∧
      ((BitVec.setWidth 128 (a 3)) * (19#128)).umulOverflow (BitVec.setWidth 128 (b 2)) = false ∧
      ((BitVec.setWidth 128 (a 4)) * (19#128)).umulOverflow (BitVec.setWidth 128 (b 1)) = false ∧
      (((BitVec.setWidth 128 (a 2)) * (19#128)) * (BitVec.setWidth 128 (b 3))).uaddOverflow
          ((BitVec.setWidth 128 (b 0)) * (BitVec.setWidth 128 (a 0))) =
        false ∧
      ((((BitVec.setWidth 128 (a 2)) * (19#128)) * (BitVec.setWidth 128 (b 3))) +
              ((BitVec.setWidth 128 (b 0)) * (BitVec.setWidth 128 (a 0)))).uaddOverflow
          (((BitVec.setWidth 128 (a 3)) * (19#128)) * (BitVec.setWidth 128 (b 2))) =
        false ∧
      (((((BitVec.setWidth 128 (a 2)) * (19#128)) * (BitVec.setWidth 128 (b 3))) +
                ((BitVec.setWidth 128 (b 0)) * (BitVec.setWidth 128 (a 0)))) +
              (((BitVec.setWidth 128 (a 3)) * (19#128)) * (BitVec.setWidth 128 (b 2)))).uaddOverflow
          (((BitVec.setWidth 128 (a 1)) * (19#128)) * (BitVec.setWidth 128 (b 4))) =
        false ∧
      ((((((BitVec.setWidth 128 (a 2)) * (19#128)) * (BitVec.setWidth 128 (b 3))) +
                  ((BitVec.setWidth 128 (b 0)) * (BitVec.setWidth 128 (a 0)))) +
                (((BitVec.setWidth 128 (a 3)) * (19#128)) * (BitVec.setWidth 128 (b 2)))) +
              (((BitVec.setWidth 128 (a 1)) * (19#128)) * (BitVec.setWidth 128 (b 4)))).uaddOverflow
          (((BitVec.setWidth 128 (a 4)) * (19#128)) * (BitVec.setWidth 128 (b 1))) =
        false ∧
      (BitVec.setWidth 128 (b 1)).umulOverflow (BitVec.setWidth 128 (a 0)) = false ∧
      (BitVec.setWidth 128 (a 1)).umulOverflow (BitVec.setWidth 128 (b 0)) = false ∧
      ((BitVec.setWidth 128 (b 1)) * (BitVec.setWidth 128 (a 0))).uaddOverflow
          ((BitVec.setWidth 128 (a 1)) * (BitVec.setWidth 128 (b 0))) =
        false ∧
      ((BitVec.setWidth 128 (a 2)) * (19#128)).umulOverflow (BitVec.setWidth 128 (b 4)) = false ∧
      ((BitVec.setWidth 128 (a 3)) * (19#128)).umulOverflow (BitVec.setWidth 128 (b 3)) = false ∧
      ((BitVec.setWidth 128 (a 4)) * (19#128)).umulOverflow (BitVec.setWidth 128 (b 2)) = false ∧
      (((BitVec.setWidth 128 (b 1)) * (BitVec.setWidth 128 (a 0))) +
              ((BitVec.setWidth 128 (a 1)) * (BitVec.setWidth 128 (b 0)))).uaddOverflow
          (((BitVec.setWidth 128 (a 3)) * (19#128)) * (BitVec.setWidth 128 (b 3))) =
        false ∧
      ((((BitVec.setWidth 128 (b 1)) * (BitVec.setWidth 128 (a 0))) +
                ((BitVec.setWidth 128 (a 1)) * (BitVec.setWidth 128 (b 0)))) +
              (((BitVec.setWidth 128 (a 3)) * (19#128)) * (BitVec.setWidth 128 (b 3)))).uaddOverflow
          (((BitVec.setWidth 128 (a 2)) * (19#128)) * (BitVec.setWidth 128 (b 4))) =
        false ∧
      (((((BitVec.setWidth 128 (b 1)) * (BitVec.setWidth 128 (a 0))) +
                  ((BitVec.setWidth 128 (a 1)) * (BitVec.setWidth 128 (b 0)))) +
                (((BitVec.setWidth 128 (a 3)) * (19#128)) * (BitVec.setWidth 128 (b 3)))) +
              (((BitVec.setWidth 128 (a 2)) * (19#128)) * (BitVec.setWidth 128 (b 4)))).uaddOverflow
          (((BitVec.setWidth 128 (a 4)) * (19#128)) * (BitVec.setWidth 128 (b 2))) =
        false ∧
      (BitVec.setWidth 128 (b 2)).umulOverflow (BitVec.setWidth 128 (a 0)) = false ∧
      (BitVec.setWidth 128 (b 1)).umulOverflow (BitVec.setWidth 128 (a 1)) = false ∧
      (BitVec.setWidth 128 (a 2)).umulOverflow (BitVec.setWidth 128 (b 0)) = false ∧
      ((BitVec.setWidth 128 (a 3)) * (19#128)).umulOverflow (BitVec.setWidth 128 (b 4)) = false ∧
      ((BitVec.setWidth 128 (a 4)) * (19#128)).umulOverflow (BitVec.setWidth 128 (b 3)) = false ∧
      ((BitVec.setWidth 128 (a 2)) * (BitVec.setWidth 128 (b 0))).uaddOverflow
          ((BitVec.setWidth 128 (b 1)) * (BitVec.setWidth 128 (a 1))) =
        false ∧
      (((BitVec.setWidth 128 (a 2)) * (BitVec.setWidth 128 (b 0))) +
              ((BitVec.setWidth 128 (b 1)) * (BitVec.setWidth 128 (a 1)))).uaddOverflow
          ((BitVec.setWidth 128 (b 2)) * (BitVec.setWidth 128 (a 0))) =
        false ∧
      ((((BitVec.setWidth 128 (a 2)) * (BitVec.setWidth 128 (b 0))) +
                ((BitVec.setWidth 128 (b 1)) * (BitVec.setWidth 128 (a 1)))) +
              ((BitVec.setWidth 128 (b 2)) * (BitVec.setWidth 128 (a 0)))).uaddOverflow
          (((BitVec.setWidth 128 (a 3)) * (19#128)) * (BitVec.setWidth 128 (b 4))) =
        false ∧
      (((((BitVec.setWidth 128 (a 2)) * (BitVec.setWidth 128 (b 0))) +
                  ((BitVec.setWidth 128 (b 1)) * (BitVec.setWidth 128 (a 1)))) +
                ((BitVec.setWidth 128 (b 2)) * (BitVec.setWidth 128 (a 0)))) +
              (((BitVec.setWidth 128 (a 3)) * (19#128)) * (BitVec.setWidth 128 (b 4)))).uaddOverflow
          (((BitVec.setWidth 128 (a 4)) * (19#128)) * (BitVec.setWidth 128 (b 3))) =
        false ∧
      (BitVec.setWidth 128 (b 3)).umulOverflow (BitVec.setWidth 128 (a 0)) = false ∧
      (BitVec.setWidth 128 (b 2)).umulOverflow (BitVec.setWidth 128 (a 1)) = false ∧
      (BitVec.setWidth 128 (a 2)).umulOverflow (BitVec.setWidth 128 (b 1)) = false ∧
      (BitVec.setWidth 128 (a 3)).umulOverflow (BitVec.setWidth 128 (b 0)) = false ∧
      ((BitVec.setWidth 128 (a 4)) * (19#128)).umulOverflow (BitVec.setWidth 128 (b 4)) = false ∧
      ((BitVec.setWidth 128 (b 2)) * (BitVec.setWidth 128 (a 1))).uaddOverflow
          ((BitVec.setWidth 128 (a 2)) * (BitVec.setWidth 128 (b 1))) =
        false ∧
      (((BitVec.setWidth 128 (b 2)) * (BitVec.setWidth 128 (a 1))) +
              ((BitVec.setWidth 128 (a 2)) * (BitVec.setWidth 128 (b 1)))).uaddOverflow
          ((BitVec.setWidth 128 (a 3)) * (BitVec.setWidth 128 (b 0))) =
        false ∧
      ((((BitVec.setWidth 128 (b 2)) * (BitVec.setWidth 128 (a 1))) +
                ((BitVec.setWidth 128 (a 2)) * (BitVec.setWidth 128 (b 1)))) +
              ((BitVec.setWidth 128 (a 3)) * (BitVec.setWidth 128 (b 0)))).uaddOverflow
          ((BitVec.setWidth 128 (b 3)) * (BitVec.setWidth 128 (a 0))) =
        false ∧
      (((((BitVec.setWidth 128 (b 2)) * (BitVec.setWidth 128 (a 1))) +
                  ((BitVec.setWidth 128 (a 2)) * (BitVec.setWidth 128 (b 1)))) +
                ((BitVec.setWidth 128 (a 3)) * (BitVec.setWidth 128 (b 0)))) +
              ((BitVec.setWidth 128 (b 3)) * (BitVec.setWidth 128 (a 0)))).uaddOverflow
          (((BitVec.setWidth 128 (a 4)) * (19#128)) * (BitVec.setWidth 128 (b 4))) =
        false ∧
      (BitVec.setWidth 128 (b 4)).umulOverflow (BitVec.setWidth 128 (a 0)) = false ∧
      (BitVec.setWidth 128 (b 3)).umulOverflow (BitVec.setWidth 128 (a 1)) = false ∧
      (BitVec.setWidth 128 (b 2)).umulOverflow (BitVec.setWidth 128 (a 2)) = false ∧
      (BitVec.setWidth 128 (a 3)).umulOverflow (BitVec.setWidth 128 (b 1)) = false ∧
      (BitVec.setWidth 128 (a 4)).umulOverflow (BitVec.setWidth 128 (b 0)) = false ∧
      ((BitVec.setWidth 128 (a 3)) * (BitVec.setWidth 128 (b 1))).uaddOverflow
          ((BitVec.setWidth 128 (b 2)) * (BitVec.setWidth 128 (a 2))) =
        false ∧
      (((BitVec.setWidth 128 (a 3)) * (BitVec.setWidth 128 (b 1))) +
              ((BitVec.setWidth 128 (b 2)) * (BitVec.setWidth 128 (a 2)))).uaddOverflow
          ((BitVec.setWidth 128 (b 3)) * (BitVec.setWidth 128 (a 1))) =
        false ∧
      ((((BitVec.setWidth 128 (a 3)) * (BitVec.setWidth 128 (b 1))) +
                ((BitVec.setWidth 128 (b 2)) * (BitVec.setWidth 128 (a 2)))) +
              ((BitVec.setWidth 128 (b 3)) * (BitVec.setWidth 128 (a 1)))).uaddOverflow
          ((BitVec.setWidth 128 (a 4)) * (BitVec.setWidth 128 (b 0))) =
        false ∧
      (((((BitVec.setWidth 128 (a 3)) * (BitVec.setWidth 128 (b 1))) +
                  ((BitVec.setWidth 128 (b 2)) * (BitVec.setWidth 128 (a 2)))) +
                ((BitVec.setWidth 128 (b 3)) * (BitVec.setWidth 128 (a 1)))) +
              ((BitVec.setWidth 128 (a 4)) * (BitVec.setWidth 128 (b 0)))).uaddOverflow
          ((BitVec.setWidth 128 (b 4)) * (BitVec.setWidth 128 (a 0))) =
        false := by
  have z00 := zmul_lt (ha 0) (hb 0)
  have z01 := zmul_lt (ha 0) (hb 1)
  have z02 := zmul_lt (ha 0) (hb 2)
  have z03 := zmul_lt (ha 0) (hb 3)
  have z04 := zmul_lt (ha 0) (hb 4)
  have z10 := zmul_lt (ha 1) (hb 0)
  have z11 := zmul_lt (ha 1) (hb 1)
  have z12 := zmul_lt (ha 1) (hb 2)
  have z13 := zmul_lt (ha 1) (hb 3)
  have z14 := zmul_lt (ha 1) (hb 4)
  have z20 := zmul_lt (ha 2) (hb 0)
  have z21 := zmul_lt (ha 2) (hb 1)
  have z22 := zmul_lt (ha 2) (hb 2)
  have z23 := zmul_lt (ha 2) (hb 3)
  have z24 := zmul_lt (ha 2) (hb 4)
  have z30 := zmul_lt (ha 3) (hb 0)
  have z31 := zmul_lt (ha 3) (hb 1)
  have z32 := zmul_lt (ha 3) (hb 2)
  have z33 := zmul_lt (ha 3) (hb 3)
  have z34 := zmul_lt (ha 3) (hb 4)
  have z40 := zmul_lt (ha 4) (hb 0)
  have z41 := zmul_lt (ha 4) (hb 1)
  have z42 := zmul_lt (ha 4) (hb 2)
  have z43 := zmul_lt (ha 4) (hb 3)
  have z44 := zmul_lt (ha 4) (hb 4)
  have w10 := zmul19_lt (ha 1) (hb 0)
  have w11 := zmul19_lt (ha 1) (hb 1)
  have w12 := zmul19_lt (ha 1) (hb 2)
  have w13 := zmul19_lt (ha 1) (hb 3)
  have w14 := zmul19_lt (ha 1) (hb 4)
  have w20 := zmul19_lt (ha 2) (hb 0)
  have w21 := zmul19_lt (ha 2) (hb 1)
  have w22 := zmul19_lt (ha 2) (hb 2)
  have w23 := zmul19_lt (ha 2) (hb 3)
  have w24 := zmul19_lt (ha 2) (hb 4)
  have w30 := zmul19_lt (ha 3) (hb 0)
  have w31 := zmul19_lt (ha 3) (hb 1)
  have w32 := zmul19_lt (ha 3) (hb 2)
  have w33 := zmul19_lt (ha 3) (hb 3)
  have w34 := zmul19_lt (ha 3) (hb 4)
  have w40 := zmul19_lt (ha 4) (hb 0)
  have w41 := zmul19_lt (ha 4) (hb 1)
  have w42 := zmul19_lt (ha 4) (hb 2)
  have w43 := zmul19_lt (ha 4) (hb 3)
  have w44 := zmul19_lt (ha 4) (hb 4)
  have y00 := zmul_lt (hb 0) (ha 0)
  have y01 := zmul_lt (hb 1) (ha 0)
  have y02 := zmul_lt (hb 2) (ha 0)
  have y03 := zmul_lt (hb 3) (ha 0)
  have y04 := zmul_lt (hb 4) (ha 0)
  have y10 := zmul_lt (hb 0) (ha 1)
  have y11 := zmul_lt (hb 1) (ha 1)
  have y12 := zmul_lt (hb 2) (ha 1)
  have y13 := zmul_lt (hb 3) (ha 1)
  have y14 := zmul_lt (hb 4) (ha 1)
  have y20 := zmul_lt (hb 0) (ha 2)
  have y21 := zmul_lt (hb 1) (ha 2)
  have y22 := zmul_lt (hb 2) (ha 2)
  have y23 := zmul_lt (hb 3) (ha 2)
  have y24 := zmul_lt (hb 4) (ha 2)
  have y30 := zmul_lt (hb 0) (ha 3)
  have y31 := zmul_lt (hb 1) (ha 3)
  have y32 := zmul_lt (hb 2) (ha 3)
  have y33 := zmul_lt (hb 3) (ha 3)
  have y34 := zmul_lt (hb 4) (ha 3)
  have y40 := zmul_lt (hb 0) (ha 4)
  have y41 := zmul_lt (hb 1) (ha 4)
  have y42 := zmul_lt (hb 2) (ha 4)
  have y43 := zmul_lt (hb 3) (ha 4)
  have y44 := zmul_lt (hb 4) (ha 4)
  repeat' apply And.intro
  all_goals
    first
    | exact (zext_mul19_overflow _).1
    | exact (zext_mul19_overflow _).2
    | exact zmul_umul _ _
    | exact zmul19_umul (ha _) (hb _)
    | ( simp only [BitVec.uaddOverflow, decide_eq_false_iff_not, Nat.not_le, BitVec.toNat_add]
        omega)

/-- The columns, for limbs below `2^54`, are what `_carry128` takes. -/
theorem Fe.mul.cols_pre {a b : Fin 5 → BitVec 64} (ha : Fe.Lt a (2 ^ 54)) (hb : Fe.Lt b (2 ^ 54)) :
    Fe.carry128.Pre (Fe.mul.cols a b) := by
  have z00 := zmul_lt (ha 0) (hb 0)
  have z01 := zmul_lt (ha 0) (hb 1)
  have z02 := zmul_lt (ha 0) (hb 2)
  have z03 := zmul_lt (ha 0) (hb 3)
  have z04 := zmul_lt (ha 0) (hb 4)
  have z10 := zmul_lt (ha 1) (hb 0)
  have z11 := zmul_lt (ha 1) (hb 1)
  have z12 := zmul_lt (ha 1) (hb 2)
  have z13 := zmul_lt (ha 1) (hb 3)
  have z14 := zmul_lt (ha 1) (hb 4)
  have z20 := zmul_lt (ha 2) (hb 0)
  have z21 := zmul_lt (ha 2) (hb 1)
  have z22 := zmul_lt (ha 2) (hb 2)
  have z23 := zmul_lt (ha 2) (hb 3)
  have z24 := zmul_lt (ha 2) (hb 4)
  have z30 := zmul_lt (ha 3) (hb 0)
  have z31 := zmul_lt (ha 3) (hb 1)
  have z32 := zmul_lt (ha 3) (hb 2)
  have z33 := zmul_lt (ha 3) (hb 3)
  have z34 := zmul_lt (ha 3) (hb 4)
  have z40 := zmul_lt (ha 4) (hb 0)
  have z41 := zmul_lt (ha 4) (hb 1)
  have z42 := zmul_lt (ha 4) (hb 2)
  have z43 := zmul_lt (ha 4) (hb 3)
  have z44 := zmul_lt (ha 4) (hb 4)
  have w10 := zmul19_lt (ha 1) (hb 0)
  have w11 := zmul19_lt (ha 1) (hb 1)
  have w12 := zmul19_lt (ha 1) (hb 2)
  have w13 := zmul19_lt (ha 1) (hb 3)
  have w14 := zmul19_lt (ha 1) (hb 4)
  have w20 := zmul19_lt (ha 2) (hb 0)
  have w21 := zmul19_lt (ha 2) (hb 1)
  have w22 := zmul19_lt (ha 2) (hb 2)
  have w23 := zmul19_lt (ha 2) (hb 3)
  have w24 := zmul19_lt (ha 2) (hb 4)
  have w30 := zmul19_lt (ha 3) (hb 0)
  have w31 := zmul19_lt (ha 3) (hb 1)
  have w32 := zmul19_lt (ha 3) (hb 2)
  have w33 := zmul19_lt (ha 3) (hb 3)
  have w34 := zmul19_lt (ha 3) (hb 4)
  have w40 := zmul19_lt (ha 4) (hb 0)
  have w41 := zmul19_lt (ha 4) (hb 1)
  have w42 := zmul19_lt (ha 4) (hb 2)
  have w43 := zmul19_lt (ha 4) (hb 3)
  have w44 := zmul19_lt (ha 4) (hb 4)
  simp only [Fe.carry128.Pre, Fe.mul.cols, BitVec.toNat_add]
  omega

-- 92 steps over 128-bit products left unnamed, as the overflow facts spell them
set_option maxHeartbeats 500000 in
/-- `Fe.mul` stores `spec a b` at `out`, for limbs below `2^54`. -/
public theorem Fe_mul.call_eq (out a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsFit out) (ha : s.mem.LimbsFit a) (hb : s.mem.LimbsFit b)
    (ha' : Fe.Lt (s.mem.readLimbs a) (2 ^ 54)) (hb' : Fe.Lt (s.mem.readLimbs b) (2 ^ 54)) :
    Fe_mul.call (Fe_mul.args (.value out) (.value a) (.value b)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩,
            mem :=
              s.mem.storeLimbs out (Fe.mul.spec (s.mem.readLimbs a) (s.mem.readLimbs b)) }) := by
  func_init
  have ha₁ := hS ▸ ha'
  have hb₁ := hS ▸ hb'
  have hov := Fe.mul.noOverflow ha₁ hb₁
  have hpre := Fe.mul.cols_pre ha₁ hb₁
  simp only [MemoryState.readLimbs] at hov
  clear ha' hb' ha₁ hb₁
  block_init
  iterate 3 step_pure
  step_alloca with t
  step_alloca with r
  have htF₀ : Fits ((S₀.alloca 40).alloca 80).mem t 320 := hS ▸ ht_fits
  have ht_off' := ht_off
  limbs_fit t
  have hr_wide := MemoryState.WideFit.of_fits hr_fits hr_off
  have hrW₀ : ((S₀.alloca 40).alloca 80).mem.WideFit r := hS ▸ hr_wide
  clear hr_fits
  step_load
  step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 2 step_pure
  step_load
  iterate 2 step_pure
  step_load
  step_pure
  iterate 12 (step_pure [hov])
  step_pure [hov] with c0
  step_store
  step_pure
  iterate 8 (step_pure [hov])
  step_pure [hov] with c1
  step_store
  step_pure
  iterate 8 (step_pure [hov])
  step_pure [hov] with c2
  step_store
  step_pure
  iterate 8 (step_pure [hov])
  step_pure [hov] with c3
  step_store
  step_pure
  iterate 8 (step_pure [hov])
  step_pure [hov] with c4
  step_store
  -- the columns stored, in Zig's order
  have hcols :
    S.mem.readWide r =
      Fe.mul.cols (S₀.mem.readLimbs a) (S₀.mem.readLimbs b) := by
    rw [hS, MemoryState.readWide_stores hrW₀]
    funext i
    fin_cases i <;> simp only [Fe.mul.cols, MemoryState.readLimbs, hc0, hc1, hc2, hc3, hc4] <;> ring
  have hpre' : Fe.carry128.Pre (S.mem.readWide r) := hcols ▸ hpre
  clear hpre hcols
  step_call using Fe_carry128.call_eq consuming hpre'
  have hout320 := hout.fits
  have ht320 := ht_limbs.fits
  step_memcpy consuming hout320 ht320
  finish_block
  have hcv :
    (fun
        | ⟨0, _⟩ => c0
        | ⟨1, _⟩ => c1
        | ⟨2, _⟩ => c2
        | ⟨3, _⟩ => c3
        | ⟨4, _⟩ => c4 : Fin 5 → BitVec 128) =
      Fe.mul.cols (S₀.mem.readLimbs a) (S₀.mem.readLimbs b) := by
    funext i
    fin_cases i <;> simp only [Fe.mul.cols, MemoryState.readLimbs, hc0, hc1, hc2, hc3, hc4] <;> ring
  rw [hS, (MemoryState.readWide_stores hrW₀ c0 c1 c2 c3 c4).trans hcv,
    MemoryState.readAt_storeLimbs_self (by simpa using htF₀) (by simp [ht_off']), ←
    MemoryState.storeLimbs_eq_storeAt hout.1, Fe.mul.spec]
  erase_frame
  simp [GlobalState.alloca]

/-- `call_eq` on the limbs `A`, `B` read at `a`, `b`. -/
public theorem Fe_mul.call_eq_of (out a b : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsFit out) (ha : s.mem.LimbsFit a) (hb : s.mem.LimbsFit b)
    (hA : s.mem.readLimbs a = A) (hB : s.mem.readLimbs b = B) (hA' : Fe.Lt A (2 ^ 54))
    (hB' : Fe.Lt B (2 ^ 54)) :
    Fe_mul.call (Fe_mul.args (.value out) (.value a) (.value b)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩,
            mem := s.mem.storeLimbs out (Fe.mul.spec A B) }) := by
  subst hA hB
  exact Fe_mul.call_eq out a b s hwf hout ha hb hA' hB'

end Proof

end MLIR.Zig
