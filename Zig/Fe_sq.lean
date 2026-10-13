module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Zig.Fe_carry128
public import Zig.Mlir.Fe_sq
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

namespace MLIR.Zig

/-! ## Specification -/

@[expose] public section

/-- The five columns of `a²`, as `_sq` computes them, `double` false. -/
def Fe.sq.cols (a : Fin 5 → BitVec 64) : Fin 5 → BitVec 128 :=
  let ax (i : Fin 5) := (a i).setWidth 128
  let a0_2 := 2#128 * ax 0
  let a1_2 := 2#128 * ax 1
  let a1_38 := 38#128 * ax 1
  let a2_38 := 38#128 * ax 2
  let a3_38 := 38#128 * ax 3
  let a3_19 := 19#128 * ax 3
  let a4_19 := 19#128 * ax 4
  fun
  | ⟨0, _⟩ => ax 0 * ax 0 + a1_38 * ax 4 + a2_38 * ax 3
  | ⟨1, _⟩ => a0_2 * ax 1 + a2_38 * ax 4 + a3_19 * ax 3
  | ⟨2, _⟩ => a0_2 * ax 2 + ax 1 * ax 1 + a3_38 * ax 4
  | ⟨3, _⟩ => a0_2 * ax 3 + a1_2 * ax 2 + a4_19 * ax 4
  | ⟨4, _⟩ => a0_2 * ax 4 + a1_2 * ax 3 + ax 2 * ax 2

