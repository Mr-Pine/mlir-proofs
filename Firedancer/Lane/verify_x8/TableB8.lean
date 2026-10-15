module

public import Firedancer.Lane.verify_x8.TableSeg
public import Firedancer.Lane.verify_x8.TableTac
public import Firedancer.Lane.verify_x8.TableOps
public import Firedancer.Lane.fd_ed25519_lane_point_dbl
public import Firedancer.Lane.fd_ed25519_lane_point_add
public import Firedancer.Lane.Common.Runs
public import Firedancer.Lane.Common.Tactics

/-! `^bb79`'s entry 8: `fd_ed25519_lane_point_dbl( &tmp, &p4, 1 )`, then the result's
`fd_ed25519_lane_to_niels` stored as `ktab[8]`. -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512
open _root_.Firedancer.Lane.Mlir (verify_x8)
open _root_.Firedancer.Lane.Mlir.verify_x8 (Γ hty)

attribute [-simp] BitVec.replicate_succ BitVec.reduceReplicate

attribute [-mlir_operation] zipWith_eq_ofFn Operation.vpmadd52l Operation.vpmadd52h

attribute [local mlir_operation] vpmadd52l_wwl vpmadd52h_wwl zipWith_add_wwl zipWith_sub_wwl
  zipWith_and_wwl zipWith_mul_wwl zipWith_shl_wwl zipWith_lshr_wwl

attribute [local mlir_transport] MemoryState.FrameOn.storeAt MemoryState.FrameOn.storeAt_add
  MemoryState.FrameOn.storeVec MemoryState.FrameOn.storeVec_add MemoryState.FrameOn.lifetimeStart
  MemoryState.FrameOn.lifetimeEnd MemoryState.FrameOn.storeFe MemoryState.FrameOn.storeFe_add
  MemoryState.FrameOn.storeLanePoint

attribute [local mlir_read] readFe_storeAt_of_id_ne readLanePoint_storeAt_of_id_ne
  readNiels_storeAt_of_id_ne readLanePoint_storeVec_of_id_ne readNiels_storeVec_of_id_ne
  readAt_storeLanePoint_x0 readAt_storeLanePoint_x1
  readAt_storeLanePoint_x2 readAt_storeLanePoint_x3 readAt_storeLanePoint_x4
  readAt_storeLanePoint_y0 readAt_storeLanePoint_y1 readAt_storeLanePoint_y2
  readAt_storeLanePoint_y3 readAt_storeLanePoint_y4 readAt_storeLanePoint_z0
  readAt_storeLanePoint_z1 readAt_storeLanePoint_z2 readAt_storeLanePoint_z3
  readAt_storeLanePoint_z4 readAt_storeLanePoint_t0 readAt_storeLanePoint_t1
  readAt_storeLanePoint_t2 readAt_storeLanePoint_t3 readAt_storeLanePoint_t4

variable {β : Type} {g : Vals [] × GlobalState → PoisonOr β} {K : PoisonOr β}

