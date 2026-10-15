module

public import Firedancer.Lane.verify_x8.TableSeg
public import Firedancer.Lane.verify_x8.TableTac
public import Firedancer.Lane.verify_x8.TableOps
public import Firedancer.Lane.fd_ed25519_lane_bcast_fe
public import Firedancer.Lane.Common.Runs
public import Firedancer.Lane.Common.Tactics

/-! `^bb79` up to entry 2: `k2d` broadcast, entry 0 (`Niels.zero`) stored, and entry 1,
`fd_ed25519_lane_to_niels( &n1, a, &k2d )`, stored into `n1` and copied into `ktab`. -/

namespace MLIR.Firedancer.Lane.VerifyX8

open Firedancer.Avx512
open _root_.Firedancer.Lane.Mlir (verify_x8)
open _root_.Firedancer.Lane.Mlir.verify_x8 (Γ hty)

/-- `fd_f25519_k`'s bytes. -/
theorem tobytes_k2d :
    tobytes #v[3934839304537#64, 507525298899#64, 15037786634#64, 521695520920#64,
        6596238350568#64, 309467527341#64, 0#64, 0#64] = k2dBytes := by
  decide

/-- `k2d`: the broadcast `fd_f25519_k`. -/
theorem bcast_k2d :
    bcastBytes (tobytes #v[3934839304537#64, 507525298899#64, 15037786634#64, 521695520920#64,
        6596238350568#64, 309467527341#64, 0#64, 0#64]) = lc.k2d := by
  rw [tobytes_k2d]; rfl

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

variable {β : Type} {g : Vals [] × GlobalState → PoisonOr β} {K : PoisonOr β}

-- 243 instructions, a call and an inlined product, in one declaration
set_option maxHeartbeats 4000000 in
/-- `^bb79` from its start to the first `fd_ed25519_lane_point_dbl`. -/
public theorem segA (c : Call) (M₀ : MemoryState) (kt k2 n1 p2 p3 p4 p6 tmp acc a : Pointer)
    (hp : Ptrs c kt k2 n1 p2 p3 p4 p6 tmp acc a) (E : ⟪Γ⟫) (S : GlobalState)
    (hA : E.args = c.args) (hE : EnvT0 c kt k2 n1 p2 p3 p4 p6 tmp acc a E)
    (hS : StT0 c M₀ kt k2 n1 p2 p3 p4 p6 tmp acc a S)
    (hK :
      ∀ (E' : ⟪Γ⟫) (S' : GlobalState), E'.args = c.args →
        EnvT243 c kt k2 n1 p2 p3 p4 p6 tmp acc a E' →
          StT243 c M₀ kt k2 n1 p2 p3 p4 p6 tmp acc a S' →
            (_root_.Firedancer.Lane.Mlir.verify_x8.bb79.runBodyFrom E' 243 S' >>= G79 c g) = K) :
    (_root_.Firedancer.Lane.Mlir.verify_x8.bb79.runBodyFrom E 0 S >>= G79 c g) = K := by
  obtain ⟨hkt, hk2, hn1, hp2, hp3, hp4, hp6, htmp, hacc, ha⟩ := hp
  obtain ⟨hwf, hfr, hb3, hw3, hb4, hw4, hb5, hw5, hb6, hw6, hb7, hw7, hb8, hw8, hb9, hw9, hb10,
    hw10, hb11, hw11, haf, har⟩ := hS
  have hkt_off : kt.offset = 0 := by rw [hkt]; rfl
  have hk2_off : k2.offset = 0 := by rw [hk2]; rfl
  have hn1_off : n1.offset = 0 := by rw [hn1]; rfl
  have hp2_off : p2.offset = 0 := by rw [hp2]; rfl
  have hp3_off : p3.offset = 0 := by rw [hp3]; rfl
  have hp4_off : p4.offset = 0 := by rw [hp4]; rfl
  have hp6_off : p6.offset = 0 := by rw [hp6]; rfl
  have htmp_off : tmp.offset = 0 := by rw [htmp]; rfl
  have hacc_off : acc.offset = 0 := by rw [hacc]; rfl
  have ha_off : a.offset = 0 := by rw [ha]; rfl
  have hkt_k : ¬Keep c kt.id := hkt ▸ not_keep_slot c (by decide) (by decide)
  have hk2_k : ¬Keep c k2.id := hk2 ▸ not_keep_slot c (by decide) (by decide)
  have hn1_k : ¬Keep c n1.id := hn1 ▸ not_keep_slot c (by decide) (by decide)
  have hp2_k : ¬Keep c p2.id := hp2 ▸ not_keep_slot c (by decide) (by decide)
  have hp3_k : ¬Keep c p3.id := hp3 ▸ not_keep_slot c (by decide) (by decide)
  have hp4_k : ¬Keep c p4.id := hp4 ▸ not_keep_slot c (by decide) (by decide)
  have hp6_k : ¬Keep c p6.id := hp6 ▸ not_keep_slot c (by decide) (by decide)
  have htmp_k : ¬Keep c tmp.id := htmp ▸ not_keep_slot c (by decide) (by decide)
  have hn1ov : ¬n1.offset.uaddOverflow 1280#64 := nov_of_zero hn1_off (by decide)
  have hax0 : S.mem.readAt a 512 = BitVec.packLanes c.aNeg.x.l0 :=
    readAt_eq_of_readVec (by rw [← har, MemoryState.readLanePoint_eq])
  have hax1 : S.mem.readAt (a.add 64#64) 512 = BitVec.packLanes c.aNeg.x.l1 :=
    readAt_eq_of_readVec (by rw [← har, MemoryState.readLanePoint_eq])
  have hax2 : S.mem.readAt (a.add 128#64) 512 = BitVec.packLanes c.aNeg.x.l2 :=
    readAt_eq_of_readVec (by rw [← har, MemoryState.readLanePoint_eq])
  have hax3 : S.mem.readAt (a.add 192#64) 512 = BitVec.packLanes c.aNeg.x.l3 :=
    readAt_eq_of_readVec (by rw [← har, MemoryState.readLanePoint_eq])
  have hax4 : S.mem.readAt (a.add 256#64) 512 = BitVec.packLanes c.aNeg.x.l4 :=
    readAt_eq_of_readVec (by rw [← har, MemoryState.readLanePoint_eq])
  have hay0 : S.mem.readAt (a.add 320#64) 512 = BitVec.packLanes c.aNeg.y.l0 :=
    readAt_eq_of_readVec (by rw [← har, MemoryState.readLanePoint_eq])
  have hay1 : S.mem.readAt (a.add 384#64) 512 = BitVec.packLanes c.aNeg.y.l1 :=
    readAt_eq_of_readVec (by rw [← har, MemoryState.readLanePoint_eq])
  have hay2 : S.mem.readAt (a.add 448#64) 512 = BitVec.packLanes c.aNeg.y.l2 :=
    readAt_eq_of_readVec (by rw [← har, MemoryState.readLanePoint_eq])
  have hay3 : S.mem.readAt (a.add 512#64) 512 = BitVec.packLanes c.aNeg.y.l3 :=
    readAt_eq_of_readVec (by rw [← har, MemoryState.readLanePoint_eq])
  have hay4 : S.mem.readAt (a.add 576#64) 512 = BitVec.packLanes c.aNeg.y.l4 :=
    readAt_eq_of_readVec (by rw [← har, MemoryState.readLanePoint_eq])
  have haz0 : S.mem.readAt (a.add 640#64) 512 = BitVec.packLanes c.aNeg.z.l0 :=
    readAt_eq_of_readVec (by rw [← har, MemoryState.readLanePoint_eq])
  have haz1 : S.mem.readAt (a.add 704#64) 512 = BitVec.packLanes c.aNeg.z.l1 :=
    readAt_eq_of_readVec (by rw [← har, MemoryState.readLanePoint_eq])
  have haz2 : S.mem.readAt (a.add 768#64) 512 = BitVec.packLanes c.aNeg.z.l2 :=
    readAt_eq_of_readVec (by rw [← har, MemoryState.readLanePoint_eq])
  have haz3 : S.mem.readAt (a.add 832#64) 512 = BitVec.packLanes c.aNeg.z.l3 :=
    readAt_eq_of_readVec (by rw [← har, MemoryState.readLanePoint_eq])
  have haz4 : S.mem.readAt (a.add 896#64) 512 = BitVec.packLanes c.aNeg.z.l4 :=
    readAt_eq_of_readVec (by rw [← har, MemoryState.readLanePoint_eq])
  have hat0 : S.mem.readAt (a.add 960#64) 512 = BitVec.packLanes c.aNeg.t.l0 :=
    readAt_eq_of_readVec (by rw [← har, MemoryState.readLanePoint_eq])
  have hat1 : S.mem.readAt (a.add 1024#64) 512 = BitVec.packLanes c.aNeg.t.l1 :=
    readAt_eq_of_readVec (by rw [← har, MemoryState.readLanePoint_eq])
  have hat2 : S.mem.readAt (a.add 1088#64) 512 = BitVec.packLanes c.aNeg.t.l2 :=
    readAt_eq_of_readVec (by rw [← har, MemoryState.readLanePoint_eq])
  have hat3 : S.mem.readAt (a.add 1152#64) 512 = BitVec.packLanes c.aNeg.t.l3 :=
    readAt_eq_of_readVec (by rw [← har, MemoryState.readLanePoint_eq])
  have hat4 : S.mem.readAt (a.add 1216#64) 512 = BitVec.packLanes c.aNeg.t.l4 :=
    readAt_eq_of_readVec (by rw [← har, MemoryState.readLanePoint_eq])
  have haz : S.mem.readAt (a.add 640#64) 2560 = c.aNeg.z.bits :=
    readAt_fe_at ha_off haf.2.inBounds 640 (by omega) (by omega) haz0 haz1 haz2 haz3 haz4
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
  sp
  sp
  have hfe4 : S.mem.FeRoom k2 := ⟨nov_of_zero hk2_off (by decide), by mem_fact⟩
  step_call using _root_.Firedancer.Lane.Mlir.fd_ed25519_lane_bcast_fe.call_eq
  hide_body
  rw [bcast_k2d] at hS hread_k2 hread_k2_64 hread_k2_128 hread_k2_192 hread_k2_256
  iterate 6 sp
  -- entry 0: `Niels.zero`
  ss
  sp
  sp
  sms
  ss
  sp
  sp
  sms
  ss
  iterate 5 (sp; ss)
  sp
  sp
  sms
  have hT0 : S.mem.readAt (kt.add 0#64) 12800 = (c.tab 0).bits :=
    readAt_entry0 hkt_off hroom_kt.1.inBounds (by omega) hread_kt hread_kt_64 hread_kt_320
      hread_kt_384 hread_kt_960 hread_kt_1024 hread_kt_1088 hread_kt_1152 hread_kt_1216
      hread_kt_1280 hread_kt_1344
  have hF0 := fits_entry0 hkt_off hfits_kt hfits_kt_64 hfits_kt_320 hfits_kt_384 hfits_kt_960
    hfits_kt_1024 hfits_kt_1088 hfits_kt_1152 hfits_kt_1216 hfits_kt_1280 hfits_kt_1344
  clear hread_kt hread_kt_64 hread_kt_320 hread_kt_384 hread_kt_960 hread_kt_1024 hread_kt_1088
    hread_kt_1152 hread_kt_1216 hread_kt_1280 hread_kt_1344 hfits_kt hfits_kt_64 hfits_kt_320
    hfits_kt_384 hfits_kt_960 hfits_kt_1024 hfits_kt_1088 hfits_kt_1152 hfits_kt_1216 hfits_kt_1280
    hfits_kt_1344
  -- entry 1: `fd_ed25519_lane_to_niels( &n1, a, &k2d )`
  slv
  slv
  sp
  sp
  slv
  slv
  sp
  sp
  sp
  slv
  slv
  sp
  sp
  sp
  slv
  slv
  sp
  sp
  sp
  slv
  slv
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  sp
  ss
  sp
  sp
  ss
  sp
  sp
  ss
  sp
  sp
  ss
  sp
  sp
  ss
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
  sp
  sp
  ss
  sp
  sp
  ss
  sp
  sp
  ss
  sp
  sp
  ss
  sp
  sp
  ss
  sp
  sp
  smc
  sp
  slv
  slv
  slv
  slv
  slv
  slv
  sp
  slv
  sp
  slv
  sp
  slv
  sp
  slv
  step_pattern using runBodyFrom_mulStoreRun 704 768 832 896 (hov := hn1ov); hide_body
  sp
  sp
  ss
  spn
  sp
  ss
  spn
  sp
  ss
  spn
  sp
  ss
  spn
  sp
  ss
  -- entry 1's field elements in `n1`
  subst v2272 v2273 v2274 v2275 v2276 v2277 v2279 v2281 v2283 v2285
  have hn1b := hroom_n1.1.inBounds
  have hP1 : S.mem.readAt n1 2560 = (nielsC c.aNeg lc.k2d).p.bits :=
    readAt_fe_base hn1_off hn1b (by omega) hread_n1 hread_n1_64 hread_n1_128 hread_n1_192
      hread_n1_256
  have hM1 : S.mem.readAt (n1.add 320#64) 2560 = (nielsC c.aNeg lc.k2d).m.bits :=
    readAt_fe_at hn1_off hn1b 320 (by omega) (by omega) hread_n1_320 hread_n1_384 hread_n1_448
      hread_n1_512 hread_n1_576
  have hK1 : S.mem.readAt (n1.add 640#64) 2560 = (nielsC c.aNeg lc.k2d).k.bits :=
    readAt_fe_at hn1_off hn1b 640 (by omega) (by omega) hread_n1_640 hread_n1_704 hread_n1_768
      hread_n1_832 hread_n1_896_readAt
  have hNK1 : S.mem.readAt (n1.add 960#64) 2560 = (nielsC c.aNeg lc.k2d).nk.bits :=
    readAt_fe_at hn1_off hn1b 960 (by omega) (by omega) hread_n1_960 hread_n1_1024 hread_n1_1088
      hread_n1_1152 hread_n1_1216
  have hfP1 := fits_fe_base hn1_off hfits_n1 hfits_n1_64 hfits_n1_128 hfits_n1_192 hfits_n1_256
  have hfM1 : Fits S.mem (n1.add 320#64) 2560 := fits_fe_at hn1_off 320 (by omega) hfits_n1_320
    hfits_n1_384 hfits_n1_448 hfits_n1_512 hfits_n1_576
  have hfK1 : Fits S.mem (n1.add 640#64) 2560 := fits_fe_at hn1_off 640 (by omega) hfits_n1_640
    hfits_n1_704 hfits_n1_768 hfits_n1_832 hfits_n1_896
  have hfNK1 : Fits S.mem (n1.add 960#64) 2560 := fits_fe_at hn1_off 960 (by omega)
    hfits_n1_960 hfits_n1_1024 hfits_n1_1088 hfits_n1_1152 hfits_n1_1216
  clear hread_n1 hread_n1_64 hread_n1_128 hread_n1_192 hread_n1_256 hread_n1_320 hread_n1_384
    hread_n1_448 hread_n1_512 hread_n1_576 hread_n1_640 hread_n1_704 hread_n1_768 hread_n1_832
    hread_n1_960 hread_n1_1024 hread_n1_1088 hread_n1_1152 hread_n1_1216 hread_n1_896_readAt
    hfits_n1 hfits_n1_64 hfits_n1_128 hfits_n1_192 hfits_n1_256 hfits_n1_320
    hfits_n1_384 hfits_n1_448 hfits_n1_512 hfits_n1_576 hfits_n1_640 hfits_n1_704 hfits_n1_768
    hfits_n1_832 hfits_n1_896 hfits_n1_960 hfits_n1_1024 hfits_n1_1088 hfits_n1_1152 hfits_n1_1216
    hax0 hax1 hax2 hax3 hax4 hay0 hay1 hay2 hay3 hay4 haz0 haz1 haz2 haz3 haz4 hat0 hat1 hat2 hat3
    hat4 hread_a
  sp
  smc
  sp
  smc
  sp
  smc
  sp
  smc
  sp
  smc
  -- the hand-over
  have hT1 : S.mem.readAt (kt.add 1600#64) 12800 = (c.tab 1).bits := by
    have := readAt_niels_at hkt_off hroom_kt.1.inBounds 1600 (N := nielsC c.aNeg lc.k2d)
      (by omega) (by omega) hread_kt_1600 hread_kt_1920 hread_kt_2240 hread_kt_2560 hread_kt_2880
    rw [nielsC_eq] at this
    exact this
  have hF1 : Fits S.mem (kt.add 1600#64) 12800 := fits_niels_at hkt_off 1600 (by omega)
    hfits_kt_1600 hfits_kt_1920 hfits_kt_2240 hfits_kt_2560 hfits_kt_2880
  have hN1 : S.mem.readNiels n1 = c.tab 1 := by
    have := readNiels_base hn1_off hn1b (by omega)
      (readAt_niels_base hn1_off hn1b (by omega) (N := nielsC c.aNeg lc.k2d) hP1 hM1 hK1 hNK1
        hread_n1_1280)
    rw [nielsC_eq] at this
    exact this
  have hfN1 : S.mem.NielsFit n1 := ⟨nov_of_zero hn1_off (by decide),
    fits_niels_base hn1_off hfP1 hfM1 hfK1 hfNK1 hfits_n1_1280⟩
  exact hK E S hArgs (by env_reads) ⟨hwf, hfr, hroom_kt, hF0, hT0, hF1, hT1, hfe4, hread_k2,
    hread_k2_64, hread_k2_128, hread_k2_192, hread_k2_256, hfN1, hN1, hroom_p2, hroom_p3, hroom_p4,
    hroom_p6, hroom_tmp, hb11, hw11, haf, har⟩

end MLIR.Firedancer.Lane.VerifyX8
