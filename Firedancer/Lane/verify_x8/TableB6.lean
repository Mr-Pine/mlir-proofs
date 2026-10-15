module

public import Firedancer.Lane.verify_x8.TableSeg
public import Firedancer.Lane.verify_x8.TableTac
public import Firedancer.Lane.verify_x8.TableOps
public import Firedancer.Lane.fd_ed25519_lane_point_dbl
public import Firedancer.Lane.fd_ed25519_lane_point_add
public import Firedancer.Lane.Common.Runs
public import Firedancer.Lane.Common.Tactics

/-! `^bb79`'s entry 6: `fd_ed25519_lane_point_dbl( &p6, &p3, 1 )`, then the result's
`fd_ed25519_lane_to_niels` stored as `ktab[6]`. -/

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
/-- `^bb79` from position 1131 to 1353: entry 6. -/
public theorem segB6 (c : Call) (M₀ : MemoryState) (kt k2 n1 p2 p3 p4 p6 tmp acc a : Pointer)
    (hp : Ptrs c kt k2 n1 p2 p3 p4 p6 tmp acc a) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : EnvT1131 c kt k2 n1 p2 p3 p4 p6 tmp acc a E)
    (hS : StT1131 c M₀ kt k2 n1 p2 p3 p4 p6 tmp acc a S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args →
        EnvT1353 c kt k2 n1 p2 p3 p4 p6 tmp acc a E' →
          StT1353 c M₀ kt k2 n1 p2 p3 p4 p6 tmp acc a S' →
            (_root_.Firedancer.Lane.Mlir.verify_x8.bb79.runBodyFrom E' 1353 S' >>= G79 c g) = K) :
    (_root_.Firedancer.Lane.Mlir.verify_x8.bb79.runBodyFrom E 1131 S >>= G79 c g) = K := by
  obtain ⟨hkt, hk2, hn1, hp2, hp3, hp4, hp6, htmp, hacc, ha⟩ := hp
  obtain ⟨hwf, hfr, hroom_kt, hF0, hT0, hF1, hT1, hF2, hT2, hF3, hT3, hF4, hT4, hF5, hT5, hfe4,
    hk20, hk21, hk22, hk23, hk24, hfN1, hN1, hpf_p3, hpt_p3, hpf_p4, hpt_p4, hroom_p6, hroom_tmp,
    hb11, hw11⟩ := hS
  have hkt_off : kt.offset = 0 := by rw [hkt]; rfl
  have hp6_off : p6.offset = 0 := by rw [hp6]; rfl
  have hkt_k : ¬Keep c kt.id := hkt ▸ not_keep_slot c (by decide) (by decide)
  have hp6_k : ¬Keep c p6.id := hp6 ▸ not_keep_slot c (by decide) (by decide)
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
  have hlr : S.mem.LanePointRoom p6 := ⟨nov_of_zero hp6_off (by decide), hroom_p6⟩
  step_call using _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl.call_eq
  hide_body
  have hP : ∀ t0, (c.tabPt 3).dbl (decide True) t0 = c.tabPt 6 := fun _ => rfl
  rw [hP] at hS hread_p6_readLanePoint hread_p6 hread_p6_64 hread_p6_128 hread_p6_192
  rw [hP] at hread_p6_256 hread_p6_320 hread_p6_384 hread_p6_448 hread_p6_512 hread_p6_576
  rw [hP] at hread_p6_640 hread_p6_704 hread_p6_768 hread_p6_832 hread_p6_896 hread_p6_960
  rw [hP] at hread_p6_1024 hread_p6_1088 hread_p6_1152 hread_p6_1216
  clear hP
  sp
  slv
  slv
  sp
  sp
  slv
  sp
  slv
  sp
  sp
  slv
  sp
  slv
  sp
  sp
  slv
  sp
  slv
  sp
  sp
  slv
  sp
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
  sp
  slv
  sp
  slv
  sp
  slv
  sp
  slv
  sp
  slv
  sp
  slv
  sp
  slv
  sp
  slv
  sp
  slv
  sp
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
  have hR0 := readAt_fe_at hkt_off hroom_kt.1.inBounds 9600
    (A := (nielsC (c.tabPt 6) lc.k2d).p) (by omega) (by omega) hread_kt_9600 hread_kt_9664
      hread_kt_9728 hread_kt_9792 hread_kt_9856
  have hG0 := fits_fe_at hkt_off 9600 (by omega) hfits_kt_9600 hfits_kt_9664 hfits_kt_9728
    hfits_kt_9792 hfits_kt_9856
  have hR1 := readAt_fe_at hkt_off hroom_kt.1.inBounds 9920
    (A := (nielsC (c.tabPt 6) lc.k2d).m) (by omega) (by omega) hread_kt_9920 hread_kt_9984
      hread_kt_10048 hread_kt_10112 hread_kt_10176
  have hG1 := fits_fe_at hkt_off 9920 (by omega) hfits_kt_9920 hfits_kt_9984 hfits_kt_10048
    hfits_kt_10112 hfits_kt_10176
  have hR2 := readAt_fe_at hkt_off hroom_kt.1.inBounds 10240
    (A := (nielsC (c.tabPt 6) lc.k2d).k) (by omega) (by omega) hread_kt_10240 hread_kt_10304
      hread_kt_10368 hread_kt_10432 hread_kt_10496
  have hG2 := fits_fe_at hkt_off 10240 (by omega) hfits_kt_10240 hfits_kt_10304 hfits_kt_10368
    hfits_kt_10432 hfits_kt_10496
  have hR3 := readAt_fe_at hkt_off hroom_kt.1.inBounds 10560
    (A := (nielsC (c.tabPt 6) lc.k2d).nk) (by omega) (by omega) hread_kt_10560 hread_kt_10624
      hread_kt_10688 hread_kt_10752 hread_kt_10816
  have hG3 := fits_fe_at hkt_off 10560 (by omega) hfits_kt_10560 hfits_kt_10624 hfits_kt_10688
    hfits_kt_10752 hfits_kt_10816
  have hR4 := readAt_fe_at hkt_off hroom_kt.1.inBounds 10880
    (A := (nielsC (c.tabPt 6) lc.k2d).z) (by omega) (by omega) hread_kt_10880 hread_kt_10944
      hread_kt_11008 hread_kt_11072 hread_kt_11136
  have hG4 := fits_fe_at hkt_off 10880 (by omega) hfits_kt_10880 hfits_kt_10944 hfits_kt_11008
    hfits_kt_11072 hfits_kt_11136
  have hT6 : S.mem.readAt (kt.add 9600#64) 12800 = (c.tab 6).bits := by
    have := readAt_niels_at hkt_off hroom_kt.1.inBounds 9600 (N := nielsC (c.tabPt 6) lc.k2d)
      (by omega) (by omega) hR0 hR1 hR2 hR3 hR4
    rw [nielsC_eq] at this
    exact this
  have hF6 : Fits S.mem (kt.add 9600#64) 12800 :=
    fits_niels_at hkt_off 9600 (by omega) hG0 hG1 hG2 hG3 hG4
  exact hK E S hArgs (by env_reads) ⟨hwf, hfr, hroom_kt, hF0, hT0, hF1, hT1, hF2, hT2, hF3, hT3,
    hF4, hT4, hF5, hT5, hF6, hT6, hfe4, hk20, hk21, hk22, hk23, hk24, hfN1, hN1, hpf_p4, hpt_p4,
    hlr, hread_p6_readLanePoint, hroom_tmp, hb11, hw11⟩

end MLIR.Firedancer.Lane.VerifyX8

