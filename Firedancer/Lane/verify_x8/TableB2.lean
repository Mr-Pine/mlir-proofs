module

public import Firedancer.Lane.verify_x8.TableSeg
public import Firedancer.Lane.verify_x8.TableTac
public import Firedancer.Lane.verify_x8.TableOps
public import Firedancer.Lane.fd_ed25519_lane_point_dbl
public import Firedancer.Lane.fd_ed25519_lane_point_add
public import Firedancer.Lane.Common.Runs
public import Firedancer.Lane.Common.Tactics

/-! `^bb79`'s entry 2: `fd_ed25519_lane_point_dbl( &p2, a, 1 )`, then the result's
`fd_ed25519_lane_to_niels` stored as `ktab[2]`. -/

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
/-- `^bb79` from position 243 to 465: entry 2. -/
public theorem segB2 (c : Call) (M₀ : MemoryState) (kt k2 n1 p2 p3 p4 p6 tmp acc a : Pointer)
    (hp : Ptrs c kt k2 n1 p2 p3 p4 p6 tmp acc a) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : EnvT243 c kt k2 n1 p2 p3 p4 p6 tmp acc a E)
    (hS : StT243 c M₀ kt k2 n1 p2 p3 p4 p6 tmp acc a S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args →
        EnvT465 c kt k2 n1 p2 p3 p4 p6 tmp acc a E' →
          StT465 c M₀ kt k2 n1 p2 p3 p4 p6 tmp acc a S' →
            (_root_.Firedancer.Lane.Mlir.verify_x8.bb79.runBodyFrom E' 465 S' >>= G79 c g) = K) :
    (_root_.Firedancer.Lane.Mlir.verify_x8.bb79.runBodyFrom E 243 S >>= G79 c g) = K := by
  obtain ⟨hkt, hk2, hn1, hp2, hp3, hp4, hp6, htmp, hacc, ha⟩ := hp
  obtain ⟨hwf, hfr, hroom_kt, hF0, hT0, hF1, hT1, hfe4, hk20, hk21, hk22, hk23, hk24, hfN1, hN1,
    hroom_p2, hroom_p3, hroom_p4, hroom_p6, hroom_tmp, hb11, hw11, haf, har⟩ := hS
  have hkt_off : kt.offset = 0 := by rw [hkt]; rfl
  have hp2_off : p2.offset = 0 := by rw [hp2]; rfl
  have hkt_k : ¬Keep c kt.id := hkt ▸ not_keep_slot c (by decide) (by decide)
  have hp2_k : ¬Keep c p2.id := hp2 ▸ not_keep_slot c (by decide) (by decide)
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
  have hlr : S.mem.LanePointRoom p2 := ⟨nov_of_zero hp2_off (by decide), hroom_p2⟩
  step_call using _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_point_dbl.call_eq
  hide_body
  have hP : ∀ t0, c.aNeg.dbl (decide True) t0 = c.tabPt 2 := fun _ => rfl
  rw [hP] at hS hread_p2_readLanePoint hread_p2 hread_p2_64 hread_p2_128 hread_p2_192
  rw [hP] at hread_p2_256 hread_p2_320 hread_p2_384 hread_p2_448 hread_p2_512 hread_p2_576
  rw [hP] at hread_p2_640 hread_p2_704 hread_p2_768 hread_p2_832 hread_p2_896 hread_p2_960
  rw [hP] at hread_p2_1024 hread_p2_1088 hread_p2_1152 hread_p2_1216
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
  have hR0 := readAt_fe_at hkt_off hroom_kt.1.inBounds 3200
    (A := (nielsC (c.tabPt 2) lc.k2d).p) (by omega) (by omega) hread_kt_3200 hread_kt_3264
      hread_kt_3328 hread_kt_3392 hread_kt_3456
  have hG0 := fits_fe_at hkt_off 3200 (by omega) hfits_kt_3200 hfits_kt_3264 hfits_kt_3328
    hfits_kt_3392 hfits_kt_3456
  have hR1 := readAt_fe_at hkt_off hroom_kt.1.inBounds 3520
    (A := (nielsC (c.tabPt 2) lc.k2d).m) (by omega) (by omega) hread_kt_3520 hread_kt_3584
      hread_kt_3648 hread_kt_3712 hread_kt_3776
  have hG1 := fits_fe_at hkt_off 3520 (by omega) hfits_kt_3520 hfits_kt_3584 hfits_kt_3648
    hfits_kt_3712 hfits_kt_3776
  have hR2 := readAt_fe_at hkt_off hroom_kt.1.inBounds 3840
    (A := (nielsC (c.tabPt 2) lc.k2d).k) (by omega) (by omega) hread_kt_3840 hread_kt_3904
      hread_kt_3968 hread_kt_4032 hread_kt_4096
  have hG2 := fits_fe_at hkt_off 3840 (by omega) hfits_kt_3840 hfits_kt_3904 hfits_kt_3968
    hfits_kt_4032 hfits_kt_4096
  have hR3 := readAt_fe_at hkt_off hroom_kt.1.inBounds 4160
    (A := (nielsC (c.tabPt 2) lc.k2d).nk) (by omega) (by omega) hread_kt_4160 hread_kt_4224
      hread_kt_4288 hread_kt_4352 hread_kt_4416
  have hG3 := fits_fe_at hkt_off 4160 (by omega) hfits_kt_4160 hfits_kt_4224 hfits_kt_4288
    hfits_kt_4352 hfits_kt_4416
  have hR4 := readAt_fe_at hkt_off hroom_kt.1.inBounds 4480
    (A := (nielsC (c.tabPt 2) lc.k2d).z) (by omega) (by omega) hread_kt_4480 hread_kt_4544
      hread_kt_4608 hread_kt_4672 hread_kt_4736
  have hG4 := fits_fe_at hkt_off 4480 (by omega) hfits_kt_4480 hfits_kt_4544 hfits_kt_4608
    hfits_kt_4672 hfits_kt_4736
  have hT2 : S.mem.readAt (kt.add 3200#64) 12800 = (c.tab 2).bits := by
    have := readAt_niels_at hkt_off hroom_kt.1.inBounds 3200 (N := nielsC (c.tabPt 2) lc.k2d)
      (by omega) (by omega) hR0 hR1 hR2 hR3 hR4
    rw [nielsC_eq] at this
    exact this
  have hF2 : Fits S.mem (kt.add 3200#64) 12800 :=
    fits_niels_at hkt_off 3200 (by omega) hG0 hG1 hG2 hG3 hG4
  exact hK E S hArgs (by env_reads) ⟨hwf, hfr, hroom_kt, hF0, hT0, hF1, hT1, hF2, hT2, hfe4, hk20,
    hk21, hk22, hk23, hk24, hfN1, hN1, hlr, hread_p2_readLanePoint, hroom_p3, hroom_p4, hroom_p6,
    hroom_tmp, hb11, hw11⟩

end MLIR.Firedancer.Lane.VerifyX8