-- 200-odd instructions, a call and three inlined field operations, in one declaration
set_option maxHeartbeats 4000000 in
/-- `^bb79` from position 1561 to 1764: entry 8. -/
public theorem segB8 (c : Call) (M₀ : MemoryState) (kt k2 n1 p2 p3 p4 p6 tmp acc a : Pointer)
    (hp : Ptrs c kt k2 n1 p2 p3 p4 p6 tmp acc a) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : EnvT1561 c kt k2 n1 p2 p3 p4 p6 tmp acc a E)
    (hS : StT1561 c M₀ kt k2 n1 p2 p3 p4 p6 tmp acc a S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args →
        EnvT1764 c kt k2 n1 p2 p3 p4 p6 tmp acc a E' →
          StT1764 c M₀ kt k2 n1 p2 p3 p4 p6 tmp acc a S' →
            (_root_.Firedancer.Lane.Mlir.verify_x8.bb79.runBodyFrom E' 1764 S' >>= G79 c g) = K) :
    (_root_.Firedancer.Lane.Mlir.verify_x8.bb79.runBodyFrom E 1561 S >>= G79 c g) = K := by
  obtain ⟨hkt, hk2, hn1, hp2, hp3, hp4, hp6, htmp, hacc, ha⟩ := hp
  obtain ⟨hwf, hfr, hroom_kt, hF0, hT0, hF1, hT1, hF2, hT2, hF3, hT3, hF4, hT4, hF5, hT5, hF6, hT6,
    hF7, hT7, hpf_p4, hpt_p4, hroom_tmp, hb11, hw11⟩ := hS
  have hkt_off : kt.offset = 0 := by rw [hkt]; rfl
  have htmp_off : tmp.offset = 0 := by rw [htmp]; rfl
  have hkt_k : ¬Keep c kt.id := hkt ▸ not_keep_slot c (by decide) (by decide)
  have htmp_k : ¬Keep c tmp.id := htmp ▸ not_keep_slot c (by decide) (by decide)
  folded hkt
  folded hk2
  folded hn1
  folded hp2
  folded hp3
  folded hp4
  folded hp6
  folded htmp
  folded hacc
  folded ha
  env_writes hE
  unfold G79
  have hlr : S.mem.LanePointRoom tmp := ⟨nov_of_zero htmp_off (by decide), hroom_tmp⟩
  step_call using _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl.call_eq
  hide_body
  have hP : ∀ t0, (c.tabPt 4).dbl (decide True) t0 = c.tabPt 8 := fun _ => rfl
  rw [hP] at hS hread_tmp_readLanePoint hread_tmp hread_tmp_64 hread_tmp_128 hread_tmp_192
  rw [hP] at hread_tmp_256 hread_tmp_320 hread_tmp_384 hread_tmp_448 hread_tmp_512 hread_tmp_576
  rw [hP] at hread_tmp_640 hread_tmp_704 hread_tmp_768 hread_tmp_832 hread_tmp_896 hread_tmp_960
  rw [hP] at hread_tmp_1024 hread_tmp_1088 hread_tmp_1152 hread_tmp_1216
  clear hP
  slv
  slv
  sp
  slv
  slv
  sp
  slv
  slv
  sp
  slv
  slv
  sp
  slv
  slv
  sp
  step_pattern using runBodyFrom_carryRun; hide_body
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  step_pattern using runBodyFrom_carryRun; hide_body
  slv
  slv
  slv
  slv
  slv
  slv
  slv
  slv
  slv
  slv
  step_pattern using runBodyFrom_mulLooseRun; hide_body
  step_pattern using runBodyFrom_carryRun'; hide_body
  sp
  spn
  spn
  spn
  spn
  sp
  ss
  sp
  ss
  sp
  ss
  sp
  ss
  sp
  ss
  sp
  ss
  sp
  ss
  sp
  ss
  sp
  ss
  sp
  ss
  sp
  ss
  sp
  ss
  sp
  ss
  sp
  ss
  sp
  ss
  sp
  ss
  sp
  ss
  sp
  ss
  sp
  ss
  sp
  ss
  sp
  ss
  sp
  ss
  sp
  ss
  sp
  ss
  sp
  ss
  have hR0 := readAt_fe_at hkt_off hroom_kt.1.inBounds 12800
    (A := (nielsC (c.tabPt 8) lc.k2d).p) (by omega) (by omega) hread_kt_12800 hread_kt_12864
      hread_kt_12928 hread_kt_12992 hread_kt_13056
  have hG0 := fits_fe_at hkt_off 12800 (by omega) hfits_kt_12800 hfits_kt_12864 hfits_kt_12928
    hfits_kt_12992 hfits_kt_13056
  have hR1 := readAt_fe_at hkt_off hroom_kt.1.inBounds 13120
    (A := (nielsC (c.tabPt 8) lc.k2d).m) (by omega) (by omega) hread_kt_13120 hread_kt_13184
      hread_kt_13248 hread_kt_13312 hread_kt_13376
  have hG1 := fits_fe_at hkt_off 13120 (by omega) hfits_kt_13120 hfits_kt_13184 hfits_kt_13248
    hfits_kt_13312 hfits_kt_13376
  have hR2 := readAt_fe_at hkt_off hroom_kt.1.inBounds 13440
    (A := (nielsC (c.tabPt 8) lc.k2d).k) (by omega) (by omega) hread_kt_13440 hread_kt_13504
      hread_kt_13568 hread_kt_13632 hread_kt_13696
  have hG2 := fits_fe_at hkt_off 13440 (by omega) hfits_kt_13440 hfits_kt_13504 hfits_kt_13568
    hfits_kt_13632 hfits_kt_13696
  have hR3 := readAt_fe_at hkt_off hroom_kt.1.inBounds 13760
    (A := (nielsC (c.tabPt 8) lc.k2d).nk) (by omega) (by omega) hread_kt_13760 hread_kt_13824
      hread_kt_13888 hread_kt_13952 hread_kt_14016
  have hG3 := fits_fe_at hkt_off 13760 (by omega) hfits_kt_13760 hfits_kt_13824 hfits_kt_13888
    hfits_kt_13952 hfits_kt_14016
  have hR4 := readAt_fe_at hkt_off hroom_kt.1.inBounds 14080
    (A := (nielsC (c.tabPt 8) lc.k2d).z) (by omega) (by omega) hread_kt_14080 hread_kt_14144
      hread_kt_14208 hread_kt_14272 hread_kt_14336
  have hG4 := fits_fe_at hkt_off 14080 (by omega) hfits_kt_14080 hfits_kt_14144 hfits_kt_14208
    hfits_kt_14272 hfits_kt_14336
  have hT8 : S.mem.readAt (kt.add 12800#64) 12800 = (c.tab 8).bits := by
    have := readAt_niels_at hkt_off hroom_kt.1.inBounds 12800 (N := nielsC (c.tabPt 8) lc.k2d)
      (by omega) (by omega) hR0 hR1 hR2 hR3 hR4
    rw [nielsC_eq] at this
    exact this
  have hF8 : Fits S.mem (kt.add 12800#64) 12800 :=
    fits_niels_at hkt_off 12800 (by omega) hG0 hG1 hG2 hG3 hG4
  exact hK E S hArgs (by env_reads) ⟨hwf, hfr, hroom_kt, hF0, hT0, hF1, hT1, hF2, hT2, hF3, hT3,
    hF4, hT4, hF5, hT5, hF6, hT6, hF7, hT7, hF8, hT8, hroom_tmp, hb11, hw11⟩

end MLIR.Firedancer.Lane.VerifyX8

