module

public import MLIR.Run.Tactic
public import Common.LimbsBits
public import Common.Tactics
public import Zig.Point
public import Zig.Fe_add
public import Zig.Fe_sub
public import Zig.Fe_mul
public import Zig.Fe_sq
public import Zig.Steps
public import Zig.Mlir.Edwards25519_dbl
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

namespace MLIR.Zig

/-! ## Specification -/

@[expose] public section

/-- `2a²`, carried: `sq`'s columns doubled. -/
def Fe.sq2.spec (a : Fin 5 → BitVec 64) : Fin 5 → BitVec 64 :=
  Fe.carry128.spec fun i => Fe.sq.cols a i <<< 1

/-- `2P`, extended coordinates; in the program's operand order. -/
def Edwards25519.dbl.spec (P : ZPt) : ZPt :=
  let t0 := Fe.sq.spec (Fe.add.spec P.x P.y)
  let x := Fe.sq.spec P.x
  let z := Fe.sq.spec P.y
  let y := Fe.add.spec z x
  let z := Fe.sub.spec z x
  let x := Fe.sub.spec t0 y
  let t := Fe.sub.spec (Fe.sq2.spec P.z) z
  ⟨Fe.mul.spec x t, Fe.mul.spec y z, Fe.mul.spec z t, Fe.mul.spec x y⟩

end

/-- `2P`'s limbs are below `2^52`. -/
public theorem Edwards25519.dbl.spec_lt (P : ZPt) : (Edwards25519.dbl.spec P).Lt (2 ^ 52) :=
  ⟨Fe.mul.spec_lt _ _, Fe.mul.spec_lt _ _, Fe.mul.spec_lt _ _, Fe.mul.spec_lt _ _⟩

/-! ## Proof -/

section Proof

/-- A product of limbs below `2^53` is below `2^106`. -/
theorem zmul_lt53 {x y : BitVec 64} (hx : x.toNat < 2 ^ 53) (hy : y.toNat < 2 ^ 53) :
    (BitVec.setWidth 128 x * BitVec.setWidth 128 y).toNat < 2 ^ 106 := by
  have := Nat.mul_lt_mul'' hx hy
  rw [BitVec.toNat_mul, toNat_zext, toNat_zext]
  omega

/-- With a factor `k`, below `k · 2^106`. -/
theorem zmulk_lt53 {x y : BitVec 64} {k : Nat} (hk0 : 0 < k) (hk : k < 2 ^ 19)
    (hx : x.toNat < 2 ^ 53) (hy : y.toNat < 2 ^ 53) :
    (BitVec.ofNat 128 k * BitVec.setWidth 128 x * BitVec.setWidth 128 y).toNat < k * 2 ^ 106 := by
  have hxy := Nat.mul_lt_mul'' hx hy
  have hkn : (BitVec.ofNat 128 k).toNat = k := by
    simp; omega
  have hkx : k * x.toNat < 2 ^ 128 := by
    have := Nat.mul_lt_mul'' hk hx; omega
  have hkxy : k * (x.toNat * y.toNat) < k * 2 ^ 106 := Nat.mul_lt_mul_of_pos_left (by omega) hk0
  rw [BitVec.toNat_mul, BitVec.toNat_mul, hkn, toNat_zext, toNat_zext, Nat.mod_eq_of_lt hkx,
    Nat.mul_assoc, Nat.mod_eq_of_lt (by omega)]
  exact hkxy

/-- `sq`'s columns, for limbs below `2^53`: below `77 · 2^106`, the last below `5 · 2^106`. -/
theorem Fe.sq.cols_lt {a : Fin 5 → BitVec 64} (ha : Fe.Lt a (2 ^ 53)) :
    (∀ i, (Fe.sq.cols a i).toNat < 77 * 2 ^ 106) ∧ (Fe.sq.cols a 4).toNat < 5 * 2 ^ 106 := by
  have e (i j : Fin 5) (k : ℕ) (hk : 0 < k) (hk' : k < 2 ^ 19) := zmulk_lt53 hk hk' (ha i) (ha j)
  have := zmul_lt53 (ha 0) (ha 0)
  have := zmul_lt53 (ha 1) (ha 1)
  have := zmul_lt53 (ha 2) (ha 2)
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
  refine ⟨fun i => ?_, ?_⟩
  · fin_cases i <;> simp only [Fe.sq.cols, BitVec.toNat_add] <;> omega
  · simp only [Fe.sq.cols, BitVec.toNat_add]; omega

/-- A column below `2^127` doubled by a shift. -/
theorem shl1_toNat128 {x : BitVec 128} (h : x.toNat < 2 ^ 127) : (x <<< 1).toNat = 2 * x.toNat := by
  simp only [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq]
  rw [Nat.mod_eq_of_lt (by omega)]; omega

/-- A `shl nuw` by one of a column below `2^127` does not overflow. -/
theorem shl1_shr1_128 {x : BitVec 128} (h : x.toNat < 2 ^ 127) : x <<< 1 >>> 1 = x := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_ushiftRight, shl1_toNat128 h, Nat.shiftRight_eq_div_pow]; omega

