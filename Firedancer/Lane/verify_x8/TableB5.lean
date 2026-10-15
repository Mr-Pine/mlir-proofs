module

public import Firedancer.Lane.verify_x8.TableSeg
public import Firedancer.Lane.verify_x8.TableTac
public import Firedancer.Lane.verify_x8.TableOps
public import Firedancer.Lane.fd_ed25519_lane_point_dbl
public import Firedancer.Lane.fd_ed25519_lane_point_add
public import Firedancer.Lane.Common.Runs
public import Firedancer.Lane.Common.Tactics

/-! `^bb79`'s entry 5: `fd_ed25519_lane_point_add( &tmp, &p4, &n1, 1, 1 )`, then the result's
`fd_ed25519_lane_to_niels` stored as `ktab[5]`. -/

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
/-- `^bb79` from position 909 to 1131: entry 5. -/
public theorem segB5 (c : Call) (M₀ : MemoryState) (kt k2 n1 p2 p3 p4 p6 tmp acc a : Pointer)
    (hp : Ptrs c kt k2 n1 p2 p3 p4 p6 tmp acc a) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : EnvT909 c kt k2 n1 p2 p3 p4 p6 tmp acc a E)
    (hS : StT909 c M₀ kt k2 n1 p2 p3 p4 p6 tmp acc a S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args →
        EnvT1131 c kt k2 n1 p2 p3 p4 p6 tmp acc a E' →
          StT1131 c M₀ kt k2 n1 p2 p3 p4 p6 tmp acc a S' →
            (_root_.Firedancer.Lane.Mlir.verify_x8.bb79.runBodyFrom E' 1131 S' >>= G79 c g) = K) :
    (_root_.Firedancer.Lane.Mlir.verify_x8.bb79.runBodyFrom E 909 S >>= G79 c g) = K := by
  obtain ⟨hkt, hk2, hn1, hp2, hp3, hp4, hp6, htmp, hacc, ha⟩ := hp
  obtain ⟨hwf, hfr, hroom_kt, hF0, hT0, hF1, hT1, hF2, hT2, hF3, hT3, hF4, hT4, hfe4, hk20, hk21,
    hk22, hk23, hk24, hfN1, hN1, hpf_p3, hpt_p3, hpf_p4, hpt_p4, hroom_p6, hroom_tmp, hb11, hw11⟩ :=
    hS
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
  have hP : (c.tabPt 4).add (c.tab 1) true true Fe.zero = c.tabPt 5 := rfl
  rw [hP] at hS hread_tmp_readLanePoint hread_tmp hread_tmp_64 hread_tmp_128 hread_tmp_192
  rw [hP] at hread_tmp_256 hread_tmp_320 hread_tmp_384 hread_tmp_448 hread_tmp_512 hread_tmp_576
  rw [hP] at hread_tmp_640 hread_tmp_704 hread_tmp_768 hread_tmp_832 hread_tmp_896 hread_tmp_960
  rw [hP] at hread_tmp_1024 hread_tmp_1088 hread_tmp_1152 hread_tmp_1216
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
  have hR0 := readAt_fe_at hkt_off hroom_kt.1.inBounds 8000
    (A := (nielsC (c.tabPt 5) lc.k2d).p) (by omega) (by omega) hread_kt_8000 hread_kt_8064
      hread_kt_8128 hread_kt_8192 hread_kt_8256
  have hG0 := fits_fe_at hkt_off 8000 (by omega) hfits_kt_8000 hfits_kt_8064 hfits_kt_8128
    hfits_kt_8192 hfits_kt_8256
  have hR1 := readAt_fe_at hkt_off hroom_kt.1.inBounds 8320
    (A := (nielsC (c.tabPt 5) lc.k2d).m) (by omega) (by omega) hread_kt_8320 hread_kt_8384
      hread_kt_8448 hread_kt_8512 hread_kt_8576
  have hG1 := fits_fe_at hkt_off 8320 (by omega) hfits_kt_8320 hfits_kt_8384 hfits_kt_8448
    hfits_kt_8512 hfits_kt_8576
  have hR2 := readAt_fe_at hkt_off hroom_kt.1.inBounds 8640
    (A := (nielsC (c.tabPt 5) lc.k2d).k) (by omega) (by omega) hread_kt_8640 hread_kt_8704
      hread_kt_8768 hread_kt_8832 hread_kt_8896
  have hG2 := fits_fe_at hkt_off 8640 (by omega) hfits_kt_8640 hfits_kt_8704 hfits_kt_8768
    hfits_kt_8832 hfits_kt_8896
  have hR3 := readAt_fe_at hkt_off hroom_kt.1.inBounds 8960
    (A := (nielsC (c.tabPt 5) lc.k2d).nk) (by omega) (by omega) hread_kt_8960 hread_kt_9024
      hread_kt_9088 hread_kt_9152 hread_kt_9216
  have hG3 := fits_fe_at hkt_off 8960 (by omega) hfits_kt_8960 hfits_kt_9024 hfits_kt_9088
    hfits_kt_9152 hfits_kt_9216
  have hR4 := readAt_fe_at hkt_off hroom_kt.1.inBounds 9280
    (A := (nielsC (c.tabPt 5) lc.k2d).z) (by omega) (by omega) hread_kt_9280 hread_kt_9344
      hread_kt_9408 hread_kt_9472 hread_kt_9536
  have hG4 := fits_fe_at hkt_off 9280 (by omega) hfits_kt_9280 hfits_kt_9344 hfits_kt_9408
    hfits_kt_9472 hfits_kt_9536
  have hT5 : S.mem.readAt (kt.add 8000#64) 12800 = (c.tab 5).bits := by
    have := readAt_niels_at hkt_off hroom_kt.1.inBounds 8000 (N := nielsC (c.tabPt 5) lc.k2d)
      (by omega) (by omega) hR0 hR1 hR2 hR3 hR4
    rw [nielsC_eq] at this
    exact this
  have hF5 : Fits S.mem (kt.add 8000#64) 12800 :=
    fits_niels_at hkt_off 8000 (by omega) hG0 hG1 hG2 hG3 hG4
  exact hK E S hArgs (by env_reads) ⟨hwf, hfr, hroom_kt, hF0, hT0, hF1, hT1, hF2, hT2, hF3, hT3,
    hF4, hT4, hF5, hT5, hfe4, hk20, hk21, hk22, hk23, hk24, hfN1, hN1, hpf_p3, hpt_p3, hpf_p4,
    hpt_p4, hroom_p6, hroom_tmp, hb11, hw11⟩

end MLIR.Firedancer.Lane.VerifyX8

