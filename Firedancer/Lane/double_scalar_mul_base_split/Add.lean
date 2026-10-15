module

public import MLIR.Run.Tactic
public import Firedancer.Lane.Common.Split
public import Firedancer.Lane.Common.SplitRuns
public import Firedancer.Lane.Common.SplitTactics
public import Firedancer.Lane.Common.R43x6
public import Firedancer.Lane.Mlir.double_scalar_mul_base_split

namespace MLIR.Firedancer.Lane

open Firedancer.Avx512

/-! ## Proof -/

@[expose] public section

attribute [-mlir_operation] zipWith_eq_ofFn

attribute [local mlir_operation] zipWith_and_wrap zipWith_add_wrap zipWith_sub_wrap zipWith_mul_wrap
  zipWith_lshr_wrap zipWith_ashr_wrap zipWith_shl_wrap zipWith_add_nsw_wrap zipWith_add_nsw_nuw_wrap
  zipWith_sub_nsw_wrap

namespace double_scalar_mul_base_split

open _root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split
open Split

/-- The lift's runs from a block. -/
local notation "runD" => _root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split.runFrom

/-- Register `k` of the lift. -/
local macro "%%" k:num : term =>
  `(rir_reg% _root_.Firedancer.Lane.Mlir.double_scalar_mul_base_split.hty $k)

/-- The constants the main loop reads: the folds' shifts, masks and biases, the products' shifts,
the lane operations' `p` limbs, `19` for the folds' top carries, the counters', and the decode
steps' squarings' and bounds. -/
abbrev Consts (E : ⟪Γ⟫) : Prop :=
  E ⊨ [%1 := 1#64, %2 := m4340, %3 := Vector.replicate 8 1048576#64, %4 := bias03,
    %5 := Vector.replicate 8 8796093022207#64, %7 := s4340, %8 := Vector.replicate 8 43#64,
    %17 := 5#64,
    %9 := negBias, %10 := negBias03, %23 := Vector.replicate 8 24#64,
    %24 := Vector.replicate 8 7#64, %30 := 2#32, %31 := 1#32, %35 := 8#64, %47 := 0#16,
    %48 := 18446744073709551615#64, %57 := (Vector.replicate 8 .poison : ⟦.vec 8 64⟧),
    %61 := 0#64, %62 := Vector.replicate 8 0#64,
    %63 := Vector.replicate 8 9#64, %68 := 0#32, %124 := negK03, %132 := negK14, %140 := negK25,
    %148 :=
    (#v[.value 8796093022189#64, .poison, .poison, .poison, .value 8796093022207#64, .poison,
      .poison, .poison] : ⟦.vec 8 64⟧),
    %156 :=
    (#v[.value 8796093022207#64, .poison, .poison, .poison, .value 8796093022207#64, .poison,
      .poison, .poison] : ⟦.vec 8 64⟧),
    %164 :=
    (#v[.value 8796093022207#64, .poison, .poison, .poison, .value 1099511627775#64, .poison,
      .poison, .poison] : ⟦.vec 8 64⟧),
    %172 := k19Lanes,
    %180 :=
    (#v[.value 8796093022189#64, .poison, .poison, .value 8796093022189#64,
      .value 8796093022207#64, .poison, .poison, .value 8796093022207#64] : ⟦.vec 8 64⟧),
    %188 :=
    (#v[.value 8796093022207#64, .poison, .poison, .value 8796093022207#64,
      .value 8796093022207#64, .poison, .poison, .value 8796093022207#64] : ⟦.vec 8 64⟧),
    %196 :=
    (#v[.value 8796093022207#64, .poison, .poison, .value 8796093022207#64,
      .value 1099511627775#64, .poison, .poison, .value 1099511627775#64] : ⟦.vec 8 64⟧),
    %18 := 12#64, %19 := 18446744073709551613#64, %56 := 3#64, %20 := foldK,
    %21 := foldShifts, %22 := foldMask,
    %25 := (#v[-1, -1, -1, -1, -1, -1, 0, 0] : Vector (BitVec 64) 8), %58 := sqrDbl0,
    %59 := sqrDbl2, %60 := sqrDbl4, %64 := sqrMaskN1, %65 := sqrMaskN2,
    %76 := lanesBelow 6 sqrMask1, %84 := lanesBelow 6 sqrMask2, %92 := lanesBelow 5 sqrMask1,
    %100 := lanesBelow 5 sqrMask2, %108 := lanesFrom 7 wwl_zero, %116 := lanesBelow 5 wwl_zero]

set_option hygiene false in
/-- `FD_R43X6_GE_ADD_TABLE_ALT( P3, t, X )` on `t` in registers and `X` loaded, from the
permute of `t` to the result's fold, in registers: the steps' equations `e2 … e8`. -/
local macro "ge_add_table_core" : tactic =>
  `(tactic|
    (
    -- FD_R43X6_QUAD_PERMUTE( _tb, 1,0,2,3, t ), only the lanes the subtraction reads
    step_pattern using runBodyFrom_permuteRun_poison 1 0 2 3 1 0 0 0
    -- FD_R43X6_QUAD_LANE_SUB_FAST( _tb, _tb, 1,0,0,0, _tb, t )
    step_pattern using runBodyFrom_laneSubPermRun 1 0 2 3 1 0 0 0
    have e2 := _hl
    -- FD_R43X6_QUAD_LANE_ADD_FAST( _tb, _tb, 0,1,1,0, _tb, t )
    step_pattern using runBodyFrom_laneAddRun 0 1 1 0
    have e3 := _hl
    -- FD_R43X6_QUAD_FOLD_SIGNED( _tb, _tb )
    step_pattern using runBodyFrom_foldSignedRun
    have eF1 := (Quad.foldSigned_eq _).trans _hs
    -- FD_R43X6_QUAD_MUL_FAST( _ta, _ta, _tb )
    step_pattern using runBodyFrom_halvesRun 0 1 2 3 inline
    step_pattern using runBodyFrom_quadMulCoreRun
    have e4 := quadMul_of_core_id (Y := ⟨s03, s14, s25⟩) _hm
    -- FD_R43X6_QUAD_FOLD_UNSIGNED( _ta, _ta ); its lanes are below `2^44`
    step_pattern using runBodyFrom_foldUnsignedRun
    have eU1 := (Quad.foldUnsigned_eq _).trans _hu
    obtain ⟨hu03, hu14, hu25⟩ := Quad.foldUnsignedC_lt _hu
    have hpa03 := wwl_perm4_lt hu03 1 0 3 2
    have hpa14 := wwl_perm4_lt hu14 1 0 3 2
    have hpa25 := wwl_perm4_lt hu25 1 0 3 2
    -- FD_R43X6_QUAD_PERMUTE( _tb, 1,0,3,2, _ta ), FD_R43X6_QUAD_LANE_SUB_FAST( _tb, _tb, 1,0,0,1,
    -- _tb, _ta ) and FD_R43X6_QUAD_LANE_ADD_FAST( _tb, _tb, 0,1,1,0, _tb, _ta ), fused; the code's
    -- `nsw` holds
    step_pattern using runBodyFrom_permSubAddRun (hs03 := fun _ => sub_lt_ok hpa03 hu03) (hs14 :=
      fun _ => sub_lt_ok hpa14 hu14) (hs25 := fun _ => sub_lt_ok hpa25 hu25) (ha03 := fun _ =>
      sub_add_lt_ok hpa03 hu03 quadP_lt.1) (ha14 := fun _ => sub_add_lt_ok hpa14 hu14 quadP_lt.2.1)
      (ha25 := fun _ => sub_add_lt_ok hpa25 hu25 quadP_lt.2.2) (ho14 := fun _ k =>
      add_lane_ok (hpa14 k) (hu14 k)) (ho25 := fun _ k => add_lane_ok (hpa25 k) (hu25 k))
    have e5 := _hl
    -- FD_R43X6_QUAD_FOLD_SIGNED( _tb, _tb )
    step_pattern using runBodyFrom_foldSignedSplitRun inline
    have eF2 := _hf
    -- FD_R43X6_QUAD_PERMUTE( _tb, 3,1,3,1, _tb ), then FD_R43X6_QUAD_PERMUTE( _ta, 0,2,2,0, _tb )
    -- fused into FD_R43X6_QUAD_MUL_FAST( P3, _ta, _tb )
    step_pattern using runBodyFrom_permuteRun 3 1 3 1
    have e6 := _hp
    step_pattern using runBodyFrom_halvesRun 0 2 2 0 inline
    step_pattern using runBodyFrom_quadMulCoreRun
    have e7 := quadMul_of_core e6 _hm
    -- FD_R43X6_QUAD_FOLD_UNSIGNED( P3, _ta )
    step_pattern using runBodyFrom_foldUnsignedRun
    have e8 := (Quad.foldUnsigned_eq _).trans _hu))