/-- The doubled columns, for limbs below `2^53`, are what `_carry128` takes. -/
theorem Fe.sq2.cols_pre {a : Fin 5 → BitVec 64} (ha : Fe.Lt a (2 ^ 53)) :
    Fe.carry128.Pre fun i => Fe.sq.cols a i <<< 1 := by
  obtain ⟨h, h4⟩ := Fe.sq.cols_lt ha
  have e (i : Fin 5) := shl1_toNat128 (Nat.lt_trans (h i) (by norm_num))
  simp only [Fe.carry128.Pre, e]
  have := h 0; have := h 1; have := h 2; have := h 3
  omega

/-- No flagged operation of `sq`'s columns overflows, for limbs below `2^54`. -/
theorem Fe.sq2.noOverflow {a : Fin 5 → BitVec 64} (ha : Fe.Lt a (2 ^ 54)) :
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

/-- `_carry128` on the columns `R` read at `r`, its write-back as stores. -/
theorem Fe_carry128.call_eq_of (out r : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsFit out) (hr : s.mem.WideFit r) (hR : s.mem.readWide r = R)
    (hpre : Fe.carry128.Pre R) :
    Fe_carry128.call (Fe_carry128.args (.value out) (.value r)) s =
      .value
        (.nil,
          { s with
            mem :=
              ((((s.mem.storeAt (r.add 16#64) (Fe.carry128.wide R 1)).storeAt (r.add 32#64)
                            (Fe.carry128.wide R 2)).storeAt
                        (r.add 48#64) (Fe.carry128.wide R 3)).storeAt
                    (r.add 64#64) (Fe.carry128.wide R 4)).storeLimbs
                out (Fe.carry128.spec R) }) := by
  subst hR
  exact Fe_carry128.call_eq out r s hwf hout hr hpre

set_option maxHeartbeats 2000000 in
/-- `Edwards25519.dbl` stores `spec P` at `out`, `is_base` false, for `x, y, z` below `2^53`; `out`
may be `p`. -/
public theorem Edwards25519_dbl.call_eq (out p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.PtFit out) (hp : s.mem.PtFit p) (hX : Fe.Lt (s.mem.readPt p).x (2 ^ 53))
    (hY : Fe.Lt (s.mem.readPt p).y (2 ^ 53)) (hZ : Fe.Lt (s.mem.readPt p).z (2 ^ 53)) :
    Edwards25519_dbl.call (Edwards25519_dbl.args (.value out) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 28⟩,
            mem :=
              s.mem.storePt out (Edwards25519.dbl.spec (s.mem.readPt p))
                (ZPt.flag (s.mem.readRest out) 0#1) }) := by
  func_init
  generalize hPd : S.mem.readPt p = P at hX hY hZ
  have hp₀ : S₀.mem.PtFit p := hS ▸ hp
  have hout₀ : S₀.mem.PtFit out := hS ▸ hout
  have hrp :
    S.mem.readLimbs p = P.x ∧
      S.mem.readLimbs (p.add 40#64) = P.y ∧ S.mem.readLimbs (p.add 80#64) = P.z := by
    subst hPd; exact ⟨rfl, rfl, rfl⟩
  obtain ⟨hread_px, hread_py, hread_pz⟩ := hrp
  have hP₀ : S₀.mem.readPt p = P := hS ▸ hPd
  clear hPd
  block_init
  iterate 7 step_pure
  step_alloca with r
  step_alloca with ot
  limbs_fit ot
  step_alloca with oz
  limbs_fit oz
  step_alloca with oy
  limbs_fit oy
  step_alloca with ox
  limbs_fit ox
  step_alloca with t
  limbs_fit t
  step_alloca with w
  limbs_fit w
  step_alloca with zz
  limbs_fit zz
  step_alloca with y
  limbs_fit y
  step_alloca with z
  limbs_fit z
  step_alloca with x
  limbs_fit x
  step_alloca with t0
  limbs_fit t0
  step_alloca with xy
  limbs_fit xy
  step_alloca with pc
  have hpcP := MemoryState.PtFit.of_fits hpc_fits hpc_off
  have hr_wide := MemoryState.WideFit.of_fits hr_fits hr_off
  clear hpc_fits hr_fits
  have hf := hp.2
  step_memcpy consuming hf
  have hpc_eq : S.mem.readPt pc = P := by
    have h2 := hpcP
    rw [hS] at h2 ⊢
    exact (MemoryState.readPt_storeAt_readAt hp₀ ⟨h2.1, Fits.storeAt_iff.mp h2.2⟩).1.trans hP₀
  have hread_pcy : S.mem.readLimbs (pc.add 40#64) = P.y := congrArg ZPt.y hpc_eq
  have hread_pcz : S.mem.readLimbs (pc.add 80#64) = P.z := congrArg ZPt.z hpc_eq
  clear hpc_eq hread_pc
  -- t0 = (x + y)²
  step_pure
  have h1 := hX.mono (show 2 ^ 53 ≤ 2 ^ 63 by decide)
  have h2 := hY.mono (show 2 ^ 53 ≤ 2 ^ 63 by decide)
  step_call using Fe_add.call_eq_of consuming h1 h2
  have h1 := (Fe.add.spec_lt hX hY (by decide)).mono (show 2 ^ 53 + 2 ^ 53 ≤ 2 ^ 54 by decide)
  step_call using Fe_sq.call_eq_of consuming h1
  -- x², y²
  have h1 := hX.mono (show 2 ^ 53 ≤ 2 ^ 54 by decide)
  step_call using Fe_sq.call_eq_of consuming h1
  step_pure
  have h1 := hY.mono (show 2 ^ 53 ≤ 2 ^ 54 by decide)
  step_call using Fe_sq.call_eq_of consuming h1
  -- y = z + x, inline
  have hX2 := Fe.sq.spec_lt P.x
  have hY2 := Fe.sq.spec_lt P.y
  have hyo (i : Fin 5) : (Fe.sq.spec P.x i).uaddOverflow (Fe.sq.spec P.y i) = false :=
    uaddOverflow_eq_false
      (by
        have := hX2 i; have := hY2 i; omega)
  step_load
  step_load with ux0
  fix_load ux0 hux0(congrFun hread_x_readLimbs 0 : S.mem.readAt x 64 = _)
  step_pure [hyo 0]
  step_pure
  step_load with uz1
  fix_load uz1 huz1 hread_z_8
  step_pure
  step_load with ux1
  fix_load ux1 hux1(congrFun hread_x_readLimbs 1 : S.mem.readAt (x.add 8#64) 64 = _)
  step_pure [hyo 1]
  step_pure
  step_load with uz2
  fix_load uz2 huz2 hread_z_16
  step_pure
  step_load with ux2
  fix_load ux2 hux2(congrFun hread_x_readLimbs 2 : S.mem.readAt (x.add 16#64) 64 = _)
  step_pure [hyo 2]
  step_pure
  step_load with uz3
  fix_load uz3 huz3 hread_z_24
  step_pure
  step_load with ux3
  fix_load ux3 hux3(congrFun hread_x_readLimbs 3 : S.mem.readAt (x.add 24#64) 64 = _)
  step_pure [hyo 3]
  step_pure
  step_load with uz4
  fix_load uz4 huz4 hread_z_32
  step_pure
  step_load with ux4
  fix_load ux4 hux4(congrFun hread_x_readLimbs 4 : S.mem.readAt (x.add 32#64) 64 = _)
  step_pure [hyo 4]
  step_store
  iterate 4 
    step_pure
    step_store
  read_stores y, Fe.add.spec (Fe.sq.spec P.y) (Fe.sq.spec P.x) with hread_yv
  have hYv := Fe.add.spec_lt hY2 hX2 (by decide)
  -- z = z - x; x = t0 - y
  have h1 := hY2.mono (show 2 ^ 52 ≤ 2 ^ 63 by decide)
  have h2 := hX2.mono (show 2 ^ 52 ≤ 2 ^ 63 by decide)
  step_call using Fe_sub.call_eq_of consuming h1 h2
  have h1 := (Fe.sq.spec_lt (Fe.add.spec P.x P.y)).mono (show 2 ^ 52 ≤ 2 ^ 63 by decide)
  have h2 := hYv.mono (show 2 ^ 52 + 2 ^ 52 ≤ 2 ^ 63 by decide)
  step_call using Fe_sub.call_eq_of consuming h1 h2
  -- 2 z², its columns inline
  have hov := Fe.sq2.noOverflow (hZ.mono (show 2 ^ 53 ≤ 2 ^ 54 by decide))
  have hz0 : S.mem.readAt (pc.add 80#64) 64 = P.z 0 := congrFun hread_pcz 0
  have hz1 : S.mem.readAt (pc.add 88#64) 64 = P.z 1 := by
    rw [← congrFun hread_pcz 1];
    simp only [MemoryState.readLimbs, Pointer.add_add, BitVec.reduceAdd]
  have hz2 : S.mem.readAt (pc.add 96#64) 64 = P.z 2 := by
    rw [← congrFun hread_pcz 2];
    simp only [MemoryState.readLimbs, Pointer.add_add, BitVec.reduceAdd]
  have hz3 : S.mem.readAt (pc.add 104#64) 64 = P.z 3 := by
    rw [← congrFun hread_pcz 3];
    simp only [MemoryState.readLimbs, Pointer.add_add, BitVec.reduceAdd]
  have hz4 : S.mem.readAt (pc.add 112#64) 64 = P.z 4 := by
    rw [← congrFun hread_pcz 4];
    simp only [MemoryState.readLimbs, Pointer.add_add, BitVec.reduceAdd]
  step_pure
  step_pure
  step_load with v0
  fix_load v0 hv0 hz0
  step_pure
  step_pure
  step_load with v1
  fix_load v1 hv1 hz1
  step_pure
  step_pure
  step_load with v2
  fix_load v2 hv2 hz2
  step_pure
  step_pure
  step_load with v3
  fix_load v3 hv3 hz3
  step_pure
  step_pure
  step_load with v4
  fix_load v4 hv4 hz4
  step_pure
  iterate 10 (step_pure [hov, zext_shl1])
  step_pure [hov] with c0
  step_pure
  iterate 4 (step_pure [hov, zext_shl1])
  step_pure [hov] with c1
  step_pure
  iterate 4 (step_pure [hov, zext_shl1])
  step_pure [hov] with c2
  step_pure
  iterate 4 (step_pure [hov, zext_shl1])
  step_pure [hov] with c3
  step_pure
  iterate 4 (step_pure [hov, zext_shl1])
  step_pure [hov] with c4
  clear hov
  have hcol0 : c0 = Fe.sq.cols P.z 0 := by
    rw [hc0]; simp only [Fe.sq.cols]; ring
  have hcol1 : c1 = Fe.sq.cols P.z 1 := by
    rw [hc1]; simp only [Fe.sq.cols, shl1_eq]; ring
  have hcol2 : c2 = Fe.sq.cols P.z 2 := by
    rw [hc2]; simp only [Fe.sq.cols, shl1_eq]; ring
  have hcol3 : c3 = Fe.sq.cols P.z 3 := by
    rw [hc3]; simp only [Fe.sq.cols, shl1_eq]; ring
  have hcol4 : c4 = Fe.sq.cols P.z 4 := by
    rw [hc4]; simp only [Fe.sq.cols, shl1_eq]; ring
  clear hc0 hc1 hc2 hc3 hc4
  subst hcol0 hcol1 hcol2 hcol3 hcol4
  have hsh (i : Fin 5) : Fe.sq.cols P.z i <<< 1 >>> 1 = Fe.sq.cols P.z i :=
    shl1_shr1_128 (Nat.lt_trans ((Fe.sq.cols_lt hZ).1 i) (by norm_num))
  have hrW := hr_wide
  rw [hS] at hrW
  step_pure [hsh 0]
  step_store
  step_pure [hsh 1]
  step_store
  step_pure [hsh 2]
  step_store
  step_pure [hsh 3]
  step_store
  step_pure [hsh 4]
  step_store
  have hR : S.mem.readWide r = fun i => Fe.sq.cols P.z i <<< 1 := by
    rw [hS, MemoryState.readWide_stores hrW]
    funext i; fin_cases i <;> rfl
  have hpre := Fe.sq2.cols_pre hZ
  step_call using Fe_carry128.call_eq_of consuming hR hpre
  step_pure
  -- t = 2 z² - z
  have hW := Fe.carry128.spec_lt fun i => Fe.sq.cols P.z i <<< 1
  have hZZ := Fe.sub.spec_lt (b := Fe.sq.spec P.x) hY2 (by decide)
  have hXX :=
    Fe.sub.spec_lt (b := Fe.add.spec (Fe.sq.spec P.y) (Fe.sq.spec P.x))
      (Fe.sq.spec_lt (Fe.add.spec P.x P.y)) (by decide)
  have hT := Fe.sub.spec_lt (b := Fe.sub.spec (Fe.sq.spec P.y) (Fe.sq.spec P.x)) hW (by decide)
  have h1 := hW.mono (show 2 ^ 52 ≤ 2 ^ 63 by decide)
  have h2 := hZZ.mono (show 2 ^ 52 + 2 ^ 52 ≤ 2 ^ 63 by decide)
  step_call using Fe_sub.call_eq_of consuming h1 h2
  -- the outputs
  have h1 := hXX.mono (show 2 ^ 52 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  have h2 := hT.mono (show 2 ^ 52 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  step_call using Fe_mul.call_eq_of consuming h1 h2
  have f1 := hout.limbsFit_x.fits
  have f2 := hox_limbs.fits
  have hv := MemoryState.readAt_eq_limbsBits hox_limbs.fits hox_limbs.1
  step_memcpy consuming f1 f2 hv
  step_pure
  have h1 := hYv.mono (show 2 ^ 52 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  have h2 := hZZ.mono (show 2 ^ 52 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  step_call using Fe_mul.call_eq_of consuming h1 h2
  have f1 := hout.limbsFit_y.fits
  have f2 := hoy_limbs.fits
  have hv := MemoryState.readAt_eq_limbsBits hoy_limbs.fits hoy_limbs.1
  step_memcpy consuming f1 f2 hv
  step_pure
  have h1 := hZZ.mono (show 2 ^ 52 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  have h2 := hT.mono (show 2 ^ 52 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  step_call using Fe_mul.call_eq_of consuming h1 h2
  have f1 := hout.limbsFit_z.fits
  have f2 := hoz_limbs.fits
  have hv := MemoryState.readAt_eq_limbsBits hoz_limbs.fits hoz_limbs.1
  step_memcpy consuming f1 f2 hv
  step_pure
  have h1 := hXX.mono (show 2 ^ 52 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  have h2 := hYv.mono (show 2 ^ 52 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  step_call using Fe_mul.call_eq_of consuming h1 h2
  have f1 := hout.limbsFit_t.fits
  have f2 := hot_limbs.fits
  have hv := MemoryState.readAt_eq_limbsBits hot_limbs.fits hot_limbs.1
  step_memcpy consuming f1 f2 hv
  step_pure
  have f1 := hout.fits_rest.mono (show 1 ≤ 64 by omega)
  step_store consuming f1
  finish_block
  rw [hS]
  erase_frame
  rw [MemoryState.storeAt_fields_eq hout₀, hP₀]
  simp [GlobalState.alloca, Edwards25519.dbl.spec, Fe.sq2.spec]

/-- `call_eq` on the point `P` read at `p`. -/
public theorem Edwards25519_dbl.call_eq_of (out p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.PtFit out) (hp : s.mem.PtFit p) (hPd : s.mem.readPt p = P)
    (hX : Fe.Lt P.x (2 ^ 53)) (hY : Fe.Lt P.y (2 ^ 53)) (hZ : Fe.Lt P.z (2 ^ 53)) :
    Edwards25519_dbl.call (Edwards25519_dbl.args (.value out) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 28⟩,
            mem :=
              s.mem.storePt out (Edwards25519.dbl.spec P)
                (ZPt.flag (s.mem.readRest out) 0#1) }) := by
  subst hPd
  exact Edwards25519_dbl.call_eq out p s hwf hout hp hX hY hZ

end Proof

end MLIR.Zig
