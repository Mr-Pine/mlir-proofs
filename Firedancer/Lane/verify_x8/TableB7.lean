module

public import Firedancer.Lane.verify_x8.TableSeg
public import Firedancer.Lane.verify_x8.TableTac
public import Firedancer.Lane.verify_x8.TableOps
public import Firedancer.Lane.fd_ed25519_lane_point_dbl
public import Firedancer.Lane.fd_ed25519_lane_point_add
public import Firedancer.Lane.Common.Runs
public import Firedancer.Lane.Common.Tactics

/-! `^bb79`'s entry 7: `fd_ed25519_lane_point_add( &tmp, &p6, &n1, 1, 1 )`, then the result's
`fd_ed25519_lane_to_niels` stored as `ktab[7]`. -/

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
/-- `^bb79` from position 1353 to 1561: entry 7. -/
public theorem segB7 (c : Call) (M₀ : MemoryState) (kt k2 n1 p2 p3 p4 p6 tmp acc a : Pointer)
    (hp : Ptrs c kt k2 n1 p2 p3 p4 p6 tmp acc a) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : EnvT1353 c kt k2 n1 p2 p3 p4 p6 tmp acc a E)
    (hS : StT1353 c M₀ kt k2 n1 p2 p3 p4 p6 tmp acc a S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args →
        EnvT1561 c kt k2 n1 p2 p3 p4 p6 tmp acc a E' →
          StT1561 c M₀ kt k2 n1 p2 p3 p4 p6 tmp acc a S' →
            (_root_.Firedancer.Lane.Mlir.verify_x8.bb79.runBodyFrom E' 1561 S' >>= G79 c g) = K) :
    (_root_.Firedancer.Lane.Mlir.verify_x8.bb79.runBodyFrom E 1353 S >>= G79 c g) = K := by
  obtain ⟨hkt, hk2, hn1, hp2, hp3, hp4, hp6, htmp, hacc, ha⟩ := hp
  obtain ⟨hwf, hfr, hroom_kt, hF0, hT0, hF1, hT1, hF2, hT2, hF3, hT3, hF4, hT4, hF5, hT5, hF6, hT6,
    hfe4, hk20, hk21, hk22, hk23, hk24, hfN1, hN1, hpf_p4, hpt_p4, hpf_p6, hpt_p6, hroom_tmp, hb11,
    hw11⟩ := hS
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
  step_call using _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_point_add.call_eq
  hide_body
  have hP : (c.tabPt 6).add (c.tab 1) true true Fe.zero = c.tabPt 7 := rfl
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
  subst_vals
  have hR0 := readAt_fe_at hkt_off hroom_kt.1.inBounds 11200
    (A := (nielsC (c.tabPt 7) lc.k2d).p) (by omega) (by omega) hread_kt_11200 hread_kt_11264
      hread_kt_11328 hread_kt_11392 hread_kt_11456
  have hG0 := fits_fe_at hkt_off 11200 (by omega) hfits_kt_11200 hfits_kt_11264 hfits_kt_11328
    hfits_kt_11392 hfits_kt_11456
  have hR1 := readAt_fe_at hkt_off hroom_kt.1.inBounds 11520
    (A := (nielsC (c.tabPt 7) lc.k2d).m) (by omega) (by omega) hread_kt_11520 hread_kt_11584
      hread_kt_11648 hread_kt_11712 hread_kt_11776
  have hG1 := fits_fe_at hkt_off 11520 (by omega) hfits_kt_11520 hfits_kt_11584 hfits_kt_11648
    hfits_kt_11712 hfits_kt_11776
  have hR2 := readAt_fe_at hkt_off hroom_kt.1.inBounds 11840
    (A := (nielsC (c.tabPt 7) lc.k2d).k) (by omega) (by omega) hread_kt_11840 hread_kt_11904
      hread_kt_11968 hread_kt_12032 hread_kt_12096
  have hG2 := fits_fe_at hkt_off 11840 (by omega) hfits_kt_11840 hfits_kt_11904 hfits_kt_11968
    hfits_kt_12032 hfits_kt_12096
  have hR3 := readAt_fe_at hkt_off hroom_kt.1.inBounds 12160
    (A := (nielsC (c.tabPt 7) lc.k2d).nk) (by omega) (by omega) hread_kt_12160 hread_kt_12224
      hread_kt_12288 hread_kt_12352 hread_kt_12416
  have hG3 := fits_fe_at hkt_off 12160 (by omega) hfits_kt_12160 hfits_kt_12224 hfits_kt_12288
    hfits_kt_12352 hfits_kt_12416
  have hR4 := readAt_fe_at hkt_off hroom_kt.1.inBounds 12480
    (A := (nielsC (c.tabPt 7) lc.k2d).z) (by omega) (by omega) hread_kt_12480 hread_kt_12544
      hread_kt_12608 hread_kt_12672 hread_kt_12736
  have hG4 := fits_fe_at hkt_off 12480 (by omega) hfits_kt_12480 hfits_kt_12544 hfits_kt_12608
    hfits_kt_12672 hfits_kt_12736
  have hT7 : S.mem.readAt (kt.add 11200#64) 12800 = (c.tab 7).bits := by
    have := readAt_niels_at hkt_off hroom_kt.1.inBounds 11200 (N := nielsC (c.tabPt 7) lc.k2d)
      (by omega) (by omega) hR0 hR1 hR2 hR3 hR4
    rw [nielsC_eq] at this
    exact this
  have hF7 : Fits S.mem (kt.add 11200#64) 12800 :=
    fits_niels_at hkt_off 11200 (by omega) hG0 hG1 hG2 hG3 hG4
  exact hK E S hArgs (by env_reads) ⟨hwf, hfr, hroom_kt, hF0, hT0, hF1, hT1, hF2, hT2, hF3, hT3,
    hF4, hT4, hF5, hT5, hF6, hT6, hF7, hT7, hpf_p4, hpt_p4, hroom_tmp, hb11, hw11⟩

end MLIR.Firedancer.Lane.VerifyX8