/-- `0 - d` of a negative `int` digit `d = -n`, without signed overflow. -/
theorem neg_ssubOverflow {n : Nat} (h : n < 2 ^ 31) :
    (0#32).ssubOverflow (-BitVec.ofNat 32 n) = false := by
  have hn : (BitVec.ofNat 32 n).toInt = n := by
    rw [BitVec.toInt_eq_toNat_of_lt] <;> simp <;> omega
  simp only [BitVec.ssubOverflow, BitVec.toInt_neg, hn, BitVec.toInt_zero, Int.bmod_def]
  simp
  omega

/-- An odd `int` digit `2k + 1` halved by `lshr 1`. -/
theorem ushr1_odd {k : Nat} (h : 2 * k + 1 < 2 ^ 32) :
    BitVec.ofNat 32 (2 * k + 1) >>> 1 = BitVec.ofNat 32 k := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_ushiftRight, BitVec.toNat_ofNat, BitVec.toNat_ofNat, Nat.mod_eq_of_lt h]
  omega

/-- A small `int` shifted by `2`. -/
theorem shl2_ofNat (j : Nat) :
    BitVec.ofNat 32 j <<< 2 = BitVec.ofNat 32 (4 * j) := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_shiftLeft, BitVec.toNat_ofNat, BitVec.toNat_ofNat, Nat.shiftLeft_eq]
  omega