/-- `a²`, carried. -/
def Fe.sq.spec (a : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  Fe.carry128.spec (Fe.sq.cols a)

end

/-- `sq`'s limbs are below `2^52`. -/
public theorem Fe.sq.spec_lt (a : Fin 5 → BitVec 64) : Fe.Lt (Fe.sq.spec a) (2 ^ 52) :=
  Fe.carry128.spec_lt _

/-! ## Proof -/

section Proof

/-- No flagged operation of `Fe.sq` overflows, for limbs below `2^54`. -/
theorem Fe.sq.noOverflow {a : Fin 5 → BitVec 64} (ha : Fe.Lt a (2 ^ 54)) :
    (BitVec.setWidth 128 (a 2)).smulOverflow (38#128) = false ∧
      (BitVec.setWidth 128 (a 2)).umulOverflow (38#128) = false ∧
      (BitVec.setWidth 128 (a 3)).smulOverflow (19#128) = false ∧
      (BitVec.setWidth 128 (a 3)).umulOverflow (19#128) = false ∧
      (BitVec.setWidth 128 (a 4)).smulOverflow (19#128) = false ∧
      (BitVec.setWidth 128 (a 4)).umulOverflow (19#128) = false ∧
      (BitVec.setWidth 128 (a 0)).umulOverflow (BitVec.setWidth 128 (a 0)) = false ∧
      (BitVec.setWidth 128 (a 4)).smulOverflow (38#128) = false ∧
      (BitVec.setWidth 128 (a 4)).umulOverflow (38#128) = false ∧
      ((BitVec.setWidth 128 (a 2)) * (38#128)).umulOverflow (BitVec.setWidth 128 (a 3)) = false ∧
      (((BitVec.setWidth 128 (a 2)) * (38#128)) * (BitVec.setWidth 128 (a 3))).uaddOverflow
          ((BitVec.setWidth 128 (a 0)) * (BitVec.setWidth 128 (a 0))) =
        false ∧
      ((((BitVec.setWidth 128 (a 2)) * (38#128)) * (BitVec.setWidth 128 (a 3))) +
              ((BitVec.setWidth 128 (a 0)) * (BitVec.setWidth 128 (a 0)))).uaddOverflow
          (((BitVec.setWidth 128 (a 4)) * (38#128)) * (BitVec.setWidth 128 (a 1))) =
        false ∧
      ((BitVec.setWidth 128 (a 0)) <<< 1).umulOverflow (BitVec.setWidth 128 (a 1)) = false ∧
      ((BitVec.setWidth 128 (a 2)) * (38#128)).umulOverflow (BitVec.setWidth 128 (a 4)) = false ∧
      (((BitVec.setWidth 128 (a 2)) * (38#128)) * (BitVec.setWidth 128 (a 4))).uaddOverflow
          (((BitVec.setWidth 128 (a 0)) <<< 1) * (BitVec.setWidth 128 (a 1))) =
        false ∧
      ((BitVec.setWidth 128 (a 3)) * (19#128)).umulOverflow (BitVec.setWidth 128 (a 3)) = false ∧
      ((((BitVec.setWidth 128 (a 2)) * (38#128)) * (BitVec.setWidth 128 (a 4))) +
              (((BitVec.setWidth 128 (a 0)) <<< 1) * (BitVec.setWidth 128 (a 1)))).uaddOverflow
          (((BitVec.setWidth 128 (a 3)) * (19#128)) * (BitVec.setWidth 128 (a 3))) =
        false ∧
      ((BitVec.setWidth 128 (a 0)) <<< 1).umulOverflow (BitVec.setWidth 128 (a 2)) = false ∧
      (BitVec.setWidth 128 (a 1)).umulOverflow (BitVec.setWidth 128 (a 1)) = false ∧
      (((BitVec.setWidth 128 (a 0)) <<< 1) * (BitVec.setWidth 128 (a 2))).uaddOverflow
          ((BitVec.setWidth 128 (a 1)) * (BitVec.setWidth 128 (a 1))) =
        false ∧
      ((((BitVec.setWidth 128 (a 0)) <<< 1) * (BitVec.setWidth 128 (a 2))) +
              ((BitVec.setWidth 128 (a 1)) * (BitVec.setWidth 128 (a 1)))).uaddOverflow
          (((BitVec.setWidth 128 (a 4)) * (38#128)) * (BitVec.setWidth 128 (a 3))) =
        false ∧
      ((BitVec.setWidth 128 (a 0)) <<< 1).umulOverflow (BitVec.setWidth 128 (a 3)) = false ∧
      ((BitVec.setWidth 128 (a 1)) <<< 1).umulOverflow (BitVec.setWidth 128 (a 2)) = false ∧
      (((BitVec.setWidth 128 (a 0)) <<< 1) * (BitVec.setWidth 128 (a 3))).uaddOverflow
          (((BitVec.setWidth 128 (a 1)) <<< 1) * (BitVec.setWidth 128 (a 2))) =
        false ∧
      ((BitVec.setWidth 128 (a 4)) * (19#128)).umulOverflow (BitVec.setWidth 128 (a 4)) = false ∧
      ((((BitVec.setWidth 128 (a 0)) <<< 1) * (BitVec.setWidth 128 (a 3))) +
              (((BitVec.setWidth 128 (a 1)) <<< 1) * (BitVec.setWidth 128 (a 2)))).uaddOverflow
          (((BitVec.setWidth 128 (a 4)) * (19#128)) * (BitVec.setWidth 128 (a 4))) =
        false ∧
      ((BitVec.setWidth 128 (a 0)) <<< 1).umulOverflow (BitVec.setWidth 128 (a 4)) = false ∧
      ((BitVec.setWidth 128 (a 1)) <<< 1).umulOverflow (BitVec.setWidth 128 (a 3)) = false ∧
      (BitVec.setWidth 128 (a 2)).umulOverflow (BitVec.setWidth 128 (a 2)) = false ∧
      (((BitVec.setWidth 128 (a 1)) <<< 1) * (BitVec.setWidth 128 (a 3))).uaddOverflow
          ((BitVec.setWidth 128 (a 2)) * (BitVec.setWidth 128 (a 2))) =
        false ∧
      ((((BitVec.setWidth 128 (a 1)) <<< 1) * (BitVec.setWidth 128 (a 3))) +
              ((BitVec.setWidth 128 (a 2)) * (BitVec.setWidth 128 (a 2)))).uaddOverflow
          (((BitVec.setWidth 128 (a 0)) <<< 1) * (BitVec.setWidth 128 (a 4))) =
        false := by
  have p0 := zmul_lt (ha 0) (ha 0)
  have p1 := (zmulk_lt (k := 38) (by norm_num) (by norm_num) (ha 4) (ha 1)).1
  have p2 := (zmulk_lt (k := 38) (by norm_num) (by norm_num) (ha 2) (ha 3)).1
  have p3 := (zshl_lt (ha 0) (ha 1)).1
  have p4 := (zmulk_lt (k := 38) (by norm_num) (by norm_num) (ha 2) (ha 4)).1
  have p5 := (zmulk_lt (k := 19) (by norm_num) (by norm_num) (ha 3) (ha 3)).1
  have p6 := (zshl_lt (ha 0) (ha 2)).1
  have p7 := zmul_lt (ha 1) (ha 1)
  have p8 := (zmulk_lt (k := 38) (by norm_num) (by norm_num) (ha 4) (ha 3)).1
  have p9 := (zshl_lt (ha 0) (ha 3)).1
  have p10 := (zshl_lt (ha 1) (ha 2)).1
  have p11 := (zmulk_lt (k := 19) (by norm_num) (by norm_num) (ha 4) (ha 4)).1
  have p12 := (zshl_lt (ha 0) (ha 4)).1
  have p13 := (zshl_lt (ha 1) (ha 3)).1
  have p14 := zmul_lt (ha 2) (ha 2)
  repeat' apply And.intro
  all_goals
    first
    | exact (zext_mulk_overflow _ (by norm_num)).1
    | exact (zext_mulk_overflow _ (by norm_num)).2
    | exact zmul_umul _ _
    | exact zmulk_lt (by norm_num) (by norm_num) (ha _) (ha _) |>.2
    | exact zshl_lt (ha _) (ha _) |>.2
    | ( simp only [BitVec.uaddOverflow, decide_eq_false_iff_not, Nat.not_le, BitVec.toNat_add]
        omega)

/-- The columns, for limbs below `2^54`, are what `_carry128` takes. -/
theorem Fe.sq.cols_pre {a : Fin 5 → BitVec 64} (ha : Fe.Lt a (2 ^ 54)) :
    Fe.carry128.Pre (Fe.sq.cols a) := by
  have e (i j : Fin 5) (k : ℕ) (hk : 0 < k) (hk' : k < 2 ^ 19) :
    (BitVec.ofNat 128 k * BitVec.setWidth 128 (a i) * BitVec.setWidth 128 (a j)).toNat <
      k * 2 ^ 108 := by
    rw [show
        BitVec.ofNat 128 k * BitVec.setWidth 128 (a i) =
          BitVec.setWidth 128 (a i) * BitVec.ofNat 128 k
        by ring]
    exact (zmulk_lt hk hk' (ha i) (ha j)).1
  have p0 := zmul_lt (ha 0) (ha 0)
  have p7 := zmul_lt (ha 1) (ha 1)
  have p14 := zmul_lt (ha 2) (ha 2)
  simp only [Fe.carry128.Pre, Fe.sq.cols, BitVec.toNat_add]
  have := e 1 4 38 (by norm_num) (by norm_num)
  have := e 2 3 38 (by norm_num) (by norm_num)
  have := e 2 4 38 (by norm_num) (by norm_num)
  have := e 3 3 19 (by norm_num) (by norm_num)
  have := e 3 4 38 (by norm_num) (by norm_num)
  have := e 4 4 19 (by norm_num) (by norm_num)
  have := e 0 1 2 (by norm_num) (by norm_num)
  have := e 0 2 2 (by norm_num) (by norm_num)
  have := e 0 3 2 (by norm_num) (by norm_num)
  have := e 0 4 2 (by norm_num) (by norm_num)
  have := e 1 2 2 (by norm_num) (by norm_num)
  have := e 1 3 2 (by norm_num) (by norm_num)
  omega

/-- `Fe.sq` stores `spec a` at `out`, for limbs below `2^54`. -/
public theorem Fe_sq.call_eq (out a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (ha : s.mem.LimbsFit a)
    (ha' : Fe.Lt (s.mem.readLimbs a) (2 ^ 54)) :
    Fe_sq.call (Fe_sq.args (.value out) (.value a)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩,
            mem := s.mem.storeLimbs out (Fe.sq.spec (s.mem.readLimbs a)) }) := by
  func_init
  have hoa : out.offset.toNat + 32 < 2 ^ 64 := hout.1
  have ha₁ := hS ▸ ha'
  have hpre := Fe.sq.cols_pre ha₁
  clear ha'
  block_init
  iterate 5 step_pure
  step_alloca with r
  step_alloca with t
  limbs_room t
  step_pure
  have hr_wide := MemoryState.WideRoom.of_room hroom_r hr_off
  have hrW₀ := hS ▸ hr_wide
  clear hroom_r
  step_load with a0
  step_pure
  step_pure
  step_load with a1
  step_pure
  step_pure
  step_load with a2
  step_pure
  step_pure
  step_load with a3
  step_pure
  step_pure
  step_load with a4
  step_pure
  have hA : Fe.Lt (Fe.mk5 a0 a1 a2 a3 a4) (2 ^ 54) := by
    intro i
    fin_cases i
    · simp only [Fe.mk5, ha0]; exact ha₁ 0
    · simp only [Fe.mk5, ha1]; exact ha₁ 1
    · simp only [Fe.mk5, ha2]; exact ha₁ 2
    · simp only [Fe.mk5, ha3]; exact ha₁ 3
    · simp only [Fe.mk5, ha4]; exact ha₁ 4
  have hov := Fe.sq.noOverflow hA
  simp only [Fe.mk5] at hov
  clear hA ha₁
  iterate 10 (step_pure [hov, zext_shl1])
  step_pure [hov] with c0
  step_store
  step_pure
  iterate 4 (step_pure [hov, zext_shl1])
  step_pure [hov] with c1
  step_store
  step_pure
  iterate 4 (step_pure [hov, zext_shl1])
  step_pure [hov] with c2
  step_store
  step_pure
  iterate 4 (step_pure [hov, zext_shl1])
  step_pure [hov] with c3
  step_store
  step_pure
  iterate 4 (step_pure [hov, zext_shl1])
  step_pure [hov] with c4
  step_store
  -- the columns stored, in Zig's order
  have hcv :
    (fun
        | ⟨0, _⟩ => c0
        | ⟨1, _⟩ => c1
        | ⟨2, _⟩ => c2
        | ⟨3, _⟩ => c3
        | ⟨4, _⟩ => c4 : Fin 5 → BitVec 128) =
      Fe.sq.cols (S₀.mem.readLimbs a) := by
    funext i
    fin_cases i <;>
      simp only [Fe.sq.cols, MemoryState.readLimbs, hc0, hc1, hc2, hc3, hc4, ha0, ha1, ha2, ha3,
        ha4, shl1_eq] <;>
      ring
  have hpre' : Fe.carry128.Pre (S.mem.readWide r) := by
    rw [hS, (MemoryState.readWide_stores hrW₀ c0 c1 c2 c3 c4).trans hcv]
    exact hpre
  have hrF : S.mem.WideFit r := by
    rw [hS]; exact MemoryState.WideFit.stores hrW₀ _ _ _ _ _
  clear hpre
  step_call using Fe_carry128.call_eq consuming hpre'
  have htm := hS ▸ ht_limbs
  have htr := hS ▸ hread_t_readLimbs
  step_pure
  have hout320 := hout.room320
  have ht320 := ht_limbs.fits
  step_memcpy consuming hout320 ht320
  finish_block
  rw [hS]
  dsimp only
  rw [MemoryState.storeAt_readAt_eq_storeLimbs htm hoa, htr,
    (MemoryState.readWide_stores hrW₀ c0 c1 c2 c3 c4).trans hcv]
  erase_frame
  simp [GlobalState.alloca, Fe.sq.spec]

/-- `call_eq` on the limbs `A` read at `a`. -/
public theorem Fe_sq.call_eq_of (out a : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (ha : s.mem.LimbsFit a) (hA : s.mem.readLimbs a = A)
    (hA' : Fe.Lt A (2 ^ 54)) :
    Fe_sq.call (Fe_sq.args (.value out) (.value a)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 2⟩,
            mem := s.mem.storeLimbs out (Fe.sq.spec A) }) := by
  subst hA
  exact Fe_sq.call_eq out a s hwf hout ha hA'

end Proof

end MLIR.Zig
