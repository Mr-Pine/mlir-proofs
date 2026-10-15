module

public import Firedancer.Lane.verify_x8.TableSeg
public import Firedancer.Lane.verify_x8.TableTac
public import Firedancer.Lane.verify_x8.TableOps
public import Firedancer.Lane.fd_ed25519_lane_point_dbl
public import Firedancer.Lane.fd_ed25519_lane_point_add
public import Firedancer.Lane.Common.Runs
public import Firedancer.Lane.Common.Tactics

/-! `^bb79`'s entry 3: `fd_ed25519_lane_point_add( &p3, &p2, &n1, 1, 1 )`, then the result's
`fd_ed25519_lane_to_niels` stored as `ktab[3]`. -/

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
/-- `^bb79` from position 465 to 687: entry 3. -/
public theorem segB3 (c : Call) (M₀ : MemoryState) (kt k2 n1 p2 p3 p4 p6 tmp acc a : Pointer)
    (hp : Ptrs c kt k2 n1 p2 p3 p4 p6 tmp acc a) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : EnvT465 c kt k2 n1 p2 p3 p4 p6 tmp acc a E)
    (hS : StT465 c M₀ kt k2 n1 p2 p3 p4 p6 tmp acc a S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args →
        EnvT687 c kt k2 n1 p2 p3 p4 p6 tmp acc a E' →
          StT687 c M₀ kt k2 n1 p2 p3 p4 p6 tmp acc a S' →
            (_root_.Firedancer.Lane.Mlir.verify_x8.bb79.runBodyFrom E' 687 S' >>= G79 c g) = K) :
    (_root_.Firedancer.Lane.Mlir.verify_x8.bb79.runBodyFrom E 465 S >>= G79 c g) = K := by
  obtain ⟨hkt, hk2, hn1, hp2, hp3, hp4, hp6, htmp, hacc, ha⟩ := hp
  obtain ⟨hwf, hfr, hroom_kt, hF0, hT0, hF1, hT1, hF2, hT2, hfe4, hk20, hk21, hk22, hk23, hk24,
    hfN1, hN1, hpf_p2, hpt_p2, hroom_p3, hroom_p4, hroom_p6, hroom_tmp, hb11, hw11⟩ := hS
  have hkt_off : kt.offset = 0 := by rw [hkt]; rfl
  have hp3_off : p3.offset = 0 := by rw [hp3]; rfl
  have hkt_k : ¬Keep c kt.id := hkt ▸ not_keep_slot c (by decide) (by decide)
  have hp3_k : ¬Keep c p3.id := hp3 ▸ not_keep_slot c (by decide) (by decide)
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
  have hlr : S.mem.LanePointRoom p3 := ⟨nov_of_zero hp3_off (by decide), hroom_p3⟩
  step_call using _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_point_add.call_eq
  hide_body
  have hP : (c.tabPt 2).add (c.tab 1) true true Fe.zero = c.tabPt 3 := rfl
  rw [hP] at hS hread_p3_readLanePoint hread_p3 hread_p3_64 hread_p3_128 hread_p3_192
  rw [hP] at hread_p3_256 hread_p3_320 hread_p3_384 hread_p3_448 hread_p3_512 hread_p3_576
  rw [hP] at hread_p3_640 hread_p3_704 hread_p3_768 hread_p3_832 hread_p3_896 hread_p3_960
  rw [hP] at hread_p3_1024 hread_p3_1088 hread_p3_1152 hread_p3_1216
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
  have hR0 := readAt_fe_at hkt_off hroom_kt.1.inBounds 4800
    (A := (nielsC (c.tabPt 3) lc.k2d).p) (by omega) (by omega) hread_kt_4800 hread_kt_4864
      hread_kt_4928 hread_kt_4992 hread_kt_5056
  have hG0 := fits_fe_at hkt_off 4800 (by omega) hfits_kt_4800 hfits_kt_4864 hfits_kt_4928
    hfits_kt_4992 hfits_kt_5056
  have hR1 := readAt_fe_at hkt_off hroom_kt.1.inBounds 5120
    (A := (nielsC (c.tabPt 3) lc.k2d).m) (by omega) (by omega) hread_kt_5120 hread_kt_5184
      hread_kt_5248 hread_kt_5312 hread_kt_5376
  have hG1 := fits_fe_at hkt_off 5120 (by omega) hfits_kt_5120 hfits_kt_5184 hfits_kt_5248
    hfits_kt_5312 hfits_kt_5376
  have hR2 := readAt_fe_at hkt_off hroom_kt.1.inBounds 5440
    (A := (nielsC (c.tabPt 3) lc.k2d).k) (by omega) (by omega) hread_kt_5440 hread_kt_5504
      hread_kt_5568 hread_kt_5632 hread_kt_5696
  have hG2 := fits_fe_at hkt_off 5440 (by omega) hfits_kt_5440 hfits_kt_5504 hfits_kt_5568
    hfits_kt_5632 hfits_kt_5696
  have hR3 := readAt_fe_at hkt_off hroom_kt.1.inBounds 5760
    (A := (nielsC (c.tabPt 3) lc.k2d).nk) (by omega) (by omega) hread_kt_5760 hread_kt_5824
      hread_kt_5888 hread_kt_5952 hread_kt_6016
  have hG3 := fits_fe_at hkt_off 5760 (by omega) hfits_kt_5760 hfits_kt_5824 hfits_kt_5888
    hfits_kt_5952 hfits_kt_6016
  have hR4 := readAt_fe_at hkt_off hroom_kt.1.inBounds 6080
    (A := (nielsC (c.tabPt 3) lc.k2d).z) (by omega) (by omega) hread_kt_6080 hread_kt_6144
      hread_kt_6208 hread_kt_6272 hread_kt_6336
  have hG4 := fits_fe_at hkt_off 6080 (by omega) hfits_kt_6080 hfits_kt_6144 hfits_kt_6208
    hfits_kt_6272 hfits_kt_6336
  have hT3 : S.mem.readAt (kt.add 4800#64) 12800 = (c.tab 3).bits := by
    have := readAt_niels_at hkt_off hroom_kt.1.inBounds 4800 (N := nielsC (c.tabPt 3) lc.k2d)
      (by omega) (by omega) hR0 hR1 hR2 hR3 hR4
    rw [nielsC_eq] at this
    exact this
  have hF3 : Fits S.mem (kt.add 4800#64) 12800 :=
    fits_niels_at hkt_off 4800 (by omega) hG0 hG1 hG2 hG3 hG4
  exact hK E S hArgs (by env_reads) ⟨hwf, hfr, hroom_kt, hF0, hT0, hF1, hT1, hF2, hT2, hF3, hT3,
    hfe4, hk20, hk21, hk22, hk23, hk24, hfN1, hN1, hpf_p2, hpt_p2, hlr, hread_p3_readLanePoint,
    hroom_p4, hroom_p6, hroom_tmp, hb11, hw11⟩

end MLIR.Firedancer.Lane.VerifyX8

