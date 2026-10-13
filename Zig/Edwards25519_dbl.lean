module

public import MLIR.Run.Tactic
public import Firedancer.Common.Tactics
public import Zig.Common.PointCopy
public import Zig.Fe_add
public import Zig.Fe_sub
public import Zig.Fe_mul
public import Zig.Fe_sq
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

set_option hygiene false in
/-- `hS` kept reversed as `hck`: later states build on an opaque `S`, not on its frame's layers. -/
local macro "checkpoint " hck:ident : tactic => `(tactic| (have $hck:ident := hS.symm; clear hS))

set_option hygiene false in
/-- Drop a dead temporary's facts: its limbs' reads and its fit. -/
local macro "drop " x:ident : tactic => do
  let n := x.getId.toString
  let h (s : String) := Lean.mkIdent (.mkSimple s!"hread_{n}{s}")
  `(tactic|
      ( try clear $(h "_readLimbs")
        try clear $(h "")
        try clear $(h "_8")
        try clear $(h "_16")
        try clear $(h "_24")
        try clear $(h "_32")
        clear_facts $x:ident))

set_option hygiene false in
/-- `step_load` by the read fact `h`, with the load's `Fits` from `r` in the width the step states
(`mem_fact` misses it inside a limbs fact). -/
local macro "load_by " h:ident r:term:max : tactic =>
  `(tactic|
    ( have hl : Fits _ _ (Ty.bv 64).width := $r
      step_load [$h:ident] consuming $h:ident hl))

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

/-- `_carry128` on the columns `R` read at `r`. -/
theorem Fe_carry128.call_eq_of (out r : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.LimbsRoom out) (hr : s.mem.WideFit r) (hrw : Writable s.mem r)
    (hR : s.mem.readWide r = R) (hpre : Fe.carry128.Pre R) :
    Fe_carry128.call (Fe_carry128.args (.value out) (.value r)) s =
      .value
        (.nil,
          { s with
            mem :=
              (s.mem.storeWideTail r (Fe.carry128.wide R)).storeLimbs out
                (Fe.carry128.spec R) }) := by
  subst hR
  exact Fe_carry128.call_eq out r s hwf hout hr hrw hpre

-- one 140-instruction block: 14 slots, 13 calls, 15 loads, each step carrying the facts
set_option maxHeartbeats 3000000 in
/-- `Edwards25519.dbl` stores `spec P` at `out`, `is_base` false, for `x, y, z` below `2^53`. It
reads `p` before writing `out`, so `out` may be `p`. -/
public theorem Edwards25519_dbl.call_eq (out p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.PtRoom out) (hp : s.mem.PtLimbsFit p) (hX : Fe.Lt (s.mem.readPt p).x (2 ^ 53))
    (hY : Fe.Lt (s.mem.readPt p).y (2 ^ 53)) (hZ : Fe.Lt (s.mem.readPt p).z (2 ^ 53)) :
    Edwards25519_dbl.call (Edwards25519_dbl.args (.value out) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 28⟩,
            mem := s.mem.storePt out (Edwards25519.dbl.spec (s.mem.readPt p)) 0#1 }) := by
  func_init
  generalize hPd : S.mem.readPt p = P at hX hY hZ
  have hP₀ : S₀.mem.readPt p = P := hS ▸ hPd
  have ho := hout.1
  block_init
  iterate 7 step_pure
  step_alloca with r
  step_alloca with ot
  step_alloca with oz
  step_alloca with oy
  step_alloca with ox
  step_alloca with t
  step_alloca with w
  step_alloca with zz
  step_alloca with y
  step_alloca with z
  step_alloca with x
  step_alloca with t0
  step_alloca with xy
  step_alloca with pc
  checkpoint hck1
  have hpcR := MemoryState.PtRoom.of_room hpc_room hpc_off
  step_memcpy
  have hread_pcz : S.mem.readLimbs (pc.add 80#64) = P.z := by
    rw [← hread_pc_readPt]; rfl
  have hfz := hptLimbsFit_pc.limbsFit_z
  clear hfits_pc hread_pc_readAt hread_pc_readLimbs hread_pc hpc_room
  have hread_px : S.mem.readLimbs p = P.x := by
    rw [← hPd]; rfl
  have hread_py : S.mem.readLimbs (p.add 40#64) = P.y := by
    rw [← hPd]; rfl
  have hread_pcy : S.mem.readLimbs (pc.add 40#64) = P.y := by
    rw [← hread_pc_readPt]; rfl
  clear hPd hread_pc_readPt
  -- t0 = (x + y)²
  step_pure
  have h1 := hX.mono (show 2 ^ 53 ≤ 2 ^ 63 by decide)
  have h2 := hY.mono (show 2 ^ 53 ≤ 2 ^ 63 by decide)
  limbs_room xy
  step_call using Fe_add.call_eq_of consuming h1 h2 hread_py
  have h1 := (Fe.add.spec_lt hX hY (by decide)).mono (show 2 ^ 53 + 2 ^ 53 ≤ 2 ^ 54 by decide)
  limbs_room t0
  step_call using Fe_sq.call_eq_of consuming h1
  -- x², y²
  have h1 := hX.mono (show 2 ^ 53 ≤ 2 ^ 54 by decide)
  limbs_room x
  -- `x`'s room kept: its limbs are stored again in place
  step_call using Fe_sq.call_eq_of consuming h1 hread_px
  step_pure
  have h1 := hY.mono (show 2 ^ 53 ≤ 2 ^ 54 by decide)
  limbs_room z
  step_call using Fe_sq.call_eq_of consuming h1 hread_pcy
  drop xy
  drop p
  -- y = z + x, inline
  have hX2 := Fe.sq.spec_lt P.x
  have hY2 := Fe.sq.spec_lt P.y
  have hyo (i : Fin 5) : (Fe.sq.spec P.x i).uaddOverflow (Fe.sq.spec P.y i) = false :=
    uaddOverflow_eq_false
      (by
        have := hX2 i; have := hY2 i; omega)
  obtain ⟨hzo, fz0, fz8, fz16, fz24, fz32⟩ := hz_limbs
  obtain ⟨hxo, fx0, fx8, fx16, fx24, fx32⟩ := hx_limbs
  load_by hread_z fz0
  load_by hread_x fx0
  step_pure [hyo 0]
  step_pure
  load_by hread_z_8 fz8
  step_pure
  load_by hread_x_8 fx8
  step_pure [hyo 1]
  step_pure
  load_by hread_z_16 fz16
  step_pure
  load_by hread_x_16 fx16
  step_pure [hyo 2]
  step_pure
  load_by hread_z_24 fz24
  step_pure
  load_by hread_x_24 fx24
  step_pure [hyo 3]
  step_pure
  load_by hread_z_32 fz32
  step_pure
  load_by hread_x_32 fx32
  step_pure [hyo 4]
  clear hyo
  have hz_limbs : S.mem.LimbsFit z := ⟨hzo, fz0, fz8, fz16, fz24, fz32⟩
  have hx_limbs : S.mem.LimbsFit x := ⟨hxo, fx0, fx8, fx16, fx24, fx32⟩
  clear hzo fz0 fz8 fz16 fz24 fz32 hxo fx0 fx8 fx16 fx24 fx32
  obtain ⟨hyo', r0, r8, r16, r24, r32⟩ := MemoryState.LimbsRoom.of_room hy_room hy_off
  step_store consuming r0
  step_pure
  step_store consuming r8
  step_pure
  step_store consuming r16
  step_pure
  step_store consuming r24
  step_pure
  step_store consuming r32
  have hread_yv : S.mem.readLimbs y = Fe.add.spec (Fe.sq.spec P.y) (Fe.sq.spec P.x) :=
    MemoryState.readLimbs_of_reads hread_y hread_y_8 hread_y_16 hread_y_24 hread_y_32
  have hy_limbs : S.mem.LimbsFit y := ⟨hyo', hfits_y, hfits_y_8, hfits_y_16, hfits_y_24, hfits_y_32⟩
  clear hread_y hread_y_8 hread_y_16 hread_y_24 hread_y_32 hfits_y hfits_y_8 hfits_y_16 hfits_y_24
    hfits_y_32 hyo'
  have hYv := Fe.add.spec_lt hY2 hX2 (by decide)
  -- z = z - x; x = t0 - y
  have h1 := hY2.mono (show 2 ^ 52 ≤ 2 ^ 63 by decide)
  have h2 := hX2.mono (show 2 ^ 52 ≤ 2 ^ 63 by decide)
  limbs_room zz
  step_call using Fe_sub.call_eq_of consuming h1 h2 hread_z_readLimbs
  have h1 := (Fe.sq.spec_lt (Fe.add.spec P.x P.y)).mono (show 2 ^ 52 ≤ 2 ^ 63 by decide)
  have h2 := hYv.mono (show 2 ^ 52 + 2 ^ 52 ≤ 2 ^ 63 by decide)
  step_call using Fe_sub.call_eq_of consuming h1 h2 hread_t0_readLimbs
  drop z
  drop t0
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
  obtain ⟨-, g0, g8, g16, g24, g32⟩ := hfz
  simp only [Pointer.add_add, BitVec.reduceAdd] at g8 g16 g24 g32
  clear hread_pcz
  step_pure
  step_pure
  load_by hz0 g0
  step_pure
  step_pure
  load_by hz1 g8
  step_pure
  step_pure
  load_by hz2 g16
  step_pure
  step_pure
  load_by hz3 g24
  step_pure
  step_pure
  load_by hz4 g32
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
  obtain ⟨hrw, r0, r16, r32, r48, r64⟩ := MemoryState.WideRoom.of_room hroom_r hr_off
  step_pure [hsh 0]
  step_store consuming r0
  step_pure [hsh 1]
  step_store consuming r16
  step_pure [hsh 2]
  step_store consuming r32
  step_pure [hsh 3]
  step_store consuming r48
  step_pure [hsh 4]
  step_store consuming r64
  clear hsh
  have hrF : S.mem.WideFit r := ⟨hrw, hfits_r, hfits_r_16, hfits_r_32, hfits_r_48, hfits_r_64⟩
  have hR : S.mem.readWide r = fun i => Fe.sq.cols P.z i <<< 1 := by
    funext i; fin_cases i
    · exact hread_r
    · exact hread_r_16
    · exact hread_r_32
    · exact hread_r_48
    · exact hread_r_64
  clear hread_r hread_r_16 hread_r_32 hread_r_48 hread_r_64 hfits_r hfits_r_16 hfits_r_32 hfits_r_48
    hfits_r_64 hrw
  have hpre := Fe.sq2.cols_pre hZ
  limbs_room w
  step_call using Fe_carry128.call_eq_of consuming hR hpre hrF
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
  limbs_room t
  step_call using Fe_sub.call_eq_of consuming h1 h2
  drop w
  -- the outputs
  have h1 := hXX.mono (show 2 ^ 52 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  have h2 := hT.mono (show 2 ^ 52 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  limbs_room ox
  step_call using Fe_mul.call_eq_of consuming h1 h2
  have htm := hS ▸ hox_limbs
  have htr := hS ▸ hread_ox_readLimbs
  have f2 := hox_limbs.fits
  step_memcpy consuming f2
  rw [MemoryState.storeAt_readAt_eq_storeLimbs htm (by omega), htr] at hS
  clear htm htr
  drop ox
  step_pure
  have h1 := hYv.mono (show 2 ^ 52 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  have h2 := hZZ.mono (show 2 ^ 52 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  limbs_room oy
  step_call using Fe_mul.call_eq_of consuming h1 h2
  have htm := hS ▸ hoy_limbs
  have htr := hS ▸ hread_oy_readLimbs
  have f1 := hout.limbsRoom_y.room320
  have f2 := hoy_limbs.fits
  step_memcpy consuming f1 f2
  rw [MemoryState.storeAt_readAt_eq_storeLimbs htm (Pointer.field_offset ho (a := 40) (by omega)),
    htr] at hS
  clear htm htr
  drop oy
  step_pure
  have h1 := hZZ.mono (show 2 ^ 52 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  have h2 := hT.mono (show 2 ^ 52 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  limbs_room oz
  step_call using Fe_mul.call_eq_of consuming h1 h2
  have htm := hS ▸ hoz_limbs
  have htr := hS ▸ hread_oz_readLimbs
  have f1 := hout.limbsRoom_z.room320
  have f2 := hoz_limbs.fits
  step_memcpy consuming f1 f2
  rw [MemoryState.storeAt_readAt_eq_storeLimbs htm (Pointer.field_offset ho (a := 80) (by omega)),
    htr] at hS
  clear htm htr
  drop oz
  step_pure
  have h1 := hXX.mono (show 2 ^ 52 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  have h2 := hYv.mono (show 2 ^ 52 + 2 ^ 52 ≤ 2 ^ 54 by decide)
  limbs_room ot
  step_call using Fe_mul.call_eq_of consuming h1 h2
  have htm := hS ▸ hot_limbs
  have htr := hS ▸ hread_ot_readLimbs
  have f1 := hout.limbsRoom_t.room320
  have f2 := hot_limbs.fits
  step_memcpy consuming f1 f2
  rw [MemoryState.storeAt_readAt_eq_storeLimbs htm (Pointer.field_offset ho (a := 120) (by omega)),
    htr] at hS
  clear htm htr
  step_pure
  have f1 := hout.room_base
  step_store consuming f1
  finish_block
  subst_vars
  erase_frame
  rfl

/-- `call_eq` on the point `P` read at `p`. -/
public theorem Edwards25519_dbl.call_eq_of (out p : Pointer) (s : GlobalState) (hwf : s.WF)
    (hout : s.mem.PtRoom out) (hp : s.mem.PtLimbsFit p) (hPd : s.mem.readPt p = P)
    (hX : Fe.Lt P.x (2 ^ 53)) (hY : Fe.Lt P.y (2 ^ 53)) (hZ : Fe.Lt P.z (2 ^ 53)) :
    Edwards25519_dbl.call (Edwards25519_dbl.args (.value out) (.value p)) s =
      .value
        (.nil,
          { alloc := ⟨s.alloc.nextFreeBlock + 28⟩,
            mem := s.mem.storePt out (Edwards25519.dbl.spec P) 0#1 }) := by
  subst hPd
  exact Edwards25519_dbl.call_eq out p s hwf hout hp hX hY hZ

end Proof

end MLIR.Zig
