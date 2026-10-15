module

public import Firedancer.Lane.verify_x8.TableSeg
public import Firedancer.Lane.verify_x8.TableTac
public import Firedancer.Lane.verify_x8.TableOps
public import Firedancer.Lane.fd_ed25519_lane_point_dbl
public import Firedancer.Lane.fd_ed25519_lane_point_add
public import Firedancer.Lane.Common.Runs
public import Firedancer.Lane.Common.Tactics

/-! `^bb79`'s entry 4: `fd_ed25519_lane_point_dbl( &p4, &p2, 1 )`, then the result's
`fd_ed25519_lane_to_niels` stored as `ktab[4]`. -/

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
/-- `^bb79` from position 687 to 909: entry 4. -/
public theorem segB4 (c : Call) (M₀ : MemoryState) (kt k2 n1 p2 p3 p4 p6 tmp acc a : Pointer)
    (hp : Ptrs c kt k2 n1 p2 p3 p4 p6 tmp acc a) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : EnvT687 c kt k2 n1 p2 p3 p4 p6 tmp acc a E)
    (hS : StT687 c M₀ kt k2 n1 p2 p3 p4 p6 tmp acc a S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args →
        EnvT909 c kt k2 n1 p2 p3 p4 p6 tmp acc a E' →
          StT909 c M₀ kt k2 n1 p2 p3 p4 p6 tmp acc a S' →
            (_root_.Firedancer.Lane.Mlir.verify_x8.bb79.runBodyFrom E' 909 S' >>= G79 c g) = K) :
    (_root_.Firedancer.Lane.Mlir.verify_x8.bb79.runBodyFrom E 687 S >>= G79 c g) = K := by
  obtain ⟨hkt, hk2, hn1, hp2, hp3, hp4, hp6, htmp, hacc, ha⟩ := hp
  obtain ⟨hwf, hfr, hroom_kt, hF0, hT0, hF1, hT1, hF2, hT2, hF3, hT3, hfe4, hk20, hk21, hk22, hk23,
    hk24, hfN1, hN1, hpf_p2, hpt_p2, hpf_p3, hpt_p3, hroom_p4, hroom_p6, hroom_tmp, hb11, hw11⟩ :=
    hS
  have hkt_off : kt.offset = 0 := by rw [hkt]; rfl
  have hp4_off : p4.offset = 0 := by rw [hp4]; rfl
  have hkt_k : ¬Keep c kt.id := hkt ▸ not_keep_slot c (by decide) (by decide)
  have hp4_k : ¬Keep c p4.id := hp4 ▸ not_keep_slot c (by decide) (by decide)
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
  have hlr : S.mem.LanePointRoom p4 := ⟨nov_of_zero hp4_off (by decide), hroom_p4⟩
  step_call using _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl.call_eq
  hide_body
  have hP : ∀ t0, (c.tabPt 2).dbl (decide True) t0 = c.tabPt 4 := fun _ => rfl
  rw [hP] at hS hread_p4_readLanePoint hread_p4 hread_p4_64 hread_p4_128 hread_p4_192
  rw [hP] at hread_p4_256 hread_p4_320 hread_p4_384 hread_p4_448 hread_p4_512 hread_p4_576
  rw [hP] at hread_p4_640 hread_p4_704 hread_p4_768 hread_p4_832 hread_p4_896 hread_p4_960
  rw [hP] at hread_p4_1024 hread_p4_1088 hread_p4_1152 hread_p4_1216
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
  have hR0 := readAt_fe_at hkt_off hroom_kt.1.inBounds 6400
    (A := (nielsC (c.tabPt 4) lc.k2d).p) (by omega) (by omega) hread_kt_6400 hread_kt_6464
      hread_kt_6528 hread_kt_6592 hread_kt_6656
  have hG0 := fits_fe_at hkt_off 6400 (by omega) hfits_kt_6400 hfits_kt_6464 hfits_kt_6528
    hfits_kt_6592 hfits_kt_6656
  have hR1 := readAt_fe_at hkt_off hroom_kt.1.inBounds 6720
    (A := (nielsC (c.tabPt 4) lc.k2d).m) (by omega) (by omega) hread_kt_6720 hread_kt_6784
      hread_kt_6848 hread_kt_6912 hread_kt_6976
  have hG1 := fits_fe_at hkt_off 6720 (by omega) hfits_kt_6720 hfits_kt_6784 hfits_kt_6848
    hfits_kt_6912 hfits_kt_6976
  have hR2 := readAt_fe_at hkt_off hroom_kt.1.inBounds 7040
    (A := (nielsC (c.tabPt 4) lc.k2d).k) (by omega) (by omega) hread_kt_7040 hread_kt_7104
      hread_kt_7168 hread_kt_7232 hread_kt_7296
  have hG2 := fits_fe_at hkt_off 7040 (by omega) hfits_kt_7040 hfits_kt_7104 hfits_kt_7168
    hfits_kt_7232 hfits_kt_7296
  have hR3 := readAt_fe_at hkt_off hroom_kt.1.inBounds 7360
    (A := (nielsC (c.tabPt 4) lc.k2d).nk) (by omega) (by omega) hread_kt_7360 hread_kt_7424
      hread_kt_7488 hread_kt_7552 hread_kt_7616
  have hG3 := fits_fe_at hkt_off 7360 (by omega) hfits_kt_7360 hfits_kt_7424 hfits_kt_7488
    hfits_kt_7552 hfits_kt_7616
  have hR4 := readAt_fe_at hkt_off hroom_kt.1.inBounds 7680
    (A := (nielsC (c.tabPt 4) lc.k2d).z) (by omega) (by omega) hread_kt_7680 hread_kt_7744
      hread_kt_7808 hread_kt_7872 hread_kt_7936
  have hG4 := fits_fe_at hkt_off 7680 (by omega) hfits_kt_7680 hfits_kt_7744 hfits_kt_7808
    hfits_kt_7872 hfits_kt_7936
  have hT4 : S.mem.readAt (kt.add 6400#64) 12800 = (c.tab 4).bits := by
    have := readAt_niels_at hkt_off hroom_kt.1.inBounds 6400 (N := nielsC (c.tabPt 4) lc.k2d)
      (by omega) (by omega) hR0 hR1 hR2 hR3 hR4
    rw [nielsC_eq] at this
    exact this
  have hF4 : Fits S.mem (kt.add 6400#64) 12800 :=
    fits_niels_at hkt_off 6400 (by omega) hG0 hG1 hG2 hG3 hG4
  exact hK E S hArgs (by env_reads) ⟨hwf, hfr, hroom_kt, hF0, hT0, hF1, hT1, hF2, hT2, hF3, hT3,
    hF4, hT4, hfe4, hk20, hk21, hk22, hk23, hk24, hfN1, hN1, hpf_p3, hpt_p3, hlr,
    hread_p4_readLanePoint, hroom_p6, hroom_tmp, hb11, hw11⟩

end MLIR.Firedancer.Lane.VerifyX8