/-- The registers live in the main loop: the constants, the slides, `bt`, `t`, `r`'s second and
third vectors, `dec == NULL` as `fl`, `dec`'s fields and the counter `i`. -/
abbrev Live (r n1s n2s bt tp : Pointer) (fl : BitVec 1) (v326 v327 : ⟦.ptr⟧) (i : Nat)
    (E : ⟪Γ⟫) : Prop :=
  Consts E ∧
    E ⊨ [%197 := n1s, %198 := n2s, %199 := bt, %200 := tp, %208 := r.add 64#64, %325 := fl,
      %326 := v326, %327 := v327, %328 := tp.add 64#64, %329 := tp.add 128#64,
      %330 := r.add 128#64, %331 := BitVec.ofNat 64 i]

/-- `^bb14`, `n1slide[32j+i] = 2k + 1 > 0`: `r` a copy of `t` (held in registers), then
`t = t + a_tbl[4j + k]`; on to `^bb25` if `dec` is `NULL`, else to the decode step at `^bb15`. -/
theorem add1_block (r n1 ta n2 tb dec n1s n2s bt tp : Pointer) (fl : BitVec 1)
    (v326 v327 : ⟦.ptr⟧) (i j k : Nat) (hj : j < 8) (hk : k < 4) (T B : Quad) (d2 : BitVec 16)
    (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs :
      E.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb) (.value dec)).get)
    (hL : Live r n1s n2s bt tp fl v326 v327 i E)
    (hR :
      E ⊨ [%%485 := BitVec.ofNat 64 j, %%486 := T.P25, %%487 := T.P14, %%488 := T.P03,
        %%494 := d2, %%495 := BitVec.ofNat 32 (2 * k + 1)])
    (hto : ta.offset.toNat + 192 * 32 < 2 ^ 64) (hrt : r.id ≠ ta.id) (hwf : S.WF)
    (hr : S.mem.QuadRoom r) (he : S.mem.QuadFit (ta.add (BitVec.ofNat 64 (192 * (4 * j + k)))))
    (hB : S.mem.readQuad (ta.add (BitVec.ofNat 64 (192 * (4 * j + k)))) = B)
    (hnull :
      fl = 1#1 →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
              (.value dec)).get →
            Live r n1s n2s bt tp fl v326 v327 i E' →
            (E' ⊨ [%%485 := BitVec.ofNat 64 j, %%494 := d2,
              %%1343 := (fd_ed25519_point_add_with_opts.spec T B 1#32).P25,
              %%1344 := (fd_ed25519_point_add_with_opts.spec T B 1#32).P14,
              %%1345 := (fd_ed25519_point_add_with_opts.spec T B 1#32).P03]) →
            (runD E' 25 { S with mem := S.mem.storeQuad r T } >>= g) = K)
    (hdec :
      ¬fl = 1#1 →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
              (.value dec)).get →
            Live r n1s n2s bt tp fl v326 v327 i E' →
            (E' ⊨ [%%485 := BitVec.ofNat 64 j, %%494 := d2,
              %%764 := (fd_ed25519_point_add_with_opts.spec T B 1#32).P03,
              %%766 := (fd_ed25519_point_add_with_opts.spec T B 1#32).P14,
              %%768 := (fd_ed25519_point_add_with_opts.spec T B 1#32).P25]) →
            (runD E' 15 { S with mem := S.mem.storeQuad r T } >>= g) = K) :
    (runD E 14 S >>= g) = K := by
  have hU : fd_ed25519_point_add_with_opts.spec T B 1#32 = geAddTable quadMul T B := by
    simp [fd_ed25519_point_add_with_opts.spec]
  rw [hU] at hnull hdec
  obtain ⟨hC, hL⟩ := hL
  split_env hC hL hR
  block_init
  step_store
  step_store
  step_store
  step_pure [ushr1_odd (show 2 * k + 1 < 2 ^ 32 by omega)]
  step_pure
  step_pure [shl2_ofNat j]
  step_pure [saddOverflow_ofNat32 (show k + 4 * j < 2 ^ 31 by omega),
    uaddOverflow_ofNat32 (show k + 4 * j < 2 ^ 32 by omega), ← BitVec.ofNat_add]
  step_pure [msb_ofNat32 (show k + 4 * j < 2 ^ 31 by omega),
    setWidth_ofNat32 (show k + 4 * j < 2 ^ 32 by omega)]
  step_pure [Nat.add_comm k (4 * j), Nat.mod_eq_of_lt (show 4 * j + k < 2 ^ 64 by omega),
    Nat.mul_comm (4 * j + k) 192]
  -- the entry `a_tbl[4j + k]`, loaded
  step_pattern using runBodyFrom_quadLoadRun
  have eB := _hx
  ge_add_table_core
  have eT : geAddTable quadMul T B = ⟨u03, u14, u25⟩ := by
    rw [← hB, eB]
    simp only [geAddTable]
    rw [e2, e3, eF1, e4, eU1, e5, eF2, e7, e8]
  rw [eT] at hnull hdec
  clear e2 e3 eF1 e4 eU1 e5 eF2 e7 e8 eT
  seal
  finish_block
  case isTrue =>
    rw [hS]
    exact hnull hbr E hArgs ⟨by env_reads, by env_reads⟩ (by env_reads)
  case isFalse =>
    rw [hS]
    exact hdec hbr E hArgs ⟨by env_reads, by env_reads⟩ (by env_reads)

/-- `^bb26`, `n2slide[32j+i] = 2k + 1 > 0`: `r` a copy of `t` (held in registers), then
`t = t + bt[j][k]`, `bt[j]` loaded as `P`; on to `^bb37` if `dec` is `NULL`, else to the decode
step at `^bb27`. -/
theorem add2_block (r n1 ta n2 tb dec n1s n2s bt tp : Pointer) (fl : BitVec 1)
    (v326 v327 : ⟦.ptr⟧) (i j k : Nat) (hj : j < 8) (hk : k < 128) (T B : Quad) (P : Pointer)
    (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs :
      E.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb) (.value dec)).get)
    (hL : Live r n1s n2s bt tp fl v326 v327 i E)
    (hR :
      E ⊨ [%485 := BitVec.ofNat 64 j, %%1343 := T.P25, %%1344 := T.P14, %%1345 := T.P03,
        %%1346 := BitVec.ofNat 32 (2 * k + 1)])
    (hbo : bt.offset.toNat + 64 ≤ 2 ^ 64)
    (hbt : InBounds S.mem (bt.add (BitVec.ofNat 64 (8 * j))) 64)
    (hP : S.mem.loadPtr (bt.add (BitVec.ofNat 64 (8 * j))) = .value P)
    (hPo : P.offset.toNat + 192 * 128 < 2 ^ 64) (hrP : r.id ≠ P.id) (hrb : r.id ≠ bt.id)
    (hwf : S.WF) (hr : S.mem.QuadRoom r) (he : S.mem.QuadFit (P.add (BitVec.ofNat 64 (192 * k))))
    (hB : S.mem.readQuad (P.add (BitVec.ofNat 64 (192 * k))) = B)
    (hnull :
      fl = 1#1 →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
              (.value dec)).get →
            Live r n1s n2s bt tp fl v326 v327 i E' →
            (E' ⊨ [%%485 := BitVec.ofNat 64 j,
              %%2192 := (fd_ed25519_point_add_with_opts.spec T B 1#32).P25,
              %%2193 := (fd_ed25519_point_add_with_opts.spec T B 1#32).P14,
              %%2194 := (fd_ed25519_point_add_with_opts.spec T B 1#32).P03]) →
            (runD E' 37 { S with mem := S.mem.storeQuad r T } >>= g) = K)
    (hdec :
      ¬fl = 1#1 →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
              (.value dec)).get →
            Live r n1s n2s bt tp fl v326 v327 i E' →
            (E' ⊨ [%%485 := BitVec.ofNat 64 j,
              %%1614 := (fd_ed25519_point_add_with_opts.spec T B 1#32).P03,
              %%1616 := (fd_ed25519_point_add_with_opts.spec T B 1#32).P14,
              %%1618 := (fd_ed25519_point_add_with_opts.spec T B 1#32).P25]) →
            (runD E' 27 { S with mem := S.mem.storeQuad r T } >>= g) = K) :
    (runD E 26 S >>= g) = K := by
  have hU : fd_ed25519_point_add_with_opts.spec T B 1#32 = geAddTable quadMul T B := by
    simp [fd_ed25519_point_add_with_opts.spec]
  rw [hU] at hnull hdec
  obtain ⟨hC, hL⟩ := hL
  split_env hC hL hR
  block_init
  step_store
  step_store
  step_store
  -- bt[j]
  step_pure [Nat.mod_eq_of_lt (show j < 2 ^ 64 by omega), Nat.mul_comm j 8]
  step_load
  step_pure [ushr1_odd (show 2 * k + 1 < 2 ^ 32 by omega)]
  step_pure [msb_ofNat32 (show k < 2 ^ 31 by omega), setWidth_ofNat32 (show k < 2 ^ 32 by omega)]
  step_pure [Nat.mod_eq_of_lt (show k < 2 ^ 64 by omega), Nat.mul_comm k 192]
  -- the entry `bt[j][k]`, loaded
  step_pattern using runBodyFrom_quadLoadRun
  have eB := _hx
  ge_add_table_core
  have eT : geAddTable quadMul T B = ⟨u03, u14, u25⟩ := by
    rw [← hB, eB]
    simp only [geAddTable]
    rw [e2, e3, eF1, e4, eU1, e5, eF2, e7, e8]
  rw [eT] at hnull hdec
  clear e2 e3 eF1 e4 eU1 e5 eF2 e7 e8 eT
  seal
  finish_block
  case isTrue =>
    rw [hS]
    exact hnull hbr E hArgs ⟨by env_reads, by env_reads⟩ (by env_reads)
  case isFalse =>
    rw [hS]
    exact hdec hbr E hArgs ⟨by env_reads, by env_reads⟩ (by env_reads)

/-- `^bb20`, `n1slide[32j+i] = -(2k + 1) < 0`: `r` a copy of `t` (held in registers), then
`t = t - a_tbl[4j + k]`; on to `^bb25` if `dec` is `NULL`, else to the decode step at `^bb21`. -/
theorem sub1_block (r n1 ta n2 tb dec n1s n2s bt tp : Pointer) (fl : BitVec 1)
    (v326 v327 : ⟦.ptr⟧) (i j k : Nat) (hj : j < 8) (hk : k < 4) (T B : Quad) (d2 : BitVec 16)
    (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs :
      E.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb) (.value dec)).get)
    (hL : Live r n1s n2s bt tp fl v326 v327 i E)
    (hR :
      E ⊨ [%%485 := BitVec.ofNat 64 j, %%486 := T.P25, %%487 := T.P14, %%488 := T.P03,
        %%494 := d2, %%495 := -BitVec.ofNat 32 (2 * k + 1)])
    (hto : ta.offset.toNat + 192 * 32 < 2 ^ 64) (hrt : r.id ≠ ta.id) (hwf : S.WF)
    (hr : S.mem.QuadRoom r) (he : S.mem.QuadFit (ta.add (BitVec.ofNat 64 (192 * (4 * j + k)))))
    (hB : S.mem.readQuad (ta.add (BitVec.ofNat 64 (192 * (4 * j + k)))) = B)
    (hnull :
      fl = 1#1 →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
              (.value dec)).get →
            Live r n1s n2s bt tp fl v326 v327 i E' →
            (E' ⊨ [%%485 := BitVec.ofNat 64 j, %%494 := d2,
              %%1343 := (fd_ed25519_point_sub_with_opts.spec T B 1#32).P25,
              %%1344 := (fd_ed25519_point_sub_with_opts.spec T B 1#32).P14,
              %%1345 := (fd_ed25519_point_sub_with_opts.spec T B 1#32).P03]) →
            (runD E' 25 { S with mem := S.mem.storeQuad r T } >>= g) = K)
    (hdec :
      ¬fl = 1#1 →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
              (.value dec)).get →
            Live r n1s n2s bt tp fl v326 v327 i E' →
            (E' ⊨ [%%485 := BitVec.ofNat 64 j, %%494 := d2,
              %%1191 := (fd_ed25519_point_sub_with_opts.spec T B 1#32).P03,
              %%1193 := (fd_ed25519_point_sub_with_opts.spec T B 1#32).P14,
              %%1195 := (fd_ed25519_point_sub_with_opts.spec T B 1#32).P25]) →
            (runD E' 21 { S with mem := S.mem.storeQuad r T } >>= g) = K) :
    (runD E 20 S >>= g) = K := by
  have hU :
      fd_ed25519_point_sub_with_opts.spec T B 1#32 =
        geAddTable quadMul T (fd_ed25519_point_neg_precomputed.spec B) := by
    simp [fd_ed25519_point_sub_with_opts.spec, fd_ed25519_point_add_with_opts.spec]
  rw [hU] at hnull hdec
  obtain ⟨hC, hL⟩ := hL
  split_env hC hL hR
  block_init
  step_store
  step_store
  step_store
  step_pure [neg_ssubOverflow (show 2 * k + 1 < 2 ^ 31 by omega)]
  step_pure [ushr1_odd (show 2 * k + 1 < 2 ^ 32 by omega)]
  step_pure
  step_pure [shl2_ofNat j]
  step_pure [saddOverflow_ofNat32 (show k + 4 * j < 2 ^ 31 by omega),
    uaddOverflow_ofNat32 (show k + 4 * j < 2 ^ 32 by omega), ← BitVec.ofNat_add]
  step_pure [msb_ofNat32 (show k + 4 * j < 2 ^ 31 by omega),
    setWidth_ofNat32 (show k + 4 * j < 2 ^ 32 by omega)]
  step_pure [Nat.add_comm k (4 * j), Nat.mod_eq_of_lt (show 4 * j + k < 2 ^ 64 by omega),
    Nat.mul_comm (4 * j + k) 192]
  -- the entry `a_tbl[4j + k]`, loaded
  step_pattern using runBodyFrom_quadLoadRun
  have eB := _hx
  -- fd_ed25519_point_neg_precomputed of the entry
  step_pattern using runBodyFrom_negRegRun
  have eN := _hn
  ge_add_table_core
  have eT : geAddTable quadMul T (fd_ed25519_point_neg_precomputed.spec B) = ⟨u03, u14, u25⟩ := by
    rw [← hB, eB, eN]
    simp only [geAddTable]
    rw [e2, e3, eF1, e4, eU1, e5, eF2, e7, e8]
  rw [eT] at hnull hdec
  clear e2 e3 eF1 e4 eU1 e5 eF2 e7 e8 eT eN
  seal
  finish_block
  case isTrue =>
    rw [hS]
    exact hnull hbr E hArgs ⟨by env_reads, by env_reads⟩ (by env_reads)
  case isFalse =>
    rw [hS]
    exact hdec hbr E hArgs ⟨by env_reads, by env_reads⟩ (by env_reads)

/-- `^bb32`, `n2slide[32j+i] = -(2k + 1) < 0`: `r` a copy of `t` (held in registers), then
`t = t - bt[j][k]`, `bt[j]` loaded as `P`; on to `^bb37` if `dec` is `NULL`, else to the decode
step at `^bb33`. -/
theorem sub2_block (r n1 ta n2 tb dec n1s n2s bt tp : Pointer) (fl : BitVec 1)
    (v326 v327 : ⟦.ptr⟧) (i j k : Nat) (hj : j < 8) (hk : k < 128) (T B : Quad) (P : Pointer)
    (S : GlobalState) (E : ⟪Γ⟫) (g : Vals [.ptr] × GlobalState → PoisonOr β) (K : PoisonOr β)
    (hArgs :
      E.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb) (.value dec)).get)
    (hL : Live r n1s n2s bt tp fl v326 v327 i E)
    (hR :
      E ⊨ [%485 := BitVec.ofNat 64 j, %%1343 := T.P25, %%1344 := T.P14, %%1345 := T.P03,
        %%1346 := -BitVec.ofNat 32 (2 * k + 1)])
    (hbo : bt.offset.toNat + 64 ≤ 2 ^ 64)
    (hbt : InBounds S.mem (bt.add (BitVec.ofNat 64 (8 * j))) 64)
    (hP : S.mem.loadPtr (bt.add (BitVec.ofNat 64 (8 * j))) = .value P)
    (hPo : P.offset.toNat + 192 * 128 < 2 ^ 64) (hrP : r.id ≠ P.id) (hrb : r.id ≠ bt.id)
    (hwf : S.WF) (hr : S.mem.QuadRoom r) (he : S.mem.QuadFit (P.add (BitVec.ofNat 64 (192 * k))))
    (hB : S.mem.readQuad (P.add (BitVec.ofNat 64 (192 * k))) = B)
    (hnull :
      fl = 1#1 →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
              (.value dec)).get →
            Live r n1s n2s bt tp fl v326 v327 i E' →
            (E' ⊨ [%%485 := BitVec.ofNat 64 j,
              %%2192 := (fd_ed25519_point_sub_with_opts.spec T B 1#32).P25,
              %%2193 := (fd_ed25519_point_sub_with_opts.spec T B 1#32).P14,
              %%2194 := (fd_ed25519_point_sub_with_opts.spec T B 1#32).P03]) →
            (runD E' 37 { S with mem := S.mem.storeQuad r T } >>= g) = K)
    (hdec :
      ¬fl = 1#1 →
        ∀ E' : ⟪Γ⟫,
          E'.args = (args (.value r) (.value n1) (.value ta) (.value n2) (.value tb)
              (.value dec)).get →
            Live r n1s n2s bt tp fl v326 v327 i E' →
            (E' ⊨ [%%485 := BitVec.ofNat 64 j,
              %%2040 := (fd_ed25519_point_sub_with_opts.spec T B 1#32).P03,
              %%2042 := (fd_ed25519_point_sub_with_opts.spec T B 1#32).P14,
              %%2044 := (fd_ed25519_point_sub_with_opts.spec T B 1#32).P25]) →
            (runD E' 33 { S with mem := S.mem.storeQuad r T } >>= g) = K) :
    (runD E 32 S >>= g) = K := by
  have hU :
      fd_ed25519_point_sub_with_opts.spec T B 1#32 =
        geAddTable quadMul T (fd_ed25519_point_neg_precomputed.spec B) := by
    simp [fd_ed25519_point_sub_with_opts.spec, fd_ed25519_point_add_with_opts.spec]
  rw [hU] at hnull hdec
  obtain ⟨hC, hL⟩ := hL
  split_env hC hL hR
  block_init
  step_store
  step_store
  step_store
  -- bt[j]
  step_pure [Nat.mod_eq_of_lt (show j < 2 ^ 64 by omega), Nat.mul_comm j 8]
  step_load
  step_pure [neg_ssubOverflow (show 2 * k + 1 < 2 ^ 31 by omega)]
  step_pure [ushr1_odd (show 2 * k + 1 < 2 ^ 32 by omega)]
  step_pure [msb_ofNat32 (show k < 2 ^ 31 by omega), setWidth_ofNat32 (show k < 2 ^ 32 by omega)]
  step_pure [Nat.mod_eq_of_lt (show k < 2 ^ 64 by omega), Nat.mul_comm k 192]
  -- the entry `bt[j][k]`, loaded
  step_pattern using runBodyFrom_quadLoadRun
  have eB := _hx
  -- fd_ed25519_point_neg_precomputed of the entry
  step_pattern using runBodyFrom_negRegRun
  have eN := _hn
  ge_add_table_core
  have eT : geAddTable quadMul T (fd_ed25519_point_neg_precomputed.spec B) = ⟨u03, u14, u25⟩ := by
    rw [← hB, eB, eN]
    simp only [geAddTable]
    rw [e2, e3, eF1, e4, eU1, e5, eF2, e7, e8]
  rw [eT] at hnull hdec
  clear e2 e3 eF1 e4 eU1 e5 eF2 e7 e8 eT eN
  seal
  finish_block
  case isTrue =>
    rw [hS]
    exact hnull hbr E hArgs ⟨by env_reads, by env_reads⟩ (by env_reads)
  case isFalse =>
    rw [hS]
    exact hdec hbr E hArgs ⟨by env_reads, by env_reads⟩ (by env_reads)

end double_scalar_mul_base_split

end

end MLIR.Firedancer.Lane
